//
//  JYLearnCenterVC.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/18.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYLearnCenterVC.h"
#import "JYLearnCenterCell.h"
#import "JYStudyRecondCell.h"
#import "JYMylearnRecordModel.h"
#import "JYLearn_courseModel.h"

static NSString * const reuseInderfer = @"JYStudyRecondCell";

@interface JYLearnCenterVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel * learnStatu[3];
}
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UIView * nodataView;//无数据
@property (nonatomic,strong) UIView * headerView;
@property (nonatomic,strong) UIImageView * userIcon;
@property (nonatomic,strong) UILabel * userName;
@property (nonatomic,strong) UILabel * userPhone;
@property (nonatomic,strong) UILabel * totolLabel;
@property (nonatomic,copy) NSArray * statuArr;
@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,strong) JYMylearnRecordModel * learnModel;

@property (nonatomic,copy) NSString * totalminue; //总共学习时间
@property (nonatomic,copy) NSString * todayminue; //今日学习时间
@property (nonatomic,copy) NSString * continueminue; //连续学习时间
@property (nonatomic,copy) NSString * finshclass; //完成课程

 /*
 * 当前第几页:从1开始
 */
@property (nonatomic,assign) NSInteger pageIndex;
@end

@implementation JYLearnCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageIndex =1;
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.nodataView];
    [self.view addSubview:self.tableView];
    
    
}
-(void)refrshLearnData{
    
    NSString * maxlearn = [NSString stringWithFormat:@"累计学习 %@ 分钟",self.totalminue];//@"累计学习 120 分钟";
    NSMutableAttributedString * attributeStr_maxlearn = [[NSMutableAttributedString alloc]initWithString:maxlearn];
    [attributeStr_maxlearn addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:20] range:[[attributeStr_maxlearn string]rangeOfString:self.totalminue]];
    
    [attributeStr_maxlearn addAttribute:NSForegroundColorAttributeName value:WhiteTextColor range:[[attributeStr_maxlearn string]rangeOfString:self.totalminue]];
    
    self.totolLabel.attributedText = attributeStr_maxlearn;
    
    NSString * todayTime = [NSString stringWithFormat:@"%@ 分钟",self.todayminue];
           NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc]initWithString:todayTime];
           [attributeStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:20] range:[[attributeStr string]rangeOfString:self.todayminue]];
           
           [attributeStr addAttribute:NSForegroundColorAttributeName value:RGBA(51, 51, 51, 1.0) range:[[attributeStr string]rangeOfString:self.todayminue]];
    learnStatu[0].attributedText = attributeStr;
    
    NSString * continueTime = [NSString stringWithFormat:@"%@ 天",self.continueminue];
              NSMutableAttributedString * attributeStr_continueTime = [[NSMutableAttributedString alloc]initWithString:continueTime];
              [attributeStr_continueTime addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:20] range:[[attributeStr_continueTime string]rangeOfString:self.continueminue]];
              
              [attributeStr_continueTime addAttribute:NSForegroundColorAttributeName value:RGBA(51, 51, 51, 1.0) range:[[attributeStr_continueTime string]rangeOfString:self.continueminue]];
       learnStatu[1].attributedText = attributeStr_continueTime;
    
    NSString * finshClass = [NSString stringWithFormat:@"%@ 节",self.finshclass];
                 NSMutableAttributedString * attributeStr_finshClass = [[NSMutableAttributedString alloc]initWithString:finshClass];
                 [attributeStr_finshClass addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:20] range:[[attributeStr_finshClass string]rangeOfString:self.finshclass]];
                 
                 [attributeStr_finshClass addAttribute:NSForegroundColorAttributeName value:RGBA(51, 51, 51, 1.0) range:[[attributeStr_finshClass string]rangeOfString:self.finshclass]];
          learnStatu[2].attributedText = attributeStr_finshClass;
    
}

