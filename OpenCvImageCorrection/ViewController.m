//
//  ViewController.m
//  OpenCvImageCorrection
//
//  Created by lonelyBanana on 16/10/8.
//  Copyright © 2016年 lonelyBanana. All rights reserved.
//

#import "ViewController.h"
#import "BLCameraViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor purpleColor];
    [btn addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    WS(weakSelf);
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
}

-(void)btnDown{
    BLCameraViewController *BLCVc = [BLCameraViewController new];
    [self.navigationController pushViewController:BLCVc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
