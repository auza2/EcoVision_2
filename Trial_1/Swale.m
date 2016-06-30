//
//  Swale.m
//  Trial_1
//
//  Created by Jamie Auza on 5/20/16.
//  Copyright © 2016 Jamie Auza. All rights reserved.
//

#import "Swale.h"
#import "CVWrapper.h"
#import "Coordinate.h"
#import "savedLocations.h"
#import <math.h>
#import <stdlib.h>

@implementation Swale

UITapGestureRecognizer * singleTap_S; // tap that recognizes color extraction
UITapGestureRecognizer * doubleTap_S; // tap that recognizes removal of sample

UIImage* plainImage_S = nil;
UIImageView * img_S;
UIImage* threshedImage_S = nil;

NSMutableArray * SwaleSamples;
NSMutableArray * sampleImages_S;
NSMutableArray* swaleCoordinatesCalibrated;

int highHue_S, highSaturation_S, highVal_S;
int lowHue_S, lowSaturation_S, lowVal_S;
int hasNoDefaultValues;
savedLocations* savedLocationsFromFile;

@synthesize sample1;
@synthesize sample2;
@synthesize sample3;
@synthesize sample4;
@synthesize sample5;
@synthesize sample6;
@synthesize sample7;
@synthesize sample8;
@synthesize sample9;
@synthesize noDefaultButton;
@synthesize viewIconSwitch;
@synthesize tableView;


long int clickedSegment_S;
char resultsCalibrated[5000]; // changed to do testing

