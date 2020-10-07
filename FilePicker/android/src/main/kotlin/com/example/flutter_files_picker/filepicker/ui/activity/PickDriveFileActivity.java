package com.example.flutter_files_picker.filepicker.ui.activity;

import android.Manifest;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;

import androidx.annotation.Nullable;

import com.example.flutter_files_picker.R;
import com.example.flutter_files_picker.filepicker.local.FilePickerConstant;
import com.example.flutter_files_picker.filepicker.local.Util;
import com.example.flutter_files_picker.filepicker.local.filter.FileFilter;
import com.example.flutter_files_picker.filepicker.local.filter.entity.AudioFile;
import com.example.flutter_files_picker.filepicker.local.filter.entity.BaseFile;
import com.example.flutter_files_picker.filepicker.local.filter.entity.Directory;
import com.example.flutter_files_picker.filepicker.local.filter.entity.ImageFile;
import com.example.flutter_files_picker.filepicker.local.filter.entity.VideoFile;
import com.example.flutter_files_picker.filepicker.util.permissions.PermissionsKt;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.drive.DriveApi;
import com.google.android.gms.drive.DriveContents;
import com.google.android.gms.drive.DriveFile;
import com.example.flutter_files_picker.filepicker.util.permissions.util.PermissionsOptions;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import static com.example.flutter_files_picker.filepicker.ui.Picker.FILE_TYPES;


public class PickDriveFileActivity extends DriveBaseActivity {

    public static final String IS_ALLOW_CROP = "IsAllowCrop";
    private static final String TAG = "PickDriveFileActivity";
    ArrayList<String> fileTypes = new ArrayList<>();
    private boolean isAllowCrop;

    public static Intent getActivityIntent(Context context, ArrayList<String> fileTypes, boolean isAllowCrop) {
        Intent intent = new Intent(context, PickDriveFileActivity.class);
        intent.putStringArrayListExtra(FILE_TYPES, fileTypes);
        intent.putExtra(IS_ALLOW_CROP, isAllowCrop);
        return intent;
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        fileTypes = getIntent().getStringArrayListExtra(FILE_TYPES);
        isAllowCrop = getIntent().getBooleanExtra(IS_ALLOW_CROP, true);

    }

    @Override
    protected void onDriveClientReady() {

        PermissionsKt.runWithPermissions(PickDriveFileActivity.this, new String[]{Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE}, new PermissionsOptions(), () -> {
            pickFile(fileTypes)
                    .addOnSuccessListener(this,
                            driveId -> pinFile(driveId.asDriveFile()))
                    .addOnFailureListener(this, e -> {
                        showMessage(getString(R.string.lbl_file_not_selected));
                        finish();
                    });
            return null;
        });
    }

    private void pinFile(final DriveFile driveFile) {
       /* driveFile.getMetadata(getDriveClient().zzagc()).setResultCallback(metadataResult -> {
            Metadata data = metadataResult.getMetadata();

            Util.FileCategory category = Util.getFileCategory(data.getOriginalFilename());

            String folder;
            if (category == Util.FileCategory.IMAGE) {
                folder = Environment.getExternalStorageDirectory().getPath() + File.separator + "images/media";
            } else if (category == Util.FileCategory.VIDEO) {
                folder = Environment.getExternalStorageDirectory().getPath() + File.separator + "video/media";
            } else if (category == Util.FileCategory.AUDIO) {
                folder = Environment.getExternalStorageDirectory().getPath() + File.separator + "audio/media";
            } else {
                folder = Environment.getExternalStorageDirectory().getPath() + File.separator + "documents";
            }

            File directory = new File(folder);
            if (!directory.exists()) {
                directory.mkdirs();
            }

            File out = new File(folder + "/" + data.getOriginalFilename());
            DownloadFile(category, driveFile, out, getDriveClient().zzagc());
        });*/
    }

