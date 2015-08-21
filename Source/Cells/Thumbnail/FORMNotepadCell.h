//
//  FORMNotepadCell.h
//  SceneDoc
//
//  Created by Kevin Jacob on 2015-08-08.
//  Copyright (c) 2015 SceneDoc Inc. All rights reserved.
//

#import "FORMThumbnailViewCell.h"


static NSString * const FORMNotepadCellIdentifier = @"FORMNotepadCellIdentifier";


@interface FORMNotepadCell : FORMThumbnailViewCell

@property (nonatomic, strong) Notepad                               *notepad;

@end
