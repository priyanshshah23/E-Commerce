package com.example.flutter_files_picker.filepicker.ui;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;

import com.example.flutter_files_picker.R;
import com.example.flutter_files_picker.filepicker.ui.activity.AudioPickActivity;
import com.example.flutter_files_picker.filepicker.ui.activity.ImagePickActivity;
import com.example.flutter_files_picker.filepicker.ui.activity.NormalFilePickActivity;
import com.example.flutter_files_picker.filepicker.ui.activity.PickDriveFileActivity;
import com.example.flutter_files_picker.filepicker.ui.activity.PickDropboxFileActivity;
import com.example.flutter_files_picker.filepicker.ui.activity.VideoPickActivity;
import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static com.example.flutter_files_picker.filepicker.ui.Picker.FileType.*;

/**
 * Open File Picker with specified parameters
 * <p>
 * Ex.
 * <p>
 * val type = ArrayList<Picker.FileType>()
 * <p>
 * Picker.Builder(context, type)
 * .addSourceType(Picker.SourceType.GALLARY)
 * .addSourceType(Picker.SourceType.GOOGLE_DRIVE)
 * .addSourceType(Picker.SourceType.AUDIO)
 * .addSourceType(Picker.SourceType.DOCUMENTS)
 * .addSourceType(Picker.SourceType.VIDEO)
 * .addAllVideoTypes()
 * .addAllImageTypes()
 * .addAllAudioTypes()
 * .addAllDocumentTypes()
 * .allowDirectoryFilter()
 * .allowMultiSelection()
 * .allowNewFile()
 * .allowCrop()
 * .setFilesCount(5)
 * .start { intent -> activity?.startWithTransition(intent, FilePickerConstant.REQUEST_CODE_PICK_FILE) }
 */

public class Picker {

    public static final String FILE_TYPES = "FILE_TYPES";

    public enum SourceType {
        GALLARY("GALLARY"),
        AUDIO("AUDIO"),
        VIDEO("VIDEO"),
        DOCUMENTS("DOCUMENTS"),
        GOOGLE_DRIVE("GOOGLE_DRIVE"),
        DROPBOX("DROPBOX");

        private String name;

        SourceType(String name) {
            this.name = name;
        }
    }

    public enum FileType {
        TYPE_MP3("audio/mp3"),
        TYPE_AMPEG("audio/mpeg"),
        TYPE_M4A("audio/m4a"),
        TYPE_WAV("audio/x-wav"),
        TYPE_AMR("audio/amr"),
        TYPE_AAC("audio/aac"),
        TYPE_MPEG("video/mpeg"),
        TYPE_MP4("video/mp4"),
        TYPE_M4V("video/m4v"),
        TYPE_3GP("video/3gp"),
        TYPE_3GPP("video/3gpp"),
        TYPE_WEBM("video/webm"),
        TYPE_AVI("video/avi"),
        TYPE_JPG("image/jpg"),
        TYPE_JPEG("image/jpeg"),
        TYPE_PNG("image/png"),
        TYPE_BMP("image/x-ms-bmp"),
        TYPE_WEBP("image/webp"),
        TYPE_TEXT("text/plain"),
        TYPE_PDF("application/pdf"),
        TYPE_DOC("application/msword"),
        TYPE_DOCX("application/vnd.openxmlformats-officedocument.wordprocessingml.document"),
        TYPE_XLS("application/vnd.ms-excel"),
        TYPE_XLSX("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"),
        TYPE_PPT("application/vnd.ms-powerpoint"),
        TYPE_PPTX("application/vnd.openxmlformats-officedocument.presentationml.presentation");

        private String type;

        FileType(String type) {
            this.type = type;
        }

        public static FileType getFromMime(String mime) {
            for (int i = 0; i < values().length; i++) {
                if (values()[i].getType().equals(mime)) {
                    return values()[i];
                }
            }
            throw new RuntimeException("File Type Not Found for " + mime);
        }

        public String getType() {
            return type;
        }
    }

    public interface Listener {
        void setReturnIntent(Intent intent);
    }

