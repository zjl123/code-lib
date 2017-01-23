//
//  VLDContextSheet.m
//
//  Created by Vladimir Angelov on 2/7/14.
//  Copyright (c) 2014 Vladimir Angelov. All rights reserved.
//

#import "VLDContextSheetItemView.h"
#import "VLDContextSheet.h"

typedef struct {
    CGRect rect;
    CGFloat rotation;
} VLDZone;

//static const NSInteger VLDMaxTouchDistanceAllowance = 40;
static const NSInteger VLDZonesCount = 10;

static inline VLDZone VLDZoneMake(CGRect rect, CGFloat rotation) {
    VLDZone zone;
    
    zone.rect = rect;
    zone.rotation = rotation;
    
    return zone;
}

//static CGFloat VLDVectorDotProduct(CGPoint vector1, CGPoint vector2) {
//    return vector1.x * vector2.x + vector1.y * vector2.y;
//}

//static CGFloat VLDVectorLength(CGPoint vector) {
//    return sqrt(vector.x * vector.x + vector.y * vector.y);
//}
//
static CGRect VLDOrientedScreenBounds() {
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) &&
        bounds.size.width < bounds.size.height) {
        
        bounds.size = CGSizeMake(bounds.size.height, bounds.size.width);
    }
    
    return bounds;
}

@interface VLDContextSheet ()

@property (strong, nonatomic) NSArray *itemViews;
@property (strong, nonatomic) UIView *centerView;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) VLDContextSheetItemView *selectedItemView;
@property (assign, nonatomic) BOOL openAnimationFinished;
@property (assign, nonatomic) CGPoint touchCenter;
@property (strong, nonatomic) UIGestureRecognizer *starterGestureRecognizer;

@end

@implementation VLDContextSheet {
    
    VLDZone zones[VLDZonesCount];
}

- (id) initWithFrame: (CGRect) frame {
    return [self initWithItems: nil];
}

