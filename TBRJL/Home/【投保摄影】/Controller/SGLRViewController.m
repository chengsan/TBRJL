//
//  SGLRViewController.m
//  TBRJL
//
//  Created by 程三 on 15/7/26.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "SGLRViewController.h"
#import "TitleDropDown.h"
@interface SGLRViewController()
@property (nonatomic ,strong) UIButton *yesBtn;

@property (nonatomic ,strong) UIButton *noBtn;

@property (nonatomic ,strong) UIButton *nanBtn;

@property (nonatomic ,strong) UIButton *nvBtn;

@property (nonatomic ,strong) UIView *safepnameView;


@end

@implementation SGLRViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"手工录入";
    self.view.backgroundColor = [UIColor whiteColor];
    [self _initView];
    //类型：0 新建／1:缓存／2:补拍／3:补录  填充数据
    if(currentType == 1 || currentType == 2 || currentType == 3)
    {
        [self setData];
    }
}

-(void)_initView
{
    int nextHeight = 60;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scrollView.top = 0;
    scrollView.left = 0;
    scrollView.width = ScreenWidth;
    //该60为底部按钮的高度
    scrollView.height = ScreenHeight - 20 - 44 - nextHeight;
    scrollView.scrollEnabled = YES;
    scrollView.backgroundColor = RGB(235, 235, 241);
    [self.view addSubview:scrollView];
    
    //UIScrollView里面内容的总高度
    int totalHeight = 0;
    //标题统一的宽度和高度
    int width = 90;
    int height = 40;
    
    //--------------是否为同一个人---------------
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectZero];
    titleView.top = 0;
    titleView.left = 0;
    titleView.width = ScreenWidth;
    titleView.height = height * 2;
    [scrollView addSubview:titleView];
    totalHeight += titleView.height;
    
    UILabel *onePersonTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, titleView.height)];
    onePersonTitle.font = [UIFont systemFontOfSize:14];
    onePersonTitle.backgroundColor = [UIColor lightGrayColor];
    onePersonTitle.textColor = [UIColor blackColor];
    onePersonTitle.text = @"投保人和被保险人是否为同一人";
    onePersonTitle.textAlignment = NSTextAlignmentCenter;
    onePersonTitle.numberOfLines = 0;
    [titleView addSubview:onePersonTitle];
    
    UIView *onePersonView = [[UIView alloc] initWithFrame:CGRectMake(onePersonTitle.right, 0, ScreenWidth - width, titleView.height)];
    onePersonView.backgroundColor = [UIColor whiteColor];
    [titleView addSubview:onePersonView];
    
    self.yesBtn = [[UIButton alloc] initWithFrame:CGRectMake(onePersonTitle.right + 40, (titleView.height - 40)/2, 60,  40)];
    self.yesBtn.tag = 1000;
    [self setupBtn:self.yesBtn WithTitle:@"是"];
    [titleView addSubview:self.yesBtn];
  
    self.noBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.yesBtn.right+40, (titleView.height - 40)/2, 60,40)];
    self.noBtn.tag = 1001;
    [self setupBtn:self.noBtn WithTitle:@"否"];
    self.noBtn.selected = YES;
    [titleView addSubview:self.noBtn];
    
    NSString *sname = (NSString *)[safeInfo objectForKey:@"sname"];
    NSString *pname = (NSString *)[safeInfo objectForKey:@"pname"];
    NSString *cardno = (NSString *)[safeInfo objectForKey:@"cardno"];
    NSString *pcardno = (NSString *)[safeInfo objectForKey:@"pcardno"];
  
    
    
    
    //---------------流水号---------------
    UIView *safenoView = [[UIView alloc] initWithFrame:CGRectMake(0, titleView.bottom + 1, ScreenWidth, height)];
    [scrollView addSubview:safenoView];
    totalHeight += safenoView.height;
    
    UILabel *safenoTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    safenoTitle.font = [UIFont systemFontOfSize:14];
    safenoTitle.backgroundColor = [UIColor lightGrayColor];
    safenoTitle.textColor = [UIColor blackColor];
    safenoTitle.text = @"业务流水号";
    safenoTitle.textAlignment = NSTextAlignmentCenter;
    [safenoView addSubview:safenoTitle];

    
    safenoTextView = [[UITextField alloc] initWithFrame:CGRectMake(safenoTitle.right, 0, ScreenWidth - width, height)];
    //设置提示占位符
    //[safenoTextView setPlaceholder:@"占位符"];
    safenoTextView.delegate = self;
    safenoTextView.textAlignment = NSTextAlignmentCenter;
    safenoTextView.textColor = [UIColor blackColor];
    safenoTextView.font = [UIFont systemFontOfSize:14];
    safenoTextView.backgroundColor = [UIColor whiteColor];
    safenoTextView.keyboardType = UIKeyboardTypeNumberPad;
    safenoTextView.text = (NSString *)[safeInfo objectForKey:@"safeno"];
    [safenoView addSubview:safenoTextView];
    
    //-------------------险种-----------------
    UIView *safetypeView = [[UIView alloc] initWithFrame:CGRectMake(0, safenoView.bottom + 1, ScreenWidth, height)];
    [scrollView addSubview:safetypeView];
    totalHeight += safetypeView.height;
    
    UILabel *safetypeTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    safetypeTitle.font = [UIFont systemFontOfSize:14];
    safetypeTitle.backgroundColor = [UIColor lightGrayColor];
    safetypeTitle.textColor = [UIColor blackColor];
    safetypeTitle.text = @"险种";
    safetypeTitle.textAlignment = NSTextAlignmentCenter;
    [safetypeView addSubview:safetypeTitle];
    
    UILabel *safetypeContent = [[UILabel alloc] initWithFrame:CGRectMake(safetypeTitle.right, 0, ScreenWidth - width, height)];
    safetypeContent.font = [UIFont systemFontOfSize:14];
    safetypeContent.backgroundColor = [UIColor whiteColor];
    safetypeContent.textColor = [UIColor blackColor];
    safetypeContent.textAlignment = NSTextAlignmentCenter;
    [safetypeView addSubview:safetypeContent];
    
    
    //不管是新建还是其他的，险种类型都要设置
    NSString *txt = nil;
    NSString *psafetypes = (NSString *)[safeInfo objectForKey:@"psafetypes"];
    if([@"001" isEqualToString:psafetypes])
    {
        txt = @"普通寿险";
    }
    else if ([@"002" isEqualToString:psafetypes])
    {
        txt = @"分红型寿险";
    }
    else if ([@"003" isEqualToString:psafetypes])
    {
        txt = @"投资连结保险";
    }
    else if ([@"004" isEqualToString:psafetypes])
    {
        txt = @"健康保险";
    }
    else if ([@"005" isEqualToString:psafetypes])
    {
        txt = @"万能保险";
    }
    else if ([@"006" isEqualToString:psafetypes])
    {
        txt = @"意外伤害保险";
    }
    else if ([@"101" isEqualToString:psafetypes])
    {
        txt = @"车险";
    }
    else if ([@"102" isEqualToString:psafetypes])
    {
        txt = @"家财险";
    }
    else if ([@"103" isEqualToString:psafetypes])
    {
        txt =@"责任险";
    }
    else if ([@"104" isEqualToString:psafetypes])
    {
        txt = @"意外险";
    }
    else
    {
        txt = @"";
    }
    if(txt != nil && ![@"" isEqualToString:txt])
    {
        safetypeContent.text = txt;
        
    }
    txt = nil;
    
    //--------------------投保人姓名----------------
    UIView *safenameView = [[UIView alloc] initWithFrame:CGRectMake(0, safetypeView.bottom + 1, ScreenWidth, height)];
    [scrollView addSubview:safenameView];
    totalHeight += safenameView.height;
    
    UILabel *safenameTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    safenameTitle.font = [UIFont systemFontOfSize:14];
    safenameTitle.backgroundColor = [UIColor lightGrayColor];
    safenameTitle.textColor = [UIColor blackColor];
    safenameTitle.text = @"投保人姓名";
    safenameTitle.textAlignment = NSTextAlignmentCenter;
    [safenameView addSubview:safenameTitle];
    
    safenameTextView = [[UITextField alloc] initWithFrame:CGRectMake(safenameTitle.right, 0, ScreenWidth - width, height)];
    safenameTextView.delegate = self;
    safenameTextView.textAlignment = NSTextAlignmentCenter;
    safenameTextView.textColor = [UIColor blackColor];
    safenameTextView.font = [UIFont systemFontOfSize:14];
    safenameTextView.backgroundColor = [UIColor whiteColor];
