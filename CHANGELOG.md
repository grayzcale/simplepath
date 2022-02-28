## v2.2.1 (2022-02-28)
* Fixed `Path:Destroy()`
	* Properly handles the deletion of visual waypoints
	* Automatically stops further execution when destroyed
* Updated reference link

## v2.2.0 (2022-01-29)
* Fixed bug with Path.WaypointReached
	* Emerges if `Path:Run()` is binded to both `Path.WaypointReached` and `Path.Reached` for a Humanoid
	* Before the final waypoint, `Path.WaypointReached` is fired and immediately after `Humanoid.MoveTo` (then `Path.Reached`) gets fired almost simultaneously 
	* `Path.Run` executed within the scope of `Path.WaypointReached` to finish *after* `Path.Reached` gets fired
	* Fix: `Path.WaypointReached` will not fire for the second-last waypoint for Humanoid agents
* Added feature to configure settings for individual agents
	* Overridden settings can be passed as a dictionary to the constructor
* Added a new setting: `Settings.JUMP_WHEN_STUCK`
	* By default, the agent attempts to jump if it gets stuck in the same position for Settings.COMPARISON_CHECKS + 1
	* This can now be disabled and can be handled as needed
* Added a new ErrorType: `SimplePath.ErrorType.AgentStuck`
	* Use this ErrorType to define new behavior when Settings.JUMP_WHEN_STUCK is set to false
* Minor edits to the documentation
	* See complete documentation at https://00xima.github.io/RBLX-SimplePath/api-reference/

## v2.1.2 (2022-01-17)
* `Path:Destroy()` now makes the object completely empty
* Fixed some linting errors

## v2.1.1 (2022-01-15)
* Update link in modulescript

## v2.1.0 (2022-01-15)
* Fixed error when Path is destroyed
* Fixed error if Path is still referenced after being destroyed