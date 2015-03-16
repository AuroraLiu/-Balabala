//
//  ImageCell.m
//  BalaSimple
//
//  Created by LebinJiang on 15/3/13.
//  Copyright (c) 2015年 kingsoft. All rights reserved.
//

#import "ImageCell.h"
#import "UIImage+Utils.h"

static const int avatarH = 32;
static const int pad = 5;
static const int len = 150;

@implementation ImageCell

- (void)dealloc{
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(pad, pad, avatarH, avatarH)];
        [self.contentView addSubview:self.avatarImageView];
        
        CALayer * layer = [self.avatarImageView layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:self.avatarImageView.frame.size.width/2.0];
    }
    return self;
}

- (void)layoutSubviews{
    CGFloat len = 120;//self.frame.size.width-3*pad+avatarH;
    self.imageView.frame = CGRectMake(2*pad+avatarH, pad, len, len);
    self.avatarImageView.frame = CGRectMake(pad, len - avatarH, avatarH, avatarH);
}

- (NSNumber*)height{
    return [NSNumber numberWithDouble:len+2*pad];
}

- (void) loadImage{
   // dispatch_queue_t queue = dispatch_queue_create("loadImage",NULL);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"imageURL:%@\npURL:%@"
              ,self.message.imageURL
              ,self.message.portriatURL);
        if (self.message.image == nil && self.message.imageURL != nil) {
            NSData* data = [NSData dataWithContentsOfURL:self.message.imageURL];
            self.message.image = [[UIImage imageWithData:data] scaleToSize:CGSizeMake(len, len)];
        }
        if (self.message.portriat == nil && self.message.portriatURL != nil) {
            NSData* pData = [NSData dataWithContentsOfURL:self.message.portriatURL];
            self.message.portriat = [[UIImage imageWithData:pData] scaleToSize:CGSizeMake(avatarH, avatarH)];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            self.avatarImageView.image = self.message.portriat;
            self.imageView.image = self.message.image;
        });
    });
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
