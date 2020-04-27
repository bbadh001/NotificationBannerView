//
//  FloatingBannerView.m
//  BannerView
//
//  Created by Brent Badhwar on 4/26/20.
//  Copyright © 2020 Brent Badhwar. All rights reserved.
//

#import "FloatingBannerView.h"

@interface FloatingBannerView ()

@end

@implementation FloatingBannerView 

-(instancetype)init {
    self = [super init];
    if (self != nil) {
        self.panHandler = [[PanGestureHandler alloc] init];
        self.panHandler.delegate = self;
        self.animator = [[Animator alloc] init];
    }
    return self;
}






@end
