// clang -framework Foundation -fobjc-arc MAStringWithFormat.m main.m

#import <Foundation/Foundation.h>

#import "MAStringWithFormat.h"

void testStringWithFormat();
void testRanges();

int main(int argc, char **argv)
{
   // testStringWithFormat();
    testRanges();
}

void testStringWithFormat() {
    #define TEST(expected, ...) do { \
        NSString *actual = MAStringWithFormat(__VA_ARGS__); \
        if(![(expected) isEqual: actual]) { \
            NSLog(@"FAILURE! Expected %@ got %@", expected, actual); \
        } \
        else { \
            NSLog(@"Passed test: %@", expected); \
        } \
    } while(0)
    
    TEST(@"Abcd", @"Abcd");
    
    TEST(@"AB 42 CD", @"AB %d CD", 42);
    TEST(@"0", @"%d", 0);
    TEST(@"2147483647", @"%d", 2147483647);
    TEST(@"123456789", @"%d%d%d%d%d%d%d%d%d", 1, 2, 3, 4, 5, 6, 7, 8, 9);
    TEST(@"-1", @"%d", -1);
    TEST(@"-2147483648", @"%d", INT_MIN);
    
    TEST(@"1", @"%ld", 1L);
    TEST(sizeof(long) == 8 ? @"9223372036854775807" : @"2147483647", @"%ld", LONG_MAX);
    TEST(@"-1", @"%ld", -1L);
    TEST(@"1", @"%lld", 1LL);
    TEST(@"9223372036854775807", @"%lld", LLONG_MAX);
    TEST(@"-9223372036854775808", @"%lld", LLONG_MIN);
    
    TEST(@"4294967295", @"%u", -1);
    TEST(sizeof(long) == 8 ? @"18446744073709551615" : @"4294967295", @"%lu", -1L);
    TEST(@"18446744073709551615", @"%llu", -1L);
    
    TEST(@"INFINITY", @"%f", INFINITY);
    TEST(@"-INFINITY", @"%f", -INFINITY);
    TEST(@"NaN", @"%f", NAN);
    TEST(@"1.0", @"%f", 1.0);
    TEST(@"0.5", @"%f", 0.5);
    TEST(@"1.5", @"%f", 1.5);
    
    TEST(@"42.0", @"%f", 42.0);
    TEST(@"0.625", @"%f", 0.625);
    TEST(@"42.625", @"%f", 42.625);
    TEST(@"0.2000000000000000104", @"%f", 0.2);
    TEST(@"-1.0", @"%f", -1.0);
    TEST(@"0.0", @"%f", 0.0);
    
    TEST(@"10000000000000000400000000000000000000000.0", @"%f", 1e40);
    
    TEST(@"0.0000000000000000000000000000000000000000999999999999999907", @"%f", 1e-40);
    
    TEST(@"hello", @"%s", "hello");
    TEST(@"hello", @"%@", @"hello");
    TEST(@"(\n    hello\n)", @"%@", @[ @"hello" ]);
    
    TEST(@"%", @"%%");
    
    TEST(@"", @"%");
    TEST(@"", @"%l");
    TEST(@"", @"%ll");
}

BOOL compareRanges(NSArray *expected, NSArray *actual);

void testRanges() {
    #define TEST_RANGE(expectedString, expectedRanges, ...) do { \
        MAStringAndTokenRanges *actual = MAStringAndTokenRangesWithFormat(__VA_ARGS__); \
        if(![(expectedString) isEqual: actual.string]) { \
            NSLog(@"FAILURE! Expected %@ got %@", expectedString, actual.string); \
        } \
        else if(!compareRanges(expectedRanges, actual.tokenRanges)) { \
            NSLog(@"FAILURE! Expected %@ got %@", expectedRanges, actual.tokenRanges); \
        } \
        else { \
            NSLog(@"Passed test: %@", expectedString); \
        } \
        } while(0);

    TEST_RANGE(@"foo 1", @[[NSValue valueWithRange:NSMakeRange(4, 1)]], @"foo %d", 1);
    TEST_RANGE(@"foo 1.5", @[[NSValue valueWithRange:NSMakeRange(4, 3)]], @"foo %f", 1.5);
    TEST_RANGE(@"foo bar", @[[NSValue valueWithRange:NSMakeRange(4, 3)]], @"foo %@", @"bar");
    TEST_RANGE(@"foo bar", @[[NSValue valueWithRange:NSMakeRange(4, 3)]], @"foo %s", "bar");
    
    TEST_RANGE(@"-1", @[[NSValue valueWithRange:NSMakeRange(0, 2)]], @"%ld", -1L);
    TEST_RANGE(@"1", @[[NSValue valueWithRange:NSMakeRange(0, 1)]], @"%lld", 1LL);
    
    TEST_RANGE(@"%", @[], @"%%");

    NSArray *ranges = @[[NSValue valueWithRange:NSMakeRange(4, 3)],[NSValue valueWithRange:NSMakeRange(8, 3)]];
    TEST_RANGE(@"foo bar baz", ranges, @"foo %@ %@", @"bar", @"baz");
}

BOOL compareRanges(NSArray *expected, NSArray *actual) {
    return [expected isEqualToArray:actual];
}
