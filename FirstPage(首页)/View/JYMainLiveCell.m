//
//  JYMainLiveCell.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/17.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYMainLiveCell.h"

@interface JYMainLiveCell ()
{
    UIImageView * liveImgae[3];
}

@end

@implementation JYMainLiveCell

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
    
    self.leftLabel = [UILabel wh_labelWithText:@"精英直播" textFont:18 textColor:RGBA(51, 51, 51, 1.0) frame:CGRectMake(MARGIN_OX, 16, 150, 20)];
    self.leftLabel.font = PFBold(20);
    self.leftLabel.textAlignment = NSTextAlignmentLeft;
    [self.bottomView addSubview:self.leftLabel];
    
    //默认展示2个
    for (int i = 0; i<3; i++) {
        liveImgae[i] = [[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_OX, self.leftLabel.bottom+16+i*(142+12), [self.bottomView width]-MARGIN_OX*2, 142)];
        liveImgae[i].layer.cornerRadius = 12;
        [self.bottomView addSubview:liveImgae[i]];
        liveImgae[i].userInteractionEnabled = YES;
        liveImgae[i].tag = 10+i;
        
        UITapGestureRecognizer * imagetap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
        [liveImgae[i] addGestureRecognizer:imagetap];
       
    }
    
    self.moreBtn = [UIButton wh_buttonWithTitle:@"更多 >" backColor:RGBA(168, 133, 154, 1.0) backImageName:@"" titleColor:WhiteTextColor fontSize:14 frame:CGRectMake([self.bottomView width]-MARGIN_OX-60, 13.5, 60, 25) cornerRadius:12.5];
    [self.bottomView addSubview:self.moreBtn];
    
//    self.rightLabel = [UILabel wh_labelWithText:@"直播中..." textFont:13 textColor:HexadecimalColor(@"333333") frame:CGRectMake(ScreenWidth-MARGIN_OX-60, 10, 60, 20)];
//    self.rightLabel.textAlignment = NSTextAlignmentRight;
//    [self.contentView addSubview:self.rightLabel];
    
//    UIImageView * toprightImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.rightLabel.mj_x-30, 10, 30, 20)];
//    toprightImage.backgroundColor = [UIColor blueColor];
//    [self.contentView addSubview:toprightImage];
//
//    self.liveImage = [[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_OX, self.leftLabel.bottom+10, ScreenWidth-MARGIN_OX*2, 90)];
//    self.liveImage.backgroundColor = [UIColor grayColor];
//    [self.contentView addSubview:self.liveImage];
//
//    UIImageView * boleftImage = [[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_OX, self.liveImage.bottom+10, 30, 20)];
//    boleftImage.backgroundColor = [UIColor blueColor];
//    [self.contentView addSubview:boleftImage];
//
//    self.liveTitle = [UILabel wh_labelWithText:@"这是个直播标题" textFont:15 textColor:HexadecimalColor(@"333333") frame:CGRectMake(boleftImage.right+5, self.liveImage.bottom+10, 150, 20)];
//    self.liveTitle.textAlignment = NSTextAlignmentLeft;
//    [self.contentView addSubview:self.liveTitle];
//
//    self.livePrice = [UILabel wh_labelWithText:@"￥300.00" textFont:13 textColor:HexadecimalColor(@"999999") frame:CGRectMake(ScreenWidth-MARGIN_OX-100, self.liveImage.bottom+10, 100, 20)];
//       self.livePrice.textAlignment = NSTextAlignmentRight;
//       [self.contentView addSubview:self.livePrice];
//
//    UIView * linevIew = [[UIView alloc]initWithFrame:CGRectMake(0, 169, ScreenWidth, 1)];
//    linevIew.backgroundColor = HexadecimalColor(@"#F3F3F3");
//    [self.contentView addSubview:linevIew];
    
}
-(void)imageClick:(UITapGestureRecognizer *)tap{
    if (self.liveBlock) {
        self.liveBlock(tap.view.tag - 10);
    }
    
}

-(void)setRefrshLiveImageWithImageArr:(NSMutableArray *)imageArr{
    if (ArrayIsEmpty(imageArr)) {
        self.bottomView.hidden = YES;
    }
    self.bottomView.hidden = NO;
    for (int j = 0; j<imageArr.count; j++) {
        liveImgae[j].image = [UIImage imageNamed:imageArr[j]];
        
        [self.bottomView setHeight:liveImgae[j].bottom + 16];
    }
    if (imageArr.count<3) {
        self.moreBtn.hidden = YES;
    }else{
        self.moreBtn.hidden = NO;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
