// This software was developed at the National Institute of Standards and
// Technology (NIST) by employees of the Federal Government in the course
// of their official duties. Pursuant to title 17 Section 105 of the
// United States Code, this software is not subject to copyright protection
// and is in the public domain. NIST assumes no responsibility whatsoever for
// its use by other parties, and makes no guarantees, expressed or implied,
// about its quality, reliability, or any other characteristic.

#import "AFHTTPRequestOperation.h"

@interface BWSMixedReplaceHTTPRequestOperation : AFHTTPRequestOperation

/// @brief
/// Initiate a request for a multipart/x-mixed-replace endpoint.
///
/// @param request
/// NSURLRequest for an endpoint that returns multipart/x-mixed-replace content.
/// @param replace
/// Block executed once a single replacement value has been received.
/// @param success
/// Block executed once a successful connection has closed.
/// @param error
/// Block executed if there is an error opening the connection.
///
/// @return
/// Request object that can be enqueued with an AFHTTPClient.
+ (instancetype)mixedReplaceOperationWithRequest:(NSURLRequest *)request
                             replacementReceived:(void (^)(NSData *responseData))replace
                                         success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response))success
                                         failure:(void (^)(NSURLRequest *request, NSError *error))failure;

@end
