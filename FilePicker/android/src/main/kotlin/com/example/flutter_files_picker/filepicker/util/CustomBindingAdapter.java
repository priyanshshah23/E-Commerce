package com.example.flutter_files_picker.filepicker.util;

import android.graphics.Color;
import android.graphics.ColorFilter;
import android.graphics.PorterDuff;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.databinding.BindingAdapter;

import com.example.flutter_files_picker.FlutterFilePickerPlugin;

public class CustomBindingAdapter {


    @BindingAdapter("customForegroundColor")
    public static void setColorFilter(View view, String dummy) {
        if (view instanceof ImageView) {
            ((ImageView) view).setColorFilter(FlutterFilePickerPlugin.Companion.getFOREGROUND_COLOR(), PorterDuff.Mode.SRC_IN);
        }
        if (view instanceof TextView) {
            ((TextView) view).setTextColor(FlutterFilePickerPlugin.Companion.getFOREGROUND_COLOR());
        }


    }

    @BindingAdapter("customBackgroundColor")
    public static void setBackgroundColor(View view, String dummy) {
        view.setBackgroundColor(FlutterFilePickerPlugin.Companion.getTHEME_COLOR());
    }
}
