//
//  CalcutorViewController.m
//  house_usa
//
//  Created by 林 建军 on 08/08/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "CalcutorViewController.h"
#import "XYPieChartView.h"
#import "XYCommon.h"
@interface CalcutorViewController ()<PieChartDelegate>

@property (nonatomic, strong)XYPieChartView *pieChartView;

/**
 * 数据
 */
@property (nonatomic, strong)NSMutableArray *pieChartArray;

/**
 * 数据（百分比）
 */
@property (nonatomic, strong)NSMutableArray *pieChartPercentArray;
/**
 * 数据（颜色）
 */
@property (nonatomic,strong) NSMutableArray *colorArray;

/**
 * 选中的标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;

/**
 * 选中的金额
 */
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

/**
 * 选中的百分比
 */
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;

@property (weak, nonatomic) IBOutlet UIView *charView;
@property (weak, nonatomic) IBOutlet UIView *acView;
@property (weak, nonatomic) IBOutlet UIView *bcView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxLabel;
@property (weak, nonatomic) IBOutlet UILabel *perMonthLabel;

@property (weak, nonatomic) IBOutlet UILabel *daikuangLabel;

@property (weak, nonatomic) IBOutlet UILabel *allTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *itaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@end

@implementation CalcutorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpPieChart];
}