//    safenameTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    safenameTextView.text = sname;
    [safenameView addSubview:safenameTextView];

    //--------------------投保人证件类型----------------
    titleDropDown = [[TitleDropDown alloc] initWithFrame:CGRectMake(0, safenameView.bottom + 1, ScreenWidth, height)];
    titleDropDown.dropDownDelagate = self;
    titleDropDown.contentTextView.keyboardType = UIKeyboardTypeNumberPad;
    titleDropDown.contentTextView.text = cardno;
    NSMutableArray *cardtypeArray = [[NSMutableArray alloc] init];
    [cardtypeArray addObject:@"投保人身份证"];
    [cardtypeArray addObject:@"投保人护照"];
    [cardtypeArray addObject:@"投保人军官证"];
    [cardtypeArray addObject:@"投保人其他证件"];
    [titleDropDown setTableArray:cardtypeArray];
    //设置默认值
  
    [titleDropDown setSelectIndex:0];
     safeType = (NSString *)[safeInfo objectForKey:@"cardtype"];
    if (safeType == NULL) {
        safeType = @"01";
    }
    
    [scrollView addSubview:titleDropDown];
    totalHeight += titleDropDown.height;
    
    
    
    //-----------------------被保险人姓名-------------------
    _safepnameView = [[UIView alloc] initWithFrame:CGRectMake(0, titleDropDown.bottom + 1, ScreenWidth, height)];
    [scrollView addSubview:_safepnameView];
    totalHeight += _safepnameView.height;
    
    UILabel *safepnameTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    safepnameTitle.font = [UIFont systemFontOfSize:14];
    safepnameTitle.backgroundColor = [UIColor lightGrayColor];
    safepnameTitle.textColor = [UIColor blackColor];
    safepnameTitle.text = @"被保险人姓名";
    safepnameTitle.textAlignment = NSTextAlignmentCenter;
    [_safepnameView addSubview:safepnameTitle];
    
    safepnameTextView = [[UITextField alloc] initWithFrame:CGRectMake(safepnameTitle.right, 0, ScreenWidth - width, height)];
    safepnameTextView.delegate = self;
    safepnameTextView.textAlignment = NSTextAlignmentCenter;
    safepnameTextView.textColor = [UIColor blackColor];
    safepnameTextView.font = [UIFont systemFontOfSize:14];
    safepnameTextView.backgroundColor = [UIColor whiteColor];
