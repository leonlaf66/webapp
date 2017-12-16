package net.lhh.apst.advancedpagerslidingtabstrip;

import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.baidu.mapapi.SDKInitializer;
import com.livechatinc.inappchat.ChatWindowFragment;

/**
 * Created by ld on 04/10/2017.
 */

public class ChatActivity extends BaseActivity {
    ImageView backBtn;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        SDKInitializer.initialize(getApplicationContext());
        setContentView(R.layout.activity_chat);
        backBtn = (ImageView)findViewById(R.id.home_map_go_btn);


        backBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ChatActivity.this.finish();
            }
        });


    }

}
