//
//  ViewController.h
//  databaseSample
//
//  Created by swati puri on 2/5/13.
//  Copyright (c) 2013 swati puri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "showData.h"

@interface ViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *name;
    IBOutlet UITextField *roll;
    IBOutlet UITextField *course;
    AppDelegate *delegate;
    showData *showObj;
}
-(IBAction)submitBtnAction:(id)sender;
@end
