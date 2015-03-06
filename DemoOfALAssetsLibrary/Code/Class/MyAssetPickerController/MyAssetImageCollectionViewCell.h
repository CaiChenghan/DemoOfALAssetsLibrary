//
//  MyAssetImageCollectionViewCell.h
//  DemoOfALAssetsLibrary
//
//  Created by 蔡成汉 on 15/3/3.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol MyAssetImageCollectionViewCellDelegate <NSObject>

@required

/**
 *  选中按钮的委托
 *
 *  @param indexPath 当前cell的indexPath
 */
-(void)selectIconButtonIsTouch:(NSIndexPath *)indexPath;

@end

@interface MyAssetImageCollectionViewCell : UICollectionViewCell

/**
 *  用于显示单个图片的imageView
 */
@property (nonatomic , strong) UIImageView *imageView;

/**
 *  图片选中标记
 */
@property (nonatomic , strong) UIButton *selectIconButton;


@property (nonatomic , weak) id<MyAssetImageCollectionViewCellDelegate>delegate;

/**
 *  对外方法，获取图片信息
 *
 *  @param asset 图片信息
 *  @param isSelect 是否为选中状态
 *  @param indexPath cell的indexPath
 */
-(void)setMyAssetImageCollectionViewCellWithAsset:(ALAsset *)asset isSelect:(BOOL)isSelect indexPath:(NSIndexPath *)indexPath;

@end
