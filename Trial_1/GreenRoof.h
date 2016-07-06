//
//  GreenRoof.h
//  Trial_1
//
//  Created by Jamie Auza on 5/27/16.
//  Copyright © 2016 Jamie Auza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GreenRoof : UIViewController <UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong) UIImage * currentImage_GR;

@property (weak, nonatomic) IBOutlet UIImageView *sample1;
@property (weak, nonatomic) IBOutlet UIImageView *sample2;
@property (weak, nonatomic) IBOutlet UIImageView *sample3;
@property (weak, nonatomic) IBOutlet UIImageView *sample4;
@property (weak, nonatomic) IBOutlet UIImageView *sample5;
@property (weak, nonatomic) IBOutlet UIImageView *sample6;
@property (weak, nonatomic) IBOutlet UIImageView *sample7;
@property (weak, nonatomic) IBOutlet UIImageView *sample8;
@property (weak, nonatomic) IBOutlet UIImageView *sample9;

@property (weak, nonatomic) IBOutlet UISwitch *viewIconSwitch;
@property (weak, nonatomic) IBOutlet UIButton *dropDown;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSString *savedColorPalette_GR;
@property (strong, nonatomic) NSMutableArray*highLowVals_GR;

- (NSString*) getColorPaletteLabel;
- (NSMutableArray*) getHighLowVals;


- (IBAction)removeAll:(id)sender;
- (IBAction)backButton:(id)sender;
- (IBAction)dropDownButton:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *threshSwitch;


- (void) changeHSVVals;

@end
