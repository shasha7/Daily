//
//  DBHomeViewController.m
//  DouBan
//
//  Created by 王伟虎 on 2017/10/2.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "DBHomeViewController.h"
#import "DBHomeDetailViewController.h"
#import "UINavigationController+ExchangeToTopViewController.h"
#import "AFNetworking.h"

/*
 Storage class specifier关键字
 包括:auto,extern,static,register,mutable,volatile,restrict以及typedef.
 对于typedef,只是说在语句构成上,typedef声明看起来象static,extern等类型的变量声明;
 对于编译器来说,多个存储类关键字不能同时用,所以typedef register int FAST_COUNTER编译通不过
 从变量的作用域角度（空间）来分，可以分为全局变量和局部变量
 从变量的存在时间角度（生存期）来分，可以分为静态存储方式和动态存储方式
 内存中供用户使用的存储空间分为三部分:程序区、静态存储区、动态存储区
 在iOS中可使用的有auto,extern,static,register,volatile,restrict,typedef
 volatile和restrict都是为了方便编译器的优化
 static指函数是内部函数，不允许外部调用
 全局变量全部存放在静态存储区中，在程序开始执行时给全局变量分配存储区，程序执行完毕就释放
 动态存储区中存放以下数据：1.函数形式参数；2.自动变量；3.函数调用时的现场保存和返回地址
 
 static NSDictionary *FillParameters(NSDictionary *parameters, NSURL *url) {
    NSLog(@"parameters=%@, url=%@",parameters, url);
    return parameters;
 }
 */

@interface DBHomeViewController ()

@end

@implementation DBHomeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"首页";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[AFHTTPSessionManager manager] POST:@"http://120.25.226.186:32812/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 上传文件 在填写http请求体的时候，data采用NSDataReadingMappedIfSafe样式读取，控制内存峰值
        // 上传文件的格式 请求头 请求体
        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:@"/Volumes/My Passport/小码哥拓展班/02FM/0107-FMDay1/1-项目简介.mp4" options:NSDataReadingMappedIfSafe error:nil] name:@"file" fileName:@"1-项目简介.mp4" mimeType:@"video/mp4"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress = %@", @(1.0f * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount));
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"");
    }];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (@available(iOS 11.0, *)) {
        UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        self.navigationItem.searchController = searchController;
        
        // If this property is true (the default), the searchController’s search bar will hide as the user scrolls in the top view controller’s scroll view. If false, the search bar will remain visible and pinned underneath the navigation bar.
        self.navigationItem.hidesSearchBarWhenScrolling = NO;
    } else {
        // Fallback on earlier versions
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /// When set to YES, the navigation bar will use a larger out-of-line title view when requested by the current navigation item. To specify when the large out-of-line title view appears, see UINavigationItem.largeTitleDisplayMode. Defaults to NO.
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setPrefersLargeTitles:true];
    } else {
        // Fallback on earlier versions
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    /// When set to YES, the navigation bar will use a larger out-of-line title view when requested by the current navigation item. To specify when the large out-of-line title view appears, see UINavigationItem.largeTitleDisplayMode. Defaults to NO.
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setPrefersLargeTitles:false];
    } else {
        // Fallback on earlier versions
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     修饰局部变量
     保证局部变量永远只初始化一次，在程序的运行过程中永远只有一份内存，生命周期类似全局变量了，但是作用域不变。这句话怎么理解呢？还是以代码例子来讲解吧。
     */
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"cell-%ld", (long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DBHomeDetailViewController *deatilVC = [[DBHomeDetailViewController alloc] init];
    [self.navigationController exchangeToTopViewController:deatilVC animated:YES];
}

@end
