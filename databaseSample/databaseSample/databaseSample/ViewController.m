//
//  ViewController.m
//  databaseSample
//
//  Created by swati puri on 2/5/13.
//  Copyright (c) 2013 swati puri. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    delegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    showObj=[[showData alloc]init];
    
	// Do any additional setup after loading the view, typically from a nib.
}
-(IBAction)submitBtnAction:(id)sender
{
    [delegate addRecord:name.text roll:[roll.text integerValue] course:course.text];
    [self.navigationController pushViewController:showObj animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [name resignFirstResponder];
    [roll resignFirstResponder];
    [course resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
