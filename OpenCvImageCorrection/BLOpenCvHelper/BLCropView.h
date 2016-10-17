//
//  BLCropView.h
//  OpenCvImageCorrection
//
//  Created by lonelyBanana on 16/10/8.
//  Copyright © 2016年 lonelyBanana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLCropView : UIView
{
    CGPoint touchOffset;
    CGPoint a;
    CGPoint b;
    CGPoint c;
    CGPoint d;
    
    //middle
    CGPoint e,f,g,h;
    
    BOOL frameMoved,middlePoint;
    int currentIndex,previousIndex;
    int k;
    
}
@property (nonatomic, strong) UIView *activePoint;

@property (strong, nonatomic) UIView *pointD;
@property (strong, nonatomic) UIView *pointC;
@property (strong, nonatomic) UIView *pointB;
@property (strong, nonatomic) UIView *pointA;
//middle points
@property (strong, nonatomic) UIView *pointE,*pointF,*pointG,*pointH;
@property (nonatomic, strong) NSMutableArray *points;

@property (nonatomic, assign)CGFloat offset_x;
@property (nonatomic, assign)CGFloat offset_y;

- (BOOL)frameEdited;
- (void)resetFrame;
- (CGPoint)coordinatesForPoint: (int)point withScaleFactor: (CGFloat)scaleFactor;

- (void)bottomLeftCornerToCGPoint: (CGPoint)point;
- (void)bottomRightCornerToCGPoint: (CGPoint)point;
- (void)topRightCornerToCGPoint: (CGPoint)point;
- (void)topLeftCornerToCGPoint: (CGPoint)point;


-(void)checkangle:(int)index;
-(void)findPointAtLocation:(CGPoint)location;
- (void)moveActivePointToLocation:(CGPoint)locationPoint andSize:(CGSize)newSize;
@end
