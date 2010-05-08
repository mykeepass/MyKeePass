//
//  PasswordDisclosureView.m
//  MyKeePass
//
//  Created by Qiang Yu on 3/23/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import "PasswordDisclosureView.h"


@implementation PasswordDisclosureView
@synthesize _button;

- (id)init{
    if (self = [super initWithFrame:CGRectMake(0, 0, 320, 50)]) {
		_button = [UIButton buttonWithType:UIButtonTypeCustom];
		_button.frame = CGRectMake(282, 13, 30, 30);
		[_button setImage:[UIImage imageNamed:@"password.png"] forState:UIControlStateNormal];			
		[_button setImage:[UIImage imageNamed:@"passwordPressed.png"] forState:UIControlStateSelected];			
		[self addSubview:_button];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

-(id)setAddButtonTarget:(id)target selector:(SEL)selector{
	[_button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	return self;
}
@end
