package net.lhh.apst.advancedpagerslidingtabstrip;

import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.android.volley.AuthFailureError;
import com.android.volley.DefaultRetryPolicy;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;
import com.youth.banner.Banner;
import com.youth.banner.BannerConfig;
import com.youth.banner.listener.OnBannerListener;
import com.youth.banner.loader.ImageLoader;

import net.cfg.AppCfg;
import net.lhh.apst.fragments.NewsCell;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;

public class HomeNewsActivity extends BaseActivity {
    ImageView backBtn;
    TextView  naTitle;
    TextView category_title;

    TextView category_a;
    TextView category_b;
    TextView category_c;
    TextView category_d;

    Banner banner;
    JSONArray bannerdatas;

    LinearLayout tableView;

    List typedatas = new ArrayList();
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home_news);
        backBtn = (ImageView)findViewById(R.id.home_map_go_btn);
        naTitle = (TextView)findViewById(R.id.home_map_title);
        category_title = (TextView)findViewById(R.id.category_title);
        tableView = (LinearLayout)findViewById(R.id.tableView);

        category_a = (TextView)findViewById(R.id.category_a);
        category_b = (TextView)findViewById(R.id.category_b);
        category_c = (TextView)findViewById(R.id.category_c);
        category_d = (TextView)findViewById(R.id.category_d);

        category_a.setText(" ");
        category_b.setText(" ");
        category_c.setText(" ");
        category_d.setText(" ");

        naTitle.setText("新闻资讯");
        backBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                HomeNewsActivity.this.finish();
            }
        });

        if(getLanguage().contains("zh")){
            naTitle.setText("新闻资讯");
            category_title.setText("切换分类");
        }else{
            naTitle.setText("Latest news");
            category_title.setText("Choose categories");
        }

         banner = (Banner) findViewById(R.id.banner);
        //
        banner.setImageLoader(new ImageLoader());


        //设置图片集合


        getBannerDatas();
        getTypeDatas();
    }


    private void getBannerDatas(){

        String url = "http://api.usleju.cn/catalog/news/types";

        StringBuffer sb = new StringBuffer();

        sb.append(url);


        JSONObject obj = new JSONObject();
        try {
            obj.put("language",this.getLanguage());
        } catch (JSONException e) {
            e.printStackTrace();
        }

        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.GET, sb.toString(), obj.toString(), new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject jsonObject) {
                try {

                    Integer code =  jsonObject.getInt("code");

                    if(code == 200){

                       // initHomeHouseData(jsonObject);

                        initType(jsonObject.getJSONObject("data"));

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

    private void  initType(JSONObject datas){
       // typedatas = datas;

        try{
            datas.keys();
            int i = 0;
            for (Iterator it = datas.keys();it.hasNext();){
              final   String keya = it.next().toString();
                typedatas.add(keya);

                if(i == 0){
                    category_a.setText(datas.getString(keya));

                    category_a.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            category_a.setTextColor(getResources().getColor(R.color.green));
                            category_b.setTextColor(getResources().getColor(R.color.gray));
                            category_c.setTextColor(getResources().getColor(R.color.gray));
                            category_d.setTextColor(getResources().getColor(R.color.gray));
                            getNewsDatas(keya);
                        }
                    });
                    getNewsDatas(keya);
                }else  if(i == 1){
                    category_b.setText(datas.getString(keya));
                    category_b.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            category_b.setTextColor(getResources().getColor(R.color.green));
                            category_a.setTextColor(getResources().getColor(R.color.gray));
                            category_c.setTextColor(getResources().getColor(R.color.gray));
                            category_d.setTextColor(getResources().getColor(R.color.gray));
                            getNewsDatas(keya);
                        }
                    });
                }else  if(i == 2){
                    category_c.setText(datas.getString(keya));
                    category_c.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {

                            category_c.setTextColor(getResources().getColor(R.color.green));
                            category_b.setTextColor(getResources().getColor(R.color.gray));
                            category_a.setTextColor(getResources().getColor(R.color.gray));
                            category_d.setTextColor(getResources().getColor(R.color.gray));
                            getNewsDatas(keya);
                        }
                    });
                }else  if(i == 3){
                    category_d.setText(datas.getString(keya));
                    category_d.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {

                            category_d.setTextColor(getResources().getColor(R.color.green));
                            category_b.setTextColor(getResources().getColor(R.color.gray));
                            category_c.setTextColor(getResources().getColor(R.color.gray));
                            category_a.setTextColor(getResources().getColor(R.color.gray));
                            getNewsDatas(keya);
                        }
                    });
                }
                i++;
            }

        }catch (Exception e){
            e.printStackTrace();

        }



    }

    private void  initBanner(JSONArray datas){

        try{
            bannerdatas = datas;
            ArrayList images = new ArrayList();
            ArrayList titles = new ArrayList();

            for (Integer i = 0; i < datas.length();i++){

                JSONObject obj = datas.getJSONObject(i);

                images.add(obj.getString("image"));
                titles.add(obj.getString("title"));

            }

            banner.setBannerStyle(BannerConfig.CIRCLE_INDICATOR_TITLE);
            banner.setBannerTitles(titles);
            banner.setImages(images);
            banner.isAutoPlay(true);
            banner.setOffscreenPageLimit(0);
            //设置轮播时间
            banner.setDelayTime(5000);
            //设置指示器位置（当banner模式中有指示器时）
            banner.setIndicatorGravity(BannerConfig.CENTER);
            //banner设置方法全部调用完毕时最后调用

            if (bannerdatas.length() >0){

                banner.setOnBannerListener(new OnBannerListener() {
                    @Override
                    public void OnBannerClick(int position) {

                        try{
                            JSONObject o = bannerdatas.getJSONObject(position);

                            Intent intent =new Intent(HomeNewsActivity.this,NewsDetailsActivity.class);

                            //用Bundle携带数据
                            Bundle bundle=new Bundle();
                            //传递name参数为tinyphp
                            bundle.putSerializable("id", o.getString("news_id"));
                            bundle.putSerializable("title", o.getString("title"));
                            bundle.putSerializable("imgUrl", o.getString("image"));
                            intent.putExtras(bundle);

                            startActivity(intent);
                        }catch (Exception e){
                            e.printStackTrace();
                        };



                    }
                });
            }


            banner.start();




        }catch (Exception e){
            e.printStackTrace();
        }


    }




    private void getTypeDatas(){

        String url = "http://api.usleju.cn/catalog/news/list-top-banner";

        StringBuffer sb = new StringBuffer();

        sb.append(url);
        sb.append("?area_id=").append("ma");

        JSONObject obj = new JSONObject();
        try {
            obj.put("language",this.getLanguage());
        } catch (JSONException e) {
            e.printStackTrace();
        }

        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.GET, sb.toString(), obj.toString(), new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject jsonObject) {
                try {

                    Integer code =  jsonObject.getInt("code");

                    if(code == 200){

                        // initHomeHouseData(jsonObject);

                        initBanner(jsonObject.getJSONArray("data"));

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


    private void getNewsDatas(String category){


        if(getLanguage().contains("zh")){
            showLoading("正在加载数据...");
        }else{
            showLoading("loading...");
        }



        tableView.removeAllViews();

        String url = "http://api.usleju.cn/catalog/news/list";

        StringBuffer sb = new StringBuffer();
         sb.append(url);

        sb.append("?page=").append(1);
        sb.append("&page_size=").append(50);

        if(category != null){
            sb.append(url).append("&type_id=").append(category);
        }

        JSONObject obj = new JSONObject();
        try {
            obj.put("language",this.getLanguage());
        } catch (JSONException e) {
            e.printStackTrace();
        }

        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.GET, sb.toString(), obj.toString(), new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject jsonObject) {
                try {

                    Integer code =  jsonObject.getInt("code");
                       hideLoading();
                    if(code == 200){

                        initNewsData(jsonObject);

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


    private void  initNewsData(JSONObject jsonObject){

        try{
            JSONObject  datas =  jsonObject.getJSONObject("data");

            JSONArray items = datas.getJSONArray("items");

            for (int i = 0;i < items.length();i++){
                JSONObject obj  = (JSONObject)items.get(i);
                RelativeLayout  mnews  = (RelativeLayout)getLayoutInflater().inflate(R.layout.home_news_cell, null);
                TextView title =     (TextView)mnews.findViewById(R.id.newtitle);
                TextView newCount =     (TextView)mnews.findViewById(R.id.newCount);


                NewsCell newsCell = (NewsCell)mnews.findViewById(R.id.mynewscell);

                newsCell.setTitle(obj.getString("title"));
                newsCell.setNid(obj.getString("id"));
                newsCell.setImage(obj.getString("image"));

                Random random = new Random();
                String fourRandom = random.nextInt(10000) + "";
                String fourRandoma = random.nextInt(10000) + "";

                if(getLanguage().contains("zh")){
                    newCount.setText("阅读 "+fourRandom+"  收藏 "+fourRandoma);

                }else{
                    newCount.setText(fourRandom+" read   "+fourRandoma+" bookmarked");

                }



                mnews.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {


                        NewsCell ov = (NewsCell)v.findViewById(R.id.mynewscell);
                        Intent intent =new Intent(HomeNewsActivity.this,NewsDetailsActivity.class);

                        //用Bundle携带数据
                        Bundle bundle=new Bundle();
                        //传递name参数为tinyphp
                        bundle.putSerializable("id", ov.getNid());
                        bundle.putSerializable("title", ov.getTitle());
                        bundle.putSerializable("imgUrl", ov.getImage());
                        intent.putExtras(bundle);

                        startActivity(intent);




                    }
                });

                title.setText(obj.get("title").toString());
                ImageView imageView = (ImageView)mnews.findViewById(R.id.newImg);
                tableView.addView(mnews);

                RequestQueue mQueue = Volley.newRequestQueue(HomeNewsActivity.this);

                com.android.volley.toolbox.ImageLoader imageLoader = new com.android.volley.toolbox.ImageLoader(mQueue, new com.android.volley.toolbox.ImageLoader.ImageCache() {
                    @Override
                    public Bitmap getBitmap(String url) {
                        return null;
                    }

                    @Override
                    public void putBitmap(String url, Bitmap bitmap) {

                    }
                });

                com.android.volley.toolbox.ImageLoader.ImageListener listener = com.android.volley.toolbox.ImageLoader.getImageListener(imageView,R.mipmap.home_house_default, R.mipmap.home_house_default);
                imageLoader.get(obj.getString("image"), listener);
            }


        }catch (Exception e){

            e.printStackTrace();

        }




    }
}
