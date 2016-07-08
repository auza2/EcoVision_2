//
//  PermeablePaver.m
//  Trial_1
//
//  Created by Jamie Auza on 5/20/16.
//  Copyright © 2016 Jamie Auza. All rights reserved.
//

#import "GreenRoof.h"
#import "CVWrapper.h"
#import "Coordinate.h"
#import "savedLocations.h"
#import "analysisViewController.h"
#import <math.h>
#import <stdlib.h>

@implementation GreenRoof

UITapGestureRecognizer * singleTap_GR; // tap that recognizes color extraction
UITapGestureRecognizer * doubleTap_GR; // tap that recognizes removal of sample

UIImage* plainImage_GR = nil;
UIImageView * img_GR;
UIImage* threshedImage_GR = nil;

NSMutableArray * GreenRoofSamples;
NSMutableArray * sampleImages_GR;
NSMutableArray* greenRoofCoordinatesCalibrated;

int highHue_GR, highSaturation_GR, highVal_GR;
int lowHue_GR, lowSaturation_GR, lowVal_GR;
savedLocations* savedLocationsFromFile_GR;

@synthesize sample1;
@synthesize sample2;
@synthesize sample3;
@synthesize sample4;
@synthesize sample5;
@synthesize sample6;
@synthesize sample7;
@synthesize sample8;
@synthesize sample9;
@synthesize viewIconSwitch;
@synthesize tableView;


long int clickedSegment_GR;

UIImage* greenRoofIcon2 = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initializing the switch
    [self.threshSwitch addTarget:self
                          action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
    _threshSwitch.on = false;
    
    // Set Default HSV Values
    [self setHSVValues];
    
    if( GreenRoofSamples.count == 0) {
        GreenRoofSamples = [NSMutableArray array];
        sampleImages_GR = [NSMutableArray array];
        
        [sampleImages_GR addObject:sample1];
        [sampleImages_GR addObject:sample2];
        [sampleImages_GR addObject:sample3];
        [sampleImages_GR addObject:sample4];
        [sampleImages_GR addObject:sample5];
        [sampleImages_GR addObject:sample6];
        [sampleImages_GR addObject:sample7];
        [sampleImages_GR addObject:sample8];
        [sampleImages_GR addObject:sample9];
        
        // Necessary to find where to put the sampled color
        sample1.backgroundColor = UIColor.whiteColor;
        sample2.backgroundColor = UIColor.whiteColor;
        sample3.backgroundColor = UIColor.whiteColor;
        sample4.backgroundColor = UIColor.whiteColor;
        sample5.backgroundColor = UIColor.whiteColor;
        sample6.backgroundColor = UIColor.whiteColor;
        sample7.backgroundColor = UIColor.whiteColor;
        sample8.backgroundColor = UIColor.whiteColor;
        sample9.backgroundColor = UIColor.whiteColor;
    }
    
    
    // Switch to see icons
    [viewIconSwitch addTarget:self
                       action:@selector(stateChangedViewIcon:) forControlEvents:UIControlEventValueChanged];
    
    greenRoofIcon2 = [UIImage imageNamed:@"GreenRoof_Icon.png"];
    
    // For Drop Down
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    savedLocationsFromFile_GR = [[savedLocations alloc] init];
    
    // Back Button
    UIBarButtonItem *buttonizeButton = [[UIBarButtonItem alloc] initWithTitle:@"Buttonize"
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(buttonizeButtonTap:)];
    self.navigationItem.rightBarButtonItems = @[buttonizeButton];

    _highLowVals_GR = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    plainImage_GR = _currentImage_GR;
    
    [self updateScrollView:_currentImage_GR];
    
    
    // Initializing the Tap Gestures
    singleTap_GR = [[UITapGestureRecognizer alloc]
                    initWithTarget:self
                    action:@selector(handleSingleTapFrom:)];
    singleTap_GR.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:singleTap_GR];
    singleTap_GR.delegate = self;
    
    
    doubleTap_GR = [[UITapGestureRecognizer alloc]
                    initWithTarget:self
                    action:@selector(handleDoubleTapFrom:)];
    doubleTap_GR.numberOfTapsRequired = 2;
    doubleTap_GR.delegate = self;
    
    //Fail to implement single tap if double tap is met
    [singleTap_GR requireGestureRecognizerToFail:doubleTap_GR];
    
    
    // Adding a Double Tap Gesture for all the Sample Views for the Ability to remove
    for( UIImageView * sampleView in sampleImages_GR ){
        UITapGestureRecognizer * doubleTap_GRTEST = [[UITapGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(handleDoubleTapFrom:)];
        doubleTap_GRTEST.numberOfTapsRequired = 2;
        doubleTap_GRTEST.delegate = self;
        [sampleView setUserInteractionEnabled:YES];
        [sampleView addGestureRecognizer: doubleTap_GRTEST];
    }
    
    // Creating Borders
    [self.dropDown.layer setBorderWidth:2.0];
    [self.dropDown.layer setBorderColor:[UIColor colorWithRed:0.86 green:0.85 blue:0.87 alpha:1.0].CGColor];
    
    tableView.layer.borderColor = [UIColor colorWithRed:0.86 green:0.85 blue:0.87 alpha:1.0].CGColor;
    self.tableView.layer.borderWidth = 2.0;
    
}

