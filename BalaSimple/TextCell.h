//
//  TextCell.h
//  BalaSimple
//
//  Created by LebinJiang on 15/3/12.
//  Copyright (c) 2015年 kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalMessage.h"
#import "MessagesController.h"

@interface TextCell : UITableViewCell
@property (weak,nonatomic) MessagesController* messageController;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (nonatomic, strong) LocalMessage* message;
@property (strong, nonatomic) NSNumber* colorIndex;
- (NSNumber*) height;
@end
