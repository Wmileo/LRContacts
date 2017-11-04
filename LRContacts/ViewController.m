//
//  ViewController.m
//  LRContacts
//
//  Created by leo on 2017/11/4.
//  Copyright © 2017年 leospace. All rights reserved.
//

#import "ViewController.h"
#import "LRContacts.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [LRContacts fetchContactsCallBack:^(NSArray<CNContact *> *contacts, BOOL success) {
        [contacts enumerateObjectsUsingBlock:^(CNContact * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CNContactFormatter *formatter = [[CNContactFormatter alloc] init];
            NSString *strName = [formatter stringFromContact:obj];
            NSLog(@"%@",strName);
        }];
    }];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
