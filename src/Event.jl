using Dates

abstract type Event end

struct Position
    Required_Qualifications::AbstractArray{Qualification}
    Position(rq::AbstractArray{Qualification}) = new(rq)
    Position() = new([])
end

mutable struct FlightEvent <: Event
    Start::DateTime
    End::DateTime
    Positions::AbstractArray{Position}
    Participants::AbstractArray{Aircrew}
    FlightEvent(
        s::DateTime,
        e::DateTime,
        pos::AbstractArray{Position}
    ) = new(s,e,pos,[])
    FlightEvent(
        s::DateTime,
        e::DateTime,
        pos::AbstractArray{Position},
        part::AbstractArray{Aircrew}
    ) = new(s,e,pos,part)
end

mutable struct GroundEvent <: Event
    Start::DateTime
    End::DateTime
    Participants::AbstractArray{Aircrew}
    GroundEvent(
        s::Date,
        e::Date,
    ) = new(s,e,[])
    GroundEvent(
        s::Date,
        e::Date,
        part::AbstractArray{Aircrew}
    ) = new(s,e,part)
end

# isValidPerson(::Position, ::Person)
#
#     Compares if the person has the required qualifications for the position.
#     Returns True if they do
#     Returns False if they do not
function isValidPerson(position::Position,person::Person)
    if !isdefined(person,:Qualifications)
        return false
    end
    for qual in position.Required_Qualifications
        if !(qual ∈ person.Qualifications)
            return false
        end
    end
    return true
end
