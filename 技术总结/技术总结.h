///---------------------
///技术总结暨每天处理问题总结
///---------------------

-------------------------
2016.5.24

#define kCellH
UIKIT_EXTERN static const CGFloat kcellw = 0;
FOUNDATION_EXTERN CGFloat const kInfoSegmentHeight;
关于const与宏的区别
就苹果而言，它更希望开发者使用const UIKIT_EXTERN NSString *const UITableViewSelectionDidChangeNotification
const和宏的区别:
 编译时刻:宏是预编译，const是编译
 编译检查:宏不会报编译错误，const会报编译错误.
宏的好处:可以定义函数和方法，const不行
eg:
#define kPlusTwoNum(x,y)     ((x)*(y))  (√)
// const放*前面约束参数，表示*a只读
// 只能修改地址a,不能通过a修改访问的内存空间
- (void)test:(const int *)a
{
    *a = 20;
}

// const放*后面约束参数，表示a只读
// 不能修改a的地址，只能修改a访问的值
- (void)test1:(int * const)a
{
    int b;
    // 会报错
    a = &b;
    
    *a = 2;
}
// 用类名调用类方法，底层会自动把类名转换成类对象调用
// 本质：让类对象发送消息
+ (void)eat {}
[Person eat];====>相当于objc_msgSend([Person class], @selector(eat));

iOS数字格式化  NSNumberFormatter

typedef CF_ENUM(CFIndex, CFNumberFormatterStyle) {
    kCFNumberFormatterNoStyle = 0,
    kCFNumberFormatterDecimalStyle = 1,
    kCFNumberFormatterCurrencyStyle = 2,
    kCFNumberFormatterPercentStyle = 3,
    kCFNumberFormatterScientificStyle = 4,
    kCFNumberFormatterSpellOutStyle = 5,
};

对应的样式
Formatted number string:123456789
Formatted number string:123,456,789
Formatted number string:￥123,456,789.00
Formatted number string:-539,222,988%
Formatted number string:1.23456789E8
Formatted number string:一亿二千三百四十五万六千七百八十九
其中第三项和最后一项的输出会根据系统设置的语言区域的不同而不同。

/*
  在每一View的layer层中有一个mask属性，他就是专门来设置该View的遮罩效果的。
  该mask本身也是一个layer层。我们只需要生成一个自定义的layer，然后覆盖在需要遮罩的View上面即可。
*/
- (void)progressView{
    
    //圆形路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:100 startAngle:M_PI endAngle:-M_PI clockwise:YES];
    
    //底色
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame     = self.bounds;
    shapeLayer.position  = self.center;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 2.0f;
    shapeLayer.strokeColor = [UIColor colorWithRed:32/255.0 green:197/255.0 blue:146/255.0 alpha:1].CGColor;
    shapeLayer.path = [path CGPath];
    [self.layer addSublayer:shapeLayer];
    
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.frame         = self.bounds;
    progressLayer.fillColor     =  [[UIColor clearColor] CGColor];
    progressLayer.strokeColor   = [[UIColor whiteColor] CGColor];
    progressLayer.lineCap       = kCALineCapRound;
    progressLayer.lineWidth     = 2.0f;
    progressLayer.path          = [path CGPath];
    progressLayer.strokeEnd     = 0;
    shapeLayer.mask             = progressLayer
    self.progressLayer          = progressLayer;
}

- (void)startProgressAnimation:(CGFloat)percent {
    
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [CATransaction setAnimationDuration:kDuration];
    self.progressLayer.strokeEnd = percent;
    [CATransaction commit];
}

+ (void)createMask {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(40, 50, 80, 100)];
    view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:view];
    
    CGFloat viewWidth  = CGRectGetWidth(view.frame);
    CGFloat viewHeight = CGRectGetHeight(view.frame);
    
    CGFloat rightSpace = 10.;
    CGFloat topSpace = 15.;
    
    CGPoint point1 = CGPointMake(0, 0);
    CGPoint point2 = CGPointMake(viewWidth-rightSpace, 0);
    CGPoint point3 = CGPointMake(viewWidth-rightSpace, topSpace);
    CGPoint point4 = CGPointMake(viewWidth, topSpace);
    CGPoint point5 = CGPointMake(viewWidth-rightSpace, topSpace+10.);
    CGPoint point6 = CGPointMake(viewWidth-rightSpace, viewHeight);
    CGPoint point7 = CGPointMake(0, viewHeight);
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    [path addLineToPoint:point4];
    [path addLineToPoint:point5];
    [path addLineToPoint:point6];
    [path addLineToPoint:point7];
    [path closePath];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    view.layer.mask = maskLayer;
}
-------------------------
2016.5.25

几种常见的编程思想
过程                代表C\VC\VB等等
对象                代表 C++\OC\JAVA等等
链式编程思想         代表Masonry 快速自动布局  里面也有用到响应式编程思想  集中体现在block上
响应式编程思想        代表KVO
函数响应式编程思想    代表ReactiveCocoa  github开源

全新动画popAnimation第三方

在用CocoaPods导入百度地图SDK时  会报一大堆错误
在target的build settings中搜索“c++ standard library”，将其设置为“libstdc++(GNU C++ standard library)”
如果还是解决不了就添加libstdc++.6.0.9这个库

-------------------------
2016.5.26

block的用法

//方法
- (void)calculatePlus:(void(^)(int, double))clickBtn {
    clickBtn(10, 20.1);
}

- (void)viewDidLoad {
    
    [self viewDidLoad];
    //定义一个名为clickBtn的无返回值，两个参数的block
    void(^clickBtn)(int, double) = ^(int a, double d){
        a+=1;
        d+=10.2;
        NSLog(@"%f",a+d);
    };
    [self calculatePlus:clickBtn];
    
    //或者这么来
    [self calculatePlus:^(int a, double d) {
        a+=1;
        d+=10.2;
        NSLog(@"%f",a+d);
    }];
}

