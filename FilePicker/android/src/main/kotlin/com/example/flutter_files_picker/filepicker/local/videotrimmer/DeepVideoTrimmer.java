package com.example.flutter_files_picker.filepicker.local.videotrimmer;

import android.content.Context;
import android.media.MediaMetadataRetriever;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.util.AttributeSet;
import android.util.Log;
import android.view.GestureDetector;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.VideoView;

import androidx.annotation.NonNull;

import com.example.flutter_files_picker.R;
import com.example.flutter_files_picker.filepicker.local.videotrimmer.interfaces.OnProgressVideoListener;
import com.example.flutter_files_picker.filepicker.local.videotrimmer.interfaces.OnRangeSeekBarListener;
import com.example.flutter_files_picker.filepicker.local.videotrimmer.interfaces.OnTrimVideoListener;
import com.example.flutter_files_picker.filepicker.local.videotrimmer.utils.BackgroundExecutor;
import com.example.flutter_files_picker.filepicker.local.videotrimmer.utils.TrimVideoUtils;
import com.example.flutter_files_picker.filepicker.local.videotrimmer.utils.UiThreadExecutor;
import com.example.flutter_files_picker.filepicker.local.videotrimmer.view.ProgressBarView;
import com.example.flutter_files_picker.filepicker.local.videotrimmer.view.RangeSeekBarView;
import com.example.flutter_files_picker.filepicker.local.videotrimmer.view.TimeLineView;

import java.io.File;
import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.Formatter;
import java.util.List;
import java.util.Locale;

