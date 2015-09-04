//
//  RPDetailProductViewController.m
//  Ayuroma
//
//  Created by Roman Pochtaruk on 04.05.15.
//  Copyright (c) 2015 Roman Pochtaruk. All rights reserved.
//

#import "RPDetailGoodsViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+AFNetworking.h"
#import "RPPurchaseViewController.h"
#import "RPServerManager.h"
#import "RPGoods.h"
#import "RPPurchase.h"
#import "BBBadgeBarButtonItem.h"
#import "RPAppDelegate.h"

@interface RPDetailGoodsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameProductLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageProduct;
@property (weak, nonatomic) IBOutlet UILabel *categoryProductLabel;
@property (weak, nonatomic) IBOutlet UITextView *completeDescriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *countProductLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceProductLabel;

@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) UILabel *downloadLabel;
@property (strong, nonatomic) NSMutableArray *purchases;
@property (retain, nonatomic) BBBadgeBarButtonItem *badge;
@property (strong, nonatomic) RPPurchase *purcha;
@end

@implementation RPDetailGoodsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.purchases = [NSMutableArray array];
    
    if (self.goods.isProductInBasket) {
        [self.buyButton setTitle:@"Отменить"forState:UIControlStateNormal];
    } else {
        [self.buyButton setTitle:@"В корзину" forState:UIControlStateNormal];
    }

    
    if (self.purchase) {
     
        [self getCurrentProduct];
        self.purchaseBarButton.tintColor = [UIColor clearColor];
        self.purchaseBarButton.enabled = NO;
        
        self.nameProductLabel.text = [NSString stringWithFormat:@"%@\n%@",self.purchase.name,self.purchase.lastName];
        self.priceProductLabel.text = [NSString stringWithFormat:@"%@грн.",self.purchase.price];
        self.countProductLabel.text = self.purchase.count;
        self.buyButton.hidden = YES;
        self.buyButton.enabled = NO;
        //[self.buyButton setTitle:@"Отменить" forState:UIControlStateNormal];
        
        // поиск пробела
        NSString *badURLimage = [NSString stringWithFormat:@"%@",self.purchase.img];
        NSArray *insertStr  = [badURLimage componentsSeparatedByString:@" "];
        badURLimage = [insertStr componentsJoinedByString:@"%20"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.ayuroma.com.ua/%@",badURLimage]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        self.imageProduct.image = nil;
        
        // получение картинки товара
        [self.imageProduct
         setImageWithURLRequest:request
         placeholderImage:nil
         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
             
             CGSize newSize;
             newSize.width = 214;
             newSize.height = 124;
             UIGraphicsBeginImageContext(newSize);
             [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
             image = UIGraphicsGetImageFromCurrentImageContext();
             UIGraphicsEndImageContext();
             
             self.imageProduct.image = image;
             
         }
         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
             NSLog(@"%@",[error localizedDescription]);
          }];
        
    } else {
        [self getCurrentGoods];
        
        NSManagedObjectContext *context = [[RPAppDelegate sharedManager]managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RPPurchase"];
        NSArray *arr = [context executeFetchRequest:fetchRequest error:nil];
        
        [self downloadIndicatorData];
        
        
        UIButton *purchaseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        self.badge  = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:purchaseButton];
        
        self.badge.badgeBGColor =  [UIColor clearColor];
        self.badge.badgeTextColor = [UIColor blueColor];
        self.badge.shouldHideBadgeAtZero = NO;
        self.badge.badgeValue = [NSString stringWithFormat:@"%d",[arr count]];
        self.navigationItem.rightBarButtonItems = @[self.purchaseBarButton,self.badge];
        
        
        
        NSString *nameAndDescGoods = [NSString stringWithFormat:@"%@\n%@",self.goods.name,self.goods.lastName];
        self.nameProductLabel.text = nameAndDescGoods;
        self.countProductLabel.text = self.goods.count;
        self.priceProductLabel.text = [NSString stringWithFormat:@"Цена:%@грн.",self.goods.price];
        // поиск пробела
        NSString *badURLimage = [NSString stringWithFormat:@"%@",self.goods.imageURL];
        NSArray *insertStr  = [badURLimage componentsSeparatedByString:@" "];
        badURLimage = [insertStr componentsJoinedByString:@"%20"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.ayuroma.com.ua/%@",badURLimage]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        self.imageProduct.image = nil;
        
        // получение картинки товара
        [self.imageProduct
         setImageWithURLRequest:request
         placeholderImage:nil
         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
             
             CGSize newSize;
             newSize.width = 214;
             newSize.height = 124;
             UIGraphicsBeginImageContext(newSize);
             [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
             image = UIGraphicsGetImageFromCurrentImageContext();
             UIGraphicsEndImageContext();
             
             self.imageProduct.image = image;
             
         }
         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
             NSLog(@"%@",[error localizedDescription]);
         }];
    }
     
}

