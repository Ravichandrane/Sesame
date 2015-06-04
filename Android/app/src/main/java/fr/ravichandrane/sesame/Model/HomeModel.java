package fr.ravichandrane.sesame.Model;

/**
 * Created by Ravi on 04/06/15.
 */
public class HomeModel {
    private String mLasterUser;
    private String mStatusText;
    private String mTime;
    private int mStatusCode;

    public String getLasterUser() {
        return mLasterUser;
    }

    public void setLasterUser(String lasterUser) {
        mLasterUser = lasterUser;
    }

    public String getStatusText() {
        return mStatusText;
    }

    public void setStatusText(String statusText) {
        mStatusText = statusText;
    }

    public String getTime() {
        return mTime;
    }

    public void setTime(String time) {
        mTime = time;
    }

}
