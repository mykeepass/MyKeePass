//
//  MultiLineTableViewCellStyle2.m
//  MyKeePass
//
//  Created by Qiang Yu on 12/18/09.
//  Copyright 2009 Qiang Yu. All rights reserved.
//

#import "MultiLineTableViewCellStyle2.h"

#define LABEL_WIDTH (70.0f)
#define DETAIL_WIDTH (200.0f)

static UIFont * labelFont;
static UIFont * detailFont;

@implementation MultiLineTableViewCellStyle2
@synthesize _trueValue;

-(void)dealloc{
	[_trueValue release];
	[super dealloc];
}

-(id)init:(NSString *)reuseIdentifier{
	if(self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier]){		
		self.textLabel.numberOfLines = 0;
		if(!labelFont) 
			labelFont = [UIFont boldSystemFontOfSize:LABLE_SIZE];
		self.textLabel.font = labelFont;
		self.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
		self.detailTextLabel.numberOfLines = 0;
		if(!detailFont) 
			detailFont = [UIFont systemFontOfSize:DETAIL_SIZE]; 
		self.detailTextLabel.font = detailFont;
	}
	return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
	if(action == @selector(copy:)){
		return self.detailTextLabel.text!=nil&&[self.detailTextLabel.text length]>0; 
	}
	return NO;
}

- (void)copy:(id)sender{
	UIPasteboard * gpBoard = [UIPasteboard generalPasteboard];
	if(_trueValue)
		gpBoard.string = _trueValue; 
	else
		gpBoard.string = self.detailTextLabel.text;
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

+ (CGFloat) heightOfCellWithLabel:(NSString *)label detail:(NSString *)detail{
	CGSize labelSize = {0, 0};
	CGSize detailSize = {0, 0};
	
	if(!labelFont) 
		labelFont = [UIFont boldSystemFontOfSize:LABLE_SIZE];
	
	if(!detailFont) 
		detailFont = [UIFont systemFontOfSize:DETAIL_SIZE]; 
	
	if(label && ![label isEqualToString:@""]){
		labelSize = [label sizeWithFont:labelFont constrainedToSize:CGSizeMake(LABEL_WIDTH, CGFLOAT_MAX)
						  lineBreakMode:UILineBreakModeWordWrap];
	}
	
	if(detail && ![detail isEqualToString:@""]){
		detailSize = [detail sizeWithFont:detailFont constrainedToSize:CGSizeMake(DETAIL_WIDTH, CGFLOAT_MAX)
						   lineBreakMode:UILineBreakModeWordWrap]; 
	}
	
	return MAX(labelSize.height, detailSize.height)+12;
}

@end
