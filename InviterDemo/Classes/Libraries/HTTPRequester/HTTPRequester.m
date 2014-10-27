//
//  HttpRequester.m
//  Inwiter demo
//
//  Created by Inwiter on 4/21/13.
//  Copyright (c) 2013 Inwiter. All rights reserved.
//

#import "HTTPRequester.h"

#import "BaseURLS.h"


@implementation HTTPRequester
@synthesize userDefaults;
@synthesize appID, appSecret, accessToken;
static NSString *APPID_KEY = @"APPID";
static NSString *APPSECRET_KEY = @"APP_SECRET";
static NSString *ACCESS_TOKEN_KEY = @"ACCESS_TOKEN";
static int const MAX_UPLOAD_RETRTY_COUNT = 2;

int currentRetryCount = 0;
-(HTTPRequester*) init
{
    self = [super init];
    if(self)
    {
        userDefaults = [NSUserDefaults standardUserDefaults];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        NSLog(@"Creating UserDefaults");
    }
    
    return  self;
}
+(NSString *)GET {
    static NSString *get = @"GET";
    return get ;
}
+(NSString *)POST {
    static NSString *post = @"POST";
    return post ;
}
+(NSString *)PUT {
    static NSString *put = @"PUT";
    return put ;
}
+(NSString*) DELETE
{   static NSString *delete = @"DELETE";
    return delete;
}

-(void)makeHTTPRequest:(NSString *)url method:(NSString *)method params:(NSDictionary *)params responseType:(NSString *)responseType complete:(completeCallback)complete failure:(failureCallback)failure
{
    AFHTTPClient *client ;
    if ([url rangeOfString:@"http://" ].location == NSNotFound || [url rangeOfString:@"https://"].location == NSNotFound) {
        client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL ]];
    }
    else
    {
        client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"" ]];
    }
    
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    NSLog(@"HTTP- Requesting.. URL %@", url);
    
    
    if(params) {
        [[params mutableCopy] setObject:@"1" forKey:@"appType"];
        
    }
    else
    {
        params  = [[NSMutableDictionary alloc] init];
        [[params mutableCopy] setObject:@"1" forKey:@"appType"];
    }
    
    if ([HTTPRequester.POST isEqualToString:method]) {
        
        [self makePostRequestWithParams:[params mutableCopy] postPath:url theClient:client complete:^(NSDictionary *response){complete(response);} failure:^(NSDictionary *nsDError){ failure(nsDError);}] ;
        
    } else if ([HTTPRequester.GET isEqualToString:method]||[method isEqualToString:@"GET"] ) {
        
        [self makeGetRequestWithParams:[params mutableCopy] postPath:url theClient:client complete:^(NSDictionary *response){complete(response);} failure:^(NSDictionary *nsDError){ failure(nsDError);}] ;
        
    } else if ([HTTPRequester.PUT isEqualToString:method]) {
        
        [self makePutRequestWithParams:[params mutableCopy] postPath:@"" theClient:client complete:^(NSDictionary *response){complete(response);} failure:^(NSDictionary *nsDError){ failure(nsDError);}] ;
        
    } else if ([HTTPRequester.DELETE isEqualToString:method]) {
        
        [self makePostRequestWithParams:[params mutableCopy] postPath:@"" theClient:client complete:^(NSDictionary *response){complete(response);} failure:^(NSDictionary *nsDError){ failure(nsDError);}] ;
        
    } else {
        
        [self makeDeleteRequestWithParams:[params mutableCopy] postPath:@"" theClient:client complete:^(NSDictionary *response){complete(response);} failure:^(NSDictionary *nsDError){ failure(nsDError);}] ;
        
    }
}

