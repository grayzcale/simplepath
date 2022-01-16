![](https://doy2mn9upadnk.cloudfront.net/uploads/default/original/4X/0/7/9/079f2967c6063a0052eb4809633b1d1e498a345a.png)

![GitHub Workflow Status](https://img.shields.io/github/workflow/status/00xima/rblx-simplepath/Docs?color=green&label=docs&style=plastic)
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/00xima/rblx-simplepath?color=yellowgreen&sort=semver&style=plastic)
![GitHub](https://img.shields.io/github/license/00xima/rblx-simplepath?color=blue&style=plastic)

<hr>

SimplePath is an open-source pathfinding module that gives you the ability to quickly create a pathfinding script for humanoids and non-humanoids with just a few lines of code. Pathfinding is done using [Roblox's PathfindingService](https://developer.roblox.com/en-us/api-reference/class/PathfindingService).

This module works by using a "repetitive" approach to pathfinding. The pathfinding agent moves a more efficient path when computed repetitively instead of just once. Part of the reason why is because computing the path once doesn't guarantee that the agent reaches the goal as expected. Taking the repetitive approach accounts for any obstructions or obstacles blocking the path at the current time. This guarantees that the agent will reach its goal no matter what as long as it's traversable within the scope of PathfindingService. Although you can still use SimplePath normally, it is strongly suggested that you take a repetitive approach to pathfinding as this was the primary concept kept in mind during the development of this module. However, in some scenarios, it might be better to compute the path just once. For example, if the agent does not interact with moving objects, you should consider changing the structure of your pathfinding code by reducing the number of repetitions between path computations to improve performance.

To get started with using SimplePath visit [Getting Started](https://00xima.github.io/RBLX-SimplePath/guides/getting-started/).

<br>

**Useful Links:**

- <a href=https://github.com/00xima/SimplePath target=_blank>GitHub</a>
- <a href=https://devforum.roblox.com/t/1196762 target=_blank>DevForum</a>
- <a href=https://www.roblox.com/library/6744337775/SimplePath-Pathfinding-Module target=_blank>Roblox</a>
