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


![image](https://github.com/tangbin583085/TBContact/blob/master/TBContact/TBContact/screenshot/BDDA95F6-51E8-4ABE-AF1E-D019546A9FE0.png)
![image](https://github.com/tangbin583085/TBContact/blob/master/TBContact/TBContact/screenshot/E1E33DFD-F924-4758-99AB-935C44F09C56.png)
