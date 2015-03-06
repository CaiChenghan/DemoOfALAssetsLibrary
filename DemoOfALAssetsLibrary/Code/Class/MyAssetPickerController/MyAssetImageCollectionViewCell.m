//
//  MyAssetImageCollectionViewCell.m
//  DemoOfALAssetsLibrary
//
//  Created by 蔡成汉 on 15/3/3.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "MyAssetImageCollectionViewCell.h"

@interface MyAssetImageCollectionViewCell ()
{
    NSIndexPath *myIndexPath;
}
@end

@implementation MyAssetImageCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initiaMyAssetImageCollectionViewCell];
    }
    return self;
}

-(void)initiaMyAssetImageCollectionViewCell
{
    //imageView
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.imageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.imageView];
    
    //selectIconImageView
    self.selectIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectIconButton.backgroundColor = [UIColor clearColor];
    self.selectIconButton.frame = CGRectMake(self.frame.size.height * 0.5, 0, self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    [self.selectIconButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.frame.size.height * 0.1, self.frame.size.height * 0.1, 0)];
    [self.selectIconButton addTarget:self action:@selector(selectIconButtonIsTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.selectIconButton];
}

/**
 *  对外方法，获取图片信息
 *
 *  @param asset 图片信息
 *  @param isSelect 是否为选中状态
 */
-(void)setMyAssetImageCollectionViewCellWithAsset:(ALAsset *)asset isSelect:(BOOL)isSelect indexPath:(NSIndexPath *)indexPath
{
    myIndexPath = indexPath;
    self.imageView.image = [UIImage imageWithCGImage:asset.thumbnail];
    if (isSelect == YES)
    {
        [self.selectIconButton setImage:[UIImage imageNamed:@"myAsset_selectImage"] forState:UIControlStateNormal];
        [self.selectIconButton setImage:[UIImage imageNamed:@"myAsset_selectImage"] forState:UIControlStateHighlighted];
    }
    else
    {
        [self.selectIconButton setImage:[UIImage imageNamed:@"myAsset_unselectImage"] forState:UIControlStateNormal];
        [self.selectIconButton setImage:[UIImage imageNamed:@"myAsset_unselectImage"] forState:UIControlStateHighlighted];
    }
}

/**
 *  选中按钮的点击事件
 *
 *  @param paramSender 选中按钮
 */
-(void)selectIconButtonIsTouchUpInside:(UIButton *)paramSender
{
    if ([self.delegate respondsToSelector:@selector(selectIconButtonIsTouch:)])
    {
        [self.delegate selectIconButtonIsTouch:myIndexPath];
    }
}

@end
