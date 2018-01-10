package net.lhh.apst.advancedpagerslidingtabstrip;

import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.WindowManager;
import android.webkit.WebView;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.DefaultRetryPolicy;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.baidu.mapapi.SDKInitializer;
import com.baidu.mapapi.clusterutil.clustering.Cluster;
import com.baidu.mapapi.clusterutil.clustering.ClusterItem;
import com.baidu.mapapi.clusterutil.clustering.ClusterManager;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.MapStatus;
import com.baidu.mapapi.map.MapStatusUpdateFactory;
import com.baidu.mapapi.map.MapView;
import com.baidu.mapapi.map.OverlayOptions;
import com.baidu.mapapi.map.PolygonOptions;
import com.baidu.mapapi.map.Stroke;
import com.baidu.mapapi.model.LatLng;
import com.bumptech.glide.Glide;
import com.mob.MobSDK;
import com.youth.banner.Banner;
import com.youth.banner.BannerConfig;
import com.youth.banner.listener.OnBannerListener;
import com.youth.banner.loader.ImageLoader;

import net.cfg.AppCfg;
import net.lhh.apst.fragments.HouseRecomentCell;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cn.sharesdk.facebook.Facebook;
import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.sina.weibo.SinaWeibo;
import cn.sharesdk.wechat.friends.Wechat;
import cn.sharesdk.wechat.moments.WechatMoments;

/**
 * Created by ld on 04/10/2017.
 */

public class HouseDetailsActivity extends BaseActivity implements BaiduMap.OnMapLoadedCallback {
    ImageView backBtn;

    String id;
    String title;
    String imgUrl;
    TextView home_map_title;
    ImageView newshare;
    ImageView   newlike;

    JSONObject alldata;

    Banner banner;
    JSONArray bannerdatas;

    private MapView mMapView = null;
    BaiduMap mBaiduMap;


    MapStatus ms;
    private ClusterManager<MyItem> mClusterManager;



    private AlertDialog sharedialog;

    TextView locationLabel;
    TextView priceLabel;


    TextView house_detial_bed;
    TextView house_detial_bed_value;

    TextView house_detial_living_area;
    TextView house_detial_living_area_value;



    TextView house_detial_type;
    TextView house_detial_type_value;

    TextView house_detial_bath;
    TextView house_detial_bath_value;

    TextView house_detial_region;

    TextView house_detial_region_value;
    TextView house_detial_moreinformation;

    TextView house_detial_touz_value;
    TextView house_detial_touz_title_value;


    TextView house_detial_touz_a;
    TextView house_detial_touz_title_a;

    TextView house_detial_touz_value_a;
    TextView house_detial_touz_title_value_a;


    TextView house_detial_touz;
    TextView house_detial_touz_title;

    TextView  house_detial_nearby;

    LinearLayout recommend_house;


    TextView dayititle;
    TextView daikuantitle;

    TextView  kangfangtitle;

    RelativeLayout dayiBtn;
    RelativeLayout daikuangBtn;
    RelativeLayout kanfangBtn;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        SDKInitializer.initialize(getApplicationContext());
        setContentView(R.layout.activity_house_detail);
        backBtn = (ImageView)findViewById(R.id.home_map_go_btn);

        dayiBtn = (RelativeLayout)findViewById(R.id.dayiBtn);

        daikuangBtn = (RelativeLayout)findViewById(R.id.daikuangBtn);

        kanfangBtn = (RelativeLayout)findViewById(R.id.kanfangBtn);


        dayititle = (TextView)findViewById(R.id.dayititle);
        daikuantitle = (TextView)findViewById(R.id.daikuantitle);
        kangfangtitle = (TextView)findViewById(R.id.kangfangtitle);


        newlike = (ImageView)findViewById(R.id.newlike);

        home_map_title = (TextView)findViewById(R.id.home_map_title);

        house_detial_nearby = (TextView)findViewById(R.id.house_detial_nearby);

        recommend_house = (LinearLayout)findViewById(R.id.recommend_house);

        house_detial_touz_value = (TextView)findViewById(R.id.house_detial_touz_value);
        house_detial_touz_title_value = (TextView)findViewById(R.id.house_detial_touz_title_value);


        house_detial_touz_a = (TextView)findViewById(R.id.house_detial_touz_a);
        house_detial_touz_title_a = (TextView)findViewById(R.id.house_detial_touz_title_a);


        house_detial_touz_value_a = (TextView)findViewById(R.id.house_detial_touz_value_a);
        house_detial_touz_title_value_a = (TextView)findViewById(R.id.house_detial_touz_title_value_a);


