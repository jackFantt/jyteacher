//
//  JYMainSpecialCell.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/17.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYMainSpecialCell.h"
#import "JYbargain_videosModel.h"

@interface JYMainSpecialCell ()
{
    UIView * specicalView[3];
    UIImageView * statuImage[3];
    UILabel * statuTitle[3];
    UILabel * statuDec[3];
    UILabel * statuTime[3];
    UILabel * statuRed[3];
    UILabel * statuMarkPrice[3];
    UILabel * statuPrice[3];
    UIView * lineView[3];
}

@end

@implementation JYMainSpecialCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGBA(242, 242, 242, 1.0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(MARGIN_OX, 0, ScreenWidth-MARGIN_OX*2, 200)];
       self.bottomView.backgroundColor = WhiteBackColor;
       self.bottomView.userInteractionEnabled = YES;
       self.bottomView.masksToBounds = YES;
       self.bottomView.cornerRadius = 3.0f;
       [self.contentView addSubview:self.bottomView];
    
    UIImageView * topImage = [[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_OX, 16, [self.bottomView width]-MARGIN_OX*2, 30)];
    topImage.image = [UIImage imageNamed:@"今日特价标题栏"];
    [self.bottomView addSubview:topImage];
    
    for (int i = 0; i<3; i++) {
        specicalView[i] = [[UIView alloc]initWithFrame:CGRectMake(0, topImage.bottom+16+i*300, [self.bottomView width], 300)];
        specicalView[i].backgroundColor = WhiteBackColor;
        specicalView[i].tag = 100+i;
        specicalView[i].userInteractionEnabled = YES;
        [self.bottomView addSubview:specicalView[i]];
        
        WEAKSELF();
        [specicalView[i] wh_addTapActionWithBlock:^(UITapGestureRecognizer *gestureRecoginzer) {
            if (weakSelf.specialBlock) {
                weakSelf.specialBlock(gestureRecoginzer.view.tag - 100);
            }
            
        }];
        
        CGFloat image_oy = 12;
        if (i == 0) {
            image_oy = 0;
        }
        
        statuImage[i] = [[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_OX, image_oy, [specicalView[i] width]-MARGIN_OX*2, 183)];
        statuImage[i].layer.masksToBounds = YES;
        statuImage[i].cornerRadius = 12;
        [specicalView[i] addSubview:statuImage[i]];
        
        statuTitle[i] = [UILabel wh_labelWithText:@"【这里是视频标题】" textFont:16 textColor:RGBA(51, 51, 51, 1.0) frame:CGRectMake(MARGIN_OX, statuImage[i].bottom+MARGIN_OY, [specicalView[i] width]-MARGIN_OX*2-40, 20)];
        statuTitle[i].textAlignment = NSTextAlignmentLeft;
        statuTitle[i].font = PFMedium(16);
        [specicalView[i] addSubview:statuTitle[i]];
        
        statuTime[i] = [UILabel wh_labelWithText:@"02:42" textFont:12 textColor:RGBA(51, 51, 51, 1.0) frame:CGRectMake([specicalView[i] width]-MARGIN_OX-60, statuImage[i].bottom+MARGIN_OY, 60, 18)];
               statuTime[i].textAlignment = NSTextAlignmentLeft;
               statuTime[i].font = PFRegular(12);
        statuTime[i].backgroundColor = self.contentView.backgroundColor;
               [specicalView[i] addSubview:statuTime[i]];
        
        statuDec[i] = [UILabel wh_labelWithText:@"视频简介视频简介视频简介视频简介视频简介" textFont:14 textColor:RGBA(102, 102, 102, 1.0) frame:CGRectMake(MARGIN_OX, statuTitle[i].bottom+MARGIN_OY, [specicalView[i] width]-MARGIN_OX*2, 20)];
        statuDec[i].textAlignment = NSTextAlignmentLeft;
        statuDec[i].font = PFMedium(14);
        [specicalView[i] addSubview:statuDec[i]];
        
        UIImageView * boleftImage = [[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_OX, statuDec[i].bottom+12+3.5, 22, 13)];
           boleftImage.image = [UIImage imageNamed:@"眼睛图标"];
           [specicalView[i] addSubview:boleftImage];
        
       statuRed[i] = [UILabel wh_labelWithText:@"2387" textFont:12 textColor:RGBA(153, 153, 153, 1.0) frame:CGRectMake(boleftImage.right+5, statuDec[i].bottom+12, 80, 20)];
        statuRed[i].textAlignment = NSTextAlignmentLeft;
        statuRed[i].font = PFRegular(12);
        [specicalView[i] addSubview:statuRed[i]];
        
        statuPrice[i] = [UILabel wh_labelWithText:@"￥980.00" textFont:16 textColor:RGBA(218, 171, 119, 1.0) frame:CGRectMake([specicalView[i] width]-MARGIN_OX-80, statuDec[i].bottom+12, 80, 20)];
        statuPrice[i].textAlignment = NSTextAlignmentRight;
        statuPrice[i].font = PFBold(16);
        [specicalView[i] addSubview:statuPrice[i]];
        
        statuMarkPrice[i] = [UILabel wh_labelWithText:@"1328.99" textFont:12 textColor:RGBA(153, 153, 153, 1.0) frame:CGRectMake(statuPrice[i].mj_x-85, statuDec[i].bottom+12, 80, 20)];
        statuMarkPrice[i].textAlignment = NSTextAlignmentCenter;
        statuMarkPrice[i].font = PFRegular(12);
        [specicalView[i] addSubview:statuMarkPrice[i]];
        
        NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",statuMarkPrice[i].text]];
           [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
           statuMarkPrice[i].attributedText = newPrice;
        
            UIView * linevIew = [[UIView alloc]initWithFrame:CGRectMake(0, [specicalView[i] height]-1, ScreenWidth, 1)];
            linevIew.backgroundColor = RGBA(230, 230, 230, 1.0);
            [specicalView[i] addSubview:linevIew];
        
        lineView[i] = linevIew;
             
    }
    
//    self.specialImage = [[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_OX, 10, ScreenWidth-MARGIN_OX*2, 90)];
//    self.specialImage.backgroundColor = [UIColor grayColor];
//    [self.contentView addSubview:self.specialImage];
//    
//    self.specialTitle = [UILabel wh_labelWithText:@"这是个今日特价标题，快来听课吧 门前大桥下来了一群鸭" textFont:15 textColor:HexadecimalColor(@"333333") frame:CGRectMake(MARGIN_OX, self.specialImage.bottom+10, ScreenWidth-MARGIN_OX*2, 20)];
//    self.specialTitle.textAlignment = NSTextAlignmentLeft;
//    [self.contentView addSubview:self.specialTitle];
//    
//    self.specialDec = [UILabel wh_labelWithText:@"这是个今日特价详情介绍，课程精美老师讲解习题很到位IE，没有我们不互惠的 当时的三大收到的辅导辅导大幅度发顺丰的方式" textFont:12 textColor:HexadecimalColor(@"999999") frame:CGRectMake(MARGIN_OX, self.specialTitle.bottom+10, ScreenWidth-MARGIN_OX*2, 20)];
//    self.specialDec.textAlignment = NSTextAlignmentLeft;
//    [self.contentView addSubview:self.specialDec];
//    //yilian_seepassword
//    UIImageView * boleftImage = [[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_OX, self.specialDec.bottom+10, 20, 20)];
//    boleftImage.image = [UIImage imageNamed:@"yilian_seepassword"];
//    [self.contentView addSubview:boleftImage];
//    
//    self.specialRed = [UILabel wh_labelWithText:@"2387" textFont:15 textColor:HexadecimalColor(@"333333") frame:CGRectMake(boleftImage.right+5, self.specialDec.bottom+10, 80, 20)];
//            self.specialRed.textAlignment = NSTextAlignmentLeft;
//            [self.contentView addSubview:self.specialRed];
//    
//    self.specialPrice = [UILabel wh_labelWithText:@"￥980.00" textFont:15 textColor:RedBackColor frame:CGRectMake(ScreenWidth-MARGIN_OX-80, self.specialDec.bottom+10, 80, 20)];
//          self.specialPrice.textAlignment = NSTextAlignmentRight;
//          [self.contentView addSubview:self.specialPrice];
//    
//    self.markPrice = [UILabel wh_labelWithText:@"￥980.00" textFont:12 textColor:HexadecimalColor(@"999999") frame:CGRectMake(self.specialPrice.mj_x-80, self.specialDec.bottom+10, 80, 20)];
//    self.markPrice.textAlignment = NSTextAlignmentRight;
//    [self.contentView addSubview:self.markPrice];
//    
//    UIView * linevIew = [[UIView alloc]initWithFrame:CGRectMake(0, 199, ScreenWidth, 1)];
//    linevIew.backgroundColor = HexadecimalColor(@"#F3F3F3");
//    [self.contentView addSubview:linevIew];
    
}
-(void)setRefrshSpecialImageWithImageArr:(NSMutableArray *)imageArr{
    if (ArrayIsEmpty(imageArr)) {
        self.bottomView.hidden = YES;
    }
    self.bottomView.hidden = NO;
    for (int j = 0; j<imageArr.count; j++) {
        JYbargain_videosModel * model = imageArr[j];
        NSString * imageUrl = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,model.pathlink];
        [statuImage[j] sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"特价视频1"]];
        if (j == imageArr.count - 1) {
            lineView[j].hidden = YES;
        }
        
        statuTitle[j].text = model.name;
        statuDec[j].text = model.introduce;
        statuTime[j].text = model.duration;
        statuPrice[j].text = [NSString stringWithFormat:@"￥%@",KISDictionaryHaveKey(model.goods, @"price")];
        statuMarkPrice[j].text = [NSString stringWithFormat:@"￥%@",KISDictionaryHaveKey(model.goods, @"old_price")];
        
        
        [self.bottomView setHeight:32+30+ [specicalView[j] height]*imageArr.count];
        
    }
    
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
