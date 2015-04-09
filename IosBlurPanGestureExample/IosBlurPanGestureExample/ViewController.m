//
//  ViewController.m
//  IosBlurPanGestureExample
//
//  Created by Paulo Miguel Almeida on 4/9/15.
//  Copyright (c) 2015 Paulo Miguel Almeida Rodenas. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *pagGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic) CGRect imagePositionRect;
@end

@implementation ViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.imagePositionRect = [self imagePositionInImageView:self.imageView];
    NSLog(@"%s imagePositionrect: %@",__PRETTY_FUNCTION__, NSStringFromCGRect(self.imagePositionRect));
}

#pragma mark - Actions methods

- (IBAction)panHandler:(UIPanGestureRecognizer *)sender {
    CGPoint pointTranslation = [sender locationInView:self.imageView];
    
//    // code snippet from an answer on Stack Overflow - http://stackoverflow.com/a/17906177/832748
//    CGRect imageRect = AVMakeRectWithAspectRatioInsideRect(self.imageView.image.size, self.imageView.frame);
//    CGPoint imageTouchPoint = CGPointMake(pointTranslation.x - imageRect.origin.x, pointTranslation.y - imageRect.origin.y);
//    // --------
//    
//    NSLog(@"%s imageTouchPoint: %@",__PRETTY_FUNCTION__, NSStringFromCGPoint(imageTouchPoint));

    CGPoint imageTouchPoint = [self.imageView pixelPointFromViewPoint:pointTranslation];
    //Check if it's within UIImage's bounds
    if(!CGPointEqualToPoint(imageTouchPoint, CGPointZero)){
        NSLog(@"%s It's inside image's bounds",__PRETTY_FUNCTION__);
        
        CGRect rectOfInterest = {imageTouchPoint, CGSizeMake(40, 40)};
        
        UIImage *effectImage = nil;
        effectImage = [self.imageView.image applyDarkEffectWithRectOfInterest:rectOfInterest];
        self.imageView.image = effectImage;

    }else{
        NSLog(@"%s It's outside image's bounds",__PRETTY_FUNCTION__);
    }

}


// code snippet from an answer on Stack Overflow - http://stackoverflow.com/a/20646831/832748
- (CGRect) imagePositionInImageView:(UIImageView*)imageView
{
    float x = 0.0f;
    float y = 0.0f;
    float w = 0.0f;
    float h = 0.0f;
    CGFloat ratio = 0.0f;
    CGFloat horizontalRatio = imageView.frame.size.width / imageView.image.size.width;
    CGFloat verticalRatio = imageView.frame.size.height / imageView.image.size.height;
    
    switch (imageView.contentMode) {
        case UIViewContentModeScaleToFill:
            w = imageView.frame.size.width;
            h = imageView.frame.size.height;
            break;
        case UIViewContentModeScaleAspectFit:
            // contents scaled to fit with fixed aspect. remainder is transparent
            ratio = MIN(horizontalRatio, verticalRatio);
            w = imageView.image.size.width*ratio;
            h = imageView.image.size.height*ratio;
            x = (horizontalRatio == ratio ? 0 : ((imageView.frame.size.width - w)/2));
            y = (verticalRatio == ratio ? 0 : ((imageView.frame.size.height - h)/2));
            break;
        case UIViewContentModeScaleAspectFill:
            // contents scaled to fill with fixed aspect. some portion of content may be clipped.
            ratio = MAX(horizontalRatio, verticalRatio);
            w = imageView.image.size.width*ratio;
            h = imageView.image.size.height*ratio;
            x = (horizontalRatio == ratio ? 0 : ((imageView.frame.size.width - w)/2));
            y = (verticalRatio == ratio ? 0 : ((imageView.frame.size.height - h)/2));
            break;
        case UIViewContentModeCenter:
            // contents remain same size. positioned adjusted.
            w = imageView.image.size.width;
            h = imageView.image.size.height;
            x = (imageView.frame.size.width - w)/2;
            y = (imageView.frame.size.height - h)/2;
            break;
        case UIViewContentModeTop:
            w = imageView.image.size.width;
            h = imageView.image.size.height;
            x = (imageView.frame.size.width - w)/2;
            break;
        case UIViewContentModeBottom:
            w = imageView.image.size.width;
            h = imageView.image.size.height;
            y = (imageView.frame.size.height - h);
            x = (imageView.frame.size.width - w)/2;
            break;
        case UIViewContentModeLeft:
            w = imageView.image.size.width;
            h = imageView.image.size.height;
            y = (imageView.frame.size.height - h)/2;
            break;
        case UIViewContentModeRight:
            w = imageView.image.size.width;
            h = imageView.image.size.height;
            y = (imageView.frame.size.height - h)/2;
            x = (imageView.frame.size.width - w);
            break;
        case UIViewContentModeTopLeft:
            w = imageView.image.size.width;
            h = imageView.image.size.height;
            break;
        case UIViewContentModeTopRight:
            w = imageView.image.size.width;
            h = imageView.image.size.height;
            x = (imageView.frame.size.width - w);
            break;
        case UIViewContentModeBottomLeft:
            w = imageView.image.size.width;
            h = imageView.image.size.height;
            y = (imageView.frame.size.height - h);
            break;
        case UIViewContentModeBottomRight:
            w = imageView.image.size.width;
            h = imageView.image.size.height;
            y = (imageView.frame.size.height - h);
            x = (imageView.frame.size.width - w);
        default:
            break;
    }
    return CGRectMake(x, y, w, h);
}

@end
