//
//  MyBMKPinAnnotationView.h
//  house_usa
//
//  Created by 林 建军 on 26/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "MapItemView.h"
@interface MyBMKPinAnnotationView : BMKPinAnnotationView
@property(nonatomic,strong) NSString *imgName;
@property(nonatomic)BOOL aselected;
@property(nonatomic,strong) MapItemView *mapItemView;
@end
