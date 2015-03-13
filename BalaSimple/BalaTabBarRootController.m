//
//  BalaTabBarRootController.m
//  BalaSimple
//
//  Created by LebinJiang on 15/3/10.
//  Copyright (c) 2015年 kingsoft. All rights reserved.
//

#import "BalaTabBarRootController.h"
#include "AppDelegate.h"

@implementation BalaTabBarRootController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication];
    [appDelegate saveContext];
}

@end
