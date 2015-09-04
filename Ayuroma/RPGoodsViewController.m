//
//  RPProductViewController.m
//  Ayuroma
//
//  Created by Roman Pochtaruk on 14.04.15.
//  Copyright (c) 2015 Roman Pochtaruk. All rights reserved.
//

#import "RPGoodsViewController.h"
#import "RPServerManager.h"
#import "RPGoods.h"
#import "RPGoodsCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "SWRevealViewController.h"
#import "UIImageView+AFNetworking.h"
#import "BBBadgeBarButtonItem.h"
#import "RPDetailGoodsViewController.h"
#import "RPPurchaseViewController.h"
#import "RPCategory.h"
#import "RPPurchase.h"
#import "RPAppDelegate.h"

static NSString* kBuyButtonId = @"goodsId";
static NSString* kBuyButtonTitle = @"title";

@interface RPGoodsViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *goodsSearchBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *basketGoodsBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *categoriesBarButton;
@property (strong, nonatomic) NSMutableArray *goods;
@property (strong, nonatomic) NSMutableArray *purchaseGoods;
@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) UILabel *downloadLabel;
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSArray *fethcArr;
@property (strong, nonatomic) RPPurchase *purchase;
@property (strong, nonatomic) RPAppDelegate *coreDataManager;

@end

@implementation RPGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.fethcArr = [NSMutableArray array];
    self.navigationItem.title = NSLocalizedString(@"Все товары", nil);
    self.title = self.categoryTitle;
    self.tableView.separatorColor = [UIColor clearColor];
    self.downloadLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 220, 80, 30)];
    self.downloadLabel.textColor = [UIColor brownColor];
    self.downloadLabel.font = [UIFont systemFontOfSize:14];
    self.downloadLabel.text = NSLocalizedString(@"Загрузка...", nil);

    self.indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicatorView.color = [UIColor brownColor];
    self.indicatorView.frame = CGRectMake(150, 180,10,10);
    
    [self.tableView addSubview:self.indicatorView];
    [self.tableView addSubview:self.downloadLabel];
    
    self.goodsSearchBar.hidden = YES;
    [self.indicatorView startAnimating];
    
    if (self.category.categoryId == nil) {

            [self getAllProducts:^(NSMutableArray *goods) {
                self.goods = goods;
                [self.tableView reloadData];

        }];} else {

            [self getGoodsWithId:self.category.categoryId processWithBlock:^(NSMutableArray *goods) {
                self.goods = goods;
                [self.tableView reloadData];
        }];
    }
    
    //Создание кнопки "Корзина"
    UIButton *purchaseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.barButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:purchaseButton];
    self.barButton.badgeBGColor =  [UIColor clearColor];
    self.barButton.badgeTextColor = [UIColor blueColor];
    self.barButton.shouldHideBadgeAtZero = NO;
    
    self.navigationItem.rightBarButtonItems = @[self.basketGoodsBarButton,self.barButton];
    SWRevealViewController *revealController = [self revealViewController];
    [revealController tapGestureRecognizer];

    if (revealController){
        [self.categoriesBarButton setTarget: self.revealViewController];
        [self.categoriesBarButton setAction: @selector(revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }else {
        self.goodsSearchBar.hidden  = YES;
    }

}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:NO];
    
    NSManagedObjectContext *context = [[RPAppDelegate sharedManager]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RPPurchase"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    self.fethcArr = [context executeFetchRequest:fetchRequest error:&error];
    self.barButton.badgeValue = [NSString stringWithFormat:@"%d",[self.fethcArr count]];
    [self.tableView reloadData];
}

#pragma mark - ServerManager
- (void) getAllProducts:(void (^) (NSMutableArray *goods))result {
    RPServerManager *manager = [[RPServerManager alloc]init];
    [manager getToken:^(NSString *token) {
         
         AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
         manager.responseSerializer = [AFJSONResponseSerializer serializer];
         manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
         __block NSMutableArray *mGoodsArray = [NSMutableArray array];
        
         for (int i = 0; i < 25; i++) {
             
             NSDictionary *params = @{@"token":token,@"page":@(i)};
             
             [manager POST:@"http://www.ayuroma.com.ua/json/products"
                parameters:params
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
                       NSArray *products = responseObject[@"products"];
                       for (NSDictionary *product in products) {

                           RPGoods *goods = [[RPGoods alloc]initWithGoods:product];
                           [mGoodsArray addObject:goods];
                       }
                       result(mGoodsArray);

                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       //NSLog(@"Error: %@", [error localizedDescription]);
                   }];
         }
     }];
}

