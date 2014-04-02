//
//  Node.m
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import "Node.h"

@implementation Node

- (void)insertNode:(Node *)newNode
{
    
    NSLog(@"in Node insertNode:%@",newNode.nodeContent);
    //So that the leaves sprout from the bottom and not the top.
    if(self.middleNode!=nil)
    {
        [self.middleNode insertNode:newNode];
        return;
    }    

    if([newNode.nodeContent intValue] < [self.nodeContent intValue])
    {
        if(self.leftNode==nil)
        {
            self.leftNode = newNode;
        }
        else
        {
            [self.leftNode insertNode:newNode];
        }
    }
    else if([newNode.nodeContent intValue] > [self.nodeContent intValue])
    {
        if(self.rightNode==nil)
        {
            self.rightNode = newNode;
        }
        else
        {
            [self.rightNode insertNode:newNode];
        }
    }
    else
    {
        if(self.middleNode==nil)
        {
            self.middleNode = newNode;
        }
        else
        {
            [self.middleNode insertNode:newNode];
        }
    }
}


//leafMostNode:  The node when these three prevent it from traversing down.
//    1. left node being values < parent
//    2. the right node values > parent
//    3. the middle node values == parent
- (Node*)leafMostNode:(Node *)currentNode  //Now I think we can re-use this on both delete and insert.  Nice.
{
    Node *leafNode = nil;
    if(self.middleNode!=nil)
    {
        return [self.middleNode leafMostNode:currentNode];
    }
    else if([currentNode.nodeContent intValue] < [self.nodeContent intValue])
    {
        return [self.leftNode leafMostNode:currentNode];
    }
    else if([currentNode.nodeContent intValue] > [self.nodeContent intValue])
    {
        return [self.rightNode leafMostNode:currentNode];
    }
    else
    {
        return leafNode=self;
    }
    return leafNode;
}

- (void)deleteNode:(Node *)nodeToDelete
{
    
    if([nodeToDelete.nodeContent intValue]==[self.nodeContent intValue])
    {
        //We have a match!!!
        //Deleting now will fail our tests
        //Unless we check for a middle.
        //We want to remove the bottom most Node (NOTE: this behavior must match on inserting a node. Write a test cover that.)
    }
}

@end
