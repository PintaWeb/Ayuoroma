//
//  RPProduct.m
//  Ayuroma
//
//  Created by Roman Pochtaruk on 16.04.15.
//  Copyright (c) 2015 Roman Pochtaruk. All rights reserved.
//

#import "RPGoods.h"

@implementation RPGoods

-(id)initWithGoods:(NSDictionary *)goods
{
    self = [super init];
    if (self){
        self.name  = goods[@"p_t"];
        self.lastName = goods[@"l_t"];
        self.count = goods[@"count"];
        self.goodsId = goods[@"id"];
        self.price = goods[@"cena"];
        self.imageURL = goods[@"img"];
        self.isProductInBasket = NO;
        self.inStock = NO;
        self.mGoods = [NSMutableArray array];
    }
    return self;
    
}

- (id)initProductWithCount:(NSString *)count productId:(NSString *)productId {
    
    self = [super init];
    
    if (self) {
        
        self.count = count;
        self.goodsId = productId;
    }
    
    return self;
}
-(NSString *)description {
    return [NSString stringWithFormat:@"id - %@,count - %@",self.goodsId,self.count];
}
@end
