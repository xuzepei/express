//
//  RCRecentCellContentView.m
//  Food
//
//  Created by xuzepei on 8/24/13.
//
//

#import "RCRecentCellContentView.h"
#import "RCTool.h"

#define TITLE_COLOR [UIColor blackColor]
#define NOTE_COLOR [UIColor blueColor]
#define DESC_COLOR [UIColor colorWithRed:0.47 green:0.47 blue:0.47 alpha:1.00]

@implementation RCRecentCellContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc
{
    self.item = nil;
    self.imageUrl = nil;
    self.image = nil;
    self.delegate = nil;
    self.selected = NO;
    
    [super dealloc];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if(nil == _item)
        return;
    
    CGFloat max_width = [RCTool getScreenSize].width - 30.0;
    CGFloat fontSize = 14.0;
    if([RCTool isIpad])
    {
        fontSize = 18.0;
    }
    
    CGFloat offset_x = 4.0;
    CGFloat offset_y = 6.0;
    
    NSString* danhao = _item.num;
    if([danhao length])
    {
        NSString* state = @"";
        UIColor* color = nil;
        NSDictionary* dict = [RCTool getResult:_item.time];
        if(dict)
        {
            //state:快递单当前的状态 。0：在途中,1：已发货，2：疑难件，3： 已签收 ，4：已退货。
            
            int i = [[dict objectForKey:@"state"] intValue];
            switch (i) {
                case 0:
                {
                    color = COLOR_0;
                    state = @"(在途中)";
                    break;
                }
                case 1:
                {
                    color = COLOR_1;
                    state = @"(已发货)";
                    break;
                }
                case 2:
                {
                    color = COLOR_2;
                    state = @"(疑难件)";
                    break;
                }
                case 3:
                {
                    color = COLOR_3;
                    state = @"(已签收)";
                    break;
                }
                case 4:
                {
                    color = COLOR_4;
                    state = @"(已退货)";
                    break;
                }
                default:
                    break;
            }
        }
        
        [TITLE_COLOR set];
        
        NSString* temp = [NSString stringWithFormat:@"单号: %@",danhao];
        CGSize size = [temp drawInRect:CGRectMake(offset_x, offset_y, max_width, CGFLOAT_MAX) withFont:[UIFont systemFontOfSize:fontSize+2]];
        
        if([state length])
        {
            if(color)
                [color set];
            
            [state drawInRect:CGRectMake(offset_x + size.width+2, offset_y, max_width, CGFLOAT_MAX) withFont:[UIFont systemFontOfSize:fontSize+2]];
        }
        
        offset_y += size.height;
    }
    
    NSString* note = _item.note;
    if([note length])
    {
        [NOTE_COLOR set];
        NSString* temp = [NSString stringWithFormat:@"备注: %@",note];
        CGSize size = [temp drawInRect:CGRectMake(offset_x, offset_y, max_width, CGFLOAT_MAX) withFont:[UIFont systemFontOfSize:fontSize+2]];
        offset_y += size.height;
    }
    
    [DESC_COLOR set];
    NSString* name = _item.name;
    if([name length])
    {
        offset_y += 2.0f;
        NSString* temp = [NSString stringWithFormat:@"快递: %@",name];
        CGSize size = [temp drawInRect:CGRectMake(offset_x + 3, offset_y, max_width, CGFLOAT_MAX) withFont:[UIFont systemFontOfSize:fontSize]];
        offset_y += size.height;
    }
    
    double time = [_item.time doubleValue];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.dateFormat = @"yyyy-MM-dd H:m:s";
    NSString* dateString = [dateFormatter stringFromDate:date];
    if([dateString length])
    {
        NSString* temp = [NSString stringWithFormat:@"时间: %@",dateString];
        [temp drawInRect:CGRectMake(offset_x + 3, offset_y, max_width, CGFLOAT_MAX) withFont:[UIFont systemFontOfSize:fontSize]];
        //offset_y += size.height;
    }
}


- (void)updateContent:(id)item
{
    self.item = (Record*)item;

    [self setNeedsDisplay];
    
}

@end
