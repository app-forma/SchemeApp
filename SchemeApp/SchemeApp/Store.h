//
//  Store.h
//  
//
//  Created by Henrik on 2013-09-09.
//
//

#import <Foundation/Foundation.h>
#import "AdminStore.h"
#import "StudentStore.h"

@class User;


@interface Store : NSObject

@property (nonatomic, strong) User *currentUser;

+ (Store *)mainStore;
+ (AdminStore *)adminStore;
+ (StudentStore *)studentStore;

@end
