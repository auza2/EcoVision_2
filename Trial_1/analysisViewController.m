//
//  analysisViewController.m
//  Trial_1
//
//  Created by Jamie Auza on 5/20/16.
//  Copyright © 2016 Jamie Auza. All rights reserved.
//

#import "analysisViewController.h"
#import "CVWrapper.h"

@implementation analysisViewController
UIImage* plainImage2 = nil;

- (void) viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    plainImage2 = [CVWrapper getCurrentImage];                                //get a copy if the normal image
    
    // Why doesn't the getCurrentImage work?
    
}

#pragma mark - Navigations

/*
 * Can use this method after buttonizeButtonTap to instantiate anything before you segue into the next scene
 *
 * @param segue The name of the segue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toGI"])
    {
        // Set some properties of the next view controller ( for send data )
        //takeAPictureViewController *takeAPictureViewController = [segue destinationViewController];
        
    }
}

/*
 * This is the method we call when we want to segue to the Take a Picture Scene
 */
-(void)buttonizeButtonTap:(id)sender{
    [self performSegueWithIdentifier:@"toGI" sender:sender];
}

#pragma mark - IBAction
- (IBAction)toCalibrate:(id)sender {
    [self buttonizeButtonTap:self];
}
@end
