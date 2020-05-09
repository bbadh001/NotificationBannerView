//
//  BannerView.m
//  BannerView
//
//  Created by Brent Badhwar on 4/24/20.
//  Copyright © 2020 Brent Badhwar. All rights reserved.
//

#import "BannerView.h"
#import "BannerPresentationState.h"

#define kAnimationVelocityDefault 300.0
#define kDismissalVelocityAnimationDefault 150.0

#define kAnimationVelocityMax 200.0
#define kAnimationVelocityMin 100.0

#define kDistFromParentViewToAutoDismiss 50.0

@interface BannerView ()

@property (nonatomic, weak) UIView* parentView;

@property (nonatomic) BannerPresentationState presentationState;

@property (nonatomic) CGFloat mainTitleLabelTopPadding;
@property (nonatomic) CGFloat subTitleLabelTopPadding;

@property (nonatomic) CGFloat mainTitleLabelLeftPadding;
@property (nonatomic) CGFloat subTitleLabelLeftPadding;

@property (nonatomic) CGFloat bannerHeight;

@property (nonatomic) UIPanGestureRecognizer* panGesture;

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
    CGFloat bannerHeight = self.mainTitleLabelTopPadding+mainTitleLabel.frame.size.height+self.subTitleLabelTopPadding+subTitleLabel.frame.size.height+self.subTitleLabelTopPadding+20.0;
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
    self.panGesture = panGesture;
}

- (instancetype)initWithTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle {
    self = [super init];
    if (self != nil) {
        self.mainTitleLabelTopPadding = (CGFloat) 16.0;
        self.subTitleLabelTopPadding = (CGFloat) 16.0;
        
        self.mainTitleLabelLeftPadding = (CGFloat) 16.0;
        self.subTitleLabelLeftPadding = (CGFloat) 16.0;
        
        self.presentationState = BannerPresentationStateHidden;
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didRotate) name:UIDeviceOrientationDidChangeNotification object:nil];
        
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
    if (self.presentationState != BannerPresentationStateHidden &&
        self.presentationState != BannerPresentationStateAnimatingDismissal) { return; }
    NSLog(@"%f",self.bannerHeight);
    
    // add superview and init position
    [vc.view addSubview:self];
    self.frame = CGRectMake(0.0, -self.bannerHeight, vc.view.frame.size.width, self.bannerHeight);
    
    [self.panGesture setEnabled:YES];

    // present the banner
    [self.layer removeAllAnimations];
    self.presentationState = BannerPresentationStateAnimatingPresentation;
    [self animateToPosition: CGRectMake(0.0, 0.0, vc.view.frame.size.width, self.bannerHeight)
               withVelocity: kAnimationVelocityDefault
            initialVelocity: 0.0
            springDamping: 0.7
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
    
    [self.panGesture setEnabled:NO];
    
    [self.layer removeAllAnimations];
    self.presentationState = BannerPresentationStateAnimatingDismissal;
    [self animateToPosition: CGRectMake(0.0, -self.bannerHeight, self.superview.frame.size.width, self.bannerHeight)
            withVelocity: kAnimationVelocityDefault
            initialVelocity: 0.0
            springDamping: 1.0
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
           springDamping:(CGFloat)springDampingCoef
            onCompletion:(void (^)(BOOL finished))completionBlock {
    CGRect currentPosition = self.frame;
    CGFloat distanceToTargetPosition = fabs(currentPosition.origin.y-targetPosition.origin.y);
    NSTimeInterval animationTime = distanceToTargetPosition/fabs(velocity);

    NSLog(@"animate time %f", animationTime);
    
    [UIView animateWithDuration: animationTime
                          delay: 0.0
         usingSpringWithDamping: springDampingCoef
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

#pragma mark Gesture Recognizer Methods
 
///The magic function
-(void)handlePan:(UIPanGestureRecognizer*)sender {
    CGPoint delta = [sender translationInView:self.parentView];
    CGPoint velocity = [sender velocityInView:self];
    NSLog(@"Velocity: %f", velocity.y);
    
    //no reason to be here anyways
    if (self.presentationState == BannerPresentationStateHidden) {
        return;
    }
    
    //if we are hidden, force dismiss
    if (!CGRectIntersectsRect(self.frame, self.superview.frame)) {
        [self dismiss];
        return;
    }
    
    //user has stopped touching the banner
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
        // check to see if banner is too close edge, we should force a dismiss animation
        // otherwise, just animate back to presenting position
        if (self.frame.origin.y+self.frame.size.height <= self.bannerHeight*0.8) {
            if (self.presentationState != BannerPresentationStateAnimatingDismissal &&
                self.presentationState != BannerPresentationStateHidden) {
                self.presentationState = BannerPresentationStateAnimatingDismissal;
                //TODO: make this a function
                CGFloat currentVelocity = fabs(velocity.y);
                CGFloat velocityToDismiss = velocity.y;
                if (currentVelocity >= kAnimationVelocityMax) {
                    velocityToDismiss = kAnimationVelocityMax;
                } else if (currentVelocity <= kAnimationVelocityMin) {
                    velocityToDismiss = kAnimationVelocityMin;
                } else {
                    velocityToDismiss = currentVelocity;
                }
                
                [self animateToPosition: CGRectMake(0.0, -self.bannerHeight, self.superview.frame.size.width, self.bannerHeight)
                           withVelocity: velocityToDismiss
                        initialVelocity: 0.0
                          springDamping: 1.0
                           onCompletion: ^(BOOL finished) {
                            self.presentationState = BannerPresentationStateHidden;
                        }
                 ];
            }
        } else {
            //animate back to presentation state
            self.presentationState = BannerPresentationStateAnimatingPresentation;
            [self animateToPosition: CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)
                       withVelocity: kAnimationVelocityMin
                    initialVelocity: 0.0
                      springDamping: 0.7
                       onCompletion: ^(BOOL finished) {
                        self.presentationState = BannerPresentationStatePresenting;
                    }
             ];
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
            //if past presenting postion, move normally
            //otherwise give a inverse movement
            if (self.frame.origin.y <= 0) {
                nextPosition = CGRectMake(0.0, self.frame.origin.y + delta.y, self.bounds.size.width, self.bannerHeight);
                self.frame = nextPosition;
            } else {
                //inverse movement
                nextPosition = CGRectMake(0.0, self.frame.origin.y + delta.y*(0.50/self.frame.origin.y), self.bounds.size.width, self.bannerHeight);
                self.frame = nextPosition;
            }
        }
        
        self.frame = nextPosition;
    }

    [sender setTranslation:CGPointMake(0, 0) inView:self];
}

-(void)didRotate {
    if (!self.superview) { return; }
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.superview.frame.size.width,
                            self.frame.size.height
    );
}



@end
