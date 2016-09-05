//
//  CustomerChatViewController.m
//  ChatDemo-UI3.0
//
//  Created by zgsoft on 16/8/24.
//  Copyright © 2016年 zgsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerChatViewController.h"
#import "EaseMessageViewController.h"
#import "UIImageView+EMWebCache.h"
#import "UIView+Toast.h"
#import "SatisfactionViewController.h"
#import "EaseSatisfactionCell.h"
#import "EaseCustomerConsts.h"
#import "EaseTrackCell.h"
#import "EMClient.h"
#import "EMClient+Call.h"
#import "NSDictionary+MutableDeepCopy.h"
#import "ZgKfInfo.h"

@interface CustomerChatViewController()  <EaseMessageViewControllerDataSource,
                                          EaseMessageViewControllerDelegate,
                                          SatisfactionDelegate,EaseMessageCellDelegate>


@property  (nonatomic ,strong) NSString *customerUserId ;
@end

@implementation CustomerChatViewController

@synthesize customerUserId = _customerUserId;
@synthesize kfInfo = _kfInfo;


//String jsonStr="{\n" +
//" \"appkey\":\"zgsoft#ygyjs\",\n" +
//" \"extraUserId\":\"headchen\",\n" +
//"user:{\n" +
//" \"userId\":\"minnie\",\n" +
//" \"password\":\"123456\"\n" +
//"},\n" +
//"weichat:{\n" +
//"   \"queueName\":\"shouqian\",\n" +
//"      visitor:{\n" +
//"        trueName:\"李明\",\n" +
//"        qq:\"13512345678\",\n" +
//"        companyName:\"环信\",\n" +
//"        userNickname:\"小明\",\n" +
//"        description:\"会员卡号：123456\",\n" +
//"        email:\"abc@123.com\",\n" +
//"        tags: [\"vip1\", \"vip2\"]\n" +
//"      }\n" +
//"    }\n" +
//"\t\n" +
//"}\n" +
//"\t";


//{ ext:{
//msgtype:{
//    // 用户轨迹消息
//track:{
//    // 消息标题
//title:       "我正在看：",
//    // 商品价格
//price:       "¥: 235.00",
//    // 商品描述
//desc:        "女装小香风气质蕾丝假两件短袖",
//    // 商品图片链接
//img_url:     "http://yourdomain.com/img/a.jpg",
//    // 商品页面链接
//item_url:    "http://yourdomain.com/item/a.html"
//}
//}
//}
//}

- (instancetype)initWithKfInfo:(NSDictionary *)kfInfo
//                           conversationType:(EMConversationType)conversationType
{
    if(!kfInfo)
        return nil;
    _kfInfo = kfInfo;
    _customerUserId = [kfInfo objectForKey:@"extraUserId"];

    
    [[ZgKfInfo sharedInfo]  initEMClient:kfInfo];
    [[ZgKfInfo sharedInfo] tryLogin:kfInfo];
    
    
    return [super initWithConversationChatter:_customerUserId conversationType:EMConversationTypeChat];
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    
    if ([self.chatToolbar isKindOfClass:[EaseChatToolbar class]]) {
        //  MARK: 客服
        //[self.chatToolbar insertItemWithImage:nil highlightedImage:nil title: @"客服"];
    }
        self.navigationItem.title = @"客服";
    
    [[EaseSatisfactionCell appearance] setAvatarSize:40.f];
    [[EaseSatisfactionCell appearance] setAvatarCornerRadius:20.f];
    [[EaseSatisfactionCell appearance] setMessageNameIsHidden:YES];
    
    [[EaseBaseMessageCell appearance] setMessageNameIsHidden:YES];
    [[EaseTrackCell appearance] setAvatarSize:40.f];
    [[EaseTrackCell appearance] setAvatarCornerRadius:20.f];
    [[EaseTrackCell appearance] setMessageNameIsHidden:YES];
    
    if( self.chatBarMoreView )
    {
    [self.chatBarMoreView removeItematIndex : 4 ];
    [self.chatBarMoreView removeItematIndex : 3 ];
    }
    
    //        [((EaseChatBarMoreView *)_moreView)  removeItematIndex: 4];
    //        [((EaseChatBarMoreView *)_moreView)  removeItematIndex: 3];

    
    //发送商品信息
    if(_kfInfo && [_kfInfo objectForKey:@"msgtype"])
    {
        NSDictionary *dic = [_kfInfo objectForKey:@"msgtype"];
        NSDictionary *msgtype = [dic mutableDeepCopy];
        dic = [_kfInfo objectForKey:@"weichat"];
        NSDictionary *weichat = [dic mutableDeepCopy];
        NSMutableDictionary *ext = [NSMutableDictionary dictionary];
        [ext setObject:msgtype forKey:@"msgtype"];
        [ext setObject:weichat forKey:@"weichat"];
        [ext setObject:@"custom" forKey:@"type"];
        [self sendTextMessage:@"图文混排信息" withExt:ext];
    }

}
#pragma override sendMessage,add ext message

