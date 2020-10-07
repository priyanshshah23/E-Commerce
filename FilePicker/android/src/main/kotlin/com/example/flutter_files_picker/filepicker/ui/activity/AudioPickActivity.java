package com.example.flutter_files_picker.filepicker.ui.activity;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.databinding.DataBindingUtil;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.flutter_files_picker.R;
import com.example.flutter_files_picker.filepicker.local.DividerListItemDecoration;
import com.example.flutter_files_picker.filepicker.local.FilePickerConstant;
import com.example.flutter_files_picker.filepicker.local.ToastUtil;
import com.example.flutter_files_picker.filepicker.local.Util;
import com.example.flutter_files_picker.filepicker.local.adapter.AudioPickAdapter;
import com.example.flutter_files_picker.filepicker.local.adapter.FolderListAdapter;
import com.example.flutter_files_picker.filepicker.local.adapter.OnSelectStateListener;
import com.example.flutter_files_picker.filepicker.local.filter.FileFilter;
import com.example.flutter_files_picker.filepicker.local.filter.callback.FilterResultCallback;
import com.example.flutter_files_picker.filepicker.local.filter.entity.AudioFile;
import com.example.flutter_files_picker.filepicker.local.filter.entity.Directory;
import com.example.flutter_files_picker.filepicker.ui.BaseActivity;
import com.example.flutter_files_picker.filepicker.util.ActivityUtils;
import com.example.flutter_files_picker.filepicker.util.permissions.PermissionsKt;
import com.example.flutter_files_picker.filepicker.util.permissions.util.PermissionsOptions;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import static com.example.flutter_files_picker.filepicker.ui.Picker.FileType.TYPE_AAC;
import static com.example.flutter_files_picker.filepicker.ui.Picker.FileType.TYPE_AMPEG;
import static com.example.flutter_files_picker.filepicker.ui.Picker.FileType.TYPE_AMR;
import static com.example.flutter_files_picker.filepicker.ui.Picker.FileType.TYPE_M4A;
import static com.example.flutter_files_picker.filepicker.ui.Picker.FileType.TYPE_MP3;
import static com.example.flutter_files_picker.filepicker.ui.Picker.FileType.TYPE_WAV;


/**
 * Created by Vincent Woo
 * Date: 2016/10/21
 * Time: 17:31
 */

public class AudioPickActivity extends BaseActivity {
    public static final String IS_NEED_RECORDER = "IsNeedRecorder";
    public static final String FILETYPES = "FileTypes";
    public static final String IS_TAKEN_AUTO_SELECTED = "IsTakenAutoSelected";
    public int mCurrentNumber = 0;
    public ArrayList<AudioFile> mSelectedList = new ArrayList<>();
    private int mMaxNumber;
    private RecyclerView mRecyclerView;
    private AudioPickAdapter mAdapter;
    private boolean isNeedRecorder;
    private boolean isTakenAutoSelected;
    private ArrayList<String> fileTypes = new ArrayList<>();
    private List<Directory<AudioFile>> mAll;
    private String mAudioPath;

    private TextView tv_count;
    private TextView tv_folder;
    private LinearLayout ll_folder;
    private ImageView ivDone;
    private ImageView btn_filter;
    private LinearLayout tb_pick;
    private ImageView rl_rec_aud;
    private boolean isPickable = false;

    private Uri takenAudioUri;

    public static Intent getActivityIntent(Context context, boolean isMultiSelection, boolean isRecorder, boolean isFolderList, int count, ArrayList<String> fileTypes) {
        Intent intent = new Intent(context, AudioPickActivity.class);
        intent.putExtra(AudioPickActivity.IS_NEED_RECORDER, isRecorder);
        intent.putExtra(FilePickerConstant.MAX_NUMBER, isMultiSelection ? count : DEFAULT_MAX_NUMBER);
        intent.putExtra(AudioPickActivity.IS_NEED_FOLDER_LIST, isFolderList);
        intent.putExtra(AudioPickActivity.FILETYPES, fileTypes);
        return intent;
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        DataBindingUtil.setContentView(this,R.layout.activity_audio_pick);

        mMaxNumber = getIntent().getIntExtra(FilePickerConstant.MAX_NUMBER, DEFAULT_MAX_NUMBER);
        fileTypes = getIntent().getStringArrayListExtra(FILETYPES);
        isNeedRecorder = getIntent().getBooleanExtra(IS_NEED_RECORDER, false);
        isTakenAutoSelected = getIntent().getBooleanExtra(IS_TAKEN_AUTO_SELECTED, true);
        initView();

        for (String type : fileTypes) {
            if (type.equals(TYPE_MP3.getType()) || type.equals(TYPE_AMPEG.getType()) || type.equals(TYPE_M4A.getType()) || type.equals(TYPE_WAV.getType()) || type.equals(TYPE_AMR.getType()) || type.equals(TYPE_AAC.getType())) {
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

        PermissionsKt.runWithPermissions(AudioPickActivity.this, new String[]{Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE}, new PermissionsOptions(), () -> {
            loadData();
            return null;
        });
    }

    private void initView() {
        tv_count = findViewById(R.id.tv_count);
        tv_count.setText(mCurrentNumber + "/" + mMaxNumber);

        tv_folder = findViewById(R.id.tv_folder);
        tv_folder.setText(getResources().getString(R.string.lbl_all));

        mRecyclerView = findViewById(R.id.rv_audio_pick);
        LinearLayoutManager layoutManager = new LinearLayoutManager(this);
        mRecyclerView.setLayoutManager(layoutManager);
        mRecyclerView.addItemDecoration(new DividerListItemDecoration(this,
                LinearLayoutManager.VERTICAL, R.drawable.vw_divider_rv_file));
        mAdapter = new AudioPickAdapter(this, mMaxNumber);
        mRecyclerView.setAdapter(mAdapter);

        mAdapter.setOnSelectStateListener(new OnSelectStateListener<AudioFile>() {
            @Override
            public void OnSelectStateChanged(boolean state, AudioFile file) {
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
            }
        });

        ivDone = findViewById(R.id.ivDone);
        ivDone.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if (mSelectedList.size() == 0) {
                    Toast.makeText(AudioPickActivity.this, "Please select Audio", Toast.LENGTH_LONG).show();
                    return;
                }
                Intent intent = new Intent();
                intent.putParcelableArrayListExtra(FilePickerConstant.RESULT_PICK_FILE, mSelectedList);
                setResult(RESULT_OK, intent);
                ActivityUtils.finishWithTransition(AudioPickActivity.this);
            }
        });

