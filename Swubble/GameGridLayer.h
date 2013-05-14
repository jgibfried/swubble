//
//  GameGridLayer.h
//  Swubble
//
//  Created by John Gibfried on 3/11/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#import "BaseLayer.h"
#import "GameObject.h"
#import "Bubble.h"

@interface GameGridLayer : BaseLayer

@property (nonatomic, strong) GameObject *game;

@property (nonatomic, strong) CCLabelTTF *totalScoreLabel;
@property (nonatomic, strong) CCLabelTTF *score1Label;
@property (nonatomic, strong) CCLabelTTF *score2Label;
@property (nonatomic, strong) CCLabelTTF *score3Label;


@end
