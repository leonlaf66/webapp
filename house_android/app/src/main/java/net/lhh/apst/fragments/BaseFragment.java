package net.lhh.apst.fragments;

import android.app.Fragment;
import android.view.Window;

import net.lhh.apst.advancedpagerslidingtabstrip.App;
import net.lhh.apst.advancedpagerslidingtabstrip.LoadingDialog;

/**
 * Created by ld on 03/10/2017.
 */

public class BaseFragment extends Fragment {

    private LoadingDialog loadingDialog;


    public  String getLanguage(){
        App app = (App)getActivity().getApplication();

        return app.getLanguage();
    }

    public void setLanguage(String language) {
        App app = (App)getActivity().getApplication();
        app.setLanguage(language);

    }

    public  void showLoading(String msg){
        loadingDialog =   new LoadingDialog(getActivity());
        //

        loadingDialog.setMessage(msg);
        loadingDialog.show();
    }

    public  void hideLoading(){
        loadingDialog.hide();
    }
}
