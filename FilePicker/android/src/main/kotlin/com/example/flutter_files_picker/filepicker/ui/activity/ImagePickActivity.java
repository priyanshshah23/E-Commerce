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
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.databinding.DataBindingUtil;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.flutter_files_picker.R;
import com.example.flutter_files_picker.databinding.ActivityImagePickBinding;
import com.example.flutter_files_picker.filepicker.local.DividerGridItemDecoration;
import com.example.flutter_files_picker.filepicker.local.FilePickerConstant;
import com.example.flutter_files_picker.filepicker.local.adapter.ImagePickAdapter;
import com.example.flutter_files_picker.filepicker.local.filter.FileFilter;
import com.example.flutter_files_picker.filepicker.local.filter.entity.Directory;
import com.example.flutter_files_picker.filepicker.local.filter.entity.ImageFile;
import com.example.flutter_files_picker.filepicker.ui.BaseActivity;
import com.example.flutter_files_picker.filepicker.ui.Picker;
import com.example.flutter_files_picker.filepicker.util.ActivityUtils;
import com.example.flutter_files_picker.filepicker.util.permissions.PermissionsKt;
import com.example.flutter_files_picker.filepicker.util.permissions.util.PermissionsOptions;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import static com.example.flutter_files_picker.filepicker.ui.Picker.FileType.TYPE_BMP;
import static com.example.flutter_files_picker.filepicker.ui.Picker.FileType.TYPE_JPEG;
import static com.example.flutter_files_picker.filepicker.ui.Picker.FileType.TYPE_PNG;
import static com.example.flutter_files_picker.filepicker.ui.Picker.FileType.TYPE_WEBP;


public class ImagePickActivity extends BaseActivity {
    public static final String IS_NEED_CAMERA = "IsNeedCamera";
    public static final String IS_ALLOW_CROP = "IsAllowCrop";
    public static final String IS_NEED_IMAGE_PAGER = "IsNeedImagePager";
    public static final String IS_TAKEN_AUTO_SELECTED = "IsTakenAutoSelected";

    public static final int COLUMN_NUMBER = 3;
    public static final String FILETYPES = "FileTypes";
    public ArrayList<ImageFile> mSelectedList = new ArrayList<>();
    public int mCurrentNumber = 0;
    private int mMaxNumber;
    private RecyclerView mRecyclerView;
    private ImagePickAdapter mAdapter;
    private boolean isAllowCrop;
    private boolean isNeedCamera;
    private boolean isNeedImagePager;
    private boolean isTakenAutoSelected;
    private List<Directory<ImageFile>> mAll;
    private TextView tv_count;
    private TextView tv_folder;
    private LinearLayout ll_folder;
    private ImageView ivDone;
    private LinearLayout tb_pick;
    private ArrayList<String> fileTypes = new ArrayList<>();
    private boolean isPickable = false;
    private ImageView btn_filter;

