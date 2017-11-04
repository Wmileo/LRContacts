//
//  LRContacts.m
//  Ever79
//
//  Created by leo on 2017/11/4.
//  Copyright © 2017年 leo. All rights reserved.
//

#import "LRContacts.h"

@implementation LRContacts

+(void)isAuthorization:(void (^)(BOOL))auth{
    if (auth) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
            if (status == CNAuthorizationStatusAuthorized) {
                auth(YES);
            }else{
                CNContactStore *store = [[CNContactStore alloc] init];
                [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        auth(granted);
                    });
                }];
            }
        });
    }
}

+(CNContactFetchRequest *)contactFetchRequest{
    return [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactIdentifierKey, [CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName], CNContactPhoneNumbersKey, CNContactEmailAddressesKey,CNContactOrganizationNameKey,CNContactJobTitleKey,CNContactBirthdayKey,CNContactRelationsKey]];
}

+(void)fetchContactsCallBack:(void (^)(NSArray<CNContact *> *, BOOL))callback{
    if (callback) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self isAuthorization:^(BOOL auth) {
                if (auth) {
                    CNContactStore *store = [[CNContactStore alloc] init];
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
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        callback(nil, NO);
                    });
                }
            }];
        });
    }
}

@end
