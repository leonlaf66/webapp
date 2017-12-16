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

public class TypeFilterView extends LinearLayout {
    RelativeLayout allItemView;
    RelativeLayout sfItemView;
    RelativeLayout mfItemView;
    RelativeLayout ccItemView;
    RelativeLayout ciItemView;
    RelativeLayout buItemView;
    RelativeLayout ldItemView;


    CheckBox allItemViewCheck;
    CheckBox sfItemViewCheck;
    CheckBox mfItemViewCheck;
    CheckBox ccItemViewCheck;
    CheckBox ciItemViewCheck;
    CheckBox buItemViewCheck;
    CheckBox ldItemViewCheck;



    TextView allItemViewTitle;
    TextView sfItemViewTitle;
    TextView mfItemViewTitle;
    TextView ccItemViewTitle;
    TextView ciItemViewTitle;
    TextView buItemViewTitle;
    TextView ldItemViewTitle;


    Button search_Btn;

    public TypeFilterView(Context context) {
        this(context, null);
    }

    public TypeFilterView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public TypeFilterView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);

        // 设置布局文件
        LayoutInflater.from(context).inflate(R.layout.filter_type_view, this);

        search_Btn = findViewById(R.id.search_Btn);

        allItemView = findViewById(R.id.allItemView);
        sfItemView = findViewById(R.id.sfItemView);
        mfItemView = findViewById(R.id.mfItemView);
        ccItemView = findViewById(R.id.ccItemView);
        ciItemView = findViewById(R.id.ciItemView);
        buItemView = findViewById(R.id.buItemView);
        ldItemView = findViewById(R.id.ldItemView);




         allItemViewCheck = findViewById(R.id.allItemViewCheck);
         sfItemViewCheck= findViewById(R.id.sfItemViewCheck);
         mfItemViewCheck= findViewById(R.id.mfItemViewCheck);
         ccItemViewCheck= findViewById(R.id.ccItemViewCheck);
         ciItemViewCheck= findViewById(R.id.ciItemViewCheck);
         buItemViewCheck= findViewById(R.id.buItemViewCheck);
         ldItemViewCheck= findViewById(R.id.ldItemViewCheck);



         allItemViewTitle= findViewById(R.id.allItemViewTitle);
         sfItemViewTitle= findViewById(R.id.sfItemViewTitle);
         mfItemViewTitle= findViewById(R.id.mfItemViewTitle);
         ccItemViewTitle= findViewById(R.id.ccItemViewTitle);
         ciItemViewTitle= findViewById(R.id.ciItemViewTitle);
         buItemViewTitle= findViewById(R.id.buItemViewTitle);
         ldItemViewTitle= findViewById(R.id.ldItemViewTitle);



        allItemView.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {

                allItemViewCheck.setChecked(!allItemViewCheck.isChecked());
                if(allItemViewCheck.isChecked()){
                    sfItemViewCheck.setChecked(false);
                    mfItemViewCheck.setChecked(false);
                    ccItemViewCheck.setChecked(false);
                    ciItemViewCheck.setChecked(false);
                    buItemViewCheck.setChecked(false);
                    ldItemViewCheck.setChecked(false);
                }


            }
        });

        allItemViewCheck.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                 if(isChecked){
                     sfItemViewCheck.setChecked(false);
                     mfItemViewCheck.setChecked(false);
                     ccItemViewCheck.setChecked(false);
                     ciItemViewCheck.setChecked(false);
                     buItemViewCheck.setChecked(false);
                     ldItemViewCheck.setChecked(false);
                 }
            }
        });



        sfItemView.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {

                sfItemViewCheck.setChecked(!sfItemViewCheck.isChecked());

            }
        });


        mfItemView.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {

                mfItemViewCheck.setChecked(!mfItemViewCheck.isChecked());

            }
        });

        ccItemView.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {

                ccItemViewCheck.setChecked(!ccItemViewCheck.isChecked());

            }
        });

        ciItemView.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {

                ciItemViewCheck.setChecked(!ciItemViewCheck.isChecked());

            }
        });

        buItemView.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {

                buItemViewCheck.setChecked(!buItemViewCheck.isChecked());

            }
        });

        ldItemView.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {

                ldItemViewCheck.setChecked(!ldItemViewCheck.isChecked());

            }
        });


        search_Btn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
               mBack.myBack(1);

            }
        });

        setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {


            }
        });


        sfItemViewCheck.setChecked(true);
        mfItemViewCheck.setChecked(true);
        ccItemViewCheck.setChecked(true);

    }

    public void initLang(String language){

        if(language.contains("zh")){

             allItemViewTitle.setText("全部");
               sfItemViewTitle.setText("独栋别墅");
             mfItemViewTitle.setText("多家庭");
             ccItemViewTitle.setText("公寓");
             ciItemViewTitle.setText("商业用房");
             buItemViewTitle.setText("营业用房");
             ldItemViewTitle.setText("土地");

        }else{
            allItemViewTitle.setText("ALL");
            sfItemViewTitle.setText("Single Family");
            mfItemViewTitle.setText("Multi Family");
            ccItemViewTitle.setText("Condominium");
            ciItemViewTitle.setText("Commercial");
            buItemViewTitle.setText("Business Oportunty");
            ldItemViewTitle.setText("Land");

        }



    }


    public List getCheck(){
        List checks = new ArrayList();

        if (sfItemViewCheck.isChecked()){
            checks.add("SF");
        }

        if (mfItemViewCheck.isChecked()){
            checks.add("MF");
        }
        if (ccItemViewCheck.isChecked()){
            checks.add("CC");
        }
        if (ciItemViewCheck.isChecked()){
            checks.add("CI");
        }

        if (buItemViewCheck.isChecked()){
            checks.add("BU");
        }
        if (ldItemViewCheck.isChecked()){
            checks.add("LD");
        }

        return checks;
    }


    public  void setTypeList(List ls){
        ldItemViewCheck.setChecked(false);
        buItemViewCheck.setChecked(false);
        ciItemViewCheck.setChecked(false);
        ccItemViewCheck.setChecked(false);
        mfItemViewCheck.setChecked(false);
        sfItemViewCheck.setChecked(false);


        for (int i = 0; i< ls.size();i++){
            if(ls.get(i).equals("SF")){
                sfItemViewCheck.setChecked(true);

            }else if(ls.get(i).equals("MF")){
                mfItemViewCheck.setChecked(true);
            }else if(ls.get(i).equals("CC")){
                ccItemViewCheck.setChecked(true);
            }else if(ls.get(i).equals("CI")){
                ciItemViewCheck.setChecked(true);
            }else if(ls.get(i).equals("BU")){
                buItemViewCheck.setChecked(true);
            }else if(ls.get(i).equals("LD")){
                ldItemViewCheck.setChecked(true);
            }
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
