package net.lhh.apst.advancedpagerslidingtabstrip;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
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

import java.util.HashMap;
import java.util.Map;

/**
 * Created by ld on 04/10/2017.
 */

public class RegisterActivity extends BaseActivity {
    ImageView backBtn;
    TextView home_map_title;
    TextView reg_title;

    EditText userName;
    EditText nickName;
    EditText password;
    EditText passwordconfirm;
    TextView liencense_title;
    Button login_Btn;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        SDKInitializer.initialize(getApplicationContext());
        setContentView(R.layout.activity_register);
        backBtn = (ImageView)findViewById(R.id.home_map_go_btn);

        home_map_title = (TextView)findViewById(R.id.home_map_title);
        reg_title = (TextView)findViewById(R.id.reg_title);
        login_Btn = (Button)findViewById(R.id.login_Btn);
        userName = (EditText)findViewById(R.id.userName);
        nickName = (EditText)findViewById(R.id.nickName);
        password = (EditText)findViewById(R.id.password);
        passwordconfirm = (EditText)findViewById(R.id.passwordconfirm);
        liencense_title = (TextView)findViewById(R.id.liencense_title);
        if(getLanguage().contains("zh")){
            home_map_title.setText("注册");
            reg_title.setText("创建账号");
            userName.setHint("请输入邮箱");
            nickName.setHint("请输入昵称");
            password.setHint("请输入6-12位密码");
            passwordconfirm.setHint("密码确认");
            login_Btn.setText("注册");
            liencense_title.setText("注册/登录代表接手米乐居使用条款");
        }else{
            home_map_title.setText("Add an account");
            reg_title.setText("Create Account");

            userName.setHint("Enter the email");
            nickName.setHint("Enter the nickname");
            password.setHint("Enter password");
            passwordconfirm.setHint("Password confirm");
            login_Btn.setText("OK");
            liencense_title.setText("By signing in you agreed to the USLEJU");
        }


        login_Btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                reg();
            }
        });


        backBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                RegisterActivity.this.finish();
            }
        });

    }

    public  void reg(){

        String regex = "\\w+(\\.\\w)*@\\w+(\\.\\w{2,3}){1,3}";


        if(!(userName.getText().toString().matches(regex))){
            if(getLanguage().contains("zh")){
                Toast.makeText(RegisterActivity.this, "请输入正确的邮箱地址", Toast.LENGTH_SHORT).show();
            }else{
                Toast.makeText(RegisterActivity.this, "the email is invalid", Toast.LENGTH_SHORT).show();
            }
            return;
        }

        if(password.getText().toString().length() < 6){
            if(getLanguage().contains("zh")){
                Toast.makeText(RegisterActivity.this, "请输入正确的密码", Toast.LENGTH_SHORT).show();
            }else{
                Toast.makeText(RegisterActivity.this, "the password is invalid", Toast.LENGTH_SHORT).show();
            }
            return;
        }


        if(passwordconfirm.getText().toString().length() < 6 || passwordconfirm.getText().toString().length() >12){
            if(getLanguage().contains("zh")){
                Toast.makeText(RegisterActivity.this, "请输入正确的密码确认", Toast.LENGTH_SHORT).show();
            }else{
                Toast.makeText(RegisterActivity.this, "the password confirm is invalid", Toast.LENGTH_SHORT).show();
            }
            return;
        }

        if(!(passwordconfirm.getText().toString().equals(password.getText().toString()))){
            if(getLanguage().contains("zh")){
                Toast.makeText(RegisterActivity.this, "两次密码输入不同", Toast.LENGTH_SHORT).show();
            }else{
                Toast.makeText(RegisterActivity.this, "the password confirm is not equals to the password", Toast.LENGTH_SHORT).show();
            }
            return;
        }

        if(getLanguage().contains("zh")){
            showLoading("正在注册...,请稍等");
        }else{
            showLoading("Creating user...,");
        }



        String url = "http://api.usleju.cn/passport/account/register";

        JSONObject obj = new JSONObject();
        try {
            obj.put("email",userName.getText());
            obj.put("password",password.getText());
            obj.put("username",nickName.getText());
        } catch (JSONException e) {
            e.printStackTrace();
        }

        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.POST, url, obj.toString(), new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject jsonObject) {
                try {
                    hideLoading();
                    Integer code =  jsonObject.getInt("code");

                    if(code == 200){
                        if(getLanguage().contains("zh")){
                            Toast.makeText(RegisterActivity.this, "注册成功,请到邮箱"+userName.getText()+"确认后登录", Toast.LENGTH_SHORT).show();
                        }else{
                            Toast.makeText(RegisterActivity.this, "Create account successfully,please confirm"+userName.getText()+",and than login", Toast.LENGTH_SHORT).show();
                        }
                        finish();
                    }else{
                        Toast.makeText(RegisterActivity.this, jsonObject.getString("message"), Toast.LENGTH_SHORT).show();

                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError arg0) {
                System.err.println(" 我日日你2");
                // CustomProgress.dissDialog();
                // callback.callback("-1", arg0.getMessage() + "", null);
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
