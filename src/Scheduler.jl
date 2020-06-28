module Scheduler
# Write your package code here.
export Qualification, Aircrew, NonAircrew, Event, FlightEvent, GroundEvent, Position

include("Aircrew.jl")
include("Event.jl")

end