UIImage* swaleIcon2 = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initializing the switch
    [self.threshSwitch addTarget:self
                          action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
    _threshSwitch.on = false;
    
    // Set Default HSV Values
    [self setHSVValues];
    
    if( SwaleSamples.count == 0) {
        SwaleSamples = [NSMutableArray array];
        sampleImages_S = [NSMutableArray array];
        
        [sampleImages_S addObject:sample1];
        [sampleImages_S addObject:sample2];
        [sampleImages_S addObject:sample3];
        [sampleImages_S addObject:sample4];
        [sampleImages_S addObject:sample5];
        [sampleImages_S addObject:sample6];
        [sampleImages_S addObject:sample7];
        [sampleImages_S addObject:sample8];
        [sampleImages_S addObject:sample9];
        
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

    // When switching between views we want to keep their settings the same
    if( hasNoDefaultValues == true ){
        noDefaultButton.selected = !noDefaultButton.selected;
        [self setNoDefault:nil];
    }else{
        [self setDefaultHSV];
        hasNoDefaultValues = false;
    }
    
    // Switch to see icons
    [viewIconSwitch addTarget:self
          action:@selector(stateChangedViewIcon:) forControlEvents:UIControlEventValueChanged];
    
    swaleIcon2 = [UIImage imageNamed:@"Swale_Icon.png"];
    
    // For Drop Down
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    savedLocationsFromFile = [[savedLocations alloc] init];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    plainImage_S = _currentImage_S;
    
    [self updateScrollView:_currentImage_S];
    
    
    // Initializing the Tap Gestures
    singleTap_S = [[UITapGestureRecognizer alloc]
                    initWithTarget:self
                    action:@selector(handleSingleTapFrom:)];
    singleTap_S.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:singleTap_S];
    singleTap_S.delegate = self;
    
    
    doubleTap_S = [[UITapGestureRecognizer alloc]
                    initWithTarget:self
                    action:@selector(handleDoubleTapFrom:)];
    doubleTap_S.numberOfTapsRequired = 2;
    doubleTap_S.delegate = self;
    
    //Fail to implement single tap if double tap is met
    [singleTap_S requireGestureRecognizerToFail:doubleTap_S];
    
    
    // Adding a Double Tap Gesture for all the Sample Views for the Ability to remove
    for( UIImageView * sampleView in sampleImages_S ){
        UITapGestureRecognizer * doubleTap_STEST = [[UITapGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(handleDoubleTapFrom:)];
        doubleTap_STEST.numberOfTapsRequired = 2;
        doubleTap_STEST.delegate = self;
        [sampleView setUserInteractionEnabled:YES];
        [sampleView addGestureRecognizer: doubleTap_STEST];
    }
    
}

#pragma -mark View Icons Switch
- (void)stateChangedViewIcon:(UISwitch *)switchState
{
    if( switchState.isOn ){
        UIGraphicsBeginImageContext(_currentImage_S.size);
        [_currentImage_S drawInRect:CGRectMake(0, 0, _currentImage_S.size.width, _currentImage_S.size.height)];
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
        [CVWrapper analysis:_currentImage_S studyNumber: 0 trialNumber:0 results:resultafter];
        
        
        swaleCoordinatesCalibrated = [CVWrapper getSwaleCoordinates];
         NSLog(@"There are %i swales detected" , swaleCoordinatesCalibrated.count);
        [self drawIconsInArray:swaleCoordinatesCalibrated image:swaleIcon2];
        
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    
        [self updateScrollView:result];
        NSLog(@"stateChangedViewIcon -- End ");
    } else {
        [self updateScrollView:_currentImage_S];
    }

}

-(void) drawIconsInArray:(NSMutableArray *)iconArray image:(UIImage*)iconImage{
    CGFloat squareWidth = _currentImage_S.size.width/23;
    CGFloat squareHeight = _currentImage_S.size.height/25;
    for( Coordinate * coord in iconArray){
        [iconImage drawInRect:CGRectMake( coord.getX * squareWidth,
                                         _currentImage_S.size.height - ( coord.getY + 1 ) * squareHeight,
                                         squareWidth, squareHeight)];
    }
}


#pragma -mark Update View

/*
 * Update the scroll view
 */
- (void) updateScrollView:(UIImage *) newImg {
    //MAKE SURE THAT IMAGE VIEW IS REMOVED IF IT EXISTS ON SCROLLVIEW!!
    if (img_S != nil)
    {
        [img_S removeFromSuperview];
        
    }
    
    img_S = [[UIImageView alloc] initWithImage:newImg];
    
    
    
     //handle pinching in/ pinching out to zoom
     img_S.userInteractionEnabled = YES;
     img_S.backgroundColor = [UIColor clearColor];
     img_S.contentMode =  UIViewContentModeCenter;
     //img.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.scrollView.minimumZoomScale=0.5;
    self.scrollView.maximumZoomScale=6.0;
    self.scrollView.contentSize = CGSizeMake(img_S.frame.size.width+100, img_S.frame.size.height+100);
    self.scrollView.clipsToBounds = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = true;
    self.scrollView.showsHorizontalScrollIndicator = true;

    
    
    //Set image on the scrollview
    [self.scrollView addSubview:img_S];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return img_S;
}


#pragma -mark Handle Taps

- (void) handleSingleTapFrom: (UITapGestureRecognizer *)recognizer
{
    printf("I am single tapping...\n");
    
    CGPoint point =[singleTap_S locationInView:self.scrollView];
    
    UIColor * color = [self GetCurrentPixelColorAtPoint:point];
    
    // Find the first view that has no color and add the color we found
    for (UIImageView * view in sampleImages_S) {
        if( [view.backgroundColor isEqual:UIColor.whiteColor]){
            view.backgroundColor = color;
            [SwaleSamples addObject:color];
            break;
        }
    }
    
    
}

- (void) handleDoubleTapFrom: (UITapGestureRecognizer *) recognizer
{
    printf("I double tapped\n");
    UIView *view = recognizer.view;
    
    Boolean removed = false;
    // Finds the color in the SwaleSamples array and removes it
    for (UIColor * color in SwaleSamples) {
        if( [color isEqual:view.backgroundColor]){
            [SwaleSamples removeObject:color];
            printf("Removed a color\n");
            printf("Permeable Pavers has %i things", SwaleSamples.count);
            removed = true;
            break;
        }
    }
    
    [self setHighandlowVal_Sues];
    
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
    NSLog(@"In ShowSamples: Samples has %i",SwaleSamples.count );
    for( UIColor * color in SwaleSamples){
        for (UIImageView * view in sampleImages_S) {
            if( [view.backgroundColor isEqual:UIColor.whiteColor]){
                view.backgroundColor = color;
                break;
            }
        }
    }
}

#pragma -mark Action Buttons

- (IBAction)removeAll:(id)sender {
    [SwaleSamples removeAllObjects];
    for( UIImageView * sample in sampleImages_S){
        sample.backgroundColor = UIColor.whiteColor;
    }
    
    NSIndexPath *selectedIndexPath = [tableView indexPathForSelectedRow];
    
    NSMutableArray * newSetting  = [savedLocationsFromFile getHSVForSavedLocationAtIndex: selectedIndexPath.row Icon:0];
    
    lowHue_S = [[newSetting objectAtIndex:0] integerValue];
    highHue_S = [[newSetting objectAtIndex:1] integerValue];
    
    lowSaturation_S = [[newSetting objectAtIndex:2] integerValue];
    highSaturation_S = [[newSetting objectAtIndex:3] integerValue];
    
    lowVal_S = [[newSetting objectAtIndex:4] integerValue];
    highVal_S = [[newSetting objectAtIndex:5] integerValue];
    
    NSLog(@"LowHue_S is %i", lowHue_S);
    
    [self changeHSVVals];
}

- (IBAction)setNoDefault:(id)sender {
    
    if( hasNoDefaultValues == false ){
        [self setNoDefault];
        hasNoDefaultValues =  1;
        noDefaultButton.selected = !noDefaultButton.selected;
    }else {
        [self setDefaultHSV];
        hasNoDefaultValues =  0;
        noDefaultButton.selected = !noDefaultButton.selected;
    }
}

#pragma mark - Threshold Switch
/*
 * This is the method that gets called when we toggle the switch.
 */
- (void)stateChanged:(UISwitch *)switchState
{
    if ([switchState isOn]) {
        [self threshold_image];
    } else {
        [self un_thresh_image];
    }
}

/*
 * Threshold
 */
- (void) threshold_image{
    if (plainImage_S == nil) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"No image to threshold!" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    //thresh either the plain image or the median filtered image
    /* thresholds image
     ** colorCases: 0 = green <--
     **             1 = red
     **             2 = wood
     **             3 = blue
     **             4 = dark green (corner markers)
     */
    
    [CVWrapper setSegmentIndex:0];
    [self changeHSVVals];
    
    threshedImage_S = [CVWrapper thresh:plainImage_S colorCase: 0];
    //_scrollView.zoomScale = plainImage_S.scale;
    [self updateScrollView:threshedImage_S];
}

/*
 * UnThreshold
 */
- (void) un_thresh_image{
    if (img_S != nil && (img_S.image != plainImage_S))
    {
        printf("Reseting to unthreshed image\n");
        [self updateScrollView:plainImage_S];
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
     ** colorCases: 0 = green <--
     **             1 = red
     **             2 = wood
     **             3 = blue
     **             4 = dark green (corner markers)
     */
    
    int caseNum = 0;
    int vals[30] = {0};
    [CVWrapper getHSV_Values:vals];
    
    if (SwaleSamples == NULL)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Samples of brown pieces not found: Please pick some samples" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        [alert show];
    }
    if( SwaleSamples.count < 2 && hasNoDefaultValues == true)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Using no default settings means you need to have at least 2 samples before you can threshold the image" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        [alert show];
    }
    
    // Find the High and Low Values
    [self setHighandlowVal_Sues];
    
    // changes the values by the CVWrapper
    vals[caseNum * 6] = lowHue_S;
    vals[caseNum * 6 + 1] = highHue_S;
    vals[caseNum * 6 + 2] = lowSaturation_S;
    vals[caseNum * 6 + 3] = highSaturation_S;
    vals[caseNum * 6 + 4] = lowVal_S;
    vals[caseNum * 6 + 5] = highVal_S;
    
    [CVWrapper setHSV_Values:vals];
    
    NSError *error;
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"hsvValues"];
    fileName = [fileName stringByAppendingPathExtension:@"txt"];
    
    NSString* content = [NSString stringWithContentsOfFile:fileName
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
    NSLog(@"Reading from hsvValues.txt from changeHSV --  after we use CVWrapper, does it change?: %@", content);
}

