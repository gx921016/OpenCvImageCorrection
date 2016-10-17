//
//  BLEditorItemView.m
//  OpenCvImageCorrection
//
//  Created by lonelyBanana on 16/10/17.
//  Copyright © 2016年 lonelyBanana. All rights reserved.
//

#import "BLEditorItemView.h"
@interface BLEditorItemView ()

@property (nonatomic, strong)UIView *backView1;

@property (nonatomic, strong)UIView *backView2;

@property (nonatomic, strong)UIView *backView3;

@property (nonatomic, strong)UIView *backView4;



@end
@implementation BLEditorItemView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self bl_initialize];
        [self bl_addSubviews];
        
    }
    return self;
}

-(void)bl_initialize{
    [self updateConstraintsIfNeeded];
    [self setNeedsUpdateConstraints];
}
-(void)updateConstraints{
    WS(weakSelf);
    [self.backView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.top.and.bottom.equalTo(weakSelf);
        make.width.equalTo(@(SCREEN_WIDTH/4));
    }];
    [self.backView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.backView1.mas_right);
        make.top.and.bottom.equalTo(weakSelf);
        make.width.equalTo(@(SCREEN_WIDTH/4));
    }];
    [self.backView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.backView2.mas_right);
        make.top.and.bottom.equalTo(weakSelf);
        make.width.equalTo(@(SCREEN_WIDTH/4));
    }];
    [self.backView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.backView3.mas_right);
        make.top.and.bottom.equalTo(weakSelf);
        make.width.equalTo(@(SCREEN_WIDTH/4));
    }];
    
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.backView1);
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.backView2);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.backView3);
    }];
    
    [self.tureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.backView4);
    }];
    [super updateConstraints];
}
-(void)bl_addSubviews{
    [self addSubview:self.backView1];
    [self addSubview:self.backView2];
    [self addSubview:self.backView3];
    [self addSubview:self.backView4];
    [self.backView1 addSubview:self.delBtn];
    [self.backView2 addSubview:self.leftBtn];
    [self.backView3 addSubview:self.rightBtn];
    [self.backView4 addSubview:self.tureBtn];
}

-(UIView *)backView1{
    if (!_backView1) {
        _backView1 = [UIView new];
    }
    return _backView1;
}

-(UIButton *)delBtn{
    if (!_delBtn) {
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delBtn setImage:[UIImage imageNamed:@"camera_del"] forState:0];
    }
    return _delBtn;
}

-(UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setImage:[UIImage imageNamed:@"camera_left"] forState:0];
    }
    return _leftBtn;
}

-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:@"camera_right"] forState:0];
    }
    return _rightBtn;
}

-(UIButton *)tureBtn{
    if (!_tureBtn) {
        _tureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tureBtn setImage:[UIImage imageNamed:@"camera_ture"] forState:0];
    }
    return _tureBtn;
}

-(UIView *)backView2{
    if (!_backView2) {
        _backView2 = [UIView new];
    }
    return _backView2;
}

-(UIView *)backView3{
    if (!_backView3) {
        _backView3 = [UIView new];
    }
    return _backView3;
}

-(UIView *)backView4{
    if (!_backView4) {
        _backView4 = [UIView new];
    }
    return _backView4;
}

@end