#pragma -mark Back Button

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"backToAnalysis"])
    {
        analysisViewController *analysisViewController = [segue destinationViewController];
        analysisViewController.currentImage_A = _currentImage_GR;
    }
}
-(void)buttonizeButtonTap:(id)sender{
    [self performSegueWithIdentifier:@"backToAnalysis" sender:sender];
}

- (IBAction)backButton:(id)sender {
    [self buttonizeButtonTap: self];
}
#pragma -mark sending data
- (NSString*) getColorPaletteLabel{
    return self.dropDown.currentTitle;
}

- (NSMutableArray*) getHighLowVals{
    [_highLowVals_GR removeAllObjects];
    [_highLowVals_GR addObject:[NSString stringWithFormat:@"%d",lowHue_GR]];
    [_highLowVals_GR addObject:[NSString stringWithFormat:@"%d",highHue_GR]];
    [_highLowVals_GR addObject:[NSString stringWithFormat:@"%d",lowSaturation_GR]];
    [_highLowVals_GR addObject:[NSString stringWithFormat:@"%d",highSaturation_GR]];
    [_highLowVals_GR addObject:[NSString stringWithFormat:@"%d",lowVal_GR]];
    [_highLowVals_GR addObject:[NSString stringWithFormat:@"%d",highVal_GR]];
    return _highLowVals_GR;
}


#pragma -mark View Icons Switch
- (void)stateChangedViewIcon:(UISwitch *)switchState
{
    if( switchState.isOn ){
        if( _threshSwitch.isOn)
            [_threshSwitch setOn:false];
        
        UIGraphicsBeginImageContext(_currentImage_GR.size);
        [_currentImage_GR drawInRect:CGRectMake(0, 0, _currentImage_GR.size.width, _currentImage_GR.size.height)];
        NSLog(@"stateChangedViewIcon -- Begin");
        
        // Use the new HSV Values
        [self changeHSVVals];
        NSLog(@"stateChangedViewIcon -- AFTER WE CHANGE THE HSV VALUES");
        int HSV_values[30];
        [CVWrapper getHSV_Values:HSV_values];
        
        for( int x = 0; x < 30 ; x++)
            NSLog(@"HSV VAL -- %i", HSV_values[x]);
        NSLog(@"stateChangedViewIcon -- AFTER WE CHANGE THE HSV VALUES");
        char resultafter[5000];
        [CVWrapper analysis:_currentImage_GR studyNumber: 0 trialNumber:0 results:resultafter];
        
        
        greenRoofCoordinatesCalibrated = [CVWrapper getGreenRoofCoordinates];
        NSLog(@"There are %i permeable pavers detected" , greenRoofCoordinatesCalibrated.count);
        [self drawIconsInArray:greenRoofCoordinatesCalibrated image:greenRoofIcon2];
        
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [self updateScrollView:result];
        NSLog(@"stateChangedViewIcon -- End ");
    } else {
        [self updateScrollView:_currentImage_GR];
    }
    
}

