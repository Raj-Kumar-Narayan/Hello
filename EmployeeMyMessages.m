//
//  EmployeeMyMessages.m
//  lputouch
//
//  Created by Vinay Anand on 12/04/12.
//  Copyright (c) 2012 vinay.anand@hotmail.com. All rights reserved.
//

#import "EmployeeMyMessages.h"
#import "UserDetail.h"

@implementation EmployeeMyMessages
@synthesize StaffMyMessageArray;

BOOL *elementFound;
NSMutableData *webData;
NSMutableString *soapResults;
NSURLConnection *conn;



//XML Parser
//---xml parsing---
NSXMLParser *xmlParser;
- (void)addColumn:(CGFloat)position {
    [columns addObject:[NSNumber numberWithFloat:position]];
    
}
-(IBAction) DisplayData
{
    UIActivityIndicatorView *actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem *actItem = [[UIBarButtonItem alloc] initWithCustomView:actInd];
    
    self.navigationItem.rightBarButtonItem = actItem;
    
    [actInd startAnimating];
    
    //[self hidekeyboard];
    [StaffMyMessageArray removeAllObjects];
    UserDetail *obj=[UserDetail getData];  
    
    
    
    NSString *soapMsg = 
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
     "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
     "<soap:Body>"
     "<EmployeeMyMessagesForService xmlns=\"http://tempuri.org/\">"
     "<UserId>%@</UserId>"
     "<Password>%@</Password>"
     "</EmployeeMyMessagesForService>"
     "</soap:Body>"
     "</soap:Envelope>",obj.LoggedUser,obj.LoggedUserPass
     ];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",obj.BaseUrl,obj.LocationUrl]];
    NSMutableURLRequest *req = 
    [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = 
    [NSString stringWithFormat:@"%d", [soapMsg length]];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://tempuri.org/EmployeeMyMessagesForService" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    if (conn) 
    {
        
        webData = [NSMutableData data];
    }  
}
-(void) connection:(NSURLConnection *) connection 
didReceiveResponse:(NSURLResponse *) response {
    [webData setLength: 0];
}

-(void) connection:(NSURLConnection *) connection 
    didReceiveData:(NSData *) data {
    [webData appendData:data];
}

-(void) connection:(NSURLConnection *) connection 
  didFailWithError:(NSError *) error {
    //[ActivityIndicator stopAnimating]; 
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"TouchLPU"
                          message:@"Error Connectiing to server"
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    
    [alert show];
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
    
    // Parse tHe XML Data
    xmlParser = [[NSXMLParser alloc] initWithData: webData];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
    [self.tableView reloadData]; 
    self.navigationItem.rightBarButtonItem = Nil;
    //    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Change Month", @"")
//                                                                  style:UIBarButtonItemStyleBordered
//                                                                 target:self
//                                                                 action:@selector(GetFinYear:)];
    //self.navigationItem.rightBarButtonItem = addButton; 
    //self.navigationItem.rightBarButtonItem = self.btnRefreshData;
    
}
-(void) parser:(NSXMLParser *) parser
didStartElement:(NSString *) elementName
  namespaceURI:(NSString *) namespaceURI
 qualifiedName:(NSString *) qName
    attributes:(NSDictionary *) attributeDict {
    //CurrentElement = elementName;
    if( [elementName isEqualToString:@"Table"])
    {
        //currentRow = [StaffAttendanceData alloc];
        
    }
}

