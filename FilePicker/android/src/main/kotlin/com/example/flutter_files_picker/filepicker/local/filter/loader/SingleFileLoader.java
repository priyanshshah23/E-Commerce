package com.example.flutter_files_picker.filepicker.local.filter.loader;

import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.provider.MediaStore;

import androidx.loader.content.CursorLoader;

import com.example.flutter_files_picker.filepicker.local.Util;
import com.example.flutter_files_picker.filepicker.local.filter.callback.FilterResultCallback;
import com.example.flutter_files_picker.filepicker.local.filter.entity.AudioFile;
import com.example.flutter_files_picker.filepicker.local.filter.entity.Directory;
import com.example.flutter_files_picker.filepicker.local.filter.entity.ImageFile;
import com.example.flutter_files_picker.filepicker.local.filter.entity.VideoFile;

import java.util.ArrayList;
import java.util.List;

import static android.provider.BaseColumns._ID;
import static android.provider.MediaStore.Images.ImageColumns.BUCKET_DISPLAY_NAME;
import static android.provider.MediaStore.Images.ImageColumns.BUCKET_ID;
import static android.provider.MediaStore.Images.ImageColumns.ORIENTATION;
import static android.provider.MediaStore.MediaColumns.DATA;
import static android.provider.MediaStore.MediaColumns.DATE_ADDED;
import static android.provider.MediaStore.MediaColumns.SIZE;
import static android.provider.MediaStore.MediaColumns.TITLE;
import static android.provider.MediaStore.Video.VideoColumns.DURATION;

/**
 * Created by Vincent Woo
 * Date: 2016/10/12
 * Time: 14:48
 */

public class SingleFileLoader extends CursorLoader {
    private static final String[] IMAGE_PROJECTION = {
            //Base File
            MediaStore.Images.Media._ID,
            MediaStore.Images.Media.TITLE,
            MediaStore.Images.Media.DATA,
            MediaStore.Images.Media.SIZE,
            MediaStore.Images.Media.BUCKET_ID,
            MediaStore.Images.Media.BUCKET_DISPLAY_NAME,
            MediaStore.Images.Media.DATE_ADDED,
            //Image File
            MediaStore.Images.Media.ORIENTATION
    };
    private static final String[] VIDEO_PROJECTION = {
            //Base File
            MediaStore.Video.Media._ID,
            MediaStore.Video.Media.TITLE,
            MediaStore.Video.Media.DATA,
            MediaStore.Video.Media.SIZE,
            MediaStore.Video.Media.BUCKET_ID,
            MediaStore.Video.Media.BUCKET_DISPLAY_NAME,
            MediaStore.Video.Media.DATE_ADDED,
            //Video File
            MediaStore.Video.Media.DURATION
    };
    private static final String[] AUDIO_PROJECTION = {
            //Base File
            MediaStore.Audio.Media._ID,
            MediaStore.Audio.Media.TITLE,
            MediaStore.Audio.Media.DATA,
            MediaStore.Audio.Media.SIZE,
            MediaStore.Audio.Media.DATE_ADDED,
            //Audio File
            MediaStore.Audio.Media.DURATION
    };
    private Context context;

    private SingleFileLoader(Context context, Uri uri, String[] projection, String selection, String[] selectionArgs, String sortOrder) {
        super(context, uri, projection, selection, selectionArgs, sortOrder);
    }

    public SingleFileLoader(Context context) {
        super(context);
        this.context = context;
    }

    public void getPath(Uri uri, Util.FileCategory category, FilterResultCallback callback) {
        if (category == Util.FileCategory.IMAGE) {
            Cursor cursor = context.getContentResolver().query(uri, IMAGE_PROJECTION, null, null, null);
            List<Directory<ImageFile>> file = onImageResult(cursor);
            cursor.close();
            callback.onResult(file);
        }else if (category == Util.FileCategory.VIDEO){
            Cursor cursor = context.getContentResolver().query(uri, VIDEO_PROJECTION, null, null, null);
            List<Directory<VideoFile>> file = onVideoResult(cursor);
            cursor.close();
            callback.onResult(file);
        }else if (category == Util.FileCategory.AUDIO){
            Cursor cursor = context.getContentResolver().query(uri, AUDIO_PROJECTION, null, null, null);
            List<Directory<AudioFile>> file = onAudioResult(cursor);
            cursor.close();
            callback.onResult(file);
        }
    }

