//
//  Swale.h
//  Trial_1
//
//  Created by Jamie Auza on 5/20/16.
//  Copyright © 2016 Jamie Auza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Swale : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISwitch *threshSwitch;
@property (weak, nonatomic) IBOutlet UITextField *myTextField;


- (IBAction)removeAllSamples:(id)sender;
- (IBAction)SendHSVVals:(id)sender;

@end
