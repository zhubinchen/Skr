//
//  NSArray+HigherOrder.m
//  NewsEarn
//
//  Created by zhubch on 2018/3/1.
//  Copyright © 2018年 CooHua. All rights reserved.
//

#import "NSArray+HigherOrder.h"

@implementation NSArray (HigherOrder)

- (void)forEach:(void (^)(id))iterator {
    if (!iterator) {
        return ;
    }
    for (id obj in self.copy) {
        iterator(obj);
    }
}

- (NSArray *)map:(id (^)(id))map {
    if (!map) {
        return self;
    }
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    for (id obj in self.copy) {
        id newObj = map(obj);
        if (newObj) {
            [array addObject:newObj];
        }
    }
    return array.copy;
}

- (NSArray *)filter:(BOOL (^)(id))filter {
    if (!filter) {
        return self;
    }
    return [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return filter(evaluatedObject);
    }]];
}

- (id)first:(BOOL (^)(id))where {
    if (!where) {
        return nil;
    }
    for (id obj in self.copy) {
        if (where(obj)) {
            return obj;
        }
    }
    return nil;
}

- (id)reduceWithInitial:(id)initial reduce:(id (^)(id, id))reduce {
    if (!reduce) {
        return initial;
    }
    id result = initial;
    for (id obj in self.copy) {
        result = reduce(result,obj);
    }
    return result;
}

- (NSInteger)index:(BOOL (^)(id))where {
    if (!where) {
        return -1;
    }
    NSArray *array = self.copy;
    for (int i = 0; i < array.count; i++) {
        if (where(array[i])) {
            return i;
        }
    }
    return -1;
}

@end
