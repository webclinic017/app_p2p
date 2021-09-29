package com.example.app_p2p

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothServerSocket
import android.bluetooth.BluetoothSocket
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log

import androidx.annotation.NonNull
import com.example.app_p2p.bluetooth.BluetoothThread
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.IOException
import java.util.*

class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.soflop.app_p2p/bluetooth"
    private val CHECK_BLUETOOTH_METHOD = "checkBluetooth"
    private val GET_PAIRED_DEVICE_METHOD = "getPairedDevices"
    private val DISCOVER_DEVICES_METHOD = "discoverDevices"
    private val INIT_AS_BLUETOOTH_SERVER = "initAsBluetoothServer"

    private val CONNECTION_ESTABLISHED = "connectionEstablished"


    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)

        val filter = IntentFilter(BluetoothDevice.ACTION_FOUND)
        registerReceiver(receiver, filter)

    }


    private val receiver = object : BroadcastReceiver() {

        override fun onReceive(context: Context, intent: Intent) {
            val action: String = intent.action as String
            when(action) {
                BluetoothDevice.ACTION_FOUND -> {
                    // Discovery has found a device. Get the BluetoothDevice
                    // object and its info from the Intent.
                    val device: BluetoothDevice? =
                            intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)
                    val deviceName = device?.name
                    val deviceHardwareAddress = device?.address // MAC address

                    print("Device found: ${deviceName} ${deviceHardwareAddress}")

                    platform?.invokeMethod(DISCOVER_DEVICES_METHOD,
                    "${deviceName}|${deviceHardwareAddress}")

                }
            }
        }
    }



    private var platform : MethodChannel? = null


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        platform =  MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->




            if(call.method.equals(CHECK_BLUETOOTH_METHOD)) {

                val bluetoothState = checkIfActive()

                if(bluetoothState == 1) {
                   result.success(true)
                }else if(bluetoothState == 0) {
                    result.success(false)
                }else {
                    result.error("No existent Adapter", "The bluetooth adapter doesn't exist for this device", null)
                }

            }else if(call.method.equals(GET_PAIRED_DEVICE_METHOD)) {


                val devices = getPairedDevices()

                if(devices.isNotEmpty()) {
                    result.success(devices)
                }else {
                    result.success(devices)
                }



            }else if(call.method.equals(DISCOVER_DEVICES_METHOD)) {

                var r = discoverDevices()

                result.success(r)

            }else if(call.method.equals(INIT_AS_BLUETOOTH_SERVER)) {


                result.success(initBluetoothServer())
            }
        }
    }


    private val REQUEST_ENABLE_BT : Int = 55

    private fun checkIfActive() : Int {
        val defaultAdapter : BluetoothAdapter? = BluetoothAdapter.getDefaultAdapter()

        if(defaultAdapter != null) {

            if(!defaultAdapter.isEnabled) {
                val enableBtIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
                startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT)
                return 0
            }else {
                return 1;
            }

        }else {
            return -1
        }




    }


    private fun getPairedDevices() : MutableList<String> {

        val pairedDevicesList : MutableList<String> = mutableListOf()

        val defaultAdapter : BluetoothAdapter? = BluetoothAdapter.getDefaultAdapter()

        val pairedDevices : Set<BluetoothDevice>? = defaultAdapter?.bondedDevices


        if (pairedDevices != null) {
            for(device : BluetoothDevice in pairedDevices) {
                val deviceName = device.name
                val deviceAddress = device.address
                val newElement = "${deviceName}|${deviceAddress}"

                pairedDevicesList.add(newElement)
            }

        }


        return pairedDevicesList



    }


    private fun discoverDevices() : Boolean{

        val defaultAdapter : BluetoothAdapter? = BluetoothAdapter.getDefaultAdapter()


        return defaultAdapter?.startDiscovery() as Boolean




    }


    private fun initBluetoothServer() : Boolean {


        val uuid : UUID = UUID.fromString("4fafc201-1fb5-459e-8fcc-c5c9c331914b")

       val t  = BluetoothThread(uuid)
        t.start()

        return true

    }


    private fun connect(id: String) {


    }

    private fun manageMyConnectedSocket(socket: BluetoothSocket) {

        platform?.invokeMethod(CONNECTION_ESTABLISHED, "")

    }

    override fun onDestroy() {
        super.onDestroy()


        // Don't forget to unregister the ACTION_FOUND receiver.
        unregisterReceiver(receiver)
    }






}


