//
//  RCRecentCell.m
//  Food
//
//  Created by xuzepei on 8/24/13.
//
//

#import "RCRecentCell.h"

@implementation RCRecentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _myContentView = [[RCRecentCellContentView alloc]
						  initWithFrame:CGRectMake(0,0,320,80)];
		[self.contentView addSubview: _myContentView];
        
    }
    return self;
}

- (void)dealloc
{
    self.myContentView = nil;
    self.delegate = nil;
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
	_myContentView.selected = selected;
	[_myContentView setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	[super setHighlighted:highlighted animated:animated];
	
	_myContentView.selected = highlighted;
	[_myContentView setNeedsDisplay];
}

- (void)updateContent:(id)item height:(CGFloat)height delegate:(id)delegate
{
	if(nil == item)
		return;
    
    CGRect rect = _myContentView.frame;
    rect.size.height = height;
    _myContentView.frame = rect;
    
	[_myContentView updateContent:item];
}

@end
