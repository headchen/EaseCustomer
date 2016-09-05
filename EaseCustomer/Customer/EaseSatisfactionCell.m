//
//  EaseSatisfactionCell.m
//  ChatDemo-UI3.0
//
//  Created by zgsoft on 16/8/23.
//  Copyright © 2016年 zgsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EaseSatisfactionCell.h"
#import "EaseBubbleView+Satisfaction.h"
#import "EaseBubbleView+text.h"
#import "UIImageView+EMWebCache.h"
#import "EaseCustomerConsts.h"

NSString *const kRouterEventSatisfactionBubbleTapEventName = @"kRouterEventSatisfactionBubbleTapEventName";

@implementation EaseSatisfactionCell

@synthesize isEnabled=_isEnabled;

-(BOOL) isCustomBubbleView:(id)model
{
    return YES;
}

-(void) setCustomBubbleView:(id<IMessageModel>)model
{
    [_bubbleView setupSatisfactionBubbleView];

}

-(void) setCustomModel:(id<IMessageModel>)model
{
    if (model.avatarURLPath) {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatarURLPath] placeholderImage:model.avatarImage];
    } else {
        self.avatarView.image = model.avatarImage;
    }
  
}

- (void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id<IMessageModel>)model
{
    [_bubbleView updateSatisfactionMargin:bubbleMargin];
    _bubbleView.translatesAutoresizingMaskIntoConstraints = YES;
    _bubbleView.frame = CGRectMake(55, 20, 200, 30);
     self.bubbleView.satisfactionLabel.frame = CGRectMake(3, 0, 190, 30);
    
}


-(void) setModel:(id<IMessageModel>)model
{
    [super setModel:model];
    
//    _isEnabled =([model.message.ext objectForKey:kMesssageExtWeChat]) && [[model.message.ext objectForKey:kMesssageExtWeChat] objectForKey:@"enable"];
//    if(_isEnabled)
//         _bubbleView.satisfactionLabel.text =@"您已经做过了评价";
//    else
//         _bubbleView.satisfactionLabel.text =@"请您对我的服务进行评价";
//    
 
}

+ (NSString *)cellIdentifierWithModel:(id<IMessageModel>)model
{
    NSString *str= model.isSender ? @"__satisCellSendIdentifier__"  : @"__satisCellReceiveIdentifier__";
    return [str stringByAppendingString:[model messageId]];
}

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model
{
    return 50.f;
}

+ (BOOL)isSatisfactionMessage:(EMMessage*)message
{
    //NSDictionary *userInfo = [;
    //NSString *login = [userInfo objectForKey:kSDKUsername];
    BOOL isSender = ([EMClient sharedClient].isLoggedIn &&  [[EMClient sharedClient].currentUsername isEqualToString:message.from]) ? YES : NO;
    if ([message.ext objectForKey:kMesssageExtWeChat] && !isSender) {
        NSDictionary *dic = [message.ext objectForKey:kMesssageExtWeChat];
        if ([dic objectForKey:kMesssageExtWeChat_ctrlType] &&
            [dic objectForKey:kMesssageExtWeChat_ctrlType] != [NSNull null] &&
            [[dic objectForKey:kMesssageExtWeChat_ctrlType] isEqualToString:kMesssageExtWeChat_ctrlType_inviteEnquiry]) {
            return YES;
        }
    }
    return NO;
}




@end
