//
//  DWTagList.m
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import "DWTagList.h"
#import <QuartzCore/QuartzCore.h>

#define CORNER_RADIUS 5.0f
#define LABEL_MARGIN 15.0f
#define BOTTOM_MARGIN 15.0f
#define FONT_SIZE 16.0f
#define HORIZONTAL_PADDING 12.0f
#define VERTICAL_PADDING 9.0f
#define BACKGROUND_COLOR [UIColor whiteColor]
#define TEXT_COLOR [UIColor blackColor]
#define TEXT_SHADOW_COLOR [UIColor whiteColor]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f)
#define BORDER_COLOR [UIColor grayColor].CGColor
#define BORDER_WIDTH 1.0f

@implementation DWTagList
NSMutableSet *set;
@synthesize view, textArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:view];
    }
    return self;
}

- (void)setTags:(NSArray *)array
{
    textArray = [[NSArray alloc] initWithArray:array];
    sizeFit = CGSizeZero;
    [self display];
}

- (void)setLabelBackgroundColor:(UIColor *)color
{
    lblBackgroundColor = color;
    [self display];
}

-(void)onClickUILable:(UITapGestureRecognizer *)sender{
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    
    UILabel *la=(UILabel*)tap.view;
    NSLog(@"%@", la.text);
    CGSize textSize = [la.text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:CGSizeMake(self.frame.size.width, 1500) lineBreakMode:UILineBreakModeWordWrap];
    float width = textSize.width + 2 * HORIZONTAL_PADDING;
    float height = textSize.height + 2 * VERTICAL_PADDING;
    CGRect frame = CGRectMake((width - 5) * 0.88f, (height - 5) * 0.83f, 10, 10);
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:frame];
    UIImage *img = [UIImage imageNamed:@"check.png"];
    imgview.image = img;
    if (la.textColor == [UIColor blackColor]) {
        la.textColor = [UIColor redColor];
        la.layer.borderColor = [UIColor redColor].CGColor;
        [set addObject:la.text];
        [la addSubview:imgview];
        NSLog(@"%@", set);
    }
    else{
        la.textColor = [UIColor blackColor];
        la.layer.borderColor = [UIColor grayColor].CGColor;
        for (UIImageView *imgv in [la subviews]) {
            [imgv removeFromSuperview];
        }
        [set removeObject:la.text];
        NSLog(@"%@", set);
    }
    
    //相应代码
    
}

- (void)display
{
    set = [[NSMutableSet alloc] init];
    for (UILabel *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    float totalHeight = 0;
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    for (NSString *text in textArray) {
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:CGSizeMake(self.frame.size.width, 1500) lineBreakMode:UILineBreakModeWordWrap];
        textSize.width += HORIZONTAL_PADDING*2;
        textSize.height += VERTICAL_PADDING*2;
        UILabel *label = nil;
        if (!gotPreviousFrame) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
            totalHeight = textSize.height;
        } else {
            CGRect newRect = CGRectZero;
            if (previousFrame.origin.x + previousFrame.size.width + textSize.width + LABEL_MARGIN > self.frame.size.width) {
                newRect.origin = CGPointMake(0, previousFrame.origin.y + textSize.height + BOTTOM_MARGIN);
                totalHeight += textSize.height + BOTTOM_MARGIN;
            } else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
            }
            newRect.size = textSize;
            label = [[UILabel alloc] initWithFrame:newRect];
        }
        previousFrame = label.frame;
        gotPreviousFrame = YES;
        [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        if (!lblBackgroundColor) {
            [label setBackgroundColor:BACKGROUND_COLOR];
        } else {
            [label setBackgroundColor:lblBackgroundColor];
        }
        [label setTextColor:TEXT_COLOR];
        [label setText:text];
        [label setTextAlignment:UITextAlignmentCenter];
//        [label setShadowColor:TEXT_SHADOW_COLOR];
//        [label setShadowOffset:TEXT_SHADOW_OFFSET];
        [label.layer setMasksToBounds:YES];
        [label.layer setCornerRadius:CORNER_RADIUS];
        [label.layer setBorderColor:BORDER_COLOR];
        [label.layer setBorderWidth: BORDER_WIDTH];
        UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickUILable:)];
        [label addGestureRecognizer:tapgesture];
        label.userInteractionEnabled = YES;
        [self addSubview:label];
    }
    sizeFit = CGSizeMake(self.frame.size.width, totalHeight + 1.0f);
}

- (CGSize)fittedSize
{
    return sizeFit;
}

+ (NSMutableSet *)returnSet
{
    return set;
}

@end
