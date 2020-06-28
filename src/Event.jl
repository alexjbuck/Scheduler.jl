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
function isValidPerson(event::Event,position::Position,person::Person)
    if !isdefined(person,:Qualifications)
        return false
    end
    if position.RequiredQualifications == []
        return true
    end
    for qual in position.RequiredQualifications
        if !(qual ∈ person.Qualifications)
            return false
        else
            for pqual in person.Qualifications[qual .== person.Qualifications]
                if pqual.CanExpire && (event.Start < pqual.Granted || pqual.Expires < event.End)
                    return false
                end
            end
        end
    end
    return true
end
