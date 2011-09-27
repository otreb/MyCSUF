//
//  DelegeMethods.h
//  MyCSUF
//
//  Created by Ismael Martinez on 9/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#ifndef MyCSUF_DelegeMethods_h
#define MyCSUF_DelegeMethods_h

@protocol NewTodoDelegate

- (void)updateTitleField:(NSString *)title;
- (void)updateDateField:(NSDate *)date;
- (void)updateReminderField:(NSString *)reminder;

@end

#endif
