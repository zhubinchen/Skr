//
//  KeyboardViewController.m
//  Keyboard
//
//  Created by 朱炳程 on 2018/12/29.
//  Copyright © 2018 朱炳程. All rights reserved.
//

#import "KeyboardViewController.h"
#import "SKRKeyboardMainViewController.h"

static KeyboardViewController *_shared = nil;

@interface KeyboardViewController ()
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@property (nonatomic, strong) SKRKeyboardMainViewController *mainVC;
@end

@implementation KeyboardViewController

+ (instancetype)shared {
    return _shared;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SKRKeyboardMainViewController *vc = SKRKeyboardMainViewController.instance;
    [self.view addSubview:vc.view];
    [self addChildViewController:vc];
    self.mainVC = vc;
    _shared = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGFloat expandedHeight = 280;
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant: expandedHeight];
    [self.view addConstraint:heightConstraint];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.mainVC.view.frame = self.view.bounds;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
}

- (CGSize)preferredContentSize {
    return CGSizeMake(375, 300);
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}

@end
