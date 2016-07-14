//
//  saveColors.m
//  Trial_1
//
//  Created by Jamie Auza on 7/4/16.
//  Copyright © 2016 Jamie Auza. All rights reserved.
//

#import "saveColors.h"
#import "Swale.h"
#import "HSVLocation.h"
#import "savedLocations.h"
#import "CVWrapper.h"


@implementation saveColors
savedLocations* savedLocationsFromFile_SC;
double R_low;
double G_low;
double B_low;
double R_high;
double G_high;
double B_high;
Boolean noChoiceMade;
NSString * nameOfEntry;


- (void)viewDidLoad {
    [super viewDidLoad];

    _Swale = [self.tabBarController.childViewControllers objectAtIndex:0];
    _PermeablePaver = [self.tabBarController.childViewControllers objectAtIndex:1];
    _GreenRoof = [self.tabBarController.childViewControllers objectAtIndex:2];
    _RainBarrel = [self.tabBarController.childViewControllers objectAtIndex:3];
    _GreenCorners = [self.tabBarController.childViewControllers objectAtIndex:4];
    
     savedLocationsFromFile_SC = [[savedLocations alloc] init];

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    noChoiceMade = false;
    [self updateSwaleLabels];
    [self updateRainBarrelLabels];
    [self updatePermeablePaverLabels];
    [self updateGreenRoofLabels];
    [self updateGreenCornerLabels];
    
}

-(void) updateSwaleLabels{
    _colorPalette_S.text = [_Swale getColorPaletteLabel];
    _swaleColors = [_Swale getHighLowVals];
    
    _LH_S.text = [_swaleColors objectAtIndex:0];
    _LS_S.text = [_swaleColors objectAtIndex:2];
    _LB_S.text = [_swaleColors objectAtIndex:4];
    _HH_S.text = [_swaleColors objectAtIndex:1];
    _HS_S.text = [_swaleColors objectAtIndex:3];
    _HB_S.text = [_swaleColors objectAtIndex:5];
    
    
    [CVWrapper getRGBValuesFromH:[_LH_S.text intValue]
                               S:[_LS_S.text intValue]
                               V:[_LB_S.text intValue]
                               R:&R_low
                               G:&G_low
                               B:&B_low];
    
    [CVWrapper getRGBValuesFromH:[_HH_S.text intValue]
                               S:[_HS_S.text intValue]
                               V:[_HB_S.text intValue]
                               R:&R_high
                               G:&G_high
                               B:&B_high];
    
    _low_S.backgroundColor = [[UIColor alloc] initWithRed:R_low/255.0
                                                    green:G_low/255.0
                                                     blue:B_low/255.0
                                                    alpha:1];
    
    _high_S.backgroundColor = [[UIColor alloc] initWithRed:R_high/255.0
                                                     green:G_high/255.0
                                                      blue:B_high/255.0
                                                     alpha:1];
    
    if( _swaleColors == nil || [_colorPalette_S.text isEqualToString:@"Choose Saved Color Palette"]){
        noChoiceMade = true;
    }
}

-(void) updateRainBarrelLabels{
    //NSLog(@"%@", [_RainBarrel getColorPaletteLabel]);
    //NSLog(@"%@", [_RainBarrel getHighLowVals]);
    
    _colorPalette_RB.text = [_RainBarrel getColorPaletteLabel];
    _rainBarrelColors = [_RainBarrel getHighLowVals];
    
    _LH_RB.text = [_rainBarrelColors objectAtIndex:0];
    _LS_RB.text = [_rainBarrelColors objectAtIndex:2];
    _LB_RB.text = [_rainBarrelColors objectAtIndex:4];
    _HH_RB.text = [_rainBarrelColors objectAtIndex:1];
    _HS_RB.text = [_rainBarrelColors objectAtIndex:3];
    _HB_RB.text = [_rainBarrelColors objectAtIndex:5];
    
    [CVWrapper getRGBValuesFromH:[_LH_RB.text intValue]
                               S:[_LS_RB.text intValue]
                               V:[_LB_RB.text intValue]
                               R:&R_low
                               G:&G_low
                               B:&B_low];
    
    [CVWrapper getRGBValuesFromH:[_HH_RB.text intValue]
                               S:[_HS_RB.text intValue]
                               V:[_HB_RB.text intValue]
                               R:&R_high
                               G:&G_high
                               B:&B_high];
    
    
    
    _low_RB.backgroundColor = [[UIColor alloc] initWithRed:R_low/255.0
                                                    green:G_low/255.0
                                                     blue:B_low/255.0
                                                    alpha:1];
    
    _high_RB.backgroundColor = [[UIColor alloc] initWithRed:R_high/255.0
                                                     green:G_high/255.0
                                                      blue:B_high/255.0
                                                     alpha:1];
    
    if( _rainBarrelColors == nil  || [_colorPalette_RB.text isEqualToString:@"Choose Saved Color Palette"]){
        noChoiceMade = true;
    }

}

