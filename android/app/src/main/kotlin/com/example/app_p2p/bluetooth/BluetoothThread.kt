package com.example.app_p2p.bluetooth

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothServerSocket
import android.bluetooth.BluetoothSocket
import android.util.Log
import java.io.IOException
import java.util.*

class BluetoothThread(uuid: UUID) : Thread() {

    private val mmServerSocket: BluetoothServerSocket? by lazy(LazyThreadSafetyMode.NONE) {
        BluetoothAdapter.getDefaultAdapter()?.listenUsingInsecureRfcommWithServiceRecord("app_p2p", uuid)

    }

    override fun run() {


        var shouldLoop = true
        while (shouldLoop) {
            val socket: BluetoothSocket? = try {
                mmServerSocket?.accept()
            } catch (e: IOException) {
                Log.e("TAG", "Socket's accept() method failed", e)
                shouldLoop = false
                null
            }


            socket?.also {

                mmServerSocket?.close()
                shouldLoop = false
            }
        }

    }

    fun cancel() {
        try {
            mmServerSocket?.close()
        } catch (e: IOException) {
            Log.e("TAG", "Could not close the connect socket", e)
        }
    }

}