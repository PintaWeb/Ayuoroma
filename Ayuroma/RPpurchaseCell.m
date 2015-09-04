//
//  RPBascketOfGoodsCell.m
//  Ayuroma
//
//  Created by Roman Pochtaruk on 04.05.15.
//  Copyright (c) 2015 Roman Pochtaruk. All rights reserved.
//

#import "RPPurchaseCell.h"
#import "RPPurchase.h"

@interface RPPurchaseCell ()

@property (weak, nonatomic) IBOutlet UILabel *storeLabel;
@property (strong, nonatomic) RPPurchase *purchase;
@end

@implementation RPPurchaseCell


- (void)awakeFromNib
{
    self.storeLabel.text = NSLocalizedString(@"На складе:", nil);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
