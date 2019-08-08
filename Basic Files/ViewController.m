//
//  ViewController.m
//
//  Created by dyf on 2017/1/16.
//  Copyright © 2017 dyf. All rights reserved.
//

#import "ViewController.h"
#import "DYFBlurEffect.h"

@interface ViewController ()
@property (weak  , nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) DYFBlurEffect *blurEffect;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.imgView.userInteractionEnabled = YES;
    
    UIImage *image = [UIImage imageNamed:@"BeauGir.jpg"];
    self.imgView.image = image;
    
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] init];
    [longPressGR addTarget:self action:@selector(changeEffect:)];
    [self.imgView addGestureRecognizer:longPressGR];
}

- (void)changeEffect:(UILongPressGestureRecognizer *)recognizer {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"改变效果" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self executeChangingEffect];
    }];
    [alertController addAction:confirmAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:NULL];
}

- (void)executeChangingEffect {
    UIImage *image = [UIImage imageNamed:@"BeauGir.jpg"];
    static int i = 0;
    
    if (i == 0) {
        self.imgView.image = [self.blurEffect blurryImage:image style:DYFBlurEffectLight];
    } else if (i == 1) {
        self.imgView.image = [self.blurEffect blurryImage:image tintColor:[UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1]];
    } else if (i == 2) {
        self.imgView.image = image;
        
        UIVisualEffectView *blurView = [self.blurEffect blurViewWithStyle:UIBlurEffectStyleLight];
        blurView.frame = self.imgView.bounds;
        blurView.tag = 10;
        blurView.userInteractionEnabled = YES;
        [self.view addSubview:blurView];
        
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] init];
        [longPressGR addTarget:self action:@selector(changeEffect:)];
        [blurView addGestureRecognizer:longPressGR];
    } else {
        self.imgView.image = [self.blurEffect coreImage:image blurRadius:10];
    }
    
    if (i != 2) {
        UIVisualEffectView *blurView = [self.view viewWithTag:10];
        !blurView ?: [blurView removeFromSuperview];
    }
    
    i++;
    if (i >= 4) { i = 0; }
}

- (DYFBlurEffect *)blurEffect {
    if (!_blurEffect) {
        _blurEffect = [[DYFBlurEffect alloc] init];
    }
    return _blurEffect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
