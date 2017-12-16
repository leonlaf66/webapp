package net.lhh.apst.advancedpagerslidingtabstrip;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

public class HomeMapSearchActivity extends BaseActivity {
    ImageView backBtn;
    TextView naTitle;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home_map_search);
        backBtn = (ImageView)findViewById(R.id.home_map_go_btn);
        naTitle = (TextView)findViewById(R.id.home_map_title);

        if(getLanguage().contains("zh")){
            naTitle.setText("购房流程");

        }else{
            naTitle.setText("Purchase flows");
        }

        backBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                HomeMapSearchActivity.this.finish();
            }
        });
    }

}
