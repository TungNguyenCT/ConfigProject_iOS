//
//  HomeViewController.swift
//  ConfigProject
//
//  Created by MBA0239P on 3/18/19.
//  Copyright © 2019 Tung Nguyen C.T. All rights reserved.
//

import UIKit
import SwifterSwift

class HomeViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var calendarCollectionView: UICollectionView!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var monthLabel: UILabel!

    // MARK: - Properties
    let date = Date()
    let calendar = Calendar.current
    lazy var day = calendar.component(.day, from: date)
    lazy var weekday = calendar.component(.weekday, from: date) - 1 // sunday return 0, monday return 1, ....
    lazy var month = calendar.component(.month, from: date) - 1
    lazy var year = calendar.component(.year, from: date)

    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    var currentMonth = String()
    var numberOfEmptyBox = Int() // The number of empty boxex at start of the current month
    var nextNumberOfEmptyBox = Int() // next month
    var previousNumberOfEmptyBox = Int()
    var direction = 0 // = 0 if at the current mont, = 1 if at a future month, = -1 if at a past month
    var positionIndex = 0 // store above vars of the empty boxes
    var leapYearCounter = 2
    var dayCounter = 0

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        currentMonth = months[month]
        monthLabel.text = "\(currentMonth) \(year)"
        if weekday == 0 {
            weekday = 7
        }
        getStartDateDayPosition()
    }

    private func configCollectionView() {
        calendarCollectionView.register(nibWithCellClass: CalendarCollectionCell.self)
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        let width = (calendarCollectionView.width - 50) / 7
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: width, height: width)
        calendarCollectionView.collectionViewLayout = layout
    }

    @IBAction private func nextButtonTouchUpInside(_ sender: UIButton) {
        switch currentMonth {
        case "Dec":
            month = 0
            year += 1
            direction = 1

            if year % 4 == 0 && year % 100 != 0 {
                daysInMonth[1] = 29
            } else {
                daysInMonth[1] = 28
            }

            getStartDateDayPosition()

            currentMonth = months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            calendarCollectionView.reloadData()
        default:
            direction = 1

            getStartDateDayPosition()

            month += 1

            currentMonth = months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            calendarCollectionView.reloadData()
        }
    }

    @IBAction private func backButtonTouchUpInside(_ sender: UIButton) {
        switch currentMonth {
        case "Jan":
            month = 11
            year -= 1
            direction = -1

            if year % 4 == 0 && year % 100 != 0 {
                daysInMonth[1] = 29
            } else {
                daysInMonth[1] = 28
            }

            getStartDateDayPosition()

            currentMonth = months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            calendarCollectionView.reloadData()
        default:
            month -= 1
            direction = -1
            getStartDateDayPosition()
            currentMonth = months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            calendarCollectionView.reloadData()
        }
    }

    private func getStartDateDayPosition() {
        switch direction {
        case 0:
            numberOfEmptyBox = weekday
            dayCounter = day
            while dayCounter > 0 {
                numberOfEmptyBox -= 1
                dayCounter -= 1
                if numberOfEmptyBox == 0 {
                    numberOfEmptyBox = 7
                }
            }
            if numberOfEmptyBox == 7 {
                numberOfEmptyBox = 0
            }
            positionIndex = numberOfEmptyBox
        case 1...:
            nextNumberOfEmptyBox = (positionIndex + daysInMonth[month]) % 7
            positionIndex = nextNumberOfEmptyBox
        case -1:
            previousNumberOfEmptyBox = (7 - (daysInMonth[month] - positionIndex) % 7)
            if previousNumberOfEmptyBox == 7 {
                previousNumberOfEmptyBox = 0
            }
            positionIndex = previousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch direction {
//        case 0:
//            return daysInMonth[month] + numberOfEmptyBox
//        case 1...:
//            return daysInMonth[month] + nextNumberOfEmptyBox
//        case -1:
//            return daysInMonth[month] + previousNumberOfEmptyBox
//        default:
//            fatalError()
//        }
        return 35
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: CalendarCollectionCell.self, for: indexPath)
        cell.backgroundColor = .clear
        cell.dateLabel.textColor = .black
        if cell.isHidden {
            cell.isHidden = false
        }
        switch direction {
        case 0:
            cell.dateLabel.text = "\(indexPath.row + 1 - numberOfEmptyBox)"
        case 1...:
            cell.dateLabel.text = "\(indexPath.row + 1 - nextNumberOfEmptyBox)"
        case -1:
            cell.dateLabel.text = "\(indexPath.row + 1 - previousNumberOfEmptyBox)"
        default:
            fatalError()
        }
        guard let number = Int(cell.dateLabel.text ?? "") else {
            return cell
        }

        switch indexPath.row {
        case 5,6,12,13,19,20,26,27,33,34:
            if number > 0 {
                cell.dateLabel.textColor = .red
            }
        default:
            break
        }

        if number < 1 {
            if month != 0 {
                cell.dateLabel.text = "\(daysInMonth[month - 1] + number)"
            } else {
                cell.dateLabel.text = "\(daysInMonth[11] + number)"
            }
            cell.dateLabel.textColor = .lightGray
        } else if number > daysInMonth[month] {
            cell.dateLabel.text = "\(number - daysInMonth[month])"
            cell.dateLabel.textColor = .lightGray
        }

        if currentMonth == months[calendar.component(.month, from: date) - 1] && year == calendar.component(.year, from: date) && indexPath.row + 1 - numberOfEmptyBox == day {
            let center = ((UIScreen.main.bounds.width - 90) / 7) / 2
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: center,y: center), radius: CGFloat(center - 3), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)

            let shapeLayer = CAShapeLayer()
            shapeLayer.name = "circle"
            shapeLayer.path = circlePath.cgPath

            //change the fill color
            shapeLayer.fillColor = UIColor.clear.cgColor
            //you can change the stroke color
            shapeLayer.strokeColor = UIColor.red.cgColor
            //you can change the line width
            shapeLayer.lineWidth = 3.0

            // We want to animate the strokeEnd property of the circleLayer
            let animation = CABasicAnimation(keyPath: "strokeEnd")

            // Set the animation duration appropriately
            animation.duration = 2

            // Animate from 0 (no circle) to 1 (full circle)
            animation.fromValue = 0
            animation.toValue = 1

            // Do a linear animation (i.e. the speed of the animation stays the same)
            animation.timingFunction = CAMediaTimingFunction(name:.linear)

            // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
            // right value when the animation ends.
            shapeLayer.strokeEnd = 1.0

            // Do the actual animation
            shapeLayer.add(animation, forKey: "animateCircle")

            cell.layer.addSublayer(shapeLayer)

        }

        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
}
