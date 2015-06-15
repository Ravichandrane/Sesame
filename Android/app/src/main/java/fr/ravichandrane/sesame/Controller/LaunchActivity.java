package fr.ravichandrane.sesame.Controller;

import android.annotation.TargetApi;
import android.app.ActionBar;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.view.View;

import com.parse.ParseUser;

import fr.ravichandrane.sesame.R;

public class LaunchActivity extends AppCompatActivity {

    private static int SPLASH_TIME_OUT = 3000;
    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_launch);

        View decorView = getWindow().getDecorView();
        // Hide the status bar.
        int uiOptions = View.SYSTEM_UI_FLAG_FULLSCREEN;
        decorView.setSystemUiVisibility(uiOptions);
        ActionBar actionBar = getActionBar();
        if (actionBar != null) {
            actionBar.hide();
        }

        final SharedPreferences settings=getSharedPreferences("prefs",0);
        boolean firstRun=settings.getBoolean("firstRun",false);
        //Check if the user opened the App for the first time
        if(!firstRun){
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    // This method will be executed once the timer is over
                    // Start the Splash activity
                    SharedPreferences.Editor editor = settings.edit();
                    editor.putBoolean("firstRun", true);
                    editor.apply();
                    Intent intent = new Intent(LaunchActivity.this, SplashActivity.class);
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
                    startActivity(intent);
                    finish();
                }
            }, SPLASH_TIME_OUT);
        }else {
            ParseUser currentuser = ParseUser.getCurrentUser();
            if(currentuser == null){
                Intent a=new Intent(LaunchActivity.this,LoginActivity.class);
                startActivity(a);
                finish();
            }else{
                Intent a=new Intent(LaunchActivity.this,MainActivity.class);
                startActivity(a);
                finish();
            }
        }
    }


}
