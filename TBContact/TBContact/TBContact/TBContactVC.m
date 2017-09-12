//
//  TBContactVC.m
//  com.pintu.aaaaaa
//
//  Created by hanchuangkeji on 2017/9/16.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "TBContactVC.h"
#import "TBContactTool.h"
#import "TBContactPerson.h"

@interface TBContactVC ()<TBContactToolDelegate>

@end

@implementation TBContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)btnClick:(id)sender {
    TBContactTool *contactToll = [[TBContactTool alloc] init];
    contactToll.delegate = self;
}

- (void)contactArray:(NSArray *)personAray authorizationSuccess:(BOOL)success{
    if (!success) return;
    
    NSLog(@"==========================contactArray===================================");
    for (TBContactPerson *person in personAray) {
        NSLog(@"%@", person.name);
        for (NSString *string in person.telphoneArray) {
            NSLog(@"%@", string);
        }
        NSLog(@"=============================================================");
    }
}

- (void)contactByLastNameDic:(NSArray *)personArray authorizationSuccess:(BOOL)success {
    
    if (!success) return;
    
    NSLog(@"======================contactByLastNameDic=======================================");
    NSArray *keys = personArray[0];
    for (NSString *keyString in keys) {
        NSLog(@"======================key===================== %@", keyString);
        NSArray *personInDicArray = (NSArray *)(personArray[1][keyString]);
        for (TBContactPerson *person in personInDicArray) {
            NSLog(@"%@", person.name);
            for (NSString *string in person.telphoneArray) {
                NSLog(@"%@", string);
            }
            NSLog(@"=============================================================");
        }
    }
}

@end
