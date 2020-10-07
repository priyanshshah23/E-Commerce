package com.example.flutter_files_picker.filepicker.local.filter;

import android.app.Activity;
import android.net.Uri;

import androidx.fragment.app.FragmentActivity;

import com.example.flutter_files_picker.filepicker.local.Util;
import com.example.flutter_files_picker.filepicker.local.filter.callback.FileLoaderCallbacks;
import com.example.flutter_files_picker.filepicker.local.filter.callback.FilterResultCallback;
import com.example.flutter_files_picker.filepicker.local.filter.entity.AudioFile;
import com.example.flutter_files_picker.filepicker.local.filter.entity.ImageFile;
import com.example.flutter_files_picker.filepicker.local.filter.entity.NormalFile;
import com.example.flutter_files_picker.filepicker.local.filter.entity.VideoFile;
import com.example.flutter_files_picker.filepicker.local.filter.loader.SingleFileLoader;

import static com.example.flutter_files_picker.filepicker.local.filter.callback.FileLoaderCallbacks.*;


/**
 * Created by Vincent Woo
 * Date: 2016/10/11
 * Time: 10:19
 */

public class FileFilter {
    public static void getImages(FragmentActivity activity, FilterResultCallback<ImageFile> callback){
        activity.getSupportLoaderManager().initLoader(0, null,
                new FileLoaderCallbacks(activity, callback, TYPE_IMAGE));
    }

    public static void getVideos(FragmentActivity activity, FilterResultCallback<VideoFile> callback){
        activity.getSupportLoaderManager().initLoader(1, null,
                new FileLoaderCallbacks(activity, callback, TYPE_VIDEO));
    }

    public static void getAudios(FragmentActivity activity, FilterResultCallback<AudioFile> callback){
        activity.getSupportLoaderManager().initLoader(2, null,
                new FileLoaderCallbacks(activity, callback, TYPE_AUDIO));
    }

    public static void getFiles(FragmentActivity activity,
                                FilterResultCallback<NormalFile> callback, String[] suffix){
        activity.getSupportLoaderManager().initLoader(3, null,
                new FileLoaderCallbacks(activity, callback, TYPE_FILE, suffix));
    }

    public static void getImageFiles(Activity activity, FilterResultCallback<ImageFile> callback, Uri uri, Util.FileCategory category){
        new SingleFileLoader(activity).getPath(uri, category, callback);
    }

    public static void getVideoFiles(Activity activity, FilterResultCallback<VideoFile> callback, Uri uri, Util.FileCategory category){
        new SingleFileLoader(activity).getPath(uri, category, callback);
    }

    public static void getAudioFiles(Activity activity, FilterResultCallback<AudioFile> callback, Uri uri, Util.FileCategory category){
        new SingleFileLoader(activity).getPath(uri, category, callback);
    }
}
