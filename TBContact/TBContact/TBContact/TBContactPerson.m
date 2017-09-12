//
//  TBPerson.m
//  com.pintu.aaaaaa
//
//  Created by hanchuangkeji on 2017/9/16.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "TBContactPerson.h"

@implementation TBContactPerson


- (NSMutableArray<NSString *> *)telphoneArray {
    if (!_telphoneArray) {
        _telphoneArray = [NSMutableArray array];
    }
    return _telphoneArray;
}


@end
