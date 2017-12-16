package net.lhh.apst.advancedpagerslidingtabstrip;

import android.content.Intent;
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
import com.tencent.mm.opensdk.modelmsg.SendAuth;

import net.cfg.AppCfg;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by ld on 04/10/2017.
 */

public class LoginActivity extends BaseActivity {
    ImageView backBtn;
    ImageView wxLogin;
    TextView home_map_title;
    TextView btn_reg;
    TextView liencense_title;
    TextView login_other_title;
    TextView login_title;
    Button login_Btn;

    EditText userName;
    EditText password;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        SDKInitializer.initialize(getApplicationContext());
        setContentView(R.layout.activity_login);
        backBtn = (ImageView)findViewById(R.id.home_map_go_btn);
        wxLogin = (ImageView)findViewById(R.id.wxLogin);

        login_Btn = (Button)findViewById(R.id.login_Btn);

        home_map_title = (TextView)findViewById(R.id.home_map_title);
        login_title = (TextView)findViewById(R.id.login_title);

        btn_reg = (TextView)findViewById(R.id.btn_reg);

        liencense_title = (TextView)findViewById(R.id.liencense_title);
        login_other_title = (TextView)findViewById(R.id.login_other_title);


        userName = (EditText)findViewById(R.id.userName);
        password = (EditText)findViewById(R.id.password);

        if(getLanguage().contains("zh")){
            home_map_title.setText("登录");
            btn_reg.setText("注册");
            liencense_title.setText("注册/登录代表接手米乐居使用条款");
            login_other_title.setText("社交账号直接登录");
            login_Btn.setText("登录");
            userName.setHint("请输入邮箱");
            password.setHint("请输入密码");
            login_title.setText("账号密码登录");
        }else{
            home_map_title.setText("Login in");
            btn_reg.setText("Add an account");
            liencense_title.setText("By signing in you agreed to the USLEJU");
            login_other_title.setText("Others");
            login_Btn.setText("Login in");
            userName.setHint("Enter the email address");
            password.setHint("Enter the password");
            login_title.setText("Account and password");
        }

        login_Btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

             login();
            }
        });


        wxLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                App app = (App)getApplication();

                if (!app.mWxApi.isWXAppInstalled()) {

                    return;
                }
                final SendAuth.Req req = new SendAuth.Req();
                req.scope = "snsapi_userinfo";
                req.state = "diandi_wx_login";
                req.transaction = "wxca09ddff0b293126";
                app.mWxApi.sendReq(req);




            }
        });

        btn_reg.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(LoginActivity.this, RegisterActivity.class));
            }
        });


        backBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                LoginActivity.this.finish();
            }
        });

    }

    private void login(){

        String regex = "\\w+(\\.\\w)*@\\w+(\\.\\w{2,3}){1,3}";


if(!(userName.getText().toString().matches(regex))){
    if(getLanguage().contains("zh")){
        Toast.makeText(LoginActivity.this, "请输入正确的邮箱地址", Toast.LENGTH_SHORT).show();
    }else{
        Toast.makeText(LoginActivity.this, "the email is invalid", Toast.LENGTH_SHORT).show();
    }
    return;
}

        if(password.getText().toString().length() < 1){
            if(getLanguage().contains("zh")){
                Toast.makeText(LoginActivity.this, "请输入正确的密码", Toast.LENGTH_SHORT).show();
            }else{
                Toast.makeText(LoginActivity.this, "the password is invalid", Toast.LENGTH_SHORT).show();
            }
            return;
        }
        if(getLanguage().contains("zh")){
            showLoading("正在登陆...,请稍等");
        }else{
            showLoading("Logining in...,");
        }


        String url = "http://api.usleju.cn/passport/account/login";

        JSONObject obj = new JSONObject();
        try {
            obj.put("username",userName.getText());
            obj.put("password",password.getText());
        } catch (JSONException e) {
            e.printStackTrace();
        }

        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.POST, url, obj.toString(), new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject jsonObject) {
                try {

                    Integer code =  jsonObject.getInt("code");

                    if(code == 200){
                       JSONObject data = jsonObject.getJSONObject("data");
                        String access_token = data.getString("access_token");
                      saveLoginInfor(access_token);
//message
                    }else{
                        Toast.makeText(LoginActivity.this, jsonObject.getString("message"), Toast.LENGTH_SHORT).show();

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

    private void saveLoginInfor(String access_token){
        WesUser user = new WesUser();
        user.setPhone(userName.getText().toString());
        user.setPassword(password.getText().toString());
        user.setToken(access_token);
        user.setAvatar("11");
        user.setName(userName.getText().toString());

       App app = (App) getApplication();
        app.deleteUser();
        app.addUser(user);


        if(getLanguage().contains("zh")){
            Toast.makeText(LoginActivity.this, "登录成功", Toast.LENGTH_SHORT).show();
        }else{
            Toast.makeText(LoginActivity.this, "Login in successfully", Toast.LENGTH_SHORT).show();
        }


        if(app.mFourthFragment !=null)
            app.mFourthFragment.aloadView();
        hideLoading();
        this.finish();
    }

}
