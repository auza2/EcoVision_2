//
//  saveColors.h
//  Trial_1
//
//  Created by Jamie Auza on 7/4/16.
//  Copyright © 2016 Jamie Auza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface saveColors : UIViewController <UIImagePickerControllerDelegate>


@property (weak, nonatomic) IBOutlet UILabel *colorPalette_S;
@property (weak, nonatomic) IBOutlet UILabel *colorPalette_RB;
@property (weak, nonatomic) IBOutlet UILabel *colorPalette_PP;
@property (weak, nonatomic) IBOutlet UILabel *colorPalette_GR;

@end
