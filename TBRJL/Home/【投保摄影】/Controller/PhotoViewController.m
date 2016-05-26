//
//  photoViewController.m
//  TBRJL
//
//  Created by 程三 on 15/7/12.
//  Copyright (c) 2015年 程三. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoTableViewCell.h"
#import "CustomCarmeraController.h"
#import "WXHLDataService.h"
#import "FVCustomAlertView.h"
#import "SearchParameters.h"
@interface PhotoViewController()
@property (nonatomic ,copy) NSString *creatTime;
@property (nonatomic ,copy) NSString *currentTime;
@property (nonatomic ,strong)NSMutableArray *photos;
@property (nonatomic ,strong)UIView *btnView;
@end

@implementation PhotoViewController
-(NSMutableArray *)photos{
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        
    }
    
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [super setTitle:@"投保摄影"];
    [self _initView];

    
    //获取图片存放的目录
    if(currentType == 1)
    {
         //缓存就从保单对象中拿
        self.creatTime = (NSString *)[safeInfo objectForKey:@"creattime"];
//        photoDicPath = (NSString *)[safeInfo objectForKey:@"photoDicPath"];
        NSString *time = (NSString *)[safeInfo objectForKey:@"time"];
        NSString *photoPath = photoInfoDic;
        NSLog(@"目录名%@",time);
        photoDicPath = [photoPath stringByAppendingPathComponent:time];
        NSLog(@"  地址 %@",photoDicPath);
        
    }
    else{
    
        if (currentType == 2 || currentType == 3) {    //补拍
            self.title = @"图像补拍";
            saveBtn.hidden = YES;
            sendBtn.frame = CGRectMake((ScreenWidth - 200)/2 ,(self.btnView.height - 40)/2, 200, 40);
            UIImage *sendImg = [UIImage imageNamed:@"login_submit_normal.png"];
            sendImg = [sendImg stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            [sendBtn setBackgroundImage:sendImg forState:UIControlStateNormal];
            [self.btnView addSubview:sendBtn];
        }
        //新建、补录和补拍就新建
        photoDicPath = photoInfoDic;
        NSDictionary *timeDic = [Util getCurrentTime];
        NSString *time = [NSString stringWithFormat:@"%@%@%@%@%@%@",[timeDic objectForKey:@"year"],[timeDic objectForKey:@"month"],[timeDic objectForKey:@"day"],[timeDic objectForKey:@"hour"],[timeDic objectForKey:@"minute"],[timeDic objectForKey:@"second"]];
        [safeInfo setValue:time forKey:@"time"];
        photoDicPath = [photoDicPath stringByAppendingPathComponent:time];
        
    }
    
//    创建保单表
    [self creatPolicy];
//    创建图片表
    [self creatPolicyImage];
   
   }


