//
//  MyAssetGroupController.m
//  DemoOfALAssetsLibrary
//
//  Created by 蔡成汉 on 15/3/3.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "MyAssetGroupController.h"
#import "MyAssetImageController.h"
#import "MyAssetGroupTableViewCell.h"

@interface MyAssetGroupController ()<UITableViewDataSource,UITableViewDelegate,MyAssetImageControllerDelegate>
{
    /**
     *  相册列表tableview
     */
    UITableView *imageGroupTableView;
    
    /**
     *  是否为第一次进入这个VC -- 第一次的时候需要直接跳转到图片列表页，否则为页面加载
     */
    BOOL isFirst;
}
@end

@implementation MyAssetGroupController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        //设置默认值
        isFirst = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    if ([[UIDevice currentDevice] systemVersion].floatValue>=7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self initiaNav];
    
    //获取相册列表
    [self getImageGroup];
    
    //创建tableview
    imageGroupTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    imageGroupTableView.dataSource = self;
    imageGroupTableView.delegate = self;
    imageGroupTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:imageGroupTableView];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"groupTableViewCell";
    MyAssetGroupTableViewCell *groupTableViewCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (groupTableViewCell == nil)
    {
        groupTableViewCell = [[MyAssetGroupTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    [groupTableViewCell setMyAssetGroupTableViewCellWithAssetsGroup:[self.groups objectAtIndex:indexPath.row]];
    return groupTableViewCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyAssetImageController *imageController = [[MyAssetImageController alloc]init];
    imageController.assetsGroup = [self.groups objectAtIndex:indexPath.row];
    imageController.delegate = self;
    [self.navigationController pushViewController:imageController animated:YES];
}

/**
 *  获取相册列表
 */
-(void)getImageGroup
{
    if (self.assetsLibrary == nil)
    {
        self.assetsLibrary = [self.class defaultAssetsLibrary];
    }
    
    if (self.groups == nil)
    {
        self.groups = [NSMutableArray array];
    }
    else
    {
        [self.groups removeAllObjects];
    }
    
    ALAssetsFilter *assetsFilter = [ALAssetsFilter allPhotos];
    
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group)
        {
            [group setAssetsFilter:assetsFilter];
            if (group.numberOfAssets > 0)
            {
                [self.groups addObject:group];
            }
        }
        else
        {
            [self getAssetGroupFinish];
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        
        //        [self showNotAllowed];
        NSLog(@"错误信息提示");
        
    };
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
    
    // Then all other groups
    NSUInteger type =
    ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent |
    ALAssetsGroupFaces | ALAssetsGroupPhotoStream;
    
    [self.assetsLibrary enumerateGroupsWithTypes:type
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
}

#pragma mark - ALAssetsLibrary

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

/**
 *  获取相册列表完成
 */
-(void)getAssetGroupFinish
{
    self.title = @"照片";
    
    if (isFirst == YES)
    {
        isFirst = NO;
        MyAssetImageController *viewController = [[MyAssetImageController alloc]init];
        viewController.assetsGroup = [self.groups objectAtIndex:0];
        viewController.maxSelectItem = self.maxSelectItem;
        viewController.delegate = self;
        [self.navigationController pushViewController:viewController animated:NO];
    }
    else
    {
        [imageGroupTableView reloadData];
    }
}

/**
 *  取消按钮点击事件
 */
-(void)cancle
{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(didCancleSelectImage:)])
        {
            [self.delegate didCancleSelectImage:self];
        }
    }];
}

/**
 *  完成图片选择
 *
 *  @param controller 当前的MyAssetImageController
 *  @param imageArray 选取的图片数组 - 数组元素为image
 */
-(void)myAssetImageController:(MyAssetImageController *)controller didFinishSelectImage:(NSArray *)imageArray
{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(myAssetGroupController:didFinishSelect:)])
        {
            [self.delegate myAssetGroupController:self didFinishSelect:imageArray];
        }
    }];
}

/**
 *  取消图片选择
 *
 *  @param controller <#controller description#>
 */
-(void)didCancleSelect:(MyAssetImageController *)controller
{
    [self cancle];
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
