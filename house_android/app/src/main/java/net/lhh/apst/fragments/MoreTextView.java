package net.lhh.apst.fragments;

import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.widget.TextView;

import net.lhh.apst.advancedpagerslidingtabstrip.R;

/**
 * Created by ld on 15/10/2017.
 */

public class MoreTextView extends TextView {

    private  boolean checked = false;

    public MoreTextView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        // TODO Auto-generated constructor stub
    }
    public MoreTextView(Context context, AttributeSet attrs) {
        super(context, attrs);
        // TODO Auto-generated constructor stub
    }
    public MoreTextView(Context context) {
        super(context);
        // TODO Auto-generated constructor stub
    }

    public void setChecked(boolean checked) {
        this.checked = checked;
        if(getChecked()){
            setBackgroundColor(getResources().getColor(R.color.green));
            setTextColor(getResources().getColor(R.color.white));
        }else{
            setBackgroundColor(getResources().getColor(R.color.globgray));
            setTextColor(getResources().getColor(R.color.black));
        }
    }

    public boolean getChecked() {
        return checked;
    }
}
