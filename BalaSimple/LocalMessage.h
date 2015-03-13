//
//  LocalMessage.h
//  BalaSimple
//
//  Created by LebinJiang on 15/3/13.
//  Copyright (c) 2015年 kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
    MessageTypeText,
    MessageTypeImage,
    MessageTypeNon
}MessageType;

@interface LocalMessage : NSObject
- (instancetype) initWithText:(NSString*) msg;
- (instancetype) initWithImage:(UIImage*) image imageURL:(NSURL*)url;

@property (nonatomic) MessageType tag;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) NSURL * imageURL;
@property (nonatomic, strong) UIImage* portriat;
@property (nonatomic, strong) NSURL * portriatURL;
@property (nonatomic, strong) UIImage* image;
@property (nonatomic, strong) NSDate * time;
@property (nonatomic, strong) NSString *email;
@end
