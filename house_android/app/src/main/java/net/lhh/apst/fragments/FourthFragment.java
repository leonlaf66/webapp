package net.lhh.apst.fragments;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;

import net.lhh.apst.advancedpagerslidingtabstrip.AboutusActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.App;
import net.lhh.apst.advancedpagerslidingtabstrip.FavoriteActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.HouseListActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.LoginActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.R;
import net.lhh.apst.advancedpagerslidingtabstrip.ScheduleActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.ServiceDetailsActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.SettingActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.WesUser;

/**
 * Created by linhonghong on 2015/8/11.
 */
public class FourthFragment extends BaseFragment {

    ImageView personImg;
    ImageView  myheader;

    RelativeLayout aboutus;
    RelativeLayout setting;
    RelativeLayout myschedule;
    RelativeLayout myfavorite;
    TextView headertitle;
    TextView mytitle;
    TextView yuyuetitle;
    TextView shezhititle;

    TextView acouttitle;

    public static FourthFragment instance() {
        FourthFragment view = new FourthFragment();
        return view;
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fourth_fragment, null);
        personImg = (ImageView)view.findViewById(R.id.personImg);
        myheader = (ImageView)view.findViewById(R.id.myheader);
        aboutus = (RelativeLayout)view.findViewById(R.id.aboutus);
        setting = (RelativeLayout)view.findViewById(R.id.setting);
        headertitle = (TextView)view.findViewById(R.id.headertitle);

        myschedule = (RelativeLayout)view.findViewById(R.id.myschedule);
        myfavorite = (RelativeLayout)view.findViewById(R.id.myfavorite);
        mytitle =  (TextView)view.findViewById(R.id.mytitle);
        yuyuetitle =  (TextView)view.findViewById(R.id.yuyuetitle);

        shezhititle =  (TextView)view.findViewById(R.id.shezhititle);

        acouttitle =  (TextView)view.findViewById(R.id.acouttitle);

        myschedule.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                App app = (App)getActivity().getApplication();

                WesUser user = app.getLastUser();

                if(user == null){
                    startActivityForResult(new Intent(getActivity(), LoginActivity.class), 111);
                }else{
                    getActivity().startActivity(new Intent(getActivity(), ScheduleActivity.class));
                }




            }
        });

        myfavorite.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {


                App app = (App)getActivity().getApplication();

                WesUser user = app.getLastUser();

                if(user == null){
                    startActivityForResult(new Intent(getActivity(), LoginActivity.class), 111);
                }else{
                    getActivity().startActivity(new Intent(getActivity(), FavoriteActivity.class));
                }




            }
        });

        setting.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                getActivity().startActivity(new Intent(getActivity(), SettingActivity.class));

            }
        });

        personImg.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                App app = (App)getActivity().getApplication();

                WesUser user = app.getLastUser();

                if(user == null){
                    startActivityForResult(new Intent(getActivity(), LoginActivity.class), 111);
                }



               // getActivity().startActivity(new Intent(getActivity(), LoginActivity.class));

            }
        });

        aboutus.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                getActivity().startActivity(new Intent(getActivity(), AboutusActivity.class));

            }
        });

        aloadView();


        return view;
    }

    public void aloadView(){

        if(getActivity() != null && getActivity().getApplication() != null){

            App app = (App) getActivity().getApplication();
            WesUser user = app.getLastUser();

            if(myheader != null && user != null){

                if(user.getAvatar().length() > 10){
                    Glide.with(getActivity())
                            .load(user.getAvatar())
                            .into(myheader);
                }


            }

            if (headertitle != null){
                if(user != null){
                    headertitle.setText(user.getPhone());
                }else{

                    if(getLanguage().contains("zh")){
                        headertitle.setText("登录");

                    }else{
                        headertitle.setText("Login in");

                    }

                }
            }

            if (mytitle != null){

                if(getLanguage().contains("zh")){

                    mytitle.setText("我的收藏");
                }else{

                    mytitle.setText("My favorites");
                }
            }


            if (yuyuetitle != null){

                if(getLanguage().contains("zh")){

                    yuyuetitle.setText("我的预约");
                }else{

                    yuyuetitle.setText("My schedule");
                }
            }


            if (shezhititle != null){

                if(getLanguage().contains("zh")){

                    shezhititle.setText("设置");
                }else{

                    shezhititle.setText("Setting");
                }
            }

            if (acouttitle != null){

                if(getLanguage().contains("zh")){

                    acouttitle.setText("关于我们");
                }else{

                    acouttitle.setText("About us");
                }
            }



        }





    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if(resultCode == 111){

        }
    }
}