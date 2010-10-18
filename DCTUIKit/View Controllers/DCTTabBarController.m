//
//  DCTTabBarController.m
//  DTKit
//
//  Created by Daniel Tull on 29.09.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import "DCTTabBarController.h"
#import "UIView+DCTSubviewExtensions.h"

NSInteger const DCTTabBarUnselectedIndex = -1;

@interface DCTTabBarController ()
- (void)dctInternal_setUpTabBarItems;
- (void)dctInternal_sendDelegateMessageDidSelectViewController:(UIViewController *)viewController;
@end


@implementation DCTTabBarController

@synthesize viewControllers, selectedIndex, delegate, tabBar;

#pragma mark -
#pragma mark NSObject

- (void)dealloc {
	[tabBar release];
	[viewControllers release];
    [super dealloc];
}

- (id)initWithViewControllers:(NSArray *)vcs {
	
	if (!(self = [self init])) return nil;
	
	viewControllers = [vcs retain];
	self.position = DCTContentBarPositionBottom;
	selectedIndex = DCTTabBarUnselectedIndex;
	
	return self;
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidUnload {
	[super viewDidUnload];
	viewIsLoaded = NO;
}

- (void)viewDidLoad {
	[self dctInternal_setUpTabBarItems];
	self.barView = self.tabBar;
	if (self.selectedIndex == DCTTabBarUnselectedIndex) self.selectedIndex = 0;
	self.tabBar.selectedItem = [self.tabBar.items objectAtIndex:self.selectedIndex];
	self.tabBar.delegate = self;
	[super viewDidLoad];
	[self loadContentView];
	viewIsLoaded = YES;
}

- (void)didReceiveMemoryWarning {
	NSMutableArray *array = [viewControllers mutableCopy];
	[array removeObject:self.selectedViewController];
	for (UIViewController *vc in array)
		[vc didReceiveMemoryWarning];
	[array release];
	[super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.selectedViewController viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.selectedViewController viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.selectedViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self.selectedViewController viewDidDisappear:animated];
}

#pragma mark -
#pragma mark Public methods

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated {
	[self setBarHidden:hidden animated:animated];
}



- (void)loadContentView {
	[self.contentView dct_removeAllSubviews];
	self.selectedViewController.view.frame = self.contentView.bounds;
	[self.contentView addSubview:self.selectedViewController.view];	
}

#pragma mark -
#pragma mark Accessors

- (void)setSelectedIndex:(NSUInteger)integer {
	selectedIndex = integer;
	if (viewIsLoaded) {
		//UIViewController *selectedViewController = self.selectedViewController;
		//selectedViewController.view.frame = self.contentView.bounds;
		self.title = self.selectedViewController.title;
		[self loadContentView];
	}
}

- (UIViewController *)selectedViewController {
	if (self.selectedIndex == DCTTabBarUnselectedIndex) self.selectedIndex = 0;
	return [viewControllers objectAtIndex:self.selectedIndex];
}

- (void)setSelectedViewController:(UIViewController *)vc {
	self.selectedIndex = [viewControllers indexOfObject:vc];
}

- (void)setTabBar:(DCTTabBar *)aTabBar {
	[tabBar release];
	tabBar = [aTabBar retain];
	self.barView = tabBar;
	[self dctInternal_setUpTabBarItems];
}

- (DCTTabBar *)tabBar {
	if (!tabBar) tabBar = [[DCTTabBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 44.0)];
	return tabBar;
}

#pragma mark -
#pragma mark DCTTabBarDelegate

- (void)tabBar:(DCTTabBar *)tab didSelectItem:(UITabBarItem *)item {
	self.selectedIndex = [tab.items indexOfObject:item];
	[self dctInternal_sendDelegateMessageDidSelectViewController:self.selectedViewController];
}

#pragma mark -
#pragma mark Internal methods

- (void)dctInternal_setUpTabBarItems {
	NSMutableArray *tempItems = [[NSMutableArray alloc] init];
	for (UIViewController *vc in self.viewControllers)
		[tempItems addObject:vc.tabBarItem];
	self.tabBar.items = tempItems;
	[tempItems release];
}

- (void)dctInternal_sendDelegateMessageDidSelectViewController:(UIViewController *)vc {
	if ([self.delegate respondsToSelector:@selector(DCTTabBarController:didSelectViewController:)])
		[self.delegate DCTTabBarController:self didSelectViewController:vc];
}

@end
