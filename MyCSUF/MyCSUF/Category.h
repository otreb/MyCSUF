//
//  Category.h
//  MyCSUF
//
//  Created by Ismael Martinez on 9/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface Category : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *task;
@property (nonatomic, retain) NSString * fontColor;

+ (NSArray *)myCurrentList:(NSManagedObjectContext *)context;
+ (Category *)createNewCategory:(NSString *)categoryName withColor:(NSString *)colorType withManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)saveData:(NSManagedObjectContext *)context;

@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addTaskObject:(Task *)value;
- (void)removeTaskObject:(Task *)value;
- (void)addTask:(NSSet *)values;
- (void)removeTask:(NSSet *)values;

@end
