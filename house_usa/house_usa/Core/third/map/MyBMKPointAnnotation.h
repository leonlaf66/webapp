//
//  MyBMKPointAnnotation.h
//  house_usa
//
//  Created by 林 建军 on 28/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//


#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface MyBMKPointAnnotation : BMKPointAnnotation
@property(nonatomic,strong) NSDictionary *data;
@property(nonatomic)BOOL aselected;
@end
