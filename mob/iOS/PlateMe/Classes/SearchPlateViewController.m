//
//  SearchPlateViewController.m
//  PlateMe
//
//  Created by Kevin Calcote on 1/15/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "SearchPlateViewController.h"
#import "PMLoadingView.h"
#import "ProfileViewController.h"

@implementation SearchPlateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    plateSearchBar.delegate = self;
    currentState = @"PM";
    
    listOfStates = [[NSMutableArray alloc] init];
	[listOfStates addObject:@"PlateMe Generic"];
	[listOfStates addObject:@"AL - Alabama"];
	[listOfStates addObject:@"AK - Alaska"];
	[listOfStates addObject:@"AZ - Arizona"];
	[listOfStates addObject:@"AR - Arkansas"];
	[listOfStates addObject:@"CA - California"];
	[listOfStates addObject:@"CO - Colorado"]; 
	[listOfStates addObject:@"CT - Connecticut"]; 
	[listOfStates addObject:@"DE - Delaware"];
	[listOfStates addObject:@"FL - Florida"]; 
	[listOfStates addObject:@"GA - Georgia"]; 
	[listOfStates addObject:@"HI - Hawaii"]; 
	[listOfStates addObject:@"ID - Idaho"]; 
	[listOfStates addObject:@"IL - Illinois"]; 
	[listOfStates addObject:@"IN - Indiana"]; 
	[listOfStates addObject:@"IA - Iowa"]; 
	[listOfStates addObject:@"KS - Kansas"]; 
	[listOfStates addObject:@"KY - Kentucky"]; 
	[listOfStates addObject:@"LA - Louisiana"]; 
	[listOfStates addObject:@"ME - Maine"]; 
	[listOfStates addObject:@"MD - Maryland"]; 
	[listOfStates addObject:@"MA - Massachusetts"]; 
	[listOfStates addObject:@"MI - Michigan"]; 
	[listOfStates addObject:@"MN - Minnesota"]; 
	[listOfStates addObject:@"MS - Mississippi"]; 
	[listOfStates addObject:@"MO - Missouri"]; 
	[listOfStates addObject:@"MT - Montana"]; 
	[listOfStates addObject:@"NE - Nebraska"]; 
	[listOfStates addObject:@"NV - Nevada"]; 
	[listOfStates addObject:@"NH - New Hampshire"]; 
	[listOfStates addObject:@"NJ - New Jersey"]; 
	[listOfStates addObject:@"NM - New Mexico"]; 
	[listOfStates addObject:@"NY - New York"]; 
	[listOfStates addObject:@"NC - North Carolina"]; 
	[listOfStates addObject:@"ND - North Dakota"]; 
	[listOfStates addObject:@"OH - Ohio"]; 
	[listOfStates addObject:@"OK - Oklahoma"]; 
	[listOfStates addObject:@"OR - Oregon"]; 
	[listOfStates addObject:@"PA - Pennsylvania"]; 
	[listOfStates addObject:@"RI - Rhode Island"]; 
	[listOfStates addObject:@"SC - South Carolina"]; 
	[listOfStates addObject:@"SD - South Dakota"];
	[listOfStates addObject:@"TN - Tennessee"]; 
	[listOfStates addObject:@"TX - Texas"]; 
	[listOfStates addObject:@"UT - Utah"]; 
	[listOfStates addObject:@"VT - Vermont"]; 
	[listOfStates addObject:@"VA - Virginia"]; 
	[listOfStates addObject:@"WA - Washington"]; 
	[listOfStates addObject:@"WV - West Virginia"]; 
	[listOfStates addObject:@"WI - Wisconsin"];
	[listOfStates addObject:@"WY - Wyoming"];
    
    [plateLabel setFont:[UIFont fontWithName:@"LicensePlate" size:50]];
    
    validString = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [plateLabel setText:searchText];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setText:@""];
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    ProfileViewController *profile = (ProfileViewController*)[PlateMeViewController dequeueReusableView:[ProfileViewController class] :navController];
    
    [PMLoadingView invokeWithLoading:@selector(doSearch:::) onTarget:self :@"Searching..." :self.view, searchBar.text, currentState, profile, nil];
    
    [searchBar resignFirstResponder]; 
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL isValid = YES;
    
    if (text.length > 0)
    {
        unichar last = [text characterAtIndex:[text length] - 1];
        
        if (text.length == 1 && last == '\n')
            return YES;
        
        text = [text uppercaseString];
    
        NSRange validRange = [validString rangeOfString:text];
    
        if ((validRange.location == NSNotFound) || (range.location >= 8))
            isValid = NO;
    }
    
    return isValid;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [listOfStates objectAtIndex:row];
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [listOfStates count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
	return 1;
}

