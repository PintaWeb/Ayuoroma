//
//  RPBascketOfGoodsViewController.m
//  Ayuroma
//
//  Created by Roman Pochtaruk on 04.05.15.
//  Copyright (c) 2015 Roman Pochtaruk. All rights reserved.
//

#import "RPPurchaseViewController.h"
#import "RPDetailGoodsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "RPPurchaseCell.h"
#import "RPGoods.h"
#import "RPOrderGoodsViewController.h"
#import "PKYStepper.h"
#import "RPPurchase.h"
#import "BBBadgeBarButtonItem.h"
#import "RPAppDelegate.h"

@interface RPPurchaseViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *orderGoodsBarButton;

@property (strong, nonatomic) NSMutableArray *goods;
@property (strong, nonatomic) NSMutableArray *countGoods;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) RPGoods *goodsOrder;
@property (strong, nonatomic) NSMutableArray *orders;

@end

@implementation RPPurchaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Корзина", nil);
    self.orderGoodsBarButton.title = NSLocalizedString(@"Заказать", nil);
    self.goods = [NSMutableArray array];
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(100, 180, 140, 50)];
    self.label.text = NSLocalizedString(@"Корзина пуста", nil);
    self.orders = [NSMutableArray array];
    
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSManagedObjectContext *context = [[RPAppDelegate sharedManager] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init ];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RPPurchase" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    self.goods = [[context executeFetchRequest:fetchRequest error:nil]mutableCopy];
    //[self.tableView reloadData];
    
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.goods count] == 0 ) {
        
        tableView.separatorColor = [UIColor clearColor];
        tableView.userInteractionEnabled = NO;
        [tableView addSubview:self.label];
        self.orderGoodsBarButton.enabled = NO;
        return [self.goods count];
        
    }else {
        self.orderGoodsBarButton.enabled = YES;
        return [self.goods count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *p  = NSLocalizedString(@"Цена:", nil);
    NSString *valuta = NSLocalizedString(@"грн.", nil);
    
    static NSString *kCellIdentifier = @"purchaseCell";
    
    RPPurchaseCell *cell = (RPPurchaseCell *)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    PKYStepper *stepper = [[PKYStepper alloc] initWithFrame:CGRectMake(200, 40, 120, 40)];
    if (!cell) {
        cell = [[RPPurchaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }

    RPPurchase *purchase = self.goods[indexPath.row];
    cell.goodsNameLabel.text = purchase.name;
    cell.goodsCountLabel.text = purchase.count;
    cell.goodsPriceLabel.text = [NSString stringWithFormat:@"%@ %@%@",p,purchase.price,valuta];
    stepper.countLabel.text = @"1";
    __block int count = [stepper.countLabel.text intValue];
    __block int countProduct = [purchase.count intValue];
    __block int maxProdCount = [purchase.count intValue];
    
    stepper.incrementCallback = ^(PKYStepper *stepper, float newValue){
        
        count ++;
        countProduct = (int)newValue + 1;
        stepper.countLabel.text = [NSString stringWithFormat:@"%d",countProduct];
        purchase.count = stepper.countLabel.text;
         NSLog(@"%@,%d",purchase.name,countProduct);
        if (countProduct == maxProdCount) {
            stepper.incrementButton.enabled = NO;
        }
    };
   
    stepper.decrementCallback = ^(PKYStepper *stepper, float newValue){
        
        count --;
        countProduct = count;
       
        stepper.countLabel.text = [NSString stringWithFormat:@"%d",countProduct];
         NSLog(@"%@,%d",purchase.name,countProduct);
        if (countProduct < maxProdCount) {
            stepper.incrementButton.enabled = YES;
        }
        
    };
    
    [self.orders addObject:purchase];
    [stepper setup];
    [cell.contentView addSubview:stepper];
    
    
    NSString *badURLimage = [NSString stringWithFormat:@"%@",purchase.img];
    NSArray *insertStr  = [badURLimage componentsSeparatedByString:@" "];
    badURLimage = [insertStr componentsJoinedByString:@"%20"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.ayuroma.com.ua/%@",badURLimage]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    __weak UITableViewCell *weakCell = cell;
    cell.goodsImageView.image = nil;
    
    [weakCell.imageView
     setImageWithURLRequest:request
     placeholderImage:nil
     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
         
         CGSize newSize;
         newSize.height = 50;
         newSize.width = 50;
         UIGraphicsBeginImageContext(newSize);
         [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
         image = UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();
         
         cell.goodsImageView.image = image;
         [weakCell layoutSubviews];
     }
     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
     }];
    
    return cell;

}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [[RPAppDelegate sharedManager] managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [context deleteObject:[self.goods objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        NSMutableArray *ar = (NSMutableArray *)self.goods;
        [ar removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 85;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NSLocalizedString(@"Удалить", nil);;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = nil;
    
    if ([segue.identifier isEqualToString:@"showDetailGoods"]) {
        
        indexPath = [self.tableView indexPathForSelectedRow];
        RPPurchase *selectedPurchase = self.goods[indexPath.row];
        RPDetailGoodsViewController *destViewController = segue.destinationViewController;
        destViewController.purchase = selectedPurchase;
        //destViewController.purchase = selectedPurchase;
    }
    if ([segue.identifier isEqualToString:@"showOrders"]) {
        
        NSLog(@"%@",self.orders);

        RPOrderGoodsViewController *destViewController = segue.destinationViewController;
        destViewController.orders = self.orders;

        //[self.tableView reloadData];
    }
    
}

@end
