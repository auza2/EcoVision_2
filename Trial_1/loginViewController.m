//
//  loginViewController.m
//  Trial_1
//
//  Created by Jamie Auza on 5/12/16.
//  Copyright © 2016 Jamie Auza. All rights reserved.
//

#import "loginViewController.h"
#import "takeAPictureViewController.h"

@interface loginViewController ()

@end

@implementation loginViewController

@synthesize serverIP;
@synthesize groupNumber;

/*
 *  I don't know why this is here.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *buttonizeButton = [[UIBarButtonItem alloc] initWithTitle:@"Buttonize"
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(buttonizeButtonTap:)];
    self.navigationItem.rightBarButtonItems = @[buttonizeButton];
}

/*
 * I don't know why this is here
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * Can use this method after buttonizeButtonTap to instantiate anything before you segue into the next scene
 * 
 * @param segue The name of the segue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Associate"])
    {
        // Set some properties of the next view controller ( for send data )
        takeAPictureViewController *takeAPictureViewController = [segue destinationViewController];
        takeAPictureViewController.groupNumber = self.grpNumber;
        takeAPictureViewController.IPAddress = self.IPAddress;
    }
}



// Jamie's Code


/*
 * This is the method we call when we want to segue to the Take a Picture Scene
 */
-(void)buttonizeButtonTap:(id)sender{
    [self performSegueWithIdentifier:@"Associate" sender:sender];
}

/*
 * General method to throw an alert message
 *
 * @param the error message that goes along with the error ebing thrown
 */
- (void) throwErrorAlert:(NSString*) alertString {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:alertString delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
    [alert show];
    //self.scrollView.backgroundColor = [UIColor whiteColor]; // hides scrollView ( we don't really need this cause we don't have one in this Scene
}

/*
 * This method checks if the user put in a Server IP and Group Number before segueing (sp?) to the "Take a Picture" scene.
 * If the user left the text fields empty, do not segue.
 */
- (IBAction)begin:(id)sender {
    NSLog(@"BEFORE");
    
    NSString *server = serverIP.text;
    NSString *group = groupNumber.text;
    
    // Testing
    NSLog(@"%@: %@",serverIP.text, groupNumber.text);
    
    
    // Checks if the user filled in the Server IP and Group Number
    if(![server  isEqual: @""] &&  ![group  isEqual: @""]){
        // Initializing IPAddress and Group Number
        _IPAddress = @"%@" , server;
        _grpNumber = [group intValue];
        
        // Segue to the next scene
        [self buttonizeButtonTap:(id)sender];
        return;
    } else {
        [self throwErrorAlert: @"Please Enter both a Server IP and a Group Number before proceeding."];
    }
    
    
    return;
}
@end
