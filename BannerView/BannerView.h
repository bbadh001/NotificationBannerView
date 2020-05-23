//
//  BannerView.h
//  BannerView
//
//  Created by Brent Badhwar on 4/24/20.
//  Copyright © 2020 Brent Badhwar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerPresentationState.h"
//#import "BannerViewStyleSuccess.h"

NS_ASSUME_NONNULL_BEGIN

@interface BannerView : UIView

- (instancetype)initWithTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle;

-(void)presentOnView:(UIView*)view;
-(void)dismiss;

/// unavailable API
-(void)setFrame:(CGRect)frame     __attribute__((unavailable("frame is calculated based on content size.")));
-(void)setBounds:(CGRect)bounds   __attribute__((unavailable("bounds is calculated based on content size.")));
-(void)addSubview:(UIView *)view  __attribute__((unavailable("use leftView and rightView properties to add a custom view.")));

@end

NS_ASSUME_NONNULL_END
