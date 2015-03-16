//
//  MessagesController.h
//  BalaSimple
//
//  Created by LebinJiang on 15/3/10.
//  Copyright (c) 2015年 kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface MessagesController : UITableViewController<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) NSMutableArray* messages;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
- (void) addTextMessage: (NSString*) message;
- (void) addImageMessage:(UIImage*) image imageURL:(NSURL*) url;
@end