    public static class Builder {
        private Context context;
        private Intent mChooserIntent;
        private ArrayList<String> filetypes = new ArrayList<>();
        private Set<SourceType> sourceTypes = new HashSet<>();
        private boolean multiSelection = false, newFile = false, directoryFilter = false, allowCrop = false;
        private int pickable = 1;
        private BottomSheetDialog dialog;
        private View view;

        public Builder(Context context, ArrayList<FileType> fileTypes) {
            this.context = context;
            dialog = new BottomSheetDialog(context);
            dialog.setCancelable(true);
            dialog.setCanceledOnTouchOutside(true);
            view = ((LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE)).inflate(R.layout.dialog_directory_picker, null);

            for (FileType type : fileTypes)
                this.filetypes.add(type.getType());
        }

        public Builder allowNewFile() {
            newFile = true;
            return this;
        }

        public Builder addAllImageTypes() {
            this.filetypes.add(TYPE_JPG.getType());
            this.filetypes.add(TYPE_JPEG.getType());
            this.filetypes.add(TYPE_PNG.getType());
            this.filetypes.add(TYPE_BMP.getType());
            this.filetypes.add(TYPE_WEBP.getType());
            return this;
        }

        public Builder addAllDocumentTypes() {
            //this.filetypes.add(TYPE_TEXT.getType());
            this.filetypes.add(TYPE_PDF.getType());
            //this.filetypes.add(TYPE_DOC.getType());
            //this.filetypes.add(TYPE_DOCX.getType());
            //this.filetypes.add(TYPE_XLS.getType());
            //this.filetypes.add(TYPE_XLSX.getType());
            //this.filetypes.add(TYPE_PPT.getType());
            //this.filetypes.add(TYPE_PPTX.getType());
            return this;
        }

        public Builder addAllVideoTypes() {
            this.filetypes.add(TYPE_MPEG.getType());
            this.filetypes.add(TYPE_MP4.getType());
            this.filetypes.add(TYPE_M4V.getType());
            this.filetypes.add(TYPE_3GP.getType());
            this.filetypes.add(TYPE_3GPP.getType());
            this.filetypes.add(TYPE_WEBM.getType());
            this.filetypes.add(TYPE_AVI.getType());
            return this;
        }

        public Builder addAllAudioTypes() {
            this.filetypes.add(TYPE_MP3.getType());
            this.filetypes.add(TYPE_AMPEG.getType());
            this.filetypes.add(TYPE_M4A.getType());
            this.filetypes.add(TYPE_WAV.getType());
            this.filetypes.add(TYPE_AMR.getType());
            this.filetypes.add(TYPE_AAC.getType());
            return this;
        }

        public Builder addUsingMimeType(List<String> mimeTypes) {
            this.filetypes.addAll(mimeTypes);
            return this;
        }

        public Builder allowDirectoryFilter() {
            directoryFilter = true;
            return this;
        }

        public Builder allowCrop() {
            allowCrop = true;
            return this;
        }

        public Builder allowMultiSelection() {
            multiSelection = true;
            return this;
        }


        public Builder setFilesCount(int count) {
            pickable = count;
            return this;
        }

        public Builder addSourceType(SourceType type) {
            sourceTypes.add(type);
            return this;
        }

        public Builder addSourceTypeByName(String sourceTypeName) {
            sourceTypes.add(SourceType.valueOf(sourceTypeName));
            return this;
        }


        public Builder addFileTypesBySource(String sourceType) {
            if (Picker.SourceType.valueOf(sourceType) == Picker.SourceType.DOCUMENTS) {
                addAllDocumentTypes();
            } else if (Picker.SourceType.valueOf(sourceType) == Picker.SourceType.GALLARY) {
                addAllImageTypes();
            } else if (Picker.SourceType.valueOf(sourceType) == Picker.SourceType.VIDEO) {
                addAllVideoTypes();
            } else if (Picker.SourceType.valueOf(sourceType) == Picker.SourceType.AUDIO) {
                addAllAudioTypes();
            }
            return this;
        }


