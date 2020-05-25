//
//  BannerView.m
//  BannerView
//
//  Created by Brent Badhwar on 4/24/20.
//  Copyright © 2020 Brent Badhwar. All rights reserved.
//

#import "BannerView.h"
#import "BannerPresentationState.h"
#import "BannerViewPresentationPosition.h"
#import "BannerViewPresentationPositionFactory.h"

#define kAnimationVelocityDefault 300.0
#define kDismissalVelocityAnimationDefault 150.0

#define kAnimationVelocityMax 200.0
#define kAnimationVelocityMin 100.0

#define kDistFromParentViewToAutoDismiss 50.0


@interface BannerView ()

@property (nonatomic) BannerPresentationState presentationState;
@property (nonatomic) BannerViewPresentationPosition* positions;
@property (nonatomic) BannerViewPresentationPositionType positionType;

@property (nonatomic, copy) NSString* mainTitleText;
@property (nonatomic, copy) NSString* subTitleText;

@property (strong, nonatomic) UILabel* mainTitleLabel;
@property (strong, nonatomic) UILabel* subTitleLabel;

@property (nonatomic) CGFloat mainTitleLabelTopPadding;
@property (nonatomic) CGFloat subTitleLabelTopPadding;
@property (nonatomic) CGFloat mainTitleLabelLeftPadding;
@property (nonatomic) CGFloat subTitleLabelLeftPadding;

@property (nonatomic) NSLayoutConstraint* superviewBorderConstraint;
@property (nonatomic) NSLayoutConstraint* widthConstraint;

@property (nonatomic) UIPanGestureRecognizer* panGesture;

@end

@implementation BannerView

#pragma mark Setup and Init Methods

-(void)setupLabels:(NSString*)mainTitle subTitle:(NSString*)subTitle {
    self.mainTitleLabel = [UILabel new];
    self.subTitleLabel = [UILabel new];
        
    //TODO: attribute text for labels
    self.mainTitleLabel.text = mainTitle;
    self.mainTitleLabel.textColor = UIColor.whiteColor;
    self.mainTitleLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightBold];
    self.mainTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mainTitleLabel setNumberOfLines:1];
    [self.mainTitleLabel sizeToFit];
    
    self.subTitleLabel.text = subTitle;
    self.subTitleLabel.textColor = UIColor.whiteColor;
    self.subTitleLabel.font = [UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium];
    self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.subTitleLabel setNumberOfLines:2];
    [self.subTitleLabel sizeToFit];
}

-(void)configureConstraints {
    if (!self.superview) { return; }

    //config stackviews
    UIStackView* textStackView = [UIStackView new];
    textStackView.translatesAutoresizingMaskIntoConstraints = NO;
    textStackView.axis = UILayoutConstraintAxisVertical;
    textStackView.distribution = UIStackViewDistributionFill;
    [textStackView addArrangedSubview:self.mainTitleLabel];
    [textStackView addArrangedSubview:self.subTitleLabel];
    textStackView.spacing = 8.0;
    [textStackView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];

    UIActivityIndicatorView* leftView = [UIActivityIndicatorView new];
    leftView.frame = CGRectMake(0, 0, 25, 25);
    [leftView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleMedium];
    [leftView startAnimating];
    [leftView setColor:UIColor.whiteColor];
    [leftView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis: UILayoutConstraintAxisHorizontal];
    
    UIButton* rightView = [UIButton new];
    rightView.frame = CGRectMake(0, 0, 25, 25);
    [rightView setTitle:@"Dismiss" forState:UIControlStateNormal];
    rightView.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium];
    [rightView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis: UILayoutConstraintAxisHorizontal];

    UIStackView* horizontalStackView = [UIStackView new];
    horizontalStackView.translatesAutoresizingMaskIntoConstraints = NO;
    horizontalStackView.axis = UILayoutConstraintAxisHorizontal;
    horizontalStackView.distribution = UIStackViewDistributionFill;
//    [horizontalStackView addArrangedSubview:leftView];
    [horizontalStackView addArrangedSubview:textStackView];
    [horizontalStackView addArrangedSubview:rightView];
    horizontalStackView.spacing = 8.0;
    
    [self addSubview:horizontalStackView];
    
    NSArray* horizontalStackViewConstraints = [NSArray arrayWithObjects:
        [NSLayoutConstraint constraintWithItem:horizontalStackView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant: self.positionType == BannerViewPresentationPositionTypeTop ? 28.0 : 8.0],
        [NSLayoutConstraint constraintWithItem:horizontalStackView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-8.0],
        [NSLayoutConstraint constraintWithItem:horizontalStackView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:8.0],
        [NSLayoutConstraint constraintWithItem:horizontalStackView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-8.0],
    nil];
    
    [NSLayoutConstraint activateConstraints:horizontalStackViewConstraints];
    [self addConstraints:horizontalStackViewConstraints];
    
    //self with superview constraints:
    self.widthConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.superview.frame.size.width];
    NSArray* constraints = [NSArray arrayWithObjects:
        self.widthConstraint,
    nil];

    [NSLayoutConstraint activateConstraints:constraints];
    [self addConstraints:constraints];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    //set top constraint
    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.frame.size.height];
    NSArray* topConstraints = [NSArray arrayWithObjects:
        topConstraint,
    nil];
    
    self.superviewBorderConstraint = topConstraint;

    [NSLayoutConstraint activateConstraints:topConstraints];
    [self.superview addConstraints:constraints];
    
    [self.superview setNeedsLayout];
    [self.superview layoutIfNeeded];
}

