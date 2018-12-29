//
//  SKRCollectionViewLayout.m
//  Skr
//
//  Created by 朱炳程 on 2018/12/29.
//  Copyright © 2018 朱炳程. All rights reserved.
//

#import "SKRCollectionViewLayout.h"

#define DWScreenH = [UIScreen mainScreen].bounds.size.height
#define DWScreenW = [UIScreen mainScreen].bounds.size.width

@interface SKRCollectionViewLayout()

@property (nonatomic,strong) NSMutableArray *attributesArray;

@property (nonatomic,assign) CGFloat maxY;

@property (nonatomic,assign) CGFloat left;

@property (nonatomic,assign) CGFloat right;

@property (nonatomic,assign) CGFloat top;

@property (nonatomic,assign) CGFloat between;

@end

@implementation SKRCollectionViewLayout

- (instancetype)initWithEdgeInsets:(UIEdgeInsets)insets {
    if (self = [super init]) {
        self.left = insets.left;
        self.right = insets.right;
        self.top = insets.top;
        self.between = insets.bottom;
    }
    return self;
}

- (void)setWidthArray:(NSArray *)widthArray {
    _widthArray = widthArray;
    [self invalidateLayout];
}

-(void)prepareLayout {

    [super prepareLayout];

    [self.attributesArray removeAllObjects];
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    for (int i =0; i<itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributesArray addObject:attributes];
        if (i == self.widthArray.count-1) {
            [self loadOldAttributes:attributes.frame];
        }
    }
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width, self.maxY);
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes *attributes in array) {
        if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
        }
    }
    return self.attributesArray;
}


-(UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath*)indexPath{
    UICollectionViewLayoutAttributes *attributs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSNumber *currentWidthNumber = self.widthArray[indexPath.row];
    CGFloat width = currentWidthNumber.floatValue;
    
    ///没有换行所以超出部分不显示（不写下面的代码也不会报错，不知道为啥）
    if (width > [UIScreen mainScreen].bounds.size.width-(self.left+self.right)) {
        width = [UIScreen mainScreen].bounds.size.width - (self.left+self.right);
    }
    
    CGFloat height = 30;
    CGRect currentFrame = CGRectZero;
    
    if (1) {
        if (self.attributesArray.count!=0) {
            ///1.取出上一个item的attributes
            UICollectionViewLayoutAttributes *lastAttributs = [self.attributesArray lastObject];
            CGRect lastFrame = lastAttributs.frame;
            
            ///判断当前item和上一个item是否在同一个row
            if (CGRectGetMaxX(lastAttributs.frame)+self.right==self.collectionView.bounds.size.width) {
                ///不在同一row
                currentFrame.origin.x = self.left;
                currentFrame.origin.y = CGRectGetMaxY(lastFrame) +self.top;
                currentFrame.size.width = width;
                currentFrame.size.height = height;
                attributs.frame = currentFrame;
                
            }else{
                ///上一个item的最大x值+当前item的宽度和左边距
                CGFloat totleWidth = CGRectGetMaxX(lastFrame)+(self.between+width+self.right);
                ///判断上一个item所在row的剩余宽度是否还够显示当前item
                if (totleWidth>=self.collectionView.bounds.size.width) {
                    ///不足以显示当前item的宽度
                    
                    ///将和上一个item在同一个row的item的放在同一个数组
                    NSMutableArray *sameYArray = [NSMutableArray array];
                    for (UICollectionViewLayoutAttributes *subAttributs in self.attributesArray) {
                        if (subAttributs.frame.origin.y==lastFrame.origin.y) {
                            [sameYArray addObject:subAttributs];
                        }
                    }
                    
                    ///判断出上一row还剩下多少宽度
                    CGFloat sameYWidth = 0.0;
                    for (UICollectionViewLayoutAttributes *sameYAttributs in sameYArray) {
                        sameYWidth += sameYAttributs.size.width;
                    }
                    sameYWidth = sameYWidth + (self.left+self.right+(sameYArray.count-1)*self.between);
                    ///上一个row所剩下的宽度
                    CGFloat sameYBetween = (self.collectionView.bounds.size.width-sameYWidth)/sameYArray.count;
                    
                    for (UICollectionViewLayoutAttributes *sameYAttributs in sameYArray) {
                        CGFloat sameAttributeWidth = sameYAttributs.size.width;
                        CGFloat sameAttributeHeight = sameYAttributs.size.height;
                        
                        CGRect sameYAttributsFrame = sameYAttributs.frame;
                        ///更新sameYAttributs宽度使之均衡显示
                        sameAttributeWidth += sameYBetween;
                        sameYAttributs.size = CGSizeMake(sameAttributeWidth, sameAttributeHeight);
                        NSInteger index = [sameYArray indexOfObject:sameYAttributs];
                        
                        sameYAttributsFrame.origin.x += (sameYBetween*index);
                        sameYAttributsFrame.size.width = sameAttributeWidth;
                        sameYAttributs.frame = sameYAttributsFrame;
                    }
                    currentFrame.origin.x = self.left;
                    currentFrame.origin.y = CGRectGetMaxY(lastFrame)+self.top;
                    currentFrame.size.width = width;
                    currentFrame.size.height = height;
                    attributs.frame = currentFrame;
                    
                }else{
                    currentFrame.origin.x = CGRectGetMaxX(lastFrame)+self.between;
                    currentFrame.origin.y = lastFrame.origin.y;
                    currentFrame.size.width = width;
                    currentFrame.size.height = height;
                    attributs.frame = currentFrame;
                }
            }
        }else{
            currentFrame.origin.x = self.left;
            currentFrame.origin.y = self.top;
            currentFrame.size.width = width;
            currentFrame.size.height = height;
            attributs.frame = currentFrame;
        }
    }
    
    //    attributs.size = CGSizeMake(width, 30);
    self.maxY = CGRectGetMaxY(attributs.frame)+10;
    
    return attributs;
}

