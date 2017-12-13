//
//  HotAreaViewController.m
//  house_usa
//
//  Created by 林 建军 on 08/09/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "HotAreaViewController.h"
#import "HotAreaViewCell.h"
@interface HotAreaViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *aImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bImageView;
@property (weak, nonatomic) IBOutlet UIImageView *cImageView;
@property (weak, nonatomic) IBOutlet UILabel *aLabel;
@property (weak, nonatomic) IBOutlet UILabel *bLabel;
@property (weak, nonatomic) IBOutlet UILabel *cLabel;




@property (weak, nonatomic) IBOutlet UIView *aView;
@property (weak, nonatomic) IBOutlet UIView *bView;
@property (weak, nonatomic) IBOutlet UIView *cView;
@end

@implementation HotAreaViewController

- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    NSArray *value = [_datas allValues];
    
    if([value count] > 0){
        NSDictionary *obj = [value objectAtIndex:0];
       [_aImageView sd_setImageWithURL:[NSURL URLWithString:obj[@"image_url"]] placeholderImage:nil];
        
      _aLabel.text =   [NSString stringWithFormat:@"%@(%@)",obj[@"name"],obj[@"desc"] ];
        
        
        NSDictionary *objb = [value objectAtIndex:1];
        [_bImageView sd_setImageWithURL:[NSURL URLWithString:objb[@"image_url"]] placeholderImage:nil];
        
          _bLabel.text =   [NSString stringWithFormat:@"%@(%@)",objb[@"name"],objb[@"desc"] ];
        NSDictionary *objc = [value objectAtIndex:2];
        [_cImageView sd_setImageWithURL:[NSURL URLWithString:objc[@"image_url"]] placeholderImage:nil];
          _cLabel.text =   [NSString stringWithFormat:@"%@(%@)",objc[@"name"],objc[@"desc"] ];
        
        
        
        
        UITapGestureRecognizer *atap = [[UITapGestureRecognizer alloc] init];
        [atap addTarget:self action:@selector(atap)];
        [_aView addGestureRecognizer:atap];
        
        
        
        
        UITapGestureRecognizer *btap = [[UITapGestureRecognizer alloc] init];
        [btap addTarget:self action:@selector(btap)];
        [_bView addGestureRecognizer:btap];

        
        
        
        UITapGestureRecognizer *ctap = [[UITapGestureRecognizer alloc] init];
        [ctap addTarget:self action:@selector(ctap)];
        [_cView addGestureRecognizer:ctap];


        
     }
}

-(void)atap{
    NSString *key = [self.datas.allKeys objectAtIndex:0];
    NSString *name =  _datas[key][@"name"];
    _getBackAction(@{@"code":key,@"address":name});
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)btap{
    NSString *key = [self.datas.allKeys objectAtIndex:2];
    NSString *name =  _datas[key][@"name"];
    _getBackAction(@{@"code":key,@"address":name});
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)ctap{
    NSString *key = [self.datas.allKeys objectAtIndex:1];
    NSString *name =  _datas[key][@"name"];
    _getBackAction(@{@"code":key,@"address":name});
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    if([[self getMyLang] containsString:@"zh"]){
    
     self.ctitleLabel.text = @"区域选择";
    }else{
    
     self.ctitleLabel.text = @"Choose location";
    }
}
-(void)setDatas:(NSDictionary *)datas{

    _datas = datas;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
    
}



// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.datas.allKeys count];
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    
    static NSString *identifierb=@"HotAreaViewCell";
    HotAreaViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifierb];
    if (cell==nil) {
        
        cell= [[[NSBundle mainBundle]loadNibNamed:@"HotAreaViewCell" owner:nil options:nil] firstObject];
    }
    
     cell.titleLabel.text =   _datas[[self.datas.allKeys objectAtIndex:row]][@"name"];
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    
    NSString *key = [self.datas.allKeys objectAtIndex:row];
    NSString *name =  _datas[key][@"name"];
    _getBackAction(@{@"code":key,@"address":name});
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)setGetBackAction:(AddressGetBackAction)getBackAction{

    _getBackAction = getBackAction;
}

@end