-(void)_initView
{
    photoTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    photoTableView.left = 0;
    photoTableView.top = 0;
    photoTableView.width = ScreenWidth;
    photoTableView.height = ScreenHeight - 20 - 44 - 60;
    photoTableView.delegate = self;
    photoTableView.dataSource = self;
    [self.view addSubview:photoTableView];
    
    
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectZero];
    btnView.left = 0;
    btnView.top = photoTableView.bottom;
    btnView.width = ScreenWidth;
    btnView.height = 60;
    btnView.backgroundColor = [UIColor lightGrayColor];
    self.btnView = btnView;
    [self.view addSubview:btnView];
    
    
    int widthBtn = 80;
    //保存按钮
    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"暂存" forState:UIControlStateNormal];
    saveBtn.tag = 100;
    saveBtn.frame = CGRectZero;
    saveBtn.left = (ScreenWidth - widthBtn * 2 - 20)/2;
    saveBtn.top = 10;
    saveBtn.width = widthBtn;
    saveBtn.height = 40;
    saveBtn.layer.cornerRadius = 5;
    saveBtn.layer.masksToBounds = YES;
    
    //设置不可点击
    //saveBtn.enabled = NO;
    
    UIImage *img = [UIImage imageNamed:@"login_submit_normal.png"];
    img = [img stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [saveBtn setBackgroundImage:img forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:saveBtn];
    
    
    //发送按钮
    sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.tag = 101;
    sendBtn.frame = CGRectZero;
    sendBtn.left = saveBtn.right + 20;
    sendBtn.top = 10;
    sendBtn.width = widthBtn;
    sendBtn.height = 40;
    sendBtn.layer.cornerRadius = 5;
    sendBtn.layer.masksToBounds = YES;
    //设置不可点击
    //sandBtn.enabled = NO;
    
    UIImage *sendImg = [UIImage imageNamed:@"login_submit_normal.png"];
    sendImg = [sendImg stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [sendBtn setBackgroundImage:sendImg forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:sendBtn];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //删除ZIP包
    BOOL success = [Util delForDic:zipPath];
    
    NSLog(@"删除ZIP包:%@",[[NSNumber alloc] initWithBool:success]);
}

#pragma mark 按钮回调事件
-(void)onClick:(UIButton *)btn
{
//      暂存数据
    if(btn == saveBtn)
    {
//      暂存数据到数据库
        BOOL res = [self isUpdatePolicy];
        
            if (!res) {
                [MBProgressHUD showError:@"暂存失败"];
            }else{
                
                for (int i = 0; i < photoArray.count; i++)
                {
                    
                    EntityBean *bean = [photoArray objectAtIndex:i];
                    NSDictionary *dic = [bean getDic];
                    NSLog(@" 暂存图片数据   --------%@",dic);
                    PhotoInfoModel *photoModel = [[PhotoInfoModel alloc] init];
                    photoModel.attid = dic[@"attid"];
                    photoModel.beanname = dic[@"beanname"];
                    photoModel.code = dic[@"code"];
                    photoModel.createtime = dic[@"createtime"];
                    photoModel.creator = dic[@"creator"];
                    photoModel.filename = dic[@"filename"];
                    photoModel.iswater = dic[@"iswater"] ;
                    photoModel.nullable1 = dic[@"nullable"];
                    photoModel.path = dic[@"path"];
                    photoModel.photocode = dic[@"photocode"];
                    photoModel.photoname = dic[@"photoname"];
                    photoModel.phototype = dic[@"phototype"];
                    photoModel.title = dic[@"title"];
                    photoModel.updater = dic[@"updater"];
                    photoModel.updatetime = dic[@"updatetime"];
                    BOOL rst =  [self updatePolicyImage:photoModel withCreatTime:self.currentTime];
                    
                    if (!rst) {
                        [MBProgressHUD showError:@"暂存失败"];
                        return;
                    }
                }
                
                //  如果重新暂存 ，先判断是否有有之前创建的数据
                if (self.creatTime) {       //  有就删除数据
                    // 删除保单表和图片表
                    NSLog(@"暂存前的文件的创建时间 %@",self.creatTime);
                    BOOL isDelPolicy = [self deleteTableByCreatTime:self.creatTime TableName:@"policy"];
                    BOOL isDelPolicyImage =  [self deleteTableByCreatTime:self.creatTime TableName:@"policyimage"];
                     NSLog(@" 删除保单表 %d   删除图片表%d",isDelPolicy,isDelPolicyImage);
                }
                [MBProgressHUD showSuccess:@"暂存成功"];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
    }
    else if(btn == sendBtn)
    {
        
        NSString *isOffline = (NSString *)[Util getValue:@"offline"];
        if ([isOffline isEqualToString:@"1"]) {
            [MBProgressHUD hideHUD];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您目前的状态是离线，请在有网的状态下登陆后上传." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return;
            
        }        
        //当前类型值 0 ：新建 ，1：缓存，2：补拍 3：补录
        BOOL b = false;
        switch (currentType)
        {
            case 0:
                b = [self isOK];
                break;
            case 1:
                b = [self isOK];
                break;
            case 2:
            case 3:
                b = [self isOK];
                if(b)
                {
                    //显示提示
                    sendNotice = [[FVCustomAlertView alloc] init];
                    [sendNotice showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:-1];
                    
                    //补拍直接发送，不用提示
                    //补拍直接发送，不用提示
                    [self startAddFile2ZIP];
                }
                else
                {
                    [self showNoice:@"温馨提示" msg:@"温馨提示：请确保所有必需拍摄的照片都已拍摄完毕（带星号标记表示必须拍摄的栏目）"];
                }
                return;
        }
        
        if(b)
        {
            [self isHaveData];
        }
        else
        {
            [self showNoice:@"温馨提示" msg:@"温馨提示：请确保所有必需拍摄的照片都已拍摄完毕（带星号标记表示必须拍摄的栏目）"];
        }
    }
}

//保单号是否已经存在
-(void)isHaveData
{
    
    //显示提示
    sendNotice = [[FVCustomAlertView alloc] init];
    [sendNotice showAlertWithonView:self.view Width:100 height:100 contentView:nil cancelOnTouch:false Duration:-1];
    
    //获取保单号和用户ID
    NSString *safeno = (NSString *)[safeInfo objectForKey:@"safeno"];
    NSString *userid = (NSString *)[Util getValue:@"id"];
   
    if(safeno == nil || [@"" isEqualToString:safeno] ||
       userid == nil || [@"" isEqualToString:userid])
    {
        if(nil != sendNotice)
        {
            [sendNotice dismiss];
        }
        [self showNoice:@"温馨提示" msg:@"用户信息不完整,无法提交"];
    }
    else
    {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        
        //查询保单号是否存在
        SearchParameters *search = [[SearchParameters alloc] init];
        [search setFillCodeValue:@"true"];
        [search addParameter:@"userid" value:userid flag:11];
        [search addParameter:@"safeno" value:safeno flag:11];
        [search addFieldName:@"checkstatus"];
        [search setPageSize:[[NSNumber alloc] initWithInt:10]];
        [search setPageNum:[[NSNumber alloc] initWithInt:1]];
        
        [params setObject:[search getStringOfObject] forKey:@"par"];
        [params setObject:@"false" forKey:@"isBupai"];
        
        [[Globle getInstance].service requestWithServiceName:@"BBTone_getDataList" params:params httpMethod:@"POST" resultIsDictionary:true completeBlock:^(id result)
        {
            if(result == nil)
            {
                //继续发送
                [self startAddFile2ZIP];
            }
            else
            {
                //终止发送，并给出相应的提示
                NSDictionary *dic = result;
                if(dic == nil)
                {
                    //继续发送
                    [self startAddFile2ZIP];
                }
                else
                {
                    NSArray *array = [dic objectForKey:@"result"];
                    if(array != nil && array.count > 0)
                    {
                        //获取结果
                        NSDictionary *bean = [array objectAtIndex:0];
                        //checkstatus 0是待审/1是补拍/2是审核通过/3退回/4已删除
                        NSString *checkstatus = [bean objectForKey:@"checkstatus"];
                        
                        if([@"0" isEqualToString:checkstatus] ||
                           [@"1" isEqualToString:checkstatus] ||
                           [@"3" isEqualToString:checkstatus])
                        {
                            if(nil != sendNotice)
                            {
                                [sendNotice dismiss];
                            }

                            [self showNoice:@"温馨提示" msg:@"该保单号或业务流水号已经存在，请暂存并修改后再上传。"];
                        }
                        else if([@"2" isEqualToString:checkstatus])
                        {
                            if(nil != sendNotice)
                            {
                                [sendNotice dismiss];
                            }

                            [self showNoice:@"温馨提示" msg:@"该保单已存在，且已审核通过，不得再次上传。"];
                        }
                        else if([@"4" isEqualToString:checkstatus])
                        {
                            if(nil != sendNotice)
                            {
                                [sendNotice dismiss];
                            }

                            [self showNoice:@"温馨提示" msg:@"该保单号或业务流水号已经存在已删列表中，请暂存并修改后再上传。"];
                        }
                    }
                    else
                    {
                        //继续发送
                        [self startAddFile2ZIP];
                    }
                }
            }
        }];
    }
}

//开始压缩图片
-(void)startAddFile2ZIP
{
    NSDictionary *timeDic = [Util getCurrentTime];
    
    zipPath = photoZipDic;
    NSString *fileName = [NSString stringWithFormat:@"%@%@%@%@%@%@.zip",[timeDic objectForKey:@"year"],[timeDic objectForKey:@"month"],[timeDic objectForKey:@"day"],[timeDic objectForKey:@"hour"],[timeDic objectForKey:@"minute"],[timeDic objectForKey:@"second"]];
    NSLog(@"%@",fileName);
    
    zipPath = [zipPath stringByAppendingPathComponent:fileName];
    BOOL zipSuccess = [Util addFileToZip:photoDicPath zipFullPath:zipPath];
    if(zipSuccess)
    {
        //压缩成功
        NSLog(@"压缩成功");
        NSString *isBuPai = @"false";
        if(currentType == 2 || currentType == 3){    // 补拍
            isBuPai = @"YES";
        }
        [self sendZIPPath:zipPath safeno:(NSString *)[safeInfo objectForKey:@"safeno"] isBuPai:isBuPai fileName:fileName];
        
    }
    else
    {
        //压缩成功
        NSLog(@"压缩失败");
        if(nil != sendNotice)
        {
            [sendNotice dismiss];
        }
        [self showNoice:@"温馨提示" msg:@"图片压缩失败"];
    }

}

-(BOOL)sendZIPPath:(NSString *)zipFullPath safeno:(NSString *)safeno isBuPai:(NSString *)isBuPai fileName:(NSString *)fileName
{
    NSLog(@"safeno  %@",safeno);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[[Globle getInstance].userInfoDic objectForKey:@"id"] forKey:@"userid"];
    [params setObject:safeno forKey:@"bdhm"];
    [params setObject:isBuPai forKey:@"bupai"];
    
    NSString *string = (NSString *)[Util getValue:@"serviceURL"];
    NSLog(@"服务器地址  %@",string);
    NSString *url = [NSString stringWithFormat:@"%@logic/BBToneImageUpload",string];
    url = [NSString stringWithFormat:@"%@?userid=%@&bdhm=%@&bupai=%@",url,[[Globle getInstance].userInfoDic objectForKey:@"id"],safeno,isBuPai];
    
    
    [[Globle getInstance].service uploadUrl:url fileFullPath:zipFullPath params:nil name:@"tbpZipFile" fileName:fileName completeBlock:^(id result)
    {
    
        NSLog(@"上传文件结果：%@",result);
        if(result == nil)
        {
            [sendNotice dismiss];
            [self showNoice:@"温馨提示" msg:@"文件上传失败，请稍后再上传"];
        }
        else 
        {
            NSDictionary *dic = result;
            NSString *result = [dic  objectForKey:@"result"];
            if([@"true" isEqualToString:result])
            {
                NSString *namedPath = [dic objectForKey:@"namedPath"];
                if(nil != namedPath)
                {
                    [self sendSafeInfo:namedPath];
                }
            }
            else
            {
                [self showNoice:@"温馨提示" msg:@"文件上传失败，请稍后再上传"];
            }
        }
    }];
    
    return false;
}

//发送保单信息
-(BOOL)sendSafeInfo:(NSString *)namedPath
{
    //设置登录人的信息
    BOOL b = [self setLoginPersonInfo:safeInfo];
    if(!b)
    {
        [sendNotice dismiss];
        [self showNoice:@"温馨提示" msg:@"登录人信息不完整，请更新配置文件"];
        return false;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < photoArray.count; i++)
    {
        EntityBean *bean = [photoArray objectAtIndex:i];
        if(nil != bean)
        {
            NSDictionary *dic = [bean getDic];
            [array addObject:dic];
        }
    }
    
    [safeInfo setValue:array forKey:@"atts"];
    NSLog(@" 发送的所有   %@",[safeInfo getDic]);
    NSString *safeInfoString = [Util objectToJson:[safeInfo getDic]];
    NSLog(@"发送   safeInfoString   %@",safeInfoString);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:safeInfoString,@"bean",namedPath,@"namedPath", nil];
    NSString *serviceName = nil;
    if(currentType == 0 || currentType == 1)
    {
        serviceName = @"BBTone_CreateImages2";
    }
    else
    {
        serviceName = @"BBTone_ModifyImages2";
    }
    [[Globle getInstance] .service requestWithServiceName:serviceName params:params httpMethod:@"POST" resultIsDictionary:false completeBlock:^(id result)
    {
        [sendNotice dismiss];
        
        if([@"true" isEqualToString:(NSString *)result])
        {
            //删除照片
            BOOL success = [Util delForDic:photoDicPath];
            NSLog(@"删除照片:%@",[[NSNumber alloc] initWithBool:success]);
            
           // 删除保单表和图片表
            BOOL isDelPolicy = [self deleteTableByCreatTime:self.creatTime TableName:@"policy"];
            BOOL isDelPolicyImage =  [self deleteTableByCreatTime:self.creatTime TableName:@"policyimage"];
            NSLog(@" 删除保单表 %d   删除图片表%d",isDelPolicy,isDelPolicyImage);
            
            successNotice = [[FVCustomAlertView alloc] init];
            successNotice.customAlertViewDelegate = self;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            label.text = @"发送成功";
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:14];
            label.layer.cornerRadius = 10;
            
            [successNotice showAlertWithonView:self.view Width:100 height:100 contentView:label cancelOnTouch:false Duration:3];
        }
        else
        {
            [self showNoice:@"温馨提示" msg:@"发送失败"];
        }
    }];
    
    return false;
}

