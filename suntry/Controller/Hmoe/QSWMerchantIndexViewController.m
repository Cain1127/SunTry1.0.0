//
//  QSWMerchantIndexViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWMerchantIndexViewController.h"
#import "DeviceSizeHeader.h"
#import "FontHeader.h"
#import "QSMapNavigationViewController.h"
#import "QSWMerchantIndexCell.h"

@interface QSWMerchantIndexViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIImageView *foodImageView;
@property (weak, nonatomic) IBOutlet UIButton *sharkButton;
@property (weak, nonatomic) IBOutlet UIButton *packageButton;
@property (weak, nonatomic) IBOutlet UIButton *carButton;
@property (weak, nonatomic) IBOutlet UIButton *customButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UILabel *specialsLabel;
@property (strong, nonatomic)UICollectionView *collectionView;
@end

@implementation QSWMerchantIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=@"体育西路";
    
    ///加载头部view
    [self setupTopView];
    
    ///加载食品列表
    [self setupFoodListView];
    
}

///加载顶部view
-(void)setupTopView
{
    
    _foodImageView.frame=CGRectMake(0, 0, SIZE_DEVICE_WIDTH, SIZE_DEFAULT_HOME_BANNAR_HEIGHT);
    
    CGFloat buttonW=(SIZE_DEVICE_WIDTH-5*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)/4;
    CGFloat buttonH=buttonW*74/78;
    CGFloat buttonY=SIZE_DEFAULT_HOME_BANNAR_HEIGHT+SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    
    _sharkButton.frame=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, buttonY, buttonW, buttonH);
    
    _packageButton.frame=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT*2+buttonW, buttonY, buttonW, buttonH);
    
    _carButton.frame=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT*3+2*buttonW, buttonY, buttonW, buttonH);
    
     _customButton.frame=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT*4+3*buttonW, buttonY, buttonW, buttonH);
    
    _specialsLabel.frame=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT,buttonY+buttonH+SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 180.0f, 30.0f);
    
    _moreButton.frame=CGRectMake(SIZE_DEVICE_WIDTH-SIZE_DEFAULT_MARGIN_LEFT_RIGHT-30.0f, buttonY+buttonH+SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 30.0f, 30.0f);
    
}

///加载食品列表
-(void)setupFoodListView
{

    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, self.moreButton.frame.origin.y+30+SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_WIDTH-2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT-self.moreButton.frame.origin.y-30-49.0f) collectionViewLayout:flowLayout];
    self.collectionView.showsVerticalScrollIndicator=NO;
    
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    
    //注册Cell，必须要有
    [self.collectionView registerClass:[QSWMerchantIndexCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    [self.view addSubview:self.collectionView];
}

#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    
    QSWMerchantIndexCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell==nil) {
        
        cell=[[QSWMerchantIndexCell alloc]init];
    
    }
   
    cell.foodImageView.image=[UIImage imageNamed:@"home_bannar"];
    cell.foodNameLabel.text=@"都城辣子鸡";
    cell.priceMarkImageView.image=[UIImage imageNamed:@"home_pricemark"];
    cell.priceLabel.text=@"188";
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat viewW=(SIZE_DEVICE_WIDTH-3*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)*0.5-10;
    CGFloat viewH=viewW*289/335;
    return CGSizeMake(viewW, viewH);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat margin=SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    return UIEdgeInsetsMake(margin, margin, margin, margin);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //临时改变个颜色，看好，只是临时改变的。如果要永久改变，可以先改数据源，然后在cellForItemAtIndexPath中控制。
    cell.backgroundColor = [UIColor greenColor];
    NSLog(@"item======%d",indexPath.item);
    NSLog(@"row=======%d",indexPath.row);
    NSLog(@"section===%d",indexPath.section);
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (IBAction)sharkButtonClick:(id)sender {
}

- (IBAction)packageButtonClick:(id)sender {
}

- (IBAction)carButtonClick:(id)sender {
    
    QSMapNavigationViewController *VC=[[QSMapNavigationViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)customButtonClick:(id)sender {
}
- (IBAction)moreButtonClick:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
