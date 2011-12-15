//
//  MainController.h
//  Test
//
//  Created by Nicky on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol grabdata
-(void) authentication: (BOOL) authenticated;
@end

@interface MainController : UIViewController <grabdata,NSURLConnectionDelegate>{
    UITableView *table;
    NSArray *userArray;
    //NSMutableArray *dicarray;
    NSMutableData *tempData;
    NSMutableData *receivedData;
//    id<Scheduledelegate> scheduledelegate;
}

@property(nonatomic, retain) NSMutableData *receivedData;
//@property (nonatomic, retain) NSMutableArray *dicarray;
//@property (assign) id<Scheduledelegate> scheduledelegate;
@property (nonatomic, retain) IBOutlet UITableView *table;
-(IBAction)login:(id)sender;
@end
