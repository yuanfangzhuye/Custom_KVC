//
//  LCPerson.m
//  Custom_KVC
//
//  Created by lab team on 2021/5/19.
//

#import "LCPerson.h"

@implementation LCPerson

//+ (BOOL)accessInstanceVariablesDirectly {
//    return NO;
//}

//- (NSString *)getName {
//    NSLog(@"%s", __func__);
//
//    return self.name;
//}

//- (NSString *)name {
//    NSLog(@"%s", __func__);
//
//    return @"";
//}

//- (NSString *)isName {
//    NSLog(@"%s", __func__);
//
//    return @"";
//}

//- (NSString *)_name {
//    NSLog(@"%s", __func__);
//
//    return @"12";
//}



- (void)setName:(NSString *)name {
    NSLog(@"%s", __func__);
}

//- (void)_setName:(NSString *)name {
//    NSLog(@"%s", __func__);
//}

//- (void)setIsName:(NSString *)name {
//    NSLog(@"%s", __func__);
//}

//- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    NSLog(@"%s", __func__);
//}

//- (id)valueForUndefinedKey:(NSString *)key {
//    NSLog(@"%s", __func__);
//
//    return nil;
//}

#pragma mark - 集合

//// 个数
//- (NSUInteger)countOfName {
//    NSLog(@"%s", __func__);
//    return [self.arr count];
//}
//
//// 获取值
//- (id)objectInNameAtIndex: (NSUInteger)index {
//    NSLog(@"%s", __func__);
//    return [NSString stringWithFormat:@"names %lu", index];
//}
//
//- (id)nameAtIndexes:(NSUInteger)index {
//    NSLog(@"%s", __func__);
//    return [NSString stringWithFormat:@"names %lu", index];
//}
//
//// 个数
//- (NSUInteger)countOfName{
//    NSLog(@"%s",__func__);
//    return [self.set count];
//}
//
//// 是否包含这个成员对象
//- (id)memberOfName:(id)object {
//    NSLog(@"%s",__func__);
//    return [self.set containsObject:object] ? object : nil;
//}
//
//// 迭代器
//- (id)enumeratorOfName {
//    // objectEnumerator
//    NSLog(@"来了 迭代编译");
//    return [self.arr reverseObjectEnumerator];
//}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
