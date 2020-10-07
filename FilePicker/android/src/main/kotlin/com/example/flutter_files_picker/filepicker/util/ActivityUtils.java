package com.example.flutter_files_picker.filepicker.util;

import android.app.Activity;
import android.content.Intent;

import androidx.appcompat.app.AppCompatActivity;

import com.example.flutter_files_picker.R;

public class ActivityUtils {

    public static void startWithTransition(Activity activity, Intent intent, int requestCode) {
        if (requestCode == 0)
            activity.startActivity(intent);
        else
            activity.startActivityForResult(intent, requestCode);
        activity.overridePendingTransition(R.anim.grow_fade_in, R.anim.scale_out);
    }

    public static void finishWithTransition(AppCompatActivity activity) {
        activity.finish();
        activity.overridePendingTransition(R.anim.scale_in, R.anim.shrink_fade_out);
    }
}
