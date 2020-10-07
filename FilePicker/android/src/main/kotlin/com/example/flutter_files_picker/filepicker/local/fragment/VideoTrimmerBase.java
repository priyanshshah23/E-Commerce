package com.example.flutter_files_picker.filepicker.local.fragment;

import android.os.SystemClock;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatDelegate;
import androidx.core.content.ContextCompat;
import androidx.fragment.app.Fragment;

import com.example.flutter_files_picker.R;
import com.google.android.material.snackbar.Snackbar;


public class VideoTrimmerBase extends Fragment {
    static {
        AppCompatDelegate.setCompatVectorFromResourcesEnabled(true);
    }

    protected boolean shouldPerformDispatchTouch = true;
    protected long lastClickTime = 0;
    private Snackbar snackbar;

    public void showToastShort(String message) {
        Toast.makeText(getContext(), message, Toast.LENGTH_SHORT).show();
    }

    public void showToastLong(String message) {
        Toast.makeText(getContext(), message, Toast.LENGTH_LONG).show();
    }

    public void showSnackbar(View view, String msg, int LENGTH) {
        if (view == null) return;
        snackbar = Snackbar.make(view, msg, LENGTH);
        View sbView = snackbar.getView();
        TextView textView = sbView.findViewById(R.id.snackbar_text);
        textView.setTextColor(ContextCompat.getColor(getContext(), R.color.whiteBackground));
        snackbar.show();
    }

    public void preventDoubleClick(View view) {
        /*// preventing double, using threshold of 1000 ms*/
        if (SystemClock.elapsedRealtime() - lastClickTime < 1000) {
            return;
        }
        lastClickTime = SystemClock.elapsedRealtime();
    }
}