-(void)setupGestureRecongizers {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:panGesture];
    self.panGesture = panGesture;
}

- (instancetype)initWithTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle {
    self = [super init];
    if (self != nil) {
        //setup labels (we have to wait to for a 'presentOnView' call first to setup constriants though)
        self.mainTitleText = mainTitle;
        self.subTitleText = subTitle;
        self.mainTitleLabelTopPadding = (CGFloat) 16.0;
        self.subTitleLabelTopPadding = (CGFloat) 16.0;
        self.mainTitleLabelLeftPadding = (CGFloat) 16.0;
        self.subTitleLabelLeftPadding = (CGFloat) 16.0;
        [self setupLabels:mainTitle subTitle:subTitle];
    
        //for autolayout
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        //init presentation state
        self.presentationState = BannerPresentationStateHidden;
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleRotation) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        [self setupGestureRecongizers];
    }
    
    return self;
}

#pragma mark Public Methods
-(void)presentOnViewController:(UIViewController*)vc withPosition:(BannerViewPresentationPositionType)positionType {
    // make sure we have a superview to present on
    if (!vc) { return; }

    // make sure we are in the hidden state
    if (self.presentationState != BannerPresentationStateHidden &&
        self.presentationState != BannerPresentationStateAnimatingDismissal) { return; }
    
    // add banner to superview...
    // now we can start configuring constraints as we know our superview
    [vc.view addSubview:self];
    self.positionType = positionType;
    [self configureConstraints];
    
    // pan gesture recongizer will be toggled on/off on present and dismiss respectively just as a precaution to avoid any possible bad states (e.g being able to touch banner when its off screen after being dismissed)
    [self.panGesture setEnabled:YES];

    // present the banner
    self.presentationState = BannerPresentationStateAnimatingPresentation;
    [self animateConstraint: self.superviewBorderConstraint
         toNewConstantValue: 0.0
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
    [self animateConstraint: self.superviewBorderConstraint
            toNewConstantValue: self.frame.size.height
            withVelocity: kAnimationVelocityDefault
            initialVelocity: 0.0
            springDamping: 1.0
            onCompletion: ^(BOOL finished) {
                self.presentationState = BannerPresentationStateHidden;
                [self removeFromSuperview];
                [self removeConstraints:[self constraints]];
                for (UIView* subview in [self subviews]) {
                    [subview removeFromSuperview];
                }
            }
     ];
}

#pragma mark Private Methods

/// General animation method
///
///
-(void)animateConstraint:(NSLayoutConstraint*)constraint
            toNewConstantValue:(CGFloat)constant
            withVelocity:(CGFloat)velocity
         initialVelocity:(CGFloat)initialVelocity
           springDamping:(CGFloat)springDampingCoef
            onCompletion:(void (^)(BOOL finished))completionBlock {
    [self.layer removeAllAnimations];

    CGFloat currentValue = self.superviewBorderConstraint.constant;
    CGFloat distanceToTargetValue = fabs(currentValue-constant);
    NSTimeInterval animationTime = distanceToTargetValue/fabs(velocity);

    NSLog(@"animate time %f", animationTime);

    [self.superview layoutIfNeeded];
    [UIView animateWithDuration: animationTime
                          delay: 0.0
         usingSpringWithDamping: springDampingCoef
          initialSpringVelocity: initialVelocity
                        options: UIViewAnimationOptionAllowUserInteraction
        animations: ^{
            self.superviewBorderConstraint.constant = constant;
            [self.superview layoutIfNeeded];
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
                //could use this
//                CGFloat dismissVelocity = [self normalizeVelocity:velocity.y];
                [self dismiss];
            }
        } else {
            //animate back to presentation state
            self.presentationState = BannerPresentationStateAnimatingPresentation;
            [self animateConstraint: self.superviewBorderConstraint
                 toNewConstantValue: 0.0
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
        CGRect nextPosition = CGRectZero;
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
//                nextPosition = CGRectMake(0.0, self.frame.origin.y + delta.y*(0.5/self.frame.origin.y), self.frame.size.width, self.frame.size.height);
                nextPosition = CGRectMake(0.0, self.frame.origin.y + delta.y*(0.05), self.frame.size.width, self.frame.size.height);
            }
        }
//        self.transform = CGAffineTransformMakeTranslation(nextPosition.origin.x, nextPosition.origin.y);
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
    // update width
    self.widthConstraint.constant = self.superview.frame.size.width;
    // if top banner, adjust internal spacing for extra space for status bar accordingly
    if (self.positionType == BannerViewPresentationPositionTypeTop) {
        
    }
    [self layoutIfNeeded];
    [self setNeedsUpdateConstraints];
}
@end
