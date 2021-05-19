//
//  NSObject+CustomKVC.h
//  QRCodeTest
//
//  Created by lab team on 2021/5/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CustomKVC)

//设值
- (void)lc_setValue:(nullable id)value forKey:(NSString *)key;
//取值
- (nullable id)lc_valueForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
