package net.lhh.apst.advancedpagerslidingtabstrip;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.v7.app.ActionBarActivity;


public class MainActivity extends ActionBarActivity {



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        new Handler().postDelayed(new Runnable() {
            public void run() {
                MainActivity.this.startActivity(new Intent(MainActivity.this,IconTabActivity.class));
                MainActivity.this.finish();
            }
        }, 2000);

    }




}
