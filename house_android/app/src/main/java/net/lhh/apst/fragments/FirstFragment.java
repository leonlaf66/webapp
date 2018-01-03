package net.lhh.apst.fragments;

import android.app.AlertDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.graphics.drawable.LayerDrawable;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RatingBar;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;


import com.android.volley.AuthFailureError;
import com.android.volley.DefaultRetryPolicy;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;
import com.bumptech.glide.Glide;


import net.cfg.AppCfg;
import net.lhh.apst.advancedpagerslidingtabstrip.App;
import net.lhh.apst.advancedpagerslidingtabstrip.HomeMapActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.HomeMapSearchActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.HomeNewsActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.HomeServiceCenterActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.HomeServiceDetialActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.HouseDetailActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.HouseDetailsActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.HouseListActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.IconTabActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.LoadingDialog;
import net.lhh.apst.advancedpagerslidingtabstrip.LoginActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.MainActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.NewsDetailsActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.NewsListActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.R;
import net.lhh.apst.advancedpagerslidingtabstrip.RegionActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.SearchActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.ServiceDetailsActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.ZQImageViewRoundOval;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;


/**
 * Created by linhonghong on 2017/8/11.
 */
public class FirstFragment extends BaseFragment{

    LinearLayout scrollView;
    RelativeLayout newsHeader;
    LayoutInflater inflater;

    RelativeLayout chineseFlag;
    RelativeLayout englishFlag;

    TextView home_zhoubian_title;
    TextView home_news_title;
    TextView home_fangguan_title;
    TextView home_dituzhaofang_title;
    TextView  home_location_title;
    TextView searchText;

    private AlertDialog sharedialog;

    JSONObject hotAreas = null;

    public static FirstFragment instance() {
        FirstFragment view = new FirstFragment();
		return view;
	}
	private void loadLanguage(){


        IconTabActivity tac = (IconTabActivity)getActivity();
        tac.loadDataByLanguage();

        if(getLanguage().contains("zh")){
            home_zhoubian_title.setText("周边房源");
            home_news_title.setText("新闻资讯");
            home_fangguan_title.setText("房管中心");
            home_dituzhaofang_title.setText("购房流程");
            searchText.setText("搜索城市，邮编，地址或房源号");
        }else{
            home_zhoubian_title.setText("Nearby");
            home_news_title.setText("News");
            home_fangguan_title.setText("Pro services");
            home_dituzhaofang_title.setText("Work flows");
            searchText.setText("Search Address,City or Zip");
        }

        loadDatas();


    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        this.inflater = inflater;
        View view = inflater.inflate(R.layout.first_fragment, null);
        scrollView = (LinearLayout)view.findViewById(R.id.homescrollViewnew);
        chineseFlag = (RelativeLayout)view.findViewById(R.id.chineseFlag);

        englishFlag = (RelativeLayout)view.findViewById(R.id.englishFlag);
        home_location_title = view.findViewById(R.id.home_location_title);

        searchText = view.findViewById(R.id.searchText);


        home_zhoubian_title = (TextView)view.findViewById(R.id.home_zhoubian_title);
        home_news_title = (TextView)view.findViewById(R.id.home_news_title);
        home_fangguan_title = (TextView)view.findViewById(R.id.home_fangguan_title);
        home_dituzhaofang_title = (TextView)view.findViewById(R.id.home_dituzhaofang_title);


        RelativeLayout home_zhoubian_view = (RelativeLayout)view.findViewById(R.id.home_zhoubian_view);
        RelativeLayout  home_news_view =  (RelativeLayout)view.findViewById(R.id.home_news_view);
        RelativeLayout home_service_center_view = (RelativeLayout)view.findViewById(R.id.home_service_center_view);
        RelativeLayout  home_map_search_view = (RelativeLayout)view.findViewById(R.id.home_map_search_view);
        initViewDatas();

        RelativeLayout  searchBar =  (RelativeLayout)view.findViewById(R.id.searchBar);


        LinearLayout regionBtn = (LinearLayout)view.findViewById(R.id.regionBtn);


        regionBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

               // getActivity().startActivity(new Intent(getActivity(), RegionActivity.class));

                if(hotAreas != null){

                    try{
                        LinearLayout vv = (LinearLayout)getActivity().getLayoutInflater().inflate(R.layout.region, null);

                        ImageView a_img = vv.findViewById(R.id.a_img);
                        ImageView b_img = vv.findViewById(R.id.b_img);
                        ImageView c_img = vv.findViewById(R.id.c_img);

                        ImageView d_img = vv.findViewById(R.id.d_img);
                        ImageView e_img = vv.findViewById(R.id.e_img);

                        TextView a_title =  vv.findViewById(R.id.a_title);
                        TextView b_title =  vv.findViewById(R.id.b_title);
                        TextView c_title =  vv.findViewById(R.id.c_title);

                        TextView d_title =  vv.findViewById(R.id.d_title);
                        TextView e_title =  vv.findViewById(R.id.e_title);



                        final   JSONObject aobject = hotAreas.getJSONObject("ga");
                        final   JSONObject bobject = hotAreas.getJSONObject("ny");
                        final  JSONObject cobject = hotAreas.getJSONObject("ma");

                        final JSONObject dobject = hotAreas.getJSONObject("ca");
                        final JSONObject eobject = hotAreas.getJSONObject("il");

                        a_title.setText(aobject.getString("desc"));
                        b_title.setText(bobject.getString("desc"));
                        c_title.setText(cobject.getString("desc"));

                        d_title.setText(dobject.getString("desc"));
                        e_title.setText(eobject.getString("desc"));

                        Glide.with(getActivity())
                                .load(dobject.getString("image_url"))
                                .into(d_img);


                        Glide.with(getActivity())
                                .load(eobject.getString("image_url"))
                                .into(e_img);


                        Glide.with(getActivity())
                                .load(aobject.getString("image_url"))
                                .into(a_img);


                        Glide.with(getActivity())
                                .load(bobject.getString("image_url"))
                                .into(b_img);



                        Glide.with(getActivity())
                                .load(cobject.getString("image_url"))
                                .into(c_img);


                        e_img.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                App app = (App)getActivity().getApplication();
                                app.area ="il";
                                sharedialog.hide();

                                try{
                                    home_location_title.setText(eobject.getString("name"));
                                }catch (Exception e){
                                    e.printStackTrace();
                                }
                                loadDatas();
                                ((IconTabActivity) getActivity()).onRefresha();
                            }
                        });

