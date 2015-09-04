//
//  RPOrderGoodsViewController.h
//  Ayuroma
//
//  Created by Roman Pochtaruk on 05.05.15.
//  Copyright (c) 2015 Roman Pochtaruk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQDropDownTextField.h"

@class RPGoods;

@interface RPOrderGoodsViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) RPGoods *goods;
@property (strong, nonatomic) NSMutableArray *orders;

@end
