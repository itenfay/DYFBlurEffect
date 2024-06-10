**中文版** | [English Version](README-en.md)

如果能帮助到你，请你给[一颗星](https://github.com/itenfay/DYFBlurEffect)，谢谢！

## DYFBlurEffect

我们使用`DYFBlurEffect`可以快速实现模糊图像，并支持系统`UIVisualEffectView`。

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/DYFBlurEffect.svg?style=flat)](http://cocoapods.org/pods/DYFBlurEffect)&nbsp;
![CocoaPods](http://img.shields.io/cocoapods/p/DYFBlurEffect.svg?style=flat)&nbsp;

## QQ群 (ID:614799921)

<div align=left>
&emsp; <img src="https://github.com/itenfay/DYFBlurEffect/raw/master/images/g614799921.jpg" width="30%">
</div>

## 安装

使用 [CocoaPods](https://cocoapods.org):

```
pod 'DYFBlurEffect'
```

Or

```
pod 'DYFBlurEffect', '~> 2.1.0'
```

## 预览

<div align=left>
&emsp; <img src="https://github.com/itenfay/DYFBlurEffect/raw/master/images/BlurEffectPreview.gif" width="40%" />
</div>

## 使用

- 实例化

```
// Lazy load
- (DYFBlurEffect *)blurEffect {
    if (!_blurEffect) {
        _blurEffect = [[DYFBlurEffect alloc] init];
    }
    return _blurEffect;
}
```

- 使用 CoreGraphics and vImage
    
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

- 使用 UIVisualEffectView (Available iOS 8.0 or later)

```
UIVisualEffectView *blurView = [self.blurEffect blurViewWithStyle:UIBlurEffectStyleLight];
blurView.frame = self.imgView.bounds;
//blurView.tag = 10;
//blurView.userInteractionEnabled = YES;
[self.view addSubview:blurView];
```

- 使用 CoreImage

```
 self.imgView.image = [self.blurEffect coreImage:image blurRadius:10];
```

## 示例

如需了解更多，请到[这里](https://github.com/itenfay/DYFBlurEffect/blob/master/Basic%20Files/ViewController.m)。
