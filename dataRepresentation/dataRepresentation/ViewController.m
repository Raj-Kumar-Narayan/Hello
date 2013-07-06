//
//  ViewController.m
//  dataRepresentation
//
//  Created by admin on 02/07/13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *namelbl=[[UILabel alloc]init];
    namelbl.frame =CGRectMake(10, 30, 120, 15);
    namelbl.textColor =[UIColor blackColor];
    [namelbl setFont:[UIFont fontWithName:@"MyriadPro-Bold" size:12]];
    namelbl.numberOfLines=1;
    namelbl.backgroundColor= [UIColor clearColor];
    namelbl.text=@"Name";
    [self.view addSubview:namelbl];
    UILabel *rolllbl=[[UILabel alloc]init];
    rolllbl.frame =CGRectMake(150, 30, 120, 15);
    rolllbl.textColor =[UIColor blackColor];
    [rolllbl setFont:[UIFont fontWithName:@"MyriadPro-Bold" size:12]];
    rolllbl.numberOfLines=1;
    rolllbl.backgroundColor= [UIColor clearColor];
    rolllbl.text=@"Roll Number";
    [self.view addSubview:rolllbl];
    UILabel *Classlbl=[[UILabel alloc]init];
    Classlbl.frame =CGRectMake(300, 30, 120, 15);
    Classlbl.textColor =[UIColor blackColor];
    [Classlbl setFont:[UIFont fontWithName:@"MyriadPro-Bold" size:12]];
    Classlbl.numberOfLines=1;
    Classlbl.backgroundColor= [UIColor clearColor];
    Classlbl.text=@"Class";
    [self.view addSubview:Classlbl];
    UILabel *Sectionlbl=[[UILabel alloc]init];
    Sectionlbl.frame =CGRectMake(450, 30, 120, 15);
    Sectionlbl.textColor =[UIColor blackColor];
    [Sectionlbl setFont:[UIFont fontWithName:@"MyriadPro-Bold" size:12]];
    Sectionlbl.numberOfLines=1;
    Sectionlbl.backgroundColor= [UIColor clearColor];
    Sectionlbl.text=@"Section";
    [self.view addSubview:Sectionlbl];
    UILabel *Grouplbl=[[UILabel alloc]init];
    Grouplbl.frame =CGRectMake(600, 30, 120, 15);
    Grouplbl.textColor =[UIColor blackColor];
    [Grouplbl setFont:[UIFont fontWithName:@"MyriadPro-Bold" size:12]];
    Grouplbl.numberOfLines=1;
    Grouplbl.backgroundColor= [UIColor clearColor];
    Grouplbl.text=@"Group";
    [self.view addSubview:Grouplbl];
    name=[[NSMutableArray alloc]initWithObjects:
          @"Deepak",
          @"Farukh",                   
          @"Gomcy",
          @"Nonu",
          @"Inderpreet",
          @"Vandna",
          @"Eva", nil];
    section1 =[[NSMutableArray alloc]initWithObjects:@"D1203",@"D1203", @"D1203",@"D1203",@"D1203",@"D1203",@"D1203",nil];
    Class1 =[[NSMutableArray alloc]initWithObjects:@"B.Tech",@"B.Tech",@"B.Tech",@"B.Tech",@"B.Tech",@"B.Tech",@"B.Tech", nil];
    roll=[[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
    group=[[NSMutableArray alloc]initWithObjects:@"A",@"A",@"B",@"A",@"B",@"B",@"A", nil];
    NSSortDescriptor *sortOrder1 = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: YES];
    [name sortUsingDescriptors:[NSArray arrayWithObject: sortOrder1]];
    
    [self.view addSubview:tableView1];}
    	// Do any additional setup after loading the view, typically from a nib.
   
  


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
       return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.rowHeight=50;
    return [name count];
    return [roll count];
    return [Class1 count];
    return [group count];
    return [section1 count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*CellIdentifier=@"cell";
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
               
        if (cell == nil){
            
            cell = [[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            
            cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
            
        }
    //clear window
    for (UILabel *Cell in cell.contentView.subviews ) {
        if ([Cell isKindOfClass:[UILabel class]]) {
            [Cell removeFromSuperview];
        }
        if ([Cell isKindOfClass:[UIButton class]]) {
            [Cell removeFromSuperview];
        }
        if ([Cell isKindOfClass:[UIImage class]]) {
            [Cell removeFromSuperview];
        }
        if ([Cell isKindOfClass:[UITextField class]]) {
            [Cell removeFromSuperview];
        }
    }
    
    cell.selectionStyle =UITableViewCellSelectionStyleGray;
    cell.backgroundColor = [UIColor colorWithRed:0. green:0.39 blue:0.106 alpha:0.];
    UILabel *namelbl1=[[UILabel alloc]init];
    namelbl1.frame =CGRectMake(10, 15, 120, 20);
    namelbl1.textColor =[UIColor blueColor];
    [namelbl1 setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:10]];
    namelbl1.numberOfLines=1;
    namelbl1.backgroundColor= [UIColor clearColor];
    namelbl1.text=[name objectAtIndex: indexPath.row];
    [cell.contentView addSubview:namelbl1];
    
    UILabel *rolllbl1=[[UILabel alloc]init];
    rolllbl1.frame =CGRectMake(180, 15, 120, 20);
    rolllbl1.textColor =[UIColor blueColor];
    [rolllbl1 setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:10]];
    rolllbl1.numberOfLines=1;
    rolllbl1.backgroundColor= [UIColor clearColor];
    rolllbl1.text=[roll objectAtIndex: indexPath.row];
    [cell.contentView addSubview:rolllbl1];
   
    UILabel *classlbl1=[[UILabel alloc]init];
    classlbl1.frame =CGRectMake(300, 15, 120, 20);
    classlbl1.textColor =[UIColor blueColor];
    classlbl1.numberOfLines=1;
    classlbl1.backgroundColor= [UIColor clearColor];
    classlbl1.text=[Class1 objectAtIndex: indexPath.row];
    [cell.contentView addSubview:classlbl1];
  
    UILabel *seclbl1=[[UILabel alloc]init];
    seclbl1.frame =CGRectMake(450, 15, 120, 20);
    seclbl1.textColor =[UIColor blueColor];
    [seclbl1 setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:10]];
    seclbl1.numberOfLines=10;
    seclbl1.backgroundColor= [UIColor clearColor];
    seclbl1.text=[section1 objectAtIndex: indexPath.row];
    [cell.contentView addSubview:seclbl1];
 
    UILabel *grouplbl1=[[UILabel alloc]init];
    grouplbl1.frame =CGRectMake(600, 15, 120, 20);
    grouplbl1.textColor =[UIColor blueColor];
    [grouplbl1 setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:10]];
    grouplbl1.numberOfLines=1;
    grouplbl1.backgroundColor= [UIColor clearColor];
    grouplbl1.text=[group objectAtIndex: indexPath.row];
    [cell.contentView addSubview:grouplbl1];
    //row separator
    UIView *whiteRow = [[UIView alloc]init];
    whiteRow.frame = CGRectMake(0, 48, 800, 1.0f);
    whiteRow.backgroundColor = [UIColor grayColor];
    [cell.contentView addSubview:whiteRow];
    UIView *gray = [[UIView alloc]init];
    gray.frame = CGRectMake(0, 49, 800, 1.0f);
    gray.backgroundColor =[UIColor grayColor];
    cell.backgroundColor=[UIColor greenColor];
    [self.view addSubview:cell];
    return cell;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
