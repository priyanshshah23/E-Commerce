package com.mydiamonds.app


import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.IntentSender
import android.content.pm.PackageManager
import android.location.LocationManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.core.content.ContextCompat
import com.example.flutter_files_picker.FlutterFilePickerPlugin
import com.example.flutter_files_picker.FlutterFilePickerPlugin.Companion.activityContext
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.api.GoogleApiClient
//import com.google.android.gms.location.LocationRequest
//import com.google.android.gms.location.LocationServices
//import com.google.android.gms.location.LocationSettingsRequest
//import com.google.android.gms.location.LocationSettingsStatusCodes
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*

class MainActivity : FlutterFragmentActivity(), GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener {

    private val REQUEST_CHECK_SETTINGS_GPS = 100
    private val GPS_CHANNEL = "GPS_CHANNEL"
    private var result: MethodChannel.Result? = null
    private var googleApiClient: GoogleApiClient? = null

    private val PERMISSION_STATUS_UNKNOWN = 0
    private val PERMISSION_STATUS_DENIED = 1
    private val PERMISSION_STATUS_GRANTED = 2
    private val PERMISSION_STATUS_RESTRICTED = 3

/*    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
//        googleApiClient = GoogleApiClient.Builder(this)
//                .addApi(LocationServices.API)
//                .addConnectionCallbacks(this)
//                .addOnConnectionFailedListener(this)
//                .build()
//        googleApiClient?.connect()

        Log.e("Register", "in main")
        GeneratedPluginRegistrant.registerWith(this)
        MethodChannel(flutterView.dartExecutor.binaryMessenger, GPS_CHANNEL).setMethodCallHandler { call, result ->
            this.result = result
            if (call.method == "isGPSEnabled") {
                if (isGpsEnabled())
                    result.success(true);
                else
                    result.error("NOT_ENABLED", "GPS Not Enabled", null)
            } else if (call.method == "checkAndShowGpsDialog") {
                if (!isGpsEnabled())
                    showStartGpsDialog()
                else
                    result.success(true)
            } else if (call.method == "checkPermissionStatus") {
                result.success(checkPermissionStatus(this))
            } else
                result.notImplemented()
        }
    }*/

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        Log.e("Register", "in main")
//        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), GPS_CHANNEL)
                .setMethodCallHandler { call, result ->
                    this.result = result
                    if (call.method == "isGPSEnabled") {
                        if (isGpsEnabled())
                            result.success(true);
                        else
                            result.error("NOT_ENABLED", "GPS Not Enabled", null)
                    } else if (call.method == "checkAndShowGpsDialog") {
                        if (!isGpsEnabled())
                            showStartGpsDialog()
                        else
                            result.success(true)
                        result.success(checkPermissionStatus(this))
                    } else if (call.method == "checkPermissionStatus") {
                        result.success(checkPermissionStatus(this))
                    } else if(call.method == "getTimeZoneName") {
                        result.success(TimeZone.getDefault().getID());
                    }
                    else
                        result.notImplemented()
                    }

                    MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "dexterx.dev/flutter_local_notifications_example")
                .setMethodCallHandler { call, result ->
                    this.result = result
                    if(call.method == "getTimeZoneName") {
                        result.success(TimeZone.getDefault().getID());
                    }
                    else
                        result.notImplemented()
                    }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_CHECK_SETTINGS_GPS) {
            if (resultCode == Activity.RESULT_OK) {
                result?.success(true)
            } else
                this.result?.error("NOT_AVAILBLE", "GPS Service Not available", null)
        } else
            FlutterFilePickerPlugin.handleResult(data, requestCode, resultCode)
    }

    fun isGpsEnabled(): Boolean {
        val locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager
        return locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
    }

    private fun showStartGpsDialog() {
//        if (!isGpsEnabled()) {
//            val locationRequest: LocationRequest = LocationRequest.create()
//                    .setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY)
//                    .setInterval(1000)
//                    .setSmallestDisplacement(100f)
//                    .setFastestInterval(1000)
//            val builder = LocationSettingsRequest.Builder().addLocationRequest(locationRequest)
//            builder.setAlwaysShow(true)
//
//            val result = LocationServices.SettingsApi.checkLocationSettings(googleApiClient, builder.build())
//            result.setResultCallback { result ->
//                val status = result.status
//                Log.e("status", "${result.status}");
//                Log.e("status", "$result");
//                when (status.statusCode) {
//                    LocationSettingsStatusCodes.SUCCESS -> {
//                        this.result?.success(true)
//                    }
//                    LocationSettingsStatusCodes.RESOLUTION_REQUIRED -> try {
//                        status.startResolutionForResult(activityContext, REQUEST_CHECK_SETTINGS_GPS)
//                    } catch (e: IntentSender.SendIntentException) {
//                        e.printStackTrace()
//                    }
//                    LocationSettingsStatusCodes.SETTINGS_CHANGE_UNAVAILABLE -> {
//                        this.result?.error("NOT_AVAILBLE", "GPS Service Not available", null)
//                    }
//                }
//            }
//        }x
    }

    fun checkPermissionStatus(context: Context?): Int {
        val names = arrayListOf<String>(Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION)
        if (names == null) {
            return PERMISSION_STATUS_GRANTED
        }

        //if no permissions were found then there is an issue and permission is not set in Android manifest
        if (names.size == 0) {
            return PERMISSION_STATUS_UNKNOWN
        }
        if (context == null) {
            return PERMISSION_STATUS_UNKNOWN
        }
        val targetsMOrHigher = context.applicationInfo.targetSdkVersion >= Build.VERSION_CODES.M
        for (name in names) {
            if (targetsMOrHigher) {
                val permissionStatus = ContextCompat.checkSelfPermission(context, name)
                if (permissionStatus == PackageManager.PERMISSION_GRANTED) {
                    return PERMISSION_STATUS_GRANTED
                }
            }
        }
        return PERMISSION_STATUS_UNKNOWN
    }

    override fun onConnected(p0: Bundle?) {

    }

    override fun onConnectionSuspended(p0: Int) {
        this.result?.error("NOT_AVAILBLE", "GPS Service Not available", null)
    }

    override fun onConnectionFailed(p0: ConnectionResult) {
        this.result?.error("NOT_AVAILBLE", "GPS Service Not available", null)
    }
}