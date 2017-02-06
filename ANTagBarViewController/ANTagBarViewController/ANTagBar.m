//
//  ANTagBar.m
//  ANTagBarViewController
//
//  Created by JasonZhang on 2017/1/18.
//  Copyright © 2017年 wscn. All rights reserved.
//

#import "ANTagBar.h"

@implementation ANTagBarItem

- (instancetype)initWithTitle:(NSString *)title
             normalTitleColor:(UIColor *)normalTitleColor
           selectedTitleColor:(UIColor *)selectedTitleColor
{
    self = [super init];
    if (self) {
        self.title = title;
        self.normalTitleColor = normalTitleColor;
        self.selectedTitleColor = selectedTitleColor;
    }
    return self;
}

@end


#define ANTagBarButtonTagFlag 9527
@interface ANTagBar ()

@property (nonatomic, strong) NSMutableArray *tagBarButtons;

@property (nonatomic, strong) NSMutableArray *tagBarButtonsContentWidth;

@property (nonatomic, strong) UIScrollView *tagBarScrollView;

@property (nonatomic, strong) UIView *bottomBorderLine;

@property (nonatomic, strong) UIView *indicatorView;

@end

@implementation ANTagBar
{
    struct {
        unsigned int didSelectedAtIndex : 1;
    } _delegateFlags;
}

#pragma mark -- setter && getter
- (NSMutableArray *)tagBarButtons
{
    if (_tagBarButtons == nil) {
        _tagBarButtons = [NSMutableArray array];
    }
    return _tagBarButtons;
}

- (NSMutableArray *)tagBarButtonsContentWidth
{
    if (_tagBarButtonsContentWidth == nil) {
        _tagBarButtonsContentWidth = [NSMutableArray array];
    }
    return _tagBarButtonsContentWidth;
}

- (void)setDelegate:(id<ANTagBarDelegate>)delegate
{
    _delegate = delegate;
    _delegateFlags.didSelectedAtIndex = _delegate && [_delegate respondsToSelector:@selector(tagBar:didSelectedAtIndex:)];
}

- (void)setTitleFont:(UIFont *)titleFont
{
    if (_titleFont != titleFont) {
        _titleFont = titleFont;
        for (UIButton *tagBarButton in self.tagBarButtons) {
            tagBarButton.titleLabel.font = _titleFont;
        }
        for (ANTagBarItem *item in self.tagBarItems) {
            item.titleFont = _titleFont;
        }
    }
}

- (void)setNormalTitleColor:(UIColor *)normalTitleColor
{
    if (_normalTitleColor != normalTitleColor) {
        _normalTitleColor = normalTitleColor;
        for (UIButton *tagBarButton in self.tagBarButtons) {
            [tagBarButton setTitleColor:_normalTitleColor forState:UIControlStateNormal];
        }
        for (ANTagBarItem *item in self.tagBarItems) {
            item.normalTitleColor = _normalTitleColor;
        }
    }
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor
{
    if (_selectedTitleColor != selectedTitleColor) {
        _selectedTitleColor = selectedTitleColor;
        for (UIButton *tagBarButton in self.tagBarButtons) {
            [tagBarButton setTitleColor:_selectedTitleColor forState:UIControlStateSelected];
        }
        for (ANTagBarItem *item in self.tagBarItems) {
            item.selectedTitleColor = _selectedTitleColor;
        }
    }
}

- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    if (_indicatorColor != indicatorColor) {
        _indicatorColor = indicatorColor;
        self.indicatorView.backgroundColor = _indicatorColor;
    }
}

- (void)setBottomBorderColor:(UIColor *)bottomBorderColor
{
    if (_bottomBorderColor != bottomBorderColor) {
        _bottomBorderColor = bottomBorderColor;
        self.bottomBorderLine.backgroundColor = _bottomBorderColor;
    }
}

