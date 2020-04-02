//
//  JYPurchasedVC.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/17.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYPurchasedVC.h"
#import "JYPurchaseCell.h"
#import "JYHasBuyListModel.h"
static NSString * const reuseInderfer = @"JYPurchaseCell";

@interface JYPurchasedVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) UIView * nodataView;//无数据

 /*
 * 当前第几页:从1开始
 */
@property (nonatomic,assign) NSInteger pageIndex;

@end

@implementation JYPurchasedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTopViewWithTitle:@"购买记录" withBackButton:NO viewColor:WhiteBackColor];
    self.pageIndex = 1;
    [self.view addSubview:self.nodataView];
    [self.view addSubview:self.tableView];
}

-(void)refrshdata:(NSInteger )pageIndex isDown:(BOOL)isDown{
     WEAKSELF();
     NSDictionary * param = @{
                              @"page":[NSNumber numberWithInteger:pageIndex]
                             };
    [AFHttpOperation postRequestWithURL:KAPIJYeduction_hasbuy parameters:param viewController:self success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] integerValue] == RESPONSE_CODE_SUCCESS) {
            NSDictionary * resultDic = kParseData(responseObject);
            if (resultDic == nil) {
                 [weakSelf.tableView.header endRefreshing];
                [weakSelf.tableView.footer endRefreshing];
                return ;
            }
            
            if (isDown) {
                weakSelf.dataArray = [JYHasBuyListModel mj_objectArrayWithKeyValuesArray:resultDic[@"orderList"]];
            }else{
                //上拉加载
                NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
                
                array =  [JYHasBuyListModel mj_objectArrayWithKeyValuesArray:resultDic[@"orderList"]];
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
    return self.dataArray.count+8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        JYPurchaseCell * cell = (JYPurchaseCell * )[tableView dequeueReusableCellWithIdentifier:reuseInderfer];
           if (!cell) {
               cell = [[JYPurchaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseInderfer];
           }
        return cell;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 128;
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
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[JYPurchaseCell class] forCellReuseIdentifier:reuseInderfer];
      
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
