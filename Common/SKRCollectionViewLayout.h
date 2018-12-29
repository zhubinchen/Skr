//
//  SKRCollectionViewLayout.h
//  Skr
//
//  Created by 朱炳程 on 2018/12/29.
//  Copyright © 2018 朱炳程. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKRCollectionViewLayout : UICollectionViewLayout

@property (nonatomic,strong) NSArray *widthArray;

- (instancetype)initWithEdgeInsets:(UIEdgeInsets)insets;

@end

NS_ASSUME_NONNULL_END
