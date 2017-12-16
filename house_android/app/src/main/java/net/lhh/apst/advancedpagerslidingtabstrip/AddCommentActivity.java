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
import android.widget.RatingBar;
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

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by ld on 04/10/2017.
 */

public class AddCommentActivity extends BaseActivity {




    Button btn;


    ImageView backBtn;
    TextView naTitle;


    String id;

    RatingBar room_ratingbar;

    float ratinga = 5;

    EditText inputText;

    Button addComment;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        SDKInitializer.initialize(getApplicationContext());
        setContentView(R.layout.activity_add_comment);

        backBtn = (ImageView)findViewById(R.id.home_map_go_btn);

        naTitle = (TextView)findViewById(R.id.home_map_title);

        room_ratingbar = (RatingBar)findViewById(R.id.room_ratingbar);

        inputText = (EditText)findViewById(R.id.inputText);

        addComment = (Button)findViewById(R.id.addComment);



        addComment.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                addSchedule();
            }
        });

        room_ratingbar.setOnRatingBarChangeListener(new RatingBar.OnRatingBarChangeListener() {

            @Override
            public void onRatingChanged(RatingBar ratingBar, float rating, boolean fromUser) {
                ratinga = rating;
            }
        });

        id = (String) getIntent().getSerializableExtra("id");

        backBtn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                AddCommentActivity.this.finish();
            }
        });





        if(getLanguage().contains("zh")){
            naTitle.setText("添加评论");
            addComment.setText("添加");
            inputText.setHint("请输入评论");


        }else{
            naTitle.setText("Comments");
            addComment.setText("OK");
            inputText.setHint("Enter the comment");

        }
    }

    private void addSchedule(){


        if(inputText.getText() == null || inputText.getText().length() < 1){
            if(getLanguage().contains("zh")){
                Toast.makeText(AddCommentActivity.this, "请输入评价内容", Toast.LENGTH_SHORT).show();
            }else{
                Toast.makeText(AddCommentActivity.this, "Please enter the comment", Toast.LENGTH_SHORT).show();
            }
            return;

        }



        if(getLanguage().contains("zh")){
            showLoading("正在添加评论...");
        }else{
            showLoading("adding...");
        }

        StringBuffer sb = new StringBuffer();

        String url = "http://api.usleju.cn/catalog/comment/submit";

        sb.append(url);
        sb.append("?id=").append(id);

        sb.append("&type=").append("yellowpage");

        App app = (App) getApplication();
        WesUser user = app.getLastUser();

        sb.append("&access-token=").append(user.getToken());
        //sb.append("&rating=").append(ratinga);
        //sb.append("&content=").append(inputText.getText());


        JSONObject obj = new JSONObject();
        try {

            obj.put("rating",ratinga);
            obj.put("content",inputText.getText());

        } catch (Exception e) {
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
                            Toast.makeText(AddCommentActivity.this, "添加成功", Toast.LENGTH_SHORT).show();
                        }else{
                            Toast.makeText(AddCommentActivity.this, "Add successfully", Toast.LENGTH_SHORT).show();
                        }

                        Intent mIntent = new Intent();
                        //mIntent.putExtra("change01", "1000");
                        //mIntent.putExtra("change02", "2000");
                        // 设置结果，并进行传送
                        setResult(2, mIntent);
                        finish();
                    }else{
                        if(getLanguage().contains("zh")){
                            Toast.makeText(AddCommentActivity.this, "添加失败", Toast.LENGTH_SHORT).show();
                        }else{
                            Toast.makeText(AddCommentActivity.this, "Add failed", Toast.LENGTH_SHORT).show();
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

}