- (void)setUpPieChart {
    
  
    
    // 刷新加载
  
    
    // 设置圆心标题 （NSString类型）
    //    [self.pieChartView setAmountText:@"总资产"];
    
   
    _bcView.backgroundColor =  [UIColor colorWithString:@"#FF3C51"];
    _acView.backgroundColor = GlobalTintColor;
    _bcView.layer.cornerRadius = 5;
    _acView.layer.cornerRadius = 5;
    
    
   // [newdata setObject:_yearValueLabel.text forKey:@"year"];
   // [newdata setObject:_percentInput.text forKey:@"downPayment"];
   // [newdata setObject:_taxPercentInput.text forKey:@"taxPercentInput"];
    
       //总金额
    double total = 0.0;
    
    
   
    
    if([[self getMyLang] containsString:@"zh"]){
     total =  [[[_data[@"price"]   stringByReplacingOccurrencesOfString:@"万美元" withString:@""]
                stringByReplacingOccurrencesOfString:@"," withString:@"" ] doubleValue]*10000;
    }else{
     total =  [[[_data[@"price"]   stringByReplacingOccurrencesOfString:@"$" withString:@""]
               stringByReplacingOccurrencesOfString:@"," withString:@"" ]doubleValue];
    
    }
   
   
    
    NSInteger months = [_data[@"year"] integerValue] * 12;//30年
    //首付比例
    double firstRate = [_data[@"downPayment"] doubleValue];//20.0;//20%downPayment
    
    //月利率
    double ir = [_data[@"taxPercentInput"] doubleValue] / (100 * 12);
    
    //首付
    double firstPay = total * (firstRate / 100);
    
    //要贷款的金额
    double principal = total - firstPay;
    
    //每月税费
    double taxMonth = [_data[@"tax"] doubleValue] / 12;
    
    
    //月供
    double monthPay = principal * (ir/(1- pow((1 + ir),(0 - months)))) + taxMonth;

    
    
    
    NSNumber *wo = @( [[_data[@"tax"] stringByReplacingOccurrencesOfString:@"," withString:@""] doubleValue]);
   
    _pieChartArray = [NSMutableArray arrayWithObjects:@{@"title":@"房产税", @"percent":@"45", @"amount":@( monthPay ),@"percent":@( [wo doubleValue]  /(monthPay+ [wo doubleValue]))}, @{@"title":@"本金利息", @"percent":@(monthPay * 12*30  /(monthPay + [wo doubleValue])),@"amount":wo}, nil];
  
   
     _pieChartPercentArray = [NSMutableArray arrayWithObjects:@(monthPay  /(monthPay + [wo doubleValue])*100),@( [wo doubleValue]  /(monthPay +[wo doubleValue]) *100), nil];
    
    //[NSString stringWithFormat:@"%.2f",monthPay * 12 ]
    
    CGRect pieChartFrame = CGRectMake(0, 0, 200, 200);
    
    // 初始化饼图
    self.pieChartView = [[XYPieChartView alloc] initWithFrame:pieChartFrame withPieChartTypeArray:self.pieChartArray withPercentArray:self.pieChartPercentArray withColorArray:self.colorArray];
    
    self.pieChartView.delegate = self;
    
    // 当有一项数据的百分比小于你所校验的数值时，会将该项数值百分比移出饼图展示（校验数值从0~100）
    [self.pieChartView setCheckLessThanPercent:16];
    
    if([[self getMyLang] containsString:@"zh"]){
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"月供\n%@美元",[NSString stringWithFormat:@"%.2f",monthPay ]]];
        
        
        ;
        _priceLabel.text = [NSString stringWithFormat:@"房屋总价：%@",_data[@"price"]];
        
        _firstPayLabel.text =[NSString stringWithFormat:@"首          付：%@万美元", [NSString stringWithFormat:@"%.2f",firstPay/10000]];
        
        // tax
        
        _taxLabel.text =[NSString stringWithFormat:@"房  产  税：%@美元",[_data[@"tax"] stringByReplacingOccurrencesOfString:@"," withString:@""]];
        
        
        _daikuangLabel.text =[NSString stringWithFormat:@"贷 款 总 额：%@万美元",[NSString stringWithFormat:@"%.2f",principal/10000]];
        
        _perMonthLabel.text =[NSString stringWithFormat:@"月       供：%@美元",[NSString stringWithFormat:@"%.2f",monthPay]];
        
        _allTotalLabel.text =[NSString stringWithFormat:@"年还款总额：%@美元",[NSString stringWithFormat:@"%.2f",monthPay * 12 ]];
        
        _itaxLabel.text  = @"房产税";
        _accountLabel.text = @"本金利息";
        
        // 设置圆心标题（NSMutableAttributedString类型）
        [self.pieChartView setTitleText:str];
    
    }else{
        _itaxLabel.text  = @"Property Tax";
        _accountLabel.text = @"Annual Payment";
    
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Monthly Payment\n$%@",[NSString stringWithFormat:@"%.2f",monthPay ]]];
        
        
        ;
        _priceLabel.text = [NSString stringWithFormat:@"Purchase     Price：%@",_data[@"price"]];
        
        _firstPayLabel.text =[NSString stringWithFormat:@"Down  Payment：$%.2f", firstPay];
        
        // tax
        
        _taxLabel.text =[NSString stringWithFormat:@"Property       Tax：$%@",_data[@"tax"] ];
        
        
        _daikuangLabel.text =[NSString stringWithFormat:@"Loan     Amount：$%@",[NSString stringWithFormat:@"%.2f",principal]];
        
        _perMonthLabel.text =[NSString stringWithFormat:@"Monthly Payment：$%@",[NSString stringWithFormat:@"%.2f",monthPay]];
        
        _allTotalLabel.text =[NSString stringWithFormat:@"Annual Payment：$%@",[NSString stringWithFormat:@"%.2f",monthPay * 12 ]];
        
        
        
        // 设置圆心标题（NSMutableAttributedString类型）
        [self.pieChartView setTitleText:str];
    }
    
   
    
   
    
    [self.charView addSubview:self.pieChartView];
    
      [self.pieChartView reloadChart];
}

-(void)setData:(NSDictionary *)data{

    _data = data;
    
   
}





- (NSMutableArray *)colorArray {
    
    if (_colorArray == nil) {
        
        //        (餐饮、购物、娱乐、零食)
        _colorArray = [NSMutableArray arrayWithObjects:
                      [UIColor colorWithString:@"#FF3C51"],
                      GlobalTintColor,
                       nil];
    }
    
    return _colorArray;
}

#pragma mark - <选中扇形回调>
- (void)selectedFinish:(XYPieChartView *)pieChartView index:(NSInteger)index selectedType:(NSDictionary *)selectedType {
    
    self.titlelabel.text = selectedType[@"title"];
    
    self.amountLabel.text = selectedType[@"amount"];
    
    self.percentLabel.text = [NSString stringWithFormat:@"%@%%", selectedType[@"percent"]];
    
}

#pragma mark - <点击扇形同心圆回调>
- (void)onCenterClick:(XYPieChartView *)PieChartView {
    
    NSLog(@"点击了圆心");
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.ctitleLabel.text = self.lang[@"mortgagen"];
    self.navigationController.navigationBarHidden = YES;
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
