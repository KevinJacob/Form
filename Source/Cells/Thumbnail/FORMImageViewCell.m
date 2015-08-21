//
//  FORMImageViewCell.m
//  SceneDoc
//
//  Created by Kevin Jacob on 2015-08-08.
//  Copyright (c) 2015 SceneDoc Inc. All rights reserved.
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
    if (!self) return nil;
    
    self.thumbnailImageView.image = [UIImage imageNamed:kDefaultPhotoImage];
    
    return self;
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Signature Set/Get
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)setImage
{
    self.thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageAdded = YES;
    NSString *photoImageFilePath = [self.photo pathForPhotoImage];
    
    if (!self.photo.chunkHeader)
    {
        [[CoreDataHelper sharedInstance] findChunkHeader:self.photo];
    }
    
    NSString *tempImageFilePath = [[ChunkManager sharedInstance] readChunkData:photoImageFilePath chunkHeader:self.photo.chunkHeader];
    UIImage *image = [UIImage imageScaleAndImmediateLoadWithContentsOfFile:tempImageFilePath];
    if (image)
    {
        self.thumbnailImageView.image = image;
    }
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - FORMBaseFormFieldCell
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)updateFieldWithDisabled:(BOOL)disabled
{
    self.alpha                                      = disabled ? 0.5f : 1.0f;
    self.thumbnailImageView.userInteractionEnabled  = disabled ? NO : YES;
}



- (void)updateWithField:(FORMFields *)field
{
    [super updateWithField:field];
    
    self.hidden                                     = (field.sectionSeparator);
    self.alpha                                      = field.disabled ? 0.5f : 1.0f;
    self.thumbnailImageView.userInteractionEnabled  = field.disabled ? NO : YES;
    
    if(self.formfield.photos)
    {
        self.photo = self.formfield.photos;
        if(!self.photo.isComplete)
        {
            SDCThriftGCDManager *GCDManager = [SDCThriftGCDManager sharedInstance];
            [GCDManager getPhotoDataChunks:self.photo
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
}


@end