//
//  ViewController.m
//  tableView
//
//  Created by admin on 01/07/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize tableview;
@synthesize searchText1;

- (void)viewDidLoad{
    [super viewDidLoad];
    data =[[NSMutableArray alloc]initWithObjects:@"Deepak",@"Raj", @"Mani",@"Ritesh",@"Mohit",@"Karan",nil];
    NSSortDescriptor *sortOrder1 = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: YES];
    [data dataSortUsingDiscriptors:[[[[[[[[[NSArray arrayWithObjects:sortOrder1] ];
                                          [self.view addSubview:sortOrder1];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
