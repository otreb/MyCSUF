//
//  TodoListTableViewCell.h
//  MyCSUF
//
//  Created by Ismael Martinez on 10/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodoListTableViewCell : UITableViewCell {
    UILabel *title;
    UILabel *dateMonth;
    UILabel *dateTime;
    UILabel *notes;
}

@property (retain) IBOutlet UILabel *title;
@property (retain) IBOutlet UILabel *dateMonth;
@property (retain) IBOutlet UILabel *dateTime;
@property (retain) IBOutlet UILabel *notes;

@end
