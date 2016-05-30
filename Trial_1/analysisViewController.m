//
//  analysisViewController.m
//  Trial_1
//
//  Created by Jamie Auza on 5/20/16.
//  Copyright © 2016 Jamie Auza. All rights reserved.
//

#import "analysisViewController.h"
#import "Swale.h"
#import "GreenRoof.h"
#import "CVWrapper.h"

@implementation analysisViewController
@synthesize currentImage_A;
UIImage* plainImage2 = nil;

- (void) viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //plainImage2 = [CVWrapper getCurrentImage];                                //get a copy if the normal image
    
    // Why doesn't the getCurrentImage work?
    plainImage2 = currentImage_A;
    [self updateScrollView:plainImage2];
    
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
        
        
        // Swale *swale = [segue destinationViewController];
        //swale.currentImage_S = plainImage2; // BREAKS
        
        
        UINavigationController *navController = [segue destinationViewController];
        
        Swale *swale = navController.viewControllers[0];
        swale.currentImage_S = plainImage2;
        
        GreenRoof *greenRoof = navController.viewControllers[2];
        greenRoof.currentImage_GR  = plainImage2;
        
       // Swale *swale = (Swale *)navController.topViewController; //BREAKS

    }
}

/*
 * This is the method we call when we want to segue to the Take a Picture Scene
 */
-(void)buttonizeButtonTap:(id)sender{
    [self performSegueWithIdentifier:@"toGI" sender:sender];
}

/*
 * The following code presents userImage in scrollView
 */
- (void) updateScrollView:(UIImage *) img {
    
    UIImageView *newView = [[UIImageView alloc] initWithImage:img];
    
    // if there is an image in scrollView it will remove it
    [self.imageView removeFromSuperview];
    
    //handle pinching in/ pinching out to zoom
    newView.userInteractionEnabled = YES;
    newView.backgroundColor = [UIColor clearColor];
    newView.contentMode =  UIViewContentModeCenter;
    
    self.imageView = newView;
    [self.scrollView addSubview:newView];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = self.imageView.bounds.size;
    self.scrollView.maximumZoomScale = 4.0;
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.contentOffset = CGPointMake(-(self.scrollView.bounds.size.width-self.imageView.bounds.size.width)/2, -(self.scrollView.bounds.size.height-self.imageView.bounds.size.height)/2);
    [self.scrollView addSubview:newView];
    //Set image on the scrollview
}


#pragma mark - IBAction
- (IBAction)toCalibrate:(id)sender {
    [self buttonizeButtonTap:self];
}
@end
