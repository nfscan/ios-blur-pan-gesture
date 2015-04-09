//
//  UIImageView+CoordinateTransform.m
//  IosBlurPanGestureExample
//
//  Code extracted from http://b2cloud.com.au/tutorial/uiimageview-transforming-touch-coordinates-to-pixel-coordinates/
//
//  Created by Paulo Miguel Almeida on 4/9/15.
//  Copyright (c) 2015 Paulo Miguel Almeida Rodenas. All rights reserved.
//

#import "UIImageView+CoordinateTransform.h"

@implementation UIImageView (CoordinateTransform)

-(CGPoint) pixelPointFromViewPoint:(CGPoint)touch
{
    // Sanity check to see whether the touch is actually in the view
    if(touch.x >= 0.0 && touch.x <= self.frame.size.width && touch.y >= 0.0 && touch.y <= self.frame.size.height)
    {
        // http://developer.apple.com/library/ios/#DOCUMENTATION/UIKit/Reference/UIView_Class/UIView/UIView.html#//apple_ref/occ/cl/UIView
        switch(self.contentMode)
        {
                // Simply scale the image size by the size of the frame
            case UIViewContentModeScaleToFill:
                // Redraw is basically the same as scale to fill but redraws itself in the drawRect call (so when bounds change)
            case UIViewContentModeRedraw:
                return CGPointMake(floor(touch.x/(self.frame.size.width/self.image.size.width)),floor(touch.y/(self.frame.size.height/self.image.size.height)));
                // Although the documentation doesn't state it, we will assume a centered image. This mode makes the image fit into the view with its aspect ratio
            case UIViewContentModeScaleAspectFit:
            {
                // If the aspect ratio favours width over height in relation to the images aspect ratio
                if(self.frame.size.width/self.frame.size.height > self.image.size.width/self.image.size.height)
                {
                    // Checking whether the touch coordinate is not in a 'blank' spot on the view
                    if(touch.x >= (self.frame.size.width/2.0)-(((self.frame.size.height/self.image.size.height)*self.image.size.width)/2.0)
                       && touch.x <= (self.frame.size.width/2.0)+(((self.frame.size.height/self.image.size.height)*self.image.size.width)/2.0))
                    {
                        // Scaling by using the height ratio as a reference, and minusing the blank x coordiantes on the view
                        return CGPointMake(floor((touch.x-((self.frame.size.width/2.0)-(((self.frame.size.height/self.image.size.height)*self.image.size.width)/2.0)))/(self.frame.size.height/self.image.size.height)),floor(touch.y/(self.frame.size.height/self.image.size.height)));
                    }
                    break;
                }
                // Or if the aspect ratio favours height over width in relation to the images aspect ratio
                else if(self.frame.size.width/self.frame.size.height < self.image.size.width/self.image.size.height)
                {
                    // Obtaining half of the view that is taken up by the aspect ratio
                    CGFloat halfAspectFit = ((self.frame.size.width/self.image.size.width)*self.image.size.height)/2.0;
                    // Checking whether the touch coordinate is not in a 'blank' spot on the view
                    if(touch.y >= (self.frame.size.height/2.0)-halfAspectFit
                       && touch.y <= (self.frame.size.height/2.0)+halfAspectFit)
                    {
                        // Scaling by using the width ratio as a reference, and minusing the blank y coordinates on the view
                        return CGPointMake(floor(touch.x/(self.frame.size.width/self.image.size.width)),floor((touch.y-((self.frame.size.width/2.0)-halfAspectFit))/(self.frame.size.height/self.image.size.height)));
                    }
                }
                // This is just the same as a scale to fill mode if the aspect ratios from the view and the image are the same
                else return CGPointMake(floor(touch.x/(self.frame.size.width/self.image.size.width)),floor(touch.y/(self.frame.size.width/self.image.size.height)));
                break;
            }
                // This fills the view with the image in its aspect ratio, meaning that it could get cut off in either axis
            case UIViewContentModeScaleAspectFill:
            {
                // If the aspect ratio favours width over height in relation to the images aspect ratio
                if(self.frame.size.width/self.frame.size.height > self.image.size.width/self.image.size.height)
                {
                    // Scaling by using the width ratio, this will cut off some height
                    return CGPointMake(floor(touch.x/(self.frame.size.width/self.image.size.width)),floor(touch.y/(self.frame.size.width/self.image.size.width)));
                }
                // If the aspect ratio favours height over width in relation to the images aspect ratio
                else if(self.frame.size.width/self.frame.size.height < self.image.size.width/self.image.size.height)
                {
                    // Scaling by using the height ratio, this will cut off some width
                    return CGPointMake(floor(touch.x/(self.frame.size.height/self.image.size.height)),floor(touch.y/(self.frame.size.height/self.image.size.height)));
                }
                // Again if the aspect ratios are the same, then it will just be another copy of scale to fill mode
                else return CGPointMake(floor(touch.x/(self.frame.size.width/self.image.size.width)),floor(touch.y/(self.frame.size.width/self.image.size.height)));
                break;
            }
                // This centers the image in the view both vertically and horizontally
            case UIViewContentModeCenter:
            {
                // Check whether our touch is on the image centered vertically and horizontally
                if(touch.x >= (self.frame.size.width/2.0)-(self.image.size.width/2.0)
                   && touch.x <= (self.frame.size.width/2.0)+(self.image.size.width/2.0)
                   && touch.y >= (self.frame.size.height/2.0)-(self.image.size.height/2.0)
                   && touch.y <= (self.frame.size.height/2.0)+(self.image.size.height/2.0))
                    // Just return the touch coordinates and minus the offset
                    return CGPointMake(floor(touch.x-((self.frame.size.width/2.0)-(self.image.size.width/2.0))),floor(touch.y-((self.frame.size.height/2.0)-(self.image.size.height/2.0))));
                break;
            }
                // This centers the image horizontally and moves it up to the top
            case UIViewContentModeTop:
            {
                // Check whether our touch is on the image centered horizontally and put at the vertical start
                if(touch.x >= (self.frame.size.width/2.0)-(self.image.size.width/2.0)
                   && touch.x <= (self.frame.size.width/2.0)+(self.image.size.width/2.0)
                   && touch.y <= self.image.size.height)
                    // Just return the touch coordinates and minus the offset
                    return CGPointMake(floor(touch.x-((self.frame.size.width/2.0)-(self.image.size.width/2.0))),floor(touch.y));
                break;
            }
                // This centers the image horizontally and moves it down to the bottom
            case UIViewContentModeBottom:
            {
                // Check whether our touch is on the image centered horizontally and put at the vertical end
                if(touch.x >= (self.frame.size.width/2.0)-(self.image.size.width/2.0)
                   && touch.x <= (self.frame.size.width/2.0)+(self.image.size.width/2.0)
                   && touch.y >= self.frame.size.height-self.image.size.height)
                    // Just return the touch coordinates and minus the offset
                    return CGPointMake(floor(touch.x-((self.frame.size.width/2.0)-(self.image.size.width/2.0))),floor(touch.y-(self.frame.size.height-self.image.size.height)));
                break;
            }
                // This moves the image to the horizontal start and centers it vertically
            case UIViewContentModeLeft:
            {
                // Check whether our touch is on the image at the horizontal start and centered vertically
                if(touch.x <= self.image.size.width
                   && touch.y >= (self.frame.size.height/2.0)-(self.image.size.height/2.0)
                   && touch.y <= (self.frame.size.height/2.0)+(self.image.size.height/2.0))
                    return CGPointMake(floor(touch.x),floor(touch.y-((self.frame.size.height/2.0)-(self.image.size.height/2.0))));
                break;
            }
                // This moves the image to the horizontal end and centers it vertically
            case UIViewContentModeRight:
            {
                if(touch.x >= self.frame.size.width-self.image.size.width
                   && touch.y >= (self.frame.size.height/2.0)-(self.image.size.height/2.0)
                   && touch.y <= (self.frame.size.height/2.0)+(self.image.size.height/2.0))
                    return CGPointMake(floor(touch.x-(self.frame.size.width-self.image.size.width)),floor(touch.y-((self.frame.size.height/2.0)-(self.image.size.height/2.0))));
                break;
            }
                // This simply moves the image to the horizontal and vertical start
            case UIViewContentModeTopLeft:
            {
                if(touch.x <= self.image.size.width
                   && touch.x <= self.image.size.height)
                    // My favourite
                    return CGPointMake(floor(touch.x),floor(touch.y));
                break;
            }
                // This moves the image to the horizontal end and vertical start
            case UIViewContentModeTopRight:
            {
                if(touch.x >= self.frame.size.width-self.image.size.width
                   && touch.y <= self.image.size.height)
                    return CGPointMake(floor(touch.x-(self.frame.size.width-self.image.size.width)),floor(touch.y));
                break;
            }
                // This moves the image to the horizontal start and vertical end
            case UIViewContentModeBottomLeft:
            {
                if(touch.x <= self.image.size.width
                   && touch.y <= self.frame.size.height-self.image.size.height)
                    return CGPointMake(floor(touch.x),floor(touch.y-(self.frame.size.height-self.image.size.height)));
                break;
            }
                // This moves the image to the horizontal and vertical end
            case UIViewContentModeBottomRight:
            {
                if(touch.x <= self.frame.size.width-self.image.size.width
                   && touch.y <= self.frame.size.height-self.image.size.height)
                    return CGPointMake(floor(touch.x-(self.frame.size.width-self.image.size.width)),floor(touch.y-(self.frame.size.height-self.image.size.height)));
                break;
            }
            default: break;
        }
    }
    return CGPointZero;
}

