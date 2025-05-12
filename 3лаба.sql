IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'NBA_GraphDB')
BEGIN
    CREATE DATABASE NBA_GraphDB;
END;
USE NBA_GraphDB;

IF OBJECT_ID('PlayerTeam', 'U') IS NOT NULL DROP TABLE PlayerTeam;
IF OBJECT_ID('PlayerMatch', 'U') IS NOT NULL DROP TABLE PlayerMatch;
IF OBJECT_ID('TeamMatch', 'U') IS NOT NULL DROP TABLE TeamMatch;
IF OBJECT_ID('PlayerRelationships', 'U') IS NOT NULL DROP TABLE PlayerRelationships;
IF OBJECT_ID('TeamRivalries', 'U') IS NOT NULL DROP TABLE TeamRivalries;
IF OBJECT_ID('PlayerStats', 'U') IS NOT NULL DROP TABLE PlayerStats;
IF OBJECT_ID('TeamStats', 'U') IS NOT NULL DROP TABLE TeamStats;
IF OBJECT_ID('Matches', 'U') IS NOT NULL DROP TABLE Matches;
IF OBJECT_ID('Players', 'U') IS NOT NULL DROP TABLE Players;
IF OBJECT_ID('Teams', 'U') IS NOT NULL DROP TABLE Teams;

CREATE TABLE Teams (
    ID INT PRIMARY KEY IDENTITY, 
    Name NVARCHAR(100) NOT NULL,
    City NVARCHAR(100),
    FoundedYear INT
) AS NODE;

CREATE TABLE Players (
    ID INT PRIMARY KEY IDENTITY, 
    Name NVARCHAR(100) NOT NULL, 
    Position NVARCHAR(50),
    BirthDate DATE,
    Height INT,
    Weight INT
) AS NODE;

CREATE TABLE Matches (
    ID INT PRIMARY KEY IDENTITY, 
    Date DATE NOT NULL,
    Venue NVARCHAR(100),
    HomeScore INT,
    AwayScore INT
) AS NODE;

CREATE TABLE PlayerStats (
    ID INT PRIMARY KEY IDENTITY,
    Points INT,
    Assists INT,
    Rebounds INT,
    Steals INT,
    Blocks INT,
    Turnovers INT,
    MinutesPlayed INT
) AS NODE;

CREATE TABLE TeamStats (
    ID INT PRIMARY KEY IDENTITY,
    Points INT,
    Assists INT,
    Rebounds INT,
    Steals INT,
    Blocks INT,
    Turnovers INT,
    FieldGoalPercentage DECIMAL(5,2)
) AS NODE;

INSERT INTO Teams (Name, City, FoundedYear) VALUES 
('Los Angeles Lakers', 'Los Angeles', 1947),
('Golden State Warriors', 'San Francisco', 1946),
('Boston Celtics', 'Boston', 1946),
('Chicago Bulls', 'Chicago', 1966),
('Miami Heat', 'Miami', 1988),
('New York Knicks', 'New York', 1946),
('Dallas Mavericks', 'Dallas', 1980),
('Philadelphia 76ers', 'Philadelphia', 1946),
('Houston Rockets', 'Houston', 1967),
('Brooklyn Nets', 'Brooklyn', 1967);

INSERT INTO Players (Name, Position, BirthDate, Height, Weight) VALUES 
('LeBron James', 'Forward', '1984-12-30', 206, 113),
('Stephen Curry', 'Guard', '1988-03-14', 191, 86),
('Jayson Tatum', 'Forward', '1998-03-03', 203, 95),
('Zach LaVine', 'Guard', '1995-03-10', 196, 91),
('Jimmy Butler', 'Forward', '1989-09-14', 201, 104),
('Jalen Brunson', 'Guard', '1996-08-31', 188, 86),
('Luka Dončić', 'Guard', '1999-02-28', 201, 104),
('Joel Embiid', 'Center', '1994-03-16', 213, 127),
('Jalen Green', 'Guard', '2002-02-09', 193, 84),
('Kevin Durant', 'Forward', '1988-09-29', 208, 109);

INSERT INTO Matches (Date, Venue, HomeScore, AwayScore) VALUES 
('2025-03-10', 'Staples Center', 120, 115),
('2025-03-15', 'TD Garden', 105, 102),
('2025-04-01', 'FTX Arena', 98, 99),
('2025-04-05', 'American Airlines Center', 110, 108),
('2025-04-20', 'Toyota Center', 112, 119),
('2025-04-25', 'Chase Center', 127, 121),
('2025-05-01', 'Madison Square Garden', 102, 97),
('2025-05-05', 'Staples Center', 115, 111),
('2025-05-10', 'United Center', 104, 99),
('2025-05-15', 'Barclays Center', 123, 118);

