//
//  ViewController.m
//  Skr
//
//  Created by 朱炳程 on 2018/12/29.
//  Copyright © 2018 朱炳程. All rights reserved.
//

#import "ViewController.h"
#import "SKRKeyboardMainViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    SKRKeyboardMainViewController *vc = SKRKeyboardMainViewController.instance;
    [self.view addSubview:vc.view];
    vc.view.frame = CGRectMake(0, 100, 375, 280);
    [self addChildViewController:vc];    
}


@end
