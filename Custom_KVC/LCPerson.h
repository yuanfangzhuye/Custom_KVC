//
//  LCPerson.h
//  Custom_KVC
//
//  Created by lab team on 2021/5/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCPerson : NSObject {
//    NSString *_name;
//    NSString *_isName;
//    NSString *name;
//    NSString *isName;
}

//@property(nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, strong) NSSet   *set;

@end

NS_ASSUME_NONNULL_END
