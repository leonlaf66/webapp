package net.lhh.apst.advancedpagerslidingtabstrip;

import android.app.AlertDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapShader;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.RectF;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;


import com.android.volley.AuthFailureError;
import com.android.volley.DefaultRetryPolicy;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.baidu.mapapi.SDKInitializer;
import com.baidu.location.BDLocation;
import com.baidu.location.BDLocationListener;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.baidu.mapapi.clusterutil.clustering.Cluster;
import com.baidu.mapapi.clusterutil.clustering.ClusterItem;
import com.baidu.mapapi.clusterutil.clustering.ClusterManager;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.MapStatus;
import com.baidu.mapapi.map.MapStatusUpdate;
import com.baidu.mapapi.map.MapStatusUpdateFactory;
import com.baidu.mapapi.map.MapView;
import com.baidu.mapapi.map.MyLocationConfiguration;
import com.baidu.mapapi.map.MyLocationConfiguration.LocationMode;
import com.baidu.mapapi.map.MyLocationData;
import com.baidu.mapapi.map.OverlayOptions;
import com.baidu.mapapi.map.PolygonOptions;
import com.baidu.mapapi.map.Stroke;
import com.baidu.mapapi.model.LatLng;


import java.io.IOException;
import java.io.Serializable;
import java.net.URLEncoder;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import com.bigkoo.pickerview.OptionsPickerView;
import com.bumptech.glide.Glide;
import com.squareup.okhttp.Call;
import com.squareup.okhttp.Callback;

import com.squareup.okhttp.Headers;
import com.squareup.okhttp.OkHttpClient;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.Response;

