# == Schema Information
#
# Table name: countries
#
#  name        :string       not null, primary key
#  continent   :string
#  area        :integer
#  population  :integer
#  gdp         :integer

require_relative './sqlzoo.rb'

def highest_gdp
  # Which countries have a GDP greater than every country in Europe? (Give the
  # name only. Some countries may have NULL gdp values)
  execute(<<-SQL)
    select
      name
    from
      countries
    where
      gdp > (select 
              max(gdp)
            from
              countries
            where
              continent = 'Europe');
  SQL
end

def largest_in_continent
  # Find the largest country (by area) in each continent. Show the continent,
  # name, and area.
  execute(<<-SQL)
    select
      continent, name, area
    from 
      (select continent, name, area, 
        rank() over (partition by continent order by area desc) as r
      from 
        countries
      ) temp
    where 
        r = 1
  SQL
end

def large_neighbors
  # Some countries have populations more than three times that of any of their
  # neighbors (in the same continent). Give the countries and continents.
  execute(<<-SQL)
    select
      name, countries.continent
    from 
      countries 
    join 
      (select 
        continent, population as second_pop 
      from(select 
              continent,
              population, 
              rank() over(partition by continent order by population desc) as r
            from 
              countries) temp2
      where 
        r = 2) temp
    on countries.continent = temp.continent
    where
      countries.population > 3 * second_pop;
  SQL
end
