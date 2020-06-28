using Dates

struct Qualification
    Name::AbstractString
    Granted::Union{Date,Missing}
    Expires::Union{Date,Missing}
    Qualification(Name::AbstractString) = new(Name,missing,missing)
    Qualification(Name::AbstractString,Granted::Date,Expires::Date) = new(Name,Granted,Expires)
end

abstract type Person end

mutable struct Aircrew <: Person
    Name::AbstractString
    Qualifications::AbstractArray{Qualification}
    Aircrew() = new()
    Aircrew(Name::AbstractString,Qualifications::AbstractArray{Qualification}) = new(Name,Qualifications)
end
