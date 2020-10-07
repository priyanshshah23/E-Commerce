package com.example.flutter_files_picker.filepicker.ui.activity;

import android.Manifest;
import android.content.Intent;
import android.database.DatabaseUtils;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;
import androidx.databinding.DataBindingUtil;
import androidx.viewpager.widget.PagerAdapter;
import androidx.viewpager.widget.ViewPager;

import com.bm.library.PhotoView;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.resource.drawable.DrawableTransitionOptions;
import com.example.flutter_files_picker.R;
import com.example.flutter_files_picker.filepicker.local.FilePickerConstant;
import com.example.flutter_files_picker.filepicker.local.ToastUtil;
import com.example.flutter_files_picker.filepicker.local.filter.FileFilter;
import com.example.flutter_files_picker.filepicker.local.filter.entity.Directory;
import com.example.flutter_files_picker.filepicker.local.filter.entity.ImageFile;
import com.example.flutter_files_picker.filepicker.ui.BaseActivity;
import com.example.flutter_files_picker.filepicker.util.ActivityUtils;
import com.example.flutter_files_picker.filepicker.util.permissions.PermissionsKt;
import com.google.android.material.shape.MaterialShapeDrawable;
import com.google.android.material.shape.RoundedCornerTreatment;
import com.google.android.material.shape.ShapePathModel;
import com.example.flutter_files_picker.filepicker.util.permissions.util.PermissionsOptions;

import java.util.ArrayList;

public class ImageBrowserActivity extends BaseActivity {
    public static final String IMAGE_BROWSER_INIT_INDEX = "ImageBrowserInitIndex";
    public static final String IMAGE_BROWSER_SELECTED_LIST = "ImageBrowserSelectedList";
    public static final String IMAGE_BROWSER_DIRECTORY_PATH = "ImageBrowserDirectoryPath";
    private int mMaxNumber;
    private int mCurrentNumber = 0;
    private int initIndex = 0;
    private int mCurrentIndex = 0;
    private TextView tvTitle;

    private ImageView ivBack, ivDone;
    private ViewPager mViewPager;
    private ArrayList<ImageFile> mList = new ArrayList<>();
    private ImageView mSelectView;
    private ArrayList<ImageFile> mSelectedFiles;

    private RelativeLayout bottomBar;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        DataBindingUtil.setContentView(this, R.layout.activity_image_browser);

        mMaxNumber = getIntent().getIntExtra(FilePickerConstant.MAX_NUMBER, DEFAULT_MAX_NUMBER);
        initIndex = getIntent().getIntExtra(IMAGE_BROWSER_INIT_INDEX, 0);
        mCurrentIndex = initIndex;
        mSelectedFiles = getIntent().getParcelableArrayListExtra(IMAGE_BROWSER_SELECTED_LIST);
        mCurrentNumber = mSelectedFiles.size();

