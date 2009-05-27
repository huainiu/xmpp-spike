//
//  xmpp_spikeAppDelegate.m
//  xmpp-spike
//
//  Created by  on 5/25/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "xmpp_spikeAppDelegate.h"
#import "xmpp_spikeViewController.h"

@implementation xmpp_spikeAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
