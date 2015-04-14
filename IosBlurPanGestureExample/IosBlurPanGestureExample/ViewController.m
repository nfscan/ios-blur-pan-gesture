//
//  ViewController.m
//  IosBlurPanGestureExample
//
//  Version 0.0.2
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
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (nonatomic) InputMethod inputMethod;
@property (strong, nonatomic) NSMutableArray* drawRectArray; //of CGRect
@end


@implementation ViewController

#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define DEFAULT_ROI_WIDTH   40
#define DEFAULT_ROI_HEIGHT   40

#pragma mark - UIViewController lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.inputMethod = DrawBlurContinuously;
}

#pragma mark - Actions methods

- (IBAction)panHandler:(UIPanGestureRecognizer *)sender {
    CGPoint pointTranslation = [sender locationInView:self.imageView];
    
    CGPoint imageTouchPoint = [self.imageView pixelPointFromViewPoint:pointTranslation];
    //Check if it's within UIImage's bounds
    if(!CGPointEqualToPoint(imageTouchPoint, CGPointZero)){
        NSLog(@"%s It's inside image's bounds",__PRETTY_FUNCTION__);

        //Extract the region of interest of that image
        CGRect rectOfInterest = {imageTouchPoint, CGSizeMake(DEFAULT_ROI_WIDTH, DEFAULT_ROI_HEIGHT)};
        
        if(self.inputMethod == DrawBlurContinuously)
        {
            // Blur
            [self blurRegionOfInterest:rectOfInterest];
            
        }
        else if (self.inputMethod == DrawBlurInARect)
        {

            switch (sender.state) {
                case UIGestureRecognizerStateBegan:
                    self.drawRectArray = [[NSMutableArray alloc] init];
                    break;
                case UIGestureRecognizerStateChanged:
                    [self.drawRectArray addObject:[NSValue valueWithCGRect:rectOfInterest]];
                    break;
                case UIGestureRecognizerStateEnded:
                {
                    CGFloat minx = [[self.drawRectArray valueForKeyPath:@"@min.x"] floatValue];
                    CGFloat miny = [[self.drawRectArray valueForKeyPath:@"@min.y"] floatValue];
                    CGFloat maxx = [[self.drawRectArray valueForKeyPath:@"@max.x"] floatValue];
                    CGFloat maxy = [[self.drawRectArray valueForKeyPath:@"@max.y"] floatValue];

                    // Calculate Rect we're going to blur later
                    rectOfInterest = CGRectMake(minx, miny, maxx - minx, maxy - miny);
                    
                    if(rectOfInterest.size.width < DEFAULT_ROI_WIDTH)
                    {
                        // Vertical Rect
                       rectOfInterest = CGRectMake(minx, miny, DEFAULT_ROI_WIDTH, maxy - miny);
                    }
                    else if (rectOfInterest.size.height < DEFAULT_ROI_HEIGHT)
                    {
                        // Horizontal Rect
                        rectOfInterest = CGRectMake(minx, miny, maxx - minx, DEFAULT_ROI_HEIGHT);
                    }

                    // Blur
                    [self blurRegionOfInterest:rectOfInterest];
                    
                    break;
                }

                default:
                    NSLog(@"%s state not handled: %ld",__PRETTY_FUNCTION__, sender.state);
                    break;
            }
        }
    
    }else{
        NSLog(@"%s It's outside image's bounds",__PRETTY_FUNCTION__);
    }
}

- (IBAction)touchedUpResetButton:(id)sender {
    // Reseting the UIImage to its original state
    self.imageView.image = [UIImage imageNamed:@"DisplayImage"];
}

- (IBAction)touchedUpInputMethodButton:(id)sender {
    [self setInputMethod:(self.inputMethod == DrawBlurContinuously ? DrawBlurInARect : DrawBlurContinuously)];
}


- (IBAction)touchedSaveToCameraRollButton:(id)sender {
    // Saving it to Camera Roll
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

#pragma mark - Utility methods

-(void) blurRegionOfInterest:(CGRect) rectOfInterest
{
    //Crop it
    UIImage *croppedImage = [self.imageView.image cropImage:rectOfInterest];
    //Apply a blur effect on it
    UIImage *effectImage = [croppedImage applyLightEffect];
    //Draw the blurred image on the original image
    UIImage* newImage = [self.imageView.image drawImage:effectImage inRect:rectOfInterest];
    self.imageView.image = newImage;
}

#pragma mark - Getters/Setters methods

- (void)setInputMethod:(InputMethod)inputMethod {
    if(inputMethod == DrawBlurContinuously)
    {
        self.descriptionLabel.text = @"Blurring image continuously";
    }
    else
    {
        self.descriptionLabel.text = @"Blurring image in a rect";
    }
    _inputMethod = inputMethod;
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
