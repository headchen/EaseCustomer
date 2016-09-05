//
//  ZgKfInfo.m
//  ChatDemo-UI3.0
//
//  Created by zgsoft on 16/8/25.
//  Copyright © 2016年 zgsoft. All rights reserved.
//

#import "ZgKfInfo.h"
#import "chatDemoHelper.h"

static ZgKfInfo *singleInfo=nil;

@implementation ZgKfInfo

  BOOL isinit=NO;

#pragma mark - app delegate notifications

- (void)_setupAppDelegateNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundNotif:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)appDidEnterBackgroundNotif:(NSNotification*)notif
{
    [[EMClient sharedClient] applicationDidEnterBackground:notif.object];
}

- (void)appWillEnterForeground:(NSNotification*)notif
{
    [[EMClient sharedClient] applicationWillEnterForeground:notif.object];
}

  + (instancetype) sharedInfo
{
    if(!singleInfo)
    {
        singleInfo = [[ZgKfInfo alloc]init];
    }
    return singleInfo;
}

-(void)initEMClient:(NSDictionary *)kfInfo
{
    if(isinit)
        return;
    
    NSString *appkey = [kfInfo objectForKey:@"appkey"];
    
    [self _setupAppDelegateNotifications];
    EMOptions *options = [EMOptions optionsWithAppkey:appkey];
    options.isAutoLogin=false;
    EMError *error= [[EMClient sharedClient] initializeSDKWithOptions:options];
    if(error)
      NSLog(@"easemob init error:%@",error. errorDescription);
    
        [ChatDemoHelper shareHelper];

    isinit = YES;
}

-(void) tryLogin:(NSDictionary *)kfInfo
{
    NSDictionary *dic = [kfInfo objectForKey:@"user"];
    NSString *userId=[dic objectForKey:@"userId"];
    NSString *password = [dic objectForKey:@"password"];
    
    //自动登录
    if(![EMClient sharedClient].isLoggedIn )
    {
        EMError *error= [[EMClient sharedClient] loginWithUsername:userId password:password];
        if(error)
            NSLog(@"easemob login error:%@",error.errorDescription);
    }
    else if (![[EMClient sharedClient].currentUsername isEqualToString:userId])
    {
        [[EMClient sharedClient] logout:NO];
        [[EMClient sharedClient] loginWithUsername:userId password:password];
        
    }
 
}

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

-(NSDictionary *) createDebugInfo
{
    NSDictionary *info = [[NSMutableDictionary alloc]init];
    
    [info setValue:@"zgsoft#ygyjs" forKey:@"appkey"];
    [info setValue:@"headchen" forKey:@"extraUserId"];
    NSDictionary *weichat = [[NSMutableDictionary alloc] init];
    NSDictionary *visitor = [[NSMutableDictionary alloc] init];
    NSDictionary *user = [[NSMutableDictionary alloc] init];
    
    [info setValue:user forKey:@"user"];
    [user setValue:@"minnie" forKey:@"userId"];
    [user setValue:@"123456" forKey:@"password"];
    
    [info setValue:weichat forKey:@"weichat"];
    [weichat setValue:@"shouqian" forKey:@"queueName"];
    [weichat setValue:visitor forKey:@"visitor"];
    
    [visitor setValue:@"headchen" forKey:@"trueName"];
    [visitor setValue:@"171577840" forKey:@"qq"];
    [visitor setValue:@"中港软件" forKey:@"companyName"];
    [visitor setValue:@"chenfazong" forKey:@"userNickname"];
    [visitor setValue:@"tel:31500759903; cardNo:8888888" forKey:@"description"];
    [visitor setValue:@"123@qq.com" forKey:@"email"];
    
    
    
    return info;
}

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


-(NSDictionary *)createDebugInfoWithCommodity
{
    NSDictionary *info = [self createDebugInfo];
    NSDictionary *msgType = [[NSMutableDictionary alloc]init];
    NSDictionary *track = [[NSMutableDictionary alloc]init];
    
    [info setValue:msgType forKeyPath:@"msgtype"];
    [msgType setValue:track forKey:@"track"];
    
    [track setValue:@"商品编号：110100098" forKey:@"title"];
    [track setValue:@"¥ 15.23" forKey:@"price"];
    [track setValue:@"女装小香风气质蕾丝假两件短袖" forKey:@"desc"];
    [track setValue:@"http://tools.melove.net/test/image/shop_01.png" forKey:@"img_url"];

    return info;
    
}

@end
