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
@dynamic alert;
@dynamic complete;


+ (NSArray *)todoListForCategory:(Category *)category inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSMutableArray *temp = nil;
    NSFetchRequest *requestor = [[NSFetchRequest alloc] init];
    requestor.entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:context];
    requestor.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:
                           [NSArray arrayWithObjects:
                            [NSPredicate predicateWithFormat:@"category = %@",category],
                            [NSPredicate predicateWithFormat:@"priority = 2"],
                            [NSPredicate predicateWithFormat:@"complete = %@", [NSNumber numberWithBool:NO]],nil]]
                           ;
    requestor.sortDescriptors = [NSArray arrayWithObjects:
                                 [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES], nil];
    temp = [NSMutableArray arrayWithObject:[context executeFetchRequest:requestor error:NULL]];
    requestor.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:
                           [NSArray arrayWithObjects:
                            [NSPredicate predicateWithFormat:@"category = %@",category],
                            [NSPredicate predicateWithFormat:@"priority = 1"],
                            [NSPredicate predicateWithFormat:@"complete = %@", [NSNumber numberWithBool:NO]],nil]]
    ;
    [temp addObject:[context executeFetchRequest:requestor error:NULL]];
    requestor.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:
                           [NSArray arrayWithObjects:
                            [NSPredicate predicateWithFormat:@"category = %@",category],
                            [NSPredicate predicateWithFormat:@"priority = 0"],
                            [NSPredicate predicateWithFormat:@"complete = %@", [NSNumber numberWithBool:NO]],nil]]
    ;
    [temp addObject:[context executeFetchRequest:requestor error:NULL]];
    [requestor release];
    return temp;
}

+ (Task *)addTodoItem:(NSDictionary *)items withCategory:(Category *)cat inMangedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *requestor = [[[NSFetchRequest alloc] init] autorelease];
    requestor.entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:context];
    requestor.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:
                           [NSArray arrayWithObjects:
                            [NSPredicate predicateWithFormat:@"category = %@",cat],
                            [NSPredicate predicateWithFormat:@"title = %@", [items objectForKey:@"title"]],nil]];
    
    NSError *error = nil;
    Task *todo = [[context executeFetchRequest:requestor error:&error] lastObject];
    if (!todo && !error) {
        todo = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];
        todo.title = [items objectForKey:@"title"];
        todo.date = [items objectForKey:@"date"];
        todo.alert = [items objectForKey:@"alert"];
        todo.notes = [items objectForKey:@"notes"];
        todo.priority = [items objectForKey:@"priority"];
        todo.category = cat;
        todo.complete = [NSNumber numberWithBool:NO];
        [self saveData:context];
    }
    return todo;
}

+ (Task *)editTodoItem:(Task *)task withNewInformation:(NSDictionary *)items inMangedObjectContext:(NSManagedObjectContext *)context
{
    task.title = [items objectForKey:@"title"];
    task.date = [items objectForKey:@"date"];
    task.alert = [items objectForKey:@"alert"];
    task.notes = [items objectForKey:@"notes"];
    task.priority = [items objectForKey:@"priority"];
    task.complete = [NSNumber numberWithBool:NO];
    [self saveData:context];
    return task;
}

+ (void)markTaskAsComplete:(Task *)task inManagedObjectContext:(NSManagedObjectContext *)context
{
    task.complete = [NSNumber numberWithBool:YES];
    [self saveData:context];
}

+ (void)saveData:(NSManagedObjectContext *)context
{
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"%@",[error description]);
    }
}

@end
