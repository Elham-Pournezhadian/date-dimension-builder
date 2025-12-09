--========================
-- Author: Elham Pournezhadian
-- Description: This query creates DimDate table which is filled with Gregorian and Persian dates in the given period.
--========================

-------- Parameters ---------
DECLARE
 @StartDate DATETIME	=	'2025-01-01'
,@EndDate	DATETIME	=	'2025-01-30' 
-----------------------------

DROP TABLE IF EXISTS dbo.DimDate
CREATE TABLE dbo.[DimDate](
	DateKey INT, 
	FullDateDatabaseStandard DATE, 
	FullDateDatabaseStandardText VARCHAR(10), 
	FullDateBritish VARCHAR(10),
	FullDateAmerican VARCHAR(10),
	YearNumber SMALLINT, 
	MonthNumberOfYear TINYINT, 
	[MonthName] VARCHAR(20), 
	[DayOfYear] INT,
	[DayOfMonth] SMALLINT,
	[DayOfWeek] SMALLINT,
	DayOfWeekName VARCHAR(20),
	DayOfWeekType VARCHAR(20),
	CalendarQuarter TINYINT,
	CalendarQuarterName VARCHAR(5),
	Season VARCHAR(20),

	-----  Persian dates column	-----
	PersianDateKey int, 
	PersianFullDate VARCHAR(10), 
	PersianCalendarYear smallint, 
	PersianMonthNumberOfYear tinyint, 
	PersianMonthNameLatin VARCHAR(20), 
	PersianMonthName NVARCHAR(20), 
	PersianDayOfYear INT,
	PersianDayOfMonth smallint,
	PersianDayOfWeek smallint,
	PersianDayOfWeekName NVARCHAR(20),
	PersianDayOfWeekType NVARCHAR(20),
	PersianCalendarQuarter tinyint, 
	PersianCalendarSeason NVARCHAR(20) 

) ON [PRIMARY]



DECLARE @date DATE = @StartDate

DECLARE 
	@DateKey INT, 
	@FullDateDatabaseStandard DATE, 
	@FullDateDatabaseStandardText VARCHAR(10), 
	@FullDateBritish VARCHAR(10),
	@FullDateAmerican VARCHAR(10),
	@YearNumber SMALLINT, 
	@MonthNumberOfYear TINYINT, 
	@MonthName VARCHAR(20), 
	@DayOfYear INT,
	@DayOfMonth SMALLINT,
	@DayOfWeek SMALLINT,
	@DayOfWeekName VARCHAR(20),
	@DayOfWeekType VARCHAR(20),
	@CalendarQuarter TINYINT,
	@CalendarQuarterName VARCHAR(5),
	@Season VARCHAR(20)

DECLARE
	@PersianDateKey int, 
	@PersianFullDate VARCHAR(10), 
	@PersianCalendarYear smallint, 
	@PersianMonthNumberOfYear tinyint, 
	@PersianMonthNameLatin VARCHAR(20), 
	@PersianMonthName NVARCHAR(20), 
	@PersianDayOfYear INT,
	@PersianDayOfMonth smallint,
	@PersianDayOfWeek smallint,
	@PersianDayOfWeekName NVARCHAR(20),
	@PersianDayOfWeekType NVARCHAR(20),
	@PersianCalendarQuarter tinyint, 
	@PersianCalendarSeason NVARCHAR(20) 



