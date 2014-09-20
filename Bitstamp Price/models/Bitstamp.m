//
//  Bitstamp.m
//  Bitstamp Price
//
//  Created by Sebas on 25/02/14.
//  Copyright (c) 2014 WasabitLabs. All rights reserved.
//

#import "Bitstamp.h"

@implementation Bitstamp

- (NSData *)ticker
{
    NSURL *url = [NSURL URLWithString:@"https://www.bitstamp.net/api/ticker/"];

    NSData *jsonData = [NSData dataWithContentsOfURL:url];

    return jsonData;
}

- (float)price
{
    float price_value = 0;

    NSData *jsonData = [self ticker];

    if(jsonData != nil) {
        NSError *error = nil;

        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];

        if (error == nil)
            price_value = [result[@"last"] floatValue];
    }

    return price_value;
}
@end
