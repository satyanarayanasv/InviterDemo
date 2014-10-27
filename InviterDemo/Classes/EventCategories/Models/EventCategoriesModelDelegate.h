//
//  EventCategoriesModelDelegate.h
//  InwiterTEST
//
//  Created by Inwiter on 20/08/14.
//  Copyright (c) 2014 Inwiter. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EventCategoriesModelDelegate <NSObject>
/**  Set the loaded   EventCategoriesModeArray form EventCategoriesModel to EventCategoriesController
 
 @param array Which contains the  EventCategoriesModels  .
 */
-(void) loadedEventCategoriesWithArray:(NSMutableArray *)array ;
/**
 * This method will be invoked when there was error while getting event categories
 * @param error Holds error message
 */
-(void) receivedErrorOnEventCategories:(NSDictionary*) error;
@end
