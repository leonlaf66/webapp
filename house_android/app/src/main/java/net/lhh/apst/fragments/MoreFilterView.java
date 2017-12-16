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

import java.util.ArrayList;
import java.util.List;

/**
 * Created by ld on 14/10/2017.
 */

public class MoreFilterView extends LinearLayout {


    Button search_Btn;
    Button reset_Btn;

    String value;

    //类型
    TextView typeTitle;
    MoreTextView type_a;
    MoreTextView type_b;
    MoreTextView type_c;
    MoreTextView type_d;
    MoreTextView type_e;
    MoreTextView type_f;

    //卧室

    TextView bedsTitle;
    MoreTextView beds_a;
    MoreTextView beds_b;
    MoreTextView beds_c;
    MoreTextView beds_d;
    MoreTextView beds_e;
    MoreTextView beds_f;


    TextView priceTitle;
    MoreTextView price_a;
    MoreTextView price_b;
    MoreTextView price_c;
    MoreTextView price_d;


    TextView areaTitle;
    MoreTextView area_a;
    MoreTextView area_b;
    MoreTextView area_c;
    MoreTextView area_d;


    TextView bathTitle;
    MoreTextView bath_a;
    MoreTextView bath_b;
    MoreTextView bath_c;
    MoreTextView bath_d;
    MoreTextView bath_e;


    TextView parkingTitle;
    MoreTextView parking_a;
    MoreTextView parking_b;
    MoreTextView parking_c;
    MoreTextView parking_d;
    MoreTextView parking_e;


    TextView marketTitle;
    MoreTextView market_a;
    MoreTextView market_b;
    MoreTextView market_c;

    String lmanguage = "en";

    public MoreFilterView(Context context) {
        this(context, null);
    }

