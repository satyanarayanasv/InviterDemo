//
//  EventCategoriesModel.m
//  InwiterTEST
//
//  Created by Inwiter on 7/28/14.
//  Copyright (c) 2014 Inwiter. All rights reserved.
//

#import "EventCategoriesModel.h"

@implementation EventCategoriesModel
@synthesize delegate ;
@synthesize name;
@synthesize categoryColor;
@synthesize categoryImageURL;
@synthesize categoryID;
-(void) loadEventCategories {
    
    
    HTTPRequester *hTTPRequester = [[HTTPRequester alloc] init] ;
    NSMutableDictionary *params = [[ NSMutableDictionary alloc] init];
    
    [params setObject:@"greeting" forKey:@"categoryType"];
    
    [hTTPRequester makeRESTHTTPRequest:@"geteventcategories" method:HTTPRequester.GET params:params responseType:@"JSON" complete:^(NSDictionary *response) {
        
        NSLog(@"loadGreetingCategories response %@",[EventCategoriesModel arrayOfModelsFromDictionaries:[response objectForKey:@"data"]]);
        if (delegate) {
            [delegate loadedEventCategoriesWithArray:[EventCategoriesModel arrayOfModelsFromDictionaries:[response objectForKey:@"data"]]];
        }
        
    } failure:^(NSDictionary *nsDError) {
        if (delegate) {
            [delegate receivedErrorOnEventCategories:nsDError];
        }
    }];
    
    
}

-(void)setCategoryIconURL:(NSString<Optional> *)argCategoryIconURL
{
    _categoryIconURL = argCategoryIconURL;
    self.categoryImageURL = [NSURL URLWithString: self.categoryIconURL];
    
}

@end
