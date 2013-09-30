//
//  RCAddNoteView.m
//  Food
//
//  Created by xuzepei on 8/24/13.
//
//

#import "RCAddNoteView.h"
#import "RCTool.h"
#import <QuartzCore/QuartzCore.h>

#define BG_COLOR [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]

@implementation RCAddNoteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width - 200)/2.0, 16, 200, 24)] autorelease];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.text = @"添加备注";
        [self addSubview:_titleLabel];
        
        _inputTF = [[UITextField alloc] initWithFrame:CGRectMake((self.bounds.size.width - 200)/2.0, 56, 200, 28)];
        _inputTF.textColor = [UIColor blackColor];
        _inputTF.borderStyle = UITextBorderStyleLine;
        _inputTF.layer.borderWidth= 1.0f;
        _inputTF.layer.borderColor = [UIColor grayColor].CGColor;
        _inputTF.font = [UIFont systemFontOfSize:16];
        _inputTF.placeholder = @"请输入备注";
        [self addSubview:_inputTF];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame = CGRectMake(self.bounds.size.width/2.0 - 100 - 4, 96, 100, 40);
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [self.cancelButton setTitleColor:NAVIGATION_BAR_COLOR forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(clickedCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelButton];
        
        
        self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sureButton.frame = CGRectMake(self.bounds.size.width/2.0 + 4, 96, 100, 40);
        self.sureButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [self.sureButton setTitleColor:NAVIGATION_BAR_COLOR forState:UIControlStateNormal];
        [self.sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.sureButton addTarget:self action:@selector(clickedSureButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.sureButton];
        
        
//        if([RCTool isIpad])
//        {
//            
//        }
//        else
//        {
//            _inputTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
//        }
        
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    self.inputTF = nil;
    self.cancelButton = nil;
    self.sureButton = nil;
    self.titleLabel = nil;
    
    [super dealloc];
}

- (void)drawRoundRect:(CGRect)rect radius:(CGFloat)radius
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGPathRef clippath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath;
    CGContextAddPath(ctx, clippath);

    CGContextSetFillColorWithColor(ctx, BG_COLOR.CGColor);
    CGContextFillPath(ctx);
    
    CGContextRestoreGState(ctx);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self drawRoundRect:self.bounds radius:15];
}

- (void)clickedCancelButton:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(clickedCancelButton:)])
    {
        _inputTF.text = nil;
        [_delegate clickedCancelButton:nil];
    }
}

- (void)clickedSureButton:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(clickedSureButton:)])
    {
        [_delegate clickedSureButton:_inputTF.text];
    }
}


@end
