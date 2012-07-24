//
//  Photo.m
//  Instagram
//
//  Created by Saulo Arruda Coelho on 7/23/12.
//  Copyright (c) 2012 Jera. All rights reserved.
//

#import "Photo.h"
#import "Constants.h"

@interface Photo ()

@property (nonatomic, weak) id<PhotoDownloadDelegate> delegate;
@property (nonatomic, strong) NSMutableData* receivedData;
@property (nonatomic, strong) UIImage* photoImage;

@end

@implementation Photo

@synthesize longDescription, url, createdAt;
@synthesize delegate = _delegate;
@synthesize receivedData = _receivedData;
@synthesize photoImage = _photoImage;

+ (NSArray*)photosArrayFromJson:(NSArray*)photosJson
{
    NSMutableArray* photosArray = [[NSMutableArray alloc] initWithCapacity:[photosJson count]];
    for (NSDictionary* photoJson in photosJson) {
        Photo* photo = [[Photo alloc] init];
        photo.url = [photoJson objectForKey:@"url"];
        photo.longDescription = [photoJson objectForKey:@"description"];
        photo.createdAt = [photoJson objectForKey:@"created_at"];
        [photosArray addObject:photo];
    }
    return photosArray;
}

- (void)downloadWithDelegate:(id<PhotoDownloadDelegate>)delegate
{
    if (self.photoImage) 
        [delegate photoDownloadDidFinish:self.photoImage];
    else {
        NSURL* nsurl = [NSURL URLWithString:self.url];
        NSURLRequest* request = [NSURLRequest requestWithURL:nsurl];
        NSURLConnection* connection = [NSURLConnection connectionWithRequest:request delegate:self];
        if (connection) {
            self.delegate = delegate;
            self.receivedData = [[NSMutableData alloc] init];
        }
    }
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error loading image: %@", error);
    [self.delegate photoDownloadFailWithError:error];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.photoImage = [UIImage imageWithData:self.receivedData];
    [self.delegate photoDownloadDidFinish:self.photoImage];
    self.delegate = nil;
}

@end
