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
#import "CVWrapper.h"


@implementation saveColors

- (void)viewDidLoad {
    [super viewDidLoad];

    _Swale = [self.tabBarController.childViewControllers objectAtIndex:0];
    _PermeablePaver = [self.tabBarController.childViewControllers objectAtIndex:1];
    _GreenRoof = [self.tabBarController.childViewControllers objectAtIndex:2];
    _RainBarrel = [self.tabBarController.childViewControllers objectAtIndex:3];

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateSwaleLabels];
    [self updateRainBarrelLabels];
    [self updatePermeablePaverLabels];
    [self updateGreenRoofLabels];
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
    
    _low_S.backgroundColor = [[UIColor alloc] initWithHue:(float)[_LH_S.text intValue]*1/225
                                               saturation:(float)[_LS_S.text intValue]*1/225
                                               brightness:(float)[_LB_S.text intValue]*1/225
                                                    alpha:1];
    _high_S.backgroundColor = [[UIColor alloc] initWithHue:(float)[_HH_S.text intValue]*1/225
                                                saturation:(float)[_HS_S.text intValue]*1/225
                                                brightness:(float)[_HB_S.text intValue]*1/225
                                                     alpha:1];
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
    
    _low_RB.backgroundColor = [[UIColor alloc] initWithHue:(float)[_LH_RB.text intValue]*1/225
                                               saturation:(float)[_LS_RB.text intValue]*1/225
                                               brightness:(float)[_LB_RB.text intValue]*1/225
                                                    alpha:1];
    _high_RB.backgroundColor = [[UIColor alloc] initWithHue:(float)[_HH_RB.text intValue]*1/225
                                                saturation:(float)[_HS_RB.text intValue]*1/225
                                                brightness:(float)[_HB_RB.text intValue]*1/225
                                                     alpha:1];

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
    
    NSLog(@"Permeable Paver Low hue %f", (float)[_LS_PP.text intValue]*1/225);
    
    _low_PP.backgroundColor = [[UIColor alloc] initWithHue:(float)[_LH_PP.text intValue]*1/225
                                                saturation:(float)[_LS_PP.text intValue]*1/225
                                                brightness:(float)[_LB_PP.text intValue]*1/225
                                                     alpha:1];
    _high_PP.backgroundColor = [[UIColor alloc] initWithHue:(float)[_HH_PP.text intValue]*1/225
                                                 saturation:(float)[_HS_PP.text intValue]*1/225
                                                 brightness:(float)[_HB_PP.text intValue]*1/225
                                                      alpha:1];
    
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
    
    _low_GR.backgroundColor = [[UIColor alloc] initWithHue:(float)[_LH_GR.text intValue]*1/225
                                                saturation:(float)[_LS_GR.text intValue]*1/225
                                                brightness:(float)[_LB_GR.text intValue]*1/225
                                                     alpha:1];
    _high_GR.backgroundColor = [[UIColor alloc] initWithHue:(float)[_HH_GR.text intValue]*1/225
                                                 saturation:(float)[_HS_GR.text intValue]*1/225
                                                 brightness:(float)[_HB_GR.text intValue]*1/225
                                                      alpha:1];
    
}

@end
