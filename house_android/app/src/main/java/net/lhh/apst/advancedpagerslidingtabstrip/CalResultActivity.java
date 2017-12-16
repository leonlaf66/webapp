package net.lhh.apst.advancedpagerslidingtabstrip;

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.TimePickerDialog;
import android.graphics.Color;
import android.graphics.Typeface;
import android.os.Bundle;
import android.text.SpannableString;
import android.text.style.ForegroundColorSpan;
import android.text.style.RelativeSizeSpan;
import android.text.style.StyleSpan;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.DefaultRetryPolicy;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.baidu.mapapi.SDKInitializer;
import com.github.mikephil.charting.animation.Easing;
import com.github.mikephil.charting.charts.PieChart;
import com.github.mikephil.charting.components.Legend;
import com.github.mikephil.charting.data.PieData;
import com.github.mikephil.charting.data.PieDataSet;
import com.github.mikephil.charting.data.PieEntry;
import com.github.mikephil.charting.formatter.PercentFormatter;
import com.github.mikephil.charting.utils.ColorTemplate;
import com.github.mikephil.charting.utils.MPPointF;

import net.cfg.AppCfg;

import org.json.JSONException;
import org.json.JSONObject;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by ld on 04/10/2017.
 */

public class CalResultActivity extends BaseActivity {



    ImageView backBtn;
    TextView naTitle;
    String price;

    double newPrice;

    String tax;
    String downPayment;
    String  year;
    String  rate;
    private PieChart mChart;

    TextView aa;
    TextView bb;
    TextView cc;
    TextView dd;
    TextView ee;
    TextView ff;

    protected String[] mMonths = new String[] {
            "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Dec"
    };

    protected String[] mParties = new String[] {
            "Party A", "Party B", "Party C", "Party D", "Party E", "Party F", "Party G", "Party H",
            "Party I", "Party J", "Party K", "Party L", "Party M", "Party N", "Party O", "Party P",
            "Party Q", "Party R", "Party S", "Party T", "Party U", "Party V", "Party W", "Party X",
            "Party Y", "Party Z"
    };

    protected Typeface mTfRegular;
    protected Typeface mTfLight;

    protected float getRandom(float range, float startsfrom) {
        return (float) (Math.random() * range) + startsfrom;
    }
    double monthPay;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        SDKInitializer.initialize(getApplicationContext());
        setContentView(R.layout.activity_cal_result);
        naTitle = (TextView)findViewById(R.id.home_map_title);

        aa = (TextView)findViewById(R.id.aa);
        bb = (TextView)findViewById(R.id.bb);
        cc = (TextView)findViewById(R.id.cc);
        dd = (TextView)findViewById(R.id.dd);
        ee = (TextView)findViewById(R.id.ee);
        ff = (TextView)findViewById(R.id.ff);

        price = (String) getIntent().getSerializableExtra("price");
        tax = (String) getIntent().getSerializableExtra("tax");

        downPayment = (String) getIntent().getSerializableExtra("downPayment");

        year = (String) getIntent().getSerializableExtra("year");
        rate = (String) getIntent().getSerializableExtra("rate");

        mTfRegular = Typeface.createFromAsset(getAssets(), "OpenSans-Regular.ttf");
        mTfLight = Typeface.createFromAsset(getAssets(), "OpenSans-Light.ttf");

        if(getLanguage().contains("zh")){

            String a = price.replaceAll("万美元","");

            newPrice = Double.parseDouble(a.replaceAll(",",""))*10000;
        }else{
            String a = price.replaceAll("\\$","");
            newPrice = Double.parseDouble(a.replaceAll(",",""));
        }


        backBtn = (ImageView)findViewById(R.id.home_map_go_btn);

        mChart = (PieChart)findViewById(R.id.mChart);

        mChart.setUsePercentValues(true);
        mChart.getDescription().setEnabled(false);
        mChart.setExtraOffsets(5, 10, 5, 5);

        mChart.setDragDecelerationFrictionCoef(0.95f);


        mChart.setCenterText(generateCenterSpannableText());

        mChart.setDrawHoleEnabled(true);
        mChart.setHoleColor(Color.WHITE);

        mChart.setTransparentCircleColor(Color.WHITE);
        mChart.setTransparentCircleAlpha(110);

        mChart.setHoleRadius(58f);
        mChart.setTransparentCircleRadius(61f);

        mChart.setDrawCenterText(true);

        mChart.setRotationAngle(0);
        // enable rotation of the chart by touch
        mChart.setRotationEnabled(true);
        mChart.setHighlightPerTapEnabled(true);






