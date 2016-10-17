//
//  BLEditorViewController.m
//  OpenCvImageCorrection
//
//  Created by lonelyBanana on 16/10/12.
//  Copyright © 2016年 lonelyBanana. All rights reserved.
//
#import "BLEditorViewController.h"

#include <vector>
#import "BLCropView.h"
#import "BLOpenCVHelper.h"
#import "UIColor+HexRepresentation.h"
#import "UIImage+fixOrientation.h"
#import "UIImageView+ContentFrame.h"

#import "BLEditorItemView.h"

#import "BLImageViewController.h"
@interface BLEditorViewController (){
    CGFloat _rotateSlider;
    CGRect _initialRect,final_Rect;
    CGSize _newSize;
    CGFloat _myScale;
    int     _rotateTag;
}

@property (nonatomic, strong)UIImageView *myImageView;

@property (nonatomic, strong)BLCropView *cropRect;

@property (nonatomic, strong)BLEditorItemView *iteamView;

@property (nonatomic, strong)UIButton *backBtn;

@property (nonatomic, assign)BOOL itemHide;

@property (nonatomic, strong)NSDictionary *pointDic;

@end

@implementation BLEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.myImageView];
    [self.view addSubview:self.backBtn];
    [self.view updateConstraintsIfNeeded];
    [self.view setNeedsUpdateConstraints];
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
        _myImageView.contentMode = UIViewContentModeScaleAspectFill;
        _myImageView.backgroundColor = [UIColor whiteColor];
        _initialRect = _myImageView.frame;
        final_Rect = _myImageView.frame;
        _myImageView.userInteractionEnabled = YES;
    }
    return _myImageView;
}

-(BLCropView *)cropRect{
    if (!_cropRect) {
        CGRect cropFrame=CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-106);
        _cropRect= [[BLCropView alloc] initWithFrame:cropFrame];
        //        _cropRect.backgroundColor = blue_color;
        _cropRect.offset_x = _myImageView.contentFrame.origin.x;
        _cropRect.offset_y = _myImageView.contentFrame.origin.y;
        UIPanGestureRecognizer *singlePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(singlePan:)];
        singlePan.maximumNumberOfTouches = 1;
        [_cropRect addGestureRecognizer:singlePan];
    }
    return _cropRect;
}

