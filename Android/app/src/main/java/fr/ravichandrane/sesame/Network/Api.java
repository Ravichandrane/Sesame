package fr.ravichandrane.sesame.Network;

import com.parse.ParseUser;
import com.squareup.okhttp.Call;
import com.squareup.okhttp.Callback;
import com.squareup.okhttp.FormEncodingBuilder;
import com.squareup.okhttp.OkHttpClient;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.RequestBody;
import com.squareup.okhttp.Response;

import org.json.JSONException;

import java.io.IOException;

/**
 * Created by Ravi on 31/05/15.
 */
public class Api {

    private OkHttpClient client;

    public Api(){
        this.client = new OkHttpClient();
    }

    public void getState(final ApiCallback cb) {
        String url = "http://raspberry.pierre-olivier.fr:3000/garage/status";
        Request request = new Request.Builder().url(url).get().build();
        String onError = "Impossible";
        call(request, onError, cb);
    }

    public void toggleDoor(final ApiCallback cb){
        ParseUser User = ParseUser.getCurrentUser();
        String userId = (String) User.get("userfirstname");
        String url = "http://raspberry.pierre-olivier.fr:3000/garage/toggle";
        RequestBody formBody = new FormEncodingBuilder().add("authenticate", userId).build();
        Request request = new Request.Builder().url(url).post(formBody).build();
        String onError = "Impossible d'ouvrir";
        call(request, onError, cb);
    }

     // CALL REQUEST
    private void call(Request request, final String error, final ApiCallback cb){
        Call call = this.client.newCall(request);
        call.enqueue(new Callback() {
            public void onFailure(Request request, IOException e) {
                cb.onFailure(error);
            }

            public void onResponse(Response response) throws IOException {
                try {
                    if (response.isSuccessful()) {
                        cb.onSuccess(response);
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });
    }

    // API CALLBACK INTERFACE
    public interface ApiCallback{
        public void onFailure(String error);
        public void onSuccess(Response response) throws IOException, JSONException;
    }

}
