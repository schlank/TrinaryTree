//
//  TrinaryTreeTests.m
//  TrinaryTreeTests
//
//  Created by Philip Leder on 3/31/14.
//  Testing Repo: https://github.com/schlank/TrinaryTree
//
//

#import <XCTest/XCTest.h>

//Class in test
#import "TrinaryTree.h"
#import "Node.h"
/**
 I love it when the test class uses a delegate.  It makes verification tests possible without mocking.
 Just make the XCTestCase a delegate, and the functions are called on the XCTestCase class!
 **/

@interface TrinaryTreeTests : XCTestCase <TrinaryTreeDelegate>

@property (nonatomic, retain) id<TrinaryTreeDelegate> delegate;
@property (nonatomic, strong) TrinaryTree *trinaryTree;

@end

@implementation TrinaryTreeTests

- (void)setUp
{
    [super setUp];
    self.trinaryTree = [[TrinaryTree alloc] init];
    self.trinaryTree.delegate = self;
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.trinaryTree.delegate = nil;
    self.trinaryTree = nil;
}

- (NSArray*)treeTestNumbersWithKey:(NSString*)testKey
{
    //Test data will be loaded from a plist file and be loaded into the tree.
    NSString *settingsPListPath = [[NSBundle mainBundle] pathForResource:@"TestTrees" ofType:@"plist"];
    NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:settingsPListPath];
    return [settingsDictionary objectForKey:testKey];
}

#pragma mark - TrinaryTreeDelegate Methods

- (void)trinaryTreeDidInsertNode:(Node *)aNode
{
    
}

- (void)trinaryTreeWillDeleteNode:(Node *)aNode
{
    
}

#pragma mark - Tests

/**
As a mobile dev, I'd like to implement the insert and delete methods of a tri-nary tree.

 Acceptance:
 1. Insert is implemented and tested.
 2. Delete is implemented and tested.
 3. Maintain integrity of Trinary Tree.
 
 //  Test Verificaion Criteria
    1. the left node being values < parent
    2. the right node values > parent
    3. the middle node values == parent
 
 
 Tests:
 testInsert
 **/

- (void)testA1_insert_usingStandardTestData
{
    NSArray *standardTree = [self treeTestNumbersWithKey:@"standard"];

    [standardTree enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Node *newNode = [[Node alloc] init];
        newNode.nodeContent = [standardTree objectAtIndex:idx];
        [self.trinaryTree insertNode:newNode];
    }];
    
    
//Now the challenge presents itself. :)
//We added all the test data to the tree, but how do we verify the correct results to our specifications as follows?
//    1. left node being values < parent
//    2. the right node values > parent
//    3. the middle node values == parent
// We must be able to traverse the whole Tree.
    /**
     
     Options:
        1.  Traverse the Tree recursively here in the test.
            Nah: A bit messy and complicated for a test.
        2.  Implement a function on TrinaryTreeTests to return the Tree in a NSArray (list).  Order will not matter, since the nodes will still maintain their references to each other.  In order to keep code that is un-used in production out of production code, we can use a Category to add the function for testing.
            No: It does not feel clean enough.  A bit heavy passing around an Array.
        3.  Implement an enumaration with a block function similar to the NSArray function enumerateObjectsUsingBlock.  This will allow us to walk the tree fully right here in the test class.
            Yes: Underpands Check - Profit
     
     Getting late.  More tomorrow.
     **/

}

- (void)testA2_DelegateMethods
{
    XCTFail(@"not implemented yet.");
}

- (void)testA3_Delete
{
    XCTFail(@"not implemented yet.");
}

@end