-(void)makeRESTHTTPRequest:(NSString *)url method:(NSString *)method params:(NSMutableDictionary *)params responseType:(NSString *)responseType complete:(completeCallback)complete failure:(failureCallback)failure
{
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
//    NSLog(@"APP_ID %@ Secret %@ access token %@", [userDefaults objectForKey:APPID_KEY], [userDefaults objectForKey:APPSECRET_KEY], [userDefaults objectForKey:ACCESS_TOKEN_KEY]);
//    if( [userDefaults objectForKey:APPID_KEY] != nil && [userDefaults objectForKey:APPSECRET_KEY ] != nil && [userDefaults objectForKey:ACCESS_TOKEN_KEY] != nil)
//    {
//        NSURLCredential *nsCredential = [NSURLCredential credentialWithUser:[userDefaults objectForKey:APPID_KEY] password:[userDefaults objectForKey:APPSECRET_KEY] persistence:NSURLCredentialPersistenceForSession];
//        [client setDefaultCredential:nsCredential];
//        if (params) {
//            if( [params objectForKey:@"accesstoken"] == nil)
//                
//                [params setObject:[userDefaults objectForKey:ACCESS_TOKEN_KEY] forKey:@"accesstoken"];
//            
//        }
//        else
//        {
//            params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[userDefaults objectForKey:ACCESS_TOKEN_KEY], @"accesstoken", nil ];
//            
//        }
//
//    }
    
    if ([[UserAPIKeys sharedInstance] appID]!= nil && [[UserAPIKeys sharedInstance] appSecret]!= nil &&[[UserAPIKeys sharedInstance] accessToken]!= nil ) {
        
        NSURLCredential *nsCredential = [NSURLCredential credentialWithUser:[[UserAPIKeys sharedInstance] appID] password:[[UserAPIKeys sharedInstance] appSecret] persistence:NSURLCredentialPersistenceForSession];
        [client setDefaultCredential:nsCredential];
        if (params) {
            if( [params objectForKey:@"accesstoken"] == nil)
                [params setObject:[[UserAPIKeys sharedInstance] accessToken] forKey:@"accesstoken"];
            [[params mutableCopy] setObject:@"1" forKey:@"appType"];
            
        }
        else
        {
            params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[UserAPIKeys sharedInstance] accessToken], @"accesstoken", nil ];
            [[params mutableCopy] setObject:@"1" forKey:@"appType"];
        }

        
        
    }
    else
    {
        NSLog(@"++++++++++++++Rest request error") ;
    }
    
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    NSLog(@"REST Requesting.. URL %@", url);
    NSLog(@"Request type %@", method);
    NSLog(@"Request params %@", params);
    NSLog(@"API keys APPID %@, Access token %@, secret%@ ", [[UserAPIKeys sharedInstance] appID], [[UserAPIKeys sharedInstance] accessToken], [[UserAPIKeys sharedInstance] appSecret]);
    if ([HTTPRequester.POST isEqualToString:method]) {
        
        [self makePostRequestWithParams:[params mutableCopy] postPath:url theClient:client complete:^(NSDictionary *response){complete(response);} failure:^(NSDictionary *nsDError){ failure(nsDError);}] ;
        
    } else if ([HTTPRequester.GET isEqualToString:method]) {
        
        [self makeGetRequestWithParams:[params mutableCopy] postPath:url theClient:client complete:^(NSDictionary *response){complete(response);} failure:^(NSDictionary *nsDError){ failure(nsDError);}] ;
        
    } else if ([HTTPRequester.PUT isEqualToString:method]) {
        
        [self makePutRequestWithParams:params postPath:url theClient:client complete:^(NSDictionary *response){complete(response);} failure:^(NSDictionary *nsDError){ failure(nsDError);}] ;
        
    } else if ([HTTPRequester.DELETE isEqualToString:method]) {
        
        [self makePostRequestWithParams:params postPath:@"" theClient:client complete:^(NSDictionary *response){complete(response);} failure:^(NSDictionary *nsDError){ failure(nsDError);}] ;
        
    } else {
        
        [self makeDeleteRequestWithParams:params postPath:@"" theClient:client complete:^(NSDictionary *response){complete(response);} failure:^(NSDictionary *nsDError){ failure(nsDError);}] ;
        
    }
    
    
    //    [client postPath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id response){
    //
    //        NSLog(@"AFN REST response %@", operation.responseString);
    //        NSError *error;
    //        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
    //        complete(responseData);
    //    }
    //             failure:^(AFHTTPRequestOperation *operation, NSError *error)
    //     {
    //         //NSLog(@"AFN REST error %@", error.description);
    //         //NSLog(@"error is %@",error);
    //         if(error.code == -1009)
    //         {
    //         }
    //        NSDictionary *nsDError = [NSDictionary dictionaryWithObjectsAndKeys:error.description, @"error", [NSString stringWithFormat:@"%d", [operation.response statusCode]], @"statuscode", nil];
    //         //NSLog(@"response code %d", [operation.response statusCode]);
    //         failure(nsDError);
    //
    //         if(error.code == -1009)
    //             [[NSNotificationCenter defaultCenter]
    //              postNotificationName:@"networkFailureNotification"
    //              object:self];
    //
    //     }];
    
}
-(void)uploadFileToURL: (NSString*)url params: (NSMutableDictionary*)params responseType:(NSString *)responseType withFileURL: (NSURL*) withFileURL complete:(completeCallback)complete failure:(failureCallback)failure uploadProgress:(uploadProgressCallback)uploadProgress
{
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL ]];
    if ([[UserAPIKeys sharedInstance] appID]!= nil && [[UserAPIKeys sharedInstance] appSecret]!= nil &&[[UserAPIKeys sharedInstance] accessToken]!= nil ) {
        
        NSURLCredential *nsCredential = [NSURLCredential credentialWithUser:[[UserAPIKeys sharedInstance] appID] password:[[UserAPIKeys sharedInstance] appSecret] persistence:NSURLCredentialPersistenceForSession];
        [httpClient setDefaultCredential:nsCredential];
        if (params) {
            if( [params objectForKey:@"accesstoken"] == nil)
                [params setObject:[[UserAPIKeys sharedInstance] accessToken] forKey:@"accesstoken"];
            
        }
        else
        {
            params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[UserAPIKeys sharedInstance] accessToken], @"accesstoken", nil ];
            
        }
        
        
        
    }
    else
    {
        NSLog(@"++++++++++++++Rest request error") ;
    }
    
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    NSData *videoData = [NSData dataWithContentsOfURL:withFileURL];
    
    
//    [httpClient postPath:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
    
    
//    NSLog(@"APP_ID %@ Secret %@ access token %@", [userDefaults objectForKey:APPID_KEY], [userDefaults objectForKey:APPSECRET_KEY], [userDefaults objectForKey:ACCESS_TOKEN_KEY]);
//    if( [userDefaults objectForKey:APPID_KEY] != nil && [userDefaults objectForKey:APPSECRET_KEY ] != nil && [userDefaults objectForKey:ACCESS_TOKEN_KEY] != nil)
//    {
//        NSURLCredential *nsCredential = [NSURLCredential credentialWithUser:[userDefaults objectForKey:APPID_KEY] password:[userDefaults objectForKey:APPSECRET_KEY] persistence:NSURLCredentialPersistenceForSession];
//        [httpClient setDefaultCredential:nsCredential];
//        if (params) {
//            if( [params objectForKey:@"accesstoken"] == nil)
//                
//                [params setObject:[userDefaults objectForKey:ACCESS_TOKEN_KEY] forKey:@"accesstoken"];
//            
//        }
//        else
//        {
//            params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[userDefaults objectForKey:ACCESS_TOKEN_KEY], @"accesstoken", nil ];
//            
//        }
//        
//    }
//    
//    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
//    NSLog(@"Upload Requesting.. URL %@", url);
    if(withFileURL)
    {
        NSLog(@"URL %@", withFileURL);
        NSLog(@"file size %d", [videoData length]);
        TFLog(@"Upload video file size %d bytes", [videoData length]);
        if(videoData)
        {
            NSLog(@"uploading data ");
            
            NSMutableURLRequest *afRequest = [httpClient multipartFormRequestWithMethod:@"POST" path:url parameters:params constructingBodyWithBlock:^(id <AFMultipartFormData>formData)
                                              {
                                                  [formData appendPartWithFileData:videoData name:@"file" fileName:@"ios-video.mp4" mimeType:@"video/mp4"];
                                                  [formData throttleBandwidthWithPacketSize:kAFUploadStream3GSuggestedPacketSize delay:kAFUploadStream3GSuggestedDelay];
                                              }];
            
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:afRequest];
            __block NSUInteger totalBytesUploaded = 0;
            [operation setUploadProgressBlock:^(NSUInteger bytesWritten,long long totalBytesWritten,long long totalBytesExpectedToWrite)
             {
                 
                 //NSLog(@"uploaded percent %f", (float)totalBytesWritten/totalBytesExpectedToWrite);
                 totalBytesUploaded += bytesWritten;
                 //[Console log:[NSString stringWithFormat:@"bytesWritten %d total bytes %lld", totalBytesUploaded, totalBytesExpectedToWrite]];
                 uploadProgress((float)(100.0*totalBytesUploaded/totalBytesExpectedToWrite));
                 
             }];
            
            [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id response)
             {
                 NSLog(@"AFN REST response %@", operation.responseString);
                 NSError *error;
                 NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
                 complete(responseData);
                 
             }
                                              failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 NSMutableDictionary *nsDError = [NSMutableDictionary dictionaryWithObjectsAndKeys:error.description, @"error",  [NSString stringWithFormat:@"%d",[operation.response statusCode]] , @"statuscode", nil];
                 TFLog(@"Upload file error %@", error.description);
                 
                 if (currentRetryCount < MAX_UPLOAD_RETRTY_COUNT)
                 {
                     currentRetryCount++;
                     [nsDError setObject:@"success" forKey:@"retrystatus"];
                     TFLog(@"Re-uploading count  %d",currentRetryCount);
                     //                     [Console alertWithTitle:[NSString stringWithFormat:@"Re-trying %d", currentRetryCount] message:nsDError.description cancelButtonTitle:@"OK"];
                     [Console alertWithTitle:@"OOPS..Its a Network Issue." message:@"Sorry for the Inconvenience. There is a Network issue, please ignore this." cancelButtonTitle:@"OK"];
                     [self uploadFileToURL:url params:params responseType:@"JSON" withFileURL:withFileURL complete:complete failure:failure uploadProgress:uploadProgress];
                     
                 }
                 else
                 {
                     [nsDError setObject:@"fail" forKey:@"retrystatus"];
                     if (failure) {
                         failure(nsDError);
                     }
                 }
                 
                 if(error.code == -1009)
                 {
                     [[NSNotificationCenter defaultCenter]
                      postNotificationName:@"networkFailureNotification"
                      object:self];
                 }
                 
             }];
            
            [httpClient enqueueHTTPRequestOperation:operation];
            
        }
    }
}
-(void)uploadFileToURL: (NSString*)url params: (NSMutableDictionary*)params responseType:(NSString*) responseType withFileData: (NSData *) fileData complete:(completeCallback)complete failure:(failureCallback)failure uploadProgress:(uploadProgressCallback)uploadProgress
{
    
    //NSData *videoData = [NSData dataWithContentsOfFile:withFileURL.absoluteString];
    NSData *videoData = fileData;
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString: url]];
    NSLog(@"APP_ID %@ Secret %@ access token %@", [userDefaults objectForKey:APPID_KEY], [userDefaults objectForKey:APPSECRET_KEY], [userDefaults objectForKey:ACCESS_TOKEN_KEY]);
    if( [userDefaults objectForKey:APPID_KEY] != nil && [userDefaults objectForKey:APPSECRET_KEY ] != nil && [userDefaults objectForKey:ACCESS_TOKEN_KEY] != nil)
    {
        NSURLCredential *nsCredential = [NSURLCredential credentialWithUser:[userDefaults objectForKey:APPID_KEY] password:[userDefaults objectForKey:APPSECRET_KEY] persistence:NSURLCredentialPersistenceForSession];
        [httpClient setDefaultCredential:nsCredential];
        if (params) {
            if( [params objectForKey:@"accesstoken"] == nil)
                
                [params setObject:[userDefaults objectForKey:ACCESS_TOKEN_KEY] forKey:@"accesstoken"];
            
        }
        else
        {
            params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[userDefaults objectForKey:ACCESS_TOKEN_KEY], @"accesstoken", nil ];
            
        }
        
    }
    
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    NSLog(@"Upload Requesting.. URL %@", url);
    if(fileData)
    {
        
        NSLog(@"file size %d", [videoData length]);
        if(videoData)
        {
            NSLog(@"uploading data ");
            
            
            NSMutableURLRequest *afRequest = [httpClient multipartFormRequestWithMethod:@"POST" path:@"" parameters:params constructingBodyWithBlock:^(id <AFMultipartFormData>formData)
                                              {
                                                  [formData appendPartWithFileData:videoData name:@"file" fileName:@"ios-video.mp4" mimeType:@"video/mp4"];
                                                  [formData throttleBandwidthWithPacketSize:kAFUploadStream3GSuggestedPacketSize delay:kAFUploadStream3GSuggestedDelay];
                                                  
                                                  
                                              }];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:afRequest];
            
            [operation setUploadProgressBlock:^(NSUInteger bytesWritten,long long totalBytesWritten,long long totalBytesExpectedToWrite)
             {
                 
                 //NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
                 //NSLog(@"uploaded percent %f", (float)totalBytesWritten/totalBytesExpectedToWrite);
                 uploadProgress((float)(100.0*totalBytesWritten/totalBytesExpectedToWrite));
                 
             }];
            [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id response)
             {
                 NSLog(@"AFN REST response %@", operation.responseString);
                 NSError *error;
                 NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
                 complete(responseData);
                 
             }
                                              failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 //NSLog(@"Failure response header %@", [[operation response] allHeaderFields]);
                 // NSDictionary *nsDError = [NSDictionary dictionaryWithObjectsAndKeys:error.description, @"error", [NSString stringWithFormat:@"%d", [operation.response statusCode]], @"statuscode", nil];
                 NSLog(@"Upload file error %@", error.description);
                 
             }];
            
            [operation start];
        }
    }
    
}
-(void)uploadImageToURL:(NSString *)url params:(NSMutableDictionary *)params responseType:(NSString *)responseType withFileData:(NSData *)fileData complete:(completeCallback)complete failure:(failureCallback)failure uploadProgress:(uploadProgressCallback)uploadProgress
{
    //NSData *videoData = [NSData dataWithContentsOfFile:withFileURL.absoluteString];
    NSData *videoData = fileData;
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    
    if ([[UserAPIKeys sharedInstance] appID]!= nil && [[UserAPIKeys sharedInstance] appSecret]!= nil &&[[UserAPIKeys sharedInstance] accessToken]!= nil ) {
        
        NSURLCredential *nsCredential = [NSURLCredential credentialWithUser:[[UserAPIKeys sharedInstance] appID] password:[[UserAPIKeys sharedInstance] appSecret] persistence:NSURLCredentialPersistenceForSession];
        [httpClient setDefaultCredential:nsCredential];
        if (params) {
            if( [params objectForKey:@"accesstoken"] == nil)
                [params setObject:[[UserAPIKeys sharedInstance] accessToken] forKey:@"accesstoken"];
            
        }
        else
        {
            params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[UserAPIKeys sharedInstance] accessToken], @"accesstoken", nil ];
            
        }
        
        
        
    }
    else
    {
        NSLog(@"++++++++++++++Rest request error") ;
    }
    
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    NSLog(@"Upload image Requesting.. URL %@",url);
    if(fileData)
    {
        
        NSLog(@"file size %d", [videoData length]);
        if(videoData)
        {
            NSLog(@"uploading data ");
            
            
            NSMutableURLRequest *afRequest = [httpClient multipartFormRequestWithMethod:@"POST" path:url parameters:params constructingBodyWithBlock:^(id <AFMultipartFormData>formData)
                                              {
                                                  [formData appendPartWithFileData:videoData name:@"file" fileName:@"ios_profile_pic.jpg" mimeType:@"image/jpeg"];
                                                  [formData throttleBandwidthWithPacketSize:kAFUploadStream3GSuggestedPacketSize delay:kAFUploadStream3GSuggestedDelay];
                                                  
                                                  
                                              }];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:afRequest];
            
            [operation setUploadProgressBlock:^(NSUInteger bytesWritten,long long totalBytesWritten,long long totalBytesExpectedToWrite)
             {
                 
                 //NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
                 //NSLog(@"uploaded percent %f", (float)totalBytesWritten/totalBytesExpectedToWrite);
                 uploadProgress((float)(100.0*totalBytesWritten/totalBytesExpectedToWrite));
                 
             }];
            [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id response)
             {
                 NSLog(@"AFN REST response %@", operation.responseString);
                 NSError *error;
                 NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
                 complete(responseData);
                 
             }
                                              failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 //NSLog(@"Failure response header %@", [[operation response] allHeaderFields]);
                 // NSDictionary *nsDError = [NSDictionary dictionaryWithObjectsAndKeys:error.description, @"error", [NSString stringWithFormat:@"%d", [operation.response statusCode]], @"statuscode", nil];
                 NSLog(@"Upload file error %@", error.description);
                 
             }];
            
            [operation start];
        }
    }
    
}

