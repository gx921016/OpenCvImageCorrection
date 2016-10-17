//
//  BLCameraViewController.m
//  OpenCvImageCorrection
//
//  Created by lonelyBanana on 16/10/8.
//  Copyright © 2016年 lonelyBanana. All rights reserved.
//

#import "BLCameraViewController.h"
#import "CameraSessionView.h"
#import "BLEditorViewController.h"
@interface BLCameraViewController ()<CACameraSessionDelegate>
@property (nonatomic, strong) CameraSessionView *cameraView;
@end

@implementation BLCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.cameraView];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
}

-(void)updateViewConstraints{
    WS(weakSelf);
    [self.cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [super updateViewConstraints];
}

-(CameraSessionView *)cameraView{
    if (!_cameraView) {
        _cameraView = [[CameraSessionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _cameraView.delegate = self;
    }
    return _cameraView;
}

#pragma mark -
- (void)didCaptureImage:(UIImage *)image{
    BLEditorViewController *BLEditorVc = [BLEditorViewController new];
    BLEditorVc.editorImg = image;
    [self.navigationController pushViewController:BLEditorVc animated:YES];
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