-(BLEditorItemView *)iteamView{
    if (!_iteamView) {
        _iteamView = [[BLEditorItemView alloc] init];
        _iteamView.frame = CGRectMake(0, SCREEN_HEIGHT-106, SCREEN_WIDTH, 106);
        [_iteamView.rightBtn addTarget:self action:@selector(rightBtnDown) forControlEvents:UIControlEventTouchUpInside];
        [_iteamView.leftBtn addTarget:self action:@selector(leftBtnDown) forControlEvents:UIControlEventTouchUpInside];
        
        [_iteamView.delBtn addTarget:self action:@selector(delBtnDown) forControlEvents:UIControlEventTouchUpInside];
        
        [_iteamView.tureBtn addTarget:self action:@selector(trueBtnDown) forControlEvents:UIControlEventTouchUpInside];
          }
    return _iteamView;
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
#pragma mark - set
-(void)setEditorImg:(UIImage *)editorImg{
    _editorImg = editorImg;
    self.myImageView.image = editorImg;
}
#pragma mark - func
-(void)trueBtnDown{
    if([_cropRect frameEdited]){
        
        //Thanks To stackOverflow
        CGFloat scaleFactor =  [_myImageView contentScale];
        /*
         CGPoint pt1 = [_cropRect coordinatesForPoint:1 withScaleFactor:scaleFactor];
         CGPoint pt2 = [_cropRect coordinatesForPoint:2 withScaleFactor:scaleFactor];
         CGPoint pt3 = [_cropRect coordinatesForPoint:3 withScaleFactor:scaleFactor];
         CGPoint pt4 = [_cropRect coordinatesForPoint:4 withScaleFactor:scaleFactor];
         
         CGPoint ptBottomLeft =[(NSValue *)[self.pointDic objectForKey:@"3"] CGPointValue];// CGPointMake(pt1.x-_editorImageView.contentFrame.origin.x*2, pt1.y-_editorImageView.contentFrame.origin.y);
         CGPoint ptBottomRight = [(NSValue *)[self.pointDic objectForKey:@"2"] CGPointValue];//CGPointMake(pt2.x-_editorImageView.contentFrame.origin.x*2, pt2.y-_editorImageView.contentFrame.origin.y);
         CGPoint ptTopRight = [(NSValue *)[self.pointDic objectForKey:@"1"] CGPointValue];//CGPointMake(pt3.x-_editorImageView.contentFrame.origin.x*2, pt3.y-_editorImageView.contentFrame.origin.y);
         CGPoint ptTopLeft =[(NSValue *)[self.pointDic objectForKey:@"0"] CGPointValue];// CGPointMake(pt4.x-_editorImageView.contentFrame.origin.x*2, pt4.y-_editorImageView.contentFrame.origin.y);
         */
        CGPoint ptBottomLeft = [_cropRect coordinatesForPoint:1 withScaleFactor:scaleFactor];
        CGPoint ptBottomRight = [_cropRect coordinatesForPoint:2 withScaleFactor:scaleFactor];
        CGPoint ptTopRight = [_cropRect coordinatesForPoint:3 withScaleFactor:scaleFactor];
        CGPoint ptTopLeft = [_cropRect coordinatesForPoint:4 withScaleFactor:scaleFactor];
        
        NSLog(@"%f--%f",ptTopLeft.x,ptTopLeft.y);
        CGFloat w1 = sqrt( pow(ptBottomRight.x - ptBottomLeft.x , 2) + pow(ptBottomRight.x - ptBottomLeft.x, 2));
        CGFloat w2 = sqrt( pow(ptTopRight.x - ptTopLeft.x , 2) + pow(ptTopRight.x - ptTopLeft.x, 2));
        
        CGFloat h1 = sqrt( pow(ptTopRight.y - ptBottomRight.y , 2) + pow(ptTopRight.y - ptBottomRight.y, 2));
        CGFloat h2 = sqrt( pow(ptTopLeft.y - ptBottomLeft.y , 2) + pow(ptTopLeft.y - ptBottomLeft.y, 2));
        
        CGFloat maxWidth = (w1 < w2) ? w1 : w2;
        CGFloat maxHeight = (h1 < h2) ? h1 : h2;
        
        
        NSLog(@"%f--%f",maxWidth,maxHeight);
        cv::Point2f src[4], dst[4];
        //                src[0].x = ptTopLeft.x-35;
        //                src[0].y = ptTopLeft.y-20;
        //                src[1].x = ptTopRight.x-95;
        //                src[1].y = ptTopRight.y-20;
        //                src[2].x = ptBottomRight.x-95;
        //                src[2].y = ptBottomRight.y+20;
        //                src[3].x = ptBottomLeft.x-35;
        //                src[3].y = ptBottomLeft.y+20;
        src[0].x = ptTopLeft.x;
        src[0].y = ptTopLeft.y;
        src[1].x = ptTopRight.x;
        src[1].y = ptTopRight.y;
        src[2].x = ptBottomRight.x;
        src[2].y = ptBottomRight.y;
        src[3].x = ptBottomLeft.x;
        src[3].y = ptBottomLeft.y;
        
        dst[0].x = 0;
        dst[0].y = 0;
        dst[1].x = maxWidth - 1;
        dst[1].y = 0;
        dst[2].x = maxWidth - 1;
        dst[2].y = maxHeight - 1;
        dst[3].x = 0;
        dst[3].y = maxHeight - 1;
        
        cv::Mat undistorted = cv::Mat( cvSize(maxWidth,maxHeight), CV_8UC4);
        cv::Mat original = [BLOpenCVHelper cvMatFromUIImage:_editorImg];
        
        NSLog(@"%f %f %f %f----%f",ptBottomLeft.x,ptBottomRight.x,ptTopRight.x,ptTopLeft.x,scaleFactor);
        cv::warpPerspective(original, undistorted, cv::getPerspectiveTransform(src, dst), cvSize(maxWidth, maxHeight));
        
       BLImageViewController *edcVc = [[BLImageViewController alloc] init];
        UIImage *img = nil;
        if (_rotateSlider == 0.5f||_rotateSlider == -1.5) {
            img =  [UIImage imageWithCGImage:[BLOpenCVHelper UIImageFromCVMat:undistorted].CGImage scale:1 orientation:UIImageOrientationRight];
        }else if(std::abs(_rotateSlider) == 1.f||_rotateSlider==-3){
            img = [UIImage imageWithCGImage:[BLOpenCVHelper UIImageFromCVMat:undistorted].CGImage scale:1 orientation:UIImageOrientationDown];
        }else if (_rotateSlider == -0.5 || _rotateSlider == -2.5){
            img =[UIImage imageWithCGImage:[BLOpenCVHelper UIImageFromCVMat:undistorted].CGImage scale:1 orientation:UIImageOrientationLeft];
        }else{
            img = [UIImage imageWithCGImage:[BLOpenCVHelper UIImageFromCVMat:undistorted].CGImage scale:1 orientation:UIImageOrientationUp];
        }
        
        edcVc.myImage = img;//[MMOpenCVHelper UIImageFromCVMat:undistorted];
        [self.navigationController pushViewController:edcVc animated:YES];
        original.release();
        undistorted.release();
    }
}


-(void)leftBtnDown{
    CGFloat value = (int)floorf((_rotateSlider + 1)*2) - 1;
    NSLog(@"%f",value);
    if(value<-4){ value -= -4; }
    _rotateSlider = value / 2 - 1;
    [UIView animateWithDuration:0.5 animations:^{
        [self rotateStateDidChange];
    }];
}

-(void)rightBtnDown{
    CGFloat value = (int)floorf((_rotateSlider + 1)*2) + 1;
    
    if(value>4){ value -= 4; }
    _rotateSlider = value / 2 - 1;
    [UIView animateWithDuration:0.5 animations:^{
        [self rotateStateDidChange];
    }];
}

-(void)delBtnDown{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)disMissBtnDown{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark OpenCV
- (void)detectEdges
{
    cv::Mat original = [BLOpenCVHelper cvMatFromUIImage:_myImageView.image];
    CGSize targetSize = self.myImageView.contentSize;
    cv::resize(original, original, cvSize(targetSize.width, targetSize.height));
    
    std::vector<std::vector<cv::Point>>squares;
    std::vector<cv::Point> largest_square;
    
    find_squares(original, squares);
    find_largest_square(squares, largest_square);
    
    if (largest_square.size() == 4)
    {
        
        // Manually sorting points, needs major improvement. Sorry.
        
        NSMutableArray *points = [NSMutableArray array];
        NSMutableDictionary *sortedPoints = [NSMutableDictionary dictionary];
        
        for (int i = 0; i < 4; i++)
        {
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:CGPointMake(largest_square[i].x, largest_square[i].y)], @"point" , [NSNumber numberWithInt:(largest_square[i].x + largest_square[i].y)], @"value", nil];
            [points addObject:dict];
        }
        
        int min = [[points valueForKeyPath:@"@min.value"] intValue];
        int max = [[points valueForKeyPath:@"@max.value"] intValue];
        
        int minIndex = 0;
        int maxIndex = 0;
        
        int missingIndexOne = 0;
        int missingIndexTwo = 0;
        
        for (int i = 0; i < 4; i++)
        {
            NSDictionary *dict = [points objectAtIndex:i];
            
            if ([[dict objectForKey:@"value"] intValue] == min)
            {
                [sortedPoints setObject:[dict objectForKey:@"point"] forKey:@"0"];
                minIndex = i;
                continue;
            }
            
            if ([[dict objectForKey:@"value"] intValue] == max)
            {
                [sortedPoints setObject:[dict objectForKey:@"point"] forKey:@"2"];
                maxIndex = i;
                continue;
            }
            
            NSLog(@"MSSSING %i", i);
            
            missingIndexOne = i;
        }
        
        for (int i = 0; i < 4; i++)
        {
            if (missingIndexOne != i && minIndex != i && maxIndex != i)
            {
                missingIndexTwo = i;
            }
        }
        
        
        if (largest_square[missingIndexOne].x < largest_square[missingIndexTwo].x)
        {
            //2nd Point Found
            [sortedPoints setObject:[[points objectAtIndex:missingIndexOne] objectForKey:@"point"] forKey:@"3"];
            [sortedPoints setObject:[[points objectAtIndex:missingIndexTwo] objectForKey:@"point"] forKey:@"1"];
        }
        else
        {
            //4rd Point Found
            [sortedPoints setObject:[[points objectAtIndex:missingIndexOne] objectForKey:@"point"] forKey:@"1"];
            [sortedPoints setObject:[[points objectAtIndex:missingIndexTwo] objectForKey:@"point"] forKey:@"3"];
        }
        CGPoint point0 = [(NSValue *)[sortedPoints objectForKey:@"0"] CGPointValue];
        CGPoint point1 = [(NSValue *)[sortedPoints objectForKey:@"1"] CGPointValue];
        CGPoint point2 = [(NSValue *)[sortedPoints objectForKey:@"2"] CGPointValue];
        CGPoint point3 = [(NSValue *)[sortedPoints objectForKey:@"3"] CGPointValue];
        
        
        [_cropRect topLeftCornerToCGPoint:CGPointMake(point0.x+_myImageView.contentFrame.origin.x, point0.y+_myImageView.contentFrame.origin.y)];
        [_cropRect topRightCornerToCGPoint:CGPointMake(point1.x+_myImageView.contentFrame.origin.x, point1.y+_myImageView.contentFrame.origin.y)];
        [_cropRect bottomRightCornerToCGPoint:CGPointMake(point2.x+_myImageView.contentFrame.origin.x, point2.y+_myImageView.contentFrame.origin.y)];
        [_cropRect bottomLeftCornerToCGPoint:CGPointMake(point3.x+_myImageView.contentFrame.origin.x, point3.y+_myImageView.contentFrame.origin.y)];
        
        //        [self.pointArr addObject:[sortedPoints objectForKey:@"0"]];
        //        self.pointDic = sortedPoints;
        NSLog(@"%@ Sorted Points",sortedPoints);
        
        
        
    }
    else{
        [_cropRect topLeftCornerToCGPoint:CGPointMake(50, 100)];
        [_cropRect topRightCornerToCGPoint:CGPointMake(SCREEN_WIDTH-50, 100)];
        [_cropRect bottomRightCornerToCGPoint:CGPointMake(SCREEN_WIDTH-50, SCREEN_HEIGHT-126)];
        [_cropRect bottomLeftCornerToCGPoint:CGPointMake(50, SCREEN_HEIGHT-126)];
    }
    
    original.release();
    
    
    
}


