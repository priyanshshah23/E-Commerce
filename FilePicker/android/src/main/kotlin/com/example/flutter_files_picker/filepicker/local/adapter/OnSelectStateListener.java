package com.example.flutter_files_picker.filepicker.local.adapter;

/**
 * Created by Vincent Woo
 * Date: 2016/10/14
 * Time: 16:06
 */

public interface OnSelectStateListener<T> {
    void OnSelectStateChanged(boolean state, T file);
}
