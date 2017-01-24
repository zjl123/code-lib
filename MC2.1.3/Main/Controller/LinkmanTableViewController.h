//
//  LinkmanTableViewController.h
//  MiningCircle
//
//  Created by ql on 15/12/24.
//  Copyright © 2015年 zjl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tool.h"
@interface LinkmanTableViewController : UITableViewController
{
    BOOL isEditing;
   
}
@property(nonatomic,retain)NSArray *paramsArr;
@property(nonatomic,retain)NSArray *linkArr;
@property(nonatomic,retain)NSArray *tagArr;
@property (nonatomic,retain)NSArray *firstArr;
//@property(nonatomic,assign)LinkmanTableViewController *linkmanController;
@end
