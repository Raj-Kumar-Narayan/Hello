//
//  ViewController.m
//  testingApp
//
//  Created by admin on 11/07/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize firstNameTxt;
@synthesize lastNameTxt;
@synthesize passTxt;
@synthesize confrmPassTxt;
@synthesize emailTxt;
@synthesize phoneNum;

-(IBAction)signinClicked:(id)sender
{
    
}
-(IBAction)signupClicked:(id)sender
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"signIn.png"]];
    CGRect screenRect =[[UIScreen mainScreen]bounds];
    if (screenRect.size.height==568.0f) {
        bg.image =[UIImage imageNamed:@"signIn.png"];
    }
    
    bg.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ;
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
    
    UIButton *signinBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [signinBtn setImage:[UIImage imageNamed:@"signInBtn.png"] forState:UIControlStateNormal];
    signinBtn.frame = CGRectMake(90, 187, 140, 120);
    [signinBtn addTarget:self action:@selector(signinClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signinBtn];
    UIButton *signupBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [signupBtn setImage:[UIImage imageNamed:@"signUpBtn.png"] forState:UIControlStateNormal];
    signupBtn.frame =CGRectMake(174, 471, 120, 100);
    [signupBtn addTarget:self action:@selector(signUpClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signupBtn];
    UIBarButtonItem *addButton =[[UIBarButtonItem alloc]initWithCustomView:signinBtn];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.rightBarButtonItem.enabled=YES;
    firstNameTxt.frame = CGRectMake(100, 130, 150 , 15);
    
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end