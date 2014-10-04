//
//  AddStorageFormViewController.m
//  CalHacks
//
//  Created by Pierre Karpov on 10/4/14.
//  Copyright (c) 2014 SetarehLotfi. All rights reserved.
//

#import "AddStorageFormViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreLocation/CoreLocation.h>

@interface AddStorageFormViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) UITableView *aTableView;

@property (strong, nonatomic) NSString *offerTitle;
@property (nonatomic) NSInteger offerPrice;
@property (strong, nonatomic) NSString *offerDescription;
@property (strong, nonatomic) NSString *offerAddress;
@property (nonatomic) NSInteger offerLocationX;
@property (nonatomic) NSInteger offerLocationY;
@property (strong, nonatomic) NSString *offerEmail;

@property (strong, nonatomic) UIImage *offerImage;
@property (strong, nonatomic) UIView *imagePreviewView;

@property (strong, nonatomic) UITextField *offerTitleTextField;
@property (strong, nonatomic) UITextField *offerPriceTextField;
@property (strong, nonatomic) UITextField *offerDescriptionTextField;
@property (strong, nonatomic) UITextField *offerAddressTextField;
@property (strong, nonatomic) UITextField *offerEmailTextField;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation AddStorageFormViewController

#pragma mark - View life cycle functions

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect tableViewFrame = CGRectMake(10, 60, self.view.bounds.size.width - 20, 360);
    
    self.aTableView = [[UITableView alloc] initWithFrame:tableViewFrame];
    self.aTableView.dataSource = self;
    self.aTableView.delegate = self;
    [self.view addSubview:self.aTableView];
    
    
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper functions

- (void)useGeolocalization
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    //NSDate* eventDate = location.timestamp;
    self.offerLocationX = location.coordinate.longitude;
    self.offerLocationY = location.coordinate.latitude;
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
    UITableViewCell *cell = [self.aTableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType =  UITableViewCellAccessoryCheckmark;
    
    [self.locationManager stopMonitoringSignificantLocationChanges];
}


- (void)popupDescription
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Description" message:nil/*@"This is an example alert!"*/ delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1; //1 is for description alert
    [alert show];
}

- (void)createNewStorageOffer
{
    self.offerTitle = self.offerTitleTextField.text;
    self.offerPrice = [self.offerPriceTextField.text intValue];
    self.offerDescription = self.offerDescriptionTextField.text;
    self.offerAddress = self.offerAddressTextField.text;
    self.offerEmail = self.offerEmailTextField.text;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create new offer"
                                                    message:[NSString stringWithFormat:@"Is your offer correct?\nTitle: \"%@\"\nPrice: \"%d\"\nDescription: \"%@\"\nAddress: \"%@\"\nEmail: \"%@\"\nLongitude: \"%d\"\nLatitude: \"%d\"", self.offerTitle, (int)self.offerPrice, self.offerDescription, self.offerAddress, self.offerEmail, (int)self.offerLocationX, (int)self.offerLocationY]
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    alert.tag = 0; //0 is for creating an offer
    [alert addButtonWithTitle:@"OK"];
    [alert show];
    
}

- (void)takePicture
{
    UIImagePickerController *uiipc = [[UIImagePickerController alloc] init];
    uiipc.delegate = self;
    uiipc.mediaTypes = @[(NSString *)kUTTypeImage];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
        && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        uiipc.sourceType = UIImagePickerControllerSourceTypeCamera|UIImagePickerControllerSourceTypePhotoLibrary;
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
               && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        uiipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    } else if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
              && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        uiipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    } else {
        //ERROR?
    }
    uiipc.allowsEditing = YES;
    
    [self presentViewController:uiipc animated:YES completion:NULL];
}

#pragma mark - UIImagePickerController delegate functions

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = info[UIImagePickerControllerEditedImage];
    if (!img) {
        img = info[UIImagePickerControllerOriginalImage];
    }
    self.offerImage = img;
    [self updateImagePreview];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Update UI functions