-(void) drawIconsInArray:(NSMutableArray *)iconArray image:(UIImage*)iconImage{
    CGFloat squareWidth = _currentImage_GR.size.width/23;
    CGFloat squareHeight = _currentImage_GR.size.height/25;
    for( Coordinate * coord in iconArray){
        [iconImage drawInRect:CGRectMake( coord.getX * squareWidth,
                                         _currentImage_GR.size.height - ( coord.getY + 1 ) * squareHeight,
                                         squareWidth, squareHeight)];
    }
}


#pragma -mark Update View

/*
 * Update the scroll view
 */
- (void) updateScrollView:(UIImage *) newImg {
    //MAKE SURE THAT IMAGE VIEW IS REMOVED IF IT EXISTS ON SCROLLVIEW!!
    if (img_GR != nil)
    {
        [img_GR removeFromSuperview];
        
    }
    
    img_GR = [[UIImageView alloc] initWithImage:newImg];
    
    
    
    //handle pinching in/ pinching out to zoom
    img_GR.userInteractionEnabled = YES;
    img_GR.backgroundColor = [UIColor clearColor];
    img_GR.contentMode =  UIViewContentModeCenter;
    //img.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.scrollView.minimumZoomScale=0.5;
    self.scrollView.maximumZoomScale=6.0;
    self.scrollView.contentSize = CGSizeMake(img_GR.frame.size.width+100, img_GR.frame.size.height+100);
    self.scrollView.clipsToBounds = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = true;
    self.scrollView.showsHorizontalScrollIndicator = true;
    
    
    
    //Set image on the scrollview
    [self.scrollView addSubview:img_GR];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return img_GR;
}


#pragma -mark Handle Taps

- (void) handleSingleTapFrom: (UITapGestureRecognizer *)recognizer
{
    printf("I am single tapping...\n");
    
    CGPoint point =[singleTap_GR locationInView:self.scrollView];
    
    UIColor * color = [self GetCurrentPixelColorAtPoint:point];
    
    // Find the first view that has no color and add the color we found
    for (UIImageView * view in sampleImages_GR) {
        if( [view.backgroundColor isEqual:UIColor.whiteColor]){
            view.backgroundColor = color;
            [GreenRoofSamples addObject:color];
            break;
        }
    }
    
    [self setHighandlowVal_GRues];
    
    if( [self.dropDown.currentTitle isEqualToString:@"Choose Saved Color Palette"])
        [self changeColorSetToIndex: 0];
}

- (void) handleDoubleTapFrom: (UITapGestureRecognizer *) recognizer
{
    printf("I double tapped\n");
    UIView *view = recognizer.view;
    
    Boolean removed = false;
    // Finds the color in the GreenRoofSamples array and removes it
    for (UIColor * color in GreenRoofSamples) {
        if( [color isEqual:view.backgroundColor]){
            [GreenRoofSamples removeObject:color];
            printf("Removed a color\n");
            printf("Permeable Pavers has %i things", GreenRoofSamples.count);
            removed = true;
            break;
        }
    }
    
    // Before setting the High and Low values, change to default from picked color set
    [self changeColorSetToIndex:clickedSegment_GR];
    [self setHighandlowVal_GRues];
    
    // Remove the color on the view
    view.backgroundColor = UIColor.whiteColor;
}


- (UIColor *) GetCurrentPixelColorAtPoint:(CGPoint)point
{
    // Extract Colour
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM(context, -point.x, -point.y);
    [self.scrollView.layer renderInContext:context];
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}

- (void) showSamples{
    NSLog(@"In ShowSamples: Samples has %i",GreenRoofSamples.count );
    for( UIColor * color in GreenRoofSamples){
        for (UIImageView * view in sampleImages_GR) {
            if( [view.backgroundColor isEqual:UIColor.whiteColor]){
                view.backgroundColor = color;
                break;
            }
        }
    }
}

#pragma -mark Action Buttons

- (IBAction)removeAll:(id)sender {
    [GreenRoofSamples removeAllObjects];
    for( UIImageView * sample in sampleImages_GR){
        sample.backgroundColor = UIColor.whiteColor;
    }
    if( _threshSwitch.isOn || viewIconSwitch.isOn){
        [_threshSwitch setOn:false];
        [viewIconSwitch setOn:false];
        [self updateScrollView:_currentImage_GR];
    }

    [self setHighandlowVal_GRues];
    [self changeColorSetToIndex: clickedSegment_GR];
}

