package com.example.flutter_files_picker.filepicker.ui.activity;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.databinding.DataBindingUtil;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.flutter_files_picker.R;
import com.example.flutter_files_picker.filepicker.local.DividerGridItemDecoration;
import com.example.flutter_files_picker.filepicker.local.FilePickerConstant;
import com.example.flutter_files_picker.filepicker.local.adapter.VideoPickAdapter;
import com.example.flutter_files_picker.filepicker.local.filter.FileFilter;
import com.example.flutter_files_picker.filepicker.local.filter.entity.Directory;
import com.example.flutter_files_picker.filepicker.local.filter.entity.VideoFile;
import com.example.flutter_files_picker.filepicker.ui.BaseActivity;
import com.example.flutter_files_picker.filepicker.util.ActivityUtils;
import com.example.flutter_files_picker.filepicker.util.permissions.PermissionsKt;
import com.example.flutter_files_picker.filepicker.util.permissions.util.PermissionsOptions;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import static com.example.flutter_files_picker.filepicker.ui.Picker.FileType.*;

/**
 * Created by Vincent Woo
 * Date: 2016/10/21
 * Time: 14:02
 */

public class VideoPickActivity extends BaseActivity {
    public static final String THUMBNAIL_PATH = "FilePick";
    public static final String IS_NEED_CAMERA = "IsNeedCamera";
    public static final String IS_ALLOW_CROP = "IsAllowCrop";
    public static final String IS_TAKEN_AUTO_SELECTED = "IsTakenAutoSelected";

    public static final int COLUMN_NUMBER = 3;
    public static final String FILETYPES = "FileTypes";
    public int mCurrentNumber = 0;
    public ArrayList<VideoFile> mSelectedList = new ArrayList<>();
    private int mMaxNumber;
    private RecyclerView mRecyclerView;
    private VideoPickAdapter mAdapter;
    private boolean isNeedCamera;
    private boolean isTakenAutoSelected;
    private List<Directory<VideoFile>> mAll;
    private ProgressBar mProgressBar;
    private TextView tv_count;
    private TextView tv_folder;
    private LinearLayout ll_folder;
    private ImageView btn_filter;
    private ImageView ivDone;
    private LinearLayout tb_pick;
    private boolean isAllowCrop;
    private ArrayList<String> fileTypes = new ArrayList<>();
    private boolean isPickable = false;


    public static Intent getActivityIntent(Context context, boolean isMultiSelection, boolean isCamera, boolean isFolderList, int numFiles, boolean isAllowCrop, ArrayList<String> fileTypes) {
        Intent intent = new Intent(context, VideoPickActivity.class);
        intent.putExtra(VideoPickActivity.IS_NEED_CAMERA, isCamera);
        intent.putExtra(VideoPickActivity.IS_ALLOW_CROP, isAllowCrop);
        intent.putExtra(FilePickerConstant.MAX_NUMBER, isMultiSelection ? numFiles : DEFAULT_MAX_NUMBER);
        intent.putExtra(AudioPickActivity.FILETYPES, fileTypes);
        intent.putExtra(VideoPickActivity.IS_NEED_FOLDER_LIST, isFolderList);
        return intent;
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        DataBindingUtil.setContentView(this,R.layout.activity_video_pick);
        mMaxNumber = getIntent().getIntExtra(FilePickerConstant.MAX_NUMBER, DEFAULT_MAX_NUMBER);
        fileTypes = getIntent().getStringArrayListExtra(FILETYPES);
        isNeedCamera = getIntent().getBooleanExtra(IS_NEED_CAMERA, false);
        isTakenAutoSelected = getIntent().getBooleanExtra(IS_TAKEN_AUTO_SELECTED, true);
        isAllowCrop = getIntent().getBooleanExtra(IS_ALLOW_CROP, false);
        initView();

        for (String type : fileTypes) {
            if (type.equals(TYPE_MPEG.getType()) || type.equals(TYPE_MP4.getType()) || type.equals(TYPE_M4V.getType()) || type.equals(TYPE_3GP.getType()) || type.equals(TYPE_3GPP.getType()) || type.equals(TYPE_WEBM.getType()) || type.equals(TYPE_AVI.getType())) {
                isPickable = true;
                break;
            }
        }

        if (!isPickable) {
            Toast.makeText(this, "No suitable files found.", Toast.LENGTH_SHORT).show();
            Intent intent = new Intent();
            setResult(RESULT_CANCELED, intent);
            ActivityUtils.finishWithTransition(this);
        }

        PermissionsKt.runWithPermissions(VideoPickActivity.this, new String[]{Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE}, new PermissionsOptions(), () -> {
            loadData();
            return null;
        });
    }

