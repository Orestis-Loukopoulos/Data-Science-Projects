# pip install mysql-connector-python
import mysql.connector
conn = mysql.connector.connect(
    host='localhost', user='root', passwd='STam1996!', database='e_properties')
myCursor = conn.cursor()


def view_queries():
    view_queries_lista = []
    # Creates VIEWS via SQL queries and adds them to a list
    query1 = 'CREATE VIEW VTOTAL_FOR_LOC_5 AS\
                SELECT location_id, cnt\
                            FROM (\
                                SELECT x.location_id,\
                                    (SELECT COUNT(valuation.valuation_id)\
                                    FROM valuation\
                                    LEFT JOIN property\
                                        ON valuation.property_id = property.property_id\
                                    WHERE x.location_id = property.location_id AND valuation.val_year = 2020) AS cnt\
                                FROM (\
                                SELECT DISTINCT location_id FROM property INNER JOIN valuation on valuation.property_id=property.property_id WHERE valuation.val_year=2020) AS x) AS y'

    query2 = 'CREATE VIEW VTOTAL_FOR_ALL_5 AS\
                SELECT COUNT(valuation_id) AS total_valuations_2020\
                FROM valuation\
                WHERE val_year=2020;'

    query3 = 'CREATE VIEW POPULATION_LOC_5 AS\
                SELECT location_id, population AS pop_loc\
                FROM loc;'

    query4 = 'CREATE VIEW POPULATION_TOTAL_5 AS\
                SELECT SUM(distinct(population)) AS total_population\
                FROM loc;'

    for i in (query1, query2, query3, query4):
        view_queries_lista.append(i)

    return(view_queries_lista)


def main_query():
    # The main SQL query
    query5 = 'SELECT  vtotal_for_loc_5.location_id, (vtotal_for_loc_5.cnt/total_valuations_2020)*100 AS cnt_val, (pop_loc/total_population)*100 AS cnt_pop\
                FROM vtotal_for_loc_5, vtotal_for_all_5, population_loc_5, population_total_5\
                WHERE vtotal_for_loc_5.location_id=population_loc_5.location_id;'
    return query5


def main():
    # Executes View queries
    for i in view_queries():
        myCursor.execute(i)
    # Executes main query
    myCursor.execute(main_query())
    # Prints table
    print("\nTABLE ANSWER TO QUESTION 5\n")
    for location_id, cnt_val, cnt_pop in myCursor:
        print(location_id, cnt_val, cnt_pop)


if __name__ == "__main__":
    main()
