//
//  Category.m
//  MyCSUF
//
//  Created by Ismael Martinez on 9/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Category.h"
#import "Task.h"


@implementation Category
@dynamic name;
@dynamic task;
@dynamic fontColor;

+ (NSArray *)myCurrentList:(NSManagedObjectContext *)context
{
    NSFetchRequest *requestor = [[[NSFetchRequest alloc] init] autorelease];
    requestor.entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:context];
    requestor.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    return [context executeFetchRequest:requestor error:NULL];
}

+ (Category *)createNewCategory:(NSString *)categoryName withColor:(NSString *)colorType withManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *requestor = [[NSFetchRequest alloc] init];
    requestor.entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:context];
    requestor.predicate = [NSPredicate predicateWithFormat:@"name = %@", categoryName];
    
    NSError *error = nil;
    Category *category = nil;
    category = [[context executeFetchRequest:requestor error:&error] lastObject];
    [requestor release];
    if (!category && !error) {
        category = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:context];
        category.name = categoryName;
        category.fontColor = colorType;
        [self saveData:context];
    }
    return category;
}

+ (void)saveData:(NSManagedObjectContext *)context
{
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"%@",[error description]);
    }
}

@end
