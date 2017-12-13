//
//  VideoModel.m
//  house_usa
//
//  Created by 林 建军 on 05/06/2017.
//  Copyright © 2017 yl. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

DEF_SINGLETON(VideoModel);


-(void)findVideoList:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{

    [self postUrl:@"app/new/video/list.do" data:data success:^(id responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];

}
@end
