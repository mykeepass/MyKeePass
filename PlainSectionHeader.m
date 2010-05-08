//
//  PlainSectionHeader.m
//  MyKeePass
//
//  Created by Qiang Yu on 3/7/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import "PlainSectionHeader.h"


@implementation PlainSectionHeader
@synthesize _label;

- (id)initWithTitle:(NSString *) title {
    if (self = [super initWithFrame:CGRectMake(0, 0, 320, 20)]) {
		self.backgroundColor = [UIColor clearColor];
		_label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 20)];
		_label.backgroundColor = [UIColor clearColor];
		_label.font = [UIFont boldSystemFontOfSize:16];
		_label.text = title;
		[self addSubview:_label];
				
		_button = [UIButton buttonWithType:UIButtonTypeCustom];
		_button.frame = CGRectMake(300, 0, 20, 20);
		[_button setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];	
		
		[self addSubview:_button];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}

-(id)setAddButtonTarget:(id)target selector:(SEL)selector{
	[_button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	return self;
}

@end