//    safepnameTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    safepnameTextView.text = pname;
    [_safepnameView addSubview:safepnameTextView];
    
    //----------------------被保险人证件类型-----------------------
    safepnameDropDown = [[TitleDropDown alloc] initWithFrame:CGRectMake(0, _safepnameView.bottom + 1, ScreenWidth, height)];
    safepnameDropDown.dropDownDelagate = self;
    safepnameDropDown.contentTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    safepnameDropDown.contentTextView.text = pcardno;
    NSMutableArray *pcardtypeArray = [[NSMutableArray alloc] init];
    [pcardtypeArray addObject:@"被保险人身份证"];
    [pcardtypeArray addObject:@"被保险人护照"];
    [pcardtypeArray addObject:@"被保险人军官证"];
    [pcardtypeArray addObject:@"被保险人其他证件"];
    [safepnameDropDown setTableArray:pcardtypeArray];
    //设置默认值
    [safepnameDropDown setSelectIndex:0];
    
    psafeType = (NSString *)[safeInfo objectForKey:@"pcardtype"];
    if (psafeType == NULL) {
        psafeType = @"01";
    }
    
    [scrollView addSubview:safepnameDropDown];
    totalHeight += safepnameDropDown.height;
    
    //-----------------------保费-------------------
    UIView *safepayView = [[UIView alloc] initWithFrame:CGRectMake(0, safepnameDropDown.bottom + 1, ScreenWidth, height)];
    [scrollView addSubview:safepayView];
    totalHeight += safepayView.height;
    
    UILabel *safepayTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    safepayTitle.font = [UIFont systemFontOfSize:14];
    safepayTitle.backgroundColor = [UIColor lightGrayColor];
    safepayTitle.textColor = [UIColor blackColor];
    safepayTitle.text = @"保费";
    safepayTitle.textAlignment = NSTextAlignmentCenter;
    [safepayView addSubview:safepayTitle];
    
    safepayTextView = [[UITextField alloc] initWithFrame:CGRectMake(safepayTitle.right, 0, ScreenWidth - width, height)];
    safepayTextView.delegate = self;
    safepayTextView.textAlignment = NSTextAlignmentCenter;
    safepayTextView.textColor = [UIColor blackColor];
    safepayTextView.font = [UIFont systemFontOfSize:14];
    safepayTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    safepayTextView.backgroundColor = [UIColor whiteColor];

    safepayTextView.text = (NSString *)[safeInfo objectForKey:@"safecost"];
    [safepayView addSubview:safepayTextView];
    
    //-----------------------保额-------------------
    UIView *safecostView = [[UIView alloc] initWithFrame:CGRectMake(0, safepayView.bottom + 1, ScreenWidth, height)];
    [scrollView addSubview:safecostView];
    totalHeight += safecostView.height;
    
    UILabel *safecostTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    safecostTitle.font = [UIFont systemFontOfSize:14];
    safecostTitle.backgroundColor = [UIColor lightGrayColor];
    safecostTitle.textColor = [UIColor blackColor];
    safecostTitle.text = @"保额";
    safecostTitle.textAlignment = NSTextAlignmentCenter;
    [safecostView addSubview:safecostTitle];
    
    safecostTextView = [[UITextField alloc] initWithFrame:CGRectMake(safecostTitle.right, 0, ScreenWidth - width, height)];
    safecostTextView.delegate = self;
    safecostTextView.textAlignment = NSTextAlignmentCenter;
    safecostTextView.textColor = [UIColor blackColor];
    safecostTextView.font = [UIFont systemFontOfSize:14];
    safecostTextView.backgroundColor = [UIColor whiteColor];
    safecostTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    safecostTextView.text = (NSString *)[safeInfo objectForKey:@"psafepay"];
    [safecostView addSubview:safecostTextView];

    
    //------------------保险起期-----------------------
    UIView *starttimeView = [[UIView alloc] initWithFrame:CGRectMake(0, safecostView.bottom + 1, ScreenWidth, height)];
    starttimeView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:starttimeView];
    totalHeight += starttimeView.height;
    
    UILabel *starttimeTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    starttimeTitle.font = [UIFont systemFontOfSize:14];
    starttimeTitle.backgroundColor = [UIColor lightGrayColor];
    starttimeTitle.textColor = [UIColor blackColor];
    starttimeTitle.text = @"保险起期";
    starttimeTitle.textAlignment = NSTextAlignmentCenter;
    [starttimeView addSubview:starttimeTitle];
    
    starttimeTextView = [[UITextField alloc] initWithFrame:CGRectMake(safecostTitle.right, 0, ScreenWidth - width - 50, height)];
    starttimeTextView.delegate = self;
    starttimeTextView.textAlignment = NSTextAlignmentCenter;
    starttimeTextView.textColor = [UIColor blackColor];
    starttimeTextView.font = [UIFont systemFontOfSize:14];
    starttimeTextView.backgroundColor = [UIColor whiteColor];
    starttimeTextView.enabled = false;
    starttimeTextView.text = (NSString *)[safeInfo objectForKey:@"psafedate"];
    [starttimeView addSubview:starttimeTextView];
    
    UIButton *starttimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    starttimeBtn.tag = 100;
    starttimeBtn.frame = CGRectMake(starttimeTextView.right + (50 - 40)/2, (height - 40)/2, 40, 40);
    [starttimeBtn setImage:[UIImage imageNamed:@"mainpage_create_calendar.png"] forState:UIControlStateNormal];
    [starttimeBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [starttimeView addSubview:starttimeBtn];
    
    //------------------保险止期-----------------------
    UIView *endtimeView = [[UIView alloc] initWithFrame:CGRectMake(0, starttimeView.bottom + 1, ScreenWidth, height)];
    endtimeView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:endtimeView];
    totalHeight += endtimeView.height;
    
    NSString *companytype = (NSString *)[safeInfo objectForKey:@"companytype"];
    NSString *text = nil;
    if ([companytype isEqualToString:@"1"]) {     // 财险
        text = @"保险止期";
    }else{        //  寿险
        text = @"保险期间";
    }
    UILabel *endtimeTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    endtimeTitle.font = [UIFont systemFontOfSize:14];
    endtimeTitle.backgroundColor = [UIColor lightGrayColor];
    endtimeTitle.textColor = [UIColor blackColor];
    endtimeTitle.text = text;
    endtimeTitle.textAlignment = NSTextAlignmentCenter;
    [endtimeView addSubview:endtimeTitle];
    
    endtimeTextView = [[UITextField alloc] initWithFrame:CGRectMake(safecostTitle.right, 0, ScreenWidth - width-50 , height)];
    endtimeTextView.delegate = self;
    endtimeTextView.textAlignment = NSTextAlignmentCenter;
    endtimeTextView.textColor = [UIColor blackColor];
    endtimeTextView.font = [UIFont systemFontOfSize:14];
    endtimeTextView.backgroundColor = [UIColor whiteColor];
    endtimeTextView.enabled = false;
    endtimeTextView.text = (NSString *)[safeInfo objectForKey:@"psafedateend"];
    endtimeTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [endtimeView addSubview:endtimeTextView];
    
    
    
    UIButton *endtimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    endtimeBtn.tag = 101;
    endtimeBtn.backgroundColor = [UIColor whiteColor];
    endtimeBtn.frame = CGRectMake(endtimeTextView.right + (50 - 40)/2, (height - 40)/2, 40, 40);
    [endtimeBtn setImage:[UIImage imageNamed:@"mainpage_create_calendar.png"] forState:UIControlStateNormal];
    [endtimeBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [endtimeView addSubview:endtimeBtn];
    
    if ([companytype isEqualToString:@"1"]) {     // 财险
        endtimeBtn.hidden = NO;
        endtimeTextView.enabled = NO;
    }else{        //  寿险
        endtimeBtn.hidden = YES;
        endtimeTextView.enabled = YES;
        
    }
    
    //判断是否是车险，如果是就加上车牌号和车架号
//    NSString *psafetypes = (NSString *)[safeInfo objectForKey:@"psafetypes"];
    
    NSLog(@"----%@",psafetypes);
    if([@"101" isEqualToString:psafetypes])
    {
        //---------------------车牌号------------------------
        UIView *pcarnoView = [[UIView alloc] initWithFrame:CGRectMake(0, endtimeView.bottom + 1, ScreenWidth, height)];
        [scrollView addSubview:pcarnoView];
        totalHeight += pcarnoView.height;
        
        UILabel *pcarnoTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        pcarnoTitle.font = [UIFont systemFontOfSize:14];
        pcarnoTitle.backgroundColor = [UIColor lightGrayColor];
        pcarnoTitle.textColor = [UIColor blackColor];
        pcarnoTitle.text = @"车牌号";
        pcarnoTitle.textAlignment = NSTextAlignmentCenter;
        [pcarnoView addSubview:pcarnoTitle];
        
        pcarnoTextView = [[UITextField alloc] initWithFrame:CGRectMake(safecostTitle.right, 0, ScreenWidth - width, height)];
        pcarnoTextView.delegate = self;
        pcarnoTextView.textAlignment = NSTextAlignmentCenter;
        pcarnoTextView.textColor = [UIColor blackColor];
        pcarnoTextView.font = [UIFont systemFontOfSize:14];
        pcarnoTextView.backgroundColor = [UIColor whiteColor];
//        pcarnoTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        pcarnoTextView.text = (NSString *)[safeInfo objectForKey:@"pcarno"];
        [pcarnoView addSubview:pcarnoTextView];
        
        //---------------------车架号------------------------
        UIView *carpwinView = [[UIView alloc] initWithFrame:CGRectMake(0, pcarnoView.bottom + 1, ScreenWidth, height)];
        [scrollView addSubview:carpwinView];
        totalHeight += carpwinView.height;
        
        UILabel *carpwinTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        carpwinTitle.font = [UIFont systemFontOfSize:14];
        carpwinTitle.backgroundColor = [UIColor lightGrayColor];
        carpwinTitle.textColor = [UIColor blackColor];
        carpwinTitle.text = @"车架号";
        carpwinTitle.textAlignment = NSTextAlignmentCenter;
        [carpwinView addSubview:carpwinTitle];
        
        carpwinTextView = [[UITextField alloc] initWithFrame:CGRectMake(safecostTitle.right, 0, ScreenWidth - width, height)];
        carpwinTextView.delegate = self;
        carpwinTextView.textAlignment = NSTextAlignmentCenter;
        carpwinTextView.textColor = [UIColor blackColor];
        carpwinTextView.font = [UIFont systemFontOfSize:14];
        carpwinTextView.backgroundColor = [UIColor whiteColor];
//        carpwinTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        carpwinTextView.text = (NSString *)[safeInfo objectForKey:@"pwin"];
        [carpwinView addSubview:carpwinTextView];
    }
    else if([@"001" isEqualToString:psafetypes] ||
            [@"002" isEqualToString:psafetypes] ||
            [@"003" isEqualToString:psafetypes] ||
            [@"004" isEqualToString:psafetypes] ||
            [@"005" isEqualToString:psafetypes] ||
            [@"006" isEqualToString:psafetypes])
    {
        //---------------------性别------------------------
        UIView *sexView = [[UIView alloc] initWithFrame:CGRectMake(0, endtimeView.bottom + 1, ScreenWidth, height)];
        [scrollView addSubview:sexView];
        totalHeight += sexView.height;
        
        UILabel *sexTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        sexTitle.font = [UIFont systemFontOfSize:14];
        sexTitle.backgroundColor = [UIColor lightGrayColor];
        sexTitle.textColor = [UIColor blackColor];
        sexTitle.text = @"投保人性别";
        sexTitle.textAlignment = NSTextAlignmentCenter;
        [sexView addSubview:sexTitle];
        
        UIView *sexBtnView = [[UIView alloc] initWithFrame:CGRectMake(safecostTitle.right, 0, ScreenWidth - width, height)];
        sexBtnView.backgroundColor = [UIColor whiteColor];
        [sexView addSubview:sexBtnView];
        
        UIButton *nanBtn = [[UIButton alloc] initWithFrame:CGRectMake(safecostTitle.right + 40, 0, 60,  height)];
        nanBtn.tag = 1002;
        nanBtn.selected = YES;
        [self setupBtn:nanBtn WithTitle:@"男"];
        [sexView addSubview:nanBtn];
        self.nanBtn = nanBtn;
        
        
        UIButton *nvBtn = [[UIButton alloc] initWithFrame:CGRectMake(nanBtn.right+40,0, 60 ,height)];
        nvBtn.tag = 1003;
        [self setupBtn:nvBtn WithTitle:@"女"];
        [sexView addSubview:nvBtn];
        self.nvBtn = nvBtn;
        
        NSString *sex = (NSString *)[safeInfo objectForKey:@"sex"];
        if ([sex isEqualToString:@"0"]) {
            nvBtn.selected = YES;
            nanBtn.selected = NO;
            
        }else{
            nanBtn.selected = YES;
            nvBtn.selected = NO;
        }
        
        

        //---------------------年龄------------------------
        UIView *ageView = [[UIView alloc] initWithFrame:CGRectMake(0, sexView.bottom + 1, ScreenWidth, height)];
        [scrollView addSubview:ageView];
        totalHeight += ageView.height;
        
        UILabel *ageTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        ageTitle.font = [UIFont systemFontOfSize:14];
        ageTitle.backgroundColor = [UIColor lightGrayColor];
        ageTitle.textColor = [UIColor blackColor];
        ageTitle.text = @"投保人年龄";
        ageTitle.textAlignment = NSTextAlignmentCenter;
        [ageView addSubview:ageTitle];
        
        ageTextView = [[UITextField alloc] initWithFrame:CGRectMake(safecostTitle.right, 0, ScreenWidth - width, height)];
        ageTextView.delegate = self;
        ageTextView.textAlignment = NSTextAlignmentCenter;
        ageTextView.textColor = [UIColor blackColor];
        ageTextView.font = [UIFont systemFontOfSize:14];
        ageTextView.backgroundColor = [UIColor whiteColor];
        ageTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        ageTextView.text = (NSString *)[safeInfo objectForKey:@"age"];
        [ageView addSubview:ageTextView];
    }
    
    
    if ([sname isEqualToString:pname] && [cardno isEqualToString:pcardno]) {
        self.yesBtn.selected = YES;
        self.noBtn.selected = NO;
        _safepnameView.userInteractionEnabled = NO;
        safepnameDropDown.userInteractionEnabled = NO;
        safepnameTextView.backgroundColor = RGB(210, 210, 210);
        safepnameDropDown.contentTextView.backgroundColor = RGB(210, 210, 210);
    }else{
        self.noBtn.selected = YES;
        self.yesBtn.selected = NO;
    }

    //--------------------下一步按钮-----------------
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectZero];
    btnView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
    btnView.top = ScreenHeight - 44 - 20 - nextHeight;
    btnView.left = 0;
    btnView.width = ScreenWidth;
    btnView.height = nextHeight;
    [self.view addSubview:btnView];
    
    
 
    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.tag = 111;
    nextBtn.frame = CGRectZero;
    nextBtn.width = 200;
    nextBtn.height = 40;
    nextBtn.left = (btnView.width - nextBtn.width)/2;
    nextBtn.top = (btnView.height - nextBtn.height)/2;
    
    UIImage *img = [UIImage imageNamed:@"login_submit_normal.png"];
    img = [img stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [nextBtn setBackgroundImage:img forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:nextBtn];
    
    scrollView.contentSize = CGSizeMake(ScreenWidth, totalHeight);
    
    
//    补录无照片数据
    if (currentType == 3 && photoArray == nil) {
        [nextBtn setTitle:@"发送" forState:UIControlStateNormal];
    }
}