#pragma change HSV Values based on samples

/*
 * Goes through the Array of Colors and sets the High and Low Values of the Hue, Saturation, and Value.
 */
-(void) setHighandlowVal_Sues{
    int H_Sample;
    int S_Sample;
    int V_Sample;
    
    for( UIColor * color in SwaleSamples) {
        const CGFloat* components = CGColorGetComponents(color.CGColor);
        
        int red = components[0]*255.0;
        int green = components[1]*255.0;
        int blue = components[2]*255.0;
        
        [CVWrapper getHSVValuesfromRed:red Green:green Blue:blue H:&H_Sample S:&S_Sample V:&V_Sample];
        
        highHue_S = ( highHue_S < H_Sample ) ? H_Sample : highHue_S ;
        highSaturation_S = ( highSaturation_S < S_Sample ) ? S_Sample : highSaturation_S ;
        highVal_S = ( highVal_S < V_Sample ) ? V_Sample : highVal_S ;
        
        lowHue_S = ( lowHue_S > H_Sample ) ? H_Sample : lowHue_S ;
        lowSaturation_S = ( lowSaturation_S > S_Sample ) ? S_Sample : lowSaturation_S ;
        lowVal_S = ( lowVal_S > V_Sample ) ? V_Sample : lowVal_S;
        
    }
}

