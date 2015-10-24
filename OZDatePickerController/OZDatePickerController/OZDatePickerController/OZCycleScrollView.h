//
//  OZCycleScrollView.h
//  CycleScrollView
//
//  Created by StanOz on 10/15/15.
//  Copyright © 2015 Quzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OZCycleScrollViewDataSource;
@protocol OZCycleScrollViewDelegate;

@interface OZCycleScrollView : UIView <UIScrollViewDelegate>

@property (assign, nonatomic, readonly) NSInteger selectedIndex;
@property (weak, nonatomic) id <OZCycleScrollViewDataSource> dataSource;
@property (weak, nonatomic) id <OZCycleScrollViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame;
-(instancetype)initWithCoder:(NSCoder *)aDecoder;
-(void)setSelectedIndex:(NSInteger)selectedIndex;
-(void)reloadData;
-(void)reloadDataThenPerformSelectedRow;
@end


@protocol OZCycleScrollViewDataSource <NSObject>
@required
-(NSInteger)numberOfRowsInScrollview:(OZCycleScrollView *)sv;
-(UIView *)cycleScrollView:(OZCycleScrollView *)sv viewForRow:(NSInteger )index;
@end


@protocol OZCycleScrollViewDelegate <NSObject>
@optional
-(void)cycleScrollView:(OZCycleScrollView *)sv selectedRow:(NSInteger)row;
-(void)cycleScrollView:(OZCycleScrollView *)sv viewWillBeSelected:(UIView *)view;
@end