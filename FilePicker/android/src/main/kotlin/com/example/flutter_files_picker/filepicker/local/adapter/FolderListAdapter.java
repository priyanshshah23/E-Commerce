package com.example.flutter_files_picker.filepicker.local.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.databinding.DataBindingUtil;
import androidx.recyclerview.widget.RecyclerView;


import com.example.flutter_files_picker.R;
import com.example.flutter_files_picker.filepicker.local.filter.entity.Directory;

import java.util.ArrayList;

public class FolderListAdapter extends BaseAdapter<Directory, FolderListAdapter.FolderListViewHolder> {
    private FolderListListener mListener;

    public FolderListAdapter(Context ctx, ArrayList<Directory> list) {
        super(ctx, list);
    }

    @Override
    public FolderListViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(mContext).inflate(R.layout.layout_item_folder_list,
                parent, false);
        return new FolderListViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(final FolderListViewHolder holder, int position) {
        holder.mTvTitle.setText(mList.get(position).getName());
        holder.itemView.setOnClickListener(v -> {
            if (mListener != null) {
                mListener.onFolderListClick(mList.get(holder.getAdapterPosition()));
            }
        });
    }

    @Override
    public int getItemCount() {
        return mList.size();
    }

    public void setListener(FolderListListener listener) {
        this.mListener = listener;
    }

    public interface FolderListListener {
        void onFolderListClick(Directory directory);
    }

    class FolderListViewHolder extends RecyclerView.ViewHolder {
        private TextView mTvTitle;

        public FolderListViewHolder(View itemView) {
            super(itemView);
            DataBindingUtil.bind(itemView);
            mTvTitle = itemView.findViewById(R.id.tv_folder_title);
        }
    }
}
