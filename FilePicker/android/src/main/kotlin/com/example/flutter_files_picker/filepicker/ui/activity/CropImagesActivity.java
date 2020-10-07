package com.example.flutter_files_picker.filepicker.ui.activity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.databinding.DataBindingUtil;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;
import androidx.viewpager.widget.ViewPager;


import com.example.flutter_files_picker.R;
import com.example.flutter_files_picker.filepicker.local.FilePickerConstant;
import com.example.flutter_files_picker.filepicker.local.Util;
import com.example.flutter_files_picker.filepicker.local.filter.entity.BaseFile;
import com.example.flutter_files_picker.filepicker.local.filter.entity.ImageFile;
import com.example.flutter_files_picker.filepicker.ui.BaseActivity;
import com.example.flutter_files_picker.filepicker.ui.fragment.FragmentImageCrop;
import com.example.flutter_files_picker.filepicker.util.ActivityUtils;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class CropImagesActivity extends BaseActivity {
    public static ArrayList<BaseFile> mSelectedFiles;
    public ArrayList<BaseFile> mDefaultFiles;
    private int mMaxNumber;
    private int mCurrentNumber = 0;
    private int initIndex = 0;
    private TextView tvTitle;
    private TextView ivLeft, ivRight;
    private ImageView tvFinish, tvCancel;
    private ViewPager mViewPager;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        DataBindingUtil.setContentView(this,R.layout.activity_crop_images);
        initIndex = 0;
        mSelectedFiles = getIntent().getParcelableArrayListExtra(FilePickerConstant.RESULT_PICK_FILE);
        mDefaultFiles = mSelectedFiles;
        mMaxNumber = mSelectedFiles.size();
        mCurrentNumber = 1;
        initView();
    }

    private void initView() {
        tvTitle = findViewById(R.id.tvTitle);
        tvTitle.setText(mCurrentNumber + "/" + mMaxNumber);

        tvCancel = findViewById(R.id.tvCancel);
        tvCancel.setOnClickListener(v -> {
            new AlertDialog.Builder(this)
                    .setTitle("Cancel")
                    .setMessage(R.string.msg_cancel_crop)
                    .setPositiveButton("Cancel", (dialog, which) -> {
                        finishThis(false);
                        dialog.dismiss();
                    }).setNegativeButton("Resume", (dialog, which) -> {
                dialog.dismiss();
            }).show();
        });

        tvFinish = findViewById(R.id.tvFinish);
        tvFinish.setOnClickListener(v -> {
            new AlertDialog.Builder(this)
                    .setTitle("Finish")
                    .setMessage(R.string.msg_finish_crop)
                    .setPositiveButton("Finish", (dialog, which) -> {
                        finishThis(true);
                        dialog.dismiss();
                    }).setNegativeButton("Cancel", (dialog, which) -> {
                dialog.dismiss();
            }).show();
        });

        ivLeft = findViewById(R.id.ivLeft);
        ivLeft.setOnClickListener(v -> {
            mViewPager.setCurrentItem(mViewPager.getCurrentItem() - 1, true);
        });

        ivRight = findViewById(R.id.ivRight);
        ivRight.setOnClickListener(v -> {
            mViewPager.setCurrentItem(mViewPager.getCurrentItem() + 1, true);
        });

        ivLeft.setVisibility(mSelectedFiles.size() > 1 ? View.VISIBLE : View.GONE);
        ivRight.setVisibility(mSelectedFiles.size() > 1 ? View.VISIBLE : View.GONE);


        mViewPager = findViewById(R.id.vp_image_pick);
        mViewPager.setPageMargin((int) (getResources().getDisplayMetrics().density * 15));
        mViewPager.setAdapter(new ImageCropperAdapter(getSupportFragmentManager()));
        mViewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                mCurrentNumber = position + 1;
                tvTitle.setText(mCurrentNumber + "/" + mMaxNumber);
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });

        mViewPager.setCurrentItem(initIndex, false);
    }

    private void finishThis(boolean cropped) {
        Intent intent = new Intent();
        if (cropped) {
            intent.putParcelableArrayListExtra(FilePickerConstant.RESULT_CROPPED_FILES, mSelectedFiles);
        } else {
            intent.putParcelableArrayListExtra(FilePickerConstant.RESULT_CROPPED_FILES, mDefaultFiles);
        }
        setResult(RESULT_OK, intent);
        ActivityUtils.finishWithTransition(this);
    }

    @Override
    public void onBackPressed() {
        finishThis(false);
    }


    public class ImageCropperAdapter extends FragmentPagerAdapter {

        List<Fragment> items = new ArrayList<>();

        public ImageCropperAdapter(FragmentManager fragmentManager) {
            super(fragmentManager);
            for (int i = 0; i < mSelectedFiles.size(); i++) {
                if (mSelectedFiles.get(i) instanceof ImageFile) {
//                    File file = new File(Environment.getExternalStorageDirectory().getPath() + "/" + "Cropped");
                    File file = new File(getFilesDir().getAbsolutePath() + "/" + "Cropped");
                    if (!file.exists()) {
                        file.mkdirs();
                    }
                    File emptyFile = new File(file.getPath() + "/" + System.currentTimeMillis() + "_" + Util.extractFileNameWithSuffix(mSelectedFiles.get(i).getPath()));
                    if (!emptyFile.exists()) {
                        try {
                            emptyFile.createNewFile();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                    items.add(FragmentImageCrop.getInstance(i, mSelectedFiles.get(i).getPath(), emptyFile.getPath(), true, getIntent().getStringExtra(FragmentImageCrop.KEY_CROPMODE)));
                    ((FragmentImageCrop) items.get(i)).setCallback(position -> mViewPager.setCurrentItem(position));
                }
            }
        }

        @Override
        public int getCount() {
            return mSelectedFiles.size();
        }

        @Override
        public Fragment getItem(int position) {
            return items.get(position);
        }
    }
}
