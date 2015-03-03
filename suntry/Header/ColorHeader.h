//
//  QSColor.h
//  suntry
//
//  Created by 王树朋 on 15/2/2.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#ifndef suntry_ColorHeader_h
#define suntry_ColorHeader_h

///返回一个给定透明度的颜色
#define COLOR_RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

///返回一个不透明RGB颜色
#define COLOR_RGB(r,g,b) COLOR_RGBA(r,g,b,1.0f)

#define COLOR_RGBH(r,g,b) COLOR_RGBA(r,g,b,0.5f)

///将十六进制颜色转化为RGB颜色
#define COLOR_HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

///十六进制颜色转为半透明RGB颜色
#define COLOR_HEXCOLORH(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:a]

///肝红色
#define COLOR_CHARACTERS_RED COLOR_HEXCOLOR(0x812E3D)

///边线颜色(银色)
#define COLOR_CHARACTERS_ROOTLINE     [UIColor colorWithRed:0.505 green:0.513 blue:0.525 alpha:1.000]
///浅黄色
#define COLOR_CHARACTERS_YELLOW   [UIColor colorWithRed:214.0f / 255.0f green:205.0f / 255.0f blue:188.0f / 255.0f alpha:1.0f]

#endif
