//
//  RPCategory.h
//  Ayuroma
//
//  Created by Roman Pochtaruk on 15.04.15.
//  Copyright (c) 2015 Roman Pochtaruk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPCategory : NSObject 

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSMutableArray *allCategories;
@property (strong, nonatomic) NSMutableArray *goodsArray;
@property (strong, nonatomic) NSDictionary *allCategory;

+ (RPCategory *) sharedCategory;

- (id) initWithAllCat:(NSDictionary *)allCategory;

@end