// http://stackoverflow.com/questions/8667818/opencv-c-obj-c-detecting-a-sheet-of-paper-square-detection
void find_squares(cv::Mat& image, std::vector<std::vector<cv::Point>>&squares) {
    
    // blur will enhance edge detection
    
    cv::Mat blurred(image);
    //    medianBlur(image, blurred, 9);
    GaussianBlur(image, blurred, cvSize(11,11), 0);//change from median blur to gaussian for more accuracy of square detection
    
    cv::Mat gray0(blurred.size(), CV_8U), gray;
    std::vector<std::vector<cv::Point> > contours;
    
    // find squares in every color plane of the image
    for (int c = 0; c < 3; c++)
    {
        int ch[] = {c, 0};
        mixChannels(&blurred, 1, &gray0, 1, ch, 1);
        
        // try several threshold levels
        const int threshold_level = 2;
        for (int l = 0; l < threshold_level; l++)
        {
            // Use Canny instead of zero threshold level!
            // Canny helps to catch squares with gradient shading
            if (l == 0)
            {
                Canny(gray0, gray, 10, 20, 3); //
                //                Canny(gray0, gray, 0, 50, 5);
                
                // Dilate helps to remove potential holes between edge segments
                dilate(gray, gray, cv::Mat(), cv::Point(-1,-1));
            }
            else
            {
                gray = gray0 >= (l+1) * 255 / threshold_level;
            }
            
            // Find contours and store them in a list
            findContours(gray, contours, CV_RETR_LIST, CV_CHAIN_APPROX_SIMPLE);
            
            // Test contours
            std::vector<cv::Point> approx;
            for (size_t i = 0; i < contours.size(); i++)
            {
                // approximate contour with accuracy proportional
                // to the contour perimeter
                approxPolyDP(cv::Mat(contours[i]), approx, arcLength(cv::Mat(contours[i]), true)*0.02, true);
                
                // Note: absolute value of an area is used because
                // area may be positive or negative - in accordance with the
                // contour orientation
                if (approx.size() == 4 &&
                    fabs(contourArea(cv::Mat(approx))) > 1000 &&
                    isContourConvex(cv::Mat(approx)))
                {
                    double maxCosine = 0;
                    
                    for (int j = 2; j < 5; j++)
                    {
                        double cosine = fabs(angle(approx[j%4], approx[j-2], approx[j-1]));
                        maxCosine = MAX(maxCosine, cosine);
                    }
                    
                    if (maxCosine < 0.3)
                        squares.push_back(approx);
                }
            }
        }
    }
}

