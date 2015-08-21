//
//  FORMNotepadCell.m
//  SceneDoc
//
//  Created by Kevin Jacob on 2015-08-08.
//  Copyright (c) 2015 SceneDoc Inc. All rights reserved.
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
    if (!self) return nil;
    
    self.thumbnailImageView.image = [UIImage imageNamed:kDefaultCanvasImage];
    
    return self;
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark - Signature Set/Get
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (void)setImage
{
    self.thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageAdded = YES;
    NSString *photoImageFilePath = [self.notepad pathForThumbnail];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:photoImageFilePath];
    
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
    
    if(self.formfield.notepads)
    {
        self.notepad = self.formfield.notepads;
        if(!self.notepad.isComplete)
        {
            SDCThriftGCDManager *GCDManager = [SDCThriftGCDManager sharedInstance];
            [GCDManager getNotepad:self.notepad
                         sceneFile:self.notepad.sceneFile
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