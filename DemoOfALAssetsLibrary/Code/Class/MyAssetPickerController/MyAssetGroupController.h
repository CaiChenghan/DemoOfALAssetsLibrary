//
//  MyAssetGroupController.h
//  DemoOfALAssetsLibrary
//
//  Created by 蔡成汉 on 15/3/3.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class MyAssetGroupController;

@protocol MyAssetGroupControllerDelegate <NSObject>

@optional

/**
 *  完成图片选择
 *
 *  @param controller 当前的MyAssetGroupController
 *  @param imageArray 选择的图片数组
 */
-(void)myAssetGroupController:(MyAssetGroupController *)controller didFinishSelect:(NSArray *)imageArray;

/**
 *  选择图片出错
 *
 *  @param controller 当前的MyAssetGroupController
 *  @param error      错误信息
 */
-(void)myAssetGroupController:(MyAssetGroupController *)controller selectImageWithError:(NSError *)error;

/**
 *  取消图片选择
 *
 *  @param controller 当前的MyAssetGroupController
 */
-(void)didCancleSelectImage:(MyAssetGroupController *)controller;

@end

@interface MyAssetGroupController : UIViewController

/**
 *  最大选择图片数量
 */
@property (nonatomic , assign) int maxSelectItem;

/**
 *  所有图片
 */
@property (nonatomic , strong) ALAssetsLibrary *assetsLibrary;

/**
 *  相册列表
 */
@property (nonatomic , strong) NSMutableArray *groups;

@property (nonatomic , weak) id<MyAssetGroupControllerDelegate>delegate;

@end
