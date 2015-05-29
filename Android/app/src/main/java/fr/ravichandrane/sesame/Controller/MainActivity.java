package fr.ravichandrane.sesame.Controller;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.ImageView;

import com.parse.ParseUser;

import butterknife.InjectView;
import fr.ravichandrane.sesame.R;


public class MainActivity extends Activity {

    @InjectView(R.id.imageButton) ImageView mButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        ParseUser currentuser = ParseUser.getCurrentUser();
        if(currentuser == null){
            navigationToLogin();
        }
        
    }

    private void navigationToLogin() {
        Intent loginIntent = new Intent(this, LoginActivity.class);
        loginIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        loginIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(loginIntent);
    }



}