//填充数据
-(void)setData
{
 NSString *cardtype = (NSString *)[safeInfo objectForKey:@"cardtype"];
NSString *pcardtype = (NSString *)[safeInfo objectForKey:@"pcardtype"];
    NSLog(@"%@-----%@",cardtype,pcardtype);
    if ([cardtype isEqualToString:pcardtype]) {
        [titleDropDown setSelectIndex:[self getIndexWith:cardtype]];
        [safepnameDropDown setSelectIndex:[self getIndexWith:cardtype]];
    }else{
        [titleDropDown setSelectIndex:[self getIndexWith:cardtype]];
        [safepnameDropDown setSelectIndex:[self getIndexWith:pcardtype]];
    }
    
}



-(int)getIndexWith:(NSString *)type{
    if ([type isEqualToString:@"01"]) {
        return 0;
    }else if([type isEqualToString:@"02"]){
        return 1;
    }else if([type isEqualToString:@"03"]){
        return 2;
    }else if([type isEqualToString:@"02"]){
        return 3;
    }else{
        return 0;
    }
    return 0;
}



//  设置 选择按钮
-(void)setupBtn:(UIButton *)btn WithTitle:(NSString *)title{
    [btn setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"right-gou"] forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)btnClick:(UIButton *)btn{
    if (btn.tag == 1000) {
        self.yesBtn.selected = YES;
        self.noBtn.selected = NO;
        _safepnameView.userInteractionEnabled = NO;
        safepnameDropDown.userInteractionEnabled = NO;
        safepnameTextView.text = safenameTextView.text;
        safepnameDropDown.contentTextView.text = titleDropDown.contentTextView.text;
        safepnameTextView.backgroundColor = RGB(210, 210, 210);
        safepnameDropDown.contentTextView.backgroundColor = RGB(210, 210, 210);
        safenameTextView.delegate = self;
        titleDropDown.contentTextView.delegate = self;
       
        
    }else if(btn.tag == 1001){
        self.noBtn.selected = YES;
        self.yesBtn.selected = NO;
        safepnameTextView.backgroundColor = [UIColor whiteColor];
        safepnameDropDown.contentTextView.backgroundColor = [UIColor whiteColor];
        _safepnameView.userInteractionEnabled = YES;
        safepnameDropDown.userInteractionEnabled = YES;
    }else if(btn.tag == 1002){
        self.nanBtn.selected = YES;
        self.nvBtn.selected = NO;
    }else if(btn.tag == 1003){
        self.nvBtn.selected = YES;
        self.nanBtn.selected = NO;
    }else{
        return;
    }
    return;
}


