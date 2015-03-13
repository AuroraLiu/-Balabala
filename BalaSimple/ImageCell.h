//
//  ImageCell.h
//  BalaSimple
//
//  Created by LebinJiang on 15/3/13.
//  Copyright (c) 2015年 kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCell : UITableViewCell
@property (nonatomic, strong) NSURL* imageURL;
@property (strong, nonatomic) NSNumber* colorIndex;
- (NSNumber*) height;
@end