-(void)refrshdata:(NSInteger )pageIndex isDown:(BOOL)isDown{
    WEAKSELF();
    NSDictionary * param = @{
                                @"page":[NSNumber numberWithInteger:pageIndex]
                            };
    [AFHttpOperation postRequestWithURL:KAPIJYEducationmylearnrecord parameters:param viewController:self success:^(id  _Nonnull responseObject) {
        
        if ([responseObject[@"code"] integerValue] == RESPONSE_CODE_SUCCESS) {
                     NSDictionary * resultDic = kParseData(responseObject);
                     if (resultDic == nil) {
                          [weakSelf.tableView.header endRefreshing];
                         [weakSelf.tableView.footer endRefreshing];
                         return ;
                     }
            
            //顶部数据刷新
            weakSelf.totalminue = [NSString stringWithFormat:@"%@",KISDictionaryHaveKey(resultDic[@"record"], @"total_learn_minute")];
            weakSelf.todayminue = [NSString stringWithFormat:@"%@",KISDictionaryHaveKey(resultDic[@"record"], @"today_learn_minute")];
            weakSelf.continueminue = [NSString stringWithFormat:@"%@",KISDictionaryHaveKey(resultDic[@"record"], @"continue_days")];
            weakSelf.finshclass = [NSString stringWithFormat:@"%@",KISDictionaryHaveKey(resultDic[@"record"], @"finish_course")];
                     
                     if (isDown) {
                         weakSelf.learnModel = [JYMylearnRecordModel mj_objectWithKeyValues:resultDic[@"record"]];
                         weakSelf.dataArray = weakSelf.learnModel.learn_course;
                         
                     }else{
                         //上拉加载
                         NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
                         weakSelf.learnModel = [JYMylearnRecordModel mj_objectWithKeyValues:resultDic[@"record"]];
                         array =  weakSelf.learnModel.learn_course;
                         if (! ArrayIsEmpty(array)) {
                             [weakSelf.dataArray addObjectsFromArray:array];
                         }else{
                             weakSelf.pageIndex-- ;
                             [weakSelf.tableView.header endRefreshing];
                             [weakSelf.tableView.footer endRefreshingWithNoMoreData];
                             return ;
                         }
                     }
                 }else{
                     if (!isDown) {
                         weakSelf.pageIndex-- ;
                     }
                     [[AXProgressHUDHelper getInstance]showTextWithStatus:responseObject[@"msg"] onView:self.view];
                 }
                 [weakSelf refrshLearnData];
                 [weakSelf.tableView reloadData];
                 [weakSelf.tableView.header endRefreshing];
                 [weakSelf.tableView.footer endRefreshing];
                 
                 if (ArrayIsEmpty(weakSelf.dataArray)) {
                            weakSelf.nodataView.hidden = NO;
                            weakSelf.tableView.hidden = YES;
                        }else{
                            weakSelf.nodataView.hidden = YES;
                            weakSelf.tableView.hidden = NO;
                        }
        
        
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
        
    }];
    
}
#pragma mark--tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JYStudyRecondCell * cell = (JYStudyRecondCell * )[tableView dequeueReusableCellWithIdentifier:reuseInderfer];
    if (!cell) {
        cell = [[JYStudyRecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseInderfer];
    }
    
    if (!ArrayIsEmpty(self.dataArray)) {
        cell.courseModel = self.dataArray[indexPath.row];
    }
        return cell;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 227;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
        return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
        return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  
    UIView * header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    header.backgroundColor = RGBA(230, 230, 230, 1.0);
    UILabel * titleLabel = [UILabel wh_labelWithText:@"在学课程" textFont:small_fontsize textColor:RGBA(51, 51, 51, 1.0) frame:CGRectMake(MARGIN_OX, MARGIN_OY, 150, 20)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [header addSubview:titleLabel];
    return header;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(void)backButtonClick:(UIButton *)backBtn{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark--LZ
-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 300)];
        _headerView.backgroundColor = RGBA(230, 230, 230, 1.0);
        
        UIImageView * topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [_headerView width], 260)];
        topImage.image = [UIImage imageNamed:@"learntop"];
        topImage.userInteractionEnabled = YES;
        [_headerView addSubview:topImage];
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, NavitionbarHeight-44, ScreenWidth-100, 44)];
           titleLabel.textColor = WhiteTextColor;
           titleLabel.backgroundColor = [UIColor clearColor];
           titleLabel.text = @"学习记录";
           titleLabel.textAlignment = NSTextAlignmentCenter;
           titleLabel.font = PFBold(18);
        [topImage addSubview:titleLabel];
        
        UIButton * backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, NavitionbarHeight-44, 44, 44)];
        backButton.backgroundColor = [UIColor clearColor];
         [backButton setImage:[UIImage imageNamed:@"backgray"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [topImage addSubview:backButton];
        
        //
        self.userIcon = [[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_OX, NavitionbarHeight+15, 60, 60)];
        self.userIcon.userInteractionEnabled = YES;
        self.userIcon.layer.masksToBounds = YES;
        self.userIcon.layer.cornerRadius = 30.f;
        self.userIcon.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.userIcon.image = [UIImage imageNamed:@"learnusericon"];
        [_headerView addSubview:self.userIcon];
        
        NSString * userName = @"";
        if (StringIsEmpty([UserInfo shareInstance].userName)) {
            userName = @"未设置";
        }else{
            userName = [UserInfo shareInstance].userName;
        }
        self.userName = [UILabel wh_labelWithText:userName textFont:18 textColor:WhiteTextColor frame:CGRectMake(self.userIcon.right+MARGIN_OX, NavitionbarHeight+20, 150, 20)];
        self.userName.textAlignment = NSTextAlignmentLeft;
        self.userName.font = [UIFont boldSystemFontOfSize:18];
        [_headerView addSubview:self.userName];
        
        NSString * phone = @"";
        if (StringIsEmpty([UserInfo shareInstance].mobile)) {
            phone = @"暂无";
            
        }else{
            phone = [UserInfo shareInstance].mobile;
        }
        self.userPhone = [UILabel wh_labelWithText:phone textFont:13 textColor:WhiteTextColor frame:CGRectMake(self.userIcon.right+MARGIN_OX, self.userName.bottom+MARGIN_OY, 150, 20)];
        self.userPhone.textAlignment = NSTextAlignmentLeft;
        self.userPhone.font = [UIFont mediumWithSize:13];
        [_headerView addSubview:self.userPhone];
        
//        NSString * labelStr = @"累计学习 120 分钟";
//        NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc]initWithString:labelStr];
//        [attributeStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:20] range:[[attributeStr string]rangeOfString:@" 120 "]];
//
//        [attributeStr addAttribute:NSForegroundColorAttributeName value:WhiteTextColor range:[[attributeStr string]rangeOfString:@" 120 "]];
        self.totolLabel = [UILabel wh_labelWithText:@"" textFont:15 textColor:WhiteTextColor frame:CGRectMake(MARGIN_OX, self.userIcon.bottom+20, 200, 20)];
        self.totolLabel.font = [UIFont mediumWithSize:15];
        self.totolLabel.textAlignment = NSTextAlignmentLeft;
//        self.totolLabel.attributedText = attributeStr;
        self.totolLabel.userInteractionEnabled = YES;
        [_headerView addSubview:self.totolLabel];
        
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(MARGIN_OX, self.totolLabel.bottom+MARGIN_OX, ScreenWidth-MARGIN_OX*2, 100)];
        bottomView.backgroundColor = WhiteBackColor;
        bottomView.layer.masksToBounds = YES;
        bottomView.layer.cornerRadius = 12.f;
        [_headerView addSubview:bottomView];
        
        CGFloat labelWidth = ([bottomView width] -MARGIN_OX*4)/3;
        NSArray * arr = @[@"20分钟",@"12天",@"12节"];
        for (int i = 0; i<self.statuArr.count; i++) {
            learnStatu[i] = [UILabel wh_labelWithText:arr[i] textFont:15 textColor:HexadecimalColor(@"333333") frame:CGRectMake(MARGIN_OX+i%3*(labelWidth+MARGIN_OX), 20, labelWidth, 20)];
            
            UILabel * decLabel = [UILabel wh_labelWithText:self.statuArr[i] textFont:14 textColor:RGBA(153, 153, 153, 1.0) frame:CGRectMake(MARGIN_OX+i%3*(labelWidth+MARGIN_OX), learnStatu[i].bottom+12, labelWidth, 20)];
            decLabel.font = [UIFont mediumWithSize:14];
            [bottomView addSubview:learnStatu[i]];
            [bottomView addSubview:decLabel];
        }
        
        [_headerView setHeight:bottomView.bottom + 4];
        
        
    }
    return _headerView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.headerView.bottom, ScreenWidth, ScreenHeight - self.headerView.bottom-BottomSafebarHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBA(230, 230, 230, 1.0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[JYStudyRecondCell class] forCellReuseIdentifier:reuseInderfer];
        
        WEAKSELF();
             _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                  weakSelf.pageIndex = 1;
                  [weakSelf refrshdata:weakSelf.pageIndex isDown:YES];
                                
              }];
              _tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                  weakSelf.pageIndex ++;
                  [weakSelf refrshdata:weakSelf.pageIndex isDown:NO];
                          
              }];
              [_tableView.header beginRefreshing];
        
    }
    return _tableView;
}

-(UIView *)nodataView{
    if (_nodataView == nil) {
        _nodataView = [[UIView alloc]initWithFrame:CGRectMake(0, self.tableView.centerY-100, ScreenWidth, 200)];
        UIImageView * nodataImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-88.5, 0, 177, 126)];
        nodataImage.image = [UIImage imageNamed:@"nodataeImage"];
        [_nodataView addSubview:nodataImage];
        
        UILabel * label = [UILabel wh_labelWithText:@"暂无数据~" textFont:16 textColor:RGBA(153, 153, 153, 1.0) frame:CGRectMake(0, nodataImage.bottom+20, ScreenWidth, 20)];
        label.font = [UIFont boldSystemFontOfSize:16];
        [_nodataView addSubview:label];
    }
    return _nodataView;
}
-(NSArray *)statuArr{
    if (_statuArr == nil) {
        _statuArr = @[@"今日学习",@"连续学习",@"完成课程"];
    }
    return _statuArr;
}
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
