//
//  RPProductViewController.h
//  Ayuroma
//
//  Created by Roman Pochtaruk on 14.04.15.
//  Copyright (c) 2015 Roman Pochtaruk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RPCategory;
@class BBBadgeBarButtonItem;
@class RPGoodsCell;
@class RPGoods;
@interface RPGoodsViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) RPCategory *category;
@property (strong, nonatomic) BBBadgeBarButtonItem *barButton;
@property (strong, nonatomic) RPGoodsCell *goodsButton;
@property (strong, nonatomic) RPGoods *product;
@property (strong, nonatomic) NSString *categoryTitle;


@end