import net.cfg.AppCfg;
import net.lhh.apst.fragments.ComCell;
import net.lhh.apst.fragments.MoreFilterView;
import net.lhh.apst.fragments.MoreFilterViewMap;
import net.lhh.apst.fragments.MoreTextViewa;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class HomeMapActivity extends BaseActivity implements BaiduMap.OnMapLoadedCallback ,MoreFilterViewMap.MyCallBack{

    public static final int CORNER_NONE = 0;
    public static final int CORNER_TOP_LEFT = 1;
    public static final int CORNER_TOP_RIGHT = 1 << 1;
    public static final int CORNER_BOTTOM_LEFT = 1 << 2;
    public static final int CORNER_BOTTOM_RIGHT = 1 << 3;
    public static final int CORNER_ALL = CORNER_TOP_LEFT | CORNER_TOP_RIGHT | CORNER_BOTTOM_LEFT | CORNER_BOTTOM_RIGHT;
    public static final int CORNER_TOP = CORNER_TOP_LEFT | CORNER_TOP_RIGHT;
    public static final int CORNER_BOTTOM = CORNER_BOTTOM_LEFT | CORNER_BOTTOM_RIGHT;
    public static final int CORNER_LEFT = CORNER_TOP_LEFT | CORNER_BOTTOM_LEFT;
    public static final int CORNER_RIGHT = CORNER_TOP_RIGHT | CORNER_BOTTOM_RIGHT;


    ImageView backBtn;
    TextView naTitle;

    private static final int LOCATION_PERMISSION_REQUEST_CODE = 1;
    private MapView mMapView = null;
    public MyLocationListenner myListener = new MyLocationListenner();

    private final OkHttpClient client = new OkHttpClient();
    boolean isFirstLoc = true;

    BaiduMap mBaiduMap;
    MapStatus ms;
    private ClusterManager<MyItem> mClusterManager;

    float zoom = 11.f;

    MyItem  currentItem = null;

    List<MyItem> itemsa;

    LinearLayout houseInfors;

    String currentId;

    String home = "";

    String latlong = null;

    JSONArray keys = null;

    EditText inputText;

    LinearLayout comView;

    ImageView  filter_btn;

    ImageView  searchgo;

    String type = "purchase";
    LinearLayout gvvvv;

    private AlertDialog sharedialog;
    TextView typeTitle;

    LinearLayout moreView;
    MoreFilterViewMap moreViewIn;

    LinearLayout filterBg;

   TextView countText;

    TextView subwayText;

    LinearLayout subway_btn;


    private OptionsPickerView pvOptions;

    private ArrayList<JSONObject> allsubways = new ArrayList<JSONObject>();


    private ArrayList markerlist = new ArrayList();

    private ArrayList<String> Provincestr = new ArrayList<>();//省



    private ArrayList<ArrayList<String>> Citystr = new ArrayList<>();


    JSONObject currentLine;

    JSONObject currentStation;

    String details;

    JSONArray allitems;


    public void myBack(int checks){

        filterBg.setVisibility(View.INVISIBLE);

        moreView.setVisibility(View.INVISIBLE);

        if(checks == 6){
            currentLine = null;
            currentStation = null;
        }


        getHouseDatas();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        SDKInitializer.initialize(getApplicationContext());
        setContentView(R.layout.activity_home_map);
        backBtn = (ImageView)findViewById(R.id.back_btn);

        filter_btn = (ImageView)findViewById(R.id.filter_btn);

        subway_btn  = (LinearLayout)findViewById(R.id.subway_btn);

        typeTitle = (TextView) findViewById(R.id.typeTitle);

        subwayText = (TextView) findViewById(R.id.subwayText);

        searchgo = (ImageView)findViewById(R.id.searchgo);

        inputText = (EditText) findViewById(R.id.inputText);

        countText = (TextView) findViewById(R.id.countText);

        gvvvv = (LinearLayout) findViewById(R.id.gvvvv);

        filterBg= (LinearLayout) findViewById(R.id.filterBg);

        moreView = (LinearLayout)findViewById(R.id.moreView);;

        moreViewIn = (MoreFilterViewMap) findViewById(R.id.moreViewIn);


        moreViewIn.setMyCallBack(HomeMapActivity.this);

        moreViewIn.initLang(getLanguage(),type);

        filterBg.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                filterBg.setVisibility(View.INVISIBLE);

                moreView.setVisibility(View.INVISIBLE);
            }
        });




        // naTitle = (TextView)findViewById(R.id.home_map_title);

        backBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                HomeMapActivity.this.finish();
            }
        });

        home = (String) getIntent().getSerializableExtra("home");

        houseInfors = (LinearLayout)findViewById(R.id.houseInfors);
        comView = (LinearLayout)findViewById(R.id.comView);

        if(getLanguage().contains("zh")){
          //  naTitle.setText("周边房源");
            inputText.setHint("搜索城市，邮编，地址");
            typeTitle.setText("购房");
            subwayText.setText("地铁搜房");
        }else{
            inputText.setHint("Search Address,City");
            typeTitle.setText("Purchase");
            subwayText.setText("Subway");
        }





        subway_btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(pvOptions!=null){
                    pvOptions.show(); //弹出条件选择器
                }else{

                    if(getLanguage().contains("zh")){
                        Toast.makeText(HomeMapActivity.this, "暂无地铁数据，请稍后", Toast.LENGTH_SHORT).show();
                    }else{
                        Toast.makeText(HomeMapActivity.this, "No subway datas,wait a moment", Toast.LENGTH_SHORT).show();
                    }

                }


            }
        });


        filter_btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                filterBg.setVisibility(View.VISIBLE);

                moreView.setVisibility(View.VISIBLE);
            }
        });


        searchgo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                getHouseDatas();
            }
        });


        gvvvv.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                LinearLayout vv = (LinearLayout)getLayoutInflater().inflate(R.layout.type, null);

                final MoreTextViewa a = vv.findViewById(R.id.sort_a);
                final  MoreTextViewa b = vv.findViewById(R.id.sort_b);

                if(getLanguage().contains("zh")){
                    a.setText("购房");
                    b.setText("租房");
                }else{
                    a.setText("Purchase");
                    b.setText("Rental");
                }


                a.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        type = "purchase";
                        sharedialog.hide();

                        if (getLanguage().contains("zh")){
                            typeTitle.setText("购房");

                        }else{
                            typeTitle.setText("Purchase");


                        }


                    }
                });

                b.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        type = "lease";
                        sharedialog.hide();

                        if (getLanguage().contains("zh")){
                            typeTitle.setText("租房");

                        }else{
                            typeTitle.setText("Rental");

                        }
                    }
                });



                AlertDialog.Builder  builder=new AlertDialog.Builder(HomeMapActivity.this);


                builder.setView(vv);


                sharedialog=builder.create();
                //sharedialog.setTitle("房屋类型选择");


                sharedialog.show();


            }
        });




        houseInfors.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if(currentId != null){
                    Intent intent =new Intent(HomeMapActivity.this,HouseDetailsActivity.class);

                    //用Bundle携带数据
                    Bundle bundle=new Bundle();
                    //传递name参数为tinyphp
                    bundle.putSerializable("id", currentId);

                    intent.putExtras(bundle);

                    startActivity(intent);
                }

            }
        });


        inputText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {


                if(inputText.getText().length()>0){


                    if(keys != null){

                        try{
                            comView.removeAllViews();
                            List tem = new ArrayList();

                            for(int i = 0;i < keys.length();i++){
                                JSONObject obj = keys.getJSONObject(i);
                                if( obj.getString("title").toLowerCase().startsWith(inputText.getText().toString())){

                                    tem.add(obj);
                                    if(tem.size() == 6){
                                        break;
                                    }
                                }

                            }

                            if(tem.size()>0){
                                comView.setVisibility(View.VISIBLE);


                                for(int i = 0;i < tem.size();i++){
                                    JSONObject obj = (JSONObject)tem.get(i);

                                    RelativeLayout rl = (RelativeLayout)getLayoutInflater().inflate(R.layout.home_com_view,null);

                                    ComCell comCell = rl.findViewById(R.id.comCell);

                                    comCell.setObj(obj);

                                    comCell.setOnClickListener(new View.OnClickListener() {
                                        @Override
                                        public void onClick(View v) {
                                            ComCell mycomCell = v.findViewById(R.id.comCell);

                                            try{
                                                JSONObject o = mycomCell.getObj();



                                                inputText.setText(o.getString("title"));
                                                comView.setVisibility(View.INVISIBLE);



                                            }catch (Exception e){
                                                e.printStackTrace();
                                            }
                                        }
                                    });

                                    comView.addView(rl);
                                }

                            }else{
                                comView.setVisibility(View.INVISIBLE);
                            }

                        }catch (Exception e){
                            e.printStackTrace();
                        }




                    }else{
                        comView.setVisibility(View.INVISIBLE);
                    }





                }else{
                    comView.setVisibility(View.INVISIBLE);
                }

            }
        });

        this.mMapView = (MapView)this.findViewById(R.id.bmapView);

        this.mBaiduMap = this.mMapView.getMap();
        this.mBaiduMap.setMyLocationEnabled(true);
        this.mBaiduMap.setMyLocationEnabled(true);



        LocationClient mLocClient = new LocationClient(getApplicationContext());
        mLocClient.registerLocationListener(this.myListener);
        LocationClientOption option = new LocationClientOption();
        option.setOpenGps(true);
        option.setScanSpan(1000);

        mLocClient.setLocOption(option);

        LatLng ll = new LatLng(42.49997, -71.14281);
        MapStatus.Builder builder = new MapStatus.Builder();

        builder.target(ll).zoom(zoom);
        mBaiduMap.animateMapStatus(MapStatusUpdateFactory.newMapStatus(builder.build()));



        // 定义点聚合管理类ClusterManager
        mClusterManager = new ClusterManager<MyItem>(this, mBaiduMap);
        // 添加Marker点
       // addMarkers();

        // 设置地图监听，当地图状态发生改变时，进行点聚合运算
        mBaiduMap.setOnMapStatusChangeListener(mClusterManager);
        // 设置maker点击时的响应
        mBaiduMap.setOnMarkerClickListener(mClusterManager);

        mClusterManager.setOnClusterClickListener(new ClusterManager.OnClusterClickListener<MyItem>() {
            @Override
            public boolean onClusterClick(Cluster<MyItem> cluster) {
                zoom = mBaiduMap.getMapStatus().zoom + 3;
                ms = new MapStatus.Builder().zoom(zoom).build();
                mBaiduMap.animateMapStatus(MapStatusUpdateFactory.newMapStatus(ms));
                return true;
            }
        });
        mClusterManager.setOnClusterItemClickListener(new ClusterManager.OnClusterItemClickListener<MyItem>() {
            @Override
            public boolean onClusterItemClick(MyItem item) {
                currentId = item.id;
                getDetailDatas(item.id);

               // mBaiduMap.clear();
               // mClusterManager.clearItems();
               // //markerlist = new ArrayList();

               // addAnnotation(allitems);

                return false;
            }
        });



        try{

            if(Integer.parseInt(home) == 1){
                mLocClient.start();
            }else if(Integer.parseInt(home) == 2){
                this.getHouseDatas();
            }else if(Integer.parseInt(home) == 3){
                details  = (String) getIntent().getSerializableExtra("details");

              JSONObject objs = new JSONObject(details);

                JSONArray recommend_houses = objs.getJSONArray("recommend_houses");

                Double   longitude  = objs.getDouble("longitude");
                Double   latitude  = objs.getDouble("latitude");

                JSONArray   polygons  = objs.getJSONArray("polygons");

                LatLng lll = new LatLng(latitude,
                        longitude);
                MapStatus.Builder builderl = new MapStatus.Builder();
                builderl.target(lll).zoom(11.0f);
                mBaiduMap.animateMapStatus(MapStatusUpdateFactory.newMapStatus(builderl.build()));


                addLines(polygons);
                addAnnotationDetial(recommend_houses);
            }




            getKeyDatas();

            getSubwayDatas();
        }catch (Exception e){
            e.printStackTrace();
        }


    }


    private void addAnnotationDetial(JSONArray items){
        //  "72238943|39.5|SF|42.49997|-71.14281",

        try{
            itemsa = new ArrayList<MyItem>();
            for(Integer i = 0;i < items.length();i++){
                JSONObject dataString = items.getJSONObject(i);



                String  id = dataString.getString("id");

                Double lat = dataString.getDouble("latitude");

                Double lon = dataString.getDouble("longitude");



                String  newprice =  dataString.getString("list_price");




                String  newtype = dataString.getString("prop_type_name");






                LatLng llA = new LatLng(lat, lon);



                MyItem a =   new MyItem(llA,newprice,newtype,id,false);

                itemsa.add(a);




            }

            mClusterManager.addItems(itemsa);

            LatLng ll =  itemsa.get(0).getPosition();


            zoom = mBaiduMap.getMapStatus().zoom + 2;
            ms = new MapStatus.Builder().target(ll).zoom(zoom).build();

            mBaiduMap.animateMapStatus(MapStatusUpdateFactory.newMapStatus(ms));


        }catch (Exception e){
            e.printStackTrace();
        }



    }



     protected void onPause() {
     super.onPause();
     this.mMapView.onPause();
     }

     protected void onResume() {
     super.onResume();
     this.mMapView.onResume();
     }

     protected void onDestroy() {
     super.onDestroy();
     this.mMapView.onDestroy();

     }

      class MyLocationListenner implements BDLocationListener {
        public MyLocationListenner() {
     }

     public void onReceiveLocation(BDLocation location) {



         // map view 销毁后不在处理新接收的位置
         if (location == null || mMapView == null) {
             return;
         }
         MyLocationData locData = new MyLocationData.Builder()
                 .accuracy(location.getRadius())
                 // 此处设置开发者获取到的方向信息，顺时针0-360
                 .direction(100).latitude(location.getLatitude())
                 .longitude(location.getLongitude()).build();
         //42.425293,-71.285443
         mBaiduMap.setMyLocationData(locData);
         if (isFirstLoc) {

             isFirstLoc = false;
             LatLng ll = new LatLng(location.getLatitude(),
                     location.getLongitude());

            // LatLng ll = new LatLng(42.425293,
                   //  -71.285443);
             MapStatus.Builder builder = new MapStatus.Builder();
             builder.target(ll).zoom(14.0f);
             mBaiduMap.animateMapStatus(MapStatusUpdateFactory.newMapStatus(builder.build()));

            // latlong = "&filters[latlon]=42.425293,-71.285443";
             latlong = "&filters[latlon]="+location.getLatitude()+","+location.getLongitude();
             getHouseDatas();
         }


     }

     public void onReceivePoi(BDLocation poiLocation) {
     }
     }

    private void initHouseDatas(JSONObject jsonObject){

        try{
            JSONArray items = jsonObject.getJSONArray("items");

            allitems = items;

       if(getLanguage().contains("zh")){
           countText.setText("共"+items.length()+"套房源");

       }else{
           countText.setText("There are "+items.length()+" houses");
       }


            JSONArray polygons = jsonObject.getJSONArray("polygons");

            addAnnotation(items);

            addLines(polygons);

        }catch (Exception e){
          e.printStackTrace();
        }

    }

    private void addAnnotation(JSONArray items){
        //  "72238943|39.5|SF|42.49997|-71.14281",

        try{

            for(Integer i = 0;i < items.length();i++){
                 String dataString = items.getString(i);

                 String []datas = dataString.split("\\|");

                 String  id = datas[0];

                 Double lat = Double.parseDouble(datas[3]);

                 Double lon = Double.parseDouble(datas[4]);

                 String  type = datas[2];

                 String  price = datas[1];

                String  newprice = "";

                if(getLanguage().contains("zh")){
                    newprice = price+"万美元";
                }else{
                    DecimalFormat df   = new DecimalFormat("######0.00");
                    newprice = "$" + df.format(Double.parseDouble(price)*10000);
                }


                String  newtype = "";

                if(getLanguage().contains("zh")){

                    if(type.equals("SF")){
                        newtype = "独栋别墅";

                    }else if(type.equals("MF")){
                        newtype = "多家庭";

                    }else if( type.equals("CC")){
                        newtype = "公寓";

                    }else if(type.equals("CI")){
                        newtype = "商业用房";

                    }else if(type.equals("BU")){
                        newtype = "营业用房";

                    }else if(type.equals("LD")){
                        newtype = "土地";

                    }else if(type.equals("RN")){
                        newtype = "租房";

                    }


                }else{

                    if(type.equals("SF")){
                        newtype = "Single Family";

                    }else if(type.equals("MF")){
                        newtype = "Multi Family";

                    }else if(type.equals("CC")){
                        newtype = "Condominium";

                    }else if(type.equals("CI")){
                        newtype = "Commercial";

                    }else if(type.equals("BU")){
                        newtype = "Business Opportunity";

                    }else if(type.equals("LD")){
                        newtype = "Land";

                    }else if(type.equals("RN")){
                        newtype = "Rental";

                    }

                }




                LatLng llA = new LatLng(lat, lon);


               itemsa = new ArrayList<MyItem>();

                if(currentId != null && currentId.equals(id)){
                    MyItem a =   new MyItem(llA,newprice,newtype,id,true);

                    itemsa.add(a);
                }else{
                    MyItem a =   new MyItem(llA,newprice,newtype,id,false);

                    itemsa.add(a);
                }


                mClusterManager.addItems(itemsa);

                if(i == items.length()-1){
                    LatLng ll = new LatLng(lat, lon);


                    zoom = mBaiduMap.getMapStatus().zoom + 1;
                    ms = new MapStatus.Builder().target(ll).zoom(zoom).build();

                    mBaiduMap.animateMapStatus(MapStatusUpdateFactory.newMapStatus(ms));
                }
            }


        }catch (Exception e){
            e.printStackTrace();
        }



    }

    private void addLines(JSONArray polygons){
        try{


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



    private void getHouseDatas(){

        this.mBaiduMap.clear();
        mClusterManager.clearItems();
        markerlist = new ArrayList();
        zoom = mBaiduMap.getMapStatus().zoom - 1;
        if(getLanguage().contains("zh")){
            showLoading("正在加载数据...");
        }else{
            showLoading("loading...");
        }

        App app = (App)getApplication();

        String url = "http://api.usleju.cn/estate/house/map-search";

        StringBuffer sb = new StringBuffer();
        sb.append(url);
        sb.append("?type=").append(type);

        //sb.append("&limit=100");




        if(Integer.parseInt(home) == 1){
            if(inputText.getText() != null && inputText.getText().toString().trim().length()>0){

                try{
                    sb.append("&").append("q="+ URLEncoder.encode(inputText.getText().toString(),"utf-8"));
                    latlong = null;
                }catch (Exception e){
                    e.printStackTrace();
                }

            }else{
               // sb.append("&q=").append(app.area);

            }


        }else if(Integer.parseInt(home) == 2){
            if(inputText.getText() != null && inputText.getText().toString().trim().length()>0){

                try{
                    sb.append("&").append("q="+ URLEncoder.encode(inputText.getText().toString(),"utf-8"));
                }catch (Exception e){
                    e.printStackTrace();
                }
                latlong = null;

            }else{
               // sb.append("&q=").append("Boston");
            }

            //sb.append("&area_id=").append(app.area);
        }





        if(moreViewIn != null){

            if("lease".equals(type)){


                if(moreViewIn.getPrice() != null){

                    if(Integer.parseInt(moreViewIn.getPrice())== 1){
                        sb.append("&");
                        sb.append("filters[list_price][from]=0&filters[list_price][to]=1000");

                    }else if(Integer.parseInt(moreViewIn.getPrice())== 2){
                        sb.append("&");
                        sb.append("filters[list_price][from]=1000&filters[list_price][to]=2000");

                    }else if(Integer.parseInt(moreViewIn.getPrice())== 3){
                        sb.append("&");
                        sb.append("filters[list_price][from]=2000&filters[list_price][to]=3000");

                    }else if(Integer.parseInt(moreViewIn.getPrice())== 4){
                        sb.append("&");
                        sb.append("filters[list_price][from]=3000");
                    }
                }


            }else{
                List p_types =    moreViewIn.getType();
                for (int i = 0;i < p_types.size();i++){
                    sb.append("&filters[prop-type][]=").append(p_types.get(i));
                }

                if(moreViewIn.getPrice() != null){

                    if(Integer.parseInt(moreViewIn.getPrice())== 1){
                        sb.append("&");
                        sb.append("filters[list_price][from]=0&filters[list_price][to]=500000");

                    }else if(Integer.parseInt(moreViewIn.getPrice())== 2){
                        sb.append("&");
                        sb.append("filters[list_price][from]=500000&filters[list_price][to]=800000");

                    }else if(Integer.parseInt(moreViewIn.getPrice())== 3){
                        sb.append("&");
                        sb.append("filters[list_price][from]=800000&filters[list_price][to]=1200000");

                    }else if(Integer.parseInt(moreViewIn.getPrice())== 4){
                        sb.append("&");
                        sb.append("filters[list_price][from]=1200000");
                    }
                }


            }
            if(moreViewIn.getBeds() != null){
                sb.append("&filters[beds]=").append(moreViewIn.getBeds());
            }


            if(moreViewIn.getArea() != null){


                if(Integer.parseInt(moreViewIn.getArea())== 1){
                    sb.append("&");

                    if(getLanguage().contains("zh")){
                        sb.append("filters[square][from]=0&filters[square][to]=1076");
                    }else{
                        sb.append("filters[square][from]=0&filters[square][to]=1000");
                    }


                }else if(Integer.parseInt(moreViewIn.getArea())== 2){
                    sb.append("&");

                    if(getLanguage().contains("zh")){
                        sb.append("filters[square][from]=1076&filters[square][to]=2152");
                    }else{
                        sb.append("filters[square][from]=1000&filters[square][to]=2000");
                    }


                }else if(Integer.parseInt(moreViewIn.getArea())== 3){
                    sb.append("&");


                    if(getLanguage().contains("zh")){
                        sb.append("filters[square][from]=2152&filters[square][to]=3228");
                    }else{
                        sb.append("filters[square][from]=2000&filters[square][to]=3000");
                    }



                }else if(Integer.parseInt(moreViewIn.getArea())== 4){
                    sb.append("&");


                    if(getLanguage().contains("zh")){
                        sb.append("filters[square][from]=3228");
                    }else{
                        sb.append("filters[square][from]=3000");
                    }
                }

            }

            if(moreViewIn.getBath() != null){
                sb.append("&");
                sb.append(moreViewIn.getBath());
            }

            if(moreViewIn.getParking() != null){
                sb.append("&");
                sb.append(moreViewIn.getParking());
            }
            if(moreViewIn.getMarket() != null){
                sb.append("&");
                sb.append(moreViewIn.getMarket());
            }

        }

       // currentLine = cline;
       // currentStation = stat;

        if(currentLine != null){

            try{
                sb.append("&");
                sb.append("filters[subway_line]=");
                sb.append(currentLine.getString("id"));
            }catch (Exception e){
                e.printStackTrace();
            }


        }

        if(currentStation != null){
            try{
                sb.append("&");
                sb.append("filters[subway_stations][]=");
                sb.append(currentStation.getString("id"));
            }catch (Exception e){
                e.printStackTrace();
            }


        }

        if(latlong != null){

            sb.append(latlong);
        }


        JSONObject obj = new JSONObject();
        try {
            obj.put("language",this.getLanguage());
        } catch (JSONException e) {
            e.printStackTrace();
        }


        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(com.android.volley.Request.Method.GET, sb.toString(), obj.toString(), new com.android.volley.Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject jsonObject) {
                try {
                    hideLoading();
                    Integer code =  jsonObject.getInt("code");

                    if(code == 200){
                        initHouseDatas(jsonObject.getJSONObject("data"));
                    }else{
                        if(getLanguage().contains("zh")){
                            countText.setText("共"+0+"套房源");

                        }else{
                            countText.setText("There are "+0+" houses");
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }, new com.android.volley.Response.ErrorListener() {
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
                    App app =  (App)getApplication();
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
       //

    }


    private void getDetailDatas(String id){

        if(getLanguage().contains("zh")){
            showLoading("正在加载数据...");
        }else{
            showLoading("loading...");
        }

        String url = "http://api.usleju.cn/estate/house/get";

        StringBuffer sb = new StringBuffer();
        sb.append(url).append("?id=").append(id);

        JSONObject obj = new JSONObject();
        try {
            obj.put("language",this.getLanguage());
        } catch (JSONException e) {
            e.printStackTrace();
        }

        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(com.android.volley.Request.Method.GET, sb.toString(), obj.toString(), new com.android.volley.Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject jsonObject) {
                try {
                    hideLoading();
                    Integer code =  jsonObject.getInt("code");

                    if(code == 200){

                        JSONObject obj = jsonObject.getJSONObject("data");



                        TextView title =     (TextView)houseInfors.findViewById(R.id.housetitle);

                        TextView houselocation =     (TextView)houseInfors.findViewById(R.id.houselocation);

                        TextView houseInfor =     (TextView)houseInfors.findViewById(R.id.houseInfor);

                        TextView priceLabel =     (TextView)houseInfors.findViewById(R.id.priceLabel);
                        TextView priceValue =     (TextView)houseInfors.findViewById(R.id.priceValue);

                        TextView statusLabel =     (TextView)houseInfors.findViewById(R.id.statusLabel);

                        TextView marketLabel =     (TextView)houseInfors.findViewById(R.id.marketLabel);


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


                        ImageView imageView = (ImageView)houseInfors.findViewById(R.id.houseImage);


                        JSONArray images = obj.getJSONArray("images");
                        Glide.with(HomeMapActivity.this)
                                .load(images.getString(0))
                                .into(imageView);

                        houseInfors.setVisibility(View.VISIBLE);

                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }, new com.android.volley.Response.ErrorListener() {
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

        public  String price;
        public  String type;
        public  String id;

        TextView priceLabel;
        TextView typeLabel;

        boolean istype;

        BitmapDescriptor bitmap1;

        public MyItem(LatLng latLng,String price,String type,String id, boolean istype) {
            mPosition = latLng;
            this.id = id;
            this.price = price;
            this.type = type;
            this.istype = istype;

        }

        @Override
        public LatLng getPosition() {
            return mPosition;
        }

        @Override
        public BitmapDescriptor getBitmapDescriptor() {
            View view = getLayoutInflater().inflate(R.layout.map_item, null);

             priceLabel = view.findViewById(R.id.tv_price);

             typeLabel = view.findViewById(R.id.tv_type);

              priceLabel.setText(price);

            if (istype){
                typeLabel.setText(type);
            }

            //



            view.measure(View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED), View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED));
            view.layout(0, 0, view.getMeasuredWidth(), view.getMeasuredHeight());
            view.buildDrawingCache();
            Bitmap bitmap = view.getDrawingCache();
            markerlist.add(bitmap);
            if(bitmap == null){

            }

             bitmap1 = BitmapDescriptorFactory.fromBitmap(bitmap);

            return bitmap1;
        }
    }




    @Override
    public void onMapLoaded() {
        // TODO Auto-generated method stub
      //  ms = new MapStatus.Builder().zoom(zoom).build();
       // mBaiduMap.animateMapStatus(MapStatusUpdateFactory.newMapStatus(ms));
    }



    private void getKeyDatas(){

        String url = "http://api.usleju.cn/estate/house/search-options";

        StringBuffer sb = new StringBuffer();

        sb.append(url);


        JSONObject obj = new JSONObject();
        try {
            obj.put("language",this.getLanguage());
        } catch (JSONException e) {
            e.printStackTrace();
        }

        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(com.android.volley.Request.Method.GET, sb.toString(), obj.toString(), new com.android.volley.Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject jsonObject) {
                try {

                    Integer code =  jsonObject.getInt("code");

                    if(code == 200){

                        keys = jsonObject.getJSONArray("data");
                        // initHomeHouseData(jsonObject);

                        //initType(jsonObject.getJSONObject("data"));

                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }, new com.android.volley.Response.ErrorListener() {
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
                    App app =  (App)getApplication();
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
       //

    }


////////////

    private void getSubwayDatas(){

        String url = "http://api.usleju.cn/catalog/subway/maps";

        StringBuffer sb = new StringBuffer();

        sb.append(url);


        JSONObject obj = new JSONObject();
        try {
            obj.put("language",this.getLanguage());
        } catch (JSONException e) {
            e.printStackTrace();
        }

        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(com.android.volley.Request.Method.GET, sb.toString(), obj.toString(), new com.android.volley.Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject jsonObject) {
                try {

                    Integer code =  jsonObject.getInt("code");

                    if(code == 200){

                       JSONObject data = jsonObject.getJSONObject("data");

                        getOptionData(data);


                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }, new com.android.volley.Response.ErrorListener() {
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

    ///// subway



    private void getOptionData(JSONObject obj) {

        /**
         * 注意：如果是添加JavaBean实体数据，则实体类需要实现 IPickerViewData 接口，
         * PickerView会通过getPickerViewText方法获取字符串显示出来。
         */
      //  getOptionData();
      //


        for(Iterator<String> it = obj.keys();it.hasNext();){

            try{
                JSONObject  line = obj.getJSONObject(it.next());
                allsubways.add(line);
                Provincestr.add(line.getString("name"));

                ArrayList<String> options2Items_01 = new ArrayList<>();

                JSONArray stations = line.getJSONArray("stations");


                for (int i = 0;i<stations.length();i++){

                    JSONObject sta = stations.getJSONObject(i);
                    options2Items_01.add(sta.getString("name"));
                }



                Citystr.add(options2Items_01);

            }catch (Exception e){

            }


        }
        initOptionPicker();

    }





    private void initOptionPicker() {//条件选择器初始化


        if(getLanguage().contains("zh")){

            /**
             * 注意 ：如果是三级联动的数据(省市区等)，请参照 JsonDataActivity 类里面的写法。
             */

            pvOptions = new OptionsPickerView.Builder(this, new OptionsPickerView.OnOptionsSelectListener() {
                @Override
                public void onOptionsSelect(int options1, int options2, int options3, View v) {
                    //返回的分别是三个级别的选中位置

                    try{
                        JSONObject cline = allsubways.get(options1);

                        JSONObject  stat =  cline.getJSONArray("stations").getJSONObject(options2);


                        currentLine = cline;
                        currentStation = stat;

                        getHouseDatas();

                    }catch (Exception e){
                        e.printStackTrace();
                    }



                }


            })
                    .setTitleText("地铁选择")
                    .setSubmitText("确定")
                    .setCancelText("取消")
                    .setContentTextSize(20)//设置滚轮文字大小
                    .setDividerColor(Color.LTGRAY)//设置分割线的颜色
                    .setSelectOptions(0, 1)//默认选中项
                    .setBgColor(Color.BLACK)
                    .setTitleBgColor(Color.DKGRAY)
                    .setTitleColor(Color.LTGRAY)
                    .setCancelColor(Color.YELLOW)
                    .setSubmitColor(Color.YELLOW)
                    .setTextColorCenter(Color.LTGRAY)
                    .isCenterLabel(false) //是否只显示中间选中项的label文字，false则每项item全部都带有label。
                    .setLabels(" ", " ", " ")
                    .setBackgroundId(0x66000000) //设置外部遮罩颜色
                    .build();
        }else{
            /**
             * 注意 ：如果是三级联动的数据(省市区等)，请参照 JsonDataActivity 类里面的写法。
             */

            pvOptions = new OptionsPickerView.Builder(this, new OptionsPickerView.OnOptionsSelectListener() {
                @Override
                public void onOptionsSelect(int options1, int options2, int options3, View v) {
                    //返回的分别是三个级别的选中位置

                    try{
                        JSONObject cline = allsubways.get(options1);

                        JSONObject  stat =  cline.getJSONArray("stations").getJSONObject(options2);


                        currentLine = cline;
                        currentStation = stat;

                        getHouseDatas();

                    }catch (Exception e){
                        e.printStackTrace();
                    }



                }


            })
                    .setTitleText("Choose subway")
                    .setSubmitText("OK")
                    .setCancelText("Cancel")
                    .setContentTextSize(20)//设置滚轮文字大小
                    .setDividerColor(Color.LTGRAY)//设置分割线的颜色
                    .setSelectOptions(0, 1)//默认选中项
                    .setBgColor(Color.BLACK)
                    .setTitleBgColor(Color.DKGRAY)
                    .setTitleColor(Color.LTGRAY)
                    .setCancelColor(Color.YELLOW)
                    .setSubmitColor(Color.YELLOW)
                    .setTextColorCenter(Color.LTGRAY)
                    .isCenterLabel(false) //是否只显示中间选中项的label文字，false则每项item全部都带有label。
                    .setLabels(" ", " ", " ")
                    .setBackgroundId(0x66000000) //设置外部遮罩颜色
                    .build();
        }







        //pvOptions.setSelectOptions(1,1);
        /*pvOptions.setPicker(options1Items);//一级选择器*/
        pvOptions.setPicker(Provincestr, Citystr);//二级选择器
        /*pvOptions.setPicker(options1Items, options2Items,options3Items);//三级选择器*/
    }

    ////


    class  ProvinceBean implements Serializable {

        public int getPro_id() {
            return pro_id;
        }

        public void setPro_id(int pro_id) {
            this.pro_id = pro_id;
        }

        public String getPro_code() {
            return pro_code;
        }

        public void setPro_code(String pro_code) {
            this.pro_code = pro_code;
        }

        public String getPro_name() {
            return pro_name;
        }

        public void setPro_name(String pro_name) {
            this.pro_name = pro_name;
        }

        public String getPro_name2() {
            return pro_name2;
        }

        public void setPro_name2(String pro_name2) {
            this.pro_name2 = pro_name2;
        }

        public  ProvinceBean(int pro_id, String pro_code, String pro_name, String pro_name2) {
            this.pro_id = pro_id;
            this.pro_code = pro_code;
            this.pro_name = pro_name;
            this.pro_name2 = pro_name2;

        }

        private int pro_id;//省份id
        private String pro_code;//城市编码
        private String pro_name;//省份名称
        private String pro_name2;//省份别称
    }





    //////////




    public  Bitmap fillet(Bitmap bitmap, int roundPx,int corners) {
        try {
            // 其原理就是：先建立一个与图片大小相同的透明的Bitmap画板
            // 然后在画板上画出一个想要的形状的区域。
            // 最后把源图片帖上。
            final int width = bitmap.getWidth();
            final int height = bitmap.getHeight();

            Bitmap paintingBoard = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
            Canvas canvas = new Canvas(paintingBoard);
            canvas.drawARGB(Color.TRANSPARENT, Color.TRANSPARENT, Color.TRANSPARENT, Color.TRANSPARENT);

            final Paint paint = new Paint();
            paint.setAntiAlias(true);
            paint.setColor(Color.BLACK);

            //画出4个圆角
            final RectF rectF = new RectF(0, 0, width, height);
            canvas.drawRoundRect(rectF, roundPx, roundPx, paint);

            //把不需要的圆角去掉
            int notRoundedCorners = corners ^ CORNER_ALL;
            if ((notRoundedCorners & CORNER_TOP_LEFT) != 0) {
                clipTopLeft(canvas,paint,roundPx,width,height);
            }
            if ((notRoundedCorners & CORNER_TOP_RIGHT) != 0) {
                clipTopRight(canvas, paint, roundPx, width, height);
            }
            if ((notRoundedCorners & CORNER_BOTTOM_LEFT) != 0) {
                clipBottomLeft(canvas,paint,roundPx,width,height);
            }
            if ((notRoundedCorners & CORNER_BOTTOM_RIGHT) != 0) {
                clipBottomRight(canvas, paint, roundPx, width, height);
            }
            paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));

            //帖子图
            final Rect src = new Rect(0, 0, width, height);
            final Rect dst = src;
            canvas.drawBitmap(bitmap, src, dst, paint);
            return paintingBoard;
        } catch (Exception exp) {
            return bitmap;
        }
    }

    private  void clipTopLeft(final Canvas canvas, final Paint paint, int offset, int width, int height) {
        final Rect block = new Rect(0, 0, offset, offset);
        canvas.drawRect(block, paint);
    }

    private  void clipTopRight(final Canvas canvas, final Paint paint, int offset, int width, int height) {
        final Rect block = new Rect(width - offset, 0, width, offset);
        canvas.drawRect(block, paint);
    }

    private  void clipBottomLeft(final Canvas canvas, final Paint paint, int offset, int width, int height) {
        final Rect block = new Rect(0, height - offset, offset, height);
        canvas.drawRect(block, paint);
    }

    private  void clipBottomRight(final Canvas canvas, final Paint paint, int offset, int width, int height) {
        final Rect block = new Rect(width - offset, height - offset, width, height);
        canvas.drawRect(block, paint);
    }

}
