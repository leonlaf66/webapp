//
//  HomeBusinessCell.m
//  house_usa
//
//  Created by 林 建军 on 26/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "HomeBusinessCell.h"

@implementation HomeBusinessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     _startView.pentacleScore = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSArray *)data{

    _data = data;
    //MultiPentacleView
     // [_myImageView sd_setImageWithURL:[NSURL URLWithString:_data[@"photo"]] placeholderImage:nil];
    
   // _titleLabel.text = _data[@"name"];
   // _startView.pentacleScore = [_data[@"rating"] doubleValue];
    
    NSInteger row = 0;
    
    for(NSDictionary *objs  in _data){
             if(row == 0){
            _lastView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
        
        }else{
           
        
           _lastView = [[UIView alloc] initWithFrame:CGRectMake(0,  _lastView.frame.origin.y + _lastView.frame.size.height + 10, ScreenWidth, 130)];
        }
        
        _lastView.backgroundColor = [UIColor whiteColor];
     
        [self.contentView addSubview:_lastView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth, 20)];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = [UIColor colorWithString:@"#333333"];
        titleLabel.text = objs[@"name"];
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_lastView addSubview:titleLabel];
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,  titleLabel.frame.origin.y+20+ 5, ScreenWidth, 1)];
        lineView.backgroundColor = [UIColor colorWithString:@"#f2f2f2"];
        
         [_lastView addSubview:lineView];
        
        NSInteger column = 0;

        CGFloat width = ScreenWidth / 4;
        
        for(NSDictionary * o  in objs[@"items"]){
           
            if(column <= 3){
                
            UIView   *itemView = [[UIView alloc] initWithFrame:CGRectMake(column*width, lineView.frame.origin.y + 5, width, 60)];
                UIImageView *img =  [[UIImageView alloc] initWithFrame:CGRectMake((width - 50)/2, 5, 50, 50)];
                img.clipsToBounds = YES;
                img.layer.cornerRadius = 25;
                
                [img sd_setImageWithURL:[NSURL URLWithString:o[@"photo"]] placeholderImage:nil];
                [itemView addSubview:img];
                
                itemView.tag = [o[@"id"]integerValue] +200000;
                UITapGestureRecognizer *atap = [[UITapGestureRecognizer alloc] init];
                [atap addTarget:self action:@selector(tapped:)];
                [itemView addGestureRecognizer:atap];

                
                
                [_lastView addSubview:itemView];
                
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, img.frame.origin.y+50+5, width, 15)];
                nameLabel.font = [UIFont systemFontOfSize:10];
                nameLabel.textColor = [UIColor colorWithString:@"#333333"];
                nameLabel.text = o[@"name"];
                
                nameLabel.textAlignment = NSTextAlignmentCenter;
                [itemView addSubview:nameLabel];
                
                MultiPentacleView *start = [[MultiPentacleView alloc] initWithFrame:CGRectMake((width - 70) /2, nameLabel.frame.origin.y+15 , 70, 10)];
               // start.backgroundColor  = [UIColor redColor];
                
                 start.pentacleScore = [o[@"rating"] doubleValue];
                 [itemView addSubview:start];
                
            }
            column++;
        }
        
        row++;
    }
    
    
}

- (void)tapped:(UITapGestureRecognizer *)t {
  
    _getBack(t.view.tag - +200000);
}
-(void)setGetBack:(BusinessGetBackAction)getBack{

    _getBack = getBack;

}

@end
