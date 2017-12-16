package net.lhh.apst.advancedpagerslidingtabstrip;

import android.content.Context;
import android.content.Intent;
import android.graphics.PorterDuff;
import android.graphics.drawable.LayerDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RatingBar;
import android.widget.TextView;

import com.android.volley.AuthFailureError;
import com.android.volley.DefaultRetryPolicy;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.bumptech.glide.Glide;

import net.cfg.AppCfg;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class HomeServiceCenterActivity extends BaseActivity implements  SwipeRefreshLayout.OnRefreshListener {

    private static final int REFRESH_COMPLETE = 0X110;
    ImageView backBtn;
    TextView naTitle;


    private RecyclerView mRecyclerView;
    SwipeRefreshLayout mSwipeRefreshWidget;
    MyAdapter  adapter = new MyAdapter();
    private JSONArray mDatas = new JSONArray();

    private List typeDatas = new ArrayList();
    LinearLayout typeView;

    private RecyclerView mRecyclerView_type;


    TypeAdapter  typeadapter = new TypeAdapter();

    Button allBtn;

   int heeight = 500;
   TextView typeText;

    private Handler mHandler = new Handler()
    {
        public void handleMessage(android.os.Message msg)
        {
            switch (msg.what)
            {
                case REFRESH_COMPLETE:
                    adapter.notifyDataSetChanged();
                    mSwipeRefreshWidget.setRefreshing(false);
                    break;
            }
        };
    };
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home_service_center);
        backBtn = (ImageView)findViewById(R.id.home_map_go_btn);
        naTitle = (TextView)findViewById(R.id.home_map_title);

        allBtn = (Button)findViewById(R.id.allBtn);
        typeView = (LinearLayout)findViewById(R.id.typeView);

        typeText = (TextView) findViewById(R.id.typeText);

        mSwipeRefreshWidget = (SwipeRefreshLayout) findViewById(R.id.swipe_refresh_widget);

        mSwipeRefreshWidget.setOnRefreshListener(this);

        mSwipeRefreshWidget.setColorSchemeResources(android.R.color.holo_blue_bright, android.R.color.holo_green_light,
                android.R.color.holo_orange_light, android.R.color.holo_red_light);


        mRecyclerView = (RecyclerView)findViewById(R.id.home_list_recycle_view);
        mRecyclerView.setLayoutManager(new GridLayoutManager(this, 2));
        mRecyclerView.setAdapter(adapter);


        mRecyclerView_type  = (RecyclerView)findViewById(R.id.home_list_recycle_view_type);

        mRecyclerView_type.setLayoutManager(new GridLayoutManager(this, 4));


        allBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                WindowManager wm = (WindowManager)
                        getSystemService(Context.WINDOW_SERVICE);

                int height = wm.getDefaultDisplay().getHeight();

                ViewGroup.LayoutParams params= (ViewGroup.LayoutParams) typeView.getLayoutParams();

                if(heeight == 500  ){

                    params.height=height;//设置当前控件布局的高度
                    heeight = height;
                }else{
                    params.height=500;//设置当前控件布局的高度
                    heeight = 500;
                }

                typeView.setLayoutParams(params);

            }
        });

        backBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                HomeServiceCenterActivity.this.finish();
            }
        });

        if(getLanguage().contains("zh")){
            naTitle.setText("房管中心");
            typeText.setText("服务类型");
            allBtn.setText("全部");
        }else{
            naTitle.setText("Pro services");
            typeText.setText("Types");
            allBtn.setText("ALL");
        }

        mSwipeRefreshWidget.setRefreshing(true);
        this.onRefresh();




        loadType();

    }


    @Override
    public void onRefresh() {


        loadDatas(null);


    }

    private void loadDatas(String typeId){




        String url = "http://api.usleju.cn/catalog/yellow-page/list";

        StringBuffer sb = new StringBuffer();

        sb.append(url);
        sb.append("?page=1").append("page_size=30");
        if(typeId != null){
            sb.append("&type_id=").append(typeId);
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

                    Integer code =  jsonObject.getInt("code");

                    if(code == 200){

                        JSONObject data = jsonObject.getJSONObject("data");

                      //  getOptionData(data);

                        mDatas  = data.getJSONArray("items");

                        mHandler.sendEmptyMessageDelayed(REFRESH_COMPLETE, 2000);
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


    private void loadType(){




        String url = "http://api.usleju.cn/catalog/yellow-page/types";

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

                        try{
                            JSONArray datas = jsonObject.getJSONArray("data");

                            for(int i = 0;i<datas.length();i++){
                                typeDatas.add(datas.get(i));
                            }
                            mRecyclerView_type.setAdapter(typeadapter);
                        }catch (Exception e){
                            e.printStackTrace();
                        }




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

    //继承自 RecyclerView.Adapter
    class MyAdapter extends RecyclerView.Adapter<MyAdapter.ViewHolder> {

        //RecyclerView显示的子View
        //该方法返回是ViewHolder，当有可复用View时，就不再调用
        @Override
        public ViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
            View v = getLayoutInflater().inflate(R.layout.recycler_item, null);
            return new ViewHolder(v);
        }

        //将数据绑定到子View
        @Override
        public void onBindViewHolder(ViewHolder viewHolder, int i) {
            //--  viewHolder.textView.setText(data[i]);

           // Map item = (Map)mDatas.get(i);



            try{
                JSONObject obj = mDatas.getJSONObject(i);
                viewHolder.obj = obj;


                Glide.with(HomeServiceCenterActivity.this)
                        .load(obj.getString("photo_url"))
                        .into(viewHolder.headeImg);

                viewHolder.nametitle.setText(obj.getString("name"));

                if(getLanguage().contains("zh")){
                    viewHolder.typeLabel.setText("业务范围:"+obj.getString("business"));
                }else{
                    viewHolder.typeLabel.setText("BUSINESS:"+obj.getString("business"));
                }


                LayerDrawable ld_stars = (LayerDrawable)viewHolder.room_ratingbar.getProgressDrawable();
                viewHolder.room_ratingbar.setRating((float) obj.getDouble("rating"));
                ld_stars.getDrawable(2).setColorFilter(getResources().getColor(R.color.green), PorterDuff.Mode.SRC_ATOP);


            }catch (Exception e){
                e.printStackTrace();
            }


               // viewHolder.price.setText(price.get("value").toString() + price.get("suffix").toString());





            //--  viewHolder.imageView.setLayoutParams(lp);

        }

        //RecyclerView显示数据条数
        @Override
        public int getItemCount() {
            return mDatas.length();
        }

        //自定义的ViewHolder,减少findViewById调用次数
        class ViewHolder extends RecyclerView.ViewHolder {


            ImageView headeImg;

            TextView typeLabel;
            TextView nametitle;
            JSONObject obj;
            RatingBar room_ratingbar;
            public ViewHolder(View itemView) {
                super(itemView);

                itemView.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                       // Map ds = (Map)ViewHolder.this.datas;

               try{
                   Intent intent =new Intent(HomeServiceCenterActivity.this,HomeServiceDetialActivity.class);
                   JSONObject obja  = ViewHolder.this.obj;
                   //用Bundle携带数据
                   Bundle bundle=new Bundle();
                   //传递name参数为tinyphp
                   bundle.putSerializable("id", obja.getString("id"));

                   intent.putExtras(bundle);

                   startActivity(intent);
               }catch (Exception e){
                   e.printStackTrace();
               }


                    }
                });


                try{

                    headeImg = (ImageView) itemView.findViewById(R.id.headImg);
                    nametitle = (TextView) itemView.findViewById(R.id.nametitle);
                    typeLabel = (TextView) itemView.findViewById(R.id.typeLabel);
                    room_ratingbar = (RatingBar)itemView.findViewById(R.id.room_ratingbar);//圆形图片
                }catch (Exception e){
                    e.printStackTrace();
                }



//photo_url





            }

        }
    }





