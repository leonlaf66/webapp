package net.lhh.apst.advancedpagerslidingtabstrip;

import android.app.Dialog;
import android.app.TimePickerDialog;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;


import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import android.app.Activity;
import android.app.DatePickerDialog;
import android.app.Dialog;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.DatePicker;
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

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by ld on 04/10/2017.
 */

public class AddScheduleActivity extends BaseActivity {



    int mYear, mMonth, mDay,hour, minute;
    Button btn;
    TextView date_title;
    TextView startTime_title;
    TextView endTime_title;
    final int DATE_DIALOG = 1;
    final int TIME_DIALOG = 2;

     int current;

    ImageView backBtn;
    TextView naTitle;

    ImageView choose_date_btn;
    ImageView choose_starttime_btn;
    ImageView choose_endtime_btn;

    TextView endTime_choose;

    TextView startTime_choose;

    TextView date_choose;
    TextView add_title;

    LinearLayout okBtn;

    String id;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        SDKInitializer.initialize(getApplicationContext());
        setContentView(R.layout.activity_add_schedule);
        okBtn = (LinearLayout)findViewById(R.id.okBtn);

        backBtn = (ImageView)findViewById(R.id.home_map_go_btn);
        add_title = (TextView)findViewById(R.id.add_title);
        endTime_choose = (TextView)findViewById(R.id.endTime_choose);
        startTime_choose = (TextView)findViewById(R.id.startTime_choose);
        date_choose = (TextView)findViewById(R.id.date_choose);



        naTitle = (TextView)findViewById(R.id.home_map_title);
        date_title = (TextView)findViewById(R.id.date_title);

        startTime_title = (TextView)findViewById(R.id.startTime_title);
        endTime_title = (TextView)findViewById(R.id.endTime_title);

        choose_date_btn = (ImageView)findViewById(R.id.choose_date_btn);
        choose_starttime_btn = (ImageView)findViewById(R.id.choose_starttime_btn);
        choose_endtime_btn = (ImageView)findViewById(R.id.choose_endtime_btn);

        final Calendar ca = Calendar.getInstance();
        mYear = ca.get(Calendar.YEAR);
        mMonth = ca.get(Calendar.MONTH);
        mDay = ca.get(Calendar.DAY_OF_MONTH);
        hour = ca.get(Calendar.HOUR_OF_DAY);
        minute = ca.get(Calendar.MINUTE);
        id = (String) getIntent().getSerializableExtra("id");

        backBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AddScheduleActivity.this.finish();
            }
        });


        choose_date_btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showDialog(DATE_DIALOG);
            }
        });


        choose_starttime_btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                current = 1;

                showDialog(TIME_DIALOG);

            }
        });


        choose_endtime_btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                current = 2;

                showDialog(TIME_DIALOG);
            }
        });

        okBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                addSchedule();
            }
        });





        if(getLanguage().contains("zh")){
            naTitle.setText("看房");

            endTime_choose.setText("结束时间");
            startTime_choose.setText("开始时间");
            date_choose.setText("日期选择");
            add_title.setText("添加");

        }else{
            naTitle.setText("SCHEDULE TOUR");

            date_choose.setText("Choose date");
            startTime_choose.setText("Start time");
           endTime_choose.setText("End time");


            add_title.setText("OK");
        }
    }

    private void addSchedule(){

       // endTime_choose.setText("结束时间");
       // startTime_choose.setText("开始时间");
       // date_choose.setText("日期选择");

        String cdate = date_title.getText().toString();

        String cstart = startTime_title.getText().toString();

        String cend = endTime_title.getText().toString();

        if(cdate.length() < 1){
            if(getLanguage().contains("zh")){
                Toast.makeText(AddScheduleActivity.this, "请选择日期", Toast.LENGTH_SHORT).show();
            }else{
                Toast.makeText(AddScheduleActivity.this, "Please choose the date", Toast.LENGTH_SHORT).show();
            }
            return;

        }

        if(cstart.length() < 1){
            if(getLanguage().contains("zh")){
                Toast.makeText(AddScheduleActivity.this, "请选择开始时间", Toast.LENGTH_SHORT).show();
            }else{
                Toast.makeText(AddScheduleActivity.this, "Please choose the start time", Toast.LENGTH_SHORT).show();
            }
            return;
        }

        if(cend.length() < 1){
            if(getLanguage().contains("zh")){
                Toast.makeText(AddScheduleActivity.this, "请选择结束时间", Toast.LENGTH_SHORT).show();
            }else{
                Toast.makeText(AddScheduleActivity.this, "Please choose the end time", Toast.LENGTH_SHORT).show();
            }
            return;
        }
        App app = (App) getApplication();
        WesUser user = app.getLastUser();

        if(getLanguage().contains("zh")){
            showLoading("正在添加行程...");
        }else{
            showLoading("adding...");
        }

        StringBuffer sb = new StringBuffer();

        String url = "http://api.usleju.cn/estate/house/tour";

        sb.append(url);
        sb.append("?id=").append(id);
        sb.append("&access-token=").append(user.getToken());

        JSONObject obj = new JSONObject();
        try {

            obj.put("id",id );
            obj.put("day",cdate );
            obj.put("time_start",cstart );
            obj.put("time_end",cend );
        } catch (JSONException e) {
            e.printStackTrace();
        }



        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.POST, sb.toString(), obj.toString(), new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject jsonObject) {
                try {
                    hideLoading();
                    Integer code =  jsonObject.getInt("code");

                    if(code == 200){

                        if(getLanguage().contains("zh")){
                            Toast.makeText(AddScheduleActivity.this, "添加成功", Toast.LENGTH_SHORT).show();
                        }else{
                            Toast.makeText(AddScheduleActivity.this, "Add successfully", Toast.LENGTH_SHORT).show();
                        }

                     finish();
                    }else{
                        if(getLanguage().contains("zh")){
                            Toast.makeText(AddScheduleActivity.this, "添加失败", Toast.LENGTH_SHORT).show();
                        }else{
                            Toast.makeText(AddScheduleActivity.this, "Add failed", Toast.LENGTH_SHORT).show();
                        }

                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError arg0) {
                hideLoading();
            }
        }) {
            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                HashMap<String, String> headers = new HashMap<String, String>();
                try {
                    // MCrypt mCrypt = new MCrypt();
                    // headers.put("accept", "text/json");
                    headers.put("app-token",  AppCfg.TOKEN);
                    headers.put("language", getLanguage());
                } catch (Exception e) {
                    e.printStackTrace();
                }
                return headers;
            }
        };

        jsonObjectRequest.setRetryPolicy(new DefaultRetryPolicy(5 * 1000, 1, 1.0f));

        App.getHttpQueue().add(jsonObjectRequest);
       //


    }


    @Override
    protected Dialog onCreateDialog(int id) {
        switch (id) {

            case DATE_DIALOG:
                return new DatePickerDialog(this, mdateListener, mYear, mMonth, mDay);
            case TIME_DIALOG:
                return new TimePickerDialog(this, mtimeListener, hour, minute, true);
        }
        return null;
    }

    /**
     * 设置日期 利用StringBuffer追加
     */
    public void display() {

        date_title.setText(new StringBuffer().append(mYear).append("-").append(mMonth + 1).append("-").append(mDay));
    }


    private TimePickerDialog.OnTimeSetListener mtimeListener = new TimePickerDialog.OnTimeSetListener() {

        @Override
        public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
           if(current == 1){
               startTime_title.setText(hourOfDay+":"+minute+"");

           }else  if(current == 2){
               endTime_title.setText(hourOfDay+":"+minute+"");
           }
        }
    };

    private DatePickerDialog.OnDateSetListener mdateListener = new DatePickerDialog.OnDateSetListener() {

        @Override
        public void onDateSet(DatePicker view, int year, int monthOfYear,
                              int dayOfMonth) {
            mYear = year;
            mMonth = monthOfYear;
            mDay = dayOfMonth;
            display();
        }
    };

}