-(NSDictionary *) getCustomExt
{
    return [self getExtWithWeiChat];
}

- (NSDictionary*)getExtWithWeiChat
{
    //发送商品信息
    if(_kfInfo && [_kfInfo objectForKey:@"msgtype"])
    {
        NSDictionary *dic = [_kfInfo objectForKey:@"weichat"];
        NSDictionary *weichat = [dic mutableDeepCopy];
        NSMutableDictionary *ext = [NSMutableDictionary dictionary];
        [ext setObject:weichat forKey:@"weichat"];
        
//        [ext setObject:@"custom" forKey:@"type"];
        return ext;
    }
    else
        return nil;
}


#pragma mark

- (void)commitSatisfactionWithExt:(NSDictionary*)ext messageModel:(id<IMessageModel>)model
{
    
    NSString *currentUser = [EMClient sharedClient].currentUsername;
    NSString *toUser = _customerUserId;
    EMTextMessageBody *cmdChat = [[EMTextMessageBody alloc] initWithText:@""];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:self.conversation.conversationId from:currentUser to:toUser body:cmdChat ext:@{@"weichat":ext}];
    message.chatType = EMChatTypeChat;
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *message,EMError *error)
     {
         //发送完毕后，显示评价成功，然后删除之
         if(!error)
         {
             [self.view makeToast:@"满意度评价成功"];
         }
         [self.conversation deleteMessageWithId:message.messageId];
     }
     ];
   
}



#pragma mrak - 自定义满意度评价的Cell  和  trackCell已经 OrderCell

/*!
 @method
 @brief 获取消息自定义cell
 @discussion 用户根据messageModel判断是否显示自定义cell。返回nil显示默认cell，否则显示用户自定义cell
 @param tableView 当前消息视图的tableView
 @param messageModel 消息模型
 @result 返回用户自定义cell
 */
