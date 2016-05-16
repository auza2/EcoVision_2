//
//  takeAPictureViewController.h
//  Trial_1
//
//  Created by Jamie Auza on 5/12/16.
//  Copyright © 2016 Jamie Auza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface takeAPictureViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView* imageView; // why
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)takePhoto:(id)sender;


@end