-(BOOL)setLoginPersonInfo:(EntityBean *)entityBean
{
    if(nil == entityBean ||  [Globle getInstance].userInfoDic == nil)
    {
        return false;
    }
    //登录人公司名称
    [entityBean setValue:[[Globle getInstance].userInfoDic objectForKey:@"orgname"] forKey:@"personorgname"];
    //用户orgno
    [entityBean setValue:[[Globle getInstance].userInfoDic objectForKey:@"orgno"] forKey:@"personorgno"];
    //添加会员姓名
    [entityBean setValue:[[Globle getInstance].userInfoDic objectForKey:@"name"] forKey:@"hyname"];
    //添加会员编号
    [entityBean setValue:[[Globle getInstance].userInfoDic objectForKey:@"id"] forKey:@"userid"];
    //原始版本版本号
    [entityBean setValue:@"IOS_V1.0" forKey:@"upversion"];
    //升级后的版本号，如果没有升级就是一样的
    [entityBean setValue:@"IOS_V1.0" forKey:@"version"];
    
    return true;
}

/**
 * 判断是否可以发送
 */
-(BOOL)isOK
{
    for (int i = 0; i < photoArray.count; i++)
    {
        EntityBean *myDic = [photoArray objectAtIndex:i];
        
        if(nil == myDic)
        {
            return false;
        }
        
        // 如果是补拍或者补录的话，则一定要拍照片，全部都要检查
        //类型：0 新建／1:缓存／2:补拍／3:补录
        if(currentType == 2 || currentType == 3)
        {
            NSString *path = (NSString *)[myDic objectForKey:@"path"];
            if(nil == path || [@"" isEqualToString:path])
            {
                return false;
            }

        }
        else
        {
            if([@"1" isEqualToString:(NSString *)[myDic objectForKey:@"nullable"]])
            {
//                NSString *path = (NSString *)[myDic objectForKey:@"path"];
                NSLog(@"---%@",photoDicPath);
                if(photoDicPath == nil || [@"" isEqualToString:photoDicPath])
                {
                    return false;
                }
                else
                {
                    //判断文件是否存在
                    NSString *filename = (NSString *)[myDic objectForKey:@"filename"];
                    if(![[NSFileManager defaultManager] fileExistsAtPath:[photoDicPath stringByAppendingPathComponent:filename]])
                    {
                        return false;
                    }
                }
            }

        }
    }
    return true;
}


