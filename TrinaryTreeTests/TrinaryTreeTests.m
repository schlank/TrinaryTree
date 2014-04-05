//
//  TrinaryTreeTests.m
//  TrinaryTreeTests
//
//  Created by Philip Leder on 3/31/14.
//  Testing Repo: https://github.com/schlank/TrinaryTree
//
//

#import <XCTest/XCTest.h>
#import "XCTestCase+Util.h"

//Classes in test
#import "TrinaryTree.h"
#import "Node.h"



//Test Friend Category
@interface TrinaryTree (TestFriend)

- (void)enumerateNodesUsingBlock:(void (^)(Node *node, BOOL *stop))block andRootNode:(Node*)currentNode;
- (int)nodeCount;

@end

@implementation TrinaryTree (TestFriend)

- (void)enumerateNodesUsingBlock:(void (^)(Node *node, BOOL *stop))block andRootNode:(Node*)currentNode
{
    if(self.rootNode==nil)
        return;
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


@interface TrinaryTreeTests : XCTestCase

@property (nonatomic, strong) TrinaryTree *trinaryTree;

@end

@implementation TrinaryTreeTests

- (void)setUp
{
    [super setUp];
    self.trinaryTree = [[TrinaryTree alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.trinaryTree.delegate = nil;
    self.trinaryTree = nil;
}

//Fetch our test data by key from our test plist file.
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

//Populate our test tree from a plist by a test key
- (void)populateTestTreeWithKey:(NSString*)testKey
{
    //Reset the tree.
    self.trinaryTree = nil;
    self.trinaryTree = [[TrinaryTree alloc] init];
    NSArray *standardTree = [self treeTestNumbersWithKey:@"standard"];
    [standardTree enumerateObjectsUsingBlock:^(NSNumber *num, NSUInteger idx, BOOL *stop) {
        Node *newNode = [Node nodeWithNumber:num];
        NSLog(@"insertNode: %@", newNode.nodeContent);
        [self.trinaryTree insertNode:newNode];
    }];
}

//This verifies our 3 laws of Node integrity on each node in the true.  And also checks the tree count.
//1. the left node being values < parent
//2. the right node values > parent
//3. the middle node values == parent
- (void)verifyTreeIntegrity
{
    //Verify we have our tree set up and with test data.
    XCTAssertNotNil(self.trinaryTree, @"Initialize your trinaryTree!");
    XCTAssertTrue([self.trinaryTree nodeCount]>0, @"populate your trinaryTree!");
    
    Node *leftMostNode = self.trinaryTree.rootNode;
    while(leftMostNode.leftNode !=nil)
        leftMostNode = leftMostNode.leftNode;
    
    int smallestNodeValueToTest = [leftMostNode.nodeContent intValue];
    
    //Our Node Category enumerator
    [self.trinaryTree enumerateNodesUsingBlock:^(Node *node, BOOL *stop) {
        
        NSLog(@"enumerateNodesUsingBlock: %@", node.nodeContent);

        //1. the left node being values < parent
        if(node.leftNode)
            XCTAssertTrue([node.leftNode.nodeContent intValue] < [node.nodeContent intValue], @"Left Node are greater than Parent. Parent:%@ leftNode:%@", node.nodeContent, node.leftNode.nodeContent);
        
        //2. the right node values > parent
        if(node.rightNode)
            XCTAssertTrue([node.rightNode.nodeContent intValue]>[node.nodeContent intValue], @"Right Node is Less than Parent. Parent:%@ leftNode:%@", node.nodeContent, node.rightNode.nodeContent);
        
        //3. the middle node values == parent
        if(node.middleNode)
            XCTAssertTrue([node.middleNode.nodeContent intValue] == [node.nodeContent intValue], @"Middle Node is not Equal to Parent:%@ middle node:%@", node.nodeContent, node.middleNode.nodeContent);
        
        XCTAssertTrue(smallestNodeValueToTest<=[node.nodeContent intValue], @"Expected:%d Actual:%d", [node.nodeContent intValue], smallestNodeValueToTest);
        
    } andRootNode:self.trinaryTree.rootNode];
}

#pragma mark - Tests

/**
Story Definition:
 
As a mobile dev, I'd like to implement the insert and delete methods of a tri-nary tree.

 Acceptance:
 1. Insert is implemented and tested.
 2. Delete is implemented and tested.
 3. Maintain integrity of Trinary Tree.
 
 //Test Verificaion Criteria (see verifyTreeIntegrity method)
    1. the left node being values < parent
    2. the right node values > parent
    3. the middle node values == parent
 **/

//making sure our count matches our tree.
- (void)testA1_treeCount
{
    NSArray *standardTree = [self treeTestNumbersWithKey:@"standard"];
    [self populateTestTreeWithKey:@"standard"];
    XCTAssertTrue([standardTree count] == [self.trinaryTree nodeCount], @"Our node count is off!  Check your insert code and tests.");
}

//Testing the class Node's smallestNode method
- (void)testA2_smallestNode
{
    [self populateTestTreeWithKey:@"standard"];
    Node *rootNode = self.trinaryTree.rootNode;
    
    Node *leftMostNode = rootNode;
    while(leftMostNode.leftNode !=nil)
        leftMostNode = leftMostNode.leftNode;
    
    int smallestNodeValueToTest = [leftMostNode.nodeContent intValue];
    __block int expectedSmallestValue = [rootNode.nodeContent intValue];

    Node *smallestNode = [rootNode smallestNode];
    
    //Our Node Category enumerator
    [self.trinaryTree enumerateNodesUsingBlock:^(Node *node, BOOL *stop)
    {
        if(expectedSmallestValue>[node.nodeContent intValue])
            expectedSmallestValue = [node.nodeContent intValue];
    } andRootNode:rootNode];

    XCTAssertTrue(smallestNodeValueToTest<=[smallestNode.nodeContent intValue], @"[Node smallestNode] Expected:%d Actual:%d", expectedSmallestValue, [smallestNode.nodeContent intValue]);
    XCTAssertTrue(smallestNodeValueToTest<=expectedSmallestValue, @"Left most Node is not the smallest: Expected:%d Actual:%d", expectedSmallestValue, smallestNodeValueToTest);
    XCTAssertTrue([smallestNode.nodeContent intValue]<=expectedSmallestValue, @"[Node smallestNode] method failed. Left most Node is not the smallest.  Expected:%d Actual:%d", expectedSmallestValue, [smallestNode.nodeContent intValue]);
}

//Adds nodes from standard test data, and verifies tree's integrity after each add.
- (void)testA3_insertNodes
{
    NSArray *standardTree = [self treeTestNumbersWithKey:@"standard"];

    [standardTree enumerateObjectsUsingBlock:^(NSNumber *nodeNumber, NSUInteger idx, BOOL *stop) {
        Node *newNode = [[Node alloc] init];
        newNode.nodeContent = nodeNumber;
        
        NSLog(@"insertNode: %@", newNode.nodeContent);
        [self.trinaryTree insertNode:newNode];
        
        //We check every node for integrity after each add.
        [self verifyTreeIntegrity];
    }];
}

//Populates tree, removes a node, checks the count and tree integrity.  Repeats the process for every node.
- (void)testA4_deleteNode
{
     NSArray *standardTree = [self treeTestNumbersWithKey:@"standard"];
    //re-populates tree and removes a diferent node.  Until all nodes have been removed.
    [standardTree enumerateObjectsUsingBlock:^(NSNumber *nodeNumber, NSUInteger idx, BOOL *stop) {

        //Populate the tree.
        [self populateTestTreeWithKey:@"standard"];
        [self verifyTreeIntegrity];
        
        int startingCount = [self.trinaryTree nodeCount];
        Node *nodeToDelete= [self.trinaryTree.rootNode nodeWithValue:[nodeNumber intValue]];
        NSLog(@"nodeNumber:%@",nodeNumber);
        [self.trinaryTree deleteNode:nodeToDelete];
        
        //Making sure we maintain our 3 laws of node integrity
        [self verifyTreeIntegrity];
        
        NSLog(@"Testing removal of node:%@ Index:%i",nodeToDelete.nodeContent, idx);
        NSLog(@"%i  [self.trinaryTree nodeCount]:%i", startingCount-idx, [self.trinaryTree nodeCount]);
        if(!nodeToDelete.nodeContent)
        {
            NSLog(@"nodeToDelete:%@", nodeToDelete);
        }
        //Check the Count
        XCTAssertTrue((startingCount-1) == [self.trinaryTree nodeCount], @"Removing Node:%@ Our node count is wrong after Delete. Tree Counts: Expected:%u Actual%d", nodeToDelete, (startingCount-1), [self.trinaryTree nodeCount]);
    }];
}

- (void)testA5_insertAndDelete100RandomNumbers
{
    int randomTestNumbers = 100;
    NSMutableArray *randomNodeArray = [NSMutableArray array];
    for(int x=0;x<=randomTestNumbers;x++)
    {
        NSInteger randomNodeValue = [self getRandomNumberBetween:0 maxNumber:INT_MAX];
        Node *newNode = [Node nodeWithNumber:[NSNumber numberWithInteger:randomNodeValue]];
        [randomNodeArray addObject:newNode];
    }
    //Insert 100 Random Nodes
    [randomNodeArray enumerateObjectsUsingBlock:^(Node *randomNode, NSUInteger idx, BOOL *stop) {
        [self.trinaryTree insertNode:randomNode];
        [self verifyTreeIntegrity];
    }];
    
    XCTAssertTrue([self.trinaryTree nodeCount]==[randomNodeArray count],@" trinaryTree full: Actual:%d", [self.trinaryTree nodeCount]);
    
    //Delete the 100 Random Nodes
    [randomNodeArray enumerateObjectsUsingBlock:^(Node *randomNode, NSUInteger idx, BOOL *stop) {
        [self.trinaryTree deleteNode:randomNode];
        
        //No efficient.  The nodeCount is costly.
        if([self.trinaryTree nodeCount]>0)
            [self verifyTreeIntegrity];
    }];
    
    XCTAssertTrue([self.trinaryTree nodeCount]==0,@" trinaryTree Should be empty. Actual:%d", [self.trinaryTree nodeCount]);
    
}

//As a curiousity I implemented the solution on this Gist: https://gist.github.com/dydt/870393  and verified a concern a comment had.
- (void)testA6_deleteNodeByValueWith20RandomNumbers
{
    int randomTestNumbers = 20;
    NSMutableArray *randomNodeArray = [NSMutableArray array];
    for(int x=0;x<=randomTestNumbers;x++)
    {
        NSInteger randomNodeValue = [self getRandomNumberBetween:0 maxNumber:INT_MAX];
        Node *newNode = [Node nodeWithNumber:[NSNumber numberWithInteger:randomNodeValue]];
        [randomNodeArray addObject:newNode];
    }
    //Insert 20 Random Nodes
    [randomNodeArray enumerateObjectsUsingBlock:^(Node *randomNode, NSUInteger idx, BOOL *stop) {
        [self.trinaryTree insertNode:randomNode];
        [self verifyTreeIntegrity];
    }];
    
    XCTAssertTrue([self.trinaryTree nodeCount]==[randomNodeArray count],@" trinaryTree full: Actual:%d", [self.trinaryTree nodeCount]);
    
    //Delete the 20 Random Nodes
    [randomNodeArray enumerateObjectsUsingBlock:^(Node *randomNode, NSUInteger idx, BOOL *stop) {
        self.trinaryTree.rootNode = [self.trinaryTree deleteNode:randomNode fromRoot:self.trinaryTree.rootNode];
        
        //No efficient.  The nodeCount is costly.
        if([self.trinaryTree nodeCount]>0)
            [self verifyTreeIntegrity];
    }];
    //We suspect this delete will not work, and verify with this XCTAssert
    XCTAssertFalse([self.trinaryTree nodeCount]==0,@"TrinaryTree is empty, but we were expecting Nodes!. Actual:%d", [self.trinaryTree nodeCount]);
}



@end
