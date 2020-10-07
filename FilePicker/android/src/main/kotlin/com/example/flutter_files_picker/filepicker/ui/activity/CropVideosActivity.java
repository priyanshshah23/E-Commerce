package com.example.flutter_files_picker.filepicker.ui.activity;

import android.content.Intent;
import android.os.Bundle;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.databinding.DataBindingUtil;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;
import androidx.viewpager.widget.ViewPager;

import com.example.flutter_files_picker.R;
import com.example.flutter_files_picker.filepicker.local.FilePickerConstant;
import com.example.flutter_files_picker.filepicker.local.filter.entity.BaseFile;
import com.example.flutter_files_picker.filepicker.ui.BaseActivity;
import com.example.flutter_files_picker.filepicker.ui.fragment.FragmentVideoTrim;
import com.example.flutter_files_picker.filepicker.util.ActivityUtils;
import com.example.flutter_files_picker.filepicker.util.CustomViewPager;

import java.util.ArrayList;

public class CropVideosActivity extends BaseActivity {
    public static ArrayList<BaseFile> mSelectedVideos;
    public ArrayList<BaseFile> mDefaultFiles;
    private int mMaxNumber;
    private int mCurrentNumber = 0;
    private int initIndex = 0;
    private TextView tvTitle;
    private TextView ivLeft, ivRight;
    private ImageView tvFinish, tvCancel;
    private CustomViewPager mViewPager;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        DataBindingUtil.setContentView(this,R.layout.activity_crop_videos);
        initIndex = 0;
        mSelectedVideos = getIntent().getParcelableArrayListExtra(FilePickerConstant.RESULT_PICK_FILE);
        mDefaultFiles = mSelectedVideos;
        mMaxNumber = mSelectedVideos.size();
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

        mViewPager = findViewById(R.id.vp_image_pick);
        mViewPager.setPagingEnabled(false);
        mViewPager.setPageMargin((int) (getResources().getDisplayMetrics().density * 15));
        mViewPager.setAdapter(new VideoCropperAdapter(getSupportFragmentManager()));

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
            intent.putParcelableArrayListExtra(FilePickerConstant.RESULT_CROPPED_FILES, mSelectedVideos);
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


    public class VideoCropperAdapter extends FragmentPagerAdapter {

        public VideoCropperAdapter(FragmentManager fragmentManager) {
            super(fragmentManager);
        }

        @Override
        public int getCount() {
            return mSelectedVideos.size();
        }

        @Override
        public Fragment getItem(int position) {
            FragmentVideoTrim instance = FragmentVideoTrim.getInstance(position, mSelectedVideos.get(position).getPath());
            instance.setVideoCroppedCallback(pos -> {
                notifyDataSetChanged();
            });
            return instance;
        }

        @Override
        public int getItemPosition(@NonNull Object object) {
            return POSITION_NONE;
        }
    }
}