WHILE @date < @EndDate
BEGIN

	SET @FullDateDatabaseStandard = @date
	SET @FullDateDatabaseStandardText = CONVERT(varchar(10), @date, 23)
	SET @FullDateBritish = FORMAT(@date,'dd/MM/yyyy')
	SET @FullDateAmerican = FORMAT(@date,'MM/dd/yyyy')
	SET @YearNumber = DATEPART(YEAR,@date)
	SET @MonthNumberOfYear = DATEPART(MONTH,@date)
	SET @MonthName = DATENAME(MONTH,@date)
	SET @DayOfYear = DATEPART(DAYOFYEAR,@date)
	SET @DayOfMonth = DATEPART(DAY,@date)
	SET @DayOfWeek = DATEPART(WEEKDAY,@date)
	SET @DayOfWeekName = DATENAME(WEEKDAY,@date)
	SET @DayOfWeekType = IIF(@DayOfWeekName IN ('Saturday','Sunday'),'Weekends','Workday')
	SET @CalendarQuarter =
		CASE 
			WHEN @MonthNumberOfYear IN (1,2,3) THEN 1
			WHEN @MonthNumberOfYear IN (4,5,6) THEN 2
			WHEN @MonthNumberOfYear IN (7,8,9) THEN 3
			WHEN @MonthNumberOfYear IN (10,11,12) THEN 4
		END
	SET @CalendarQuarterName = 'Q' + CAST(@CalendarQuarter AS VARCHAR(1))
	SET @Season = 
		CASE 
			WHEN @MonthName IN ('March', 'April', 'May') THEN 'Spring'
			WHEN @MonthName IN ('June', 'July', 'August') THEN 'Summer'
			WHEN @MonthName IN ('September', 'October', 'November') THEN 'Autumn'
			WHEN @MonthName IN ('December', 'January', 'February') THEN 'Winter'
		END

	SET @DateKey = REPLACE(@FullDateDatabaseStandardText,'-','')

 
	--Test/Debug mode
	/*
	SELECT @DateKey AS DateKey
		,@FullDateDatabaseStandard		AS FullDateDatabaseStandard
		,@FullDateDatabaseStandardText	AS FullDateDatabaseStandardText
		,@FullDateBritish				AS FullDateBritish
		,@FullDateAmerican				AS FullDateAmerican
		,@YearNumber					AS YearNumber
		,@MonthNumberOfYear				AS MonthNumberOfYear
		,@MonthName						AS MonthName
		,@DayOfYear						AS DayOfYear
		,@DayOfMonth					AS DayOfMonth
		,@DayOfWeek						AS DayOfWeek
		,@DayOfWeekName					AS DayOfWeekName
		,@DayOfWeekType					AS DayOfWeekType
		,@CalendarQuarter				AS CalendarQuarter
		,@CalendarQuarterName			AS CalendarQuarterName
		,@Season						AS Season
	*/

	---------------------Calculating Persian Calendar---------------------
	SET @PersianFullDate = dbo.ufn_ConvertGregorianToPersian(@date)  
	SET @PersianDateKey = replace(@PersianFullDate,'/','')
	SET @PersianCalendarYear = @PersianDateKey / 10000
	SET @PersianMonthNumberOfYear = (@PersianDateKey / 100) % 100
	SET @PersianDayOfMonth = @PersianDateKey % 100
	
	SET @PersianDayOfYear = ((@PersianMonthNumberOfYear-1) * 30) + @PersianDayOfMonth
	SET @PersianDayOfYear = @PersianDayOfYear + IIF(@PersianMonthNumberOfYear<7,@PersianMonthNumberOfYear,6)

	IF 		@PersianMonthNumberOfYear= 12 SET @PersianMonthName=N'اسفند'
	ELSE IF @PersianMonthNumberOfYear= 11 SET @PersianMonthName=N'بهمن'
	ELSE IF @PersianMonthNumberOfYear= 10 SET @PersianMonthName=N'دی'
	ELSE IF @PersianMonthNumberOfYear= 9  SET @PersianMonthName=N'آذر'
	ELSE IF @PersianMonthNumberOfYear= 8  SET @PersianMonthName=N'آبان'
	ELSE IF @PersianMonthNumberOfYear= 7  SET @PersianMonthName=N'مهر'
	ELSE IF @PersianMonthNumberOfYear= 6  SET @PersianMonthName=N'شهریور'
	ELSE IF @PersianMonthNumberOfYear= 5  SET @PersianMonthName=N'مرداد'
	ELSE IF @PersianMonthNumberOfYear= 4  SET @PersianMonthName=N'تیر'
	ELSE IF @PersianMonthNumberOfYear= 3  SET @PersianMonthName=N'خرداد'
	ELSE IF @PersianMonthNumberOfYear= 2  SET @PersianMonthName=N'اردیبهشت'
	ELSE IF @PersianMonthNumberOfYear= 1  SET @PersianMonthName=N'فروردین'

	IF 		@PersianMonthNumberOfYear= 12 SET @PersianMonthNameLatin='Esfand'
	ELSE IF @PersianMonthNumberOfYear= 11 SET @PersianMonthNameLatin='Bahman'
	ELSE IF @PersianMonthNumberOfYear= 10 SET @PersianMonthNameLatin='Dey'
	ELSE IF @PersianMonthNumberOfYear= 9  SET @PersianMonthNameLatin='Azar'
	ELSE IF @PersianMonthNumberOfYear= 8  SET @PersianMonthNameLatin='Aban'
	ELSE IF @PersianMonthNumberOfYear= 7  SET @PersianMonthNameLatin='Mehr'
	ELSE IF @PersianMonthNumberOfYear= 6  SET @PersianMonthNameLatin='Shahrivar'
	ELSE IF @PersianMonthNumberOfYear= 5  SET @PersianMonthNameLatin='Mordad'
	ELSE IF @PersianMonthNumberOfYear= 4  SET @PersianMonthNameLatin='Tir'
	ELSE IF @PersianMonthNumberOfYear= 3  SET @PersianMonthNameLatin='Khordad'
	ELSE IF @PersianMonthNumberOfYear= 2  SET @PersianMonthNameLatin='Ordibehesht'
	ELSE IF @PersianMonthNumberOfYear= 1  SET @PersianMonthNameLatin='Farvardin'

	SET @PersianDayOfWeek = iif(@DayOfWeek + 1 = 8, 1, @DayOfWeek + 1)


	IF @PersianDayOfWeek = 1
		SET @PersianDayOfWeekName = N'شنبه'
	ELSE IF @PersianDayOfWeek = 2
		SET @PersianDayOfWeekName = N'یکشنبه'
	ELSE IF @PersianDayOfWeek = 3
		SET @PersianDayOfWeekName = N'دوشنبه'
	ELSE IF @PersianDayOfWeek = 4
		SET @PersianDayOfWeekName = N'سه شنبه'
	ELSE IF @PersianDayOfWeek = 5
		SET @PersianDayOfWeekName = N'چهارشنبه'
	ELSE IF @PersianDayOfWeek = 6
		SET @PersianDayOfWeekName = N'پنجشنبه'
	ELSE IF @PersianDayOfWeek = 7
		SET @PersianDayOfWeekName = N'جمعه'

	IF @PersianDayOfWeek < 6
		SET @PersianDayOfWeekType = 'Workday'
	ELSE SET @PersianDayOfWeekType = 'Weekend'

	
	IF @PersianMonthNumberOfYear BETWEEN 1 AND 3
	BEGIN
		SET @PersianCalendarQuarter = 1
		SET @PersianCalendarSeason = N'بهار'
	END
	ELSE IF @PersianMonthNumberOfYear BETWEEN 4 AND 6
	BEGIN
		SET @PersianCalendarQuarter = 2
		SET @PersianCalendarSeason = N'تابستان'
	END
	ELSE IF @PersianMonthNumberOfYear BETWEEN 7 AND 9
	BEGIN
		SET @PersianCalendarQuarter = 3
		SET @PersianCalendarSeason = N'پاییز'
	END
	ELSE IF @PersianMonthNumberOfYear BETWEEN 10 AND 12
	BEGIN
		SET @PersianCalendarQuarter = 4
		SET @PersianCalendarSeason = N'زمستان'
	END


	--Test/Debug mode
	/*
	SELECT  @PersianDateKey AS PersianDateKey
		,@PersianFullDate			AS PersianFullDate
		,@PersianCalendarYear		AS PersianCalendarYear
		,@PersianMonthNumberOfYear	AS PersianMonthNumberOfYear
		,@PersianMonthName			AS PersianMonthName
		,@PersianMonthNameLatin		AS PersianMonthNameLatin
		,@PersianDayOfMonth			AS PersianDayOfMonth
		,@PersianDayOfWeek			AS PersianDayOfWeek
		,@PersianDayOfWeekName		AS PersianDayOfWeekName
		,@PersianDayOfWeekType		AS PersianDayOfWeekType
		,@PersianCalendarQuarter	AS PersianCalendarQuarter
		,@PersianCalendarSeason		AS PersianCalendarSeason
	*/

	INSERT dbo.DimDate (
		 DateKey
		,FullDateDatabaseStandard	
		,FullDateDatabaseStandardText
		,FullDateBritish
		,FullDateAmerican
		,YearNumber				
		,MonthNumberOfYear			
		,[MonthName]				
		,[DayOfYear]				
		,[DayOfMonth]				
		,[DayOfWeek]					
		,DayOfWeekName				
		,DayOfWeekType				
		,CalendarQuarter			
		,CalendarQuarterName		
		,Season		
		,PersianDateKey
		,PersianFullDate
		,PersianCalendarYear
		,PersianMonthNumberOfYear
		,PersianMonthName
		,PersianMonthNameLatin
		,PersianDayOfMonth
		,PersianDayOfWeek
		,PersianDayOfYear
		,PersianDayOfWeekName
		,PersianDayOfWeekType
		,PersianCalendarQuarter
		,PersianCalendarSeason
		)
	VALUES (
		 @DateKey
		,@FullDateDatabaseStandard	
		,@FullDateDatabaseStandardText
		,@FullDateBritish
		,@FullDateAmerican
		,@YearNumber				
		,@MonthNumberOfYear			
		,@MonthName					
		,@DayOfYear					
		,@DayOfMonth				
		,@DayOfWeek					
		,@DayOfWeekName				
		,@DayOfWeekType				
		,@CalendarQuarter			
		,@CalendarQuarterName		
		,@Season		
		,@PersianDateKey
		,@PersianFullDate
		,@PersianCalendarYear
		,@PersianMonthNumberOfYear
		,@PersianMonthName
		,@PersianMonthNameLatin
		,@PersianDayOfMonth
		,@PersianDayOfWeek
		,@PersianDayOfYear
		,@PersianDayOfWeekName
		,@PersianDayOfWeekType
		,@PersianCalendarQuarter
		,@PersianCalendarSeason
		)

	SET @date = DATEADD(d, 1, @date) 

END

SELECT * FROM dbo.DimDate