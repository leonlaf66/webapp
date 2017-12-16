package net.lhh.apst.fragments;

import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import net.lhh.apst.advancedpagerslidingtabstrip.R;

/**
 * Created by ld on 05/10/2017.
 */

public class NewsCell extends RelativeLayout {
    String nid;
    String title;
    String image;
    public NewsCell(Context context) {
        this(context, null);
    }

    public NewsCell(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public NewsCell(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);

        // 设置布局文件
        LayoutInflater.from(context).inflate(R.layout.home_news_cell_item_view, this);


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
}
