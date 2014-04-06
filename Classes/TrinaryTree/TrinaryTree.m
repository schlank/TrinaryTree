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
    }
    [self.delegate trinaryTreeDidInsertNode:node];
}

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

-(Node*)deleteNode:(Node*)root forValue:(int)nodeValue
{
    
    if (root == NULL)
    {
        return root;
    }
    
    Node *curr = root;
    Node *parent;
    while (curr != nil && nodeValue != [curr.nodeContent intValue])
    {
        parent = curr;
        curr = (nodeValue < [curr.nodeContent intValue]) ? curr.leftNode : curr.rightNode;
    }
    if (curr == NULL)
    {
        NSLog(@"item not found");
        return root;
    }
    
    Node *q, *suc;
    if (curr.leftNode == NULL)
    {
        q = curr.rightNode;
    }
    else if (curr.rightNode == NULL)
    {
        q = curr.leftNode;
    }
    else
    {
        //obtain in order successor
        suc = curr.rightNode;
        while (suc.leftNode != NULL)
        {
            suc = suc.leftNode;
        }
        suc.leftNode = curr.leftNode;
        q = curr.rightNode;
    }
    if (parent == NULL)
    {
        return q;
    }
    if (curr == parent.leftNode)
    {
        parent.leftNode = q;
    }
    else
    {
        parent.rightNode = q;
    }
    curr = NULL;
    return root;
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

@end