        house_detial_touz = (TextView)findViewById(R.id.house_detial_touz);
        house_detial_touz_title = (TextView)findViewById(R.id.house_detial_touz_title);


        this.mMapView = (MapView)this.findViewById(R.id.bmapView);

        this.mBaiduMap = this.mMapView.getMap();
        this.mBaiduMap.setMyLocationEnabled(true);
        this.mBaiduMap.setMyLocationEnabled(true);




        mClusterManager = new ClusterManager<MyItem>(this, mBaiduMap);
        // 添加Marker点

        // 设置地图监听，当地图状态发生改变时，进行点聚合运算
        mBaiduMap.setOnMapStatusChangeListener(mClusterManager);
        // 设置maker点击时的响应
        mBaiduMap.setOnMarkerClickListener(mClusterManager);

        mClusterManager.setOnClusterClickListener(new ClusterManager.OnClusterClickListener<MyItem>() {
            @Override
            public boolean onClusterClick(Cluster<MyItem> cluster) {


                return false;
            }
        });
        mClusterManager.setOnClusterItemClickListener(new ClusterManager.OnClusterItemClickListener<MyItem>() {
            @Override
            public boolean onClusterItemClick(MyItem item) {


                return false;
            }
        });

        newshare = (ImageView)findViewById(R.id.newshare);

        house_detial_moreinformation  = (TextView)findViewById(R.id.house_detial_moreinformation);
        locationLabel = (TextView)findViewById(R.id.house_detial_location);
        priceLabel = (TextView)findViewById(R.id.house_detial_price);


        house_detial_region = (TextView)findViewById(R.id.house_detial_region);
        house_detial_region_value = (TextView)findViewById(R.id.house_detial_region_value);


        house_detial_type = (TextView)findViewById(R.id.house_detial_type);
        house_detial_type_value = (TextView)findViewById(R.id.house_detial_type_value);


        house_detial_bath = (TextView)findViewById(R.id.house_detial_bath);
        house_detial_bath_value = (TextView)findViewById(R.id.house_detial_bath_value);




        house_detial_bed = (TextView)findViewById(R.id.house_detial_bed);
        house_detial_bed_value = (TextView)findViewById(R.id.house_detial_bed_value);


        house_detial_living_area = (TextView)findViewById(R.id.house_detial_living_area);
        house_detial_living_area_value = (TextView)findViewById(R.id.house_detial_living_area_value);




        if(getLanguage().contains("zh")){
            house_detial_type.setText("类型：");
            house_detial_bath.setText("卫生间数：");

            house_detial_bed.setText("卧室数：");
            house_detial_living_area.setText("居住面积：");

            house_detial_region.setText("区域：");
            house_detial_moreinformation.setText("更多信息");
            house_detial_touz_title.setText("投资回报（全款）");
            house_detial_touz_title_value.setText("周边投资回报（全款）");
            house_detial_touz_title_a.setText("年净收入预期（全款）");
            house_detial_touz_title_value_a.setText("区域平均年净收入（全款）");
            house_detial_nearby.setText("查看周边");


            dayititle.setText("答疑");
            daikuantitle.setText("贷款");
            kangfangtitle.setText("看房");



        }else{
            house_detial_type.setText("Property Type:");
            house_detial_bath.setText("Baths:");

            house_detial_bed.setText("Beds：");
            house_detial_living_area.setText("Living Area:");

            house_detial_region.setText("Area:");
            house_detial_moreinformation.setText("More informations");

            house_detial_touz_title.setText("Westimated ROI(Cash)");
            house_detial_touz_title_value.setText("Area ROI(Cash)");
            house_detial_touz_title_a.setText("Area Avg.Net Income(Cash)");
            house_detial_touz_title_value_a.setText("Net Income(Cash)");
            house_detial_nearby.setText("Nearby");

            dayititle.setText("CONTACT INFO");
            daikuantitle.setText("MORTGAGE CALC");
            kangfangtitle.setText("SCHEDULE TOUR");
        }


        id = (String) getIntent().getSerializableExtra("id");

        banner = (Banner) findViewById(R.id.banner);
        //
        banner.setImageLoader(new ImageLoader());


        MobSDK.init(this,"185b3576c3ffe");


        dayiBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                showPopwindow();
            }
        });


        kanfangBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {


                App app = (App) getApplication();
                WesUser user = app.getLastUser();

                if(user == null){
                    startActivityForResult(new Intent(HouseDetailsActivity.this, LoginActivity.class), 111);
                }else{

                    Intent intent =new Intent(HouseDetailsActivity.this,AddScheduleActivity.class);

                    //用Bundle携带数据
                    Bundle bundle=new Bundle();
                    //传递name参数为tinyphp
                    bundle.putSerializable("id", id);

                    intent.putExtras(bundle);

                    startActivity(intent);

                }





            }
        });


        daikuangBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if(alldata != null){

                    try{

                        Intent intent =new Intent(HouseDetailsActivity.this,CalFrontActivity.class);

                        //用Bundle携带数据
                        Bundle bundle=new Bundle();
                        //传递name参数为tinyphp
                        bundle.putSerializable("price", alldata.getString("list_price"));
                        //JSONArray details = alldata.getJSONArray("details");

                      //  JSONObject  taxs = details.getJSONObject(details.length() -1);
//
                        JSONObject items = alldata.getJSONObject("taxes");

                      //  JSONObject     taxes = items.getJSONObject("taxes");

                        if(items.get("rawValue") != null){
                            bundle.putSerializable("taxes", items.getString("rawValue"));
                        }else{
                            bundle.putSerializable("taxes", "0");
                        }



                        intent.putExtras(bundle);

                        startActivity(intent);

                    }catch (Exception e){
                        e.printStackTrace();
                    }



                }



            }
        });


        backBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                HouseDetailsActivity.this.finish();
            }
        });


        newlike.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                App app = (App) getApplication();
                WesUser user = app.getLastUser();

                if(user == null){
                    startActivityForResult(new Intent(HouseDetailsActivity.this, LoginActivity.class), 111);
                }else{

                    addLike(user);

                }

            }
        });



        house_detial_nearby.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
              if(alldata != null){
                  Intent intent =new Intent(HouseDetailsActivity.this,HomeMapActivity.class);

                  //用Bundle携带数据
                  Bundle bundle=new Bundle();
                  //传递name参数为tinyphp
                  bundle.putSerializable("details", alldata.toString());
                  bundle.putSerializable("home", "3");


                  intent.putExtras(bundle);

                  startActivity(intent);
              }
            }
        });

        house_detial_moreinformation.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                Intent intent =new Intent(HouseDetailsActivity.this,MoreInformationActivity.class);

                //用Bundle携带数据
                Bundle bundle=new Bundle();
                //传递name参数为tinyphp
                bundle.putSerializable("id", id);

                intent.putExtras(bundle);

                startActivity(intent);

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

                        AlertDialog.Builder  builder=new AlertDialog.Builder(HouseDetailsActivity.this);


                        builder.setView(vv);


                        sharedialog=builder.create();

                        sharedialog.show();

                    }catch (Exception e){
                        e.printStackTrace();
                    }

                }




            }
        });

        getDetail();


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

            String url = "http://app.usleju.cn/home.html?language="+getLanguage()+"&id="+alldata.getString("id");


            String location =alldata.getString("location");

            String title = alldata.getString("prop_type_name") +"("+alldata.getString("list_price")+")";


           // String allTitle =  alldata.getString("title");

            JSONArray small_images = alldata.getJSONArray("small_images");

         String image = small_images.getString(0);

            //HouseDetailActivity


            if (type == 1){
                Facebook.ShareParams sp = new  Facebook.ShareParams();
                sp.setText(location);
                sp.setText(title);
                sp.setImagePath(image);

                Platform weibo = ShareSDK.getPlatform(Facebook.NAME);
                // weibo.setPlatformActionListener(paListener); // 设置分享事件回调
// 执行图文分享
                weibo.share(sp);
            } else if (type == 2){



                Platform.ShareParams sp = new   Platform.ShareParams();
                sp.setShareType(Platform.SHARE_WEBPAGE);// 一定要设置分享属性
                sp.setText(location);
                sp.setTitle(title);
                sp.setUrl(url);
               // sp.setImageData(null);
               sp.setImageUrl(image);
                //sp.setImagePath(null);
             // sp.setImageData(this.getImageFromNet(imgUrl));

                Platform qzone = ShareSDK.getPlatform (Wechat.NAME);

                qzone.share(sp);
            }else if(type == 3){



                WechatMoments.ShareParams sp = new  WechatMoments.ShareParams();
                sp.setTitle(title);
                sp.setText(location);
                sp.setImageUrl(image);
                sp.setUrl(url);

                Platform weibo = ShareSDK.getPlatform(WechatMoments.NAME);
                // weibo.setPlatformActionListener(paListener); // 设置分享事件回调
// 执行图文分享
                weibo.share(sp);
            }else if(type == 4){



                SinaWeibo.ShareParams sp = new  SinaWeibo.ShareParams();
                sp.setText(title);
                sp.setImagePath(image);

                Platform weibo = ShareSDK.getPlatform(SinaWeibo.NAME);
                // weibo.setPlatformActionListener(paListener); // 设置分享事件回调
// 执行图文分享
                weibo.share(sp);
            }



        }catch (Exception e){
         e.printStackTrace();
        }





    }

    private void initDetail(){
        try{
            initBanner(alldata.getJSONArray("images"));
            locationLabel.setText(alldata.getString("location"));
            priceLabel.setText(alldata.getString("list_price"));
            house_detial_type_value.setText(alldata.getString("prop_type_name"));
            house_detial_bath_value.setText(alldata.getString("no_full_baths"));
            house_detial_bed_value.setText(alldata.getString("no_bedrooms"));
            house_detial_living_area_value.setText(alldata.getString("square_feet"));

            house_detial_region_value.setText(alldata.getString("area"));

            JSONObject roi = alldata.getJSONObject("roi");

            house_detial_touz.setText(roi.getString("est_roi_cash"));
            house_detial_touz_value.setText(roi.getString("ave_roi_cash"));
            house_detial_touz_a.setText(roi.getString("est_annual_income_cash"));
            house_detial_touz_value_a.setText(roi.getString("ave_annual_income_cash"));

            if(alldata.get("latitude") != null && alldata.get("longitude") != null){
                LatLng ll = new LatLng(alldata.getDouble("latitude"), alldata.getDouble("longitude"));
                MapStatus.Builder builder = new MapStatus.Builder();

                builder.target(ll).zoom(12);
                mBaiduMap.animateMapStatus(MapStatusUpdateFactory.newMapStatus(builder.build()));
                List<MyItem> items = new ArrayList<MyItem>();
                items.add(new MyItem(ll));


                mClusterManager.addItems(items);
            }







            initLines();


            JSONArray recommend_houses = alldata.getJSONArray("recommend_houses");

            for (int i = 0; i < recommend_houses.length();i++){
                JSONObject obj = recommend_houses.getJSONObject(i);
                RelativeLayout vv = (RelativeLayout)getLayoutInflater().inflate(R.layout.home_house_recommand_view, null);

                HouseRecomentCell cell = vv.findViewById(R.id.recommend_house_cell);
                cell.setNid(obj.getString("id"));

                vv.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        HouseRecomentCell cellnew = v.findViewById(R.id.recommend_house_cell);
                        Intent intent =new Intent(HouseDetailsActivity.this,HouseDetailsActivity.class);

                        //用Bundle携带数据
                        Bundle bundle=new Bundle();
                        //传递name参数为tinyphp
                        bundle.putSerializable("id", cellnew.getNid());

                        intent.putExtras(bundle);

                        startActivity(intent);
                    }
                });

                TextView pricetitle = cell.findViewById(R.id.pricetitle);
                pricetitle.setText(obj.getString("list_price"));

                TextView  houseInfor = cell.findViewById(R.id.houseInfor);

                TextView  locationtitle = cell.findViewById(R.id.locationtitle);

                locationtitle.setText(obj.getString("location"));
                if(getLanguage().contains("zh")){

                    String infora = "卧室 "+obj.get("no_bedrooms")+"| 全卫 "+obj.get("no_full_baths")+" 半卫 "+obj.get("no_half_baths")+" | 居住面积 "+obj.get("square_feet");
                    houseInfor.setText(infora);

                }else{
                    String infora = obj.get("no_bedrooms")+"beds  "+obj.get("no_full_baths")+"baths "+"  "+obj.get("square_feet");
                    houseInfor.setText(infora);


                }

                ImageView houseImage =  cell.findViewById(R.id.houseImage);

                Glide.with(this)
                        .load(obj.getString("image"))
                        .into(houseImage);

                recommend_house.addView(vv);
            }


        }catch (Exception e){
            e.printStackTrace();
        }



    }

    private void  initLines(){
        try{
            JSONArray polygons = alldata.getJSONArray("polygons");

            for (int i = 0;i< polygons.length();i++){

                JSONArray allLines = polygons.getJSONArray(i);
                List<LatLng> pts = new ArrayList<LatLng>();
                for (int j = 0;j< allLines.length();j++){

                    JSONArray latlong = allLines.getJSONArray(j);

                    LatLng pt1 = new LatLng(latlong.getDouble(1), latlong.getDouble(0));
                    pts.add(pt1);
                }

                OverlayOptions polygonOption = new PolygonOptions()
                        .points(pts)
                        .stroke(new Stroke(5, 0xAAFF0000))
                        .fillColor(0x00FFFFFF);
                mBaiduMap.addOverlay(polygonOption);
            }






        }catch (Exception e){
           e.printStackTrace();
        }




    }


    private void  initBanner(JSONArray datas){

        try{
            ArrayList images = new ArrayList();


            for (Integer i = 0; i < datas.length();i++){


                images.add(datas.getString(i));


            }

            banner.setBannerStyle(BannerConfig.NUM_INDICATOR);

            banner.setImages(images);
            banner.isAutoPlay(true);
            banner.setOffscreenPageLimit(0);
            //设置轮播时间
            banner.setDelayTime(5000);
            //设置指示器位置（当banner模式中有指示器时）
            banner.setIndicatorGravity(BannerConfig.CENTER);
            //banner设置方法全部调用完毕时最后调用



            banner.start();




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

                      //  initHomeBusinessData(jsonObject);
                        JSONObject data = jsonObject.getJSONObject("data");
                        alldata = data;

                        initDetail();

                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError arg0) {

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





    private void addLike(WesUser user){

        if(getLanguage().contains("zh")){
            showLoading("正在收藏房源...");
        }else{
            showLoading("making...");
        }

        StringBuffer sb = new StringBuffer();

        String url = "http://api.usleju.cn/estate/house/favorite";

        sb.append(url);
        sb.append("?id=").append(id);
        sb.append("&access-token=").append(user.getToken());

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

                        if(getLanguage().contains("zh")){
                            Toast.makeText(HouseDetailsActivity.this, "收藏成功", Toast.LENGTH_SHORT).show();
                        }else{
                            Toast.makeText(HouseDetailsActivity.this, "Bookmark successfully", Toast.LENGTH_SHORT).show();
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


    /**
     * 每个Marker点，包含Marker点坐标以及图标
     */
    public class MyItem implements ClusterItem {
        private final LatLng mPosition;

        public MyItem(LatLng latLng) {
            mPosition = latLng;
        }

        @Override
        public LatLng getPosition() {
            return mPosition;
        }

        @Override
        public BitmapDescriptor getBitmapDescriptor() {
            return BitmapDescriptorFactory
                    .fromResource(R.drawable.icon_gcoding);
        }
    }

    @Override
    public void onMapLoaded() {
        // TODO Auto-generated method stub
        ms = new MapStatus.Builder().zoom(15).build();
        mBaiduMap.animateMapStatus(MapStatusUpdateFactory.newMapStatus(ms));
    }




    /**
     * 显示popupWindow
     */
    private void showPopwindow() {
        // 利用layoutInflater获得View
       // LayoutInflater inflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View viewa = getLayoutInflater().inflate(R.layout.alert_dialog, null);

        // 下面是两种方法得到宽度和高度 getWindow().getDecorView().getWidth()
        TextView chattitle = viewa.findViewById(R.id.chattitle);

        TextView kehutitle = viewa.findViewById(R.id.kehutitle);

        TextView  emailtitle= viewa.findViewById(R.id.emailtitle);
        TextView  catLabel= viewa.findViewById(R.id.catLabel);

        FrameLayout cn_btn =  viewa.findViewById(R.id.cn_btn);
        FrameLayout en_btn =  viewa.findViewById(R.id.en_btn);



        if(getLanguage().contains("zh")){
            chattitle.setText("在线客服");
            kehutitle.setText("米乐居客服");
            emailtitle.setText("邮箱:contact@usleju.com");
            catLabel.setText("微信:woniuusa");
        }else{
            chattitle.setText("Online chat");
            kehutitle.setText("Customer Service");
            emailtitle.setText("Email:contact@usleju.com");
            catLabel.setText("Wechat:woniuusa");
        }

        LinearLayout kefuBtn = viewa.findViewById(R.id.kefuBtn);

        AlertDialog.Builder  builder=new AlertDialog.Builder(HouseDetailsActivity.this);


        builder.setView(viewa);


        sharedialog=builder.create();

        sharedialog.show();


        kefuBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(HouseDetailsActivity.this, com.livechatinc.inappchat.ChatWindowActivity.class);
                intent.putExtra(com.livechatinc.inappchat.ChatWindowActivity.KEY_GROUP_ID, "0");
                intent.putExtra(com.livechatinc.inappchat.ChatWindowActivity.KEY_LICENCE_NUMBER, "7739171");
                startActivity(intent);

            }
        });

        cn_btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                Intent intent = new Intent(Intent.ACTION_DIAL, Uri.parse("tel:13167111930"));
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(intent);
            }
        });

        en_btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(Intent.ACTION_DIAL,Uri.parse("tel:8572054318"));
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(intent);

            }
        });





    }

}
