//
//  DYFBlurEffect.m
//
//  Created by dyf on 2017/01/16.
//  Copyright © 2017 dyf.
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

#import "DYFBlurEffect.h"
#import <float.h>

@implementation DYFBlurEffect

#if __IPHONE_OS_BLUR_ALLOWED

- (UIVisualEffectView *)blurViewWithStyle:(UIBlurEffectStyle)style {
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    return effectView;
}

#endif

- (UIImage *)blurryImage:(UIImage *)image style:(DYFBlurEffectStyle)style {
    CGFloat blurRadius = 0.f;
    UIColor *tintColor = nil;
    
    switch (style) {
        case DYFBlurEffectLight: {
            blurRadius = 30.f;
            tintColor  = [UIColor colorWithWhite:1.0 alpha:0.3];
            break;
        }
            
        case DYFBlurEffectExtraLight: {
            blurRadius = 20.f;
            tintColor  = [UIColor colorWithWhite:0.97 alpha:0.82];
            break;
        }
            
        case DYFBlurEffectDark: {
            blurRadius = 20.f;
            tintColor  = [UIColor colorWithWhite:0.11 alpha:0];
            break;
        }
            
        default:
            break;
    }
    
    return [self blurryImage:image blurRadius:blurRadius tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}

- (UIImage *)blurryImage:(UIImage *)image tintColor:(UIColor *)tintColor {
    CGFloat EffectColorAlpha = 0.6;
    UIColor *effectColor     = tintColor;
    NSInteger componentCount = CGColorGetNumberOfComponents(tintColor.CGColor);
    
    if (componentCount == 2) {
        CGFloat b;
        
        if ([tintColor getWhite:&b alpha:NULL]) {
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    } else {
        CGFloat r, g, b;
        
        if ([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    
    return [self blurryImage:image blurRadius:10 tintColor:effectColor saturationDeltaFactor:1.0 maskImage:nil];
}

- (UIImage *)blurryImage:(UIImage *)image blurRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage {
    // Check pre-conditions.
    if (image.size.width < 1 || image.size.height < 1) {
#if DEBUG
        NSLog(@"error, invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", image.size.width, image.size.height, image);
#endif
        return nil;
    }
    
    if (!image.CGImage) {
#if DEBUG
        NSLog(@"error, image must be backed by a CGImage: %@", image);
#endif
        return nil;
    }
    
    if (maskImage && !maskImage.CGImage) {
#if DEBUG
        NSLog(@"error, maskImage must be backed by a CGImage: %@", maskImage);
#endif
        return nil;
    }
    
    CGRect imageRect     = { CGPointZero, image.size };
    UIImage *effectImage = image;
    
    BOOL hasBlur         = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    CGFloat scale        = [[UIScreen mainScreen] scale];
    
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(image.size, NO, scale);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -image.size.height);
        CGContextDrawImage(effectInContext, imageRect, image.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(image.size, NO, scale);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * scale;
            uint32_t radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        
        BOOL effectImageBuffersAreSwapped = NO;
        
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(image.size, NO, scale);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -image.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, image.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

- (UIImage *)coreImage:(UIImage *)image blurRadius:(CGFloat)blurRadius {
    CGFloat scale       = [[UIScreen mainScreen] scale];
    CGFloat inputRadius = blurRadius * scale;
    
    CIContext *context  = [CIContext contextWithOptions:nil];
    
    CIImage *cImage     = [CIImage imageWithData:UIImagePNGRepresentation(image)];
    
    CIFilter *filter    = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:cImage forKey:kCIInputImageKey];
    [filter setValue:@(inputRadius) forKey:kCIInputRadiusKey];
    
    CGRect rect            = CGRectMake(0, 0, image.size.width, image.size.height);
    CIImage *result        = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outputImage = [context createCGImage:result fromRect:rect];
    UIImage *blurImage     = [UIImage imageWithCGImage:outputImage];
    
    return blurImage;
}

@end

