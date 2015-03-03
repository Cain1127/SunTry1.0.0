//
//  QSWServiceTermViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWServiceTermViewController.h"
#import "DeviceSizeHeader.h"
#import "ColorHeader.h"

@interface QSWServiceTermViewController ()

@end

@implementation QSWServiceTermViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ///标题
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:17]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setText:@"服务协议"];
    self.navigationItem.titleView = navTitle;
    
    ///自定义返回按钮
    UIBarButtonItem *turnBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(turnBackAction)];
    turnBackButton.tintColor = [UIColor whiteColor];
    
    ///设置返回按钮的颜色
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_selected"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = turnBackButton;
    
    UITextView *serviceView=[[UITextView alloc]initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, (iOS7 ? 69.0f : 5.0f), SIZE_DEFAULT_MAX_WIDTH, SIZE_DEVICE_HEIGHT - 79.0f)];
    
    serviceView.text=@"欢迎您使用香哉网络订餐服务，包括互联网订餐网站，手机App订餐客户端，以及香哉基于互联网或手机上网功能开发的其他订餐平台，提供的服务（以下简称\"我们的服务\"）。请仔 细阅读本法律条款。您使用我们的服务即表示您已同意本条款。我们的服务范围可能会拓展，因此有时还会适用一些附加条款或要求。附加条 款将会与相关服务一同提供，并且在您使用这些服务后，成为您与我们所达成的协议的一部分。本法律条款适用于您当前及未来使用的我们的 服务。\n1、我们的服务中所涉及的商标、服务标志、设计、文字或图案及相关知识产权等均属广州香哉餐饮管理有限公司或其关联公司（以下简称：香哉餐饮）所有、或已取得所有人的正式授权，受法律保护，在未取得香哉餐饮或有关第三方书面授权之前，任何人不得擅自使用，包括但不限于复制、复印、修改、出版、公布、传送、分发我们的服务中使用的文本、图象、影音、镜像等内容，否则将承担相应法律责任。使用我们的服务并不让您拥有我们的服务或您所访问的内容的任何知识产权。本条款并未授予您使用我们的服务中所用的任何商标、标志、设计、文字等的权利。\n2、我们在提供服务时将会尽到商业上合理水平的技能和注意义务，希望您会喜欢我们的服务，但有些关于服务的事项恕我们无法作出承诺。因此，在法律允许的范围内，我们的服务对信息的准确性和及时性不给予任何明示或默示的保证。我们的服务不承担因您进入或使用我们的服务而导致的任何直接的、间接的、意外的、因果性的损害责任。请使用合法软件和设备。\n3、您在使用我们的服务时，可以自愿选择是否提交个人信息资料。如果您提交个人信息，即表示您接受我们的服务隐私权条款，我们的服务对于您的个人信息和隐私权予以尊重和保密。您在使用我们的服务时传送的任何其他资料、信息，包括但不限于意见、客户反馈、喜好、建议、支持、请求、问题等内容，将被当作非保密资料和非专有资料处理；您的传送行为即表示您同意这些资料用作我们的调查、统计等目的而由我们无偿使用。\n4、当您在使用我们的服务时，某些信息可以通过各种技术和方法不经您主动提供而被收集，这些方法包括IP地址、Cookies，设备信息，日志数据收集等。这些信息不足以使他人辨认您个人的身份，收集上述信息的目的旨在为您提供更完善的服务。\n5、您在使用我们的服务时不得传送和发放带有中伤、诽谤、造谣、色情及其他违法或不道德的资料和言论，我们有权对此进行管理和监督，但并不对您的上述行为承担任何责任。\n6、我们的服务无意向18岁以下未成年人提供网络订餐服务或收集个人信息，家长或监护人应承担未成年人在网络环境下的隐私权的首要责任。请家长或监护人对其子女或被监护人使用我们的服务进行监管和负责。由于我们的服务无法辨认用户是否为未成年人，因此如有未成年人使用我们的服务，则表示其已获得家长或监护人认可，任何相关后果由其家长或监护人承担。\n7、如果我们的服务提供了第三方网站链接，仅仅是为了向您提供便利。如果您使用这些链接，您将离开本站。我们无法评估此类第三方网站，也不对任何此类第三方网站或这些网站提供的产品、服务或内容负责。因此，对于此类第三方网站，或此类网站上提供的任何信息、软件、产品、服务或材料，或使用这些网站可能得到的任何结果，您需自行评估及承担使用风险。\n8、我们可以修改本条款或相关条款并会予以更新和公布，所有修改的适用不具有追溯力。但是，对服务新功能的特别修改或由于法律原因所作的修改将立即生效。如果您不同意服务的修改条款，应停止使用我们的服务。";
    
    serviceView.textColor=COLOR_CHARACTERS_ROOTLINE;
    serviceView.font=[UIFont systemFontOfSize:16.0f];
    serviceView.showsHorizontalScrollIndicator = NO;
    serviceView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:serviceView];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
}

#pragma mark - 返回事件
- (void)turnBackAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
