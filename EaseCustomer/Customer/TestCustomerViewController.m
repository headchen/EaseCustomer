//
//  TestCustomerViewController.m
//  ChatDemo-UI3.0
//
//  Created by zgsoft on 16/8/25.
//  Copyright © 2016年 zgsoft. All rights reserved.
//

#import "TestCustomerViewController.h"
#import "CustomerChatViewController.h"
#import "ZgKfInfo.h"

@interface TestCustomerViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnTestWithComm;

@property (weak, nonatomic) IBOutlet UIButton *btnTestCustomer;
- (IBAction)doTestCusomerWithComm:(id)sender;
- (IBAction)doTestCustomer:(id)sender;
@end

@implementation TestCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doTestCusomerWithComm:(id)sender {
    NSDictionary *info = [[ZgKfInfo sharedInfo] createDebugInfoWithCommodity];
    [info setValue:@"boy" forKeyPath:@"user.userId"];
    CustomerChatViewController *cusV = [[CustomerChatViewController alloc] initWithKfInfo: info];
    
//    [[self navigationController] pushViewController:cusV animated:YES];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cusV];
    [self presentViewController:nav animated:YES completion:nil];

   
    
}

- (IBAction)doTestCustomer:(id)sender {
    CustomerChatViewController *cusV = [[CustomerChatViewController alloc] initWithKfInfo:[[ZgKfInfo sharedInfo] createDebugInfo] ];
    
    [[self navigationController] pushViewController:cusV animated:YES];
}
@end