- (void)updateImagePreview
{
    UIView *aView = self.imagePreviewView;
    UIImage *anImage = self.offerImage;
    
    UIGraphicsBeginImageContext(aView.frame.size);
    [anImage drawInRect:aView.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    aView.backgroundColor = [UIColor colorWithPatternImage:image];
}

#pragma mark - Alert delegate functions

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) { //for description alert
        self.offerDescription = [[alertView textFieldAtIndex:0] text];
        self.offerDescriptionTextField.text = [[alertView textFieldAtIndex:0] text];
    }
}

#pragma mark - UITextField delegate functions

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UITableViewCell *cell = (UITableViewCell *)[(UIView *)[textField superview] superview];
    if(floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) { //checks for ios 7
        cell = (UITableViewCell *)[[[textField superview] superview] superview];
    }
    NSIndexPath *indexPath = [self.aTableView indexPathForCell:cell];

    [self.aTableView scrollToRowAtIndexPath:indexPath
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:YES];
    if (textField.tag == 2) {
        [textField resignFirstResponder];
        [self popupDescription];
    }
}

//TO HANDLE NEXT AND DONE RETURN BUTTONS
- (BOOL) textFieldShouldReturn:(UITextField *)tf {
    switch (tf.tag) {
        case 0: // Title
            [self.offerPriceTextField becomeFirstResponder];
            break;
        case 1: // Price
            [self.offerDescriptionTextField becomeFirstResponder];
            break;
        case 2: // Description
            [self.offerAddressTextField becomeFirstResponder];
            break;
        case 3: // Address
            [self.offerEmailTextField becomeFirstResponder];
            break;
        case 4: // Email
            [tf resignFirstResponder]; //[self.offerPriceTextField becomeFirstResponder];
            //MAYBE Create offer?
            break;
        default:
            [tf resignFirstResponder];
            break;
    }
    return YES;
}

