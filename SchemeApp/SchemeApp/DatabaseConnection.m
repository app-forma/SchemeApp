//
//  DatabaseConnection.m
//  SchemeApp
//
//  Created by Henrik on 2013-09-19.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "DatabaseConnection.h"


@implementation DatabaseConnection
{
    NSOperationQueue *queue;
    NSURLSession *urlSession;
    NSString *dbURL;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        queue = [[NSOperationQueue alloc] init];
        
        NSURLSessionConfiguration *sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration;
        sessionConfig.HTTPAdditionalHeaders = @{@"Accept": @"application/json",
                                                @"Content-Type": @"application/json"};
        
        urlSession = [NSURLSession sessionWithConfiguration:sessionConfig
                                                   delegate:nil
                                              delegateQueue:queue];
        
        dbURL = @"http://schemeapp.erikosterberg.com";
    }
    return self;
}

#pragma mark - Basic CRUD operations
- (void)postContent:(id)content toPath:(NSString *)path withCompletion:(completion)handler
{
    [self runSessionDataTaskWithRequest:[self requestWithPath:path bodyJSONObject:content andMethod:@"POST"]
                          andCompletion:handler];
}
- (void)getPath:(NSString *)path withParams:(NSDictionary *)params andCompletion:(completion)handler;
{
    NSMutableURLRequest *request;
    if (params)
    {
        request = [self requestWithPath:path
                         bodyJSONObject:params
                              andMethod:@"POST"];
    }
    else
    {
        request = [self requestWithPath:path
                         bodyJSONObject:nil
                              andMethod:@"GET"];
    }
    
    [self runSessionDataTaskWithRequest:request
                          andCompletion:handler];
}
- (void)putContent:(id)content toPath:(NSString *)path withCompletion:(completion)handler;
{
    [self runSessionDataTaskWithRequest:[self requestWithPath:path bodyJSONObject:content andMethod:@"PUT"]
                          andCompletion:handler];
}
- (void)deletePath:(NSString *)path withCompletion:(completion)handler;
{
    [self runSessionDataTaskWithRequest:[self requestWithPath:path bodyJSONObject:nil andMethod:@"DELETE"]
                          andCompletion:handler];
}

#pragma mark - Extracted methods
- (NSMutableURLRequest *)requestWithPath:(NSString *)path bodyJSONObject:(id)jsonObject andMethod:(NSString *)methodString
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", dbURL, path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = methodString;
    
    if (jsonObject)
    {
        NSError *error;
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:jsonObject
                                                           options:NSJSONWritingPrettyPrinted error:&error];
        if (error)
        {
            NSLog(@"%@ tried to parse incomming jsonObject but got error: %@", self.class, error);
            return nil;
        }
    }
    
    return request;
}
- (void)runSessionDataTaskWithRequest:(NSMutableURLRequest *)request andCompletion:(completion)handler
{
    [[urlSession dataTaskWithRequest:request
                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          id jsonObject;
          
          if (!error)
          {
              jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                           options:NSJSONReadingMutableContainers
                                                             error:&error];
          }
          
          handler(jsonObject, response, error);
      }] resume];
}

@end