///返回对应于indexPath的位置的追加视图的布局属性，如果没有追加视图可不重载
-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    return [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
}

///返回对应于indexPath的位置的装饰视图的布局属性，如果没有装饰视图可不重载
-(UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)decorationViewKind atIndexPath:(NSIndexPath*)indexPath{
    return [super layoutAttributesForDecorationViewOfKind:decorationViewKind atIndexPath:indexPath];
}

///当边界发生改变时，是否应该刷新布局。如果YES则在边界变化（一般是scroll到其他地方）时，将重新计算需要的布局信息。
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return [super shouldInvalidateLayoutForBoundsChange:newBounds];
}

-(void)loadOldAttributes:(CGRect)lastFrame{
    ///将和上一个item在同一个row的item的放在同一个数组
    NSMutableArray *sameYArray = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *subAttributs in self.attributesArray) {
        if (subAttributs.frame.origin.y==lastFrame.origin.y) {
            [sameYArray addObject:subAttributs];
        }
    }
    
    ///判断出上一row还剩下多少宽度
    CGFloat sameYWidth = 0.0;
    for (UICollectionViewLayoutAttributes *sameYAttributs in sameYArray) {
        sameYWidth += sameYAttributs.size.width;
    }
    sameYWidth = sameYWidth + (self.left+self.right+(sameYArray.count-1)*self.between);
    ///上一个row所剩下的宽度
    CGFloat sameYBetween = (self.collectionView.bounds.size.width-sameYWidth)/sameYArray.count;
    
    for (UICollectionViewLayoutAttributes *sameYAttributs in sameYArray) {
        CGFloat sameAttributeWidth = sameYAttributs.size.width;
        CGFloat sameAttributeHeight = sameYAttributs.size.height;
        
        CGRect sameYAttributsFrame = sameYAttributs.frame;
        ///更新sameYAttributs宽度使之均衡显示
        sameAttributeWidth += sameYBetween;
        sameYAttributs.size = CGSizeMake(sameAttributeWidth, sameAttributeHeight);
        NSInteger index = [sameYArray indexOfObject:sameYAttributs];
        
        sameYAttributsFrame.origin.x += (sameYBetween*index);
        sameYAttributsFrame.size.width = sameAttributeWidth;
        sameYAttributs.frame = sameYAttributsFrame;
    }
}

-(NSMutableArray*)attributesArray{
    if (!_attributesArray) {
        _attributesArray = [NSMutableArray array];
    }
    return _attributesArray;
}

@end