-(void) updatePermeablePaverLabels{
    //NSLog(@"%@", [_PermeablePaver getColorPaletteLabel]);
    //NSLog(@"%@", [_PermeablePaver getHighLowVals]);
    
    _colorPalette_PP.text = [_PermeablePaver getColorPaletteLabel];
    _permeablePaverColors = [_PermeablePaver getHighLowVals];
    
    _LH_PP.text = [_permeablePaverColors objectAtIndex:0];
    _LS_PP.text = [_permeablePaverColors objectAtIndex:2];
    _LB_PP.text = [_permeablePaverColors objectAtIndex:4];
    _HH_PP.text = [_permeablePaverColors objectAtIndex:1];
    _HS_PP.text = [_permeablePaverColors objectAtIndex:3];
    _HB_PP.text = [_permeablePaverColors objectAtIndex:5];
    
    [CVWrapper getRGBValuesFromH:[_LH_PP.text intValue]
                               S:[_LS_PP.text intValue]
                               V:[_LB_PP.text intValue]
                               R:&R_low
                               G:&G_low
                               B:&B_low];
    
    [CVWrapper getRGBValuesFromH:[_HH_PP.text intValue]
                               S:[_HS_PP.text intValue]
                               V:[_HB_PP.text intValue]
                               R:&R_high
                               G:&G_high
                               B:&B_high];
    
    _low_PP.backgroundColor = [[UIColor alloc] initWithRed:R_low/255.0
                                                    green:G_low/255.0
                                                     blue:B_low/255.0
                                                    alpha:1];
    
    _high_PP.backgroundColor = [[UIColor alloc] initWithRed:R_high/255.0
                                                     green:G_high/255.0
                                                      blue:B_high/255.0
                                                     alpha:1];
    if( _permeablePaverColors ==  nil || [_colorPalette_PP.text isEqualToString:@"Choose Saved Color Palette"]){
        noChoiceMade = true;
    }
}

-(void) updateGreenRoofLabels{
    //NSLog(@"%@", [_GreenRoof getColorPaletteLabel]);
    //NSLog(@"%@", [_GreenRoof getHighLowVals]);
    
    _colorPalette_GR.text = [_GreenRoof getColorPaletteLabel];
    _greenRoofColors = [_GreenRoof getHighLowVals];
    
    _LH_GR.text = [_greenRoofColors objectAtIndex:0];
    _LS_GR.text = [_greenRoofColors objectAtIndex:2];
    _LB_GR.text = [_greenRoofColors objectAtIndex:4];
    _HH_GR.text = [_greenRoofColors objectAtIndex:1];
    _HS_GR.text = [_greenRoofColors objectAtIndex:3];
    _HB_GR.text = [_greenRoofColors objectAtIndex:5];
    
    [CVWrapper getRGBValuesFromH:[_LH_GR.text intValue]
                               S:[_LS_GR.text intValue]
                               V:[_LB_GR.text intValue]
                               R:&R_low
                               G:&G_low
                               B:&B_low];
    
    [CVWrapper getRGBValuesFromH:[_HH_GR.text intValue]
                               S:[_HS_GR.text intValue]
                               V:[_HB_GR.text intValue]
                               R:&R_high
                               G:&G_high
                               B:&B_high];
    
    _low_GR.backgroundColor = [[UIColor alloc] initWithRed:R_low/255.0
                                                     green:G_low/255.0
                                                      blue:B_low/255.0
                                                     alpha:1];
    
    _high_GR.backgroundColor = [[UIColor alloc] initWithRed:R_high/255.0
                                                      green:G_high/255.0
                                                       blue:B_high/255.0
                                                      alpha:1];
    if( _greenRoofColors == nil || [_colorPalette_GR.text isEqualToString:@"Choose Saved Color Palette"]){
        noChoiceMade = true;
    }
    
}

