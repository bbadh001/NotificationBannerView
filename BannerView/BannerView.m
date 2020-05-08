//
//  BannerView.m
//  BannerView
//
//  Created by Brent Badhwar on 4/24/20.
//  Copyright © 2020 Brent Badhwar. All rights reserved.
//

#import "BannerView.h"
#import "BannerPresentationState.h"

#define kPresentingAnimationTime 0.3
#define kDefaultDismissalAnimationTime 0.3

#define kDefaultAnimationVelocity 330.0
#define kDefaultDismissalAnimationVelocity 25.0
#define kTouchDismissalAnimationVelocityLimit 100.0

#define kDistFromParentViewToAutoDismiss 36.0
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
//    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel* mainTitleLabel = [UILabel new];
    UILabel* subTitleLabel = [UILabel new];
    
    //attribute text would be a good idea here
    mainTitleLabel.text = mainTitle;
    mainTitleLabel.textColor = UIColor.whiteColor;
    mainTitleLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightBold];
    mainTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    mainTitleLabel.layer.borderColor = UIColor.redColor.CGColor;
//    mainTitleLabel.layer.borderWidth = 2.0;
    [mainTitleLabel sizeToFit];
    
    subTitleLabel.text = subTitle;
    subTitleLabel.textColor = UIColor.whiteColor;
    subTitleLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
    subTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [subTitleLabel setNumberOfLines:5];
//    subTitleLabel.layer.borderColor = UIColor.redColor.CGColor;
//    subTitleLabel.layer.borderWidth = 2.0;
    [subTitleLabel sizeToFit];
    
//    [self addSubview: mainTitleLabel];
//    [self addSubview: subTitleLabel];
    
//    NSArray* mainTitleLabelConstraints = [NSArray arrayWithObjects: [NSLayoutConstraint constraintWithItem:mainTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.mainTitleLabelTopPadding], [NSLayoutConstraint constraintWithItem:mainTitleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:self.mainTitleLabelLeftPadding], nil];
//
//    [NSLayoutConstraint activateConstraints:mainTitleLabelConstraints];
//    [self addConstraints:mainTitleLabelConstraints];
//
//    NSArray* subTitleLabelConstraints = [NSArray arrayWithObjects:
//        [NSLayoutConstraint constraintWithItem:subTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:mainTitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:self.subTitleLabelTopPadding],
//        [NSLayoutConstraint constraintWithItem:subTitleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:self.subTitleLabelLeftPadding],
//        [NSLayoutConstraint constraintWithItem:subTitleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.subTitleLabelTopPadding],
//        [NSLayoutConstraint constraintWithItem:subTitleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-self.subTitleLabelTopPadding], nil];
//
//    [NSLayoutConstraint activateConstraints:mainTitleLabelConstraints];
//    [self addConstraints:subTitleLabelConstraints];
//
    CGFloat bannerHeight = self.mainTitleLabelTopPadding+mainTitleLabel.frame.size.height+self.subTitleLabelTopPadding+subTitleLabel.frame.size.height+self.subTitleLabelTopPadding+50.0;
    NSLog(@"Height %f", bannerHeight);
    self.bannerHeight = bannerHeight;
    
    UIStackView* stackView = [UIStackView new];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    [stackView addArrangedSubview:mainTitleLabel];
    [stackView addArrangedSubview:subTitleLabel];
    stackView.spacing = 8.0;
    
    [self addSubview:stackView];
    stackView.layer.borderColor = UIColor.redColor.CGColor;
    stackView.layer.borderWidth = 2.0;
    
    NSArray* stackViewConstraints = [NSArray arrayWithObjects:
        [NSLayoutConstraint constraintWithItem:stackView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0],
        [NSLayoutConstraint constraintWithItem:stackView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0],
    nil];
    
    [NSLayoutConstraint activateConstraints:stackViewConstraints];
    [self addConstraints:stackViewConstraints];
}

-(void)setupGestureRecongizer {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:panGesture];
}

- (instancetype)initWithTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle parentView:(UIView *)parentView {
    self = [super init];
    if (self != nil) {
        self.mainTitleLabelTopPadding = (CGFloat) 16.0;
        self.subTitleLabelTopPadding = (CGFloat) 16.0;
        
        self.mainTitleLabelLeftPadding = (CGFloat) 16.0;
        self.subTitleLabelLeftPadding = (CGFloat) 16.0;
        
        self.parentView = parentView;
        self.presentationState = BannerPresentationStateHidden;

        self.frame = CGRectMake(0.0, -self.bannerHeight, self.parentView.bounds.size.width, self.bannerHeight);
        [self setBackgroundColor: [UIColor colorWithRed:.10 green:.63 blue:.37 alpha:1.0]];
        
        [self setupGestureRecongizer];
        [self setupLabels:mainTitle subTitle:subTitle];
    }
    
    return self;
}

#pragma mark Public Methods

