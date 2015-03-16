//
//  TextCell.m
//  BalaSimple
//
//  Created by LebinJiang on 15/3/12.
//  Copyright (c) 2015年 kingsoft. All rights reserved.
//

#import "TextCell.h"
#include "UIImage+Utils.h"

static const int avatarH = 32;
static const int pad = 5;
static const int messagePad = 8;

@interface TextCell ()
+ (UIImage*) grayBubble;
- (UIColor*) getColor;
@end


@implementation TextCell{
    UIImageView* messageBackgroundView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        self.textLabel.font = [UIFont systemFontOfSize:14.0f];
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 0;
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.textColor = [UIColor whiteColor];
        
        messageBackgroundView = [[UIImageView alloc] initWithFrame:self.textLabel.frame];
        [self.contentView insertSubview:messageBackgroundView belowSubview:self.textLabel];

        self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(pad, pad, avatarH, avatarH)];
        
        [self.contentView addSubview:self.avatarImageView];
        
        CALayer * layer = [self.avatarImageView layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:self.avatarImageView.frame.size.width/2.0];
        
        self.colorIndex = [[NSNumber alloc] initWithInt:0];
    }
    return self;
}

+ (UIImage*) grayBubble{
    static UIImage* bubbleImage = nil;
    if (bubbleImage == nil) {
        bubbleImage = [UIImage imageNamed:@"MessageBubble"];
    }
    return bubbleImage;
}

- (UIColor*) getColor{
    int index = [self.colorIndex intValue] % 8;
    static CGFloat colors[8][4]  = {
        {0.5804,0.7216,0.9098,1},
        {0.8784,0.5059,0.4902,1},
        {0.7137,0.8157,0.4941,1},
        {0.5843,0.4902,0.7098,1},
        {0.3608,0.7451,0.8392,1},
        {0.9686,0.6314,0.3373,1},
        {0.6510,0.7608,0.9020,1},
        {0.9020,0.6431,0.6353,1},
    };
    UIColor* color = [UIColor colorWithRed:colors[index][0]
                                     green:colors[index][1]
                                      blue:colors[index][2]
                                     alpha:colors[index][3]];
    
    return color;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize labelSize =[self.textLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width - (avatarH + 4*pad + 2*messagePad) , MAXFLOAT)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14.0f] }
                                                        context:nil].size;
    
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x = avatarH + 2*pad + messagePad;
    textLabelFrame.origin.y = pad + messagePad;
    textLabelFrame.size.width = labelSize.width;
    textLabelFrame.size.height = labelSize.height;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            self.frame.size.width,
                            2*pad+MAX(labelSize.height+2*messagePad,avatarH));
    
    self.textLabel.frame = textLabelFrame;
    messageBackgroundView.frame = CGRectMake(avatarH + 2*pad, pad, labelSize.width + 2*messagePad,labelSize.height + 2*messagePad);
    
    self.avatarImageView.frame=CGRectMake(pad, self.frame.size.height-pad-avatarH, avatarH, avatarH);
    
    
    UIEdgeInsets insets = UIEdgeInsetsMake(17, 26.5, 17.5, 21);
    UIImage *coloredImage = [[TextCell grayBubble]  maskWithColor:[self getColor]];
    
    coloredImage = [UIImage
                   imageWithCGImage: [coloredImage CGImage]
                   scale: 1
                   orientation:UIImageOrientationUpMirrored];

    messageBackgroundView.image = [coloredImage resizableImageWithCapInsets:insets];
    
    self.avatarImageView.image = [UIImage imageNamed:@"Inori"];
}

- (NSNumber*)height{
    CGSize labelSize =[self.textLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width - (avatarH + 4*pad + 2*messagePad) , MAXFLOAT)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14.0f] }
                                                        context:nil].size;
    return [NSNumber numberWithDouble:labelSize.height+2*pad+2*messagePad];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