- (void) setNoDefault{
    lowHue_S = 225;
    highHue_S = 0;
    
    lowSaturation_S = 225;
    highSaturation_S = 0;
    
    lowVal_S = 225;
    highVal_S = 0;
}

- (void) setDefaultHSV{
    
    lowHue_S = 10;
    highHue_S = 80;
    
    lowSaturation_S = 50;
    highSaturation_S = 200;
    
    lowVal_S = 50;
    highVal_S = 255;
}

#pragma Change HSV Values based on Location

#pragma -mark Drop Down Menu
// Number of thins shown in the drop down

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    return [savedLocationsFromFile count];
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
    
    cell.textLabel.text = [savedLocationsFromFile nameOfObjectAtIndex:indexPath.row];
    
    return cell;
}

/*
 * Tells the delegate that the specified row is now selected.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableView * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [self.dropDown setTitle: [savedLocationsFromFile nameOfObjectAtIndex:indexPath.row]  forState:UIControlStateNormal];
    
    NSMutableArray * newSetting  = [savedLocationsFromFile getHSVForSavedLocationAtIndex:indexPath.row Icon:0];
    
    lowHue_S = [[newSetting objectAtIndex:0] integerValue];
    highHue_S = [[newSetting objectAtIndex:1] integerValue];
    
    lowSaturation_S = [[newSetting objectAtIndex:2] integerValue];
    highSaturation_S = [[newSetting objectAtIndex:3] integerValue];
    
    lowVal_S = [[newSetting objectAtIndex:4] integerValue];
    highVal_S = [[newSetting objectAtIndex:5] integerValue];
    
    NSLog(@"LowHue_S is %i", lowHue_S);
    
    [self changeHSVVals];
    
    self.tableView.hidden =  TRUE;
}


- (IBAction)dropDownButton:(id)sender {
    if( self.tableView.hidden == TRUE )
        self.tableView.hidden =  FALSE;
    else
        self.tableView.hidden = TRUE;
}

@end