        tb_pick = findViewById(R.id.tb_pick);
        ll_folder = findViewById(R.id.fabFolder);
        btn_filter = findViewById(R.id.filterBtn);

        setFilterBackground(ll_folder);


        if (isNeedFolderList) {
            btn_filter.setVisibility(View.VISIBLE);
            btn_filter.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    mFolderHelper.toggle(tb_pick);
                }
            });

            mFolderHelper.setFolderListListener(new FolderListAdapter.FolderListListener() {
                @Override
                public void onFolderListClick(Directory directory) {
                    mFolderHelper.toggle(tb_pick);
                    tv_folder.setText(directory.getName());

                    if (TextUtils.isEmpty(directory.getPath())) { //All
                        refreshData(mAll);
                    } else {
                        for (Directory<AudioFile> dir : mAll) {
                            if (dir.getPath().equals(directory.getPath())) {
                                List<Directory<AudioFile>> list = new ArrayList<>();
                                list.add(dir);
                                refreshData(list);
                                break;
                            }
                        }
                    }
                }
            });
        }

        if (isNeedRecorder) {
            rl_rec_aud = findViewById(R.id.iv_rec_aud);
            rl_rec_aud.setVisibility(View.VISIBLE);
            rl_rec_aud.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Intent intent = new Intent(MediaStore.Audio.Media.RECORD_SOUND_ACTION);

                    /*String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.ENGLISH).format(new Date());
                    File file = new File(getFilesDir().getAbsolutePath()
                            + "/Audio_" + timeStamp + ".amr");
                    mAudioPath = file.getAbsolutePath();

                    ContentValues contentValues = new ContentValues(1);
                    contentValues.put(MediaStore.Images.Media.DATA, mAudioPath);
                    takenAudioUri = getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues);

                    intent.putExtra(MediaStore.EXTRA_OUTPUT, takenAudioUri);*/

                    if (Util.detectIntent(AudioPickActivity.this, intent)) {
                        startActivityForResult(intent, FilePickerConstant.REQUEST_CODE_TAKE_AUDIO);
                    } else {
                        ToastUtil.getInstance(AudioPickActivity.this).showToast(getString(R.string.lbl_no_audio_app));
                    }
                }
            });
        }
    }

    private void loadData() {
        FileFilter.getAudios(this, new FilterResultCallback<AudioFile>() {
            @Override
            public void onResult(List<Directory<AudioFile>> directories) {
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
            }
        });
    }

    private void refreshData(List<Directory<AudioFile>> directories) {
        boolean tryToFindTaken = isTakenAutoSelected;

        // if auto-select taken file is enabled, make sure requirements are met
        if (tryToFindTaken && !TextUtils.isEmpty(mAudioPath)) {
            File takenFile = new File(mAudioPath);
            tryToFindTaken = !mAdapter.isUpToMax() && takenFile.exists(); // try to select taken file only if max isn't reached and the file exists
        }

        List<AudioFile> list = new ArrayList<>();
        for (Directory<AudioFile> directory : directories) {
            list.addAll(directory.getFiles());

            // auto-select taken file?
            if (tryToFindTaken) {
                tryToFindTaken = findAndAddTaken(directory.getFiles());   // if taken file was found, we're done
            }
        }

        for (AudioFile file : mSelectedList) {
            int index = list.indexOf(file);
            if (index != -1) {
                list.get(index).setSelected(true);
            }
        }
        mAdapter.refresh(list);
    }

    private boolean findAndAddTaken(List<AudioFile> list) {
        for (AudioFile audioFile : list) {
            if (audioFile.getPath().equals(mAudioPath)) {
                mSelectedList.add(audioFile);
                mCurrentNumber++;
                mAdapter.setCurrentNumber(mCurrentNumber);
                tv_count.setText(mCurrentNumber + "/" + mMaxNumber);

                return true;   // taken file was found and added
            }
        }
        return false;    // taken file wasn't found
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case FilePickerConstant.REQUEST_CODE_TAKE_AUDIO:
                if (resultCode == RESULT_OK) {
                    if (data.getData() != null) {
                        mAudioPath = data.getData().getPath();
                    }
                }

/*                    Intent mediaScanIntent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
                    File file = new File(mAudioPath);
                    Uri contentUri = Uri.fromFile(file);
                    mediaScanIntent.setData(contentUri);
                    sendBroadcast(mediaScanIntent);
                    loadData();
                } else
                    getApplicationContext().getContentResolver().delete(takenAudioUri, null, null);*/
                break;
        }
    }
}
