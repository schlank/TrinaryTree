//
//  XCTestCase+Util.m
//  TrinaryTree
//
//  Created by Philip Leder on 4/4/14.
//
//

#import "XCTestCase+Util.h"

@implementation XCTestCase (Util)

//http://stackoverflow.com/questions/9678373/generate-random-numbers-between-two-numbers-in-objective-c
- (NSInteger)getRandomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
    return min + arc4random() % (max - min + 1);
}

@end