#pragma mark - Get Product
- (void) getCurrentGoods
{
    RPServerManager *manager = [[RPServerManager alloc]init];
    [manager getToken:^(NSString *token)  {
         
         AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
         manager.responseSerializer = [AFJSONResponseSerializer serializer];
         manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
         
         NSDictionary *params = @{@"token":token,@"id":self.goods.goodsId};

        
         [manager POST:@"http://www.ayuroma.com.ua/json/product"
            parameters:params
               success:^(AFHTTPRequestOperation *operation,id responseObject) {
                   
                   NSArray *product = responseObject[@"product"];
                   
                   for (NSDictionary *d in product ) {

                           self.completeDescriptionTextView.text = d[@"cont"];
                           NSString *nameCategory = [NSString stringWithFormat:@"%@,%@",d[@"c"],d[@"s_c"]];
                           self.categoryProductLabel.text = nameCategory;
                   }
                   [self.indicatorView stopAnimating];
                   self.downloadLabel.hidden = YES;
                   
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   NSLog(@"Error: %@",[error localizedDescription]);
               }];
        
     }];
}

- (void) getCurrentProduct
{
    RPServerManager *manager = [[RPServerManager alloc]init];
    [manager getToken:^(NSString *token)  {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSDictionary *params = @{@"token":token,@"id":self.purchase.goodsId};
        
        [manager POST:@"http://www.ayuroma.com.ua/json/product"
           parameters:params
              success:^(AFHTTPRequestOperation *operation,id responseObject) {
                  
                  NSArray *product = responseObject[@"product"];
                  
                  for (NSDictionary *d in product ) {
                    self.completeDescriptionTextView.text = d[@"cont"];
                      NSString *nameCategory = [NSString stringWithFormat:@"%@,%@",d[@"c"],d[@"s_c"]];
                      self.categoryProductLabel.text = nameCategory;
                      
                  }
                  [self.indicatorView stopAnimating];
                  self.downloadLabel.hidden = YES;
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@",[error localizedDescription]);
              }];
        
    }];
}

#pragma mark - Private method
- (void)downloadIndicatorData {
    
    self.downloadLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 280, 80, 30)];
    self.downloadLabel.textColor = [UIColor brownColor];
    self.downloadLabel.font = [UIFont systemFontOfSize:14];
    self.downloadLabel.text = NSLocalizedString(@"Загрузка...", nil);
    
    self.indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicatorView.color = [UIColor brownColor];
    self.indicatorView.frame = CGRectMake(150, 250,10,10);
    [self.view addSubview:self.indicatorView];
    [self.view addSubview:self.downloadLabel];
    [self.indicatorView startAnimating];
}

- (IBAction)buyButton:(UIButton *)sender {
    
    
    NSManagedObjectContext *context = [[RPAppDelegate sharedManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RPPurchase"];
    NSArray *arr = [context executeFetchRequest:fetchRequest error:nil];
  
    if ([sender.currentTitle isEqualToString:@"В корзину"]) {
      
        [sender setTitle:@"Отменить" forState:UIControlStateNormal];
        self.purchase = [NSEntityDescription insertNewObjectForEntityForName:@"RPPurchase"
                                                      inManagedObjectContext:context];
        [self.purchase setValue:self.goods.name     forKey:@"name"];
        [self.purchase setValue:self.goods.lastName forKey:@"lastName"];
        [self.purchase setValue:self.goods.price    forKey:@"price"];
        [self.purchase setValue:self.goods.count    forKey:@"count"];
        [self.purchase setValue:self.goods.imageURL forKey:@"img"];
        [self.purchase setValue:self.goods.goodsId  forKey:@"goodsId"];
        self.badge.badgeValue = [NSString stringWithFormat:@"%d",[arr count]+1];
            
    } else  {
        self.badge.badgeValue = [NSString stringWithFormat:@"%d",[arr count]-1];
        
        [sender setTitle:@"В корзину"forState:UIControlStateNormal];
        
        [context deleteObject:self.purchase];

    }
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}


@end
