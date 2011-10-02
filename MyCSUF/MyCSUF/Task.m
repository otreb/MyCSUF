//
//  Task.m
//  MyCSUF
//
//  Created by Ismael Martinez on 9/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Task.h"


@implementation Task
@dynamic date;
@dynamic title;
@dynamic notes;
@dynamic priority;
@dynamic category;

+ (NSArray *)todoListForCategory:(Category *)category inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *requestor = [[[NSFetchRequest alloc] init] autorelease];
    requestor.entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:context];
    requestor.predicate = [NSPredicate predicateWithFormat:@"category = %@",category];
    
    return [context executeFetchRequest:requestor error:NULL];
}

+ (Task *)addTodoItem:(NSDictionary *)items withCategory:(Category *)cat inMangedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *requestor = [[[NSFetchRequest alloc] init] autorelease];
    requestor.entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:context];
    requestor.predicate = [NSPredicate predicateWithFormat:@"category = %@",cat];
    
    NSError *error = nil;
    Task *todo = [[context executeFetchRequest:requestor error:&error] lastObject];
    if (!todo && !error) {
        todo = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];
        todo.title = [items objectForKey:@"title"];
        todo.notes = [items objectForKey:@"notes"];
        todo.priority = [items objectForKey:@"priority"];
        todo.date = [items objectForKey:@"date"];
        todo.category = cat;
        [self saveData:context];
    }
    return todo;
}

+ (void)saveData:(NSManagedObjectContext *)context
{
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"%@",[error description]);
    }
}

@end