                        d_img.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                App app = (App)getActivity().getApplication();
                                app.area ="ca";
                                sharedialog.hide();

                                try{
                                    home_location_title.setText(dobject.getString("name"));
                                }catch (Exception e){
                                    e.printStackTrace();
                                }
                                loadDatas();
                                ((IconTabActivity) getActivity()).onRefresha();
                            }
                        });


                        a_img.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                App app = (App)getActivity().getApplication();
                                app.area ="ga";
                                sharedialog.hide();
                                try{
                                    home_location_title.setText(aobject.getString("name"));
                                }catch (Exception e){
                                    e.printStackTrace();
                                }
                                loadDatas();

                                ((IconTabActivity) getActivity()).onRefresha();
                            }
                        });

                        b_img.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                App app = (App)getActivity().getApplication();
                                app.area ="ny";
                                sharedialog.hide();
                                try{
                                    home_location_title.setText(bobject.getString("name"));
                                }catch (Exception e){
                                    e.printStackTrace();
                                }
                                loadDatas();
                                ((IconTabActivity) getActivity()).onRefresha();
                            }
                        });

                        c_img.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                App app = (App)getActivity().getApplication();
                                app.area ="ma";
                                sharedialog.hide();

                                try{
                                    home_location_title.setText(cobject.getString("name"));
                                }catch (Exception e){
                                    e.printStackTrace();
                                }
                                loadDatas();
                                ((IconTabActivity) getActivity()).onRefresha();
                            }
                        });


                        AlertDialog.Builder  builder=new AlertDialog.Builder(getActivity());


                        builder.setView(vv);


                        sharedialog=builder.create();
                        //sharedialog.setTitle("房屋类型选择");


                        sharedialog.show();

                    }catch (Exception e){
                        e.printStackTrace();
                    }


                }

            }
        });



        searchBar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                getActivity().startActivity(new Intent(getActivity(),SearchActivity.class));

            }
        });

        chineseFlag.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(getLanguage().contains("en")){
                    setLanguage("zh-CN");
                    chineseFlag.setBackgroundColor(Color.argb(1,222,222,222));
                    englishFlag.setBackgroundColor(Color.argb(1,242,242,242));
                    loadLanguage();
                    ((IconTabActivity) getActivity()).initLang();
                }

            }
        });

        englishFlag.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(getLanguage().contains("zh")){
                    setLanguage("en-US");
                    englishFlag.setBackgroundColor(Color.argb(1,222,222,222));
                    chineseFlag.setBackgroundColor(Color.argb(1,242,242,242));
                    loadLanguage();
                    ((IconTabActivity) getActivity()).initLang();
                }


            }
        });

        home_zhoubian_view.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent =new Intent(getActivity(),HomeMapActivity.class);

                //用Bundle携带数据
                Bundle bundle=new Bundle();
                //传递name参数为tinyphp
                bundle.putSerializable("home", "1");

                intent.putExtras(bundle);

                startActivity(intent);

            }
        });



        home_news_view.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                getActivity().startActivity(new Intent(getActivity(),HomeNewsActivity.class));

            }
        });

        home_service_center_view.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                getActivity().startActivity(new Intent(getActivity(), HomeServiceCenterActivity.class));

            }
        });

        home_map_search_view.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                getActivity().startActivity(new Intent(getActivity(), HomeMapSearchActivity.class));

            }
        });

        loadLanguage();
        getHotAreaDatas();
        addVersion();
        new UpdateManager(getActivity()).checkUpdate();
        return view;
    }

    private void loadDatas(){

        App app = (App)getActivity().getApplication();

        if(app.getLanguage().contains("zh")){
            showLoading("正在加载数据...");
        }else{
            showLoading("loading...");
        }


        scrollView.removeAllViews();
        this.getHomeNewsDatas();
    }

    private void  initHomeNewsData(JSONObject jsonObject){


        RelativeLayout  mnewsHeader  = (RelativeLayout)inflater.inflate(R.layout.home_news_cell_header, null);
        scrollView.addView(mnewsHeader);

        TextView titleText = (TextView)mnewsHeader.findViewById(R.id.newsHeaderTitle);
        TextView newsHeaderMore = (TextView)mnewsHeader.findViewById(R.id.newsHeaderMore);
        if(getLanguage().contains("zh")){
            titleText.setText("新闻资讯");
            newsHeaderMore.setText("查看更多");
        }else{
            titleText.setText("Latest news");
            newsHeaderMore.setText("more");
        }

        newsHeaderMore.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                getActivity().startActivity(new Intent(getActivity(), HomeNewsActivity.class));

            }
        });


        try{
            JSONArray  datas =  jsonObject.getJSONArray("data");
            for (int i = 0;i < datas.length();i++){
                JSONObject obj  = (JSONObject)datas.get(i);
                RelativeLayout  mnews  = (RelativeLayout)inflater.inflate(R.layout.home_news_cell, null);
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
                        Intent intent =new Intent(getActivity(),NewsDetailsActivity.class);

                        //用Bundle携带数据
                        Bundle bundle=new Bundle();
                        //传递name参数为tinyphp
                        bundle.putSerializable("id", ov.getNid());
                        bundle.putSerializable("title", ov.getTitle());
                        bundle.putSerializable("imgUrl", ov.getImage());
                        intent.putExtras(bundle);

                        getActivity().startActivity(intent);




                    }
                });

                title.setText(obj.get("title").toString());
                ImageView imageView = (ImageView)mnews.findViewById(R.id.newImg);
                scrollView.addView(mnews);

                Glide.with(getActivity())
                        .load(obj.getString("image"))
                        .into(imageView);


            }
            this.getHomeHouseDatas();

        }catch (Exception e){

            e.printStackTrace();

        }




    }


    private void  initHomeHouseData(JSONObject jsonObject){
        RelativeLayout  mhouseHeader  = (RelativeLayout)inflater.inflate(R.layout.home_house_cell_header, null);
         scrollView.addView(mhouseHeader);

        TextView titleText = (TextView)mhouseHeader.findViewById(R.id.newsHeaderTitle);
        TextView newsHeaderMore = (TextView)mhouseHeader.findViewById(R.id.newsHeaderMore);
        if(getLanguage().contains("zh")){
            titleText.setText("推荐房源");
            newsHeaderMore.setText("查看更多");
        }else{
            titleText.setText("Recommended");
            newsHeaderMore.setText("more");
        }

        newsHeaderMore.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                getActivity().startActivity(new Intent(getActivity(), HouseListActivity.class));

            }
        });

        try{
            JSONArray  datas =  jsonObject.getJSONArray("data");
            for (int i = 0;i < datas.length();i++){
                JSONObject obj  = (JSONObject)datas.get(i);
                RelativeLayout  house  = (RelativeLayout)inflater.inflate(R.layout.home_house_cell, null);

                HouseCell houseCell = house.findViewById(R.id.myhousecell);
                houseCell.nid = obj.getString("id");

                house.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        try {

                            HouseCell houseCella = v.findViewById(R.id.myhousecell);
                            Intent intent =new Intent(getActivity(),HouseDetailsActivity.class);

                            //用Bundle携带数据
                            Bundle bundle=new Bundle();
                            //传递name参数为tinyphp
                            bundle.putSerializable("id", houseCella.nid);

                            intent.putExtras(bundle);

                            startActivity(intent);

                        }catch (Exception e){
                              e.printStackTrace();
                        }



                    }
                });

                TextView title =     (TextView)houseCell.findViewById(R.id.housetitle);

                TextView houselocation =     (TextView)houseCell.findViewById(R.id.houselocation);

                TextView houseInfor =     (TextView)houseCell.findViewById(R.id.houseInfor);

                TextView priceLabel =     (TextView)houseCell.findViewById(R.id.priceLabel);
                TextView priceValue =     (TextView)houseCell.findViewById(R.id.priceValue);

                TextView statusLabel =     (TextView)houseCell.findViewById(R.id.statusLabel);

                TextView marketLabel =     (TextView)houseCell.findViewById(R.id.marketLabel);


                title.setText(obj.get("name").toString());
                houselocation.setText(obj.get("location").toString());
                priceValue.setText(obj.get("list_price").toString());
                if(getLanguage().contains("zh")){

                    String infora = "卧室 "+obj.get("no_bedrooms")+"| 全卫 "+obj.get("no_full_baths")+" 半卫 "+obj.get("no_half_baths")+" | 居住面积 "+obj.get("square_feet");
                    houseInfor.setText(infora);
                    priceLabel.setText("售价：");
                }else{
                    String infora = obj.get("no_bedrooms")+"beds  "+obj.get("no_full_baths")+"baths "+"  "+obj.get("square_feet");
                    houseInfor.setText(infora);
                    priceLabel.setText("Price：");

                }

                statusLabel.setText(obj.get("status_name").toString());
                marketLabel.setText(obj.get("list_days_description").toString());


                ImageView imageView = (ImageView)houseCell.findViewById(R.id.houseImage);
                scrollView.addView(house);

                Glide.with(getActivity())
                        .load(obj.getString("image"))
                        .into(imageView);
            }
           this.getHomeBusinessDatas();

        }catch (Exception e){

            e.printStackTrace();

        }




    }



    private void getHomeHouseDatas(){

        String url = "http://api.usleju.cn/estate/house/top";

        JSONObject obj = new JSONObject();
        try {
            obj.put("language",this.getLanguage());
        } catch (JSONException e) {
            e.printStackTrace();
        }

        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.GET, url, obj.toString(), new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject jsonObject) {
                try {

                    Integer code =  jsonObject.getInt("code");

                    if(code == 200){

                        initHomeHouseData(jsonObject);

                    }
                    hideLoading();
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
                    App app =  (App)getActivity().getApplication();
                    headers.put("area-id",  app.area);
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
       ////

    }


    private void getHomeNewsDatas(){

        String url = "http://api.usleju.cn/catalog/news/latest";

        JSONObject obj = new JSONObject();
        try {
            obj.put("language",this.getLanguage());
        } catch (JSONException e) {
            e.printStackTrace();
        }

        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.GET, url, obj.toString(), new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject jsonObject) {
                try {
                    hideLoading();
                 Integer code =  jsonObject.getInt("code");

                    if(code == 200){

                        initHomeNewsData(jsonObject);

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
                    App app =  (App)getActivity().getApplication();
                    headers.put("area-id",  app.area);
                      headers.put("app-token", AppCfg.TOKEN);
                      headers.put("language", getLanguage());
                } catch (Exception e) {
                    e.printStackTrace();
                }
                return headers;
            }
        };

        jsonObjectRequest.setRetryPolicy(new DefaultRetryPolicy(5 * 1000, 1, 1.0f));

        App.getHttpQueue().add(jsonObjectRequest);
       ////

        }


    private void getHomeBusinessDatas(){

        String url = "http://api.usleju.cn/catalog/yellow-page/recommends";

        JSONObject obj = new JSONObject();
        try {
            obj.put("language",this.getLanguage());
        } catch (JSONException e) {
            e.printStackTrace();
        }

        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.GET, url, obj.toString(), new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject jsonObject) {
                try {

                    Integer code =  jsonObject.getInt("code");

                    if(code == 200){

                        initHomeBusinessData(jsonObject);

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
                    App app =  (App)getActivity().getApplication();
                    headers.put("area-id",  app.area);
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
      // //

    }

    private void  initHomeBusinessData(JSONObject jsonObject){

        RelativeLayout  serviceHeader  = (RelativeLayout)inflater.inflate(R.layout.home_service_cell_header, null);
        scrollView.addView(serviceHeader);
        TextView titleText = (TextView)serviceHeader.findViewById(R.id.newsHeaderTitle);
        TextView newsHeaderMore = (TextView)serviceHeader.findViewById(R.id.newsHeaderMore);
        if(getLanguage().contains("zh")){
            titleText.setText("推荐商家");
            newsHeaderMore.setText("查看更多");
        }else{
            titleText.setText("Recommended");
            newsHeaderMore.setText("more");
        }

        newsHeaderMore.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                getActivity().startActivity(new Intent(getActivity(), HomeServiceCenterActivity.class));

            }
        });

        try{
            JSONArray  datas =  jsonObject.getJSONArray("data");
            for (int i = 0;i < datas.length();i++) {
                JSONObject obj = (JSONObject) datas.get(i);
                RelativeLayout house = (RelativeLayout) inflater.inflate(R.layout.home_service_cell, null);
                TextView servicetitle = (TextView) house.findViewById(R.id.servicetitle);

                LinearLayout  serContent = (LinearLayout) house.findViewById(R.id.serContent);



                JSONArray items = obj.getJSONArray("items");

                for (int j = 0; j < items.length();j++){
                   final JSONObject item = items.getJSONObject(j);
                    RelativeLayout ov = (RelativeLayout) inflater.inflate(R.layout.home_service_cell_item, null);

                    ov.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            try{
                                Intent intent =new Intent(getActivity(),HomeServiceDetialActivity.class);

                                //用Bundle携带数据
                                Bundle bundle=new Bundle();
                                //传递name参数为tinyphp
                                bundle.putSerializable("id", item.getString("id"));

                                intent.putExtras(bundle);

                                startActivity(intent);
                            }catch (Exception e){
                                e.printStackTrace();
                            }



                        }
                    });

                    RatingBar room_ratingbar = (RatingBar)ov.findViewById(R.id.room_ratingbar);//圆形图片
                    LayerDrawable ld_stars = (LayerDrawable)room_ratingbar.getProgressDrawable();
                    room_ratingbar.setRating((float) item.getDouble("rating"));
                    ld_stars.getDrawable(2).setColorFilter(getResources().getColor(R.color.green), PorterDuff.Mode.SRC_ATOP);
                    TextView title = (TextView) ov.findViewById(R.id.servicetitle);
                    title.setText(item.get("name").toString());
                    ImageView imageView = (ImageView)ov.findViewById(R.id.newImg);//圆形图片
                     serContent.addView(ov);

                    Glide.with(getActivity())
                            .load(item.getString("photo"))
                            .into(imageView);



                    if(j>4){
                        break;
                    }
                }

                servicetitle.setText(obj.get("name").toString());
                //ImageView imageView = (ImageView) house.findViewById(R.id.houseImage);
                scrollView.addView(house);

            }


        }catch (Exception e){

            e.printStackTrace();

        }




    }




    private void initViewDatas(){




    }




    private void getHotAreaDatas(){

        String url = "http://api.usleju.cn/estate/area/list";

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

                        hotAreas = jsonObject.getJSONObject("data");

                       // initHot(jsonObject.getJSONObject("data"));
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


    }







    private void addVersion(){




        String url = "http://api.usleju.cn/support/configs/submit?app_id=android";

        JSONObject obj = new JSONObject();
        try {
            obj.put("config_id","androidVersion");
            obj.put("config_content","7.0");
        } catch (JSONException e) {
            e.printStackTrace();
        }

        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.POST, url, obj.toString(), new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject jsonObject) {
                try {

                    Integer code =  jsonObject.getInt("code");

                    if(code == 200){

//message
                    }else{


                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError arg0) {
int a = 1;
            }
        }) {
            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                HashMap<String, String> headers = new HashMap<String, String>();
                try {

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
