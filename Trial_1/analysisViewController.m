//
//  analysisViewController.m
//  Trial_1
//
//  Created by Jamie Auza on 5/20/16.
//  Copyright © 2016 Jamie Auza. All rights reserved.
//

#import "analysisViewController.h"
#import "Swale.h"
#import "GreenRoof.h"
#import "PermeablePaver.h"
#import "RainBarrel.h"
#import "CVWrapper.h"
#import "Coordinate.h"

@implementation analysisViewController
UITapGestureRecognizer * singleTap_A; // tap that recognizes color extraction
UITapGestureRecognizer * doubleTap_A; // tap that recognizes removal of sample


UIImage* plainImage2 = nil;

UIImage* watermarkImage = nil;
UIImage* swaleIcon = nil;
UIImage* rainBarrelIcon = nil;
UIImage* greenRoofIcon = nil;
UIImage* permeablePaverIcon = nil;

NSMutableArray* swaleCoordinates;
NSMutableArray* rainBarrelCoordinates;
NSMutableArray* permeablePaverCoordinates;
NSMutableArray* greenRoofCoordinates;
NSMutableArray* arrayOfCoordinateArrays;
NSMutableArray* addButtons;

int pressedButton = -1;

@synthesize swaleSwitch;
@synthesize greenRoofSwitch;
@synthesize permeablePaverSwitch;
@synthesize rainBarrelSwitch;

@synthesize currentImage_A;

@synthesize squareWidth;
@synthesize squareHeight;
@synthesize switches; // doesnt need to be a property

@synthesize watermarkButton;

@synthesize addSwaleButton;
@synthesize addRainBarrelButton;
@synthesize addGreenRoofButton;
@synthesize addPermeablePaverButton;

- (void) viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Set up the picture on Scroll View
    plainImage2 = currentImage_A;
    [self updateScrollView:plainImage2];
    watermarkImage = [UIImage imageNamed:@"watermark.png"];
    
    // Getting Icon Images
    swaleIcon = [UIImage imageNamed:@"Swale_Icon.png"];
    rainBarrelIcon = [UIImage imageNamed:@"RainBarrel_Icon.png"];
    greenRoofIcon = [UIImage imageNamed:@"GreenRoof_Icon.png"];
    permeablePaverIcon = [UIImage imageNamed:@"PermeablePaver_Icon.png"];
    
    // Get Coordinates
    swaleCoordinates = [CVWrapper getSwaleCoordinates];
    rainBarrelCoordinates = [CVWrapper getRainBarrelCoordinates];
    permeablePaverCoordinates = [CVWrapper getPermeablePaverCoordinates];
    greenRoofCoordinates = [CVWrapper getGreenRoofCoordinates];
    
    // Initilializing
    arrayOfCoordinateArrays = [[NSMutableArray alloc] init];
    
    [arrayOfCoordinateArrays addObject: swaleCoordinates];
    [arrayOfCoordinateArrays addObject: rainBarrelCoordinates];
    [arrayOfCoordinateArrays addObject: permeablePaverCoordinates];
    [arrayOfCoordinateArrays addObject: greenRoofCoordinates];
    
    NSLog(@"Width: %f", currentImage_A.size.width);
    NSLog(@"Height: %f", currentImage_A.size.height);
    
    // Initializing the switches
    switches = [[NSMutableArray alloc] init];
    
    [switches addObject: swaleSwitch];
    [switches addObject: rainBarrelSwitch];
    [switches addObject: permeablePaverSwitch];
    [switches addObject: greenRoofSwitch];
    
    
    for( UISwitch * s in switches){
        [s addTarget:self
                        action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    squareWidth = currentImage_A.size.width/23;
    squareHeight = currentImage_A.size.height/25;
    
    
    // Testing Gradient
    /*
    CAGradientLayer *btnGradient = [CAGradientLayer layer];
    btnGradient.frame = watermarkButton.bounds;
    btnGradient.colors = [NSArray arrayWithObjects:
                          (id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor],
                          (id)[[UIColor colorWithRed:51.0f / 255.0f green:51.0f / 255.0f blue:51.0f / 255.0f alpha:1.0f] CGColor],
                          nil];
    [watermarkButton.layer insertSublayer:btnGradient atIndex:0];
    
    CALayer *btnLayer = [watermarkButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
     */
    
    // Testing Pressed
    
    // Add Buttons
    addButtons = [[NSMutableArray alloc] init];

    [addButtons addObject: addSwaleButton];
    [addButtons addObject: addGreenRoofButton];
    [addButtons addObject: addRainBarrelButton];
    [addButtons addObject: addPermeablePaverButton];
    
    // Tap Gestures
    // Initializing the Tap Gestures
    singleTap_A = [[UITapGestureRecognizer alloc]
                    initWithTarget:self
                    action:@selector(handleSingleTapFrom:)];
    singleTap_A.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:singleTap_A];
    singleTap_A.delegate = self;
    
    
    doubleTap_A = [[UITapGestureRecognizer alloc]
                    initWithTarget:self
                    action:@selector(handleDoubleTapFrom:)];
    doubleTap_A.numberOfTapsRequired = 2;
    doubleTap_A.delegate = self;
    [_scrollView addGestureRecognizer:doubleTap_A];

}