    public MoreFilterView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public MoreFilterView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);

        // 设置布局文件
        LayoutInflater.from(context).inflate(R.layout.filter_more_view, this);

        search_Btn = findViewById(R.id.search_Btn);
        reset_Btn = findViewById(R.id.reset_Btn);

        typeTitle = findViewById(R.id.typeTitle);
        type_a = findViewById(R.id.type_a);
        type_b = findViewById(R.id.type_b);
        type_c = findViewById(R.id.type_c);
        type_d = findViewById(R.id.type_d);
        type_e = findViewById(R.id.type_e);
        type_f = findViewById(R.id.type_f);


        type_a.setChecked(true);
        type_b.setChecked(true);
        type_c.setChecked(true);






        bedsTitle = findViewById(R.id.bedsTitle);
        beds_a = findViewById(R.id.beds_a);
        beds_b = findViewById(R.id.beds_b);
        beds_c = findViewById(R.id.beds_c);
        beds_d = findViewById(R.id.beds_d);
        beds_e = findViewById(R.id.beds_e);
        beds_f = findViewById(R.id.beds_f);



        priceTitle = findViewById(R.id.priceTitle);
        price_a = findViewById(R.id.price_a);
        price_b = findViewById(R.id.price_b);
        price_c = findViewById(R.id.price_c);
        price_d = findViewById(R.id.price_d);



        areaTitle = findViewById(R.id.areaTitle);
        area_a = findViewById(R.id.area_a);
        area_b = findViewById(R.id.area_b);
        area_c = findViewById(R.id.area_c);
        area_d = findViewById(R.id.area_d);


        bathTitle = findViewById(R.id.bathTitle);
        bath_a = findViewById(R.id.bath_a);
        bath_b = findViewById(R.id.bath_b);
        bath_c = findViewById(R.id.bath_c);
        bath_d = findViewById(R.id.bath_d);
        bath_e = findViewById(R.id.bath_e);




        parkingTitle = findViewById(R.id.parkingTitle);
        parking_a = findViewById(R.id.parking_a);
        parking_b = findViewById(R.id.parking_b);
        parking_c = findViewById(R.id.parking_c);
        parking_d = findViewById(R.id.parking_d);
        parking_e = findViewById(R.id.parking_e);



        marketTitle = findViewById(R.id.marketTitle);
        market_a = findViewById(R.id.market_a);
        market_b = findViewById(R.id.market_b);
        market_c = findViewById(R.id.market_c);

        reset_Btn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                type_a.setChecked(false);
                type_b.setChecked(false);
                type_c.setChecked(false);
                type_d.setChecked(false);
                type_e.setChecked(false);
                type_f.setChecked(false);

                beds_a.setChecked(false);
                beds_b.setChecked(false);
                beds_c.setChecked(false);
                beds_d.setChecked(false);
                beds_e.setChecked(false);
                beds_f.setChecked(false);

                price_a.setChecked(false);
                price_b.setChecked(false);
                price_c.setChecked(false);
                price_d.setChecked(false);


                area_a.setChecked(false);
                area_b.setChecked(false);
                area_c.setChecked(false);
                area_d.setChecked(false);



                bath_a.setChecked(false);
                bath_b.setChecked(false);
                bath_c.setChecked(false);
                bath_d.setChecked(false);
                bath_e.setChecked(false);


                parking_a.setChecked(false);
                parking_b.setChecked(false);
                parking_c.setChecked(false);
                parking_d.setChecked(false);
                parking_e.setChecked(false);


                market_a.setChecked(false);
                market_b.setChecked(false);
                market_c.setChecked(false);

                mBack.myBack(5);

            }
        });



        setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {


            }
        });

        type_a.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                type_a.setChecked(!type_a.getChecked());



            }
        });
        type_b.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {

                type_b.setChecked(!type_b.getChecked());
            }
        });
        type_c.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                type_c.setChecked(!type_c.getChecked());

            }
        });
        type_d.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                type_d.setChecked(!type_d.getChecked());

            }
        });
        type_e.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                type_e.setChecked(!type_e.getChecked());

            }
        });
        type_f.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {

                type_f.setChecked(!type_f.getChecked());
            }
        });

        /////////////////////////

        beds_a.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                beds_a.setChecked(true);
                beds_b.setChecked(false);
                beds_c.setChecked(false);
                beds_d.setChecked(false);
                beds_e.setChecked(false);
                beds_f.setChecked(false);


            }
        });
        beds_b.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {

                beds_b.setChecked(true);
                beds_a.setChecked(false);
                beds_c.setChecked(false);
                beds_d.setChecked(false);
                beds_e.setChecked(false);
                beds_f.setChecked(false);
            }
        });
        beds_c.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                beds_c.setChecked(true);
                beds_b.setChecked(false);
                beds_a.setChecked(false);
                beds_d.setChecked(false);
                beds_e.setChecked(false);
                beds_f.setChecked(false);

            }
        });
        beds_d.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                beds_d.setChecked(true);
                beds_b.setChecked(false);
                beds_c.setChecked(false);
                beds_a.setChecked(false);
                beds_e.setChecked(false);
                beds_f.setChecked(false);

            }
        });
        beds_e.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                beds_e.setChecked(true);
                beds_b.setChecked(false);
                beds_c.setChecked(false);
                beds_d.setChecked(false);
                beds_a.setChecked(false);
                beds_f.setChecked(false);

            }
        });
        beds_f.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {

                beds_f.setChecked(true);
                beds_b.setChecked(false);
                beds_c.setChecked(false);
                beds_d.setChecked(false);
                beds_e.setChecked(false);
                beds_a.setChecked(false);
            }
        });

        ///////////////////

        price_a.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                price_a.setChecked(true);
                price_b.setChecked(false);
                price_c.setChecked(false);
                price_d.setChecked(false);




            }
        });
        price_b.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {

                price_b.setChecked(true);
                price_a.setChecked(false);
                price_c.setChecked(false);
                price_d.setChecked(false);


            }
        });
        price_c.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                price_c.setChecked(true);
                price_b.setChecked(false);
                price_a.setChecked(false);
                price_d.setChecked(false);



            }
        });
        price_d.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                price_d.setChecked(true);
                price_b.setChecked(false);
                price_c.setChecked(false);
                price_a.setChecked(false);



            }
        });



        ///////////


        area_a.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                area_a.setChecked(true);
                area_b.setChecked(false);
                area_c.setChecked(false);
                area_d.setChecked(false);




            }
        });
        area_b.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {

                area_b.setChecked(true);
                area_a.setChecked(false);
                area_c.setChecked(false);
                area_d.setChecked(false);


            }
        });
        area_c.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                area_c.setChecked(true);
                area_b.setChecked(false);
                area_a.setChecked(false);
                area_d.setChecked(false);



            }
        });
        area_d.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                area_d.setChecked(true);
                area_b.setChecked(false);
                area_c.setChecked(false);
                area_a.setChecked(false);

            }
        });



        //////////

        bath_a.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                bath_a.setChecked(true);
                bath_b.setChecked(false);
                bath_c.setChecked(false);
                bath_d.setChecked(false);
                bath_e.setChecked(false);


            }
        });
        bath_b.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {

                bath_b.setChecked(true);
                bath_a.setChecked(false);
                bath_c.setChecked(false);
                bath_d.setChecked(false);
                bath_e.setChecked(false);

            }
        });
        bath_c.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                bath_c.setChecked(true);
                bath_b.setChecked(false);
                bath_a.setChecked(false);
                bath_d.setChecked(false);
                bath_e.setChecked(false);


            }
        });
        bath_d.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                bath_d.setChecked(true);
                bath_b.setChecked(false);
                bath_c.setChecked(false);
                bath_a.setChecked(false);
                bath_e.setChecked(false);
            }
        });

        bath_e.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                bath_e.setChecked(true);
                bath_b.setChecked(false);
                bath_c.setChecked(false);
                bath_a.setChecked(false);
                bath_d.setChecked(false);

            }
        });

        //////
        parking_a.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                parking_a.setChecked(true);
                parking_b.setChecked(false);
                parking_c.setChecked(false);
                parking_d.setChecked(false);
                parking_e.setChecked(false);


            }
        });
        parking_b.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {

                parking_b.setChecked(true);
                parking_a.setChecked(false);
                parking_c.setChecked(false);
                parking_d.setChecked(false);
                parking_e.setChecked(false);

            }
        });
        parking_c.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                parking_c.setChecked(true);
                parking_b.setChecked(false);
                parking_a.setChecked(false);
                parking_d.setChecked(false);
                parking_e.setChecked(false);


            }
        });
        parking_d.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                parking_d.setChecked(true);
                parking_b.setChecked(false);
                parking_c.setChecked(false);
                parking_a.setChecked(false);
                parking_e.setChecked(false);
            }
        });

        parking_e.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                parking_e.setChecked(true);
                parking_b.setChecked(false);
                parking_c.setChecked(false);
                parking_a.setChecked(false);
                parking_d.setChecked(false);

            }
        });