void find_largest_square(const std::vector<std::vector<cv::Point> >& squares, std::vector<cv::Point>& biggest_square)
{
    if (!squares.size())
    {
        // no squares detected
        return;
    }
    
    int max_width = 0;
    int max_height = 0;
    int max_square_idx = 0;
    
    for (size_t i = 0; i < squares.size(); i++)
    {
        // Convert a set of 4 unordered Points into a meaningful cv::Rect structure.
        cv::Rect rectangle = boundingRect(cv::Mat(squares[i]));
        
        //        std::cout << "find_largest_square: #" << i << " rectangle x:" << rectangle.x << " y:" << rectangle.y << " " << rectangle.width << "x" << rectangle.height << std::endl;
        
        printf("find_largest_square: %zu rectangle x:%d y:%d \n %d x %d \n\n",i,rectangle.x,rectangle.y,rectangle.width,rectangle.height);
        // Store the index position of the biggest square found
        if ((rectangle.width >= max_width) && (rectangle.height >= max_height))
        {
            max_width = rectangle.width;
            max_height = rectangle.height;
            max_square_idx = i;
        }
    }
    
    biggest_square = squares[max_square_idx];
}


double angle( cv::Point pt1, cv::Point pt2, cv::Point pt0 ) {
    double dx1 = pt1.x - pt0.x;
    double dy1 = pt1.y - pt0.y;
    double dx2 = pt2.x - pt0.x;
    double dy2 = pt2.y - pt0.y;
    return (dx1*dx2 + dy1*dy2)/sqrt((dx1*dx1 + dy1*dy1)*(dx2*dx2 + dy2*dy2) + 1e-10);
}

