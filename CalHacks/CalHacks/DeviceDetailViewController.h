//
//  DeviceDetailViewController.h
//  CalHacks
//
//  Created by Setareh Lotfi on 10/4/14.
//  Copyright (c) 2014 SetarehLotfi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *versionTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;

@property (strong) NSManagedObject *device;


- (IBAction)cancel:(id)sender;

- (IBAction)save:(id)sender;

@end