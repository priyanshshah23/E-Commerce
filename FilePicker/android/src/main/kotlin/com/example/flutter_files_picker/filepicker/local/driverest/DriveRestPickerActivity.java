package com.example.flutter_files_picker.filepicker.local.driverest;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.example.flutter_files_picker.FlutterFilePickerPlugin;
import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.auth.api.signin.GoogleSignInClient;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.common.api.Scope;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Tasks;
import com.google.api.client.extensions.android.http.AndroidHttp;
import com.google.api.client.googleapis.extensions.android.gms.auth.GoogleAccountCredential;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.services.drive.Drive;
import com.google.api.services.drive.DriveScopes;
import com.google.api.services.drive.model.FileList;


import java.util.Collections;
import java.util.concurrent.Callable;
import java.util.concurrent.Executors;

public class DriveRestPickerActivity extends AppCompatActivity {

    private static final int REQUEST_CODE_SIGN_IN = 1;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);


        GoogleSignInOptions signInOptions =
                new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
                        .requestEmail()
                        .requestScopes(new Scope(DriveScopes.DRIVE_FILE))
                        .build();
        GoogleSignInClient client = GoogleSignIn.getClient(this, signInOptions);
        client.signOut().addOnSuccessListener(new OnSuccessListener<Void>() {
            @Override
            public void onSuccess(Void aVoid) {
                startActivityForResult(client.getSignInIntent(), REQUEST_CODE_SIGN_IN);
            }
        });

        /*if (client.getSignInIntent() == null)
            startActivityForResult(client.getSignInIntent(), REQUEST_CODE_SIGN_IN);
        else
            loadFiles(client.getSignInIntent());*/
        // The result of the sign-in Intent is handled in onActivityResult.


    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        loadFiles(data);
    }

    private void loadFiles(Intent data) {
        GoogleSignIn.getSignedInAccountFromIntent(data)
                .addOnSuccessListener(this, new OnSuccessListener<GoogleSignInAccount>() {
                    @Override
                    public void onSuccess(GoogleSignInAccount googleSignInAccount) {
                        GoogleAccountCredential credential = GoogleAccountCredential.usingOAuth2(DriveRestPickerActivity.this, Collections.singleton(DriveScopes.DRIVE_FILE));
                        credential.setSelectedAccount(googleSignInAccount.getAccount());
                        Drive driveService = new Drive.Builder(AndroidHttp.newCompatibleTransport(), new GsonFactory(), credential)
                                .setApplicationName(FlutterFilePickerPlugin.Companion.getAPPLICATION_NAME()).build();


                        Tasks.call(Executors.newSingleThreadExecutor(), new Callable<FileList>() {

                            @Override
                            public FileList call() throws Exception {
                                return driveService.files().list().setSpaces("drive").execute();
                            }
                        }).addOnSuccessListener(new OnSuccessListener<FileList>() {
                            @Override
                            public void onSuccess(FileList list) {
                                if (list != null) {
                                    for (int i = 0; i < list.getFiles().size(); i++) {
                                        Log.e("driveFile", list.getFiles().get(i).getName() + "");

                                    }
                                }
                            }
                        })
                                .addOnFailureListener(new OnFailureListener() {
                                    @Override
                                    public void onFailure(@NonNull Exception e) {
                                        e.printStackTrace();
                                    }
                                })
                        ;

                    }
                })
                .addOnFailureListener(new OnFailureListener() {
                    @Override
                    public void onFailure(@NonNull Exception e) {
                        e.printStackTrace();
                        Log.e("Error Message", e.getMessage());

                    }
                });

    }
}
