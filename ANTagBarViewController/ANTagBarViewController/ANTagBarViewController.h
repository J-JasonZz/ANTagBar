//
//  ANTagBarViewController.h
//  ANTagBarViewController
//
//  Created by JasonZhang on 2017/1/18.
//  Copyright © 2017年 wscn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANTagBar.h"

@interface ANTagBarViewController : UIViewController

// tagBar
@property (nonatomic, strong) ANTagBar *tagBar;

// 所有子视图控制器
@property (nonatomic, strong) NSArray<UIViewController *> *viewControllers;

// 内容滚动视图
@property (nonatomic ,strong) UIScrollView *scrollView;

// 当前选中位置
@property (nonatomic, assign) NSInteger selectedIndex;

// 当前选中的子视图控制器
@property (nonatomic, strong, readonly) UIViewController *selectedViewController;

@end

@interface UIViewController (ANTabBarControllerItem)

@property (nonatomic, strong) ANTagBarItem *tagBarItem;

@property (nonatomic, strong) ANTagBarViewController *tagBarController;

@end
