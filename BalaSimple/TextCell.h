//
//  TextCell.h
//  BalaSimple
//
//  Created by LebinJiang on 15/3/12.
//  Copyright (c) 2015年 kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextCell : UITableViewCell
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) NSNumber* colorIndex;
- (NSNumber*) height;
@end
