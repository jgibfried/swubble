//
//  Constants.h
//  Swubble
//
//  Created by John Gibfried on 3/7/13.
//  Copyright (c) 2013 gibfried. All rights reserved.
//

#define ARC4RANDOM_MAX     0x100000000

#define introBackground    @"menuBackgroundImage.png"
#define menuBackground     @"menuBackgroundImage.png"
#define gameBackground     @"menuBackgroundImage.png"

#define redBubbleSprite    @"redBubble.png"
#define greenBubbleSprite  @"greenBubble.png"

#define gameTimeDefault 120

#define gameGridSizeHeight 10
#define gameGridSizeWidth  6

#define gameGridCellHeight 60 // points
#define gameGridCellWidth  60 // points

#define gameGridOffsetY    80 // points
#define gameGridOffsetX    96 // points

#define gameBubbleDragDistance  60 // points

#define difficultyLevels   5

typedef enum dragDirection {
    kDirectionUp,
    kDirectionDown,
    kDirectionLeft,
    kDirectionRight,
} DragDirection;

typedef void (^HandlerBlock)(void);
