Philip R. Leder Leder Consulting LLC April 2014

Forked From:
Steve Baker Beepscore LLC 5 Dec 2010

# TrinaryTree
Adds and deletes nodes in a tree.

# Specification
Implement insert and delete in a tri-nary tree.  
Much like a binary tree but with 3 child nodes for each parent instead of two -- with the left node being values < parent, the right node values > parent, and the middle node values == parent.  For example, if I added the following nodes to the tree in this

order:  5, 4, 9, 5, 7, 2, 2 --  the tree would look like this:

            5
          / | \
         4  5  9
        /     /
      2      7
      |
      2

---

The forked repo:
https://github.com/beepscore/TrinaryTree

I did read about solutions online.  I also tried and tested many of them with random and specific test data, and settled on the insert and delete that worked best for the project.  I also built off a good legacy project.  Working with legacy code is something I enjoy.  I like taking something a little under the weather and returning it to its former glory.  I hoped to show that with a forked project.

//Insert Node method in TrinaryTree Class:

- (void)insertNode:(Node *)node
{
    if (self.rootNode == nil)
    {
        self.rootNode = node;
    }
    else
    {
        [self.rootNode insertNode:node];
    }
    [self.delegate trinaryTreeDidInsertNode:node];
}

//Insert Method in Node Class

- (void)insertNode:(Node *)newNode
{
    NSLog(@"+in Node:%@ insertNode:%@", self.nodeContent, newNode.nodeContent);
    if(newNode==nil)
    {
        NSLog(@"insertNode: newNode is nil. Returning");
        return;
    }
    
    //The order of these matter.  This order ensures insertion on the top Node of any middleNodes.
    if([newNode.nodeContent intValue] < [self.nodeContent intValue])
    {
        if(self.leftNode==nil)
        {
            self.leftNode = newNode;
        }
        else
            [self.leftNode insertNode:newNode];
    }
    else if([newNode.nodeContent intValue] > [self.nodeContent intValue])
    {
        if(self.rightNode==nil)
        {
            self.rightNode = newNode;
        }
        else
            [self.rightNode insertNode:newNode];
    }
    else
    {
        if(self.middleNode==nil)
        {
            self.middleNode = newNode;
        }
        else
            [self.middleNode insertNode:newNode];
    }
    NSLog(@"-in Node:%@ insertNode:%@", self.nodeContent, newNode.nodeContent);
}




//Delete Node (on Trinary Tree)  Turned out that my favorite solution was very similar to the original Trinary Tree Delete.  My method does not rely on a "parentNode" reference saved on each node.  Which, in my opinion, violated the rules of the tree structure.

- (void)deleteNode:(Node *)aNode
{
    NSLog(@"start TrinaryTree deleteNode:");
    
    if (!aNode)
    {
        NSLog(@"TrinaryTree can't delete an empty node");
        return;
    }
    
    // Keep a reference to any soon-to-be orphan nodes so we don't lose them when we delete aNode.
    // Note right hand side references may be nil.
    Node *leftOrphanNode = aNode.leftNode;
    Node *middleOrphanNode = aNode.middleNode;
    Node *rightOrphanNode = aNode.rightNode;
    
    
    Node *parentNode = [self.rootNode parentNodeWithChildNode:aNode];
    
    //(Phil)We can use the parentNode set during the insert and stored on the Node object
    //but the existance of the parentNode violates the trinary tree.  ParentNode gives the ability to travel up
    //The tree, and it is my understanding that a trinary tree does not allow for that.
    //aNode.parentNode
    
    // If aNode has a parent, remove parent's reference to aNode.
    // This will reduce aNode's retain count
    if (parentNode)
    {
        // Is aNode the leftChild of it's parent?
        if (aNode == parentNode.leftNode)
        {
            parentNode.leftNode = nil;
        }
        else if (aNode == parentNode.middleNode)
        {
            parentNode.middleNode = nil;
        }
        else if (aNode == parentNode.rightNode)
        {
            parentNode.rightNode = nil;
        }
    }
    
    // If aNode is the root of the tree, remove tree's reference to aNode.
    if (aNode == self.rootNode)
    {
        self.rootNode = nil;
    }
    
    // make sure we don't try to use a bad reference
    aNode = nil;
    
    // For any children of aNode, remove the child's reference to it's ex-parent aNode.
    // Then re-connect orphans to tree.
    // The order of re-connection can affect the result, and the order is arbitrary
    // If middle node exists, reconnect it first to minimize changes to tree appearance.
    if (middleOrphanNode)
    {
        [self insertNode:middleOrphanNode];
    }
    if (leftOrphanNode)
    {
        [self insertNode:leftOrphanNode];
    }
    if (rightOrphanNode)
    {
        [self insertNode:rightOrphanNode];
    }
    
    //Inform our delegates.  Update the UI and verify our counts.
    [self.delegate trinaryTreeDidDeleteNode];
    NSLog(@"end TrinaryTree deleteNode:");
}


