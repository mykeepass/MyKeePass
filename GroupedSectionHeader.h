//
//  SectionHeader.h
//  MyKeePass
//
//  Created by Qiang Yu on 3/3/10.
//  Copyright 2010 Qiang Yu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GroupedSectionHeader : UIView {
	UILabel * _label;
	UIButton * _button;
}

@property(nonatomic, readonly) UILabel * _label;
@property(nonatomic, readonly) UIButton * _button;

@end
