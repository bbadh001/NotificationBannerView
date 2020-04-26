//
//  ViewController.m
//  BannerView
//
//  Created by Brent Badhwar on 4/24/20.
//  Copyright © 2020 Brent Badhwar. All rights reserved.
//

#import "ViewController.h"
#import "BannerView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *dismissBtn;
@property (weak, nonatomic) BannerView* bannerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BannerView* banner = [[BannerView alloc] initWithTitle:@"Main title" subTitle:@"Sub title" parentView:self.view];
    self.bannerView = banner;
    [self.view addSubview:banner];
    [banner present];
}

- (IBAction)dismissBtnTapped:(UIButton *)sender {
    [self.bannerView dismiss];
}



@end