    private void initView() {
        tv_count = findViewById(R.id.tv_count);
        tv_count.setText(mCurrentNumber + "/" + mMaxNumber);

        tv_folder = findViewById(R.id.tv_folder);
        tv_folder.setText(getResources().getString(R.string.lbl_all));


        mRecyclerView = findViewById(R.id.rv_video_pick);
        GridLayoutManager layoutManager = new GridLayoutManager(this, COLUMN_NUMBER);
        mRecyclerView.setLayoutManager(layoutManager);
        mRecyclerView.addItemDecoration(new DividerGridItemDecoration(this));

        mAdapter = new VideoPickAdapter(this, isNeedCamera, mMaxNumber);
        mRecyclerView.setAdapter(mAdapter);

        mAdapter.setOnSelectStateListener((state, file) -> {
            if (state) {
                mSelectedList.add(file);
                mCurrentNumber++;
            } else {
                mSelectedList.remove(file);
                if (mCurrentNumber > 0)
                    mCurrentNumber--;
                else
                    mCurrentNumber = 0;
            }
            tv_count.setText(mCurrentNumber + "/" + mMaxNumber);
        });

        mProgressBar = findViewById(R.id.pb_video_pick);
        File folder = new File(getExternalCacheDir().getAbsolutePath() + File.separator + THUMBNAIL_PATH);
        if (!folder.exists()) {
            mProgressBar.setVisibility(View.VISIBLE);
        } else {
            mProgressBar.setVisibility(View.GONE);
        }

        ivDone = findViewById(R.id.ivDone);
        ivDone.setOnClickListener(v -> {
            if (mSelectedList.size() == 0) {
                Toast.makeText(this, "Please select Video", Toast.LENGTH_LONG).show();
                return;
            }
            if (isAllowCrop) {
                Intent intent = new Intent(this, CropVideosActivity.class);
                intent.putParcelableArrayListExtra(FilePickerConstant.RESULT_PICK_FILE, mSelectedList);
                startActivityForResult(intent, FilePickerConstant.REQUEST_CODE_CROP_FILES);
            } else {
                Intent intent = new Intent();
                intent.putParcelableArrayListExtra(FilePickerConstant.RESULT_PICK_FILE, mSelectedList);
                setResult(RESULT_OK, intent);
                ActivityUtils.finishWithTransition(this);
            }
        });

        tb_pick = findViewById(R.id.tb_pick);
        ll_folder = findViewById(R.id.fabFolder);
        btn_filter = findViewById(R.id.filterBtn);

        setFilterBackground(ll_folder);

        if (isNeedFolderList) {
            btn_filter.setVisibility(View.VISIBLE);
            btn_filter.setOnClickListener(v -> mFolderHelper.toggle(tb_pick));

            mFolderHelper.setFolderListListener(directory -> {
                mFolderHelper.toggle(tb_pick);
                tv_folder.setText(directory.getName());

                if (TextUtils.isEmpty(directory.getPath())) { //All
                    refreshData(mAll);
                } else {
                    for (Directory<VideoFile> dir : mAll) {
                        if (dir.getPath().equals(directory.getPath())) {
                            List<Directory<VideoFile>> list = new ArrayList<>();
                            list.add(dir);
                            refreshData(list);
                            break;
                        }
                    }
                }
            });
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case FilePickerConstant.REQUEST_CODE_TAKE_VIDEO:
                if (resultCode == RESULT_OK) {
                    Intent mediaScanIntent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
                    File file = new File(mAdapter.mVideoPath);
                    Uri contentUri = Uri.fromFile(file);
                    mediaScanIntent.setData(contentUri);
                    sendBroadcast(mediaScanIntent);
                    loadData();
                }
                break;
            case FilePickerConstant.REQUEST_CODE_CROP_FILES:
                Intent intent = new Intent();
                intent.putParcelableArrayListExtra(FilePickerConstant.RESULT_PICK_FILE, data.getParcelableArrayListExtra(FilePickerConstant.RESULT_CROPPED_FILES));
                setResult(RESULT_OK, intent);
                ActivityUtils.finishWithTransition(this);
                break;
        }
    }

    private void loadData() {
        FileFilter.getVideos(this, directories -> {
            mProgressBar.setVisibility(View.GONE);
            // Refresh folder list
            if (isNeedFolderList) {
                ArrayList<Directory> list = new ArrayList<>();
                Directory all = new Directory();
                all.setName(getResources().getString(R.string.lbl_all));
                list.add(all);
                list.addAll(directories);
                mFolderHelper.fillData(list);
            }

            mAll = directories;
            refreshData(directories);
        });
    }

    private void refreshData(List<Directory<VideoFile>> directories) {
        boolean tryToFindTaken = isTakenAutoSelected;

        // if auto-select taken file is enabled, make sure requirements are met
        if (tryToFindTaken && !TextUtils.isEmpty(mAdapter.mVideoPath)) {
            File takenFile = new File(mAdapter.mVideoPath);
            tryToFindTaken = !mAdapter.isUpToMax() && takenFile.exists(); // try to select taken file only if max isn't reached and the file exists
        }

        List<VideoFile> list = new ArrayList<>();
        for (Directory<VideoFile> directory : directories) {
            list.addAll(directory.getFiles());

            // auto-select taken file?
            if (tryToFindTaken) {
                tryToFindTaken = findAndAddTaken(directory.getFiles());   // if taken file was found, we're done
            }
        }

        for (VideoFile file : mSelectedList) {
            int index = list.indexOf(file);
            if (index != -1) {
                list.get(index).setSelected(true);
            }
        }
        mAdapter.refresh(list);
    }

    private boolean findAndAddTaken(List<VideoFile> list) {
        for (VideoFile videoFile : list) {
            if (videoFile.getPath().equals(mAdapter.mVideoPath)) {
                mSelectedList.add(videoFile);
                mCurrentNumber++;
                mAdapter.setCurrentNumber(mCurrentNumber);
                tv_count.setText(mCurrentNumber + "/" + mMaxNumber);

                return true;
            }
        }
        return false;
    }
}
