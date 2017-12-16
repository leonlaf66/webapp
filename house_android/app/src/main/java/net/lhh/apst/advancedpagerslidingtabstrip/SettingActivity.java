package net.lhh.apst.advancedpagerslidingtabstrip;

import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.baidu.mapapi.SDKInitializer;

/**
 * Created by ld on 04/10/2017.
 */

public class SettingActivity extends BaseActivity {
    ImageView backBtn;
    TextView home_map_title;

    TextView cleanText;
    TextView logoutText;

    LinearLayout cleanView;
    LinearLayout outView;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        SDKInitializer.initialize(getApplicationContext());
        setContentView(R.layout.activity_setting);
        backBtn = (ImageView)findViewById(R.id.home_map_go_btn);

        home_map_title = (TextView)findViewById(R.id.home_map_title);


        cleanText = (TextView)findViewById(R.id.cleanText);

        logoutText = (TextView)findViewById(R.id.logoutText);

        cleanView = (LinearLayout)findViewById(R.id.cleanView);

        outView = (LinearLayout)findViewById(R.id.outView);


        cleanView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(getLanguage().contains("zh")){
                    Toast.makeText(SettingActivity.this, "内存清理成功", Toast.LENGTH_SHORT).show();
                }else{
                    Toast.makeText(SettingActivity.this, "Clean successfully", Toast.LENGTH_SHORT).show();
                }
            }
        });


        outView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                App app = (App)getApplication();
                app.deleteUser();
                if(getLanguage().contains("zh")){
                    Toast.makeText(SettingActivity.this, "注销成功", Toast.LENGTH_SHORT).show();
                }else{
                    Toast.makeText(SettingActivity.this, "Log out successfully", Toast.LENGTH_SHORT).show();
                }


            }
        });



        if(getLanguage().contains("zh")){
            home_map_title.setText("设置");
            cleanText.setText("内存清理");
            logoutText.setText("退出登录");
        }else{
            home_map_title.setText("Setting");
            cleanText.setText("Clean memory");
            logoutText.setText("LOG OUT");
        }


        backBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                SettingActivity.this.finish();
            }
        });

    }

}
