//
//  savedLocations.m
//  Trial_1
//
//  Created by Jamie Auza on 6/24/16.
//  Copyright © 2016 Jamie Auza. All rights reserved.
//

#import "savedLocations.h"
#import "HSVLocation.h"

@implementation savedLocations

#pragma mark Singleton Methods
@synthesize allSavedLocations;

+ (id)sharedSavedLocations {
    static savedLocations *sharedsavedLocations = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedsavedLocations = [[self alloc] init];
    });
    return sharedsavedLocations;
}

- (id)init {
    allSavedLocations = [[NSMutableArray alloc] init];
    if (self = [super init]) {
        // Where we actually intialize the array of HSVLocations from the file
        
        // Opening File savedHsvValues.txt
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"savedHsvValues"];
        fileName = [fileName stringByAppendingPathExtension:@"txt"];
        
        // If file not found, create one
        if(![[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
            NSLog(@"We didn't find the file, so we're creating one");
            [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
            
            // Add Default HSV values to file
            NSString* defaultHSV = @"Default:10 80 50 200 50 255 80 175 140 255 100 255 90 110 40 100 120 225 0 15 30 220 50 210 15 90 35 200 35 130\n";
            
            NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
            [file writeData:[defaultHSV dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        // Get all of the file
        NSString* content = [NSString stringWithContentsOfFile:fileName
                                                      encoding:NSUTF8StringEncoding
                                                         error:NULL];
        
        // Break up by line
        NSMutableArray * savedLines = [content componentsSeparatedByString:@"\n"];
        
        // Each line has format
        //      (string):(int) (int) (int) .....(eol)
        //      (name):(HSV Values seperated by spaces)(\n)
        // Break up and save in HSVLocation object
        for( NSString* line in savedLines){
            if( ![line isEqualToString:@""]){
                NSArray * oneHSV = [line componentsSeparatedByString:@":"];
                NSArray * stringValues = [oneHSV[1] componentsSeparatedByString:@" "];
                
                HSVLocation * HSV;
                HSV = [[HSVLocation alloc] initWithName:oneHSV[0] Values: stringValues];
            
                [allSavedLocations addObject:HSV];
            }
        }
    }
    //[self printAll];
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

- (NSMutableArray*) getHSVForSavedLocationAtIndex:(NSInteger)index Icon:(NSInteger)caseNum{
    NSMutableArray* result = [[NSMutableArray alloc]init];
    result = [[allSavedLocations objectAtIndex: index ] getValuesFromIcon:caseNum];
    return result;
}

- (int) count{
    return [allSavedLocations count];
}

- (NSString*) nameOfObjectAtIndex:(int)index{
    return [[allSavedLocations objectAtIndex:index] getName];
}

- (void) printAll{
    for( HSVLocation * location in allSavedLocations){
        NSLog(@"PRINTING OUT allSavedLocations");
        NSLog(@"NAME: %@ FIRST VALUE: %@", [location getName] , location.getSwaleValues[0]);
    }
}



@end
