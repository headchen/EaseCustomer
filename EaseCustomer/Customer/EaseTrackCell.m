//*****
//  EaseTrackCell.m
//  ChatDemo-UI3.0
//
//  Created by zgsoft on 16/8/22.
//  Copyright © 2016年 zgsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EaseTrackCell.h"
#import "EaseBubbleView+Track.h"
#import "UIImageView+EMWebCache.h"



@implementation EaseTrackCell : EaseBaseMessageCell

#pragma mark - IModelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(id<IMessageModel>)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier model:model];
    
    if (self) {
        self.hasRead.hidden = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (BOOL)isCustomBubbleView:(id<IMessageModel>)model
{
    return YES;
}

- (void)setCustomModel:(id<IMessageModel>)model
{
//    UIImage *image = model.image;
//    if (!image) {
//        [self.bubbleView.imageView sd_setImageWithURL:[NSURL URLWithString:model.fileURLPath] placeholderImage:[UIImage imageNamed:model.failImageName]];
//    } else {
//        _bubbleView.imageView.image = image;
//    }
    
    if (model.avatarURLPath) {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:model.avatarURLPath] placeholderImage:model.avatarImage];
    } else {
        self.avatarView.image = model.avatarImage;
    }
    
//    if([imageUrlStr length] >0)
//    {
//        //NSURL *imageURL = [NSURL URLWithString:imageUrlStr];
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrlStr]];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // Update the UI
//                _cimageView.image = [UIImage imageWithData:imageData];
//            });
//        });
//   }

}

- (void)setCustomBubbleView:(id<IMessageModel>)model
{
    [_bubbleView setupTrackBubbleView];
    
//    _bubbleView.imageView.image = [UIImage imageNamed:@"imageDownloadFail"];
}

- (void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id<IMessageModel>)model
{
    [_bubbleView updateTrackMargin:bubbleMargin];
    _bubbleView.translatesAutoresizingMaskIntoConstraints = YES;
//    _bubbleView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 273.5, 2, 213, 94);
    if (model.isSender) {
        _bubbleView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 273.5, 2, 200, 110);
        self.bubbleView.orderTitleLabel.frame = CGRectMake(6, 5, 200, 20);
        self.bubbleView.trackTitleLabel.frame = CGRectMake(6, 25, 200, 20);
        self.bubbleView.trackImage.frame = CGRectMake(6, /*CGRectGetMaxY(self.bubbleView.trackTitleLabel.frame)*/45 + 5, 56, 56);
        self.bubbleView.trackDescLabel.frame = CGRectMake(CGRectGetMaxX(self.bubbleView.trackImage.frame) + 5, CGRectGetMaxY(self.bubbleView.trackTitleLabel.frame) + 5, 120, 35);
        self.bubbleView.trackDescLabel.numberOfLines = 2;
        self.bubbleView.priceLabel.frame = CGRectMake(CGRectGetMaxX(self.bubbleView.trackImage.frame) + 5, CGRectGetMaxY(self.bubbleView.trackDescLabel.frame), 120, 15);
    }else{
        _bubbleView.frame = CGRectMake(55, 2, 213, 94);
        self.bubbleView.orderTitleLabel.frame = CGRectMake(20, 19, 26, 34);
        self.bubbleView.trackTitleLabel.frame = CGRectMake(55, 19, 156, 15);
        self.bubbleView.trackImage.frame = CGRectMake(55, 41, 49, 12);
        self.bubbleView.trackDescLabel.frame = CGRectMake(20, 73, 200, 20);
        self.bubbleView.priceLabel.frame = CGRectMake(152, 73, 80, 20);
        
    }
    
}

+ (NSString *)cellIdentifierWithModel:(id<IMessageModel>)model
{
    NSString *str= model.isSender ? @"__trackCellSendIdentifier__" : @"__trackCellReceiveIdentifier__";
    return [str stringByAppendingString:model.messageId];
}

+ (CGFloat)cellHeightWithModel:(id<IMessageModel>)model
{
    return 120;
}

- (void)setModel:(id<IMessageModel>)model
{
    [super setModel:model];
    
    NSDictionary *dic = [model.message.ext objectForKey:@"msgtype"];
    BOOL isOrder = [dic objectForKey:@"order"];
    NSDictionary *itemDic = isOrder ? [dic objectForKey:@"order"] : [dic objectForKey:@"track"];
    self.bubbleView.orderTitleLabel.text = isOrder ? [itemDic objectForKey:@"order_title"] :  @"我正在看";
    
    self.bubbleView.trackTitleLabel.text = [itemDic objectForKey:@"title"];
    self.bubbleView.trackDescLabel.text = [itemDic objectForKey:@"desc"];
    self.bubbleView.priceLabel.text = [itemDic objectForKey:@"price"];
    
    NSString *imageUrlStr = [itemDic objectForKey:@"img_url"];
    if(imageUrlStr)
        [self.bubbleView.trackImage sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"imageDownloadFail"]];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    NSString *imageName = self.model.isSender ? @"RedpacketCellResource.bundle/redpacket_sender_bg" : @"RedpacketCellResource.bundle/redpacket_receiver_bg";
//    UIImage *image = self.model.isSender ? [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:30 topCapHeight:35] :
//    [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:20 topCapHeight:35];
//    
//    self.bubbleView.backgroundImageView.image = image;
}


@end