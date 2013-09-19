//
//  DatabaseConnection.h
//  SchemeApp
//
//  Created by Henrik on 2013-09-19.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^completion)(id jsonObject, id response, NSError *error);


@interface DatabaseConnection : NSObject

#pragma mark - Basic CRUD operations
- (void)postContent:(id)content toPath:(NSString *)path withCompletion:(completion)handler;
- (void)getPath:(NSString *)path withParams:(NSDictionary *)params andCompletion:(completion)handler;
- (void)putContent:(id)content toPath:(NSString *)path withCompletion:(completion)handler;
- (void)deletePath:(NSString *)path withCompletion:(completion)handler;

@end
