

#import "LXActivity.h"
#import "HomeModel.h"

#define WINDOW_COLOR                            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]
#define ACTIONSHEET_BACKGROUNDCOLOR             [UIColor colorWithRed:106/255.00f green:106/255.00f blue:106/255.00f alpha:0.8]
#define ANIMATE_DURATION                        0.25f

#define CORNER_RADIUS                           5
#define SHAREBUTTON_BORDER_WIDTH                0.5f
#define SHAREBUTTON_BORDER_COLOR                [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8].CGColor
#define SHAREBUTTONTITLE_FONT                   [UIFont fontWithName:@"HelveticaNeue-Bold" size:18]

#define CANCEL_BUTTON_COLOR                     [UIColor colorWithRed:53/255.00f green:53/255.00f blue:53/255.00f alpha:1]

#define SHAREBUTTON_WIDTH                       50
#define SHAREBUTTON_HEIGHT                      50
#define SHAREBUTTON_INTERVAL_WIDTH              42.5
#define SHAREBUTTON_INTERVAL_HEIGHT             35

#define SHARETITLE_WIDTH                        50
#define SHARETITLE_HEIGHT                       20
#define SHARETITLE_INTERVAL_WIDTH               42.5
#define SHARETITLE_INTERVAL_HEIGHT              SHAREBUTTON_WIDTH+SHAREBUTTON_INTERVAL_HEIGHT
#define SHARETITLE_FONT                         [UIFont fontWithName:@"Helvetica-Bold" size:14]

#define TITLE_INTERVAL_HEIGHT                   15
#define TITLE_HEIGHT                            35
#define TITLE_INTERVAL_WIDTH                    30
#define TITLE_WIDTH                             260
#define TITLE_FONT                              [UIFont fontWithName:@"Helvetica-Bold" size:10]
#define SHADOW_OFFSET                           CGSizeMake(0, 0.8f)
#define TITLE_NUMBER_LINES                      2

#define BUTTON_INTERVAL_HEIGHT                  20
#define BUTTON_HEIGHT                           40
#define BUTTON_INTERVAL_WIDTH                   40
#define BUTTON_WIDTH                            240
#define BUTTONTITLE_FONT                        [UIFont fontWithName:@"HelveticaNeue-Bold" size:18]
#define BUTTON_BORDER_WIDTH                     0.5f
#define BUTTON_BORDER_COLOR                     [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8].CGColor


@interface UIImage (custom)

+ (UIImage *)imageWithColor:(UIColor *)color;

@end


@implementation UIImage (custom)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end

@interface LXActivity (){
    Success _successBlock;
    Fail _failBlock;
}

@property(nonatomic) CGFloat iconWidth;
@property(nonatomic,strong) NSDictionary *data;
@property(nonatomic,strong) UIView *pview;
@property(nonatomic,strong) UIButton *weiXin;
@property(nonatomic,strong) UIButton *pybutton;
@property(nonatomic,strong) UIButton *qq;
@property(nonatomic,strong) UIButton *qqspace;
@property(nonatomic,strong) UIButton *xlbutton;

@property (nonatomic,strong) NSString *actionTitle;
@property (nonatomic,assign) NSInteger postionIndexNumber;
@property (nonatomic,assign) BOOL isHadTitle;
@property (nonatomic,assign) BOOL isHadShareButton;
@property (nonatomic,assign) BOOL isHadCancelButton;
@property (nonatomic,assign) CGFloat LXActivityHeight;
@property (nonatomic,assign) id<LXActivityDelegate>delegate;

@end

@implementation LXActivity
@synthesize backGroundView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Public method

- (id)initWithTitle:(NSString *)title delegate:(id<LXActivityDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle ShareButtonTitles:(NSArray *)shareButtonTitlesArray withShareButtonImagesName:(NSArray *)shareButtonImagesNameArray;
{
    self = [super init];
    if (self) {
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = ACTIONSHEET_BACKGROUNDCOLOR;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        if (delegate) {
            self.delegate = delegate;
        }
        
        [self creatButtonsWithTitle:title cancelButtonTitle:cancelButtonTitle shareButtonTitles:shareButtonTitlesArray withShareButtonImagesName:shareButtonImagesNameArray];
        
    }
    return self;
}

- (void)showInView:(UIView *)view
{
   // [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
    [view addSubview:self];
}

#pragma mark - Praviate method

- (void)creatButtonsWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle shareButtonTitles:(NSArray *)shareButtonTitlesArray withShareButtonImagesName:(NSArray *)shareButtonImagesNameArray
{
    //初始化
    self.isHadTitle = NO;
    self.isHadShareButton = NO;
    self.isHadCancelButton = NO;
    
    //初始化LXACtionView的高度为0
    self.LXActivityHeight = 130;
    
    //初始化IndexNumber为0;
    self.postionIndexNumber = 0;
    
    //生成LXActionSheetView
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
    self.backGroundView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    //给LXActionSheetView添加响应事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackGroundView)];
    [self.backGroundView addGestureRecognizer:tapGesture];
    
    [self addSubview:self.backGroundView];
    
    
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-self.LXActivityHeight, [UIScreen mainScreen].bounds.size.width, self.LXActivityHeight)];
    } completion:^(BOOL finished) {
    }];
}

