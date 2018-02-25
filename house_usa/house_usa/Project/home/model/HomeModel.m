//
//  HomeModel.m
//  house_usa
//
//  Created by 林 建军 on 02/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel
DEF_SINGLETON(HomeModel);


-(void)addFovaritesHouse:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{
    
   
    
    [self gettUrl:@"estate/house/favorite" data:data success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];
    
}


-(void)getFovaritesHouse:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{
    
    
    
    [self gettUrl:@"member/favorite/list" data:data success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];
    
}


-(void)deleteFovaritesHouse:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{
    
    
    
    [self gettUrl:@"member/favorite/remove" data:data success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];
    
}

    
-(void)findHomeList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{
    
    [self postUrl:@"app/new/pic/list.do" data:data success:^(id responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];
    
}

-(void)getHouseList:(NSDictionary *) data success:(void (^)(NSDictionary *operation))success failure:(void (^)(NSError *error))failure{
    
   
    
    [self gettUrl:@"estate/house/search" data:data success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];
    
    
}

-(void)getHotAreaData:(NSDictionary *) data success:(void (^)(NSDictionary *operation))success failure:(void (^)(NSError *error))failure{
    [self gettUrl:@"estate/house/hot-areas" data:data success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];


}

-(void)getAreaData:(NSDictionary *) data success:(void (^)(NSDictionary *operation))success failure:(void (^)(NSError *error))failure{
    [self gettUrl:@"estate/area/list" data:data success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];
    
    
}


-(void)getHouseDetail:(NSDictionary *) data success:(void (^)(NSDictionary *operation))success failure:(void (^)(NSError *error))failure{
    
    
    [self gettUrl:@"estate/house/get" data:data success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];
    
}

-(void)findNewsList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{

    [self gettUrl:@"catalog/news/list" data:data success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];

}

-(void)findHomeNewsList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{
    [self gettUrl:@"catalog/news/latest" data:data success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];

}

-(void)findNewsDetail:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{

    [self gettUrl:@"catalog/news/get" data:data success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];


}


-(void)findNewsCategoryList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{
    
    [self gettUrl:@"catalog/news/types" data:data success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];
    
    
}

-(void)findNewsBannerList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{
    [self gettUrl:@"catalog/news/list-top-banner" data:data success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];


}


-(void)findHomeHouseList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{
    [self gettUrl:@"estate/house/top" data:data success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];
}

-(void)findHomeYellowList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{

    [self gettUrl:@"catalog/yellow-page/recommends" data:data success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];

}


-(void)getNearByData:(NSDictionary *) data success:(void (^)(NSDictionary *operation))success failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *newdata = [NSMutableDictionary dictionaryWithDictionary:data];
    
    //[newdata setObject:self.area forKey:@"area_id"];
    [self gettUrl:@"estate/house/map-search" data:newdata success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];


}


-(void)findYellowPageTypeList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{

    [self gettUrl:@"catalog/yellow-page/types" data:data success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];


}


-(void)findYellowPageList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{
    
    [self gettUrl:@"catalog/yellow-page/list" data:data success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];
    
    
}

-(void)findYellowPageDetail:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{
    
    [self gettUrl:@"catalog/yellow-page/get" data:data success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];
    
    
}


-(void)login:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{
    [self gettUrl:@"passport/account/login" data:data success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];
    
}

-(void)loginSer:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{
    [self postUrl:@"passport/account/wechat-login" data:data success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];
    
}


-(void)registerAccount:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{
    [self postUrl:@"passport/account/register" data:data success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];
    
  
    
}


-(void)addComments:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{
    
   NSString *url =  [NSString stringWithFormat:@"catalog/comment/submit?id=%@&type=%@",data[@"id"],data[@"type"]];
    
    [self postUrl:url data:data success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];
    
    
    
}

-(void)findCommentsList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{
    
    [self gettUrl:@"catalog/comment/list" data:data success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];
    
    
}

-(void)getSubwayList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{

    
    [self gettUrl:@"catalog/subway/maps" data:data success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];

}


-(void)addSchedule:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{
    
    NSString *url =  [NSString stringWithFormat:@"estate/house/tour?id=%@",data[@"id"]];
    
    [self postUrl:url data:data success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];
    
    
    
}


-(void)findScheduleList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{
    
    [self gettUrl:@"member/schedule/list" data:data success:^(id responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];
    
}

-(void)deleteSchedule:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{
    
    [self gettUrl:@"member/schedule/remove" data:data success:^(id responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];
    
}


-(void)findKeyWordsList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{
    
    [self gettUrl:@"estate/house/search-options" data:data success:^(id responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];
    
}


-(void)wxLogin:(NSString *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{
    [self gettUrlwx:data data:@{} success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];
    
}


-(void)wxUserINfor:(NSString *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{
    [self gettUrlwx:data data:@{} success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];
    
}

//


-(void)addDeviceToken:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{
    
    _sessionManager.requestSerializer = [AFJSONRequestSerializer new];
    _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
   
    
    [_sessionManager POST:@"http://35.177.161.21/app/device/addDevice.do" parameters:data progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result  =[[ NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"the fuck %@",result);
        
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                    options:NSJSONReadingAllowFragments
                                                                      error:nil];
        BLOCK_SAFE(success)(jsonObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        BLOCK_SAFE(failure)(error);
    }];

    
}


-(void)addCfg:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{
    
      NSString *url =  [NSString stringWithFormat:@"support/configs/submit?app_id=iphone"];
    
    [self postUrl:url data:data success:^(NSDictionary *responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];
    
}


-(void)getCfg:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{
    
    [self gettUrl:@"support/configs/get" data:data success:^(id responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];
    
}
@end
