//
//  RPProductCell.h
//  Ayuroma
//
//  Created by Roman Pochtaruk on 16.04.15.
//  Copyright (c) 2015 Roman Pochtaruk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RPGoods;

@interface RPGoodsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionGoodsLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceGoodsLabel;
@property (weak, nonatomic) IBOutlet UILabel *countGoodsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageVIew;
@property (weak, nonatomic) IBOutlet UIButton *buyGoodsButton;

- (void)fillCellWithGoods:(RPGoods *)goods;

@end
