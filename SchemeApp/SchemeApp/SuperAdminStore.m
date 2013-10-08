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
    [Store.dbConnection postContent:user.asDictionary
                                    toPath:DB_TYPE_USER
                            withCompletion:^(id responseBody, id response, NSError *error)
     {
         handler(responseBody, response, error);
     }];
}
- (void)updateUser:(User *)user completion:(completion)handler
{
    [Store.dbConnection putContent:user.asDictionary
                                   toPath:[NSString stringWithFormat:@"%@/%@", DB_TYPE_USER, user.docID]
                           withCompletion:^(id responseBody, id response, NSError *error)
     {
         handler(responseBody, response, error);
     }];
}
- (void)deleteUser:(User *)user completion:(completion)handler
{
    [Store.dbConnection deletePath:[NSString stringWithFormat:@"%@/%@", DB_TYPE_USER, user.docID]
                           withCompletion:^(id responseBody, id response, NSError *error)
     {
         handler(responseBody, response, error);
     }];
}

@end
