//
//  TBContactTool.m
//  com.pintu.aaaaaa
//
//  Created by hanchuangkeji on 2017/9/16.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "TBContactTool.h"
#import <AddressBook/AddressBook.h>
#import "TBContactPerson.h"

@implementation TBContactTool


- (void)setDelegate:(id<TBContactToolDelegate>)delegate {
    _delegate = delegate;
    [self loadPerson];
}

- (void)loadPerson
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    // 首次授权
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
            
            CFErrorRef *error1 = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
            [self copyAddressBook:addressBook];
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){// 已经授权
        
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        [self copyAddressBook:addressBook];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{// 拒绝授权
            // 执行代理
            if ([self.delegate respondsToSelector:@selector(contactArray:authorizationSuccess:)]) {
                [self.delegate contactArray:nil authorizationSuccess:NO];
            }
            
            if ([self.delegate respondsToSelector:@selector(contactByLastNameDic:authorizationSuccess:)]) {
                [self.delegate contactByLastNameDic:nil authorizationSuccess:NO];
            }
            NSLog(@"没有获取通讯录权限");
        });
    }
}


- (void)copyAddressBook:(ABAddressBookRef)addressBook
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray<TBContactPerson *> *personArray = [NSMutableArray array];

        CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
        CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);

        for ( int i = 0; i < numberOfPeople; i++){
            // 封装对象
            TBContactPerson *tbPerson = [[TBContactPerson alloc] init];
            [personArray addObject:tbPerson];
            
            // 赋值名字
            ABRecordRef person = CFArrayGetValueAtIndex(people, i);
            NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
            NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
            NSString *nickName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonNicknameProperty));
            NSString *organizatiName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonOrganizationProperty));
            NSString *departmentName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonDepartmentProperty));
            
            tbPerson.firstName = firstName.length? firstName : @"";
            tbPerson.lastName = lastName.length? lastName : @"";
            tbPerson.name = [NSString stringWithFormat:@"%@%@", tbPerson.lastName, tbPerson.firstName];
            tbPerson.name = tbPerson.name.length? tbPerson.name : nickName;
            tbPerson.name = tbPerson.name.length? tbPerson.name : organizatiName;
            tbPerson.name = tbPerson.name.length? tbPerson.name : departmentName;
            tbPerson.name = tbPerson.name.length? tbPerson.name : @"#";
            
            //读取电话多值
            ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
            for (int k = 0; k<ABMultiValueGetCount(phone); k++)
            {
                //获取电话Label
        //            NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
                
                //获取该Label下的电话值
                NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
                
                // 手机号码去除-,空格,+
                NSString *telSub = [personPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
                telSub = [telSub stringByReplacingOccurrencesOfString:@" " withString:@""];
                telSub = [telSub stringByReplacingOccurrencesOfString:@"+" withString:@""];
                [tbPerson.telphoneArray addObject:telSub];
            }
            
            // 更多属性请点击kABPersonLastNameProperty进入查看
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 执行代理
            if ([self.delegate respondsToSelector:@selector(contactArray:authorizationSuccess:)]) {
                [self.delegate contactArray:personArray authorizationSuccess:YES];
            }

            if ([self.delegate respondsToSelector:@selector(contactByLastNameDic:authorizationSuccess:)]) {
                NSArray *array = [self arrayOrderByName:personArray];
                [self.delegate contactByLastNameDic:array authorizationSuccess:YES];
            }
        
        });
    });
    
}


- (NSArray *)arrayOrderByName:(NSMutableArray<TBContactPerson *> *)array {
    
    
    NSMutableDictionary<NSString *, NSMutableArray *> *dic = [NSMutableDictionary dictionary];
    
    // 遍历每一个对象
    for (TBContactPerson *person in array) {
        
        // 首个字符拼音
        NSString *pinYin = [self getFirstLetterFromString:person.name];
        // 如果存在直接添加
        if (dic[pinYin]) {
            NSMutableArray *array = dic[pinYin];
            [array addObject:person];
        }else{
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:person];
            dic[pinYin] = array;
        }
    }
    
    // 所有keys排序
    NSArray *keysArray = [[dic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    // # 排在最后
    if ([keysArray.firstObject isEqualToString:@"#"]) {
        NSMutableArray *mutableNamekeys = [NSMutableArray arrayWithArray:keysArray];
        [mutableNamekeys insertObject:keysArray.firstObject atIndex:keysArray.count];
        [mutableNamekeys removeObjectAtIndex:0];
        return @[mutableNamekeys, dic];
    }
    
    return @[keysArray, dic];
}


#pragma mark - 获取联系人姓名首字母(传入汉字字符串, 返回大写拼音首字母)
#pragma 该方法 来自PPGetAddressBook
- (NSString *)getFirstLetterFromString:(NSString *)aString
{
    NSMutableString *mutableString = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    NSString *pinyinString = [mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    
    // 将拼音首字母装换成大写
    NSString *strPinYin = [[self polyphoneStringHandle:aString pinyinString:pinyinString] uppercaseString];
    // 截取大写首字母
    NSString *firstString = [strPinYin substringToIndex:1];
    // 判断姓名首位是否为大写字母
    NSString * regexA = @"^[A-Z]$";
    NSPredicate *predA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexA];
    // 获取并返回首字母
    return [predA evaluateWithObject:firstString] ? firstString : @"#";
    
}

/**
 多音字处理
 */
- (NSString *)polyphoneStringHandle:(NSString *)aString pinyinString:(NSString *)pinyinString
{
    if ([aString hasPrefix:@"长"]) { return @"chang";}
    if ([aString hasPrefix:@"沈"]) { return @"shen"; }
    if ([aString hasPrefix:@"厦"]) { return @"xia";  }
    if ([aString hasPrefix:@"地"]) { return @"di";   }
    if ([aString hasPrefix:@"重"]) { return @"chong";}
    return pinyinString;
}




@end
