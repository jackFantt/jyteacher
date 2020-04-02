//
//  JYClassPayMentCell.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/26.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYClassPayMentCell.h"

@implementation JYClassPayMentCell

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
    
    self.iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_OX, 18, 20, 20)];
    [self.contentView addSubview:self.iconImage];
    
    self.paymentTitle = [UILabel wh_labelWithText:@"" textFont:14 textColor:RGBA(102, 102, 102, 1.0) frame:CGRectMake(self.iconImage.right+MARGIN_OX, 18, 200, 20)];
    self.paymentTitle.textAlignment = NSTextAlignmentLeft;
    self.paymentTitle.font = [UIFont mediumWithSize:14];
    [self.contentView addSubview:self.paymentTitle];
    
    UIView * linevIew = [[UIView alloc]initWithFrame:CGRectMake(0, 55, ScreenWidth, 1)];
    linevIew.backgroundColor = RGBA(230, 230, 230, 1.0);
    [self.contentView addSubview:linevIew];
    
    self.payImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-MARGIN_OX-20, 18, 20, 20)];
    self.payImage.image = [UIImage imageNamed:@"payuncheck"];
    [self.contentView addSubview:self.payImage];
}

-(void)setIsCheck:(BOOL)isCheck{
    _isCheck = isCheck;
    if (isCheck) {
        self.payImage.image = [UIImage imageNamed:@"payischeck"];
    }else{
        self.payImage.image = [UIImage imageNamed:@"payuncheck"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
