//
//  Config.h
//  house_usa
//
//  Created by 林 建军 on 26/05/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#ifndef Config_h
#define Config_h

#define PLANTFORM                   0

#if (PLANTFORM==0)//开发平台
#define SEVERADDR               @"http://172.104.15.126"                                 //开发平台（内网）

#elif (PLANTFORM==1)//测试平台
#define SEVERADDR               @"http://192.168.6.19"                                  //测试平台（内网）


#elif (PLANTFORM==2)//正式平台
#define SEVERADDR               @"http://interfaces.cdzlxt.com"                         //正式平台（http:
#endif


//百度地图key
#define BMKEY               @"GMONPlVHdfi8OPEiD2WQF1bZt02sFRf8"

#endif 
/* Config_h */

#define APPTOKEN          @"b2e476cb5ddcbf81c337218d5b5d43fa83bd6a8d4c9b7ba4ea047c70d22a828c"

#define LC_URL              "https://cdn.livechatinc.com/app/mobile/urls.json"
#define LC_LICENSE          "7739171"
#define LC_CHAT_GROUP       "0"


//新浪微博分享
#define kWeiboAppKey                 @"842669912"
#define kWeiboAppSecret              @"34630ad56278d8ec890324181d0169c2"
#define kWeiboredirectUri            @"http://www.usleju.com"
//微信分享wxca09ddff0b293126
#define kWXAppKey                    @"wxca09ddff0b293126"
#define kWXAppSecret                 @"44b6833a0b635628a312d29bfccf2162"
//QQ微博
#define kTencentWeiboAppKey          @"801307650"
#define kTencentWeiboAppSecret       @"94f6a2f22f641173f5f6bdb7a23b2dde"
#define kTencentWeibodirectUri       @"https://itunes.apple.com/cn/app/hui-sheng-hui-guan-jia-ping-tai/id921900795?mt=8"

//QQ分享
#define kQQAppKey                    @"1105069124"
#define kQQAppSecret                 @"BLtyhKMiQjcwfxk1"
