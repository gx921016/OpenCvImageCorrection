//
//  BLImageViewController.m
//  OpenCvImageCorrection
//
//  Created by lonelyBanana on 16/10/17.
//  Copyright © 2016年 lonelyBanana. All rights reserved.
//

#import "BLImageViewController.h"

@interface BLImageViewController ()

@property (nonatomic, strong)UIImageView *myImageView;

@property (nonatomic, strong)UIButton *backBtn;

@end

@implementation BLImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.myImageView];
    [self.view addSubview:self.backBtn];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

-(void)updateViewConstraints{
    WS(weakSelf);
    [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).with.offset(30);
        make.left.equalTo(weakSelf.view).with.offset(10);
    }];
    [super updateViewConstraints];
}

#pragma mark - lazyLoad
-(UIImageView *)myImageView{
    if (!_myImageView) {
        _myImageView = [UIImageView new];
    }
    return _myImageView;
}

-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_backBtn setImage:[[UIImage imageNamed:@"返回"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:0];
        [_backBtn addTarget:self
                     action:@selector(disMissBtnDown)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
#pragma mark - action
-(void)disMissBtnDown{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - set

-(void)setMyImage:(UIImage *)myImage{
    _myImage  = myImage;
    self.myImageView.image = myImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
