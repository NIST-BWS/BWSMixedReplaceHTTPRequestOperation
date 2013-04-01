# BWSMixedReplaceHTTPRequestOperation

`BWSMixedReplaceHTTPRequestOperation` is an [`AFHTTPRequestOperation`](http://engineering.gowalla.com/AFNetworking/Classes/AFHTTPRequestOperation.html) subclass for handling [`multipart/x-mixed-replace`](http://en.wikipedia.org/wiki/MIME#Mixed-Replace), for use with [`AFNetworking`](https://github.com/AFNetworking/AFNetworking) Cocoa projects. This is useful for streaming data from web servers, like IP cameras or biometric sensors.

## How To Use
 1. Add `BWSMixedReplaceHTTPRequestOperation.[hm]` into your Xcode project that is already set up to use `AFNetworking`.
 2. Call `mixedReplaceOperationWithRequest:replacementReceived:success:failure`, where `replacementReceived` a block executed with the last complete chunk of data received. 
    * **Note** that it is the caller's responsibility to ensure that the data provided is well-formed.  In cases where large data chunks is being streamed extremely rapidly, iOS could truncate a chunk to keep up.

## How To Test

 1. Clone the [`Multipart-Streaming-HTTP-Server`](https://github.com/hsjunnesson/Multipart-Streaming-HTTP-Server) submodule.
 2. Run `server.rb`
    * This will create a server running on port 8080 on your local machine that streams the current date and time for 10 seconds.
    
## License

This software was developed at the [National Institute of Standards and Technology (NIST)](http://nist.gov) by employees of the Federal Government in the course of their official duties. Pursuant to title 17, section 105 of the United States Code, this software is not subject to copyright protection and is in the **public domain**. NIST assumes no responsibility whatsoever for its use by other parties, and makes no guarantees, expressed or implied, about its quality, reliability, or any other characteristic.

Licensing information for `Multipart-Streaming-HTTP-Server` and `AFNetworking` can be found on the [`Multipart-Streaming-HTTP-Server`](https://github.com/hsjunnesson/Multipart-Streaming-HTTP-Server) and [`AFNetworking`](https://github.com/AFNetworking/AFNetworking) GitHub pages respectively.
