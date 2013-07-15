//
//  MyView.m
//  Food
//
//  Created by xuzepei on 12/17/11.
//  Copyright 2011 rumtel. All rights reserved.
//

#import "MyView.h"


@implementation MyView
@synthesize _delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	
	self._delegate = nil;
    [super dealloc];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	
	if(_delegate)
	 [_delegate._inputTF resignFirstResponder];
}


@end
