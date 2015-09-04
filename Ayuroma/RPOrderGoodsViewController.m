//
//  RPOrderGoodsViewController.m
//  Ayuroma
//
//  Created by Roman Pochtaruk on 05.05.15.
//  Copyright (c) 2015 Roman Pochtaruk. All rights reserved.
//

#import "RPOrderGoodsViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "RPServerManager.h"
#import "RPGoods.h"

@interface RPOrderGoodsViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *sumGoodsLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *paymentField;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *deliveryMethodField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;

@property (weak, nonatomic) IBOutlet UIView *viewOnScrollView;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *delivery;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *payment;

@end

@implementation RPOrderGoodsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar sizeToFit];
    
    UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil];
    
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Готово", nil)
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self action:@selector(doneClicked:)];
    
    [toolbar setItems:@[buttonflexible,buttonDone]];
    self.deliveryMethodField.inputAccessoryView = toolbar;
    self.deliveryMethodField.isOptionalDropDown = NO;
    [self.deliveryMethodField setItemList:@[@"УкрПошта",@"Нова Пошта"]];
    self.delivery = [self.deliveryMethodField text];
    self.payment = self.paymentField.text;
}

#pragma mark - Selector
-(void)doneClicked:(UIBarButtonItem*)button {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.nameField]){
        
        [self.emailField becomeFirstResponder];
    }
    else if ([textField isEqual:self.emailField]){
        
        [self.phoneField becomeFirstResponder];
    }
    else if ([textField isEqual:self.phoneField]){
        
        [self.addressField becomeFirstResponder];
    }
    else if ([textField isEqual:self.addressField]){
        
        [self.deliveryMethodField becomeFirstResponder];
    }
    else if ([textField isEqual:self.deliveryMethodField]){
        
        [self.deliveryMethodField resignFirstResponder];
    }

    return YES;
}

#pragma mark - Action
- (IBAction)actionDidEnd:(UITextField *)sender {
    
    if ([sender isEqual:self.nameField]){

        self.name = sender.text;
    }else if ([sender isEqual:self.emailField]){
        
        self.email = sender.text;
        
    }else if ([sender isEqual:self.phoneField]){
        
        self.phone = sender.text;
        
    }else if ([sender isEqual:self.addressField]){
        
        self.address = sender.text;
        
    }else if ([sender isEqual:self.deliveryMethodField]){
        
        self.delivery = self.deliveryMethodField.text;
    }
}

- (void) alert {

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Внимание!", nil)
                                                   message:NSLocalizedString(@"Заполните необходимые поля", nil)
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"Заполнить", nil)
                                         otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void) messageAlert {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Здравствуйте!", nil)
                                                   message:NSLocalizedString(@"Ваш заказ принят", nil)
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"выйти", nil)
                                         otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)checkoutButton:(id)sender {
    
    
    [[RPServerManager sharedManager]
     getToken:^(NSString *token) {
         
         AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
         manager.responseSerializer = [AFJSONResponseSerializer serializer];
         
         RPGoods *product = [[RPGoods alloc]init];
         
         for (product in self.orders) {
             
             NSLog(@"%@",product);
             NSLog(@"%d",[self.orders count]);
             
             NSDictionary *params = @{@"token"          :token,
                                      @"name"           :self.name,
                                      @"email"          :self.email,
                                      @"phone"          :self.phone,
                                      @"address"        :self.address,
                                      @"methodSending"  :self.delivery,
                                      @"products"       :product.goodsId,
                                      @"count"          :product.count,
                                      @"methodPayment"  :self.payment};
             
             
             NSLog(@"%@",params);
             
             
             [manager POST:@"http://www.ayuroma.com.ua/json/post_zakaz"
                parameters:params
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       
                   }];
         }
     }];
    [self messageAlert];
    
}

@end
