//
//  JYLearnVC.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/17.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYLearnVC.h"
#import "JYMainRecommedCell.h"
#import "JYStudyRecondCell.h"
#import "JYLearnRecordModel.h"
static NSString * const reuseInderfer_study = @"JYStudyRecondCell";

@interface JYLearnVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton * toptagBtn[3];
}

@property (nonatomic,strong)UIView * headerView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView * nodataView;//无数据
@property (nonatomic,strong) UILabel * topTitle;
@property (nonatomic,copy) NSArray * toptagArr;
@property (nonatomic,strong) NSMutableArray * dataArray;
/*
 * 当前第几页:从1开始
 */
@property (nonatomic,assign) NSInteger pageIndex;


@end

@implementation JYLearnVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTopViewWithTitle:@"学习记录" withBackButton:NO viewColor:WhiteBackColor];
    self.pageIndex = 1;
    [self.view addSubview:self.nodataView];
    [self.view addSubview:self.tableView];
}

#pragma mark--LZ
-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, NavitionbarHeight, ScreenWidth, 105)];
        _headerView.backgroundColor = WhiteBackColor;
        
        self.topTitle = [UILabel wh_labelWithText:@"专升本" textFont:18 textColor:kBlackColor frame:CGRectMake(MARGIN_OX, MARGIN_OY, 200, 20)];
        self.topTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        self.topTitle.textAlignment = NSTextAlignmentLeft;
        [_headerView addSubview:self.topTitle];
        
        CGFloat btnWith = 90;
        for (int i = 0; i<self.toptagArr.count; i++) {
            toptagBtn [i] = [UIButton buttonWithType:UIButtonTypeCustom];
            toptagBtn[i].frame = CGRectMake(MARGIN_OX+i%3*(btnWith + MARGIN_OX), self.topTitle.bottom+20, btnWith, 25);
            toptagBtn[i].layer.masksToBounds = YES;
            toptagBtn[i].layer.cornerRadius = 2.0f;
            toptagBtn[i].layer.borderColor = [HexadecimalColor(@"999999") CGColor];
            toptagBtn[i].layer.borderWidth = 1.0f;
            toptagBtn[i].tag = 10+ i;
            toptagBtn[i].titleLabel.font = [UIFont systemFontOfSize:13];
            [toptagBtn[i] setTitle:self.toptagArr[i] forState:UIControlStateNormal];
            [toptagBtn[i] setTitleColor:HexadecimalColor(@"999999") forState:UIControlStateNormal];
            [toptagBtn[i] setTitleColor:WhiteTextColor forState:UIControlStateSelected];
//            [toptagBtn[i] setImage:[self imageWithColor:WhiteBackColor] forState:UIControlStateNormal];
//            [toptagBtn[i] setImage:[self imageWithColor:RGBA(0, 30, 245, 1.0)] forState:UIControlStateSelected];
            if (i == 0) {
                toptagBtn[i].selected = YES;
                toptagBtn[i].backgroundColor = RGBA(0, 30, 245, 1.0);
            }else{
                toptagBtn[i].backgroundColor = WhiteBackColor;
            }
            [toptagBtn[i] addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_headerView addSubview:toptagBtn[i]];
        }
        
        UIView * linevIew = [[UIView alloc]initWithFrame:CGRectMake(0, [_headerView height]-10, ScreenWidth, 10)];
        linevIew.backgroundColor = HexadecimalColor(@"#F3F3F3");
        [_headerView addSubview:linevIew];
        
    }
    return _headerView;
}

