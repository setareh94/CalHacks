//
//  UIImageView+PPUtilities.h
//  ParseKit
//
//  Created by Ashkon Farhangi on 2/25/14.
//  Copyright (c) 2014 Ashkon Farhangi. All rights reserved.
//

@class PFFile;

@interface UIImageView (PKUtilities)

- (void)pk_setImageWithFile:(PFFile *)file;
- (void)pk_setImageWithFile:(PFFile *)file showActivityIndicator:(BOOL)showActivityIndicator;
- (void)pk_setImageWithFile:(PFFile *)file adjustment:(UIImage * (^)(UIImage *image))adjustment showActivityIndicator:(BOOL)showActivityIndicator; // The adjustment block must return the final image to use

@end
