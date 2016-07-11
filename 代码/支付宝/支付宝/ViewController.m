//
//  ViewController.m
//  支付宝
//
//  Created by GG on 16/7/8.
//  Copyright © 2016年 GG. All rights reserved.
//

#import "ViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //支付宝用到的变量
    
    //1. partnerID
    NSString *partnerID = @"2088902818840206";
    
    //2. sellerID
    
    NSString *sellerId = @"13121529304";
    
    //3. 私钥
    
    NSString *privatekey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAM1NHCkaC7oUsASQg2MPcsjE4qb8hYXhaH038D4u9eV/8J7bGI6C5kx5ED2CfgQ1Nrlbo/fcfSSV0HnLHhnr+Q21BKlB3FedYMtEJGqFTs/J+scs31eGnQPcnTwaOTStVFKUBbI7F29s8Ju7W8QBegC3cO68YiLBqIvJ/qKZYJBhAgMBAAECgYB7XJ5TREdPpSavV3bbi2jZoxTealaBQBTdSUOe2fD/2oTnr5dt6tIfmY9cppC6To93ic1ZHrBDz5HZ3WdVBCo+MoM+WdIv15GFy3jpWgaqa7k2NWU8RysejM1NdXmMj0pxyrm18+0eZDg8nkdz+nJYBcL7+/aQHYmQNjfdQKHRwQJBAO+fPraVQEfLtDZiZsoAWf4zJEuf8HwKv/l9/JOV2fdyJY7o2OdS3lkzx8ro71f1Rs1WBPSpZw7OdHGjdMth8+0CQQDbVVc3hLUiqNfwGMgJG4RrkilTHl4lR8gCWklPn0I1zIjG8VC/om+GQ5H6qtOcFfaUMpCLZ2vRDnnYmkqw2efFAkEAluJMSAX1IwBG6tPNa7cK88DaQvBkKodOWNiXGYuLY3+x3KoMIqUQs1SiosdIJregrJ1Uo4akCTPBKOlHGuYEBQJAeAUNAs5VqC+oajPFUmaCYbLLdjZJ4jCTW+Y385/8RSA1QFfQjey/BkN3YCmWPfUuxw2cVwwyzWUUe9iCQqAa2QJAfssES0IC5IqRBCb2ppyeFfiZIqdeWfVn2IFAHmjTAbGs38Emoc4LYbpSCuF4L/vVW2EwNM9CcP9uOhxkqyOqAQ==";
    
    // 生成订单信息
    Order *order = [[Order alloc]init];
    
    order.partner = partnerID;
    order.sellerID = sellerId;
    order.outTradeNO = @"123456";
    order.totalFee = @"100";
    
    order.service = @"mobile.securitypay.pay";
    order.inputCharset = @"utf-8";
    order.notifyURL = @"www.xxx.com";
    
    // 将订单信息生成待签名字符串
    NSString *orderSpec = order.description;
    
    //签名
    id<DataSigner> datasigner =  CreateRSADataSigner(privatekey);
    
    NSString *signString = [datasigner signString:orderSpec];
    
    //将签名格式化为订单字符串
    NSString *orderStr = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec,signString,@"RSA"];
    
    NSLog(@"=%@",orderStr);
    
    AlipaySDK *alipay = [AlipaySDK defaultService];
    
    [alipay payOrder:orderStr fromScheme:@"mypay" callback:^(NSDictionary *resultDic) {
       
        NSLog(@"result = %@",resultDic);
        
    }];
    
}

@end
