//
//  BaoDanCell.m
//  TBRJL
//
//  Created by Charls on 15/12/10.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "BaoDanCell.h"
#import "PublicClass.h"
@interface BaoDanCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;


@end
@implementation BaoDanCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.titleLabel.textColor = [PublicClass colorWithHexString:@"#04a3fe"];

}

+(instancetype)cellForTableView:(UITableView *)tableView{
 
    BaoDanCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"BaoDanCell" owner:self options:nil]lastObject];
    
    return cell;
}


//    赋值
-(void)setModel:(BaoDanModel *)model{
    _model = model;
    if ([model.title isEqualToString:@"补拍原因"] || [model.title isEqualToString:@"补录原因"]) {
        self.detailLabel.textColor = [UIColor redColor];
    }
    self.titleLabel.text = model.title;
    self.detailLabel.text = model.result;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
