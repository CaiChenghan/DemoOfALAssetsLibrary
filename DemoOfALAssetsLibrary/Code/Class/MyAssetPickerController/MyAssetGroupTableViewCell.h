//
//  MyAssetGroupTableViewCell.h
//  DemoOfALAssetsLibrary
//
//  Created by 蔡成汉 on 15/3/3.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface MyAssetGroupTableViewCell : UITableViewCell

/**
 *  对外方法，获取单个相册列表内容
 *
 *  @param group 单个相册列表信息
 */
-(void)setMyAssetGroupTableViewCellWithAssetsGroup:(ALAssetsGroup *)group;

@end
