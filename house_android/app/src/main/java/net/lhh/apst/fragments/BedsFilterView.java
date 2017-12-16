package net.lhh.apst.fragments;

import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import net.lhh.apst.advancedpagerslidingtabstrip.R;

import java.util.List;

/**
 * Created by ld on 14/10/2017.
 */

public class BedsFilterView extends LinearLayout {
    RelativeLayout aView;
    RelativeLayout bView;
    RelativeLayout cView;
    RelativeLayout dView;
    RelativeLayout eView;

    RelativeLayout fView;
    RelativeLayout gView;



    TextView titlea;
    TextView titleb;
    TextView titlec;
    TextView titled;
    TextView titlee;
    TextView titlef;
    TextView titleg;


    Button search_Btn;

    String value = null;

    public BedsFilterView(Context context) {
        this(context, null);
    }

    public BedsFilterView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public BedsFilterView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);

        // 设置布局文件
        LayoutInflater.from(context).inflate(R.layout.filter_beds_view, this);

        search_Btn = findViewById(R.id.search_Btn);

        aView = findViewById(R.id.aView);
        bView = findViewById(R.id.bView);
        cView = findViewById(R.id.cView);
        dView = findViewById(R.id.dView);
        eView = findViewById(R.id.eView);
        fView = findViewById(R.id.fView);
        gView = findViewById(R.id.gView);


        titlea= findViewById(R.id.titlea);
        titleb= findViewById(R.id.titleb);
        titlec= findViewById(R.id.titlec);
        titled= findViewById(R.id.titled);
        titlee= findViewById(R.id.titlee);
        titlef= findViewById(R.id.titlef);
        titleg= findViewById(R.id.titleg);

        aView.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {


                value = null;

                titlea.setTextColor(getResources().getColor(R.color.green));
                titleb.setTextColor(getResources().getColor(R.color.globalBlack));
                titlec.setTextColor(getResources().getColor(R.color.globalBlack));
                titled.setTextColor(getResources().getColor(R.color.globalBlack));
                titlee.setTextColor(getResources().getColor(R.color.globalBlack));
                titlef.setTextColor(getResources().getColor(R.color.globalBlack));
                titleg.setTextColor(getResources().getColor(R.color.globalBlack));
            }
        });

        bView.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {

                value= "filters[beds]=1";

                titleb.setTextColor(getResources().getColor(R.color.green));
                titlea.setTextColor(getResources().getColor(R.color.globalBlack));
                titlec.setTextColor(getResources().getColor(R.color.globalBlack));
                titled.setTextColor(getResources().getColor(R.color.globalBlack));
                titlee.setTextColor(getResources().getColor(R.color.globalBlack));
                titlef.setTextColor(getResources().getColor(R.color.globalBlack));
                titleg.setTextColor(getResources().getColor(R.color.globalBlack));
            }
        });

        cView.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {

                value= "filters[beds]=2";


                titlec.setTextColor(getResources().getColor(R.color.green));
                titleb.setTextColor(getResources().getColor(R.color.globalBlack));
                titlea.setTextColor(getResources().getColor(R.color.globalBlack));
                titled.setTextColor(getResources().getColor(R.color.globalBlack));
                titlee.setTextColor(getResources().getColor(R.color.globalBlack));
                titlef.setTextColor(getResources().getColor(R.color.globalBlack));
                titleg.setTextColor(getResources().getColor(R.color.globalBlack));
            }
        });

        dView.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {

                value= "filters[beds]=3";

                titled.setTextColor(getResources().getColor(R.color.green));
                titleb.setTextColor(getResources().getColor(R.color.globalBlack));
                titlec.setTextColor(getResources().getColor(R.color.globalBlack));
                titlea.setTextColor(getResources().getColor(R.color.globalBlack));
                titlee.setTextColor(getResources().getColor(R.color.globalBlack));
                titlef.setTextColor(getResources().getColor(R.color.globalBlack));
                titleg.setTextColor(getResources().getColor(R.color.globalBlack));
            }
        });

        eView.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {


                value= "filters[beds]=4";

                titlee.setTextColor(getResources().getColor(R.color.green));
                titleb.setTextColor(getResources().getColor(R.color.globalBlack));
                titlec.setTextColor(getResources().getColor(R.color.globalBlack));
                titled.setTextColor(getResources().getColor(R.color.globalBlack));
                titlea.setTextColor(getResources().getColor(R.color.globalBlack));
                titlef.setTextColor(getResources().getColor(R.color.globalBlack));
                titleg.setTextColor(getResources().getColor(R.color.globalBlack));
            }
        });

        fView.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {


                value= "filters[beds]=5";

                titlef.setTextColor(getResources().getColor(R.color.green));
                titleb.setTextColor(getResources().getColor(R.color.globalBlack));
                titlec.setTextColor(getResources().getColor(R.color.globalBlack));
                titled.setTextColor(getResources().getColor(R.color.globalBlack));
                titlea.setTextColor(getResources().getColor(R.color.globalBlack));
                titlee.setTextColor(getResources().getColor(R.color.globalBlack));
                titleg.setTextColor(getResources().getColor(R.color.globalBlack));
            }
        });


        gView.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {


                value= "filters[beds]=6";

                titleg.setTextColor(getResources().getColor(R.color.green));
                titleb.setTextColor(getResources().getColor(R.color.globalBlack));
                titlec.setTextColor(getResources().getColor(R.color.globalBlack));
                titled.setTextColor(getResources().getColor(R.color.globalBlack));
                titlea.setTextColor(getResources().getColor(R.color.globalBlack));
                titlee.setTextColor(getResources().getColor(R.color.globalBlack));
                titlef.setTextColor(getResources().getColor(R.color.globalBlack));
            }
        });


        search_Btn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
               mBack.myBack(4);

            }
        });

        setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {


            }
        });

    }

    public void initLang(String language){

        if(language.contains("zh")){

            titlea.setText("全部(单位)");

            titleb.setText("一居室");
            titlec.setText("二居室");
            titled.setText("三居室");
            titlee.setText("四居室");
            titlef.setText("五居室");
            titleg.setText("六居室");
            search_Btn.setText("确定");
        }else{
            titlea.setText("ALL");

            titleb.setText("1+");
            titlec.setText("2+");
            titled.setText("3+");
            titlee.setText("4+");
            titlef.setText("5+");
            titleg.setText("6+");
            search_Btn.setText("OK");

        }



    }

    public  void setBeds(String beds){

        titlea.setTextColor(getResources().getColor(R.color.globalBlack));
        titleb.setTextColor(getResources().getColor(R.color.globalBlack));
        titlec.setTextColor(getResources().getColor(R.color.globalBlack));
        titled.setTextColor(getResources().getColor(R.color.globalBlack));
        titlee.setTextColor(getResources().getColor(R.color.globalBlack));
        titlef.setTextColor(getResources().getColor(R.color.globalBlack));
        titleg.setTextColor(getResources().getColor(R.color.globalBlack));
        if(beds != null){



            value = "filters[beds]="+beds;
            if(Integer.parseInt(beds) == 1){
                titleb.setTextColor(getResources().getColor(R.color.green));
            }else if(Integer.parseInt(beds) == 2){
                titlec.setTextColor(getResources().getColor(R.color.green));
            }else if(Integer.parseInt(beds) == 3){
                titled.setTextColor(getResources().getColor(R.color.green));
            }else if(Integer.parseInt(beds) == 4){
                titlee.setTextColor(getResources().getColor(R.color.green));
            }else if(Integer.parseInt(beds) == 5){
                titlef.setTextColor(getResources().getColor(R.color.green));
            }else if(Integer.parseInt(beds) == 6){
                titleg.setTextColor(getResources().getColor(R.color.green));
            }
        }else{
            titlea.setTextColor(getResources().getColor(R.color.green));
        }
    }


    public String  getCheck(){


        return value;
    }


    private MyCallBack mBack;

    public void setMyCallBack(MyCallBack mBack){
        this.mBack=mBack;
    }

    public interface MyCallBack{
        public void myBack(int checks);
    }


}
