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

public class AreaFilterView extends LinearLayout {
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
    String value_a;

    String lmanguage = "en";

    public AreaFilterView(Context context) {
        this(context, null);
    }

    public AreaFilterView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public AreaFilterView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);

        // 设置布局文件
        LayoutInflater.from(context).inflate(R.layout.filter_area_view, this);

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
                value_a = null;
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

                if(lmanguage.contains("zh")){

                    value= "filters[square][from]=0&filters[square][to]=1076";
                }else{

                    value= "filters[square][from]=0&filters[square][to]=1000";
                }


                value_a = "1";
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




                if(lmanguage.contains("zh")){

                    value= "filters[square][from]=1076&filters[square][to]=2152";
                }else{

                    value= "filters[square][from]=1000&filters[square][to]=2000";
                }

                value_a = "2";
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



                if(lmanguage.contains("zh")){

                    value= "filters[square][from]=2152&filters[square][to]=3228";
                }else{

                    value= "filters[square][from]=2000&filters[square][to]=3000";
                }
                value_a = "3";
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




                if(lmanguage.contains("zh")){

                    value= "filters[square][from]=3228";
                }else{

                    value= "filters[square][from]=3000";
                }

                value_a = "4";
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
               mBack.myBack(3);

            }
        });

        setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {


            }
        });

    }

    public void initLang(String language){

        lmanguage = language;

        if(lmanguage.contains("zh")){

            titlea.setText("全部(单位：平方米)");

            titleb.setText("0-100平方米");
            titlec.setText("100-200平方米");
            titled.setText("200-300平方米");
            titlee.setText("300平方米+");



            search_Btn.setText("确定");
        }else{
            titlea.setText("ALL");

            search_Btn.setText("OK");

            titleb.setText("0-1000Sq.Ft");
            titlec.setText("1000-2000Sq.Ft");
            titled.setText("2000-3000Sq.Ft");
            titlee.setText("3000Sq.Ft+");

        }



    }


    public String  getCheck(){


        return value;
    }


    public String  getCheckdd(){


        return value_a;
    }


    public void  setArea(String area){
        value_a = area;

       if(area!=null){
           titlea.setTextColor(getResources().getColor(R.color.globalBlack));
           titleb.setTextColor(getResources().getColor(R.color.globalBlack));
           titlec.setTextColor(getResources().getColor(R.color.globalBlack));
           titled.setTextColor(getResources().getColor(R.color.globalBlack));
           titlee.setTextColor(getResources().getColor(R.color.globalBlack));



           if(Integer.parseInt(area) == 1){
               titlea.setTextColor(getResources().getColor(R.color.green));
              // value= "filters[square][from]=0&filters[square][to]=1000";

               if(lmanguage.contains("zh")){

                   value= "filters[square][from]=0&filters[square][to]=1076";
               }else{

                   value= "filters[square][from]=0&filters[square][to]=1000";
               }
           }else if(Integer.parseInt(area) == 2){
               titleb.setTextColor(getResources().getColor(R.color.green));
               //value= "filters[square][from]=1000&filters[square][to]=2000";

               if(lmanguage.contains("zh")){

                   value= "filters[square][from]=1076&filters[square][to]=2152";
               }else{

                   value= "filters[square][from]=1000&filters[square][to]=2000";
               }

           }else if(Integer.parseInt(area) == 3){
               titlec.setTextColor(getResources().getColor(R.color.green));
               //value= "filters[square][from]=2000&filters[square][to]=3000";
               if(lmanguage.contains("zh")){

                   value= "filters[square][from]=2152&filters[square][to]=3228";
               }else{

                   value= "filters[square][from]=2000&filters[square][to]=3000";
               }
           }else if(Integer.parseInt(area) == 4){
               titled.setTextColor(getResources().getColor(R.color.green));
              // value= "filters[square][from]=3000";

               if(lmanguage.contains("zh")){

                   value= "filters[square][from]=3228";
               }else{

                   value= "filters[square][from]=3000";
               }
           }

       }else{
           value_a = null;
           value = null;
           titlea.setTextColor(getResources().getColor(R.color.green));
           titleb.setTextColor(getResources().getColor(R.color.globalBlack));
           titlec.setTextColor(getResources().getColor(R.color.globalBlack));
           titled.setTextColor(getResources().getColor(R.color.globalBlack));
           titlee.setTextColor(getResources().getColor(R.color.globalBlack));


       }
    }


    private MyCallBack mBack;

    public void setMyCallBack(MyCallBack mBack){
        this.mBack=mBack;
    }

    public interface MyCallBack{
        public void myBack(int checks);
    }


}
