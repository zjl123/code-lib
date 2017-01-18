//
//  ActSubTbVIew.h
//  MiningCircle
//
//  Created by ql on 2016/10/19.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JumpDelegate <NSObject>

-(void)jumpTo:(NSInteger)tag;

@end
@interface ActSubTbVIew : UITableView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) NSArray *tbArr;

@property(nonatomic, weak) id <JumpDelegate> jumpDelegate;
//+(ActSubTbVIew *)shareInstance;
@end
