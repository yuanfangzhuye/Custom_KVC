//
//  NSObject+CustomKVC.m
//  QRCodeTest
//
//  Created by lab team on 2021/5/19.
//

#import "NSObject+CustomKVC.h"
#import <objc/runtime.h>

@implementation NSObject (CustomKVC)

//设值
- (void)lc_setValue:(nullable id)value forKey:(NSString *)key {
    
    //1. 判断 key 是否存在
    if (key == nil || key.length == 0) return;
    
    NSString *Key = key.capitalizedString; // 首字母大写
    
    //2. 找setter方法，顺序是：setXXX、_setXXX、 setIsXXX
    NSString *setKey = [NSString stringWithFormat:@"set%@", Key];
    NSString *_setKey = [NSString stringWithFormat:@"_set%@", Key];
    NSString *setIsKey = [NSString stringWithFormat:@"setIs%@", Key];
    
    if ([self respondsToSelector:NSSelectorFromString(setKey)]) {
        [self performSelector:NSSelectorFromString(setKey) withObject:value];
        return;
    }
    else if ([self respondsToSelector:NSSelectorFromString(_setKey)]) {
        [self performSelector:NSSelectorFromString(_setKey) withObject:value];
        return;
    }
    else if ([self respondsToSelector:NSSelectorFromString(setIsKey)]) {
        [self performSelector:NSSelectorFromString(setIsKey) withObject:value];
        return;
    }
    
    //3. 判断是否响应`accessInstanceVariablesDirectly`方法，即间接访问实例变量，返回YES，继续下一步设值，如果是NO，则崩溃
    if (![self.class accessInstanceVariablesDirectly]) {
        @throw [NSException exceptionWithName:@"LCUnKnownKeyException" reason:[NSString stringWithFormat:@"****[%@ valueForUndefinedKey:]: this class is not key value coding-compliant for the key name.****",self] userInfo:nil];
    }
    
    // 4. 访问变量赋值，顺序为：_key、_isKey、key、isKey
    
    NSMutableArray *mutableArray = [self getClassIvarLists];
    NSString *_key = [NSString stringWithFormat:@"_%@", key];
    NSString *_isKey = [NSString stringWithFormat:@"_is%@", Key];
    NSString *isKey = [NSString stringWithFormat:@"is%@", Key];
    
    if ([mutableArray containsObject:_key]) {
        Ivar ivar = class_getInstanceVariable([self class], _key.UTF8String);
        object_setIvar(self, ivar, value);
        return;
    }
    else if ([mutableArray containsObject:_isKey]) {
        Ivar ivar = class_getInstanceVariable([self class], _isKey.UTF8String);
        object_setIvar(self, ivar, value);
        return;
    }
    else if ([mutableArray containsObject:key]) {
        Ivar ivar = class_getInstanceVariable([self class], key.UTF8String);
        object_setIvar(self, ivar, value);
        return;
    }
    else if ([mutableArray containsObject:isKey]) {
        Ivar ivar = class_getInstanceVariable([self class], isKey.UTF8String);
        object_setIvar(self, ivar, value);
        return;
    }
    
    if ([self respondsToSelector:@selector(setValue:forUndefinedKey:)]) {
        return;
    }
    
    // 5、如果找不到则抛出异常
    @throw [NSException exceptionWithName:@"LCUnknownKeyException" reason:[NSString stringWithFormat:@"****[%@ %@]: this class is not key value coding-compliant for the key name.****",self,NSStringFromSelector(_cmd)] userInfo:nil];
}

- (NSMutableArray *)getClassIvarLists {
    
    NSMutableArray *ivarList = [[NSMutableArray alloc] initWithCapacity:1];
    unsigned int count = 0;
    
    // 获取类的成员变量列表
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) { //遍历成员变量列表
        Ivar ivar = ivars[i];
        // 获取成员变量名字字符
        const char *ivarNameChar = ivar_getName(ivar);
        NSString *ivarNameString = [NSString stringWithUTF8String:ivarNameChar]; //将字符转换成字符串
        [ivarList addObject:ivarNameString];
    }
    
    free(ivars);
    return ivarList;
}

