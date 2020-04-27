//
//  BaseBannerView.m
//  BannerView
//
//  Created by Brent Badhwar on 4/24/20.
//  Copyright © 2020 Brent Badhwar. All rights reserved.
//

#import "BaseBannerView.h"
#import "BannerPresentationState.h"
#import "PanGestureHandler.h"
#import "Animator.h"

@interface BaseBannerView ()

@property (nonatomic) CGFloat mainTitleLabelTopPadding;
@property (nonatomic) CGFloat subTitleLabelTopPadding;

@property (nonatomic) CGFloat mainTitleLabelLeftPadding;
@property (nonatomic) CGFloat subTitleLabelLeftPadding;

@property (nonatomic) CGFloat bannerHeight;

@end

@implementation BaseBannerView

#pragma mark Setup and Init Methods

-(void)setupLabels:(NSString*)mainTitle subTitle:(NSString*)subTitle {
    UILabel* mainTitleLabel = [UILabel new];
    UILabel* subTitleLabel = [UILabel new];
    
    //attribute text would be a good idea here
    mainTitleLabel.text = mainTitle;
    mainTitleLabel.textColor = UIColor.whiteColor;
    mainTitleLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightBold];
    mainTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    subTitleLabel.text = subTitle;
    subTitleLabel.textColor = UIColor.whiteColor;
    subTitleLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
    subTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview: mainTitleLabel];
    [self addSubview: subTitleLabel];
    
    NSArray* mainTitleLabelConstraints = [NSArray arrayWithObjects: [NSLayoutConstraint constraintWithItem:mainTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.mainTitleLabelTopPadding], [NSLayoutConstraint constraintWithItem:mainTitleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:self.mainTitleLabelLeftPadding], nil];
    
    [NSLayoutConstraint activateConstraints:mainTitleLabelConstraints];
    [self addConstraints:mainTitleLabelConstraints];
    
    NSArray* subTitleLabelConstraints = [NSArray arrayWithObjects: [NSLayoutConstraint constraintWithItem:subTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:mainTitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.subTitleLabelTopPadding], [NSLayoutConstraint constraintWithItem:subTitleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:self.subTitleLabelLeftPadding], [NSLayoutConstraint constraintWithItem:subTitleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.subTitleLabelTopPadding] ,nil];
    
    [NSLayoutConstraint activateConstraints:mainTitleLabelConstraints];
    [self addConstraints:subTitleLabelConstraints];
}

-(void)setupGestureRecongizer {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:panGesture];
}

- (instancetype)initWithTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle {
    self = [super init];
    if (self != nil) {
        self.mainTitleLabelTopPadding = (CGFloat) 16.0;
        self.subTitleLabelTopPadding = (CGFloat) 8.0;
        
        self.mainTitleLabelLeftPadding = (CGFloat) 16.0;
        self.subTitleLabelLeftPadding = (CGFloat) 16.0;
        
        self.bannerHeight = (CGFloat) 100.0;
        self.presentationState = BannerPresentationStateHidden;

        self.frame = CGRectMake(0.0, -self.bannerHeight, self.parentView.bounds.size.width, self.bannerHeight);
        [self setBackgroundColor: [UIColor colorWithRed:.10 green:.63 blue:.37 alpha:1.0]];
        
        [self setupGestureRecongizer];
        [self setupLabels:mainTitle subTitle:subTitle];
    }
    
    return self;
}

#pragma mark Public Methods

-(void)present {
    if (self.superview == nil) { return; }
    if (self.presentationState != BannerPresentationStateHidden) { return; }
}

-(void)dismiss {
    if (self.superview == nil) { return; }
    if (self.presentationState == BannerPresentationStatePresenting ||
        self.presentationState == BannerPresentationStateAnimatingPresentation ||
        self.presentationState == BannerPresentationStateTouched) {
        [self dismissAnimationWithVelocity:kDefaultDismissalAnimationVelocity];
    }
}

//likely a reconfigrable views/constraints function here

@end
