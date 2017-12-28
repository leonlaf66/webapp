package net.lhh.apst.advancedpagerslidingtabstrip;

import android.app.AlertDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Paint;
import android.os.Bundle;
import android.os.Message;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.RelativeLayout;

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
import net.lhh.apst.advancedpagerslidingtabstrip.AboutusActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.App;
import net.lhh.apst.advancedpagerslidingtabstrip.HomeMapActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.HouseDetailActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.HouseDetailsActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.R;
import net.lhh.apst.fragments.AreaFilterView;
import net.lhh.apst.fragments.BaseFragment;
import net.lhh.apst.fragments.BedsFilterView;
import net.lhh.apst.fragments.ComCell;
import net.lhh.apst.fragments.MoreFilterView;
import net.lhh.apst.fragments.MoreTextViewa;
import net.lhh.apst.fragments.PriceFilterView;
import net.lhh.apst.fragments.TypeFilterView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import android.os.Handler;
import android.widget.TextView;

/**
 * Created by linhonghong on 2015/8/11.
 */
public class HouseListActivity extends BaseActivity implements  SwipeRefreshLayout.OnRefreshListener,TypeFilterView.MyCallBack
        ,PriceFilterView.MyCallBack,AreaFilterView.MyCallBack,BedsFilterView.MyCallBack,MoreFilterView.MyCallBack{
    private static final int REFRESH_COMPLETE = 0X110;

    Integer pageSize = 15;
    Integer currentPage = 1;

    private SwipeRefreshLayout swipeRefreshLayout;
    private RecyclerView lv;
    private MyAdapter adapter = new MyAdapter();
    private LinkedList list = new LinkedList();
    private View footerView;


    TextView house_fitle_type_title;
    TextView house_fitle_price_title;

    TextView house_fitle_beds_title;

    TextView house_fitle_area_title;
    TextView house_fitle_more_title;

    LinearLayout bgView;
    LinearLayout typeView;
    TypeFilterView typeViewIn;
    TextView sort_text;

    String type= "purchase";//lease


    LinearLayout priceView;
    PriceFilterView priceViewIn;

    private AlertDialog sharedialog;

    LinearLayout areaView;
    AreaFilterView areaViewIn;


    LinearLayout bedsView;
    BedsFilterView bedsViewIn;

    LinearLayout moreView;
    MoreFilterView moreViewIn;

    List  p_types = new ArrayList();

    String p_price;

    RelativeLayout sortBtn;


    String order = null;

    LinearLayout comView;
    EditText inputText;
    JSONArray keys = null;

    ImageView searchgo;
    ImageView goMapBtn;

    RelativeLayout myloading;
    private int lastVisibleItem;
    //是否正在加载更多的标志
    private boolean isMoreLoading=false;
    GridLayoutManager gridManager;

    ImageView back_btn;

    public void myBack(int checks){
        bgView.setVisibility(View.INVISIBLE);
        typeView.setVisibility(View.INVISIBLE);
        priceView.setVisibility(View.INVISIBLE);
        areaView.setVisibility(View.INVISIBLE);
        bedsView.setVisibility(View.INVISIBLE);

        moreView.setVisibility(View.INVISIBLE);


        if(checks == 1){
            moreViewIn.setTypeList(typeViewIn.getCheck());

        }else if(checks == 2){

            moreViewIn.setPrice(priceViewIn.getCheckedd());

        }else if(checks == 3){

            if(areaViewIn.getCheckdd() != null){
                moreViewIn.setArea(Integer.parseInt(areaViewIn.getCheckdd()));
            }
            //reset
        }else if(checks == 4){
            //reset
            String a =   bedsViewIn.getCheck();

            if(a != null){
                if(a.contains("1")){
                    moreViewIn.setBeds(1);
                }else if(a.contains("2")){
                    moreViewIn.setBeds(2);
                }if(a.contains("3")){
                    moreViewIn.setBeds(3);
                }if(a.contains("4")){
                    moreViewIn.setBeds(4);
                }if(a.contains("5")){
                    moreViewIn.setBeds(5);
                }if(a.contains("6")){
                    moreViewIn.setBeds(6);
                }else{
                    moreViewIn.setBeds(null);
                }
            }

        }else if(checks == 5){
            List types = moreViewIn.getType();
            typeViewIn.setTypeList(types);
            bedsViewIn.setBeds(moreViewIn.getBeds());

            priceViewIn.setPrice(moreViewIn.getPrice());

            areaViewIn.setArea(moreViewIn.getArea());

        }else if(checks == 6){
            //reset
        }
        //p_types   = checks;
        list = new LinkedList();
        swipeRefreshLayout.setRefreshing(true);

        getHouseDatas();
    }

    private int visibleLastIndex;//用来可显示的最后一条数据的索引
    private Handler handler = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            switch (msg.what){
                case REFRESH_COMPLETE:
                    if (swipeRefreshLayout.isRefreshing()){
                        myloading.setVisibility(View.INVISIBLE);
                        adapter.notifyDataSetChanged();
                        swipeRefreshLayout.setRefreshing(false);//设置不刷新
                    }else{
                        myloading.setVisibility(View.INVISIBLE);
                        adapter.notifyDataSetChanged();
                    }
                    break;
            }
        }
    };





    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_house_list);

        sortBtn =  (RelativeLayout)findViewById(R.id.sortBtn);
        comView = (LinearLayout)findViewById(R.id.comView);
        inputText =  (EditText)findViewById(R.id.inputText);

        back_btn = (ImageView)findViewById(R.id.back_btn);
        searchgo =  (ImageView)findViewById(R.id.searchgo);
        goMapBtn=  (ImageView)findViewById(R.id.goMapBtn);
        bgView = (LinearLayout) findViewById(R.id.bgView);
        typeView = (LinearLayout) findViewById(R.id.typeView);

        typeViewIn = (TypeFilterView) findViewById(R.id.typeViewIn);

        sort_text =  (TextView) findViewById(R.id.sort_text);


        priceView = (LinearLayout) findViewById(R.id.priceView);

        priceViewIn = (PriceFilterView) findViewById(R.id.priceViewIn);


        areaView = (LinearLayout) findViewById(R.id.areaView);

        areaViewIn = (AreaFilterView) findViewById(R.id.areaViewIn);

        myloading = (RelativeLayout) findViewById(R.id.myloading);


        bedsView = (LinearLayout) findViewById(R.id.bedsView);

        bedsViewIn = (BedsFilterView) findViewById(R.id.bedsViewIn);

        back_btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });



        moreView = (LinearLayout) findViewById(R.id.moreView);

        moreViewIn = (MoreFilterView) findViewById(R.id.moreViewIn);

        typeViewIn.setMyCallBack(this);
        priceViewIn.setMyCallBack(this);

        areaViewIn.setMyCallBack(this);

        bedsViewIn.setMyCallBack(this);

        moreViewIn.setMyCallBack(this);



        if(getIntent().getSerializableExtra("key") != null){
            inputText.setText(getIntent().getSerializableExtra("key").toString());
        }
        if(getIntent().getSerializableExtra("type") != null){
            type = getIntent().getSerializableExtra("type").toString();
        }


        typeViewIn.initLang(getLanguage());
        priceViewIn.initLang(getLanguage(),type);

        bedsViewIn.initLang(getLanguage());
        moreViewIn.initLang(getLanguage(),type);

        house_fitle_type_title = (TextView) findViewById(R.id.house_fitle_type_title);
        house_fitle_price_title = (TextView) findViewById(R.id.house_fitle_price_title);
        house_fitle_beds_title = (TextView) findViewById(R.id.house_fitle_beds_title);
        house_fitle_more_title = (TextView) findViewById(R.id.house_fitle_more_title);
        house_fitle_area_title
                = (TextView) findViewById(R.id.house_fitle_area_title);

        swipeRefreshLayout = (SwipeRefreshLayout) findViewById(R.id.main_srl);
        lv = (RecyclerView) findViewById(R.id.main_lv);

        // footerView = getActivity().getLayoutInflater().inflate(R.layout.loading_layout,null);
        //  lv.addFooterView(footerView);

        gridManager =   new GridLayoutManager(HouseListActivity.this, 1);
        lv.setLayoutManager(gridManager);




        lv.setOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
                super.onScrollStateChanged(recyclerView, newState);
                if (newState == RecyclerView.SCROLL_STATE_IDLE && lastVisibleItem + 1 == adapter.getItemCount()) {
                    if (!isMoreLoading) {
                        isMoreLoading = true;
                        myloading.setVisibility(View.VISIBLE);
                        new Handler().postDelayed(new Runnable() {
                            @Override
                            public void run() {



                                //Toast.makeText(AdvanceComInstanceActivity.this, "上拉加载了四条数据...", Toast.LENGTH_SHORT).show();
                                isMoreLoading = false;
                                new LoadDataThread().start();
                            }
                        }, 500);
                    }
                }
            }
            @Override
            public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
                super.onScrolled(recyclerView, dx, dy);
                lastVisibleItem = gridManager.findLastVisibleItemPosition();
            }
        });


        list = new LinkedList();

        bgView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                bgView.setVisibility(View.INVISIBLE);
                typeView.setVisibility(View.INVISIBLE);
                priceView.setVisibility(View.INVISIBLE);
                bedsView.setVisibility(View.INVISIBLE);
                areaView.setVisibility(View.INVISIBLE);
                moreView.setVisibility(View.INVISIBLE);
            }
        });


        searchgo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                bgView.setVisibility(View.INVISIBLE);
                typeView.setVisibility(View.INVISIBLE);
                priceView.setVisibility(View.INVISIBLE);
                bedsView.setVisibility(View.INVISIBLE);
                areaView.setVisibility(View.INVISIBLE);
                moreView.setVisibility(View.INVISIBLE);

                list = new LinkedList();
                swipeRefreshLayout.setRefreshing(true);

                getHouseDatas();
            }
        });


        goMapBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                Intent intent =new Intent(HouseListActivity.this,HomeMapActivity.class);

                //用Bundle携带数据
                Bundle bundle=new Bundle();
                //传递name参数为tinyphp
                bundle.putSerializable("home", "2");

                intent.putExtras(bundle);

                startActivity(intent);
            }
        });




        house_fitle_price_title.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                bgView.setVisibility(View.VISIBLE);
                priceView.setVisibility(View.VISIBLE);

                typeView.setVisibility(View.INVISIBLE);

                areaView.setVisibility(View.INVISIBLE);
                bedsView.setVisibility(View.INVISIBLE);
                moreView.setVisibility(View.INVISIBLE);
            }
        });


        house_fitle_type_title.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                bgView.setVisibility(View.VISIBLE);
                typeView.setVisibility(View.VISIBLE);

                priceView.setVisibility(View.INVISIBLE);

                areaView.setVisibility(View.INVISIBLE);
                bedsView.setVisibility(View.INVISIBLE);
                moreView.setVisibility(View.INVISIBLE);
            }
        });



        house_fitle_beds_title.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                bgView.setVisibility(View.VISIBLE);
                bedsView.setVisibility(View.VISIBLE);

                priceView.setVisibility(View.INVISIBLE);

                areaView.setVisibility(View.INVISIBLE);
                typeView.setVisibility(View.INVISIBLE);
                moreView.setVisibility(View.INVISIBLE);
            }
        });





        house_fitle_area_title.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                bgView.setVisibility(View.VISIBLE);
                typeView.setVisibility(View.INVISIBLE);

                priceView.setVisibility(View.INVISIBLE);

                areaView.setVisibility(View.VISIBLE);

                bedsView.setVisibility(View.INVISIBLE);
                moreView.setVisibility(View.INVISIBLE);
            }
        });



        house_fitle_more_title.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                bgView.setVisibility(View.VISIBLE);
                typeView.setVisibility(View.INVISIBLE);

                priceView.setVisibility(View.INVISIBLE);

                areaView.setVisibility(View.INVISIBLE);

                bedsView.setVisibility(View.INVISIBLE);
                moreView.setVisibility(View.VISIBLE);
            }
        });

        sortBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                try{

                    //  String url = "http://app.usleju.cn/news.html?language="+getLanguage()+"&id="+alldata.getString("id");


                    LinearLayout vv = (LinearLayout)getLayoutInflater().inflate(R.layout.sort, null);

                    final MoreTextViewa a = vv.findViewById(R.id.sort_a);
                    final  MoreTextViewa b = vv.findViewById(R.id.sort_b);
                    final  MoreTextViewa c = vv.findViewById(R.id.sort_c);
                    final  MoreTextViewa d = vv.findViewById(R.id.sort_d);
                    final  MoreTextViewa e = vv.findViewById(R.id.sort_e);
                    final  MoreTextViewa f = vv.findViewById(R.id.sort_f);

                    a.setChecked(false);
                    b.setChecked(false);
                    c.setChecked(false);
                    d.setChecked(false);
                    e.setChecked(false);
                    f.setChecked(false);

                    if(order == null){
                        a.setChecked(true);
                    }else if(order.equals("1")){
                        d.setChecked(true);
                    }else if(order.equals("2")){
                        c.setChecked(true);
                    }else if(order.equals("3")){
                        e.setChecked(true);
                    }else if(order.equals("4")){
                        f.setChecked(true);
                    }

                    a.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            a.setChecked(true);
                            b.setChecked(false);
                            c.setChecked(false);
                            d.setChecked(false);
                            e.setChecked(false);
                            f.setChecked(false);
                            order = null;
                            list = new LinkedList();
                            swipeRefreshLayout.setRefreshing(true);

                            getHouseDatas(); sharedialog.hide();
                        }
                    });

                    b.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            b.setChecked(true);
                            a.setChecked(false);
                            c.setChecked(false);
                            d.setChecked(false);
                            e.setChecked(false);
                            f.setChecked(false);
                            order = null;
                            list = new LinkedList();
                            swipeRefreshLayout.setRefreshing(true);

                            getHouseDatas(); sharedialog.hide();
                        }
                    });

                    c.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            c.setChecked(true);
                            b.setChecked(false);
                            a.setChecked(false);
                            d.setChecked(false);
                            e.setChecked(false);
                            f.setChecked(false);
                            order = "2";
                            list = new LinkedList();
                            swipeRefreshLayout.setRefreshing(true);

                            getHouseDatas(); sharedialog.hide();
                        }
                    });


                    d.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            d.setChecked(true);
                            b.setChecked(false);
                            c.setChecked(false);
                            a.setChecked(false);
                            e.setChecked(false);
                            f.setChecked(false);
                            order = "1";
                            list = new LinkedList();
                            swipeRefreshLayout.setRefreshing(true);

                            getHouseDatas(); sharedialog.hide();
                        }
                    });

                    e.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            e.setChecked(true);
                            b.setChecked(false);
                            c.setChecked(false);
                            d.setChecked(false);
                            a.setChecked(false);
                            f.setChecked(false);
                            order = "3";
                            list = new LinkedList();
                            swipeRefreshLayout.setRefreshing(true);

                            getHouseDatas(); sharedialog.hide();
                        }
                    });


                    f.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            f.setChecked(true);
                            b.setChecked(false);
                            c.setChecked(false);
                            d.setChecked(false);
                            e.setChecked(false);
                            a.setChecked(false);
                            order = "4";
                            list = new LinkedList();
                            swipeRefreshLayout.setRefreshing(true);

                            getHouseDatas();
                            sharedialog.hide();
                        }
                    });

                    AlertDialog.Builder  builder=new AlertDialog.Builder(HouseListActivity.this);


                    builder.setView(vv);


                    sharedialog=builder.create();

                    sharedialog.show();

                }catch (Exception e){
                    e.printStackTrace();
                }
            }
        });



        lv.setAdapter(adapter);


        swipeRefreshLayout.setColorSchemeResources(android.R.color.holo_blue_bright, android.R.color.holo_green_light,
                android.R.color.holo_orange_light, android.R.color.holo_red_light);

        swipeRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                currentPage = 1;
                list = new LinkedList();
                new LoadDataThread().start();
            }
        });

        swipeRefreshLayout.setRefreshing(true);



        getHouseDatas();

        initLang();

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


        getKeyDatas();

    }


    @Override
    public void onRefresh() {



    }


    public  void initLang(){


        if (getLanguage().contains("zh")){
            if (house_fitle_type_title != null)
                house_fitle_type_title.setText("类型");
            if (house_fitle_price_title != null)
                house_fitle_price_title.setText("价格");
            if (house_fitle_area_title != null)
                house_fitle_area_title.setText("面积");
            if (house_fitle_beds_title != null)
                house_fitle_beds_title.setText("卧室");
            if (house_fitle_more_title != null)
                house_fitle_more_title.setText("更多");

            if (sort_text != null)
                sort_text.setText("排序");

        }else{
            if (house_fitle_type_title != null)
                house_fitle_type_title.setText("Type");
            if (house_fitle_price_title != null)
                house_fitle_price_title.setText("Price");
            if (house_fitle_area_title != null)
                house_fitle_area_title.setText("Area");
            if (house_fitle_beds_title != null)
                house_fitle_beds_title.setText("Beds");
            if (house_fitle_more_title != null)
                house_fitle_more_title.setText("More");


            if (sort_text != null)
            sort_text.setText("Sort");
        }
        list = new LinkedList();
        swipeRefreshLayout.setRefreshing(true);

        typeViewIn.initLang(getLanguage());
        priceViewIn.initLang(getLanguage(),type);
        areaViewIn.initLang(getLanguage());
        bedsViewIn.initLang(getLanguage());
        moreViewIn.initLang(getLanguage(),type);
        getHouseDatas();

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






    private void getHouseDatas(){

        p_types =  typeViewIn.getCheck();



        //  tableView.removeAllViews();

        String url = "http://api.usleju.cn/estate/house/search";

        StringBuffer sb = new StringBuffer();
        sb.append(url);

        sb.append("?page=").append(currentPage);
        sb.append("&page_size=").append(pageSize);



        JSONObject obj = new JSONObject();

        JSONObject filters = new JSONObject();
        try {



            if(priceViewIn.getCheck() != null){
                sb.append("&").append(priceViewIn.getCheck());
            }

            if(areaViewIn.getCheck() != null){
                sb.append("&").append(areaViewIn.getCheck());
            }
            if(bedsViewIn.getCheck() != null){
                sb.append("&").append(bedsViewIn.getCheck());
            }

            if(areaViewIn.getCheck() != null){
                sb.append("&").append(areaViewIn.getCheck());
            }

            if(moreViewIn.getMarket() != null){
                sb.append("&").append(moreViewIn.getMarket());
            }

            if(moreViewIn.getParking() != null){
                sb.append("&").append(moreViewIn.getParking());
            }
            if(moreViewIn.getBath() != null){
                sb.append("&").append(moreViewIn.getBath());
            }
            if(order != null){
                sb.append("&").append("order="+order);
            }


            if(inputText.getText() != null && inputText.getText().length()>0){
                sb.append("&").append("q="+inputText.getText());
            }


            if("lease".equals(type)){

            }else{
                for (int i = 0;i < p_types.size();i++){
                    sb.append("&filters[prop-type][]=").append(p_types.get(i));
                }
            }




            sb.append("&").append("type="+type);


        } catch (Exception e) {
            e.printStackTrace();
        }


        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.GET, sb.toString(), obj, new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject jsonObject) {
                try {

                    Integer code =  jsonObject.getInt("code");

                    if(code == 200){

                        //  initNewsData(jsonObject);
                        JSONArray ds = jsonObject.getJSONObject("data").getJSONArray("items");

                        for(int i = 0;i<ds.length();i++){
                            list.add(ds.getJSONObject(i));
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


    class MyAdapter extends RecyclerView.Adapter<MyAdapter.ViewHolder> {

        //RecyclerView显示的子View
        //该方法返回是ViewHolder，当有可复用View时，就不再调用
        @Override
        public ViewHolder onCreateViewHolder(ViewGroup parent, int i) {

            ViewHolder holder = new ViewHolder(LayoutInflater.from(
                    HouseListActivity.this).inflate(R.layout.home_house_cell, parent,
                    false));


            return holder;
        }

        //将数据绑定到子View
        @Override
        public void onBindViewHolder(ViewHolder viewHolder, int i) {
            JSONObject obj  = (JSONObject)list.get(i);

            viewHolder.data = obj;

            TextView title =     viewHolder.title;

            TextView houselocation =     viewHolder.houselocation;

            TextView houseInfor =     viewHolder.houseInfor;

            TextView priceLabel =     viewHolder.priceLabel;
            TextView priceValue =     viewHolder.priceValue;

            TextView statusLabel =     viewHolder.statusLabel;

            TextView marketLabel =     viewHolder.marketLabel;

            try{

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





                Glide.with(HouseListActivity.this)
                        .load(obj.getString("image"))
                        .into(viewHolder.houseImage);

            }catch (Exception e){
                e.printStackTrace();
            }


        }

        //RecyclerView显示数据条数
        @Override
        public int getItemCount() {
            return list.size();
        }

        //自定义的ViewHolder,减少findViewById调用次数
        class ViewHolder extends RecyclerView.ViewHolder {

            TextView title;

            TextView houselocation ;

            TextView houseInfor ;

            TextView priceLabel ;
            TextView priceValue ;

            TextView statusLabel ;

            TextView marketLabel;

            JSONObject data;

            ImageView houseImage;

            public ViewHolder(View itemView) {
                super(itemView);

                itemView.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        try{
                            Intent intent =new Intent(HouseListActivity.this,HouseDetailsActivity.class);
                            JSONObject obj  =data;
                            //用Bundle携带数据
                            Bundle bundle=new Bundle();
                            //传递name参数为tinyphp
                            bundle.putSerializable("id", obj.getString("id"));

                            intent.putExtras(bundle);

                            startActivity(intent);

                        }catch (Exception e){
                            e.printStackTrace();
                        }





                    }
                });


                title =     (TextView)itemView.findViewById(R.id.housetitle);

                houselocation =     (TextView)itemView.findViewById(R.id.houselocation);

                houseInfor =     (TextView)itemView.findViewById(R.id.houseInfor);

                priceLabel =     (TextView)itemView.findViewById(R.id.priceLabel);
                priceValue =     (TextView)itemView.findViewById(R.id.priceValue);

                statusLabel =     (TextView)itemView.findViewById(R.id.statusLabel);

                marketLabel =     (TextView)itemView.findViewById(R.id.marketLabel);

                houseImage =     (ImageView)itemView.findViewById(R.id.houseImage);

            }

        }
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

        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.GET, sb.toString(), obj.toString(), new Response.Listener<JSONObject>() {
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

}