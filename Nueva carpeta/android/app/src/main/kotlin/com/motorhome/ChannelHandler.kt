package com.motorhome

import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.FileDescriptor

object ChannelHandler : MethodChannel.MethodCallHandler, EventChannel.StreamHandler {

    private var fd: FileDescriptor? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            result.success(
                when(call.method.toChannelMethod()) {
                    ChannelMethod.OPEN -> init()
                    ChannelMethod.CLOSE -> close()
                    ChannelMethod.READ -> read()
                    ChannelMethod.WRITE -> write(call.argument<ByteArray>("bytes"))
                }
            )
        } catch(e: Exception) {
            if (e is IllegalArgumentException) {
                result.notImplemented()
            } else {
                result.error("", e.message, null)
            }
        }
    }

    private fun String.toChannelMethod(): ChannelMethod = ChannelMethod.valueOf(uppercase())

    private fun init(): Boolean {
        fd = Uart.open() ?: throw Exception("Can't open port")
        return true
    }

    private fun close(): Boolean {
        Uart.close(fd ?: throw Exception("Can't close port"))
        fd = null
        return true
    }

    private fun read(): ByteArray? {
        val result = Uart.read(fd!!)
        return result
    }

    private fun write(bytes: ByteArray?): Int = Uart.write(fd!!, bytes!!)

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
//        TODO("Not yet implemented")
    }

    override fun onCancel(arguments: Any?) {
//        TODO("Not yet implemented")
    }
}
