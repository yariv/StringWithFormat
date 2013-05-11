#import "MAStringWithFormat.h"

@interface MAStringFormatter : NSObject

- (NSString *)format: (NSString *)format arguments: (va_list)arguments;

@end

NSString *MAStringWithFormat(NSString *format, ...)
{
    va_list arguments;
    va_start(arguments, format);
    
    MAStringFormatter *formatter = [[MAStringFormatter alloc] init];
    NSString *result = [formatter format: format arguments: arguments];
    
    va_end(arguments);
    
    return result;
}

@implementation MAStringFormatter {
    va_list _arguments;
    
    CFStringInlineBuffer _formatBuffer;
    NSUInteger _formatLength;
    NSUInteger _cursor;
    
    NSMutableString *_output;
}

- (NSString *)format: (NSString *)format arguments: (va_list)arguments
{
    _formatLength = [format length];
    CFStringInitInlineBuffer((__bridge CFStringRef)format, &_formatBuffer, CFRangeMake(0, _formatLength));
    _output = [NSMutableString string];
    _cursor = 0;
    
    int c;
    while((c = [self read]) >= 0)
    {
        if(c != '%')
        {
            [self write: c];
        }
        else
        {
            int next = [self read];
            if(next < 0)
            {
                [self write: c];
                break;
            }
            
            if(next == 'd')
            {
                int value = va_arg(arguments, int);
                [self writeInt: value];
            }
        }
    }
    
    return _output;
}

- (void)writeInt: (int)value
{
    int cursor = 1;
    while(value / cursor >= 10)
        cursor *= 10;
    
    while(cursor > 0)
    {
        int digit = value / cursor;
        [self write: '0' + digit];
        value -= digit * cursor;
        cursor /= 10;
    }
}

- (int)read
{
    if(_cursor < _formatLength)
        return CFStringGetCharacterFromInlineBuffer(&_formatBuffer, _cursor++);
    else
        return -1;
}

- (void)write: (unichar)c
{
    [_output appendFormat: @"%C", c];
}

@end