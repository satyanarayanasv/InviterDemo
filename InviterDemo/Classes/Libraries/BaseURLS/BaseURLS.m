//
//  BaseURLS.m
//  InwiterDev
//
//  Created by Inwiter on 9/4/13.
//  Copyright (c) 2013 Inwiter. All rights reserved.
//

#import "BaseURLS.h"

@implementation BaseURLS


+(NSURL *)getAbsoluteURLByString:(NSString *)string {
    
    NSURL *url = [NSURL URLWithString:string];
    NSLog(@"video URL scheme %@ host %@", url.scheme, url.host);
    if (!url.scheme && !url.host) {
        NSString *videoURLString = [NSString stringWithFormat:@"%@%@", BASE_URL, url.absoluteString];
        url = [NSURL URLWithString:videoURLString];
    }
    return url ;
}

+(NSURL *)getAbsoluteURLByURL:(NSURL *)url {
    
    
    NSLog(@"video URL scheme %@ host %@", url.scheme, url.host);
    if (!url.scheme && !url.host) {
        NSString *videoURLString = [NSString stringWithFormat:@"%@%@", BASE_URL, url.absoluteString];
        url = [NSURL URLWithString:videoURLString];
    }
    return url ;
}
@end