-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
    
    if(!soapResults) 
		soapResults = [[NSMutableString alloc] initWithString:string];
	else
		[soapResults appendString:string];
    
    
    
}

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    
    
    if ([elementName isEqualToString:@"Announcement"]) 
	{
        [StaffMyMessageArray addObject:[NSString stringWithFormat:@"%@",soapResults]];
//        NSLog(@"%@",[NSString stringWithFormat:@"%@",soapResults]);
//        NSLog(@"%@",StaffMyMessageArray);
	}
    
    if ([elementName isEqualToString:@"Table"])
    {
        elementFound = FALSE;
    }
    
    soapResults = nil;
    [soapResults setString:@""];
    
    
    
    
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) BackClicked:(id) sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    UIImageView*bg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bgNew.png"]];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    bg.frame=CGRectMake(0, 0, self.view.frame.size.width, 480);
    if (screenRect.size.height == 568.0f)
    {
        bg.frame=CGRectMake(0, 0, self.view.frame.size.width, 568);
        bg.image=[UIImage imageNamed:@"bgnew568.png"];
    }
    
     [self.tableView setBackgroundView:bg];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"MyriadPro-Regular" size:20];
    // label.font=[UIFont boldSystemFontOfSize:20.0f];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor colorWithRed:138.0f/255.0f green:137.0f/255.0f blue:137.0f/255.0f alpha:1.0]; // change this color
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"My Messages", @"");
    [label sizeToFit];
    UIButton* btnback=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnback setImage:[UIImage imageNamed:@"back1.png"] forState:UIControlStateNormal];
    btnback.frame=CGRectMake(0, 7, 64, 30);
    [btnback addTarget:self action:@selector(BackClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *addButton=[[UIBarButtonItem alloc]initWithCustomView:btnback];
    self.navigationItem.leftBarButtonItem = addButton;

    StaffMyMessageArray  = [[NSMutableArray alloc] init];
    [self DisplayData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 27)];
    header.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"abar.png"]];
    UILabel*data=[[UILabel alloc]init];
    data.frame=CGRectMake(10,3.5f,300,20);
    data.backgroundColor=[UIColor clearColor];
    data.textAlignment=NSTextAlignmentCenter;
    [data setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:15]];
    //data.text =[NSString stringWithFormat:@"%@, %@", CurrentSelectedMonth,CurrentSelectedYear];
    data.textColor=[UIColor colorWithRed:0.0f/255.0f green:99.0f/255.0f blue:110.0f/255.0f alpha:1.0f];
    
    if (StaffMyMessageArray.count==0) {
        data.text= @"No Message Available";
    }
    else{
        data.text=@"My Messages";
    }
    [header addSubview:data];
    
    return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    tableView.rowHeight = 100;
    // Return the number of rows in the section.
    return [StaffMyMessageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // clear cell View
    for (UIView *Cell in cell.contentView.subviews )
	{
		if([Cell isKindOfClass:[UIImageView class]])
		{
			[Cell removeFromSuperview];
		}
		if([Cell isKindOfClass:[UILabel class]])
		{
			[Cell removeFromSuperview];
		}
        if([Cell isKindOfClass:[UIButton class]])
		{
			[Cell removeFromSuperview];
		}
        if([Cell isKindOfClass:[UITextField class]])
		{
			[Cell removeFromSuperview];
		}
	}
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSString *imagefile = [[NSBundle mainBundle]
						   pathForResource:@"message-icon" ofType:@"png"];
	UIImage *ui = [[UIImage alloc] initWithContentsOfFile:imagefile];
	//set the image on the table cell
	cell.imageView.image = ui;

    UILabel*statuslbl=[[UILabel alloc]init];
    statuslbl.frame=CGRectMake(60,0,250,90);
    statuslbl.backgroundColor=[UIColor clearColor];
    [statuslbl setFont:[UIFont fontWithName:@"MyriadPro-Regular" size:12]];
    statuslbl.numberOfLines=6;
    statuslbl.textColor=[UIColor colorWithRed:0.0f/255.0f green:99.0f/255.0f blue:110.0f/255.0f alpha:1.0f];
    statuslbl.text = [NSString stringWithFormat:@"%@",[StaffMyMessageArray objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:statuslbl];
    UIView*separateLine=[[UIView alloc]initWithFrame:CGRectMake(0, 98, 320, 1.0f)];
    separateLine.backgroundColor=[UIColor colorWithRed:199.0f/255.0f green:212.0f/255.0f blue:213.0f/255.0f alpha:1.0f];
    [cell.contentView addSubview:separateLine];
    
    UIView*separateLineW=[[UIView alloc]initWithFrame:CGRectMake(0,99, 320, 1.0f)];
    separateLineW.backgroundColor=[UIColor whiteColor];
    [cell.contentView addSubview:separateLineW];

    //StaffMyMessageArray *CurrentRecord = [StaffAttendanceArray objectAtIndex:indexPath.row];
   // cell.textLabel.text= [NSString stringWithFormat:@"%@",[StaffMyMessageArray objectAtIndex:indexPath.row] ];
//    cell.detailTextLabel.text= [NSString stringWithFormat:@"%@",[StaffMyMessageArray objectAtIndex:indexPath.row] ];

    //cell.textLabel.font = [UIFont systemFontOfSize:13];
   // cell.detailTextLabel.font = [UIFont systemFontOfSize:11.5];
    //cell.detailTextLabel.textColor = [UIColor brownColor];
  //  cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
   // cell.textLabel.numberOfLines = 6;
       //    
    
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
