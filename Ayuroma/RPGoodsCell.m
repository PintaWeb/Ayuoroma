//
//  RPProductCell.m
//  Ayuroma
//
//  Created by Roman Pochtaruk on 16.04.15.
//  Copyright (c) 2015 Roman Pochtaruk. All rights reserved.
//

#import "RPGoodsCell.h"
#import "RPGoods.h"
#import "RPPurchase.h"


@interface RPGoodsCell () 

@property (weak, nonatomic) IBOutlet UILabel *stokeLabel;
@property (strong, nonatomic) RPGoods *goods;

@end

@implementation RPGoodsCell

- (void)awakeFromNib
{
    self.stokeLabel.text = NSLocalizedString(@"на складе:", nil);
    [self.buyGoodsButton setTitle:NSLocalizedString(@"В корзину", nil) forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:NO];
}

- (void)fillCellWithGoods:(RPGoods *)goods {
    
    self.goods = goods;
    NSString *price  = NSLocalizedString(@"Цена:", nil);
    NSString *valuta = NSLocalizedString(@"грн.", nil);
    
    self.goodsNameLabel.text = goods.name;
    self.descriptionGoodsLabel.text = goods.lastName;
    self.priceGoodsLabel.text = [NSString stringWithFormat:@"%@ %@%@",price,goods.price,valuta];
    self.countGoodsLabel.text = goods.count;
    
    
    NSString *titleString = self.goods.isProductInBasket ? NSLocalizedString(@"Отменить", nil) : NSLocalizedString(@"В корзину", nil);
    
    NSString *stoke = self.goods.inStock ? NSLocalizedString(@"нет", nil) :self.goods.count;
    self.countGoodsLabel.text = stoke;
    [self.buyGoodsButton setTitle:titleString forState:UIControlStateNormal];

}

@end
