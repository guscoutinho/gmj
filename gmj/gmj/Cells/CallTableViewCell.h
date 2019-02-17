//
//  CallTableViewCell.h
//  gmj
//
//  Created by Gustavo  Coutinho on 2/16/19.
//  Copyright © 2019 Gustavo  Coutinho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *tag1;
@property (weak, nonatomic) IBOutlet UILabel *tag2;

@end
