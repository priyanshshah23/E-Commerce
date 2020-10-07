package com.example.flutter_files_picker.filepicker.local.videotrimmer.interfaces;

import android.net.Uri;

/**
 * Created by Deep Patel
 * (Sr. Android Developer)
 * on 6/4/2018
 */
public interface OnTrimVideoListener {

    void finishTrimming(final Uri uri);
    void startTrimming();
}
