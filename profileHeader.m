//
//  CSAlwaysOnTopHeader.m
//  socialCalendar
//
//  Created by Yifan Xiao on 7/17/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

#import "profileHeader.h"
#import "CSStickyHeaderFlowLayoutAttributes.h"

@implementation profileHeader

- (void)applyLayoutAttributes:(CSStickyHeaderFlowLayoutAttributes *)layoutAttributes {

    [UIView beginAnimations:@"" context:nil];

    self.titleLabel.text = [PFUser currentUser].username;
    self.NameLabel.text = [PFUser currentUser].username;
    
    if (layoutAttributes.progressiveness <= 0.58) {
        self.titleLabel.alpha = 1;
    } else {
        self.titleLabel.alpha = 0;
    }

    [UIView commitAnimations];
}

- (IBAction)cameraButtonTapped:(id)sender {

    [self.delegate tapToShowPhotoGallery];

}


@end
