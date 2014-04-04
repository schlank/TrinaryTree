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

##Updates:
    Upgraded project to Xcode 5.
    Fixed iOS7 UI navigation bar issues.
    Populates the UI with test data on app load.
    Improved object oriented Insert function.
    StringToLong Category on NSString.  See StringToLongTests XCTestCase for example.

##Covered TineryTree and Node with Unit and Integration tests.
    testA1_treeCount     //making sure our count matches our tree.
    testA2_smallestNode  //Testing the class Node's smallestNode method
    testA3_insertNodes   //Adds nodes from standard test data, and verifies tree's integrity after each add.
    testA4_deleteNode    //Populates tree, removes a node, checks the count and tree integrity.  Repeats the process for every node.