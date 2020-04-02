//
//  JYLearnCenterCell.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/18.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYLearnCenterCell.h"

@implementation JYLearnCenterCell

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
    //macollectionSelected
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(MARGIN_OX, 10, ScreenWidth-MARGIN_OX*2, 180)];
    bottomView.layer.masksToBounds = YES;
    bottomView.layer.cornerRadius = 3.0f;
    bottomView.layer.borderColor = [HexadecimalColor(@"#F3F3F3") CGColor];
    bottomView.layer.borderWidth = 1.0f;
    [self.contentView addSubview:bottomView];
    
     self.teacherIcon = [[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_OX, 15, 35, 35)];
            self.teacherIcon.backgroundColor = RGBA(2, 60, 245, 1.0);
            self.teacherIcon.userInteractionEnabled = YES;
            self.teacherIcon.layer.masksToBounds = YES;
            self.teacherIcon.layer.cornerRadius = 17.5f;
            [bottomView addSubview:self.teacherIcon];
    
    self.teacherName = [UILabel wh_labelWithText:@"欧阳老师" textFont:15 textColor:HexadecimalColor(@"333333") frame:CGRectMake(self.teacherIcon.right+10, self.teacherIcon.centerY-10, 70, 20)];
    self.teacherName.textAlignment = NSTextAlignmentLeft;
    [bottomView addSubview:self.teacherName];
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(self.teacherName.right+5, self.teacherIcon.centerY-12.5, 100, 25)];
    bgView.backgroundColor = RGBA(122, 95, 246, 1.0);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 12.5;
    [bottomView addSubview:bgView];
    
    self.skillIcon = [[UIImageView alloc]initWithFrame:CGRectMake(3, 0, 25, 25)];
    self.skillIcon.image = [UIImage imageNamed:@"macollectionSelected"];
    [bgView addSubview:self.skillIcon];
    
    self.skillName = [UILabel wh_labelWithText:@"资深教师" textFont:15 textColor:HexadecimalColor(@"ffffff") frame:CGRectMake(self.skillIcon.right+5, 2.5, 80, 20)];
    self.skillName.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:self.skillName];
    
    NSString * message = @"“把人民群众生命安全和身体健康放在第一位。”“紧紧依靠人民群众坚决打赢疫情防控阻击战。”“确保人民群众生命安全和身体健康，是我们党治国理政的一项重大任务。”“没有任何力量能够阻挡中国人民和中华民族的前进步伐。”这是人民至上的坚定宣示。";
    self.decMessage = [UILabel wh_labelWithText:message textFont:15 textColor:HexadecimalColor(@"333333") frame:CGRectMake(MARGIN_OX, self.teacherIcon.bottom+10, [bottomView width]-MARGIN_OX*2, 80)];
    self.decMessage.textAlignment = NSTextAlignmentLeft;
    self.decMessage.numberOfLines = 0;
    [bottomView addSubview:self.decMessage];
    
    self.timeMessage = [UILabel wh_labelWithText:@"共120课时  共102小时23分钟" textFont:15 textColor:HexadecimalColor(@"333333") frame:CGRectMake(MARGIN_OX, [bottomView height]-30, [bottomView width]-MARGIN_OX*2, 20)];
    self.timeMessage.textAlignment = NSTextAlignmentLeft;
   
    [bottomView addSubview:self.timeMessage];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
