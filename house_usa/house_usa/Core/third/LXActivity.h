

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

#import "LXActivity.h"


typedef void (^ Success)(void);
typedef void (^ Fail)(NSError *error);

typedef enum {
    /**
     *  QQ
     */
    QQ,
    /**
     *  QQ空间
     */
    QQZONE,
    /**
     *  微信
     */
    WX,
    /**
     *  微信说说
     */
    WXZONE,
    /**
     *  新浪微博
     */
    XINSA
} ShareType;

@protocol LXActivityDelegate <NSObject>

@optional
- (void)didClickOnCancelButton;
- (void)didClickOnImageIndex:(NSInteger *)imageIndex;
@end

@interface LXActivity : UIView
@property (nonatomic,strong) UIView *backGroundView;

- (id)initWithTitle:(NSString *)title delegate:(id<LXActivityDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle ShareButtonTitles:(NSArray *)shareButtonTitlesArray withShareButtonImagesName:(NSArray *)shareButtonImagesNameArray;
- (void)showInView:(UIView *)view;
- (void)tappedCancel;
-(void)share:(NSDictionary *)data  inView:(UIView *) view success:(void (^)(void))success failure:(void (^)(NSError *error))failure;
@end
