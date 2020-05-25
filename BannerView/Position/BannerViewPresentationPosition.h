//
//  BannerViewPresentationPosition.h
//  BannerView
//
//  Created by Brent Badhwar on 5/23/20.
//  Copyright © 2020 Brent Badhwar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BannerViewPresentationPosition : NSObject

@property (nonatomic) CGRect presentationPosition;
@property (nonatomic) CGRect hiddenPosition;

-(instancetype)initWithFrame:(CGRect)frame withSuperviewFrame:(CGRect)superviewFrame;

@end

NS_ASSUME_NONNULL_END
