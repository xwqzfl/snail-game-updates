-- A harmless initial release that exercises the process-local patch loader.
local originalEventSp = original("offline.TourMetrics", "eventSp")
replace("offline.TourMetrics", "eventSp", function(state, eventId)
    return originalEventSp(state, eventId)
end)
