//
//  SKRPhraseViewController.m
//  Skr
//
//  Created by 朱炳程 on 2018/12/29.
//  Copyright © 2018 朱炳程. All rights reserved.
//

#import "SKRPhraseViewController.h"
#import "SKRPhraseCell.h"
#import "SKRCollectionViewLayout.h"
#import "NSArray+HigherOrder.h"
#import "KeyboardViewController.h"

@interface SKRPhraseViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray<NSString*> *phrases;
@property (nonatomic,strong) NSMutableArray<NSNumber*> *widthArray;
@end

@implementation SKRPhraseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.phrases = @[@"collectionView",@"registerNib",@"forCellWithReuseIdentifier",@"SKRPhraseCell",@"widthArray",@"initWithFrameinitWithFrameinitWithFrameinitWithFrame"].mutableCopy;
    
    self.widthArray = [self.phrases map:^id(NSString *obj) {
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGSize size = [obj boundingRectWithSize:CGSizeMake(200, 30)
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:dic context:nil].size;
        return @(size.width);
    }].mutableCopy;
    
    SKRCollectionViewLayout *layout = [[SKRCollectionViewLayout alloc] initWithEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    layout.widthArray = self.widthArray;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"SKRPhraseCell" bundle:NSBundle.mainBundle] forCellWithReuseIdentifier:@"SKRPhraseCell"];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = UIColor.groupTableViewBackgroundColor;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.phrases.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = self.phrases[indexPath.row];
    SKRPhraseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SKRPhraseCell" forIndexPath:indexPath];
    cell.textLabel.text = text;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = self.phrases[indexPath.row];
    [KeyboardViewController.shared.textDocumentProxy insertText:text];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
