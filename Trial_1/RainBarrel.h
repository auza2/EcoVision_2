//
//  RainBarrel.h
//  Trial_1
//
//  Created by Jamie Auza on 5/31/16.
//  Copyright © 2016 Jamie Auza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RainBarrel : UIViewController <UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong) UIImage * currentImage_RB;

@property (weak, nonatomic) IBOutlet UIImageView *sample1;
@property (weak, nonatomic) IBOutlet UIImageView *sample2;
@property (weak, nonatomic) IBOutlet UIImageView *sample3;
@property (weak, nonatomic) IBOutlet UIImageView *sample4;
@property (weak, nonatomic) IBOutlet UIImageView *sample5;
@property (weak, nonatomic) IBOutlet UIImageView *sample6;
@property (weak, nonatomic) IBOutlet UIImageView *sample7;
@property (weak, nonatomic) IBOutlet UIImageView *sample8;
@property (weak, nonatomic) IBOutlet UIImageView *sample9;

- (IBAction)removeAll:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *threshSwitch;

@end
