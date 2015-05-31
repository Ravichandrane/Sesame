package fr.ravichandrane.sesame.Controller;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.ImageView;

import com.parse.ParseUser;

import butterknife.ButterKnife;
import butterknife.InjectView;
import fr.ravichandrane.sesame.Fragment.NavigationDrawerFragment;
import fr.ravichandrane.sesame.R;


public class MainActivity extends AppCompatActivity {

    public static final String TAG = MainActivity.class.getSimpleName();

    private Toolbar mToolbar;
    private NavigationDrawerFragment mNavigationDrawerFragment;

    @InjectView(R.id.buttonOpenDoor) ImageView mButtonOpenDoor;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ButterKnife.inject(this);

        ParseUser currentuser = ParseUser.getCurrentUser();
        if(currentuser == null){
            Intent loginIntent = new Intent(this, LoginActivity.class);
            loginIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            loginIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
            startActivity(loginIntent);
        }

        //Setup the toolbar
        mToolbar = (Toolbar) findViewById(R.id.toolBar);
        setSupportActionBar(mToolbar);

        // Creat the drawer navigation
        mNavigationDrawerFragment = (NavigationDrawerFragment)
                getSupportFragmentManager().findFragmentById(R.id.fragment_navigation_drawer);
        mNavigationDrawerFragment.setUp(
                (DrawerLayout) findViewById(R.id.drawer_layout),
                mToolbar
        );

        mButtonOpenDoor.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MainActivity.this, NewUserActivity.class);
                startActivity(intent);
            }
        });


    }

}
