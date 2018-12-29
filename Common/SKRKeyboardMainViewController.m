//
//  SKRKeyboardMainViewController.m
//  Skr
//
//  Created by 朱炳程 on 2018/12/29.
//  Copyright © 2018 朱炳程. All rights reserved.
//

#import "SKRKeyboardMainViewController.h"
#import "SKRPhraseViewController.h"
#import "KeyboardViewController.h"
#import "UIView+SKRKit.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "NSArray+HigherOrder.h"

@interface SKRKeyboardMainViewController ()
@property (nonatomic, weak) IBOutlet UIButton *returnButton;
@property (nonatomic, strong) UIViewController *containerVC;
@property (nonatomic, strong) UIScrollView *topBar;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSMutableArray *buttons;
@end

@implementation SKRKeyboardMainViewController

+ (instancetype)instance {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Common" bundle:NSBundle.mainBundle];
    return [sb instantiateViewControllerWithIdentifier:@"SKRKeyboardMainViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = @[@"剪切板",@"快捷短语",@"银行卡",@"证  件",@"我的地址",@"无线输入",@"切  换"];
    self.buttons = @[].mutableCopy;
    CGFloat h = 280.0 / 7;
    self.topBar = [[UIScrollView alloc] initWithFrame:CGRectMake(4, 4, 80, self.view.height - 8)];
    self.topBar.contentSize = CGSizeMake(0, h * self.items.count);
    self.topBar.backgroundColor = UIColor.whiteColor;
    self.topBar.showsHorizontalScrollIndicator = NO;
    self.topBar.cornerRadius = 4;
    [self.view addSubview:self.topBar];
    
    for (int i = 0; i < self.items.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, h * i, 80, 40)];
        [btn setTitleColor:UIColor.darkTextColor forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.redColor forState:UIControlStateSelected];
        [btn setTitle:self.items[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.topBar addSubview:btn];
        
        if (i == self.items.count - 1) {
            [btn addTarget:self action:@selector(nextKeyboard:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            btn.tag = i;
            [self.buttons addObject:btn];
            [btn addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(5, h - 0.5, 70, 0.5)];
            line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
            [btn addSubview:line];
        }
    }
    
    self.containerVC = [[SKRPhraseViewController alloc] init];
    [self.view addSubview:self.containerVC.view];
    [self addChildViewController:self.containerVC];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSArray *titles = @[@"换行",@"前往",@"Google",@"加入",@"下一个",@"Route",@"搜索",@"发送",@"Yahoo",@"完成",@"紧急",@"继续"];
    [self.returnButton setTitle:titles[KeyboardViewController.shared.textDocumentProxy.returnKeyType] forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.topBar setContentOffset:CGPointMake(0, 8) animated:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.containerVC.view.frame = CGRectMake(84, 0, self.view.width - 84, self.view.height - 56);
    self.topBar.frame = CGRectMake(4, 4, 80, self.view.height - 8);
}

- (void)nextKeyboard:(UIButton*)sender {
    [KeyboardViewController.shared advanceToNextInputMode];
}

- (void)selectedButton:(UIButton*)sender {
    [self.buttons forEach:^(UIButton* obj) {
        obj.selected = sender == obj;
    }];
}

- (IBAction)insertSpace:(id)sender {
    [KeyboardViewController.shared.textDocumentProxy insertText:@" "];
}

- (IBAction)deleteBackward:(id)sender {
    [KeyboardViewController.shared.textDocumentProxy deleteBackward];
}

- (IBAction)insertReturn:(id)sender {
    NSLog(@"%@",KeyboardViewController.shared.textDocumentProxy.documentContextAfterInput);
    [KeyboardViewController.shared.textDocumentProxy insertText:@"\n"];
}

@end
