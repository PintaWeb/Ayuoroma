//
//  RPDetailProductViewController.h
//  Ayuroma
//
//  Created by Roman Pochtaruk on 04.05.15.
//  Copyright (c) 2015 Roman Pochtaruk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RPGoods;
@class RPPurchase;
@interface RPDetailGoodsViewController : UIViewController

@property (strong, nonatomic) RPGoods *goods;
@property (strong,nonatomic)  RPPurchase *purchase;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *purchaseBarButton;

@end
