//
//  HttpRequester.h
//  Inwiter demo
//
//  Created by Inwiter on 4/21/13.
//  Copyright (c) 2013 Inwiter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPRequestOperation.h"
#import "AFNetworkActivityIndicatorManager.h"

typedef void(^completeCallback)( NSDictionary *response);
typedef void(^failureCallback)(NSDictionary *nsDError);
typedef void(^uploadProgressCallback)(float uploadPercent);
typedef void(^downloadProgressCallback)(float downloadPercent);

@interface HTTPRequester : NSObject
{
    
}

@property (nonatomic,retain) NSUserDefaults *userDefaults;
@property (nonatomic,retain) NSString *appID;
@property (nonatomic,retain) NSString *appSecret;
@property (nonatomic,retain) NSString *accessToken;

+(NSString *) GET ;
+(NSString *) POST ;
+(NSString *) PUT ;
+(NSString *) DELETE;

-(void) makeHTTPRequest: (NSString*) url method: (NSString*) method params: (NSDictionary*) params responseType: (NSString*) responseType complete:(completeCallback) complete failure:(failureCallback) failure;

-(void) makeRESTHTTPRequest: (NSString*) url method: (NSString*) method params: (NSDictionary*) params responseType: (NSString*) responseType complete:(completeCallback) complete failure:(failureCallback) failure;

-(void)uploadFileToURL: (NSString*)url params: (NSMutableDictionary*)params responseType:(NSString*) responseType withFileURL: (NSURL *) withFileURL complete:(completeCallback)complete failure:(failureCallback)failure uploadProgress:(uploadProgressCallback)uploadProgress;
-(void)uploadFileToURL: (NSString*)url params: (NSMutableDictionary*)params responseType:(NSString*) responseType withFileData: (NSData *) fileData complete:(completeCallback)complete failure:(failureCallback)failure uploadProgress:(uploadProgressCallback)uploadProgress;
-(void)uploadImageToURL: (NSString*)url params: (NSMutableDictionary*)params responseType:(NSString*) responseType withFileData: (NSData *) fileData complete:(completeCallback)complete failure:(failureCallback)failure uploadProgress:(uploadProgressCallback)uploadProgress;


-(void)downloadFileFromURL:(NSString*) url params: (NSMutableDictionary*) params  toPath:(NSString*) savePath complete:(completeCallback)complete failure:(failureCallback)failure downloadProgress:(downloadProgressCallback)downloadProgress;
//-(void)uploadVideoFileToURL:(NSString *)url params:(NSMutableDictionary *)params responseType:(NSString *)responseType withFileURL:(NSURL *)withFileURL complete:(completeCallback)complete failure:(failureCallback)failure uploadProgress:(uploadProgressCallback)uploadProgress;
@end
