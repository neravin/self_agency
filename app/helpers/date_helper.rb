module DateHelper
	def duration_time(tstart, tend)
		# duration time on site
    dt = TimeDifference.between(tend, tstart).in_general  # difference time
    years = dt[:years]                              # years
    months = dt[:months]                            # months
    days = dt[:days] + dt[:weeks] * 7               # days
    s_years = ""                                    # years to string format
    s_months = ""                                   # months to string format
    s_days = ""                                     # days to string format
    if years != 0
      s_years = years.to_s + " " + Russian::pluralize(years, "год", "года", "лет") + " "
    end
    if months != 0
      s_months = months.to_s + " " + Russian::pluralize(months, "месяц", "месяца", "месяцев") + " "
    end
   	if days != 0
    	s_days = days.to_s + " " + Russian::pluralize(days, "день", "дня", "дней")
    end
    duration_time = s_years + s_months + s_days
	end
end