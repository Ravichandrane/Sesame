package fr.ravichandrane.sesame.Controller;

import android.app.AlertDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.parse.LogInCallback;
import com.parse.ParseException;
import com.parse.ParseUser;

import butterknife.ButterKnife;
import butterknife.InjectView;
import fr.ravichandrane.sesame.R;

public class LoginActivity extends AppCompatActivity {

    @InjectView(R.id.userfirstname) EditText mUsername;
    @InjectView(R.id.userpassword) EditText mUserpassword;
    @InjectView(R.id.signInButton) Button mSiginButton;
    @InjectView(R.id.createAccoutn) Button mCreateAccount;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        ButterKnife.inject(this);

        mSiginButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String username = mUsername.getText().toString();
                String password = mUserpassword.getText().toString();

                username = username.trim();
                password = password.trim();

                if (username.isEmpty() || password.isEmpty()) {
                    //Alert message if input are empty
                    AlertDialog.Builder builder = new AlertDialog.Builder(LoginActivity.this)
                            .setTitle(R.string.error_title)
                            .setMessage(R.string.error_message)
                            .setPositiveButton(R.string.error_cancelMsg, null);
                    AlertDialog dialog = builder.create();
                    dialog.show();
                } else {
                    //Login
                    ParseUser.logInInBackground(username, password, new LogInCallback() {
                        @Override
                        public void done(ParseUser parseUser, ParseException e) {
                            if (e == null) {
                                //Success!
                                Intent mainIntent = new Intent(LoginActivity.this, MainActivity.class);
                                mainIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                                mainIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
                                startActivity(mainIntent);
                                finish();
                            } else {
                                //Error :(
                                AlertDialog.Builder builder = new AlertDialog.Builder(LoginActivity.this)
                                        .setTitle(getString(R.string.error_title))
                                        .setMessage(e.getMessage())
                                        .setPositiveButton(getString(R.string.error_cancelMsg), null);
                                AlertDialog dialog = builder.create();
                                dialog.show();
                            }
                        }
                    });
                }

            }
        });

        mCreateAccount.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent createAccountIntent = new Intent(LoginActivity.this, NewUserActivity.class);
                startActivity(createAccountIntent);
            }
        });


    }

}
