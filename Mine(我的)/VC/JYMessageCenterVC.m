//
//  JYMessageCenterVC.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/18.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYMessageCenterVC.h"
#import "JYMessageCenterCell.h"

static NSString * const reuseInderfer = @"JYMessageCenterCell";

@interface JYMessageCenterVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,copy) NSArray * decArr;
@property (nonatomic,strong) NSMutableArray * cellHighArr;

@end

@implementation JYMessageCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTopViewWithTitle:@"消息中心" withBackButton:YES viewColor:WhiteBackColor];
    [self.view addSubview:self.tableView];
    [self getcellHigh];
}

-(void)getcellHigh{
    for (int i = 0; i<self.decArr.count; i++) {
         NSString * message = self.decArr[i];
           UIFont * font = [UIFont mediumWithSize:14];
           CGRect rect = [message boundingRectWithSize:CGSizeMake(ScreenWidth-MARGIN_OX*4, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];

//           CGFloat cellHeight = rect.size.height + 102;
         CGFloat h = [[CommonTool manager] getSpaceLabelHeight:message withFont:[UIFont mediumWithSize:14] withWidth:ScreenWidth-MARGIN_OX*4];
        [self.cellHighArr addObject:[NSNumber numberWithFloat:h+102]];
    }
    
    [self.tableView reloadData];
}

#pragma mark--tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.decArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JYMessageCenterCell * cell = (JYMessageCenterCell * )[tableView dequeueReusableCellWithIdentifier:reuseInderfer];
    if (!cell) {
        cell = [[JYMessageCenterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseInderfer];
    }
    
    NSString * infoStr = self.decArr[indexPath.row];
    [cell setCellMessageDec:infoStr];
        return cell;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHigh = [self.cellHighArr[indexPath.row] floatValue];
    return cellHigh;
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

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavitionbarHeight, ScreenWidth, ScreenHeight - NavitionbarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = RGBA(245, 245, 245, 1.0);
        
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[JYMessageCenterCell class] forCellReuseIdentifier:reuseInderfer];
        
    }
    return _tableView;
}

#pragma mark--LZ
-(NSArray *)decArr{
    if (_decArr == nil) {
        _decArr = @[@"说到AI技术，无论是在“抗疫”前线还是在复工潮涌动的各大人流密集场所，都展现了其独特的魅力——比如，AI辅助诊断系统可提高新冠肺炎的检测效率、红外测温仪可迅速识别出人群中的高温个体、AI追踪技术可准确还原确诊病例活动轨迹。作为一项被不断提及却又未能被广泛应用的新兴技术，AI在特殊时期发挥的作用不可小觑，这也引来人们对此项技术新一轮的关注。",
        @"在教育领域，AI可谓是持续升温的热词，因此也衍生了“AI+教育”，或者人工智能教育这些专属名词(下文统称“AI+教育”)。",
        @"我国的“AI+教育”起步较晚，但是发展迅速，这离不开国家政策的支持。2017年3月，“人工智能”首次被写入全国政府工作报告，意味着人工智能已上升为国家战略，以BAT为首的科技企业陆续发布各自的人工智能发展战略;2018年4月2日，教育部印发《高等学校人工智能创新行动计划》，提出要加快人工智能在教育领域的创新应用，紧接着4月13日，教育部印发《教育信息化2.0行动计划》，提出了教育信息化的新方向，彼时，已经陆续有科技企业将人工智能与教育产品相结合;2019年初，党中央国务院发布了《中国教育现代化2035》，对“AI+教育”做出了明确部署，“AI+教育”进入全面发展阶段。AI+教育”的迅速发展当然也得益于各种企业在该领域的争相投入。目前可以看到的是，参与到该领域的公司可大致分成四类，一类是以新东方和好未来为代表的教育类公司，他们凭借丰富的市场经验，打造了最符合当下用户需求的产品"];
    }
    return _decArr;
}
-(NSMutableArray *)cellHighArr{
    if (_cellHighArr == nil) {
        _cellHighArr = [NSMutableArray new];
    }
    return _cellHighArr;
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