//获取保单数据
-(BOOL)getData
{
    if(safeInfo == nil)
    {
        return false;
    }
    NSString *txt = nil;
    
    NSLog(@"------%@",psafeType);
//    //是否为同一人
//    if (self.yesBtn.selected) {
//        txt = @"1";
//    }else if(self.noBtn.selected){
//        txt = @"0";
//    }
//    [safeInfo setValue:txt forKey:@"isprofessional"];
//    txt = nil;
    
    //流水号
    if(nil != safenoTextView)
    {
        txt = safenoTextView.text;
        if(txt == nil || [@"" isEqualToString:txt])
        {
            [self showAlertNotice:@"业务流水号不能为空"];
            return false;
        }
        BOOL isAllow = [PublicClass checkPrint:txt withRule:@"^[A-Za-z0-9]+$"];
        if (!isAllow) {
            [self showAlertNotice:@"业务流水号只能有字母和数字组成"];
            return false;
        }
        [safeInfo setValue:txt forKey:@"safeno"];
        
    }
    txt = nil;
    
    //险种类型，分为产险和寿险，跟公司类型一致
    [safeInfo setValue:[safeInfo objectForKey:@"companytype"] forKey:@"safetype"];
    
    //投保人姓名
    if(nil != safenameTextView)
    {
        txt = safenameTextView.text;
        if(txt == nil || [@"" isEqualToString:txt])
        {
            [self showAlertNotice:@"投保人姓名不能为空"];
            return false;
        }
        [safeInfo setValue:txt forKey:@"sname"];
    }
    txt = nil;

    //投保人证件
    if(nil != titleDropDown)
    {
        txt = [titleDropDown getTextFieldContent];
        if(txt == nil || [@"" isEqualToString:txt])
        {
            [self showAlertNotice:@"投保人证件号不能为空"];
            return false;
        }
        
        
        NSLog(@" >>>>>>   %@",safeType);
//        如果是身份证就做检查
        if([@"01" isEqualToString:safeType])
        {
            BOOL isCardno = [PublicClass checkIdentityCardNo:txt];
            if (!isCardno) {
                
                [self showAlertNotice:@"投保人证件号格式不正确"];
                return false;
            }
            
        }
        
        [safeInfo setValue:txt forKey:@"cardno"];
        [safeInfo setValue:safeType forKey:@"cardtype"];
    }
    txt = nil;
    
    //被保险人姓名
    if(nil != safepnameTextView)
    {
        txt = safepnameTextView.text;
        if(txt == nil || [@"" isEqualToString:txt])
        {
            [self showAlertNotice:@"被保险人姓名不能为空"];
            return false;
        }
        [safeInfo setValue:txt forKey:@"pname"];
    }
    txt = nil;
    
    //被保险人证件号
    if(nil != safepnameDropDown)
    {
        txt = [safepnameDropDown getTextFieldContent];
       
        if(txt == nil || [@"" isEqualToString:txt])
        {
            [self showAlertNotice:@"被保险人证件号不能为空"];
            return false;
        }
        
       
        //如果是身份证就做检查
        if([@"01" isEqualToString:psafeType])
        {
            BOOL isCardno = [PublicClass checkIdentityCardNo:txt];
            if (!isCardno) {
                [self showAlertNotice:@"被保险人证件号格式不正确"];
                return false;
            }
        }
        if (self.yesBtn.selected) {
            [safeInfo setValue:safeType forKey:@"pcardtype"];
        }else{
           [safeInfo setValue:psafeType forKey:@"pcardtype"];
        }
        [safeInfo setValue:txt forKey:@"pcardno"];
       
    }
    txt = nil;
    
    
    //保费
    if(nil != safepayTextView)
    {
        txt = safepayTextView.text;
        if(txt == nil || [@"" isEqualToString:txt])
        {
            [self showAlertNotice:@"保费不能为空"];
            return false;
        }
        
//        BOOL isAllow = [self checkPrint:txt withRule:@"^[0-9]+$"];
//        if (!isAllow) {
//            [self showAlertNotice:@"保额只能是数字"];
//            return false;
//        }

        [safeInfo setValue:txt forKey:@"safecost"];
    }
    txt = nil;

    //保额
    if(nil != safecostTextView)
    {
        txt = safecostTextView.text;
        
        if(txt == nil || [@"" isEqualToString:txt])
        {
            [self showAlertNotice:@"保额不能为空"];
            return false;
        }
        
//        BOOL isAllow = [self checkPrint:txt withRule:@"^[0-9]+$"];
//        if (!isAllow) {
//            [self showAlertNotice:@"保额只能是数字"];
//            return false;
//        }

        [safeInfo setValue:txt forKey:@"psafepay"];
    }
    txt = nil;
    
    //保单始期
    if(nil != starttimeTextView)
    {
        txt = starttimeTextView.text;
        if(txt == nil || [@"" isEqualToString:txt])
        {
            [self showAlertNotice:@"保单起始时间不能为空"];
            return false;
        }
        [safeInfo setValue:txt forKey:@"psafedate"];
    }
    txt = nil;
    
    //保险止期
    if(nil != endtimeTextView)
    {
        txt = endtimeTextView.text;
        if(txt == nil || [@"" isEqualToString:txt])
        {
            NSString *companytype = (NSString *)[safeInfo objectForKey:@"companytype"];
            NSString *text = nil;
            if ([companytype isEqualToString:@"1"]) {     // 财险
                text = @"保单止期时间不能为空";
            }else{        //  寿险
                text = @"保险期间不能为空";
            }

            [self showAlertNotice:text];
            return false;
        }
        NSLog(@"保险期间  %@",txt);
//        txt = [NSString stringWithFormat:@""%@"",txt];
        [safeInfo setValue:txt forKey:@"psafedateend"];
    }
    txt = nil;
    
    //车牌号
    if(nil != pcarnoTextView)
    {
        txt = pcarnoTextView.text;
        if(txt == nil || [@"" isEqualToString:txt])
        {
            [self showAlertNotice:@"车牌号不能为空"];
            return false;
        }
        [safeInfo setValue:txt forKey:@"pcarno"];
    }
    txt = nil;
    
    //车架号
    if(nil != carpwinTextView)
    {
        txt = carpwinTextView.text;
        if(txt == nil || [@"" isEqualToString:txt])
        {
            [self showAlertNotice:@"车架号不能为空"];
            return false;
        }
        
        [safeInfo setValue:txt forKey:@"pwin"];
    }
    txt = nil;
    
    //投保人性别
        if (self.nanBtn.selected) {
            txt = @"1";
        }else if(self.nvBtn.selected){
            txt = @"0";
        }
        [safeInfo setValue:txt forKey:@"sex"];
    txt = nil;
    
    //投保人年龄
    if(nil != ageTextView)
    {
        txt = ageTextView.text;
        if(txt == nil || [@"" isEqualToString:txt])
        {
            [self showAlertNotice:@"投保人年龄不能为空"];
            return false;
        }
        
        
        BOOL isAllow = [PublicClass checkPrint:txt withRule:@"^[0-9]+$"];
        if (!isAllow) {
            [self showAlertNotice:@"年龄只能是数字"];
            return false;
        }
        [safeInfo setValue:txt forKey:@"age"];
    }
    txt = nil;
    
    return true;

}








