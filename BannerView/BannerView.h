//
//  BannerView.h
//  BannerView
//
//  Created by Brent Badhwar on 4/24/20.
//  Copyright © 2020 Brent Badhwar. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum BannerPresentationStateType {
    AnimatingIn,
    Presenting,
    AnimatingOut,
    Hidden
} BannerPresentationState;

@interface BannerView : UIView

@property (nonatomic, readonly) BOOL isPresenting;

- (instancetype)initWithTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle parentView:(UIView *)parentView;

-(void)present;
-(void)dismiss;


@end

NS_ASSUME_NONNULL_END
