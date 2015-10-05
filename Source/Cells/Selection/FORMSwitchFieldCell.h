//
// FORMSwitchFieldCell.h
// SceneDoc
//
// Created by Kevin Jacob on 2015-09-02.
// Copyright (c) 2015 SceneDoc Inc. All rights reserved.
//

#import "FORMBaseFieldCell.h"

static NSString *const FORMSwitchFieldCellIdentifier = @"FORMSwitchFieldCellIdentifier";

@interface FORMSwitchFieldCell : FORMBaseFieldCell


@property (nonatomic, strong) UISwitch          *switchButton;
@property (nonatomic, strong) UILabel           *subLabel;


@end