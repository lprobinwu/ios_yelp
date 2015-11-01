//
//  SwitchCell.m
//  Yelp
//
//  Created by Robin Wu on 10/31/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "SwitchCell.h"

@implementation SwitchCell

- (void)awakeFromNib {
    // Initialization code    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchValueChanged:(id)sender {
    [self.delegate switchCell:self didUpdateValue:self.toggleSwitch.on];
}

- (void) setOn:(BOOL)on {
    [self setOn:on animated:NO];
}

- (void) setOn:(BOOL)on animated:(BOOL)animated {
    _on = on;
    [self.toggleSwitch setOn:on animated:animated];
}

@end
