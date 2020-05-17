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

@property (nonatomic) UIPanGestureRecognizer* panGesture;

@property (nonatomic) NSLayoutConstraint* widthConstraint;

@end

@implementation BannerView

#pragma mark Setup and Init Methods

-(void)setupLabels:(NSString*)mainTitle subTitle:(NSString*)subTitle {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel* mainTitleLabel = [UILabel new];
    UILabel* subTitleLabel = [UILabel new];
    
    //attribute text would be a good idea here
    mainTitleLabel.text = mainTitle;
    mainTitleLabel.textColor = UIColor.whiteColor;
    mainTitleLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightBold];
    mainTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [mainTitleLabel setNumberOfLines:1];
    [mainTitleLabel sizeToFit];
    
    subTitleLabel.text = subTitle;
    subTitleLabel.textColor = UIColor.whiteColor;
    subTitleLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
    subTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [subTitleLabel setNumberOfLines:2];
    [subTitleLabel sizeToFit];
    
    UIStackView* stackView = [UIStackView new];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFillProportionally;
    [stackView addArrangedSubview:mainTitleLabel];
    [stackView addArrangedSubview:subTitleLabel];
    stackView.spacing = 8.0;
    
    [self addSubview:stackView];
    
    NSArray* stackViewConstraints = [NSArray arrayWithObjects:
        [NSLayoutConstraint constraintWithItem:stackView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:20.0],
        [NSLayoutConstraint constraintWithItem:stackView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-8.0],
        [NSLayoutConstraint constraintWithItem:stackView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:8.0],
        [NSLayoutConstraint constraintWithItem:stackView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-8.0],
    nil];
    
    [NSLayoutConstraint activateConstraints:stackViewConstraints];
    [self addConstraints:stackViewConstraints];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)setupGestureRecongizer {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:panGesture];
    self.panGesture = panGesture;
}

- (instancetype)initWithTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle {
    self = [super init];
    if (self != nil) {
        self.translatesAutoresizingMaskIntoConstraints = NO;

        self.mainTitleLabelTopPadding = (CGFloat) 16.0;
        self.subTitleLabelTopPadding = (CGFloat) 16.0;
        
        self.mainTitleLabelLeftPadding = (CGFloat) 16.0;
        self.subTitleLabelLeftPadding = (CGFloat) 16.0;
        
        self.presentationState = BannerPresentationStateHidden;
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleRotation) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        [self setupGestureRecongizer];
    }
    
    return self;
}

#pragma mark Public Methods
-(void)presentOnView:(UIView*)view {
    // make sure we have a superview to present on
    if (!view) { return; }

    // make sure we are in the hidden state
    if (self.presentationState != BannerPresentationStateHidden &&
        self.presentationState != BannerPresentationStateAnimatingDismissal) { return; }
    
    [view addSubview:self];
    NSArray* constraints = [NSArray arrayWithObjects:
        [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:view .frame.size.width],
    nil];

    [NSLayoutConstraint activateConstraints:constraints];
    [self addConstraints:constraints];
    
    [self layoutIfNeeded];
    
    [self setupLabels:@"Success!" subTitle:@"Looks like we're good boys! We made it! Well, kinda maybe. Hopefully!"];
    
    self.frame = CGRectMake(0,  -self.frame.size.height,  self.frame.size.width,  self.frame.size.height);
    
    [self.panGesture setEnabled:YES];

    // present the banner
    [self.layer removeAllAnimations];
    self.presentationState = BannerPresentationStateAnimatingPresentation;
    [self animateToPosition: CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)
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
    [self animateToPosition: CGRectMake(0.0, -self.frame.size.height, self.frame.size.width, self.frame.size.height)
            withVelocity: kAnimationVelocityDefault
            initialVelocity: 0.0
            springDamping: 1.0
            onCompletion: ^(BOOL finished) {
                self.presentationState = BannerPresentationStateHidden;
                [self removeFromSuperview];
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

//    NSLog(@"animate time %f", animationTime);
    
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
    CGPoint delta = [sender translationInView:self.superview];
    CGPoint velocity = [sender velocityInView:self];
//    NSLog(@"Velocity: %f", velocity.y);
    
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
        if (self.frame.origin.y+self.frame.size.height <= self.frame.size.height*0.8) {
            if (self.presentationState != BannerPresentationStateAnimatingDismissal &&
                self.presentationState != BannerPresentationStateHidden) {
                self.presentationState = BannerPresentationStateAnimatingDismissal;
                
                CGFloat dismissVelocity = [self normalizeVelocity:velocity.y];
                
                [self animateToPosition: CGRectMake(0.0, -self.frame.size.height, self.frame.size.width, self.frame.size.height)
                           withVelocity: dismissVelocity
                        initialVelocity: 0.0
                          springDamping: 1.0
                           onCompletion: ^(BOOL finished) {
                            self.presentationState = BannerPresentationStateHidden;
                            [self removeFromSuperview];
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
            nextPosition = CGRectMake(0.0, self.frame.origin.y + delta.y, self.frame.size.width, self.frame.size.height);
        } else {
            //user is guiding the banner down
            //if past presenting postion, move normally
            //otherwise give a inverse movement
            if (self.frame.origin.y <= 0) {
                nextPosition = CGRectMake(0.0, self.frame.origin.y + delta.y, self.frame.size.width, self.frame.size.height);
            } else {
                //inverse movement
                nextPosition = CGRectMake(0.0, self.frame.origin.y + delta.y*(0.5/self.frame.origin.y), self.frame.size.width, self.frame.size.height);
            }
        }
        self.frame = nextPosition;
    }

    [sender setTranslation:CGPointMake(0, 0) inView:self];
}

//used to normalize a velocity value to avoid extreme values, to avoid extreme animation times
-(CGFloat)normalizeVelocity:(CGFloat)velocity {
    CGFloat currentVelocity = fabs(velocity);
    CGFloat normalizedVelocity = currentVelocity;
    if (currentVelocity >= kAnimationVelocityMax) {
        normalizedVelocity = kAnimationVelocityMax;
    } else if (currentVelocity <= kAnimationVelocityMin) {
        normalizedVelocity = kAnimationVelocityMin;
    } else {
        normalizedVelocity = currentVelocity;
    }
    return normalizedVelocity;
}

-(void)handleRotation {
    if (!self.superview) { return; }
    self.widthConstraint.constant = self.superview.frame.size.width;
    [self setNeedsLayout];
}



@end
