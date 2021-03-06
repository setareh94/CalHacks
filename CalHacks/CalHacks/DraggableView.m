//
//  DraggableView.m
//  testing swiping
//
//  Created by Richard Kim on 5/21/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//
//  @cwRichardKim for updates and requests

#define ACTION_MARGIN 120 //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
#define SCALE_STRENGTH 4 //%%% how quickly the card shrinks. Higher = slower shrinking
#define SCALE_MAX .93 //%%% upper bar for how much the card shrinks. Higher = shrinks less
#define ROTATION_MAX 1 //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
#define ROTATION_STRENGTH 320 //%%% strength of rotation. Higher = weaker rotation
#define ROTATION_ANGLE M_PI/8 //%%% Higher = stronger rotation angle


#import "DraggableView.h"
#import <Parse/Parse.h>

@implementation DraggableView {
    CGFloat xFromCenter;
    CGFloat yFromCenter;
}

//delegate is instance of ViewController
//@synthesize delegate;
//
//@synthesize panGestureRecognizer;
//@synthesize information;
//@synthesize overlayView;
//@synthesize Closet;

- (id)initWithFrame:(CGRect)frame andData:(PFObject *)data
{
    self = [super initWithFrame:frame];
    if (self) {
        self.data = data;
        [self setupView];
        PFQuery *myNames = [PFQuery queryWithClassName:@"Data"];
//        PFImageView *creature = [[PFImageView alloc] init];
//        self.Closet.image = [UIImage imageNamed:@"delivery123"]; // placeholder image
//        creature.file = (PFFile *)file;
//        [creature loadInBackground];
        CGFloat topPadding = 180.f;
//        self.imageView = [[PFImageView alloc] initWithFrame:CGRectMake(floorf((CGRectGetWidth(self.bounds) - self.imageView.image.size.width)/2),
//                                                                      topPadding,
//                                                                      self.imageView.image.size.width,
//                                                                      self.imageView.image.size.height)];
        
        self.imageView = [[PFImageView alloc] initWithFrame:CGRectMake(45,
                                                                       topPadding,
                                                                       200,
                                                                       200)];

        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.backgroundColor = [UIColor blackColor];
//        [myNames getObjectInBackgroundWithId:@"XAYUWIHprG"
//                                       block:^(PFObject *textdu, NSError *error) {
//                                           {
//                                               // Getting Picture from Parse
//                                               if (!error) {
//                                                   
//                                                   PFFile *imageFile = [textdu objectForKey:@"Picture"];
//                                                   // Tell the PFImageView about  file
//                                                   self.imageView.file = self.file;
//                                                   [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//                                                       if (!error) {
//                                                           self.imageView.image = [UIImage imageWithData:data];
//                                                           [self.imageView loadInBackground];
//
//                                                           
//                                                       }
//                                                   }];
//                                               }
//                                           }
//                                       }];
        
#warning placeholder stuff, replace with card-specific information {
        
        NSLog(@"%@", self.data.allKeys);
        [[self.data objectForKey:@"Picture"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                    self.imageView.image = [UIImage imageWithData:data];
                    [self.imageView loadInBackground:^(UIImage *image, NSError *error) {
                        if (error) {
                            NSLog(@"%@", error);
                        } else {
                            NSLog(@"loaded");
                        }
                    }];
            }
        }];

        self.information = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, self.frame.size.width, 100)];
        
        self.information.text = [self.data objectForKey:@"Title"];
        [self.information setTextAlignment:NSTextAlignmentCenter];
        UIFont *myFont = [UIFont fontWithName:@"PoetsenOne-Regular" size:20.0f];
        [self.information setFont:myFont];

        self.information.textColor = [UIColor blackColor];
        
        self.backgroundColor = [UIColor whiteColor];
        for (NSString* family in [UIFont familyNames])
        {
            NSLog(@"%@", family);
            
            for (NSString* name in [UIFont fontNamesForFamilyName: family])
            {
                NSLog(@"  %@", name);
            }
        }
#warning placeholder stuff, replace with card-specific information }
//        self.Closet = [[UIImageView alloc] initWithImage:self.imageView];
        NSLog (@"loadddddd");
