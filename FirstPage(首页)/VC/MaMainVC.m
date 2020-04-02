//
//  MaMainVC.m
//  JYEducation
//
//  Created by wofuli on 2019/11/5.
//  Copyright © 2019 smart. All rights reserved.
//

#import "MaMainVC.h"
#import "JYMainLiveCell.h"
#import "JYMainSpecialCell.h"
#import "JYMainRecommedCell.h"
#import "JYMainTableHeaderView.h"
#import "JYSearchVC.h"
#import "JYLivePlayerVC.h"
#import "JYHeaderSectionVC.h"
#import "JYClassPayMentVC.h"
#import "JYCourseDetailsVC.h"
#import "MaLunBoModel.h"
#import "JYRecommendModel.h"
#import "JYbargain_videosModel.h"

#import "JYTuiLiuVC.h"
#import "JYQNLaLiuVC.h"

static NSString * const reuseInderfer_living = @"JYMainLiveCell";
static NSString * const reuseInderfer_special = @"JYMainSpecialCell";
static NSString * const reuseInderfer_recommend = @"JYMainRecommedCell";

@interface MaMainVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) JYMainTableHeaderView * tablehaderView;
@property (nonatomic,strong) NSMutableArray * bannerArr;//顶部轮播视图
@property (nonatomic,strong) NSMutableArray * liveArray;//直播课程数组
@property (nonatomic,strong) NSMutableArray * specialArray;//今日特价课程数组
@property (nonatomic,strong) NSMutableArray * recommendArray;//推荐课程数组
@property(nonatomic,strong)UIButton *upbtn;//回到顶部
/*
 * 当前第几页:从1开始
 */
@property (nonatomic,assign) NSInteger pageIndex;
@end

@implementation MaMainVC

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if(self.upbtn){
        self.upbtn.alpha=0;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTopViewWithTitle:@"精英大学" withBackButton:NO viewColor:WhiteBackColor];
    [self.view addSubview:self.tableView];
    [self createUI];
}


-(void)createUI{
    //回到顶部按钮
    UIButton *upbtn=[[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-60, ScreenHeight-BottomSafebarHeight-129, 50, 50)];
    [upbtn setImage:[UIImage imageNamed:@"homeUptopbtn"] forState:UIControlStateNormal];
    [upbtn addTarget:self action:@selector(upbtnclick:) forControlEvents:UIControlEventTouchUpInside];
    self.upbtn=upbtn;
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:upbtn];
    
    self.upbtn.alpha=0;
}

//回到顶部按钮
-(void)upbtnclick:(UIButton *)btn{
    if(self.tableView){
        [self.tableView setContentOffset:CGPointMake(0, 0)];
    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(scrollView.contentOffset.y>50){
        self.upbtn.alpha=1;
    }else{
        self.upbtn.alpha=0;
    }
}
-(void)refrshdata:(NSInteger )pageIndex isDown:(BOOL)isDown{
    WEAKSELF();
    
    NSDictionary * param = @{};
    [AFHttpOperation postRequestWithURL:KAPISmart_homePage parameters:param success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] integerValue] == RESPONSE_CODE_SUCCESS) {
            NSDictionary * resultDic = kParseData(responseObject);
            if (resultDic != nil) {
                if (isDown) {
                //轮播数据
                weakSelf.bannerArr = [MaLunBoModel mj_objectArrayWithKeyValuesArray:resultDic[@"banner"]];
                //推荐课程
                weakSelf.recommendArray = [JYRecommendModel mj_objectArrayWithKeyValuesArray:resultDic[@"recommend_videos"]];
                //特价课程
                    weakSelf.specialArray = [JYbargain_videosModel mj_objectArrayWithKeyValuesArray:resultDic[@"bargain_videos"]];
                   
            }
                [weakSelf.tablehaderView refrshJYHeaderBanner:weakSelf.bannerArr];
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView.header endRefreshing];
                    [weakSelf.tableView.footer endRefreshing];
        }
    }
        
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView.footer endRefreshing];
        [[AXProgressHUDHelper getInstance]showTextWithStatus:@"网络有点慢哦。。" onView:weakSelf.view];
        
        
    }];
    