//取值
- (nullable id)lc_valueForKey:(NSString *)key {
    
    // 1.判断非空
    if (key == nil || key.length == 0) {
        return nil;
    }
    
    // 2.找到相关方法：get<Key> <key> countOf<Key>  objectIn<Key>AtIndex
    NSString *capitalizedKey = key.capitalizedString;
    NSString *getKeyMethod = [NSString stringWithFormat:@"get%@", capitalizedKey];
    NSString *isKeyMethod  = [NSString stringWithFormat:@"is%@", capitalizedKey];
    NSString *_keyMethod   = [NSString stringWithFormat:@"_%@", key];
    NSString *countOfKey = [NSString stringWithFormat:@"countOf%@",capitalizedKey];
    NSString *objectInKeyAtIndex = [NSString stringWithFormat:@"objectIn%@AtIndex:",capitalizedKey];
//
    if ([self respondsToSelector:NSSelectorFromString(getKeyMethod)]) {
        return [self performSelector:NSSelectorFromString(getKeyMethod)];
    }
    else if ([self respondsToSelector:NSSelectorFromString(key)]) {
        return [self performSelector:NSSelectorFromString(key)];
    }
    else if ([self respondsToSelector:NSSelectorFromString(isKeyMethod)]) {
        return [self performSelector:NSSelectorFromString(isKeyMethod)];
    }
    else if ([self respondsToSelector:NSSelectorFromString(_keyMethod)]) {
        return [self performSelector:NSSelectorFromString(_keyMethod)];
    }
    else if ([self respondsToSelector:NSSelectorFromString(countOfKey)]) {
        if ([self respondsToSelector:NSSelectorFromString(objectInKeyAtIndex)]) {
            int num = (int)[self performSelector:NSSelectorFromString(countOfKey)];
            NSMutableArray *mArray = [[NSMutableArray alloc] initWithCapacity:1];
            for (int i = 0; i < num - 1; i++) {
                num = (int)[self performSelector:NSSelectorFromString(countOfKey)];
            }
            for (int j = 0; j < num; j++) {
                id objc = [self performSelector:NSSelectorFromString(objectInKeyAtIndex) withObject:@(num)];
                [mArray addObject:objc];
            }
            
            return mArray;
        }
    }
    
    // 3. 判断是否响应`accessInstanceVariablesDirectly`方法，即间接访问实例变量，返回YES，继续下一步设值，如果是NO，则崩溃
    if (![self.class accessInstanceVariablesDirectly]) {
        @throw [NSException exceptionWithName:@"LCUnKnownKeyException" reason:[NSString stringWithFormat:@"****[%@ valueForUndefinedKey:]: this class is not key value coding-compliant for the key name.****",self] userInfo:nil];
    }
    
    //4. 找相关实例变量进行赋值，顺序为：_<key>、 _is<Key>、 <key>、 is<Key>
    NSMutableArray *ivarList = [self getClassIvarLists];
    
    NSString *_key = [NSString stringWithFormat:@"_%@", key];
    NSString *_isKey = [NSString stringWithFormat:@"_is%@", capitalizedKey];
    NSString *isKey = [NSString stringWithFormat:@"is%@", capitalizedKey];
    
    if ([ivarList containsObject:_key]) {
        Ivar ivar = class_getInstanceVariable([self class], _key.UTF8String);
        return object_getIvar(self, ivar);
    }
    else if ([ivarList containsObject:_isKey]) {
        Ivar ivar = class_getInstanceVariable([self class], _isKey.UTF8String);
        return object_getIvar(self, ivar);
    }
    else if ([ivarList containsObject:key]) {
        Ivar ivar = class_getInstanceVariable([self class], key.UTF8String);
        return object_getIvar(self, ivar);
    }
    else if ([ivarList containsObject:isKey]) {
        Ivar ivar = class_getInstanceVariable([self class], isKey.UTF8String);
        return object_getIvar(self, ivar);
    }
    
    return @"";
}

@end
