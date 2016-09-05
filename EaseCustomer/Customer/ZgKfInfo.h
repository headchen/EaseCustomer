//
//  ZgKfInfo.h
//  ChatDemo-UI3.0
//
//  Created by zgsoft on 16/8/25.
//  Copyright © 2016年 zgsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZgKfInfo : NSObject
+ (instancetype) sharedInfo;
-(NSDictionary *) createDebugInfo;
-(NSDictionary *) createDebugInfoWithCommodity;
-(void) initEMClient : (NSDictionary*) kfInfo;
-(void) tryLogin:(NSDictionary *)kfInfo;

@end
