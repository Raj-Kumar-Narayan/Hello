//
//  showData.m
//  databaseSample
//
//  Created by swati puri on 2/5/13.
//  Copyright (c) 2013 swati puri. All rights reserved.
//

#import "showData.h"

@interface showData ()

@end

@implementation showData

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    nameLbl.text=delegate.nameStr;
    rollLbl.text=[NSString stringWithFormat:@"%d",delegate.rollStr];
    courseLbl.text=delegate.courseStr;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
