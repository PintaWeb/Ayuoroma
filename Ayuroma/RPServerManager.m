//
//  RPServerManager.m
//  Ayuroma
//
//  Created by Roman Pochtaruk on 15.04.15.
//  Copyright (c) 2015 Roman Pochtaruk. All rights reserved.
//

#import "RPServerManager.h"
#import "AFHTTPRequestOperationManager.h"

static NSString *const kUsername = @"ANDROID_API";
static NSString *const kPassword = @"juVbjZFL";

@implementation RPServerManager

+ (RPServerManager*) sharedManager
{
    static RPServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RPServerManager alloc] init];
    });
    
    return manager;
}
-(void) getToken:(void (^)(NSString *token))result
{
    
    NSURL *baseUrl = [NSURL URLWithString:@"http://www.ayuroma.com.ua"];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"username":kUsername,@"password":kPassword};
    
    [manager POST:@"manager/processors/login.processor.php"
                   parameters:parameters
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          // с сервера приходит токен и 4 символа "\n\r" для их удаления я вывожу первые 32 символа
                          NSString *badToken = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                          NSString *goodToken = [badToken substringToIndex:32];
                          
                          result(goodToken);
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          
                          NSLog(@"Error: %@", [error localizedDescription]);
                      }];
}

@end
