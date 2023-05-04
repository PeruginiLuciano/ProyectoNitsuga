package com.motorhome

import java.io.FileDescriptor

object Uart {

    init {
        System.loadLibrary("uart")
    }

    external fun open(): FileDescriptor?
    external fun close(fd: FileDescriptor)
    external fun read(fd: FileDescriptor): ByteArray?
    external fun write(fd: FileDescriptor, byteArray: ByteArray): Int
}