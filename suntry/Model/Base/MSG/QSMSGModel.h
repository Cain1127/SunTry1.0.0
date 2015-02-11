//
//  QSMSGModel.h
//  suntry
//
//  Created by 王树朋 on 15/2/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

/*!
 *  @author wangshupeng, 15-02-11 18:02:20
 *
 *  @brief  请求服务端返回的列表数据msg基本数据模型
 *
 *  @since  1.0.0
 */
@interface QSMSGModel : QSBaseModel

@property (nonatomic,copy) NSString *total_page;    //!<总页数
@property (nonatomic,copy) NSString *total_num;     //!<总的记录数
@property (nonatomic,copy) NSString *page_num;      //!<每一页的记录数量
@property (nonatomic,copy) NSString *before_page;   //!<前一页页码
@property (nonatomic,copy) NSString *per_page;      //!<当前页
@property (nonatomic,copy) NSString *next_page;     //!<下一页页码

@end
