package com.example.flutter_files_picker.filepicker.ui;

import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;

import com.example.flutter_files_picker.FlutterFilePickerPlugin;
import com.example.flutter_files_picker.R;
import com.example.flutter_files_picker.filepicker.local.FolderListHelper;
import com.example.flutter_files_picker.filepicker.util.ActivityUtils;
import com.google.android.material.shape.MaterialShapeDrawable;
import com.google.android.material.shape.RoundedCornerTreatment;
import com.google.android.material.shape.ShapePathModel;

/**
 * Created by Vincent Woo
 * Date: 2016/10/12
 * Time: 16:21
 */

public abstract class BaseActivity extends AppCompatActivity {
    public static final String IS_NEED_FOLDER_LIST = "isNeedFolderList";
    public static final int DEFAULT_MAX_NUMBER = 1;
    private static final int RC_READ_EXTERNAL_STORAGE = 123;
    private static final int RC_CAMERA_PERMISSION = 124;
    private static final String TAG = BaseActivity.class.getName();
    protected FolderListHelper mFolderHelper;
    protected boolean isNeedFolderList;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        isNeedFolderList = getIntent().getBooleanExtra(IS_NEED_FOLDER_LIST, false);

        if (isNeedFolderList) {
            mFolderHelper = new FolderListHelper();
            mFolderHelper.initFolderListView(this);
        }
    }

    @Override
    protected void onStart() {
        super.onStart();
        View filterBtn = findViewById(R.id.filterBtn);
        if (filterBtn != null)
            filterBtn.setVisibility(isNeedFolderList ? View.VISIBLE : View.GONE);
    }

    public void onBackClick(View view) {
        ActivityUtils.finishWithTransition(this);
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        ActivityUtils.finishWithTransition(this);
    }

    public void setFilterBackground(LinearLayout linearLayout) {

        ShapePathModel shapePathModel = new ShapePathModel();
        shapePathModel.setTopLeftCorner(new RoundedCornerTreatment(getResources().getDimensionPixelSize(R.dimen._10px)));

        MaterialShapeDrawable shapeDrawable = new MaterialShapeDrawable(shapePathModel);
        shapeDrawable.setShadowElevation(20);
        shapeDrawable.setShadowEnabled(true);
        shapeDrawable.setTint(FlutterFilePickerPlugin.Companion.getTHEME_COLOR());
        linearLayout.setBackground(shapeDrawable);
    }
}
