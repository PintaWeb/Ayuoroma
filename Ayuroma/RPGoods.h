//
//  RPProduct.h
//  Ayuroma
//
//  Created by Roman Pochtaruk on 16.04.15.
//  Copyright (c) 2015 Roman Pochtaruk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPGoods : NSObject

@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *count;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *goodsId;
@property (strong, nonatomic) NSMutableArray *mGoods;
@property (assign, nonatomic) BOOL isProductInBasket;
@property (assign, nonatomic) BOOL inStock;

- (id)initWithGoods:(NSDictionary *)goods;
- (id)initProductWithCount:(NSString *)count productId:(NSString *)productId;

@end
