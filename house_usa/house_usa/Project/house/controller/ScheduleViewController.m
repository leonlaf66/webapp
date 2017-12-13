//
//  ScheduleViewController.m
//  house_usa
//
//  Created by 林 建军 on 01/09/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "ScheduleViewController.h"
#import "HomeModel.h"
@interface ScheduleViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>{

    NSInteger type ;
    NSArray *_yearDatas;
     NSArray *_monthDatas;
     NSArray *_daysDatas;
    
      NSArray *_hoursDatas;
    
      NSArray *_minsDatas;
}
@property (weak, nonatomic) IBOutlet UIButton *scheduleBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;


@property(nonatomic,strong)  UIView *dateView;

@property(nonatomic,strong)  UIView *bgView;
@property(nonatomic,strong)  UIPickerView *pickView;

@property(nonatomic,strong)  UIButton *subwaySureBtn;
@property(nonatomic,strong)  UIButton *subwayCancelBtn;

@end

@implementation ScheduleViewController

#pragma mark UIPickerViewDataSource 数据源方法
// 返回多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if(type == 1){
      return 3;
    }else{
      return 2;
    }
   
    
    
}

// 返回多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if(type == 1){
        if(component == 0){
            return [_yearDatas count];
        }else  if(component == 1){
            return [_monthDatas count];
        }else{
            return [_daysDatas count];
            
        }
        
    }else{
        if(component == 0){
            return [_hoursDatas count];
        }else{
            return [_minsDatas count];
            
        }
        
    }
    
    
   
    
}

#pragma mark UIPickerViewDelegate 代理方法

// 返回每行的标题
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if(type == 1){
        if(component == 0){
            NSNumber *obj = [_yearDatas objectAtIndex:row];
            return [obj stringValue];
        }else  if(component == 1){
            NSString *obj = [_monthDatas objectAtIndex:row];
            return obj;
        }else {
            NSString *obj = [_daysDatas objectAtIndex:row];
            return obj;
        }

    }else{
        if(component == 0){
            NSString *obj = [_hoursDatas objectAtIndex:row];
            return obj;
        }else {
            NSString *obj = [_minsDatas objectAtIndex:row];
            return obj;
        }

    }
    
    
    
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    // 这里用label来展示要显示的文字, 然后可以用label的textAlignment来设置文字的对齐模式
    UILabel *myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth/2  , 35)];
    myView.font = [UIFont systemFontOfSize:14];
    myView.backgroundColor = [UIColor whiteColor];
    myView.textAlignment = NSTextAlignmentCenter;
    
    if(type == 1){
        if(component == 0){
            NSNumber *obj = [_yearDatas objectAtIndex:row];
            myView.text =  [obj stringValue];
        }else  if(component == 1){
            NSString *obj = [_monthDatas objectAtIndex:row];
            myView.text =  obj;
        }else {
            NSString *obj = [_daysDatas objectAtIndex:row];
            myView.text =  obj;
        }

    }else{
        if(component == 0){
            NSString *obj = [_hoursDatas objectAtIndex:row];
            myView.text =  obj ;
        }else {
            NSString *obj = [_minsDatas objectAtIndex:row];
            myView.text =  obj;
        }
    }
    
    
    
    return myView;
}