// Action when state gets selected.
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	NSString *rowTitle = [listOfStates objectAtIndex:row];
    
    if (rowTitle == @"PlateMe Generic")
	{
		[stateImageView setImage: [UIImage imageNamed:@"genericPlate.png"]];
	}
	else if (rowTitle == @"AL - Alabama")
	{
		[stateImageView setImage: [UIImage imageNamed:@"alabamaPlate.png"]];
	}
    else if (rowTitle == @"AK - Alaska")
	{
		[stateImageView setImage: [UIImage imageNamed:@"alaskaPlate.png"]];

	}
	else if (rowTitle == @"AZ - Arizona")
	{
		[stateImageView setImage: [UIImage imageNamed:@"arizonaPlate.png"]];

	}
    else if (rowTitle == @"AR - Arkansas")
	{
		[stateImageView setImage: [UIImage imageNamed:@"arkansasPlate.png"]];

	}
    else if (rowTitle == @"CA - California")
	{
		[stateImageView setImage: [UIImage imageNamed:@"californiaPlate.png"]];

	}
    else if (rowTitle == @"CO - Colorado")
	{
		[stateImageView setImage: [UIImage imageNamed:@"coloradoPlate.png"]];

	}
    else if (rowTitle == @"CT - Connecticut")
	{
		[stateImageView setImage: [UIImage imageNamed:@"connecticutPlate.png"]];

	}
    else if (rowTitle == @"DE - Delaware")
	{
		[stateImageView setImage: [UIImage imageNamed:@"delawarePlate.png"]];

	}
	else if (rowTitle == @"FL - Florida")
	{
		[stateImageView setImage: [UIImage imageNamed:@"floridaPlate.png"]];
	}
    else if (rowTitle == @"GA - Georgia")
	{
		[stateImageView setImage: [UIImage imageNamed:@"georgiaPlate.png"]];

	}
    else if (rowTitle == @"HI - Hawaii")
	{
		[stateImageView setImage: [UIImage imageNamed:@"hawaiiPlate.png"]];

	}
    else if (rowTitle == @"ID - Idaho")
	{
		[stateImageView setImage: [UIImage imageNamed:@"idahoPlate.png"]];

	}
	else if (rowTitle == @"IL - Illinois")
	{
		[stateImageView setImage: [UIImage imageNamed:@"illinoisPlate.png"]];
	}
    else if (rowTitle == @"IN - Indiana")
	{
		[stateImageView setImage: [UIImage imageNamed:@"indianaPlate.png"]];

	}
    else if (rowTitle == @"IA - Iowa")
	{
		[stateImageView setImage: [UIImage imageNamed:@"iowaPlate.png"]];

	}
    else if (rowTitle == @"KS - Kansas")
	{
		[stateImageView setImage: [UIImage imageNamed:@"kansasPlate.png"]];

	}
    else if (rowTitle == @"KY - Kentucky")
	{
		[stateImageView setImage: [UIImage imageNamed:@"kentuckyPlate.png"]];

	}
    else if (rowTitle == @"LA - Louisiana")
	{
		[stateImageView setImage: [UIImage imageNamed:@"louisianaPlate.png"]];

	}
    else if (rowTitle == @"ME - Maine")
	{
		[stateImageView setImage: [UIImage imageNamed:@"mainePlate.png"]];

	}
    else if (rowTitle == @"MD - Maryland")
	{
		[stateImageView setImage: [UIImage imageNamed:@"marylandPlate.png"]];

	}
    else if (rowTitle == @"MA - Massachusetts")
	{
		[stateImageView setImage: [UIImage imageNamed:@"massachusettsPlate.png"]];

	}
    else if (rowTitle == @"MI - Michigan")
	{
		[stateImageView setImage: [UIImage imageNamed:@"michiganPlate.png"]];

	}
    else if (rowTitle == @"MN - Minnesota")
	{
		[stateImageView setImage: [UIImage imageNamed:@"minnesotaPlate.png"]];

	}
    else if (rowTitle == @"MS - Mississippi")
	{
		[stateImageView setImage: [UIImage imageNamed:@"mississippiPlate.png"]];

	}
    else if (rowTitle == @"MO - Missouri")
	{
		[stateImageView setImage: [UIImage imageNamed:@"missouriPlate.png"]];

	}
    else if (rowTitle == @"MT - Montana")
	{
		[stateImageView setImage: [UIImage imageNamed:@"montanaPlate.png"]];

	}
    else if (rowTitle == @"NE - Nebraska")
	{
		[stateImageView setImage: [UIImage imageNamed:@"nebraskaPlate.png"]];

	}
    else if (rowTitle == @"NV - Nevada")
	{
		[stateImageView setImage: [UIImage imageNamed:@"nevadaPlate.png"]];

	}
    else if (rowTitle == @"NH - New Hampshire")
	{
		[stateImageView setImage: [UIImage imageNamed:@"newHampshirePlate.png"]];

	}
    else if (rowTitle == @"NJ - New Jersey")
	{
		[stateImageView setImage: [UIImage imageNamed:@"newJerseyPlate.png"]];

	}
    else if (rowTitle == @"NM - New Mexico")
	{
		[stateImageView setImage: [UIImage imageNamed:@"newMexicoPlate.png"]];

	}
    else if (rowTitle == @"NY - New York")
	{
		[stateImageView setImage: [UIImage imageNamed:@"newYorkPlate.png"]];

	}
    else if (rowTitle == @"NC - North Carolina")
	{
		[stateImageView setImage: [UIImage imageNamed:@"northCarolinaPlate.png"]];

	}
    else if (rowTitle == @"ND - North Dakota")
	{
		[stateImageView setImage: [UIImage imageNamed:@"northDakotaPlate.png"]];

	}
    else if (rowTitle == @"OH - Ohio")
	{
		[stateImageView setImage: [UIImage imageNamed:@"ohioPlate.png"]];

	}
    else if (rowTitle == @"OK - Oklahoma")
	{
		[stateImageView setImage: [UIImage imageNamed:@"oklahomaPlate.png"]];

	}
    else if (rowTitle == @"OR - Oregon")
	{
		[stateImageView setImage: [UIImage imageNamed:@"oregonPlate.png"]];

	}
    else if (rowTitle == @"PA - Pennsylvania")
	{
		[stateImageView setImage: [UIImage imageNamed:@"pennsylvaniaPlate.png"]];

	}
    else if (rowTitle == @"RI - Rhode Island")
	{
		[stateImageView setImage: [UIImage imageNamed:@"rhodeIslandPlate.png"]];

	}
    else if (rowTitle == @"SC - South Carolina")
	{
		[stateImageView setImage: [UIImage imageNamed:@"southCarolinaPlate.png"]];

	}
    else if (rowTitle == @"SD - South Dakota")
	{
		[stateImageView setImage: [UIImage imageNamed:@"southDakotaPlate.png"]];

	}
    else if (rowTitle == @"TN - Tennessee")
	{
		[stateImageView setImage: [UIImage imageNamed:@"tennesseePlate.png"]];

	}
    else if (rowTitle == @"TX - Texas")
	{
		[stateImageView setImage: [UIImage imageNamed:@"texasPlate.png"]];

	}
    else if (rowTitle == @"UT - Utah")
	{
		[stateImageView setImage: [UIImage imageNamed:@"utahPlate.png"]];

	}
    else if (rowTitle == @"VT - Vermont")
	{
		[stateImageView setImage: [UIImage imageNamed:@"vermontPlate.png"]];

	}
    else if (rowTitle == @"VA - Virginia")
	{
		[stateImageView setImage: [UIImage imageNamed:@"virginiaPlate.png"]];

	}
    else if (rowTitle == @"WA - Washington")
	{
		[stateImageView setImage: [UIImage imageNamed:@"washingtonPlate.png"]];

	}
    else if (rowTitle == @"WV - West Virginia")
	{
		[stateImageView setImage: [UIImage imageNamed:@"westVirginiaPlate.png"]];

	}
    else if (rowTitle == @"WI - Wisconsin")
	{
		[stateImageView setImage: [UIImage imageNamed:@"wisconsinPlate.png"]];

	}
    else if (rowTitle == @"WY - Wyoming")
	{
		[stateImageView setImage: [UIImage imageNamed:@"wyomingPlate.png"]];

	}
	else 
	{
		// Do Nothing.
	}
    
    if (rowTitle == @"PlateMe Generic")
    {
        currentState = @"PM";
    }
    else
    {
        //Release the current alloc
        [currentState release];
    
        //Set the current state
        currentState = [[NSString alloc] initWithBytes:rowTitle.UTF8String length:2 encoding:NSUTF8StringEncoding];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //dynamically take on parent view nav controller
    self.navController = (UINavigationController*)self.parentViewController;
    
    //Store the previous hidden state
    //navBarPrevHidden = self.navController.navigationBar.hidden;
    
    //Override the back button
    [self overrideBackButton];
    
    //Change hidden status
    [self.navController setNavigationBarHidden:NO animated:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //Restore hidden state
    //[self.navController setNavigationBarHidden:navBarPrevHidden animated:YES];
}

- (void) doSearch:(NSString*)plate :(NSString*)state :(ProfileViewController*)profile
{
    PlateMeSession *newSession = [[PlateMeSession alloc] init];
    
    //Assign plate data to the new session
    PMPlateData *plateData = [pmServer GetPlate:plate :state];    
    [newSession addPlate:plateData :YES];
    
    //Assign user data to the new session
    if ((plateData.associatedAccountId != nil) && ![plateData.associatedAccountId isEqualToString:@""] )
    {
        PMUserData *userData = [pmServer GetUserInfo:plateData.associatedAccountId];   
        [newSession setUserData:userData];
    }
    else
    {
        [newSession setUserData:nil];
    }
    
    [profile setCurrentSession:newSession];
    
    [self.navController performSelectorOnMainThread:@selector(pushViewController:animated:) withObject:profile waitUntilDone:YES];
}

- (void) initializeSearch:(NSString*)plate :(NSString*)state
{
    isDefaultedSearch = YES;
    plateSearchBar.text = plate;
    plateLabel.text = plate;
    //Select State
    NSString *formattedState = [state stringByAppendingString:@" - "];
    for (NSString *tempState in listOfStates)
    {
        if ([[tempState substringToIndex:5] isEqualToString:formattedState]) 
        {
            NSInteger stateIndex = [listOfStates indexOfObject:tempState];
            [statePicker selectRow:stateIndex inComponent:0 animated:NO];
            [self pickerView:statePicker didSelectRow:stateIndex inComponent:0];
        }
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(isDefaultedSearch)
    {
        // Alert Notifications asking "Is this correct?" showing picture preview, extracted chars, and assumed state via GPS
        NSString *message = [[[plateSearchBar.text stringByAppendingString:@", "] stringByAppendingString:currentState] stringByAppendingString:@"\n\n\n\n"];
        UIAlertView *confirmationAlert = [[UIAlertView alloc] initWithTitle:@"Is this correct?" message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(90, 70, 100, 55)];
        UIImage *plate= [UIImage imageNamed:@"samplePlate.png"];
        [imageView setImage:plate];
        [plate release];
        [confirmationAlert addSubview:imageView];
        [imageView release];
        
        [confirmationAlert show];
        [confirmationAlert release]; 
        isDefaultedSearch = NO;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Yes"])
    {
        //If yes, go to profile
        [self searchBarSearchButtonClicked:plateSearchBar];
    }
    //else do nothing
}

@end
