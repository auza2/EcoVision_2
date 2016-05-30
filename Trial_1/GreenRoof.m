//
//  GreenRoof.m
//  Trial_1
//
//  Created by Jamie Auza on 5/27/16.
//  Copyright © 2016 Jamie Auza. All rights reserved.
//

#import "GreenRoof.h"
#import "CVWrapper.h"


@implementation GreenRoof
UITapGestureRecognizer * singleTap_GR; // tap that recognizes color extraction
UITapGestureRecognizer * doubleTap_GR; // tap that recognizes removal of sample

UIImage* plainImage_GR = nil;
UIImageView * img_GR;
UIImage* threshedImage_GR = nil;

NSMutableArray * GreenRoofSamples;
NSMutableArray * sampleImages_GR;

int highHue, highSaturation, highVal;
int lowHue, lowSaturation, lowVal;

@synthesize sample1;
@synthesize sample2;
@synthesize sample3;
@synthesize sample4;
@synthesize sample5;
@synthesize sample6;
@synthesize sample7;
@synthesize sample8;
@synthesize sample9;



long int clickedSegment_GR;

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
    plainImage_GR = _currentImage_GR;
    
    [self updateScrollView:_currentImage_GR];
    
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
    
}

#pragma -mark Handle Taps

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
    self.scrollView.contentSize = CGSizeMake(img_GR.frame.size.width+100, img_GR.frame.size.height+100);
    self.scrollView.clipsToBounds = YES;
    self.scrollView.delegate = self;
    //self.TouchableImage.contentSize=CGSizeMake(1280, 960);
    
    
    
    //Set image on the scrollview
    [self.scrollView addSubview:img_GR];
}

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
            printf("Green Samples has %i things", GreenRoofSamples.count);
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
    [GreenRoofSamples removeAllObjects];
    for( UIImageView * sample in sampleImages_GR){
        sample.backgroundColor = UIColor.whiteColor;
    }
    [self setDefaultHSV];
    printf("Green Samples has %i things \n", GreenRoofSamples.count);
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
    
    [CVWrapper setSegmentIndex:2];
    [self changeHSVVals];
    threshedImage_GR = [CVWrapper thresh:plainImage_GR colorCase: [CVWrapper getSegmentIndex]];
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
    int caseNum = 2;
    int vals[30] = {0};
    [CVWrapper getHSV_Values:vals];
    
    if (GreenRoofSamples == NULL)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Samples of brown pieces not found: Please pick some samples" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
        [alert show];
    }
    
    // Find the High and Low Values
    [self setHighandLowValues];
    
    // changes the values by the CVWrapper
    vals[caseNum * 6] = lowHue;
    vals[caseNum * 6 + 1] = highHue;
    vals[caseNum * 6 + 2] = lowSaturation;
    vals[caseNum * 6 + 3] = highSaturation;
    vals[caseNum * 6 + 4] = lowVal;
    vals[caseNum * 6 + 5] = highVal;
    
    [CVWrapper setHSV_Values:vals];
}

/*
 * Goes through the Array of Colors and sets the High and Low Values of the Hue, Saturation, and Value.
 */
-(void) setHighandLowValues{
    int H_Sample;
    int S_Sample;
    int V_Sample;
    
    for( UIColor * color in GreenRoofSamples) {
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
        
        highHue = ( highHue < H_Sample ) ? H_Sample : highHue ;
        highSaturation = ( highSaturation < S_Sample ) ? S_Sample : highSaturation ;
        highVal = ( highVal < V_Sample ) ? V_Sample : highVal ;
        
        lowHue = ( lowHue > H_Sample ) ? H_Sample : lowHue ;
        lowSaturation = ( lowSaturation > S_Sample ) ? S_Sample : lowSaturation ;
        lowVal = ( lowVal > V_Sample ) ? V_Sample : lowVal;
        
    }
}

- (void) setDefaultHSV{
    lowHue = 90;
    highHue = 110;
    
    lowSaturation = 40;
    highSaturation = 100;
    
    lowVal = 120;
    highVal = 225;
}
@end
