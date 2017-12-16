package net.lhh.apst.advancedpagerslidingtabstrip;

import android.app.Application;
import android.database.sqlite.SQLiteDatabase;

import com.android.volley.RequestQueue;
import com.android.volley.toolbox.Volley;
import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.imagepipeline.backends.okhttp.OkHttpImagePipelineConfigFactory;
import com.facebook.imagepipeline.core.ImagePipelineConfig;
import com.mob.MobApplication;
import com.mob.MobSDK;
import com.squareup.okhttp.OkHttpClient;
import com.baidu.mapapi.SDKInitializer;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import android.content.Context;
import android.database.Cursor;

import net.lhh.apst.fragments.FourthFragment;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;


/**
 * Created by ld on 16/2/16.
 */
public class App extends MobApplication{
    // 建立请求队列
    public static RequestQueue queue;

    private String language = "en-US";

    SQLiteDatabase db = null;

    public  String area = "ma";

    IWXAPI mWxApi;

    public FourthFragment mFourthFragment;

    @Override
    public void onCreate() {

        super.onCreate();
        ResourcesManager.getInstace(MobSDK.getContext());
        ImagePipelineConfig frescoConfig = OkHttpImagePipelineConfigFactory
                .newBuilder(this, new OkHttpClient())
                .build();
        Fresco.initialize(this,frescoConfig);
        queue = Volley.newRequestQueue(getApplicationContext());
        SDKInitializer.initialize(this);
        //自4.3.0起，百度地图SDK所有接口均支持百度坐标和国测局坐标，用此方法设置您使用的坐标类型.
        //包括BD09LL和GCJ02两种坐标，默认是BD09LL坐标。
        initDataBase();

        Locale locale = getResources().getConfiguration().locale;
        String lang = locale.getLanguage();
        if(lang.contains("zh")){
            language = "zh-CN";
        }else{
            language = "en-US";
        }


        registToWX();
    }

    private void registToWX() {

        //AppConst.WEIXIN.APP_ID是指你应用在微信开放平台上的AppID，记得替换。
        mWxApi = WXAPIFactory.createWXAPI(this,"wxca09ddff0b293126", true);
        // 将该app注册到微信
        mWxApi.registerApp("wxca09ddff0b293126");
    }


    private void initDataBase(){

        db = openOrCreateDatabase("usleju.db", Context.MODE_PRIVATE, null);

        this.createUserTable();
        this.createKeyTable();

    }

    private void createUserTable(){

        StringBuffer sb = new StringBuffer();
        sb.append("CREATE TABLE IF NOT EXISTS User");
        sb.append("(");
        sb.append("'phone' VARCHAR(50,0) NOT NULL,");
        sb.append("'name' VARCHAR(50,0),");
        sb.append("'password' VARCHAR(50,0),");
        sb.append("'gesture' VARCHAR(50,0),");
        sb.append("'token' VARCHAR(100,0),");
        sb.append(" 'img' VARCHAR(100,0),");
        sb.append("PRIMARY KEY('phone')");
        sb.append(")");
        db.execSQL(sb.toString());

    }


    private void createKeyTable(){

        StringBuffer sb = new StringBuffer();
        sb.append("CREATE TABLE IF NOT EXISTS Keys");
        sb.append("(");
        sb.append("'id' integer PRIMARY KEY autoincrement,");
        sb.append("'name' VARCHAR(50,0)");
        sb.append(")");
        db.execSQL(sb.toString());

    }

    public void deleteUser(){
        db.delete("User",null,null);

    }

    public void addUser(WesUser user){

        StringBuffer sb = new StringBuffer();
        sb.append("INSERT INTO User(phone,name,password,gesture,token,img) VALUES(?,?,?,?,?,?)");
        db.execSQL(sb.toString(), new String[]{user.getPhone(),user.getName(), user.getPassword(),user.getPhone(),user.getToken(),user.getAvatar()});

    }


    public void addKeys(String  key){



        StringBuffer sba = new StringBuffer();
        sba.append("Delete from  Keys where name=?");
        db.execSQL(sba.toString(), new String[]{key});



        StringBuffer sb = new StringBuffer();
        sb.append("INSERT INTO Keys(name) VALUES(?)");
        db.execSQL(sb.toString(), new String[]{key});

    }


    public List getKeys() {
      List rs = new ArrayList();
        Cursor c = db.rawQuery("SELECT name FROM Keys order by id desc limit 0,4", null);
        while (c.moveToNext()) {

            Map<String, Object> map = new HashMap<String, Object>();
            map.put("code", c.getString(0));
            map.put("text", c.getString(0));

            rs.add(map);
        }

        return rs;


    }


    public  WesUser getLastUser() {
        WesUser user = null;
        Cursor c = db.rawQuery("SELECT phone,name,password,token,img FROM User ", null);
        while (c.moveToNext()) {
            user = new WesUser();
            user.setPhone(c.getString(0));
            user.setName(c.getString(1));
            user.setPassword(c.getString(2));
            user.setToken(c.getString(3));
            user.setAvatar(c.getString(4));
        }

        return user;


    }


    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public static RequestQueue getHttpQueue() {
        return queue;
    }
}
