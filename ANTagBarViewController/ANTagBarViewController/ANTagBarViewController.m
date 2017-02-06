//
//  ANTagBarViewController.m
//  ANTagBarViewController
//
//  Created by JasonZhang on 2017/1/18.
//  Copyright © 2017年 wscn. All rights reserved.
//

#import "ANTagBarViewController.h"
#import <objc/runtime.h>

@interface ANTagBarViewController ()<UIScrollViewDelegate, ANTagBarDelegate>

// 当前选中的子视图控制器
@property (nonatomic, strong) UIViewController *selectedViewController;

@end

@implementation ANTagBarViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tagBar = [[ANTagBar alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.hidden ? 0.f : 64.f, [UIScreen mainScreen].bounds.size.width, 44.f)];
    }
    return self;
}

#pragma mark -- setter && getter
- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers
{
    _viewControllers = viewControllers;
    for (UIViewController *controller in viewControllers) {
        controller.tagBarController = self;
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex == selectedIndex) {
        return;
    }
    
    if (self.viewControllers.count <= 0) {
        return;
    }
    
    if (selectedIndex < 0 || selectedIndex >= self.viewControllers.count) {
        return;
    }
    
    _selectedIndex = selectedIndex;
    
    if (self.isViewLoaded) {
        [self scrollToSelectedIndex];
    }
}

- (UIViewController *)selectedViewController
{
    return self.viewControllers[self.selectedIndex];
}

#pragma mark -- lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initSubViews];
    
    [self addSubViewControllers];
    
    [self scrollToSelectedIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- private
- (void)initSubViews
{
    [self initTagBar];
    [self initScrollView];
}

- (void)initTagBar
{
    self.tagBar.backgroundColor = [UIColor whiteColor];
    self.tagBar.delegate = self;
    [self.view addSubview:self.tagBar];
    
    NSMutableArray *tagBarItems = [NSMutableArray array];
    
    for (NSInteger index = 0; index < self.viewControllers.count; index++) {
        UIViewController *controller = self.viewControllers[index];
        ANTagBarItem *tagBarItem = controller.tagBarItem;
        if (tagBarItem == nil) {
            tagBarItem = [[ANTagBarItem alloc] initWithTitle:[NSString stringWithFormat:@"item%ld", index] normalTitleColor:nil selectedTitleColor:nil];
        }
        [tagBarItems addObject:tagBarItem];
    }
    [self.tagBar setTagBarItems:[NSArray arrayWithArray:tagBarItems]];
}

- (void)initScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tagBar.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.tagBar.frame))];
    self.scrollView.scrollsToTop = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * self.viewControllers.count, self.scrollView.bounds.size.height);
    [self.view addSubview:self.scrollView];
}

- (void)addSubViewControllers
{
    for (NSInteger index = 0; index < self.viewControllers.count; index++) {
        UIViewController *controller = self.viewControllers[index];
        [self addChildViewController:controller];
    }
}

- (void)scrollToSelectedIndex
{
    [self.tagBar setIndicatorPositionFactor:self.selectedIndex];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width * self.selectedIndex, 0) animated:NO];
    [self addChildViewAtIndex:self.selectedIndex];
}

- (void)addChildViewAtIndex:(NSInteger)index
{
    UIViewController *controller = self.childViewControllers[index];
    controller.view.frame = CGRectMake(self.scrollView.bounds.size.width * index, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    [self.scrollView addSubview:controller.view];
}

#pragma mark -- delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger factor = floor(scrollView.contentOffset.x / scrollView.bounds.size.width);
    self.selectedIndex = factor;
    [self.tagBar setIndicatorPositionFactor:factor];
    
    [self addChildViewAtIndex:factor];
}

- (void)tagBar:(ANTagBar *)tagBar didSelectedAtIndex:(NSInteger)index
{
    self.selectedIndex = index;
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width * index, 0) animated:YES];
    
    [self addChildViewAtIndex:index];
}

@end


static NSString *const tagBarItemKey = @"ANTagBarItemKey";
static NSString *const tagBarControllerKey = @"ANTagBarControllerKey";

@implementation UIViewController (ANTabBarControllerItem)

- (void)setTagBarItem:(ANTagBarItem *)tagBarItem
{
    objc_setAssociatedObject(self, &tagBarItemKey, tagBarItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ANTagBarItem *)tagBarItem
{
    return objc_getAssociatedObject(self, &tagBarItemKey);
}

- (void)setTagBarController:(ANTagBarViewController *)tagBarController
{
    objc_setAssociatedObject(self, &tagBarControllerKey, tagBarController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ANTagBarViewController *)tagBarController
{
    return objc_getAssociatedObject(self, &tagBarControllerKey);
}

@end
