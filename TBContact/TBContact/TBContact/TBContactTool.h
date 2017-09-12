//
//  TBContactTool.h
//  com.pintu.aaaaaa
//
//  Created by hanchuangkeji on 2017/9/16.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TBContactToolDelegate <NSObject>

@optional

/**
 * 无序的排列
 */
- (void)contactArray:(NSArray *)personAray authorizationSuccess:(BOOL)success;

/**
 * 按姓氏的排列
 */
- (void)contactByLastNameDic:(NSArray *)personArray authorizationSuccess:(BOOL)success;

@end



@interface TBContactTool : NSObject

@property (nonatomic, weak)id<TBContactToolDelegate> delegate;

@end