//显示提示
-(void)showAlertNotice:(NSString *)string
{
    if(nil == string || [@"" isEqualToString:string])
    {
        return;
    }
    
    FVCustomAlertView *successNotice = [[FVCustomAlertView alloc] init];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    label.text = string;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.layer.cornerRadius = 10;
    
    [successNotice showAlertWithonView:self.view Width:200 height:60 contentView:label cancelOnTouch:false Duration:2];
}

-(void)onClick:(UIButton *)btn
{
    int tag = (int)btn.tag;
    if(tag == 100)
    {
        mark = 0;
        //开始时间
        [self showDateTimerOnView];
    }
    else if(tag == 101)
    {
        mark = 1;
        //结束时间
        [self showDateTimerOnView];
    }
    else if(tag == 111)
    {
        //下一步
        BOOL isOK = [self getData];
        
        NSLog(@"获取所有数据了%d",isOK);
        if(isOK)
        {
            if(safeInfo != nil)
            {
                //补录时照片数组可以为空
                if(currentType == 3)
                {
                
                    if(nil == photoArray || photoArray.count <= 0)
                    {
                        //上传数据
                        [self sendData];
                        return;
                    }
                }
                
                PhotoViewController *phoneViewController = [[PhotoViewController alloc] init];
                [phoneViewController setSafeInfo:safeInfo];
                [phoneViewController setPhotoArray:photoArray];
                [phoneViewController setCurrentType:currentType];
                [self.navigationController pushViewController:phoneViewController animated:YES];
            }
        }
    }
    else if(tag == 200)
    {
        [self hideDateView];
    }
    else if(tag == 201)
    {
        [self hideDateView];
        
        //将选择的时间设置到文本框中
        if(mark == 0)
        {
            starttimeTextView.text = startTimeString;
        }
        else if(mark == 1)
        {
            endtimeTextView.text = endTimeString;
        }
    }
    else if(tag == 300)
    {
        [self hideDateView];
    }
}


