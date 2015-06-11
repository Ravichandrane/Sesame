package fr.ravichandrane.sesame.Controller;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;

import com.parse.ParseUser;

import fr.ravichandrane.sesame.R;

public class LaunchActivity extends ActionBarActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_launch);

        SharedPreferences settings=getSharedPreferences("prefs",0);
        boolean firstRun=settings.getBoolean("firstRun",false);
        if(!firstRun){
            SharedPreferences.Editor editor=settings.edit();
            editor.putBoolean("firstRun",true);
            editor.apply();
            Intent i = new Intent(LaunchActivity.this, SplashActivity.class);
            startActivity(i);
            finish();
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
