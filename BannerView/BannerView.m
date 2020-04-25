//
//  BannerView.m
//  BannerView
//
//  Created by Brent Badhwar on 4/24/20.
//  Copyright © 2020 Brent Badhwar. All rights reserved.
//

#import "BannerView.h"

@interface BannerView ()

#define kPresentingAnimationTimeInSeconds 1.0

@property (nonatomic, weak) UIView* parentView;

@property (nonatomic) BOOL isPresenting;

@property (nonatomic) CGFloat mainTitleLabelTopPadding;
@property (nonatomic) CGFloat subTitleLabelTopPadding;
@property (nonatomic) CGFloat bannerHeight;

@end

@implementation BannerView

-(void)setupLabels:(NSString*)mainTitle subTitle:(NSString*)subTitle {
    UILabel* mainTitleLabel = [UILabel new];
    mainTitleLabel.text = mainTitle;
    mainTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    UILabel* subTitleLabel = [UILabel new];
    subTitleLabel.text = subTitle;
    
    [self addSubview: mainTitleLabel];
    [self addSubview: subTitleLabel];
    
    NSArray* mainTitleLabelConstraints = [NSArray arrayWithObjects: [NSLayoutConstraint constraintWithItem:mainTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0], [NSLayoutConstraint constraintWithItem:mainTitleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0], nil];
    
    [NSLayoutConstraint activateConstraints:mainTitleLabelConstraints];
    [self addConstraints:mainTitleLabelConstraints];
}

- (instancetype)initWithTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle parentView:(UIView *)parentView {
    self = [super init];
    if (self != nil) {
        self.parentView = parentView;
        self.mainTitleLabelTopPadding = (CGFloat) 8.0;
        self.subTitleLabelTopPadding = (CGFloat) 8.0;
        self.bannerHeight = (CGFloat) 48.0;
        
        self.frame = CGRectMake(0.0, -self.bannerHeight, parentView.bounds.size.width, self.bannerHeight);
        [self setupLabels:mainTitle subTitle:subTitle];
        [self setBackgroundColor: UIColor.redColor];
    }
    
    return self;
}

#pragma mark Instance Methods

-(void)present {
    if (self.isPresenting) {
        return;
    }
        
    self.isPresenting = YES;
    [UIView animateWithDuration: kPresentingAnimationTimeInSeconds animations: ^{
        CGRect targetPosition = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bannerHeight);
        self.frame = targetPosition;
    } completion: nil];
}

-(void)dismiss {
    if (!self.isPresenting) {
        return;
    }
    
    [UIView animateWithDuration: kPresentingAnimationTimeInSeconds animations: ^{
        CGRect targetPosition = CGRectMake(0.0, -self.bannerHeight, self.bounds.size.width, self.bannerHeight);
        self.frame = targetPosition;
    } completion: nil];
}

@end
