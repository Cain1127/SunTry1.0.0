// 0.从appStore上获取最新的版本信息
#define REQUEST_APPLE_VERSION @"http://itunes.apple.com/lookup?id=973358881"

///检查更新版本
#define REQUEST_VERSION_URL  @"site/GetVersion"

///数据请求根地址
//#define REQUEST_ROOT_URL @"http://test.9dxz.com/"
#define REQUEST_ROOT_URL @"api.9dxz.com/"

// 1.判断是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] == 7.0)

// 2.获得RGB颜色
#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 3.自定义Log
#ifdef DEBUG
#define QSLog(...) NSLog(__VA_ARGS__)
#else
#define QSLog(...)
#endif

// 4.是否为4inch
#define fourInch ([UIScreen mainScreen].bounds.size.height == 568)

/** 表格的边框宽度 */
#define StatusTableBorder 5

/** cell的边框宽度 */
#define StatusCellBorder 10

// 5.常用的对象
#define NotificationCenter [NSNotificationCenter defaultCenter]

