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

- (void)readType:(NSString *)type withId:(NSString *)typeId completion:(completion)handler
{
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/%@", dbURL, type];
    if (typeId)
    {
        [urlString appendString:[NSString stringWithFormat:@"/%@", typeId]];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"GET";
    
    [[urlSession dataTaskWithRequest:request
                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          id jsonObject;
          
          if (error)
          {
#warning Testing
              NSLog(@"%@ got response: %@ with error: %@", self.class, response, error.userInfo);
          }
          else
          {
#warning Testing
              jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                              options:NSJSONReadingAllowFragments
                                                                error:&error];
              if (error)
              {
                  NSLog(@"%@ got response: %@ with jsonError: %@", self.class, response, error.userInfo);
              }
              NSLog(@"%@ got response: %@ with JSONData: %@", self.class, response, jsonObject);
          }
          
          handler(jsonObject, response, error);
          
      }] resume];
}

- (void)createType:(NSString *)type withContent:(id)content completion:(completion)handler
{
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/%@", dbURL, type];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSError *error;
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:content options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"[%@] JSON parse error: %@", self.class, error);
    }
    NSLog(@"asdasd %@", request.HTTPBody);
    
    request.HTTPMethod = @"POST";
    
    [[urlSession dataTaskWithRequest:request
                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          id jsonObject;
          
          if (error)
          {
#warning Testing
              NSLog(@"%@ got response: %@ with error: %@", self.class, response, error.userInfo);
          }
          else
          {
#warning Testing
              jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                           options:NSJSONReadingAllowFragments
                                                             error:&error];
              if (error)
              {
                  NSLog(@"%@ got response: %@ with jsonError: %@", self.class, response, error.userInfo);
              }
              NSLog(@"%@ got response: %@ with JSONData: %@", self.class, response, jsonObject);
          }
          
          handler(jsonObject, response, error);
          
      }] resume];
}

@end
