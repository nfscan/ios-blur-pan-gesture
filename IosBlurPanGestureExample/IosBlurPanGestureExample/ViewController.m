//
//  ViewController.m
//  IosBlurPanGestureExample
//
//  Version 0.0.1
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Paulo Miguel Almeida Rodenas <paulo.ubuntu@gmail.com>
//
//  Get the latest version from here:
//
//  https://github.com/pauloubuntu/ios-blur-pan-gesture
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *pagGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
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

- (IBAction)touchedUpResetButton:(id)sender {
    // Reseting the UIImage to its original state
    self.imageView.image = [UIImage imageNamed:@"DisplayImage"];
}
- (IBAction)touchedSaveToCameraRollButton:(id)sender {
    // Saving it to Camera Roll
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

#pragma mark - Delegate methods

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(!error)
    {
        [self buildAlert:@"Info" message:@"Image has been saved to Camera Roll =)"];
    }
    else
    {
        [self buildAlert:@"Error" message:@"Something went wrong when saving it =("];
    }
}


#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
-(void) buildAlert:(NSString*) title message:(NSString*) message
{
    if(IS_OS_8_OR_LATER)
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:okButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
    }
}

@end
