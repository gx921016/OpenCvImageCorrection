//
//  BLOpenCVHelper.h
//  OpenCvImageCorrection
//
//  Created by lonelyBanana on 16/10/8.
//  Copyright © 2016年 lonelyBanana. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>

@interface BLOpenCVHelper : NSObject
+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;

+ (cv::Mat)cvMatFromAdjustedUIImage:(UIImage *)image;
+ (cv::Mat)cvMatFromUIImage:(UIImage *)image;
+ (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image;
+ (cv::Mat)cvMatGrayFromAdjustedUIImage:(UIImage *)image;

@end
