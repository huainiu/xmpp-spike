//
//  xmpp_spikeAppDelegate.h
//  xmpp-spike
//
//  Created by  on 5/25/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class xmpp_spikeViewController;

@interface xmpp_spikeAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    xmpp_spikeViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet xmpp_spikeViewController *viewController;

@end

