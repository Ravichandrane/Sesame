package fr.ravichandrane.sesame.Fragment;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.squareup.okhttp.Response;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;

import fr.ravichandrane.sesame.Controller.OpenActivity;
import fr.ravichandrane.sesame.Model.HomeModel;
import fr.ravichandrane.sesame.Network.Api;
import fr.ravichandrane.sesame.R;

/**
 * Created by Ravi on 04/06/15.
 */
public class HomeFragment extends Fragment {

    private HomeModel mHomeModel;

    protected TextView mStatus;
    protected TextView mInfoOpenedText;
    protected ImageView mButtonOpen;


    public HomeFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.home_fragment, container, false);

        mStatus = (TextView) rootView.findViewById(R.id.doorState);
        mInfoOpenedText = (TextView) rootView.findViewById(R.id.infoOpenedText);
        mButtonOpen = (ImageView) rootView.findViewById(R.id.buttonOpenDoor);

        Api api = new Api();
        api.getState(new Api.ApiCallback() {
            @Override
            public void onFailure(String error) {
                Log.e("error", "oups");
            }

            @Override
            public void onSuccess(final Response response) throws IOException {
                try {
                    String jsonData = response.body().string();
                    if (response.isSuccessful()){
                        mHomeModel = getCurrentDetails(jsonData);
                        getActivity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                updateDisplay();
                            }
                        });
                    }else{
                        Log.e("error","oups");
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                } catch (JSONException e){
                    e.printStackTrace();
                }
            }
        });

        mButtonOpen.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Api toggle = new Api();
                toggle.toggleDoor(new Api.ApiCallback() {
                    @Override
                    public void onFailure(String error) {
                        Log.e("Error:", error);
                    }

                    @Override
                    public void onSuccess(final Response response) throws IOException {
                        try {
                            String jsonData = response.body().string();
                            if (response.isSuccessful()) {
                                Log.v("Data :", jsonData);
                                mHomeModel = getCurrentDetails(jsonData);
                                getActivity().runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        updateDisplay();
                                    }
                                });
                            } else {
                                Log.e("error", "oups");
                            }
                        } catch (IOException e) {
                            e.printStackTrace();
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                });

                Intent startActivity = new Intent(getActivity(), OpenActivity.class);
                startActivity(startActivity);
            }
        });

        // Inflate the layout for this fragment
        return rootView;
    }

    private void updateDisplay() {
        mStatus.setText("État : "+ mHomeModel.getStatusText());
        mInfoOpenedText.setText("À " + mHomeModel.getTime() + " par " + mHomeModel.getLasterUser());
    }

    private HomeModel getCurrentDetails(String jsonData) throws JSONException{
        JSONObject status = new JSONObject(jsonData);
        HomeModel homeModel = new HomeModel();
        homeModel.setStatusText(status.getString("status_text"));
        homeModel.setLasterUser(status.getString("lastUser"));
        homeModel.setTime(status.getString("lastOpen"));
        return homeModel;
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
