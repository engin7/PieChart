//
//  Models.swift
//  PieChart
//
//  Created by Engin KUK on 30.11.2021.
//

import UIKit

 
// sample data

let seriesPoints0: [AxisData] = [
//    AxisData(index: 0, label: "SAN", value: 1),
//    AxisData(index: 0, label: "Hüseyin", value: 0),

   AxisData(index: 0, label: "apple", value: 50),
   AxisData(index: 1, label: "cherries", value: 40),
   AxisData(index: 2, label: "oranges and oranges oranges and oranges oranges and oranges oranges and oranges", value: 90),
   AxisData(index: 3, label: "peaches", value: 0),
   AxisData(index: 4, label: "pears", value: 50),
   AxisData(index: 5, label: "banana", value: 70),
   AxisData(index: 6, label: "nuts", value: 100),
   AxisData(index: 7, label: "pumpkin", value: 50),
   AxisData(index: 8, label: "rose", value: 30),
   AxisData(index: 9, label: "oranges and oranges oranges and oranges oranges and oranges oranges and oranges", value: 20),
   AxisData(index: 10, label: "cheese", value: 60),
]

let seriesPoints1: [AxisData] = [
//    AxisData(index: 0, label: "Hüseyin", value: 1),
//    AxisData(index: 0, label: "SAN", value: 0),
    
   AxisData(index: 0, label: "apples", value: 50),
   AxisData(index: 1, label: "cherries", value: 0),
   AxisData(index: 2, label: "oranges", value: 0),
   AxisData(index: 3, label: "peaches", value: 55),
   AxisData(index: 4, label: "pears", value: 50),
   AxisData(index: 5, label: "banana", value: 30),
   AxisData(index: 6, label: "nuts", value: 40),
   AxisData(index: 7, label: "pumpkin", value: 45),
   AxisData(index: 8, label: "rose", value: 35),
   AxisData(index: 9, label: "bread", value: 25),
   AxisData(index: 10, label: "cheese", value: 30),
]

let seriesPoints2: [AxisData] = [
//    AxisData(index: 0, label: "Hüseyin", value: 1),
//    AxisData(index: 0, label: "SAN", value: 0)
    
   AxisData(index: 0, label: "apples", value: 50),
   AxisData(index: 1, label: "cherries", value: 35),
   AxisData(index: 2, label: "oranges", value: 20),
   AxisData(index: 3, label: "peaches", value: 55),
   AxisData(index: 4, label: "pears", value: 50),
   AxisData(index: 5, label: "banana", value: 0),
   AxisData(index: 6, label: "nuts", value: 40),
   AxisData(index: 7, label: "pumpkin", value: 45),
   AxisData(index: 8, label: "rose", value: 35),
   AxisData(index: 9, label: "bread", value: 25),
   AxisData(index: 10, label: "cheese", value: 0),
]

let dataSet0: SeriesDataSet = SeriesDataSet(seriesName: "Farm I", seriesPoints: seriesPoints0)
let dataSet1: SeriesDataSet = SeriesDataSet(seriesName: "Farm II", seriesPoints: seriesPoints1)
let dataSet2: SeriesDataSet = SeriesDataSet(seriesName: "Farm III", seriesPoints: seriesPoints2)

let globaChartData = [dataSet0, dataSet1, dataSet2]
/// Data Models
 

