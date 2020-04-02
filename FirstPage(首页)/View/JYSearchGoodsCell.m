//
//  JYSearchGoodsCell.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/16.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYSearchGoodsCell.h"

@implementation JYSearchGoodsCell

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
    self.labelTitle = [UILabel wh_labelWithText:@"" textFont:15 textColor:HexadecimalColor(@"333333") frame:CGRectMake(MARGIN_OX, 12, ScreenWidth-MARGIN_OX*2, 20)];
    self.labelTitle.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.labelTitle];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
