package fr.ravichandrane.sesame.Network;

import com.squareup.okhttp.OkHttpClient;

/**
 * Created by Ravi on 31/05/15.
 */
public class Api {

    private static OkHttpClient client = new OkHttpClient();
    private static String stateUrl = "http://raspberry.pierre-olivier.fr:3000/garage/status";


}
