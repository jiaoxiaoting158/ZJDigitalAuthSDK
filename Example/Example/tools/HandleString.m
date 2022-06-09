//
//  HandleNull.m
//  Example
//
//  Created by jiaoxt on 2021/5/6.
//

#import "HandleString.h"

@implementation HandleString
+ (NSString *)handleNull:(NSString *)str{
    if ([str isKindOfClass:[NSNull class]]) {
        str = @"";
    }
    else if (![str isKindOfClass:[NSString class]]) {
        str = @"";
    }
    else if (str == nil) {
        str = @"";
    }
    else if ([str isEqualToString:@"null"]) {
        str = @"";
    }
    else if ([str isEqualToString:@"(null)"]) {
        str = @"";
    }
    else if ([str isEqualToString:@"<null>"]) {
        str = @"";
    }
    return str;
}
@end
