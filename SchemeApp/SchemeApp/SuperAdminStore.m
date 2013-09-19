//
//  SuperAdminStore.m
//  SchemeApp
//
//  Created by Henrik on 2013-09-11.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#warning Handle error in methods where now callback:NULL

#import "SuperAdminStore.h"
#import "User.h"


@implementation SuperAdminStore
    
- (void)createUser:(User *)user completion:(completion)handler
{
    [Store.dbSessionConnection postContent:user.asDictionary
                                    toPath:DB_TYPE_USER
                            withCompletion:^(id jsonObject, id response, NSError *error)
     {
         handler(jsonObject, response, error);
     }];
}
- (void)updateUser:(User *)user completion:(completion)handler
{
    [Store.dbSessionConnection putContent:user.asDictionary
                                   toPath:[NSString stringWithFormat:@"%@/%@", DB_TYPE_USER, user.docID]
                           withCompletion:^(id jsonObject, id response, NSError *error)
     {
         handler(jsonObject, response, error);
     }];
}
- (void)deleteUser:(User *)user completion:(completion)handler
{
    [Store.dbSessionConnection deletePath:[NSString stringWithFormat:@"%@/%@", DB_TYPE_USER, user.docID]
                           withCompletion:^(id jsonObject, id response, NSError *error)
     {
         handler(jsonObject, response, error);
     }];
}

@end
