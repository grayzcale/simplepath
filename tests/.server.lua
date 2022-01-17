local repS = game:GetService("ReplicatedStorage")
local TestEZ = require(repS.TestEZ)
TestEZ.TestBootstrap:run({ repS }, TestEZ.Reporters.TextReporterQuiet)