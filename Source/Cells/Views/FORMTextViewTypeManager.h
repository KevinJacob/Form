//
//  FORMTextViewTypeManager.h
//  SceneDoc
//
//  Created by Kevin Jacob on 2015-07-22.
//  Copyright (c) 2015 SceneDoc Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FORMTextView.h"

@interface FORMTextViewTypeManager : NSObject

- (void)setUpType:(FORMTextViewInputType)type forTextView:(UITextView *)textView;

@end