- (UITableViewCell *)messageViewController:(UITableView *)tableView
                       cellForMessageModel:(id<IMessageModel>)messageModel
{
    if ([self isSatisfactionMessage:messageModel] )
    {
        /**
         *  satisfactionCell
         */
        EaseSatisfactionCell *cell =[tableView dequeueReusableCellWithIdentifier:[EaseSatisfactionCell cellIdentifierWithModel:messageModel]];
            
            if (!cell) {
                cell = [[EaseSatisfactionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[EaseSatisfactionCell cellIdentifierWithModel:messageModel] model:messageModel];
                cell.delegate = self;
            }
            
            cell.model = messageModel;
            
            return cell;
        
    }
    
    else if([self isTrackMessage:messageModel ])
    {
        EaseTrackCell *trackCell = [tableView dequeueReusableCellWithIdentifier:[EaseTrackCell cellIdentifierWithModel:messageModel]];
        if(!trackCell)
        {
            trackCell = [[EaseTrackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[EaseTrackCell cellIdentifierWithModel:messageModel]
                                                       model:messageModel];
        }
        trackCell.model = messageModel;
        return trackCell;
    }
    
    return nil;
}

/*!
 @method
 @brief 获取消息cell高度
 @discussion 用户根据messageModel判断，是否自定义显示cell的高度
 @param viewController 当前消息视图
 @param messageModel 消息模型
 @param cellWidth 视图宽度
 @result 返回用户自定义cell
 */

- (CGFloat) messageViewController:(EaseMessageViewController *)viewController heightForMessageModel:(id<IMessageModel>)messageModel withCellWidth:(CGFloat)cellWidth
{
  if([self isSatisfactionMessage:messageModel])
  {
      return [EaseSatisfactionCell cellHeightWithModel:messageModel];
  }
    else if ([self isTrackMessage:messageModel])
        return [EaseTrackCell cellHeightWithModel:messageModel];
    else
        return 0.f;
}

/*!
@method
@brief 选中消息的回调
@discussion 用户根据messageModel判断，是否自定义处理消息选中时间。返回YES为自定义处理，返回NO为默认处理
@param viewController 当前消息视图
@param messageModel 消息模型
@result 是否采用自定义处理
*/
- (BOOL)messageViewController:(EaseMessageViewController *)viewController
        didSelectMessageModel:(id<IMessageModel>)model
{
    
    //需要调用评价
    if([self isSatisfactionMessage: model])
    {
        //目前看来这个Enable好像没有什么用处。
//        BOOL isEnabled =([model.message.ext objectForKey:kMesssageExtWeChat])
//        && [[model.message.ext objectForKey:kMesssageExtWeChat] objectForKey:@"enable"];
//        if(isEnabled)
        {
          SatisfactionViewController *view = [[SatisfactionViewController alloc] init];
          view.messageModel = model;
          view.delegate = self;
          [self.navigationController pushViewController:view animated:YES];
        }

        return YES;
    }
    return NO;
}

//-(void) messageViewController:(EaseMessageViewController *)viewController didSelectAvatarMessageModel:(id<IMessageModel>) messageModel
//{
//    return ;
//}

-(void) messageViewController:(EaseMessageViewController *)viewController didSelectAvatarMessageModel:(id<IMessageModel>)messageModel
{
    NSLog(@"avatar selected");
}

//-(void) messageCellSelected:(id<IMessageModel>)model
//{
//    //需要调用评价
//    if([self isSatisfactionMessage: model])
//    {
//        BOOL isEnabled =([model.message.ext objectForKey:kMesssageExtWeChat])
//        && [[model.message.ext objectForKey:kMesssageExtWeChat] objectForKey:@"enable"];
//        if(isEnabled)
//        {
//            SatisfactionViewController *view = [[SatisfactionViewController alloc] init];
//            view.messageModel = model;
//            view.delegate = self;
//            [self.navigationController pushViewController:view animated:YES];
//        }
//        
//    }
//    else
//      [super messageCellSelected:model] ;
//
//}

- (BOOL)isSatisfactionMessage:(id<IMessageModel>)messageModel
{
    if(!(messageModel.message.ext))
        return NO;
        
    if (!messageModel.isSender && [messageModel.message.ext objectForKey:kMesssageExtWeChat])
    {
        NSDictionary *dic = [messageModel.message.ext objectForKey:kMesssageExtWeChat];
        if ([dic objectForKey:kMesssageExtWeChat_ctrlType] &&
            [dic objectForKey:kMesssageExtWeChat_ctrlType] != [NSNull null] &&
            [[dic objectForKey:kMesssageExtWeChat_ctrlType] isEqualToString:kMesssageExtWeChat_ctrlType_inviteEnquiry]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isTrackMessage:(id<IMessageModel>)messageModel
{
    if(!(messageModel.message.ext) )
        return NO;

    if (messageModel.isSender && [messageModel.message.ext objectForKey:kMessageExtMsgType])
    {
        NSDictionary *dic = [messageModel.message.ext objectForKey:kMessageExtMsgType];
        if ([dic objectForKey:kMessageExtMsgType_track] || [dic objectForKey:KMessageExtMsgType_order])
        {
            return YES;
        }
    }
    return NO;
}



@end
