//
//  BannerView.m
//  BannerView
//
//  Created by Brent Badhwar on 4/24/20.
//  Copyright © 2020 Brent Badhwar. All rights reserved.
//

#import "BannerView.h"
#import "BannerPresentationState.h"

#define kPresentingAnimationTimeInSeconds 0.3
#define kDistFromParentViewToAutoDismiss 16

@interface BannerView ()

@property (nonatomic, weak) UIView* parentView;

@property (nonatomic) BannerPresentationState presentationState;

@property (nonatomic) CGFloat mainTitleLabelTopPadding;
@property (nonatomic) CGFloat subTitleLabelTopPadding;

@property (nonatomic) CGFloat mainTitleLabelLeftPadding;
@property (nonatomic) CGFloat subTitleLabelLeftPadding;

@property (nonatomic) CGFloat bannerHeight;

@end

@implementation BannerView

#pragma mark Setup and Init Methods

-(void)setupLabels:(NSString*)mainTitle subTitle:(NSString*)subTitle {
    UILabel* mainTitleLabel = [UILabel new];
    mainTitleLabel.text = mainTitle;
    mainTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    UILabel* subTitleLabel = [UILabel new];
    subTitleLabel.text = subTitle;
    
    [self addSubview: mainTitleLabel];
    [self addSubview: subTitleLabel];
    
    NSArray* mainTitleLabelConstraints = [NSArray arrayWithObjects: [NSLayoutConstraint constraintWithItem:mainTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.mainTitleLabelTopPadding], [NSLayoutConstraint constraintWithItem:mainTitleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:self.mainTitleLabelLeftPadding], nil];
    
    [NSLayoutConstraint activateConstraints:mainTitleLabelConstraints];
    [self addConstraints:mainTitleLabelConstraints];
}

-(void)setupGestureRecongizer {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:panGesture];
}

- (instancetype)initWithTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle parentView:(UIView *)parentView {
    self = [super init];
    if (self != nil) {
        self.mainTitleLabelTopPadding = (CGFloat) 16.0;
        self.subTitleLabelTopPadding = (CGFloat) 8.0;
        
        self.mainTitleLabelLeftPadding = (CGFloat) 16.0;
        self.subTitleLabelLeftPadding = (CGFloat) 16.0;
        
        self.bannerHeight = (CGFloat) 60.0;
        self.parentView = parentView;
        self.presentationState = BannerPresentationStateHidden;

        self.frame = CGRectMake(0.0, -self.bannerHeight, self.parentView.bounds.size.width, self.bannerHeight);
        [self setBackgroundColor: UIColor.redColor];
        
        [self setupGestureRecongizer];
        [self setupLabels:mainTitle subTitle:subTitle];
    }
    
    return self;
}

#pragma mark Instance Methods

-(void)present {
    if (self.presentationState != BannerPresentationStateHidden) {
        return;
    }
        
    [UIView animateWithDuration: kPresentingAnimationTimeInSeconds animations: ^{
        CGRect targetPosition = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bannerHeight);
        self.frame = targetPosition;
    } completion: ^(BOOL finished) {
        self.presentationState = BannerPresentationStatePresenting;
    }];
}

-(void)dismissWithVelocity:(CGFloat)pointsPerSecond{
    if (self.presentationState != BannerPresentationStatePresenting) {
        return;
    }
    
    CGFloat distanceFromBannerToEnd = -self.frame.origin.y;
    NSTimeInterval animationTime = distanceFromBannerToEnd/pointsPerSecond;
    
    [UIView animateWithDuration: animationTime animations: ^{
        CGRect targetPosition = CGRectMake(0.0, -self.bannerHeight, self.bounds.size.width, self.bannerHeight);
        self.frame = targetPosition;
    } completion: nil];
}

#pragma mark Gesture Recognizer Methods

-(void)handlePan:(UIPanGestureRecognizer*)sender {
    CGPoint delta = [sender translationInView:self.parentView];
    NSLog(@"y delta: %f", delta.y);
    
    if (self.frame.origin.y+self.frame.size.height <= kDistFromParentViewToAutoDismiss) {
        CGPoint pointsPerSecond = [sender velocityInView:self];
        [self dismissWithVelocity:pointsPerSecond.y];
        return;
    }
    
    if (delta.y < 0) {
        CGRect targetPosition = CGRectMake(0.0, self.frame.origin.y+delta.y, self.bounds.size.width, self.bannerHeight);
        self.frame = targetPosition;
        //animate back to presenting position here...
    } else {
        //animate back to presenting position here...
    }
    
    [sender setTranslation:CGPointMake(0, 0) inView:self];
}

@end
