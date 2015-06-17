package fr.ravichandrane.sesame.Fragment;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.ListFragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import com.parse.FindCallback;
import com.parse.ParseException;
import com.parse.ParseQuery;
import com.parse.ParseRelation;
import com.parse.ParseUser;

import java.util.List;

import fr.ravichandrane.sesame.Adapter.FoyerAdapter;
import fr.ravichandrane.sesame.Controller.EditActivity;
import fr.ravichandrane.sesame.R;

/**
 * Created by Ravi on 04/06/15.
 */
public class FoyerFragment extends ListFragment{

    protected List<ParseUser> mUsers;
    protected ParseRelation<ParseUser> mUserParseRelation;
    protected ParseUser mCurrentUser;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.foyer_fragment, container, false);
        // Inflate the layout for this fragment
        return rootView;
    }

    @Override
    public void onResume() {
        super.onResume();

        ParseQuery<ParseUser> query = ParseUser.getQuery();
        query.findInBackground(new FindCallback<ParseUser>() {
            @TargetApi(Build.VERSION_CODES.KITKAT)
            @Override
            public void done(List<ParseUser> users, ParseException e) {
                if(e == null){
                    mUsers = users;
                    String [] usernames = new String[mUsers.size()];
                    int i = 0;
                    for (ParseUser user : mUsers){
                        usernames[i] = String.valueOf(user.get("userfirstname")) + " " + user.get("userlastname");
                        i++;
                    }
                    FoyerAdapter adapter = new FoyerAdapter(getListView().getContext(), mUsers);
                    setListAdapter(adapter);
                }else{
                    AlertDialog.Builder builder = new AlertDialog.Builder(getListView().getContext())
                            .setTitle(getString(R.string.error_title))
                            .setMessage(e.getMessage())
                            .setPositiveButton(getString(R.string.error_cancelMsg), null);
                    AlertDialog dialog = builder.create();
                    dialog.show();
                }
            }
        });


    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        // Inflate the menu; this adds items to the action bar if it is present.
        super.onCreateOptionsMenu(menu, inflater);
        inflater.inflate(R.menu.menu_foyer, menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();

        if (id == R.id.action_edit){
            Intent editIntent = new Intent(getListView().getContext(), EditActivity.class);
            startActivity(editIntent);
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
    }

    @Override
    public void onDetach() {
        super.onDetach();
    }


    @Override
    public void onListItemClick(ListView l, View v, int position, long id) {
        super.onListItemClick(l, v, position, id);
        Log.v("Click", String.valueOf(position));
    }
}
