//
//  Course.h
//  MyCSUF
//
//  Created by Bert Aguilar on 10/10/11.
//  Copyright (c) 2011 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Course : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * courseName;
@property (nonatomic, retain) NSString * courseTime;
@property (nonatomic, retain) NSString * teacher;
@property (nonatomic, retain) NSString * room;
@property (nonatomic, retain) NSString * courseNumber;

@end
