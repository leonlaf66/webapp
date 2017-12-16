package net.lhh.apst.fragments;

import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import net.lhh.apst.advancedpagerslidingtabstrip.R;

import org.json.JSONObject;

/**
 * Created by ld on 05/10/2017.
 */

public class ComCell extends RelativeLayout {
    String nid;
    String title;
    String image;

    JSONObject obj;
    TextView housetitle;
    TextView housetitle_item;
    public ComCell(Context context) {
        this(context, null);
    }

    public ComCell(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public ComCell(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);

        // 设置布局文件
        LayoutInflater.from(context).inflate(R.layout.home_com_item_view, this);

       housetitle = findViewById(R.id.housetitle);
        housetitle_item = findViewById(R.id.housetitle_item);
    }

    public String getNid() {
        return nid;
    }

    public String getTitle() {
        return title;
    }

    public void setNid(String nid) {
        this.nid = nid;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }


    public JSONObject getObj() {
        return obj;
    }

    public void setObj(JSONObject obj) {


        this.obj = obj;

        try {
            housetitle.setText(obj.getString("title"));
            housetitle_item.setText(obj.getString("desc"));
        }catch (Exception e){
            e.printStackTrace();
        }


    }
}
