package com.example.flutter_files_picker.filepicker.ui.activity;

import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;

import androidx.appcompat.app.AppCompatActivity;
import androidx.databinding.DataBindingUtil;

import com.example.flutter_files_picker.R;
import com.example.flutter_files_picker.filepicker.local.ImageCompression;
import com.example.flutter_files_picker.filepicker.local.fragment.BasicFragment;


public class ImageCropActivity extends AppCompatActivity {

    public static final String IMAGE_PATH = "image_path";
    public static final String IMAGE_TYPE = "type";
    public static final String IMAGE_POSITION = "pos";
    private static final String KEY_IMG_INDEX = "img_index";
    public static String cropTypeCircle = "circle";
    public static String cropTypeSquare = "square";
    public static String cropTypeFitSquare = "fitSquare";
    public static Bitmap cropped = null;
    public static int position = -1;
    String path;

    private BasicFragment basicFragment;
    private int mImageIndex = 1;

    public static Intent getActivityIntent(AppCompatActivity activity, String strImagePath, String emptyPath, String imageType, int position, boolean isCompress) {
        if (isCompress && strImagePath != null && strImagePath.length() > 0 && emptyPath != null && emptyPath.length() > 0) {
            String str = ImageCompression.compressImage(strImagePath, emptyPath);
            if (str != null) {
                strImagePath = str;
            }
        }

        Intent intent = new Intent(activity, ImageCropActivity.class);
        intent.putExtra(ImageCropActivity.IMAGE_PATH, strImagePath);
        intent.putExtra(ImageCropActivity.IMAGE_TYPE, imageType != null && imageType.length() > 0 ? imageType : cropTypeSquare);
        intent.putExtra(ImageCropActivity.IMAGE_POSITION, position);
        return intent;
    }

    private void closeActivity() {
        finish();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.show_selected_menu, menu);
        menu.findItem(R.id.showImgRotate).setVisible(true);
        menu.findItem(R.id.showImgDone).setVisible(true);
        menu.findItem(R.id.showImgAttach).setVisible(false);
        menu.findItem(R.id.showImgCrop).setVisible(false);
        menu.findItem(R.id.showImgDelete).setVisible(false);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int i = item.getItemId();
        if (i == android.R.id.home) {
            closeActivity();
            return true;
        } else if (i == R.id.showImgRotate) {
            try {
                basicFragment.rotateImage(true);
            } catch (Exception e) {
                e.printStackTrace();
            }

        } /*else if (i == R.id.icon_uri) {
            try {
                basicFragment.rotateImage(false);
            } catch (Exception e) {
                e.printStackTrace();
            }

        }*/ else if (i == R.id.showImgDone) {
            basicFragment.cropImage();
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onBackPressed() {
        closeActivity();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        DataBindingUtil.setContentView(this,R.layout.activity_crop_image);
        if (savedInstanceState == null) {
            basicFragment = BasicFragment.newInstance();
            Bundle bundle = new Bundle();
            bundle.putString(ImageCropActivity.IMAGE_PATH, getIntent().getStringExtra(ImageCropActivity.IMAGE_PATH));
            bundle.putString(ImageCropActivity.IMAGE_TYPE, getIntent().getStringExtra(ImageCropActivity.IMAGE_TYPE));
            bundle.putInt(ImageCropActivity.IMAGE_POSITION, position);
            basicFragment.setArguments(bundle);
            getSupportFragmentManager().beginTransaction().add(R.id.container, basicFragment).commit();
        }
    }

    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        outState.putInt(KEY_IMG_INDEX, mImageIndex);
    }

    @Override
    public void onRestoreInstanceState(Bundle savedInstanceState) {
        super.onRestoreInstanceState(savedInstanceState);
        mImageIndex = savedInstanceState.getInt(KEY_IMG_INDEX);
    }

    public void setCropResult(String path) {
        Intent data = new Intent();
        String text = "Result to be returned....";
        data.setData(Uri.parse(text));
        data.putExtra("path", path);
        setResult(RESULT_OK, data);
        closeActivity();
    }
}
