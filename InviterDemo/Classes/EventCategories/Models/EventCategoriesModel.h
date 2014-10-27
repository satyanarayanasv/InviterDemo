//
//  EventCategoriesModel.h
//  InwiterTEST
//
//  Created by Inwiter on 7/28/14.
//  Copyright (c) 2014 Inwiter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel+networking.h"
#import "HTTPRequester.h"

#import "EventCategoriesModelDelegate.h"

/** EventCategoriesModel which make calls to php and get data
 */
@interface EventCategoriesModel : JSONModel

{
    NSString *_categoryIconURL;
    
}
/** categoryName
 */
@property (strong, nonatomic) NSString  <Optional> *name;

/** categoryColor
 */
@property (strong, nonatomic) NSString   <Optional> *categoryColor;

/** categoryIconUrl
 */
@property (strong, nonatomic) NSString  <Optional> *categoryIconURL;
@property (strong, nonatomic) NSURL  <Ignore> *categoryImageURL;

/** categoryID
 */
@property (strong, nonatomic) NSString  <Optional> *categoryID;
//@property (strong, nonatomic) NSString  <Optional> *selected;
//@property (strong, nonatomic) NSString  <Optional> *date;


@property (strong,nonatomic) id <EventCategoriesModelDelegate,Ignore> delegate ;

/** Which can make a rest request to EventCategories
 */
-(void) loadEventCategories  ;
@end
