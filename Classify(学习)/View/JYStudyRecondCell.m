//
//  JYStudyRecondCell.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/24.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYStudyRecondCell.h"

@implementation JYStudyRecondCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGBA(245, 245, 245, 1.0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    UIView * bottomView= [[UIView alloc]initWithFrame:CGRectMake(MARGIN_OX, MARGIN_OY, ScreenWidth-MARGIN_OX*2, 215)];
    bottomView.backgroundColor = WhiteBackColor;
    bottomView.layer.masksToBounds = YES;
    bottomView.layer.cornerRadius = 3.0f;
    [self.contentView addSubview:bottomView];
    
    self.teacherIcon = [[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_OX, MARGIN_OY, 20, 20)];
    self.teacherIcon.layer.masksToBounds = YES;
    self.teacherIcon.layer.cornerRadius = 10.f;
    self.teacherIcon.image = [UIImage imageNamed:@"studyteacherIcon"];
    [bottomView addSubview:self.teacherIcon];
    
    self.teacherName = [UILabel wh_labelWithText:@"欧阳老师" textFont:14 textColor:RGBA(51, 51, 51, 1.0) frame:CGRectMake(self.teacherIcon.right+MARGIN_OX, MARGIN_OY, 70, 20)];
    self.teacherName.textAlignment = NSTextAlignmentLeft;
    [bottomView addSubview:self.teacherName];
    
    UIImageView * skillImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.teacherName.right+MARGIN_OX, MARGIN_OY, 70, 20)];
  
    skillImage.image = [UIImage imageNamed:@"资深老师徽章"];
    [bottomView addSubview:skillImage];
    
    self.studyTitle = [UILabel wh_labelWithText:@"精英大学资深授课老师倾情演绎学..." textFont:16 textColor:RGBA(51, 51, 51, 1.0) frame:CGRectMake(MARGIN_OX, self.teacherIcon.bottom+16, [bottomView width]-MARGIN_OX*2, 20)];
    self.studyTitle.textAlignment = NSTextAlignmentLeft;
    self.studyTitle.font = PFBold(16);
    [bottomView addSubview:self.studyTitle];
    
    NSString * message = @"把人民群众生命安全和身体健康放在第一位。紧紧依靠人民群众坚决打赢疫情防控阻击战.";
    self.studyDec = [UILabel wh_labelWithText:message textFont:15 textColor:RGBA(102, 102, 102, 1.0) frame:CGRectMake(MARGIN_OX, self.studyTitle.bottom+16, [bottomView width]-MARGIN_OX*2, 60)];
    self.studyDec.textAlignment = NSTextAlignmentLeft;
    self.studyDec.numberOfLines = 0;
    self.studyDec.font = PFMedium(14);
    [self changeSpaceForLabel:self.studyDec withLineSpace:12 WordSpace:3];
    [bottomView addSubview:self.studyDec];
    
    self.studyTime = [UILabel wh_labelWithText:@"共120课时  共102小时23分钟" textFont:15 textColor:RGBA(153, 153, 153, 1.0) frame:CGRectMake(MARGIN_OX, self.studyDec.bottom+16, [bottomView width]-MARGIN_OX*2, 20)];
     self.studyTime.textAlignment = NSTextAlignmentLeft;
     self.studyTime.font = PFRegular(12);
     [bottomView addSubview:self.studyTime];
    
}

-(void)setCourseModel:(JYLearn_courseModel *)courseModel{
    if (_courseModel == nil) {
        _courseModel = courseModel;
    }
    
    NSString * iconUrl = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,KISDictionaryHaveKey(courseModel.teacher, @"avatar")];
    [self.teacherIcon sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"studyteacherIcon"]];
    self.teacherName.text = KISDictionaryHaveKey(courseModel.teacher, @"name");
    
    self.studyTitle.text = KISDictionaryHaveKey(courseModel.teacher, @"title");
    self.studyDec.text = courseModel.introduce;
    
    NSString * classHour = [NSString stringWithFormat:@"共%@课时 共100小时23分钟",courseModel.class_hours];
    self.studyTime.text = classHour;
    
    
}

/// 設置文字間距
- (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {

    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];

}

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space {

    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];

}


/**
 *  改变行间距和字间距
 */
- (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace {

    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
