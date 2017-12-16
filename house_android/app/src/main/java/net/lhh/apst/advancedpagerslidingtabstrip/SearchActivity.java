package net.lhh.apst.advancedpagerslidingtabstrip;

import android.app.AlertDialog;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.SimpleAdapter;
import android.widget.SimpleCursorAdapter;
import android.widget.TextView;

import com.android.volley.AuthFailureError;
import com.android.volley.DefaultRetryPolicy;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.baidu.mapapi.SDKInitializer;
import com.baidu.mapapi.map.MapView;

import net.cfg.AppCfg;
import net.lhh.apst.fragments.ComCell;
import net.lhh.apst.fragments.MoreTextViewa;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

/**
 * Created by ld on 04/10/2017.
 */

public class SearchActivity extends BaseActivity {
    ImageView backBtn;
    JSONArray keys = null;
    LinearLayout comView;
    EditText inputText;

    String type= "purchase";//lease
    LinearLayout gvvvv;

    TextView typeTitle;


    private GridView gview;
    private List<Map<String, Object>> data_list;
    private SimpleAdapter sim_adapter;

    ListView listView;

    RelativeLayout nodataView;

    TextView nodataText;
    TextView  hotArealabel;
    TextView  historylabel;
    private AlertDialog sharedialog;
    List a ;

    ImageView searchgo;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        SDKInitializer.initialize(getApplicationContext());
        setContentView(R.layout.activity_search);
        backBtn = (ImageView)findViewById(R.id.back_btn);
        comView = (LinearLayout)findViewById(R.id.comView);
        inputText = (EditText) findViewById(R.id.inputText);
        gvvvv = (LinearLayout) findViewById(R.id.gvvvv);

        hotArealabel = (TextView) findViewById(R.id.hotArealabel);

        historylabel = (TextView) findViewById(R.id.historylabel);

        searchgo = (ImageView) findViewById(R.id.searchgo);
        typeTitle = (TextView) findViewById(R.id.typeTitle);

        nodataText = (TextView) findViewById(R.id.nodataText);

        backBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                SearchActivity.this.finish();
            }
        });

        nodataView = (RelativeLayout) findViewById(R.id.nodataView);

        gview = (GridView) findViewById(R.id.gview);
        listView = (ListView) findViewById(R.id.listView);
        //新建List
        data_list = new ArrayList<Map<String, Object>>();

        searchgo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent =new Intent(SearchActivity.this,HouseListActivity.class);
                //用Bundle携带数据
                Bundle bundle=new Bundle();
                //传递name参数为tinyphp

                if(inputText.getText() != null && inputText.getText().length()>0){
                    bundle.putSerializable("key", inputText.getText().toString());
                    App app = (App)getApplication();
                    app.addKeys( inputText.getText().toString());
                }

                bundle.putSerializable("type", type);
                intent.putExtras(bundle);

                startActivity(intent);
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



                AlertDialog.Builder  builder=new AlertDialog.Builder(SearchActivity.this);


                builder.setView(vv);


                sharedialog=builder.create();
                //sharedialog.setTitle("房屋类型选择");


                sharedialog.show();


            }
        });

        if (getLanguage().contains("zh")){
            typeTitle.setText("购房");
            nodataText.setText("暂无历史搜索记录");

            hotArealabel.setText("热门区域");
            historylabel.setText("历史搜索记录");


        }else{
            typeTitle.setText("Purchase");
            nodataText.setText("No records");

            hotArealabel.setText("Hot");
            historylabel.setText("History");

        }

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
                                if(obj.getString("title").contains(inputText.getText())){

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

                                                App app = (App)getApplication();
                                                app.addKeys(o.getString("title"));

                                                Intent intent =new Intent(SearchActivity.this,HouseListActivity.class);
                                                //用Bundle携带数据
                                                Bundle bundle=new Bundle();
                                                //传递name参数为tinyphp
                                                bundle.putSerializable("key", o.getString("title"));
                                                bundle.putSerializable("type", type);
                                                intent.putExtras(bundle);

                                                startActivity(intent);

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
        getHotDatas();
        App app = (App)getApplication();
         a = app.getKeys();

        if(a.size()>0){
            listView.setVisibility(View.VISIBLE);
            nodataView.setVisibility(View.INVISIBLE);

        }else{
            listView.setVisibility(View.INVISIBLE);
            nodataView.setVisibility(View.VISIBLE);
        }


        String [] from ={"text"};
        int [] to = {R.id.texta};
        SimpleAdapter    asim_adapter = new SimpleAdapter(this, a, R.layout.search_item_a, from, to);

        listView.setAdapter(asim_adapter);


        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                Map map =  (Map)a.get(position);

                App app = (App)getApplication();
                app.addKeys(map.get("text").toString());



                Intent intent =new Intent(SearchActivity.this,HouseListActivity.class);
                //用Bundle携带数据
                Bundle bundle=new Bundle();
                //传递name参数为tinyphp
                bundle.putSerializable("key", map.get("text").toString());
                bundle.putSerializable("type", type);
                intent.putExtras(bundle);

                startActivity(intent);


            }
        });

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



    private void getHotDatas(){

        String url = "http://api.usleju.cn/estate/house/hot-areas";

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

                       initHot(jsonObject.getJSONObject("data"));
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

    private void initHot(JSONObject obj){

        for(Iterator it = obj.keys();it.hasNext();){

            try{

                String key = it.next().toString();

                Map<String, Object> map = new HashMap<String, Object>();
                map.put("code", key);
                map.put("text", obj.getString(key));
                data_list.add(map);
            }catch (Exception e){
             e.printStackTrace();
            }


        }

        //新建适配器
        String [] from ={"text"};
        int [] to = {R.id.text};
        sim_adapter = new SimpleAdapter(this, data_list, R.layout.search_item, from, to);
        //配置适配器
        gview.setAdapter(sim_adapter);

        gview.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                Map<String, Object> map = data_list.get(position);

                App app = (App)getApplication();
                app.addKeys(map.get("text").toString());



                Intent intent =new Intent(SearchActivity.this,HouseListActivity.class);
                //用Bundle携带数据
                Bundle bundle=new Bundle();
                //传递name参数为tinyphp
                bundle.putSerializable("key", map.get("text").toString());
                bundle.putSerializable("type", type);
                intent.putExtras(bundle);

                startActivity(intent);


            }
        });

    }

}