//        self.Closet.contentMode = UIViewContentModeScaleAspectFit;
//        CGFloat topPadding = 10.f;
//        self.Closet.frame = CGRectMake(floorf((CGRectGetWidth(self.bounds) - self.imageView.image.size.width)/2),
//                                  topPadding,
//                                  self.imageView.image.size.width,
//                                  self.imageView.image.size.height);
//        self.Closet.backgroundColor = [UIColor blackColor];
        
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(beingDragged:)];
        
        [self addGestureRecognizer:self.panGestureRecognizer];
        [self addSubview:self.information];
        
        self.overlayView = [[OverlayView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-100, 0, 100, 100)];
        self.overlayView.alpha = 0;
        [self addSubview:self.overlayView];
        [self addSubview:self.imageView];
    }
    return self;
}

-(void)setupView
{
    self.layer.cornerRadius = 4;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeMake(1, 1);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//%%% called when you move your finger across the screen.
// called many times a second
-(void)beingDragged:(UIPanGestureRecognizer *)gestureRecognizer
{
    //%%% this extracts the coordinate data from your swipe movement. (i.e. How much did you move?)
    xFromCenter = [gestureRecognizer translationInView:self].x; //%%% positive for right swipe, negative for left
    yFromCenter = [gestureRecognizer translationInView:self].y; //%%% positive for up, negative for down
    
    //%%% checks what state the gesture is in. (are you just starting, letting go, or in the middle of a swipe?)
    switch (gestureRecognizer.state) {
            //%%% just started swiping
        case UIGestureRecognizerStateBegan:{
            self.originalPoint = self.center;
            break;
        };
            //%%% in the middle of a swipe
        case UIGestureRecognizerStateChanged:{
            //%%% dictates rotation (see ROTATION_MAX and ROTATION_STRENGTH for details)
            CGFloat rotationStrength = MIN(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX);
            
            //%%% degree change in radians
            CGFloat rotationAngel = (CGFloat) (ROTATION_ANGLE * rotationStrength);
            
            //%%% amount the height changes when you move the card up to a certain point
            CGFloat scale = MAX(1 - fabsf(rotationStrength) / SCALE_STRENGTH, SCALE_MAX);
            
            //%%% move the object's center by center + gesture coordinate
            self.center = CGPointMake(self.originalPoint.x + xFromCenter, self.originalPoint.y + yFromCenter);
            
            //%%% rotate by certain amount
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            
            //%%% scale by certain amount
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            
            //%%% apply transformations
            self.transform = scaleTransform;
            [self updateOverlay:xFromCenter];
            
            break;
        };
            //%%% let go of the card
        case UIGestureRecognizerStateEnded: {
            [self afterSwipeAction];
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}

//%%% checks to see if you are moving right or left and applies the correct overlay image
-(void)updateOverlay:(CGFloat)distance
{
    if (distance > 0) {
        self.overlayView.mode = GGOverlayViewModeRight;
    } else {
        self.overlayView.mode = GGOverlayViewModeLeft;
    }
    
    self.overlayView.alpha = MIN(fabsf(distance)/100, 0.4);
}

//%%% called when the card is let go
- (void)afterSwipeAction
{
    if (xFromCenter > ACTION_MARGIN) {
        [self rightAction];
    } else if (xFromCenter < -ACTION_MARGIN) {
        [self leftAction];
    } else { //%%% resets the card
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.center = self.originalPoint;
                             self.transform = CGAffineTransformMakeRotation(0);
                             self.overlayView.alpha = 0;
                         }];
    }
}

//%%% called when a swipe exceeds the ACTION_MARGIN to the right
-(void)rightAction
{
    CGPoint finishPoint = CGPointMake(500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [self.delegate cardSwipedRight:self];
    
    NSLog(@"YES");
}

//%%% called when a swip exceeds the ACTION_MARGIN to the left
-(void)leftAction
{
    CGPoint finishPoint = CGPointMake(-500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [self.delegate cardSwipedLeft:self];
    
    NSLog(@"NO");
}

-(void)rightClickAction
{
    CGPoint finishPoint = CGPointMake(600, self.center.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(1);
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [self.delegate cardSwipedRight:self];
    
    NSLog(@"YES");
}

-(void)leftClickAction
{
    CGPoint finishPoint = CGPointMake(-600, self.center.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(-1);
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [self.delegate cardSwipedLeft:self];
    
    NSLog(@"NO");
}



@end
