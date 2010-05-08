//
//  TKLabelTextfieldCell.h
//  Created by Devin Ross on 7/1/09.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "TextFieldCell.h"

@implementation TextFieldCell
@synthesize _field;

-(id)initWithIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
		_field = [[UITextField alloc] initWithFrame:CGRectZero];
		_field.autocorrectionType = UITextAutocorrectionTypeNo;
		_field.clearButtonMode = UITextFieldViewModeWhileEditing;			
		_field.delegate = self; 
		_field.font = [UIFont systemFontOfSize:18.0];
		[self addSubview:_field];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
	CGRect r = CGRectInset(self.bounds, 20, 8);
	r.origin.y += 2;
	r.size.height -= 2;
	r.origin.x += 5;
	r.size.width -= 5;
	
	if(self.editing){
		r.origin.x += 20;
		r.size.width -= 20;
	}
	
	_field.frame = r;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[_field resignFirstResponder];
	return NO;
}


- (void)willTransitionToState:(UITableViewCellStateMask)state{
	[super willTransitionToState:state];
	[self setNeedsDisplay];
}

- (void)dealloc {
	//UITextField delegate property is defined as "assign", not "retain".
	//there is a possibility that TExtFieldCell is released, but _field.delegate still 
	//holds the reference, which is invalid of course.
	_field.delegate = nil; 
	[_field release];
	[super dealloc];
}


@end
