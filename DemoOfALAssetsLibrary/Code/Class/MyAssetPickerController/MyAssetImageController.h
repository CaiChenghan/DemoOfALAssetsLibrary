//
//  MyAssetImageController.h
//  DemoOfALAssetsLibrary
//
//  Created by 蔡成汉 on 15/3/3.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class MyAssetImageController;

@protocol MyAssetImageControllerDelegate <NSObject>

@optional

/**
 *  完成图片选择
 *
 *  @param controller 当前的图片选择器
 *  @param imageArray 图片数组
 */
-(void)myAssetImageController:(MyAssetImageController *)controller didFinishSelectImage:(NSArray *)imageArray;

/**
 *  选择图片出错
 *
 *  @param controller 当前的图片选择器
 *  @param error      错误信息
 */
-(void)myAssetImageController:(MyAssetImageController *)controller selectImageWithError:(NSError *)error;

/**
 *  用户取消选择
 *
 *  @controller 当前的视图控制器
 */
-(void)didCancleSelect:(MyAssetImageController *)controller;

@end

@interface MyAssetImageController : UIViewController

/**
 *  最大图片选择数量
 */
@property (nonatomic , assign) int maxSelectItem;

/**
 *  单个相册
 */
@property (nonatomic , strong) ALAssetsGroup *assetsGroup;

@property (nonatomic , weak) id<MyAssetImageControllerDelegate>delegate;

@end
