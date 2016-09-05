# EaseCustomer
## 注意 
此集成项目为EasemobIOS 3.15
EaseCustomer/HyphenateFullSDK/lib/libHyphenateFullSDK.a 从官网下载3.15版本，拷贝到此路径下即可
  
## 对原文件修改的地方：  

```objectivec  
1. EaseMessageViewController.h 
  //added by headchen for customer
-(NSDictionary *) getCustomExt;

```

2. EaseMessageViewController.m  
``` objectivec
#pragma mark - added by headchen
-(NSDictionary *) getCustomExt
{
    return nil;
}

```

目的：为了能够在以后每次发送消息时加上ext也就是发送顾客visitor的信息。

3. ChatViewController.m  

``` objectivec   

- (void)backAction
{
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].roomManager removeDelegate:self];
    [[ChatDemoHelper shareHelper] setChatVC:nil];
    
    if (self.deleteConversationIfNull) {
        //判断当前会话是否为空，若符合则删除该会话
        EMMessage *message = [self.conversation latestMessage];
        if (message == nil) {
            [[EMClient sharedClient].chatManager deleteConversation:self.conversation.conversationId isDeleteMessages:NO completion:nil];
        }
    }
    
    //modified by headchen for cordova
    if(self.navigationController.viewControllers.count ==1 )
        [self dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController popViewControllerAnimated:YES];
}


```

修改的目的时为了能够在cordova环境下下当用presentViewController 调用时，点击back也能够正确返回。具体请看TestEaseCustomerViewController.m中的调用示范

## 新增文件   
新增文件均在EaseCustomer/Customer 路径下。
