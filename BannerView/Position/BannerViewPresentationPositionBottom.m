//
//  BannerViewPresentationPositionBottom.m
//  BannerView
//
//  Created by Brent Badhwar on 5/24/20.
//  Copyright © 2020 Brent Badhwar. All rights reserved.
//

#import "BannerViewPresentationPositionBottom.h"

@implementation BannerViewPresentationPositionBottom

-(instancetype)initWithFrame:(CGRect)frame withSuperviewFrame:(CGRect)superviewFrame {
    self = [super init];
    if (self) {
        self.hiddenPosition =       CGRectMake(0,
                                               superviewFrame.size.height,
                                               frame.size.width,
                                               frame.size.height
        );
        self.presentationPosition = CGRectMake(0,
                                               superviewFrame.size.height-frame.size.height,
                                               frame.size.width,
                                               frame.size.height
        );
    }
    
    return self;
}

@end
