//
//  JYSearchVC.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/16.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYSearchVC.h"
#import "JYSearchGoodsCell.h"
#import "ZYTokenManager.h"

static NSString * const reuseInderfer = @"JYSearchGoodsCell";

@interface JYSearchVC ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITextField * searchText;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * searchHistory;
@property (nonatomic,strong)NSArray *myArray;//搜索记录的数组

@end

@implementation JYSearchVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [self readNSUserDefaults];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTopViewWithTitle:@"搜索" withBackButton:YES viewColor:WhiteBackColor];
    [self setupUI];
}

-(void)setupUI{
    UIView * searchView = [[UIView alloc]initWithFrame:CGRectMake(MARGIN_OX, NavitionbarHeight+MARGIN_OY , ScreenWidth-MARGIN_OX*2, 40)];
          searchView.backgroundColor = WhiteBackColor;
          [self.view addSubview:searchView];
          searchView.layer.masksToBounds = YES;
          searchView.layer.cornerRadius = 20.0f;
        searchView.layer.borderColor = [HexadecimalColor(@"999999") CGColor];
       searchView.layer.borderWidth = 1.0f;
          
          UIImageView * searchImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12.5, 15, 15)];
          searchImage.image = [UIImage imageNamed:@"hometopsearch"];
          [searchView addSubview:searchImage];
    
      self.searchText = [[UITextField alloc]initWithFrame:CGRectMake(searchImage.right+5,0, [searchView width]-searchImage.right-5*2, 40)];
          self.searchText.backgroundColor = [UIColor clearColor];
          self.searchText.font = [UIFont systemFontOfSize:15];
          self.searchText.textColor = HexadecimalColor(@"#333333");
          self.searchText.textAlignment = NSTextAlignmentLeft;
    self.searchText.delegate = self;
          self.searchText.returnKeyType = UIReturnKeySearch;
          
          //ios13
          // 就下面这两行是重点
             NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请搜索课程名称" attributes:
             @{NSForegroundColorAttributeName:HexadecimalColor(@"#CCCCCC"),
                          NSFontAttributeName:[UIFont systemFontOfSize:15]
                  }];
             self.searchText.attributedPlaceholder = attrString;
          [searchView addSubview:self.searchText];
    
         [self.view addSubview:self.tableView];
}

//搜索方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length > 0) {
        //缓存搜索记录
        [ZYTokenManager SearchText:textField.text];
        [self readNSUserDefaults];
        
    }else{
        NSLog(@"请输入查找内容");
    }
    
    return YES;
}

#pragma mark -- LZ
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavitionbarHeight+40+MARGIN_OY*2, ScreenWidth, ScreenHeight-(NavitionbarHeight+40+MARGIN_OY_10*2)-BottomSafebarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[JYSearchGoodsCell class] forCellReuseIdentifier:reuseInderfer];
    }
    return _tableView;
}

#pragma mark--tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
//返回多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
         return 1;
    }else{
        //如果搜索历史长度大于0就隐藏
        if (_myArray.count>0) {
            
            return _myArray.count+1+1;
        }else{
            return 1;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
         cell.textLabel.text = @"热搜";
        
        return cell;
    }else if (indexPath.section==1) {
        if(indexPath.row ==0){
            UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"历史搜索";
            return cell;
        }else if (indexPath.row == _myArray.count+1){
            UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
            cell.textLabel.text = @"清除历史记录";
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            JYSearchGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseInderfer];
            NSArray* reversedArray = [[_myArray reverseObjectEnumerator] allObjects];
            cell.labelTitle.text = reversedArray[indexPath.row-1];
            cell.labelTitle.textColor = [UIColor blueColor];
//            if (self.myArray.count != 0 ) {
//                 cell.lableText.text = self.myArray[self.myArray.count-1-indexPath.row];
//            }
            return cell;
        }
    }else{
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
        return 10;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _myArray.count+1) {
        return 100;
    }
    self.tableView.estimatedRowHeight = 44.0f;
    //    self.searchTableView.estimatedRowHeight = 44.0f;
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _myArray.count+1) {//清除所有历史记录
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"清除历史记录" message:@"" preferredStyle: UIAlertControllerStyleAlert];
        
        //@“ UIAlertControllerStyleAlert，改成这个就是中间弹出"
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [ZYTokenManager removeAllArray];
            _myArray = nil;
            [self.tableView reloadData];
            
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:deleteAction];
        //            [alertController addAction:archiveAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return;
        }
//        muyiViewController *search = [muyiViewController new];
//        if (self.myArray.count!=0) {
//
//            search.title = self.myArray[self.myArray.count-1-indexPath.row];
//        }
//        [self.navigationController pushViewController:search animated:YES];
        NSLog(@"跳转详情页");
    
    }
}

-(NSMutableArray *)searchHistory{
    if (_searchHistory == nil) {
        _searchHistory = [NSMutableArray new];
    }
    return _searchHistory;
}

-(void)readNSUserDefaults{//取出缓存的数据
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数组NSArray类型的数据
    NSArray * myArray = [userDefaultes arrayForKey:@"myArray"];
    self.myArray = myArray;
    [self.tableView reloadData];
   
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
