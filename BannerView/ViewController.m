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
    BannerView* banner = [[BannerView alloc] initWithTitle:@"Success!" subTitle:@"Your new changes were saved" parentView:self.view];
    self.bannerView = banner;
    [self.bannerView present:self];
}

- (IBAction)presentBtnTapped:(UIButton *)sender {
    
    [self.bannerView present:self];
}


- (IBAction)dismissBtnTapped:(UIButton *)sender {
    [self.bannerView dismiss];
}



@end
