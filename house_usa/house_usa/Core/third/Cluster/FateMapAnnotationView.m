//
//  FateMapAnnotationView.m
//  moyou
//
//  Created by 幻想无极（谭启宏） on 16/7/6.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "FateMapAnnotationView.h"
#import "MapItemView.h"
@interface FateMapAnnotationView ()

@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIImageView *userImage;
@property (nonatomic,strong)UILabel *iconButton;
@property (nonatomic,strong)MapItemView *itemView;
@end

@implementation FateMapAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        [self setBounds:CGRectMake(0.f, 0.f, 140.0/2, 140.0/2)];
        [self common];
        
    }
    return self;
}


-(double)getWidthWithString:(NSString*)str font:(UIFont*)font{
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize detailSize = [str sizeWithAttributes:dict];
    return detailSize.width;
}


- (void)common {
    self.imageView = [UIImageView new];
    self.userImage = [UIImageView new];
    self.itemView = [[MapItemView alloc] initWithFrame:CGRectMake(0, 0, 130/2, 30)] ;
    // self.itemView.center = CGPointMake(self.itemView.center.x, self.itemView.center.y-3);
    self.iconButton = [UILabel new];
    self.layer.cornerRadius = self.frame.size.width/2;
  
    self.imageView.frame = self.bounds;
    self.userImage.frame = CGRectMake(0, 0, 20, 20);
    
     //self.itemView.frame = CGRectMake(0, 0, 130/2, 130/2);
    self.iconButton.frame = CGRectMake(3, 11,30, 11);
    self.iconButton.textAlignment = NSTextAlignmentCenter;
   
    self.iconButton.layer.masksToBounds = YES;
   //self.iconButton.backgroundColor = [UIColor redColor];
    self.iconButton.font = [UIFont systemFontOfSize:10];
    self.iconButton.textColor = [UIColor whiteColor];
   // [self.iconButton setTitle:@"99" forState:UIControlStateNormal];
    self.userImage.center = CGPointMake(self.imageView.center.x-5, self.imageView.center.y+10);
   
    
    // self.iconButton.center = CGPointMake(self.imageView.center.x, self.imageView.center.y-3);
     self.itemView.center = CGPointMake(self.imageView.center.x, self.imageView.center.y-3);
//    self.userImage.layer.borderColor = [MoyouColor colorWithLine].CGColor;
   // self.imageView.image = [UIImage imageNamed:@"currentMap"];
    self.userImage.image = [UIImage imageNamed:@"downs"];
    
    [self addSubview: self.itemView];
    [self addSubview:self.iconButton];
    
    [self addSubview:self.userImage];
}

- (void)setCluster:(BMKCluster *)cluster {
//     [self.userImage sd_setImageWithURL:[NSURL URLWithString:cluster.model.pic] placeholderImage:[UIImage imageNamed:@"yuanfen_icon_touxiang"]];
}

- (void)setModel:(FateModel *)model {
    _model = model;
    self.itemView.data = _model;
   [self.itemView setSelected:NO];
}

//- (void)setImagUrlString:(NSString *)imagUrlString {
//    _imagUrlString = imagUrlString;
//    [self.userImage sd_setImageWithURL:[NSURL URLWithString:imagUrlString] placeholderImage:[UIImage imageNamed:@"yuanfen_icon_touxiang"]];
//    NSLog(@"-----");
//}

//mask覆盖图
//
//- (UIImage *)imageByComposingImage:(UIImage *)image withMaskImage:(UIImage *)maskImage {
//    CGImageRef maskImageRef = maskImage.CGImage;
//    CGImageRef maskRef = CGImageMaskCreate(CGImageGetWidth(maskImageRef),
//                                           CGImageGetHeight(maskImageRef),
//                                           CGImageGetBitsPerComponent(maskImageRef),
//                                           CGImageGetBitsPerPixel(maskImageRef),
//                                           CGImageGetBytesPerRow(maskImageRef),
//                                           CGImageGetDataProvider(maskImageRef), NULL, false);
//    
//    CGImageRef newImageRef = CGImageCreateWithMask(image.CGImage, maskRef);
//    CGImageRelease(maskRef);
//    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
//    CGImageRelease(newImageRef);
//    
//    return newImage;
//}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    if(selected){
        if (_size > 1) {
            
            [self.itemView setSelected:NO];
            self.userImage.image = [UIImage imageNamed:@"downs"];
        }else {
            [self.itemView setSelected:YES];
            self.userImage.image = [UIImage imageNamed:@"downs-red"];
            
        }
    
    }else{
        [self.itemView setSelected:NO];
         self.userImage.image = [UIImage imageNamed:@"downs"];
    
    }
   


}

- (void)setSize:(NSInteger)size {
     _size = size;
    if (_size > 1) {
          [self setBounds:CGRectMake(0.f, 0.f, 70.0/2, 70.0/2)];
        self.iconButton.hidden = NO;
          self.itemView.hidden = YES;
         self.userImage.hidden = YES;
        self.layer.cornerRadius = 17.5;
        [self.iconButton setText:[NSString stringWithFormat:@"%ld",_size]];
          self.backgroundColor = [UIColor globalTintColor];
      
    }else {
        self.iconButton.hidden = YES;
         self.itemView.hidden = NO;
        self.userImage.hidden = NO;
          self.backgroundColor = [UIColor clearColor];
      
        [self setBounds:CGRectMake(0.f, 0.f, self.itemView.frame.size.width,30)];
    }
}

@end

@implementation FateMapAnnotation
- (void)setModel:(FateModel *)model {
    _model = model;
    
}

@end

