//
//  PlateMeNavigationController.m
//  PlateMe
//
//  Created by Kevin Calcote on 1/16/12.
//  Copyright (c) 2012 PlateMe.com. All rights reserved.
//

#import "PlateMeNavigationController.h"
#import "PlateMeViewController.h"

@implementation PlateMeNavigationController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navToHomeButton = [[[UIButton alloc] init] retain];
    [navToHomeButton setBackgroundColor:[UIColor clearColor]];
    [self.navigationBar addSubview:navToHomeButton];
    
    CGRect navBarBounds = self.navigationBar.bounds;
    navBarBounds.size.width = 200;
    navBarBounds.size.height -= 10;
    [navToHomeButton setFrame:navBarBounds];
    [navToHomeButton setCenter:CGPointMake(170, self.navigationBar.frame.size.height/2)];
    
    // Add target to pop to root
    [navToHomeButton addTarget: self action:@selector(popToRootViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
}

- (UIViewController*) popViewControllerAnimated:(BOOL)animated
{
    UIViewController *poppedController = [super popViewControllerAnimated:animated];
    
    if ([poppedController isKindOfClass:[PlateMeViewController class]])
    {
        PlateMeViewController *plateMeController = (PlateMeViewController*)poppedController;
        
        [plateMeController viewControllerRemovedFromNavController];
    }
    
    [PlateMeViewController enqueueReusableView:(PlateMeViewController*)poppedController];
    
    return poppedController;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    NSMutableArray *poppedControllers = [[[NSMutableArray alloc] init] autorelease];
    
    while(self.viewControllers.count > 1)
    {
        [poppedControllers addObject:self.topViewController];
        if (self.viewControllers.count == 2)
            [self popViewControllerAnimated:YES];
        else
            [self popViewControllerAnimated:NO];
    }
    
    return poppedControllers;
}

@end
