//
//  BannerView.m
//  BannerView
//
//  Created by Brent Badhwar on 4/24/20.
//  Copyright © 2020 Brent Badhwar. All rights reserved.
//

#import "BannerView.h"
#import "BannerPresentationState.h"

#define kDefaultAnimationVelocity 300.0

@interface BannerView ()

@property (nonatomic) BannerPresentationState presentationState;

@property (nonatomic) CGFloat mainTitleLabelTopPadding;
@property (nonatomic) CGFloat subTitleLabelTopPadding;

@property (nonatomic) CGFloat mainTitleLabelLeftPadding;
@property (nonatomic) CGFloat subTitleLabelLeftPadding;

@property (nonatomic) CGFloat bannerHeight; //might be able to remove if we can set height in setup

@end

@implementation BannerView

#pragma mark Setup and Init Methods

-(void)setupLabels:(NSString*)mainTitle subTitle:(NSString*)subTitle {
    UILabel* mainTitleLabel = [UILabel new];
    UILabel* subTitleLabel = [UILabel new];
    
    //attribute text would be a good idea here
    mainTitleLabel.text = mainTitle;
    mainTitleLabel.textColor = UIColor.whiteColor;
    mainTitleLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightBold];
    mainTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [mainTitleLabel sizeToFit];
    
    subTitleLabel.text = subTitle;
    subTitleLabel.textColor = UIColor.whiteColor;
    subTitleLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
    subTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [subTitleLabel setNumberOfLines:3];
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

-(void)setupGestureRecongizers {
    UISwipeGestureRecognizer* swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swipeGesture];
}

- (instancetype)initWithTitle:(NSString *)mainTitle subTitle:(NSString *)subTitle {
    self = [super init];
    if (self != nil) {
        self.mainTitleLabelTopPadding = (CGFloat) 16.0;
        self.subTitleLabelTopPadding = (CGFloat) 16.0;
        
        self.mainTitleLabelLeftPadding = (CGFloat) 16.0;
        self.subTitleLabelLeftPadding = (CGFloat) 16.0;
        
        self.presentationState = BannerPresentationStateHidden;
        
        [self setupGestureRecongizers];
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
    [self.layer removeAllAnimations];

    CGRect currentPosition = self.frame;
    CGFloat distanceToTargetPosition = fabs(currentPosition.origin.y-targetPosition.origin.y);
    NSTimeInterval animationTime = distanceToTargetPosition/fabs(velocity);
    
    
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

#pragma mark Gesture Recognizer Methods

-(void)handleSwipe:(UIPanGestureRecognizer*)sender {
    [self dismiss];
}

@end
