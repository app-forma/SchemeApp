//
//  DatabaseConnection.h
//  SchemeApp
//
//  Created by Henrik on 2013-09-19.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#warning Unimplemented

#import <Foundation/Foundation.h>

typedef void (^completion)(id jsonObject, id response, NSError *error);


@interface DatabaseConnection : NSObject

- (void)addCompletionHandler:(completion)handler forSession:(NSString *)identifier;
- (void)callCompletionHandlerForSession:(NSString *)identifier;

-(void)createType:(NSString *)type withContent:(NSDictionary *)content completion:(completion)handler;
-(void)readType:(NSString *)type withId:(NSString *)typeId completion:(completion)handler;
//-(void)updateType:(NSString *)type withContent:(NSDictionary *)content completion:(completion)handler;
//-(void)deleteType:(NSString *)type withId:(NSString *)typeId completion:(completion)handler;
//-(void)readByStartDate:(NSString *)startDate toEndDate:(NSString *)endDate completion:(completion)handler;
//-(void)readByEmail:(NSString *)email completion:(completion)handler;

@end
