//
//  DataModel.m
//  decoration
//
//  Created by 林 建军 on 08/12/2016.
//  Copyright © 2016 yl. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

-(instancetype)init{
    self = [super init];
    
    if (self) {
       _sessionManager  = [AFHTTPSessionManager manager];
       _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;

}




-(void)add:(NSDictionary *) data success:(void (^)(id operation))success failure:(void (^)(NSError *error))failure{
    
    [self postUrl:@"app/comment/add.do" data:data success:^(id responseObject) {
        BLOCK_SAFE(success)(responseObject);
    } failure:^(NSError *error) {
        BLOCK_SAFE(failure)(error);
    }];


}

-(void)postUrl:(NSString *) url data:(NSDictionary *) data success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    
    
    NSString *lang = [self getLang];
    if (!lang) {
        lang = [self getSystemLang];
    }
    
    
    
    
   
    NSMutableDictionary *newData = [[NSMutableDictionary alloc] initWithDictionary:data];
    
    if ([lang containsString:@"zh"]) {
        [newData setObject:@"zh-CN" forKey:@"language"];
    }else{
        [newData setObject:@"en-US" forKey:@"language"];
        
    }
    
    NSMutableArray *users =  [[UPDao sharedInstance] getUsers];
    
    if([users count] >0){
         UserTime *user = [users objectAtIndex:0];
        [newData setObject:user.token forKey:@"access-token"];
     
        
    }else{
          [newData setObject:@"WODjh82TU7fIk09ydADVfEv56K5ernLS" forKey:@"access-token"];
    }
    
     NSString *newurl  = @"";
    
    if([url containsString:@"?"]){
       newurl =  [NSString stringWithFormat:@"%@/%@&access-token=%@",SEVERADDR,url,newData[@"access-token"]];
    }else{
      newurl =  [NSString stringWithFormat:@"%@/%@?access-token=%@",SEVERADDR,url,newData[@"access-token"]];
    
    }
    
  
    
    NSLog(@"the url is %@",newurl);
    
    //[newData setObject:APPTOKEN forKey:@"app-token"];
    
    _sessionManager.requestSerializer = [AFJSONRequestSerializer new];
    _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    [_sessionManager.requestSerializer setValue:APPTOKEN forHTTPHeaderField:@"app-token"];
    [_sessionManager.requestSerializer setValue:newData[@"language"] forHTTPHeaderField:@"language"];

    
    [_sessionManager POST:newurl parameters:data progress:^(NSProgress * _Nonnull uploadProgress) {
        
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


-(void)gettUrl:(NSString *) url data:(NSDictionary *) data success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    
    
    NSString *lang = [self getLang];
    if (!lang) {
        lang = [self getSystemLang];
    }
    
    
  
    NSMutableDictionary *newData = [[NSMutableDictionary alloc] initWithDictionary:data];
    
    if ([lang containsString:@"zh"]) {
        [newData setObject:@"zh-CN" forKey:@"language"];
    }else{
        [newData setObject:@"en-US" forKey:@"language"];
        
    }

    
    
    NSMutableArray *users =  [[UPDao sharedInstance] getUsers];
    
    if([users count] >0){
        UserTime *user = [users objectAtIndex:0];
        [newData setObject:user.token forKey:@"access-token"];
        
        
    }else{
        [newData setObject:@"WODjh82TU7fIk09ydADVfEv56K5ernLS" forKey:@"access-token"];
    }

  
    
    
    NSString *newurl =  [NSString stringWithFormat:@"%@/%@?access-token=%@",SEVERADDR,url,newData[@"access-token"]];
    
    
      NSLog(@"the url is %@",newurl);
    
    _sessionManager.requestSerializer = [AFJSONRequestSerializer new];
    _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    [_sessionManager.requestSerializer setValue:APPTOKEN forHTTPHeaderField:@"app-token"];
     [_sessionManager.requestSerializer setValue:newData[@"language"] forHTTPHeaderField:@"language"];
   
        
    [_sessionManager GET:newurl parameters:data progress:^(NSProgress * _Nonnull uploadProgress) {
        
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


-(void)postUrlWithFormData:(NSString *) url data:(NSDictionary *) data formData:(id<AFMultipartFormData>) formData success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    
    
     NSString *newurl =  [NSString stringWithFormat:@"%@/%@",SEVERADDR,url];

    
    [_sessionManager POST:newurl parameters:data
            constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    
    [formData appendPartWithFileData:formData name:@"imgUrl" fileName:@"image.jpg" mimeType:@"image/jpeg"];
    
} progress:^(NSProgress * _Nonnull uploadProgress) {
    
    
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





-(void)gettUrlwx:(NSString *) url data:(NSDictionary *) data success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    
    
    
    
  
    
    
    
    
    _sessionManager.requestSerializer = [AFJSONRequestSerializer new];
    _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
   
    
    
    [_sessionManager GET:url parameters:data progress:^(NSProgress * _Nonnull uploadProgress) {
        
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



@end
