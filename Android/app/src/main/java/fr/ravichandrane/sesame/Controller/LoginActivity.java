package fr.ravichandrane.sesame.Controller;

import android.app.Activity;
import android.graphics.Typeface;
import android.os.Bundle;
import android.widget.TextView;

import butterknife.ButterKnife;
import butterknife.InjectView;
import fr.ravichandrane.sesame.R;


public class LoginActivity extends Activity {

    @InjectView(R.id.homeTitle) TextView mHomeTitle;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        ButterKnife.inject(this);

        //Set SourceSans Pro font
        Typeface sourceSansPro = Typeface.createFromAsset(getAssets(), "fonts/SourceSansPro-Bold.ttf");
        mHomeTitle.setTypeface(sourceSansPro);



    }

}
