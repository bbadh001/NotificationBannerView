//
//  BannerView.m
//  BannerView
//
//  Created by Brent Badhwar on 4/24/20.
//  Copyright © 2020 Brent Badhwar. All rights reserved.
//

#import "BannerView.h"
#import "BannerPresentationState.h"

#include "math.h"

#define kPresentingAnimationTime 0.3
#define kDefaultDismissalAnimationTime 0.3

#define kPresentingAnimationVelocity 100.0
#define kDefaultDismissalAnimationVelocity 25.0
#define kTouchDismissalAnimationVelocityLimit 100.0

#define kDistFromParentViewToAutoDismiss 36

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
    //only present from hidden state
//    if (self.presentationState != BannerPresentationStateHidden) {
//        return;
//    }
    
    self.presentationState = BannerPresentationStateAnimatingIn;
    
    NSTimeInterval animationTime = self.bannerHeight/kPresentingAnimationVelocity;
    
    NSLog(@"velo: %f", -kPresentingAnimationVelocity);
    NSLog(@"anim: %f", animationTime);
    
    [UIView animateWithDuration: animationTime delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:-kPresentingAnimationVelocity options:UIViewAnimationOptionCurveEaseIn animations: ^{
            CGRect targetPosition = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bannerHeight);
            self.frame = targetPosition;
        }
        completion: ^(BOOL finished) {
            self.presentationState = BannerPresentationStatePresenting;
        }
    ];
}

-(void)dismiss {
    if (self.presentationState != BannerPresentationStatePresenting) { return; }
    [self dismissWithVelocity:kDefaultDismissalAnimationVelocity];
}

-(void)dismissWithVelocity:(CGFloat)velocity {
    //only allow for programmatic dismiss only in these two states
    if (self.presentationState != BannerPresentationStatePresenting &&
        self.presentationState != BannerPresentationStateTouched) {
        return;
    }
    
    self.presentationState = BannerPresentationStateAnimatingOut;
    
    CGFloat distanceFromBannerToEnd = self.frame.origin.y+self.bannerHeight;
    NSTimeInterval animationTime = distanceFromBannerToEnd/velocity;
    
    NSLog(@"dist to end: %f", distanceFromBannerToEnd);
    NSLog(@"velo: %f", velocity);
    NSLog(@"anim: %f", animationTime);
    
    [UIView animateWithDuration: animationTime delay: 0.0 usingSpringWithDamping:1.0 initialSpringVelocity:velocity options:UIViewAnimationOptionBeginFromCurrentState animations: ^{
            CGRect targetPosition = CGRectMake(0.0, -self.bannerHeight, self.bounds.size.width, self.bannerHeight);
            self.frame = targetPosition;
        }
        completion: ^(BOOL finished) {
            self.presentationState = BannerPresentationStateHidden;
        }
    ];
}

#pragma mark Gesture Recognizer Methods

-(void)handlePan:(UIPanGestureRecognizer*)sender {
    CGPoint delta = [sender translationInView:self.parentView];
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self present];
    }
    
    //banner is close to edge anyways, we should force a dismiss animation
    if (self.frame.origin.y+self.frame.size.height <= kDistFromParentViewToAutoDismiss) {
        CGPoint velocity = [sender velocityInView:self];
        //hard limit on velocity, if above set threshold dismiss at the limit
        //otherwise, dismiss at velocity/2
        //if below default, just dismiss at the default velocity
        if (-velocity.y >= kTouchDismissalAnimationVelocityLimit) {
            [self dismissWithVelocity:kTouchDismissalAnimationVelocityLimit];
        } else if (-velocity.y > kDefaultDismissalAnimationVelocity) {
            [self dismissWithVelocity:-velocity.y/2];//this needs more, too fast
        } else {
            [self dismissWithVelocity:kDefaultDismissalAnimationVelocity];
        }
    } else {
        //not close to edge yet, so move banner wherever the touch guides us
        CGRect nextPosition = self.frame;
        if (delta.y < 0) {
            //user is guiding the banner up
            nextPosition = CGRectMake(0.0, self.frame.origin.y + delta.y, self.bounds.size.width, self.bannerHeight);
            self.frame = nextPosition;
        } else {
            //user is guiding the banner down
            if (self.frame.origin.y <= 0) {
                nextPosition = CGRectMake(0.0, self.frame.origin.y + delta.y, self.bounds.size.width, self.bannerHeight);
                self.frame = nextPosition;
            } else {
//                NSLog(@"delta y %f", delta.y);
//                NSLog(@"sqrt delta y %f", sqrt(delta.y));
//                NSLog(@"self.frame.origin.y %f", self.frame.origin.y);
                nextPosition = CGRectMake(0.0, self.frame.origin.y + delta.y*(1/self.frame.origin.y), self.bounds.size.width, self.bannerHeight);
                self.frame = nextPosition;
            }
        }
        
        self.frame = nextPosition;
    }
    
    [sender setTranslation:CGPointMake(0, 0) inView:self];
}


@end