//  上传保单
-(void)sendData{
//    [safeInfo setValue:@"1" forKey:@"isqrcode"];
//    [safeInfo setValue:@"01" forKey:@"cardtype"];
     NSString *safeInfoString = [Util objectToJson:[safeInfo getDic]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"bean"] = safeInfoString;
    [[Globle getInstance] .service requestWithServiceName:@"BBTone_ModifyImages2" params:params httpMethod:@"POST" resultIsDictionary:false completeBlock:^(id result){
        if ([result isEqualToString:@"true"]) {
            [MBProgressHUD showSuccess:@"发送成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:@"发送失败"];
        }
     }];
}


//隐藏时间选择界面
-(void)hideDateView
{
    if(dateView != nil)
    {
        [UIView animateWithDuration:0.3 animations:^
        {
            dateView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 216 + 40);
        }
        completion:^(BOOL finished)
        {
            if(nil != viewLayout)
            {
                [viewLayout removeFromSuperview];
            }
        }];
    }
}

-(void)setSafeInfo:(EntityBean *)safeInfoBean
{
    safeInfo = safeInfoBean;
    NSLog(@"safeinfo    %@",[safeInfo getDic]);
}

-(void)setPhotoArray:(NSArray *)photos
{
    photoArray = photos;
}

-(void)setCurrentType:(int)type
{
    currentType = type;
 
}