-(CGPoint) viewPointFromPixelPoint:(CGPoint)pixelPoint
{
    // Sanity check to see whether the pixel point is actually in the image
    if(pixelPoint.x >= 0.0 && pixelPoint.x <= self.image.size.width && pixelPoint.y >= 0.0 && pixelPoint.y <= self.image.size.height)
    {
        switch(self.contentMode)
        {
            case UIViewContentModeScaleToFill:
            case UIViewContentModeRedraw:
                return CGPointMake(floor(pixelPoint.x*(self.frame.size.width/self.image.size.width)),floor(pixelPoint.y*(self.frame.size.height/self.image.size.height)));
            case UIViewContentModeScaleAspectFit:
            {
                if(self.frame.size.width/self.frame.size.height > self.image.size.width/self.image.size.height)
                    return CGPointMake(floor(((self.frame.size.width/2.0)-((self.image.size.width/2.0)*(self.frame.size.height/self.image.size.height)))+pixelPoint.x*(self.frame.size.height/self.image.size.height)),floor(pixelPoint.y*(self.frame.size.height/self.image.size.height)));
                else if(self.frame.size.width/self.frame.size.height < self.image.size.width/self.image.size.height)
                    return CGPointMake(floor(pixelPoint.x*(self.frame.size.width/self.image.size.width)),floor(((self.frame.size.height/2.0)-((self.image.size.height/2.0)*(self.frame.size.width/self.image.size.width)))+pixelPoint.y*(self.frame.size.width/self.image.size.width)));
                return CGPointMake(floor(pixelPoint.x*(self.frame.size.width/self.image.size.width)),floor(pixelPoint.y*(self.frame.size.height/self.image.size.height)));
            }
            case UIViewContentModeScaleAspectFill:
            {
                if(self.frame.size.width/self.frame.size.height > self.image.size.width/self.image.size.height)
                    return CGPointMake(floor(pixelPoint.x*(self.frame.size.width/self.image.size.width)),floor(pixelPoint.y*(self.frame.size.width/self.image.size.width)));
                else if(self.frame.size.width/self.frame.size.height < self.image.size.width/self.image.size.height)
                    return CGPointMake(floor(pixelPoint.x*(self.frame.size.height/self.image.size.height)),floor(pixelPoint.y*(self.frame.size.height/self.image.size.height)));
                return CGPointMake(floor(pixelPoint.x*(self.frame.size.width/self.image.size.width)),floor(pixelPoint.y*(self.frame.size.height/self.image.size.height)));
            }
            case UIViewContentModeCenter:
                return CGPointMake(floor(pixelPoint.x+(self.frame.size.width/2.0)-(self.image.size.width/2.0)),floor(pixelPoint.y+(self.frame.size.height/2.0)-(self.image.size.height/2.0)));
            case UIViewContentModeTop:
                return CGPointMake(floor(pixelPoint.x+(self.frame.size.width/2.0)-(self.image.size.width/2.0)),floor(pixelPoint.y));
            case UIViewContentModeBottom:
                return CGPointMake(floor(pixelPoint.x+(self.frame.size.width/2.0)-(self.image.size.width/2.0)),floor(pixelPoint.y-(self.frame.size.height-self.image.size.height)));
            case UIViewContentModeLeft:
                return CGPointMake(floor(pixelPoint.x),floor(pixelPoint.y+(self.frame.size.height/2.0)-(self.image.size.height/2.0)));
            case UIViewContentModeRight:
                return CGPointMake(floor(pixelPoint.x-(self.frame.size.width-self.image.size.width)),floor(pixelPoint.y+(self.frame.size.height/2.0)-(self.image.size.height/2.0)));
            case UIViewContentModeTopLeft:
                return CGPointMake(floor(pixelPoint.x),floor(pixelPoint.y));
            case UIViewContentModeTopRight:
                return CGPointMake(floor(pixelPoint.x-(self.frame.size.width-self.image.size.width)),floor(pixelPoint.y));
            case UIViewContentModeBottomLeft:
                return CGPointMake(floor(pixelPoint.x),floor(pixelPoint.y-(self.frame.size.height-self.image.size.height)));
            case UIViewContentModeBottomRight:
                return CGPointMake(floor(pixelPoint.x-(self.frame.size.width-self.image.size.width)),floor(pixelPoint.y-(self.frame.size.height-self.image.size.height)));
            default: break;
        }
    }
    return CGPointZero;
}

