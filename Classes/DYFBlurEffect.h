//
//  DYFBlurEffect.h
//
//  Created by Tenfay on 2017/01/16.
//  Copyright © 2017 Tenfay.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreImage/CoreImage.h>

# ifndef __IPHONE_OS_BLUR_ALLOWED
# if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
# define __IPHONE_OS_BLUR_ALLOWED     1
# else
# define __IPHONE_OS_BLUR_ALLOWED     0
# endif
# endif

typedef NS_ENUM(NSInteger, DYFBlurEffectStyle) {
    DYFBlurEffectLight,       // Blur effect light.
    DYFBlurEffectExtraLight,  // Blur effect extra light.
    DYFBlurEffectDark         // Blur effect dark.
};

@interface DYFBlurEffect : NSObject

#if __IPHONE_OS_BLUR_ALLOWED

/**
 Returns a blur view, but you need to set up the frame.
 */
- (UIVisualEffectView *)blurViewWithStyle:(UIBlurEffectStyle)style;

#endif

/**
 Blur out an image with an original image and a `DYFBlurEffectStyle` style.
 */
- (UIImage *)blurryImage:(UIImage *)image style:(DYFBlurEffectStyle)style;

/**
 Blur out an image with an original image and tint with a color.
 */
- (UIImage *)blurryImage:(UIImage *)image tintColor:(UIColor *)tintColor;

/**
 Blur out an image with an original image, a blur radius, tint with a color, a saturation delta factor and a mask image.
 */
- (UIImage *)blurryImage:(UIImage *)image blurRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

/**
 Blur out an image with an original image and a blur radius. But it isn't recommended.
 */
- (UIImage *)coreImage:(UIImage *)image blurRadius:(CGFloat)blurRadius;

@end
