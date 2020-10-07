package com.example.flutter_files_picker.filepicker.util.permissions.util

data class PermissionsOptions(
        var handleRationale: Boolean = true,
        var rationaleMessage: String = "",
        var handlePermanentlyDenied: Boolean = true,
        var permanentlyDeniedMessage: String = "",
        var rationaleMethod: ((PermissionsRequest) -> Unit)? = null,
        var permanentDeniedMethod: ((PermissionsRequest) -> Unit)? = null,
        var permissionsDeniedMethod: ((PermissionsRequest) -> Unit)? = null
)