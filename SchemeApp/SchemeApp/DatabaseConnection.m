//
//  DatabaseConnection.m
//  SchemeApp
//
//  Created by Henrik on 2013-09-19.
//  Copyright (c) 2013 Team leet. All rights reserved.
//

#import "DatabaseConnection.h"

@interface DatabaseConnection ()<NSURLSessionDelegate, NSURLSessionTaskDelegate>

@end

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
        dbURL = @"http://schemeapp.erikosterberg.com";
        
        queue = [[NSOperationQueue alloc] init];
        
        NSURLSessionConfiguration *sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration;
        sessionConfig.HTTPAdditionalHeaders = @{@"Accept": @"application/json",
                                                @"Content-Type": @"application/json"};
        sessionConfig.HTTPShouldSetCookies = YES;
        sessionConfig.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicyAlways;
        
        urlSession = [NSURLSession sessionWithConfiguration:sessionConfig
                                                   delegate:self
                                              delegateQueue:queue];
        
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
- (NSMutableURLRequest *)requestWithPath:(NSString *)path bodyJSONObject:(id)responseBody andMethod:(NSString *)methodString
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", dbURL, path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = methodString;
    
    if (responseBody)
    {
        NSError *error;
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:responseBody
                                                           options:NSJSONWritingPrettyPrinted error:&error];
        if (error)
        {
            NSLog(@"%@ tried to parse incomming responseBody but got error: %@", self.class, error);
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
          id responseBody;
          
          if (!error)
          {
              responseBody = [NSJSONSerialization JSONObjectWithData:data
                                                           options:NSJSONReadingMutableContainers
                                                             error:&error];
          }
          
          handler(responseBody, response, error);
      }] resume];
}

@end
