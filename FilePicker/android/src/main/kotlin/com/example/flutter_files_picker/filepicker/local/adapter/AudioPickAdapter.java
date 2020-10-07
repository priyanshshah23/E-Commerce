package com.example.flutter_files_picker.filepicker.local.adapter;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.databinding.DataBindingUtil;
import androidx.recyclerview.widget.RecyclerView;

import com.example.flutter_files_picker.R;
import com.example.flutter_files_picker.filepicker.local.ToastUtil;
import com.example.flutter_files_picker.filepicker.local.Util;
import com.example.flutter_files_picker.filepicker.local.filter.entity.AudioFile;
import com.example.flutter_files_picker.filepicker.ui.activity.AudioPickActivity;

import java.util.ArrayList;


/**
 * Created by Vincent Woo
 * Date: 2016/10/25
 * Time: 10:57
 */

public class AudioPickAdapter extends BaseAdapter<AudioFile, AudioPickAdapter.AudioPickViewHolder> {
    private int mMaxNumber;
    private int mCurrentNumber = 0;

    public AudioPickAdapter(Context ctx, int max) {
        this(ctx, new ArrayList<AudioFile>(), max);
    }

    public AudioPickAdapter(Context ctx, ArrayList<AudioFile> list, int max) {
        super(ctx, list);
        mMaxNumber = max;
    }

    @Override
    public AudioPickViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(mContext).inflate(R.layout.layout_item_audio_pick, parent, false);
        return new AudioPickViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(final AudioPickViewHolder holder, final int position) {
        final AudioFile file = mList.get(position);

        holder.mTvTitle.setText(Util.extractFileNameWithSuffix(file.getPath()));
        holder.mTvTitle.measure(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED);
        if (holder.mTvTitle.getMeasuredWidth() >
                Util.getScreenWidth(mContext) - Util.dip2px(mContext, 10 + 32 + 10 + 48 + 10 * 2)) {
            holder.mTvTitle.setLines(2);
        } else {
            holder.mTvTitle.setLines(1);
        }

        holder.mTvDuration.setText(Util.getDurationString(file.getDuration()));
        if (file.isSelected()) {
            holder.mCbx.setSelected(true);
        } else {
            holder.mCbx.setSelected(false);
        }

        holder.mCbx.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mMaxNumber != 1) {
                    if (!v.isSelected() && isUpToMax()) {
                        ToastUtil.getInstance(mContext).showToast(R.string.lbl_up_to_max);
                        return;
                    }
                    mList.get(holder.getAdapterPosition()).setSelected(!holder.mCbx.isSelected());
                } else {
                    boolean selected = mList.get(holder.getAdapterPosition()).isSelected();
                    for (int i = 0; i < mList.size(); i++)
                        mList.get(i).setSelected(false);
                    mCurrentNumber = 0;
                    ((AudioPickActivity) mContext).mSelectedList.clear();
                    ((AudioPickActivity) mContext).mCurrentNumber = 0;
                    mList.get(holder.getAdapterPosition()).setSelected(!selected);
                }

                if (!mList.get(holder.getAdapterPosition()).isSelected()) {
                    holder.mCbx.setSelected(false);
                    mCurrentNumber--;
                } else {
                    holder.mCbx.setSelected(true);
                    mCurrentNumber++;
                }


                if (mListener != null) {
                    mListener.OnSelectStateChanged(holder.mCbx.isSelected(), mList.get(holder.getAdapterPosition()));
                }
                notifyDataSetChanged();
            }
        });

        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Uri uri = Uri.parse("file://" + file.getPath());
                Intent intent = new Intent(Intent.ACTION_VIEW);
                intent.setDataAndType(uri, "audio/mp3");
                if (Util.detectIntent(mContext, intent)) {
                    mContext.startActivity(intent);
                } else {
                    ToastUtil.getInstance(mContext).showToast(mContext.getString(R.string.lbl_no_audio_play_app));
                }
            }
        });
    }

    @Override
    public int getItemCount() {
        return mList.size();
    }

    public boolean isUpToMax() {
        return mCurrentNumber >= mMaxNumber;
    }

    public void setCurrentNumber(int number) {
        mCurrentNumber = number;
    }

    class AudioPickViewHolder extends RecyclerView.ViewHolder {
        private TextView mTvTitle;
        private TextView mTvDuration;
        private ImageView mCbx;

        public AudioPickViewHolder(View itemView) {
            super(itemView);
            DataBindingUtil.bind(itemView);
            mTvTitle = itemView.findViewById(R.id.tv_audio_title);
            mTvDuration = itemView.findViewById(R.id.tv_duration);
            mCbx = itemView.findViewById(R.id.cbx);
        }
    }
}
