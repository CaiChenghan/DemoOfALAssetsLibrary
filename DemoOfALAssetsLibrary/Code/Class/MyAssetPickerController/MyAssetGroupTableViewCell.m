//
//  MyAssetGroupTableViewCell.m
//  DemoOfALAssetsLibrary
//
//  Created by 蔡成汉 on 15/3/3.
//  Copyright (c) 2015年 JW. All rights reserved.
//

#import "MyAssetGroupTableViewCell.h"

@implementation MyAssetGroupTableViewCell


/**
 *  对外方法，获取单个相册列表内容
 *
 *  @param group 单个相册列表信息
 */
-(void)setMyAssetGroupTableViewCellWithAssetsGroup:(ALAssetsGroup *)group
{
    CGImageRef posterImage      = group.posterImage;
    float scale                 = 2.0;
    self.imageView.image        = [UIImage imageWithCGImage:posterImage scale:scale orientation:UIImageOrientationUp];
    self.textLabel.text         = [group valueForProperty:ALAssetsGroupPropertyName];
    self.detailTextLabel.text   = [NSString stringWithFormat:@"%ld",(long)[group numberOfAssets]];
    self.detailTextLabel.font = [UIFont systemFontOfSize:12];
    self.accessoryType          = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
