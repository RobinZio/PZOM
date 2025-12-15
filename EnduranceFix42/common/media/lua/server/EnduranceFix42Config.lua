-- EnduranceFix42Config.lua
-- Server-side configuration

EnduranceFix42 = EnduranceFix42 or {}

-- How often to check players (seconds)
EnduranceFix42.CheckInterval = 10

-- Endurance restored per check (0.0 - 1.0)
EnduranceFix42.RecoveryRate = 0.015

-- Enable debug logging
EnduranceFix42.Debug = true

-- Auto-disable mod if native recovery is detected
EnduranceFix42.AutoDisable = true

-- Number of positive samples before auto-disable
EnduranceFix42.RequiredPositiveSamples = 3