-(void) updateGreenCornerLabels{
    //NSLog(@"%@", [_GreenRoof getColorPaletteLabel]);
    //NSLog(@"%@", [_GreenRoof getHighLowVals]);
    
    _colorPalette_GC.text = [_GreenCorners getColorPaletteLabel];
    _greenCornerColors = [_GreenCorners getHighLowVals];
    
    _LH_GC.text = [_greenCornerColors objectAtIndex:0];
    _LS_GC.text = [_greenCornerColors objectAtIndex:2];
    _LB_GC.text = [_greenCornerColors objectAtIndex:4];
    _HH_GC.text = [_greenCornerColors objectAtIndex:1];
    _HS_GC.text = [_greenCornerColors objectAtIndex:3];
    _HB_GC.text = [_greenCornerColors objectAtIndex:5];
    
    [CVWrapper getRGBValuesFromH:[_LH_GC.text intValue]
                               S:[_LS_GC.text intValue]
                               V:[_LB_GC.text intValue]
                               R:&R_low
                               G:&G_low
                               B:&B_low];
    
    [CVWrapper getRGBValuesFromH:[_HH_GC.text intValue]
                               S:[_HS_GC.text intValue]
                               V:[_HB_GC.text intValue]
                               R:&R_high
                               G:&G_high
                               B:&B_high];
    
    _low_GC.backgroundColor = [[UIColor alloc] initWithRed:R_low/255.0
                                                     green:G_low/255.0
                                                      blue:B_low/255.0
                                                     alpha:1];
    
    _high_GC.backgroundColor = [[UIColor alloc] initWithRed:R_high/255.0
                                                      green:G_high/255.0
                                                       blue:B_high/255.0
                                                      alpha:1];
    if( _greenCornerColors ==  nil || [_colorPalette_GC.text isEqualToString:@"Choose Saved Color Palette"] ){
        noChoiceMade = true;
    }
    
}

- (IBAction)saveAs:(id)sender {
    if( noChoiceMade == true){
        NSString * info = [NSString stringWithFormat: @"Choose a Saved Color Palette for all Icons before saving"];
        UIAlertView * alertNull = [[UIAlertView alloc] initWithTitle:@"Error!" message: info delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertNull show];
        return;
    }
    
    NSString * info = [NSString stringWithFormat: @"We suggest naming this color set based on the location/condition of the room it was taken.\n e.g. 'Lab - Flourescent Lighting'"];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Saving Color Set" message: info delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 0;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.placeholder = @"Insert name here";
    [alert show];
}

-(void) writeToFile: (NSString*) name{
    NSMutableArray * saveValues = [[NSMutableArray alloc] init];
    
    [saveValues addObjectsFromArray:[_Swale getHighLowVals]];
    [saveValues addObjectsFromArray:[_RainBarrel getHighLowVals]];
    [saveValues addObjectsFromArray:[_GreenRoof getHighLowVals]];
    [saveValues addObjectsFromArray:[_PermeablePaver getHighLowVals]];
    [saveValues addObjectsFromArray:[_GreenCorners getHighLowVals]];
    
    int index = [savedLocationsFromFile_SC saveEntryWithName:name Values:saveValues];
    
    // Adds the new or modified HSVLocation for the drop down
    [savedLocationsFromFile_SC changeFromFile];
    [_Swale changeFromFile];
    [_Swale changeColorSetToIndex: index];
    [_RainBarrel changeFromFile];
    [_RainBarrel changeColorSetToIndex: index];
    [_GreenRoof changeFromFile];
    [_GreenRoof changeColorSetToIndex: index];
    [_PermeablePaver changeFromFile];
    [_PermeablePaver changeColorSetToIndex: index];
    [_GreenCorners changeFromFile];
    [_GreenCorners changeColorSetToIndex: index];
    // Any action can be performed here
}


// Gets called after we enter from the alert view
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 )
    {
        // User Clicked Cancel
    }
    else if( [alertView tag] == 0)
    {
        NSLog(@"user pressed Button Indexed 1");
        
        NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
        nameOfEntry = [[alertView textFieldAtIndex:0] text];
        
        // Checking if user is overwriting
        if([savedLocationsFromFile_SC isOverwriting:nameOfEntry]){
            NSString * info = [NSString stringWithFormat: @"There is already a Color Pallette called '%@' would you like to over write it?", [[alertView textFieldAtIndex:0]text]];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Over Writing Color Palette" message: info delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
            alert.tag = 1;
            [alert show];
            return;
        }else
            [self writeToFile:nameOfEntry];
    }else{
        // if the user chooses to overwrite
        [self writeToFile:[[alertView textFieldAtIndex:0]text]];
    }
}
    @end
