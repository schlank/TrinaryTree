//
//  Node.m
//  TrinaryTree
//
//  Created by Steve Baker on 12/5/10.
//  Copyright 2010 Beepscore LLC. All rights reserved.
//

#import "Node.h"

@implementation Node

+ (id)nodeWithNumber:(NSNumber*)nodeContent
{
    return  [[Node alloc]initWithNumber:nodeContent];
}

- (id)initWithNumber:(NSNumber *)nodeContent
{
    if ((self = [super init]))
	{
        self.nodeContent = nodeContent;
	}
	return self;
}

#pragma mark - Mutating Methods

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
            newNode.parentNode = self;
        }
        else
            [self.leftNode insertNode:newNode];
    }
    else if([newNode.nodeContent intValue] > [self.nodeContent intValue])
    {
        if(self.rightNode==nil)
        {
            newNode.parentNode = self;
            self.rightNode = newNode;
        }
        else
            [self.rightNode insertNode:newNode];
    }
    else
    {
        if(self.middleNode==nil)
        {
            newNode.parentNode = self;
            self.middleNode = newNode;
        }
        else
            [self.middleNode insertNode:newNode];
    }
    NSLog(@"-in Node:%@ insertNode:%@", self.nodeContent, newNode.nodeContent);
}

- (Node*)nodeWithValue:(int)nodeValue
{
    if([self.nodeContent intValue] > nodeValue)
    {
        return [self.leftNode nodeWithValue:nodeValue];
    }
    else if([self.nodeContent intValue] < nodeValue)
    {
        return [self.rightNode nodeWithValue:nodeValue];
    }
    else if([self.nodeContent intValue] == nodeValue)
    {
        return self;
    }
    else
    {
        return nil;
    }
}

#pragma mark - Traversing Methods
//return the smallest or left most node from this node.
- (Node*)smallestNode
{
    //If it has no left node, it is the smallest.
    if(self.leftNode==nil)
        return self;
    else
        return [self.leftNode smallestNode];
}

//leafMostNode: starting from currentNode, the node when these three prevent it from traversing down.
//    1. left node being values < parent
//    2. the right node values > parent
//    3. the middle node values == parent
- (Node*)leafMostNode:(Node *)currentNode
{
    Node *leafNode = nil;
    if(self.middleNode!=nil && [currentNode.nodeContent intValue] == [self.middleNode.nodeContent intValue])
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

@end
