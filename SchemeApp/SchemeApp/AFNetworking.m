#import "AFNetworking.h"
#import <AFJSONRequestOperation.h>
#import <AFHTTPClient.h>
@implementation AFNetworking
{
    NSString *baseURL;
}
-(id)init
{
    self = [super init];
    if (self) {
        baseURL = @"http://schemeapp.erikosterberg.com/";
    }
    return self;
}
-(void)createType:(NSString *)type withContent:(NSDictionary *)content callback:(callback)callback
{
    NSURL *url = [NSURL URLWithString:baseURL];
    AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:url];
    [client POST:type parameters:content success:^(NSHTTPURLResponse *response, id responseObject) {
        //Handle success
    } failure:^(NSError *error) {
        //Handle failure
    }];
}
-(void)readType:(NSString *)type withId:(NSString *)typeId callback:(callback)callback
{
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@%@", baseURL, type];
    if (typeId) {
        [urlString appendFormat:@"/%@", typeId];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        callback(JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //Handle failure
    }];
    
    [operation start];
}
-(void)updateType:(NSString *)type withContent:(NSDictionary *)content callback:(callback)callback
{
    NSURL *url = [NSURL URLWithString:baseURL];
    NSString *putPath = [NSString stringWithFormat:@"%@/%@", type, content[@"_id"]];
    AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:url];
    [client PUT:putPath parameters:content success:^(NSHTTPURLResponse *response, id responseObject) {
        //Handle success
    } failure:^(NSError *error) {
        //Handle failure
    }];
   
}
-(void)deleteType:(NSString *)type withId:(NSString *)typeId callback:(callback)callback
{
    NSURL *url = [NSURL URLWithString:baseURL];
    NSString *deletePath = [NSString stringWithFormat:@"%@/%@", type, typeId];
    AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:url];
    [client DELETE:deletePath parameters:nil success:^(NSHTTPURLResponse *response, id responseObject) {
        //Handle success
    } failure:^(NSError *error) {
        //Handle failure
    }];
}

-(void)readByStartDate:(NSString *)startDate toEndDate:(NSString *)endDate callback:(callback)callback
{
    NSURL *url = [NSURL URLWithString:baseURL];
    NSDictionary *param = @{@"startDate": startDate, @"endDate": endDate};
    AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:url];
    [client POST:@"eventwrappers/findbydate" parameters:param success:^(NSHTTPURLResponse *response, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSError *error) {
        //Handle failure
    }];
}
@end
