//
//  ChartDataSet.swift
//  PieChart
//
//  Created by Engin KUK on 6.12.2021.
//

import Foundation


struct ChartDataSet {
let ChartType: GraphEnum
let data: [SeriesDataSet]
// colorPallette ?
}

struct SeriesDataSet {
let seriesName: String
let seriesPoints: [AxisData]
}

struct AxisData {
let index: Int
let label: String
let value: Double
}


enum GraphEnum {
case Pie
case Line
case Vertical
case Horizontal
case VerticalGrouped
case HorizontalGrouped
case VerticalStacked
case HorizontalStacked
}
