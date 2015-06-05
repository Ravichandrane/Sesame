package fr.ravichandrane.sesame.Controller;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.TextView;

import com.parse.ParseUser;

import butterknife.ButterKnife;
import butterknife.InjectView;
import fr.ravichandrane.sesame.Fragment.FoyerFragment;
import fr.ravichandrane.sesame.Fragment.HomeFragment;
import fr.ravichandrane.sesame.Fragment.NavigationDrawerFragment;
import fr.ravichandrane.sesame.R;


public class MainActivity extends AppCompatActivity implements NavigationDrawerFragment.FragmentDrawerListener{

    private Toolbar mToolbar;
    private NavigationDrawerFragment mNavigationDrawerFragment;

    @InjectView(R.id.usernameNav) TextView mUsernameNav;
    @InjectView(R.id.useremailNav) TextView mUseremailNav;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ButterKnife.inject(this);

        //ParseUser.logOut();

        ParseUser currentuser = ParseUser.getCurrentUser();
        if(currentuser == null){
            login();
        }else{
            mUsernameNav.setText(currentuser.getUsername() +" "+currentuser.get("userfirstname"));
            mUseremailNav.setText(currentuser.getEmail());

            //Setup the toolbar
            mToolbar = (Toolbar) findViewById(R.id.app_bar);
            setSupportActionBar(mToolbar);

            //DrawerNavigation
            mNavigationDrawerFragment = (NavigationDrawerFragment)
                    getSupportFragmentManager().findFragmentById(R.id.fragment_navigation_drawer);
            mNavigationDrawerFragment.setUp(R.id.fragment_navigation_drawer,
                    (DrawerLayout) findViewById(R.id.drawer_layout),
                    mToolbar
            );
            mNavigationDrawerFragment.setDrawerListener(this);

            displayView(0);
        }
    }

    private void login() {
        Intent loginIntent = new Intent(this, LoginActivity.class);
        loginIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        loginIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(loginIntent);
    }

    @Override
    public void onDrawerItemSelected(View view, int position) {
        displayView(position);
    }

    private void displayView(int position) {
        Fragment fragment = null;
        String title = getString(R.string.app_name);
        switch (position) {
            case 0:
                fragment = new HomeFragment();
                title = getString(R.string.app_name);
                break;
            case 1:
                fragment = new FoyerFragment();
                title = getString(R.string.title_foyer);
                break;
            case 2:
                break;
            case 3:
                login();
                ParseUser.logOut();
                break;
            default:
                break;
        }

        if (fragment != null) {
            FragmentManager fragmentManager = getSupportFragmentManager();
            FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
            fragmentTransaction.replace(R.id.container_body, fragment);
            fragmentTransaction.commit();

            getSupportActionBar().setTitle(title);
        }
    }

}
