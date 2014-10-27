//
//  BaseURLS.h
//  InwiterDev
//
//  Created by Inwiter on 9/4/13.
//  Copyright (c) 2013 Inwiter. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define BASE_URL @"http://inwiter.com/v1.1.0"
//#define HOST_URL @"http://inwiter.com"

#define BASE_URL @"http://test.inviter.com/"
#define HOST_URL @"http://test.inviter.com/"

@interface BaseURLS : NSObject


+(NSURL *)getAbsoluteURLByURL:(NSURL *)url ;
+(NSURL *)getAbsoluteURLByString:(NSString *)string ;
@end