public class DeepVideoTrimmer extends FrameLayout implements MediaPlayer.OnErrorListener, MediaPlayer.OnPreparedListener, MediaPlayer.OnCompletionListener,
        SeekBar.OnSeekBarChangeListener, OnRangeSeekBarListener, OnProgressVideoListener {

    private static final String TAG = DeepVideoTrimmer.class.getSimpleName();
    private static final int MIN_TIME_FRAME = 1000;
    private static final int SHOW_PROGRESS = 2;
    @NonNull
    private final MessageHandler mMessageHandler = new MessageHandler(this);
    private SeekBar mHolderTopView;
    private RangeSeekBarView mRangeSeekBarView;
    private RelativeLayout mLinearVideo;
    private VideoView mVideoView;
    private ImageView mPlayView;
    private TextView mTextSize;
    private TextView mTextTimeStart, mTextTimeEnd;
    private TextView mTextTime;
    private TimeLineView mTimeLineView;
    private Uri mSrc;
    private String mFinalPath;
    private int mMaxDuration;
    private List<OnProgressVideoListener> mListeners;
    private OnTrimVideoListener mOnTrimVideoListener;
    private int mDuration = 0;
    private int maxFileSize = 25;
    private int mTimeVideo = 0;
    private int mStartPosition = 0;
    private int mEndPosition = 0;
    private long mOriginSizeFile;
    private boolean mResetSeekBar = true;
    @NonNull
    private final GestureDetector.SimpleOnGestureListener mGestureListener = new GestureDetector.SimpleOnGestureListener() {
        @Override
        public boolean onSingleTapConfirmed(MotionEvent e) {
            if (mVideoView.isPlaying()) {
                mPlayView.setVisibility(View.VISIBLE);
                mMessageHandler.removeMessages(SHOW_PROGRESS);
                mVideoView.pause();
            } else {
                mPlayView.setVisibility(View.GONE);

                if (mResetSeekBar) {
                    mResetSeekBar = false;
                    mVideoView.seekTo(mStartPosition);
                }

                mMessageHandler.sendEmptyMessage(SHOW_PROGRESS);
                mVideoView.start();
            }
            return true;
        }
    };
    private boolean letUserProceed;
    private GestureDetector mGestureDetector;
    @NonNull
    private final OnTouchListener mTouchListener = new OnTouchListener() {
        @Override
        public boolean onTouch(View v, @NonNull MotionEvent event) {
            mGestureDetector.onTouchEvent(event);
            return true;
        }
    };
    private int initialLength;

    public DeepVideoTrimmer(@NonNull Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public DeepVideoTrimmer(@NonNull Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context);
    }

    private void init(Context context) {

        LayoutInflater.from(context).inflate(R.layout.view_time_line, this, true);

        mHolderTopView = findViewById(R.id.handlerTop);
        ProgressBarView progressVideoView = findViewById(R.id.timeVideoView);
        mRangeSeekBarView = findViewById(R.id.timeLineBar);
        mLinearVideo = findViewById(R.id.layout_surface_view);
        mVideoView = findViewById(R.id.video_loader);
        mPlayView = findViewById(R.id.icon_video_play);
        mTextSize = findViewById(R.id.textSize);
        mTextTimeStart = findViewById(R.id.textTimeStart);
        mTextTimeEnd = findViewById(R.id.textTimeEnd);
        mTextTime = findViewById(R.id.textTime);
        mTimeLineView = findViewById(R.id.timeLineView);
        View viewButtonSave = findViewById(R.id.btSave);

        mVideoView.start();
        if (viewButtonSave != null) {
            viewButtonSave.setOnClickListener(view -> {

                        mOnTrimVideoListener.startTrimming();
                        if (letUserProceed) {
                            if (mStartPosition <= 0 && mEndPosition >= mDuration) {
                                mOnTrimVideoListener.finishTrimming(mSrc);
                            } else {
                                mPlayView.setVisibility(View.VISIBLE);
                                mVideoView.pause();

                                MediaMetadataRetriever mediaMetadataRetriever = new MediaMetadataRetriever();
                                mediaMetadataRetriever.setDataSource(getContext(), mSrc);
                                long METADATA_KEY_DURATION = Long.parseLong(mediaMetadataRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION));

                                File file = new File(mSrc.getPath());

                                if (mTimeVideo < MIN_TIME_FRAME) {

                                    if ((METADATA_KEY_DURATION - mEndPosition) > (MIN_TIME_FRAME - mTimeVideo)) {
                                        mEndPosition += (MIN_TIME_FRAME - mTimeVideo);
                                    } else if (mStartPosition > (MIN_TIME_FRAME - mTimeVideo)) {
                                        mStartPosition -= (MIN_TIME_FRAME - mTimeVideo);
                                    }
                                }
                                startTrimVideo(file, mFinalPath, mStartPosition, mEndPosition, mOnTrimVideoListener);
                            }
                        } else {
                            Toast.makeText(getContext(), "Please trim your video less than 25MB of size", Toast.LENGTH_SHORT).show();
                        }
                    }
            );
        }

        mListeners = new ArrayList<>();
        mListeners.add(this);
        mListeners.add(progressVideoView);

        mHolderTopView.setMax(1000);
        mHolderTopView.setSecondaryProgress(0);

        mRangeSeekBarView.addOnRangeSeekBarListener(this);
        mRangeSeekBarView.addOnRangeSeekBarListener(progressVideoView);

        int marge = mRangeSeekBarView.getThumbs().get(0).getWidthBitmap();
        int widthSeek = mHolderTopView.getThumb().getMinimumWidth() / 2;

        LinearLayout.LayoutParams lp = (LinearLayout.LayoutParams) mHolderTopView.getLayoutParams();
        lp.setMargins(marge - widthSeek, 0, marge - widthSeek, 0);
        mHolderTopView.setLayoutParams(lp);

        RelativeLayout.LayoutParams rlp = (RelativeLayout.LayoutParams) mTimeLineView.getLayoutParams();
        rlp.setMargins(marge, 0, marge, 0);
        mTimeLineView.setLayoutParams(rlp);

        lp = (LinearLayout.LayoutParams) progressVideoView.getLayoutParams();
        lp.setMargins(marge, 0, marge, 0);
        progressVideoView.setLayoutParams(lp);

        mHolderTopView.setOnSeekBarChangeListener(this);

        mVideoView.setOnPreparedListener(this);
        mVideoView.setOnCompletionListener(this);
        mVideoView.setOnErrorListener(this);

        mGestureDetector = new GestureDetector(getContext(), mGestureListener);
        mVideoView.setOnTouchListener(mTouchListener);

        setDefaultDestinationPath();
    }

    @SuppressWarnings("unused")
    public void setVideoURI(final Uri videoURI) {
        mSrc = videoURI;

        getSizeFile(false);

        mVideoView.setVideoURI(mSrc);
        mVideoView.requestFocus();
        mTimeLineView.setVideo(mSrc);
    }

    @SuppressWarnings("unused")
    public void setDestinationPath(final String finalPath) {
        mFinalPath = finalPath;
        Log.d(TAG, "Setting custom path " + mFinalPath);
    }

    private void setDefaultDestinationPath() {
        File folder = Environment.getExternalStorageDirectory();
        mFinalPath = folder.getPath() + File.separator;
        Log.d(TAG, "Setting default path " + mFinalPath);
    }

    @Override
    public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
        int duration = (int) ((mDuration * progress) / 1000L);

        if (fromUser) {
            if (duration < mStartPosition) {
                setProgressBarPosition(mStartPosition);
                duration = mStartPosition;
            } else if (duration > mEndPosition) {
                setProgressBarPosition(mEndPosition);
                duration = mEndPosition;
            }
            setTimeVideo(duration);
        }
    }

    @Override
    public void onStartTrackingTouch(SeekBar seekBar) {
        mMessageHandler.removeMessages(SHOW_PROGRESS);
        mVideoView.pause();
        mPlayView.setVisibility(View.VISIBLE);
        updateProgress(false);
    }

    @Override
    public void onStopTrackingTouch(@NonNull SeekBar seekBar) {
        mMessageHandler.removeMessages(SHOW_PROGRESS);
        mVideoView.pause();
        mPlayView.setVisibility(View.VISIBLE);

        int duration = (int) ((mDuration * seekBar.getProgress()) / 1000L);
        mVideoView.seekTo(duration);
        setTimeVideo(duration);
        updateProgress(false);
    }

    @Override
    public void onPrepared(@NonNull MediaPlayer mp) {
        int videoWidth = mp.getVideoWidth();
        int videoHeight = mp.getVideoHeight();
        float videoProportion = (float) videoWidth / (float) videoHeight;
        int screenWidth = mLinearVideo.getWidth();
        int screenHeight = mLinearVideo.getHeight();
        float screenProportion = (float) screenWidth / (float) screenHeight;
        ViewGroup.LayoutParams lp = mVideoView.getLayoutParams();

        if (videoProportion > screenProportion) {
            lp.width = screenWidth;
            lp.height = (int) ((float) screenWidth / videoProportion);
        } else {
            lp.width = (int) (videoProportion * (float) screenHeight);
            lp.height = screenHeight;
        }
        mVideoView.setLayoutParams(lp);

        mPlayView.setVisibility(View.VISIBLE);

        mDuration = mVideoView.getDuration();
        setSeekBarPosition();
        getSizeFile(false);
        setTimeFrames();
        setTimeVideo(0);
        letUserProceed = getCroppedFileSize() < maxFileSize;
    }

    public int getMaxFileSize() {
        return maxFileSize;
    }

    public void setMaxFileSize(int maxFileSize) {
        this.maxFileSize = maxFileSize;
    }

    private void setSeekBarPosition() {

        if (mDuration >= mMaxDuration) {
            mStartPosition = mDuration / 2 - mMaxDuration / 2;
            mEndPosition = mDuration / 2 + mMaxDuration / 2;

            mRangeSeekBarView.setThumbValue(0, (mStartPosition * 100) / mDuration);
            mRangeSeekBarView.setThumbValue(1, (mEndPosition * 100) / mDuration);

        } else {
            mStartPosition = 0;
            mEndPosition = mDuration;
        }

        setProgressBarPosition(mStartPosition);
        mVideoView.seekTo(mStartPosition);

        mTimeVideo = mDuration;
        mRangeSeekBarView.initMaxWidth();

        initialLength = ((mEndPosition - mStartPosition) / 1000);
    }

    private void startTrimVideo(@NonNull final File file, @NonNull final String dst, final int startVideo, final int endVideo, @NonNull final OnTrimVideoListener callback) {
        BackgroundExecutor.execute(new BackgroundExecutor.Task("", 0L, "") {
                                       @Override
                                       public void execute() {
                                           try {
                                               TrimVideoUtils.startTrim(file, dst, startVideo, endVideo, callback);
                                           } catch (final Throwable e) {
                                               Thread.getDefaultUncaughtExceptionHandler().uncaughtException(Thread.currentThread(), e);
                                           }
                                       }
                                   }
        );
    }

    private void setTimeFrames() {
        String seconds = getContext().getString(R.string.short_seconds);
        mTextTimeStart.setText(String.format(Locale.ENGLISH,"%s %s", stringForTime(mStartPosition), seconds));
        mTextTimeEnd.setText(String.format(Locale.ENGLISH,"%s %s", stringForTime(mEndPosition), seconds));
    }


    private void setTimeVideo(int position) {
        String seconds = getContext().getString(R.string.short_seconds);
        mTextTime.setText(String.format(Locale.ENGLISH,"%s %s", stringForTime(position), seconds));
    }

    @Override
    public void onCreate(RangeSeekBarView rangeSeekBarView, int index, float value) {

    }

    @Override
    public void onSeek(RangeSeekBarView rangeSeekBarView, int index, float value) {
        switch (index) {
            case 0: {
                mStartPosition = (int) ((mDuration * value) / 100L);
                mVideoView.seekTo(mStartPosition);
                break;
            }
            case 1: {
                mEndPosition = (int) ((mDuration * value) / 100L);
                break;
            }
        }
        setProgressBarPosition(mStartPosition);

        setTimeFrames();
        mTimeVideo = mEndPosition - mStartPosition;
        letUserProceed = getCroppedFileSize() < maxFileSize;
    }

    @Override
    public void onSeekStart(RangeSeekBarView rangeSeekBarView, int index, float value) {

    }

    @Override
    public void onSeekStop(RangeSeekBarView rangeSeekBarView, int index, float value) {
        mMessageHandler.removeMessages(SHOW_PROGRESS);
        mVideoView.pause();
        mPlayView.setVisibility(View.VISIBLE);
    }

    private String stringForTime(int timeMs) {
        int totalSeconds = timeMs / 1000;

        int seconds = totalSeconds % 60;
        int minutes = (totalSeconds / 60) % 60;
        int hours = totalSeconds / 3600;

        Formatter mFormatter = new Formatter();
        if (hours > 0) {
            return mFormatter.format("%d:%02d:%02d", hours, minutes, seconds).toString();
        } else {
            return mFormatter.format("%02d:%02d", minutes, seconds).toString();
        }
    }

    private void getSizeFile(boolean isChanged) {
        if (isChanged) {
            long initSize = getFileSize();
            long newSize;
            newSize = ((initSize / initialLength) * (mEndPosition - mStartPosition));
            mTextSize.setText(String.format(Locale.ENGLISH,"%s %s", newSize / 1024, getContext().getString(R.string.megabyte)));
        } else {
            if (mOriginSizeFile == 0) {
                File file = new File(mSrc.getPath());

                mOriginSizeFile = file.length();
                long fileSizeInKB = mOriginSizeFile / 1024;

                if (fileSizeInKB > 1000) {
                    long fileSizeInMB = fileSizeInKB / 1024;
                    mTextSize.setText(String.format(Locale.ENGLISH,"%s %s", fileSizeInMB, getContext().getString(R.string.megabyte)));
                } else {
                    mTextSize.setText(String.format(Locale.ENGLISH,"%s %s", fileSizeInKB, getContext().getString(R.string.kilobyte)));
                }
            }
        }
    }

    private long getFileSize() {
        File file = new File(mSrc.getPath());
        mOriginSizeFile = file.length();
        long fileSizeInKB = mOriginSizeFile / 1024;

        return fileSizeInKB / 1024;
    }

    private long getCroppedFileSize() {
        long initSize = getFileSize();
        long newSize;
        newSize = ((initSize / initialLength) * (mEndPosition - mStartPosition));
        return newSize / 1024;
    }

    @SuppressWarnings("unused")
    public void setOnTrimVideoListener(OnTrimVideoListener onTrimVideoListener) {
        mOnTrimVideoListener = onTrimVideoListener;
    }

    public void setMaxDuration(int maxDuration) {
        if (maxDuration == 0) {
            mMaxDuration = (mEndPosition - mStartPosition) * 1000;
        } else if (maxDuration < 0) {
            mMaxDuration = -maxDuration * 1000;
        } else {
            mMaxDuration = maxDuration * 1000;
        }
    }

    public void setSurface(boolean overlay) {
        mVideoView.post(() -> mVideoView.setVideoURI(overlay ? mSrc : null));
        if (!overlay){
            mVideoView.stopPlayback();
            mVideoView.setZOrderMediaOverlay(false);
            mVideoView.setVisibility(View.GONE);
            mVideoView.suspend();
            mVideoView.invalidate();
            mVideoView.destroyDrawingCache();
        }else {
            mVideoView.postDelayed(() -> {
                mVideoView.setZOrderMediaOverlay(true);
                mVideoView.setVisibility(View.VISIBLE);
            }, 1000);
        }
    }

    @Override
    public void onCompletion(MediaPlayer mediaPlayer) {
        mVideoView.seekTo(0);
    }

    @Override
    public boolean onError(MediaPlayer mediaPlayer, int i, int i1) {
        return false;
    }

    private void updateProgress(boolean all) {
        if (mDuration == 0) return;

        int position = mVideoView.getCurrentPosition();
        if (all) {
            for (OnProgressVideoListener item : mListeners) {
                item.updateProgress(position, mDuration, ((position * 100) / mDuration));
            }
        } else {
            mListeners.get(1).updateProgress(position, mDuration, ((position * 100) / mDuration));
        }
    }

    @Override
    public void updateProgress(int time, int max, float scale) {
        if (mVideoView == null) {
            return;
        }

        if (time >= mEndPosition) {
            mMessageHandler.removeMessages(SHOW_PROGRESS);
            mVideoView.pause();
            mPlayView.setVisibility(View.VISIBLE);
            mResetSeekBar = true;
            return;
        }

        if (mHolderTopView != null) {
            setProgressBarPosition(time);
        }
        setTimeVideo(time);
    }

    private void setProgressBarPosition(int position) {
        if (mDuration > 0) {
            long pos = 1000L * position / mDuration;
            mHolderTopView.setProgress((int) pos);
        }
    }

    public void destroy() {
        BackgroundExecutor.cancelAll("", true);
        UiThreadExecutor.cancelAll("");
    }

    private static class MessageHandler extends Handler {

        @NonNull
        private final WeakReference<DeepVideoTrimmer> mView;

        MessageHandler(DeepVideoTrimmer view) {
            mView = new WeakReference<>(view);
        }

        @Override
        public void handleMessage(Message msg) {
            DeepVideoTrimmer view = mView.get();
            if (view == null || view.mVideoView == null) {
                return;
            }

            view.updateProgress(true);
            if (view.mVideoView.isPlaying()) {
                sendEmptyMessageDelayed(0, 10);
            }
        }
    }
}
