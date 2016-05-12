//
//  takeAPicture.m
//  Trial_1
//
//  Created by Jamie Auza on 4/28/16.
//  Copyright © 2016 Jamie Auza. All rights reserved.
//

#import "takeAPicture.h"

@interface takeAPicture()
@end

@implementation takeAPicture

@synthesize sendButton = _sendButton;

- (void) viewDidLoad {
    NSLog(@"Hello World");
}

- (IBAction)sendTapped:(UIButton *)sender {
    NSLog(@"Tapped");
    _sendButton.titleLabel.text = @"hello";
}

@end
