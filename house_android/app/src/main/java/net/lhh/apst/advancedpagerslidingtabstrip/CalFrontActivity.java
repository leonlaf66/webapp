package net.lhh.apst.advancedpagerslidingtabstrip;

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.TimePickerDialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
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

import net.cfg.AppCfg;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by ld on 04/10/2017.
 */

public class CalFrontActivity extends BaseActivity {




    TextView priceLabel;
    TextView priceValue;
    TextView downpayLabel;
    TextView yearLabel;
    TextView yearunit;
    TextView rateLabel;
    TextView taxLabel;

    ImageView backBtn;
    TextView naTitle;
    TextView TaxValue;

    EditText downpayValue;
    EditText yearValue;
    EditText rateValue;
    LinearLayout okBtn;

    TextView add_title;



    String price;

    String tax;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        SDKInitializer.initialize(getApplicationContext());
        setContentView(R.layout.activity_cal_front);
        price = (String) getIntent().getSerializableExtra("price");
        tax = (String) getIntent().getSerializableExtra("taxes");

        backBtn = (ImageView)findViewById(R.id.home_map_go_btn);

        naTitle = (TextView)findViewById(R.id.home_map_title);
        priceValue = (TextView)findViewById(R.id.priceValue);

        priceLabel = (TextView)findViewById(R.id.priceLabel);
        downpayLabel = (TextView)findViewById(R.id.downpayLabel);

        add_title = (TextView)findViewById(R.id.add_title);

        okBtn = (LinearLayout) findViewById(R.id.okBtn);

        downpayValue = (EditText) findViewById(R.id.downpayValue);
        yearValue = (EditText) findViewById(R.id.yearValue);
        rateValue = (EditText) findViewById(R.id.rateValue);


        yearLabel= (TextView) findViewById(R.id.yearLabel);
        yearunit =  (TextView) findViewById(R.id.yearunit);
        rateLabel = (TextView) findViewById(R.id.rateLabel);
        taxLabel = (TextView) findViewById(R.id.taxLabel);
        TaxValue = (TextView) findViewById(R.id.TaxValue);
        priceValue.setText(price);
        TaxValue.setText(tax);

        if(getLanguage().contains("zh")){
            naTitle.setText("房贷计算器");

            priceLabel.setText("房屋总价");
            yearunit.setText("年");
            yearLabel.setText("贷款年限");
            downpayLabel.setText("首付");
            rateLabel.setText("利率");
            taxLabel.setText("房产税");
            add_title.setText("开始计算");

        }else{
            naTitle.setText("MORTGAGE CALC");

            priceLabel.setText("Purchase price");
            yearunit.setText("Year");
            yearLabel.setText("Mortgage Term");
            downpayLabel.setText("Down Payment");
            rateLabel.setText("Interest Rate");
            taxLabel.setText("Property Tax");
            add_title.setText("Calculate");
        }

        backBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });


        okBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent =new Intent(CalFrontActivity.this,CalResultActivity.class);

                //用Bundle携带数据
                Bundle bundle=new Bundle();
                //传递name参数为tinyphp

                bundle.putSerializable("tax", tax);
                bundle.putSerializable("price", price);
                bundle.putSerializable("downPayment", downpayValue.getText().toString());
                bundle.putSerializable("year", yearValue.getText().toString());
                bundle.putSerializable("rate", rateValue.getText().toString());
                intent.putExtras(bundle);

                startActivity(intent);
            }
        });
    }


}