- (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
- (UIButton *)creatCancelButtonWith:(NSString *)cancelButtonTitle
{
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_INTERVAL_WIDTH, BUTTON_INTERVAL_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT)];
    cancelButton.layer.masksToBounds = YES;
    cancelButton.layer.cornerRadius = CORNER_RADIUS;
    
    cancelButton.layer.borderWidth = BUTTON_BORDER_WIDTH;
    cancelButton.layer.borderColor = BUTTON_BORDER_COLOR;

    UIImage *image = [UIImage imageWithColor:CANCEL_BUTTON_COLOR];
    [cancelButton setBackgroundImage:image forState:UIControlStateNormal];

    [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    cancelButton.titleLabel.font = BUTTONTITLE_FONT;
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    return cancelButton;
}

- (UIButton *)creatShareButtonWithColumn:(int)column andLine:(int)line
{
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(SHAREBUTTON_INTERVAL_WIDTH+((line-1)*(SHAREBUTTON_INTERVAL_WIDTH+SHAREBUTTON_WIDTH)), SHAREBUTTON_INTERVAL_HEIGHT+((column-1)*(SHAREBUTTON_INTERVAL_HEIGHT+SHAREBUTTON_HEIGHT)), SHAREBUTTON_WIDTH, SHAREBUTTON_HEIGHT)];
    return shareButton;
}

- (UILabel *)creatShareLabelWithColumn:(int)column andLine:(int)line
{
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(SHARETITLE_INTERVAL_WIDTH+((line-1)*(SHARETITLE_INTERVAL_WIDTH+SHARETITLE_WIDTH)), SHARETITLE_INTERVAL_HEIGHT+((column-1)*(SHARETITLE_INTERVAL_HEIGHT)), SHARETITLE_WIDTH, SHARETITLE_HEIGHT)];
    
    shareLabel.backgroundColor = [UIColor clearColor];
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.font = TITLE_FONT;
    shareLabel.textColor = [UIColor whiteColor];
    return shareLabel;
}

- (UILabel *)creatTitleLabelWith:(NSString *)title
{
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_INTERVAL_WIDTH, TITLE_INTERVAL_HEIGHT, TITLE_WIDTH, TITLE_HEIGHT)];
    titlelabel.backgroundColor = [UIColor lightGrayColor];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.shadowColor = [UIColor blackColor];
    titlelabel.shadowOffset = SHADOW_OFFSET;
    titlelabel.font = SHARETITLE_FONT;
    titlelabel.text = title;
    titlelabel.textColor = [UIColor whiteColor];
    titlelabel.numberOfLines = TITLE_NUMBER_LINES;
    return titlelabel;
}

- (void)didClickOnImageIndex:(UIButton *)button
{
    if (self.delegate) {
        if (button.tag != self.postionIndexNumber-1) {
            if ([self.delegate respondsToSelector:@selector(didClickOnImageIndex:)] == YES) {
                [self.delegate didClickOnImageIndex:(NSInteger *)button.tag];
            }
        }
        else{
            if ([self.delegate respondsToSelector:@selector(didClickOnCancelButton)] == YES){
                [self.delegate didClickOnCancelButton];
            }
        }
    }
    [self tappedCancel];
}

- (void)tappedCancel
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)tappedBackGroundView
{
    //
    
}


