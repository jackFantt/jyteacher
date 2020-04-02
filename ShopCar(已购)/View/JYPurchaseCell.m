//
//  JYPurchaseCell.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/17.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYPurchaseCell.h"

@implementation JYPurchaseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = WhiteBackColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}
-(void)createUI{
    self.goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_OX, 16, 153, 96)];
    self.goodsImage.backgroundColor = RGBA(119, 156, 247, 1.0);
    self.goodsImage.layer.masksToBounds = YES;
    self.goodsImage.layer.cornerRadius = 12;
    self.goodsImage.image = [UIImage imageNamed:@"课程封面"];
    [self.contentView addSubview:self.goodsImage];
    
    
       self.purchaseTitle = [UILabel wh_labelWithText:@"这是个课程推荐标题" textFont:16 textColor:RGBA(51, 51, 51, 1.0) frame:CGRectMake(self.goodsImage.right+MARGIN_OX, 16, ScreenWidth-MARGIN_OX-self.goodsImage.right-MARGIN_OX, 16)];
       self.purchaseTitle.textAlignment = NSTextAlignmentLeft;
      self.purchaseTitle.font = PFBold(16);
       [self.contentView addSubview:self.purchaseTitle];
    
    self.purchaseDec = [UILabel wh_labelWithText:@"精英大学资深授课老师倾情演绎..." textFont:14 textColor:RGBA(102, 102, 102, 1.0) frame:CGRectMake(self.goodsImage.right+MARGIN_OX, self.purchaseTitle.bottom+12, ScreenWidth-MARGIN_OX-self.goodsImage.right-MARGIN_OX, 14)];
     self.purchaseDec.textAlignment = NSTextAlignmentLeft;
    self.purchaseDec.font = PFRegular(14);
     [self.contentView addSubview:self.purchaseDec];
    
    self.purchaseTeacher = [UILabel wh_labelWithText:@"张老师" textFont:13 textColor:RGBA(153, 153, 153, 1.0) frame:CGRectMake(self.goodsImage.right+10, self.purchaseDec.bottom+12, 70, 13)];
       self.purchaseTeacher.textAlignment = NSTextAlignmentLeft;
    self.purchaseTeacher.font = PFRegular(13);
    [self.contentView addSubview:self.purchaseTeacher];
       
       self.purchaseSkill = [UILabel wh_labelWithText:@"精英资深老师" textFont:13 textColor:RGBA(153, 153, 153, 1.0) frame:CGRectMake(self.purchaseTeacher.right+12, self.purchaseDec.bottom+12, ScreenWidth-self.purchaseTeacher.right-12-MARGIN_OX, 13)];
       self.purchaseSkill.font = PFRegular(13);
    self.purchaseSkill.textAlignment = NSTextAlignmentLeft;
       [self.contentView addSubview:self.purchaseSkill];
    
    self.purchaseTime = [UILabel wh_labelWithText:@"下单时间：2019-03-16 12:15" textFont:13 textColor:RGBA(153, 153, 153, 1.0) frame:CGRectMake(self.goodsImage.right+12, self.purchaseTeacher.bottom +12, ScreenWidth-self.goodsImage.right-12-MARGIN_OX, 13)];
    self.purchaseTime.textAlignment = NSTextAlignmentLeft;
    self.purchaseTime.font = PFMedium(13);
    [self.contentView addSubview:self.purchaseTime];
    
    
    UIView * linevIew = [[UIView alloc]initWithFrame:CGRectMake(0, self.goodsImage.bottom+15, ScreenWidth, 1)];
    linevIew.backgroundColor = RGBA(230, 230, 230, 1.0);
    [self.contentView addSubview:linevIew];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