//计时器的安全释放
if (_timer) {
    [_timer invalidate];
    self.timer = nil;
}

手动选中某一行cell
[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];

-------------------------
2016.5.27

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [self setSelected:selected animated:animated];
    
    //前提我们设置了cell的选中样式为none,在这个方法里面去设置文本的选中颜色、或者去设置indicatorView的选中与否
    self.textLabel.textColor = selected?[UIColor redColor]:[UIColor whiteColor];
    self.indicatorView.hidden = !selected;
}

-------------------------
2016.5.31

//cell 重用问题

if ([[userInfo.rank getStringValueForKey:@"pic" defaultValue:nil] length]) {
    self.rankButton.hidden = NO;
}else {
    self.rankButton.hidden = YES;
}
//重点在于这个重置button里面UIImageView里面的图片,后续用就没有问题了
[self.rankButton jy_setBackgroundImageWithURL:[NSURL URLWithString:[userInfo.rank getStringValueForKey:@"pic" defaultValue:nil]] forState:UIControlStateNormal placeholder:nil];

-------------------------
2016.6.1

凡是需要重用的东西,用之前清空状态,防止之后使用出现BUG

-------------------------
2016.6.2

关于今天处理js调用oc方法的bug处理解决方案   调用时间上不正确
应该在网页加载完毕之后(webViewDidFinishLoad:)调用才会收到奇效

e.g:
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //js调用oc方法
    [self jscallOCMethods:webView];
}

JSPatch:
为项目动态添加模块，或替换项目原生代码动态修复 bug


-------------------------
2016.6.3

//音视频处理
AudioFileStreamer   时提到它的作用是用来读取采样率、码率、时长等基本信息以及分离音频帧

-------------------------
2016.6.15

在定义cell重用标识的时候采用驼峰样式命名
static NSString *noticeIdentifier = @"NoticeView";

做网络请求时候 请求成功时候
- (void)getDataReturn:(NSDictionary*)dicReturn{
    
    NSInteger retcode = [dicReturn getIntegerValueForKey:@"retcode" defaultValue:0];
    if (retcode == 1) {
        
    }
    //这个不管 retcode是否为1 都要调用以下方法
    [self freshViewWithConnectError:NO msg:nil];
}

//广告条 自动化测试

static NSString *adIdentifier = @"AdviewCell";
UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:adIdentifier];
if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:adIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:_cellAdView];
    //自动化测试
    [cell setAccessibilityLabel:@"advertise"];
}
return cell;

//给某一个Button
//自动化测试
[button setIsAccessibilityElement:YES];
[button setAccessibilityLabel:"someName"];

//UserInfo 里面的属性  通过便捷方法 或者 字典中取值 响应的也要保存两个地方   以芝麻信用分为例:

[ShareData sharedInstance].curUserInfo.hasCertifyZMC = score;//便捷方法
NSMutableDictionary *userDic = [[ShareData sharedInstance].curUserInfo.infoDic mutableCopy];
[userDic setObject:@(score).stringValue forKey:@"249"];
[ShareData sharedInstance].curUserInfo.infoDic = [userDic copy];//从字典中取值

kScaleFactor这个宏的值为1  不必写这个了
#define kWidth 10000*kScaleFactor

//接受购买服务成功后的通知,通过Block来完成保存好炫彩相框的时候采取刷新界面----可以借鉴这种写法
- (void)processTranctionSucceededEvent:(NSNotification *)notification{
    @weakify(self)
    [self savePhotoFrame:^{
        @strongify(self)
        [self getPhotoFrameData];
    }];
}

- (void)savePhotoFrame:(void(^)())completion {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"personcenternew",@"action",@"saveframepic",@"fun",@([ShareData sharedInstance].curUserInfo.uid),@"uid",@(_model.fid), @"fid", nil];
    
    @weakify(self)
    [self.requestManager POST:kURL_MORE_FOCUS requestID:HTTP_ACITON_POST_PHOTO_FRAME parameters:params success:^(id result) {
        @strongify(self)
        [self closeWaitingAlertView];
        [self savePhotoFrameReturn:result];
        if (completion) {
            completion();
        }
    } failure:^(NSString *errorDesc) {
        @strongify(self)
        [self closeWaitingAlertView];
        [self savePhotoFrameFaild:errorDesc];
    }];
}


//正在加载中.......提示,看时机调用
[self showWaitingView:nil];

//关闭
[self closeWaitingAlertView];
//关闭蒙层完成之后---把需要做的事情放到一个block中
-(void)closeWaitingAlertViewWithCompletion:(void (^)(void))completion;

在解析json字典时候  没必要解析go link 在跳转页面的时候直接扔进去一个包含go link的字典即可

/**
 *  请求指定用户信息
 *  @param  userInfo 待请求数据的用户数据结构
 *  @param  src 页面对应入口标识
 *
 */
- (void)sendUserInfoRequestWithModel:(UserInfo *)userInfo
userInfoTypes:(NSString *)userInfoTypes
src:(NSUInteger)src
requestId:(NSString *)requestId
success:(void (^)(id result))success
failure:(void (^)(NSString *errorDesc))failure;


自定义UICollectionViewLayout  必须实现的方法
/*
 1.- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds 当collectionView视图位置有新改变(发生移动)时调用，其若返回YES则重新布局
 2.- (void)prepareLayout 准备好布局时调用。此时collectionView所有属性都已确定。读者在这里可以将collectionView当做画布，有了画布后，我们便可以在其上面画出每个item
 3.- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect 返回collectionView视图中所有视图的属性(UICollectionViewLayoutAttributes)数组
 4.- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath 返回indexPath对应item的属性
 5.- (CGSize)collectionViewContentSize 设置collectionView的可显示范围
 这些方法中最重要的便是3，4方法，在3方法中返回所有视图属性数组，并根据这些属性进行布局，而4方法则返回每个item的属性，我们则在这里设置每个item的属性(主要是frame)，就可以让collectionView按照我们的意愿进行布局了!(在这里我们不需要用到1方法，若item属性根据滑动改变，此时就需要随时进行布局改变)
 */

