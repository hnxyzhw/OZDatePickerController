//
//  OZCycleScrollView.m
//  CycleScrollView
//
//  Created by StanOz on 10/15/15.
//  Copyright © 2015 Quzi. All rights reserved.
//

#import "OZCycleScrollView.h"

@interface OZCycleScrollView () {
    CGFloat rowHeight;
    NSInteger factor;
    NSInteger visibleRow;
    NSInteger totalDataRow;
    NSInteger visibleStartIndex;
}
@property (assign, nonatomic) BOOL isFirstAppear;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *visibleSubViews;
@end


// 2 extren row individually on top and bottom
static NSInteger externRow = 2;

@implementation OZCycleScrollView

@synthesize selectedIndex = _selectedIndex;

#pragma mark - initializer
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializer];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializer];
    }
    return self;
}

-(void)initializer {
    _isFirstAppear = YES;
    visibleStartIndex = 0;
    visibleRow = 5;
    factor = visibleRow + externRow;
    rowHeight = self.bounds.size.height / visibleRow;
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width, rowHeight * factor);
    _scrollView.contentOffset = CGPointMake(0, externRow + rowHeight);
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
}

#pragma mark - Custom Accessories
-(void)setDataSource:(id<OZCycleScrollViewDataSource>)dataSource {
    _dataSource = dataSource;
}

-(void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    visibleStartIndex = selectedIndex - visibleRow / 2;
}

-(NSInteger)selectedIndex {
    return _selectedIndex;
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY > externRow * rowHeight) {
        visibleStartIndex ++;
        [self reloadDataInPrivate];
    }
    
    if (offsetY < 0) {
        visibleStartIndex --;
        [self reloadDataInPrivate];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_scrollView.contentOffset.y == rowHeight) {
        [self delegatePerformDidSelectedRow];
        
    } else {
        [_scrollView setContentOffset:CGPointMake(0, rowHeight) animated:YES];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        if (_scrollView.contentOffset.y == rowHeight) {
            [self delegatePerformDidSelectedRow];
            
        } else {
            [_scrollView setContentOffset:CGPointMake(0, rowHeight) animated:YES];
        }
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self delegatePerformDidSelectedRow];
}

#pragma mark - Public
-(void)reloadData {
    [self delegatePerformNumberOfRow];
    if (totalDataRow == 0) {
        return;
    }
    [self loadData];
}

-(void)reloadDataThenPerformSelectedRow {
    [self reloadData];
    [self delegatePerformDidSelectedRow];
}

#pragma mark - Private
-(void)loadData {
    [self recenterIfNecessary];

    // remove all subViews
    NSArray *subViews = [_scrollView subviews];
    for (UIView *subView in subViews) {
        [subView removeFromSuperview];
    }
    
    [self loadSubViewsNeedDisplayToContainer];
    
    // reset subViews'frame
    for (NSInteger i = 0; i < _visibleSubViews.count; i++) {
        UIView *view = _visibleSubViews[i];
        [view setFrame:CGRectMake(0, rowHeight * i, _scrollView.bounds.size.width, rowHeight)];
        [_scrollView addSubview:view];
    }
 
    [self highlightSelectedView];
    if (_isFirstAppear) {
        _isFirstAppear = NO;
        [self delegatePerformDidSelectedRow];
    }
}

-(void)reloadDataInPrivate {
    if (_isFirstAppear) {
        [self delegatePerformNumberOfRow];
    }
    if (totalDataRow == 0) {
        return;
    }
    [self loadData];
}

-(void)loadSubViewsNeedDisplayToContainer {
    if (nil == _visibleSubViews) {
        _visibleSubViews = [NSMutableArray array];
    }
    [_visibleSubViews removeAllObjects];
    
    for (NSInteger i = 0; i < visibleRow + externRow; i++) {
        NSInteger index = [self calculateVaildIndex:i];
        if (i == visibleRow / 2 + 1) {
            _selectedIndex = index;
        }
        [_visibleSubViews addObject:[_dataSource cycleScrollView:self viewForRow:index]];
    }
}

-(NSInteger)calculateVaildIndex:(NSInteger)i {

    NSInteger index = visibleStartIndex + i;
    
    if (index < 0) {
        index += totalDataRow;
        if (index == 0) {
            visibleStartIndex = 0;
        }
    }

    if (index >= totalDataRow) {
        index = index % totalDataRow;
        if (visibleStartIndex == totalDataRow) {
            visibleStartIndex = 0;
        }
    }
    return index;
}

#pragma mark - Delegate Callback
-(void)highlightSelectedView {
    UIView *willSelectedView = _visibleSubViews[visibleRow / 2 + 1];
    if (_delegate && [_delegate respondsToSelector:@selector(cycleScrollView:viewWillBeSelected:)]) {
        [_delegate cycleScrollView:self viewWillBeSelected:willSelectedView];
    }
}

-(void)delegatePerformDidSelectedRow {
    if ((_delegate && [_delegate respondsToSelector:@selector(cycleScrollView:selectedRow:)])) {
        [_delegate cycleScrollView:self selectedRow:_selectedIndex];
    }
}

-(void)delegatePerformNumberOfRow {
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfRowsInScrollview:)]) {
        totalDataRow = [_dataSource numberOfRowsInScrollview:self];
    }
}

#pragma mark - Layout
-(void)layoutSubviews {
    [super layoutSubviews];
    
    /*
     *  resize scrollView if layout is changed
     */
    [_scrollView setFrame:self.bounds];
    rowHeight = self.bounds.size.height / visibleRow;
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width, rowHeight * factor);
    [self reloadData];
}


- (void)recenterIfNecessary {
    _scrollView.contentOffset = CGPointMake(0, externRow + rowHeight);
}
@end
