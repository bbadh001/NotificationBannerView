//
//  BannerViewPresentationPositionTop.m
//  BannerView
//
//  Created by Brent Badhwar on 5/23/20.
//  Copyright © 2020 Brent Badhwar. All rights reserved.
//

#import "BannerViewPresentationPositionTop.h"

@implementation BannerViewPresentationPositionTop

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        self.presentationPosition = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.hiddenPosition = CGRectMake(0, -frame.size.height, frame.size.width, frame.size.height);
    }
    return self;
}

@end
