#import <UIKit/UIKit.h>
#import "XMPP.h"


@interface xmpp_spikeViewController : UIViewController {

	XMPPClient* client;
	
	IBOutlet UITextView* logView;
	
	IBOutlet UITextField* toField;
	IBOutlet UITextView*  messageView;
}

-(IBAction)onSend: (id) sender;

@end