-(void)createFrame{
    
    CGFloat marginWidth = (ScreenWidth-(_iconWidth * 5 + 4 * 5)) / 2;
    
   
    

    
    _pybutton = [[UIButton alloc] initWithFrame:CGRectMake(marginWidth,5, _iconWidth, _iconWidth)];
    _pybutton.tag = 901;
    [_pybutton setImage:[UIImage imageNamed:@"facebook"] forState:UIControlStateNormal];
    
    [_pybutton addTarget:self action:@selector(weiXinAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundView addSubview:_pybutton];
    
    
    
    
    
    _qq = [[UIButton alloc] initWithFrame:CGRectMake(_pybutton.frame.origin.x+self.iconWidth+5,5, _iconWidth, _iconWidth)];
    _qq.tag = 902;
    [_qq setImage:[UIImage imageNamed:@"wx"] forState:UIControlStateNormal];
    
    [_qq addTarget:self action:@selector(weiXinAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundView addSubview:_qq];
    
    
    
    
    
    _qqspace = [[UIButton alloc] initWithFrame:CGRectMake(_qq.frame.origin.x + _iconWidth+5,5, _iconWidth, _iconWidth)];
    _qqspace.tag = 903;
    [_qqspace setImage:[UIImage imageNamed:@"py"] forState:UIControlStateNormal];
    
    [_qqspace addTarget:self action:@selector(weiXinAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundView addSubview:_qqspace];
    
    
    
    _xlbutton = [[UIButton alloc] initWithFrame:CGRectMake(_qqspace.frame.origin.x+self.iconWidth+5,5, _iconWidth, _iconWidth)];
    _xlbutton.tag = 904;
    [_xlbutton setImage:[UIImage imageNamed:@"xl"] forState:UIControlStateNormal];
    
    [_xlbutton addTarget:self action:@selector(weiXinAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundView addSubview:_xlbutton];
    
    
    
    
    _weiXin = [UIButton buttonWithType:UIButtonTypeCustom];
    _weiXin.frame = CGRectMake(_xlbutton.frame.origin.x+self.iconWidth+5,5, _iconWidth, _iconWidth);
    _weiXin.tag = 900;
    _weiXin.userInteractionEnabled = YES;
    [_weiXin setImage:[UIImage imageNamed:@"tw"] forState:UIControlStateNormal];
    
    
   [self.backGroundView addSubview:_weiXin];
    [_weiXin addTarget:self action:@selector(weiXinAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton  *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame =  CGRectMake(10, 80, self.frame.size.width - 20, 40);
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    cancel.userInteractionEnabled = YES;
   
    [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIColor *color = ColorWithString(@"#cccccc");
    cancel.layer.borderColor =  [color CGColor];
    cancel.layer.borderWidth = 1;
    cancel.layer.cornerRadius = 5;
    [cancel addTarget:self action:@selector(cancelShare) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundView addSubview:cancel];
    
    
}

-(void)cancelShare{
    [self tappedCancel];
}

-(void)weiXinAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    SSDKPlatformType type = SSDKPlatformSubTypeWechatTimeline;
    switch (tag) {
        case 900:
            type = SSDKPlatformSubTypeWechatTimeline;
            break;
        case 901:
            type = SSDKPlatformTypeFacebook;
              break;
        case 902:
            type = SSDKPlatformTypeWechat;
              break;
        case 903:
            type = SSDKPlatformSubTypeWechatTimeline;
              break;
        case 904:
            type = SSDKPlatformTypeSinaWeibo;
              break;
        default:
            type = SSDKPlatformSubTypeWechatTimeline;
    }
    [self tappedCancel];
    //http://app.wesnail.com/detail.html?type=buySell&id=72028990list_price
    
  
    
    if(_data[@"atype"] && [_data[@"atype"] isEqualToString:@"artical"]){
        NSString *title = [NSString stringWithFormat:@"%@",_data[@"title"]];//[_data objectForKey:@"title"];
        
       // NSArray *images = [_data objectForKey:@"images"];
        
        //http://47.93.188.234:8081/usleju/home.html?language=zh-CN1&id=72200884
        
        NSString *lang = @"en-US";
        
        if([[self getMyLang] containsString:@"zh"]){
            lang = @"zh-CN";
        }else{
            lang = @"en-US";
        }
        
      //  NSString *area_id = [HomeModel sharedInstance].area;
        
        NSString *url = [NSString stringWithFormat:@"http://webapp.usleju.cn/ca/news/%@", _data[@"id"]];
        
        NSString *imgUrl = _data[@"image"];//;//[_data objectForKey:@"imgUrl"];
        
        
        NSData *nsd = [[NSData alloc]initWithContentsOfURL:[[NSURL alloc] initWithString:imgUrl]];
        UIImage *imga =  [UIImage imageWithData:nsd];
        
         NSData *nsdnew  =  UIImageJPEGRepresentation(imga,0.1);
        
         UIImage *img =  [UIImage imageWithData:nsdnew];
        
        
        NSMutableDictionary * shareParames = [[NSMutableDictionary alloc]init];
        if (type == SSDKPlatformTypeSinaWeibo) {
            [shareParames SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@ %@",_data[@"title"],url] images:img url:[[NSURL alloc] initWithString:url] title:title type:SSDKContentTypeAuto];
            
            [ShareSDK showShareEditor:SSDKPlatformTypeSinaWeibo otherPlatformTypes:nil shareParams:shareParames onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                switch (state) {
                    case SSDKResponseStateSuccess:
                        _successBlock();
                        break;
                    case SSDKResponseStateFail:
                        _failBlock(error);
                        break;
                    case SSDKResponseStateCancel:
                        _failBlock(error);
                        break;
                        
                    default:
                        break;
                }
            }];
            
        }else{
            
            [shareParames SSDKSetupShareParamsByText:_data[@"location"] images:img url:[[NSURL alloc] initWithString:url] title:title type:SSDKContentTypeAuto];
            
            [ShareSDK share:type parameters:shareParames onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                
                switch (state) {
                    case SSDKResponseStateSuccess:
                        _successBlock();
                        break;
                    case SSDKResponseStateFail:
                        _failBlock(error);
                        break;
                    case SSDKResponseStateCancel:
                        _failBlock(error);
                        break;
                        
                    default:
                        break;
                }
            }];
            
        }
    
    
    }else{
    
        NSString *title = [NSString stringWithFormat:@"%@(%@)",_data[@"name"],_data[@"list_price"]];//[_data objectForKey:@"title"];
        
        NSArray *images = [_data objectForKey:@"small_images"];
        
       
        
        NSString *lang = @"en-US";
        
        if([[self getMyLang] containsString:@"zh"]){
            lang = @"zh-CN";
        }else{
            lang = @"en-US";
        }
        
         NSString *area_id = [HomeModel sharedInstance].area;
        
        
        NSString *url = [NSString stringWithFormat:@"http://webapp.usleju.cn/%@/house/%@",area_id, _data[@"id"]];
        
        NSString *imgUrl = images[0];//;//[_data objectForKey:@"imgUrl"];
        
        
       imgUrl= [NSString stringWithFormat:@"http://media.mlspin.com/Photo.aspx?mls=%@&n=0&w=80&h=60",_data[@"id"]];
        
        
        NSData *nsd = [[NSData alloc]initWithContentsOfURL:[[NSURL alloc] initWithString:imgUrl]];
        UIImage *img =  [UIImage imageWithData:nsd];
        
       
       
        
        NSMutableDictionary * shareParames = [[NSMutableDictionary alloc]init];
        if (type == SSDKPlatformTypeSinaWeibo) {
            [shareParames SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@ %@",_data[@"location"],url] images:img url:[[NSURL alloc] initWithString:url] title:title type:SSDKContentTypeAuto];
            
            [ShareSDK showShareEditor:SSDKPlatformTypeSinaWeibo otherPlatformTypes:nil shareParams:shareParames onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                switch (state) {
                    case SSDKResponseStateSuccess:
                        _successBlock();
                        break;
                    case SSDKResponseStateFail:
                        _failBlock(error);
                        break;
                    case SSDKResponseStateCancel:
                        _failBlock(error);
                        break;
                        
                    default:
                        break;
                }
            }];
            
        }else{
            
            [shareParames SSDKSetupShareParamsByText:_data[@"location"] images:img url:[[NSURL alloc] initWithString:url] title:title type:SSDKContentTypeAuto];
            
            [ShareSDK share:type parameters:shareParames onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                
                switch (state) {
                    case SSDKResponseStateSuccess:
                        _successBlock();
                        break;
                    case SSDKResponseStateFail:
                        _failBlock(error);
                        break;
                    case SSDKResponseStateCancel:
                        _failBlock(error);
                        break;
                        
                    default:
                        break;
                }
            }];
            
        }
    
    }
    
    
   
}


-(void)share:(NSDictionary *)data inView:(UIView *) view success:(void (^)(void))success failure:(void (^)(NSError *error))failure{
    _data = data;
    _successBlock = success;
    _failBlock = failure;
    [self initIconWidth];
    [self createFrame];
    _pview = view;
    
    [self showInView:_pview];
    
    
}
-(void)initIconWidth{
    if(ScreenWidth == 320){
        _iconWidth = 58;
    }else if(ScreenWidth == 375){
        _iconWidth = 65;
    }else {
        _iconWidth = 75;
    }
    
    
}



@end
