//
//  DataModel.h
//  decoration
//
//  Created by 林 建军 on 08/12/2016.
//  Copyright © 2016 yl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
@interface DataModel : NSObject{

    AFHTTPSessionManager *_sessionManager;
}

-(void)gettUrl:(NSString *) url data:(NSDictionary *) data success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

-(void)postUrl:(NSString *) url data:(NSDictionary *) data success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

//文件上传

-(void)postUrlWithFormData:(NSString *) url data:(NSDictionary *) data formData:(id<AFMultipartFormData>) formData success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

-(void)gettUrlwx:(NSString *) url data:(NSDictionary *) data success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end
