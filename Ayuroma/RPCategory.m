//
//  RPCategory.m
//  Ayuroma
//
//  Created by Roman Pochtaruk on 15.04.15.
//  Copyright (c) 2015 Roman Pochtaruk. All rights reserved.
//

#import "RPCategory.h"

@implementation RPCategory

+ (RPCategory *) sharedCategory
{
    static RPCategory *category = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        category = [[self alloc] init];
    });
    
    return category;
}

- (id) initWithAllCat:(NSDictionary *)allCategory
{
    self = [super init];
    if (self) {
        self.name = allCategory[@"c"];
        self.categoryId = allCategory[@"c_id"];
    }
    
    return self;
}

@end