        if(getLanguage().contains("zh")){
            naTitle.setText("房贷计算器");


        }else{
            naTitle.setText("MORTGAGE CALC");


        }


        backBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });



        setData(4, 100);

        mChart.animateY(1400, Easing.EasingOption.EaseInOutQuad);
        // mChart.spin(2000, 0, 360);



        Legend l = mChart.getLegend();
        l.setVerticalAlignment(Legend.LegendVerticalAlignment.TOP);
        l.setHorizontalAlignment(Legend.LegendHorizontalAlignment.RIGHT);
        l.setOrientation(Legend.LegendOrientation.VERTICAL);
        l.setDrawInside(false);
        l.setXEntrySpace(17f);
        l.setYEntrySpace(11f);
        l.setYOffset(11f);

        // entry label styling
        mChart.setEntryLabelColor(Color.WHITE);
        mChart.setEntryLabelTypeface(mTfRegular);
        mChart.setEntryLabelTextSize(0f);


    }

    private SpannableString generateCenterSpannableText() {



        int months = Integer.parseInt(year) * 12;//30年
        //首付比例
        double firstRate = Double.parseDouble(downPayment);//20.0;//20%downPayment

        //月利率
        double ir = Double.parseDouble(rate) / (100 * 12);

        //首付
        double firstPay = newPrice * (firstRate / 100);

        //要贷款的金额
        double principal = newPrice - firstPay;

        //每月税费
        double taxMonth = Double.parseDouble(tax) / 12;
        DecimalFormat df = new DecimalFormat("#.00");

        //月供
         monthPay = principal * (ir/(1- Math.pow((1 + ir),(0 - months)))) + taxMonth;

        SpannableString s;

        if(getLanguage().contains("zh")){
            s = new SpannableString("月供\n"+df.format(monthPay)+"美元");
        }else{
            s = new SpannableString("Monthly Payment\n"+"$"+df.format(monthPay));
        }


        if(getLanguage().contains("zh")){
            aa.setText("房屋总价："+price);
            bb.setText("首付："+df.format(firstPay)+"美元");
            cc.setText("房产税："+tax+"美元");
            dd.setText("贷款总额："+df.format(principal)+"美元");
            ee.setText("月供："+df.format(monthPay)+"美元");
            ff.setText("年还贷总额："+df.format(monthPay*12)+"美元");
        }else{

            aa.setText("Purchase price："+price);
            bb.setText("Down payment：$"+df.format(firstPay)+"");
            cc.setText("Property tax：$"+tax+"");
            dd.setText("Loan amount：$"+df.format(principal)+"");
            ee.setText("Monthly payment：$"+df.format(monthPay)+"");
            ff.setText("Annual payment：$"+df.format(monthPay*12)+"");

        }



        return s;
    }


    private void setData(int count, float range) {

        float mult = range;

        ArrayList<PieEntry> entries = new ArrayList<PieEntry>();

        // NOTE: The order of the entries when being added to the entries array determines their position around the center of
        // the chart.
      Double ad =  (Double.parseDouble(tax) / (Double.parseDouble(tax)+monthPay)*100) ;

        Double bd =  (monthPay / (Double.parseDouble(tax)+monthPay)*100) ;

        if(getLanguage().contains("zh")){
            entries.add(new PieEntry(ad.intValue(),
                    " 房产税",
                    getResources().getColor(R.color.green)));


            entries.add(new PieEntry(bd.intValue(),
                    "本金利息",
                    getResources().getColor(R.color.red)));
        }else{
            entries.add(new PieEntry(ad.intValue(),
                    "Property Tax",
                    getResources().getColor(R.color.green)));


            entries.add(new PieEntry(bd.intValue(),
                    "Annual Payment",
                    getResources().getColor(R.color.red)));
        }





        PieDataSet dataSet = new PieDataSet(entries, " ");

        dataSet.setDrawIcons(false);

        dataSet.setSliceSpace(3f);
        dataSet.setIconsOffset(new MPPointF(0, 40));
        dataSet.setSelectionShift(5f);

        // add a lot of colors

        ArrayList<Integer> colors = new ArrayList<Integer>();


            colors.add( getResources().getColor(R.color.green));


            colors.add( getResources().getColor(R.color.red));


        colors.add(ColorTemplate.getHoloBlue());

        dataSet.setColors(colors);
        //dataSet.setSelectionShift(0f);

        PieData data = new PieData(dataSet);
        data.setValueFormatter(new PercentFormatter());
        data.setValueTextSize(11f);
        data.setValueTextColor(Color.WHITE);
        data.setValueTypeface(mTfLight);
        mChart.setData(data);

        // undo all highlights
        mChart.highlightValues(null);

        mChart.invalidate();
    }

}
