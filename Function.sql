CREATE FUNCTION dbo.ufn_ConvertGregorianToPersian ( @Date DATETIME )
RETURNS NVARCHAR(max)
BEGIN

	DECLARE 
		 @shYear AS INT
		,@shMonth AS INT
		,@shDay AS INT
		,@intYY AS INT
		,@intMM AS INT
		,@intDD AS INT
		,@Kabiseh  AS INT
		,@shKabiseh AS INT
		,@d1 AS INT
		,@m1 AS INT
		,@shMaah AS NVARCHAR(max)
		,@shRooz AS NVARCHAR(max)
		,@DayCnt AS INT

	DECLARE @DayDate AS NVARCHAR(max)


	SET @intYY = DATEPART(yyyy, @Date)

	IF @intYY < 1000 
		SET @intYY = @intYY + 2000

	SET @intMM = MONTH(@Date)
	SET @intDD = DAY(@Date)
	SET @shYear = @intYY - 622
	SET @DayCnt = DATEPART(dw, '01/02/' + CONVERT(CHAR(4), @intYY))

	SET @m1 = 1
	SET @d1 = 1
	SET @shMonth = 10
	SET @shDay = 11

	IF ((@intYY - 1993) % 4 = 0) 
		SET @shDay = 12

	WHILE (@m1 != @intMM) OR (@d1 != @intDD)
	BEGIN

		SET @d1 = @d1 + 1
		SET @DayCnt = @DayCnt + 1

		IF((@intYY - 1992) % 4 = 0) 
			SET @Kabiseh = 1 
		ELSE 
			SET @Kabiseh = 0

		IF((@shYear - 1371) % 4 = 0) 
			SET @shKabiseh = 1 
		ELSE 
			SET @shKabiseh = 0



		IF (@d1 = 32 AND (@m1 = 1 OR @m1 = 3 OR @m1 = 5 OR @m1 = 7 OR @m1 = 8 OR @m1 = 10 OR @m1 = 12))
			OR (@d1 = 31 AND (@m1 = 4 OR @m1 = 6 OR @m1 = 9 OR @m1 = 11))
			OR (@d1 = 30 AND @m1 = 2 AND @Kabiseh = 1)
			OR (@d1 = 29 AND @m1 = 2 AND @Kabiseh = 0)
		BEGIN
			SET @m1 = @m1 + 1
			SET @d1 = 1
		END

		IF @m1 > 12
		BEGIN
			SET @intYY = @intYY + 1
			SET @m1 = 1
		END

		IF @DayCnt > 7 
			SET @DayCnt = 1

		SET @shDay = @shDay + 1

		IF (@shDay = 32 AND @shMonth < 7)
			OR (@shDay = 31 AND @shMonth > 6 AND @shMonth < 12)
			OR (@shDay = 31 AND @shMonth = 12 AND @shKabiseh = 1)
			OR (@shDay = 30 AND @shMonth = 12 AND @shKabiseh = 0)
		BEGIN
			SET @shMonth = @shMonth + 1
			SET @shDay = 1
		END

		IF @shMonth > 12
		BEGIN
			SET @shYear = @shYear + 1
			SET @shMonth = 1
		END

	END

	IF @shMonth=1 SET @shMaah=N'فروردین'
	IF @shMonth=2 SET @shMaah=N'اردیبهشت'
	IF @shMonth=3 SET @shMaah=N'خرداد'
	IF @shMonth=4 SET @shMaah=N'تیر'
	IF @shMonth=5 SET @shMaah=N'مرداد'
	IF @shMonth=6 SET @shMaah=N'شهریور'
	IF @shMonth=7 SET @shMaah=N'مهر'
	IF @shMonth=8 SET @shMaah=N'آبان'
	IF @shMonth=9 SET @shMaah=N'آذر'
	IF @shMonth=10 SET @shMaah=N'دی'
	IF @shMonth=11 SET @shMaah=N'بهمن'
	IF @shMonth=12 SET @shMaah=N'اسفند'

	IF @DayCnt=1 SET @shRooz=N'شنبه'
	IF @DayCnt=2 SET @shRooz=N'یکشنبه'
	IF @DayCnt=3 SET @shRooz=N'دوشنبه'
	IF @DayCnt=4 SET @shRooz=N'سه‌شنبه'
	IF @DayCnt=5 SET @shRooz=N'چهارشنبه'
	IF @DayCnt=6 SET @shRooz=N'پنجشنبه'
	IF @DayCnt=7 SET @shRooz=N'جمعه'


	--1394/02/17
	SET @DayDate = REPLACE(RIGHT(STR(@shYear, 4), 4), ' ', '0') + '/'+ REPLACE(STR(@shMonth, 2), ' ', '0') + '/' + REPLACE(( STR(@shDay,2) ), ' ', '0')

	/*

	-------- Here are different types of DayDate that can be generated -------------

	--پنجشنبه 17 اردیبهشت 1394
	SET @DayDate = @shRooz + ' ' + LTRIM(STR(@shDay,2)) + ' ' + @shMaah + ' ' + STR(@shYear,4)


	--17 اردیبهشت 1394
	SET @DayDate = LTRIM(STR(@shDay,2)) + ' ' + @shMaah + ' ' + STR(@shYear,4)


	--1394/2/17
	SET @DayDate = STR(@shYear,4) + '/'+LTRIM(STR(@shMonth,2)) + '/' + LTRIM(STR(@shDay,2))


	*/


	RETURN @DayDate

END

GO
