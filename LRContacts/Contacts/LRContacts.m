//
//  LRContacts.m
//  Ever79
//
//  Created by leo on 2017/11/4.
//  Copyright © 2017年 leo. All rights reserved.
//

#import "LRContacts.h"

@implementation LRContacts

+(BOOL)isAuthorization{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    return status == CNAuthorizationStatusAuthorized;
}

+(CNContactFetchRequest *)contactFetchRequest{
    return [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactIdentifierKey, [CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName], CNContactPhoneNumbersKey, CNContactEmailAddressesKey,CNContactOrganizationNameKey,CNContactJobTitleKey,CNContactBirthdayKey,CNContactRelationsKey]];
}

+(void)fetchContactsCallBack:(void (^)(NSArray<CNContact *> *, BOOL))callback{
    if (callback) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            if (![self isAuthorization]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(nil, NO);
                });
            }else{
                CNContactStore *store = [[CNContactStore alloc] init];
                [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if (!granted) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            callback(nil, NO);
                        });
                    }else{
                        NSMutableArray *contacts = [NSMutableArray arrayWithCapacity:30];
                        NSError *fetchError;
                        BOOL success = [store enumerateContactsWithFetchRequest:[self contactFetchRequest] error:&fetchError usingBlock:^(CNContact *contact, BOOL *stop) {
                            [contacts addObject:contact];
                        }];
                        if (!success) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                callback(nil, NO);
                            });
                        }else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                callback(contacts, YES);
                            });
                        }
                    }
                }];
            }
        });
    }
}

@end
