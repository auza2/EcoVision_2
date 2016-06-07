//
//  PermeablePaver.m
//  Trial_1
//
//  Created by Jamie Auza on 5/30/16.
//  Copyright © 2016 Jamie Auza. All rights reserved.
//

#import "PermeablePaver.h"
#import "CVWrapper.h"

@implementation PermeablePaver

UITapGestureRecognizer * singleTap_PP; // tap that recognizes color extraction
UITapGestureRecognizer * doubleTap_PP; // tap that recognizes removal of sample

UIImage* plainImage_PP = nil;
UIImageView * img_PP;
UIImage* threshedImage_PP = nil;

NSMutableArray * PermeablePaverSamples;
NSMutableArray * sampleImages_PP;

int highHue_PP, highSaturation_PP, highVal_PP;
int lowHue_PP, lowSaturation_PP, lowVal_PP;

@synthesize sample1;
@synthesize sample2;
@synthesize sample3;
@synthesize sample4;
@synthesize sample5;
@synthesize sample6;
@synthesize sample7;
@synthesize sample8;
@synthesize sample9;



long int clickedSegment_PP;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    // Initializing the switch
    [self.threshSwitch addTarget:self
                          action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
    _threshSwitch.on = false;
    
    // Set Default HSV Values
    [self setHSVValues];
    [self setDefaultHSV];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    plainImage_PP = _currentImage_PP;
    
    [self updateScrollView:_currentImage_PP];
    
    PermeablePaverSamples = [NSMutableArray array];
    sampleImages_PP = [NSMutableArray array];
    
    [sampleImages_PP addObject:sample1];
    [sampleImages_PP addObject:sample2];
    [sampleImages_PP addObject:sample3];
    [sampleImages_PP addObject:sample4];
    [sampleImages_PP addObject:sample5];
    [sampleImages_PP addObject:sample6];
    [sampleImages_PP addObject:sample7];
    [sampleImages_PP addObject:sample8];
    [sampleImages_PP addObject:sample9];
    
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
    
    
    // Initializing the Tap Gestures
    singleTap_PP = [[UITapGestureRecognizer alloc]
                    initWithTarget:self
                    action:@selector(handleSingleTapFrom:)];
    singleTap_PP.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:singleTap_PP];
    singleTap_PP.delegate = self;
    
    
    doubleTap_PP = [[UITapGestureRecognizer alloc]
                    initWithTarget:self
                    action:@selector(handleDoubleTapFrom:)];
    doubleTap_PP.numberOfTapsRequired = 2;
    doubleTap_PP.delegate = self;
    
    //Fail to implement single tap if double tap is met
    [singleTap_PP requireGestureRecognizerToFail:doubleTap_PP];
    
    
    // Adding a Double Tap Gesture for all the Sample Views for the Ability to remove
    for( UIImageView * sampleView in sampleImages_PP ){
        UITapGestureRecognizer * doubleTap_PPTEST = [[UITapGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(handleDoubleTapFrom:)];
        doubleTap_PPTEST.numberOfTapsRequired = 2;
        doubleTap_PPTEST.delegate = self;
        [sampleView setUserInteractionEnabled:YES];
        [sampleView addGestureRecognizer: doubleTap_PPTEST];
    }
    
}

#pragma -mark Handle Taps

/*
 * Update the scroll view
 */
- (void) updateScrollView:(UIImage *) newImg {
    //MAKE SURE THAT IMAGE VIEW IS REMOVED IF IT EXISTS ON SCROLLVIEW!!
    if (img_PP != nil)
    {
        [img_PP removeFromSuperview];
        
    }
    
    img_PP = [[UIImageView alloc] initWithImage:newImg];
    
    
    /*
     //handle pinching in/ pinching out to zoom
     img.userInteractionEnabled = YES;
     img.backgroundColor = [UIColor clearColor];
     img.contentMode =  UIViewContentModeCenter;
     //img.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
     */
    
    //add a tap gesture recognizer for extracting colour
    
    
    self.scrollView.minimumZoomScale=0.5;
    self.scrollView.maximumZoomScale=15.0;
    self.scrollView.contentSize = CGSizeMake(img_PP.frame.size.width+100, img_PP.frame.size.height+100);
    self.scrollView.clipsToBounds = YES;
    self.scrollView.delegate = self;
    //self.TouchableImage.contentSize=CGSizeMake(1280, 960);
    
    
    
    //Set image on the scrollview
    [self.scrollView addSubview:img_PP];
}

- (void) handleSingleTapFrom: (UITapGestureRecognizer *)recognizer
{
    printf("I am single tapping...\n");
    
    CGPoint point =[singleTap_PP locationInView:self.scrollView];
    
    UIColor * color = [self GetCurrentPixelColorAtPoint:point];
    
    // Find the first view that has no color and add the color we found
    for (UIImageView * view in sampleImages_PP) {
        if( [view.backgroundColor isEqual:UIColor.whiteColor]){
            view.backgroundColor = color;
            [PermeablePaverSamples addObject:color];
            break;
        }
    }
}

