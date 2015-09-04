//
//  RPBascketOfGoodsCell.h
//  Ayuroma
//
//  Created by Roman Pochtaruk on 04.05.15.
//  Copyright (c) 2015 Roman Pochtaruk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPPurchaseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;

@end
