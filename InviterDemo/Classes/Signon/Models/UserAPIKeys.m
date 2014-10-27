//
//  UserAPIKeys.m
//  InwiterTEST
//
//  Created by Inwiter on 7/12/14.
//  Copyright (c) 2014 Inwiter. All rights reserved.
//

#import "UserAPIKeys.h"

@implementation UserAPIKeys
@synthesize delegate ;
@synthesize userID ;
@synthesize appID ;

+(UserAPIKeys*) sharedInstance{
    static dispatch_once_t onceToken;
    static UserAPIKeys *userAPIKeys= nil ;
    dispatch_once(&onceToken, ^{
        userAPIKeys = [[self alloc] init];
    });
    return userAPIKeys;
}



@end
