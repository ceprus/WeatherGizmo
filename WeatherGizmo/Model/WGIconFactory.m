//
//  WGIconFactory.m
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 18.09.15.
//  Copyright (c) 2015 rsbw. All rights reserved.
//

#import "WGIconFactory.h"

// Extern
long const WGWeatherIconSkyIsClear = 800;


@implementation WGIconFactory

// http://openweathermap.org/weather-conditions

- (NSImage *)imageWithWeatherId:(long)weatherId
                       withDate:(NSDate *)datetime
                       andStyle:(WGWeatherIconStyle)style;
{
    // Weather icon without sun or moon
    BOOL gloomy = NO;
    
    // Weather Id
    NSString *weatherName;
    
    switch (weatherId) {
        
        case 200:	// гроза с дождем света
        case 201:	// гроза с дождем
        case 202:	// гроза с сильным дождем
        case 210:	// свет гроза
        case 211:	// гроза
        case 212:	// гроза
        case 221:	// рваный гроза
        case 230:	// гроза с дождем света
        case 231:	// гроза с дождем
        case 232:	// гроза с сильным дождем
            
            weatherName = @"storm";
            gloomy = YES;
            break;
        
        // Морось =======================
        case 300:	// мелкий дождь интенсивности
        case 301:	// морось
        case 302:	// тяжелый дождь интенсивности
        case 310:	// Интенсивность света дождь дождь
        case 311:	// дождь дождь
        case 312:	// тяжелая интенсивность дождь дождь
        case 313:	// ливень и дождь
        case 314:	// сильный дождь душ и дождь
        case 321:	// душ дождь
            
            weatherName = @"rain";
            gloomy = YES;
            break;
        
        // Дождь =======================
        case 500:	// легкий дождь
        case 501:	// небольшой дождь
        case 502:	// сильный дождь интенсивности
        case 503:	// очень сильный дождь
        case 504:	// крайняя дождь
            
            weatherName = @"rain";
            break;
            
        case 511:	// ледяной дождь
            
            weatherName = @"snow";
            gloomy = YES;
            break;
            
        case 520:	// Интенсивность света ливень
        case 521:	// ливень
        case 522:	// тяжелая интенсивность ливень
        case 531:	// рваный ливень
            
            weatherName = @"rain";
            gloomy = YES;
            break;
        
        // Снег =======================
        case 600:	// небольшой снег
        case 601:	// снег
        case 602:	// сильный снегопад
        case 611:	// дождь со снегом
        case 612:	// душ мокрый снег
        case 615:	// дождь и снег
        case 616:	// дождь со снегом
        case 620:	// свет душ снег
        case 621:	// душ снег
        case 622:	// сильный снег душ
            
            weatherName = @"snow";
            gloomy = YES;
            break;
        
        // Атмосфера =======================
        case 701:	// туман
        case 711:	// дым
        case 721:	// дымка
        case 731:	// песок, пыль кружится
        case 741:	// туман
        case 751:	// песок
        case 761:	// пыли
        case 762:	// вулканический пепел
        case 771:	// шквалы
        case 781:	// торнадо
            
            weatherName = @"fog";
            gloomy = YES;
            break;
        
        // Облака =======================
        case WGWeatherIconSkyIsClear:	// чистое небо
            
            weatherName = @"";
            break;
            
        case 801:	// Несколько облака
        case 802:	// рассеянные облака
            
            weatherName = @"cloud";
            break;
            
        case 803:	// разорванные облака
        case 804:	// пасмурно облака
            
            weatherName = @"cloud";
            gloomy = YES;
            break;
        
        // Крайняя =======================
        case 900:	// торнадо
        case 901:	// тропическая буря
        case 902:	// ураган
        case 903:	// холодный
        case 904:	// горячий
        case 905:	// ветреный
        case 906:	// град
            
            weatherName = @"";
            break;
        
        // Дополнительный ==================
        case 951:	// спокойствие
        case 952:	// легкий ветер
        case 953:	// нежный бриз
        case 954:	// умеренный ветер
        case 955:	// свежий ветер
        case 956:	// сильный ветер
        case 957:	// Сильный ветер, ветер рядом
        case 958:	// буря
        case 959:	// тяжелая ветер
        case 960:	// буря
        case 961:	// сильный шторм
        case 962:	// ураган
            
            weatherName = @"windfast";
            break;
            
        default:
            NSLog(@"Unknown weatherId code (%s)", __func__);
            break;
    }
    
    
    // Datetime
    NSString *sunMoon;
    
    if (gloomy) {
        sunMoon = @"";
        
    } else {
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *components = [cal components: NSCalendarUnitHour fromDate: datetime];
        NSInteger hour = [components hour];
        
        sunMoon = (hour > 6 && hour < 22) ? @"sun" : @"moon";
    }


    // Style
    NSString *iconStyle = (style == WGWeatherIconStyleGray) ? @"gray_" : @"light_";
    
    
    return [NSImage imageNamed: [NSString stringWithFormat: @"%@%@%@", iconStyle, weatherName, sunMoon]];
}


@end
