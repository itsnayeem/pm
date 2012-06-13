//
//  SearchPlateView.m
//
//  Created by User on 8/11/11.
//  Copyright 2011 PlateMe.com. All rights reserved.
//

#import "SearchPlateView.h"

@implementation SearchPlateView



- (IBAction)showLastView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[self removeFromSuperview];
	[UIView commitAnimations];
}

- (IBAction)showProfileView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[searchPlateView removeFromSuperview];
	[self addSubview:profileView];
	[UIView commitAnimations];
	
	licensePlateFont = [UIFont fontWithName:@"LicensePlate" size:30];
	plateDisplayMini.font = licensePlateFont;
	[plateDisplayMini setTextColor:plateDisplay.textColor];
    plateDisplayMini.text = plateDisplay.text;
	
	[stateImageMini setImage:currentStatePlate];
}

- (IBAction)showPlatePhotoView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[searchPlateView removeFromSuperview];
	[self addSubview:platePhotoView];
	[UIView commitAnimations];
}

- (IBAction)enteringPlateNum:(id)sender
{
	licensePlateFont = [UIFont fontWithName:@"LicensePlate" size:50];
	plateDisplay.font = licensePlateFont;
	[plateDisplay setText:plateNum.text];
    //plateDisplay.text = plateNum.text;
}

- (IBAction)clickPlateImage:(id)sender
{
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
	return 1;
}

// Populates the Array.
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{	
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
	return [listOfStates count];
}

// Populates each row of the Picker using the Array.
- (NSInteger *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [listOfStates objectAtIndex:row];
}

// Action when state gets selected.
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if ([listOfStates objectAtIndex:row] == @"PlateMe Generic")
	{
		currentStatePlate = [UIImage imageNamed:@"genericPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
	else if ([listOfStates objectAtIndex:row] == @"AL - Alabama")
	{
		currentStatePlate = [UIImage imageNamed:@"alabamaPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"AK - Alaska")
	{
		currentStatePlate = [UIImage imageNamed:@"alaskaPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
	else if ([listOfStates objectAtIndex:row] == @"AZ - Arizona")
	{
		currentStatePlate = [UIImage imageNamed:@"arizonaPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"AR - Arkansas")
	{
		currentStatePlate = [UIImage imageNamed:@"arkansasPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"CA - California")
	{
		currentStatePlate = [UIImage imageNamed:@"californiaPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"CO - Colorado")
	{
		currentStatePlate = [UIImage imageNamed:@"coloradoPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"CT - Connecticut")
	{
		currentStatePlate = [UIImage imageNamed:@"connecticutPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"DE - Delaware")
	{
		currentStatePlate = [UIImage imageNamed:@"delawarePlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
	else if ([listOfStates objectAtIndex:row] == @"FL - Florida")
	{
		currentStatePlate = [UIImage imageNamed:@"floridaPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor greenColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"GA - Georgia")
	{
		currentStatePlate = [UIImage imageNamed:@"georgiaPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"HI - Hawaii")
	{
		currentStatePlate = [UIImage imageNamed:@"hawaiiPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"ID - Idaho")
	{
		currentStatePlate = [UIImage imageNamed:@"idahoPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
	else if ([listOfStates objectAtIndex:row] == @"IL - Illinois")
	{
		currentStatePlate = [UIImage imageNamed:@"illinoisPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor redColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"IN - Indiana")
	{
		currentStatePlate = [UIImage imageNamed:@"indianaPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"IA - Iowa")
	{
		currentStatePlate = [UIImage imageNamed:@"iowaPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"KS - Kansas")
	{
		currentStatePlate = [UIImage imageNamed:@"kansasPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"KY - Kentucky")
	{
		currentStatePlate = [UIImage imageNamed:@"kentuckyPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"LA - Louisiana")
	{
		currentStatePlate = [UIImage imageNamed:@"louisianaPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"ME - Maine")
	{
		currentStatePlate = [UIImage imageNamed:@"mainePlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"MD - Maryland")
	{
		currentStatePlate = [UIImage imageNamed:@"marylandPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"MA - Massachusetts")
	{
		currentStatePlate = [UIImage imageNamed:@"massachusettsPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"MI - Michigan")
	{
		currentStatePlate = [UIImage imageNamed:@"michiganPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"MN - Minnesota")
	{
		currentStatePlate = [UIImage imageNamed:@"minnesotaPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"MS - Mississippi")
	{
		currentStatePlate = [UIImage imageNamed:@"mississippiPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"MO - Missouri")
	{
		currentStatePlate = [UIImage imageNamed:@"missouriPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"MT - Montana")
	{
		currentStatePlate = [UIImage imageNamed:@"montanaPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"NE - Nebraska")
	{
		currentStatePlate = [UIImage imageNamed:@"nebraskaPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"NV - Nevada")
	{
		currentStatePlate = [UIImage imageNamed:@"nevadaPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"NH - New Hampshire")
	{
		currentStatePlate = [UIImage imageNamed:@"newHampshirePlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"NJ - New Jersey")
	{
		currentStatePlate = [UIImage imageNamed:@"newJerseyPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"NM - New Mexico")
	{
		currentStatePlate = [UIImage imageNamed:@"newMexicoPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"NY - New York")
	{
		currentStatePlate = [UIImage imageNamed:@"newYorkPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"NC - North Carolina")
	{
		currentStatePlate = [UIImage imageNamed:@"northCarolinaPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"ND - North Dakota")
	{
		currentStatePlate = [UIImage imageNamed:@"northDakotaPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"OH - Ohio")
	{
		currentStatePlate = [UIImage imageNamed:@"ohioPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"OK - Oklahoma")
	{
		currentStatePlate = [UIImage imageNamed:@"oklahomaPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"OR - Oregon")
	{
		currentStatePlate = [UIImage imageNamed:@"oregonPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"PA - Pennsylvania")
	{
		currentStatePlate = [UIImage imageNamed:@"pennsylvaniaPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"RI - Rhode Island")
	{
		currentStatePlate = [UIImage imageNamed:@"rhodeIslandPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"SC - South Carolina")
	{
		currentStatePlate = [UIImage imageNamed:@"southCarolinaPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"SD - South Dakota")
	{
		currentStatePlate = [UIImage imageNamed:@"southDakotaPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"TN - Tennessee")
	{
		currentStatePlate = [UIImage imageNamed:@"tennesseePlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"TX - Texas")
	{
		currentStatePlate = [UIImage imageNamed:@"texasPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"UT - Utah")
	{
		currentStatePlate = [UIImage imageNamed:@"utahPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"VT - Vermont")
	{
		currentStatePlate = [UIImage imageNamed:@"vermontPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"VA - Virginia")
	{
		currentStatePlate = [UIImage imageNamed:@"virginiaPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"WA - Washington")
	{
		currentStatePlate = [UIImage imageNamed:@"washingtonPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"WV - West Virginia")
	{
		currentStatePlate = [UIImage imageNamed:@"westVirginiaPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"WI - Wisconsin")
	{
		currentStatePlate = [UIImage imageNamed:@"wisconsinPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
    else if ([listOfStates objectAtIndex:row] == @"WY - Wyoming")
	{
		currentStatePlate = [UIImage imageNamed:@"wyomingPlate.png"];
		[stateImage setImage:currentStatePlate];
		[plateDisplay setTextColor:[UIColor blackColor]];
	}
	else 
	{
		// Do Nothing.
	}

	//NSString *selectedState = [NSString stringWithFormat:@"State Selected: %@", [listOfStates objectAtIndex:row]];
}

@end
