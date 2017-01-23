//
//  VLDContextSheetItemView.m,
//
//  Created by Vladimir Angelov on 2/9/14.
//  Copyright (c) 2014 Vladimir Angelov. All rights reserved.
//

#import "VLDContextSheetItemView.h"
#import "VLDContextSheetItem.h"

#import <CoreImage/CoreImage.h>


//static const NSInteger VLDTextPadding = 5;

@interface VLDContextSheetItemView ()

//@property (nonatomic, strong) UIImageView *imageView;
//@property (nonatomic, strong) UIImageView *highlightedImageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) NSInteger labelWidth;

@end

@implementation VLDContextSheetItemView

@synthesize item = _item;

- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: CGRectMake(0, 0, 50, 83)];
    
    if(self) {
    }
    
    return self;
}


- (void) setItem:(VLDContextSheetItem *)item {
    _item = item;
    
    [self setImage:item.image forState:UIControlStateNormal];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    

}
-(void)setHighlighted:(BOOL)highlighted
{
    _isHighlighted = highlighted;

}
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
