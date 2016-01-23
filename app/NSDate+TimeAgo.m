//
//  NSDate+TimeAgo.m
//  TheApp
//
//  Created by Joel Oliveira on 8/29/13.
//  Copyright (c) 2013 Notificare. All rights reserved.
//

#import "NSDate+TimeAgo.h"

@implementation NSDate (TimeAgo)


-(NSString *)timeAgo {
    NSDate *now = [NSDate date];
    double deltaSeconds = fabs([self timeIntervalSinceDate:now]);
    double deltaMinutes = deltaSeconds / 60.0f;
    
    if(deltaSeconds < 5) {
        return NSLocalizedString(@"just_now", @"text for just now");
    } else if(deltaSeconds < 60) {
        return [NSString stringWithFormat:NSLocalizedString(@"seconds_ago", @"format placeholder for seconds ago"), (int)deltaSeconds];
    } else if(deltaSeconds < 120) {
        return NSLocalizedString(@"minute_ago", @"text for a minute ago");
    } else if (deltaMinutes < 60) {
        return [NSString stringWithFormat:NSLocalizedString(@"minutes_ago", @"format placeholder for minutes ago"), (int)deltaMinutes,NSLocalizedString(@"minutes", @"text for minutes")];
    } else if (deltaMinutes < 120) {
        return NSLocalizedString(@"hour_ago", @"text for a hour ago");
    } else if (deltaMinutes < (24 * 60)) {
        return [NSString stringWithFormat:NSLocalizedString(@"hours_ago", @"format placeholder for hours ago"), (int)floor(deltaMinutes/60)];
    } else if (deltaMinutes < (24 * 60 * 2)) {
        return NSLocalizedString(@"yesterday", @"text for yesterday");
    } else if (deltaMinutes < (24 * 60 * 7)) {
        return [NSString stringWithFormat:NSLocalizedString(@"days_ago", @"format placeholder for days ago"), (int)floor(deltaMinutes/(60 * 24))];
    } else if (deltaMinutes < (24 * 60 * 14)) {
        return NSLocalizedString(@"last_week", @"text for last week");
    } else if (deltaMinutes < (24 * 60 * 31)) {
        return [NSString stringWithFormat:NSLocalizedString(@"weeks_ago", @"format placeholder for weeks ago"), (int)floor(deltaMinutes/(60 * 24 * 7))];
    } else if (deltaMinutes < (24 * 60 * 61)) {
        return NSLocalizedString(@"last_month", @"text for last month");
    } else if (deltaMinutes < (24 * 60 * 365.25)) {
        return [NSString stringWithFormat:NSLocalizedString(@"months_ago", @"format placeholder for months ago"), (int)floor(deltaMinutes/(60 * 24 * 30))];
    } else if (deltaMinutes < (24 * 60 * 731)) {
        return NSLocalizedString(@"last_year", @"text for last year");
    }
    return [NSString stringWithFormat:NSLocalizedString(@"years_ago", @"format placeholder for years ago"), (int)floor(deltaMinutes/(60 * 24 * 365))];
}

@end