- (id) initWithItems: (NSArray *) items {
    self = [super initWithFrame: VLDOrientedScreenBounds()];
    
    if(self) {
        _items = items;
        _radius = width1/4;
        _rangeAngle = M_PI / 1.6;
        
        [self createSubviews];
    }
    return self;
}
-(void)tap:(UITapGestureRecognizer *)tap
{
    [self.delegate close];
}
- (void) createSubviews {
    
    _backgroundView = [[UIView alloc] initWithFrame: CGRectZero];
    _backgroundView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [_backgroundView addGestureRecognizer:tap];
    [self addSubview: self.backgroundView];
    
    _itemViews = [[NSMutableArray alloc] init];
        for(VLDContextSheetItem *item in _items) {
        VLDContextSheetItemView *itemView = [[VLDContextSheetItemView alloc] init];
        itemView.item = item;
        [itemView addTarget:self action:@selector(btnCick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: itemView];
        
        [(NSMutableArray *) _itemViews addObject: itemView];
    }
    
  
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    
}
-(void)btnCick:(VLDContextSheetItemView *)btn
{

    self.selectedItemView = btn;
        [self.delegate contextSheet: self didSelectItem: self.selectedItemView.item];
    
}
- (void) layoutSubviews {
    [super layoutSubviews];
        
    self.backgroundView.frame = CGRectMake(0, 0, width1,height1-49);
}

- (void) setCenterViewHighlighted: (BOOL) highlighted {
    _centerView.backgroundColor = highlighted ? [UIColor colorWithWhite: 0.5 alpha: 0.4] : nil;
}

- (void) createZones {
    CGRect screenRect = self.bounds;
    
    NSInteger rowHeight1 = 120;
    
    zones[0] = VLDZoneMake(CGRectMake(0, 0, 70, rowHeight1), 0.8);
    zones[1] = VLDZoneMake(CGRectMake(zones[0].rect.size.width, 0, 40, rowHeight1), 0.4);
    
    zones[2] = VLDZoneMake(CGRectMake(zones[1].rect.origin.x + zones[1].rect.size.width, 0, screenRect.size.width - 2 *(zones[0].rect.size.width + zones[1].rect.size.width), rowHeight1), 0);
    
    zones[3] = VLDZoneMake(CGRectMake(zones[2].rect.origin.x + zones[2].rect.size.width, 0, zones[1].rect.size.width, rowHeight1),  -zones[1].rotation);
    zones[4] = VLDZoneMake(CGRectMake(zones[3].rect.origin.x + zones[3].rect.size.width, 0, zones[0].rect.size.width, rowHeight1), -zones[0].rotation);
    
    NSInteger rowHeight2 = screenRect.size.height - zones[0].rect.size.height;
    
    zones[5] = VLDZoneMake(CGRectMake(0, zones[0].rect.size.height, zones[0].rect.size.width, rowHeight2), M_PI - zones[0].rotation);
    zones[6] = VLDZoneMake(CGRectMake(zones[5].rect.size.width, zones[5].rect.origin.y, zones[1].rect.size.width, rowHeight2), M_PI - zones[1].rotation);
    zones[7] = VLDZoneMake(CGRectMake(zones[6].rect.origin.x + zones[6].rect.size.width, zones[5].rect.origin.y, zones[2].rect.size.width, rowHeight2), M_PI - zones[2].rotation);
    zones[8] = VLDZoneMake(CGRectMake(zones[7].rect.origin.x + zones[7].rect.size.width, zones[5].rect.origin.y, zones[3].rect.size.width, rowHeight2), M_PI - zones[3].rotation);
    zones[9] = VLDZoneMake(CGRectMake(zones[8].rect.origin.x + zones[8].rect.size.width, zones[5].rect.origin.y, zones[4].rect.size.width, rowHeight2), M_PI - zones[4].rotation);
}

/* Only used for testing the touch zones */
- (void) drawZones {
    for(int i = 0; i < VLDZonesCount; i++) {
        UIView *zoneView = [[UIView alloc] initWithFrame: zones[i].rect];
        
        CGFloat hue = ( arc4random() % 256 / 256.0 );
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        
        zoneView.backgroundColor = color;
        [self addSubview: zoneView];
    }
}

- (void) updateItemView: (UIView *) itemView
          touchDistance: (CGFloat) touchDistance
               animated: (BOOL) animated  {
    
    if(!animated) {
        [self updateItemViewNotAnimated: itemView touchDistance: touchDistance];
    }
    else  {        
        [UIView animateWithDuration: 0.4
                              delay: 0
             usingSpringWithDamping: 0.45
              initialSpringVelocity: 7.5
                            options: UIViewAnimationOptionBeginFromCurrentState
                         animations: ^{
                             [self updateItemViewNotAnimated: itemView
                                               touchDistance: touchDistance];
                         }
                         completion: nil];
    }
}

- (void) updateItemViewNotAnimated: (UIView *) itemView touchDistance: (CGFloat) touchDistance  {
    NSInteger itemIndex = [self.itemViews indexOfObject: itemView];
    
   // CGFloat angle = -0.65 + self.rotation + itemIndex * (self.rangeAngle / self.itemViews.count);
    CGFloat angle = M_PI/6+M_PI/3*itemIndex;
  //  CGFloat resistanceFactor = 1.0 / (touchDistance > 0 ? 6.0 : 3.0);
   // NSLog(@"%f",sin(angle));
    itemView.center = CGPointMake((width1/4)*(itemIndex+1),
                                  self.touchCenter.y - self.radius * sin(angle));
    
   // CGFloat angle = -0.65 + self.rotation + itemIndex * (self.rangeAngle / self.itemViews.count);
//    CGFloat angle = 30+60*itemIndex;
//  //  CGFloat resistanceFactor = 1.0 / (touchDistance > 0 ? 6.0 : 3.0);
//    
//    itemView.center = CGPointMake((width1/4)*(itemIndex+1),
//                                  self.touchCenter.y -(80* sin(angle)));
    
    CGFloat scale = 1 ;
    
    itemView.transform = CGAffineTransformMakeScale(scale, scale);
}

- (void) openItemsFromCenterView {
    self.openAnimationFinished = NO;
    
    for(int i = 0; i < self.itemViews.count; i++) {
        VLDContextSheetItemView *itemView = self.itemViews[i];
        itemView.transform = CGAffineTransformIdentity;
        itemView.center = self.touchCenter;
        
        [UIView animateWithDuration: 0.5
                              delay: i * 0.01
             usingSpringWithDamping: 0.45
              initialSpringVelocity: 7.5
                            options: 0
                         animations: ^{
                             [self updateItemViewNotAnimated: itemView touchDistance: 0.0];
                             
                         }
                         completion: ^(BOOL finished) {
                             self.openAnimationFinished = YES;
                         }];
    }
}

- (void) closeItemsToCenterView {
    [UIView animateWithDuration: 0.1
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         self.alpha = 1.0;
                     }];
    
}

- (void) startWithGestureRecognizer: (UIButton *) gestureRecognizer inView: (UIView *) view {
    [view addSubview: self];
    self.frame = CGRectMake(0, 0, width1, height1-49);
    [self createZones];
    self.touchCenter = CGPointMake(gestureRecognizer.center.x,height1- gestureRecognizer.center.y-36);
    self.centerView.center = self.touchCenter;
    self.selectedItemView = nil;
    [self setCenterViewHighlighted: YES];
    self.rotation = [self rotationForCenter: self.centerView.center];
    
    [self openItemsFromCenterView];
    
}

- (CGFloat) rotationForCenter: (CGPoint) center {
    for(NSInteger i = 0; i < 10; i++) {
        VLDZone zone = zones[i];
        
        if(CGRectContainsPoint(zone.rect, center)) {
            return M_PI;
        }
    }
    
    return 0;
}


- (void) end {
 //   [self.starterGestureRecognizer removeTarget: self action: @selector(gestureRecognizedStateObserver:)];
    
//    if(self.selectedItemView && self.selectedItemView.isHighlighted) {
//        [self.delegate contextSheet: self didSelectItem: self.selectedItemView.item];
//    }
    
    [self closeItemsToCenterView];
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