#pragma mark - Threshold Switch
/*
 * This is the method that gets called when we toggle the switch.
 */
- (void)stateChanged:(UISwitch *)switchState
{
    if ([switchState isOn]) {
        if( viewIconSwitch.isOn)
            [viewIconSwitch setOn:false];
        
        [self threshold_image];
    } else {
        [self un_thresh_image];
    }
}

/*
 * Threshold
 */
- (void) threshold_image{
    if (plainImage_GR == nil) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"No image to threshold!" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    //thresh either the plain image or the median filtered image
    /* thresholds image
     ** colorCases: 0 = green
     **             1 = red
     **             2 = wood <--
     **             3 = blue
     **             4 = dark green (corner markers)
     */
    
    [CVWrapper setSegmentIndex:0];
    [self changeHSVVals];
    
    threshedImage_GR = [CVWrapper thresh:plainImage_GR colorCase: 2];
    //_scrollView.zoomScale = plainImage_GR.scale;
    [self updateScrollView:threshedImage_GR];
}

/*
 * UnThreshold
 */
- (void) un_thresh_image{
    if (img_GR != nil && (img_GR.image != plainImage_GR))
    {
        printf("Reseting to unthreshed image\n");
        [self updateScrollView:plainImage_GR];
    }
}

#pragma -mark HSV Values

/*
 * Gets the integers from hsvValues.txt and sends them to CVWrapper
 */
- (void) setHSVValues {
    int hsvValues[30];
    [CVWrapper getHSV_Values:hsvValues];
    
    NSError *error;
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"hsvValues"];
    fileName = [fileName stringByAppendingPathExtension:@"txt"];
    
    NSString* content = [NSString stringWithContentsOfFile:fileName
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
    
    // if file reading creates an error, set values to default
    if(error) {
        NSLog(@"File reading error: default hsv values loaded");
        int hsvDefault[] = {10, 80, 50, 200, 50, 255,       // Green (Swale)
            80, 175, 140, 255, 100, 255,    // Red (Rain Barrel
            90, 110, 40, 100, 120, 225,     // Brown (Green Roof)
            0, 15, 30, 220, 50, 210,        // Blue (Permeable Paver)
            15, 90, 35, 200, 35, 130};      // Dark Green (Corner Markers)
        [CVWrapper setHSV_Values:hsvDefault];
        return;
    }
    
    NSLog(@"Reading from hsvValues.txt from setHSVValues: %@", content);
    
    NSArray *arr = [content componentsSeparatedByString:@" "];
    
    int i;
    for(i = 0; i < 30; i++) {
        // loss of precision is fine since all numbers stored in arr will have only zeroes after the decimal
        hsvValues[i] = [[arr objectAtIndex:i]integerValue];
    }
    
    [CVWrapper setHSV_Values:hsvValues];
}

/*
 * Changes the HSV Values in CVWrapper
 * Does this change the txt file?
 */
- (void) changeHSVVals{
    /*
     ** colorCases: 0 = green
     **             1 = red
     **             2 = wood <--
     **             3 = blue
     **             4 = dark green (corner markers)
     */
    
    int caseNum = 2;
    int vals[30] = {0};
    [CVWrapper getHSV_Values:vals];
    
    if (GreenRoofSamples == NULL)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Samples of brown pieces not found: Please pick some samples" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        [alert show];
    }
    
    // Find the High and Low Values from Samples
    [self setHighandlowVal_GRues];
    
    // changes the values by the CVWrapper
    vals[caseNum * 6] = lowHue_GR;
    vals[caseNum * 6 + 1] = highHue_GR;
    vals[caseNum * 6 + 2] = lowSaturation_GR;
    vals[caseNum * 6 + 3] = highSaturation_GR;
    vals[caseNum * 6 + 4] = lowVal_GR;
    vals[caseNum * 6 + 5] = highVal_GR;
    
    [CVWrapper setHSV_Values:vals];
}

#pragma change HSV Values based on samples

