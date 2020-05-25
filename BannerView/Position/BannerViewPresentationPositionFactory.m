//
//  BannerViewPresentationPositionFactory.m
//  BannerView
//
//  Created by Brent Badhwar on 5/23/20.
//  Copyright © 2020 Brent Badhwar. All rights reserved.
//

#import "BannerViewPresentationPositionFactory.h"
#import "BannerViewPresentationPositionTop.h"
#import "BannerViewPresentationPositionBottom.h"


@implementation BannerViewPresentationPositionFactory

+(BannerViewPresentationPosition*)getBannerPositionsForType:(BannerViewPresentationPositionType)type forFrame:(CGRect)frame withSuperviewFrame:(CGRect)superviewFrame {
    switch (type) {
        case BannerViewPresentationPositionTypeTop:
            return [[BannerViewPresentationPositionTop alloc] initWithFrame:frame];
            break;
        case BannerViewPresentationPositionTypeBottom:
            return [[BannerViewPresentationPositionBottom alloc] initWithFrame:frame withSuperviewFrame: superviewFrame];
            break;
        default:
            return nil;
    }
    return nil;
}

@end
