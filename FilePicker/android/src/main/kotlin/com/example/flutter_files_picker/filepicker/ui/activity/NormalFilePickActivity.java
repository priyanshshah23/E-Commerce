package com.example.flutter_files_picker.filepicker.ui.activity;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
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
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.flutter_files_picker.R;
import com.example.flutter_files_picker.filepicker.local.DividerListItemDecoration;
import com.example.flutter_files_picker.filepicker.local.FilePickerConstant;
import com.example.flutter_files_picker.filepicker.local.adapter.NormalFilePickAdapter;
import com.example.flutter_files_picker.filepicker.local.filter.FileFilter;
import com.example.flutter_files_picker.filepicker.local.filter.entity.Directory;
import com.example.flutter_files_picker.filepicker.local.filter.entity.NormalFile;
import com.example.flutter_files_picker.filepicker.ui.BaseActivity;
import com.example.flutter_files_picker.filepicker.ui.Picker;
import com.example.flutter_files_picker.filepicker.util.ActivityUtils;
import com.example.flutter_files_picker.filepicker.util.permissions.PermissionsKt;
import com.example.flutter_files_picker.filepicker.util.permissions.util.PermissionsOptions;

import java.util.ArrayList;
import java.util.List;

import static com.example.flutter_files_picker.filepicker.ui.Picker.FileType.*;


/**
 * Created by Vincent Woo
 * Date: 2016/10/26
 * Time: 10:14
 */

public class NormalFilePickActivity extends BaseActivity {
    public static final String SUFFIX = "Suffix";
    public int mCurrentNumber = 0;
    public ArrayList<NormalFile> mSelectedList = new ArrayList<>();
    private int mMaxNumber;
    private RecyclerView mRecyclerView;
    private NormalFilePickAdapter mAdapter;
    private List<Directory<NormalFile>> mAll;
    private ProgressBar mProgressBar;
    private ArrayList<String> mSuffix = new ArrayList<>();
    private String[] extensions;


    private TextView tv_count;
    private TextView tv_folder;
    private LinearLayout ll_folder;
    private ImageView btn_filter;
    private ImageView ivDone;
    private LinearLayout tb_pick;

    public static Intent getActivityIntent(Context context, boolean isMultiSelection, boolean isFolderList, int count, ArrayList<String> filetypes) {
        Intent intent = new Intent(context, NormalFilePickActivity.class);
        intent.putExtra(FilePickerConstant.MAX_NUMBER, isMultiSelection ? count : DEFAULT_MAX_NUMBER);
        intent.putExtra(NormalFilePickActivity.IS_NEED_FOLDER_LIST, isFolderList);
        intent.putExtra(NormalFilePickActivity.SUFFIX, filetypes);
        return intent;
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        DataBindingUtil.setContentView(this,R.layout.activity_file_pick);
        mMaxNumber = getIntent().getIntExtra(FilePickerConstant.MAX_NUMBER, DEFAULT_MAX_NUMBER);
        mSuffix = getIntent().getStringArrayListExtra(SUFFIX);

        if (mSuffix == null || mSuffix.size() == 0) {
            mSuffix = new ArrayList<>();
            mSuffix.add(TYPE_DOC.getType());
            mSuffix.add(TYPE_DOCX.getType());
            mSuffix.add(TYPE_TEXT.getType());
            mSuffix.add(TYPE_PDF.getType());
            mSuffix.add(TYPE_XLS.getType());
            mSuffix.add(TYPE_XLSX.getType());
            mSuffix.add(TYPE_PPT.getType());
            mSuffix.add(TYPE_PPTX.getType());
        }

        extensions = new String[mSuffix.size()];
        for (int i = 0; i < mSuffix.size(); i++) {
            switch (Picker.FileType.getFromMime(mSuffix.get(i))) {
                case TYPE_DOC:
                    extensions[i] = "doc";
                    break;

                case TYPE_DOCX:
                    extensions[i] = "docx";
                    break;

                case TYPE_TEXT:
                    extensions[i] = "txt";
                    break;

                case TYPE_PDF:
                    extensions[i] = "pdf";
                    break;

                case TYPE_XLS:
                    extensions[i] = "xls";
                    break;

                case TYPE_XLSX:
                    extensions[i] = "xlsx";
                    break;

                case TYPE_PPT:
                    extensions[i] = "ppt";
                    break;

                case TYPE_PPTX:
                    extensions[i] = "pptx";
                    break;
            }
        }

        initView();

        extensions = removeNullElements(extensions);
        if (extensions.length == 0) {
            Toast.makeText(this, "No suitable files found.", Toast.LENGTH_SHORT).show();
            Intent intent = new Intent();
            setResult(RESULT_CANCELED, intent);
            ActivityUtils.finishWithTransition(this);
        }

        PermissionsKt.runWithPermissions(NormalFilePickActivity.this, new String[]{Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE}, new PermissionsOptions(), () -> {
            loadData();
            return null;
        });
    }

    public String[] removeNullElements(String[] extensions) {
        List<String> list = new ArrayList<String>();
        for (String s : extensions) {
            if (s != null && s.length() > 0) {
                list.add(s);
            }
        }
        return list.toArray(new String[list.size()]);
    }

    private void initView() {
        tv_count = findViewById(R.id.tv_count);
        tv_count.setText(mCurrentNumber + "/" + mMaxNumber);

        tv_folder = findViewById(R.id.tv_folder);
        tv_folder.setText(getResources().getString(R.string.lbl_all));


        mRecyclerView = findViewById(R.id.rv_file_pick);
        LinearLayoutManager layoutManager = new LinearLayoutManager(this);
        mRecyclerView.setLayoutManager(layoutManager);
        mRecyclerView.addItemDecoration(new DividerListItemDecoration(this, LinearLayoutManager.VERTICAL, R.drawable.vw_divider_rv_file));
        mAdapter = new NormalFilePickAdapter(this, mMaxNumber);
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

        mProgressBar = findViewById(R.id.pb_file_pick);

        ivDone = findViewById(R.id.ivDone);
        ivDone.setOnClickListener(v -> {
            if (mSelectedList.size() == 0) {
                Toast.makeText(this, "Please select File", Toast.LENGTH_LONG).show();
                return;
            }
            Intent intent = new Intent();
            intent.putParcelableArrayListExtra(FilePickerConstant.RESULT_PICK_FILE, mSelectedList);
            setResult(RESULT_OK, intent);
            ActivityUtils.finishWithTransition(this);
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
                    for (Directory<NormalFile> dir : mAll) {
                        if (dir.getPath().equals(directory.getPath())) {
                            List<Directory<NormalFile>> list = new ArrayList<>();
                            list.add(dir);
                            refreshData(list);
                            break;
                        }
                    }
                }
            });
        }
    }

    private void loadData() {
        FileFilter.getFiles(this, directories -> {
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
        }, extensions);
    }

    private void refreshData(List<Directory<NormalFile>> directories) {
        mProgressBar.setVisibility(View.GONE);
        List<NormalFile> list = new ArrayList<>();
        for (Directory<NormalFile> directory : directories) {
            list.addAll(directory.getFiles());
        }

        for (NormalFile file : mSelectedList) {
            int index = list.indexOf(file);
            if (index != -1) {
                list.get(index).setSelected(true);
            }
        }

        mAdapter.refresh(list);
    }
}
