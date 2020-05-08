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
    BannerView* banner = [[BannerView alloc] initWithTitle:@"Lorem Ipsum!" subTitle:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam faucibus, dui vel condimentum ultricies, ligula nulla faucibus felis, in lacinia ligula quam eget odio. Nullam auctor libero nisl, eget luctus nisi iaculis non. Integer malesuada, nibh et rhoncus tincidunt, lacus massa posuere arcu, id faucibus urna dolor sit amet sapien. Nullam eros sapien, vehicula sed felis sit amet, vestibulum venenatis ex. Mauris rutrum risus eget nulla consequat, in porta dui convallis. Donec eu mauris tortor. In ligula ligula, blandit quis posuere sit amet, eleifend accumsan nulla. Morbi eu mauris at justo efficitur auctor. Maecenas sed viverra eros. Donec malesuada, erat a commodo pharetra, nibh odio pretium tortor, non aliquam mi neque in libero." parentView:self.view];
    self.bannerView = banner;
    [self.bannerView presentOnViewController:self];
}

- (IBAction)presentBtnTapped:(UIButton *)sender {
    
    [self.bannerView presentOnViewController:self];
}


- (IBAction)dismissBtnTapped:(UIButton *)sender {
    [self.bannerView dismiss];
}



@end