在直接使用_property属性的时候时刻注意循环引用问题
在 block 里直接写 _property 相当于 self->_property，虽然没写 self，但是暗含了对 self 的retain，容易造成循环引用。要记得用 weakSelf/strongSelf 大法。
NSDictionary 的allValues方法返回的是NSArray类型，并且内容顺序是随机的，并不是按照插入的顺序，键值果然不按套路来~这必然和它的存储方式有关系

UIView 的exclusiveTouch属性
exclusiveTouch的意思是UIView会独占整个Touch事件，具体的来说，就是当设置了exclusiveTouch的 UIView是事件的第一响应者，那么到你的所有手指离开前，其他的视图UIview是不会响应任何触摸事件的，对于多点触摸事件，这个属性就非常重要，值得注意的是：手势识别（GestureRecognizers）会忽略此属性。
列举用途：我们知道ios是没有GridView视图的，通常做法是在UITableView的cell上加载几个子视图，来模拟实现 GridView视图，但对于每一个子视图来说，就需要使用exclusiveTouch，否则当同时点击多个子视图，那么会触发每个子视图的事件。当然 还有我们常说的模态对话框。

//自动计算cell行高
1、使用Autolayout进行UI布局约束。
2、指定你的TableView的estimatedRowHeight属性的默认值。
3、指定你的TableView的rowHeight属性为UITableViewAutomaticDimension。

UIAlertView默认情况下所有的text是居中对齐的。 那如果需要将文本向左对齐或者添加其他控件比如输入框时该怎么办呢？ 不用担心， iPhone SDK还是很灵活的， 有很多delegate消息供调用程序使用。 所要做的就是在
- (void)willPresentAlertView:(UIAlertView *)alertView
中按照自己的需要修改或添加即可,比如需要将消息文本左对齐，下面的代码即可实现:
- (void)willPresentAlertView:(UIAlertView *)alertView
{
    for( UIView * view in alertView.subviews )
    {
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel *label = (UILabel*)view;
            label.textAlignment = UITextAlignmentLeft;
        }
    }
}


UIView的setNeedsDisplay和setNeedsLayout
1.首先 两个方法都是异步执行的。
2.其次 setNeedsDisplay会调用自动调用drawRect方法，这样可以拿到UIGraphicsGetCurrentContext，就可以画画了。而setNeedsLayout会默认调用layoutSubViews，就可以处理子视图中的一些数据。
综上所述，setNeedsDisplay方便绘图，而layoutSubViews方便处理数据。

-------------------------
2016.6.16

UIButton的，我发现，当给一个button的enable设置为NO后，如果想再更新它的title，background，就没法更新。
兼容方案是：先恢复enable为YES，然后再更新，最后再还原。或者设置userInteractionEnabled为NO

-------------------------
2016.6.22

//OC调用JS
在JYAdMobWebViewExport类 .m中
JSContext *context = [JSContext currentContext];//拿到当前context,注意线程问题
//调用JS方法uploadSuccess出入参数
[context evaluateScript:[NSString stringWithFormat:@"uploadSuccess('%@')",[ShareData sharedInstance].curUserInfo.avatarURL]];

/**
 解释：
 决定导航栏是否是半透明的；
 
 默认是YES，如果设置成YES ，放了一副不透明的图，那么效果是自动会把这个图弄成半透明;
 如果设置成NO,放了一副半透明的图，
 如果barstyle是UIBarStyleBlack，效果是半透明的图自动加上黑色背景
 如果barstyle是UIBarStyleDefault，效果是半透明的图自动加上白色背景
 如果设置了barTintColor,效果是半透明的图自动加上barTintColor的背景
 */
navigation.navigationBar.translucent = NO;

{\"lng\":%f,\"lat\":%f}  //    \"代表的"  \转译字符  双引号不能直接写  必须转移以后才会识别
====json {"lng":%f,"lat":%f}
    
-------------------------
2016.6.24
    
MKUserLocation  自定义一个大头针实体类,就会在MKMapView中显示一个MKAnnotionView,但是MKAnnotionView还是系统自带的
只有自定义了MKAnnotionView 才会显示自定义的view
自定义时候使用MKAnnotionView的子类MKPinAnnotationView去自定义

//正则表达式的使用
- (void)regularExpression {
    // 要被匹配的目标字符串
    NSString *target = @"";
    
    //1. 定义正则表达式字符串
    NSString *pattern = @"[0-9]";
    
    //2. 创建正则表达式对象
    NSError *error = nil;
    NSRegularExpression *expr = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:&error];
    
    //3. 使用正则式匹配目标字符串，得到一个结果集数组
    if (error)
        NSLog(@"error = %@\n", error);
    
    NSArray *results = [expr matchesInString:target options:0 range:NSMakeRange(0, target.length)];
    
    //4. 结果集数组中的每一个元素就是匹配成功的字串内容的范围
    for (NSTextCheckingResult *result in results) {
        
        //1. 获取字串的范围
        NSRange range = result.range;
        
        //2. 从目标串截取字串
        NSString *subString = [target substringWithRange:range];
        
        //3. 打印字串
        NSLog(@"range = %@ , subString = %@\n", range, subString);
    }
    
    //5. 也可以通过结果集数组的个数，来判断是否匹配成功
    if (results.count > 1) 
    {
        匹配成功
    } else {
        匹配失败
    }
}
-------------------------
2016.6.27
    
