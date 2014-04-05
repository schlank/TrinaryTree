//
//  TrinaryTree.m
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//
//  Phil Leder 4/3/2014 - Forked Repo:
//  https://github.com/schlank/TrinaryTree
//  References:
//  https://gist.github.com/dydt/870393
//  http://stackoverflow.com/questions/12066057/binary-tree-in-objective-c/12066498#12066498

#import "TrinaryTree.h"
#import "Node.h"

@implementation TrinaryTree

#pragma mark - Methods to manage tree
- (void)listTreeBranchStartingAtNode:(Node *)aNode
{
    if (aNode)
    {
        NSLog(@"%i, ", aNode.nodeContent.intValue);
        {
            if (aNode.leftNode)
            {
                [self listTreeBranchStartingAtNode:aNode.leftNode];
            }
            if (aNode.middleNode)
            {
                [self listTreeBranchStartingAtNode:aNode.middleNode];
            }
            if (aNode.rightNode)
            {
                [self listTreeBranchStartingAtNode:aNode.rightNode];        
            }
        }
    }
}

#pragma mark - Mutate Tree

- (void)insertNode:(Node *)node
{
    if (self.rootNode == nil)
    {
        self.rootNode = node;
    }
    else
    {
        [self.rootNode insertNode:node];
        [self.delegate trinaryTreeDidInsertNode:node];
    }
}


/*Helper function for deletion.  When you delete a key with children,
 *you want to make sure that it's replaced with either itself or its successor,
 *which is the minimum of the right subtree.
 */
//public TrinaryNode findMin(node) {
//    if (node != null) {
//        while (node.left != null) {
//            return findMin(node.left);
//        }
//    }
//    return node;
//}

/*General method that deletes a node.  Starts at a node, then travels down until it replaces
 *a node with either itself (the middle child), its successor (the minimum of the right
 *subtree, or its left child (which can be null), in that order.
 */
//public TrinaryNode delete(key, node) {
//    if (node == null) {
//        throw new RuntimeException();
//    } else if (key < node.key) {
//        node.left = delete(key, node.left);
//    } else if (key > node.key) {
//        node.right = delete(key, node.right);
//    } else {
//        if (node.middle != null) {
//            node.middle = delete(key, node.middle);
//        } else if (node.right != null) {
//            node.key = findMin(node.right).key;
//            node.right = delete(findMin(node.right).key, node.right);
//        } else {
//            node = node.left;
//        }
//    }
//    return node;
//}

- (Node*)deleteNode:(Node*)targetNode fromRoot:(Node*)currentNode
{
    if (currentNode == nil || targetNode == nil)
        return nil;
    
    int targetNodeValue = [targetNode.nodeContent intValue];
    
    if (targetNodeValue < [currentNode.nodeContent intValue])
        currentNode.leftNode = [self deleteNode:targetNode fromRoot:currentNode.leftNode];
    else if (targetNodeValue > [currentNode.nodeContent intValue])
        currentNode.rightNode = [self deleteNode:targetNode fromRoot:currentNode.rightNode];
    else
    {
        if (currentNode.middleNode != nil)
            currentNode.middleNode = [self deleteNode:targetNode fromRoot:currentNode.middleNode];
        else if (currentNode.rightNode != nil)
        {
            Node *smallestRightNode = [currentNode.rightNode smallestNode];
            currentNode.nodeContent = smallestRightNode.nodeContent;
            currentNode.rightNode = [self deleteNode:smallestRightNode fromRoot:currentNode.rightNode];
        }
        else
            currentNode = currentNode.leftNode;
    }
    return currentNode;
}

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
    
    // If aNode has a parent, remove parent's reference to aNode.
    // This will reduce aNode's retain count
    if (aNode.parentNode)
    {
        // Is aNode the leftChild of it's parent?
        if (aNode == aNode.parentNode.leftNode)
        {
            // Disconnect aNode parent's link to aNode
            aNode.parentNode.leftNode = nil;
        }
        else if (aNode == aNode.parentNode.middleNode)
        {
            aNode.parentNode.middleNode = nil;
        }
        else if (aNode == aNode.parentNode.rightNode)
        {
            aNode.parentNode.rightNode = nil;
        }
    }
    
    // If aNode is the root of the tree, remove tree's reference to aNode.
    if (aNode == self.rootNode)
    {
        self.rootNode = nil;
    }
    
    // NOTE:  I think this statement caused a crash when positioned earlier in the method.
    // send delegate message with reference to node before delete node
    [self.delegate trinaryTreeWillDeleteNode:aNode];
    
    // make sure we don't try to use a bad reference
    aNode = nil;
    
    // For any children of aNode, remove the child's reference to it's ex-parent aNode.
    // Then re-connect orphans to tree.
    // The order of re-connection can affect the result, and the order is arbitrary
    // If middle node exists, reconnect it first to minimize changes to tree appearance.
    if (middleOrphanNode)
    {
        middleOrphanNode.parentNode = nil;
        [self insertNode:middleOrphanNode];
    }
    if (leftOrphanNode)
    {
        leftOrphanNode.parentNode = nil;
        [self insertNode:leftOrphanNode];
    }
    if (rightOrphanNode)
    {
        rightOrphanNode.parentNode = nil;
        [self insertNode:rightOrphanNode];
    }
    NSLog(@"end TrinaryTree deleteNode:");
    [self.delegate trinaryTreeWillDeleteNode:aNode];
}

@end
