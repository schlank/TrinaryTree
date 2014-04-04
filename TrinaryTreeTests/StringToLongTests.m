//
//  StringToLongTests.m
//  TrinaryTree
//
//  Created by Philip Leder on 4/3/14.
//
//

#import <XCTest/XCTest.h>

@interface NSString (StringToLong)

- (long)toLong;

@end

@implementation NSString (StringToLong)

- (long)toLong
{
    long  stringLongedResult = 0;
    for(int x=0;x<=self.length-1;x++)
    {
        unichar currentChar = [self characterAtIndex:x];
        //Convert to the numerical value. 1=49 2=50
        long numberValue = (currentChar-48);
        
        //Multiplier by character index backwards.
        int charMuliplier = (self.length - 1) - x;
        
        //This character (10 tothe power of charMuliplier) * numberValue
        int floatOffset = pow(10,charMuliplier) * numberValue;

        stringLongedResult += floatOffset;
    }
    return stringLongedResult;
}

@end


@interface StringToLongTests : XCTestCase

@end

@implementation StringToLongTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStringToLongCategory
{
    NSString *longString = @"4129";
    long long desiredResult = 4129.0;
    
    long stringLonged = [longString toLong];
    XCTAssertTrue(stringLonged == desiredResult, @"Coversion Failed Actual:%ld Expected:%lld", stringLonged, desiredResult);
    
    desiredResult = 4129.0;
    longString = @"9999";
    stringLonged = [longString toLong];
    XCTAssertFalse(stringLonged == desiredResult, @"Coversion SHOULD Fail Actual:%ld Expected:%lld", stringLonged, desiredResult);
}

@end
