use bikes_db

// Task 2.2 
// How many bikes are there for sale?
db.ads.count() 

// Task 2.3
// What is the average price of a motorcycle (give a number)? 
// What is the number of listings that were used in order to calculate this average (give a number as well)? 
// Is the number of listings used the same as the answer in 2.2? Why?

db.ads.aggregate([
    {
      '$match': {
          'ad_data.Price': {
              '$exists': true
              }
          }
      },
      {
          '$group': {
              '_id': null,
              'avg_price': {
                  '$avg': '$ad_data.Price'
              }
          }
      }
])
      
  
db.ads.find({'ad_data.Price' : {'$ne': null}}).count()


// Task 2.4
// What is the maximum and minimum price of a motorcycle currently available in the market?
db.ads.aggregate([   
    { 
      "$match" : {
          "ad_data.Price" : {
                "$exists" : true 
            } 
          }
        }, 
            {
        "$group": {
            "_id": null, 
            "MaxPrice": {
              "$max":"$ad_data.Price"
                }, 
            "MinPrice": {
              "$min":"$ad_data.Price"
        }
      }
   }
   ])


// Task 2.5
// How many listings have a price that is identified as negotiable?

db.ads.find({ "ad_data.Negotiable": true}).count()

// Task 2.6 (Optional)
// For each Brand, what percentage of its listings is listed as negotiable?

db.ads.aggregate([
    {
        '$match':{
        "metadata.brand": {'$exists' :true}
        }
    }
    ,{
        '$group':{
            '_id': '$metadata.brand',
            'count_Negotiable': {
                '$sum': { '$cond': [{'$eq': ["$ad_data.Negotiable", true]}, 1, 0]}
            },
            'Total': {
                '$sum': 1
            }
        }
    },
    {
        '$project':{
            'Percentage_of_Negotiable':{
                '$divide':['$count_Negotiable','$Total']
            }
        }
    }])

// Task 2.7 (optional)
// What is the motorcycle brand with the highest average price?

db.ads.aggregate([
        {
            '$group':{
                '_id': '$metadata.brand',
                'avg_price': {
                    '$avg': '$ad_data.Price'
                }
            }
        },
        {
          '$sort': {
              'avg_price': -1
              }
         },
         {
             '$limit': 1
             } ])

// Task 2.8 (optional)
// What are the TOP 10 models with the highest average age? 

db.ads.aggregate([
         {
            '$group': {
               '_id': '$ad_data.Make/Model',
                'avg_Age': {
                    '$avg': '$ad_data.Age'
                }
            }
        },
        { 
            '$project': {
                'rounded_AVG_AGE':{
                    '$round' :['$avg_Age', 1]
                }
            }
        },
        {
            '$sort':{
                'rounded_AVG_AGE':-1
            }
        },
        {
            '$limit': 10
                }])


// Task 2.9 (optional)
// How many bikes have “ABS” as an extra? 
db.ads.find({'extras': 'ABS'}).count()

// Task 2.10 (optional)
// What is the average Mileage of bikes that have “ABS” AND “Led lights” as an extra?

db.ads.aggregate([
      {
          '$match': {
              'extras' : 'ABS', 
              'extras': 'Led lights' , 
              'ad_data.Mileage' : {
                "$exists" : true 
            } 
          }
      },
      {
          '$group': {
              '_id': null,
              'avg_Mileage': {
                  '$avg': '$ad_data.Mileage'
              }
          }
      }])
      
// Task 2.11 (optional)
// What are the TOP 3 colors per bike category?

db.ads.aggregate([
    {
        '$group': {
            '_id': {
                'Category': '$ad_data.Category', 
                'Color': '$ad_data.Color'
                },
                'count_col':{
                    '$sum': 1
                }
            }
        },
        {   
           '$sort':{
               'count_col': -1
                   }
         },
         {
             '$group': {
                 '_id': '$_id.Category',
                 'Colors': {
                     '$push': {
                         'Color': '$_id.Color',
                         'count_col': '$count_col'
                     }
                 }
             }
         },
         {
             '$project': {
                 'Colors': { 
                     "$slice": [ "$Colors", 3 ] 
                     }
                 }
             }])

// Task 2.12 (optional)
// Identify a set of ads that you consider “Best Deals”. 
             
// Create variable avgprice

var cursorP = db.ads.aggregate([ 
    {
      '$match': {
          'ad_data.Price': {
              '$exists': true
              }
          }
    },
    { 
        "$group": { 
            "_id": null, 
            "avgprice": { 
                "$avg": "$ad_data.Price" 
                }
            }
        }   
])
        
var avgprice = cursorP.toArray()[0]["avgprice"]

// Create variable avgmileage
var cursorM = db.ads.aggregate([ 
    {
      '$match': {
          'ad_data.Mileage': {
              '$exists': true
              }
          }
    },
    { 
        "$group": { 
            "_id": null, 
            "avgmileage": { 
                "$avg": "$ad_data.Mileage" 
                }
            }
        }   
])
        
var avgmileage = cursorM.toArray()[0]["avgmileage"]    

// Create variable avgage
var cursorA = db.ads.aggregate([ 
    {
      '$match': {
          'ad_data.Age': {
              '$exists': true
              }
          }
    },
    { 
        "$group": { 
            "_id": null, 
            "avgage": { 
                "$avg": "$ad_data.Age" 
                }
            }
        }   
])
        
var avgage = cursorA.toArray()[0]["avgage"]    

db.ads.find({$and:[{'ad_data.Price' : {'$lt': avgprice}},{'ad_data.Mileage': {'$lt': avgmileage}},{'ad_data.Age': {'$lt': avgage}}]})

