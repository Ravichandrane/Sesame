package fr.ravichandrane.sesame.Fragment;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Vibrator;
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
import java.util.Timer;
import java.util.TimerTask;

import fr.ravichandrane.sesame.Controller.OpenActivity;
import fr.ravichandrane.sesame.Helper.dateFromString;
import fr.ravichandrane.sesame.Model.HomeModel;
import fr.ravichandrane.sesame.Model.StatusCodeModel;
import fr.ravichandrane.sesame.Network.Api;
import fr.ravichandrane.sesame.R;

/**
 * Created by Ravi on 04/06/15.
 */
public class HomeFragment extends Fragment {

    private Timer timer;
    private TimerTask timerTask;

    private HomeModel mHomeModel;
    private StatusCodeModel mStatusCodeModel;

    protected TextView mStatus;
    protected TextView mInfoOpenedText;
    protected ImageView mButtonOpen;


    Boolean flag=false;

    public HomeFragment() {
        // Required empty public constructor
    }

    public void onPause(){
        super.onPause();
        timer.cancel();
    }

    public void onResume(){
        super.onResume();
        try {
            timer = new Timer();
            timerTask = new TimerTask() {
                @Override
                public void run() {
                    //Download file here and refresh
                    getStatus();
                }
            };
            timer.schedule(timerTask, 1000, 1000);
        } catch (IllegalStateException e){
            android.util.Log.i("Damn", "resume error");
        }
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


        getStatus();

        mButtonOpen.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openDoor();
                Vibrator vibration = (Vibrator) getActivity().getSystemService(Context.VIBRATOR_SERVICE);
                vibration.vibrate(400);
                if(flag==false) {
                    mButtonOpen.setImageResource(R.drawable.button_open);
                    flag=true;
                }
                else{
                    mButtonOpen.setImageResource(R.drawable.button_close);
                    flag=false;
                }
            }
        });

        // Inflate the layout for this fragment
        return rootView;
    }
    private void getStatus() {
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
                    if (response.isSuccessful()) {
                        mHomeModel = getCurrentDetails(jsonData);
                        getActivity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                updateData();
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
    }

    private void openDoor() {
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
                        //Log.v("Data :", jsonData);
                        mStatusCodeModel = getStatusCode(jsonData);
                        getActivity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                updateData();
                            }
                        });

                        int StatusCode = mStatusCodeModel.getStatusCode();
                        Context context = getActivity();
                        if (StatusCode == 4) {
                            openDoor(context.getString(R.string.txt_open), context.getString(R.string.msg_open));
                        } else {
                            openDoor(context.getString(R.string.text_close), context.getString(R.string.msg_close));
                        }
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
    }


    private HomeModel getCurrentDetails(String jsonData) throws JSONException{
        JSONObject status = new JSONObject(jsonData);
        HomeModel homeModel = new HomeModel();
        homeModel.setStatusText(status.getString("status_text"));
        homeModel.setLasterUser(status.getString("lastUser"));
        homeModel.setTime(status.getString("lastOpen"));
        return homeModel;
    }

    private void updateData() {
        dateFromString date = new dateFromString();
        mStatus.setText("État : " + mHomeModel.getStatusText());
        mInfoOpenedText.setText("À " + date.datetoString(mHomeModel.getTime()) + " par " + mHomeModel.getLasterUser());
    }

    private StatusCodeModel getStatusCode(String jsonData) throws JSONException {
        JSONObject status = new JSONObject(jsonData);
        JSONObject statusCode = status.getJSONObject("response");
        StatusCodeModel mStatus = new StatusCodeModel();
        mStatus.setStatusCode(statusCode.getInt("status_code"));
        return mStatus;
    }

    private void openDoor(String text, String msg) {
        Intent startActivity = new Intent(getActivity(), OpenActivity.class);
        startActivity.putExtra("text", text);
        startActivity.putExtra("msg", msg);
        startActivity(startActivity);
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
