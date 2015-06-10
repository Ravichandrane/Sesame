package fr.ravichandrane.sesame.Helper;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

/**
 * Created by Ravi on 05/06/15.
 */
public class dateFromString {

    public dateFromString (){

    }

    public String datetoString(String time){
        DateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
        inputFormat.setTimeZone(TimeZone.getDefault());
        DateFormat outputFormat = new SimpleDateFormat("HH:mm");
        Date parsed = null;
        try {
            parsed = inputFormat.parse(time);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        return outputFormat.format(parsed);
    }

}
