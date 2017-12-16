package net.lhh.apst.advancedpagerslidingtabstrip;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.DefaultRetryPolicy;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.baidu.mapapi.SDKInitializer;
import com.bumptech.glide.Glide;

import net.cfg.AppCfg;

import org.json.JSONArray;
import org.json.JSONObject;

import java.net.URLEncoder;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;

/**
 * Created by ld on 04/10/2017.
 */

public class FavoriteActivity extends BaseActivity implements  AbsListView.OnScrollListener{

    private static final int REFRESH_COMPLETE = 0X110;
    ImageView backBtn;
    TextView home_map_title;


    Integer pageSize = 30;
    Integer currentPage = 0;

    private SwipeRefreshLayout swipeRefreshLayout;
    private ListView lv;
    private MyAdapter adapter = new MyAdapter();
    private LinkedList list;


    private int visibleLastIndex;//用来可显示的最后一条数据的索引
    private Handler handler = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            switch (msg.what){
                case REFRESH_COMPLETE:
                    if (swipeRefreshLayout.isRefreshing()){
                        adapter.notifyDataSetChanged();
                        swipeRefreshLayout.setRefreshing(false);//设置不刷新
                    }
                    break;
            }
        }
    };

    @Override
    public void onScrollStateChanged(AbsListView view, int scrollState) {
        if(adapter.getCount() == visibleLastIndex && scrollState == SCROLL_STATE_IDLE){
            new FavoriteActivity.LoadDataThread().start();
        }
    }

    @Override
    public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
        visibleLastIndex = firstVisibleItem + visibleItemCount - 1;//减去最后一个加载中那条
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        SDKInitializer.initialize(getApplicationContext());
        setContentView(R.layout.activity_favorite);
        backBtn = (ImageView)findViewById(R.id.home_map_go_btn);

        home_map_title = (TextView)findViewById(R.id.home_map_title);


        swipeRefreshLayout = (SwipeRefreshLayout) findViewById(R.id.main_srl);
        lv = (ListView) findViewById(R.id.main_lv);


        lv.setOnScrollListener(this);

        list = new LinkedList();


        lv.setAdapter(adapter);

        lv.setOnItemClickListener(new AdapterView.OnItemClickListener()
        {

            @Override
            public void onItemClick(AdapterView<?> parent, View view,
                                    int position, long id)
            {
                try{
                    Intent intent =new Intent(FavoriteActivity.this,HouseDetailsActivity.class);
                    JSONObject obj  = (JSONObject)list.get(position);
                    //用Bundle携带数据
                    Bundle bundle=new Bundle();

                    JSONObject house = obj.getJSONObject("house");
                    //传递name参数为tinyphp
                    bundle.putSerializable("id", house.getString("id"));

                    intent.putExtras(bundle);

                    startActivity(intent);

                }catch (Exception e){
                    e.printStackTrace();
                }

            }

        });



        lv.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            @Override
            public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {

                AlertDialog.Builder builder = new AlertDialog.Builder(FavoriteActivity.this);
                //builder.setIcon(R.drawable.ic_launcher);

                String[] cities =  new String[]{"删除", "取消"};
                if(getLanguage().contains("zh")){
                    builder.setTitle("删除确认");
                }else{
                    builder.setTitle("Remove comfirm");
                     cities = new String[]{"REMOVE", "CANCEL"};
                }


                final  int index = position;

                builder.setItems(cities, new DialogInterface.OnClickListener()
                {
                    @Override
                    public void onClick(DialogInterface dialog, int which)
                    {
                        if(which == 0){

                              removeDatas(index);

                        }
                    }
                });


                builder.show();
                return true;
            }
        });

        swipeRefreshLayout.setColorSchemeResources(android.R.color.holo_blue_bright, android.R.color.holo_green_light,
                android.R.color.holo_orange_light, android.R.color.holo_red_light);

        swipeRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {

                new FavoriteActivity.LoadDataThread().start();
            }
        });

        swipeRefreshLayout.setRefreshing(true);
        getHouseDatas();

        if(getLanguage().contains("zh")){
            home_map_title.setText("我的收藏");
        }else{
            home_map_title.setText("My favorites");
        }


        backBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                FavoriteActivity.this.finish();
            }
        });

    }


    /**
     * 模拟加载数据的线程
     */
    class LoadDataThread extends  Thread{
        @Override
        public void run() {
            getHouseDatas();

        }


    }

    private void removeDatas(int index){


        if(getLanguage().contains("zh")){
            showLoading("正在删除...");
        }else{
            showLoading("Removing...");
        }


        App app = (App)getApplication();

        WesUser user = app.getLastUser();

        String url = "http://api.usleju.cn/member/favorite/remove";

        StringBuffer sb = new StringBuffer();
        sb.append(url);




        JSONObject obj = new JSONObject();


        try {

            JSONObject house = (JSONObject)list.get(index);

            sb.append("?id=").append(house.getString("id"));
            sb.append("&access-token=").append(user.getToken());


        } catch (Exception e) {
            e.printStackTrace();
        }


        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.GET, sb.toString(), obj, new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject jsonObject) {
                try {

                    hideLoading();

                    Integer code =  jsonObject.getInt("code");

                    if(code == 200){


                        if(getLanguage().contains("zh")){
                            Toast.makeText(FavoriteActivity.this, "删除成功", Toast.LENGTH_SHORT).show();
                        }else{
                            Toast.makeText(FavoriteActivity.this, "Remove successfully", Toast.LENGTH_SHORT).show();
                        }


                        swipeRefreshLayout.setRefreshing(true);
                        getHouseDatas();

                    }

                    handler.sendEmptyMessageDelayed(REFRESH_COMPLETE, 2000);
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


    private void getHouseDatas(){


        App app = (App)getApplication();

        WesUser user = app.getLastUser();

        String url = "http://api.usleju.cn/member/favorite/list";

        StringBuffer sb = new StringBuffer();
        sb.append(url);

        sb.append("?page=").append(currentPage);
        sb.append("&page_size=").append(pageSize);
       sb.append("&access-token=").append(user.getToken());


        JSONObject obj = new JSONObject();


        try {




        } catch (Exception e) {
            e.printStackTrace();
        }


        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.GET, sb.toString(), obj, new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject jsonObject) {
                try {

                    Integer code =  jsonObject.getInt("code");

                    if(code == 200){
                        list = new LinkedList();
                        //  initNewsData(jsonObject);
                        JSONArray ds = jsonObject.getJSONObject("data").getJSONArray("items");

                        for(int i = 0;i<ds.length();i++){
                            list.add(ds.getJSONObject(i));
                        }
                        currentPage = 1;
                    }

                    handler.sendEmptyMessageDelayed(REFRESH_COMPLETE, 2000);
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




    class MyAdapter extends BaseAdapter implements AdapterView.OnItemClickListener{

        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {




        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {

            JSONObject obja  = (JSONObject)list.get(position);


            RelativeLayout house = (RelativeLayout)getLayoutInflater().inflate(
                    R.layout.home_house_cell, null);



                    RelativeLayout newCellLine =  (RelativeLayout)house.findViewById(R.id.newCellLine);

            newCellLine.setVisibility(View.INVISIBLE);
            TextView title =     (TextView)house.findViewById(R.id.housetitle);

            TextView houselocation =     (TextView)house.findViewById(R.id.houselocation);

            TextView houseInfor =     (TextView)house.findViewById(R.id.houseInfor);

            TextView priceLabel =     (TextView)house.findViewById(R.id.priceLabel);
            TextView priceValue =     (TextView)house.findViewById(R.id.priceValue);

            TextView statusLabel =     (TextView)house.findViewById(R.id.statusLabel);

            TextView marketLabel =     (TextView)house.findViewById(R.id.marketLabel);

            try{

                JSONObject obj = obja.getJSONObject("house");
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


                ImageView imageView = (ImageView)house.findViewById(R.id.houseImage);



                Glide.with(FavoriteActivity.this)
                        .load(obj.getString("image"))
                        .into(imageView);

            }catch (Exception e){
                e.printStackTrace();
            }




            return house;
        }
        @Override
        public long getItemId(int position) {
            return position;
        }
        @Override
        public Object getItem(int position) {
            return list.get(position);
        }
        @Override
        public int getCount() {
            return list.size();
        }
    }


}
