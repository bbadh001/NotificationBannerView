//
//  BannerView.h
//  BannerView
//
//  Created by Brent Badhwar on 4/24/20.
//  Copyright © 2020 Brent Badhwar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerPresentationState.h"

NS_ASSUME_NONNULL_BEGIN

@interface BannerView : UIView

- (instancetype)initWithTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle parentView:(UIView *)parentView;

-(void)present:(UIViewController*)vc;
-(void)dismiss;

@end

NS_ASSUME_NONNULL_END