/*
 * Goes through the Array of Colors and sets the High and Low Values of the Hue, Saturation, and Value.
 */
- (void) setHighandlowVal_GRues{
    int H_Sample;
    int S_Sample;
    int V_Sample;
    
    for( UIColor * color in GreenRoofSamples) {
        const CGFloat* components = CGColorGetComponents(color.CGColor);
        
        int red = components[0]*255.0;
        int green = components[1]*255.0;
        int blue = components[2]*255.0;
        
        [CVWrapper getHSVValuesfromRed:red Green:green Blue:blue H:&H_Sample S:&S_Sample V:&V_Sample];
        
        highHue_GR = ( highHue_GR < H_Sample ) ? H_Sample : highHue_GR ;
        highSaturation_GR = ( highSaturation_GR < S_Sample ) ? S_Sample : highSaturation_GR ;
        highVal_GR = ( highVal_GR < V_Sample ) ? V_Sample : highVal_GR ;
        
        lowHue_GR = ( lowHue_GR > H_Sample ) ? H_Sample : lowHue_GR ;
        lowSaturation_GR = ( lowSaturation_GR > S_Sample ) ? S_Sample : lowSaturation_GR ;
        lowVal_GR = ( lowVal_GR > V_Sample ) ? V_Sample : lowVal_GR;
        
    }
}

- (void) setNoDefault{
    lowHue_GR = 225;
    highHue_GR = 0;
    
    lowSaturation_GR = 225;
    highSaturation_GR = 0;
    
    lowVal_GR = 225;
    highVal_GR = 0;
}

- (void) setDefaultHSV{
    
    lowHue_GR = 10;
    highHue_GR = 80;
    
    lowSaturation_GR = 50;
    highSaturation_GR = 200;
    
    lowVal_GR = 50;
    highVal_GR = 255;
}

#pragma Change HSV Values based on Location

#pragma -mark Drop Down Menu
// Number of thins shown in the drop down

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    return [savedLocationsFromFile_GR count];
}

/*
 * Returns the table cell at the specified index path.
 *
 * Return Value
 * An object representing a cell of the table, or nil if the cell is not visible or indexPath is out of range.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // cell.textLabel.text = @"";
    // indexPath.row -- I'm guessing this gets called multiple times to initialize all the cells
    
    cell.textLabel.text = [savedLocationsFromFile_GR nameOfObjectAtIndex:indexPath.row];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.40 green:0.60 blue:0.20 alpha:1.0];
    
    return cell;
}

/*
 * Tells the delegate that the specified row is now selected.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if( _threshSwitch.isOn || viewIconSwitch.isOn){
        [_threshSwitch setOn:false];
        [viewIconSwitch setOn:false];
        [self updateScrollView:_currentImage_GR];
    }
    
    clickedSegment_GR = index;
    [self changeColorSetToIndex:indexPath.row];
}

- (void) changeColorSetToIndex: (int)index{
    clickedSegment_GR = index;
    
    [self.dropDown setTitle: [savedLocationsFromFile_GR nameOfObjectAtIndex:index]  forState:UIControlStateNormal];
    
    // Icon == CaseNum
    NSMutableArray * newSetting  = [savedLocationsFromFile_GR getHSVForSavedLocationAtIndex:index Icon:2];
    
    lowHue_GR = [[newSetting objectAtIndex:0] integerValue];
    highHue_GR = [[newSetting objectAtIndex:1] integerValue];
    
    lowSaturation_GR = [[newSetting objectAtIndex:2] integerValue];
    highSaturation_GR = [[newSetting objectAtIndex:3] integerValue];
    
    lowVal_GR = [[newSetting objectAtIndex:4] integerValue];
    highVal_GR = [[newSetting objectAtIndex:5] integerValue];
    
    NSLog(@"lowHue_GR is %i", lowHue_GR);
    
    [self changeHSVVals];
    
    self.tableView.hidden =  TRUE;
}
- (void) changeFromFile{
    [savedLocationsFromFile_GR changeFromFile];
}

- (IBAction)dropDownButton:(id)sender {
    if( self.tableView.hidden == TRUE )
        self.tableView.hidden =  FALSE;
    else
        self.tableView.hidden = TRUE;
}



@end
