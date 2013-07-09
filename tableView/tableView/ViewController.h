//
//  ViewController.h
//  tableView
//
//  Created by admin on 01/07/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    NSString *searchText1;
    NSMutableArray *data;
    UITableView *table;
    UISearchBar *searchbar;
    NSMutableArray*copyData;
    BOOL searching;
    BOOL letUseSelectRow;
}
@property (retain,nonatomic) IBOutlet UISearchBar *searchbar;
-(void) searchTableView;
- (void)doneSearching_Clicked:(id)sender;
@property(retain,nonatomic) NSString *searchText1;
@property (retain, nonatomic) IBOutlet UITableView *tableview;

@end
