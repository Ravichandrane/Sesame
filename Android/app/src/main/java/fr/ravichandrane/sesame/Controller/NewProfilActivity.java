package fr.ravichandrane.sesame.Controller;

import android.app.AlertDialog;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.EditText;
import android.widget.Toast;

import com.parse.ParseObject;
import com.rengwuxian.materialedittext.MaterialEditText;
import com.rey.material.widget.Slider;

import butterknife.ButterKnife;
import butterknife.InjectView;
import fr.ravichandrane.sesame.R;

public class NewProfilActivity extends AppCompatActivity {

    private Toolbar mToolbar;
    @InjectView(R.id.rankField) EditText mRank;
    @InjectView(R.id.startimer) MaterialEditText mStartTimer;
    @InjectView(R.id.endTimer) MaterialEditText mEndTimer;
    @InjectView(R.id.radiusMeter) Slider mRadiusMeter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_new_profil);
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
        getMenuInflater().inflate(R.menu.menu_new_profil, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_addNewProfil) {
            String rank = mRank.getText().toString();
            String startTimer = mStartTimer.getText().toString();
            String endTimer = mEndTimer.getText().toString();
            int radiusMeters = mRadiusMeter.getValue();

            rank = rank.trim();
            startTimer = startTimer.trim();
            endTimer = endTimer.trim();

            if (rank.isEmpty() || startTimer.isEmpty() || endTimer.isEmpty()){
                //Alert message
                AlertDialog.Builder builder = new AlertDialog.Builder(NewProfilActivity.this)
                        .setTitle(R.string.error_title)
                        .setMessage(R.string.error_message)
                        .setPositiveButton(R.string.error_cancelMsg,null);
                AlertDialog dialog = builder.create();
                dialog.show();
            }else{
                //Add Data
                ParseObject newProfil = new ParseObject("NewProfil");
                newProfil.put("rank",rank);
                newProfil.put("startTimer", startTimer);
                newProfil.put("endTimer", endTimer);
                newProfil.put("meters", radiusMeters);
                newProfil.saveInBackground();

                //Clean data from the view
                mRank.setText("");
                mStartTimer.setText("");
                mEndTimer.setText("");
                mRadiusMeter.setValue(0, true);

                //Toast to infor the user
                Toast.makeText(getApplicationContext(), "Nouveau profil ajouté", Toast.LENGTH_LONG).show();
            }

        }

        return super.onOptionsItemSelected(item);
    }
}