// 选中行显示在label上
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate *date = [NSDate date];//这个是NSDate类型的日期，所要获取的年月日都放在这里；
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|
    NSDayCalendarUnit;//这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；
    
    NSDateComponents *d = [cal components:unitFlags fromDate:date];//把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；
    //然后就可以从d中获取具体的年月日了；
    NSInteger year = [d year];
    NSInteger month = [d month];
    NSInteger day  =  [d day];
    _yearDatas = @[@(year),@(year+1)];
    _monthDatas = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
    
      _daysDatas = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",
                     @"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"12",@"22",@"23",@"24"
                     ,@"25",@"26",@"27",@"28",@"29",@"30",@"31"];
    
    
    _hoursDatas = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",
                   @"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"12",@"22",@"23"];
    
    
    _minsDatas = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",
                   @"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"12",@"22",@"23",@"24"
                   ,@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37"
                   ,@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50"
                   ,@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
    
    _scheduleBtn.layer.cornerRadius= 3;
    
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHight -20)];
    
    _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    _bgView.hidden = YES;
       
    [self.view addSubview:_bgView];

    
    
    _dateView = [[UIView alloc]initWithFrame: CGRectMake(0, ScreenHight, ScreenWidth, 200)];
    _dateView.backgroundColor = [UIColor whiteColor];
    
    _pickView =  [[UIPickerView alloc]initWithFrame: CGRectMake(0,44, ScreenWidth, 156)];
    
    _pickView.showsSelectionIndicator = YES;
    //在iOS 7之后可以自定义选择器视图的背景颜色改变其backgroundColor
    
    _pickView.backgroundColor = [UIColor whiteColor];
    _pickView.delegate = self;
    //设置pickVIew的透明度
    
    _pickView.alpha = 1;
    
    
    
   
    [self.view insertSubview:_dateView aboveSubview:_bgView];
    
    
    _subwaySureBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 50, 5, 44, 30)];
    _subwayCancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 5, 44, 30)];
    
    
    _subwaySureBtn.backgroundColor = [UIColor whiteColor];
    _subwaySureBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    _subwayCancelBtn.backgroundColor = [UIColor whiteColor];
    _subwayCancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [_subwayCancelBtn  setTitleColor:[UIColor colorWithString:@"#333333"] forState:UIControlStateNormal];
    
    [_subwaySureBtn  setTitleColor:GlobalTintColor forState:UIControlStateNormal];
    
    
    
    [_subwayCancelBtn addTarget:self action:@selector(hideSubway) forControlEvents:UIControlEventTouchUpInside];
    
    [_subwaySureBtn addTarget:self action:@selector(surreSubway) forControlEvents:UIControlEventTouchUpInside];
    //_dateView.backgroundColor = [UIColor redColor];
    
     [_dateView addSubview:_pickView];
    [_dateView insertSubview:_subwaySureBtn aboveSubview:_pickView];
     [_dateView insertSubview:_subwayCancelBtn aboveSubview:_pickView];
   
   
    // Do any additional setup after loading the view from its nib.
}
-(void)surreSubway{
    [UIView animateWithDuration:0.5 animations:^{
        _dateView.frame = CGRectMake(0, ScreenHight, ScreenWidth, 200);
    }];
    _bgView.hidden = YES;
    _dateView.hidden = YES;
    
    if(type == 1){
        NSInteger row =[_pickView selectedRowInComponent:0];
        
        NSNumber *year = [_yearDatas objectAtIndex:row];
        
        NSInteger mrow =[_pickView selectedRowInComponent:1];
        
        NSString *moth = [_monthDatas objectAtIndex:mrow];
        
        
        NSInteger drow =[_pickView selectedRowInComponent:2];
        
        NSString *day = [_daysDatas objectAtIndex:drow];
        
        _dateLabel.text =   [NSString stringWithFormat:@"%@-%@-%@",year,moth,day ];
        
    }else  if(type == 2){
        
        
        
        NSInteger mrow =[_pickView selectedRowInComponent:0];
        
        NSString *hour = [_hoursDatas objectAtIndex:mrow];
        
        
        NSInteger mmrow =[_pickView selectedRowInComponent:1];
        
        NSString *min = [_minsDatas objectAtIndex:mmrow];
        
        _startTimeLabel.text =   [NSString stringWithFormat:@"%@:%@",hour,min ];
        
    }else  if(type == 3){
        
        
        
        NSInteger mrow =[_pickView selectedRowInComponent:0];
        
        NSString *hour = [_hoursDatas objectAtIndex:mrow];
        
        
        NSInteger mmrow =[_pickView selectedRowInComponent:1];
        
        NSString *min = [_minsDatas objectAtIndex:mmrow];
        
        _endTimeLabel.text =   [NSString stringWithFormat:@"%@:%@",hour,min ];
        
    }


}

-(void)hideSubway{
    [UIView animateWithDuration:0.5 animations:^{
        _dateView.frame = CGRectMake(0, ScreenHight, ScreenWidth, 200);
    }];
    _bgView.hidden = YES;
    _dateView.hidden = YES;
    

}

-(void)showSubway{
    _dateView.hidden = NO;
    _bgView.hidden = NO;
    [_pickView reloadAllComponents];
    
    [UIView animateWithDuration:0.5 animations:^{
        _dateView.frame = CGRectMake(0, ScreenHight - 200, ScreenWidth, 200);
    }];
    
}

