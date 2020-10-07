package com.example.flutter_files_picker.filepicker.local;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;

import androidx.appcompat.app.AlertDialog;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;


import com.example.flutter_files_picker.R;
import com.example.flutter_files_picker.filepicker.local.adapter.FolderListAdapter;
import com.example.flutter_files_picker.filepicker.local.filter.entity.Directory;

import java.util.ArrayList;
import java.util.List;


/**
 * Created by Vincent Woo
 * Date: 2018/2/27
 * Time: 13:43
 */

public class FolderListHelper {
    private AlertDialog directoryPicker;
    private View mContentView;
    private RecyclerView rv_folder;
    private FolderListAdapter mAdapter;

    public void initFolderListView(Context ctx) {
        if (directoryPicker == null) {
            AlertDialog.Builder dialogBuilder = new AlertDialog.Builder(ctx);

            LayoutInflater inflater = ((LayoutInflater) ctx.getSystemService(Context.LAYOUT_INFLATER_SERVICE));
            mContentView = inflater.inflate(R.layout.layout_folder_list, null);
            rv_folder = mContentView.findViewById(R.id.rv_folder);
            mAdapter = new FolderListAdapter(ctx, new ArrayList<Directory>());
            rv_folder.setAdapter(mAdapter);
            rv_folder.setLayoutManager(new LinearLayoutManager(ctx));
            mContentView.setFocusable(true);
            mContentView.setFocusableInTouchMode(true);
            dialogBuilder.setTitle("Select Directory");

            dialogBuilder.setView(mContentView);
            directoryPicker = dialogBuilder.create();
        }
    }

    public void setFolderListListener(FolderListAdapter.FolderListListener listener) {
        mAdapter.setListener(listener);
    }

    public void fillData(List<Directory> list) {
        mAdapter.refresh(list);
    }

    public void toggle(View anchor) {
        if (directoryPicker.isShowing()) {
            directoryPicker.dismiss();
        } else {
            directoryPicker.show();
        }
    }
}
