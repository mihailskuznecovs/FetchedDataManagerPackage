//
//  BitcoinManager.swift
//  BitcoinManager
//
//  Created by MihailsKuznecovs on 23/06/2021.
//

import Foundation

@available(iOS 10.0, *)
public class BitcoinManager {
    private var timer: Timer?
    private let network = NetworkManager()
    private let calendar: Calendar = .current
    private let formatter = DateComponentsFormatter()
    
    private var previousRate: Float = 0
    private var previousDate: Date = Date()
    
    
    public func startLoadingBitcoinData(completion: @escaping (BitcoinModel) -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.loadBitcoinData(completion: completion)
        }
    }
    
    public func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    public init() {}
    
    private func loadBitcoinData(completion: @escaping (BitcoinModel) -> Void) {
        network.ParseBitcoin { [weak self] bitcoinModel in
            guard let self = self, let model = bitcoinModel else { return }
            
            let (rateChange, difference) = self.calculateChange(newRate: model.bpi.EUR.rateFloat, newDate: model.time.updatedISO)
            
            let bitcoinModel = BitcoinModel(currency: model.bpi.EUR.description,
                                     rate: model.bpi.EUR.rate,
                                     disclaimer: model.disclaimer,
                                     timeDifference: difference,
                                     rateChange: rateChange)
            
            
            completion(bitcoinModel)
        }
    }
    
    private func calculateChange(newRate: Float, newDate: String) -> (Float, DateComponents) {
        if newRate > previousRate {
            updateDate(from: newDate)
        } else if newRate < previousRate {
            updateDate(from: newDate)
        }
        
        let rateChange = newRate - previousRate
        let difference = calculateTimeDifference()
        
        previousRate = newRate
        
        return (rateChange, difference)
    }
    
    private func updateDate(from dateString: String) {
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: dateString) {
            previousDate = date == previousDate ? Date() : date
        }
    }
    
    private func calculateTimeDifference() -> DateComponents {
        calendar.dateComponents([.second, .minute], from: previousDate, to: Date())
    }
    
    
//MARK: - Methods for Mocking Data
    
    public func mockLoadingBitcoinData(completion: @escaping (BitcoinModel) -> Void) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            let rateFloat: Float = Float.random(in: 100...10000)
            let (rateChange, difference) = self.calculateChange(newRate: rateFloat, newDate: self.dateString())
            let model = BitcoinModel(currency: "Mock Euro",
                                     rate: String(rateFloat),
                                     disclaimer: "MOCK Disclaimer",
                                     timeDifference: difference,
                                     rateChange: rateChange)
            completion(model)
        }
    }
    
    private func dateString() -> String {
        let earlyDate = Calendar.current.date(
          byAdding: .second,
            value: Int.random(in: -120...0),
          to: Date())
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.string(from: earlyDate!)
    }
    
}
