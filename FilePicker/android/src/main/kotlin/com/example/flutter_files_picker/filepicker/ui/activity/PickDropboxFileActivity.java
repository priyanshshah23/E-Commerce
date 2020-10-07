package com.example.flutter_files_picker.filepicker.ui.activity;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.example.flutter_files_picker.filepicker.local.FilePickerConstant;
import com.example.flutter_files_picker.filepicker.local.Util;
import com.example.flutter_files_picker.filepicker.local.filter.FileFilter;
import com.example.flutter_files_picker.filepicker.local.filter.entity.AudioFile;
import com.example.flutter_files_picker.filepicker.local.filter.entity.BaseFile;
import com.example.flutter_files_picker.filepicker.local.filter.entity.Directory;
import com.example.flutter_files_picker.filepicker.local.filter.entity.ImageFile;
import com.example.flutter_files_picker.filepicker.local.filter.entity.VideoFile;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLConnection;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

import static com.example.flutter_files_picker.filepicker.ui.Picker.FILE_TYPES;


public class PickDropboxFileActivity extends AppCompatActivity {

    public static final String IS_ALLOW_CROP = "IsAllowCrop";
    static final int DBX_CHOOSER_REQUEST = 0;  // You can change this if needed
    public boolean isAllowCrop;
//    private DbxChooser mChooser;
    ArrayList<String> fileTypes = new ArrayList<>();

    public static Intent getActivityIntent(Context context, ArrayList<String> fileTypes, boolean isAllowCrop) {
        Intent intent = new Intent(context, PickDropboxFileActivity.class);
        intent.putStringArrayListExtra(FILE_TYPES, fileTypes);
        intent.putExtra(IS_ALLOW_CROP, isAllowCrop);
        return intent;
    }

    public static String getFileExt(String fileName) {
        return fileName.substring(fileName.lastIndexOf(".") + 1);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        fileTypes = getIntent().getStringArrayListExtra(FILE_TYPES);
        isAllowCrop = getIntent().getBooleanExtra(IS_ALLOW_CROP, true);

      /*  mChooser = new DbxChooser(BuildConfig.DROPBOX_KEY);
        DbxChooser.ResultType resultType = DbxChooser.ResultType.DIRECT_LINK;

        PermissionsManagerKt.runWithPermissions(PickDropboxFileActivity.this, new String[]{Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE}, new PermissionsOptions(), () -> {
            mChooser.forResultType(resultType).launch(PickDropboxFileActivity.this, DBX_CHOOSER_REQUEST);
            return null;
        });*/
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == DBX_CHOOSER_REQUEST) {
            if (resultCode == Activity.RESULT_OK) {
//                DbxChooser.Result result = new DbxChooser.Result(data);
                boolean isFileOk = false;

               /* Log.d("main", "Link to selected file: " + result.getLink());
                for (String type : fileTypes) {
                    if (type.contains(getFileExt(result.getLink().toString()))) {
                        isFileOk = true;
                        new DownloadFile().execute(result.getLink().toString());
                    }
                }*/

                if (!isFileOk) {
                    Toast.makeText(this, "Invalid File Selected, Please try again.", Toast.LENGTH_SHORT).show();
                    Intent resultIntent = new Intent();
                    setResult(Activity.RESULT_CANCELED, resultIntent);
                    finish();
                }
            } else {
                finish();
            }
        } else if (requestCode == FilePickerConstant.REQUEST_CODE_CROP_FILES) {
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
        } else {
            super.onActivityResult(requestCode, resultCode, data);
            finish();
        }
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

    private class DownloadFile extends AsyncTask<String, String, String> {

        private static final String TAG = "ASYNC";
        private ProgressDialog progressDialog;
        private String fileName;

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            this.progressDialog = new ProgressDialog(PickDropboxFileActivity.this);
            this.progressDialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
            this.progressDialog.setCancelable(false);
            this.progressDialog.setCanceledOnTouchOutside(false);
            this.progressDialog.show();
        }

        @Override
        protected String doInBackground(String... f_url) {
            int count;
            try {
                URL url = new URL(f_url[0]);
                URLConnection connection = url.openConnection();
                connection.connect();
                int lengthOfFile = connection.getContentLength();

                // input stream to read file - with 8k buffer
                InputStream input = new BufferedInputStream(url.openStream(), 8192);
                String timestamp = new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss", Locale.ENGLISH).format(new Date());

                fileName = f_url[0].substring(f_url[0].lastIndexOf('/') + 1);
                fileName = timestamp + "_" + fileName;

                Util.FileCategory category = Util.getFileCategory(url.getPath());

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

                File out = new File(folder + "/" + fileName);
                if (!out.exists()) {
                    out.createNewFile();
                }
                OutputStream output = new FileOutputStream(out);
                byte[] data = new byte[1024];
                long total = 0;

                while ((count = input.read(data)) != -1) {
                    total += count;
                    publishProgress("" + (int) ((total * 100) / lengthOfFile));
                    Log.d(TAG, "Progress: " + (int) ((total * 100) / lengthOfFile));

                    output.write(data, 0, count);
                }

                // flushing output
                output.flush();
                output.close();
                input.close();
                return out.getPath();

            } catch (Exception e) {
                e.printStackTrace();
            }
            return null;
        }

        protected void onProgressUpdate(String... progress) {
            progressDialog.setProgress(Integer.parseInt(progress[0]));
        }


        @Override
        protected void onPostExecute(String uri) {
            if (uri == null) {
                Toast.makeText(PickDropboxFileActivity.this, "Something went wrong while downloading file.", Toast.LENGTH_SHORT).show();
                Intent resultIntent = new Intent();
                setResult(Activity.RESULT_CANCELED, resultIntent);
                finish();
            }

            Util.FileCategory category = Util.getFileCategory(uri);
            // dismiss the dialog after the file was downloaded
            if (category == Util.FileCategory.IMAGE) {
                ContentValues values = new ContentValues();
                values.put(MediaStore.Images.Media.DATA, uri);
                Uri entry = getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values);
                loadData(entry, category);
            } else if (category == Util.FileCategory.VIDEO) {
                ContentValues values = new ContentValues();
                values.put(MediaStore.Video.Media.DATA, uri);
                Uri entry = getContentResolver().insert(MediaStore.Video.Media.EXTERNAL_CONTENT_URI, values);
                loadData(entry, category);
            } else if (category == Util.FileCategory.AUDIO) {
                ContentValues values = new ContentValues();
                values.put(MediaStore.Audio.Media.DATA, uri);
                Uri entry = getContentResolver().insert(MediaStore.Audio.Media.EXTERNAL_CONTENT_URI, values);
                loadData(entry, category);
            } else {
                BaseFile bf = new BaseFile();
                bf.setId(System.currentTimeMillis());
                bf.setBucketId(UUID.randomUUID().toString());
                bf.setPath(uri);
                bf.setBucketName("Documents");
                bf.setDate(new File(uri).lastModified());
                bf.setName(Util.extractFileNameWithSuffix(uri));
                bf.setSelected(false);
                bf.setSize(new File(uri).lastModified());

                ArrayList<BaseFile> mSelectedList = new ArrayList<>();
                mSelectedList.add(bf);

                Intent resultIntent = new Intent();
                resultIntent.putParcelableArrayListExtra(FilePickerConstant.RESULT_PICK_FILE, mSelectedList);
                setResult(Activity.RESULT_OK, resultIntent);
                finish();
            }

            this.progressDialog.dismiss();
        }
    }
}