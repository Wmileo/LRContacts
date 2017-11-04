//
//  LRContacts.h
//  Ever79
//
//  Created by leo on 2017/11/4.
//  Copyright © 2017年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>

@interface LRContacts : NSObject

+(BOOL)isAuthorization;

+(void)fetchContactsCallBack:(void (^)(NSArray<CNContact *>* contacts, BOOL success))callback;

@end
