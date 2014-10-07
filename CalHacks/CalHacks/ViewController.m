//
//  ViewController.m
//  CalHacks
//
//  Created by Setareh Lotfi on 10/4/14.
//  Copyright (c) 2014 SetarehLotfi. All rights reserved.
//

#import "ViewController.h"
#import "DraggableViewBackground.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DraggableViewBackground *draggableBackground = [[DraggableViewBackground alloc]initWithFrame:self.view.frame];
    [self.view addSubview:draggableBackground];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
