package fr.ravichandrane.sesame.Controller;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.widget.TextView;

import butterknife.ButterKnife;
import butterknife.InjectView;
import fr.ravichandrane.sesame.R;

public class OpenActivity extends AppCompatActivity {

    @InjectView(R.id.textOpenGarage) TextView mTextOpenGarage;
    @InjectView(R.id.msgOpenGarage) TextView mOpenGarage;

    //This activity show when the user presh on the open button
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_open);
        ButterKnife.inject(this);

        Bundle extras = getIntent().getExtras();
        if (extras != null) {
            String text = extras.getString("text");
            String msg = extras.getString("msg");
            mTextOpenGarage.setText(text);
            mOpenGarage.setText(msg);
        }

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
