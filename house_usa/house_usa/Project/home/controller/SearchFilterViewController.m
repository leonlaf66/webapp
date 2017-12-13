//
//  SearchFilterViewController.m
//  house_usa
//
//  Created by 林 建军 on 27/07/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "SearchFilterViewController.h"
#import "HomeModel.h"
#import "UPDao+SearchKey.h"
#import "HouseListViewController.h"
#import "FilterLabel.h"

#import "CompleteViewController.h"
#import "UPDao+Key.h"

@interface SearchFilterViewController ()<UIActionSheetDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *pView;
@property (weak, nonatomic) IBOutlet UIButton *selectTypeBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTextInput;
@property (weak, nonatomic) IBOutlet UILabel *hotLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bntWidth;

@property (strong, nonatomic)  NSString *type;

@property (strong, nonatomic)UILabel *mySearchLabel;
@property (weak, nonatomic) IBOutlet UIView *ccView;


@property (strong, nonatomic) CompleteViewController *comTroller;
@property(nonatomic,strong)  UIView *comView;

@end

@implementation SearchFilterViewController

- (IBAction)searchAction:(id)sender {
    
    [_searchTextInput resignFirstResponder];
    _comView.hidden = YES;
    [self goAction];
   
    
}
-(void)goAction{
    if([[_searchTextInput.text trim] length] > 0){
        NSLog(@"the text = %@",_searchTextInput.text);
        
        SearchKey *key = [[SearchKey alloc] init];
        key.cityName = _searchTextInput.text;
        
        [[UPDao sharedInstance] createSearchKeya:key];
        
        
        HouseListViewController *controller = [[HouseListViewController alloc] initWithNibName:@"HouseListViewController" bundle:nil];
        
        controller.searchKey = _searchTextInput.text;
       // controller.key = _searchTextInput.text;
        controller.type = _type;
        [self.navigationController pushViewController:controller animated:YES];
        
    }

}
- (IBAction)didOnExit:(id)sender {
    [_searchTextInput resignFirstResponder];
     [self goAction];
    
}

- (IBAction)selectTypeAction:(id)sender {
    
    if([[self getMyLang] containsString:@"zh"]){
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"类型选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"购房",@"租房", nil ];
        //actionSheet样式
        sheet.actionSheetStyle = UIActionSheetStyleDefault;
        //显示
        [sheet showInView:self.view];
        sheet.delegate = self;
    
    }else{
    
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"Choose type" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Purchase",@"Rental", nil ];
        //actionSheet样式
        sheet.actionSheetStyle = UIActionSheetStyleDefault;
        //显示
        [sheet showInView:self.view];
        sheet.delegate = self;

    }
   
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"点击确定");
        _type = @"purchase";
        
        if([[self getMyLang] containsString:@"zh"]){
             [_selectTypeBtn setTitle:@"买房" forState:UIControlStateNormal];
        }else{
             [_selectTypeBtn setTitle:@"Purchase" forState:UIControlStateNormal];
        }
        
    }else if (buttonIndex == 1) {
        NSLog(@"点击确定");
        _type = @"lease";
        
        if([[self getMyLang] containsString:@"zh"]){
            [_selectTypeBtn setTitle:@"租房" forState:UIControlStateNormal];
        }else{
            [_selectTypeBtn setTitle:@"Rental" forState:UIControlStateNormal];
        }

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _pView.layer.cornerRadius = 3;
    CGFloat spacing = 3.0;

    _type = @"purchase";
     [self loadHotAreaData];
    
    
    if([[self getMyLang] containsString:@"zh"]){
        _hotLabel.text = @"  热门区域";
        [_selectTypeBtn setTitle:@"买房" forState:UIControlStateNormal];
        _bntWidth.constant = 60;
        // 图片右移
        CGSize imageSize = _selectTypeBtn.imageView.frame.size;
        _selectTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width * 2 - spacing, 0.0, 0.0);
        
        // 文字左移
        CGSize titleSize = _selectTypeBtn.titleLabel.frame.size;
        _selectTypeBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - titleSize.width * 2 - spacing);

    }else{
        _hotLabel.text = @"  Hot";
          [_selectTypeBtn setTitle:@"Purchase" forState:UIControlStateNormal];
         _bntWidth.constant = 90;
        // 图片右移
        CGSize imageSize = _selectTypeBtn.imageView.frame.size;
        _selectTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width * 2 - spacing, 0.0, 0.0);
        
        // 文字左移
        CGSize titleSize = _selectTypeBtn.titleLabel.frame.size;
        _selectTypeBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - titleSize.width * 2 - spacing);

    }
    
    
    _comTroller = [[CompleteViewController alloc] initWithNibName:@"CompleteViewController" bundle:nil];
    
    // __block UIView *cview =  self.comView;
    
    
    _comView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 200)];
    _comView.backgroundColor = [UIColor blueColor];
    _comView.hidden = YES;
    
    [_comView layoutIfNeeded];
    
    [_comView addSubview: _comTroller.view];
    _comTroller.view.frame = CGRectMake(0, 0, ScreenWidth, 400);
    
   
    
    _searchTextInput.delegate = self;
    __block SearchFilterViewController * me = self;
    _comTroller.backAction = ^(Key *key){
        me.comView.hidden = YES;
        me.searchTextInput.text = key.cityCode;
        [me.searchTextInput resignFirstResponder];
        
        
        SearchKey *akey = [[SearchKey alloc] init];
        akey.cityName = key.cityCode;
       // akey.cityCode = key.cityCode;
        [[UPDao sharedInstance] createSearchKeya:akey];
        
        
        HouseListViewController *controller = [[HouseListViewController alloc] initWithNibName:@"HouseListViewController" bundle:nil];
        
        controller.searchKey = key.cityCode;
        //controller.key = label.code;
        controller.type = me.type;
        [me.navigationController pushViewController:controller animated:YES];
        
        
    };
    

    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{

    [super  viewWillAppear:animated];
    
    self.lang = [self getMyLocal];
    _searchTextInput.placeholder = self.lang[@"homeSearchPlaceHolder"];
}
-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
   
}

