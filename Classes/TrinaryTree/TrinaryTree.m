//
//  TrinaryTree.m
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

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

- (void)deleteNodeWithContent:(NSNumber*)nodeContent
{
    Node *nodeToDelete = [[Node alloc]init];
    [nodeToDelete setNodeContent:nodeContent];
    [self deleteNode:nodeToDelete];
}

- (void)deleteNode:(Node *)aNode
{
    if(aNode==nil || self.rootNode==nil)
        return;
    [aNode deleteNode:aNode];
    
}

@end