- (void)setTagBarItems:(NSArray<ANTagBarItem *> *)tagBarItems
{
    _tagBarItems = tagBarItems;
    
    if (_tagBarItems.count > 0) {
        switch (self.tagBarStyle) {
            case ANTagBarStyleBottomFixedWidth:
                self.tagBarButtonWidth = self.frame.size.width / _tagBarItems.count;
                break;
            case ANTagBarStyleBottomFreedomWidth:
                break;
            default:
                break;
        }
    }
    [self configTagBarScrollView];
    [self configTagBarButtons];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
        [self initTagBarScrollView];
        [self initIndicatorView];
        [self initBottomBorderLine];
    }
    return self;
}

- (void)initialize
{
    self.titleFont = [UIFont systemFontOfSize:14.f];
    self.normalTitleColor = [UIColor lightGrayColor];
    self.selectedTitleColor = [UIColor redColor];
    self.bottomBorderColor = [UIColor lightGrayColor];
    self.indicatorColor = [UIColor redColor];
}

- (void)initTagBarScrollView
{
    self.tagBarScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.tagBarScrollView.showsVerticalScrollIndicator = NO;
    self.tagBarScrollView.showsHorizontalScrollIndicator = NO;
    self.tagBarScrollView.bounces = NO;
    [self addSubview:self.tagBarScrollView];
}

- (void)initIndicatorView
{
    self.indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 2.f, 0, 2.f)];
    self.indicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.indicatorView.backgroundColor = self.indicatorColor;
    [self.tagBarScrollView addSubview:self.indicatorView];
}

- (void)initBottomBorderLine
{
    self.bottomBorderLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 0.5f, self.bounds.size.width, 0.5f)];
    self.bottomBorderLine.backgroundColor = self.bottomBorderColor;
    [self addSubview:self.bottomBorderLine];
}

- (void)configTagBarScrollView
{
    CGFloat contentWidth = self.tagBarButtonWidth * self.tagBarItems.count;
    if (contentWidth <= self.frame.size.width) {
        self.tagBarButtonWidth = self.frame.size.width / _tagBarItems.count;
        self.tagBarScrollView.contentSize = self.bounds.size;
    } else {
        self.tagBarScrollView.contentSize = CGSizeMake(contentWidth, self.tagBarScrollView.bounds.size.height);
    }
}

