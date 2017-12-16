package net.lhh.apst.advancedpagerslidingtabstrip;

import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.baidu.mapapi.SDKInitializer;

/**
 * Created by ld on 04/10/2017.
 */

public class AboutusActivity extends BaseActivity {
    ImageView backBtn;
    TextView home_map_title;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        SDKInitializer.initialize(getApplicationContext());
        setContentView(R.layout.activity_about_us);
        backBtn = (ImageView)findViewById(R.id.home_map_go_btn);

        home_map_title = (TextView)findViewById(R.id.home_map_title);

        if(getLanguage().contains("zh")){
            home_map_title.setText("关于我们");
        }else{
            home_map_title.setText("About us");
        }


        backBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AboutusActivity.this.finish();
            }
        });

    }

}
