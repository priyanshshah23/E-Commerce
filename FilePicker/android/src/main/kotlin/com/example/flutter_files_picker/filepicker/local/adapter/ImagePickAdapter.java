package com.example.flutter_files_picker.filepicker.local.adapter;

import android.Manifest;
import android.app.Activity;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.ImageView;

import androidx.appcompat.app.AppCompatActivity;
import androidx.databinding.DataBindingUtil;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.request.RequestOptions;
import com.example.flutter_files_picker.R;
import com.example.flutter_files_picker.filepicker.local.FilePickerConstant;
import com.example.flutter_files_picker.filepicker.local.ToastUtil;
import com.example.flutter_files_picker.filepicker.local.Util;
import com.example.flutter_files_picker.filepicker.local.filter.entity.ImageFile;
import com.example.flutter_files_picker.filepicker.ui.activity.ImageBrowserActivity;
import com.example.flutter_files_picker.filepicker.ui.activity.ImagePickActivity;
import com.example.flutter_files_picker.filepicker.util.ActivityUtils;
import com.example.flutter_files_picker.filepicker.util.permissions.PermissionsKt;
import com.example.flutter_files_picker.filepicker.util.permissions.util.PermissionsOptions;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;

import static android.app.Activity.RESULT_OK;
import static android.os.Environment.DIRECTORY_DCIM;
import static com.bumptech.glide.load.resource.drawable.DrawableTransitionOptions.withCrossFade;
import static com.example.flutter_files_picker.filepicker.ui.activity.ImageBrowserActivity.IMAGE_BROWSER_INIT_INDEX;
import static com.example.flutter_files_picker.filepicker.ui.activity.ImageBrowserActivity.IMAGE_BROWSER_SELECTED_LIST;


/**
 * Created by Vincent Woo
 * Date: 2016/10/13
 * Time: 16:07
 */

public class ImagePickAdapter extends BaseAdapter<ImageFile, ImagePickAdapter.ImagePickViewHolder> {
    public String mImagePath;
    public Uri mImageUri;
    private boolean isNeedImagePager;
    private boolean isNeedCamera;
    private int mMaxNumber;
    private int mCurrentNumber = 0;
    private Context context;
    private String directotyPath;

    public ImagePickAdapter(Context ctx, boolean needCamera, boolean isNeedImagePager, int max) {
        this(ctx, new ArrayList<ImageFile>(), needCamera, isNeedImagePager, max);
    }

    public ImagePickAdapter(Context ctx, ArrayList<ImageFile> list, boolean needCamera, boolean needImagePager, int max) {
        super(ctx, list);
        isNeedCamera = needCamera;
        mMaxNumber = max;
        isNeedImagePager = needImagePager;
        this.context = ctx;
    }

    public String getDirectotyPath() {
        return directotyPath;
    }

    public void setDirectotyPath(String directotyPath) {
        this.directotyPath = directotyPath;
    }

