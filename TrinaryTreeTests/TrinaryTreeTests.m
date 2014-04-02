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


//Test Friend Category
@interface TrinaryTree (EnumerateWithBlock)

- (void)enumerateNodesUsingBlock:(void (^)(Node *node, BOOL *stop))block andRootNode:(Node*)currentNode;
- (int)nodeCount;

@end

@implementation TrinaryTree (EnumerateWithBlock)

- (void)enumerateNodesUsingBlock:(void (^)(Node *node, BOOL *stop))block andRootNode:(Node*)currentNode
{
    if(currentNode==nil)
        currentNode = self.rootNode;
    block(currentNode, NO);
    if(currentNode.leftNode)
        [self enumerateNodesUsingBlock:block andRootNode:currentNode.leftNode];
    if(currentNode.middleNode)
        [self enumerateNodesUsingBlock:block andRootNode:currentNode.middleNode];
    if(currentNode.rightNode)
        [self enumerateNodesUsingBlock:block andRootNode:currentNode.rightNode];
}

- (int)nodeCount
{
    __block int count = 0;
    [self enumerateNodesUsingBlock:^(Node *node, BOOL *stop) {
        count++;
    } andRootNode:self.rootNode];
    return count;
}

@end


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
    if(!settingsDictionary)
    {
        XCTFail(@"The Test Trees Plist has the wrong path or is not targeted on the app target TrinaryTree.");
    }
    return [settingsDictionary objectForKey:testKey];
}

- (void)insertTestNumbersWithKey:(NSString*)testKey
{
    NSArray *standardTree = [self treeTestNumbersWithKey:@"standard"];
    [standardTree enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Node *newNode = [[Node alloc] init];
        newNode.nodeContent = (NSNumber*)obj;
        
        NSLog(@"insertNode: %@", newNode.nodeContent);
        [self.trinaryTree insertNode:newNode];
    }];
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
 
 //  Test Verificaion Criteria.
    1. the left node being values < parent
    2. the right node values > parent
    3. the middle node values == parent
 
 
 Tests:
 testInsert
 testDelete
 **/

- (void)testA1_insert_usingStandardTestData
{
    NSArray *standardTree = [self treeTestNumbersWithKey:@"standard"];

    [standardTree enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Node *newNode = [[Node alloc] init];
        newNode.nodeContent = (NSNumber*)obj;
        
        NSLog(@"insertNode: %@", newNode.nodeContent);
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
        
        3.  Implement an enumaration with a block function similar to the NSArray function enumerateObjectsUsingBlock on our Node class.  This will allow us to walk the tree fully right here in the test class.  We can make this a category for now, but it has the potential to be promoted to production code.  Why?  Because it could replace functionality in production with more re-usable code.
        Yes: Underpands Check - Profit
     
     **/
    
    //Our custom Node enumerator
    [self.trinaryTree enumerateNodesUsingBlock:^(Node *node, BOOL *stop) {
        NSLog(@"enumerateNodesUsingBlock: %@", node.nodeContent);
        if(node.leftNode)
            XCTAssertTrue([node.leftNode.nodeContent intValue] < [node.nodeContent intValue], @"Left Node are greater than Parent. Parent:%@ leftNode:%@", node.nodeContent, node.leftNode.nodeContent);
        if(node.rightNode)
            XCTAssertTrue([node.rightNode.nodeContent intValue]>[node.nodeContent intValue], @"Right Node is Less than Parent. Parent:%@ leftNode:%@", node.nodeContent, node.rightNode.nodeContent);
        if(node.middleNode)
            XCTAssertTrue([node.middleNode.nodeContent intValue] == [node.nodeContent intValue], @"Middle Node is not Equal to Parent:%@ middle node:%@", node.nodeContent, node.middleNode.nodeContent);
        } andRootNode:self.trinaryTree.rootNode];
}

/*
 How to test our Delete...
    1.  We will still want to maintain our 3 laws up above, so we'll test those after a delete operation.
    2.  We will also want to remove multiple times with a variety of tree sizes and numbers.
    3.  Lets keep track of the count after each delete as well.  If we remove one and the count went doen 2, we have a problem.
 
 */

- (void)testA2_Delete
{
    XCTFail(@"not implemented yet.");
}

//I like to make sure my category count function is correct.
- (void)testA3_treeCount
{
    NSArray *standardTree = [self treeTestNumbersWithKey:@"standard"];
    [standardTree enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Node *newNode = [[Node alloc] init];
        newNode.nodeContent = (NSNumber*)obj;
        NSLog(@"insertNode: %@", newNode.nodeContent);
        [self.trinaryTree insertNode:newNode];
    }];
    XCTAssertTrue([standardTree count] == [self.trinaryTree nodeCount], @"Our node count is off!  Check your insert code and tests.");
    
}

@end