#pragma mark - Tap Handlers

- (void) handleSingleTapFrom: (UITapGestureRecognizer *)recognizer
{
    printf("I am single tapping...\n");
    
    CGPoint point =[singleTap_A locationInView:self.scrollView];
    
    // Covert Point to Coordinate Object
    Coordinate * addCoord;
    addCoord = [[Coordinate alloc] initWithXCoord:(point.x / squareWidth) YCoord: 25 -(point.y / squareHeight)];
    
    // We should have error messages if that Icon isn't allowed on that location
    
    NSLog(@"Coordinate found X Value: %i", addCoord.getX);
    NSLog(@"Coordinate found y Value: %i", addCoord.getY);
    
    switch(pressedButton){
        case -1:
            // No add button was pressed
            // Add pop-up error message
            break;
        case 0:
            [swaleCoordinates addObject:addCoord];
            break;
        case 1:
            [rainBarrelCoordinates addObject:addCoord];
            break;
        case 2:
            [greenRoofCoordinates addObject:addCoord];
            break;
        case 3:
            [permeablePaverCoordinates addObject:addCoord];
            break;
    }

    if( pressedButton != -1 )
        [self updateViewedIcons];
}

- (void) handleDoubleTapFrom: (UITapGestureRecognizer *) recognizer
{
    printf("I double tapped\n");
    
    CGPoint point =[doubleTap_A locationInView:self.scrollView];
    
    // Covert Point to Coordinate Object
    Coordinate * removeCoord;
    removeCoord = [[Coordinate alloc] initWithXCoord:(point.x / squareWidth) YCoord: 25 - (point.y / squareHeight) ];
    
    NSLog(@"Coordinate found X Value -- remove: %i", removeCoord.getX);
    NSLog(@"Coordinate found y Value -- remove: %i", removeCoord.getY);
    
    Coordinate * removeMe =[[Coordinate alloc] initWithXCoord:-1 YCoord: -1 ]; // Cannot remove while looping
    
    for( NSMutableArray * coordinateArray in arrayOfCoordinateArrays){
        for( Coordinate * coord in coordinateArray ){
            if( coord.getX == removeCoord.getX &&  coord.getY == removeCoord.getY )
                removeMe = coord;
        }
        
        if( removeMe.getY != -1 ){
            [coordinateArray removeObject:removeMe];
        }
    }
    
    [self updateViewedIcons];
}


#pragma mark - Switches
/*
 * This is the method that gets called when we toggle the switch.
 */
- (void)stateChanged:(UISwitch *)switchState
{
    [self updateViewedIcons];
}

