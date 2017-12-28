package net.lhh.apst.fragments;

/**
 * Created by ld on 28/10/2017.
 */

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.DefaultRetryPolicy;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import net.cfg.AppCfg;
import net.lhh.apst.advancedpagerslidingtabstrip.App;
import net.lhh.apst.advancedpagerslidingtabstrip.FavoriteActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.R;
public class UpdateManager {
    private static final String VERSION_PATH = "http://api.usleju.cn/support/configs/get?app_id=android&config_id=androidVersion";
    private static final int DOWNLOAD_ING = 1;
    private static final int DOWNLOAD_OVER = 2;
    private String version_code;
    private String version_name ="usleju";
    private String version_desc;
    private String version_path = "http://13.58.244.145/app-release.apk";
    private Activity mContext;
    private String mSavePath;
    private ProgressBar mProgress;
    private int progress;
    private Dialog downDialog;
    private Boolean isCancle = false;
    public UpdateManager(Activity context){
        mContext = context;
    }

    private Handler progressHandler = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what){
                case DOWNLOAD_ING:
                    mProgress.setProgress(progress);
                    break;
                case DOWNLOAD_OVER:
                    downDialog.dismiss();
                    installAPK();
                    break;
            }
        }
    };


    private Handler versionHandler = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            JSONObject jsonObject = (JSONObject) msg.obj;
            try {
                version_code = jsonObject.getString("data");
               // version_name = jsonObject.getString("version_name");
               // version_desc = jsonObject.getString("version_desc");
               // version_path = jsonObject.getString("version_path");

                if (isUpdate()){
                   // Toast.makeText(mContext, "需要更新", Toast.LENGTH_SHORT).show();
                    // 显示提示更新对话框
                    showNoticeDialog();
                } else{
                   // Toast.makeText(mContext, "已是最新版本", Toast.LENGTH_SHORT).show();
                }

            } catch (JSONException e) {
                e.printStackTrace();
            }

        }
    };


    /**
     *检测软件是否需要更新
     * */
    public void checkUpdate() {

        JSONObject obj = new JSONObject();

        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.GET, VERSION_PATH, obj, new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject jsonObject) {
                try {


                    Integer code =  jsonObject.getInt("code");

                    if(code == 200){

                        Message msg = Message.obtain();
                        msg.obj = jsonObject;
                        versionHandler.sendMessage(msg);

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
                    // MCrypt mCrypt = new MCrypt();
                    // headers.put("accept", "text/json");
                    headers.put("app-token",  AppCfg.TOKEN);
                   // headers.put("language", getLanguage());
                } catch (Exception e) {
                    e.printStackTrace();
                }
                return headers;
            }
        };

        jsonObjectRequest.setRetryPolicy(new DefaultRetryPolicy(5 * 1000, 1, 1.0f));

        App.getHttpQueue().add(jsonObjectRequest);


    }


    /**
     * 是否需要更新
     * @return
     */
    protected boolean isUpdate() {

        float serverVersion = Float.parseFloat(version_code);
        int localVersion = 1;

        try {
            localVersion = mContext.getPackageManager().getPackageInfo("net.lhh.apst.advancedpagerslidingtabstrip",0).versionCode;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

        if(serverVersion > localVersion){
            return  true;
        }
        return  false;
    }


    /*
    * 有更新时显示提示对话框
    */
    protected void showNoticeDialog() {



        App app = (App)mContext.getApplication();
        AlertDialog.Builder builder = new AlertDialog.Builder(mContext);

        if(app.getLanguage().contains("zh")){
            builder.setTitle("发现新版本");
            builder.setMessage("需要升级吗? " );
            builder.setPositiveButton("更新", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    //取消对话框
                    dialog.dismiss();
                    //下载文件
                   // showDownloadDialog();

                    Intent intent = new Intent();
//Intent intent = new Intent(Intent.ACTION_VIEW,uri);
                    intent.setAction("android.intent.action.VIEW");
                    Uri content_url = Uri.parse("https://fir.im/e9gr");
                    intent.setData(content_url);
                    mContext.startActivity(intent);
                }
            });

            builder.setNegativeButton("下次再说", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    //取消对话框
                    dialog.dismiss();
                }
            });
        }else{


            builder.setTitle("New version found");
            builder.setMessage("Did update?");
            builder.setPositiveButton("UPDATE", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    //取消对话框
                    dialog.dismiss();
                    //下载文件
                    showDownloadDialog();
                }
            });

            builder.setNegativeButton("CANCEL", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    //取消对话框
                    dialog.dismiss();
                }
            });

        }

        builder.create().show();
    }


    /*
     * 显示正在下载对话框
     */
    protected void showDownloadDialog() {

        App app = (App)mContext.getApplication();

        View view = LayoutInflater.from(mContext).inflate(R.layout.down_progress,null);
        mProgress = (ProgressBar) view.findViewById(R.id.id_Progress);
        AlertDialog.Builder builder = new AlertDialog.Builder(mContext);


        if(app.getLanguage().contains("zh")){
            builder.setTitle("正在下载");
            builder.setView(view);
            builder.setNegativeButton("取消下载", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    isCancle = true;
                }
            });
        }else{
            builder.setTitle("Downloading");
            builder.setView(view);
            builder.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    isCancle = true;
                }
            });
        }


        downDialog = builder.create();
        downDialog.setCanceledOnTouchOutside(false);
        downDialog.show();

        downloadAPK();
    }

    /*
    * 开启新线程下载文件
    */
    private void downloadAPK() {
        System.out.println(version_path);
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    if(Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)){
                        String sdPath = Environment.getExternalStorageDirectory() + "/";
                        mSavePath = sdPath +"deanDownload";
                        File file = new File(mSavePath);
                        if(!file.exists()){
                            file.mkdir();
                        }

                        URL url = new URL(version_path);
                        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                        connection.connect();
                        InputStream is = connection.getInputStream();

                        int len = connection.getContentLength();
                        File apkFile = new File(mSavePath, version_name);
                        FileOutputStream fos = new FileOutputStream(apkFile);
                        int count = 0;
                        byte[] buffer = new byte[1024];
                        while(!isCancle){
                            int numread = is.read(buffer);
                            count += numread;
                            // 计算进度条的当前位置
                            progress = (int) (((float)count/len) * 100);
                            // 更新进度条
                            progressHandler.sendEmptyMessage(DOWNLOAD_ING);

                            // 下载完成
                            if (numread < 0){
                                progressHandler.sendEmptyMessage(DOWNLOAD_OVER);
                                break;
                            }
                            fos.write(buffer, 0, numread);
                        }
                    }else{
                        System.out.println("00000000000000000000000000000");
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                }

            }
        }).start();
    }


    /*
     * 下载到本地后执行安装
     */
    protected void installAPK() {
        File apkFile = new File(mSavePath, version_name);
        if (!apkFile.exists())
            return;

        Intent intent = new Intent(Intent.ACTION_VIEW);
        Uri uri = Uri.parse("file://" + apkFile.toString());
        intent.setDataAndType(uri, "application/vnd.android.package-archive");
        mContext.startActivity(intent);
    }

}