INSERT INTO PlayerStats (Points, Assists, Rebounds, Steals, Blocks, Turnovers, MinutesPlayed) VALUES 
(32, 8, 10, 2, 1, 3, 38),
(29, 7, 4, 1, 0, 2, 36),
(28, 5, 6, 0, 1, 4, 37),
(22, 6, 3, 3, 0, 1, 32),
(30, 4, 7, 2, 1, 2, 40),
(24, 8, 2, 1, 0, 3, 35),
(35, 9, 5, 1, 0, 5, 39),
(27, 3, 10, 0, 2, 2, 36),
(21, 5, 6, 2, 0, 4, 31),
(34, 6, 8, 1, 1, 3, 37);

INSERT INTO TeamStats (Points, Assists, Rebounds, Steals, Blocks, Turnovers, FieldGoalPercentage) VALUES 
(120, 28, 45, 8, 5, 12, 48.5),
(115, 25, 42, 6, 3, 10, 46.2),
(105, 22, 44, 7, 4, 11, 45.8),
(102, 20, 38, 5, 2, 9, 44.3),
(98, 18, 40, 6, 3, 14, 42.1),
(99, 19, 39, 5, 2, 12, 43.7),
(110, 24, 43, 7, 4, 10, 47.2),
(108, 23, 41, 6, 5, 11, 46.8),
(112, 21, 42, 5, 3, 13, 45.5),
(119, 26, 45, 8, 4, 9, 49.1);

CREATE TABLE PlayerTeam (
    JoinDate DATE,
    JerseyNumber INT
) AS EDGE;

CREATE TABLE PlayerMatch (
    ID INT PRIMARY KEY IDENTITY, 
    Source INT, 
    Target INT
) AS EDGE;

CREATE TABLE TeamMatch (
    IsHomeTeam BIT NOT NULL
) AS EDGE;

CREATE TABLE PlayerRelationships (
    RelationshipType NVARCHAR(50)
) AS EDGE;

CREATE TABLE TeamRivalries (
    RivalryName NVARCHAR(100)
) AS EDGE;

INSERT INTO PlayerTeam ($from_id, $to_id, JoinDate, JerseyNumber)
SELECT p.$node_id, t.$node_id, pt.JoinDate, pt.JerseyNumber
FROM (VALUES
    (1, 1, '2018-07-01', 23),
    (2, 2, '2009-06-25', 30),
    (3, 3, '2017-06-19', 0),
    (4, 4, '2017-06-22', 8),
    (5, 5, '2019-07-06', 22),
    (6, 6, '2022-07-12', 11),
    (7, 7, '2018-06-21', 77),
    (8, 8, '2014-06-26', 21),
    (9, 9, '2021-07-29', 0),
    (10, 10, '2023-02-09', 7)
) AS pt(PlayerID, TeamID, JoinDate, JerseyNumber)
JOIN Players p ON p.ID = pt.PlayerID
JOIN Teams t ON t.ID = pt.TeamID;

INSERT INTO PlayerMatch ($from_id, $to_id)
SELECT p.$node_id, m.$node_id
FROM (VALUES
    (1, 1), (2, 1), (3, 2), (4, 2),
    (5, 3), (6, 3), (7, 4), (8, 4),
    (9, 5), (10, 5)
) AS pm(PlayerID, MatchID)
JOIN Players p ON p.ID = pm.PlayerID
JOIN Matches m ON m.ID = pm.MatchID;

INSERT INTO TeamMatch ($from_id, $to_id, IsHomeTeam)
SELECT t.$node_id, m.$node_id, tm.IsHomeTeam
FROM (VALUES
    (1, 1, 1), (2, 1, 0), (3, 2, 1), (4, 2, 0),
    (5, 3, 1), (6, 3, 0), (7, 4, 1), (8, 4, 0),
    (9, 5, 1), (10, 5, 0)
) AS tm(TeamID, MatchID, IsHomeTeam)
JOIN Teams t ON t.ID = tm.TeamID
JOIN Matches m ON m.ID = tm.MatchID;

INSERT INTO PlayerRelationships ($from_id, $to_id, RelationshipType)
SELECT p1.$node_id, p2.$node_id, pr.RelationshipType
FROM (VALUES
    (1, 2, 'Rivals'), (2, 3, 'Friends'), (4, 5, 'Teammates'),
    (6, 7, 'Friends'), (8, 9, 'Rivals'), (10, 1, 'Friends'),
    (3, 4, 'Teammates'), (5, 6, 'Rivals'), (7, 8, 'Friends'),
    (9, 10, 'Teammates')
) AS pr(Player1ID, Player2ID, RelationshipType)
JOIN Players p1 ON p1.ID = pr.Player1ID
JOIN Players p2 ON p2.ID = pr.Player2ID;

