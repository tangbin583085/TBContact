//
//  TBPerson.h
//  com.pintu.aaaaaa
//
//  Created by hanchuangkeji on 2017/9/16.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBContactPerson : NSObject


/**
 名字
 */
@property (nonatomic, copy)NSString *firstName;


/**
 姓氏
 */
@property (nonatomic, copy)NSString *lastName;


/**
 拼接firstName，lastName
 */
@property (nonatomic, copy)NSString *name;


/**
 一个人拥有一个或多个手机号
 */
@property (nonatomic, strong)NSMutableArray<NSString *> *telphoneArray;


@end
