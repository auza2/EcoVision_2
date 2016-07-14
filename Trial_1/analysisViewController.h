//
//  analysisViewController.h
//  Trial_1
//
//  Created by Jamie Auza on 5/20/16.
//  Copyright © 2016 Jamie Auza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface analysisViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UIImageView* imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong) UIImage * currentImage_A;
@property (nonatomic,strong) UIImage * userImage_A;

- (IBAction)toCalibrate:(id)sender;

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;

@property (weak, nonatomic) IBOutlet UISwitch *swaleSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *rainBarrelSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *permeablePaverSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *greenRoofSwitch;

@property (weak, nonatomic) IBOutlet UIButton *addSwaleButton;
@property (weak, nonatomic) IBOutlet UIButton *addRainBarrelButton;
@property (weak, nonatomic) IBOutlet UIButton *addGreenRoofButton;
@property (weak, nonatomic) IBOutlet UIButton *addPermeablePaverButton;

- (IBAction)addGi:(id)sender;
- (IBAction)retakePicture:(id)sender;
- (IBAction)send:(id)sender;

- (void) test;
- (void) drawIconsInArray:(NSMutableArray *)iconArray image:(UIImage*)iconImage;

@property CGFloat squareWidth;
@property CGFloat squareHeight;
@property NSMutableArray* switches;
@property NSString * groupNumber;
@property NSString * IPAddress;

@end
