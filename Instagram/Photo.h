//
//  Photo.h
//  Instagram
//
//  Created by Saulo Arruda Coelho on 7/23/12.
//  Copyright (c) 2012 Jera. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PhotoDownloadDelegate <NSObject>

- (void)photoDownloadFailWithError:(NSError*)error;
- (void)photoDownloadDidFinish:(UIImage*)image;
- (void)photoDownloadDidProgress:(float)progress;

@end

@interface Photo : NSObject<NSURLConnectionDataDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSString* longDescription;
@property (nonatomic, strong) NSDate* createdAt;
@property (nonatomic, strong) NSString* url;

+ (NSArray*)photosArrayFromJson:(NSArray*)photosJson;

- (void)downloadWithDelegate:(id<PhotoDownloadDelegate>)delegate;

@end
