//
//  QSPOrderRemarkViewController.m
//  suntry
//
//  Created by CoolTea on 15/2/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderRemarkViewController.h"
#import "DeviceSizeHeader.h"
#import "QSBlockButton.h"
#import "ImageHeader.h"

#define ORDER_REMARK_VIEW_CONTROLLER_TEXT_FONT_SIZE         17.
#define ORDER_REMARK_VIEW_CONTROLLER_NAV_TITLE_FONT_SIZE    17.
#define ORDER_REMARK_VIEW_CONTROLLER_PLACEHOLDER_TEXT_COLOR [UIColor colorWithRed:0.709 green:0.653 blue:0.543 alpha:1.000]

@interface QSPOrderRemarkViewController ()

@property (nonatomic,strong)UITextView* contentTextView;
@property (nonatomic,strong)UILabel *placeholderLabel;

@end

@implementation QSPOrderRemarkViewController

- (void)loadView{
    
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    QSBlockButtonStyleModel *backButtonStyle = [[QSBlockButtonStyleModel alloc] init];
    [backButtonStyle setImagesNormal:IMAGE_NAVIGATIONBAR_BACK_NORMAL];
    [backButtonStyle setImagesHighted:IMAGE_NAVIGATIONBAR_MEINFO_HIGHLIGHTED];
    
    UIButton *backButton = [UIButton createBlockButtonWithFrame:CGRectMake(0, 0, 44, 44) andButtonStyle:backButtonStyle andCallBack:^(UIButton *button) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:ORDER_REMARK_VIEW_CONTROLLER_NAV_TITLE_FONT_SIZE]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setText:@"备注要求"];
    self.navigationItem.titleView = navTitle;

    CGFloat offetY = 0;
    CGFloat placeholderLabelY = 0;
    if ([[UIDevice currentDevice].systemVersion doubleValue] == 7.0) {
        offetY = 64;
        placeholderLabelY = 6;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }else{
        placeholderLabelY = 14;
    }
    
    self.contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(16, 16+offetY, SIZE_DEVICE_WIDTH-32, 130)];
    [self.contentTextView setBackgroundColor:[UIColor clearColor]];
    [self.contentTextView setFont:[UIFont systemFontOfSize:ORDER_REMARK_VIEW_CONTROLLER_TEXT_FONT_SIZE]];
    [self.contentTextView setDelegate:self];
    [self.contentTextView setReturnKeyType:UIReturnKeyDone];
    [self.contentTextView.layer setBorderColor:[ORDER_REMARK_VIEW_CONTROLLER_PLACEHOLDER_TEXT_COLOR CGColor]];
    [self.contentTextView.layer setBorderWidth:1.0];
    [self.contentTextView.layer setCornerRadius:5.];
    [self.view addSubview:self.contentTextView];
    
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 2-placeholderLabelY, SIZE_DEVICE_WIDTH-32, 32*2)];
    [self.placeholderLabel setBackgroundColor:[UIColor clearColor]];
    [self.placeholderLabel setText:@"给我们留言，可输入口味，时间，要求等"];
    [self.placeholderLabel setNumberOfLines:0];
    [self.placeholderLabel setFont:[UIFont systemFontOfSize:ORDER_REMARK_VIEW_CONTROLLER_TEXT_FONT_SIZE]];
    [self.placeholderLabel setTextColor:ORDER_REMARK_VIEW_CONTROLLER_PLACEHOLDER_TEXT_COLOR];
    [self.contentTextView addSubview:self.placeholderLabel];
    
    
    NSString *remarkStr = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_ORDER_USER_REMARK_INFO];
    if (remarkStr && ![remarkStr isEqualToString:@""]) {
        [self.contentTextView setText:remarkStr];
        [self.placeholderLabel setHidden:YES];
    }
    
    //确定按钮
    QSBlockButtonStyleModel *submitBtStyleModel = [QSBlockButtonStyleModel alloc];
    submitBtStyleModel.bgColor  = [UIColor colorWithRed:0.471 green:0.176 blue:0.224 alpha:1.000];;
    submitBtStyleModel.title    = @"确定";
    submitBtStyleModel.titleNormalColor = [UIColor whiteColor];
    submitBtStyleModel.cornerRadio = 6.;
    UIButton *submitBt = [UIButton createBlockButtonWithFrame:CGRectMake(12, self.contentTextView.frame.origin.y+self.contentTextView.frame.size.height+10, self.view.frame.size.width-12*2, 44) andButtonStyle:submitBtStyleModel andCallBack:^(UIButton *button) {
        
        NSLog(@"submitBtl");
        
        //        if ([self.contentTextView text]&&![[self.contentTextView text] isEqualToString:@""]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[self.contentTextView text] forKey:KEY_ORDER_USER_REMARK_INFO];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //        }else{
        //            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"请输入你的备注要求！"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //            [av show];
        //            return ;
        //        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    [self.view addSubview:submitBt];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView;
{
    if (textView.text.length != 0)
    {
        [self.placeholderLabel setHidden:YES];
    }
    else
    {
        [self.placeholderLabel setHidden:NO];
    }
    
}

- (void)textViewDidChange:(UITextView *)textView;
{
    if (textView.text.length != 0)
    {
        [self.placeholderLabel setHidden:YES];
    }
    else
    {
        [self.placeholderLabel setHidden:NO];
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
