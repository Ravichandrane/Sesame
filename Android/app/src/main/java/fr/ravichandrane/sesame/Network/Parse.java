package fr.ravichandrane.sesame.Network;

import android.app.Application;

/**
 * Created by Ravi on 30/05/15.
 */
public class Parse extends Application{

    @Override
    public void onCreate() {
        super.onCreate();
        com.parse.Parse.enableLocalDatastore(this);
        com.parse.Parse.initialize(this, "PARSE_ID", "PARSE_KEY");
    }

}