#pragma mark - UITableViewDataSource functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4; //Hardcoded
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 3;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *kCellIdentifier = @"Form Cell";
    
    UITableViewCell *cell = nil; //[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:kCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if ([indexPath section] == 0) {
            UITextField *formTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            formTextField.adjustsFontSizeToFitWidth = YES;
            formTextField.textColor = [UIColor blackColor];
            if ([indexPath row] == 0) {
                formTextField.tag = 0; // 0 is for title
                formTextField.placeholder = @"example";
                formTextField.keyboardType = UIKeyboardTypeDefault;
                formTextField.returnKeyType = UIReturnKeyNext;
                formTextField.delegate = self;
            }
            else {
                formTextField.tag = 1; // 1 is for price
                formTextField.placeholder = @"Required";
                formTextField.keyboardType =  UIKeyboardTypeDefault; //UIKeyboardTypeNumberPad does not have a return button
                formTextField.returnKeyType = UIReturnKeyNext;
                formTextField.secureTextEntry = NO;
                formTextField.delegate = self;
            }
            formTextField.backgroundColor = [UIColor whiteColor];
            formTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
            formTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
            formTextField.delegate = self;
            
            formTextField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
            [formTextField setEnabled: YES];
            
            if ([indexPath row] == 0) {
                self.offerTitleTextField = formTextField;
            } else {
                self.offerPriceTextField = formTextField;
            }
            [cell.contentView addSubview:formTextField];
        } else if ([indexPath section] == 1) {
            UITextField *formTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            formTextField.adjustsFontSizeToFitWidth = YES;
            formTextField.textColor = [UIColor blackColor];
            
            formTextField.tag = 2; // 2 is for description
            formTextField.placeholder = @"description";
            formTextField.keyboardType = UIKeyboardTypeDefault;
            formTextField.returnKeyType = UIReturnKeyNext;
            formTextField.delegate = self;

            formTextField.backgroundColor = [UIColor whiteColor];
            formTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
            formTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
            formTextField.delegate = self;
            
            formTextField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
            [formTextField setEnabled: YES];
            
            self.offerDescriptionTextField = formTextField;
            [cell.contentView addSubview:formTextField];
        } else if ([indexPath section] == 2) {
            // address and email
            UITextField *formTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            formTextField.adjustsFontSizeToFitWidth = YES;
            formTextField.textColor = [UIColor blackColor];
            if ([indexPath row] == 0) {
                formTextField.tag = 3; // 3 is for address
                formTextField.placeholder = @"Address required";
                formTextField.keyboardType = UIKeyboardTypeDefault;
                formTextField.returnKeyType = UIReturnKeyNext;
                formTextField.delegate = self;
            }
            else {
                formTextField.tag = 4; // 4 is for email
                formTextField.placeholder = @"example@gmail.com";
                formTextField.keyboardType = UIKeyboardTypeEmailAddress;
                formTextField.returnKeyType = UIReturnKeyDone;
                formTextField.secureTextEntry = NO;
                formTextField.delegate = self;
            }
            formTextField.backgroundColor = [UIColor whiteColor];
            formTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
            formTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
            formTextField.delegate = self;
            
            formTextField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
            [formTextField setEnabled: YES];
            
            
            if ([indexPath row] == 0) {
                self.offerAddressTextField = formTextField;
            } else {
                self.offerEmailTextField = formTextField;
            }
            [cell.contentView addSubview:formTextField];
        } else if ([indexPath section] == 3) {
            //useful?
            /*if (self.offerImage) {
                CGRect rect = CGRectMake(10,10,40,40);
                UIGraphicsBeginImageContext( rect.size );
                [self.offerImage drawInRect:rect];
                UIGraphicsEndImageContext();
            }*/
            
            if ([indexPath row] == 0) {
                UIButton *geoLocateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [geoLocateButton addTarget:self
                                      action:@selector(useGeolocalization)
                            forControlEvents:UIControlEventTouchUpInside];
                [geoLocateButton setTitle:@"Use Geolocalization" forState:UIControlStateNormal];
                geoLocateButton.frame = CGRectMake((cell.frame.size.width - 185) / 2, 5, 185, 30);
                self.imagePreviewView = [[UIView alloc] initWithFrame:CGRectMake(20, 5, 35, 35)];
                [cell addSubview:self.imagePreviewView];
                [cell addSubview:geoLocateButton];
            } else if ([indexPath row] == 1) {
                UIButton *takePictureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [takePictureButton addTarget:self
                                      action:@selector(takePicture)
                            forControlEvents:UIControlEventTouchUpInside];
                [takePictureButton setTitle:@"Take Picture" forState:UIControlStateNormal];
                takePictureButton.frame = CGRectMake((cell.frame.size.width - 185) / 2, 5, 185, 30);
                self.imagePreviewView = [[UIView alloc] initWithFrame:CGRectMake(20, 5, 35, 35)];
                [cell addSubview:self.imagePreviewView];
                [cell addSubview:takePictureButton];
            }else {
                UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [doneButton addTarget:self
                               action:@selector(createNewStorageOffer)
                     forControlEvents:UIControlEventTouchUpInside];
                [doneButton setTitle:@"Post Offer" forState:UIControlStateNormal];
                doneButton.frame = CGRectMake((cell.frame.size.width - 185) / 2, 5, 185, 30);
                [cell addSubview:doneButton];
            }
        }
    }
    if ([indexPath section] == 0) { // Email & Password Section
        if ([indexPath row] == 0) { // Email
            cell.textLabel.text = @"Title";
        }
        else {
            cell.textLabel.text = @"Price";
        }
    } else if ([indexPath section] == 1) { //Description
        cell.textLabel.text = @"Description";
    } else if ([indexPath section] == 2) { //Address and email
        if ([indexPath row] == 0) { // Email
            cell.textLabel.text = @"Address";
        }
        else {
            cell.textLabel.text = @"Email";
        }
    }
    else {
        //cell.textLabel.text = @"Post Offer";
    }
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
