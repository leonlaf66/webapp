package net.lhh.apst.advancedpagerslidingtabstrip;

import android.support.v7.app.AppCompatActivity;

/**
 * Created by ld on 03/10/2017.
 */

public class BaseActivity extends AppCompatActivity {
    private LoadingDialog loadingDialog;
    public  String getLanguage(){
        App app = (App)getApplication();

        return app.getLanguage();
    }

    public void setLanguage(String language) {
        App app = (App)getApplication();
        app.setLanguage(language);

    }

    public  void showLoading(String msg){
        loadingDialog =   new LoadingDialog(this);
        //

        loadingDialog.setMessage(msg);
        loadingDialog.show();
    }

    public  void hideLoading(){
        loadingDialog.hide();
    }

}
