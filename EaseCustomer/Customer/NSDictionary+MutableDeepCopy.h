//
//  NSDictionary+MutableDeepCopy.h
//  ChatDemo-UI3.0
//
//  Created by zgsoft on 16/8/24.
//  Copyright © 2016年 zgsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MutableDeepCopying <NSObject>
-(id) mutableDeepCopy;
@end

@interface NSDictionary (MutableDeepCopy) <MutableDeepCopying>
@end