///////////leixing

    class TypeAdapter extends RecyclerView.Adapter<TypeAdapter.ViewHolder> {

        //RecyclerView显示的子View
        //该方法返回是ViewHolder，当有可复用View时，就不再调用
        @Override
        public ViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
            View v = getLayoutInflater().inflate(R.layout.type_item, null);
            return new ViewHolder(v);
        }

        //将数据绑定到子View
        @Override
        public void onBindViewHolder(ViewHolder viewHolder, int i) {
            //--  viewHolder.textView.setText(data[i]);

            // Map item = (Map)mDatas.get(i);



            try{
                JSONObject obj = (JSONObject)typeDatas.get(i);
                viewHolder.obj = obj;


                Glide.with(HomeServiceCenterActivity.this)
                        .load(obj.getString("icon"))
                        .into(viewHolder.headeImg);

                viewHolder.nametitle.setText(obj.getString("name"));




            }catch (Exception e){
                e.printStackTrace();
            }


            // viewHolder.price.setText(price.get("value").toString() + price.get("suffix").toString());





            //--  viewHolder.imageView.setLayoutParams(lp);

        }

        //RecyclerView显示数据条数
        @Override
        public int getItemCount() {
            return typeDatas.size();
        }

        //自定义的ViewHolder,减少findViewById调用次数
        class ViewHolder extends RecyclerView.ViewHolder {


            ImageView headeImg;

            TextView nametitle;
            JSONObject obj;
            public ViewHolder(View itemView) {
                super(itemView);

                itemView.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        // Map ds = (Map)ViewHolder.this.datas;

                        try{

                            JSONObject obja  = ViewHolder.this.obj;
                            mSwipeRefreshWidget.setRefreshing(true);
                            loadDatas(obja.getString("id"));
                            ViewGroup.LayoutParams params= (ViewGroup.LayoutParams) typeView.getLayoutParams();
                            params.height=500;//设置当前控件布局的高度
                            heeight = 500;

                        typeView.setLayoutParams(params);

                        }catch (Exception e){
                            e.printStackTrace();
                        }


                    }
                });


                try{

                    headeImg = (ImageView) itemView.findViewById(R.id.headImg);
                    nametitle = (TextView) itemView.findViewById(R.id.nametitle);


                }catch (Exception e){
                    e.printStackTrace();
                }



//photo_url





            }

        }
    }
    //////////



}
