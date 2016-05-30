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
@property (nonatomic,strong) NSString * testString;

@property (weak, nonatomic) IBOutlet UIImageView *sample1;
@property (weak, nonatomic) IBOutlet UIImageView *sample2;
@property (weak, nonatomic) IBOutlet UIImageView *sample3;
@property (weak, nonatomic) IBOutlet UIImageView *sample4;
@property (weak, nonatomic) IBOutlet UIImageView *sample5;
@property (weak, nonatomic) IBOutlet UIImageView *sample6;
@property (weak, nonatomic) IBOutlet UIImageView *sample7;
@property (weak, nonatomic) IBOutlet UIImageView *sample8;
@property (weak, nonatomic) IBOutlet UIImageView *sample9;
@property (weak, nonatomic) IBOutlet UIImageView *sample10;
@property (weak, nonatomic) IBOutlet UIImageView *sample11;
@property (weak, nonatomic) IBOutlet UIImageView *sample12;
@property (weak, nonatomic) IBOutlet UIImageView *sample13;
@property (weak, nonatomic) IBOutlet UIImageView *sample14;
@property (weak, nonatomic) IBOutlet UIImageView *sample15;
@property (weak, nonatomic) IBOutlet UIImageView *BIGVIEW;

- (IBAction)removeAllSamples:(id)sender;
- (IBAction)SendHSVVals:(id)sender;

- (void) handleSingleTapFrom: (UITapGestureRecognizer *)recognizer;

@end
