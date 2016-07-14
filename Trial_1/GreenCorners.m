//
//  GreenCorner.m
//  Trial_1
//
//  Created by Jamie Auza on 5/20/16.
//  Copyright © 2016 Jamie Auza. All rights reserved.
//

#import "GreenCorners.h"
#import "CVWrapper.h"
#import "Coordinate.h"
#import "savedLocations.h"
#import "analysisViewController.h"
#import <math.h>
#import <stdlib.h>

@implementation GreenCorners

UITapGestureRecognizer * singleTap_GC; // tap that recognizes color extraction
UITapGestureRecognizer * doubleTap_GC; // tap that recognizes removal of sample

UIImage* plainImage_GC = nil;
UIImageView * img_GC;
UIImage* threshedImage_GC = nil;

NSMutableArray * GreenCornerSamples;
NSMutableArray * sampleImages_GC;

int highHue_GC, highSaturation_GC, highVal_GC;
int lowHue_GC, lowSaturation_GC, lowVal_GC;
savedLocations* savedLocationsFromFile_GC;

@synthesize sample1;
@synthesize sample2;
@synthesize sample3;
@synthesize sample4;
@synthesize sample5;
@synthesize sample6;
@synthesize sample7;
@synthesize sample8;
@synthesize sample9;
@synthesize tableView;
@synthesize originalImage;