- (IBAction)selectDate:(id)sender {
    type = 1;
    _dateView.hidden = NO;
    _bgView.hidden = NO;
    [_pickView reloadAllComponents];
    
    if(type == 1){
        
        NSDate *date = [NSDate date];//这个是NSDate类型的日期，所要获取的年月日都放在这里；
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        unsigned int unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|
        NSDayCalendarUnit;//这句是说你要获取日期的元素有哪些。获取年就要写NSYearCalendarUnit，获取小时就要写NSHourCalendarUnit，中间用|隔开；
        
        NSDateComponents *d = [cal components:unitFlags fromDate:date];//把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的
        NSInteger year = [d year];
        NSInteger month = [d month];
        NSInteger day  =  [d day];
        
         [_pickView selectRow:month-1 inComponent:1 animated:YES];
         [_pickView selectRow:day - 1 inComponent:2 animated:YES];
    }
    

    
    [UIView animateWithDuration:0.5 animations:^{
        _dateView.frame = CGRectMake(0, ScreenHight - 200, ScreenWidth, 200);
    }];
}

- (IBAction)selectSarTime:(id)sender {
      type = 2;
    
    _dateView.hidden = NO;
    _bgView.hidden = NO;
    [_pickView reloadAllComponents];
    
    if(type == 2){
        
     
       
        
        [_pickView selectRow: [_hoursDatas count] /2 inComponent:0 animated:YES];
        [_pickView selectRow: [_minsDatas count] /2 inComponent:1 animated:YES];
       
    }
    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        _dateView.frame = CGRectMake(0, ScreenHight - 200, ScreenWidth, 200);
    }];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)selectEndTime:(id)sender {
      type = 3;
    
    _dateView.hidden = NO;
    _bgView.hidden = NO;
    [_pickView reloadAllComponents];
    
    if(type == 3){
        
       
        
        [_pickView selectRow: [_hoursDatas count] /2 inComponent:0 animated:YES];
        [_pickView selectRow: [_minsDatas count] /2 inComponent:1 animated:YES];
        
    }
    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        _dateView.frame = CGRectMake(0, ScreenHight - 200, ScreenWidth, 200);
    }];

}

- (IBAction)scheduleAction:(id)sender {
    
    if([[self getMyLang] containsString:@"zh"]){
        if([_dateLabel.text containsString:@"日期"]){
            [self showMsg:@"请选择日期"];
            return;
        }else  if([_startTimeLabel.text containsString:@"时间"]){
            [self showMsg:@"请选择开始时间"];
            return;
        }else  if([_startTimeLabel.text containsString:@"时间"]){
            [self showMsg:@"请选择结束时间"];
            return;
        }
    
    }else{
        if([_dateLabel.text containsString:@"date"]){
            [self showMsg:@"Please choose the date"];
            return;
        }else  if([_startTimeLabel.text containsString:@"from"]){
            [self showMsg:@"Please choose the start time"];
            return;
        }else  if([_startTimeLabel.text containsString:@"to"]){
            [self showMsg:@"Please choose the end time"];
            return;
        }
    
    }
    
   
    
    
    [self showLoading:@""];
    
    NSDictionary *params = @{@"id":_data[@"id"],@"day":_dateLabel.text,
                             @"time_start":_startTimeLabel.text,
                             @"time_end":_endTimeLabel.text};
    [[HomeModel sharedInstance] addSchedule:params success:^(NSDictionary *operation) {
        [self hideLoading];
        
        if([operation[@"code"] integerValue] == 200){
            if([[self getMyLang] containsString:@"zh"]){
                  [self showMsg:@"添加成功"];
                
            }else{
                  [self showMsg:@"Add successfully"];
                
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
         [self hideLoading];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
  

    
    if([[self getMyLang] containsString:@"zh"]){
        self.ctitleLabel.text = @"预约";
        [_subwaySureBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_subwayCancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _dateLabel.text = @"日期选择";
          _startTimeLabel.text = @"开始时间";
          _endTimeLabel.text = @"结束时间";
    }else{
        self.ctitleLabel.text = @"Schedule";
        [_subwaySureBtn setTitle:@"OK" forState:UIControlStateNormal];
        [_subwayCancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        
        _dateLabel.text = @"Select date";
        _startTimeLabel.text = @"You're available from";
        _endTimeLabel.text = @"You're available to";
    
    }
}
-(void)setData:(NSDictionary *)data{
    _data = data;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
