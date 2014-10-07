//
//  AdImageView.h
//  CalHacks
//
//  Created by Setareh Lotfi on 10/4/14.
//  Copyright (c) 2014 SetarehLotfi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AdImageView : UIImageView
@property (nonatomic, strong) UIImage *placeholderImage;
- (void) setFile:(PFFile *)file;

@end
