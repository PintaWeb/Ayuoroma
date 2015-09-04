//
//  RPBascketOfGoodsViewController.h
//  Ayuroma
//
//  Created by Roman Pochtaruk on 04.05.15.
//  Copyright (c) 2015 Roman Pochtaruk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RPGoodsViewController;
@class RPPurchase;

@interface RPPurchaseViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *purchaseGoods;
@property (strong, nonatomic) RPPurchase *purcase;

@end
