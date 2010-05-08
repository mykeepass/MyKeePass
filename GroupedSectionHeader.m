//
//  SectionHeader.m
//  MyKeePass
//
//  Created by Qiang Yu on 3/3/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import "GroupedSectionHeader.h"


@implementation GroupedSectionHeader
@synthesize _label;
@synthesize _button;

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
		_label = [[UILabel alloc]initWithFrame:CGRectMake(15, 8, 270, 30)];
		_label.backgroundColor = [UIColor clearColor];
		_label.font = [UIFont boldSystemFontOfSize:16];
		_label.textColor = [UIColor blackColor];
		[self addSubview:_label];
				
		_button = [UIButton buttonWithType:UIButtonTypeCustom];
		_button.frame = CGRectMake(278, 12, 30, 30);
		[_button setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];	
		[_button setImage:[UIImage imageNamed:@"addPressed.png"] forState:UIControlStateSelected];			
		[self addSubview:_button];		
		
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	[_label release];
	//[_button release];
    [super dealloc];
}

@end
