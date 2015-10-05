//
// FORMImageViewCell.m
// SceneDoc
//
// Created by Kevin Jacob on 2015-08-08.
// Copyright (c) 2015 SceneDoc Inc. All rights reserved.
//

#import "FORMImageViewCell.h"

#import "CoreDataHelper.h"
#import "SDCThriftGCDManager.h"

#import "UIImage+ImmediateLoad.h"


@interface FORMImageViewCell ()

@end


@implementation FORMImageViewCell


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Set Up
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
    {
        return nil;
    }

    self.thumbnailImageView.image = [UIImage imageNamed:kDefaultPhotoImage];

    return self;
}



- (void)prepareForReuse
{
    self.thumbnailImageView.contentMode = UIViewContentModeCenter;
    self.thumbnailImageView.image = [UIImage imageNamed:kDefaultPhotoImage];
    self.imageAdded = NO;
    self.formfield = nil;
}



// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Signature Set/Get
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)setImage
{
    self.thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageAdded = YES;
    NSString *photoImageFilePath = [self.field.photo pathForPhotoImage];

    if (!self.field.photo.chunkHeader)
    {
        [[CoreDataHelper sharedInstance] findChunkHeader:self.field.photo];
    }

    NSString *tempImageFilePath = [[ChunkManager sharedInstance] readChunkData:photoImageFilePath chunkHeader:self.field.photo.chunkHeader];
    UIImage *image = [UIImage imageScaleAndImmediateLoadWithContentsOfFile:tempImageFilePath];
    if (image)
    {
        self.thumbnailImageView.image = image;
    }

    [SVProgressHUD dismiss];
}



// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - FORMBaseFormFieldCell
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)updateFieldWithDisabled:(BOOL)disabled
{
    self.thumbnailImageView.alpha                   = disabled ? 0.5f : 1.0f;
    self.thumbnailImageView.userInteractionEnabled  = disabled ? NO : YES;
}



- (void)updateWithField:(FORMFields *)field
{
    [super updateWithField:field];

    self.hidden                                     = (field.sectionSeparator);
    self.thumbnailImageView.alpha                   = field.disabled ? 0.5f : 1.0f;
    self.thumbnailImageView.userInteractionEnabled  = field.disabled ? NO : YES;
    self.thumbnailImageView.image = self.thumbnailImageView.image;

    // Needs to check this property first in case of updates from cloud
    if (field.value && self.formfield.photo)
    {
        [SVProgressHUD showWithStatus:@"Downloading Photo..."];

        self.field.photo = self.formfield.photo;
        if (!self.field.photo.isComplete)
        {
            SDCThriftGCDManager *GCDManager = [SDCThriftGCDManager sharedInstance];
            [GCDManager getPhotoDataChunks:self.field.photo
                                forNotepad:NO
                              successBlock:^{
                 [self setImage];
             }
                              failureBlock:nil
            ];
        }
        else
        {
            [self setImage];
        }
    }
    else if (field.value && self.field.photo)
    {
        [self setImage];
    }
    
    [self validate];
}



@end