//    [self.liveArray removeAllObjects];
//    [self.specialArray removeAllObjects];
//    [self.recommendArray removeAllObjects];
//    NSArray * liveArr = @[@"精英直播1",@"精英直播2"];
//    NSArray * sprArr = @[@"特价视频1",@"特价视频2"];
//    NSArray * recArr = @[@"placelmage1",@"placelmage2",@"placelmage3"];
//    [self.liveArray addObjectsFromArray:liveArr];
//    [self.specialArray addObjectsFromArray:sprArr];
//    [self.recommendArray addObjectsFromArray:recArr];
//    [self.tableView reloadData];
//    [weakSelf.tableView.header endRefreshing];
//    [weakSelf.tableView.footer endRefreshing];
}


#pragma mark--tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (ArrayIsEmpty(self.liveArray)) {
            return 0;
        }else{
            return 1;
        }
    }else if (section == 1){
         if (ArrayIsEmpty(self.specialArray)) {
                  return 0;
              }else{
                  return 1;
              }
    }else{
        return self.recommendArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF();
    if (indexPath.section == 0) { //直播list
         JYMainLiveCell * cell = (JYMainLiveCell * )[tableView dequeueReusableCellWithIdentifier:reuseInderfer_living];
           if (!cell) {
               cell = [[JYMainLiveCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseInderfer_living];
           }
        [cell setRefrshLiveImageWithImageArr:self.liveArray];
        cell.liveBlock = ^(NSInteger index) {
            [weakSelf cellLiveImageClickWithIndex:index];
        };
        return cell;
    }else if (indexPath.section == 1){//今日特价课程
        JYMainSpecialCell * cell = (JYMainSpecialCell * )[tableView dequeueReusableCellWithIdentifier:reuseInderfer_special];
           if (!cell) {
               cell = [[JYMainSpecialCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseInderfer_special];
           }
        [cell setRefrshSpecialImageWithImageArr:self.specialArray];
        cell.specialBlock = ^(NSInteger index) {
            [weakSelf cellSpecialImageClickWithIndex:index];
            
        };
        return cell;
    }else{//课程推荐
        JYMainRecommedCell * cell = (JYMainRecommedCell * )[tableView dequeueReusableCellWithIdentifier:reuseInderfer_recommend];
           if (!cell) {
               cell = [[JYMainRecommedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseInderfer_recommend];
           }
        if (!ArrayIsEmpty(self.recommendArray)) {
            JYRecommendModel * model = self.recommendArray[indexPath.row];
            cell.recommedModel = model;
        }

        return cell;
    }
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (ArrayIsEmpty(self.liveArray)) {
            return 0.000001f;
        }else{
            return 52+ (142+12)*self.liveArray.count +10;
        }
    }else if (indexPath.section == 1){
         if (ArrayIsEmpty(self.specialArray)) {
                   return 0.000001f;
               }else{
                   return 62 + 300 *self.specialArray.count+12;
               }
    }else{
        return 184;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }else if (section == 1){
        return 12;
    }else{
        return 44;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return CGFLOAT_MIN;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else if (section == 1){
       
        
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 12)];
        headerView.backgroundColor = RGBA(242, 242, 242, 1.0);
    
        return headerView;
    }else{
               UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
               headerView.backgroundColor = RGBA(242, 242, 242, 1.0);
        headerView.layer.masksToBounds = YES;
        headerView.layer.cornerRadius = 3.0f;
        
        UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(MARGIN_OX, 0, [headerView width]-MARGIN_OX*2, [headerView height])];
        titleView.backgroundColor = WhiteBackColor;
        titleView.layer.masksToBounds = YES;
        titleView.layer.cornerRadius = 3.0f;
        [headerView addSubview:titleView];
               
               UILabel * titleLabel = [UILabel wh_labelWithText:@"课程推荐" textFont:18 textColor:RGBA(51, 51, 51, 1.0) frame:CGRectMake(MARGIN_OX, 12, 120, 20)];
               titleLabel.textAlignment = NSTextAlignmentLeft;
               titleLabel.font = PFBold(18);
               [titleView addSubview:titleLabel];
               return headerView;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    JYCourseDetailsVC * detailVC = [[JYCourseDetailsVC alloc]init];
//    detailVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma mark--顶部按钮操作事件
-(void)headerViewTapClick:(NSInteger)index{
    if (index == 10 || index == 11 || index == 13) {//专升本
          JYHeaderSectionVC * learnVC = [[JYHeaderSectionVC alloc]init];
          learnVC.hidesBottomBarWhenPushed = YES;
        if (index == 13) {
            learnVC.selectedIndex = index - 11;
        }else{
            learnVC.selectedIndex = index - 10;
        }
          [self.navigationController pushViewController:learnVC animated:YES];
    }else if (index == 14 || index == 15){
        JYTuiLiuVC * tuivc = [[JYTuiLiuVC alloc]init];
           tuivc.hidesBottomBarWhenPushed = YES;
           [self.navigationController pushViewController:tuivc animated:YES];
    }else{
        JYQNLaLiuVC * laliuvc = [[JYQNLaLiuVC alloc]init];
        
        laliuvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:laliuvc animated:YES];
    }
    
}
#pragma mark--直播点击事件
-(void)cellLiveImageClickWithIndex:(NSInteger)index{
    NSLog(@"直播%ld",index);
    JYLivePlayerVC * liveVC = [[JYLivePlayerVC alloc]init];
    liveVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:liveVC animated:YES];
}
#pragma mark--今日特价
-(void)cellSpecialImageClickWithIndex:(NSInteger)index{
    NSLog(@"今日特价===%ld",index);
    JYLivePlayerVC * liveVC = [[JYLivePlayerVC alloc]init];
       liveVC.hidesBottomBarWhenPushed = YES;
       [self.navigationController pushViewController:liveVC animated:YES];
  
}

