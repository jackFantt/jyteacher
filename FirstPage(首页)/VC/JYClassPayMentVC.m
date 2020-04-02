//
//  JYClassPayMentVC.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/26.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYClassPayMentVC.h"
#import "JYClassPayMentCell.h"

static NSString * const reuseInderfer = @"JYClassPayMentCell";

@interface JYClassPayMentVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIView * headerView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView * goodsImage;
@property (nonatomic,strong) UILabel * purchaseTitle;
@property (nonatomic,strong) UILabel * purchaseDec;
@property (nonatomic,strong) UILabel * payMoney;
@property (nonatomic,copy) NSArray * payArr;
@property (nonatomic,strong) UIButton * payBtn;
@property (nonatomic,assign) NSInteger selectedIndex;

@end

@implementation JYClassPayMentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTopViewWithTitle:@"支付" withBackButton:YES viewColor:WhiteBackColor];
    self.selectedIndex = 0;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.payBtn];
}

#pragma mark--tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.payArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        JYClassPayMentCell * cell = (JYClassPayMentCell * )[tableView dequeueReusableCellWithIdentifier:reuseInderfer];
           if (!cell) {
               cell = [[JYClassPayMentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseInderfer];
           }
    
    cell.iconImage.image = [UIImage imageNamed:self.payArr[indexPath.row]];
    cell.paymentTitle.text = self.payArr[indexPath.row];
    if (self.selectedIndex == indexPath.row) {
        cell.isCheck = YES;
    }else{
        cell.isCheck = NO;
    }
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndex = indexPath.row;
    [self.tableView reloadData];

}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavitionbarHeight, ScreenWidth, ScreenHeight - NavitionbarHeight - BottomSafebarHeight - 44) style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBA(245, 245, 245, 1.0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[JYClassPayMentCell class] forCellReuseIdentifier:reuseInderfer];
        
    }
    return _tableView;
}
-(UIView *)headerView{
   if (!_headerView) {
       _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 140)];
       _headerView.backgroundColor = WhiteBackColor;
       
       self.goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(MARGIN_OX, 16, 153, 96)];
       self.goodsImage.layer.masksToBounds = YES;
       self.goodsImage.layer.cornerRadius = 12;
       self.goodsImage.image = [UIImage imageNamed:@"课程封面"];
       [_headerView addSubview:self.goodsImage];
       
       self.purchaseTitle = [UILabel wh_labelWithText:@"学前教育" textFont:16 textColor:RGBA(51, 51, 51, 1.0) frame:CGRectMake(self.goodsImage.right+MARGIN_OX, 16, [_headerView width]-self.goodsImage.right-MARGIN_OX*2, 20)];
       self.purchaseTitle.textAlignment = NSTextAlignmentLeft;
       self.purchaseTitle.font = [UIFont boldSystemFontOfSize:16];
       [_headerView addSubview:self.purchaseTitle];
       
       self.purchaseDec = [UILabel wh_labelWithText:@"精英大学资深授课老师倾情" textFont:14 textColor:RGBA(102, 102, 102, 1.0) frame:CGRectMake(self.goodsImage.right+MARGIN_OX, self.purchaseTitle.bottom+MARGIN_OY, [_headerView width]-self.goodsImage.right-MARGIN_OX*2, 20)];
       self.purchaseDec.textAlignment = NSTextAlignmentLeft;
       self.purchaseDec.font = [UIFont mediumWithSize:14];
       [_headerView addSubview:self.purchaseDec];
       
       self.payMoney = [UILabel wh_labelWithText:@"" textFont:14 textColor:RGBA(153, 153, 153, 1.0) frame:CGRectMake(self.goodsImage.right+MARGIN_OX, self.goodsImage.bottom-20, [_headerView width]-self.goodsImage.right-MARGIN_OX*2, 20)];
             self.payMoney.textAlignment = NSTextAlignmentLeft;
             self.payMoney.font = [UIFont mediumWithSize:14];
             [_headerView addSubview:self.payMoney];
       
       NSString * money = @"需支付：￥210";
                 NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc]initWithString:money];
                 [attributeStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:18] range:[[attributeStr string]rangeOfString:@"￥210"]];
                 
                 [attributeStr addAttribute:NSForegroundColorAttributeName value:RGBA(218, 171, 119, 1.0) range:[[attributeStr string]rangeOfString:@"￥210"]];
          self.payMoney.attributedText = attributeStr;
       
       UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, [_headerView height]-MARGIN_OX, ScreenWidth, MARGIN_OX)];
       bottomView.backgroundColor = RGBA(245, 245, 245, 1.0);
       [_headerView addSubview:bottomView];
   }
    return _headerView;
}
-(UIButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [UIButton wh_buttonWithTitle:@"确认付款" backColor:RGBA(218, 171, 119, 1.0) backImageName:@"" titleColor:WhiteTextColor fontSize:16 frame:CGRectMake(0, self.tableView.bottom, ScreenWidth, 44) cornerRadius:0];
        _payBtn.titleLabel.font = [UIFont mediumWithSize:16];
    }
    return _payBtn;
}

#pragma mark--LZ
-(NSArray *)payArr{
    if (_payArr == nil) {
        _payArr = @[@"微信支付",@"支付宝支付"];
    }
    return _payArr;
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
