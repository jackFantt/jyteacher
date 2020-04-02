//
//  JYVideoViewVC.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/26.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYVideoViewVC.h"
#import "JYVideoViewCell.h"
static NSString * const reuseInderfer = @"JYVideoViewCell";

@interface JYVideoViewVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
 /*
 * 当前第几页:从1开始
 */
@property (nonatomic,assign) NSInteger pageIndex;

@end

@implementation JYVideoViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
}

-(void)refrshdata:(NSInteger )pageIndex isDown:(BOOL)isDown{
    WEAKSELF();
    [weakSelf.tableView reloadData];
    [weakSelf.tableView.header endRefreshing];
    [weakSelf.tableView.footer endRefreshing];
}

#pragma mark--tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count+8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        JYVideoViewCell * cell = (JYVideoViewCell * )[tableView dequeueReusableCellWithIdentifier:reuseInderfer];
           if (!cell) {
               cell = [[JYVideoViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseInderfer];
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
        CGFloat lastViewHigh = CGRectGetWidth(self.view.frame)*9/16 + NavitionbarHeight +45;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - lastViewHigh - BottomSafebarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[JYVideoViewCell class] forCellReuseIdentifier:reuseInderfer];
      
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
