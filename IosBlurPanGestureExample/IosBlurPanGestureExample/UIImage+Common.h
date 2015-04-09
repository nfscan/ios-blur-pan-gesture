//
//  UIImage+Common.h
//  IosBlurPanGestureExample
//
//  Created by Paulo Miguel Almeida on 4/9/15.
//  Copyright (c) 2015 Paulo Miguel Almeida Rodenas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Common)

-(UIImage*) cropImage:(CGRect) rectOfInterest;
- (UIImage *)drawImage:(UIImage *)inputImage inRect:(CGRect)frame;
@end
