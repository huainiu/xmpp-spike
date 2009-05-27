#import "xmpp_spikeViewController.h"
#import "NSArray+Utils.h"


@implementation xmpp_spikeViewController


- (void) viewDidLoad{
	[super viewDidLoad];
	
	logView.contentSize = CGSizeMake(320, 1000);

	client = [XMPPClient new];
	
	[client addDelegate:self];
	
	client.myJID = [XMPPJID jidWithString: @"test2@ilya.local"];

	client.autoLogin = YES;
//	client.allowsPlaintextAuth = ;
	client.autoPresence = YES;
	client.autoRoster = YES;
	client.autoReconnect = YES;
//	client.port = ;
//	client.usesOldStyleSSL = ;
	client.password = @"12345";
//	client.priority = ;
	client.allowsSelfSignedCertificates = YES;
	client.allowsSSLHostNameMismatch = YES;
	client.domain = @"ilya.local";
	
	[client connect];
}



- (void) dealloc{
	[toField release];
	[messageView release];
	
	[client release];
	[super dealloc];
}

#pragma mark private

-(void)log: (NSString*) format, ...{
	va_list varArgsList;
	va_start(varArgsList, format);
	NSString *formatString   = [[[NSString alloc] initWithFormat:format arguments:varArgsList] autorelease];
	va_end(varArgsList);
	
	logView.text = [logView.text stringByAppendingFormat: @"\n%@", formatString];
	[logView scrollRangeToVisible: NSMakeRange(logView.text.length - 1, 1)];
	NSLog(@"%@", formatString);
}

-(void)sendMessage: (NSString*)msg toUser: (XMPPUser*)user{
	[client sendMessage:msg toJID: user.jid];
}

-(XMPPUser*) buddyByName: (NSString*)name{
	NSArray* users = [client unsortedUsers];	
	BOOL fnIsVictim(XMPPUser* u){return [u.displayName isEqual:name];}
	XMPPUser* buddy = [users detect:fnIsVictim];
	return buddy;
}

-(void)sendTestMessage{	
	NSArray* users = [client unsortedUsers];

	NSString* victimName = @"test1@ilya.local";
	BOOL fnIsVictim(XMPPUser* u){return [u.displayName isEqual:victimName];}	
	XMPPUser* victim = [users detect:fnIsVictim];
	if(victim){
		[self sendMessage: @"Hello!" toUser: victim];
	}else {
		[self log:@"User %@ not found", victimName];
	}	
}


#pragma mark ui callbacks

-(IBAction)onSend: (id) sender{	
	
	NSString* buddyName = toField.text;
	XMPPUser* buddy = [self buddyByName:buddyName];
	
	if(!buddy){
		[self log:@"buddy %@ not found!", buddyName];
		return;
	}
	
	NSString* msg = messageView.text;	
	[self sendMessage: msg toUser: buddy];	
}



#pragma mark XMPPClient delegate

- (void)xmppClientConnecting:(XMPPClient *)sender{
	[self log:@"connecting..."];
}

- (void)xmppClientDidConnect:(XMPPClient *)sender{
	[self log:@"connected!"];
}

- (void)xmppClientDidNotConnect:(XMPPClient *)sender{
	[self log:@"failed to connect!"];
}

- (void)xmppClientDidDisconnect:(XMPPClient *)sender{
	[self log:@"disconnected"];
}

- (void)xmppClientDidRegister:(XMPPClient *)sender{
	[self log:@"registered"];
}

- (void)xmppClient:(XMPPClient *)sender didNotRegister:(NSXMLElement *)error{
	[self log:@"did not registered"];
}

- (void)xmppClientDidAuthenticate:(XMPPClient *)sender{
	[self log:@"authenticated"];
}

- (void)xmppClient:(XMPPClient *)sender didNotAuthenticate:(NSXMLElement *)error{
	[self log:@"did not authenicate"];
}

- (void)xmppClientDidUpdateRoster:(XMPPClient *)sender{
	[self log:@"contact list updated:"];	
	NSArray* users = [client unsortedUsers];
	for(XMPPUser* u in users){
		[self log:@"  %@", u];
	}
}

- (void)xmppClient:(XMPPClient *)sender didReceiveBuddyRequest:(XMPPJID *)jid{
	[self log:@"recieved buddy request: %@", jid];
}

- (void)xmppClient:(XMPPClient *)sender didReceiveIQ:(XMPPIQ *)iq{
	[self log:@"recieved IQ: %@", iq];
}

- (void)xmppClient:(XMPPClient *)sender didReceiveMessage:(XMPPMessage *)message{
	
	NSXMLElement* body = [message elementForName:@"body"];
	id subject;
	if(body){
		subject = [body stringValue]; 
		[self log:@"recieved message from %@:\n%@", message.fromStr, subject];
	}	
}

@end
