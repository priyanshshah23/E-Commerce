package com.example.flutter_files_picker.filepicker.local.adapter;

import android.content.Context;
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
import com.example.flutter_files_picker.filepicker.local.filter.entity.NormalFile;
import com.example.flutter_files_picker.filepicker.ui.activity.NormalFilePickActivity;
import com.example.flutter_files_picker.filepicker.util.MathUtil;

import java.util.ArrayList;

/**
 * Created by Vincent Woo
 * Date: 2016/10/26
 * Time: 10:23
 */

public class NormalFilePickAdapter extends BaseAdapter<NormalFile, NormalFilePickAdapter.NormalFilePickViewHolder> {
    private int mMaxNumber;
    private int mCurrentNumber = 0;

    public NormalFilePickAdapter(Context ctx, int max) {
        this(ctx, new ArrayList<NormalFile>(), max);
    }

    public NormalFilePickAdapter(Context ctx, ArrayList<NormalFile> list, int max) {
        super(ctx, list);
        mMaxNumber = max;
    }

    @Override
    public NormalFilePickViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(mContext).inflate(R.layout.layout_item_normal_file_pick, parent, false);
        return new NormalFilePickViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(final NormalFilePickViewHolder holder, final int position) {
        final NormalFile file = mList.get(position);

        holder.mTvTitle.setText(Util.extractFileNameWithSuffix(file.getPath()));
        holder.tv_file_desc.setText("Size : " + MathUtil.formatFileSize(file.getSize()));
        holder.mTvTitle.measure(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED);

        if (holder.mTvTitle.getMeasuredWidth() > Util.getScreenWidth(mContext) - Util.dip2px(mContext, 10 + 32 + 10 + 48 + 10 * 2)) {
            holder.mTvTitle.setLines(2);
        } else {
            holder.mTvTitle.setLines(1);
        }

        if (file.isSelected()) {
            holder.mCbx.setSelected(true);
        } else {
            holder.mCbx.setSelected(false);
        }

        if (file.getPath().endsWith("xls") || file.getPath().endsWith("xlsx")) {
            holder.mIvIcon.setImageResource(R.drawable.vw_ic_excel);
        } else if (file.getPath().endsWith("doc") || file.getPath().endsWith("docx")) {
            holder.mIvIcon.setImageResource(R.drawable.vw_ic_word);
        } else if (file.getPath().endsWith("ppt") || file.getPath().endsWith("pptx")) {
            holder.mIvIcon.setImageResource(R.drawable.vw_ic_ppt);
        } else if (file.getPath().endsWith("pdf")) {
            holder.mIvIcon.setImageResource(R.drawable.vw_ic_pdf);
        } else if (file.getPath().endsWith("txt")) {
            holder.mIvIcon.setImageResource(R.drawable.vw_ic_txt);
        } else {
            holder.mIvIcon.setImageResource(R.drawable.vw_ic_file);
        }

        holder.mCbx.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if (mMaxNumber != 1) {
                    if (!v.isSelected() && isUpToMax()) {
                        ToastUtil.getInstance(mContext).showToast(R.string.lbl_up_to_max);
                        return;
                    }
                    mList.get(holder.getAdapterPosition()).setSelected(!mList.get(holder.getAdapterPosition()).isSelected());
                } else {
                    boolean selected = mList.get(holder.getAdapterPosition()).isSelected();
                    for (int i = 0; i < mList.size(); i++)
                        mList.get(i).setSelected(false);
                    mCurrentNumber = 0;
                    ((NormalFilePickActivity) mContext).mSelectedList.clear();
                    ((NormalFilePickActivity) mContext).mCurrentNumber = 0;
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

//        holder.itemView.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                Uri uri = Uri.parse("file://" + file.getPath());
//                Intent intent = new Intent(Intent.ACTION_VIEW);
//                intent.setDataAndType(uri, "audio/mp3");
//                if (Util.detectIntent(mContext, intent)) {
//                    mContext.startActivity(intent);
//                } else {
//                    Toast.makeText(mContext, "No Application exists for audio!", Toast.LENGTH_SHORT).show();
//                }
//            }
//        });
    }

    @Override
    public int getItemCount() {
        return mList.size();
    }

    private boolean isUpToMax() {
        return mCurrentNumber >= mMaxNumber;
    }

    class NormalFilePickViewHolder extends RecyclerView.ViewHolder {
        private ImageView mIvIcon;
        private TextView mTvTitle;
        private TextView tv_file_desc;
        private ImageView mCbx;

        public NormalFilePickViewHolder(View itemView) {
            super(itemView);
            DataBindingUtil.bind(itemView);
            mIvIcon = itemView.findViewById(R.id.ic_file);
            mTvTitle = itemView.findViewById(R.id.tv_file_title);
            tv_file_desc = itemView.findViewById(R.id.tv_file_desc);
            mCbx = itemView.findViewById(R.id.cbx);
        }
    }

}
