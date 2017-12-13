//
//  BMapUtil.h
//  house_usa
//
//  Created by 林 建军 on 26/05/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
@interface BMapUtil : NSObject<BMKGeneralDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKGeoCodeSearchDelegate>{
    BMKMapManager* _mapManager;
    BMKLocationService* _locService;
    
    BMKUserLocation   *_userLocation;
    BMKGeoCodeSearch  *_geoCodeSearch;
}

@property (strong, nonatomic) void (^userLocationBlock)(BMKUserLocation *userLocation);

@property (strong, nonatomic) void (^userAddressBlock)(NSString *address);
AS_SINGLETON(BMapUtil);
-(void)startBDLocation;

-(void)startLoaction:(void (^)(BMKUserLocation *userLocation
                               ))success failure:(void (^)(NSString *address))address;
@end
