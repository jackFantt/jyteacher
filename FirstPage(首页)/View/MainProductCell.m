//
//  MainProductCell.m
//  JYEducation
//
//  Created by wofuli on 2019/11/7.
//  Copyright © 2019 smart. All rights reserved.
//

#import "MainProductCell.h"

@implementation MainProductCell
-(instancetype)initWithFrame:(CGRect)frame{
    if(self ==[super initWithFrame:frame]){
        self.contentView.backgroundColor = HexadecimalColor(@"#FFFFFF");
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.borderColor = [RGBA(232, 232, 232, 1.0) CGColor];
        self.contentView.layer.borderWidth = 0.5;
        [self initviews];
    }
    return self;
}
-(void)initviews{
    //商品图片
    UIImageView * productImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [self.contentView width], 120)];
    productImage.image = [UIImage imageNamed:@"mainplace"];
    [self.contentView addSubview:productImage];
    self.productImage = productImage;
    
    //商品名称
    self.productName = [[UILabel alloc]initWithFrame:CGRectMake(8, getframeOY(productImage)+5, [self.contentView width]-16, 20)];
    self.productName.textAlignment = NSTextAlignmentLeft;
    self.productName.textColor = HexadecimalColor(@"#333333");
    self.productName.font = [UIFont regularWithSize:14];
    self.productName.text = @"少女new包包";
    [self.contentView addSubview:self.productName];
    //商品价格
    self.productPrice = [UILabel wh_labelWithText:@"￥19.00" textFont:15 textColor:HexadecimalColor(@"#32C141") frame:CGRectMake(8, getframeOY(self.productName)+5, 100, 20)];
    self.productPrice.textAlignment = NSTextAlignmentLeft;
    self.productPrice.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    self.productPrice.text = @"¥88.80";
    [self.contentView addSubview:self.productPrice];
    
    
    //市场
    self.market_price = [UILabel wh_labelWithText:@"￥19.00" textFont:15 textColor:HexadecimalColor(@"#32C141") frame:CGRectMake([self.contentView width]-75, getframeOY(self.productName)+5, 70, 20)];
    self.market_price.textAlignment = NSTextAlignmentLeft;
    self.market_price.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    self.market_price.text = @"¥198.80";
    [self.contentView addSubview:self.market_price];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, [self.market_price width]-25, 1)];
    lineView.backgroundColor = HexadecimalColor(@"#32C141");
    [self.market_price addSubview:lineView];
}

@end
