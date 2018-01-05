package net.lhh.apst.advancedpagerslidingtabstrip;

import android.app.AlertDialog;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
import android.webkit.WebView;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.android.volley.AuthFailureError;
import com.android.volley.DefaultRetryPolicy;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.baidu.mapapi.SDKInitializer;
import com.mob.MobSDK;

import net.cfg.AppCfg;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import cn.sharesdk.facebook.Facebook;
import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.onekeyshare.OnekeyShare;
import cn.sharesdk.sina.weibo.SinaWeibo;
import cn.sharesdk.wechat.favorite.WechatFavorite;
import cn.sharesdk.wechat.friends.Wechat;
import cn.sharesdk.wechat.moments.WechatMoments;

/**
 * Created by ld on 04/10/2017.
 */

public class NewsDetailsActivity extends BaseActivity {
    ImageView backBtn;

    String id;
    String title;
    String imgUrl;
    TextView home_map_title;
    ImageView newshare;
    WebView webView;
    JSONObject alldata;

    private AlertDialog sharedialog;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        SDKInitializer.initialize(getApplicationContext());
        setContentView(R.layout.activity_news_details);
        backBtn = (ImageView)findViewById(R.id.home_map_go_btn);
        home_map_title = (TextView)findViewById(R.id.home_map_title);

        newshare = (ImageView)findViewById(R.id.newshare);

        webView = (WebView)findViewById(R.id.webView);

        id = (String) getIntent().getSerializableExtra("id");
        title = (String) getIntent().getSerializableExtra("title");
        imgUrl = (String) getIntent().getSerializableExtra("imgUrl");
        home_map_title.setText(title);
        backBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                NewsDetailsActivity.this.finish();
            }
        });


        newshare.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if(alldata != null){

                    try{

                      //  String url = "http://app.usleju.cn/news.html?language="+getLanguage()+"&id="+alldata.getString("id");


                        RelativeLayout vv = (RelativeLayout)getLayoutInflater().inflate(R.layout.activity_detail_share, null);


                        ImageView detail_facebook = (ImageView)vv.findViewById(R.id.detail_facebook);

                        detail_facebook.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                showShare(1);
                            }
                        });

                        ImageView detail_wx = (ImageView)vv.findViewById(R.id.detail_wx);

                        detail_wx.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                showShare(2);
                            }
                        });



                        ImageView detail_xl = (ImageView)vv.findViewById(R.id.detail_xl);


                        detail_xl.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                showShare(4);
                            }
                        });


                        ImageView detail_py = (ImageView)vv.findViewById(R.id.detail_py);


                        detail_py.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                showShare(3);
                            }
                        });

                        AlertDialog.Builder  builder=new AlertDialog.Builder(NewsDetailsActivity.this);


                        builder.setView(vv);


                        sharedialog=builder.create();

                        sharedialog.show();

                    }catch (Exception e){
                        e.printStackTrace();
                    }

                }




            }
        });

        getNewsDetail();
        MobSDK.init(this,"185b3576c3ffe");

    }

    private Bitmap getImageFromNet(String url) {
        HttpURLConnection conn = null;
        try {
            URL mURL = new URL(url);
            conn = (HttpURLConnection) mURL.openConnection();
            conn.setRequestMethod("GET"); //设置请求方法
            conn.setConnectTimeout(10000); //设置连接服务器超时时间
            conn.setReadTimeout(5000);  //设置读取数据超时时间

            conn.connect(); //开始连接

            int responseCode = conn.getResponseCode(); //得到服务器的响应码
            if (responseCode == 200) {
                //访问成功
                InputStream is = conn.getInputStream(); //获得服务器返回的流数据
                Bitmap bitmap = BitmapFactory.decodeStream(is); //根据流数据 创建一个bitmap对象
                return bitmap;

            } else {
                //访问失败

            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                conn.disconnect(); //断开连接
            }
        }
        return null;
    }

    private void showShare(int type) {

        try {

            String url = "http://app.usleju.cn/news.html?language="+getLanguage()+"&id="+alldata.getString("id");


            String location =alldata.getString("title");

            String title = alldata.getString("title");


            String allTitle =  alldata.getString("title");



            //HouseDetailActivity


            if (type == 1){
                Facebook.ShareParams sp = new  Facebook.ShareParams();
                sp.setText(location);
                sp.setText(allTitle);
                sp.setImagePath(imgUrl);

                Platform weibo = ShareSDK.getPlatform(Facebook.NAME);
                // weibo.setPlatformActionListener(paListener); // 设置分享事件回调
// 执行图文分享
                weibo.share(sp);
            } else if (type == 2){



                Platform.ShareParams sp = new   Platform.ShareParams();
                sp.setShareType(Platform.SHARE_WEBPAGE);// 一定要设置分享属性
                sp.setText(title);
                sp.setTitle(title);
                sp.setUrl(url);
               // sp.setImageData(null);
               sp.setImageUrl(imgUrl);
                //sp.setImagePath(null);
             // sp.setImageData(this.getImageFromNet(imgUrl));

                Platform qzone = ShareSDK.getPlatform (Wechat.NAME);

                qzone.share(sp);
            }else if(type == 3){



                WechatMoments.ShareParams sp = new  WechatMoments.ShareParams();
                sp.setTitle(allTitle);
                sp.setText(allTitle);
                sp.setImageUrl(imgUrl);
                sp.setUrl(url);

                Platform weibo = ShareSDK.getPlatform(WechatMoments.NAME);
                // weibo.setPlatformActionListener(paListener); // 设置分享事件回调
// 执行图文分享
                weibo.share(sp);
            }else if(type == 4){



                SinaWeibo.ShareParams sp = new  SinaWeibo.ShareParams();
                sp.setText(allTitle);
                sp.setImagePath(imgUrl);

                Platform weibo = ShareSDK.getPlatform(SinaWeibo.NAME);
                // weibo.setPlatformActionListener(paListener); // 设置分享事件回调
// 执行图文分享
                weibo.share(sp);
            }



        }catch (Exception e){
         e.printStackTrace();
        }





    }


    private void getNewsDetail(){

        if(getLanguage().contains("zh")){
            showLoading("正在加载数据...");
        }else{
            showLoading("loading...");
        }

  StringBuffer sb = new StringBuffer();

        String url = "http://api.usleju.cn/catalog/news/get";

        sb.append(url);
        sb.append("?id=").append(id);

        JSONObject obj = new JSONObject();
        try {
            obj.put("id",id );
        } catch (JSONException e) {
            e.printStackTrace();
        }

        final float scale = getResources().getDisplayMetrics().density;

        final float scaledDensity = getResources().getDisplayMetrics().scaledDensity;

        WindowManager wm = (WindowManager) this
                .getSystemService(Context.WINDOW_SERVICE);
      final   int width = wm.getDefaultDisplay().getWidth() ;

        final   int widtha =  (int) (width / scale + 0.5f) - 10;


        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.GET, sb.toString(), obj.toString(), new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject jsonObject) {
                try {

                    Integer code =  jsonObject.getInt("code");

                    if(code == 200){

                      //  initHomeBusinessData(jsonObject);
                        JSONObject data = jsonObject.getJSONObject("data");
                        alldata = data;
                        String content = data.getString("content");
                        //webView.loadData(content,"text/html", "utf-8");

                        String contents =   content.replaceAll("<img","<img style='width:"+widtha+"px;'");

                        webView.loadDataWithBaseURL(null, contents, "text/html", "utf-8", null);
                        hideLoading();

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
