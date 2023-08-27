//
//  TimeLineView.swift
//  podcastCropper
//
//  Created by Тимур Куашев on 26.08.2023.
//

import UIKit

final class TimeLineView: UIView {
    private struct Section {
        var lineView: UIView = UIView()
        var leftCons: NSLayoutConstraint?
        var rightCons: NSLayoutConstraint?
        var lblTime: UILabel = {
            let lbl = UILabel()
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.textColor = .labelsTertiary
            lbl.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            return lbl
        }()
    }
    private var sections: [Section] = []
    
    private let scrollView = UIScrollView()
    private let selfHeight: CGFloat = 25
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func config(zoomLvl: AudioWaveZoomLvls, audioDuration duration: Double) {
        let sectionsSpacing: CGFloat = 24
        let sepWidth: CGFloat = 1
        
        let secCount = Int(duration / zoomLvl.seconds) * Constants.TIMELINE_VIEW_SECTION_SUBSECTIONS_COUNT
        for i in 0..<secCount {
            let section = Section()
            section.lineView.backgroundColor = .labelsQuaternary
            section.lineView.translatesAutoresizingMaskIntoConstraints = false

            let h: CGFloat = i % 4 == 0 ? 10 : 5
            section.lineView.heightAnchor.constraint(equalToConstant: h).isActive = true
            section.lineView.widthAnchor.constraint(equalToConstant: sepWidth).isActive = true
            sections.append(section)
        }
        
        let v = UIView()
        v.attachTo(view: scrollView, toSides: [.all4Sides])
        v.heightAnchor.constraint(equalToConstant: selfHeight).isActive = true
        sections[0].lineView.attachTo(view: v, toSides: [.left, .top])
        sections[0].lblTime.text = "00"
        sections[0].lblTime.attachTo(view: v, toSides: [.bottom])
        for i in 1..<sections.count {
            sections[i].lblTime.attachTo(view: v, toSides: [.bottom])
            sections[i].lineView.attachTo(view: v, toSides: [.top])
            sections[i].leftCons = sections[i].lineView.leftAnchor.constraint(
                equalTo: sections[i-1].lineView.rightAnchor,
                constant: sectionsSpacing)
            sections[i].leftCons?.isActive = true
            
            sections[i].lblTime.leftAnchor.constraint(equalTo: sections[i].lineView.leftAnchor).isActive = true
            if i % 4 == 0 {
                let t = ((i / 4) * Int(zoomLvl.seconds))
                var text = ""
                if t.hours() > 0 {
                    text += t.hours().description + ":"
                }
                if t.minutes() > 0 {
                    text += t.minutes().description + ":"
                }
                text += t.seconds().description
                sections[i].lblTime.text = text
            }
        }
        sections.last?.lineView.rightAnchor.constraint(equalTo: v.rightAnchor).isActive = true
        let scrollWidth: CGFloat = CGFloat(sections.count) * (sepWidth + sectionsSpacing)
        print("TimeLine Scroll width: \(scrollWidth)")
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: scrollWidth, height: selfHeight)
        scrollView.contentInset = UIEdgeInsets(top: 0,
                                               left: scrollView.bounds.width / 2,
                                               bottom: 0,
                                               right: scrollView.bounds.width / 2)
        scrollView.contentOffset = CGPoint(x: -scrollView.contentInset.left, y: 0)
        scrollView.isUserInteractionEnabled = false
    }
    
    func setProgress(inPercents percent: Double) {
        scrollView.contentOffset.x = (scrollView.contentSize.width + scrollView.contentInset.left) / 100 * percent - scrollView.contentInset.left
    }
    
    private func commonInit() {
        scrollView.attachTo(view: self, toSides: [.all4Sides])
        NSLayoutConstraint.activate([
            scrollView.heightAnchor.constraint(equalToConstant: selfHeight)
        ])
    }
}
