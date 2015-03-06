//
//  MyAssetPickerController.m
//  DemoOfALAssetsLibrary
//
//  Created by 蔡成汉 on 15/3/3.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "MyAssetPickerController.h"
#import "MyAssetGroupController.h"

@interface MyAssetPickerController ()<MyAssetGroupControllerDelegate>
{
    MyAssetGroupController *viewController;
}
@end

@implementation MyAssetPickerController

/**
 *  重写init方法 -- 目的为设置MyAssetPickerController的RootViewController
 *
 *  @return 实例化之后的MyAssetPickerController
 */
-(id)init
{
    //设置默认值
    viewController = [[MyAssetGroupController alloc]init];
    viewController.maxSelectItem = 9;
    viewController.delegate = self;
    return [self initWithRootViewController:viewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 *  设置最大图片选择数量
 *
 *  @param maxSelectItem 最大图片选择数量
 */
-(void)setMaxSelectItem:(int)maxSelectItem
{
    viewController.maxSelectItem = maxSelectItem;
}

/**
 *  确定选择按钮的委托
 *
 *  @param controller 当前的pickerController
 *  @param imageArray 图片数组 - 数组的元素为image
 */
-(void)myAssetGroupController:(MyAssetGroupController *)controller didFinishSelect:(NSArray *)imageArray
{
    if (controller == viewController)
    {
        if ([self.pickControllerDelegate respondsToSelector:@selector(myAssetPickerController:didFinishSelect:)])
        {
            [self.pickControllerDelegate myAssetPickerController:self didFinishSelect:imageArray];
        }
    }
}

-(void)didCancleSelectImage:(MyAssetGroupController *)controller
{
    if (controller == viewController)
    {
        if ([self.pickControllerDelegate respondsToSelector:@selector(didCancleSelectImage:)])
        {
            [self.pickControllerDelegate didCancleSelectImage:self];
        }
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
