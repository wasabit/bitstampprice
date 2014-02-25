//
//  AppDelegate.m
//  Bitstamp Price
//
//  Created by Sebas on 25/02/14.
//  Copyright (c) 2014 WasabitLabs. All rights reserved.
//

#import "AppDelegate.h"
#import "Bitstamp.h"

@interface AppDelegate()
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) Bitstamp *bitstamp;
@property (nonatomic) float lastPrice;
@property (nonatomic) float timeInterval;
@end

@implementation AppDelegate

- (id) init
{
    self = [super init];
    if (self) {
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        NSString *plistPath;

        plistPath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];

        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                              propertyListFromData:plistXML
                                              mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                              format:&format
                                              errorDescription:&errorDesc];
        if (!temp) {
            NSLog(@"Error reading plist: %@, format: %lu", errorDesc, format);
        }
        self.timeInterval = [[temp objectForKey:@"Interval"] floatValue];

    }
    return self;
}

- (Bitstamp *)bitstamp
{
    if (!_bitstamp) _bitstamp = [[Bitstamp alloc] init];

    return _bitstamp;
}

- (float)lastPrice
{
    if (!_lastPrice) _lastPrice = 0;

    return _lastPrice;
}

- (void)awakeFromNib
{
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];

    [[self statusItem] setMenu:[self menu]];
    [[self statusItem] setToolTip:@"Bitstamp Price"];

    self.timer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(update) userInfo:Nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self update];
}

- (void)update
{
    NSAttributedString *title;
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    double price;
    NSColor *foreColor;

    price = [self.bitstamp price];

    if (price > self.lastPrice) {
        foreColor = [NSColor greenColor];
    } else if (price < self.lastPrice) {
        foreColor = [NSColor redColor];
    } else {
        foreColor = [NSColor whiteColor];
    }

    [attributes setObject:foreColor forKey:NSForegroundColorAttributeName];
    [attributes setObject:[NSColor blackColor] forKey:NSBackgroundColorAttributeName];

    NSFont *font = [NSFont systemFontOfSize:14];
    [attributes setObject:font forKey:NSFontAttributeName];


    title = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%.2f", price]
                                            attributes:attributes];
    [[self statusItem] setAttributedTitle: title];

    self.lastPrice = price;

    NSLog(@"%f", price);
}
@end