    private List<Directory<ImageFile>> onImageResult(Cursor data) {
        List<Directory<ImageFile>> directories = new ArrayList<>();

        if (data.getPosition() != -1) {
            data.moveToPosition(-1);
        }

        while (data.moveToNext()) {
            //Create a File instance
            //check for file exist in storage or not
            if (Util.fileExist(data.getString(data.getColumnIndexOrThrow(DATA)))) {
                ImageFile img = new ImageFile();
                img.setId(data.getLong(data.getColumnIndexOrThrow(_ID)));
                img.setName(data.getString(data.getColumnIndexOrThrow(TITLE)));
                img.setPath(data.getString(data.getColumnIndexOrThrow(DATA)));
                img.setSize(data.getLong(data.getColumnIndexOrThrow(SIZE)));
                img.setBucketId(data.getString(data.getColumnIndexOrThrow(BUCKET_ID)));
                img.setBucketName(data.getString(data.getColumnIndexOrThrow(BUCKET_DISPLAY_NAME)));
                img.setDate(data.getLong(data.getColumnIndexOrThrow(DATE_ADDED)));

                img.setOrientation(data.getInt(data.getColumnIndexOrThrow(ORIENTATION)));

                //Create a Directory
                Directory<ImageFile> directory = new Directory<>();
                directory.setId(img.getBucketId());
                directory.setName(img.getBucketName());
                directory.setPath(Util.extractPathWithoutSeparator(img.getPath()));

                if (!directories.contains(directory)) {
                    directory.addFile(img);
                    directories.add(directory);
                } else {
                    directories.get(directories.indexOf(directory)).addFile(img);
                }
            }
        }
        return directories;
    }

    private List<Directory<VideoFile>> onVideoResult(final Cursor data) {
        List<Directory<VideoFile>> directories = new ArrayList<>();

        if (data.getPosition() != -1) {
            data.moveToPosition(-1);
        }

        while (data.moveToNext()) {
            //Create a File instance
            VideoFile video = new VideoFile();
            video.setId(data.getLong(data.getColumnIndexOrThrow(_ID)));
            video.setName(data.getString(data.getColumnIndexOrThrow(TITLE)));
            video.setPath(data.getString(data.getColumnIndexOrThrow(DATA)));
            video.setSize(data.getLong(data.getColumnIndexOrThrow(SIZE)));
            video.setBucketId(data.getString(data.getColumnIndexOrThrow(BUCKET_ID)));
            video.setBucketName(data.getString(data.getColumnIndexOrThrow(BUCKET_DISPLAY_NAME)));
            video.setDate(data.getLong(data.getColumnIndexOrThrow(DATE_ADDED)));

            video.setDuration(data.getLong(data.getColumnIndexOrThrow(DURATION)));

            //Create a Directory
            Directory<VideoFile> directory = new Directory<>();
            directory.setId(video.getBucketId());
            directory.setName(video.getBucketName());
            directory.setPath(Util.extractPathWithoutSeparator(video.getPath()));

            if (!directories.contains(directory)) {
                directory.addFile(video);
                directories.add(directory);
            } else {
                directories.get(directories.indexOf(directory)).addFile(video);
            }
        }
        return directories;
    }

    private List<Directory<AudioFile>> onAudioResult(Cursor data) {
        List<Directory<AudioFile>> directories = new ArrayList<>();

        if (data.getPosition() != -1) {
            data.moveToPosition(-1);
        }

        while (data.moveToNext()) {
            //Create a File instance
            AudioFile audio = new AudioFile();
            audio.setId(data.getLong(data.getColumnIndexOrThrow(_ID)));
            audio.setName(data.getString(data.getColumnIndexOrThrow(TITLE)));
            audio.setPath(data.getString(data.getColumnIndexOrThrow(DATA)));
            audio.setSize(data.getLong(data.getColumnIndexOrThrow(SIZE)));
            audio.setDate(data.getLong(data.getColumnIndexOrThrow(DATE_ADDED)));

            audio.setDuration(data.getLong(data.getColumnIndexOrThrow(DURATION)));

            //Create a Directory
            Directory<AudioFile> directory = new Directory<>();
            directory.setName(Util.extractFileNameWithSuffix(Util.extractPathWithoutSeparator(audio.getPath())));
            directory.setPath(Util.extractPathWithoutSeparator(audio.getPath()));

            if (!directories.contains(directory)) {
                directory.addFile(audio);
                directories.add(directory);
            } else {
                directories.get(directories.indexOf(directory)).addFile(audio);
            }
        }
        return directories;
    }
}
