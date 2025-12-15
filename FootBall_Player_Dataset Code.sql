---FOOTBALL PLAYER DATASET
--Questions Part 1
	
--1	Write a query to find all the players in the "Arizona" team.

SELECT *
FROM [dbo].['Football Players Data$']
WHERE [Team] = 'Arizona';


--2	Write a query to find all the players who play as a "WR" (Wide Receiver).

SELECT *
FROM [dbo].['Football Players Data$']
WHERE [Pos]= 'WR';



--3	Write a query to list all players taller than 6 feet 2 inches.

SELECT *
FROM [dbo].['Football Players Data$']
WHERE [Ft]>=6 AND [In] >=2



--4	Write a query to find all players who attended the "Washington" college.

SELECT *
FROM [dbo].['Football Players Data$']
WHERE [College] = 'Washington';

--5	Write a query to list players who are 25 years old or younger.

	--Check the problematic values in the age column
		SELECT DISTINCT [Age]
		FROM [dbo].['Football Players Data$']
		WHERE TRY_CAST([Age] AS INT) IS NULL;
	
	--Clean and Replace invalid values

		UPDATE [dbo].['Football Players Data$']
		SET [Age] = NULL
		WHERE [Age] = 'N/A';

	--Update the age datatype to INT

		ALTER TABLE [dbo].['Football Players Data$']
		ALTER COLUMN [Age] INT

--Now do the query
SELECT *
FROM [dbo].['Football Players Data$']
WHERE [Age] >= 25

--6	Write a query to find all players with missing Age data.

SELECT *
FROM [dbo].['Football Players Data$']
WHERE [Age] IS NULL

--7	Write a query to find players who are rookies (Exp = 'R').

SELECT *
FROM [dbo].['Football Players Data$']
WHERE [Exp] = 'R'


--8	Write a query to find the tallest player on the "New Orleans" team.

SELECT TOP (1) *
FROM [dbo].['Football Players Data$']
WHERE [Team] = 'New Orleans'
ORDER BY [Ht] DESC


--9	Write a query to find players weighing more than 250 pounds.

SELECT *
FROM [dbo].['Football Players Data$']
WHERE [Wt] >= 250

--10 Write a query to calculate the average height of players at each position.

SELECT [Pos] AS Position, AVG([Inches]) AS AVG_Height
FROM [dbo].['Football Players Data$']
GROUP BY [Pos]


--	Questions Part 2
	
--1	Write a query to find the heaviest player for each position.

SELECT TOP(1) *
FROM [dbo].['Football Players Data$']
ORDER BY [Wt] DESC

--2	Write a query to rank players by age within their team. If two players have the same age, rank them by their weight.
SELECT *,
        RANK() OVER (
        PARTITION BY [Team]
        ORDER BY [Age] DESC, [Wt] DESC
    ) AS AgeWeightRank
FROM [dbo].['Football Players Data$']

--3	Write a query to calculate the average height (in inches) for all players older than 25 years.

SELECT AVG([Inches]) AS [Players with Age > 25 Average_Height]
FROM [dbo].['Football Players Data$']
WHERE [Age] > 25


--4	Write a query to find all players whose height is greater than the average height of their respective team.

SELECT P.Team, P.[NAME ],P.Pos,P.Age,P.Inches
FROM [dbo].['Football Players Data$'] AS P
WHERE P.Inches > (
	SELECT AVG(T.[Inches])
	FROM [dbo].['Football Players Data$'] AS T
	WHERE T.Team = P.Team

--4  Find all players whose height is greater than the average height of their respective team

WITH CTE AS(
SELECT *,
AVG([Inches]) OVER(PARTITION BY [Team]) AS Average_HEIGHT
FROM [dbo].['Football Players Data$'] 
)
SELECT *
FROM CTE 
WHERE [Inches] > Average_HEIGHT



--5	Write a query to find all players who share the same last name.

SELECT *
FROM [dbo].['Football Players Data$']
WHERE [LastName] IN (
SELECT [LastName]
FROM [dbo].['Football Players Data$']
GROUP BY [LastName]
HAVING COUNT (*) >1
)
ORDER BY [LastName], [FirstName]

--6	Write a query to find the players with the minimum height for each position.

SELECT [NAME ],[Pos],[Ht]
FROM (
		SELECT *,
				RANK () OVER (
					PARTITION BY [Pos]
					ORDER BY [Ht] ASC
					)
			AS HeightRank
		FROM [dbo].['Football Players Data$']
) AS Ranked
WHERE HeightRank = 1
ORDER BY [Pos]



--7	Write a query to get the number of players for each team grouped by their experience level.

SELECT [Team],[Exp], COUNT([NAME ]) AS PlayerCount
FROM [dbo].['Football Players Data$']
GROUP BY [Exp],[Team]
ORDER BY [Team]


--9	Write a query to find all players whose weight is above the average weight for their respective position.

SELECT [NAME ],[Pos],[Wt]
FROM [dbo].['Football Players Data$']
WHERE [Wt] >
	(
	SELECT AVG([Wt])
	FROM [dbo].['Football Players Data$']
	)
	ORDER BY [Pos],[Wt] DESC

--Calculating Average Weight--
	SELECT AVG([Wt]) AS AVG_WEIGHT
	FROM [dbo].['Football Players Data$']


--10 Write a query to calculate the percentage of players in each position for every team.
SELECT [Pos], 
		COUNT(*) AS PlayerCount,
		COUNT(*) * 100.0/ SUM(COUNT(*)) OVER () AS Percentage
	FROM [dbo].['Football Players Data$']
	WHERE [Pos] IS NOT NULL
	GROUP BY [Pos]
	ORDER BY Percentage