Here is a function on Node that delete uses to find the parent:

- (Node*)parentNodeWithChildNode:(Node*)childNode
{
    if([self hasChildNode:childNode])
        return self;
    
    int rootNodeValue = [self.nodeContent intValue];
    int nodeValue = [childNode.nodeContent intValue];
    if(rootNodeValue > nodeValue)
        return [self.leftNode parentNodeWithChildNode:childNode];
    else if(rootNodeValue < nodeValue)
        return [self.rightNode parentNodeWithChildNode:childNode];
    else
        return nil;
}


Another helper method on the Node object:

//return the smallest or left most node from this node.
- (Node*)smallestNode
{
    //If it has no left node, it is the smallest.
    if(self.leftNode==nil)
        return self;
    else
        return [self.leftNode smallestNode];
}


The following are the tests covering the trinary tree and the insert and delete methods:
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
- (void)testA6_alternativeDeleteWith20RandomNumbers
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
    
    XCTAssertTrue([self.trinaryTree nodeCount]==[randomNodeArray count],@" trinaryTree count incorrect when traversed: Actual:%d", [self.trinaryTree nodeCount]);
    
    //Delete the 20 Random Nodes
    [randomNodeArray enumerateObjectsUsingBlock:^(Node *randomNode, NSUInteger idx, BOOL *stop) {
        self.trinaryTree.rootNode = [self.trinaryTree deleteNode:randomNode fromRoot:self.trinaryTree.rootNode];
        
        if([self.trinaryTree nodeCount]>0) //Costly
            [self verifyTreeIntegrity];
    }];
    
    //We suspect this delete will not work, and verify with this XCTAssert
    XCTAssertFalse([self.trinaryTree nodeCount]==0, @"TrinaryTree (nodeCount) is empty, but we were expecting Nodes!. Actual:%d", [self.trinaryTree nodeCount]);
}

//As a curiousity I implemented the solution on this Gist: https://gist.github.com/dydt/870393  and verified a concern a comment had.
//This tests the same test case, but with our delete function
- (void)testA7_alternativeDeleteWithGistTestCase
{
    NSArray *gistDataArray = [self treeTestNumbersWithKey:@"gistexample"];
    //Insert Nodes 4 \ 6 - 6   From comment: https://gist.github.com/dydt/870393
    [gistDataArray enumerateObjectsUsingBlock:^(NSNumber *testNumber, NSUInteger idx, BOOL *stop) {
        [self.trinaryTree insertNode:[Node nodeWithNumber:testNumber]];
        [self verifyTreeIntegrity];
    }];
    
    XCTAssertTrue([self.trinaryTree nodeCount]==[gistDataArray count],@" trinaryTree count incorrect when traversed: Actual:%d", [self.trinaryTree nodeCount]);
    
    Node *nodeToRemove = [self.trinaryTree.rootNode nodeWithValue:4];
    [self.trinaryTree deleteNode:nodeToRemove];

    [self verifyTreeIntegrity];
   
    //We suspect this delete will not work, and verify with this XCTAssert
    XCTAssertTrue([self.trinaryTree nodeCount]==2, @"TrinaryTree (nodeCount):%d", [self.trinaryTree nodeCount]);
}




Next is the first question about string to long.  For this, I created a Category to NSString and added the function toLong:
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



Tests for string to long:
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