        public void start(Listener listener) {
            if (filetypes.isEmpty())
                throw new RuntimeException("Please add File types to be picked.");

            if (sourceTypes.size() == 0)
                throw new RuntimeException("Please set at least one Source Type.");

            if (sourceTypes.size() == 1) {
                setSourceType(listener, (SourceType) sourceTypes.toArray()[0]);
                return;
            }

            LinearLayout gallary = view.findViewById(R.id.llPickAlbums);
            LinearLayout audio = view.findViewById(R.id.llPickAudio);
            LinearLayout video = view.findViewById(R.id.llPickVideo);
            LinearLayout documents = view.findViewById(R.id.llPickDocuments);
            LinearLayout dropbox = view.findViewById(R.id.llPickDropbox);
            LinearLayout googleDrive = view.findViewById(R.id.llPickGoogleDrive);

            if (!sourceTypes.contains(SourceType.GALLARY)) {
                gallary.setVisibility(View.GONE);
            }

            if (!sourceTypes.contains(SourceType.AUDIO)) {
                audio.setVisibility(View.GONE);
            }

            if (!sourceTypes.contains(SourceType.VIDEO)) {
                video.setVisibility(View.GONE);
            }

            if (!sourceTypes.contains(SourceType.DOCUMENTS)) {
                documents.setVisibility(View.GONE);
            }

            if (!sourceTypes.contains(SourceType.DROPBOX)) {
                dropbox.setVisibility(View.GONE);
            }

            if (!sourceTypes.contains(SourceType.GOOGLE_DRIVE)) {
                googleDrive.setVisibility(View.GONE);
            }

            gallary.setOnClickListener(v -> {
                setSourceType(listener, SourceType.GALLARY);
                dialog.dismiss();
            });

            audio.setOnClickListener(v -> {
                setSourceType(listener, SourceType.AUDIO);
                dialog.dismiss();
            });

            video.setOnClickListener(v -> {
                setSourceType(listener, SourceType.VIDEO);
                dialog.dismiss();
            });

            documents.setOnClickListener(v -> {
                setSourceType(listener, SourceType.DOCUMENTS);
                dialog.dismiss();
            });

            dropbox.setOnClickListener(v -> {
                setSourceType(listener, SourceType.DROPBOX);
                dialog.dismiss();
            });

            googleDrive.setOnClickListener(v -> {
                setSourceType(listener, SourceType.GOOGLE_DRIVE);
                dialog.dismiss();
            });

            dialog.setContentView(view);
            dialog.show();
        }

        private void setSourceType(Listener listener, SourceType sourceType) {
            if (sourceType == SourceType.GALLARY) {
                mChooserIntent = ImagePickActivity.getActivityIntent(context, multiSelection, newFile, directoryFilter, allowCrop, pickable, filetypes);
                listener.setReturnIntent(mChooserIntent);
            } else if (sourceType == SourceType.AUDIO) {
                mChooserIntent = AudioPickActivity.getActivityIntent(context, multiSelection, newFile, directoryFilter, pickable, filetypes);
                listener.setReturnIntent(mChooserIntent);
            } else if (sourceType == SourceType.VIDEO) {
                mChooserIntent = VideoPickActivity.getActivityIntent(context, multiSelection, newFile, directoryFilter, pickable, allowCrop, filetypes);
                listener.setReturnIntent(mChooserIntent);
            } else if (sourceType == SourceType.DOCUMENTS) {
                mChooserIntent = NormalFilePickActivity.getActivityIntent(context, multiSelection, directoryFilter, pickable, filetypes);
                listener.setReturnIntent(mChooserIntent);
            } else if (sourceType == SourceType.DROPBOX) {
                mChooserIntent = PickDropboxFileActivity.getActivityIntent(context, filetypes, allowCrop);
                listener.setReturnIntent(mChooserIntent);
            } else if (sourceType == SourceType.GOOGLE_DRIVE) {
                mChooserIntent = PickDriveFileActivity.getActivityIntent(context, filetypes, allowCrop);
                listener.setReturnIntent(mChooserIntent);
            }
        }
    }


}