-(void)setSafeInfo:(EntityBean *)safeInfoBean
{
    safeInfo = safeInfoBean;
    NSLog(@" 保单信息 ————————————  %@",[safeInfo getDic]);
}
-(void)setPhotoArray:(NSArray *)photos
{
    photoArray = photos;
    for (EntityBean *bean in photoArray) {
        NSLog(@" 照片信息 ———————————— %@",[bean getDic]);
    }
    
    
}

-(void)setCurrentType:(int)type
{
    currentType = type;

}

#pragma mark UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return photoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    PhotoTableViewCell *photoCell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(photoCell == nil)
    {
        photoCell = [[PhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    EntityBean *bean = [photoArray objectAtIndex:indexPath.row];
    photoCell.filePath = photoDicPath;
    [photoCell setData:bean];
    [photoCell setCurrentType:currentType];
    return photoCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EntityBean *bean = [photoArray objectAtIndex:indexPath.row];

    position = indexPath.row;
    
    if(carmeraController == nil)
    {
        carmeraController = [[CustomCarmeraController alloc] init];
        carmeraController.waterText = @"仅供保险投保使用";
        carmeraController.titleName = (NSString *)[bean objectForKey:@"title"];
        carmeraController.waterTextColor = [UIColor lightGrayColor];
        carmeraController.waterTextSize = 34;
        carmeraController.delegate = self;
    }
    
    [self.navigationController pushViewController:carmeraController animated:YES];
}

-(void)DidTakePhotoCustomCarmeraController:(CustomCarmeraController *)customCarmeraController Image:(UIImage *)image
{
    if(photoArray != nil && photoArray.count > position && position >= 0)
    {
        EntityBean *photoDic = [photoArray objectAtIndex:position];
  
        if(nil != photoDic)
        {
//            NSString *filename = (NSString *)[photoDic objectForKey:@"filename"];
//            if(filename == nil || filename.length == 0)
//            {
                NSDictionary *timeDic = [Util getCurrentTime];
               NSString *filename = [NSString stringWithFormat:@"%@%@%@%@%@%@.jpg",[timeDic objectForKey:@"year"],[timeDic objectForKey:@"month"],[timeDic objectForKey:@"day"],[timeDic objectForKey:@"hour"],[timeDic objectForKey:@"minute"],[timeDic objectForKey:@"second"]];
//            }
        
            BOOL b = [Util saveImgToDic:photoDicPath fileName:filename UIImage:image];
            
            if(!b)
            {
                [self showNoice:@"温馨提示" msg:@"影像存储失败"];
            }
            else
            {
                NSLog(@"影像保存成功。。。");
                
                NSLog(@" 图片存储的地址  %@",photoDicPath);
                [photoDic setValue:filename forKey:@"filename"];
                [photoDic setValue:photoDicPath forKey:@"path"];
             
                
                
                //刷新TableView
                [photoTableView reloadData];
            }

        }
    }
    
}
#pragma mark FVCustomAlertView delegate
-(void)customAlertViewDismiss:(FVCustomAlertView *)customAlertView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)showNoice:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}



