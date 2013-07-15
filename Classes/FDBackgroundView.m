//
//  FDBackgroundView.m
//  Food
//
//  Created by xuzepei on 9/29/11.
//  Copyright 2011 Rumtel Co.,Ltd. All rights reserved.
//

#import "FDBackgroundView.h"


@implementation FDBackgroundView
@synthesize _isFit;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
	
	UIImage* image = nil;
	
	if(NO == _isFit)
		image = [UIImage imageNamed:@"unfit.png"];
	else 
		image = [UIImage imageNamed:@"fit.png"];

	if(image)
		[image drawInRect:CGRectMake(self.bounds.size.width - 100,self.bounds.size.height - 100,80,80)];
}


- (void)dealloc {
    [super dealloc];
}


@end
