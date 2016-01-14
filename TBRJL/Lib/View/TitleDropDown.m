//
//  DropDown.m
//  TBRJL
//
//  Created by 程三 on 15/6/27.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "TitleDropDown.h"
#import "UIViewExt.h"
#import "TBRJL-Prefix.pch"

@implementation TitleDropDown

-(id)initWithFrame:(CGRect)frame
{
    if (frame.size.height<200)
    {
        frameHeight = 200;
    }
    else
    {
        frameHeight = frame.size.height;
    }
    tabheight = frameHeight-frame.size.height;
    
    //frame.size.height = 40.0f;
    
    self = [super initWithFrame:frame];
    if(self)
    {
        
        showList = NO; //默认不显示下拉框
        
        textBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        textBtn.backgroundColor = [UIColor lightGrayColor];
        textBtn.frame = CGRectMake(0, 0, 90, frame.size.height);
        [textBtn addTarget:self action:@selector(dropdown) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:textBtn];
        
        
        //添加内容显示框
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.tag = 100;
        textLabel.numberOfLines = 0;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.left = 5;
        textLabel.width = textBtn.width - 30;
        textLabel.top = 0;
        textLabel.height = textBtn.height;
        textLabel.textColor = [UIColor blackColor];
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.tag = 100;
        [textBtn addSubview:textLabel];
        
        //添加下拉图标
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select_compary_icon.png"]];
        icon.frame = CGRectZero;
        icon.left = textLabel.right;
        icon.width = 30;
        icon.height = 30;
        icon.top = (textBtn.height - 20)/2;
        [textBtn addSubview:icon];
        
        
        
        //---------------------下拉标题-----------------
        tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 40.0f, frame.size.width, 0)];
        tv.delegate = self;
        tv.dataSource = self;
        tv.backgroundColor = [UIColor grayColor];
        tv.separatorColor = [UIColor lightGrayColor];
        tv.hidden = YES;
        [self addSubview:tv];
        
        //用于设置分割线显示完全
        if ([tv respondsToSelector:@selector(setSeparatorInset:)]) {
            
            [tv setSeparatorInset:UIEdgeInsetsZero];
            
        }
        
        if ([tv respondsToSelector:@selector(setLayoutMargins:)]) {
            
            [tv setLayoutMargins:UIEdgeInsetsZero];
            
        }
        
        
        //--------------------输入的内容------------------
        contentTextView = [[UITextField alloc] initWithFrame:CGRectZero];
        contentTextView.font = [UIFont systemFontOfSize:14];
        contentTextView.delegate = self;
        contentTextView.backgroundColor = [UIColor whiteColor];
        contentTextView.textColor = [UIColor blackColor];
        contentTextView.left = textBtn.right;
        contentTextView.width = frame.size.width - 90;
        contentTextView.top = 0;
        contentTextView.height = 40;
        contentTextView.textAlignment = NSTextAlignmentCenter;
        self.contentTextView = contentTextView;
        [self addSubview:contentTextView];
    }
    
    return self;
}

-(void)dropdown
{
    if(tableArray == nil || tableArray.count == 0)
    {
        return;
    }
    if (showList)
    {
        showList = NO;
        tv.hidden = YES;
        
        CGRect sf = self.frame;
        sf.size.height = 40;
        self.frame = sf;
        CGRect frame = tv.frame;
        frame.size.height = 0;
        tv.frame = frame;
    }
    else
    {
        //如果下拉框尚未显示，则进行显示
        CGRect sf = self.frame;
        sf.size.height = frameHeight;
        
        //把dropdownList放到前面，防止下拉框被别的控件遮住
        [self.superview bringSubviewToFront:self];
        tv.hidden = NO;
        showList = YES;//显示下拉框
        
        CGRect frame = tv.frame;
        frame.size.height = 0;
        tv.frame = frame;
        frame.size.height = tabheight;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.frame = sf;
        tv.frame = frame;
        [UIView commitAnimations];
        
    }
}

//设置被选中的下标值
-(void)setSelectIndex:(int)index
{
    if(index < 0 || tableArray == nil || tableArray.count <= index)
    {
        return;
    }
    
    NSString *string = (NSString *)[tableArray objectAtIndex:index];
    if(string != nil)
    {
        if(textBtn != nil)
        {
            UILabel *label = (UILabel *)[textBtn viewWithTag:100];
            label.text = string;
        }
    }
}

//设置数据
-(void)setTableArray:(NSArray *)array
{
    if(textBtn != nil)
    {
        UILabel *label = (UILabel *)[textBtn viewWithTag:100];
        label.text = nil;
    }
    
    tableArray = array;
    if(tv != nil)
    {
        [tv reloadData];
    }
}

#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //设置cell没有选中效果
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
        label.tag = 100;
        label.backgroundColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        [cell.contentView addSubview:label];
    }
    
    /*
    cell.textLabel.text = [_tableArray objectAtIndex:[indexPath row]];
    cell.textLabel.backgroundColor = [UIColor redColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    */
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    if(nil != label)
    {
        label.text = [NSString stringWithFormat:@"  %@",[tableArray objectAtIndex:[indexPath row]]];
    }
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *textLabel = (UILabel *)[textBtn viewWithTag:100];
    if(textLabel != nil)
    {
        textLabel.text = [tableArray objectAtIndex:[indexPath row]];
    }
    showList = NO;
    tv.hidden = YES;
    
    CGRect sf = self.frame;
    sf.size.height = 40;
    self.frame = sf;
    CGRect frame = tv.frame;
    frame.size.height = 0;
    tv.frame = frame;
    
    if(_dropDownDelagate != nil)
    {
        [_dropDownDelagate titleDropDownDidSelected:self index:indexPath.row];
    }
}

//该方法用于显示完全的分割线
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//获取输入的内容
-(NSString *)getTextFieldContent
{
    if(nil == contentTextView)
    {
        return nil;
    }
    return contentTextView.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}
@end
