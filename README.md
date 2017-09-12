# TBContact
访问手机通讯录
# 1，创建使用方法
TBContactTool *contactToll = [[TBContactTool alloc] init];
contactToll.delegate = self;
# 2， 实现代理，获取手机通讯录数据
 * 无序的排列
- (void)contactArray:(NSArray *)personAray authorizationSuccess:(BOOL)success;

 * 按姓氏的排列
- (void)contactByLastNameDic:(NSArray *)personArray authorizationSuccess:(BOOL)success;
