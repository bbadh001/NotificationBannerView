//
//  BannerView.m
//  BannerView
//
//  Created by Brent Badhwar on 4/24/20.
//  Copyright © 2020 Brent Badhwar. All rights reserved.
//

#import "BannerView.h"

@interface BannerView ()

@property (weak) UIViewController* parentView;

@property (nonatomic) CGFloat mainTitleLabelTopPadding;
@property (nonatomic) CGFloat subTitleLabelTopPadding;

@end

@implementation BannerView

-(void)setupBannerConstraints {
    
}

-(void)setupLabels:(NSString*)mainTitle subTitle:(NSString*)subTitle {
    self.mainTitleLabelTopPadding = (CGFloat) 8.0;
    self.subTitleLabelTopPadding = (CGFloat) 8.0;
    
    UILabel* mainTitleLabel = [UILabel new];
    mainTitleLabel.text = mainTitle;
    UILabel* subTitleLabel = [UILabel new];
    subTitleLabel.text = subTitle;
    
    [self addSubview: mainTitleLabel];
    [self addSubview: subTitleLabel];
    
    NSArray* mainTitleLabelConstraints = [NSArray arrayWithObjects: [NSLayoutConstraint constraintWithItem:mainTitle attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.parentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0], [NSLayoutConstraint constraintWithItem:mainTitle attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.parentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0], nil];
    
    [NSLayoutConstraint activateConstraints:mainTitleLabelConstraints];
    [self addConstraints:mainTitleLabelConstraints];
}

- (instancetype)init:(NSString *)mainTitle subTitle:(NSString *)subTitle {
    if (self = [super init]) {
        [self setupLabels:mainTitle subTitle:subTitle];
    }
    
    return self;
}

#pragma mark Instance Methods

-(void)show {
    
}

-(void)dismiss {
    
}

@end
