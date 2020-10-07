package com.example.flutter_files_picker.filepicker.ui.fragment;

import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;
import androidx.databinding.DataBindingUtil;

import com.example.flutter_files_picker.R;
import com.example.flutter_files_picker.filepicker.local.ImageCompression;
import com.example.flutter_files_picker.filepicker.local.fragment.ImageCropperBase;
import com.google.android.material.shape.MaterialShapeDrawable;
import com.google.android.material.shape.RoundedCornerTreatment;
import com.google.android.material.shape.ShapePathModel;
import com.isseiaoki.simplecropview.CropImageView;


import java.io.File;


public class FragmentImageCrop extends ImageCropperBase {

    public static final String IMAGE_PATH = "image_path";
    public static final String KEY_CROPMODE = "crop_mode";//string cropmode
    private static final String KEY_IMG_INDEX = "img_index";
    private LinearLayout tabBar;

    public static FragmentImageCrop getInstance(int position, String strImagePath, String emptyPath, boolean isCompress, String cropMode) {
        if (isCompress && strImagePath != null && strImagePath.length() > 0 && emptyPath != null && emptyPath.length() > 0) {
            String str = ImageCompression.compressImage(strImagePath, emptyPath);
            if (str != null) {
                strImagePath = str;
            }
        }

        FragmentImageCrop instance = new FragmentImageCrop();
        Bundle bundle = new Bundle();
        bundle.putString(FragmentImageCrop.IMAGE_PATH, strImagePath);
        bundle.putInt(FragmentImageCrop.KEY_IMG_INDEX, position);
        bundle.putString(FragmentImageCrop.KEY_CROPMODE, cropMode);
        instance.setArguments(bundle);
        return instance;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        DataBindingUtil.bind(view);
        mCropView = view.findViewById(R.id.cropImageView);
        btnRotateLeft = view.findViewById(R.id.buttonRotateLeft);
        btnRotateRight = view.findViewById(R.id.buttonRotateRight);
        btnSave = view.findViewById(R.id.buttonSave);
        btnSquare = view.findViewById(R.id.buttonSquare);
        btnFree = view.findViewById(R.id.buttonFree);
        tabBar = view.findViewById(R.id.tab_bar);

        btnRotateLeft.setOnClickListener(v -> {
            mCropView.rotateImage(CropImageView.RotateDegrees.ROTATE_M90D, 500);
        });

        btnRotateRight.setOnClickListener(v -> {
            mCropView.rotateImage(CropImageView.RotateDegrees.ROTATE_90D, 500);
        });

        btnSquare.setOnClickListener(v -> {
            mCropView.setCropMode(CropImageView.CropMode.SQUARE);
        });

        btnFree.setOnClickListener(v -> {
            mCropView.setCropMode(CropImageView.CropMode.FREE);
        });

        btnSave.setOnClickListener(v -> {
            cropImage();
        });

        if (getArguments() != null) {
            mSourceUrii = Uri.fromFile(new File(getArguments().getString(IMAGE_PATH)));
            position = getArguments().getInt(KEY_IMG_INDEX);
            mCropView.setDebug(false);
            mCropView.setCropMode(CropImageView.CropMode.valueOf(getArguments().getString(KEY_CROPMODE, CropImageView.CropMode.FREE.name())));
            mCropView.load(mSourceUrii)
                    .initialFrameRect(mFrameRect)
                    .useThumbnail(true)
                    .execute(mLoadCallback);
        } else {
            getActivity().finish();
            Toast.makeText(getContext(), "No Image Found.", Toast.LENGTH_SHORT).show();
        }


        ShapePathModel shapePathModel = new ShapePathModel();
        shapePathModel.setTopLeftCorner(new RoundedCornerTreatment(getResources().getDimensionPixelSize(R.dimen._16px)));
        shapePathModel.setTopRightCorner(new RoundedCornerTreatment(getResources().getDimensionPixelSize(R.dimen._16px)));


        MaterialShapeDrawable shapeDrawable = new MaterialShapeDrawable(shapePathModel);
        shapeDrawable.setShadowEnabled(true);
        shapeDrawable.setShadowElevation(10);
        shapeDrawable.setTint(ContextCompat.getColor(getContext(), R.color.colorPrimary));
        tabBar.setBackground(shapeDrawable);
    }

    public void setCallback(CropCallback callback) {
        this.callback = callback;
    }

    public interface CropCallback {
        void OnCropPressed(int position);
    }
}
