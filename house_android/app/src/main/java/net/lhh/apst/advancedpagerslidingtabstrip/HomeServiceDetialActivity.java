package net.lhh.apst.advancedpagerslidingtabstrip;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.PorterDuff;
import android.graphics.drawable.LayerDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RatingBar;
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

public class HomeServiceDetialActivity extends BaseActivity implements  AbsListView.OnScrollListener{

    private static final int REFRESH_COMPLETE = 0X110;
    ImageView backBtn;
    TextView home_map_title;


    Integer pageSize = 100;
    Integer currentPage = 0;
    String id;

    private SwipeRefreshLayout swipeRefreshLayout;
    private ListView lv;
    private MyAdapter adapter = new MyAdapter();
    private LinkedList list;
    LinearLayout myheader;


    ImageView headeImg;

    TextView typeLabel;
    TextView nametitle;

    Button addComment;



    TextView contacttitle;
    TextView phonetitle;
    TextView addresstitle;

    TextView  websitetitle;

    TextView  typetitle;
    TextView  desctitle;
    TextView  licensetitle;

    TextView  emailtitle;

    RatingBar aroom_ratingbar;
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
            new HomeServiceDetialActivity.LoadDataThread().start();
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
        setContentView(R.layout.activity_home_service_detail);


       // home_map_title = (TextView)findViewById(R.id.home_map_title);

         myheader = (LinearLayout)getLayoutInflater().inflate(R.layout.service_detail_header,null);

        headeImg = (ImageView) myheader.findViewById(R.id.headImg);
        nametitle = (TextView) myheader.findViewById(R.id.nametitle);
        typeLabel = (TextView) myheader.findViewById(R.id.typeLabel);
        backBtn = (ImageView)myheader.findViewById(R.id.goback);
        addComment = (Button) myheader.findViewById(R.id.addComment);

        aroom_ratingbar = (RatingBar) myheader.findViewById(R.id.room_ratingbar);

        contacttitle = (TextView) myheader.findViewById(R.id.contacttitle);
        phonetitle = (TextView) myheader.findViewById(R.id.phonetitle);
        addresstitle = (TextView) myheader.findViewById(R.id.addresstitle);

        websitetitle  = (TextView) myheader.findViewById(R.id.websitetitle);



        typetitle  = (TextView) myheader.findViewById(R.id.typetitle);
        desctitle  = (TextView) myheader.findViewById(R.id.desctitle);
        licensetitle  = (TextView) myheader.findViewById(R.id.licensetitle);
        emailtitle  = (TextView) myheader.findViewById(R.id.emailtitle);

        id = (String) getIntent().getSerializableExtra("id");

        swipeRefreshLayout = (SwipeRefreshLayout) findViewById(R.id.main_srl);
        lv = (ListView) findViewById(R.id.main_lv);

        lv.addHeaderView(myheader);


        lv.setOnScrollListener(this);

        list = new LinkedList();


        lv.setAdapter(adapter);





        swipeRefreshLayout.setColorSchemeResources(android.R.color.holo_blue_bright, android.R.color.holo_green_light,
                android.R.color.holo_orange_light, android.R.color.holo_red_light);

        swipeRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {

                new HomeServiceDetialActivity.LoadDataThread().start();
            }
        });

        getDetaileDatas();

        swipeRefreshLayout.setRefreshing(true);
        getHouseDatas();

        if(getLanguage().contains("zh")){
            addComment.setText("评论");
        }else{
            addComment.setText("Comments");
        }


        backBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                HomeServiceDetialActivity.this.finish();
            }
        });


        addComment.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                App app = (App) getApplication();
                WesUser user = app.getLastUser();

                if(user == null){

                    Intent intent =new Intent(HomeServiceDetialActivity.this,LoginActivity.class);

                    Bundle bundle=new Bundle();


                    startActivity(intent);


                }else{
                    Intent intent =new Intent(HomeServiceDetialActivity.this,AddCommentActivity.class);

                    Bundle bundle=new Bundle();
                    //传递name参数为tinyphp
                    bundle.putSerializable("id", id);

                    intent.putExtras(bundle);

                    startActivityForResult(intent,2);

                }




            }
        });

    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {

        // 根据上面发送过去的请求吗来区别
        switch (requestCode) {
            case 0:

                break;
            case 2:{
                swipeRefreshLayout.setRefreshing(true);
                getHouseDatas();
            }

                break;
            default:
                break;
        }
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




    private void getDetaileDatas(){


        App app = (App)getApplication();

        WesUser user = app.getLastUser();

        String url = "http://api.usleju.cn/catalog/yellow-page/get";

        StringBuffer sb = new StringBuffer();
        sb.append(url);

        sb.append("?id=").append(id);



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



                                try{
                                    JSONObject data = jsonObject.getJSONObject("data");

                                    nametitle.setText(data.getString("name"));

                                    Glide.with(HomeServiceDetialActivity.this)
                                            .load(data.getString("photo_url"))
                                            .into(headeImg);


                                    LayerDrawable ld_stars = (LayerDrawable)aroom_ratingbar.getProgressDrawable();
                                    aroom_ratingbar.setRating((float) data.getDouble("rating"));
                                    ld_stars.getDrawable(2).setColorFilter(getResources().getColor(R.color.green), PorterDuff.Mode.SRC_ATOP);



                                    if(getLanguage().contains("zh")){


                                        contacttitle.setText("联  系  人:"+data.getString("contact"));
                                        phonetitle.setText("电       话:"+data.getString("phone"));
                                        addresstitle.setText("地       址:"+data.getString("address"));

                                        websitetitle.setText("网       址:"+data.getString("website"));



                                        typetitle.setText("服务类型:"+data.getString("business"));

                                        desctitle.setText("简       介:"+data.getString("intro"));
                                        licensetitle.setText("专业资质:"+data.getString("license"));
                                        emailtitle.setText("邮       箱:"+data.getString("email"));

                                    }else{

                                        contacttitle.setText("Contact:"+data.getString("contact"));
                                        phonetitle.setText("Phone:"+data.getString("phone"));
                                        addresstitle.setText("Address:"+data.getString("address"));

                                        websitetitle.setText("Website:"+data.getString("website"));



                                        typetitle.setText("Type:"+data.getString("business"));

                                        desctitle.setText("Description:"+data.getString("intro"));
                                        licensetitle.setText("License:"+data.getString("license"));
                                        emailtitle.setText("Email:"+data.getString("email"));
                                    }

                                }catch (Exception e){
                                    e.printStackTrace();
                                }


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





    private void getHouseDatas(){


        App app = (App)getApplication();

        WesUser user = app.getLastUser();

        String url = "http://api.usleju.cn/catalog/comment/list";

        StringBuffer sb = new StringBuffer();
        sb.append(url);

        sb.append("?page=").append(currentPage);
        sb.append("&page_size=").append(pageSize);
        sb.append("&id=").append(id);
        sb.append("&type=yellowpage");


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


            LinearLayout house = (LinearLayout)getLayoutInflater().inflate(
                    R.layout.comment_cell, null);


           TextView comments =     (TextView)house.findViewById(R.id.comments);

            TextView  userLabel=     (TextView)house.findViewById(R.id.userLabel);

            TextView timeLabel=     (TextView)house.findViewById(R.id.timeLabel);
            RatingBar room_ratingbar =  (RatingBar)house.findViewById(R.id.room_ratingbar);

//rating
            try{

                JSONObject user = obja.getJSONObject("user");


                comments.setText(obja.getString("comments"));

                timeLabel.setText(obja.getString("created_at").substring(0,19));

                room_ratingbar.setRating(Float.parseFloat(obja.getString("rating")));


                LayerDrawable ld_stars = (LayerDrawable)room_ratingbar.getProgressDrawable();
                room_ratingbar.setRating((float) obja.getDouble("rating"));
                ld_stars.getDrawable(2).setColorFilter(getResources().getColor(R.color.green), PorterDuff.Mode.SRC_ATOP);


                if(user.get("name") != null){
                    userLabel.setText(user.getString("name"));
                }





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