-(BOOL)isUpdatePolicy{
    NSDictionary *dict = [safeInfo getDic];
    NSLog(@" 暂存保单数据   %@",dict);
    PolicyModel *model = [[PolicyModel alloc] init];
    model.userid = (NSString *)[Util getValue:CHAccount];
    NSLog(@"-----------%@",model.userid);
    model.age = dict[@"age"];
    model.areaid = dict[@"areaid"];
    model.cardno = dict[@"cardno"];
    model.cardtype = dict[@"cardtype"];
    model.companycode = dict[@"companycode"];
    model.companyname = dict[@"companyname"];
    model.companyno = dict[@"companyno"];
    model.companytype = dict[@"companytype"];
    model.pcardno = dict[@"pcardno"];
    model.pcardtype = dict[@"pcardtype"];
    model.pname = dict[@"pname"];
    model.psafedate = dict[@"psafedate"];
    model.psafedateend = dict[@"psafedateend"];
    model.psafepay = dict[@"psafepay"];
    model.psafetypes = dict[@"psafetypes"];
    model.safecode = dict[@"safecode"];
    model.safecost = dict[@"safecost"];
    model.safeno = dict[@"safeno"];
    model.safetype = [dict[@"safetype"] integerValue];
    model.sex = dict[@"sex"];
    model.sname = dict[@"sname"];
    model.syscode = dict[@"syscode"];
    model.pcarno = dict[@"pcarno"];
    model.pwin = dict[@"pwin"];
    model.isread = dict[@"isread"];
    model.isqrcode = dict[@"isqrcode"];
    model.time = dict[@"time"];
    model.photoDicPath = photoDicPath;
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"YYYYMMddHHmmss";
    model.creatTime = [df stringFromDate:currentDate] ;
    self.currentTime = model.creatTime;
    BOOL res = [self updatePolicy:model];
    return res;
}

@end
