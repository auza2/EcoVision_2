//
//  Swale.h
//  Trial_1
//
//  Created by Jamie Auza on 5/20/16.
//  Copyright © 2016 Jamie Auza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Swale : UIViewController <UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISwitch *threshSwitch;

@property (nonatomic,strong) UIImage * currentImage_S;

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

- (void) handleSingleTapFrom: (UITapGestureRecognizer *)recognizer;

@end