#pragma mark--LZ
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavitionbarHeight, ScreenWidth, ScreenHeight-TabbarHeight -NavitionbarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = RGBA(242, 242, 242, 1.0);
        
        _tableView.tableHeaderView = self.tablehaderView;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[JYMainLiveCell class] forCellReuseIdentifier:reuseInderfer_living];
        [_tableView registerClass:[JYMainSpecialCell class] forCellReuseIdentifier:reuseInderfer_special];
        [_tableView registerClass:[JYMainRecommedCell class] forCellReuseIdentifier:reuseInderfer_recommend];
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
-(JYMainTableHeaderView *)tablehaderView{
    WEAKSELF();
    if (!_tablehaderView) {
        _tablehaderView  = [[JYMainTableHeaderView alloc]initWithJYheaderView];
        _tablehaderView.searchBlock = ^{
            [weakSelf pushSearchVC];
        };
        _tablehaderView.sectionBlock = ^(NSInteger index) {
            [weakSelf headerViewTapClick:index];
            
        };
    }
    return _tablehaderView;
}

-(void)pushSearchVC{
    JYSearchVC * searchVC = [[JYSearchVC alloc]init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}
-(NSMutableArray *)liveArray{
    if (_liveArray == nil) {
        _liveArray = [NSMutableArray new];
    }
    return _liveArray;
}
-(NSMutableArray *)specialArray{
    if (_specialArray == nil) {
        _specialArray = [NSMutableArray new];
    }
    return _specialArray;
}
-(NSMutableArray *)recommendArray{
    if ( _recommendArray == nil) {
        _recommendArray = [NSMutableArray new];
    }
    return _recommendArray;
}
-(NSMutableArray *)bannerArr{
    if (_bannerArr == nil) {
        _bannerArr = [NSMutableArray new];
    }
    return _bannerArr;
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
