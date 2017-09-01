fun is_older (date1 : int*int*int, date2 : int*int*int) =
	(#1 date1 < #1 date2)
		orelse (#1 date1 = #1 date2 andalso #2 date1 < #2 date2)
		orelse (#1 date1 = #1 date2 andalso #2 date1 = #2 date2 andalso #3 date1 < #3 date2)

fun number_in_month (dates : (int*int*int) list, month : int) =
	if null dates
	then 0
	else
		let val left_dates = number_in_month ((tl dates), month)
		in 
			if #2 (hd dates) = month
			then left_dates + 1
			else left_dates
		end

fun number_in_months (dates : (int*int*int) list, months : int list) =
	if null months
	then 0
	else
		number_in_month ( dates, (hd months )) + number_in_months ( dates, ( tl months) )

fun dates_in_month (date : (int*int*int) list, month : int) =
    if null date
    then []
    else
        let
            val rest_dates = dates_in_month((tl date), month)
        in
            if #2 (hd date) = month
            then (hd date)::rest_dates
            else rest_dates
        end

fun dates_in_months (date : (int*int*int) list, months : int list) =
    if null months
    then []
    else
        dates_in_month(date, (hd months)) @ dates_in_months(date, (tl months))

fun get_nth (stringl : string list, n : int) =
    if n = 1
    then hd stringl
    else get_nth((tl stringl), n - 1)

fun date_to_string (date : int*int*int) =
    let
        val months = ["January", "February", "March", "April", "May", "June",
                      "July", "August", "September", "October", "November", "December"]
    in
        get_nth(months, #2 date) ^ " " ^ Int.toString(#3 date) ^ ", " ^ Int.toString(#1 date)
    end

fun number_before_reaching_sum (summa : int, int_list : int list) =
    if hd int_list >= summa
    then 0
    else 1 + number_before_reaching_sum(summa - (hd int_list), (tl int_list))

fun what_month (day : int) =
    let
        val days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    in
        1 + number_before_reaching_sum(day, days_in_month)
    end

fun month_range (day1 : int, day2 : int) =
    if day1 > day2
    then []
    else what_month(day1) :: month_range(day1 + 1, day2)

fun oldest (date : (int*int*int) list) =
    if null date
    then NONE
    else
        let
            val rest_oldest = oldest(tl date)
        in
            if isSome rest_oldest andalso is_older((valOf rest_oldest), (hd date))
            then rest_oldest
            else SOME (hd date)
        end
