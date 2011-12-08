//
//  DelegeMethods.h
//  MyCSUF
//
//  Created by Ismael Martinez on 9/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "Category.h"

#ifndef MyCSUF_DelegeMethods_h
#define MyCSUF_DelegeMethods_h

@protocol NewTodoDelegate

- (void)updateTitleField:(NSString *)title;
- (void)updateDateField:(NSDate *)date;
- (void)updateAlertField:(NSString *)alert;
- (void)updateNotesField:(NSString *)notes;
- (void)updateCategoryField:(Category *)category;

@end

@protocol ListDelegate

- (void)listCreated;

@end

#endif
