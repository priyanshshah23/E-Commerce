package com.example.flutter_files_picker.filepicker.util.permissions

import android.content.Context
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import com.example.flutter_files_picker.filepicker.util.permissions.util.PermissionCheckerFragment
import com.example.flutter_files_picker.filepicker.util.permissions.util.PermissionsOptions
import com.example.flutter_files_picker.filepicker.util.permissions.util.PermissionsRequest
import com.example.flutter_files_picker.filepicker.util.permissions.util.PermissionsUtil

private const val TAG = "runWithPermissions"

fun Context?.runWithPermissions(vararg permissions: String, options: PermissionsOptions = PermissionsOptions(), callback: () -> Unit): Any? {
    return runWithPermissionsHandler(this, permissions, callback, options)
}

fun Fragment?.runWithPermissions(
        vararg permissions: String,
        options: PermissionsOptions = PermissionsOptions(),
        callback: () -> Unit
): Any? {
    return runWithPermissionsHandler(this, permissions, callback, options)
}

private fun runWithPermissionsHandler(target: Any?, permissions: Array<out String>, callback: () -> Unit, options: PermissionsOptions): Nothing? {
    if (target is AppCompatActivity || target is Fragment) {
        val context = when (target) {
            is Context -> target
            is Fragment -> target.context
            else -> null
        }

        if (PermissionsUtil.hasSelfPermission(context, arrayOf(*permissions))) {
            callback()
        } else {
            var permissionCheckerFragment = when (context) {
                is AppCompatActivity -> context.supportFragmentManager?.findFragmentByTag(PermissionCheckerFragment::class.java.canonicalName) as PermissionCheckerFragment?
                is Fragment -> context.childFragmentManager.findFragmentByTag(PermissionCheckerFragment::class.java.canonicalName) as PermissionCheckerFragment?
                else -> null
            }

            if (permissionCheckerFragment == null) {
                Log.d(TAG, "runWithPermissions: adding headless fragment for asking permissions")
                permissionCheckerFragment = PermissionCheckerFragment.newInstance()
                when (context) {
                    is AppCompatActivity -> {
                        context.supportFragmentManager.beginTransaction().apply {
                            add(permissionCheckerFragment, PermissionCheckerFragment::class.java.canonicalName)
                            commit()
                        }
                        context.supportFragmentManager?.executePendingTransactions()
                    }
                    is Fragment -> {
                        context.childFragmentManager.beginTransaction().apply {
                            add(permissionCheckerFragment, PermissionCheckerFragment::class.java.canonicalName)
                            commit()
                        }
                        context.childFragmentManager.executePendingTransactions()
                    }
                }
            }

            permissionCheckerFragment.setListener(object : PermissionCheckerFragment.PermissionsCallback {
                override fun onPermissionsGranted(permissionsRequest: PermissionsRequest?) {
                    Log.d(TAG, "runWithPermissions: got permissions")
                    try {
                        callback()
                    } catch (throwable: Throwable) {
                        throwable.printStackTrace()
                    }
                }

                override fun onPermissionsDenied(permissionsRequest: PermissionsRequest?) {
                    permissionsRequest?.permissionsDeniedMethod?.invoke(permissionsRequest)
                }

                override fun shouldShowRequestPermissionsRationale(permissionsRequest: PermissionsRequest?) {
                    permissionsRequest?.rationaleMethod?.invoke(permissionsRequest)
                }

                override fun onPermissionsPermanentlyDenied(permissionsRequest: PermissionsRequest?) {
                    permissionsRequest?.permanentDeniedMethod?.invoke(permissionsRequest)
                }
            })

            val permissionRequest = PermissionsRequest(permissionCheckerFragment, arrayOf(*permissions))
            permissionRequest.handleRationale = options.handleRationale
            permissionRequest.handlePermanentlyDenied = options.handlePermanentlyDenied
            permissionRequest.rationaleMessage = if (options.rationaleMessage.isBlank())
                "These permissions are required to perform this feature. Please allow us to use this feature. "
            else
                options.rationaleMessage
            permissionRequest.permanentlyDeniedMessage = if (options.permanentlyDeniedMessage.isBlank())
                "Some permissions are permanently denied which are required to perform this operation. Please open app settings to grant these permissions."
            else
                options.permanentlyDeniedMessage
            permissionRequest.rationaleMethod = options.rationaleMethod
            permissionRequest.permanentDeniedMethod = options.permanentDeniedMethod
            permissionRequest.permissionsDeniedMethod = options.permissionsDeniedMethod

            permissionCheckerFragment.setRequestPermissionsRequest(permissionRequest)

            permissionCheckerFragment.requestPermissionsFromUser()
        }
    } else {
        throw IllegalStateException("Found " + target!!::class.java.canonicalName + " : No support from any classes other than AppCompatActivity/Fragment")
    }
    return null
}