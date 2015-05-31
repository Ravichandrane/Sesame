package fr.ravichandrane.sesame.Controller;

import android.app.AlertDialog;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.EditText;
import android.widget.Toast;

import com.parse.ParseException;
import com.parse.ParseUser;
import com.parse.SignUpCallback;

import butterknife.ButterKnife;
import butterknife.InjectView;
import fr.ravichandrane.sesame.R;

public class NewUserActivity extends AppCompatActivity {

    private Toolbar mToolbar;
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
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }
        if (id == R.id.action_addUser){
            String username = mUsername.getText().toString();
            String userfirstname = mUserfirstname.getText().toString();
            String useremail = mUsermail.getText().toString();
            String password = mPassword.getText().toString();

            username = useremail.trim();
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
                newUser.setUsername(username);
                newUser.setEmail(useremail);
                newUser.setPassword(password);
                newUser.put("userfirstname", userfirstname);

                newUser.signUpInBackground(new SignUpCallback() {
                    @Override
                    public void done(ParseException e) {
                        if (e == null){
                            mUsername.setText("");
                            mUserfirstname.setText("");
                            mUsermail.setText("");
                            mPassword.setText("");

                            Toast.makeText(getApplicationContext(), "Nouveau utilisateur ajouté", Toast.LENGTH_LONG).show();
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
