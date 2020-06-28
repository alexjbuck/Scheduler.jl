using Scheduler
using Test
using Dates

@testset "Initializers" begin
    # Write your tests here.
    HAC = Qualification("HAC", Date(2019,1,1), Date(2020,6,1))
    @test HAC.Name == "HAC"
    @test HAC.Granted == Date(2019,1,1)
    @test HAC.Expires == Date(2020,6,1)
    @test HAC.CanExpire == true

    ANI = Qualification("ANI")
    @test ANI.Name == "ANI"
    @test ANI.Granted == Date(0)
    @test ANI.Expires == Date(0)
    @test ANI.CanExpire == false

    FCP = Qualification("FCP",Date(2018,1,1))
    @test FCP.Name == "FCP"
    @test FCP.Granted == Date(2018,1,1)
    @test FCP.Expires == Date(0)
    @test FCP.CanExpire == false

    crew = Aircrew("Alex",[HAC,ANI,FCP])
    @test crew.Name == "Alex"
    @test crew.Qualifications == [HAC,ANI,FCP]

    crew = Aircrew("old")
    @test crew.Name == "old"
    @test crew.Qualifications == []
    crew.Name = "hi"
    @test crew.Name == "hi"
    @test crew.Qualifications == []

    pos1 = Position("Pilot",["HAC","ANI"])
    @test pos1.RequiredQualifications == ["HAC","ANI"]

    evt = FlightEvent(
        DateTime(2020,1,1,8,0,0,0),
        DateTime(2020,1,1,10,0,0,0),
        [Position("Pilot",["HAC","FCP"]),Position("Copilot")]
    )
    @test evt.Start == DateTime(2020,1,1,8,0,0,0)
    @test evt.End == DateTime(2020,1,1,10,0,0,0)
    @test length(evt.Positions) == 2
    @test evt.Positions[1].RequiredQualifications == ["HAC","FCP"]
    @test evt.Positions[2].RequiredQualifications == []
end

@testset "isValidPersonForPosition" begin
    Alex = Aircrew("Alex",[Qualification("HAC"),Qualification("ANI"),Qualification("FCP")])
    Drew = Aircrew("Drew",[Qualification("HAC",Date(0),Date(2020,1,1))])
    John = Aircrew("John",[Qualification("HAC",Date(0),Date(2021,2,2))])
    Eric = Aircrew("Eric")
    Bill = NonAircrew("Bill")
    pilot = Position("Pilot",["HAC"])
    copilot = Position("Copilot")
    evt = FlightEvent(
        DateTime(2020,1,1,8),
        DateTime(2020,1,1,10),
        [pilot,copilot]
    )
    @test true   == Scheduler.isValidPersonForPosition(evt, pilot,   Alex)
    @test true   == Scheduler.isValidPersonForPosition(evt, copilot, Alex)

    @test false  == Scheduler.isValidPersonForPosition(evt, pilot,   Drew)
    @test true   == Scheduler.isValidPersonForPosition(evt, copilot, Drew)

    @test true   == Scheduler.isValidPersonForPosition(evt, pilot,   John)
    @test true   == Scheduler.isValidPersonForPosition(evt, copilot, John)

    @test false  == Scheduler.isValidPersonForPosition(evt, pilot,   Eric)
    @test true   == Scheduler.isValidPersonForPosition(evt, copilot, Eric)

    @test false  == Scheduler.isValidPersonForPosition(evt, pilot,   Bill)
    @test false  == Scheduler.isValidPersonForPosition(evt, copilot, Bill)

end

@testset "Assigning Names" begin
    Alex = Aircrew("Alex",[Qualification("HAC"),Qualification("ANI"),Qualification("FCP")])
    Drew = Aircrew("Drew",[Qualification("HAC",Date(0),Date(2020,1,1))])
    John = Aircrew("John",[Qualification("HAC",Date(0),Date(2021,2,2))])
    Eric = Aircrew("Eric")
    Bill = NonAircrew("Bill")
    pilot = Position("Pilot",["HAC"])
    copilot = Position("Copilot")
    evt = FlightEvent(
        DateTime(2020,1,1,8),
        DateTime(2020,1,1,10),
        [pilot,copilot]
    )
    evt = FlightEvent(
        DateTime(2020,1,1,8),
        DateTime(2020,1,1,10),
        [pilot,copilot]
    )
    people = [Alex, Drew, John, Eric, Bill]
end
