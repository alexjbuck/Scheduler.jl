using Dates

struct Qualification
    Name::AbstractString
    Granted::Date
    Expires::Date
    CanExpire::Bool
    Qualification(Name::AbstractString,Granted::Date,Expires::Date,CanExpire::Bool) = new(Name,Granted,Expires,CanExpire)
    Qualification(Name::AbstractString,Granted::Date,Expires::Date) = Qualification(Name,Granted,Expires,true)
    Qualification(Name::AbstractString,Granted::Date) = Qualification(Name,Granted,Date(0),false)
    Qualification(Name::AbstractString) = Qualification(Name,Date(0),Date(0),false)
end

import Base.==
==(a::AbstractString,b::Qualification) = a==b.Name
==(a::Qualification,b::AbstractString) = a.Name==b

abstract type Person end
mutable struct Aircrew <: Person
    Name::AbstractString
    Qualifications::AbstractArray{Qualification}
    Aircrew(name::AbstractString,qualifications::AbstractArray{Qualification}) = new(name,qualifications)
    Aircrew(name::AbstractString) = Aircrew(name,Qualification[])
end

mutable struct NonAircrew <: Person
    Name::AbstractString
    NonAircrew(name::AbstractString) = new(name)
end
