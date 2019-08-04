# DYFBlurEffect

DYFBlurEffect实现了毛玻璃效果，对图像模糊化处理.

https://github.com/dgynfi/DYFBlurEffect

`Author: Eastze` <br>
`Date: 2017/01/16`

## Usage

## 1.实例化
```ObjC
self.blurEffect = [[DYFBlurEffect alloc] init];
```

## 2.模糊化效果类型
```ObjC
typedef NS_ENUM(NSInteger, DYFBlurEffectStyle) {
	DYFBlurEffectLight,
	DYFBlurEffectExtraLight,
	DYFBlurEffectDark,
};
```

## 3.获取模糊图像
```ObjC
UIImage *image = [UIImage imageNamed:@"BeauGir.jpg"];
self.imgView.image = [self.blurEffect blurryImage:image withStyle:DYFBlurEffectLight];
```
