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
        com.parse.Parse.initialize(this, "d5nDyqrsIam1tkgHSEv1TB3mNDFBLVV0qOv6Gon4", "Vh6bATHzAzkxR6r3PXWJlNXkcfOjQRKKfPChZecN");
    }




}