////
        market_a.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                market_a.setChecked(true);
                market_b.setChecked(false);
                market_c.setChecked(false);



            }
        });
        market_b.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {

                market_b.setChecked(true);
                market_a.setChecked(false);
                market_c.setChecked(false);


            }
        });
        market_c.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                market_c.setChecked(true);
                market_b.setChecked(false);
                market_a.setChecked(false);


            }
        });

        //////////

        search_Btn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                mBack.myBack(5);

            }
        });



        ////

    }

    public void initLang(String language,String type){

        lmanguage = language;

        if(lmanguage.contains("zh")){



            search_Btn.setText("确定");
            reset_Btn.setText("重置");
            typeTitle.setText("类型");

            type_a.setText("独栋别墅");
            type_b.setText("多家庭");
            type_c.setText("公寓");
            type_d.setText("商业用房");
            type_e.setText("营业用房");
            type_f.setText("土地");



            bedsTitle.setText("卧室数");
            beds_a.setText("一居室");
            beds_b.setText("二居室");
            beds_c.setText("三居室");
            beds_d.setText("四居室");
            beds_e.setText("五居室");
            beds_f.setText("六居室");

            priceTitle.setText("售价(单位：美元)");

            area_a.setText("0-100");
            area_b.setText("100-200");
            area_c.setText("200-300");
            area_d.setText("300+");

            if("lease".equals(type)){
                price_a.setText("0-1000美元");
                price_b.setText("1000-2000美元");
                price_c.setText("2000-3000美元");
                price_d.setText("3000美元+");
            }else{
                price_a.setText("0-50万美元");
                price_b.setText("50-80万美元");
                price_c.setText("80-120万美元");
                price_d.setText("120万美元+");
            }


            areaTitle.setText("面积(单位：平方米)");

            bathTitle.setText("卫生间");
            parkingTitle.setText("车位");
            marketTitle.setText("上市时间");

        }else{


            search_Btn.setText("OK");
            reset_Btn.setText("RESET");
            typeTitle.setText("Type");
            type_a.setText("Single Family");
            type_b.setText("Multi Family");
            type_c.setText("Condominium");
            type_d.setText("Commercial");
            type_e.setText("Business Oportunty");
            type_f.setText("Land");

            bedsTitle.setText("Beds");
            beds_a.setText("1+");
            beds_b.setText("2+");
            beds_c.setText("3+");
            beds_d.setText("4+");
            beds_e.setText("5+");
            beds_f.setText("6+");

            area_a.setText("0-1000");
            area_b.setText("1000-2000");
            area_c.setText("2000-3000");
            area_d.setText("3000+");


            priceTitle.setText("Price($)");

            if("lease".equals(type)){
                price_a.setText("0-$1000");
                price_b.setText("$1000-$2000");
                price_c.setText("$2000-$3000");
                price_d.setText("$3000+");
            }else{

                price_a.setText("0-$500000");
                price_b.setText("$500000-$800000");
                price_c.setText("$800000-$1200000");
                price_d.setText("$1200000+");

            }



            areaTitle.setText("Living Area(Sq.Ft)");
            bathTitle.setText("Bathes");
            parkingTitle.setText("Parking");
            marketTitle.setText("Days on Market");
        }



    }

    public  void setTypeList(List ls){


        type_a.setChecked(false);
        type_b.setChecked(false);
        type_c.setChecked(false);
        type_d.setChecked(false);
        type_e.setChecked(false);
        type_f.setChecked(false);


         for (int i = 0; i< ls.size();i++){
             if(ls.get(i).equals("SF")){
                 type_a.setChecked(true);

             }else if(ls.get(i).equals("MF")){
                 type_b.setChecked(true);

             }else if(ls.get(i).equals("CC")){
                 type_c.setChecked(true);
             }else if(ls.get(i).equals("CI")){
                 type_d.setChecked(true);
             }else if(ls.get(i).equals("BU")){
                 type_e.setChecked(true);
             }else if(ls.get(i).equals("LD")){
                 type_f.setChecked(true);
             }
         }
    }

    public  List getType(){

        List typeList = new ArrayList();

        if(type_a.getChecked()){
            typeList.add("SF");
        }

        if(type_b.getChecked()){
            typeList.add("MF");
        }

        if(type_c.getChecked()){
            typeList.add("CC");
        }

        if(type_d.getChecked()){
            typeList.add("CI");
        }

        if(type_e.getChecked()){
            typeList.add("BU");
        }
        if(type_f.getChecked()){
            typeList.add("LD");
        }

        return typeList;

    }

    public  void setBeds(Integer beds){

if(beds != null){
    beds_d.setChecked(false);
    beds_b.setChecked(false);
    beds_c.setChecked(false);
    beds_a.setChecked(false);
    beds_e.setChecked(false);
    beds_f.setChecked(false);

    if(beds == 1){
        beds_a.setChecked(true);

    }else if(beds == 2){
        beds_b.setChecked(true);

    }else if(beds == 3){
        beds_c.setChecked(true);

    }else if(beds == 4){
        beds_d.setChecked(true);

    }else if(beds == 5){
        beds_e.setChecked(true);

    }else if(beds == 6){
        beds_f.setChecked(true);

    }
}


    }


    public  String getBeds(){

      String beds = null;

        if( beds_a.getChecked()){
            return "1";
        }else if( beds_b.getChecked()){
            return "2";
        }else if( beds_c.getChecked()){
            return "3";
        }else if( beds_d.getChecked()){
            return "4";
        }else if( beds_e.getChecked()){
            return "5";
        }else if( beds_f.getChecked()){
            return "6";
        }

        return beds;
    }


    public  String getPrice(){

        String beds = null;

        if( price_a.getChecked()){
            return "1";
        }else if( price_b.getChecked()){
            return "2";
        }else if( price_c.getChecked()){
            return "3";
        }else if( price_d.getChecked()){
            return "4";
        }
        return beds;
    }

    public  void setPrice( String price){

        if(price != null){

            if(Integer.parseInt(price) == 1){
                price_a.setChecked(true);
            }else if(Integer.parseInt(price) == 2){
                price_b.setChecked(true);
            }else if(Integer.parseInt(price) == 3){
                price_c.setChecked(true);
            }else if(Integer.parseInt(price) == 4){
                price_d.setChecked(true);
            }
        }



    }


    public String  getCheck(){


        return value;
    }


    public String  getMarket(){
       String market = null;

        if(market_a.getChecked()){
            return "filters[market-days]=1";
        }else  if(market_b.getChecked()){
            return "filters[market-days]=2";
        }else  if(market_c.getChecked()){
            return "filters[market-days]=3";
        }

        return market;
    }


    public String  getParking(){
        String parking = null;

        if(parking_a.getChecked()){
            return "filters[parking]=1";
        }else  if(parking_b.getChecked()){
            return "filters[parking]=2";
        }else  if(parking_c.getChecked()){
            return "filters[parking]=3";
        }else  if(parking_d.getChecked()){
            return "filters[parking]=4";
        }else  if(parking_e.getChecked()){
            return "filters[parking]=5";
        }

        return parking;
    }


    public String  getBath(){
        String bath = null;

        if(bath_a.getChecked()){
            return "filters[baths]=1";
        }else  if(bath_b.getChecked()){
            return "filters[baths]=2";
        }else  if(bath_c.getChecked()){
            return "filters[baths]=3";
        }else  if(bath_d.getChecked()){
            return "filters[baths]=4";
        }else  if(bath_e.getChecked()){
            return "filters[baths]=5";
        }

        return bath;
    }



    private MyCallBack mBack;

    public void setMyCallBack(MyCallBack mBack){
        this.mBack=mBack;
    }

    public interface MyCallBack{
        public void myBack(int checks);
    }


    public  void setArea(Integer area){

        if(area != null){
            area_d.setChecked(false);
            area_b.setChecked(false);
            area_c.setChecked(false);
            area_a.setChecked(false);


            if(area == 1){
                area_a.setChecked(true);

            }else if(area == 2){
                area_b.setChecked(true);

            }else if(area == 3){
                area_c.setChecked(true);

            }else if(area == 4){
                area_d.setChecked(true);

            }
        }


    }

    public  String getArea(){

        String beds = null;

        if( area_a.getChecked()){
            return "1";
        }else if( area_b.getChecked()){
            return "2";
        }else if( area_c.getChecked()){
            return "3";
        }else if( area_d.getChecked()){
            return "4";
        }
        return beds;
    }
}
