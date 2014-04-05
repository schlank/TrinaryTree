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
Write a tri-nary tree in Objective C, and provide an interactive on iPhone and iPad.

#Updates:
    Upgraded project to Xcode 5.
    Fixed iOS7 UI navigation bar issues.
    Populates the UI with test data on app load.
    Improved Insert function to be much more object oriented.
    StringToLong Category on NSString.  See StringToLongTests XCTestCase for example.

#Covered TineryTree and Node with Unit and Integration tests.
    testA1_treeCount     //making sure our count matches our tree.
    testA2_smallestNode  //Testing the class Node's smallestNode method
    testA3_insertNodes   //Adds nodes from standard test data, and verifies tree's integrity after each add.
    testA4_deleteNode    //Populates tree, removes a node, checks the count and tree integrity.  Repeats the process for every node.
    testA5_insertAndDelete100RandomNumbers //Inserts 100 and deletes them all.
    testA6_alternativeDeleteWith20RandomNumbers // An alternative Delete function test
    
# Interested in being a Beta Tester on Test Flight?  Join the team here: http://tflig.ht/1dVfM9K