-(void) updateViewedIcons{
    UIGraphicsBeginImageContext(currentImage_A.size);
    [currentImage_A drawInRect:CGRectMake(0, 0, currentImage_A.size.width, currentImage_A.size.height)];
     NSLog(@"Updating what's shown");
    
    for( UISwitch * s in switches){
        if( s.on == true ){
            switch( s.tag ){
                case 0:
                    [self drawIconsInArray:swaleCoordinates image:swaleIcon];
                    break;
                case 1:
                    [self drawIconsInArray:rainBarrelCoordinates image:rainBarrelIcon];
                    break;
                case 2:
                    [self drawIconsInArray:greenRoofCoordinates image:greenRoofIcon];
                    break;
                case 3:
                    [self drawIconsInArray:permeablePaverCoordinates image:permeablePaverIcon];
                    break;
            }
        }
    }
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self updateScrollView:result];
    NSLog(@"Done Updating what's shown");
}

-(void) drawIconsInArray:(NSMutableArray *)iconArray image:(UIImage*)iconImage{
    for( Coordinate * coord in iconArray){
        [iconImage drawInRect:CGRectMake( coord.getX * squareWidth,
                                         currentImage_A.size.height - ( coord.getY + 1 ) * squareHeight,
                                         squareWidth, squareHeight)];
    }
}

#pragma mark - Navigations

/*
 * Can use this method after buttonizeButtonTap to instantiate anything before you segue into the next scene
 *
 * @param segue The name of the segue
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toGI"])
    {
        UINavigationController *navController = [segue destinationViewController];
        
        Swale *swale = navController.viewControllers[0];
        swale.currentImage_S = plainImage2;
        
        PermeablePaver * permeablepaver = navController.viewControllers[1];
        permeablepaver.currentImage_PP = plainImage2;
        permeablepaver.title = @"Permeable Paver";
        
        GreenRoof *greenRoof = navController.viewControllers[2];
        greenRoof.currentImage_GR  = plainImage2;
        
        RainBarrel *rainBarrel = navController.viewControllers[3];
        rainBarrel.currentImage_RB = plainImage2;
        
     }
}

/*
 * This is the method we call when we want to segue to the Take a Picture Scene
 */
-(void)buttonizeButtonTap:(id)sender{
    [self performSegueWithIdentifier:@"toGI" sender:sender];
}

/*
 * The following code presents userImage in scrollView
 */
- (void) updateScrollView:(UIImage *) img {
    
    UIImageView *newView = [[UIImageView alloc] initWithImage:img];
    
    // if there is an image in scrollView it will remove it
    [self.imageView removeFromSuperview];
    
    //handle pinching in/ pinching out to zoom
    newView.userInteractionEnabled = YES;
    newView.backgroundColor = [UIColor clearColor];
    newView.contentMode =  UIViewContentModeCenter;
    
    self.imageView = newView;
    [self.scrollView addSubview:newView];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = self.imageView.bounds.size;
    self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.clipsToBounds = YES;
    self.scrollView.delegate = self;
    //self.scrollView.contentOffset = CGPointMake(-(self.scrollView.bounds.size.width-self.imageView.bounds.size.width)/2, -(self.scrollView.bounds.size.height-self.imageView.bounds.size.height)/2);
    [self.scrollView addSubview:newView];
    //Set image on the scrollview
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

#pragma mark - IBAction
- (IBAction)toCalibrate:(id)sender {
    [self buttonizeButtonTap:self];
}

- (IBAction)watermark:(id)sender {
    
    UIGraphicsBeginImageContext(currentImage_A.size);
    [currentImage_A drawInRect:CGRectMake(0, 0, currentImage_A.size.width, currentImage_A.size.height)];
    
    watermarkButton.selected = !watermarkButton.selected;
    
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [self updateScrollView:result];
}

- (IBAction)addGi:(id)sender {
    UIButton * clickedButton = (UIButton*)sender;
    
    for( UIButton * button in addButtons){
        if( button.tag == clickedButton.tag ){
            button.selected = !button.selected;
            if( button.selected == true )
                pressedButton = button.tag;
            else
                pressedButton = -1;
        }else{
            button.selected = false;
        }
    }
    
    NSLog(@"Pressed button is %i", pressedButton);
}
@end
