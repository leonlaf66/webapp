package net.lhh.apst.fragments;

import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import net.lhh.apst.advancedpagerslidingtabstrip.R;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by ld on 14/10/2017.
 */

public class PriceFilterView extends LinearLayout {
    RelativeLayout aView;
    RelativeLayout bView;
    RelativeLayout cView;
    RelativeLayout dView;
    RelativeLayout eView;






    TextView titlea;
    TextView titleb;
    TextView titlec;
    TextView titled;
    TextView titlee;



    Button search_Btn;

    String value;
    String a_value;

    String type ;

    public PriceFilterView(Context context) {
        this(context, null);
    }

    public PriceFilterView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public PriceFilterView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);

        // 设置布局文件
        LayoutInflater.from(context).inflate(R.layout.filter_price_view, this);

        search_Btn = findViewById(R.id.search_Btn);

        aView = findViewById(R.id.aView);
        bView = findViewById(R.id.bView);
        cView = findViewById(R.id.cView);
        dView = findViewById(R.id.dView);
        eView = findViewById(R.id.eView);




        titlea= findViewById(R.id.titlea);
        titleb= findViewById(R.id.titleb);
        titlec= findViewById(R.id.titlec);
        titled= findViewById(R.id.titled);
        titlee= findViewById(R.id.titlee);


        aView.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {


                value = null;
                a_value = null;
                titlea.setTextColor(getResources().getColor(R.color.green));
                titleb.setTextColor(getResources().getColor(R.color.globalBlack));
                titlec.setTextColor(getResources().getColor(R.color.globalBlack));
                titled.setTextColor(getResources().getColor(R.color.globalBlack));
                titlee.setTextColor(getResources().getColor(R.color.globalBlack));

            }
        });

        bView.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                a_value = "1";

                if("lease".equals(type)){
                    value= "filters[list_price][from]=0&filters[list_price][to]=1000";
                }else{
                    value= "filters[list_price][from]=0&filters[list_price][to]=500000";
                }


                titleb.setTextColor(getResources().getColor(R.color.green));
                titlea.setTextColor(getResources().getColor(R.color.globalBlack));
                titlec.setTextColor(getResources().getColor(R.color.globalBlack));
                titled.setTextColor(getResources().getColor(R.color.globalBlack));
                titlee.setTextColor(getResources().getColor(R.color.globalBlack));

            }
        });

        cView.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {



                if("lease".equals(type)){
                    value= "filters[list_price][from]=1000&filters[list_price][to]=2000";
                }else{
                    value= "filters[list_price][from]=500000&filters[list_price][to]=800000";
                }

                a_value = "2";

                titlec.setTextColor(getResources().getColor(R.color.green));
                titleb.setTextColor(getResources().getColor(R.color.globalBlack));
                titlea.setTextColor(getResources().getColor(R.color.globalBlack));
                titled.setTextColor(getResources().getColor(R.color.globalBlack));
                titlee.setTextColor(getResources().getColor(R.color.globalBlack));

            }
        });

        dView.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {



                if("lease".equals(type)){
                    value= "filters[list_price][from]=2000&filters[list_price][to]=3000";
                }else{
                    value= "filters[list_price][from]=800000&filters[list_price][to]=1200000";
                }

                a_value = "3";
                titled.setTextColor(getResources().getColor(R.color.green));
                titleb.setTextColor(getResources().getColor(R.color.globalBlack));
                titlec.setTextColor(getResources().getColor(R.color.globalBlack));
                titlea.setTextColor(getResources().getColor(R.color.globalBlack));
                titlee.setTextColor(getResources().getColor(R.color.globalBlack));

            }
        });

        eView.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {




                if("lease".equals(type)){
                    value= "filters[list_price][from]=3000";
                }else{
                    value= "filters[list_price][from]=1200000";
                }

                a_value = "4";
                titlee.setTextColor(getResources().getColor(R.color.green));
                titleb.setTextColor(getResources().getColor(R.color.globalBlack));
                titlec.setTextColor(getResources().getColor(R.color.globalBlack));
                titled.setTextColor(getResources().getColor(R.color.globalBlack));
                titlea.setTextColor(getResources().getColor(R.color.globalBlack));

            }
        });




        search_Btn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
               mBack.myBack(2);

            }
        });

        setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {


            }
        });

    }

    public void initLang(String language,String type){


        this.type = type;
        if("lease".equals(type)){

            if(language.contains("zh")){

                titlea.setText("全部(单位：美元)");
                titleb.setText("0-1000美元");
                titlec.setText("1000-2000美元");
                titled.setText("2000-3000美元");
                titlee.setText("3000美元+");

                search_Btn.setText("确定");
            }else{
                titlea.setText("ALL");
                titleb.setText("$0-$1000");
                titlec.setText("$1000-$2000");
                titled.setText("$2000-$3000");
                titlee.setText("$3000+");
                search_Btn.setText("OK");

            }


        }else{

            if(language.contains("zh")){

                titlea.setText("全部(单位：美元)");
                titleb.setText("0-50万美元");
                titlec.setText("50-80万美元");
                titled.setText("80-120万美元");
                titlee.setText("120万美元+");

                search_Btn.setText("确定");
            }else{
                titlea.setText("ALL");
                titleb.setText("$0-$500000");
                titlec.setText("$500000-$800000");
                titled.setText("$800000-$1200000");
                titlee.setText("$1200000+");
                search_Btn.setText("OK");

            }


        }




    }


    public  void setPrice( String price){

        value = null;
        a_value = price;
        titlea.setTextColor(getResources().getColor(R.color.globalBlack));
        titleb.setTextColor(getResources().getColor(R.color.globalBlack));
        titlec.setTextColor(getResources().getColor(R.color.globalBlack));
        titled.setTextColor(getResources().getColor(R.color.globalBlack));
        titlee.setTextColor(getResources().getColor(R.color.globalBlack));

        if(price != null){


            if("lease".equals(type)){
                if(Integer.parseInt(price) == 1){
                    titleb.setTextColor(getResources().getColor(R.color.green));
                    value= "filters[list_price][from]=0&filters[list_price][to]=1000";
                }else if(Integer.parseInt(price) == 2){
                    titlec.setTextColor(getResources().getColor(R.color.green));
                    value= "filters[list_price][from]=1000&filters[list_price][to]=2000";
                }else if(Integer.parseInt(price) == 3){
                    titled.setTextColor(getResources().getColor(R.color.green));
                    value= "filters[list_price][from]=2000&filters[list_price][to]=3000";
                }else if(Integer.parseInt(price) == 4){
                    titlee.setTextColor(getResources().getColor(R.color.green));
                    value= "filters[list_price][from]=3000";
                }

            }else{

                if(Integer.parseInt(price) == 1){
                    titleb.setTextColor(getResources().getColor(R.color.green));
                    value= "filters[list_price][from]=0&filters[list_price][to]=500000";
                }else if(Integer.parseInt(price) == 2){
                    titlec.setTextColor(getResources().getColor(R.color.green));
                    value= "filters[list_price][from]=500000&filters[list_price][to]=800000";
                }else if(Integer.parseInt(price) == 3){
                    titled.setTextColor(getResources().getColor(R.color.green));
                    value= "filters[list_price][from]=800000&filters[list_price][to]=1200000";
                }else if(Integer.parseInt(price) == 4){
                    titlee.setTextColor(getResources().getColor(R.color.green));
                    value= "filters[list_price][from]=1200000";
                }

            }


        }else{
            titlea.setTextColor(getResources().getColor(R.color.green));
        }



    }


    public String  getCheck(){


        return value;
    }

    public String  getCheckedd(){


        return a_value;
    }


    private MyCallBack mBack;

    public void setMyCallBack(MyCallBack mBack){
        this.mBack=mBack;
    }

    public interface MyCallBack{
        public void myBack(int checks);
    }


}
