package com.example.flutter_files_picker.filepicker.local;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.util.DisplayMetrics;
import android.view.WindowManager;

import java.io.File;
import java.util.Arrays;
import java.util.List;

public class Util {

    public static final String APPLICATION_ID = "com.coruscate.baseproject";

    public static final String[] audio_ext = {"mp3", "mpeg", "wav", "aac", "m4a", "amr"};
    public static final String[] image_ext = {"png", "jpg", "bmp", "jpeg", "webp"};
    public static final String[] video_ext = {"mpeg", "mp4", "m4v", "3gp", "3gpp", "webm", "avi"};
    public static final String[] doc_ext = {"doc", "docx", "txt", "pdf", "xls", "xlsx", "ppt", "pptx"};

    public static boolean detectIntent(Context ctx, Intent intent) {
        final PackageManager packageManager = ctx.getPackageManager();
        List<ResolveInfo> list = packageManager.queryIntentActivities(
                intent, PackageManager.MATCH_DEFAULT_ONLY);
        return list.size() > 0;
    }

    public static String getDurationString(long duration) {
//        long days = duration / (1000 * 60 * 60 * 24);
        long hours = (duration % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60);
        long minutes = (duration % (1000 * 60 * 60)) / (1000 * 60);
        long seconds = (duration % (1000 * 60)) / 1000;

        String hourStr = (hours < 10) ? "0" + hours : hours + "";
        String minuteStr = (minutes < 10) ? "0" + minutes : minutes + "";
        String secondStr = (seconds < 10) ? "0" + seconds : seconds + "";

        if (hours != 0) {
            return hourStr + ":" + minuteStr + ":" + secondStr;
        } else {
            return minuteStr + ":" + secondStr;
        }
    }

    public static int getScreenWidth(Context ctx) {
        WindowManager wm = (WindowManager) ctx.getSystemService(Context.WINDOW_SERVICE);
        DisplayMetrics dm = new DisplayMetrics();
        wm.getDefaultDisplay().getMetrics(dm);
        return dm.widthPixels;
    }

    public static int getScreenHeight(Context ctx) {
        WindowManager wm = (WindowManager) ctx.getSystemService(Context.WINDOW_SERVICE);
        DisplayMetrics dm = new DisplayMetrics();
        wm.getDefaultDisplay().getMetrics(dm);
        return dm.heightPixels;
    }

    public static int dip2px(Context context, float dpValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dpValue * scale + 0.5f);
    }

    public static int px2dip(Context context, float pxValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (pxValue / scale + 0.5f);
    }

    /**
     * Extract the file name in a URL
     * /storage/emulated/legacy/Download/sample.pptx = sample.pptx
     *
     * @param url String of a URL
     * @return the file name of URL with suffix
     */
    public static String extractFileNameWithSuffix(String url) {
        return url.substring(url.lastIndexOf("/") + 1);
    }

    /**
     * Extract the file name in a URL
     * /storage/emulated/legacy/Download/sample.pptx = sample
     *
     * @param url String of a URL
     * @return the file name of URL without suffix
     */
    public static String extractFileNameWithoutSuffix(String url) {
        try {
            return url.substring(url.lastIndexOf("/") + 1, url.lastIndexOf("."));
        } catch (StringIndexOutOfBoundsException e) {
            e.printStackTrace();
            return "";
        }
    }

    /**
     * Extract the path in a URL
     * /storage/emulated/legacy/Download/sample.pptx = /storage/emulated/legacy/Download/
     *
     * @param url String of a URL
     * @return the path of URL with the file separator
     */
    public static String extractPathWithSeparator(String url) {
        return url.substring(0, url.lastIndexOf("/") + 1);
    }

    /**
     * Extract the path in a URL
     * /storage/emulated/legacy/Download/sample.pptx = /storage/emulated/legacy/Download
     *
     * @param url String of a URL
     * @return the path of URL without the file separator
     */
    public static String extractPathWithoutSeparator(String url) {
        return url.substring(0, url.lastIndexOf("/"));
    }

    /**
     * Extract the suffix in a URL
     * /storage/emulated/legacy/Download/sample.pptx = pptx
     *
     * @param url String of a URL
     * @return the suffix of URL
     */
    public static String extractFileSuffix(String url) {
        if (url.contains(".")) {
            return url.substring(url.lastIndexOf(".") + 1);
        } else {
            return "";
        }
    }

    public static boolean fileExist(String filePath) {
        File file = new File(filePath);
        return file.exists() && file.length() > 0;
    }

    public static FileCategory getFileCategory(String filePath) {
        String suffix = extractFileSuffix(filePath);
        if (Arrays.asList(image_ext).contains(suffix)) {
            return FileCategory.IMAGE;
        } else if (Arrays.asList(audio_ext).contains(suffix)) {
            return FileCategory.AUDIO;
        } else if (Arrays.asList(video_ext).contains(suffix)) {
            return FileCategory.VIDEO;
        } else if (Arrays.asList(doc_ext).contains(suffix)) {
            return FileCategory.DOCUMENT;
        } else {
            return FileCategory.UNKNOWN;
        }
    }

    public enum FileCategory {
        IMAGE,
        AUDIO,
        VIDEO,
        DOCUMENT,
        UNKNOWN
    }
}
