/*
 DCTTabBar.m
 DCTUIKit
 
 Created by Daniel Tull on 29.09.2009.
 
 
 
 Copyright (c) 2009 Daniel Tull. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "DCTTabBar.h"
#import "UIView+DCTSubviewExtensions.h"

@implementation DCTTabBar

@synthesize selectedItem, items, delegate, itemHitAreas;

#pragma mark - 
#pragma mark NSObject

- (void)dealloc {
	[itemHitAreas release];
	[items release];
	[selectedItem release];
	[super dealloc];
}

- (id)initWithFrame:(CGRect)rect {
    if (!(self = [super initWithFrame:rect])) return nil;
	
	items = [[NSArray alloc] init];
	itemHitAreas = [[NSArray alloc] init];
	
    return self;
}

#pragma mark - 
#pragma mark UIView

- (void)drawRect:(CGRect)rect {
	
	[self dct_removeAllSubviews];
	
	self.backgroundColor = [UIColor blackColor]; 
	
	CGFloat width = self.frame.size.width / [self.items count];
	
	NSMutableArray *tempHitAreas = [[NSMutableArray alloc] init];
	CGFloat position;
	for (UITabBarItem *i in self.items) {
		
		NSLog(@"%@:%@ %@", self, NSStringFromSelector(_cmd), i.title);
		
		NSInteger intWidth = (NSInteger)width;
		NSInteger intPosition = (NSInteger)position;
		
		UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake((CGFloat)intPosition, 0.0, (CGFloat)intWidth, self.frame.size.height)];
		l.text = i.title;
		l.font = [UIFont boldSystemFontOfSize:14.0];
		l.backgroundColor = self.backgroundColor;
		
		if (i == self.selectedItem)		
			l.textColor = [UIColor yellowColor];
		else
			l.textColor = [UIColor grayColor];
		
		l.textAlignment = UITextAlignmentCenter;
		[self addSubview:l];	
		[tempHitAreas addObject:[NSValue valueWithCGRect:l.frame]];
		position += width;
	}
	self.itemHitAreas = tempHitAreas;
	[tempHitAreas release];	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *theTouch = [touches anyObject];
	
	CGPoint point = [theTouch locationInView:self];
	
	for (NSValue *v in self.itemHitAreas) {
		
		CGRect r = [v CGRectValue];
		
		if (point.x >= r.origin.x 
			&& point.y >= r.origin.y 
			&& point.x <= (r.origin.x + r.size.width) 
			&& point.y <= (r.origin.y + r.size.height)) {
			
			NSInteger index = [self.itemHitAreas indexOfObject:v];
			self.selectedItem = [self.items objectAtIndex:index];
			[self.delegate dctTabBar:self didSelectItem:self.selectedItem];
			return;
		}
	}
}

- (void)setSelectedItem:(UITabBarItem *)anItem {
	
	if (!anItem || selectedItem == anItem) return;
	
	[selectedItem release];
	selectedItem = [anItem retain];
	[self setNeedsDisplay];	
}

@end