-(void)loadHotAreaData{
    [self showLoading:@""];
    NSDictionary *params = @{};
    [[HomeModel sharedInstance] getHotAreaData:params success:^(id operation) {
        [self hideLoading];
        if([operation[@"code"] integerValue] == 200){
         //   _newsDatas =   operation[@"data"];
            [self initHotDatas:operation[@"data"]];
        }
        
        
    } failure:^(NSError *error) {
         [self hideLoading];
    }];
    
    
}

-(void)initHotDatas:(NSDictionary *)datas{
    
    NSArray *keys =  datas.allKeys;
    
    NSInteger i = 0;
    CGFloat  space = 8;
    CGFloat  width = (ScreenWidth - space * 5) / 4;
    CGFloat  height = 30;
    CGFloat  y = 110;
    for (NSString * key in keys) {
          NSLog(@"--y=%f",y);
        FilterLabel *label = [[FilterLabel alloc] initWithFrame:CGRectMake(i*width+(i+1)*space, y, width, height)];
        label.backgroundColor = [UIColor colorWithString:@"#f2f2f2"];
        label.text = datas[key];
        label.code = key;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        label.textColor  = [UIColor colorWithString:@"#333333"];
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *atap = [[UITapGestureRecognizer alloc] init];
        [atap addTarget:self action:@selector(tapped:)];
        [label addGestureRecognizer:atap];
        
        [self.view addSubview:label];
          i++;
        if (i % 4 == 0) {
            y = y + height + 12;
            i = 0;
        }
      
    }
    
    _mySearchLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y+30+12, ScreenWidth, 30)];
    _mySearchLabel.backgroundColor = [UIColor colorWithString:@"#f2f2f2"];
   
    
    if([[self getMyLang] containsString:@"zh"]){
       _mySearchLabel.text = @"  历史搜索记录";
    }else{
      _mySearchLabel.text = @"  History";
        
    }
    _mySearchLabel.textAlignment = NSTextAlignmentLeft;
    _mySearchLabel.font = [UIFont systemFontOfSize:14];
    _mySearchLabel.textColor  = [UIColor colorWithString:@"#333333"];
    
    [self.view addSubview:_mySearchLabel];
    
    NSMutableArray *mykeys = [[UPDao sharedInstance] getSearchKeys] ;
    
    
    if([mykeys count] > 0){
    
        NSInteger j = 0;
        CGFloat  myY  =  y+30+12+ 30+12;
        for (SearchKey *key in mykeys) {
            NSLog(@"-the key = %@",key.cityName);
            
            FilterLabel *myitemLabel = [[FilterLabel alloc] initWithFrame:CGRectMake(12,myY+(j+1)*5+j*height, ScreenWidth, 30)];
            
            myitemLabel.text = key.cityName;
            myitemLabel.code = key.cityCode;
            myitemLabel.textAlignment = NSTextAlignmentLeft;
            myitemLabel.font = [UIFont systemFontOfSize:10];
            myitemLabel.textColor  = [UIColor colorWithString:@"#333333"];
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12,myitemLabel.frame.origin.y+30, ScreenWidth -12, 1)];
            lineView.backgroundColor = [UIColor colorWithString:@"#f2f2f2"];
            myitemLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *atap = [[UITapGestureRecognizer alloc] init];
            [atap addTarget:self action:@selector(tapped:)];
            [myitemLabel addGestureRecognizer:atap];
            [self.view addSubview:myitemLabel];
            [self.view addSubview:lineView];
            j++;
        }
    
    }else{
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 120) / 2,_mySearchLabel.frame.origin.y+30+12, 120, 120)];
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.image = [UIImage imageNamed:@"no_data_img"];
        
        [self.view addSubview:img];
    
        UILabel *myitemLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,img.frame.origin.y+120, ScreenWidth, 30)];
        if([[self getMyLang] containsString:@"zh"]){
         myitemLabel.text = @"暂无历史搜索记录";
        }else{
         myitemLabel.text = @"No records";
        
        }
        
       
        myitemLabel.textAlignment = NSTextAlignmentCenter;
        myitemLabel.font = [UIFont systemFontOfSize:14];
        myitemLabel.textColor  = [UIColor colorWithString:@"#333333"];
        [self.view addSubview:myitemLabel];
    }
    
     [self.view addSubview:_comView];
   
}

- (void)tapped:(UITapGestureRecognizer *)t {
   
    FilterLabel *label  = (FilterLabel *)t.view;

    NSLog(@"the text = %@",label.text);
    
    SearchKey *key = [[SearchKey alloc] init];
    key.cityName = label.text;
    key.cityCode = label.code;
    [[UPDao sharedInstance] createSearchKeya:key];
    
    
    HouseListViewController *controller = [[HouseListViewController alloc] initWithNibName:@"HouseListViewController" bundle:nil];
    
    controller.searchKey = label.text;
    controller.key = label.code;
      controller.type = _type;
    [self.navigationController pushViewController:controller animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *frustr = [self.searchTextInput.text changeCharactersInRange:range replacementString:string];
    
    if([frustr length] > 0){
        _comView.hidden = NO;
        NSArray *citys =   [[UPDao sharedInstance] getSearchKeys:frustr];
        [_comTroller reloadDatas:citys];
        _comView.hidden = NO;
        
    }else{
        _comView.hidden = YES;
    }
    return true;
}

@end
