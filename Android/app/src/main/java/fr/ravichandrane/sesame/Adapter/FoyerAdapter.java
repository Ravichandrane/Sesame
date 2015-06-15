package fr.ravichandrane.sesame.Adapter;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.parse.ParseObject;
import com.parse.ParseUser;

import java.util.List;
import java.util.Objects;

import fr.ravichandrane.sesame.R;

/**
 * Created by Ravi on 15/06/15.
 */
public class FoyerAdapter extends ArrayAdapter<ParseUser> {

    protected Context mContext;
    protected List<ParseUser> mUsers;
    protected ParseUser mCurrentUser;

    public FoyerAdapter(Context context, List<ParseUser> users){
        super(context, R.layout.foyer_item, users);
        mContext = context;
        mUsers = users;
    }

    @TargetApi(Build.VERSION_CODES.KITKAT)
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        if(convertView == null) {
            convertView = LayoutInflater.from(mContext).inflate(R.layout.foyer_item, null);
            holder = new ViewHolder();
            holder.ownernameLabel = (TextView) convertView.findViewById(R.id.ownername);
            //holder.ownerLabel = (TextView) convertView.findViewById(R.id.owner);
            convertView.setTag(holder);
        }else {
            holder = (ViewHolder) convertView.getTag();
        }

        mCurrentUser = ParseUser.getCurrentUser();
        ParseObject user = mUsers.get(position);

        holder.ownernameLabel.setText(user.getString("userfirstname")+" "+user.getString("userlastname"));
        if(Objects.equals(user.getObjectId(), mCurrentUser.getObjectId())){
            holder.ownernameLabel.setText(user.getString("userfirstname")+" "+user.getString("userlastname")+" "+"(vous)");
        }
        return convertView;
    }

    private static class ViewHolder{
        TextView ownernameLabel;
        //TextView ownerLabel;
    }
}
