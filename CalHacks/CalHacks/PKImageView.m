//
//  PKImageView.m
//  ParseKit
//
//  Created by Ashkon Farhangi on 2/25/14.
//  Copyright (c) 2014 Ashkon Farhangi. All rights reserved.
//

#import "PKImageView.h"

#import "UIImageView+PKUtilities.h"

@implementation PKImageView

- (void)setImageWithFile:(PFFile *)file placeholder:(UIImage *)placeholder
{
    self.image = placeholder;
    self.imageFile = file;
}

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _setup];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        [self _setup];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    self = [super initWithImage:image highlightedImage:highlightedImage];
    if (self) {
        [self _setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)_setup
{
    self.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Setters and Getters

- (void)setImageFile:(PFFile *)imageFile
{
    if (imageFile != _imageFile) {
        _imageFile = imageFile;
        [self pk_setImageWithFile:imageFile];
    }
}

@end
