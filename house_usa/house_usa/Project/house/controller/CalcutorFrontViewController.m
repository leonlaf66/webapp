//
//  CalcutorFrontViewController.m
//  house_usa
//
//  Created by 林 建军 on 30/08/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "CalcutorFrontViewController.h"
#import "CalcutorViewController.h"
@interface CalcutorFrontViewController ()
@property (weak, nonatomic) IBOutlet UIButton *calBtn;
@property (weak, nonatomic) IBOutlet UIView *taxView;
@property (weak, nonatomic) IBOutlet UITextField *percentInput;
@property (weak, nonatomic) IBOutlet UITextField *yearInput;
@property (weak, nonatomic) IBOutlet UITextField *taxPercentInput;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstPayPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTaxLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalPriceValueLabel;


@property (weak, nonatomic) IBOutlet UILabel *yearValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *payTaxValueLabel;

@end

@implementation CalcutorFrontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _calBtn.layer.cornerRadius = 3;
    
    _taxView.layer.cornerRadius = 3;
    
    UITapGestureRecognizer *atap = [[UITapGestureRecognizer alloc] init];
    [atap addTarget:self action:@selector(tapped)];
    [self.view addGestureRecognizer:atap];
    
    _totalPriceValueLabel.text = _data[@"price"];
    _payTaxValueLabel.text = _data[@"tax"];
}
-(void)tapped{
       [_percentInput resignFirstResponder];
      [_yearInput resignFirstResponder];
      [_taxPercentInput resignFirstResponder];
   

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)calAction:(id)sender {
    
    CalcutorViewController *controller = [[CalcutorViewController alloc] initWithNibName:@"CalcutorViewController" bundle:nil];
    
    NSMutableDictionary *newdata = [NSMutableDictionary dictionaryWithDictionary:_data];
     [newdata setObject:_yearInput.text forKey:@"year"];
     [newdata setObject:_percentInput.text forKey:@"downPayment"];
     [newdata setObject:_taxPercentInput.text forKey:@"taxPercentInput"];
    [controller setData:newdata];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setData:(NSDictionary *)data{

    _data  = data;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
   
    if([[self getMyLang] containsString:@"zh"]){
     self.ctitleLabel.text = @"房贷计算器";
        _totalPriceLabel.text = @"房屋总价";
        _payTaxLabel.text = @"房产税";
          _firstPayPercentLabel.text = @"首付";
    _yearLabel.text = @"贷款年限";
        _taxLabel.text = @"利率";
        //calBtn
           [_calBtn setTitle:@"开始计算" forState:UIControlStateNormal];
    }else{
        
        self.ctitleLabel.text = @"MORTGAGE CALC";
         _totalPriceLabel.text = @"Purchase Price";
        _payTaxLabel.text = @"Property Tax";
        _firstPayPercentLabel.text = @"Down Payment";
         _yearLabel.text = @"Mortgage Term";
         _taxLabel.text = @"Interest Rate";
         [_calBtn setTitle:@"Calculate" forState:UIControlStateNormal];
    }
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
