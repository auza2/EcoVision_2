//
//  takeAPictureViewController.m
//  Trial_1
//
//  Created by Jamie Auza on 5/12/16.
//  Copyright © 2016 Jamie Auza. All rights reserved.
//

#import "takeAPictureViewController.h"
#import "CVWrapper.h"

@interface takeAPictureViewController ()

@end

@implementation takeAPictureViewController

UIImage *userImage = nil;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
 * Method that opens up the camera app
 * 
 * (NOT YET TESTED)
 */
- (IBAction)takePhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}

/*
 * Required to be a delegate for UIImagePickerController. This method gets called once the user finishes taking a picture.
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    userImage = info[UIImagePickerControllerOriginalImage];
    
    //[CVWrapper setCurrentImage:userImage];
    
    if (userImage == nil) {
        [self throwErrorAlert:@"Error taking photo! Please try taking the picture again"];
        self.scrollView.backgroundColor = [UIColor whiteColor]; // hides scrollView
    }
    else {
        
        //mean_image = [CVWrapper ApplyMedianFilter:userImage];
        //userImage = [UIImage imageWithCGImage:mean_image.CGImage];
        
        [CVWrapper setCurrentImage:userImage];
        [self updateScrollView:userImage];
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void) updateScrollView:(UIImage *) img {
    //** following code presents userImage in scrollView
    UIImageView *newView = [[UIImageView alloc] initWithImage:img];
    
    // if there is an image in scrollView it will remove it
    [self.imageView removeFromSuperview];
    
    self.imageView = newView;
    [self.scrollView addSubview:newView];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = self.imageView.bounds.size;
    self.scrollView.maximumZoomScale = 4.0;
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.contentOffset = CGPointMake(-(self.scrollView.bounds.size.width-self.imageView.bounds.size.width)/2, -(self.scrollView.bounds.size.height-self.imageView.bounds.size.height)/2);
}

@end
