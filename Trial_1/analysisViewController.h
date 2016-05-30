//
//  analysisViewController.h
//  Trial_1
//
//  Created by Jamie Auza on 5/20/16.
//  Copyright © 2016 Jamie Auza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface analysisViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIImageView* imageView; // why
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong) UIImage * currentImage_A;

- (IBAction)toCalibrate:(id)sender;


@end
