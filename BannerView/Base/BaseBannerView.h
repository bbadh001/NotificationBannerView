//
//  BaseBannerView.h
//  BannerView
//
//  Created by Brent Badhwar on 4/24/20.
//  Copyright © 2020 Brent Badhwar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerPresentationState.h"
#import "Animator.h"
#import "PanGestureHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseBannerView : UIView

@property (nonatomic) PanGestureHandler* panHandler;
@property (nonatomic) Animator* animator;

- (instancetype)initWithTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle;

-(void)present;
-(void)dismiss;

@end

NS_ASSUME_NONNULL_END
