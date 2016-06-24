//
//  SelectCompanryController.m
//  TBRJL
//
//  Created by 程三 on 15/6/22.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "SelectCompanryController.h"
#import "DropDown.h"
#import "JSONKit.h"
#import "SGLRViewController.h"
#import "QRCodeViewController.h"


@implementation SelectCompanryController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGB(230, 230, 230);
    [super setTitle:@"投保摄影"];
    [self _initView];

    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     _nextBtn.enabled = NO;
    
    
}

-(void)_initView
{
    
    int titleWith = 100;
    int titleHeight = 40;
    
    //========================公司=============================
    _dropDownCompary = [[DropDown alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, titleHeight)];
    _dropDownCompary.dropDownDelagate = self;
    [_dropDownCompary setTitle:@"公司名称"];
    [self.view addSubview:_dropDownCompary];
    
    //=========================公司机构代码=========================
    UILabel *comparyCodeTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    comparyCodeTitle.text = @"公司机构代码";
    comparyCodeTitle.font = [UIFont systemFontOfSize:14];
    comparyCodeTitle.backgroundColor = RGB(240, 240, 240);
    comparyCodeTitle.textColor = RGB(17, 17, 17);
    comparyCodeTitle.left = 0;
    comparyCodeTitle.width = titleWith;
    comparyCodeTitle.top = _dropDownCompary.bottom + 1;
    comparyCodeTitle.height = titleHeight;
    comparyCodeTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:comparyCodeTitle];
    
    
    _comparyCodeName = [[UILabel alloc] initWithFrame:CGRectZero];
    _comparyCodeName.backgroundColor = [UIColor whiteColor];
    _comparyCodeName.left = comparyCodeTitle.right;
    _comparyCodeName.top = _dropDownCompary.bottom + 1;
    _comparyCodeName.width = ScreenWidth - comparyCodeTitle.width;
    _comparyCodeName.height = titleHeight;
    _comparyCodeName.font = [UIFont systemFontOfSize:14];
    _comparyCodeName.textColor = [PublicClass colorWithHexString:@"#636363"];
    [self.view addSubview:_comparyCodeName];
    
    //=========================险种=========================
    _dropDownSafeKind = [[DropDown alloc] initWithFrame:CGRectMake(0, comparyCodeTitle.bottom + 1, ScreenWidth, titleHeight)];
    _dropDownSafeKind.dropDownDelagate = self;
    [_dropDownSafeKind setTitle:@"险种"];
    NSArray* safeKindArray=[[NSArray alloc]initWithObjects:@"车险",@"意外险",nil];
    _dropDownSafeKind.tableArray = safeKindArray;
    [self.view addSubview:_dropDownSafeKind];
    
    //=========================业务员姓名=========================
    UILabel *userNameTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    userNameTitle.text = @"业务员姓名";
    userNameTitle.font = [UIFont systemFontOfSize:14];
    userNameTitle.backgroundColor = RGB(240, 240, 240);
    userNameTitle.textColor = [UIColor blackColor];
    userNameTitle.left = 0;
    userNameTitle.width = titleWith;
    userNameTitle.top = _dropDownSafeKind.bottom + 1;
    userNameTitle.height = titleHeight;
    userNameTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:userNameTitle];
    
    _userNameName = [[UILabel alloc] initWithFrame:CGRectZero];
    _userNameName.backgroundColor = [UIColor whiteColor];
    _userNameName.left = userNameTitle.right;
    _userNameName.top = _dropDownSafeKind.bottom + 1;
    _userNameName.width = ScreenWidth - userNameTitle.width;
    _userNameName.height = titleHeight;
    _userNameName.font = [UIFont systemFontOfSize:14];
    _userNameName.textColor = [PublicClass colorWithHexString:@"#636363"];
    _userNameName.text = (NSString *)[Util getValue:@"workname"];
    [self.view addSubview:_userNameName];
    
    //=========================录入方式=========================
    UILabel *wayTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    wayTitle.text = @"录入方式";
    wayTitle.font = [UIFont systemFontOfSize:14];
    wayTitle.backgroundColor = RGB(240, 240, 240);
    wayTitle.textColor = [UIColor blackColor];
    wayTitle.left = 0;
    wayTitle.width = titleWith;
    wayTitle.top = userNameTitle.bottom + 1;
    wayTitle.height = titleHeight;
    wayTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:wayTitle];
    
    UIView *wayView = [[UIView alloc] initWithFrame:CGRectZero];
    wayView.backgroundColor = [UIColor whiteColor];
    wayView.left = wayTitle.right;
    wayView.top = userNameTitle.bottom + 1;
    wayView.height = titleHeight;
    wayView.width = ScreenWidth - titleWith;
    [self.view addSubview:wayView];
    
    //二维码Check
    UIButton *ewmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ewmBtn.tag = 102;
    ewmBtn.left = 0;
    ewmBtn.top = 0;
    ewmBtn.height = titleHeight;
    ewmBtn.width = wayView.width/2;
    [ewmBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [wayView addSubview:ewmBtn];
    
    _ewmImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compose_checkbox_checked.png"]];
    _ewmImage.width = 20;
    _ewmImage.height = 20;
    _ewmImage.top = (titleHeight - 20)/2;
    _ewmImage.left = 20;
    [ewmBtn addSubview:_ewmImage];
    
    UILabel *ewmTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    ewmTitle.left = _ewmImage.right;
    ewmTitle.top = 0;
    ewmTitle.width = ewmBtn.width - _ewmImage.right;
    ewmTitle.height = titleHeight;
    ewmTitle.text = @"二维码";
    ewmTitle.font = [UIFont systemFontOfSize:12];
    ewmTitle.textColor = [PublicClass colorWithHexString:@"#636363"];
    [ewmBtn addSubview:ewmTitle];
    
    
    //手工录入Check
    UIButton *sgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sgBtn.tag = 103;
    sgBtn.left = ewmBtn.right;
    sgBtn.top = 0;
    sgBtn.height = titleHeight;
    sgBtn.width = wayView.width/2;
    [sgBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [wayView addSubview:sgBtn];
    
    _sgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compose_checkbox.png"]];
    _sgImage.width = 20;
    _sgImage.height = 20;
    _sgImage.top = (titleHeight - 20)/2;
    _sgImage.left = 5;
    [sgBtn addSubview:_sgImage];
    
    UILabel *sgTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    sgTitle.left = _sgImage.right;
    sgTitle.top = 0;
    sgTitle.width = sgBtn.width - _sgImage.right;
    sgTitle.height = titleHeight;
    sgTitle.text = @"手工";
    sgTitle.font = [UIFont systemFontOfSize:12];
    sgTitle.textColor = [PublicClass colorWithHexString:@"#636363"];
    [sgBtn addSubview:sgTitle];
    
    
    
    //======================下一步按钮========================
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _nextBtn.tag = 111;
    _nextBtn.frame = CGRectZero;
    _nextBtn.width = 200;
    _nextBtn.height = 40;
    _nextBtn.left = (ScreenWidth - _nextBtn.width)/2;
    _nextBtn.top = ScreenHeight - 44 - 20 - 45;
    //设置不可点击
    _nextBtn.enabled = NO;
    _nextBtn.layer.cornerRadius = 5;
    _nextBtn.layer.masksToBounds = YES;
    
    UIImage *img = [UIImage imageNamed:@"login_submit_normal.png"];
    img = [img stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [_nextBtn setBackgroundImage:img forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    
    
}

-(void)onClick:(UIButton *)btn
{
    int tag = (int)btn.tag;
    
    switch (tag)
    {
        case 102:
        {
            way = 0;
            [_ewmImage setImage:[UIImage imageNamed:@"compose_checkbox_checked.png"]];
            [_sgImage setImage:[UIImage imageNamed:@"compose_checkbox.png"]];
            break;
        }
        case 103:
        {
            way = 1;
            [_ewmImage setImage:[UIImage imageNamed:@"compose_checkbox.png"]];
            [_sgImage setImage:[UIImage imageNamed:@"compose_checkbox_checked.png"]];
            break;
        }
        case 111:
        {
            [[BaiduMobStat defaultStat] logEvent:@"Insured-photo1" eventLabel:@"投保摄影1"];
            
            if(way == 0)
            {
                
                [[BaiduMobStat defaultStat] logEvent:@"QR-code" eventLabel:@"二维码-投保摄影2"];
                QRCodeViewController *qrCodeVc = [[QRCodeViewController alloc] init];
                [safeInfo setValue:@"0" forKey:@"isread"];
                [safeInfo setValue:@"1" forKey:@"isqrcode"];
                [qrCodeVc setCurrentType:0];
                [qrCodeVc setSafeInfo:safeInfo];
                [qrCodeVc setPhotoArray:photoArray];
                [self.navigationController pushViewController:qrCodeVc animated:YES];
            }
            else if(way == 1)
            {
                
                [[BaiduMobStat defaultStat] logEvent:@"manual-input" eventLabel:@"手工录入-投保摄影2"];
                SGLRViewController *sglrViewController = [[SGLRViewController alloc] init];
                [safeInfo setValue:@"1" forKey:@"isread"];
                [safeInfo setValue:@"0" forKey:@"isqrcode"];
                [sglrViewController setCurrentType:0];
                [sglrViewController setSafeInfo:safeInfo];
                [sglrViewController setPhotoArray:photoArray];
                [self.navigationController pushViewController:sglrViewController animated:YES];
            }
            
            break;
        }
            
    }
}

//获取配置文件的数据
-(void)getData
{
    NSDictionary *userInfo = nil;
    
    NSString *isOffline = (NSString *)[Util getValue:@"offline"];
    NSLog(@"%@",isOffline);
    if ([isOffline isEqualToString:@"1"]) {      //  如果是离线
        userInfo = (NSDictionary *)[Util getValue:@"userInfo"];
        _userNameName.text = userInfo[@"name"];
        
    }else{
        userInfo =  [Globle getInstance].userInfoDic;
    }
    if(userInfo != nil)
    {
        NSString *cardNo = (NSString *)[Util getValue:@"username"];
        if(cardNo != nil)
        {
            
            //目录
            NSString *dic = ComparyInfoDic;
            //拼接路径
            NSString *fullPath = [dic stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",cardNo]];
            //判断配置文件是否存在
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            if([fileManager fileExistsAtPath:fullPath])
            {
             
                //获取公司的数 组
                comparyArray = [[NSArray alloc] initWithContentsOfFile:fullPath];
                NSLog(@"====>获取公司信息");
                if(comparyArray != nil)
                {
                    NSMutableArray *comArray = [[NSMutableArray alloc] init];
                    for (int i = 0; i < comparyArray.count; i++)
                    {
                        NSDictionary *comDic = comparyArray[i];
                        if(comDic != nil)
                        {
                            NSString *comparyName = [comDic objectForKey:@"name"];
                            if(nil != comparyName)
                            {
                                [comArray addObject:comparyName];
                            }
                        }
                        
                    }
                    
                    if(nil != _dropDownCompary)
                    {
                        [_dropDownCompary setTableArray:comArray];
                    }
                    
                    if(nil != _dropDownSafeKind)
                    {
                        [_dropDownSafeKind setTableArray:nil];
                    }

                }
                return;
            }
            
    
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"配置文件不存在，请更新配置文件" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
            [alert show];
        }
    }
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];

    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark DropDown delegate
-(void)DropDownDidSelected:(DropDown *)dropDown index:(NSInteger)index
{
    if(dropDown == _dropDownCompary)
    {
        safeArray = nil;
        NSDictionary *comparyDictionary = nil;
        if(comparyArray != nil && comparyArray.count > index)
        {
            comparyDictionary = comparyArray[index];
        }
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        if(comparyDictionary != nil)
        {
            [self setComPartInfo:comparyDictionary];
            safeArray = [comparyDictionary objectForKey:@"config"];
            if(nil != safeArray)
            {
                for (int i = 0; i < safeArray.count; i++)
                {
                    NSDictionary *dic = safeArray[i];
                    if(dic != nil)
                    {
                        NSString *safecategory = [dic objectForKey:@"safecategory"];
                        if(safecategory != nil)
                        {
                            [array addObject:safecategory];
                        }
                    }
                }
            }
        }
        
        if(_dropDownSafeKind != nil)
        {
            [_dropDownSafeKind setTableArray:array];
        }
        if(nil != _nextBtn)
        {
            _nextBtn.enabled = false;
        }
        
    }
    else if(dropDown == _dropDownSafeKind)
    {
        NSDictionary *safeDictionary = nil;
        if(safeArray != nil && safeArray.count > index)
        {
            safeDictionary = safeArray[index];
        }
        
        //判断产品对象是否为空
        if(safeDictionary == nil)
        {
            [self showNoticeTitle:@"温馨提示" msg:@"配置文件不全，请在系统设置中更新配置文件"];
            return;
        }
        
        //判断险种代码
        if([safeDictionary objectForKey:@"safecode"] == nil)
        {
            [self showNoticeTitle:@"温馨提示" msg:@"配置文件不全，请在系统设置中更新配置文件"];
            return;
        }
        
        [safeInfo setValue:[safeDictionary objectForKey:@"safecode"] forKey:@"safecode"];
        [safeInfo setValue:[safeDictionary objectForKey:@"safecode"] forKey:@"psafetypes"];
        
        //获取照片数组
        photoArray = [self getPhotoArray:safeDictionary];
        
        if(photoArray == nil || photoArray.count == 0)
        {
            [self showNoticeTitle:@"温馨提示" msg:@"配置文件不全，请在系统设置中更新配置文件"];
            return;
        }
        if(nil != _nextBtn)
        {
            _nextBtn.enabled = true;
        }
    }
}

-(void)showNoticeTitle:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

-(void)setComPartInfo:(NSDictionary *)companyBean
{
    /*
     * 公司对象：
     * " beanname":" organisation",
     * "id":"119ffe194ce94a779e15890fef1e6e77",
     * " areaid":"350000000000000000",
     * " orgno":"350000003001",
     * "name":"人保财险",
     * " fullname":"中国人民财产保险股份有限公司福建省分公司",
     * " companyno":"3001",
     * " tel":"",
     * " fax":"",
     * " linkman":"",
     * "manager":"",
     * "address":"福州五四路233号保险大厦",
     * "remark":"",
     * "syscode":"34.001001000000000000000000",
     * " ishaschild":"1",
     * "creator":"350000012000",
     * " createtime":"2014-12-20 23:04:57.647",
     * "updater":"350000013001",
     * " updatetime":"2015-01-04 10:48:00.0",
     * " companytype":"1"
     *      config=[Lcom.longrise.LEAP.Base.Objects.EntityBean;@426a16f8}
     */
    if(nil == companyBean)
    {
        return;
    }
    if(nil == safeInfo)
    {
        safeInfo = [[EntityBean alloc] init];
    }
    //设置公司代码
    if(nil != _comparyCodeName)
    {
        _comparyCodeName.text = [companyBean objectForKey:@"orgno"];
    }
    
    //--------------------------设置公司信息-------------------------
    //添加保险公司名称
    [safeInfo setValue:[companyBean objectForKey:@"name"] forKey:@"companyname"];
    //添加保险公司机构代码
    [safeInfo setValue:[companyBean objectForKey:@"orgno"] forKey:@"companycode"];
    //添加区域
    [safeInfo setValue:[companyBean objectForKey:@"areaid"] forKey:@"areaid"];
    //公司类型
    [safeInfo setValue:[companyBean objectForKey:@"companytype"] forKey:@"companytype"];
    //公司号码
    [safeInfo setValue:[companyBean objectForKey:@"companyno"] forKey:@"companyno"];
    //系统代码
    [safeInfo setValue:[companyBean objectForKey:@"syscode"] forKey:@"syscode"];
    //登陆人身份证号
    [safeInfo setValue:[[Globle getInstance].userInfoDic objectForKey:@"cardno"] forKey:@"logincardno"];
}

//获取照片数组
-(NSArray *)getPhotoArray:(NSDictionary *)dic
{
    if(nil == dic)
    {
        return nil;
    }
    //照片集合
    NSArray *array = [dic objectForKey:@"atts"];
    if(nil == array || array.count <= 0)
    {
        return nil;
    }
    
    //子照片集合
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for ( int i = 0; i < array.count; i++)
    {
        /*
         * {
            beanname = bbtoneconfigatt;@
            code = 10301;@
            configid = 9f0a8d89806a4e7c833935c577fe2c2c;
            createtime = "2014-12-23 11:30:24.777";@
            creator = 350000012000;@
            id = 6095a808a4c943a5a3146933880520e7;@
            iswater = 1;
            phototype = "\U6295\U4fdd\U4eba\U4eb2\U7b14\U7b7e\U540d";
            ext =     (
            {
                attid = 6095a808a4c943a5a3146933880520e7;
                beanname = bbtoneconfigattext;
                code = 1030101;
                createtime = "2014-12-23 11:30:27.77";
                creator = 350000012000;
                id = 4c6a93bee99445dfbe1ba4cd5b6e82a6;
                nullable = 1;
                photoname = "\U6295\U4fdd\U4eba\U4eb2\U7b14\U7b7e\U540d";
                updater = 350000012000;
                updatetime = "2014-12-25 18:01:30.363";
            }
            );
         
         Java:
         
         bean2.put( "title", bean2.getString("photoname" ));
         //字段 phototype／photocode／iswater需要从外层照片对象中拿
         bean2.put( "phototype" , bean.getString("phototype" ));
         bean2.put( "photocode " , bean.getString("code" ));
         bean2.put( "iswater", bean.getInt("iswater" ));
         
         bean2.put("id", null);
         
         }
         */
        
        NSDictionary *bean = [array objectAtIndex:i];
        if(nil != bean)
        {
            //获取子照片中相片数组
            NSArray *childs = [bean objectForKey:@"ext"];
            if(nil != childs)
            {
                for ( int j = 0; j < childs.count ; j++)
                {
                    NSDictionary *bean2 = [childs objectAtIndex:j];
                    
                    if(nil != bean2)
                    {
                        
                        EntityBean *myBean = [[EntityBean alloc] init];
                        [myBean setValue:[bean2 objectForKey:@"attid"] forKey:@"attid"];
                        [myBean setValue:[bean2 objectForKey:@"beanname"] forKey:@"beanname"];
                        [myBean setValue:[bean2 objectForKey:@"code"] forKey:@"code"];
                        [myBean setValue:[bean2 objectForKey:@"createtime"] forKey:@"createtime"];
                        [myBean setValue:[bean2 objectForKey:@"creator"] forKey:@"creator"];
                        [myBean setValue:nil forKey:@"id"];
                        [myBean setValue:[bean2 objectForKey:@"nullable"] forKey:@"nullable"];
                        [myBean setValue:[bean2 objectForKey:@"updater"] forKey:@"updater"];
                        [myBean setValue:[bean2 objectForKey:@"updatetime"] forKey:@"updatetime"];
                        [myBean setValue:[bean2 objectForKey:@"photoname"] forKey:@"photoname"];
                        
                        //从外层数组中获取的值
                        [myBean setValue:[bean2 objectForKey:@"photoname"] forKey:@"title"];
                        [myBean setValue:[bean objectForKey:@"phototype"] forKey:@"phototype"];
                        [myBean setValue:[bean objectForKey:@"code"] forKey:@"photocode"];
                        [myBean setValue:[bean objectForKey:@"iswater"] forKey:@"iswater"];
                        
                        [photos addObject:myBean];
                    }
                }
            }
        }
    }
    
    if(nil == photos || photos.count <= 0)
    {
        return nil;
    }
    return photos;
}

// 进入页面，建议在此处添加
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString* cName = [NSString stringWithFormat:@"%@",  self.title, nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
    [self getData];
}

// 退出页面，建议在此处添加
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSString* cName = [NSString stringWithFormat:@"%@", self.title, nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}

@end
