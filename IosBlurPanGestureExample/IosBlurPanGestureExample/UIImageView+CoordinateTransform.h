//
//  UIImageView+CoordinateTransform.h
//  IosBlurPanGestureExample
//
//  Code extracted from http://b2cloud.com.au/tutorial/uiimageview-transforming-touch-coordinates-to-pixel-coordinates/
//
//  Created by Paulo Miguel Almeida on 4/9/15.
//  Copyright (c) 2015 Paulo Miguel Almeida Rodenas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CoordinateTransform)

-(CGPoint) pixelPointFromViewPoint:(CGPoint)viewPoint;
-(CGPoint) viewPointFromPixelPoint:(CGPoint)pixelPoint;
-(CGSize) pixelSizeFromViewSize:(CGSize)viewSize;
-(CGSize) viewSizeFromPixelSize:(CGSize)pixelSize;

@end
