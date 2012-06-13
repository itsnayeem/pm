//
//  PlacesViewController.m
//  PlateMe
//
//  Created by Kevin Calcote on 1/14/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "PlacesViewController.h"
#import "PlacesAnnotationView.h"
#import "PlacesAnnotation.h"
#import "ProfileViewController.h"
#import "PMLoadingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PlacesViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
    
    selfAnnotation = [[[MKAnnotationView alloc] init] retain];
    defaultUserPic = [[UIImage imageNamed:@"background.png"] retain];
    annotationArray = [[[NSMutableArray alloc] init] retain];
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

-(void) doAnnotationLoad
{
    //Grab fresh favorites
    currentSession.favorites = [pmServer GetFavorites];
    
    //Clear the locations
    [currentSession.locationData clearLocations];
    
    //Set all favorites locations
    for (PMFavoriteData *favData in currentSession.favorites)
    {
        if ( (nil != favData.primaryPlateId) && 
            (![favData.primaryPlateId isEqualToString:@""]) &&
            (nil != favData.primaryPlateLat) && 
            (![favData.primaryPlateLat isEqualToString:@""]) &&
            (nil != favData.primaryPlateLon) && 
            (![favData.primaryPlateLon isEqualToString:@""]) )
        {
            [currentSession.locationData addLocation:favData.primaryPlateId :favData.primaryPlateLat :favData.primaryPlateLon];
        }
    }
    
    NSDictionary *locations = [currentSession.locationData getLocations];
    
    for (NSString* key in locations)
    {
        if (nil != key)
        {
            //Get the location from the plateId
            CLLocation *location = [locations objectForKey:key];
            
            //Assign the plate data to the annotation
            PMPlateData *plateData = [currentSession getPlate:key];
            
            if([plateData.plateNumber isEqualToString:@"No Plate"])
            {
                plateData = [pmServer GetPlate:key];
                [currentSession addPlate:plateData];
            }
            
            if (nil != plateData)
            {
                PMUserData *userData = [pmServer GetUserInfo:plateData.associatedAccountId];
                
                NSString *userName = [NSString stringWithFormat:@"%@ %@", userData.firstName, userData.lastName];
                
                NSString *plateString = [NSString stringWithFormat:@"%@, %@", plateData.plateNumber, plateData.state];
                
                //Create the annotation
                PlacesAnnotation *annotation = [[PlacesAnnotation alloc]initWithCoordinate:location.coordinate andTitle:userName andSubtitle:plateString];          
                
                annotation.userData = userData;
                annotation.plateData = plateData;
                
                //Add the annotation to the annotation array
                [annotationArray addObject:annotation];
                [annotation release];
            }
        }
    }
    
    
    //Add all the annotations
    [nibMapView performSelectorOnMainThread:@selector(addAnnotations:) withObject:annotationArray waitUntilDone:YES];
    
    [nibMapView setShowsUserLocation:NO];    
    [nibMapView setShowsUserLocation:YES];    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //load annotations in the background, may need to grab many plate/user data
    [self performSelectorInBackground:@selector(doAnnotationLoad) withObject:nil];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //Clear all of the annotations
    [nibMapView removeAnnotations:annotationArray];
    
    //Clear the array
    [annotationArray removeAllObjects];
}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
    
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    MKCoordinateRegion region;
    
    region.center = mapView.userLocation.coordinate;
   
    MKCoordinateSpan span;
    span.latitudeDelta = .005;
    span.longitudeDelta = .005;
    region.span = span;
    
    [mapView setRegion:region];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    // If it's the user location, just return nil.
    //if ([annotation isKindOfClass:[MKUserLocation class]])
    //    return nil;    
    
    PlacesAnnotationView *annotationView = nil;
    
    annotationView = (PlacesAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
    
    if (nil == annotationView)
    {
        annotationView = [[[PlacesAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"] retain];
        
        [annotationView.layer setCornerRadius:10.0f];
        [annotationView.layer setBorderWidth:2.0f];
        [annotationView.layer setBorderColor:[[UIColor grayColor] CGColor]];
        [annotationView.imageView setClipsToBounds:YES];
        [annotationView.imageView.layer setCornerRadius:10.0f];
        
        [annotationView setCanShowCallout:YES];
         annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    //If this is the current location then use the usedata
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        if (nil == currentSession.userData.profileImage)
        {
            [annotationView.imageView setImage:defaultUserPic];
            [currentSession.userData performSelectorInBackground:@selector(downloadProfileImage:) withObject:annotationView.imageView];
        }
        else
        {
            [annotationView.imageView setImage:currentSession.userData.profileImage];
        }        
    }
    else
    {
        //Use the location data for the other plates
        PlacesAnnotation *placesAnnotation = (PlacesAnnotation*)annotation;
        
        if (nil == placesAnnotation.userData.profileImage)
        {
            [annotationView.imageView setImage:defaultUserPic];
            [placesAnnotation.userData performSelectorInBackground:@selector(downloadProfileImage:) withObject:annotationView.imageView];            
        }
        else
        {
            [annotationView.imageView setImage:placesAnnotation.userData.profileImage];
        }
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSString *userId = nil;
    ProfileViewController *profile = (ProfileViewController*)[PlateMeViewController dequeueReusableView:[ProfileViewController class] :navController];
    
    if ([view isKindOfClass:[PlacesAnnotationView class]])
    {
        if ([view.annotation isKindOfClass:[PlacesAnnotation class]])
        {
            PlacesAnnotation *placesAnnotation = (PlacesAnnotation*)((PlacesAnnotationView*)view).annotation;
            
            userId = placesAnnotation.plateData.associatedAccountId;
        }
        else
        {
            userId = [[[PlateMeSession currentSession] userData] userId];
        }
    }
    
    if (nil != userId)
    {
        [PMLoadingView invokeWithLoading:@selector(loadSelectedProfile::::) onTarget:[ProfileViewController class] :@"" :self.view, userId, profile, navController, pmServer,nil];         
    }
}

@end