//选择时间,0表示开始时间，1表示结束时间
-(void)showDateTimerOnView
{
    //初始化startTimeString/endTimeString,默认为当前时间
    NSDate *date =  [NSDate date];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    startTimeString = [dateFormater stringFromDate:date];
    endTimeString = startTimeString;
    
    
    viewLayout = [UIButton buttonWithType:UIButtonTypeCustom];
    viewLayout.backgroundColor = [UIColor clearColor];
    viewLayout.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [viewLayout addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    viewLayout.tag = 300;
    [self.view.window addSubview:viewLayout];
    
    dateView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 216 + 40)];
    dateView.backgroundColor = [UIColor whiteColor];
    [viewLayout addSubview:dateView];
 
    int btnWidth = 50;
    int btnHeight = 35;
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
    toolView.backgroundColor = RGB(31, 156, 215);
    [dateView addSubview:toolView];
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(5, 5, btnWidth, btnHeight);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = 200;
    [toolView addSubview:cancelBtn];
    
    //确定按钮
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(dateView.width - btnWidth - 5, 5, btnWidth, btnHeight);
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    okBtn.tag = 201;
    [toolView addSubview:okBtn];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, cancelBtn.bottom, 0, 0)];
    //datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*365*10];
    //datePicker.maximumDate = [NSDate date];
    //datePicker.date = [NSDate dateWithTimeIntervalSinceNow:-60*60*24];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [dateView addSubview:datePicker];
    
    [UIView animateWithDuration:0.3 animations:^
    {
        dateView.frame = CGRectMake(0, ScreenHeight-216, ScreenWidth, 216);
    }];
}

//选择时间
-(void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    NSDate *date =  datePicker.date;
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [dateFormater stringFromDate:date];
    if(0 == mark)
    {
        startTimeString = time;
        NSLog(@"startTimeString:%@",startTimeString);
    }
    else if(1 == mark)
    {
        endTimeString = time;
        NSLog(@"endTimeString:%@",endTimeString);
    }
    
}

#pragma mark TitleDropDown delegate
-(void)titleDropDownDidSelected:(TitleDropDown *)dropDown index:(NSInteger)index
{
    NSString *string = nil;
    
    switch (index)
    {
        case 0:
            string = @"01";
            break;
        case 1:
            string = @"02";
            break;
        case 2:
            string = @"03";
            break;
        case 3:
            string = @"04";
            break;
            
        default:
            string = @"04";
            break;
    }
   
    
    if(titleDropDown == dropDown)
    {
        safeType = string;
        if (self.yesBtn.selected) {
            [safepnameDropDown setSelectIndex:index];
        }
    }
    else if(safepnameDropDown == dropDown)
    {
        psafeType = string;
        NSLog(@" 被保险的  %@",psafeType);
    }
    
}


#pragma mark - UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.yesBtn.selected) {
        safepnameTextView.text = safenameTextView.text;
        safepnameDropDown.contentTextView.text = titleDropDown.contentTextView.text;
        
    }
}



@end