//数组传递给函数后，数组就会退化为指针 传进来的只不过时候数组的首地址 或者说数组的地址
void sortOneGroupNumbersFromSmallToBig(int *numbers, int numCount) {
    
    int tmp = 0;
    for (int i = 0; i < numCount; i++ ) {
        for (int j = i + 1; j < numCount; j++) {
            if (numbers[i] > numbers[j]) {
                tmp = numbers[i];
                numbers[i] = numbers[j];
                numbers[j] = tmp;
            }
        }
    }
}
    
    
int numbers[] = {1, 10 ,12, 2, 3, 5, 18};
printf("sizeof-%lu\n",sizeof(numbers));//28字节
printf("sizeof-%lu\n",sizeof(*numbers));//4字节 首元素
printf("sizeof-%lu\n",sizeof(int *));//在16位中是2字节，32位4字节，64位8字节

int count = sizeof(numbers)/sizeof(*numbers);
sortOneGroupNumbersFromSmallToBig(numbers, count);
for (int i = 0; i < 7; i++ ) {
    printf("num111----%d\n",numbers[i]);
}

逻辑 false / true
FAULSE/TRUE 是int类型 >>> 32位
faulse/true 是bool类型 >>> 1位
  
    
    
Callbacks回调方式
    
1.Delegate   NSURLConnection
2.Block      dispatch函数
3.c 函数指针
4.Target-Action模式（eg、UIButton添加回调处理）
5.NSNotificationCenter  键盘
6.KVO属性值改变监测       UITextView
 
    
/*
iOS中堆和栈的区别
管理方式：
对于栈来讲，是由编译器自动管理，无需我们手动控制；
对于堆来讲，释放工作有程序员控制，容易产生memory Leak。

申请大小:
栈:在Windows下，栈是向低地址扩展的数据结构，是一块连续的内存区域。这句话的意思是栈顶上的地址和栈的最大容量是系统预先规定好的
在Windows下，栈的大小是2M（也有的说1M，总之是编译器确定的一个常数），如果申请的空间超过了栈的剩余空间时候，就overflow。因此，能获得栈的空间较小。
堆:堆是向高地址扩展的数据结构，是不连续的内存区域。这是由于系统是用链表来存储的空闲内存地址的，自然是不连续的，而链表的遍历方向是由低地址向高地址。堆的大笑受限于计算机系统中有效的虚拟内存。由此可见，堆获得的空间比较灵活，也比较大。

碎片的问题：
对于堆来讲，频繁的new/delete势必会造成内存空间的不连续，从而造成大量的碎片，使程序效率降低。对于栈来讲，则不会存在这个问题，因为栈是先进后出的队列，他们是如此的一一对应，以至于永远都不可能有一个内存快从栈中弹出。

分配方式：
堆都是动态分配的，没有静态分配的堆。栈有两种分配方式：静态分配和动态分配。静态分配是编译器完成的，比如局部变量的分配。动态分配是有alloc函数进行分配的，但是栈的动态分配和堆是不同的，他的动态分配由编译器进行释放，无需我们手工实现。

分配效率：
栈是机器系统提供的数据结构，计算机会在底层堆栈提供支持，分配专门的寄存器存放栈的地址，压栈出栈都有专门的指令执行，这就决定了栈的效率比较高。堆则是C/C++函数库提供的，他的机制是很复杂的。
*/

-------------------------
2016.6.29

//判断版本号
if ([[[UIDevice currentDevice] systemVersion] compare:@"7.1" options:NSNumericSearch] != NSOrderedAscending) {
    // do something only for iOS7.1 And Later
}
    
//iOS9中iPad横屏时cell不正常显示 判断是否需要根据内容留白
tableView.cellLayoutMarginsFollowReadableWidth = NO;

-------------------------
2016.7.4
    
//解决多余行cell显示问题
tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

//最后一行分割线顶头
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.allData.count - 1) {
        // Remove seperator inset
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        // Prevent the cell from inheriting the Table View's margin settings
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        
        // Explictly set your cell's layout margins
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}
-------------------------
2016.7.5
    
//FIXME:现在的代码很可能是错的
//TODO: 以后需要做的事情

+ (NSString *)currentMachine {
    
    size_t size; /* sizeof() */
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    
    // Allocate the space to store name
    char *name = (char *)malloc(size);
    // Get the platform name
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    // Place name into a string
    NSString *machine = [NSString stringWithUTF8String:name];
    // Done with this
    free(name);
    return machine;
}
    
-------------------------
2016.7.7

    
SDWebImage 源码学习

UIImageView 下载图片过程

- (void)sd_setImageWithURL:(NSURL *)url;
                    |
                    |//调用下面的方法
                   \|/
- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;
                    |
                    |//调用SDWebImageManager类里面的方法
                   \|/
- (id <SDWebImageOperation>)downloadImageWithURL:(NSURL *)url
options:(SDWebImageOptions)options
progress:(SDWebImageDownloaderProgressBlock)progressBlock
completed:(SDWebImageCompletionWithFinishedBlock)completedBlock;
                    |
                    |//调用SDWebImageDownloader类里面的方法 真正执行下载任务
                   \|/
- (id <SDWebImageOperation>)downloadImageWithURL:(NSURL *)url
options:(SDWebImageOptions)options
progress:(SDWebImageDownloaderProgressBlock)progressBlock
completed:(SDWebImageCompletionWithFinishedBlock)completedBlock
    
extern NSString *const SDWebImageDownloadStartNotification;
 
//后台任务处理
@weakify(self)
self.backgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
    //进入后台借用时间到期之后，结束任务
    @strongify(self)
    if (self) {
        [self cancel];
        if (self.backgroundTaskId != UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskId];
            self.backgroundTaskId = UIBackgroundTaskInvalid;
        }
    }
}];
    
