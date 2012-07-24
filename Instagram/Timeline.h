//
//  Timeline.h
//  Instagram
//
//  Created by Saulo Arruda Coelho on 7/23/12.
//  Copyright (c) 2012 Jera. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TimelineLoadDelegate <NSObject>

- (void)timelineDidFinishLoad:(NSArray*)photos;
- (void)timelineLoadFailWithError:(NSError*)error;

@end

@interface Timeline : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

+ (Timeline*)sharedInstance;

- (void)allPhotosWithDelegate:(id<TimelineLoadDelegate>)delegate;

@end
