//
//  MultiLineTableViewCellStyle2.h
//  MyKeePass
//
//  Created by Qiang Yu on 12/18/09.
//  Copyright 2009 Qiang Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LABLE_SIZE 12
#define DETAIL_SIZE 16

@interface MultiLineTableViewCellStyle2 : UITableViewCell {
	NSString * _trueValue;
}

@property(nonatomic, retain) NSString * _trueValue;

-(id)init:(NSString *)reuseIdentifier;

+ (CGFloat) heightOfCellWithLabel:(NSString *)label detail:(NSString *)detail;
@end
