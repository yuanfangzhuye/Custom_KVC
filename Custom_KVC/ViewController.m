//
//  ViewController.m
//  Custom_KVC
//
//  Created by lab team on 2021/5/19.
//

#import "ViewController.h"
#import "LCPerson.h"
//#import "NSObject+CustomKVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    LCPerson *p = [LCPerson alloc];
    [p setValue:@"lc" forKey:@"name"];
    NSLog(@"自定义取值：%@", [p valueForKey:@"name"]);
}


@end
