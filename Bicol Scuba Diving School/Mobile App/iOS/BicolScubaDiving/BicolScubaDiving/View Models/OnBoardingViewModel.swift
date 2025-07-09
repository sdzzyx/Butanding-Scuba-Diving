//
//  OnBoardingViewModel.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 7/9/25.
//

import Foundation
import UIKit

class OnboardingViewModel {
    private var slides: [WelcomeModel] = []
    private(set) var currentSlideIndex: Int = 0 {
        didSet {
            onCurrentSlideChanged?()
        }
    }
    
    var onCurrentSlideChanged: (() -> Void)?
    
    init() {
        setupSlides()
    }
    
    private func setupSlides() {
        
        slides = [
            WelcomeModel(image: UIImage(named: "Welcome_Screen_1") ?? UIImage(), title: "Bicol Scuba Diving School", subtitle: "Explore the Depths", description: "Unleash your inner explorer as you embark on an exciting, fun program designed to boost your diving skills and deepen your understanding of core diving areas."),
            WelcomeModel(image: UIImage(named: "Welcome_Screen_2") ?? UIImage(), title: "Discovery Dive",subtitle: "Dive with Confidence", description: "Curious about scuba diving but not ready for a full course? Discovery Dive is the perfect first step into the ocean. You'll learn basic skills and get to experience a real dive under instructor supervision."),
            WelcomeModel(image: UIImage(named: "Welcome_Screen_3") ?? UIImage(), title: "Professional Dive Course",subtitle: "Get Scuba Certified", description: "Advance your skills and train to become a certified dive professional. This course covers advanced techniques, leadership, and real-world dive scenarios."),
            WelcomeModel(image: UIImage(named: "Welcome_Screen_4") ?? UIImage(), title: "Dive Training",subtitle: "Learn to Dive with Expert Guidance", description: "Sharpen your dive skills with focused, hands-on training. Learn safety procedures, underwater navigation, and gear handling in guided sessions. Ideal for beginners or divers looking to refresh and improve.")
        ]
    }
    
    var numberOfSlides: Int {
        return slides.count
    }
    
    func slide(at index: Int) -> WelcomeModel? {
        guard index >= 0 && index < slides.count else { return nil }
        return slides[index]
    }
    
    func setCurrentSlide(to index: Int) {
        guard index >= 0 && index < slides.count else { return }
        currentSlideIndex = index
    }
    
    var currentSlide: WelcomeModel? {
        return slide(at: currentSlideIndex)
    }
    
    var getStartedButtonTitle: String {
        return "Let's Get Started"
    }
}
