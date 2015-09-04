//
//  RPPurchase.h
//  Ayuroma
//
//  Created by Roman Pochtaruk on 01.06.15.
//  Copyright (c) 2015 Roman Pochtaruk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RPPurchase : NSManagedObject

@property (nonatomic, retain) NSString *categoryName;
@property (nonatomic, retain) NSString *count;
@property (nonatomic, retain) NSString *goodsDescription;
@property (nonatomic, retain) NSString *goodsId;
@property (nonatomic, retain) NSString *img;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *price;

@end
