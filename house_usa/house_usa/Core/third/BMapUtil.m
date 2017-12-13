//
//  BMapUtil.m
//  house_usa
//
//  Created by 林 建军 on 26/05/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "BMapUtil.h"

@implementation BMapUtil
DEF_SINGLETON(BMapUtil);
-(instancetype)init{

    self = [super init];
    
    if(self){
        // 要使用百度地图，请先启动BaiduMapManager
        _mapManager = [[BMKMapManager alloc]init];
        
        if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
            NSLog(@"经纬度类型设置成功");
        } else {
            NSLog(@"经纬度类型设置失败");
        }
        
        BOOL ret = [_mapManager start:BMKEY generalDelegate:self];
        if (!ret) {
            NSLog(@"manager start failed!");
        }
      
       // [BMKLocationService setLocationDistanceFilter:1];
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
       
        
        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
        _geoCodeSearch.delegate = self;
    
    }
    
    return self;
}

-(void)startLoaction:(void (^)(BMKUserLocation *userLocation
       ))success failure:(void (^)(NSString *address))address{
   
    self.userLocationBlock = success;
    self.userAddressBlock = address;
}


-(void)startBDLocation
{
    [_locService startUserLocationService];
}


-(void)stopBDLocation
{
    [_locService stopUserLocationService];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _userLocation = userLocation;
   // [self stopBDLocation];
    
    BLOCK_OBJC(self,this);
    BLOCK_SAFE(this.userLocationBlock)(userLocation);
    
    
 //   BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
  //  reverseGeoCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    
   // [_geoCodeSearch reverseGeoCode:reverseGeoCodeSearchOption];
    
}

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        BLOCK_OBJC(self,this);
        BLOCK_SAFE(this.userAddressBlock)(result.address);
        
    }
    else {
        
      //  [self startBDLocation];
    }
    
    NSLog(@"当前位置：%@",result.address);
    
}

/**
 *返回地址信息搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结BMKGeoCodeSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    NSLog(@"ddd");
}


@end