- (void)configTagBarButtons
{
    for (NSInteger index = 0; index < self.tagBarItems.count; index++) {
        ANTagBarItem *tagBarItem = self.tagBarItems[index];
        UIButton *tagBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tagBarButton.tag = index + ANTagBarButtonTagFlag;
        tagBarButton.frame = CGRectMake(index * self.tagBarButtonWidth, 0, self.tagBarButtonWidth, self.tagBarScrollView.bounds.size.height);
        [tagBarButton addTarget:self action:@selector(tagBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self configTagBarButton:tagBarButton withTagBarItem:tagBarItem];
        [self.tagBarScrollView addSubview:tagBarButton];
        
        CGFloat contentWidht = [self adjustedContentWidthForTagBarButton:tagBarButton];
        [self.tagBarButtonsContentWidth addObject:[NSNumber numberWithFloat:contentWidht]];
        
        if (index == self.selectedIndex) {
            self.indicatorView.frame = CGRectMake(tagBarButton.frame.origin.x + (tagBarButton.frame.size.width - contentWidht) / 2, self.indicatorView.frame.origin.y, contentWidht, self.indicatorView.frame.size.height);
        }
        
        tagBarButton.selected = self.selectedIndex == index;
        [self.tagBarButtons addObject:tagBarButton];
    }
}

- (void)configTagBarButton:(UIButton *)tagBarButton withTagBarItem:(ANTagBarItem *)tagBarItem
{
    [tagBarButton addTarget:self action:@selector(tagBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    tagBarButton.backgroundColor = [UIColor clearColor];
    [tagBarButton setTitleColor:(tagBarItem.normalTitleColor == nil ? self.normalTitleColor : tagBarItem.normalTitleColor) forState:UIControlStateNormal];
    [tagBarButton setTitleColor:(tagBarItem.selectedTitleColor == nil ? self.selectedTitleColor : tagBarItem.selectedTitleColor) forState:UIControlStateSelected];
    tagBarButton.titleLabel.font = tagBarItem.titleFont == nil ? self.titleFont : tagBarItem.titleFont;
    tagBarButton.titleEdgeInsets = tagBarItem.titleInsets;
    [tagBarButton setTitle:tagBarItem.title forState:UIControlStateNormal];
}

- (CGFloat)adjustedContentWidthForTagBarButton:(UIButton *)tagBarButton
{
    CGFloat contentWidth = [[tagBarButton titleForState:UIControlStateNormal] sizeWithAttributes:@{NSFontAttributeName : tagBarButton.titleLabel.font}].width;
    return contentWidth;
}

- (void)setTagBarScrollViewContentOffsetWithFactor:(NSInteger)factor
{
    CGPoint contentOffset = self.tagBarScrollView.contentOffset;
    CGFloat nextOffsetX = factor * self.tagBarButtonWidth + 2 * self.tagBarButtonWidth - self.tagBarScrollView.frame.size.width;
    CGFloat previousOffsetX = factor * self.tagBarButtonWidth - self.tagBarButtonWidth;
    if (nextOffsetX > self.tagBarScrollView.contentOffset.x){
        contentOffset = CGPointMake(nextOffsetX, 0);
    } else if (previousOffsetX < self.tagBarScrollView.contentOffset.x){
        contentOffset = CGPointMake(previousOffsetX, 0);
    }
    
    if (contentOffset.x < 0){
        contentOffset.x = 0.f;
    }
    else if (contentOffset.x > self.tagBarScrollView.contentSize.width - self.tagBarScrollView.frame.size.width){
        contentOffset.x = self.tagBarScrollView.contentSize.width - self.tagBarScrollView.frame.size.width;
    }
    [self.tagBarScrollView setContentOffset:contentOffset animated:YES];
}

- (void)layoutIndicatorWithFactor:(NSInteger)factor
{
    if (self.tagBarButtonsContentWidth.count <= 0) {
        return;
    }
    
    UIButton *tagBarButton = self.tagBarButtons[factor];
    CGRect indicatorFrame = self.indicatorView.frame;
    indicatorFrame.size.width = [self.tagBarButtonsContentWidth[factor] floatValue];
    indicatorFrame.origin.x = tagBarButton.frame.origin.x + (tagBarButton.frame.size.width - [self.tagBarButtonsContentWidth[factor] floatValue]) / 2.f;
    [UIView animateWithDuration:0.2f animations:^{
        self.indicatorView.frame = indicatorFrame;
    }];
}

#pragma mark -- events
- (void)tagBarButtonClick:(UIButton *)tagBarButton
{
    [self setIndicatorPositionFactor:tagBarButton.tag - ANTagBarButtonTagFlag];
    if (_delegateFlags.didSelectedAtIndex) {
        [_delegate tagBar:self didSelectedAtIndex:tagBarButton.tag - ANTagBarButtonTagFlag];
    }
}

#pragma mark -- public
- (UIView *)tagBarButtonAtIndex:(NSInteger)index
{
    return self.tagBarButtons[index];
}

- (void)setIndicatorPositionFactor:(NSInteger)factor
{
    self.selectedIndex = factor;
    if (self.tagBarStyle == ANTagBarStyleBottomFreedomWidth) {
        [self setTagBarScrollViewContentOffsetWithFactor:factor];
    }
    [self layoutIndicatorWithFactor:factor];
    
    for (NSInteger index = 0; index < self.tagBarButtons.count; index++) {
        UIButton *tagBarButton = self.tagBarButtons[index];
        tagBarButton.selected = self.selectedIndex == index;
    }
}

@end
