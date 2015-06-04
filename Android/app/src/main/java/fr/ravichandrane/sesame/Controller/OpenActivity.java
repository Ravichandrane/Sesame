package fr.ravichandrane.sesame.Controller;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;

import android.os.Handler;

import fr.ravichandrane.sesame.R;

public class OpenActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_open);

        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                Intent startActivity = new Intent(OpenActivity.this, MainActivity.class);
                startActivity(startActivity);
                finish();
            }
        }, 10000);

    }


}
