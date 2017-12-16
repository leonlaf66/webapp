package net.lhh.apst.advancedpagerslidingtabstrip;

import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

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

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/**
 * Created by ld on 12/10/2017.
 */

public class MoreInformationActivity extends BaseActivity {
    ImageView backBtn;
    TextView home_map_title;
    String id ;

    LinearLayout moreInforcontent;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_house_more_infor);
        id = (String) getIntent().getSerializableExtra("id");

        backBtn = (ImageView)findViewById(R.id.home_map_go_btn);

        home_map_title = (TextView)findViewById(R.id.home_map_title);

        moreInforcontent = (LinearLayout)findViewById(R.id.moreInforcontent);

        if(getLanguage().contains("zh")){
            home_map_title.setText("更多信息");
        }else{
            home_map_title.setText("More informations");
        }


        backBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        getDetail();

    }

    private void initDetail(JSONObject data ){

        try{

            JSONArray details = data.getJSONArray("details");


            for(int i = 0; i< details.length();i++){
                JSONObject obj = details.getJSONObject(i);
                LinearLayout house  = (LinearLayout) getLayoutInflater().inflate(R.layout.house_more_infor_item_title, null);

                TextView tv = house.findViewById(R.id.tv_value);
                tv.setText(obj.getString("title"));
                moreInforcontent.addView(house);

                JSONObject items = obj.getJSONObject("items");



                for(Iterator it =  items.keys();it.hasNext();){
                    JSONObject co = items.getJSONObject(it.next().toString());

                    LinearLayout houseitem  = (LinearLayout) getLayoutInflater().inflate(R.layout.house_more_infor_item, null);

                    TextView tvitem = houseitem.findViewById(R.id.tv_value);
                    tvitem.setText(co.getString("title")+":"+co.getString("value"));

                    moreInforcontent.addView(houseitem);
                }

            }


        }catch (Exception e){
            e.printStackTrace();
        }


    }



    private void getDetail(){

        if(getLanguage().contains("zh")){
            showLoading("正在加载数据...");
        }else{
            showLoading("loading...");
        }

        StringBuffer sb = new StringBuffer();

        String url = "http://api.usleju.cn/estate/house/get";

        sb.append(url);
        sb.append("?id=").append(id);

        JSONObject obj = new JSONObject();
        try {
            obj.put("id",id );
        } catch (JSONException e) {
            e.printStackTrace();
        }



        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.GET, sb.toString(), obj.toString(), new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject jsonObject) {
                try {
                    hideLoading();
                    Integer code =  jsonObject.getInt("code");

                    if(code == 200){
                        JSONObject data = jsonObject.getJSONObject("data");

                        initDetail(data);

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
