#include <string.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <termios.h>
#include <android/log.h>
#include <sys/stat.h>
#include <jni.h>

#define LOGI(fmt, args...) __android_log_print(ANDROID_LOG_INFO,  TAG, fmt, ##args)
#define LOGD(fmt, args...) __android_log_print(ANDROID_LOG_DEBUG, TAG, fmt, ##args)
#define LOGE(fmt, args...) __android_log_print(ANDROID_LOG_ERROR, TAG, fmt, ##args)

// Direcciones local y remota
#define LOCAL_ADDRESS 5
#define BROADCAST_ADDRESS 255
#define PBUS_CMD_ACK 0xFF
#define PBUS_CMD_RESET 0xFE
#define PBUS_CMD_BOOTMODE 0xFD
#define PBUS_CMD_FWDATA 0xFC
#define PBUS_CMD_CHNETADDR 0xFB
#define PBUS_CMD_FACTORY 0xFA
#define PBUS_CMD_INFO 0xF9
#define PBUS_CMD_RESPONSE 0xF8

#define MAIN_BUFF_SIZE 500
uint8_t mainBuff[MAIN_BUFF_SIZE];
jint mainBuffStart = 0;
jint mainBuffEnd = 0;

JNIEXPORT jobject JNICALL Java_com_motorhome_Uart_open(JNIEnv *env, jclass pThis) {
    jint fd; // UART descriptor

    const char port[] = "/dev/ttyS0";
    fd = open(port, O_RDWR | O_NONBLOCK);
    if (fd < 0) {
        return NULL;
    }
    struct termios cfg;
    if (tcgetattr(fd, &cfg)) {
        close(fd);
        return NULL;
    }

    cfmakeraw(&cfg);
    cfsetispeed(&cfg, B115200);
    cfsetospeed(&cfg, B115200);

    if (tcsetattr(fd, TCSANOW, &cfg)) {
        close(fd);
        return NULL;
    }
    memset(mainBuff, 0, sizeof(mainBuff));
    mainBuffStart = 0;
    mainBuffEnd = 0;

    jclass cFileDescriptor = (*env)->FindClass(env, "java/io/FileDescriptor");
    jmethodID iFileDescriptor = (*env)->GetMethodID(env, cFileDescriptor, "<init>", "()V");
    jfieldID descriptorID = (*env)->GetFieldID(env, cFileDescriptor, "descriptor", "I");
    jobject mFileDescriptor = (*env)->NewObject(env, cFileDescriptor, iFileDescriptor);
    (*env)->SetIntField(env, mFileDescriptor, descriptorID, fd);

    return mFileDescriptor;
}

JNIEXPORT void JNICALL Java_com_motorhome_Uart_close(JNIEnv *env, jclass type, jobject fdObject) {
    jclass FileDescriptorClass = (*env)->FindClass(env, "java/io/FileDescriptor");
    jfieldID descriptorID = (*env)->GetFieldID(env, FileDescriptorClass, "descriptor", "I");
    jint descriptor = (*env)->GetIntField(env, fdObject, descriptorID);
    close(descriptor);
}

JNIEXPORT jbyteArray JNICALL Java_com_motorhome_Uart_read(JNIEnv *env, jclass pThis, jobject fdObject) {
    jclass FileDescriptorClass = (*env)->FindClass(env, "java/io/FileDescriptor");
    jfieldID descriptorID = (*env)->GetFieldID(env, FileDescriptorClass, "descriptor", "I");
    jint fd = (*env)->GetIntField(env, fdObject, descriptorID);

    // Read serial port buffer and store data in mainBuff
    if (fd < 0) {
        return NULL;
    }
    uint8_t buff[500];
    memset(buff, 0, sizeof(buff));
    jint bytes = read(fd, buff, sizeof(buff));
    if (bytes > 0) {
        // Copy data to main buffer
        for(int i=0; i<bytes; i++) {
            mainBuff[mainBuffEnd] = buff[i];
            if (++mainBuffEnd == MAIN_BUFF_SIZE) {
                mainBuffEnd = 0;
            }
        }
        // Search for starting byte 0x7E
        for (; mainBuffStart<mainBuffEnd; mainBuffStart++) {
            if (mainBuff[mainBuffStart] == 0x7E) {
                break;
            }
        }
    }
    // Check mainBuff for available data
    while(1) {
        if ((mainBuffEnd > mainBuffStart && mainBuffEnd - mainBuffStart >= 10) ||
            (mainBuffStart > mainBuffEnd && (mainBuffEnd + MAIN_BUFF_SIZE) - mainBuffStart >= 10)) {
            uint8_t CRC = 0;
            uint8_t packet[10];
            // Get and remove packet from the main buffer
            for (int i = 0; i < 10; i++) {
                if (mainBuffStart >= MAIN_BUFF_SIZE) {
                    mainBuffStart = 0;
                }
                packet[i] = mainBuff[mainBuffStart++];
            }
//                jbyteArray result = (*env)->NewByteArray(env, 100);
//                (*env)->SetByteArrayRegion(env, result, 0, 100, mainBuff);
//                return result;
            // Check packet destination
            if (packet[2] == LOCAL_ADDRESS || packet[2] == BROADCAST_ADDRESS) {
                for (int i = 1; i < 9; i++) {
                    CRC ^= packet[i];
                }
                if (CRC == packet[9]) {
                    // Send ACK if needed
                    if (packet[2] == LOCAL_ADDRESS && packet[3] != PBUS_CMD_ACK && packet[3] != PBUS_CMD_RESPONSE) {
                        uint8_t ackCRC = LOCAL_ADDRESS ^ packet[1] ^ PBUS_CMD_ACK ^ packet[4];
                        uint8_t ack[10] = { 0x7E, LOCAL_ADDRESS, packet[1], PBUS_CMD_ACK, packet[4], 0, 0, 0, 0, ackCRC };
                        write(fd, ack, sizeof(ack));
                    }
                    if (packet[3] != PBUS_CMD_ACK) {
                        jbyteArray result = (*env)->NewByteArray(env, 8);
                        (*env)->SetByteArrayRegion(env, result, 0, 8, &packet[1]);
//                        jbyteArray result = (*env)->NewByteArray(env, 4);
//                        uint8_t res[4] = { mainBuffStart, mainBuffEnd, mainBuff[mainBuffStart], mainBuff[mainBuffEnd] };
//                        (*env)->SetByteArrayRegion(env, result, 0, 4, res);
                        return result;
                    }
                }
            }
        } else {
            return NULL;
        }
    }
}

JNIEXPORT jint JNICALL Java_com_motorhome_Uart_write(JNIEnv *env, jclass pThis, jobject fdObject, jbyteArray jbytes) {
    jclass FileDescriptorClass = (*env)->FindClass(env, "java/io/FileDescriptor");
    jfieldID descriptorID = (*env)->GetFieldID(env, FileDescriptorClass, "descriptor", "I");
    jint fd = (*env)->GetIntField(env, fdObject, descriptorID);
    if (fd < 0)
        return 0;
    uint8_t buffer[] = { 0x7E, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
    jbyte* elements = (*env)->GetByteArrayElements(env, jbytes, NULL);
    if (!elements) {
        return -1;
    }
    memcpy(&buffer[1], elements, 8);
    for (int i = 1; i < 9; i++) {
        buffer[9] ^= buffer[i];
    }
    jint wrote = write(fd, buffer, sizeof(buffer));

    (*env)->ReleaseByteArrayElements(env, jbytes, elements, JNI_ABORT);
    return wrote;
}