-(CGSize) pixelSizeFromViewSize:(CGSize)viewSize
{
    if(viewSize.width >= 0.0 && viewSize.width <= self.frame.size.width && viewSize.height >= 0.0 && viewSize.height <= self.frame.size.height)
    {
        switch(self.contentMode)
        {
            case UIViewContentModeScaleToFill:
            case UIViewContentModeRedraw:
                return CGSizeMake(floor(viewSize.width/(self.frame.size.width/self.image.size.width)),floor(viewSize.height/(self.frame.size.height/self.image.size.height)));
            case UIViewContentModeScaleAspectFit:
            {
                if(self.frame.size.width/self.frame.size.height > self.image.size.width/self.image.size.height)
                    return CGSizeMake(floor(viewSize.width/(self.frame.size.height/self.image.size.height)),floor(viewSize.height/(self.frame.size.height/self.image.size.height)));
                else if(self.frame.size.width/self.frame.size.height < self.image.size.width/self.image.size.height)
                    return CGSizeMake(floor(viewSize.width/(self.frame.size.width/self.image.size.width)),floor(viewSize.height/(self.frame.size.height/self.image.size.height)));
                return CGSizeMake(floor(viewSize.width/(self.frame.size.width/self.image.size.width)),floor(viewSize.height/(self.frame.size.height/self.image.size.height)));
            }
            case UIViewContentModeScaleAspectFill:
            {
                if(self.frame.size.width/self.frame.size.height > self.image.size.width/self.image.size.height)
                    return CGSizeMake(floor(viewSize.width/(self.frame.size.width/self.image.size.width)),floor(viewSize.height/(self.frame.size.width/self.image.size.width)));
                else if(self.frame.size.width/self.frame.size.height < self.image.size.width/self.image.size.height)
                    return CGSizeMake(floor(viewSize.width/(self.frame.size.height/self.image.size.height)),floor(viewSize.height/(self.frame.size.height/self.image.size.height)));
                return CGSizeMake(floor(viewSize.width/(self.frame.size.width/self.image.size.width)),floor(viewSize.height/(self.frame.size.height/self.image.size.height)));
            }
            case UIViewContentModeCenter:
            case UIViewContentModeTop:
            case UIViewContentModeBottom:
            case UIViewContentModeLeft:
            case UIViewContentModeRight:
            case UIViewContentModeTopLeft:
            case UIViewContentModeTopRight:
            case UIViewContentModeBottomLeft:
            case UIViewContentModeBottomRight:
                return CGSizeMake(floor(viewSize.width),floor(viewSize.height));
            default: break;
        }
    }
    return CGSizeZero;
}

