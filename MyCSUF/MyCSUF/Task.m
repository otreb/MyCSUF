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
    NSMutableArray *temp = nil;
    NSFetchRequest *requestor = [[NSFetchRequest alloc] init];
    requestor.entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:context];
    requestor.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:
                           [NSArray arrayWithObjects:
                            [NSPredicate predicateWithFormat:@"category = %@",category],
                            [NSPredicate predicateWithFormat:@"priority = 2"],nil]]
                           ;
    requestor.sortDescriptors = [NSArray arrayWithObjects:
                                 [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES], nil];
    temp = [NSMutableArray arrayWithObject:[context executeFetchRequest:requestor error:NULL]];
    requestor.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:
                           [NSArray arrayWithObjects:
                            [NSPredicate predicateWithFormat:@"category = %@",category],
                            [NSPredicate predicateWithFormat:@"priority = 1"],nil]]
    ;
    [temp addObject:[context executeFetchRequest:requestor error:NULL]];
    requestor.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:
                           [NSArray arrayWithObjects:
                            [NSPredicate predicateWithFormat:@"category = %@",category],
                            [NSPredicate predicateWithFormat:@"priority = 0"],nil]]
    ;
    [temp addObject:[context executeFetchRequest:requestor error:NULL]];
    [requestor release];
    return temp;//[context executeFetchRequest:requestor error:NULL];
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
