//
//  Swale.h
//  Trial_1
//
//  Created by Jamie Auza on 5/20/16.
//  Copyright © 2016 Jamie Auza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Swale : UIViewController <UINavigationControllerDelegate, UIScrollViewDelegate,UIGestureRecognizerDelegate, UITabBarControllerDelegate,UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISwitch *threshSwitch;

@property (nonatomic,strong) UIImage * currentImage_S;
@property (nonatomic,strong) UIImage * originalImage_S;

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

- (IBAction)removeAll:(id)sender;
- (IBAction)dropDownButton:(id)sender;
- (IBAction)backButton:(id)sender;

@property (nonatomic,strong) NSMutableArray *SwaleSamples;
@property (nonatomic,strong) NSString *savedColorPalette_S;
@property (strong, nonatomic) NSMutableArray*highLowVals_S;

- (void) handleSingleTapFrom: (UITapGestureRecognizer *)recognizer;
- (NSString*) getColorPaletteLabel;
- (NSMutableArray*) getHighLowVals;
- (void) changeFromFile;
- (void) changeColorSetToIndex: (int)index;

@end