INSERT INTO TeamRivalries ($from_id, $to_id, RivalryName)
SELECT t1.$node_id, t2.$node_id, tr.RivalryName
FROM (VALUES
    (1, 2, 'California Classic'), (3, 4, 'Historic Rivalry'),
    (5, 6, 'East Coast Showdown'), (7, 8, 'Texas vs Philly'),
    (9, 10, 'Space City vs Big Apple'), (1, 3, 'Lakers vs Celtics'),
    (2, 5, 'Warriors vs Heat'), (4, 7, 'Bulls vs Mavericks'),
    (6, 8, 'Knicks vs 76ers'), (9, 1, 'Rockets vs Lakers')
) AS tr(Team1ID, Team2ID, RivalryName)
JOIN Teams t1 ON t1.ID = tr.Team1ID
JOIN Teams t2 ON t2.ID = tr.Team2ID;

--Запросы с метч

SELECT p.Name AS Player
FROM Players p, PlayerTeam pt, Teams t
WHERE MATCH(p-(pt)->t)
AND t.Name = 'Los Angeles Lakers';


SELECT m.Date, m.HomeScore, m.AwayScore, t.Name AS Opponent
FROM Players p, PlayerMatch pm, Matches m, TeamMatch tm, Teams t
WHERE MATCH(p-(pm)->m)
AND MATCH(m<-(tm)-t)
AND p.Name = 'LeBron James';

SELECT DISTINCT op.Name AS OpponentPlayer, ot.Name AS OpponentTeam
FROM Players p, PlayerMatch pm, Matches m, PlayerMatch opm, Players op, PlayerTeam opt, Teams ot
WHERE MATCH(p-(pm)->m<-(opm)-op)
AND MATCH(op-(opt)->ot)
AND p.Name = 'LeBron James'
AND op.Name <> 'LeBron James';



SELECT m.Date, m.HomeScore, m.AwayScore
FROM Matches m, TeamMatch tm1, TeamMatch tm2, Teams t1, Teams t2
WHERE MATCH(t1-(tm1)->m<-(tm2)-t2)
AND t1.Name = 'Boston Celtics'
AND t2.Name = 'Chicago Bulls';


SELECT DISTINCT p1.Name AS Player1, p2.Name AS Player2, m.Date AS MatchDate
FROM Players p1, Players p2, PlayerMatch pm1, PlayerMatch pm2, Matches m
WHERE MATCH(p1-(pm1)->m<-(pm2)-p2)
AND p1.ID <> p2.ID
ORDER BY m.Date DESC;

--SHORTEST_PATH
WITH PlayerPath AS  
( 
    SELECT p1.Name AS StartPlayer,
           STRING_AGG(p2.Name, ' -> ') WITHIN GROUP (GRAPH PATH) AS ConnectionPath,
           LAST_VALUE(p2.Name) WITHIN GROUP (GRAPH PATH) AS LastPlayer,
           COUNT(p2.Name) WITHIN GROUP (GRAPH PATH) AS HopCount
    FROM Players AS p1,
         PlayerRelationships FOR PATH AS pr,
         Players FOR PATH AS p2
    WHERE MATCH(SHORTEST_PATH(p1(-(pr)->p2)+))
    AND p1.Name = 'LeBron James'
)  
SELECT StartPlayer, ConnectionPath
FROM PlayerPath
WHERE LastPlayer = 'Kevin Durant';


WITH TeamPath AS  
( 
    SELECT t1.Name AS StartTeam,
           STRING_AGG(t2.Name, ' -> ') WITHIN GROUP (GRAPH PATH) AS RivalryPath,
           LAST_VALUE(t2.Name) WITHIN GROUP (GRAPH PATH) AS LastTeam,
           COUNT(t2.Name) WITHIN GROUP (GRAPH PATH) AS HopCount
    FROM Teams AS t1,
         TeamRivalries FOR PATH AS tr,
         Teams FOR PATH AS t2
    WHERE MATCH(SHORTEST_PATH(t1(-(tr)->t2){1,3}))
    AND t1.Name = 'Los Angeles Lakers'
)  
SELECT StartTeam, RivalryPath
FROM TeamPath
WHERE LastTeam = 'Boston Celtics'
ORDER BY HopCount;