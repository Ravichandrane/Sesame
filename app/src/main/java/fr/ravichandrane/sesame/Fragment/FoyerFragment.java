package fr.ravichandrane.sesame.Fragment;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import com.parse.FindCallback;
import com.parse.ParseException;
import com.parse.ParseQuery;
import com.parse.ParseUser;

import java.util.List;

import fr.ravichandrane.sesame.Controller.EditActivity;
import fr.ravichandrane.sesame.R;

/**
 * Created by Ravi on 04/06/15.
 */
public class FoyerFragment extends Fragment{

    protected List<ParseUser> mUsers;
    protected ListView mListView;

    public FoyerFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.foyer_fragment, container, false);

        mListView = (ListView) rootView.findViewById(R.id.listUsers);

        ParseQuery<ParseUser> query = ParseUser.getQuery();
        query.orderByAscending("userfirstname");
        query.setLimit(1000);
        query.findInBackground(new FindCallback<ParseUser>() {
            @Override
            public void done(List<ParseUser> users, ParseException e) {
                if(e == null){
                    mUsers = users;
                    String[] userList = new String[mUsers.size()];
                    int i = 0;
                    for (ParseUser user: mUsers){
                        userList[i] = String.valueOf(user.get("userfirstname")) +" "+ user.get("userlastname");
                        i++;
                    }
                    ArrayAdapter<String> adapter = new ArrayAdapter<String>(getActivity().getApplicationContext(),
                            R.layout.custom_textview,
                            userList);
                    mListView.setAdapter(adapter);
                }else{
                    AlertDialog.Builder builder = new AlertDialog.Builder(getActivity().getApplicationContext())
                            .setTitle(getString(R.string.error_title))
                            .setMessage(e.getMessage())
                            .setPositiveButton(getString(R.string.error_cancelMsg), null);
                    AlertDialog dialog = builder.create();
                    dialog.show();
                }
            }
        });
        // Inflate the layout for this fragment
        return rootView;
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
            Intent editIntent = new Intent(getActivity().getApplicationContext(), EditActivity.class);
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
}
