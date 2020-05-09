//
//  ViewController.m
//  BannerView
//
//  Created by Brent Badhwar on 4/24/20.
//  Copyright © 2020 Brent Badhwar. All rights reserved.
//

#import "ViewController.h"
#import "BannerView.h"
#import "BannerViewStyleSuccess.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *dismissBtn;
@property (weak, nonatomic) BannerView* bannerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BannerView* banner = [[BannerView alloc]
                          initWithTitle:@"Success notifcation!"
                          subTitle:@"A simple banner that presents and dismisses."
    ];
    self.bannerView = banner;
    [self.bannerView setBackgroundColor: [UIColor colorWithRed:.10 green:.63 blue:.37 alpha:1.0]];
    [self.bannerView presentOnViewController:self];
}

- (IBAction)presentBtnTapped:(UIButton *)sender {
    
    [self.bannerView presentOnViewController:self];
}


- (IBAction)dismissBtnTapped:(UIButton *)sender {
    [self.bannerView dismiss];
}



@end