- (void) handleDoubleTapFrom: (UITapGestureRecognizer *) recognizer
{
    printf("I double tapped\n");
    UIView *view = recognizer.view;
    
    Boolean removed = false;
    // Finds the color in the PermeablePaverSamples array and removes it
    for (UIColor * color in PermeablePaverSamples) {
        if( [color isEqual:view.backgroundColor]){
            [PermeablePaverSamples removeObject:color];
            printf("Removed a color\n");
            printf("Permeable Pavers has %i things", PermeablePaverSamples.count);
            removed = true;
            break;
        }
    }
    
    if( removed )
        [self setDefaultHSV];
    
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

#pragma -mark Action Buttons

- (IBAction)removeAll:(id)sender {
    [PermeablePaverSamples removeAllObjects];
    for( UIImageView * sample in sampleImages_PP){
        sample.backgroundColor = UIColor.whiteColor;
    }
    [self setDefaultHSV];
    printf("Permeable Pavers has %i things \n", PermeablePaverSamples.count);
    
}
#pragma mark - Threshold
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
    if (plainImage_PP == nil) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"No image to threshold!" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //thresh either the plain image or the median filtered image
    /* thresholds image
     ** colorCases: 0 = green
     **             1 = red
     **             2 = wood
     **             3 = blue <--
     **             4 = dark green (corner markers)
     */
    
    [CVWrapper setSegmentIndex:3];
    [self changeHSVVals];
    threshedImage_PP = [CVWrapper thresh:plainImage_PP colorCase: 3];
    [self updateScrollView:threshedImage_PP];
}

/*
 * UnThreshold
 */
- (void) un_thresh_image{
    if (img_PP != nil && (img_PP.image != plainImage_PP))
    {
        printf("Reseting to unthreshed image\n");
        [self updateScrollView:plainImage_PP];
    }
}


#pragma -mark HSV Values

/*
 * Set's the hue, saturation, and value for all the green infrastructure icons from a file.
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
    
    NSArray *arr = [content componentsSeparatedByString:@" "];
    
    int i;
    for(i = 0; i < 30; i++) {
        // loss of precision is fine since all numbers stored in arr will have only zeroes after the decimal
        hsvValues[i] = [[arr objectAtIndex:i]integerValue];
    }
    
    [CVWrapper setHSV_Values:hsvValues];
}

- (void) changeHSVVals{
    /*
    ** colorCases: 0 = green
    **             1 = red
    **             2 = wood
    **             3 = blue <--
    **             4 = dark green (corner markers)
     */
    
    int caseNum = 3;
    int vals[30] = {0};
    [CVWrapper getHSV_Values:vals];
    
    if (PermeablePaverSamples == NULL)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Samples of brown pieces not found: Please pick some samples" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        [alert show];
    }
    
    // Find the High and Low Values
    [self setHighandlowVal_PPues];
    
    // changes the values by the CVWrapper
    vals[caseNum * 6] = lowHue_PP;
    vals[caseNum * 6 + 1] = highHue_PP;
    vals[caseNum * 6 + 2] = lowSaturation_PP;
    vals[caseNum * 6 + 3] = highSaturation_PP;
    vals[caseNum * 6 + 4] = lowVal_PP;
    vals[caseNum * 6 + 5] = highVal_PP;
    
    [CVWrapper setHSV_Values:vals];
}

/*
 * Goes through the Array of Colors and sets the High and Low Values of the Hue, Saturation, and Value.
 */
-(void) setHighandlowVal_PPues{
    int H_Sample;
    int S_Sample;
    int V_Sample;
    
    for( UIColor * color in PermeablePaverSamples) {
        const CGFloat* components = CGColorGetComponents(color.CGColor);
        
        int red = components[0]*255.0;
        int green = components[1]*255.0;
        int blue = components[2]*255.0;
        /*
         NSLog(@"Red: %f", components[0]*255.0);
         NSLog(@"Green: %f", components[1]*255.0);
         NSLog(@"Blue: %f", components[2]*255.0);
         NSLog(@"Alpha: %f", CGColorGetAlpha(color.CGColor)*255.0);
         */
        [CVWrapper getHSVValuesfromRed:red Green:green Blue:blue H:&H_Sample S:&S_Sample V:&V_Sample];
        
        /*
         NSLog(@"___________________________________");
         NSLog(@"Hue Sample: %i",H_Sample);
         NSLog(@"Saturation Sample: %i", S_Sample);
         NSLog(@"Value Sample: %i", V_Sample);
         */
        
        highHue_PP = ( highHue_PP < H_Sample ) ? H_Sample : highHue_PP ;
        highSaturation_PP = ( highSaturation_PP < S_Sample ) ? S_Sample : highSaturation_PP ;
        highVal_PP = ( highVal_PP < V_Sample ) ? V_Sample : highVal_PP ;
        
        lowHue_PP = ( lowHue_PP > H_Sample ) ? H_Sample : lowHue_PP ;
        lowSaturation_PP = ( lowSaturation_PP > S_Sample ) ? S_Sample : lowSaturation_PP ;
        lowVal_PP = ( lowVal_PP > V_Sample ) ? V_Sample : lowVal_PP;
        
    }
}

- (void) setDefaultHSV{

    lowHue_PP = 0;
    highHue_PP = 15;
    
    lowSaturation_PP = 30;
    highSaturation_PP = 220;
    
    lowVal_PP = 50;
    highVal_PP = 210;
}


@end
