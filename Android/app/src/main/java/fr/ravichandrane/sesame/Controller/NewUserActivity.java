package fr.ravichandrane.sesame.Controller;

import android.app.AlertDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.EditText;

import com.parse.ParseException;
import com.parse.ParseUser;
import com.parse.SignUpCallback;

import butterknife.ButterKnife;
import butterknife.InjectView;
import fr.ravichandrane.sesame.R;

public class NewUserActivity extends AppCompatActivity {

    private Toolbar mToolbar;
    @InjectView(R.id.usernickNameField) EditText mUserNickName;
    @InjectView(R.id.usernameField) EditText mUsername;
    @InjectView(R.id.userfirstnameField) EditText mUserfirstname;
    @InjectView(R.id.useremailField) EditText mUsermail;
    @InjectView(R.id.passwordField) EditText mPassword;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_new_user);
        ButterKnife.inject(this);

        //Setup the toolbar
        mToolbar = (Toolbar) findViewById(R.id.toolBar);
        setSupportActionBar(mToolbar);
        assert getSupportActionBar() != null;
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_new_user, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();

        //Create new user
        if (id == R.id.action_addUser){
            String userNickName = mUserNickName.getText().toString();
            String username = mUsername.getText().toString();
            String userfirstname = mUserfirstname.getText().toString();
            String useremail = mUsermail.getText().toString();
            String password = mPassword.getText().toString();

            userNickName = userNickName.trim();
            username = username.trim();
            userfirstname = userfirstname.trim();
            useremail = useremail.trim();
            password = password.trim();

            if (username.isEmpty() || userfirstname.isEmpty() || useremail.isEmpty() || password.isEmpty()){
                AlertDialog.Builder builder = new AlertDialog.Builder(NewUserActivity.this)
                        .setTitle(R.string.error_title)
                        .setMessage(R.string.error_message)
                        .setPositiveButton(R.string.error_cancelMsg,null);
                AlertDialog dialog = builder.create();
                dialog.show();
            }else{
                ParseUser newUser = new ParseUser();
                newUser.setUsername(userNickName);
                newUser.put("userlastname", username);
                newUser.put("userfirstname", userfirstname);
                newUser.setEmail(useremail);
                newUser.setPassword(password);

                newUser.signUpInBackground(new SignUpCallback() {
                    @Override
                    public void done(ParseException e) {
                        if (e == null){
                            mUserNickName.setText("");
                            mUsername.setText("");
                            mUserfirstname.setText("");
                            mUsermail.setText("");
                            mPassword.setText("");

                            Intent mainIntent = new Intent(NewUserActivity.this, MainActivity.class);
                            mainIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                            mainIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
                            startActivity(mainIntent);

                        }else{
                            AlertDialog.Builder builder = new AlertDialog.Builder(NewUserActivity.this)
                                    .setTitle(R.string.error_title)
                                    .setMessage(e.getMessage())
                                    .setPositiveButton(R.string.error_cancelMsg,null);
                            AlertDialog dialog = builder.create();
                            dialog.show();
                        }
                    }
                });
            }

        }

        return super.onOptionsItemSelected(item);
    }
}