cv::Mat debugSquares( std::vector<std::vector<cv::Point> > squares, cv::Mat image ){
    
    NSLog(@"DEBUG!/?!");
    for ( unsigned int i = 0; i< squares.size(); i++ ) {
        // draw contour
        
        NSLog(@"LOOP!");
        
        cv::drawContours(image, squares, i, cv::Scalar(255,0,0), 1, 8, std::vector<cv::Vec4i>(), 0, cv::Point());
        
        // draw bounding rect
        cv::Rect rect = boundingRect(cv::Mat(squares[i]));
        cv::rectangle(image, rect.tl(), rect.br(), cv::Scalar(0,255,0), 2, 8, 0);
        
        // draw rotated rect
        cv::RotatedRect minRect = minAreaRect(cv::Mat(squares[i]));
        cv::Point2f rect_points[4];
        minRect.points( rect_points );
        for ( int j = 0; j < 4; j++ ) {
            cv::line( image, rect_points[j], rect_points[(j+1)%4], cv::Scalar(0,0,255), 1, 8 ); // blue
        }
    }
    
    return image;
}

-(void)singlePan:(UIPanGestureRecognizer *)gesture{
    CGPoint posInStretch = [gesture locationInView:_cropRect];
    //    CGPoint newPoint = CGPointMake(posInStretch.x+_editorImageView.contentFrame.origin.x, posInStretch.y+_editorImageView.contentFrame.origin.y);
    if(gesture.state==UIGestureRecognizerStateBegan){
        [_cropRect findPointAtLocation:posInStretch];
    }
    if(gesture.state==UIGestureRecognizerStateEnded){
        _cropRect.activePoint.backgroundColor = [UIColor grayColor];
        _cropRect.activePoint = nil;
        [_cropRect checkangle:0];
    }
    
    [_cropRect moveActivePointToLocation:posInStretch andSize:_newSize];
    
}

#pragma mark Animate
- (CATransform3D)rotateTransform:(CATransform3D)initialTransform clockwise:(BOOL)clockwise
{
    CGFloat arg = _rotateSlider*M_PI;
    if(!clockwise){
        arg *= -1;
    }
    
    CATransform3D transform = initialTransform;
    transform = CATransform3DRotate(transform, arg, 0, 0, 1);
    transform = CATransform3DRotate(transform, 0*M_PI, 0, 1, 0);
    transform = CATransform3DRotate(transform, 0*M_PI, 1, 0, 0);
    
    return transform;
}

- (void)rotateStateDidChange
{
    CATransform3D transform = [self rotateTransform:CATransform3DIdentity clockwise:YES];
    
    CGFloat arg = _rotateSlider*M_PI;
    NSLog(@"%f==%f",arg,_rotateSlider);
    CGFloat Wnew = fabs(_initialRect.size.width * cos(arg)) + fabs(_initialRect.size.height * sin(arg));
    CGFloat Hnew = fabs(_initialRect.size.width * sin(arg)) + fabs(_initialRect.size.height * cos(arg));
    
    CGFloat Rw = final_Rect.size.width / Wnew;
    CGFloat Rh = final_Rect.size.height / Hnew;
    _myScale = MIN(Rw, Rh) * 1;
    
    //    _cropRect.bounds = CGRectMake(0, 0, Wnew, Hnew);
    transform = CATransform3DScale(transform, _myScale, _myScale, 1);
    _myImageView.layer.transform = transform;
    _cropRect.layer.transform = transform;
    //    [self detectEdges];
    
    //    _editorImageView.image.imageOrientation =
    _newSize = CGSizeMake(_myImageView.bounds.size.width, _myImageView.bounds.size.height);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
