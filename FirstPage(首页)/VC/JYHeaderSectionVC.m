//
//  JYHeaderSectionVC.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/26.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYHeaderSectionVC.h"
#import "JYMainRecommedCell.h"

static NSString * const reuseInderfer = @"JYMainRecommedCell";

@interface JYHeaderSectionVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton * toptagBtn[3];
}

@property (nonatomic,strong)UIView * headerView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UILabel * topTitle;
@property (nonatomic,copy) NSArray * toptagArr;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * recommendArray;//推荐课程数组
/*
 * 当前第几页:从1开始
 */
@property (nonatomic,assign) NSInteger pageIndex;


@end

@implementation JYHeaderSectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTopViewWithTitle:@"精英大学" withBackButton:YES viewColor:WhiteBackColor];
//    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
}

#pragma mark--LZ
-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, NavitionbarHeight, ScreenWidth, 120)];
        _headerView.backgroundColor = RGBA(245, 245, 245, 1.0);
        
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(MARGIN_OX, MARGIN_OY, [_headerView width] - MARGIN_OX*2, 96)];
        bottomView.backgroundColor = WhiteBackColor;
        bottomView.layer.masksToBounds = YES;
        bottomView.layer.cornerRadius = 12.f;
        [_headerView addSubview:bottomView];
        
        self.topTitle = [UILabel wh_labelWithText:self.toptagArr[self.selectedIndex] textFont:18 textColor:RGBA(51, 51, 51, 1.0) frame:CGRectMake(MARGIN_OX, 16, 200, 20)];
        self.topTitle.font = [UIFont BoldWithSize:18];
        self.topTitle.textAlignment = NSTextAlignmentLeft;
        [bottomView addSubview:self.topTitle];
        
        CGFloat btnWith = ([bottomView width] - MARGIN_OX*4)/3;
        for (int i = 0; i<self.toptagArr.count; i++) {
            toptagBtn [i] = [UIButton buttonWithType:UIButtonTypeCustom];
            toptagBtn[i].frame = CGRectMake(MARGIN_OX+i%3*(btnWith + MARGIN_OX), self.topTitle.bottom+MARGIN_OY, btnWith, 32);
            toptagBtn[i].layer.masksToBounds = YES;
            toptagBtn[i].layer.cornerRadius = 6.0f;
            toptagBtn[i].layer.borderColor = [RGBA(218, 171, 119, 1.0) CGColor];
            toptagBtn[i].layer.borderWidth = 1.0f;
            toptagBtn[i].tag = 10+ i;
            toptagBtn[i].titleLabel.font = [UIFont BoldWithSize:16];
            [toptagBtn[i] setTitle:self.toptagArr[i] forState:UIControlStateNormal];
            [toptagBtn[i] setTitleColor:RGBA(218, 171, 119, 1.0) forState:UIControlStateNormal];
            [toptagBtn[i] setTitleColor:WhiteTextColor forState:UIControlStateSelected];
//            [toptagBtn[i] setImage:[self imageWithColor:WhiteBackColor] forState:UIControlStateNormal];
//            [toptagBtn[i] setImage:[self imageWithColor:RGBA(0, 30, 245, 1.0)] forState:UIControlStateSelected];
            if (i == self.selectedIndex) {
                toptagBtn[i].selected = YES;
                toptagBtn[i].backgroundColor = RGBA(218, 171, 119, 1.0);
            }else{
                toptagBtn[i].backgroundColor = WhiteBackColor;
            }
            [toptagBtn[i] addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bottomView addSubview:toptagBtn[i]];
        }
        
        
    }
    return _headerView;
}

-(void)topBtnClick:(UIButton *)sender{
    sender.selected = YES;
    if (toptagBtn[0] == sender) { //
           toptagBtn[1].selected = NO;
           toptagBtn[2].selected = NO;
        toptagBtn[0].backgroundColor = RGBA(218, 171, 119, 1.0);
        toptagBtn[1].backgroundColor = WhiteBackColor;
        toptagBtn[2].backgroundColor = WhiteBackColor;
       }else if (toptagBtn[1] == sender){//
           toptagBtn[0].selected = NO;
           toptagBtn[2].selected = NO;
           toptagBtn[1].backgroundColor = RGBA(218, 171, 119, 1.0);
           toptagBtn[0].backgroundColor = WhiteBackColor;
           toptagBtn[2].backgroundColor = WhiteBackColor;
       }else if (toptagBtn[2] == sender){//
           toptagBtn[1].selected = NO;
           toptagBtn[0].selected = NO;
           toptagBtn[2].backgroundColor = RGBA(218, 171, 119, 1.0);
           toptagBtn[0].backgroundColor = WhiteBackColor;
           toptagBtn[1].backgroundColor = WhiteBackColor;
       }
    self.topTitle.text = self.toptagArr[sender.tag - 10];
    [self.tableView.header beginRefreshing];
}
-(void)refrshdata:(NSInteger )pageIndex isDown:(BOOL)isDown{
    WEAKSELF();
      [self.recommendArray removeAllObjects];
      NSArray * recArr = @[@"placelmage1",@"placelmage2",@"placelmage3"];
      [self.recommendArray addObjectsFromArray:recArr];
    [weakSelf.tableView reloadData];
    [weakSelf.tableView.header endRefreshing];
    [weakSelf.tableView.footer endRefreshing];
}
#pragma mark--tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recommendArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        JYMainRecommedCell * cell = (JYMainRecommedCell * )[tableView dequeueReusableCellWithIdentifier:reuseInderfer];
           if (!cell) {
               cell = [[JYMainRecommedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseInderfer];
           }
//      [cell setRefrshRecommendCell:self.recommendArray[indexPath.row]];
    
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 184;
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavitionbarHeight, ScreenWidth, ScreenHeight - NavitionbarHeight - BottomSafebarHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBA(245, 245, 245, 1.0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[JYMainRecommedCell class] forCellReuseIdentifier:reuseInderfer];
      
        WEAKSELF();
          _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
           weakSelf.pageIndex = 0;
          [weakSelf refrshdata:weakSelf.pageIndex isDown:YES];
                         
        }];
//        _tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            weakSelf.pageIndex ++;
//            [weakSelf refrshdata:weakSelf.pageIndex isDown:NO];
//
//        }];
        
        [_tableView.header beginRefreshing];
        
    }
    return _tableView;
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
-(NSMutableArray *)recommendArray{
    if ( _recommendArray == nil) {
        _recommendArray = [NSMutableArray new];
    }
    return _recommendArray;
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