-(CGSize) viewSizeFromPixelSize:(CGSize)pixelSize
{
    if(pixelSize.width >= 0.0 && pixelSize.width <= self.image.size.width && pixelSize.height >= 0.0 && pixelSize.height <= self.image.size.height)
    {
        switch(self.contentMode)
        {
            case UIViewContentModeScaleToFill:
            case UIViewContentModeRedraw:
                return CGSizeMake(floor(pixelSize.width*(self.frame.size.width/self.image.size.width)),floor(pixelSize.height*(self.frame.size.height/self.image.size.height)));
            case UIViewContentModeScaleAspectFit:
            {
                if(self.frame.size.width/self.frame.size.height > self.image.size.width/self.image.size.height)
                    return CGSizeMake(floor(pixelSize.width*(self.frame.size.height/self.image.size.height)),floor(pixelSize.height*(self.frame.size.height/self.image.size.height)));
                else if(self.frame.size.width/self.frame.size.height < self.image.size.width/self.image.size.height)
                    return CGSizeMake(floor(pixelSize.width*(self.frame.size.width/self.image.size.width)),floor(pixelSize.height*(self.frame.size.height/self.image.size.height)));
                return CGSizeMake(floor(pixelSize.width*(self.frame.size.width/self.image.size.width)),floor(pixelSize.height*(self.frame.size.height/self.image.size.height)));
            }
            case UIViewContentModeScaleAspectFill:
            {
                if(self.frame.size.width/self.frame.size.height > self.image.size.width/self.image.size.height)
                    return CGSizeMake(floor(pixelSize.width*(self.frame.size.width/self.image.size.width)),floor(pixelSize.height*(self.frame.size.width/self.image.size.width)));
                else if(self.frame.size.width/self.frame.size.height < self.image.size.width/self.image.size.height)
                    return CGSizeMake(floor(pixelSize.width*(self.frame.size.height/self.image.size.height)),floor(pixelSize.height*(self.frame.size.height/self.image.size.height)));
                return CGSizeMake(floor(pixelSize.width*(self.frame.size.width/self.image.size.width)),floor(pixelSize.height*(self.frame.size.height/self.image.size.height)));
            }
            case UIViewContentModeCenter:
            case UIViewContentModeTop:
            case UIViewContentModeBottom:
            case UIViewContentModeLeft:
            case UIViewContentModeRight:
            case UIViewContentModeTopLeft:
            case UIViewContentModeTopRight:
            case UIViewContentModeBottomLeft:
            case UIViewContentModeBottomRight:
                return CGSizeMake(floor(pixelSize.width),floor(pixelSize.height));
            default: break;
        }
    }
    return CGSizeZero;
}

@end
