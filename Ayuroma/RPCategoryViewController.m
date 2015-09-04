//
//  RPCategoryViewController.m
//  Ayuroma
//
//  Created by Roman Pochtaruk on 14.04.15.
//  Copyright (c) 2015 Roman Pochtaruk. All rights reserved.
//

#import "RPCategoryViewController.h"
#import "RPGoodsViewController.h"
#import "RPCategory.h"

@interface RPCategoryViewController ()

@property (strong, nonatomic) NSMutableArray *allCategories;

@end

@implementation RPCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.allCategories = [NSMutableArray array];
    
    NSArray *allCat = [RPCategory sharedCategory].allCategory[@"all_cat"];
    
    for (NSDictionary *category in allCat) {
        
        self.category = [[RPCategory alloc]initWithAllCat:category];
        [self.allCategories addObject:self.category];
        NSLog(@"%d",[self.allCategories count]);
    }
}
#pragma mark - TableViewDataSource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"Категории", nil);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allCategories count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"categoryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    RPCategory *category = self.allCategories[indexPath.row];
    cell.textLabel.text = category.name;

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
   
    if ([segue.identifier isEqualToString:@"showGoods"]) {
        
        UINavigationController *navController = segue.destinationViewController;
        
        RPGoodsViewController *goodsViewController = [navController childViewControllers].firstObject;
        RPCategory *cat = self.allCategories[indexPath.row];
        goodsViewController.category = cat;
        goodsViewController.categoryTitle = cat.name;
    }
}


@end
