/*
 * 官网地站:http://www.mob.com
 * 技术支持QQ: 4006852216
 * 官方微信:ShareSDK   （如果发布新版本的话，我们将会第一时间通过微信将版本更新内容推送给您。如果使用过程中有任何问题，也可以通过微信与我们取得联系，我们将会在24小时内给予回复）
 *
 * Copyright (c) 2013年 mob.com. All rights reserved.
 */

package net.lhh.apst.advancedpagerslidingtabstrip.wxapi;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.DefaultRetryPolicy;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.modelmsg.SendAuth;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import net.cfg.AppCfg;
import net.lhh.apst.advancedpagerslidingtabstrip.App;
import net.lhh.apst.advancedpagerslidingtabstrip.BaseActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.LoginActivity;
import net.lhh.apst.advancedpagerslidingtabstrip.WesUser;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import cn.sharesdk.wechat.utils.WXAppExtendObject;
import cn.sharesdk.wechat.utils.WXMediaMessage;
import cn.sharesdk.wechat.utils.WechatHandlerActivity;


/**
 * 微信登录页面
 * @author kevin_chen 2016-12-10 下午19:03:45
 * @version v1.0
 */
public class WXEntryActivity extends BaseActivity implements IWXAPIEventHandler {
	private static final String APP_SECRET = "44b6833a0b635628a312d29bfccf2162";
	private IWXAPI mWeixinAPI;
	public static final String WEIXIN_APP_ID = "wxca09ddff0b293126";
	private static String uuid;


	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mWeixinAPI = WXAPIFactory.createWXAPI(this, WEIXIN_APP_ID, true);
		mWeixinAPI.handleIntent(this.getIntent(), this);
	}

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
		setIntent(intent);
		mWeixinAPI.handleIntent(intent, this);//必须调用此句话
	}

	//微信发送的请求将回调到onReq方法
	@Override
	public void onReq(BaseReq req) {
		//LogUtils.log("onReq");
	}

	//发送到微信请求的响应结果
	@Override
	public void onResp(BaseResp resp) {
		//LogUtils.log("onResp");
		switch (resp.errCode) {
			case BaseResp.ErrCode.ERR_OK:
				//LogUtils.log("ERR_OK");
				//发送成功
				SendAuth.Resp sendResp = (SendAuth.Resp) resp;
				if (sendResp != null) {
					String code = sendResp.code;
					getAccess_token(code);
				}
				break;
			case BaseResp.ErrCode.ERR_USER_CANCEL:
				//LogUtils.log("ERR_USER_CANCEL");
				//发送取消
				finish();
				break;
			case BaseResp.ErrCode.ERR_AUTH_DENIED:
				//LogUtils.log("ERR_AUTH_DENIED");
				//发送被拒绝
				finish();
				break;
			default:
				//发送返回
				break;
		}

	}

	/**
	 * 获取openid accessToken值用于后期操作
	 * @param code 请求码
	 */
	private void getAccess_token(final String code) {

		if(getLanguage().contains("zh")){
			showLoading("正在登陆...,请稍等");
		}else{
			showLoading("Logining in...,");
		}

		//String url = "http://api.usleju.cn/estate/house/search-options";

		StringBuffer sb = new StringBuffer();

		sb.append("https://api.weixin.qq.com/sns/oauth2/access_token?appid=");
        sb.append(WEIXIN_APP_ID);
		sb.append("&secret=");
		sb.append(APP_SECRET);
		sb.append("&code=").append(code);
		sb.append("&grant_type=authorization_code");

		JSONObject obj = new JSONObject();
		try {
			obj.put("language",this.getLanguage());
		} catch (JSONException e) {
			e.printStackTrace();
		}

		JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.GET, sb.toString(), obj.toString(), new Response.Listener<JSONObject>() {
			@Override
			public void onResponse(JSONObject jsonObject) {
				try {



					String access_token = jsonObject.getString("access_token");
					String openid = jsonObject.getString("openid");


					getUserMesg(access_token,openid);


				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}, new Response.ErrorListener() {
			@Override
			public void onErrorResponse(VolleyError arg0) {
				if(getLanguage().contains("zh")){
					Toast.makeText(WXEntryActivity.this, "登录失败", Toast.LENGTH_SHORT).show();
				}else{
					Toast.makeText(WXEntryActivity.this, "Login in failed", Toast.LENGTH_SHORT).show();
				}
				finish();
			}
		}) {
			@Override
			public Map<String, String> getHeaders() throws AuthFailureError {
				HashMap<String, String> headers = new HashMap<String, String>();
				try {
					// MCrypt mCrypt = new MCrypt();
					// headers.put("accept", "text/json");
					headers.put("app-token",  AppCfg.TOKEN);
					headers.put("language", getLanguage());
				} catch (Exception e) {
					e.printStackTrace();
				}
				return headers;
			}
		};

		jsonObjectRequest.setRetryPolicy(new DefaultRetryPolicy(5 * 1000, 1, 1.0f));

		App.getHttpQueue().add(jsonObjectRequest);
		App.getHttpQueue().start();

	}


	/**
	 * 获取微信的个人信息
	 * @param access_token
	 * @param openid
	 */
	private void getUserMesg(final String access_token, final String openid) {


		StringBuffer sb = new StringBuffer();

		sb.append("https://api.weixin.qq.com/sns/userinfo?access_token=");
		sb.append(access_token);
		sb.append("&openid=");
		sb.append(openid);


		JSONObject obj = new JSONObject();
		try {
			obj.put("language",this.getLanguage());
		} catch (JSONException e) {
			e.printStackTrace();
		}

		JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.GET, sb.toString(), obj.toString(), new Response.Listener<JSONObject>() {
			@Override
			public void onResponse(JSONObject jsonObject) {
				try {



					String nickname = jsonObject.getString("nickname");
					String headimgurl = jsonObject.getString("headimgurl");

					Login(access_token, openid, nickname, headimgurl);




				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}, new Response.ErrorListener() {
			@Override
			public void onErrorResponse(VolleyError arg0) {
				if(getLanguage().contains("zh")){
					Toast.makeText(WXEntryActivity.this, "登录失败", Toast.LENGTH_SHORT).show();
				}else{
					Toast.makeText(WXEntryActivity.this, "Login in failed", Toast.LENGTH_SHORT).show();
				}
				finish();
			}
		}) {
			@Override
			public Map<String, String> getHeaders() throws AuthFailureError {
				HashMap<String, String> headers = new HashMap<String, String>();
				try {
					// MCrypt mCrypt = new MCrypt();
					// headers.put("accept", "text/json");
					headers.put("app-token",  AppCfg.TOKEN);
					headers.put("language", getLanguage());
				} catch (Exception e) {
					e.printStackTrace();
				}
				return headers;
			}
		};

		jsonObjectRequest.setRetryPolicy(new DefaultRetryPolicy(5 * 1000, 1, 1.0f));

		App.getHttpQueue().add(jsonObjectRequest);
		App.getHttpQueue().start();


	}




	private void Login(final String access_token,final  String openid,final String nickname,final String headimgurl) {


		StringBuffer sb = new StringBuffer();

		sb.append("http://api.usleju.cn/passport/account/wechat-login?open_id=");
		sb.append(openid);



		JSONObject obj = new JSONObject();
		try {
			obj.put("language",this.getLanguage());
		} catch (JSONException e) {
			e.printStackTrace();
		}

		JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(Request.Method.GET, sb.toString(), obj.toString(), new Response.Listener<JSONObject>() {
			@Override
			public void onResponse(JSONObject jsonObject) {
				try {



					Integer code =  jsonObject.getInt("code");

					if(code == 200){

					    JSONObject data = jsonObject.getJSONObject("data");

						String access_token = data.getString("access_token");




						WesUser user = new WesUser();
						user.setPhone(nickname);
						user.setPassword(access_token);
						user.setToken(access_token);
						user.setAvatar(headimgurl);
						user.setName(nickname);

						App app = (App) getApplication();
						app.deleteUser();
						app.addUser(user);


						if(getLanguage().contains("zh")){
							Toast.makeText(WXEntryActivity.this, "登录成功", Toast.LENGTH_SHORT).show();
						}else{
							Toast.makeText(WXEntryActivity.this, "Login in successfully", Toast.LENGTH_SHORT).show();
						}



					}else{

						if(getLanguage().contains("zh")){
							Toast.makeText(WXEntryActivity.this, "登录失败", Toast.LENGTH_SHORT).show();
						}else{
							Toast.makeText(WXEntryActivity.this, "Login in failed", Toast.LENGTH_SHORT).show();
						}
					}

					finish();

					App app = (App)getApplication();
					if(app.mFourthFragment !=null)
					app.mFourthFragment.aloadView();


				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}, new Response.ErrorListener() {
			@Override
			public void onErrorResponse(VolleyError arg0) {
				if(getLanguage().contains("zh")){
					Toast.makeText(WXEntryActivity.this, "登录失败", Toast.LENGTH_SHORT).show();
				}else{
					Toast.makeText(WXEntryActivity.this, "Login in failed", Toast.LENGTH_SHORT).show();
				}
				finish();
			}
		}) {
			@Override
			public Map<String, String> getHeaders() throws AuthFailureError {
				HashMap<String, String> headers = new HashMap<String, String>();
				try {
					// MCrypt mCrypt = new MCrypt();
					// headers.put("accept", "text/json");
					headers.put("app-token",  AppCfg.TOKEN);
					headers.put("language", getLanguage());
				} catch (Exception e) {
					e.printStackTrace();
				}
				return headers;
			}
		};

		jsonObjectRequest.setRetryPolicy(new DefaultRetryPolicy(5 * 1000, 1, 1.0f));

		App.getHttpQueue().add(jsonObjectRequest);
		App.getHttpQueue().start();


	}

}