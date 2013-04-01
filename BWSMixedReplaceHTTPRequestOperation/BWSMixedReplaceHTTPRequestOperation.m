// This software was developed at the National Institute of Standards and
// Technology (NIST) by employees of the Federal Government in the course
// of their official duties. Pursuant to title 17 Section 105 of the
// United States Code, this software is not subject to copyright protection
// and is in the public domain. NIST assumes no responsibility whatsoever for
// its use by other parties, and makes no guarantees, expressed or implied,
// about its quality, reliability, or any other characteristic.

#import "BWSMixedReplaceHTTPRequestOperation.h"

@interface BWSMixedReplaceHTTPRequestOperation ()

@property(nonatomic, assign) BOOL useContentLength;
@property(nonatomic, assign) NSUInteger multipartExpectedSize;
@property(nonatomic, strong) NSMutableData *multipartData;
@property(nonatomic, copy) __block void (^replace)(NSData *responseData);

@end

static NSString * const kBWSMixedReplaceHTTPRequestOperationMIMEType = @"multipart/x-mixed-replace";

@implementation BWSMixedReplaceHTTPRequestOperation

+ (instancetype)mixedReplaceOperationWithRequest:(NSURLRequest *)request
                             replacementReceived:(void (^)(NSData *responseData))replace
                                         success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response))success
                                         failure:(void (^)(NSURLRequest *request, NSError *error))failure
{
    BWSMixedReplaceHTTPRequestOperation *operation = [[BWSMixedReplaceHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setReplace:replace];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success != nil)
            success(operation.request, operation.response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure != nil)
            failure(operation.request, error);
    }];

    return (operation);
}

#pragma mark - Override NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [super connection:connection didReceiveResponse:response];

    // No Content-Size header field on multipart/x-mixed-replace transmission
    static BOOL firstTime = YES;
    if (firstTime) {
        if (![response.MIMEType isEqualToString:kBWSMixedReplaceHTTPRequestOperationMIMEType]) {
            NSLog(@"Expected MIME type of %@, got %@.", kBWSMixedReplaceHTTPRequestOperationMIMEType, response.MIMEType);
            [self cancel];
	        return;
        }

        firstTime = NO;
    }

    // Content-Length not strictly required, but abide if provided
    if (response.expectedContentLength != NSURLResponseUnknownLength) {
        self.useContentLength = YES;
	    self.multipartExpectedSize = response.expectedContentLength;
    	self.multipartData = [[NSMutableData alloc] initWithCapacity:self.multipartExpectedSize];
    } else {
        self.useContentLength = NO;
        
		if ((self.multipartData != nil) && (self.replace != nil))
        	self.replace(self.multipartData);

        // Reset data
        self.multipartData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [super connection:connection didReceiveData:data];

    [self.multipartData appendData:data];

    // Callback once all of the data has been received when using Content-Length
    if (self.useContentLength)
	    if ([self.multipartData length] == self.multipartExpectedSize)
	        if (self.replace != nil)
    	        self.replace(self.multipartData);
}

@end
