using Dates

abstract type Event end

struct Position
    Name::AbstractString
    RequiredQualifications::AbstractArray{AbstractString}
    Position(name::AbstractString,rq::AbstractArray{String}) = new(name,rq)
    Position(name::AbstractString) = new(name,AbstractString[])
end

mutable struct FlightEvent <: Event
    Start::DateTime
    End::DateTime
    Positions::AbstractArray{Position}
    Participants::AbstractArray{Aircrew}
    FlightEvent(
        s::DateTime,
        e::DateTime,
        pos::AbstractArray{Position},
        part::AbstractArray{Aircrew}
    ) = new(s,e,pos,part)
    FlightEvent(
        s::DateTime,
        e::DateTime,
        pos::AbstractArray{Position}
    ) = FlightEvent(s,e,pos,Aircrew[])
end

mutable struct GroundEvent <: Event
    Start::DateTime
    End::DateTime
    Participants::AbstractArray{Aircrew}
    GroundEvent(
        s::Date,
        e::Date,
        part::AbstractArray{Aircrew}
    ) = new(s,e,part)
    GroundEvent(
        s::Date,
        e::Date,
    ) = GroundEvent(s,e,Aircrew[])
end

# isValidPerson(::Position, ::Person)
#
#     Compares if the person has the required qualifications for the position.
#     Returns True if they do
#     Returns False if they do not
function isValidPersonForPosition(event::Event,position::Position,person::Person)
    # Require Aircrew for FlightEvent
    if typeof(event)==FlightEvent && typeof(person)!=Aircrew
        return false
    end
    # Shortcut if no qualifications required, anyone is valid
    if position.RequiredQualifications == []
        return true
    end
    # Cycle through required qualifications
    for qual in position.RequiredQualifications
        # Check if the qualification is in persons qualifications list
        if !(qual ∈ person.Qualifications)
            # If required qualification is not in the persons qualification list, they are not valid
            return false
        else
            # If the required qualification IS in their list, verify its currency
            validQual = false
            # Get the persons qualification object that matches the required qualification
            for pqual in person.Qualifications[qual .== person.Qualifications]
                # If the persons qualification cannot expire OR  its date is valid for the event time, they are valid. No need to keep searching.
                if !pqual.CanExpire || (pqual.Granted < event.Start  && event.End < pqual.Expires)
                    validQual = true
                    break
                end
            end
            if !validQual
                # After looking at the persons qualification, if it is not valid for the event, they are not valid
                return false
            end
        end
    end
    return true
end
