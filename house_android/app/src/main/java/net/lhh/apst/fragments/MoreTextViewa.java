package net.lhh.apst.fragments;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.TextView;

import net.lhh.apst.advancedpagerslidingtabstrip.R;

/**
 * Created by ld on 15/10/2017.
 */

public class MoreTextViewa extends TextView {

    private  boolean checked = false;

    public MoreTextViewa(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        // TODO Auto-generated constructor stub
    }
    public MoreTextViewa(Context context, AttributeSet attrs) {
        super(context, attrs);
        // TODO Auto-generated constructor stub
    }
    public MoreTextViewa(Context context) {
        super(context);
        // TODO Auto-generated constructor stub
    }

    public void setChecked(boolean checked) {
        this.checked = checked;
        if(getChecked()){

            setTextColor(getResources().getColor(R.color.green));
        }else{

            setTextColor(getResources().getColor(R.color.black));
        }
    }

    public boolean getChecked() {
        return checked;
    }
}
