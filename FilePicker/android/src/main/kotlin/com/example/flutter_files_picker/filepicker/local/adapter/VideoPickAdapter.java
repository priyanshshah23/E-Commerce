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
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.core.content.FileProvider;
import androidx.databinding.DataBindingUtil;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.request.RequestOptions;
import com.example.flutter_files_picker.FlutterFilePickerPlugin;
import com.example.flutter_files_picker.R;
import com.example.flutter_files_picker.filepicker.local.FilePickerConstant;
import com.example.flutter_files_picker.filepicker.local.ToastUtil;
import com.example.flutter_files_picker.filepicker.local.Util;
import com.example.flutter_files_picker.filepicker.local.filter.entity.VideoFile;
import com.example.flutter_files_picker.filepicker.ui.activity.VideoPickActivity;
import com.example.flutter_files_picker.filepicker.util.permissions.PermissionsKt;
import com.example.flutter_files_picker.filepicker.util.permissions.util.PermissionsOptions;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;

import static android.os.Environment.DIRECTORY_DCIM;
import static com.bumptech.glide.load.resource.drawable.DrawableTransitionOptions.withCrossFade;

/**
 * Created by Vincent Woo
 * Date: 2016/10/21
 * Time: 14:13
 */

public class VideoPickAdapter extends BaseAdapter<VideoFile, VideoPickAdapter.VideoPickViewHolder> {
    public String mVideoPath;
    private boolean isNeedCamera;
    private int mMaxNumber;
    private int mCurrentNumber = 0;
    private Context context;

    public VideoPickAdapter(Context ctx, boolean needCamera, int max) {
        this(ctx, new ArrayList<VideoFile>(), needCamera, max);
    }

    public VideoPickAdapter(Context ctx, ArrayList<VideoFile> list, boolean needCamera, int max) {
        super(ctx, list);
        isNeedCamera = needCamera;
        mMaxNumber = max;
        this.context = ctx;
    }

    @Override
    public VideoPickViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(mContext).inflate(R.layout.layout_item_video_pick, parent, false);
        ViewGroup.LayoutParams params = itemView.getLayoutParams();
        if (params != null) {
            WindowManager wm = (WindowManager) mContext.getSystemService(Context.WINDOW_SERVICE);
            int width = wm.getDefaultDisplay().getWidth();
            params.height = width / VideoPickActivity.COLUMN_NUMBER;
        }
        return new VideoPickViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(final VideoPickViewHolder holder, int position) {
        if (isNeedCamera && position == 0) {
            holder.mIvCamera.setVisibility(View.VISIBLE);
            holder.mIvThumbnail.setVisibility(View.INVISIBLE);
            holder.mCbx.setVisibility(View.INVISIBLE);
            holder.mShadow.setVisibility(View.INVISIBLE);
            holder.mDurationLayout.setVisibility(View.INVISIBLE);
            holder.itemView.setOnClickListener(v -> {
                PermissionsKt.runWithPermissions(context, new String[]{Manifest.permission.CAMERA}, new PermissionsOptions(), () -> {
                    Intent intent = new Intent(MediaStore.ACTION_VIDEO_CAPTURE);
                    String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss", Locale.ENGLISH).format(new Date());
                    File file = new File(Environment.getExternalStoragePublicDirectory(DIRECTORY_DCIM).getAbsolutePath()
                            + "/VID_" + timeStamp + ".mp4");
                    mVideoPath = file.getAbsolutePath();

                    ContentValues contentValues = new ContentValues(1);
                    contentValues.put(MediaStore.Video.Media.DATA, mVideoPath);
                    Uri uri = mContext.getContentResolver().insert(MediaStore.Video.Media.EXTERNAL_CONTENT_URI, contentValues);

                    intent.putExtra(MediaStore.EXTRA_OUTPUT, uri);
                    intent.putExtra(MediaStore.EXTRA_VIDEO_QUALITY, 1);
                    if (Util.detectIntent(mContext, intent)) {
                        ((Activity) mContext).startActivityForResult(intent, FilePickerConstant.REQUEST_CODE_TAKE_VIDEO);
                    } else {
                        ToastUtil.getInstance(mContext).showToast(mContext.getString(R.string.lbl_no_video_app));
                    }
                    return null;
                });
            });
        } else {
            holder.mIvCamera.setVisibility(View.INVISIBLE);
            holder.mIvThumbnail.setVisibility(View.VISIBLE);
            holder.mCbx.setVisibility(View.VISIBLE);
            holder.mDurationLayout.setVisibility(View.VISIBLE);

            final VideoFile file;
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
                        ((VideoPickActivity) mContext).mSelectedList.clear();
                        ((VideoPickActivity) mContext).mCurrentNumber = 0;
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

            holder.itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
//                    Uri uri = Uri.parse("file://" + file.getPath());
//                    Uri uri = Uri.fromFile(new File(file.getPath()));
                    Uri uri = FileProvider.getUriForFile(context.getApplicationContext(), FlutterFilePickerPlugin.Companion.getAPPLICATION_ID() + ".provider", new File(file.getPath()));

                    Intent intent = new Intent(Intent.ACTION_VIEW);
                    intent.setDataAndType(uri, "video/mp4");
                    intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                    if (Util.detectIntent(mContext, intent)) {
                        mContext.startActivity(intent);
                    } else {
                        ToastUtil.getInstance(mContext).showToast(mContext.getString(R.string.lbl_no_video_play_app));
                    }
                }
            });

            holder.mDuration.setText(Util.getDurationString(file.getDuration()));
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

    class VideoPickViewHolder extends RecyclerView.ViewHolder {
        private ImageView mIvCamera;
        private ImageView mIvThumbnail;
        private View mShadow;
        private ImageView mCbx;
        private TextView mDuration;
        private RelativeLayout mDurationLayout;

        public VideoPickViewHolder(View itemView) {
            super(itemView);
            DataBindingUtil.bind(itemView);
            mIvCamera = itemView.findViewById(R.id.iv_camera);
            mIvThumbnail = itemView.findViewById(R.id.iv_thumbnail);
            mShadow = itemView.findViewById(R.id.shadow);
            mCbx = itemView.findViewById(R.id.cbx);
            mDuration = itemView.findViewById(R.id.txt_duration);
            mDurationLayout = itemView.findViewById(R.id.layout_duration);
        }
    }
}