#if !__has_feature(objc_arc)
#error SDWebImage is ARC only. Either turn on ARC for the project or use -fobjc-arc flag
#endif
    

-------------------------
2016.9.27

    
//单例情况下几种禁用init的方法；个人推荐第一种
// 1.声明
- (instancetype)init __attribute__((unavailable("Disabled. Use +sharedInstance instead")));
- (instancetype)init NS_UNAVAILABLE;

// 2.通过断言
- (instancetype)init {
    NSAssert(false,@"unavailable, use sharedInstance instead");
    return nil;
}

// 3.或者通过异常
- (instancetype)init {
    [NSException raise:NSGenericException
            format:@"Disabled. Use +[%@ %@] instead",
     NSStringFromClass([self class]),
     NSStringFromSelector(@selector(sharedInstance))];
    return nil;
}
// 4.doesNotRecognizeSelector
- (instancetype)init {
    // unrecognized selector sent to instance 0xxxxxx'
    [super doesNotRecognizeSelector:_cmd];
    return nil;
}
     
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://120.25.226.186:32812/upload"]];
    request.HTTPMethod = @"POST";
    [request setValue:@"multipart/form-data;boundary=wwh" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [self dataWithResource:@"jy.png"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]);
    }];
}

- (NSMutableData *)dataWithResource:(NSString *)imageName {
    NSMutableData *data = [NSMutableData data];
    [data appendData:[@"--wwh" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"",imageName] dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"Content-Type:image/png" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:UIImagePNGRepresentation([UIImage imageNamed:imageName])];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"--wwh--" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    return data;
}

    
-------------------------
2016.10.21
    
//设置代理之后的强引用问题
//NSURLSession 对象在使用的时候，如果设置了代理，那么 session 会对代理对象保持一个强引用，在合适的时候应该主动进行释放
//可以在控制器调用 viewDidDisappear 方法的时候来进行处理，可以通过调用 invalidateAndCancel 方法或者是 finishTasksAndInvalidate 方法来释放对代理对象的强引用
//invalidateAndCancel      方法直接取消请求然后释放代理对象
//finishTasksAndInvalidate 方法等请求完成之后释放代理对象。
    
- (void)viewDidDisappear {
    [self.session finishTasksAndInvalidate];
}
    
-------------------------
2016.12.07
AsyncDisplayKit的使用
    
性能问题的探讨

当我们谈论性能问题的时候，我们只是关注UI性能问题，那些逻辑、网络的性能问题并不是我们要关注的重点。
作为iOS开发者而言，务必需要了解到，有什么因素会影响UI性能。

就一般应用而言，需要关注的性能的UI控件可能就只有 UITableView 和 UICollectionView，其它类型的UI，性能问题在可以容忍的范围内。 这也是 什么情况下应该使用 AsyncDisplayKit 的关注点。
但是，我们仍然有必要去列出一些影响流畅性的关键点。
1.网络请求，大部分网络请求都应该使用后台线程完成，如果你使用的是 AFNetworking、 SDWebImage 这些开源缓存库，那么切换到后台去请求网络资源的操作都已经默认完成。
2.本地数据读写和计算，当你需要从闪存中读取文件的时候，这些操作都应该使用GCD或者NSThread切换至后台线程中完成。
3.图像的处理，尽量使用合适的UIImage给予UIImageView使用，何谓合适？已经提前剪裁、缩放好的图片是最佳的，否则当UIImage赋予UIImageView.image的时候，iOS会有不必要的计算开销，而这些开销却是可以提前手动缓存起来的。
4.Layer 属性的谨慎选择，不合理的 Layer 特效（阴影、圆角）都会使流畅的滑动变成卡顿（非常重要）。
5.少用 UIView.backgroundColor = UIColor.clearColor()，透明的背景会加剧卡顿。

6.文字的渲染，你可能不知道，文字的渲染也是需要开销的。一般来说，文字渲染的开销非常小，甚至不能察觉到。但是，当一个UILabel被赋予大段富文本文字后，开销就会非常大。
7.图像的渲染，一个任何开发者、几乎所有库（包括SDWebImage）都无法解决的问题，图像在UIImageView中的渲染开销，并且图像的渲染只能在主线程中执行。

前五点都是可以在 UIView 的基础上解决的，如果前五点均优化完成后，仍然无法解决卡顿问题，则应该使用 AsyncDisplayKit。

AsyncDisplayKit 有对应的方案，着力解决文字渲染、图像渲染两个难题。

    
聊天API  AyncSocket

世纪佳缘
打开应用后 进入SplashScreenViewControlle.view界面 持续时间2秒 @“拒绝等待，我是行动派” 图片

1.在没有账户登录时
1.1	登陆登出接口
登陆接口1：
示例：
http://www.miuu.cn/api/sign/signon.php?name=xxxx&password=xxxx&channel=xxx&ver=xxxx&deviceid=xxxx&clientid=xxxx&reallogin=1
参数：
name-用户名
password-密码
channel-渠道号
ver-软件版本
deviceid -手机唯一串号
clientid- 11-iPhone, 13-Android
reallogin- 1表示真正的登陆计数，0表示token过期时，重新登陆获取新的token。
返回值：
{"token":"822bb53960177f550fae09c41d71f4214d58b8284b2d89.71866708","uid":"24894690","retcode":1}
token-唯一票据
retcode-
1	登录成功
-7	1.未提供用户名或密码及渠道信息
2.提供的用户名信息错误(手机号/邮箱/佳缘ID)
2	用户名或密码填写错误
3	登录过于频繁
4	未提供ChannelId
-1	黑名单会员登录
-2	资料关闭会员登录
-5 	准黑会员登录
kNotificationSign  登录状态 通知方法processSignEvent
/**
 *  当登录状态发生该变时  需要对NavBar进行改变
 */
