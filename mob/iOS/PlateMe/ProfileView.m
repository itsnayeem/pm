//
//  ProfileView.m
//
//  Created by User on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProfileView.h"

@implementation ProfileView

- (IBAction)showLastView:(id)sender
{
	[UIView beginAnimations:Nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
	[self removeFromSuperview];
	[UIView commitAnimations];
}


/*- (NSInteger)numberOfComponentsInTableView:(UITableView *)theTableView
{
	return 1;
}
*/

// Populates the Array.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{	
	//NSArray *blogContentArray;
	//blogContentArray [[NSArray arrayWithObjects:@"first", @"second", @"third", nil] retain];
	blogContentArray = [[NSMutableArray alloc] init];
	[blogContentArray addObject:@"first"];
	[blogContentArray addObject:@"second"];
	[blogContentArray addObject:@"third"];
	[blogContentArray addObject:nil];
	return [blogContentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//static NSString *identity;
	//identity = @"MainCell";
	UITableViewCell *cell;
	//cell = [theTableView dequeueReusableCellWithIdentifier:identity];
	//if (cell == nil)
	//{
		//cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:identity] autorelease];
	//}
	//cell.text = [blogContentArray objectAtIndex:indexPath.row];
	return cell;
}

/*// Populates each row of the Picker using the Array.
- (NSInteger *)tableView:(UITableView *)theTableView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return 1;
}

// Action when table cell gets selected.
- (void)tableView:(UITableView *)theTableView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

}
*/
@end
