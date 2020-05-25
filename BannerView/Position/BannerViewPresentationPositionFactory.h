//
//  BannerViewPresentationPositionFactory.h
//  BannerView
//
//  Created by Brent Badhwar on 5/23/20.
//  Copyright © 2020 Brent Badhwar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BannerViewPresentationPosition.h"
#import "BannerViewPresentationPositionType.h"

NS_ASSUME_NONNULL_BEGIN

@interface BannerViewPresentationPositionFactory : NSObject

+(BannerViewPresentationPosition*)getBannerPositionsForType:(BannerViewPresentationPositionType)type forFrame:(CGRect)frame withSuperviewFrame:(CGRect)superviewFrame;

@end

NS_ASSUME_NONNULL_END
