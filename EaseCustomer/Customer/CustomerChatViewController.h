//
//  CustomerChatViewController.h
//  ChatDemo-UI3.0
//
//  Created by zgsoft on 16/8/24.
//  Copyright © 2016年 zgsoft. All rights reserved.
//


#import "ChatViewController.h"

@interface CustomerChatViewController : ChatViewController

@property (nonatomic, strong) NSDictionary *kfInfo;

- (instancetype)initWithKfInfo:(NSDictionary *)kfInfo;

@end
