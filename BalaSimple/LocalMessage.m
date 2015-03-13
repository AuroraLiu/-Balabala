//
//  LocalMessage.m
//  BalaSimple
//
//  Created by LebinJiang on 15/3/13.
//  Copyright (c) 2015年 kingsoft. All rights reserved.
//

#import "LocalMessage.h"

@implementation LocalMessage

- (instancetype) init{
    self = [super init];
    if (self != nil) {
        _tag = MessageTypeNon;
        _text = nil;
        _imageURL = nil;
        _image = nil;
        _time = [NSDate date];
        _email = nil;
    }
    return self;
}

- (instancetype) initWithText:(NSString*) msg{
    self = [super init];
    if (self != nil) {
        _tag = MessageTypeText;
        _text = msg;
        _time = [NSDate date];
    }
    return self;
}

- (instancetype) initWithImage:(UIImage*) image imageURL:(NSURL*)url;{
    self = [super init];
    if (self != nil) {
        _tag = MessageTypeImage;
        _image = image;
        _imageURL = url;
        _time = [NSDate date];
    }
    return self;
}

@end