-(void)downloadFileFromURL:(NSString *)url params:(NSMutableDictionary *)params toPath:(NSString *)savePath complete:(completeCallback)complete failure:(failureCallback)failure downloadProgress:(downloadProgressCallback)downloadProgress
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    NSLog(@"Download request.. URL %@", url);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:savePath append:NO];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *requestOperation, id jsonResponse)
     {
         NSLog(@"downloading has completed");
         NSLog(@"Is file exist %@ ", [[NSFileManager defaultManager] fileExistsAtPath:savePath]? @"YES" : @"NO");
         NSError *error;
         NSDictionary *responseData;
         if( jsonResponse)
         {
             responseData = [NSJSONSerialization JSONObjectWithData:jsonResponse options:NSJSONReadingAllowFragments error:&error];
         }
         else
         {
             responseData = [[NSDictionary alloc] initWithObjectsAndKeys:@"success",@"status", nil];
         }
         complete(responseData);
     }
                                     failure:^(AFHTTPRequestOperation *requestOperation, NSError *error)
     {
         NSDictionary *nsDError = [NSDictionary dictionaryWithObjectsAndKeys:error.description, @"error", [NSString stringWithFormat:@"%d",[requestOperation.response statusCode]], @"statuscode",nil];
         failure(nsDError);
         
     }];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
     {
         //NSLog(@"Downloading %f", 100.0*totalBytesRead/totalBytesExpectedToRead);
         downloadProgress(100.0*totalBytesRead/totalBytesExpectedToRead);
     }];
    [operation start];
}