    public void DownloadFile(Util.FileCategory category, final DriveFile file, final File filename, final GoogleApiClient mGoogleApiClient) {

        ProgressDialog dialog = new ProgressDialog(this);
        dialog.setMessage("Downloading File...");
        dialog.setCancelable(false);
        dialog.setCanceledOnTouchOutside(false);
        dialog.show();
        if (!filename.exists()) {
            try {
                filename.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
                dialog.dismiss();
                finish();
            }
        }

        new Thread(() -> {
            DriveApi.DriveContentsResult driveContentsResult = file.open(mGoogleApiClient, DriveFile.MODE_READ_ONLY, null).await();
            DriveContents driveContents = driveContentsResult.getDriveContents();
            InputStream inputstream = driveContents.getInputStream();

            try {
                FileOutputStream fileOutput = new FileOutputStream(filename);

                byte[] buffer = new byte[1024];
                int bufferLength = 0;
                while ((bufferLength = inputstream.read(buffer)) > 0) {
                    fileOutput.write(buffer, 0, bufferLength);
                }
                fileOutput.close();
                inputstream.close();
                dialog.dismiss();

                if (category == Util.FileCategory.IMAGE) {
                    ContentValues values = new ContentValues();
                    values.put(MediaStore.Images.Media.DATA, filename.getPath());
                    Uri uri = getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values);
                    loadData(uri, category);
                } else if (category == Util.FileCategory.VIDEO) {
                    ContentValues values = new ContentValues();
                    values.put(MediaStore.Video.Media.DATA, filename.getPath());
                    Uri uri = getContentResolver().insert(MediaStore.Video.Media.EXTERNAL_CONTENT_URI, values);
                    loadData(uri, category);
                } else if (category == Util.FileCategory.AUDIO) {
                    ContentValues values = new ContentValues();
                    values.put(MediaStore.Audio.Media.DATA, filename.getPath());
                    Uri uri = getContentResolver().insert(MediaStore.Audio.Media.EXTERNAL_CONTENT_URI, values);
                    loadData(uri, category);
                } else {
                    BaseFile bf = new BaseFile();
                    bf.setId(System.currentTimeMillis());
                    bf.setBucketId(UUID.randomUUID().toString());
                    bf.setPath(filename.getPath());
                    bf.setBucketName("Documents");
                    bf.setDate(filename.lastModified());
                    bf.setName(Util.extractFileNameWithSuffix(filename.getPath()));
                    bf.setSelected(false);
                    bf.setSize(filename.length());

                    ArrayList<BaseFile> mSelectedList = new ArrayList<>();
                    mSelectedList.add(bf);

                    Intent resultIntent = new Intent();
                    resultIntent.putParcelableArrayListExtra(FilePickerConstant.RESULT_PICK_FILE, mSelectedList);
                    setResult(Activity.RESULT_OK, resultIntent);
                    finish();
                }
            } catch (IOException e) {
                e.printStackTrace();
                Intent resultIntent = new Intent();
                setResult(Activity.RESULT_CANCELED, resultIntent);
                finish();
            }
        }).start();
    }

    private void loadData(Uri fileUri, Util.FileCategory category) {
        if (category == Util.FileCategory.IMAGE) {
            FileFilter.getImageFiles(this, directories -> {
                List<ImageFile> list = new ArrayList<>();
                for (Directory<ImageFile> directory : directories) {
                    list.addAll(directory.getFiles());
                }
                if (!list.isEmpty()) {
                    ImageFile file = list.get(0);

                    if (isAllowCrop) {
                        ArrayList<ImageFile> mSelectedList = new ArrayList<>();
                        mSelectedList.add(file);

                        Intent intent = new Intent(this, CropImagesActivity.class);
                        intent.putParcelableArrayListExtra(FilePickerConstant.RESULT_PICK_FILE, mSelectedList);
                        startActivityForResult(intent, FilePickerConstant.REQUEST_CODE_CROP_FILES);
                    } else {
                        ArrayList<ImageFile> mSelectedList = new ArrayList<>();
                        mSelectedList.add(file);

                        Intent resultIntent = new Intent();
                        resultIntent.putParcelableArrayListExtra(FilePickerConstant.RESULT_PICK_FILE, mSelectedList);
                        setResult(Activity.RESULT_OK, resultIntent);
                        finish();
                    }
                }
            }, fileUri, category);
        } else if (category == Util.FileCategory.VIDEO) {
            FileFilter.getVideoFiles(this, directories -> {
                List<VideoFile> list = new ArrayList<>();
                for (Directory<VideoFile> directory : directories) {
                    list.addAll(directory.getFiles());
                }
                if (!list.isEmpty()) {
                    VideoFile file = list.get(0);

                    if (isAllowCrop) {
                        ArrayList<VideoFile> mSelectedList = new ArrayList<>();
                        mSelectedList.add(file);

                        Intent intent = new Intent(this, CropVideosActivity.class);
                        intent.putParcelableArrayListExtra(FilePickerConstant.RESULT_PICK_FILE, mSelectedList);
                        startActivityForResult(intent, FilePickerConstant.REQUEST_CODE_CROP_FILES);
                    } else {
                        ArrayList<VideoFile> mSelectedList = new ArrayList<>();
                        mSelectedList.add(file);

                        Intent resultIntent = new Intent();
                        resultIntent.putParcelableArrayListExtra(FilePickerConstant.RESULT_PICK_FILE, mSelectedList);
                        setResult(Activity.RESULT_OK, resultIntent);
                        finish();
                    }
                }
            }, fileUri, category);
        } else if (category == Util.FileCategory.AUDIO) {
            FileFilter.getAudioFiles(this, directories -> {
                List<AudioFile> list = new ArrayList<>();
                for (Directory<AudioFile> directory : directories) {
                    list.addAll(directory.getFiles());
                }
                if (!list.isEmpty()) {
                    AudioFile file = list.get(0);
                    ArrayList<AudioFile> mSelectedList = new ArrayList<>();
                    mSelectedList.add(file);

                    Intent resultIntent = new Intent();
                    resultIntent.putParcelableArrayListExtra(FilePickerConstant.RESULT_PICK_FILE, mSelectedList);
                    setResult(Activity.RESULT_OK, resultIntent);
                    finish();
                }
            }, fileUri, category);
        }
    }

    @Override
    public void onBackPressed() {
        Intent resultIntent = new Intent();
        setResult(Activity.RESULT_CANCELED, resultIntent);
        finish();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == FilePickerConstant.REQUEST_CODE_CROP_FILES) {
            if (resultCode == Activity.RESULT_OK) {
                Intent intent = new Intent();
                intent.putParcelableArrayListExtra(FilePickerConstant.RESULT_PICK_FILE, data.getParcelableArrayListExtra(FilePickerConstant.RESULT_CROPPED_FILES));
                setResult(RESULT_OK, intent);
                finish();
            } else {
                Intent intent = new Intent();
                setResult(RESULT_CANCELED, intent);
                finish();
            }
        }
    }
}