- (void)processSignEvent:(NSNotification *)notification
{
    int status = [[[ notification userInfo ] objectForKey: @"SignStatus"] intValue];
    if (status == 1) {
        [self refreshNavBar];
    }
    
}

显示的是 WelcomeViewController继承自UIViewController 用CRNavigationController包装
而CRNavigationController的根控制器则是RecommendViewController
在WelcomeViewController中tabBar:didSelectItem:方法中实现登陆与否的切换
#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)theTabBar didSelectItem:(UITabBarItem *)item
{
    [theTabBar setSelectedItem:nil];
    NSUInteger index = item.tag;
    [self statTrackerEvent:[NSString stringWithFormat:@"%lu",(unsigned long)[kAppDelegate tranlateTabbarIndexToAdIndex:index]]];
    JiaYuanAppDelegate *appDelegate = (JiaYuanAppDelegate *)[[UIApplication sharedApplication]delegate];
    if ( [[ShareData sharedInstance] canUseTheModel:[kAppDelegate tranlateTabbarIndexToAdIndex:index]]) {
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
        appDelegate.mainTabBarController.selectedIndex = index;
    }else{
        [appDelegate switchToLoginView:[kAppDelegate tranlateTabbarIndexToAdIndex:index]];
    }
}
2.在有账户登录时
显示的是 UITabBarController 它的controllers是
/**
 *  缘分 界面
 */
MatchViewController2
/**
 *  搜索 界面
 */
SearchTableViewController
/**
 *  消息 界面
 */
ChatListViewController
/**
 *  发现 界面
 */
DiscoveryViewController
/**
 *  我  界面
 */
PslCenterViewController

缘分 界面
FateViewController //点击有眼缘按钮 弹出的控制器


3.每一个模块包含以下内容
3.1未登录时的欢迎界面
ChoiceCell //九宫格cell视图(点击ChoiceCell则会跳到UserInfoViewController//个人资料界面)
UserInfoViewController     //个人资料界面
3.2登录注册界面
LoginViewController        //登录界面
RegisterPNViewController   //注册界面

/**
 *  消息界面
 */
ChatListViewController
//联系人
ContactsMainViewController
//联系人界面下的控制器
ChatRequestListViewController //我发起的
ChatFriendViewController      //聊友
NewContactsViewController     //新联系人
ChatIntimateViewController    //亲密聊友
AttentionListViewController   //我关注的
SubscribeAndNewsViewController//佳缘订阅
SubscribeListViewController   //佳缘提醒

4.发现 界面
DiscoveryViewController
/**
 *  缘分圈
 */
FriendsCircleViewController
SquareItem 数据模型 缘分圈 附近的人 热聊群租 活动
UnitView   视图模型 缘分圈 附近的人 热聊群租 活动

GroupMoreViewController  热聊群组界面之设置里面的内容
群组详情
聊天表情
聊天背景
聊天气泡

/**
 *  发布动态
 */
FriendCircleDynamicViewController  //发布动态
/**
 *  附近的人
 */
NearViewController                 //附近的人 点击结果列表 头像 进入个人资料 界面
                                   //点击cell介入 聊天 界面
/**
 *  热聊群组
 */
HotChatGroupViewController
/**
 *  谁看过我
 */
WhoLookMeViewController_iPhone     //谁看过我 界面 WhoLikeMeViewController 谁中意我
/**
 *  擦肩而过
 */
IntimateViewController

TogetherSearchViewController       //心有灵犀
LoveCampViewController             //爱情训练营
CalendarViewController             //签到墙控制器
/**
 *  明星脸 界面
 */
AppearanceViewController           //搜脸
StarListViewController             //选取明星
JYImageProcessController           //请选择图片 UIActionSheet
CoupleViewController               //夫妻相
StarFaceViewController             //最佳明星脸
MeetViewController                 //碰面
MeetListViewController             //碰面之缘分纪录
/**
 *  摇摇缘分
 */
SquareShakeViewController          //摇摇缘分
SquareShakeUserInfoView            //摇摇 结果视图
/**
 *  找回缘分
 */
FindFateController                 //找回缘分
FindFateSearchController           //找回缘分
WeekFindController                 //本周找回


/**
 *  丘比特之箭
 */
CupidArrowViewController

FriendCircleDynamicViewController  //发布动态 控制器
JYPlaceHolderTextView －发布动态控制器 头部视图是一个自定义有占位符的UITextView和PhotosView图片视图

NoFriendView     //当提醒谁看没有人时显示的界面
SelectRemindViewController   //提醒谁看－选择提醒的人
CalendarDayView              //签到墙

Subscribe 订阅号 界面

LoadMoreCell                //加载更多cell
JYGridView                  //
ComplainViewController      //举报 控制器
ComplainHeaderView          //举报界面 头部 视图



/**
 *  聊天 界面
 */
ChatViewController
ChatViewDrawData           聊天气泡小尾巴左右位置发送消息成功失败等等
ChatViewDrawDataUnit       聊天类型 文本、音频、图片、表情。。。。
kNotificationMsgClearChatMsgHistory 通知


/**
 *  "我"界面控制器
 */
PslCenterViewController
PslCenterHeader//“我界面”的头部视图 点击靠谱度按钮 跳转到我的靠谱度TrustViewController控制器
TrustViewController  我的靠谱度     控制器
TrustHeaderView      靠谱度        头部视图
SpiderView           靠谱评分项目   头部视图子视图

PurchaseViewController  购买 界面


PslCenterHeaderDelegate//点击头部视图按钮调用的委托方法
/**
 *  上传头像
 */
- (void)pslCenterHeaderUploadAvatar:(PslCenterHeader *)pslCenterHeader;
/**
 *  上传生活照片
 */
- (void)pslCenterHeaderUploadPhoto:(PslCenterHeader *)pslCenterHeader;
/**
 *
 */