-(void) makePostRequestWithParams:(NSMutableDictionary *)params postPath:(NSString *)postPath theClient:(AFHTTPClient *)client complete:(completeCallback)complete failure:(failureCallback)failure {
    
    [client postPath:postPath parameters:params success:^(AFHTTPRequestOperation *operation, id response){
        
        NSLog(@"AFN REST response %@", operation.responseString);
        NSError *error;
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
        complete(responseData);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"AFN REST error %@", error.description);
         //NSLog(@"error is %@",error);
         if(error.code == -1009)
         {
         }
         NSDictionary *nsDError = [NSDictionary dictionaryWithObjectsAndKeys:error.description, @"error", [NSString stringWithFormat:@"%d", [operation.response statusCode]], @"statuscode", nil];
         //NSLog(@"response code %d", [operation.response statusCode]);
         failure(nsDError);
         
         if(error.code == -1009)
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"networkFailureNotification"
              object:self];
         
     }];
    
}

-(void) makeGetRequestWithParams:(NSMutableDictionary *)params postPath:(NSString *)postPath theClient:(AFHTTPClient *)client complete:(completeCallback)complete failure:(failureCallback)failure {
    
    [client getPath:postPath parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
        
        NSLog(@"AFN REST response %@", operation.responseString);
        NSLog(@"HTTP Body %@",[[NSString alloc] initWithData:operation.request.HTTPBody encoding:4]);
        NSLog(@"HTTP all headers %@", operation.request.allHTTPHeaderFields);
        
        NSError *error;
        
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
        complete(responseData);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
        if(error.code == -1009)
        {
        }
        NSDictionary *nsDError = [NSDictionary dictionaryWithObjectsAndKeys:error.description, @"error", [NSString stringWithFormat:@"%d", [operation.response statusCode]], @"statuscode", nil];
        NSLog(@"response code %d", [operation.response statusCode]);
        failure(nsDError);
        
        if(error.code == -1009)
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"networkFailureNotification"
             object:self];
        
    }] ;

}

