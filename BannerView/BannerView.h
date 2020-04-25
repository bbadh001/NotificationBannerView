//
//  BannerView.h
//  BannerView
//
//  Created by Brent Badhwar on 4/24/20.
//  Copyright © 2020 Brent Badhwar. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BannerView : UIView

@property (nonatomic, readonly) UIView* mainTitle;
@property (nonatomic, readonly) UIView* subTitle;

-(instancetype)init:(NSString*)mainTitle subTitle:(NSString*)subTitle;

-(void)show;
-(void)dismiss;


@end

NS_ASSUME_NONNULL_END
