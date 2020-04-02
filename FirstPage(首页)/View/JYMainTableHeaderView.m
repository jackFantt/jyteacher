//
//  JYMainTableHeaderView.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/17.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYMainTableHeaderView.h"
#import "SDCycleScrollView.h"
#import "MaLunBoModel.h"
@interface JYMainTableHeaderView ()<SDCycleScrollViewDelegate>
{
    UIButton * JYtopBtn[8];
}

@property (nonatomic,strong)SDCycleScrollView * cyScrollView;
@property (nonatomic,copy) NSArray * topBtnArray;
@property (nonatomic,copy) NSArray * secondBtnArray;

@end

@implementation JYMainTableHeaderView

-(instancetype)initWithJYheaderView{
    
    self = [self initWithFrame:CGRectMake(0, 0, ScreenWidth, 574)];
    if (self) {
        [self createUI];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = WhiteBackColor;
    }
    return self;
}

-(void)createUI{
    WEAKSELF();
    //搜索区域
        UIView * searchView = [[UIView alloc]initWithFrame:CGRectMake(MARGIN_OX, 8, ScreenWidth-MARGIN_OX*2, 40)];
        searchView.backgroundColor = RGBA(245, 245, 245, 1.0);
        [self addSubview:searchView];
        searchView.layer.masksToBounds = YES;
        searchView.layer.cornerRadius = 20.0f;
        searchView.layer.borderColor = [RGBA(245, 245, 245, 1.0) CGColor];
//        searchView.layer.borderWidth = 1.0f;
        
        UIImageView * searchImage = [[UIImageView alloc]initWithFrame:CGRectMake(18, 12.5, 15, 15)];
        searchImage.image = [UIImage imageNamed:@"hometopsearch"];
        [searchView addSubview:searchImage];
        
        
        UILabel * searLabel = [UILabel wh_labelWithText:@"搜索课程名称" textFont:13 textColor:RGBA(153, 153, 153, 1.0) frame:CGRectMake(getframeOX(searchImage)+8, 0, 100, 40)];
    searLabel.font = PFMedium(14);
        searLabel.textAlignment = NSTextAlignmentLeft;
        [searchView addSubview:searLabel];
        
        [searchView wh_addTapActionWithBlock:^(UITapGestureRecognizer *gestureRecoginzer) {
            if (weakSelf.searchBlock) {
                weakSelf.searchBlock();
            }
        }];
    
    self.cyScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, searchView.bottom+10,ScreenWidth, 168) delegate:self placeholderImage:[UIImage imageNamed:@"bannertwo"]];
           self.cyScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
//           self.cyScrollView.layer.masksToBounds = YES;
//           self.cyScrollView.layer.borderColor = [WhiteBackColor CGColor];
//           self.cyScrollView.layer.cornerRadius = 2.0;
           [self addSubview:self.cyScrollView];
    
    UIView * bottomView  = [[UIView alloc]initWithFrame:CGRectMake(0, self.cyScrollView.bottom, ScreenWidth, 130)];
    bottomView.userInteractionEnabled = YES;
    bottomView.backgroundColor = RGBA(242, 242, 242, 1.0);
    [self addSubview:bottomView];
    UIView * btnView = [[UIView alloc]initWithFrame:CGRectMake(MARGIN_OX, 12, [bottomView width]-MARGIN_OX*2, 184)];
    btnView.backgroundColor = WhiteBackColor;
    btnView.layer.masksToBounds = YES;
    btnView.layer.cornerRadius = 3.0f;
    [bottomView addSubview:btnView];
        CGFloat btnWidth = 40;
         CGFloat btnHigh = 40;
         CGFloat btnjiange = ([btnView width]-btnWidth*4 -24*2)/3;
        for (int i = 0; i<self.topBtnArray.count; i++) {
                JYtopBtn[i] = [UIButton buttonWithType:UIButtonTypeCustom];
                JYtopBtn[i].frame = CGRectMake(24+i%4*(btnWidth+btnjiange),16+i/4*(btnHigh+8+20+16), btnWidth, btnHigh);
         
                [JYtopBtn[i] setImage:[UIImage imageNamed:self.topBtnArray[i]] forState:UIControlStateNormal];
                JYtopBtn[i].tag = 10+i;
            
                [JYtopBtn[i] addTarget:self action:@selector(jybuttonClickk:) forControlEvents:UIControlEventTouchUpInside];
                
                [btnView addSubview:JYtopBtn[i]];
                
                UILabel * tittleLabel = [UILabel wh_labelWithText:self.topBtnArray[i] textFont:12 textColor:RGBA(51, 51, 51, 1.0) frame:CGRectMake(getframeOX(JYtopBtn[i])-btnWidth-40, getframeOY(JYtopBtn[i])+8, btnWidth+80, 20)];
            tittleLabel.font = PFMedium(12);
                [btnView addSubview:tittleLabel];
            }
    
    
      UIView * actionView = [[UIView alloc]initWithFrame:CGRectMake(MARGIN_OX, btnView.bottom+12, [bottomView width]-MARGIN_OX*2, 128)];
      actionView.backgroundColor = WhiteBackColor;
      actionView.layer.masksToBounds = YES;
      actionView.layer.cornerRadius = 3.0f;
      [bottomView addSubview:actionView];
    [bottomView setHeight:actionView.bottom+12];
    
    
    CGFloat btnWidth_action = 101;
    CGFloat btnHigh_action = 40;
    CGFloat btnjiange_action = ([actionView width]-btnWidth_action*3 -12*2)/2;
    for (int j = 0; j<self.secondBtnArray.count; j++) {
         UIButton * button= [UIButton buttonWithType:UIButtonTypeCustom];
                       button.frame = CGRectMake(12+j%3*(btnWidth_action+btnjiange_action),16+j/3*(btnHigh_action+16), btnWidth_action, btnHigh_action);
                
                       [button setImage:[UIImage imageNamed:self.secondBtnArray[j]] forState:UIControlStateNormal];
                       button.tag = 18+j;
                   
                       [button addTarget:self action:@selector(jybuttonClickk:) forControlEvents:UIControlEventTouchUpInside];
                       
                       [actionView addSubview:button];
    }
    
}
-(void)refrshJYHeaderBanner:(NSMutableArray *)banner{
   
    NSMutableArray * UrlImageArray = [NSMutableArray new];
    for (int i = 0; i<banner.count; i++) {
        MaLunBoModel * banModel = banner[i];
        NSString * imageStr = banModel.ad_link;
        [UrlImageArray addObject:imageStr];
    }
    
    self.cyScrollView.imageURLStringsGroup = UrlImageArray;
    
}
-(void)jybuttonClickk:(UIButton *)btn{
    NSLog(@">>btn.tag===%ld",btn.tag);
    if (self.sectionBlock) {
        self.sectionBlock(btn.tag);
    }
}

#pragma mark--轮播图代理
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    NSLog(@">>>%ld",index);
}

#pragma mark--LZ
-(NSArray *)topBtnArray{
    if (_topBtnArray == nil) {
        _topBtnArray = @[@"专升本",@"成人高考",@"专本连读",@"教师资格证",
                         @"人力资源",@"职业技能",@"会计",@"其他资格证"];
    }
    return _topBtnArray;
}
-(NSArray *)secondBtnArray{
    if (_secondBtnArray == nil) {
           _secondBtnArray = @[@"直播回放",@"新课上线",@"每日优惠",@"智能练习",
                            @"模拟考试",@"考前押密"];
       }
       return _secondBtnArray;
}

@end
