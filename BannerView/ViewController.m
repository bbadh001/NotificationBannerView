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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BannerView* banner = [[BannerView alloc] initWithTitle:@"Main title" subTitle:@"Sub title" parentView:self.view];
    [self.view addSubview:banner];
}


@end
