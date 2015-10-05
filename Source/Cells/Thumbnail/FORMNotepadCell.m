//
// FORMNotepadCell.m
// SceneDoc
//
// Created by Kevin Jacob on 2015-08-08.
// Copyright (c) 2015 SceneDoc Inc. All rights reserved.
//

#import "FORMNotepadCell.h"

#import "CoreDataHelper.h"
#import "SDCThriftGCDManager.h"

#import "UIImage+ImmediateLoad.h"


@implementation FORMNotepadCell


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

    self.thumbnailImageView.image = [UIImage imageNamed:kDefaultCanvasImage];

    return self;
}



- (void)prepareForReuse
{
    self.thumbnailImageView.contentMode = UIViewContentModeCenter;
    self.thumbnailImageView.image = [UIImage imageNamed:kDefaultCanvasImage];
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
    NSString *photoImageFilePath = [self.field.notepad pathForThumbnail];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:photoImageFilePath];

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

    // Needs to check this property first in case of updates from cloud
    if (field.value && self.formfield.notepad)
    {
        [SVProgressHUD showWithStatus:@"Downloading Notepad..."];

        self.field.notepad = self.formfield.notepad;
        if (!self.field.notepad.isComplete)
        {
            SDCThriftGCDManager *GCDManager = [SDCThriftGCDManager sharedInstance];
            [GCDManager getNotepad:self.field.notepad
                         sceneFile:self.field.notepad.sceneFile
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
    else if (field.value && self.field.notepad)
    {
        [self setImage];
    }
    
    [self validate];
}



@end