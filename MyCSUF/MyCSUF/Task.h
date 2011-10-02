//
//  Task.h
//  MyCSUF
//
//  Created by Ismael Martinez on 9/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Category.h"

@interface Task : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) NSManagedObject *category;

+ (NSArray *)todoListForCategory:(Category *)category inManagedObjectContext:(NSManagedObjectContext *)context;

+ (Task *)addTodoItem:(NSDictionary *)items withCategory:(Category *)cat inMangedObjectContext:(NSManagedObjectContext *)context;

+ (void)saveData:(NSManagedObjectContext *)context;

@end
