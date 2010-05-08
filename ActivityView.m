//
//  ActivityView.m
//  MyKeePass
//
//  Created by Qiang Yu on 3/18/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import "ActivityView.h"


@implementation ActivityView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor blackColor];
		self.alpha = 0.55;
		UIActivityIndicatorView * view = [[UIActivityIndicatorView alloc] 
										  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		view.center = CGPointMake(160, 97);
		[view startAnimating];
		[self addSubview:view];
		[view release];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}


@end
