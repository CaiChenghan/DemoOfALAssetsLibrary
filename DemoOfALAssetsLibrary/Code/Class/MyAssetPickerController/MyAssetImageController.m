//
//  MyAssetImageController.m
//  DemoOfALAssetsLibrary
//
//  Created by 蔡成汉 on 15/3/3.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "MyAssetImageController.h"
#import "MyAssetImageCollectionViewCell.h"
#import "MyAssetPickerToolbar.h"

@interface MyAssetImageController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MyAssetImageCollectionViewCellDelegate,MyAssetPickerToolbarDelegate>
{
    /**
     *  显示单个image的CollectionView
     */
    UICollectionView *myCollectionView;
    
    /**
     *  assets 存放图片的数组
     */
    NSMutableArray *assets;
    
    /**
     *  图片的总数
     */
    NSInteger numberOfPhotos;
    
    /**
     *  视屏的总数
     */
    NSInteger numberOfVideos;
    
    /**
     *  已选的图片
     */
    NSMutableArray *selectArray;
    
    MyAssetPickerToolbar *toolbar;
}
@end

@implementation MyAssetImageController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        selectArray = [NSMutableArray array];
        //默认最大支持数量为9
        self.maxSelectItem = 9;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self initiaNav];
    
    //获取图片数据
    [self getImages];
    
    //myCollectionView
    myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49) collectionViewLayout:[UICollectionViewFlowLayout new]];
    myCollectionView.backgroundColor = [UIColor whiteColor];
    myCollectionView.showsVerticalScrollIndicator = YES;
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    [myCollectionView registerClass:[MyAssetImageCollectionViewCell class] forCellWithReuseIdentifier:@"MyAssetImageCollectionViewCell"];
    [self.view addSubview:myCollectionView];
    
    //toolbar
    toolbar = [[MyAssetPickerToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
    toolbar.delegate = self;
    [self.view addSubview:toolbar];
}

/**
 *  初始化导航条
 */
-(void)initiaNav
{
    //右边生成新用户
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    self.navigationItem.rightBarButtonItem = rightItem;
}


//个数（主要是Cell的个数）
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return assets.count;
}

//分区数(新的分区)
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//cell的具体内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyAssetImageCollectionViewCell";
    MyAssetImageCollectionViewCell *collectionViewCell = (MyAssetImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    collectionViewCell.delegate = self;
    
    //判断图片是否已选
    ALAsset *tpAsset = [assets objectAtIndex:indexPath.row];
    BOOL isSelect = [selectArray containsObject:tpAsset];
    [collectionViewCell setMyAssetImageCollectionViewCellWithAsset:[assets objectAtIndex:indexPath.row] isSelect:isSelect indexPath:indexPath];
    return collectionViewCell;
}

//cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //这个需要根据当前屏幕的宽度进行计算
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    int a = 4;
    
    CGFloat imageWidth = (width - (a + 1)*3.0)/a;
    
    return CGSizeMake(imageWidth, imageWidth);
}

//每个小cell的具体位置参数
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(3, 3, 3, 3);
}

//返回----具体看视图里的（For Cells）的属性
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//返回分割区的大小---具体看视图里的（For Lines）的属性
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 3;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/**
 *  来自于MyAssetImageCollectionViewCell的点击事件
 *
 *  @param indexPath <#indexPath description#>
 */
-(void)selectIconButtonIsTouch:(NSIndexPath *)indexPath
{
    BOOL needChangeState;
    
    //判断是添加还是取消 -- 获取当前的ALAsset对象，
    ALAsset *tpAsset = [assets objectAtIndex:indexPath.row];
    BOOL containsObject = [selectArray containsObject:tpAsset];
    if (containsObject == YES)
    {
        //已经存在，则需要进行一个更改
        [selectArray removeObject:tpAsset];
        needChangeState = YES;
    }
    else
    {
        if (selectArray.count < self.maxSelectItem)
        {
            [selectArray addObject:tpAsset];
            needChangeState = YES;
        }
        else
        {
            needChangeState = NO;
            UIAlertView *myAlertView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"你最多只能选择%d张照片",self.maxSelectItem] delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [myAlertView show];
        }
    }
    
    if (needChangeState == YES)
    {
        //需要对单个的collectionViewCell进行更新
        NSArray *indePathArray = [NSArray arrayWithObjects:indexPath, nil];
        [myCollectionView reloadItemsAtIndexPaths:indePathArray];
        
        //同时需要更改导航的标题
        
        //更改toolbar的状态
        if (selectArray.count >0)
        {
            self.title = [NSString stringWithFormat:@"已选择%d张照片",(int)selectArray.count];
            toolbar.buttonCanTouch = YES;
        }
        else
        {
            self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
            toolbar.buttonCanTouch = NO;
        } 
    }
}

#pragma mark - MyAssetPickerToolbarDelegate

-(void)myAssetPickerToolbar:(MyAssetPickerToolbar *)toolbar leftButtonIsTouch:(UIButton *)paramSender
{
    //视图控制器内部实现
}

-(void)myAssetPickerToolbar:(MyAssetPickerToolbar *)toolbar rightButtonIsTouch:(UIButton *)paramSender
{
    if ([self.delegate respondsToSelector:@selector(myAssetImageController:didFinishSelectImage:)])
    {
        //需要对结果进行一个处理
        NSMutableArray *tpImageArray = [NSMutableArray array];
        for (int i = 0; i<selectArray.count; i++)
        {
            ALAsset *tpAsset = [selectArray objectAtIndex:i];
            UIImage *tpImage = [UIImage imageWithCGImage:tpAsset.defaultRepresentation.fullScreenImage];
            [tpImageArray addObject:tpImage];
        }
        [self.delegate myAssetImageController:self didFinishSelectImage:tpImageArray];
    }
}

/**
 *  获取图片数据
 */
-(void)getImages
{
    if (assets == nil)
    {
        assets = [NSMutableArray array];
    }
    else
    {
        [assets removeAllObjects];
    }
    
    //获取assetsGroup里的图片
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        if (asset)
        {
            [assets addObject:asset];
            
            NSString *type = [asset valueForProperty:ALAssetPropertyType];
            
            if ([type isEqual:ALAssetTypePhoto])
                numberOfPhotos ++;
            if ([type isEqual:ALAssetTypeVideo])
                numberOfVideos ++;
        }
        
        else if (assets.count > 0)
        {
            [myCollectionView reloadData];
            
            NSIndexPath *tpIndexPath = [NSIndexPath indexPathForRow:(assets.count - 1) inSection:0];
            [myCollectionView scrollToItemAtIndexPath:tpIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
        }
    };
    [self.assetsGroup enumerateAssetsUsingBlock:resultsBlock];
}


/**
 *  取消按钮点击事件
 */
-(void)cancle
{
    if ([self.delegate respondsToSelector:@selector(didCancleSelect:)])
    {
        [self.delegate didCancleSelect:self];
    }
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