-(void)presentOnViewController:(UIViewController*)vc {
    // make sure the vc have a superview
    if (!vc) { return; }
    
    // make sure we are in the hidden state
    if (self.presentationState != BannerPresentationStateHidden) { return; }
    
    // add superview and init position
    [vc.view addSubview:self];
    self.frame = CGRectMake(0.0, -self.bannerHeight, vc.view.frame.size.width, self.bannerHeight);

    // present the banner
    [self.layer removeAllAnimations];
    self.presentationState = BannerPresentationStateAnimatingPresentation;
    [self animateToPosition: CGRectMake(0.0, 0.0, vc.view.frame.size.width, self.bannerHeight)
               withVelocity: kDefaultAnimationVelocity
            initialVelocity: 0.0
               onCompletion: ^(BOOL finished) {
                self.presentationState = BannerPresentationStatePresenting;
            }
     ];
}

-(void)dismiss {
    // make sure we are a subview of something
    if (self.superview == nil) { return; }
    // if we are hidden or in the middle of the dismissal, we have nothing to do here
    if (self.presentationState == BannerPresentationStateHidden ||
        self.presentationState == BannerPresentationStateAnimatingDismissal) { return; }
    
    [self.layer removeAllAnimations];
    self.presentationState = BannerPresentationStateAnimatingDismissal;
    [self animateToPosition: CGRectMake(0.0, -self.bannerHeight, self.superview.frame.size.width, self.bannerHeight)
               withVelocity: kDefaultAnimationVelocity
            initialVelocity: 0.0
               onCompletion: ^(BOOL finished) {
                self.presentationState = BannerPresentationStateHidden;
            }
     ];
}

#pragma mark Private Methods

/// General animation method
-(void)animateToPosition:(CGRect)targetPosition
            withVelocity:(CGFloat)velocity
         initialVelocity:(CGFloat)initialVelocity
            onCompletion:(void (^)(BOOL finished))completionBlock {
    CGRect currentPosition = self.frame;
    CGFloat distanceToTargetPosition = fabs(currentPosition.origin.y-targetPosition.origin.y);
    NSTimeInterval animationTime = distanceToTargetPosition/fabs(velocity);

    NSLog(@"animate time %f", animationTime);
    
    [UIView animateWithDuration: animationTime
                          delay: 0.0
         usingSpringWithDamping: 0.7
          initialSpringVelocity: initialVelocity
                        options: UIViewAnimationOptionAllowUserInteraction
        animations: ^{
            self.frame = targetPosition;
        }
        completion: ^(BOOL finished) {
            completionBlock(finished);
        }
    ];
}

-(void)animateToPresentingPositionWithVelocity:(CGFloat)velocity {
    self.presentationState = BannerPresentationStateAnimatingPresentation;
    
    CGFloat distanceToPresentingPosition = fabs(self.frame.origin.y);
    NSTimeInterval animationTime = distanceToPresentingPosition/velocity;
    
    NSLog(@"velo: %f", -velocity);
    NSLog(@"anim: %f", animationTime);
    
    [UIView animateWithDuration: animationTime delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.0 options: UIViewAnimationOptionAllowUserInteraction animations: ^{
            CGRect targetPosition = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bannerHeight);
            self.frame = targetPosition;
        }
        completion: ^(BOOL finished) {
            self.presentationState = BannerPresentationStatePresenting;
        }
    ];
}

-(void)dismissAnimationWithVelocity:(CGFloat)velocity {
    self.presentationState = BannerPresentationStateAnimatingDismissal;
    
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
    CGPoint velocity = [sender velocityInView:self];
    NSLog(@"%ld", (long)sender.state);
    
    //banner is too close edge, we should force a dismiss animation
    if (self.frame.origin.y+self.frame.size.height <= kDistFromParentViewToAutoDismiss) {
        //hard limit on velocity, if above set threshold dismiss at the limit
        //otherwise, dismiss at velocity/2
        //if below default, just dismiss at the default velocity
        if (-velocity.y >= kTouchDismissalAnimationVelocityLimit) {
            [self dismissAnimationWithVelocity:kTouchDismissalAnimationVelocityLimit];
        } else if (-velocity.y > kDefaultDismissalAnimationVelocity) {
            [self dismissAnimationWithVelocity:-velocity.y/2];//this needs work, too fast
        } else {
            [self dismissAnimationWithVelocity:kDefaultDismissalAnimationVelocity];
        }
    } else {
        //user was touching then let go, move banner back to presenting position
        if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
            [self animateToPresentingPositionWithVelocity: kDefaultAnimationVelocity];
        }
        
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
                //
                nextPosition = CGRectMake(0.0, self.frame.origin.y + delta.y*(0.5/self.frame.origin.y), self.bounds.size.width, self.bannerHeight);
                self.frame = nextPosition;
            }
        }
        
        self.frame = nextPosition;
    }
    
    [sender setTranslation:CGPointMake(0, 0) inView:self];
}


@end
