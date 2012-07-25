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
@property (nonatomic, weak) IBOutlet UIProgressView* photoProgressBar;
@property (nonatomic, weak) IBOutlet UILabel* errorLabel;

@end

@implementation PhotoCell

@synthesize photoImageView, photoProgressBar, errorLabel;

- (void)configureWithPhoto:(Photo*)photo
{
    [self.photoProgressBar setProgress:0];
    [self.photoImageView setHidden:YES];
    [self.photoProgressBar setHidden:NO];
    [self.errorLabel setHidden:YES];
    [photo downloadWithDelegate:self];
}

#pragma mark - PhotoDownloadDelegate

- (void)photoDownloadDidFinish:(UIImage *)image
{
    [self.photoProgressBar setHidden:YES];
    self.photoImageView.image = image;
    [self.photoImageView setHidden:NO];
}

- (void)photoDownloadFailWithError:(NSError *)error
{
    [self.errorLabel setHidden:NO];
    [self.photoProgressBar setHidden:YES];
}

- (void)photoDownloadDidProgress:(float)progress
{
    [self.photoProgressBar setProgress:progress];
}

@end