-(void) getGoodsWithId:(NSString *)goodsId processWithBlock:(void(^)(NSMutableArray *goods))goods {
    RPServerManager *manager = [[RPServerManager alloc]init];
    [manager getToken:^(NSString *token) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        __block NSMutableArray *goodsArray = [NSMutableArray array];
        
        NSDictionary *param = @{@"token":token,@"parent":goodsId};
        [manager POST:@"http://www.ayuroma.com.ua/json/cat_products"
           parameters:param
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  NSArray *prod = responseObject[@"products"];
                  for (NSDictionary *dict in prod) {
                      
                      NSString *p_id = dict[@"id"];
                      NSDictionary *param = @{@"token":token,@"parent":p_id};
                      
                      [manager POST:@"http://www.ayuroma.com.ua/json/cat_products"
                         parameters:param
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                
                                NSArray *prod = responseObject[@"products"];
                                for (NSDictionary *d in prod) {
                                    
                                    RPGoods *good = [[RPGoods alloc]initWithGoods:d];
                                    [goodsArray addObject:good];
                                }
                                
                                goods(goodsArray);
                                
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                //NSLog(@"Error: %@ %@", error,[error localizedDescription]);
                            }];
                      
                  }
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  
              }];
    }];
    
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return [self.searchResults count];
        
    } else{
        
        return [self.goods count];
    }
     */
    return [self.goods count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"goodsCell";
    
    RPGoodsCell *cell = (RPGoodsCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[RPGoodsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    RPGoods *goods = self.goods[indexPath.row];
    [cell fillCellWithGoods:goods];
    [cell.buyGoodsButton addTarget:self action:@selector(checkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.goodsSearchBar.hidden = NO;
    
    // поиск пробела
    NSString *str = [NSString stringWithFormat:@"%@",goods.imageURL];
    NSArray *insertStr  = [str componentsSeparatedByString:@" "];
    str = [insertStr componentsJoinedByString:@"%20"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.ayuroma.com.ua/%@",str]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    __weak UITableViewCell *weakCell = cell;
    
    cell.goodsImageVIew.image = nil;
    
    [weakCell.imageView
     setImageWithURLRequest:request
     placeholderImage:nil
     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
         
         CGSize newSize;
         newSize.height = 60;
         newSize.width = 60;
         UIGraphicsBeginImageContext(newSize);
         [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
         image = UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();
         
         cell.goodsImageVIew.image = image;
         [weakCell layoutSubviews];
         
         [self.indicatorView stopAnimating];
         self.downloadLabel.hidden = YES;
         self.tableView.separatorColor = [UIColor lightGrayColor];
         
     }
     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {

     }];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 85;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

#pragma mark - Action
- (void)checkButtonTapped:(id)sender {
    
    BOOL b = NO;
    
    NSManagedObjectContext *context = [[RPAppDelegate sharedManager]managedObjectContext];
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RPPurchase"];
    self.fethcArr = [context executeFetchRequest:fetchRequest error:nil];
    
    RPGoods *goods = [self.goods objectAtIndex:indexPath.row];
    
    if (indexPath) {
        
        if (!goods.isProductInBasket) {
            
            b = YES;
            self.purchase = [NSEntityDescription insertNewObjectForEntityForName:@"RPPurchase"
                                                          inManagedObjectContext:context];
            
            [self.purchase  setValue:goods.name     forKey:@"name"];
            [self.purchase  setValue:goods.lastName forKey:@"lastName"];
            [self.purchase  setValue:goods.price    forKey:@"price"];
            [self.purchase  setValue:goods.count    forKey:@"count"];
            [self.purchase  setValue:goods.imageURL forKey:@"img"];
            [self.purchase  setValue:goods.goodsId  forKey:@"goodsId"];

            self.barButton.badgeValue = [NSString stringWithFormat:@"%u",[self.fethcArr count]+1];
            
        } else {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat: @"goodsId == %@", goods.goodsId];
            [fetchRequest setPredicate:predicate];
            self.purchase = (RPPurchase *)[[context executeFetchRequest:fetchRequest error:nil] firstObject];
                
                [context deleteObject:self.purchase];
            
            
               self.barButton.badgeValue = [NSString stringWithFormat:@"%u",[self.fethcArr count]-1];
            
            //[self.tableView reloadData];
        }
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        
        goods.isProductInBasket = !goods.isProductInBasket;
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = nil;
    RPGoods *goods = nil;
    
    if ([segue.identifier isEqualToString:@"showDetailGoods"]) {
        
        if (self.searchDisplayController.active) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            goods = self.searchResults[indexPath.row];
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            goods = self.goods[indexPath.row];
        }
         
        
        RPDetailGoodsViewController *destViewController = segue.destinationViewController;
        destViewController.goods = goods;
    }
    
    if ([segue.identifier isEqualToString:@"showPurchaseGoods"]) {
        
    }
    
    
}
//- (NSManagedObjectContext *)managedObjectContext {
//    NSManagedObjectContext *context = nil;
//    id delegate = [[UIApplication sharedApplication] delegate];
//    if ([delegate performSelector:@selector(managedObjectContext)]) {
//        context = [delegate managedObjectContext];
//    }
//    return context;
//}


#pragma mark - UISearchDisplayDelegate
/*
 - (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
 {
 NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
 self.searchResults = [self.goods filteredArrayUsingPredicate:resultPredicate];
 }
 
 -(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
 {
 [self filterContentForSearchText:searchString
 scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
 objectAtIndex:[self.searchDisplayController.searchBar
 selectedScopeButtonIndex]]];
 
 return YES;
 }
 */
@end
