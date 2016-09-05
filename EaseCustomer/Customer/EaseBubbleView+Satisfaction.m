//
//  EaseBubbleView+Satisfaction.m
//  ChatDemo-UI3.0
//
//  Created by zgsoft on 16/8/23.
//  Copyright © 2016年 zgsoft. All rights reserved.
//

#import "EaseBubbleView+Satisfaction.h"
#import <objc/runtime.h>

@implementation EaseBubbleView (Satisfaction)

static char _satisfactionlabel_;
//static char _idMessage_;

-(UILabel *) satisfactionLabel
{
    return objc_getAssociatedObject(self, &_satisfactionlabel_);
}

-(void) setSatisfactionLabel:(UILabel *)satisfactionLabel
{
    objc_setAssociatedObject(self, &_satisfactionlabel_, satisfactionLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
 

//-(id<IMessageModel>) messageModel
//{
//    return objc_getAssociatedObject(self, &_idMessage_);
//}
//
//-(void) setMessageModel:(id<IMessageModel>)messageModel
//{
//    objc_setAssociatedObject(self, &_idMessage_, messageModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

#pragma mark - private

- (void)_setupSatisfactionBubbleMarginConstraints
{
    NSLayoutConstraint *marginTopConstraint = [NSLayoutConstraint constraintWithItem:self.satisfactionLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.margin.top];
    NSLayoutConstraint *marginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.satisfactionLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant: -self.margin.bottom];
    NSLayoutConstraint *marginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.satisfactionLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
    //    NSLayoutConstraint *marginRightConstraint = [NSLayoutConstraint constraintWithItem:self.satisfactionLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
    
    [self.marginConstraints removeAllObjects];
    [self.marginConstraints addObject:marginTopConstraint];
    [self.marginConstraints addObject:marginBottomConstraint];
    [self.marginConstraints addObject:marginLeftConstraint];
    //    [self.marginConstraints addObject:marginRightConstraint];
    
    [self addConstraints:self.marginConstraints];
}



#pragma mark - public

- (void)setupSatisfactionBubbleView
{
    self.satisfactionLabel = [[UILabel alloc] init];
    self.satisfactionLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.satisfactionLabel.backgroundColor = [UIColor redColor];
    self.satisfactionLabel.numberOfLines = 1;
    self.satisfactionLabel.font =[UIFont systemFontOfSize:14.0f];
    self.satisfactionLabel.textColor = [UIColor whiteColor];
    self.satisfactionLabel.text = @"请对我的服务作出评价";
    
    
//    self.satisfactionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.satisfactionBtn.userInteractionEnabled = YES;
//    [self.satisfactionBtn setTitle:@"请对我的服务作出评价" forState:UIControlStateNormal];
//    [self.satisfactionBtn setTitle:@"您已经作过评价" forState:UIControlStateSelected];
//    self.satisfactionBtn.backgroundColor = [UIColor lightGrayColor];
//    self.satisfactionBtn.layer.cornerRadius = 5.f;
//    [self.satisfactionBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
//    [self.satisfactionBtn addTarget:self action:@selector(satisfactionAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.satisfactionBtn];
    [self.backgroundImageView addSubview:self.satisfactionLabel];
    
   // [self _setupSatisfactionBubbleMarginConstraints];
}

#pragma mark - action
//- (void)satisfactionAction:(id)sender
//{
//    [self routerEventWithName:kRouterEventSatisfactionBubbleTapEventName
//                     userInfo:@{@"message":self.messageModel }];
//}

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    //[[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}

- (void)updateSatisfactionMargin:(UIEdgeInsets)margin
{
    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    _margin = margin;
    
    [self removeConstraints:self.marginConstraints];
    [self _setupSatisfactionBubbleMarginConstraints];
}



@end
