//
//  ModalViewController.m
//  Popping
//
//  Created by André Schneider on 16.05.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import "popingViewController.h"
#import "UIColor+CustomColors.h"

@interface popingViewController()
- (void)addDismissButton;
- (void)dismiss:(id)sender;
- (void)addDeleteButton;
- (void)delete:(id)sender;
- (void)addTitleLabel;
- (void)addSubtitleLabel;
@end

@implementation popingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.layer.cornerRadius = 8.f;
    self.view.backgroundColor = [UIColor customBlueColor];
    [self addDismissButton];
    [self addDeleteButton];
    [self addTitleLabel];
    //[self addSubtitleLabel];
}

#pragma mark - Private Instance methods

- (void)addTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Avenir" size:16.0f];
    titleLabel.text = @"Want to delete this event?";
    [self.view addSubview:titleLabel];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0.f]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-20.0-[titleLabel]"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(titleLabel)]];
}

- (void)addSubtitleLabel
{
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
    dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    dismissButton.tintColor = [UIColor whiteColor];
    dismissButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    [dismissButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [dismissButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dismissButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0.f]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:[dismissButton]-20.0-|"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(dismissButton)]];
}

- (void)addDismissButton
{
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
    dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    dismissButton.tintColor = [UIColor whiteColor];
    dismissButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:15.0f];
    [dismissButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [dismissButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissButton];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dismissButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0.f]];

    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:[dismissButton]-20.0-|"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(dismissButton)]];
}

-(void)addDeleteButton{
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
    deleteButton.tintColor = [UIColor whiteColor];
    deleteButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:15.0f];
    [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:deleteButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0.f]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:[deleteButton]-60.0-|"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(deleteButton)]];

}

- (void)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)delete:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate sendDataToSource];
    }];
}

@end
