//
//  PhotoCell.m
//  Instagram
//
//  Created by Saulo Arruda Coelho on 7/23/12.
//  Copyright (c) 2012 Jera. All rights reserved.
//

#import "PhotoCell.h"

@interface PhotoCell ()

@property (nonatomic, weak) IBOutlet UIImageView* photoImageView;

@end

@implementation PhotoCell

@synthesize photoImageView;

- (void)configureWithPhoto:(Photo*)photo
{
    [self.photoImageView setHidden:YES];
    [photo downloadWithDelegate:self];
}

#pragma mark - PhotoDownloadDelegate

- (void)photoDownloadDidFinish:(UIImage *)image
{
    self.photoImageView.image = image;
    [self.photoImageView setHidden:NO];
}

- (void)photoDownloadFailWithError:(NSError *)error
{
    
}

@end