        initView();
    }

    private void initView() {
        tvTitle = findViewById(R.id.tvTitle);
        tvTitle.setText(mCurrentNumber + "/" + mMaxNumber);

        ivBack = findViewById(R.id.iv_back);
        ivBack.setOnClickListener(v -> onBackPressed());

        ivDone = findViewById(R.id.ivDone);
        ivDone.setOnClickListener(v -> finishThis());

        mSelectView = findViewById(R.id.cbx);

        mSelectView.setOnClickListener(v -> {
            if (!v.isSelected() && isUpToMax()) {
                ToastUtil.getInstance(ImageBrowserActivity.this).showToast(R.string.lbl_up_to_max);
                return;
            }

            if (v.isSelected()) {
                mList.get(mCurrentIndex).setSelected(false);
                mCurrentNumber--;
                v.setSelected(false);
                mSelectedFiles.remove(mList.get(mCurrentIndex));
            } else {
                mList.get(mCurrentIndex).setSelected(true);
                mCurrentNumber++;
                v.setSelected(true);
                mSelectedFiles.add(mList.get(mCurrentIndex));
            }

            tvTitle.setText(mCurrentNumber + "/" + mMaxNumber);
        });

        mViewPager = findViewById(R.id.vp_image_pick);
        mViewPager.setPageMargin((int) (getResources().getDisplayMetrics().density * 15));
        mViewPager.setAdapter(new ImageBrowserAdapter());

        PermissionsKt.runWithPermissions(ImageBrowserActivity.this, new String[]{Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE}, new PermissionsOptions(), () -> {
            loadData();
            return null;
        });


        bottomBar = findViewById(R.id.layout_bottom_bar);
        ShapePathModel shapePathModel = new ShapePathModel();
        shapePathModel.setTopLeftCorner(new RoundedCornerTreatment(getResources().getDimensionPixelSize(R.dimen._20px)));

        MaterialShapeDrawable shapeDrawable = new MaterialShapeDrawable(shapePathModel);
        shapeDrawable.setShadowElevation(20);
        shapeDrawable.setShadowEnabled(true);
        shapeDrawable.setTint(ContextCompat.getColor(this, R.color.colorPrimary));
        bottomBar.setBackground(shapeDrawable);

    }

    private void loadData() {
        FileFilter.getImages(this, directories -> {
            String selectedDirectory = getIntent().getStringExtra(IMAGE_BROWSER_DIRECTORY_PATH);

            mList.clear();
            for (Directory<ImageFile> directory : directories) {
                if (TextUtils.isEmpty(selectedDirectory)) {
                    mList.addAll(directory.getFiles());
                } else if (directory.getPath().equals(selectedDirectory)) {
                    mList.addAll(directory.getFiles());
                }

            }
            for (ImageFile file : mList) {
                if (mSelectedFiles.contains(file)) {
                    file.setSelected(true);
                }
            }

            mViewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
                @Override
                public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

                }

                @Override
                public void onPageSelected(int position) {
                    mCurrentIndex = position;
                    mSelectView.setSelected(mList.get(mCurrentIndex).isSelected());
                }

                @Override
                public void onPageScrollStateChanged(int state) {

                }
            });
            mViewPager.getAdapter().notifyDataSetChanged();
            mViewPager.setCurrentItem(initIndex, false);
            mSelectView.setSelected(mList.get(mCurrentIndex).isSelected());
        });
    }

    private boolean isUpToMax() {
        return mCurrentNumber >= mMaxNumber;
    }

    private void finishThis() {
        Intent intent = new Intent();
        intent.putParcelableArrayListExtra(FilePickerConstant.RESULT_BROWSER_IMAGE, mSelectedFiles);
        setResult(RESULT_OK, intent);
        ActivityUtils.finishWithTransition(this);
    }

    @Override
    public void onBackPressed() {
        Intent intent = new Intent();
        intent.putParcelableArrayListExtra(FilePickerConstant.RESULT_BROWSER_IMAGE, new ArrayList<>());
        setResult(RESULT_CANCELED, intent);
        ActivityUtils.finishWithTransition(this);
    }

    private class ImageBrowserAdapter extends PagerAdapter {
        @Override
        public Object instantiateItem(ViewGroup container, int position) {
            PhotoView view = new PhotoView(ImageBrowserActivity.this);
            view.enable();
            view.setScaleType(ImageView.ScaleType.CENTER_INSIDE);

            Glide.with(ImageBrowserActivity.this)
                    .load(mList.get(position).getPath())
                    .transition(DrawableTransitionOptions.withCrossFade())
                    .into(view);
            container.addView(view);
            return view;
        }

        @Override
        public void destroyItem(ViewGroup container, int position, Object object) {
            container.removeView((View) object);
        }

        @Override
        public int getCount() {
            return mList.size();
        }

        @Override
        public boolean isViewFromObject(View view, Object object) {
            return view == object;
        }
    }
}