long int clickedSegment_GC;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initializing the switch
    [self.threshSwitch addTarget:self
                          action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
    _threshSwitch.on = false;
    
    // Set Default HSV Values
    [self setHSVValues];
    
    if( GreenCornerSamples.count == 0) {
        GreenCornerSamples = [NSMutableArray array];
        sampleImages_GC = [NSMutableArray array];
        
        [sampleImages_GC addObject:sample1];
        [sampleImages_GC addObject:sample2];
        [sampleImages_GC addObject:sample3];
        [sampleImages_GC addObject:sample4];
        [sampleImages_GC addObject:sample5];
        [sampleImages_GC addObject:sample6];
        [sampleImages_GC addObject:sample7];
        [sampleImages_GC addObject:sample8];
        [sampleImages_GC addObject:sample9];
        
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
    
    
    // For Drop Down
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    savedLocationsFromFile_GC = [[savedLocations alloc] init];
    
    // Back Button
    UIBarButtonItem *buttonizeButton = [[UIBarButtonItem alloc] initWithTitle:@"Buttonize"
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(buttonizeButtonTap:)];
    self.navigationItem.rightBarButtonItems = @[buttonizeButton];
    
    _highLowVals_GC = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    plainImage_GC = originalImage;
    
    [self updateScrollView:originalImage];
    
    
    // Initializing the Tap Gestures
    singleTap_GC = [[UITapGestureRecognizer alloc]
                    initWithTarget:self
                    action:@selector(handleSingleTapFrom:)];
    singleTap_GC.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:singleTap_GC];
    singleTap_GC.delegate = self;
    
    
    doubleTap_GC = [[UITapGestureRecognizer alloc]
                    initWithTarget:self
                    action:@selector(handleDoubleTapFrom:)];
    doubleTap_GC.numberOfTapsRequired = 2;
    doubleTap_GC.delegate = self;
    
    //Fail to implement single tap if double tap is met
    [singleTap_GC requireGestureRecognizerToFail:doubleTap_GC];
    
    
    // Adding a Double Tap Gesture for all the Sample Views for the Ability to remove
    for( UIImageView * sampleView in sampleImages_GC ){
        UITapGestureRecognizer * doubleTap_GCTEST = [[UITapGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(handleDoubleTapFrom:)];
        doubleTap_GCTEST.numberOfTapsRequired = 2;
        doubleTap_GCTEST.delegate = self;
        [sampleView setUserInteractionEnabled:YES];
        [sampleView addGestureRecognizer: doubleTap_GCTEST];
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
    if ([[segue identifier] isEqualToString:@"backToAnalysis_GC"])
    {
        analysisViewController *analysisViewController = [segue destinationViewController];
        analysisViewController.currentImage_A = originalImage;
    }
}
-(void)buttonizeButtonTap:(id)sender{
    [self performSegueWithIdentifier:@"backToAnalysis_GC" sender:sender];
}

- (IBAction)backButton:(id)sender {
    [self buttonizeButtonTap: self];
}

#pragma -mark Update View

/*
 * Update the scroll view
 */
- (void) updateScrollView:(UIImage *) newImg {
    //MAKE SURE THAT IMAGE VIEW IS REMOVED IF IT EXISTS ON SCROLLVIEW!!
    if (img_GC != nil)
    {
        [img_GC removeFromSuperview];
        
    }
    
    img_GC = [[UIImageView alloc] initWithImage:newImg];
    
    
    
    //handle pinching in/ pinching out to zoom
    img_GC.userInteractionEnabled = YES;
    img_GC.backgroundColor = [UIColor clearColor];
    img_GC.contentMode =  UIViewContentModeCenter;
    //img.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.scrollView.minimumZoomScale=0.5;
    self.scrollView.maximumZoomScale=6.0;
    self.scrollView.contentSize = CGSizeMake(img_GC.frame.size.width+100, img_GC.frame.size.height+100);
    self.scrollView.clipsToBounds = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = true;
    self.scrollView.showsHorizontalScrollIndicator = true;
    
    
    
    //Set image on the scrollview
    [self.scrollView addSubview:img_GC];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return img_GC;
}
#pragma -mark sending data
- (NSString*) getColorPaletteLabel{
    return self.dropDown.currentTitle;
}

- (NSMutableArray*) getHighLowVals{
    [_highLowVals_GC removeAllObjects];
    [_highLowVals_GC addObject:[NSString stringWithFormat:@"%d",lowHue_GC]];
    [_highLowVals_GC addObject:[NSString stringWithFormat:@"%d",highHue_GC]];
    [_highLowVals_GC addObject:[NSString stringWithFormat:@"%d",lowSaturation_GC]];
    [_highLowVals_GC addObject:[NSString stringWithFormat:@"%d",highSaturation_GC]];
    [_highLowVals_GC addObject:[NSString stringWithFormat:@"%d",lowVal_GC]];
    [_highLowVals_GC addObject:[NSString stringWithFormat:@"%d",highVal_GC]];
    return _highLowVals_GC;
}

#pragma -mark Handle Taps

- (void) handleSingleTapFrom: (UITapGestureRecognizer *)recognizer
{
    printf("I am single tapping...\n");
    
    CGPoint point =[singleTap_GC locationInView:self.scrollView];
    
    UIColor * color = [self GetCurrentPixelColorAtPoint:point];
    
    // Find the first view that has no color and add the color we found
    for (UIImageView * view in sampleImages_GC) {
        if( [view.backgroundColor isEqual:UIColor.whiteColor]){
            view.backgroundColor = color;
            [GreenCornerSamples addObject:color];
            break;
        }
    }
    
    [self setHighandlowVal_GCues];
    
    if( [self.dropDown.currentTitle isEqualToString:@"Choose Saved Color Palette"])
        [self changeColorSetToIndex: 0];
}

- (void) handleDoubleTapFrom: (UITapGestureRecognizer *) recognizer
{
    printf("I double tapped\n");
    UIView *view = recognizer.view;
    
    Boolean removed = false;
    // Finds the color in the GreenCornerSamples array and removes it
    for (UIColor * color in GreenCornerSamples) {
        if( [color isEqual:view.backgroundColor]){
            [GreenCornerSamples removeObject:color];
            removed = true;
            break;
        }
    }
    
    // Before setting the High and Low values, change to default from picked color set
    [self changeColorSetToIndex:clickedSegment_GC];
    [self setHighandlowVal_GCues];
    
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
    NSLog(@"In ShowSamples: Samples has %i",GreenCornerSamples.count );
    for( UIColor * color in GreenCornerSamples){
        for (UIImageView * view in sampleImages_GC) {
            if( [view.backgroundColor isEqual:UIColor.whiteColor]){
                view.backgroundColor = color;
                break;
            }
        }
    }
}

#pragma -mark Action Buttons

- (IBAction)removeAll:(id)sender {
    [GreenCornerSamples removeAllObjects];
    for( UIImageView * sample in sampleImages_GC){
        sample.backgroundColor = UIColor.whiteColor;
    }
    if( _threshSwitch.isOn){
        [_threshSwitch setOn:false];
        [self updateScrollView:originalImage];
    }
    [self setHighandlowVal_GCues];
    [self changeColorSetToIndex: clickedSegment_GC];
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
    if (plainImage_GC == nil) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"No image to threshold!" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    //thresh either the plain image or the median filtered image
    /* thresholds image
     ** colorCases: 0 = green
     **             1 = red
     **             2 = wood
     **             3 = blue
     **             4 = dark green (corner markers) <--
     */
    
    [CVWrapper setSegmentIndex:4];
    [self changeHSVVals];
    
    threshedImage_GC = [CVWrapper thresh:plainImage_GC colorCase: 4];
    //_scrollView.zoomScale = plainImage_GC.scale;
    [self updateScrollView:threshedImage_GC];
}

/*
 * UnThreshold
 */
- (void) un_thresh_image{
    if (img_GC != nil && (img_GC.image != plainImage_GC))
    {
        printf("Reseting to unthreshed image\n");
        [self updateScrollView:plainImage_GC];
    }
}

#pragma -mark HSV Values

/*
 * Gets the integers from hsvValues.txt and sends them to CVWrapper
 */
- (void) setHSVValues {
    /*
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
     */
    
    int hsvValues[] = {255, 0, 255, 0, 255, 0,
        255, 0, 255, 0, 255, 0,
        255, 0, 255, 0, 255, 0,
        255, 0, 255, 0, 255, 0,
        255, 0, 255, 0, 255, 0};
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
     **             2 = wood
     **             3 = blue
     **             4 = dark green (corner markers) <--
     */
    
    int caseNum = 4;
    int vals[30] = {0};
    [CVWrapper getHSV_Values:vals];
    
    if (GreenCornerSamples == NULL)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Samples of brown pieces not found: Please pick some samples" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        [alert show];
    }
    
    // Find the High and Low Values from Samples
    [self setHighandlowVal_GCues];
    
    // changes the values by the CVWrapper
    vals[caseNum * 6] = lowHue_GC;
    vals[caseNum * 6 + 1] = highHue_GC;
    vals[caseNum * 6 + 2] = lowSaturation_GC;
    vals[caseNum * 6 + 3] = highSaturation_GC;
    vals[caseNum * 6 + 4] = lowVal_GC;
    vals[caseNum * 6 + 5] = highVal_GC;
    
    [CVWrapper setHSV_Values:vals];
}

#pragma change HSV Values based on samples

/*
 * Goes through the Array of Colors and sets the High and Low Values of the Hue, Saturation, and Value.
 */
- (void) setHighandlowVal_GCues{
    int H_Sample;
    int S_Sample;
    int V_Sample;
    
    for( UIColor * color in GreenCornerSamples) {
        const CGFloat* components = CGColorGetComponents(color.CGColor);
        
        int red = components[0]*255.0;
        int green = components[1]*255.0;
        int blue = components[2]*255.0;
        
        [CVWrapper getHSVValuesfromRed:red Green:green Blue:blue H:&H_Sample S:&S_Sample V:&V_Sample];
        
        highHue_GC = ( highHue_GC < H_Sample ) ? H_Sample : highHue_GC ;
        highSaturation_GC = ( highSaturation_GC < S_Sample ) ? S_Sample : highSaturation_GC ;
        highVal_GC = ( highVal_GC < V_Sample ) ? V_Sample : highVal_GC ;
        
        lowHue_GC = ( lowHue_GC > H_Sample ) ? H_Sample : lowHue_GC ;
        lowSaturation_GC = ( lowSaturation_GC > S_Sample ) ? S_Sample : lowSaturation_GC ;
        lowVal_GC = ( lowVal_GC > V_Sample ) ? V_Sample : lowVal_GC;
        
    }
}

#pragma Change HSV Values based on Location

#pragma -mark Drop Down Menu
// Number of thins shown in the drop down

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    return [savedLocationsFromFile_GC count];
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
    
    cell.textLabel.text = [savedLocationsFromFile_GC nameOfObjectAtIndex:indexPath.row];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.40 green:0.60 blue:0.20 alpha:1.0];
    
    return cell;
}

