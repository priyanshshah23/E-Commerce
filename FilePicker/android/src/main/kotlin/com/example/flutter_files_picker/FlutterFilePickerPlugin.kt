package com.example.flutter_files_picker

import android.app.Activity
import android.content.Intent
import android.graphics.Color
import android.text.format.Formatter
import androidx.core.content.ContextCompat
import com.example.flutter_files_picker.filepicker.local.FilePickerConstant
import com.example.flutter_files_picker.filepicker.local.filter.entity.BaseFile
import com.example.flutter_files_picker.filepicker.ui.Picker
import com.example.flutter_files_picker.filepicker.util.ActivityUtils.startWithTransition
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class FlutterFilePickerPlugin : MethodCallHandler {

    companion object {
        var activityContext: Activity? = null
        var result: Result? = null
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            activityContext = registrar.activity()
            val channel = MethodChannel(registrar.messenger(), "flutter_files_picker")
            channel.setMethodCallHandler(FlutterFilePickerPlugin())
        }

        var APPLICATION_NAME = "Picker"
        var APPLICATION_ID = "Picker"
        var THEME_COLOR = 0
        var FOREGROUND_COLOR = 0

        fun handleResult(data: Intent?, requestCode: Int, resultCode: Int) {
            if (resultCode == Activity.RESULT_OK) {
                if (requestCode == FilePickerConstant.REQUEST_CODE_PICK_FILE) {
                    var arrayList = data?.getParcelableArrayListExtra<BaseFile>(FilePickerConstant.RESULT_PICK_FILE)
                    if (arrayList != null) {
                        var fileArray = arrayListOf<Map<String, Any>>()
                        arrayList.forEach {
                            val tmpObj = mapOf(Pair("fileSize", Formatter.formatShortFileSize(activityContext, it.size)),
                                    Pair("fileUrl", it.path))
                            fileArray.add(tmpObj)
                        }
                        FlutterFilePickerPlugin.result?.success(fileArray)
                    } else
                        FlutterFilePickerPlugin.result?.error("NOT_FOUND", "No data Found", null)
                }
            }
        }
    }

    override fun onMethodCall(call: MethodCall, res: Result) {
        result = res

        THEME_COLOR = Color.parseColor(call.argument<String>("themeColor"))
        FOREGROUND_COLOR = Color.parseColor(call.argument<String>("foregroundColor"))
        var builder = Picker.Builder(activityContext, arrayListOf())
        if (call.argument<Int>("fileCount") != 0)
            builder.setFilesCount(call.argument<Int>("fileCount") ?: 1)

        if (call.argument<Boolean>("showDirectoryFilter") == true)
            builder.allowDirectoryFilter()

        when {
            call.method == "pickImage" -> {
                builder.addSourceType(Picker.SourceType.GALLARY)
                        .addAllImageTypes()
                if (call.argument<Boolean>("allowNewFile") == true)
                    builder.allowNewFile()
                if (call.argument<Boolean>("allowCrop") == true)
                    builder.allowCrop()
            }
            call.method == "pickVideo" -> {
                builder.addSourceType(Picker.SourceType.VIDEO)
                        .addAllVideoTypes()
                if (call.argument<Boolean>("allowNewFile") == true)
                    builder.allowNewFile()
                if (call.argument<Boolean>("allowCrop") == true)
                    builder.allowCrop()
            }
            call.method == "pickDocument" -> {
                builder.addSourceType(Picker.SourceType.DOCUMENTS)
                        .addAllDocumentTypes()

            }
            call.method == "pickAny" -> {
                if (call.argument<List<String>>("sourceTypes") != null) {
                    var list = call.argument<List<String>>("sourceTypes")
                    list?.forEach {
                        builder.addSourceTypeByName(it).addFileTypesBySource(it)
                    }
                }

            }
            else -> res.notImplemented()
        }

        if (call.argument<List<String>>("mimeTypes") != null)
            builder.addUsingMimeType(call.argument("mimeTypes"))
        builder.start { intent ->
            startWithTransition(activityContext,
                    intent,
                    FilePickerConstant.REQUEST_CODE_PICK_FILE
            )
        }
    }
}
