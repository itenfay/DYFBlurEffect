<div align=center>
<img src="https://github.com/dgynfi/DYFBlurEffect/raw/master/images/DYFBlurEffect.png" width="90%">
</div>

如果此项目能帮助到你，就请你给[一颗星](https://github.com/dgynfi/DYFBlurEffect)。谢谢！(If this project can help you, please give it [a star](https://github.com/dgynfi/DYFBlurEffect). Thanks!)

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/DYFBlurEffect.svg?style=flat)](http://cocoapods.org/pods/DYFBlurEffect)&nbsp;
![CocoaPods](http://img.shields.io/cocoapods/p/DYFBlurEffect.svg?style=flat)&nbsp;

## DYFBlurEffect

一行代码实现图像模糊化，并支持系统UIVisualEffectView。

## Group (ID:614799921)

<div align=left>
&emsp; <img src="https://github.com/dgynfi/DYFBlurEffect/raw/master/images/g614799921.jpg" width="30%">
</div>

## Installation

Using [CocoaPods](https://cocoapods.org):

```pod install
pod 'DYFBlurEffect', '~> 2.0.0'
```

## Preview

<div align=left>
&emsp; <img src="https://github.com/dgynfi/DYFBlurEffect/raw/master/images/BlurEffectPreview.gif" width="40%" />
</div>

## Usage

- Instantiation

```
// Lazy load
- (DYFBlurEffect *)blurEffect {
    if (!_blurEffect) {
        _blurEffect = [[DYFBlurEffect alloc] init];
    }
    return _blurEffect;
}
```

- CoreGraphics and vImage
    
```
// Uses a `DYFBlurEffectStyle` style.
self.imgView.image = [self.blurEffect blurryImage:image style:DYFBlurEffectLight];

// Tints with a color.
self.imgView.image = [self.blurEffect blurryImage:image tintColor:[UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1]];
```

```
/**
Blur out an image with an original image, a blur radius, tint with a color, a saturation delta factor and a mask image.
*/
- (UIImage *)blurryImage:(UIImage *)image blurRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;
```

- UIVisualEffectView(Available iOS 8.0 or later)

```
UIVisualEffectView *blurView = [self.blurEffect blurViewWithStyle:UIBlurEffectStyleLight];
blurView.frame = self.imgView.bounds;
//blurView.tag = 10;
//blurView.userInteractionEnabled = YES;
[self.view addSubview:blurView];
```

- CoreImage

```
 self.imgView.image = [self.blurEffect coreImage:image blurRadius:10];
```

## Sample

To learn more, plaease go [here](https://github.com/dgynfi/DYFBlurEffect/blob/master/Basic%20Files/ViewController.m).

