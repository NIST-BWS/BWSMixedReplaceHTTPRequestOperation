// This software was developed at the National Institute of Standards and
// Technology (NIST) by employees of the Federal Government in the course
// of their official duties. Pursuant to title 17 Section 105 of the
// United States Code, this software is not subject to copyright protection
// and is in the public domain. NIST assumes no responsibility whatsoever for
// its use by other parties, and makes no guarantees, expressed or implied,
// about its quality, reliability, or any other characteristic.

#import "AFHTTPClient.h"
#import "BWSMixedReplaceHTTPRequestOperation.h"

#import "BWSViewController.h"

@interface BWSViewController ()

@property (nonatomic, strong) BWSMixedReplaceHTTPRequestOperation *operation;

@end

@implementation BWSViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self startStreaming];
}

- (void)startStreaming
{
	self.operation =
	[BWSMixedReplaceHTTPRequestOperation mixedReplaceOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8800"]]
							  replacementReceived:^(NSData *data) {
								  [self.webView loadHTMLString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] baseURL:[NSURL URLWithString:@""]];
							  } success:^(NSURLRequest *request, NSURLResponse *response) {
								  NSLog(@"Stream complete.");
							  } failure:^(NSURLRequest *request, NSError *error) {
								  NSLog(@"%@", error.description);
							  }
	 ];

	[self.operation start];
}

@end