    public static Intent getActivityIntent(Context context, boolean isMultiSelection, boolean isCamera, boolean isFolderList, boolean allowCrop, int maxImage, ArrayList<String> fileTypes) {
        Intent intent = new Intent(context, ImagePickActivity.class);
        intent.putExtra(ImagePickActivity.IS_NEED_CAMERA, isCamera);
        intent.putExtra(FilePickerConstant.MAX_NUMBER, isMultiSelection ? maxImage : 1);
        intent.putExtra(ImagePickActivity.IS_NEED_FOLDER_LIST, isFolderList);
        intent.putExtra(AudioPickActivity.FILETYPES, fileTypes);
        intent.putExtra(ImagePickActivity.IS_ALLOW_CROP, allowCrop);
        return intent;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        DataBindingUtil.setContentView(this, R.layout.activity_image_pick);

        mMaxNumber = getIntent().getIntExtra(FilePickerConstant.MAX_NUMBER, DEFAULT_MAX_NUMBER);
        isAllowCrop = getIntent().getBooleanExtra(IS_ALLOW_CROP, false);
        isNeedCamera = getIntent().getBooleanExtra(IS_NEED_CAMERA, false);
        fileTypes = getIntent().getStringArrayListExtra(FILETYPES);
        isNeedImagePager = getIntent().getBooleanExtra(IS_NEED_IMAGE_PAGER, true);
        isTakenAutoSelected = getIntent().getBooleanExtra(IS_TAKEN_AUTO_SELECTED, true);
        initView();

        for (String type : fileTypes) {
            if (type.equals(Picker.FileType.TYPE_JPG.getType()) || type.equals(TYPE_JPEG.getType()) || type.equals(TYPE_PNG.getType()) || type.equals(TYPE_BMP.getType()) || type.equals(TYPE_WEBP.getType())) {
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

        PermissionsKt.runWithPermissions(ImagePickActivity.this, new String[]{Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE}, new PermissionsOptions(), () -> {
            loadData();
            return null;
        });
    }

    private void initView() {
        tv_count = findViewById(R.id.tv_count);
        tv_count.setText(mCurrentNumber + "/" + mMaxNumber);

        mRecyclerView = findViewById(R.id.rv_image_pick);
        final GridLayoutManager layoutManager = new GridLayoutManager(this, COLUMN_NUMBER);
        mRecyclerView.setLayoutManager(layoutManager);
        mRecyclerView.addItemDecoration(new DividerGridItemDecoration(this));
        mAdapter = new ImagePickAdapter(this, isNeedCamera, isNeedImagePager, mMaxNumber);
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

        ivDone = findViewById(R.id.ivDone);
        ivDone.setOnClickListener(v -> {
            if (mSelectedList.size() == 0) {
                Toast.makeText(this, "Please select Image", Toast.LENGTH_LONG).show();
                return;
            }
            if (isAllowCrop) {
                Intent intent = new Intent(this, CropImagesActivity.class);
                intent.putParcelableArrayListExtra(FilePickerConstant.RESULT_PICK_FILE, mSelectedList);
                ActivityUtils.startWithTransition(this, intent, FilePickerConstant.REQUEST_CODE_CROP_FILES);
            } else {
                Intent intent = new Intent();
                intent.putParcelableArrayListExtra(FilePickerConstant.RESULT_PICK_FILE, mSelectedList);
                setResult(RESULT_OK, intent);
                ActivityUtils.finishWithTransition(this);
            }
        });
        ivDone.setVisibility(View.INVISIBLE);

        tb_pick = findViewById(R.id.tb_pick);

        tv_folder = findViewById(R.id.tv_folder);
        tv_folder.setText(getResources().getString(R.string.lbl_all));

        ll_folder = findViewById(R.id.fabFolder);
        btn_filter = findViewById(R.id.filterBtn);
        ll_folder.setVisibility(View.GONE);

        setFilterBackground(ll_folder);

        if (isNeedFolderList) {
            btn_filter.setVisibility(View.VISIBLE);
            btn_filter.setOnClickListener(v -> mFolderHelper.toggle(tb_pick));

            mFolderHelper.setFolderListListener(directory -> {
                mFolderHelper.toggle(tb_pick);
                tv_folder.setText(directory.getName());
                mAdapter.setDirectotyPath(directory.getPath());
                if (TextUtils.isEmpty(directory.getPath())) { //All
                    refreshData(mAll);
                } else {
                    for (Directory<ImageFile> dir : mAll) {
                        if (dir.getPath().equals(directory.getPath())) {
                            List<Directory<ImageFile>> list = new ArrayList<>();
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
            case FilePickerConstant.REQUEST_CODE_TAKE_IMAGE:
                if (resultCode == RESULT_OK) {
                    Intent mediaScanIntent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
                    // File file = new File(mAdapter.mImagePath);
                    // Uri contentUri = Uri.fromFile(file);
                    // mediaScanIntent.setData(contentUri);
                   /* mediaScanIntent.setData(mAdapter.mImageUri);
                    sendBroadcast(mediaScanIntent);
                    loadData();*/
                    ImageFile imageFile = new ImageFile();
                    imageFile.setPath(mAdapter.mImagePath);
                    ArrayList<ImageFile> imageFiles = new ArrayList<>();
                    imageFiles.add(imageFile);
                    Intent intent = new Intent();
                    intent.putParcelableArrayListExtra(FilePickerConstant.RESULT_PICK_FILE, imageFiles);
                    setResult(RESULT_OK, intent);
                    ActivityUtils.finishWithTransition(this);


                } else {
                    //Delete the record in Media DB, when user select "Cancel" during take picture
                    getApplicationContext().getContentResolver().delete(mAdapter.mImageUri, null, null);
                }
                break;
            case FilePickerConstant.REQUEST_CODE_BROWSER_IMAGE:
                if (resultCode == RESULT_OK) {
                    ArrayList<ImageFile> list = data.getParcelableArrayListExtra(FilePickerConstant.RESULT_BROWSER_IMAGE);
                    mCurrentNumber = list.size();
                    mAdapter.setCurrentNumber(mCurrentNumber);
                    tv_count.setText(mCurrentNumber + "/" + mMaxNumber);
                    mSelectedList.clear();
                    mSelectedList.addAll(list);

                    for (ImageFile file : mAdapter.getDataSet()) {
                        if (mSelectedList.contains(file)) {
                            file.setSelected(true);
                        } else {
                            file.setSelected(false);
                        }
                    }
                    mAdapter.notifyDataSetChanged();
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
        try {
            FileFilter.getImages(this, directories -> {
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
                if (TextUtils.isEmpty(mAdapter.getDirectotyPath())) { //All
                    refreshData(mAll);
                } else {
                    for (Directory<ImageFile> dir : mAll) {
                        if (dir.getPath().equals(mAdapter.getDirectotyPath())) {
                            List<Directory<ImageFile>> list = new ArrayList<>();
                            list.add(dir);
                            refreshData(list);
                            break;
                        }
                    }
                }
                //refreshData(directories);
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void refreshData(List<Directory<ImageFile>> directories) {
        boolean tryToFindTakenImage = isTakenAutoSelected;

        // if auto-select taken image is enabled, make sure requirements are met
        if (tryToFindTakenImage && !TextUtils.isEmpty(mAdapter.mImagePath)) {
            File takenImageFile = new File(mAdapter.mImagePath);
            tryToFindTakenImage = !mAdapter.isUpToMax() && takenImageFile.exists(); // try to select taken image only if max isn't reached and the file exists
        }

        List<ImageFile> list = new ArrayList<>();
        for (Directory<ImageFile> directory : directories) {
            list.addAll(directory.getFiles());

            // auto-select taken images?
            if (tryToFindTakenImage) {
                findAndAddTakenImage(directory.getFiles());   // if taken image was found, we're done
            }
        }

        for (ImageFile file : mSelectedList) {
            int index = list.indexOf(file);
            if (index != -1) {
                list.get(index).setSelected(true);
            }
        }
        mAdapter.refresh(list);
    }

    private boolean findAndAddTakenImage(List<ImageFile> list) {
        for (ImageFile imageFile : list) {

            if (imageFile.getPath().equals(mAdapter.mImagePath)) {
                if (!mSelectedList.contains(imageFile)) {
                    mSelectedList.add(imageFile);
                    mCurrentNumber++;
                    mAdapter.setCurrentNumber(mCurrentNumber);
                    tv_count.setText(mCurrentNumber + "/" + mMaxNumber);
                }
                return true;   // taken image was found and added
            }
        }
        return false;    // taken image wasn't found
    }

    private void refreshSelectedList(List<ImageFile> list) {
        for (ImageFile file : list) {
            if (file.isSelected() && !mSelectedList.contains(file)) {
                mSelectedList.add(file);
            }
        }
    }
}
