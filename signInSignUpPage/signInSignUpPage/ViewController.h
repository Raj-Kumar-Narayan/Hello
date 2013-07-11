//
//  ViewController.h
//  signInSignUpPage
//
//  Created by admin on 08/07/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
IBOutlet UITextField *firstNameTxt;
IBOutlet UITextField *lastNameTxt;
IBOutlet UITextField *passTxt;
IBOutlet UITextField *confrmPassTxt;
IBOutlet UITextField *emailTxt;
IBOutlet UITextField *phoneNum;
}
@property(nonatomic,retain) UITextField *firstNameTxt;
@property(nonatomic,retain) UITextField *lastNameTxt;
@property(nonatomic,retain) UITextField *passTxt;
@property(nonatomic,retain) UITextField *confrmPassTxt;
@property(nonatomic,retain) UITextField *emailTxt;
@property(nonatomic,retain) UITextField *phoneNum;
-(IBAction)signinClicked:(id)sender;
-(IBAction)signupClicked:(id)sender;
@end