    @Override
    public ImagePickViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(mContext).inflate(R.layout.layout_item_image_pick, parent, false);
        ViewGroup.LayoutParams params = itemView.getLayoutParams();
        if (params != null) {
            WindowManager wm = (WindowManager) mContext.getSystemService(Context.WINDOW_SERVICE);
            int width = wm.getDefaultDisplay().getWidth();
            params.height = width / ImagePickActivity.COLUMN_NUMBER;
        }
        return new ImagePickViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(final ImagePickViewHolder holder, int position) {
        if (isNeedCamera && position == 0) {
            holder.mIvCamera.setVisibility(View.VISIBLE);
            holder.mIvThumbnail.setVisibility(View.INVISIBLE);
            holder.mCbx.setVisibility(View.INVISIBLE);
            holder.mShadow.setVisibility(View.INVISIBLE);
            holder.itemView.setOnClickListener(v -> {
                PermissionsKt.runWithPermissions(context, new String[]{Manifest.permission.CAMERA}, new PermissionsOptions(), () -> {
                    Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
                    String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.ENGLISH).format(new Date());
                    File file = new File(Environment.getExternalStoragePublicDirectory(DIRECTORY_DCIM).getAbsolutePath()
                            + "/IMG_" + timeStamp + ".jpg");
                    mImagePath = file.getAbsolutePath();

                    ContentValues contentValues = new ContentValues(1);
                    contentValues.put(MediaStore.Images.Media.DATA, mImagePath);
                    mImageUri = mContext.getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues);

                    intent.putExtra(MediaStore.EXTRA_OUTPUT, mImageUri);
                    if (Util.detectIntent(mContext, intent)) {
                        ActivityUtils.startWithTransition(((Activity) mContext), intent, FilePickerConstant.REQUEST_CODE_TAKE_IMAGE);
                    } else {
                        ToastUtil.getInstance(mContext).showToast(mContext.getString(R.string.lbl_no_photo_app));
                    }
                    return null;
                });
            });
        } else {
            holder.mIvCamera.setVisibility(View.INVISIBLE);
            holder.mIvThumbnail.setVisibility(View.VISIBLE);
            // holder.mCbx.setVisibility(View.VISIBLE);

            ImageFile file;
            if (isNeedCamera) {
                file = mList.get(position - 1);
            } else {
                file = mList.get(position);
            }

            RequestOptions options = new RequestOptions();
            Glide.with(mContext)
                    .load(file.getPath())
                    .apply(options.centerCrop())
                    .transition(withCrossFade())
//                    .transition(new DrawableTransitionOptions().crossFade(500))
                    .into(holder.mIvThumbnail);

            if (file.isSelected()) {
                holder.mCbx.setSelected(true);
                holder.mShadow.setVisibility(View.VISIBLE);
            } else {
                holder.mCbx.setSelected(false);
                holder.mShadow.setVisibility(View.INVISIBLE);
            }

            holder.mCbx.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    int index = isNeedCamera ? holder.getAdapterPosition() - 1 : holder.getAdapterPosition();
                    if (mMaxNumber != 1) {
                        if (!v.isSelected() && isUpToMax()) {
                            ToastUtil.getInstance(mContext).showToast(R.string.lbl_up_to_max);
                            return;
                        }
                        mList.get(index).setSelected(!mList.get(index).isSelected());
                    } else {

                        boolean selected = mList.get(index).isSelected();
                        for (int i = 0; i < mList.size(); i++)
                            mList.get(i).setSelected(false);
                        mCurrentNumber = 0;
                        ((ImagePickActivity) mContext).mSelectedList.clear();
                        ((ImagePickActivity) mContext).mCurrentNumber = 0;
                        mList.get(index).setSelected(!selected);

                    }
                    if (!mList.get(index).isSelected()) {
                        holder.mShadow.setVisibility(View.INVISIBLE);
                        holder.mCbx.setSelected(false);
                        mCurrentNumber--;
                        mList.get(index).setSelected(false);
                    } else {
                        holder.mShadow.setVisibility(View.VISIBLE);
                        holder.mCbx.setSelected(true);
                        mCurrentNumber++;
                        mList.get(index).setSelected(true);
                    }

                    if (mListener != null) {
                        mListener.OnSelectStateChanged(holder.mCbx.isSelected(), mList.get(index));
                    }
                    notifyDataSetChanged();
                }
            });

            if (isNeedImagePager) {
                holder.itemView.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        int index = isNeedCamera ? holder.getAdapterPosition() - 1 : holder.getAdapterPosition();
                        ArrayList<ImageFile> mSelectedList = new ArrayList<>();
                        mSelectedList.add(mList.get(index));
                        Intent intent = new Intent();
                        intent.putParcelableArrayListExtra(FilePickerConstant.RESULT_PICK_FILE, mSelectedList);
                        AppCompatActivity activity = (AppCompatActivity) mContext;
                        activity.setResult(RESULT_OK, intent);
                        ActivityUtils.finishWithTransition(activity);
                       /*
                        Intent intent = new Intent(mContext, ImageBrowserActivity.class);
                        intent.putExtra(FilePickerConstant.MAX_NUMBER, mMaxNumber);
                        intent.putExtra(ImageBrowserActivity.IMAGE_BROWSER_DIRECTORY_PATH, getDirectotyPath());
                        intent.putExtra(IMAGE_BROWSER_INIT_INDEX,
                                isNeedCamera ? holder.getAdapterPosition() - 1 : holder.getAdapterPosition());
                        intent.putParcelableArrayListExtra(IMAGE_BROWSER_SELECTED_LIST, ((ImagePickActivity) mContext).mSelectedList);
                        ActivityUtils.startWithTransition(((AppCompatActivity) mContext), intent, FilePickerConstant.REQUEST_CODE_BROWSER_IMAGE);
*/
                    }
                });
            } else {
                holder.mIvThumbnail.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        if (mMaxNumber != 1) {
                            if (!holder.mCbx.isSelected() && isUpToMax()) {
                                ToastUtil.getInstance(mContext).showToast(R.string.lbl_up_to_max);
                                return;
                            }
                            mList.get(holder.getAdapterPosition()).setSelected(!mList.get(holder.getAdapterPosition()).isSelected());
                        } else {


                            boolean selected = mList.get(holder.getAdapterPosition()).isSelected();
                            for (int i = 0; i < mList.size(); i++)
                                mList.get(i).setSelected(false);
                            mCurrentNumber = 0;
                            ((ImagePickActivity) mContext).mSelectedList.clear();
                            ((ImagePickActivity) mContext).mCurrentNumber = 0;
                            mList.get(holder.getAdapterPosition()).setSelected(!selected);

                        }
                        int index = isNeedCamera ? holder.getAdapterPosition() - 1 : holder.getAdapterPosition();
                        if (!mList.get(holder.getAdapterPosition()).isSelected()) {
                            holder.mShadow.setVisibility(View.INVISIBLE);
                            holder.mCbx.setSelected(false);
                            mCurrentNumber--;
                            mList.get(index).setSelected(false);
                        } else {
                            holder.mShadow.setVisibility(View.VISIBLE);
                            holder.mCbx.setSelected(true);
                            mCurrentNumber++;
                            mList.get(index).setSelected(true);
                        }

                        if (mListener != null) {
                            mListener.OnSelectStateChanged(holder.mCbx.isSelected(), mList.get(index));
                        }
                        notifyDataSetChanged();
                    }
                });
            }
        }
    }

    @Override
    public int getItemCount() {
        return isNeedCamera ? mList.size() + 1 : mList.size();
    }

    public boolean isUpToMax() {
        return mCurrentNumber >= mMaxNumber;
    }

    public void setCurrentNumber(int number) {
        mCurrentNumber = number;
    }

    class ImagePickViewHolder extends RecyclerView.ViewHolder {
        private ImageView mIvCamera;
        private ImageView mIvThumbnail;
        private View mShadow;
        private ImageView mCbx;

        public ImagePickViewHolder(View itemView) {
            super(itemView);
            DataBindingUtil.bind(itemView);
            mIvCamera = itemView.findViewById(R.id.iv_camera);
            mIvThumbnail = itemView.findViewById(R.id.iv_thumbnail);
            mShadow = itemView.findViewById(R.id.shadow);
            mCbx = itemView.findViewById(R.id.cbx);
        }
    }
}
