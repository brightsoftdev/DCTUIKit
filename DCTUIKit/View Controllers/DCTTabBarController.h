//
//  DCTTabBarController.h
//  DTKit
//
//  Created by Daniel Tull on 29.09.2009.
//  Copyright 2009 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCTContentViewController.h"
#import "DCTTabBar.h"

@protocol DCTTabBarControllerDelegate;

@interface DCTTabBarController : DCTContentViewController <DCTTabBarDelegate> {
	
	BOOL viewIsLoaded;
	
	id<DCTTabBarControllerDelegate> delegate;
	
	NSUInteger selectedIndex;
}

@property (nonatomic, assign) UIViewController *selectedViewController;
@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, retain) DCTTabBar *tabBar;

@property (nonatomic, assign) NSObject<DCTTabBarControllerDelegate> *delegate;
- (id)initWithViewControllers:(NSArray *)vcs;
@end

@protocol DCTTabBarControllerDelegate <NSObject>
@optional
- (void)DCTTabBarController:(DCTTabBarController *)DCTTabBarController didSelectViewController:(UIViewController *)viewController;
@end

