//
//  Timeline.m
//  Instagram
//
//  Created by Saulo Arruda Coelho on 7/23/12.
//  Copyright (c) 2012 Jera. All rights reserved.
//

#import "Timeline.h"
#import "Constants.h"
#import "Photo.h"

static Timeline* sharedInstance;

@interface Timeline ()

@property (nonatomic, weak) id<TimelineLoadDelegate> delegate;
@property (nonatomic, strong) NSMutableData* receivedData;

@end

@implementation Timeline

@synthesize delegate = _delegate;
@synthesize receivedData = _receivedData;

+ (Timeline*)sharedInstance
{
    if (!sharedInstance) sharedInstance = [[Timeline alloc] init];
    return sharedInstance;
}

- (void)allPhotosWithDelegate:(id<TimelineLoadDelegate>)delegate
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:TIMELINE_URL_FORMAT, API_ROOT]];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
    NSURLConnection* connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    if (connection) {
        self.delegate = delegate;
        self.receivedData = [[NSMutableData alloc] init];
    }
}

#pragma mark - NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error loading timeline: %@", error);
    [self.delegate timelineLoadFailWithError:error];
    self.delegate = nil;
}

#pragma mark - NSURLConnectionDataDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError* error;
    NSArray* photosJson = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        NSLog(@"Error reading timeline json: %@", error);
        [self.delegate timelineLoadFailWithError:error];
    }
    [self.delegate timelineDidFinishLoad:[Photo photosArrayFromJson:photosJson]];
    self.delegate = nil;
}

@end
