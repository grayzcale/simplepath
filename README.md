![Version: 2.1](https://img.shields.io/badge/Version-2.1-orange?style=for-the-badge)

![](https://doy2mn9upadnk.cloudfront.net/uploads/default/optimized/4X/6/2/4/6243eab4f176605daa050656d55d47c6d1429e4b_2_690x153.png)

<hr>

SimplePath is an open-source pathfinding module that gives you the ability to quickly create a pathfinding script for humanoids and non-humanoids with just a few lines of code. Pathfinding is done using [Roblox's PathfindingService](https://developer.roblox.com/en-us/api-reference/class/PathfindingService).

This module works by using a "repetitive" approach to pathfinding. The pathfinding agent moves a more efficient path when computed repetitively instead of just once. Part of the reason why is because computing the path once doesn't guarantee that the agent reaches the goal as expected. Taking the repetitive approach accounts for any obstructions or obstacles blocking the path at the current time. This guarantees that the agent will reach its goal no matter what as long as it's traversable within the scope of PathfindingService. Although you can still use SimplePath normally, it is strongly suggested that you take a repetitive approach to pathfinding as this was the primary concept kept in mind during the development of this module. However, in some scenarios, it might be better to compute the path just once. For example, if the agent does not interact with moving objects, you should consider changing the structure of your pathfinding code by reducing the number of repetitions between path computations to improve performance.

To get started with using SimplePath visit: https://00xima16.gitbook.io/simplepath-module/guides/getting-started.

<br>

**Useful Links:**
- API Documentation/Examples: https://00xima16.gitbook.io/simplepath-module/
- DevForum: https://devforum.roblox.com/t/simplepath-v102-pathfinding-module/1196762
- ModuleScript: https://www.roblox.com/library/6744337775/SimplePath-Pathfinding-Module
