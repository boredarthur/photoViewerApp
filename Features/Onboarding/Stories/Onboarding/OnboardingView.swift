import UIKit
import Photos

class OnboardingView: BaseView<OnboardingViewState> {

    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let pageControl = UIPageControl()
    private let continuationButton = DefaultButton()
    private let checkmarkView = CheckmarkView()

    weak var delegate: OnboardingViewDelegate?

    var items: [OnboardingCollectionViewCellModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        applyStyles()
    }

    private func configureSubviews() {
        addSubview(collectionView)
        addSubview(pageControl)
        addSubview(continuationButton)
        addSubview(checkmarkView)

        checkmarkView.fill(container: self)
        checkmarkView.isHidden = true

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        continuationButton.translatesAutoresizingMaskIntoConstraints = false

        collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true

        pageControl.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10).isActive = true

        continuationButton.leadingAnchor.constraint(
            equalTo: safeAreaLayoutGuide.leadingAnchor,
            constant: 24
        ).isActive = true
        continuationButton.trailingAnchor.constraint(
            equalTo: safeAreaLayoutGuide.trailingAnchor,
            constant: -24
        ).isActive = true
        continuationButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        continuationButton.topAnchor.constraint(
            equalTo: pageControl.bottomAnchor,
            constant: 30
        ).isActive = true
        continuationButton.bottomAnchor.constraint(
            equalTo: safeAreaLayoutGuide.bottomAnchor,
            constant: -30
        ).isActive = true
    }

    private func applyStyles() {
        viewStyle(self)
        continuationButtonStyle(continuationButton)
        pageControlStyle(pageControl)
        collectionViewStyle(collectionView)
    }

    override func render(state: OnboardingViewState) {
        super.render(state: state)
        self.items = state.items

        if state.permissionGranted {
            delegate?.savePassedOnboarding()
            checkmarkView.isHidden = false
            checkmarkView.configureView()
            checkmarkView.animate(with: 0.7) { completed in
                guard completed else { return }
                MainRouter.shared.routeToMainScreen()
            }
        }
    }

    private func pageChanged(to page: Int) {
        pageControl.currentPage = page
        continuationButton.setTitle(
            page == items.count - 1 ?
            "I believe you" :
            "Next",
            for: .normal
        )

        if page == items.count - 1 {
            continuationButton.shakeAnimation()
        }
    }
}

extension OnboardingView {

    @objc fileprivate func continueOnboarding() {
        if pageControl.currentPage == items.count - 1 {
            delegate?.requestPhotoAccess()
        } else {
            collectionView.isPagingEnabled = false

            collectionView.scrollToItem(
                at: IndexPath(item: pageControl.currentPage + 1, section: 0),
                at: .left,
                animated: true
            )

            collectionView.isPagingEnabled = true
            pageChanged(to: pageControl.currentPage + 1)
        }
    }
}

extension OnboardingView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OnboardingCollectionViewCell.identifier,
            for: indexPath
        ) as? OnboardingCollectionViewCell
        cell?.configure(with: items[indexPath.row])
        return cell ?? UICollectionViewCell(frame: .zero)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: self.collectionView.frame.width,
            height: self.collectionView.frame.height
        )
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageChanged(to: Int(scrollView.contentOffset.x) / Int(scrollView.frame.width))
    }
}

// MARK: Styles

extension OnboardingView {

    private func viewStyle(_ view: UIView) {
        view.backgroundColor = .black
    }

    private func continuationButtonStyle(_ view: DefaultButton) {
        view.setTitle("Next", for: .normal)
        view.addTarget(self, action: #selector(continueOnboarding), for: .touchUpInside)
    }

    private func pageControlStyle(_ view: UIPageControl) {
        view.currentPageIndicatorTintColor = .white
        view.numberOfPages = 2
    }

    private func collectionViewStyle(_ view: UICollectionView) {
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.isPagingEnabled = true
        view.delegate = self
        view.dataSource = self
        view.register(
            OnboardingCollectionViewCell.self,
            forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier
        )

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        view.collectionViewLayout = layout
    }
}
