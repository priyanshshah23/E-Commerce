package com.example.flutter_files_picker.filepicker.ui.fragment;

import android.app.ProgressDialog;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.databinding.DataBindingUtil;

import com.example.flutter_files_picker.R;
import com.example.flutter_files_picker.filepicker.local.Util;
import com.example.flutter_files_picker.filepicker.local.fragment.VideoTrimmerBase;
import com.example.flutter_files_picker.filepicker.local.videotrimmer.DeepVideoTrimmer;
import com.example.flutter_files_picker.filepicker.local.videotrimmer.interfaces.OnTrimVideoListener;

import static com.example.flutter_files_picker.filepicker.ui.activity.CropVideosActivity.mSelectedVideos;


public class FragmentVideoTrim extends VideoTrimmerBase implements OnTrimVideoListener {

    public static final String VIDEO_PATH = "image_path";
    private static final String KEY_IMG_INDEX = "img_index";
    private String url;
    private int position;
    private DeepVideoTrimmer mVideoTrimmer;
    private ProgressDialog dialog;
    private Callback videoCroppedCallback;

    public static FragmentVideoTrim getInstance(int position, String path) {
        FragmentVideoTrim instance = new FragmentVideoTrim();
        Bundle bundle = new Bundle();
        bundle.putString(VIDEO_PATH, path);
        bundle.putInt(KEY_IMG_INDEX, position);
        instance.setArguments(bundle);
        return instance;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_video_trimmer, container, false);
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (!isVisibleToUser) {
            if (mVideoTrimmer != null) {
                mVideoTrimmer.setSurface(false);
            }
        }else {
            if (mVideoTrimmer != null) {
                mVideoTrimmer.setSurface(true);
            }
        }
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        DataBindingUtil.bind(view);
        if (getArguments() != null) {
            url = getArguments().getString(VIDEO_PATH);
            position = getArguments().getInt(KEY_IMG_INDEX);
        }

        mVideoTrimmer = view.findViewById(R.id.timeLine);
        dialog = new ProgressDialog(getContext());
        if (mVideoTrimmer != null && url != null) {
            mVideoTrimmer.setMaxDuration(100);
            mVideoTrimmer.setOnTrimVideoListener(this);
            mVideoTrimmer.setVideoURI(Uri.parse(url));
        } else {
            showToastLong(getString(R.string.msg_cannot_retrieve_selected_video));
        }
    }

    @Override
    public void finishTrimming(Uri uri) {
        dialog.dismiss();
        mSelectedVideos.get(position).setPath(uri.getPath());
        mSelectedVideos.get(position).setName(Util.extractFileNameWithSuffix(uri.getPath()));
        getArguments().clear();
        Bundle bundle = new Bundle();
        bundle.putString(VIDEO_PATH, uri.getPath());
        bundle.putInt(KEY_IMG_INDEX, position);
        setArguments(bundle);
        getActivity().runOnUiThread(() -> videoCroppedCallback.OnVideoCropped(position));
    }

    @Override
    public void startTrimming() {
        dialog.setMessage("Cropping video...");
        dialog.setCancelable(false);
        dialog.setCanceledOnTouchOutside(false);
        dialog.show();
    }

    public void setVideoCroppedCallback(Callback videoCroppedCallback) {
        this.videoCroppedCallback = videoCroppedCallback;
    }

    public interface Callback{
        void OnVideoCropped(int position);
    }
}