- (void)pslCenterHeaderTrust:(PslCenterHeader *)pslCenterHeader;
/**
 *
 */
- (void)pslCenterHeaderBindMobile:(PslCenterHeader *)pslCenterHeader;
/**
 *
 */
- (void)pslCenterHeader:(PslCenterHeader *)pslCenterHeader go:(NSInteger)tag;

/**
 * 酷炫特权、特色服务、专享特权、实用特权、精准特权模块  数据模型
 */
PslCenterSectionModel
/**
 * 酷炫特权、特色服务、专享特权、实用特权、精准特权模块  视图模型
 */
PslCenterCellView
PslCenterXktqView//酷炫特权
PslCenterTsfwView//特色服务
PslCenterZxtqView//专享特权
PslCenterSytqView//实用特权
PslCenterJztqView//精准特权

我 界面 设置按钮
MyInfoViewController        //我的资料
PropertyPickerViewController//个人资料属性修改

LifephotosViewController    //我的相册－我的生活照
MyContactsViewController    //我的往来

SetPushViewController       //提醒设置
SettingViewController       //位置设置
SetMatchViewController      //问候语设置

FeedBackViewController      //意见反馈

HowToViewController         //使用指南
AboutViewController         //关于软件
MemberIconCell              //会员头像的单元格
LogoutCell                  //注销的单元格

网络模块
聊天模块
内购模块
PurchaseViewController  购买 界面
#pragma mark - 内购模块

SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:identifier]];
request.delegate = self;
[request start];

/**
 *  拦截模块
 */
[kAppDelegate gotoView:0 withAddDict:[[kAppDelegate assistManager] interceptDict:userInfo] rootVc:self];

EmptyContentView *noContentView    无网络时或网络环境不好的情况出现的蒙板提示
JYAdViewController          //广告
curUser.uid != JiaYuanSystemUserCustomer //佳缘客服
ConstellationViewController   //星座适配
SearchResultViewController    //搜索按钮


/**
 *  统一进入个人资料界面
 *
 *  @param tag  从那个界面进入的标记
 *  @param info 谁的个人资料
 */
- (void)enterUserInfoViewControllerWithTag:(JYAD)tag userInfo:(UserInfo *)info;
/*
 *  进入聊天上下文统一方法
 *  @param tag      从哪个界面来得
 *  @param info     和谁聊天
 *  @param tempMsgs 临时聊天记录，没有可传nil
 */
- (void)enterChatViewControllerWithTag:(JYAD)tag userInfo:(UserInfo *)info tempMsgs:(NSArray *)tempMsgs;


/**
 *  我的账号
 */
ServiceDetailView  //服务具体解释视图



/*******************************************************************************************/
#pragma mark - 拦截层需要的方法重写
-(void)purchase:(PurchaseingViewController *)purchaseingViewController successed:(ProductInfo *)productInfo
{
    NSDictionary *dic = @{@"rid":self.currentRid};
    [[JYCommandManager defaultManager] performActionsWithCommand:7 params:dic rootViewControl:self];
    
    self.purchaseingViewController = nil;
    
}
- (void)ConsLeftBtnClicked{
    
    NSDictionary *dic = @{@"rid":self.currentRid};
    [[JYCommandManager defaultManager] performActionsWithCommand:7 params:dic rootViewControl:self];
}
/*******************************************************************************************/
/**
 *  当再次进入到该界面时 更新数据
 */
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isNeedRefresh) {
        [self loadData];
    }
    _isNeedRefresh = YES;
}
/**
 *  初始化操作只进行一次，每次进入该界面时刷新数据在viewWillAppear中进行
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setConfigurationInfo];
    
    [self createTableView];
    [self createEmptyView];
    
    [self showWaitingView:nil];
    
    [self loadData];
    
}

/**
 *  单聊 过程
 */
