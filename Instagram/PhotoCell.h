//
//  PhotoCell.h
//  Instagram
//
//  Created by Saulo Arruda Coelho on 7/23/12.
//  Copyright (c) 2012 Jera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface PhotoCell : UITableViewCell<PhotoDownloadDelegate>

- (void)configureWithPhoto:(Photo*)photo;

@end
