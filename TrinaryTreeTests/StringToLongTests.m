//
//  StringToLongTests.m
//  TrinaryTree
//
//  Created by Philip Leder on 4/3/14.
//
//

#import <XCTest/XCTest.h>
#import "XCTestCase+Util.h"
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
        int charMuliplier = (self.length-1)-x;
        
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
//Assert TRUE
    NSString *longString = @"4129";
    long long desiredResult = 4129;
    long stringLonged = [longString toLong];
    XCTAssertTrue(stringLonged == desiredResult, @"Coversion Failed Actual:%ld Expected:%lld", stringLonged, desiredResult);
    
    long iOSResult = [longString toLong];
    XCTAssertTrue(stringLonged == iOSResult, @"Apple thinks you are wrong!:%ld Expected:%ld", stringLonged, iOSResult);

    //I like to put random things in tests.  Not grouped together with unit or integration tests, but in stress tests.  They offer some coverage for the unknown or unthought-of bugs.
    for(int x=100;x>0;x--)
    {
        //Random
        long randomTestNumber = [self getRandomNumberBetween:0 maxNumber:LONG_MAX];
        longString = [NSString stringWithFormat:@"%ld", randomTestNumber];
        stringLonged = [longString toLong];
        
        XCTAssertTrue(randomTestNumber == stringLonged, @"Random number:%@ Failed.", longString);
        
        iOSResult = [longString toLong];
        XCTAssertTrue(stringLonged == iOSResult, @"Apple thinks you are wrong!:%ld Expected:%ld", stringLonged, iOSResult);
    }
    
//Assert FALSE
    //They don't match.
    desiredResult = 4129;
    longString = @"9999";
    stringLonged = [longString toLong];
    XCTAssertFalse(stringLonged == desiredResult, @"Coversion SHOULD Fail Actual:%ld Expected:%lld", stringLonged, desiredResult);
    
    //Special characters!???
    desiredResult = 4129;
    longString = @"4129&";
    stringLonged = [longString toLong];
    XCTAssertFalse(stringLonged == desiredResult, @"Coversion SHOULD Fail Actual:%ld Expected:%lld", stringLonged, desiredResult);
}

@end
