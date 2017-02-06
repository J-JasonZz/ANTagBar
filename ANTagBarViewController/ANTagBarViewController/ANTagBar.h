//
//  ANTagBar.h
//  ANTagBarViewController
//
//  Created by JasonZhang on 2017/1/18.
//  Copyright © 2017年 wscn. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ANTagBarItem : NSObject

// 标题
@property (nonatomic, copy) NSString *title;

// 标题字体
@property (nonatomic, strong) UIFont *titleFont;

// 标题颜色(正常)
@property (nonatomic, strong) UIColor *normalTitleColor;

// 标题颜色(选中)
@property (nonatomic, strong) UIColor *selectedTitleColor;

// 标题内边距
@property (nonatomic, assign) UIEdgeInsets titleInsets;


- (instancetype)initWithTitle:(NSString *)title
             normalTitleColor:(UIColor *)normalTitleColor
           selectedTitleColor:(UIColor *)selectedTitleColor;

@end


@class ANTagBar;

@protocol ANTagBarDelegate <NSObject>

@optional
- (void)tagBar:(ANTagBar *)tagBar didSelectedAtIndex:(NSInteger)index;

@end

typedef NS_ENUM(NSInteger, ANTagBarStyle){
    ANTagBarStyleBottomFixedWidth,   //指示条在下面，宽度为整个屏幕宽度除以tag button的个数
    ANTagBarStyleBottomFreedomWidth  //指示条在下面，宽度为手动指定,tagBar的宽度可以超过一个屏幕
};

@interface ANTagBar : UIView

// tagBar的代理, ->tagBarController
@property (nonatomic, weak) id<ANTagBarDelegate> delegate;

// 所有的数据源
@property (nonatomic, strong) NSArray<ANTagBarItem *> *tagBarItems;

// 模式
@property (nonatomic, assign) ANTagBarStyle tagBarStyle;

// 标题字体
@property (nonatomic, strong) UIFont *titleFont;

// 标题颜色(正常)
@property (nonatomic, strong) UIColor *normalTitleColor;

// 标题颜色(选中)
@property (nonatomic, strong) UIColor *selectedTitleColor;

// 指示器颜色
@property (nonatomic, strong) UIColor *indicatorColor;

// 底部线颜色
@property (nonatomic, strong) UIColor *bottomBorderColor;

// 自定义的宽度(ECTagBarStyleBottomFreedomWidth模式下有效)
@property (nonatomic, assign) CGFloat tagBarButtonWidth;

// 当前选中的位置
@property (nonatomic, assign) NSInteger selectedIndex;


// 当前选中视图
- (UIView *)tagBarButtonAtIndex:(NSInteger)index;
// 切换tag
- (void)setIndicatorPositionFactor:(NSInteger)factor;

@end
