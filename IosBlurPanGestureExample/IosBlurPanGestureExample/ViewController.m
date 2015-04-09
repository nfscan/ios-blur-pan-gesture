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


#pragma mark - Actions methods

- (IBAction)panHandler:(UIPanGestureRecognizer *)sender {
    CGPoint pointTranslation = [sender locationInView:self.imageView];
    
    CGPoint imageTouchPoint = [self.imageView pixelPointFromViewPoint:pointTranslation];
    //Check if it's within UIImage's bounds
    if(!CGPointEqualToPoint(imageTouchPoint, CGPointZero)){
        NSLog(@"%s It's inside image's bounds",__PRETTY_FUNCTION__);
        
        //Extract the region of interest of that image
        CGRect rectOfInterest = {imageTouchPoint, CGSizeMake(40, 40)};
        //Crop it
        UIImage *croppedImage = [self.imageView.image cropImage:rectOfInterest];
        //Apply a blur effect on it
        UIImage *effectImage = [croppedImage applyLightEffect];

        //Draw the blurred image on the original image
        UIImage* newImage = [self.imageView.image drawImage:effectImage inRect:rectOfInterest];
        self.imageView.image = newImage;

    }else{
        NSLog(@"%s It's outside image's bounds",__PRETTY_FUNCTION__);
    }

}


@end
