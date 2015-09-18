//
//  CSAlwaysOnTopHeader.h
//  socialCalendar
//
//  Created by Yifan Xiao on 7/17/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

@protocol cameraHeaderDelegate <NSObject>

- (void)tapToShowPhotoGallery;

@end


@interface profileHeader : UICollectionViewCell

@property (nonatomic, assign) id<cameraHeaderDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UIImageView *avaratBackImageView;

@property (weak, nonatomic) IBOutlet UIButton *cameraButton;


@end
