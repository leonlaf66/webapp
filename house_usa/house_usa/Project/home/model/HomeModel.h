//
//  HomeModel.h
//  house_usa
//
//  Created by 林 建军 on 02/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "DataModel.h"

@interface HomeModel : DataModel
AS_SINGLETON(HomeModel);
@property(strong,nonatomic)NSString *area;

-(void)addFovaritesHouse:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;

-(void)getFovaritesHouse:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;
-(void)deleteFovaritesHouse:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;

-(void)findHomeList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;

-(void)getHouseList:(NSDictionary *) data success:(void (^)(NSDictionary *operation))success failure:(void (^)(NSError *error))failure;

-(void)getHouseDetail:(NSDictionary *) data success:(void (^)(NSDictionary *operation))success failure:(void (^)(NSError *error))failure;

-(void)getNearByData:(NSDictionary *) data success:(void (^)(NSDictionary *operation))success failure:(void (^)(NSError *error))failure;

-(void)getHotAreaData:(NSDictionary *) data success:(void (^)(NSDictionary *operation))success failure:(void (^)(NSError *error))failure;

////新闻信息

-(void)findNewsBannerList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;

-(void)findNewsList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;

-(void)findNewsDetail:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;

-(void)findHomeNewsList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;


-(void)findNewsCategoryList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;

//////////房子信息

-(void)findHomeHouseList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;

-(void)findHomeYellowList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;


//////////黄页

-(void)findYellowPageTypeList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;

-(void)findYellowPageList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;

-(void)findYellowPageDetail:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;

//////////用户相关
-(void)login:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;

-(void)registerAccount:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;


-(void)addComments:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;


-(void)findCommentsList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;

-(void)getSubwayList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;


-(void)addSchedule:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;

-(void)findScheduleList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;
-(void)getAreaData:(NSDictionary *) data success:(void (^)(NSDictionary *operation))success failure:(void (^)(NSError *error))failure;
-(void)deleteSchedule:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;

-(void)findKeyWordsList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;

-(void)wxLogin:(NSString *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;
-(void)loginSer:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;
-(void)wxUserINfor:(NSString *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;


-(void)addCfg:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;


-(void)getCfg:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure;
@end