/*
 * Tells the delegate that the specified row is now selected.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if( _threshSwitch.isOn ){
        [_threshSwitch setOn:false];
        [self updateScrollView:originalImage];
    }
    
    clickedSegment_GC = index;
    [self changeColorSetToIndex:indexPath.row];
}

- (void) changeColorSetToIndex: (int)index{
    clickedSegment_GC = index;
    
    [self.dropDown setTitle: [savedLocationsFromFile_GC nameOfObjectAtIndex:index]  forState:UIControlStateNormal];
    
    // Icon == CaseNum
    NSMutableArray * newSetting  = [savedLocationsFromFile_GC getHSVForSavedLocationAtIndex:index Icon:4];
    
    lowHue_GC = [[newSetting objectAtIndex:0] integerValue];
    highHue_GC = [[newSetting objectAtIndex:1] integerValue];
    
    lowSaturation_GC = [[newSetting objectAtIndex:2] integerValue];
    highSaturation_GC = [[newSetting objectAtIndex:3] integerValue];
    
    lowVal_GC = [[newSetting objectAtIndex:4] integerValue];
    highVal_GC = [[newSetting objectAtIndex:5] integerValue];
    
    [self changeHSVVals];
    
    self.tableView.hidden =  TRUE;
    
    
}

// Called after we save to change the tableview
- (void) changeFromFile{
    savedLocationsFromFile_GC = [savedLocationsFromFile_GC changeFromFile];
    [self.tableView reloadData];
}

- (IBAction)dropDownButton:(id)sender {
    if( self.tableView.hidden == TRUE )
        self.tableView.hidden =  FALSE;
    else
        self.tableView.hidden = TRUE;
}



@end
