//
//  showData.h
//  databaseSample
//
//  Created by swati puri on 2/5/13.
//  Copyright (c) 2013 swati puri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface showData : UIViewController
{
    IBOutlet UILabel *nameLbl;
    IBOutlet UILabel *rollLbl;
    IBOutlet UILabel *courseLbl;
    AppDelegate *delegate;
    
}

@end
