//
//  JYGetLiveInfoVC.m
//  JYEducation
//
//  Created by 精英教育 on 2020/4/1.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYGetLiveInfoVC.h"
#import "JYStudyRecondCell.h"
#import "JYLIveInfoMessageCell.h"
#import "JYCourseInfoModel.h"
#import "JYLiveInfoModel.h"
static NSString * const reuseInderfer_study = @"JYLIveInfoMessageCell";

@interface JYGetLiveInfoVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,strong) JYLiveInfoModel * liveRoomModel;
/*
 * 当前第几页:从1开始
 */
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,assign) NSInteger selectedIndex;

@end

@implementation JYGetLiveInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTopViewWithTitle:@"直播列表" withBackButton:YES viewColor:WhiteBackColor];
    self.selectedIndex = 0;
    [self.view addSubview:self.tableView];
}

-(void)refrshdata:(NSInteger )pageIndex isDown:(BOOL)isDown{
    WEAKSELF();
    
    NSDictionary * param = @{
//                            @"page":[NSNumber numberWithInteger:pageIndex]
                           };
    [AFHttpOperation postRequestWithURL:KAPIJY_GetLiveInfo parameters:param viewController:self success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"code"] integerValue] == RESPONSE_CODE_SUCCESS) {
            NSDictionary * dataDic = kParseData(responseObject);
            if (dataDic == nil) {
                return ;
            }
            //mj_objectArrayWithKeyValuesArray
            weakSelf.dataArray = [JYCourseInfoModel mj_objectArrayWithKeyValuesArray:dataDic[@"course_info"]];
            weakSelf.liveRoomModel = [JYLiveInfoModel mj_objectWithKeyValues:dataDic[@"live_info"]];
            
            
        }else{
            [[AXProgressHUDHelper getInstance]showTextWithStatus:responseObject[@"msg"] onView:weakSelf.view];
        }
        [weakSelf.tableView.header endRefreshing];
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        [weakSelf.tableView.header endRefreshing];
        
    }];
}

#pragma mark--tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    JYCourseInfoModel * model = self.dataArray[section];
    return model.lives.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        JYLIveInfoMessageCell * cell = (JYLIveInfoMessageCell * )[tableView dequeueReusableCellWithIdentifier:reuseInderfer_study];
           if (!cell) {
               cell = [[JYLIveInfoMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseInderfer_study];
           }
    
    if (self.selectedIndex == indexPath.row) {
           cell.isCheck = YES;
       }else{
           cell.isCheck = NO;
       }
    
    if (!ArrayIsEmpty(self.dataArray)) {
        JYCourseInfoModel * courseModel = self.dataArray[indexPath.section];
        JYLiveModel * liveModel = courseModel.lives[indexPath.row];
        cell.liveModel = liveModel;
    }
    
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndex = indexPath.row;
    [self.tableView reloadData];
    WEAKSELF();
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        JYCourseInfoModel * courseModel = self.dataArray[indexPath.section];
        JYLiveModel * liveModel = courseModel.lives[indexPath.row];
        NSString * liveID = liveModel.classid;
        NSString * roomName = weakSelf.liveRoomModel.name;
        NSString * liveName = liveModel.name;
        
        if (weakSelf.liveRoomBlock) {
            weakSelf.liveRoomBlock(liveID, roomName,liveName,liveModel.start);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    });

}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
        return 90.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
        return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  
    JYCourseInfoModel * model = self.dataArray[section];
    UIView * hederview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
    hederview.backgroundColor = RGBA(31, 28, 25, 1.0);
    
    UILabel * headerTiltle = [UILabel wh_labelWithText:model.name textFont:15 textColor:WhiteTextColor frame:CGRectMake(MARGIN_OX, 15, [hederview width]-MARGIN_OX*2, 20)];
    headerTiltle.textAlignment = NSTextAlignmentLeft;
    headerTiltle.font = [UIFont mediumWithSize:15];
    [hederview addSubview:headerTiltle];
    
    
    UILabel * headerDec = [UILabel wh_labelWithText:model.name textFont:15 textColor:RGBA(148, 148, 148, 1.0) frame:CGRectMake(MARGIN_OX, headerTiltle.bottom+10, 150, 30)];
    headerDec.font = [UIFont mediumWithSize:12];
    
    headerDec.layer.masksToBounds = YES;
    headerDec.layer.cornerRadius = 15;
    headerDec.backgroundColor = RGBA(80, 57, 23, 1.0);
    [hederview addSubview:headerDec];
    
    return hederview;

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

#pragma mark--LZ
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavitionbarHeight, ScreenWidth, ScreenHeight - NavitionbarHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBA(31, 28, 25, 1.0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[JYLIveInfoMessageCell class] forCellReuseIdentifier:reuseInderfer_study];
      
        WEAKSELF();
          _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
           weakSelf.pageIndex = 1;
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

#pragma mark--LZ
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
