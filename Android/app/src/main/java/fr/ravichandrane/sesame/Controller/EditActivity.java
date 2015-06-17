package fr.ravichandrane.sesame.Controller;

import android.app.AlertDialog;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.parse.FindCallback;
import com.parse.GetCallback;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.rey.material.widget.Slider;

import java.util.List;

import butterknife.ButterKnife;
import butterknife.InjectView;
import fr.ravichandrane.sesame.R;

public class EditActivity extends AppCompatActivity {

    private Toolbar mToolbar;
    @InjectView(R.id.nameGarage) EditText mNameGarage;
    @InjectView(R.id.radiusMeter) Slider mRadiusMeter;
    @InjectView(R.id.numCode) TextView mNumCode;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit);
        ButterKnife.inject(this);

        //Setup the toolbar
        mToolbar = (Toolbar) findViewById(R.id.toolBar);
        setSupportActionBar(mToolbar);
        assert getSupportActionBar() != null;
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        getInfo();

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_new_profil, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();

        //Save the data into parse
        if (id == R.id.action_addNewProfil) {
            updateInfo();
        }

        return super.onOptionsItemSelected(item);
    }

    //Get data from parse
    private void getInfo() {
        ParseQuery<ParseObject> query = ParseQuery.getQuery("Homes");
        query.whereEqualTo("objectId", "5synbJmdMW");
        query.findInBackground(new FindCallback<ParseObject>() {
            public void done(List<ParseObject> data, ParseException e) {
                if (e == null) {
                    for (ParseObject dataObject : data) {
                        mNameGarage.setText(dataObject.getString("name"));
                        mRadiusMeter.setValue(dataObject.getInt("radius"), true);
                        mNumCode.setText(dataObject.getObjectId());
                    }
                } else {
                    Log.d("score", "Error: " + e.getMessage());
                }
            }
        });
    }

    //Update data to parse
    private void updateInfo() {
        String nameGarage = mNameGarage.getText().toString();
        int numberRadius = mRadiusMeter.getValue();

        nameGarage = nameGarage.trim();

        if (nameGarage.isEmpty()){
            //Alert message
            AlertDialog.Builder builder = new AlertDialog.Builder(EditActivity.this)
                    .setTitle(R.string.error_title)
                    .setMessage(R.string.error_message)
                    .setPositiveButton(R.string.error_cancelMsg, null);
            AlertDialog dialog = builder.create();
            dialog.show();
        }else{
            //Update Data
            ParseQuery<ParseObject> query = ParseQuery.getQuery("Homes");
            final String finalNameGarage = nameGarage;
            final int finalNumberRadius = numberRadius;
            query.getInBackground("5synbJmdMW", new GetCallback<ParseObject>() {
                @Override
                public void done(ParseObject parseObject, ParseException e) {
                    if (e == null) {
                        parseObject.put("name", finalNameGarage);
                        parseObject.put("radius", finalNumberRadius);
                        parseObject.saveInBackground();
                        Toast.makeText(getApplicationContext(), "Garage à jour", Toast.LENGTH_LONG).show();
                    }
                }
            });
        }
    }
}
