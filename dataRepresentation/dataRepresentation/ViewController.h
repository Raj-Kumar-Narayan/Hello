//
//  ViewController.h
//  dataRepresentation
//
//  Created by admin on 02/07/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *name;
   IBOutlet UITableView *tableView1;
    NSMutableArray *roll;
    NSMutableArray *Class1;
    NSMutableArray *section1;
    NSMutableArray *group;
}

@end
