//
//  NSArray+HigherOrder.h
//  NewsEarn
//
//  Created by zhubch on 2018/3/1.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray<__covariant ObjectType> (HigherOrder)

// 遍历
- (void)forEach:(void(^)(ObjectType obj))iterator;

// 转换
- (NSArray*)map:(id(^)(ObjectType obj))map;

// 过滤
- (NSArray<ObjectType>*)filter:(BOOL(^)(ObjectType obj))filter;

// 叠加
- (id)reduceWithInitial:(id)initial reduce:(id(^)(id result,ObjectType obj))reduce;

// 找出第一个满足条件的
- (ObjectType)first:(BOOL(^)(ObjectType obj))where;

- (NSInteger)index:(BOOL(^)(ObjectType obj))where;

@end
