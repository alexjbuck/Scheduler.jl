using Scheduler
using Test
using Dates

@testset "Initializers" begin
    # Write your tests here.
    HAC = Qualification("HAC", Date(2020,1,1), Date(2020,6,1))
    @test HAC.Name == "HAC"
    @test HAC.Granted == Date(2020,1,1)
    @test HAC.Expires == Date(2020,6,1)

    ANI = Qualification("ANI")
    @test ANI.Name == "ANI"
    @test ismissing(ANI.Granted)
    @test ismissing(ANI.Expires)

    crew = Aircrew("Alex",[HAC,ANI])
    @test crew.Name == "Alex"
    @test crew.Qualifications == [HAC,ANI]

    crew = Aircrew()
    crew.Name = "hi"
    @test crew.Name == "hi"

    position_HAC = Position([HAC])
    @test position_HAC.Required_Qualifications == [HAC]

    evt = FlightEvent(
        DateTime(2020,1,1,8,0,0,0),
        DateTime(2020,1,1,10,0,0,0),
        [Position([HAC]),Position()]
    )
    @test evt.Start == DateTime(2020,1,1,8,0,0,0)
    @test evt.End == DateTime(2020,1,1,10,0,0,0)
    @test evt.Positions[1].Required_Qualifications == [HAC]
    @test evt.Positions[2].Required_Qualifications == []
end

@testset "Comparisons" begin
    qual1 = Qualification("Qual1")
    qual2 = Qualification("Qual2")
    @test true  == Scheduler.isValidPerson(Position(), Aircrew("Alex",[qual1]))
    @test false == Scheduler.isValidPerson(Position([qual1]), Aircrew())
    @test true  == Scheduler.isValidPerson(Position([qual1]), Aircrew("Alex",[qual1]))
    @test false == Scheduler.isValidPerson(Position([qual1,qual2]), Aircrew("Alex",[qual1]))
    @test true  == Scheduler.isValidPerson(Position([qual1,qual2]), Aircrew("Alex",[qual1,qual2]))
    @test true  == Scheduler.isValidPerson(Position([qual1]), Aircrew("Alex",[qual1,qual2]))
end

@testset "Assigning Names" begin

end