//1.开启聊天 接收发数据
[self startChat];
- (void)startChat
{
    [[ChatDataController sharedInstance] beginChatWith:curUser.uid];
    [[ChatDataController sharedInstance] setDelegate:self];
}
//和谁聊天---uid
-(void)beginChatWith:(NSUInteger)uid{
    if (uid == 0) {
        return;
    }
    （NSUInteger）chatingWithUserId = uid;
    [database setChatMsgIsReadFromUser:uid];
    UserInfo *u = [database getChatFriendWithUid:uid];
    if (u.uid == uid && [ShareData sharedInstance].deviceInfo.bangeNumber >= u.unreadMsgNumber)
    {
        [ShareData sharedInstance].deviceInfo.bangeNumber -= u.unreadMsgNumber;
    }
    u.unreadMsgNumber = 0;
    if (u.uid == uid)
    {
        [database updateChatFriend:u];
    }
    time_t t = [database getChatMsgCreatedAtWithUid:uid latest:YES];
    if (t && uid != JiaYuanSystemUserCustomer)
    {
        [clientSocket sendMessage:[NSString stringWithFormat:@"{\"cmd\":2001,\"uid\":%lu,\"before\":0,\"updateTime\":%ld}",(unsigned long)uid,t]];
    }
    if (uid != JiaYuanSystemUserCustomer)
    {
        [clientSocket sendMessage:[NSString stringWithFormat:@"{\"cmd\":2005,\"uid\":%lu}",(unsigned long)uid]];
    }
    
    NSNumber *number = [NSNumber numberWithUnsignedInteger:uid];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationOpenChatView object:number userInfo:nil];
    
    [self notifyNewMsgCountChanged];
}
//消息来源
- (BOOL)setChatMsgIsReadFromUser:(NSUInteger)uid{
    __block BOOL ret = NO;
    [self.queue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:@"update  chat_log set isRead = 1  where  friendUid =?", [NSNumber numberWithUnsignedInteger:uid]];
        
        
    }];
    return  ret;
}
//获取聊天人信息
- (UserInfo*)getChatFriendWithUid:(NSUInteger)uid{
    
    __block UserInfo *chatFriend = [[UserInfo alloc] init];
    [self.queue inDatabase:^(FMDatabase *db) {
        
        /*
         Change the contents of this block to suit your needs.
         */
        
        FMResultSet *rs = [db executeQuery:@"select avatar, nick, education, prov, city, marriage, birthday, birthday_year, isMember, unRead, isLock, ctime, msgId, msgType, content, mailId from chat_friend where tauid = ?",[NSNumber numberWithUnsignedInteger:uid]];
        
        
        while ([rs next]) {
            // just print out what we've got in a number of formats.
            
            
            chatFriend.uid = uid;
            chatFriend.avatarURL = [rs stringForColumn:@"avatar"];
            chatFriend.nickName = [rs stringForColumn:@"nick"];
            chatFriend.degree = [rs stringForColumn:@"education"];
            
            chatFriend.location = [rs stringForColumn:@"prov"];
            chatFriend.subLocation = [rs stringForColumn:@"city"];
            chatFriend.marriage = [rs stringForColumn:@"marriage"];
            chatFriend.birthday = [rs stringForColumn:@"birthday"];
            chatFriend.birthday_year = [rs stringForColumn:@"birthday_year"];
            [chatFriend generateAge];
            chatFriend.isMember = [rs intForColumn:@"isMember"];
            chatFriend.unreadMsgNumber = [rs intForColumn:@"unRead"];
            chatFriend.isLocked = [rs intForColumn:@"isLock"];
            chatFriend.mostRecentDate = [rs longForColumn:@"ctime"];;
            chatFriend.mostRecentMsgId = [rs stringForColumn:@"msgId"];
            chatFriend.msgType =  [rs intForColumn:@"msgType"];
            chatFriend.mostRecentMessage = [rs stringForColumn:@"content"];
            chatFriend.mostRecentMailId = [rs stringForColumn:@"mailId"];
            break;
            
        }
        [rs close];
    }];
    return [chatFriend autorelease];
}
//2.开启聊天 接收发数据
/**
 *  我的账号
 */
AccountViewController
ServiceExchangeViewController   //服务 ----web

缘分 点击大图 送礼 进入此页面
GiftInterceptView  礼物购买页
PurchaseingViewController 购买过程控制器
    
typedef CF_OPTIONS( uint32_t, CMTimeFlags ) {
    kCMTimeFlags_Valid = 1UL<<0,
    kCMTimeFlags_HasBeenRounded = 1UL<<1,
    kCMTimeFlags_PositiveInfinity = 1UL<<2,
    kCMTimeFlags_NegativeInfinity = 1UL<<3,
    kCMTimeFlags_Indefinite = 1UL<<4,
    kCMTimeFlags_ImpliedValueFlagsMask = kCMTimeFlags_PositiveInfinity | kCMTimeFlags_NegativeInfinity | kCMTimeFlags_Indefinite
};
/*
 CMTime定义是一个C语言的结构体，是專門用來表示影片時間用的類別
 他的用法為: CMTimeMake(value, timescale)
 value指的是第几帧  int64_t--long long
 timeScale指的是1秒需要由幾個frame構成(可以視為fps)  int32_t--int
 */
typedef struct
{
    /*! @field value The value of the CMTime. value/timescale = seconds. */
    CMTimeValue	value;//long long
    
    /*! @field timescale The timescale of the CMTime. value/timescale = seconds.  */
    CMTimeScale	timescale;//int
    
    /*! @field flags The flags, eg. kCMTimeFlags_Valid, kCMTimeFlags_PositiveInfinity, etc. */
    CMTimeFlags	flags;//枚举
    
    /*
     @field epoch Differentiates between equal timestamps that are actually different because
     of looping, multi-item sequencing, etc.
     Will be used during comparison: greater epochs happen after lesser ones.
     Additions/subtraction is only possible within a single epoch,
     however, since epoch length may be unknown/variable. 
     */
    CMTimeEpoch	epoch;//long long
    
} CMTime;
    
typedef struct
{
    /*! @field duration
     The duration of the sample. If a single struct applies to
     each of the samples, they all will have this duration. */
    CMTime duration;
    
    /*! @field presentationTimeStamp
     The time at which the sample will be presented. If a single
     struct applies to each of the samples, this is the presentationTime of the
     first sample. The presentationTime of subsequent samples will be derived by
     repeatedly adding the sample duration. */
    CMTime presentationTimeStamp;
    
    /*! @field decodeTimeStamp
     The time at which the sample will be decoded. If the samples
     are in presentation order, this must be set to kCMTimeInvalid. */
    CMTime decodeTimeStamp;
    
} CMSampleTimingInfo;
    
    
    
typedef struct {
    GLfloat x;
    GLfloat y;
    GLfloat z;
} Vertex3D;
    
Vertex3D vertex;
vertex.x = 10.0;
vertex.y = 23.75;
vertex.z = -12.532;
    
GLfloat vertex[3];
vertex[0] = 10.0;    // x
vertex[1] = 23.75;   // y
vertex[2] = -12.532; // z
    
static inline Vertex3D Vertex3DMake(CGFloat inX, CGFloat inY, CGFloat inZ){
    Vertex3D ret;
    ret.x = inX;
    ret.y = inY;
    ret.z = inZ;
    return ret;
}
    
static inline GLfloat Vertex3DCalculateDistanceBetweenVertices (Vertex3D first, Vertex3D second) {
    GLfloat deltaX = second.x - first.x;
    GLfloat deltaY = second.y - first.y;
    GLfloat deltaZ = second.z - first.z;
    return sqrtf(deltaX*deltaX + deltaY*deltaY + deltaZ*deltaZ );
}
