package net.lhh.apst.advancedpagerslidingtabstrip;

import android.app.Fragment;
import android.app.FragmentManager;
import android.content.Intent;
import android.graphics.Rect;
import android.os.Bundle;
import android.support.v13.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;


import com.livechatinc.inappchat.ChatWindowFragment;

import net.lhh.apst.fragments.FirstFragment;
import net.lhh.apst.fragments.FourthFragment;
import net.lhh.apst.fragments.SecondFragment;
import net.lhh.apst.fragments.ThirdFragment;
import net.lhh.apst.library.AdvancedPagerSlidingTabStrip;

/**
 * Created by linhonghong on 2015/8/11.
 */
public class IconTabActivity extends AppCompatActivity implements ViewPager.OnPageChangeListener{

    public AdvancedPagerSlidingTabStrip mAPSTS;
    public APSTSViewPager mVP;

    private static final int VIEW_FIRST 		= 0;
    private static final int VIEW_SECOND	    = 1;
    private static final int VIEW_THIRD       = 2;
    private static final int VIEW_FOURTH    = 3;

    private static final int VIEW_SIZE = 4;

    private FirstFragment mFirstFragment = null;
    private SecondFragment mSecondFragment = null;
    private ChatWindowFragment mThirdFragment = null;
    private FourthFragment mFourthFragment = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_icon_tab);
        findViews();
        init();
    }

    private void findViews(){
        mAPSTS = (AdvancedPagerSlidingTabStrip)findViewById(R.id.tabs);
        mVP = (APSTSViewPager)findViewById(R.id.vp_main);
    }

    private void init(){
        mVP.setOffscreenPageLimit(VIEW_SIZE);

        FragmentAdapter adapter = new FragmentAdapter(getFragmentManager());

        mVP.setAdapter(new FragmentAdapter(getFragmentManager()));

        adapter.notifyDataSetChanged();
        mAPSTS.setViewPager(mVP);
        mAPSTS.setOnPageChangeListener(this);
        mVP.setCurrentItem(VIEW_FIRST);
        // mAPSTS.showDot(VIEW_FIRST,"99+");
    }

    @Override
    public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

    }

    @Override
    public void onPageSelected(int position) {

    }

    @Override
    public void onPageScrollStateChanged(int state) {

    }

    public class FragmentAdapter extends FragmentPagerAdapter implements AdvancedPagerSlidingTabStrip.IconTabProvider{

        public FragmentAdapter(FragmentManager fm) {
            super(fm);
        }

        @Override
        public Fragment getItem(int position) {
            if(position >= 0 && position < VIEW_SIZE){
                switch (position){
                    case  VIEW_FIRST:
                        if(null == mFirstFragment)
                            mFirstFragment = FirstFragment.instance();
                        return mFirstFragment;

                    case VIEW_SECOND:
                        if(null == mSecondFragment)
                            mSecondFragment = SecondFragment.instance();
                        return mSecondFragment;

                    case VIEW_THIRD:
                        if(null == mThirdFragment)
                            mThirdFragment =ChatWindowFragment.newInstance("7739171","0");



                        return mThirdFragment;

                    case VIEW_FOURTH:
                        if(null == mFourthFragment)
                            mFourthFragment = FourthFragment.instance();

                        App app = (App)getApplication();
                        app.mFourthFragment = mFourthFragment;
                        return mFourthFragment;
                    default:
                        break;
                }
            }
            return null;
        }

        @Override
        public int getCount() {
            return VIEW_SIZE;
        }

        @Override
        public CharSequence getPageTitle(int position) {
            if(position >= 0 && position < VIEW_SIZE){
                App app = (App)getApplication();

                if(app.getLanguage().contains("zh")){
                    switch (position){
                        case  VIEW_FIRST:
                            return  "首页";
                        case  VIEW_SECOND:
                            return  "找房";
                        case  VIEW_THIRD:
                            return  "服务";
                        case  VIEW_FOURTH:
                            return  "我";
                        default:
                            break;
                    }
                }else{
                    switch (position){
                        case  VIEW_FIRST:
                            return  "Home";
                        case  VIEW_SECOND:
                            return  "Search";
                        case  VIEW_THIRD:
                            return  "Service";
                        case  VIEW_FOURTH:
                            return  "Me";
                        default:
                            break;
                    }
                }


            }
            return null;
        }

        @Override
        public Integer getPageIcon(int index) {
            if(index >= 0 && index < VIEW_SIZE){
                switch (index){
                    case  VIEW_FIRST:
                        return  R.mipmap.home_main_icon_n;
                    case VIEW_SECOND:
                        return  R.mipmap.home_categry_icon_n;
                    case VIEW_THIRD:
                        return  R.mipmap.home_live_icon_n;
                    case VIEW_FOURTH:
                        return  R.mipmap.home_mine_icon_n;
                    default:
                        break;
                }
            }
            return 0;
        }

        @Override
        public Integer getPageSelectIcon(int index) {
            if(index >= 0 && index < VIEW_SIZE){
                switch (index){
                    case  VIEW_FIRST:
                        return  R.mipmap.home_main_icon_f_n;
                    case VIEW_SECOND:
                        return  R.mipmap.home_categry_icon_f_n;
                    case VIEW_THIRD:
                        return  R.mipmap.home_live_icon_f_n;
                    case VIEW_FOURTH:
                        return  R.mipmap.home_mine_icon_f_n;
                    default:
                        break;
                }
            }
            return 0;
        }

        @Override
        public Rect getPageIconBounds(int position) {
            return null;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if(resultCode == 111){
            //  mFourthFragment.aloadView();
        }
    }

    public  void loadDataByLanguage(){
        RelativeLayout tab1 = (RelativeLayout)  mAPSTS.getTabAt(0);
        TextView tv1 = (TextView)tab1.getChildAt(0);


        RelativeLayout tab2 = (RelativeLayout)  mAPSTS.getTabAt(1);
        TextView tv2 = (TextView)tab2.getChildAt(0);


        RelativeLayout tab3 = (RelativeLayout)  mAPSTS.getTabAt(2);
        TextView tv3 = (TextView)tab3.getChildAt(0);


        RelativeLayout tab4 = (RelativeLayout)  mAPSTS.getTabAt(3);
        TextView tv4 = (TextView)tab4.getChildAt(0);


        App app = (App)getApplication();

        if(app.getLanguage().contains("zh")){
            tv1.setText("首页");
            tv2.setText("找房");
            tv3.setText("服务");
            tv4.setText("我的");
        }else{
            tv1.setText("Home");
            tv2.setText("Search");
            tv3.setText("Service");
            tv4.setText("Me");
        }

        if( mFourthFragment!= null){
            mFourthFragment.aloadView();
        }

    }

    public  void initLang(){
        mSecondFragment.initLang();
    }
}