-(void)topBtnClick:(UIButton *)sender{
    sender.selected = YES;
    if (toptagBtn[0] == sender) { //
           toptagBtn[1].selected = NO;
           toptagBtn[2].selected = NO;
        toptagBtn[0].backgroundColor = RGBA(0, 30, 245, 1.0);
        toptagBtn[1].backgroundColor = WhiteBackColor;
        toptagBtn[2].backgroundColor = WhiteBackColor;
       }else if (toptagBtn[1] == sender){//
           toptagBtn[0].selected = NO;
           toptagBtn[2].selected = NO;
           toptagBtn[1].backgroundColor = RGBA(0, 30, 245, 1.0);
           toptagBtn[0].backgroundColor = WhiteBackColor;
           toptagBtn[2].backgroundColor = WhiteBackColor;
       }else if (toptagBtn[2] == sender){//
           toptagBtn[1].selected = NO;
           toptagBtn[0].selected = NO;
           toptagBtn[2].backgroundColor = RGBA(0, 30, 245, 1.0);
           toptagBtn[0].backgroundColor = WhiteBackColor;
           toptagBtn[1].backgroundColor = WhiteBackColor;
       }
    self.topTitle.text = self.toptagArr[sender.tag - 10];
    [self.tableView.header beginRefreshing];
}
-(void)refrshdata:(NSInteger )pageIndex isDown:(BOOL)isDown{
     WEAKSELF();
       NSDictionary * param = @{
                                @"page":[NSNumber numberWithInteger:pageIndex]
                               };
      [AFHttpOperation postRequestWithURL:KAPIJYeduction_learnrecord parameters:param viewController:self success:^(id  _Nonnull responseObject) {
          if ([responseObject[@"code"] integerValue] == RESPONSE_CODE_SUCCESS) {
              NSDictionary * resultDic = kParseData(responseObject);
              if (resultDic == nil) {
                   [weakSelf.tableView.header endRefreshing];
                  [weakSelf.tableView.footer endRefreshing];
                  return ;
              }
              
              if (isDown) {
                  weakSelf.dataArray = [JYLearnRecordModel mj_objectArrayWithKeyValuesArray:resultDic[@"record"][@"learn_course"]];
              }else{
                  //上拉加载
                  NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
                  
                  array =  [JYLearnRecordModel mj_objectArrayWithKeyValuesArray:resultDic[@"record"][@"learn_course"]];
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
          [[AXProgressHUDHelper getInstance]showTextWithStatus:kHUDNetWorkErrorText onView:weakSelf.view];
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
        JYStudyRecondCell * cell = (JYStudyRecondCell * )[tableView dequeueReusableCellWithIdentifier:reuseInderfer_study];
           if (!cell) {
               cell = [[JYStudyRecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseInderfer_study];
           }
    
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //测试微信支付
//    NSString *urlString   = @"https://wxpay.wxutil.com/pub_v2/app/app_pay.php?plat=ios";
//    NSDictionary * dic = @ {
//    @"appid": @"wxb4ba3c02aa476ea1",
//    @"noncestr": @"d1e6ecd5993ad2d06a9f50da607c971c",
//    @"package": @"Sign=WXPay",
//    @"partnerid": @"10000100",
//    @"prepayid": @"wx20160218122935e3753eda1f0066087993",
//    @"timestamp": @"1455769775",
//    @"sign": @"F6DEE4ADD82217782919A1696500AF06"
//    };
//    
//    [[CommonTool manager] requestWechatPay:dic];
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 227;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
        return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
        return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

#pragma mark--LZ
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavitionbarHeight, ScreenWidth, ScreenHeight-TabbarHeight - NavitionbarHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBA(245, 245, 245, 1.0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[JYStudyRecondCell class] forCellReuseIdentifier:reuseInderfer_study];
      
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
        _nodataView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight/2-100, ScreenWidth, 200)];
        UIImageView * nodataImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-88.5, 0, 177, 126)];
        nodataImage.image = [UIImage imageNamed:@"nodataeImage"];
        [_nodataView addSubview:nodataImage];
        
        UILabel * label = [UILabel wh_labelWithText:@"暂无数据~" textFont:16 textColor:RGBA(153, 153, 153, 1.0) frame:CGRectMake(0, nodataImage.bottom+20, ScreenWidth, 20)];
        label.font = [UIFont boldSystemFontOfSize:16];
        [_nodataView addSubview:label];
    }
    return _nodataView;
}
-(NSArray *)toptagArr{
    if (_toptagArr == nil) {
        _toptagArr = @[@"专升本",@"成人高考",@"教师资格证"];
    }
    return _toptagArr;
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
