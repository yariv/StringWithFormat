#import <Foundation/Foundation.h>

@interface MAStringAndTokenRanges : NSObject

@property(nonatomic, copy) NSString *string;
@property(nonatomic, copy) NSArray *tokenRanges;

@end

/**
 * A clone of [NSString stringWithFormat:(NSString *format, ...);
 */
NSString *MAStringWithFormat(NSString *format, ...);

/**
 * Similar to MAStringWithFormat() but, in addition to returning the
 * formatted string, this function returns an array of NSRange values,
 * one per token. Each NSRange indicates where its corresponding token
 * was spliced into the formatted string.
 * This can be particularly useful when you want render the result
 * string as a NSAttributedString and apply special formatting to
 * specific token values.
 */
MAStringAndTokenRanges *MAStringAndTokenRangesWithFormat(NSString *format, ...);
