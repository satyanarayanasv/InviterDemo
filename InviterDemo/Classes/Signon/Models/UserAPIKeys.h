//
//  UserAPIKeys.h
//  InwiterTEST
//
//  Created by Inwiter on 7/12/14.
//  Copyright (c) 2014 Inwiter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel+networking.h"
#import "HTTPRequester.h"


@class UserAPIKeys ;
@protocol UserAPIKeysrDelegate <NSObject>

@optional
-(void) setUserAPIKeys:(UserAPIKeys *)delegateUserAPIKeys failure:(NSDictionary *)error ;

@end

@interface UserAPIKeys : JSONModel

@property (strong, nonatomic) NSString *userID ;
@property (strong, nonatomic) NSString *appID;
@property (strong, nonatomic) NSString *appSecret;
@property (strong, nonatomic) NSString *accessToken;

@property(nonatomic,strong) id  <UserAPIKeysrDelegate,Ignore> delegate;


//-(void) getUserAPIKeyswithUserID:(NSString *)userID ;
+(UserAPIKeys*) sharedInstance ;

@end
