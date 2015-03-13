//
//  PeoplesController.h
//  BalaSimple
//
//  Created by LebinJiang on 15/3/10.
//  Copyright (c) 2015年 kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface PeoplesController : UITableViewController
@property(strong, nonatomic) NSMutableArray* friends;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
- (void) addFriend: (NSString*) friend;
@end