-(void) makePutRequestWithParams:(NSMutableDictionary *)params postPath:(NSString *)postPath theClient:(AFHTTPClient *)client complete:(completeCallback)complete failure:(failureCallback)failure {
    
    [client putPath:postPath parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"AFN REST response %@", operation.responseString);
        NSError *error;
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
        complete(responseData);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
        if(error.code == -1009)
        {
        }
        NSDictionary *nsDError = [NSDictionary dictionaryWithObjectsAndKeys:error.description, @"error", [NSString stringWithFormat:@"%d", [operation.response statusCode]], @"statuscode", nil];
        NSLog(@"response code %d", [operation.response statusCode]);
        failure(nsDError);
        
        if(error.code == -1009)
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"networkFailureNotification"
             object:self];
        
    }] ;
}

-(void) makeDeleteRequestWithParams:(NSMutableDictionary *)params postPath:(NSString *)postPath theClient:(AFHTTPClient *)client complete:(completeCallback)complete failure:(failureCallback)failure {
    
    [client deletePath:@"" parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"AFN REST response %@", operation.responseString);
        NSError *error;
        NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
        complete(responseData);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
        if(error.code == -1009)
        {
        }
        NSDictionary *nsDError = [NSDictionary dictionaryWithObjectsAndKeys:error.description, @"error", [NSString stringWithFormat:@"%d", [operation.response statusCode]], @"statuscode", nil];
        //NSLog(@"response code %d", [operation.response statusCode]);
        failure(nsDError);
        
        if(error.code == -1009)
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"networkFailureNotification"
             object:self];
        
    }] ;
}


@end
