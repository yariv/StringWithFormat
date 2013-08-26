MAStringWithFormat
==================

This fork of MAStringWithFormat is based on Mike Ash's [MAStringWithFormat](https://github.com/mikeash/StringWithFormat). MAStringWithFormat provides a couple of methods that you may find useful.

    NSString *MAStringWithFormat(NSString *format, ...);
 
This is an open source implementation of [NSString stringWithFormat:(NSString *, ...).

    MAStringAndTokenRanges *MAStringAndTokenRangesWithFormat(NSString *format, ...);

This function returns an array of NSRange values, one per token, in addition to the formatted string. Each NSRange value indicates the location in the formatted string into which the NSRange's corresponding token was spliced. This is particularly useful in conjunction with UIAttributedText or [TTTAttributedLabel](https://github.com/mattt/TTTAttributedLabel), where you may want to apply specific styling to a token or turn it into a link.

Example
=======
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    label.delegate = self;
    MAStringAndTokenRanges *result = MAStringAndTokenRangesWithFormat(@"I love visiting %@.", @"github.com");
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:result.string];
    label.text = text;
    [label addLinkToURL:[NSURL URLWithString:@"http://github.com"] withRange:[result.tokenRanges[0] rangeValue]];
    [self.view addSubview:label];
