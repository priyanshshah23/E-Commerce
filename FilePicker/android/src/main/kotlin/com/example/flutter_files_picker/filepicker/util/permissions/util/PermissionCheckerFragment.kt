package com.example.flutter_files_picker.filepicker.util.permissions.util


import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri.fromParts
import android.os.Bundle
import android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.fragment.app.Fragment
import com.example.flutter_files_picker.R
import org.jetbrains.anko.alert

class PermissionCheckerFragment : Fragment() {

    private var permissionsRequest: PermissionsRequest? = null

    interface PermissionsCallback {
        fun shouldShowRequestPermissionsRationale(permissionsRequest: PermissionsRequest?)
        fun onPermissionsGranted(permissionsRequest: PermissionsRequest?)
        fun onPermissionsPermanentlyDenied(permissionsRequest: PermissionsRequest?)
        fun onPermissionsDenied(permissionsRequest: PermissionsRequest?)
    }

    companion object {
        private const val TAG = "Permissions"
        private const val PERMISSIONS_REQUEST_CODE = 199
        fun newInstance(): PermissionCheckerFragment = PermissionCheckerFragment()
    }

    private var mListener: PermissionsCallback? = null

    fun setListener(listener: PermissionsCallback) {
        mListener = listener
        Log.d(TAG, "onCreate: listeners set")
    }

    private fun removeListener() {
        mListener = null
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        Log.d(TAG, "onCreate: permission fragment created")
    }

    fun setRequestPermissionsRequest(permissionsRequest: PermissionsRequest?) {
        this.permissionsRequest = permissionsRequest
    }

    private fun removeRequestPermissionsRequest() {
        permissionsRequest = null
    }

    fun clean() {
        if (permissionsRequest != null) {
            if (permissionsRequest?.deniedPermissions?.size ?: 0 > 0)
                mListener?.onPermissionsDenied(permissionsRequest)

            removeRequestPermissionsRequest()
            removeListener()
        } else {
            Log.w(TAG, "clean: PermissionsRequest has already completed its flow. " +
                    "No further callbacks will be called for the current flow.")
        }
    }

    fun requestPermissionsFromUser() {
        if (permissionsRequest != null) {
            Log.d(TAG, "requestPermissionsFromUser: requesting permissions")
            requestPermissions(permissionsRequest?.permissions.orEmpty(), PERMISSIONS_REQUEST_CODE)
        } else {
            Log.w(TAG, "requestPermissionsFromUser: PermissionsRequest has already completed its flow. " +
                    "Cannot request permissions again from the request received from the callback. " +
                    "You can start the new flow by calling runWithPermissions() { } again.")
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        handlePermissionResult(permissions, grantResults)
    }

    private fun handlePermissionResult(permissions: Array<String>, grantResults: IntArray) {
        if (permissions.isEmpty()) {
            Log.w(TAG, "handlePermissionResult: Permissions result discarded. You might have called multiple permissions request simultaneously")
            return
        }

        if (PermissionsUtil.hasSelfPermission(context, permissions)) {
            permissionsRequest?.deniedPermissions = emptyArray()
            mListener?.onPermissionsGranted(permissionsRequest)
            clean()
        } else {
            val deniedPermissions = PermissionsUtil.getDeniedPermissions(permissions, grantResults)
            permissionsRequest?.deniedPermissions = deniedPermissions

            var shouldShowRationale = true
            var isPermanentlyDenied = false
            for (i in 0 until deniedPermissions.size) {
                val deniedPermission = deniedPermissions[i]
                val rationale = shouldShowRequestPermissionRationale(deniedPermission)
                if (!rationale) {
                    shouldShowRationale = false
                    isPermanentlyDenied = true
                    break
                }
            }

            if (permissionsRequest?.handlePermanentlyDenied == true && isPermanentlyDenied) {

                permissionsRequest?.permanentDeniedMethod?.let {
                    // get list of permanently denied methods
                    permissionsRequest?.permanentlyDeniedPermissions =
                            PermissionsUtil.getPermanentlyDeniedPermissions(this, permissions, grantResults)
                    mListener?.onPermissionsPermanentlyDenied(permissionsRequest)
                    return
                }

                activity?.alert {
                    message = permissionsRequest?.permanentlyDeniedMessage.orEmpty()
                    positiveButton("SETTINGS") {
                        openAppSettings()
                    }
                    negativeButton("CANCEL") {
                        clean()
                    }
                }?.apply { isCancelable = false }?.show()
                return
            }

            if (permissionsRequest?.handleRationale == true && shouldShowRationale) {

                permissionsRequest?.rationaleMethod?.let {
                    mListener?.shouldShowRequestPermissionsRationale(permissionsRequest)
                    return
                }

                activity?.alert {
                    also { ctx.setTheme(R.style.CustomAlertDialog) }
                    message = permissionsRequest?.rationaleMessage.orEmpty()
                    positiveButton("TRY AGAIN") {
                        requestPermissionsFromUser()
                    }
                    negativeButton("CANCEL") {
                        clean()
                    }
                }?.apply { isCancelable = false;
                }?.show()
                return
            }

            clean()
        }
    }

    fun openAppSettings() {
        if (permissionsRequest != null) {
            val intent = Intent(ACTION_APPLICATION_DETAILS_SETTINGS, fromParts("package", activity?.packageName, null))
            startActivityForResult(intent, PERMISSIONS_REQUEST_CODE)
        } else {
            Log.w(TAG, "openAppSettings: PermissionsRequest has already completed its flow. Cannot open app settings")
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == PERMISSIONS_REQUEST_CODE) {
            val permissions = permissionsRequest?.permissions ?: emptyArray()
            val grantResults = IntArray(permissions.size)
            permissions.forEachIndexed { index, s ->
                grantResults[index] = context?.let { ActivityCompat.checkSelfPermission(it, s) } ?: PackageManager.PERMISSION_DENIED
            }

            handlePermissionResult(permissions, grantResults)
        }
    }
}
