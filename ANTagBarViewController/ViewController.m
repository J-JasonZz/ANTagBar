//
//  ViewController.m
//  ANTagBarViewController
//
//  Created by JasonZhang on 2017/1/18.
//  Copyright © 2017年 wscn. All rights reserved.
//

#import "ViewController.h"
#import "ANTagBarViewController.h"

#import "DemoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)buttonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 1000) {
        ANTagBarViewController *tagBarController = [[ANTagBarViewController alloc] init];
        tagBarController.tagBar.tagBarStyle = ANTagBarStyleBottomFixedWidth;
        tagBarController.hidesBottomBarWhenPushed = YES;
        NSMutableArray *viewControllers = [NSMutableArray array];
        NSArray *titleArray = @[@"xx", @"擦擦擦擦擦擦", @"123456"];
        for (NSInteger index = 0; index < titleArray.count; index++) {
            
            ANTagBarItem *item = [[ANTagBarItem alloc] initWithTitle:titleArray[index] normalTitleColor:nil selectedTitleColor:nil];
            DemoViewController *controller = [[DemoViewController alloc] init];
            controller.tagBarItem = item;
            [viewControllers addObject:controller];
        }
        tagBarController.viewControllers = viewControllers;
        tagBarController.selectedIndex = 1;
        [self.navigationController pushViewController:tagBarController animated:YES];

    }
    
    if (button.tag == 1001) {
        ANTagBarViewController *tagBarController = [[ANTagBarViewController alloc] init];
        tagBarController.tagBar.tagBarStyle = ANTagBarStyleBottomFreedomWidth;
        tagBarController.tagBar.tagBarButtonWidth = 60.f;
        tagBarController.hidesBottomBarWhenPushed = YES;
        NSMutableArray *viewControllers = [NSMutableArray array];
        for (NSInteger index = 0; index < 10; index++) {
            DemoViewController *controller = [[DemoViewController alloc] init];
            [viewControllers addObject:controller];
        }
        tagBarController.viewControllers = viewControllers;
        [self.navigationController pushViewController:tagBarController animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
