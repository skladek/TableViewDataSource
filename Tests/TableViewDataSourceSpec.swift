import Foundation
import Nimble
import Quick

@testable import SKTableViewDataSource

class TableViewDataSourceSpec: QuickSpec {

    let reuseId = "testReuseId"
    var unitUnderTest: TableViewDataSource<String>!

    override func spec() {
        describe("TableViewDataSource") {

            // MARK: Initializers

            context("init(objects:cellPresenter:delegate:)") {
                var delegate: TableViewDataSourceDelegate!
                var objects: [String]!

                beforeEach {
                    delegate = MockTableViewDataSourceDelegate()
                    objects = ["One", "Two", "Three", "Four", "Five"]
                    self.unitUnderTest = TableViewDataSource(objects: objects, delegate: delegate)
                }

                it("Should wrap the objects array") {
                    expect(self.unitUnderTest.objects.first).to(equal(objects))
                }

                it("Should set the delegate") {
                    expect(self.unitUnderTest.delegate).to(be(delegate))
                }
            }

            context("init(objects:cellPresenter:delegate:)") {
                var delegate: TableViewDataSourceDelegate!
                var objects: [[String]]!

                beforeEach {
                    delegate = MockTableViewDataSourceDelegate()
                    objects = [["One", "Two", "Three"], ["Three", "Four", "Five"]]
                    self.unitUnderTest = TableViewDataSource(objects: objects, delegate: delegate)
                }

                it("Should set the delegate") {
                    expect(self.unitUnderTest.delegate).to(be(delegate))
                }
            }

            context("init(objects:cell:cellPresenter:)") {
                var nib: UINib!
                var objects: [String]!

                beforeEach {
                    nib = UINib()
                    objects = ["One", "Two", "Three", "Four", "Five"]
                    self.unitUnderTest = TableViewDataSource(objects: objects, cell: nib)
                }

                it("Should wrap the objects array") {
                    expect(self.unitUnderTest.objects.first).to(equal(objects))
                }

                it("Should set the cellNib") {
                    expect(self.unitUnderTest.cellNib).to(be(nib))
                }

                it("Should set the cellClass to nil") {
                    expect(self.unitUnderTest.cellClass).to(beNil())
                }
            }

            context("init(objects:cell:cellPresenter:)") {
                var nib: UINib!
                var objects: [[String]]!

                beforeEach {
                    nib = UINib()
                    objects = [["One", "Two", "Three"], ["Three", "Four", "Five"]]
                    self.unitUnderTest = TableViewDataSource(objects: objects, cell: nib)
                }

                it("Should set the cellNib") {
                    expect(self.unitUnderTest.cellNib).to(be(nib))
                }

                it("Should set the cellClass to nil") {
                    expect(self.unitUnderTest.cellClass).to(beNil())
                }
            }

            context("init(objects:cell:cellPresenter:)") {
                var cellClass: UITableViewCell.Type!
                var objects: [String]!

                beforeEach {
                    cellClass = UITableViewCell.self
                    objects = ["One", "Two", "Three", "Four", "Five"]
                    self.unitUnderTest = TableViewDataSource(objects: objects, cell: cellClass)
                }

                it("Should wrap the objects array") {
                    let cellClass = UITableViewCell.self
                    self.unitUnderTest = TableViewDataSource(objects: objects, cell: cellClass)
                    expect(self.unitUnderTest.objects.first).to(equal(objects))
                }

                it("Should set the cellClass") {
                    let cellClass = UITableViewCell.self
                    self.unitUnderTest = TableViewDataSource(objects: objects, cell: cellClass)
                    expect(self.unitUnderTest.cellClass).to(be(cellClass))
                }

                it("Should set the cellNib to nil") {
                    let cellClass = UITableViewCell.self
                    self.unitUnderTest = TableViewDataSource(objects: objects, cell: cellClass)
                    expect(self.unitUnderTest.cellNib).to(beNil())
                }
            }

            context("init(objects:cell:cellPresenter:)") {
                var cellClass: UITableViewCell.Type!
                var objects: [[String]]!

                beforeEach {
                    cellClass = UITableViewCell.self
                    objects = [["One", "Two", "Three"], ["Three", "Four", "Five"]]
                    self.unitUnderTest = TableViewDataSource(objects: objects, cell: cellClass)
                }

                it("Should set the cellClass") {
                    let cellClass = UITableViewCell.self
                    self.unitUnderTest = TableViewDataSource(objects: objects, cell: cellClass)
                    expect(self.unitUnderTest.cellClass).to(be(cellClass))
                }

                it("Should set the cellNib to nil") {
                    let cellClass = UITableViewCell.self
                    self.unitUnderTest = TableViewDataSource(objects: objects, cell: cellClass)
                    expect(self.unitUnderTest.cellNib).to(beNil())
                }
            }

            context("init(objects:cellClass:cellNib:cellPresenter:)") {
                let objects: [[String]] = [["One", "Two", "Three"], ["Three", "Four", "Five"]]

                beforeEach() {
                    self.unitUnderTest = TableViewDataSource(objects: objects, cellClass: nil, cellNib: nil, cellPresenter: nil)
                }

                it("Should set the objects array") {
                    expect(self.unitUnderTest.objects.first).to(equal(objects.first))
                    expect(self.unitUnderTest.objects.last).to(equal(objects.last))
                }

                it("Should set the objects array to an empty array if the parameter is nil") {
                    let objects: [[String]]? = nil
                    self.unitUnderTest = TableViewDataSource(objects: objects, cellClass: nil, cellNib: nil, cellPresenter: nil)
                    expect(self.unitUnderTest.objects.count).to(equal(0))
                }
            }

            // MARK: Public Methods

            context("delete(indexPath:)") {
                let objects = [["S0R0", "S0R1", "S0R2"], ["S1R0", "S1R1", "S1R2"]]

                beforeEach {
                    self.unitUnderTest = TableViewDataSource(objects: objects, cellNib: nil)
                }

                it("Should delete the object at the specified index path") {
                    self.unitUnderTest.deleteObjectAt(IndexPath(row: 1, section: 1))
                    let sectionArray = self.unitUnderTest.objects[1]

                    expect(sectionArray).to(equal(["S1R0", "S1R2"]))
                }
            }

            context("indexPathOf(_: T) -> IndexPath?") {
                let objects = [["S0R0", "S0R1", "S0R2"], ["S1R0", "S1R1", "S1R2"]]

                beforeEach {
                    self.unitUnderTest = TableViewDataSource(objects: objects, cellNib: nil)
                }

                it("Should return nil if the object is not contained in the array") {
                    let result = self.unitUnderTest.indexPathOf("S2R4")
                    expect(result).to(beNil())
                }

                it("Should return the index path if the item is contained in the array") {
                    let result = self.unitUnderTest.indexPathOf("S0R1")
                    let expectedIndexPath = IndexPath(row: 1, section: 0)
                    expect(result).to(equal(expectedIndexPath))
                }
            }

            context("insert(_:indexPath:)") {
                let objects = [["S0R0", "S0R1", "S0R2"], ["S1R0", "S1R1", "S1R2"]]

                beforeEach {
                    self.unitUnderTest = TableViewDataSource(objects: objects, cellNib: nil)
                }

                it("Should insert the given object at the specified index path") {
                    let object = "insertedObject"
                    self.unitUnderTest.insert(object: object, at: IndexPath(row: 1, section: 1))
                    let sectionArray = self.unitUnderTest.objects[1]

                    expect(sectionArray).to(equal(["S1R0", "insertedObject", "S1R1", "S1R2"]))
                }
            }

            context("moveFrom(_:to:)") {
                let objects = [["S0R0", "S0R1", "S0R2"], ["S1R0", "S1R1", "S1R2"]]

                beforeEach {
                    self.unitUnderTest = TableViewDataSource(objects: objects, cellNib: nil)
                }

                it("Should move the object at the from index path to the to index path") {
                    let fromIndexPath = IndexPath(row: 1, section: 0)
                    let toIndexPath = IndexPath(row: 2, section: 1)
                    self.unitUnderTest.moveObjectFrom(fromIndexPath, to: toIndexPath)
                    let sectionZero = self.unitUnderTest.objects[0]
                    let sectionOne = self.unitUnderTest.objects[1]

                    expect(sectionZero).to(equal(["S0R0", "S0R2"]))
                    expect(sectionOne).to(equal(["S1R0", "S1R1", "S0R1", "S1R2"]))
                }
            }

            context("object(indexPath:) -> T") {
                let objects = [["S0R0", "S0R1", "S0R2"], ["S1R0", "S1R1", "S1R2"]]

                beforeEach {
                    self.unitUnderTest = TableViewDataSource(objects: objects, cellNib: nil)
                }

                it("Should return the object at the specified index path") {
                    let indexPath = IndexPath(row: 1, section: 1)
                    expect(self.unitUnderTest.objectAt(indexPath)).to(equal("S1R1"))
                }
            }

            context("numberOfSections(in:)") {
                let objects = [["S0R0", "S0R1", "S0R2"], ["S1R0", "S1R1", "S1R2"]]

                beforeEach {
                    self.unitUnderTest = TableViewDataSource(objects: objects, cellNib: nil)
                }

                it("Should return 2 if there is no delegate set") {
                    expect(self.unitUnderTest.numberOfSections(in: UITableView())).to(equal(2))
                }

                it("Should return the value from the delegate if the delegate provides one.") {
                    let delegate = MockTableViewDataSourceDelegate()
                    self.unitUnderTest.delegate = delegate

                    expect(self.unitUnderTest.numberOfSections(in: UITableView())).to(equal(3))
                }
            }

            context("sectionIndexTitles(for:)") {
                beforeEach {
                    self.unitUnderTest = TableViewDataSource(objects: [[""]], cellNib: nil)
                }

                it("should return the value from the delegate if the delegate provides one.") {
                    let delegate = MockTableViewDataSourceDelegate()
                    self.unitUnderTest.delegate = delegate
                    let indexTitles = self.unitUnderTest.sectionIndexTitles(for: UITableView())

                    expect(indexTitles?.count).to(equal(1))
                    expect(indexTitles?.first).to(equal("testSectionIndexTitle"))
                }

                it("should return nil if there is no delegate") {
                    expect(self.unitUnderTest.sectionIndexTitles(for: UITableView())).to(beNil())
                }
            }

            // MARK: Internal Methods

            context("registerCellIfNeeded(tableView:)") {
                var tableView: MockTableView!

                beforeEach {
                    tableView = MockTableView()
                    self.unitUnderTest = TableViewDataSource(objects: [[String]](), cellClass: nil, cellNib: nil, cellPresenter: nil)
                }

                it("Should return the reuseId if one has already been set") {
                    self.unitUnderTest.reuseId = "TestReuseId"
                    let result = self.unitUnderTest.registerCellIfNeeded(tableView: tableView)
                    expect(result).to(equal("TestReuseId"))
                }

                it("Should not call the register methods if a reuse id is already set") {
                    self.unitUnderTest.reuseId = "TestReuseId"
                    let _ = self.unitUnderTest.registerCellIfNeeded(tableView: tableView)
                    expect(tableView.registerClassCaled).to(beFalse())
                    expect(tableView.registerNibCalled).to(beFalse())
                }

                it("Should call register nib if a nib is provided in the init") {
                    self.unitUnderTest = TableViewDataSource(objects: [[String]](), cellClass: nil, cellNib: UINib(), cellPresenter: nil)
                    let _ = self.unitUnderTest.registerCellIfNeeded(tableView: tableView)
                    expect(tableView.registerClassCaled).to(beFalse())
                    expect(tableView.registerNibCalled).to(beTrue())
                }

                it("Should call register class if a class is provided in the init") {
                    self.unitUnderTest = TableViewDataSource(objects: [[String]](), cellClass: UITableViewCell.self, cellNib: nil, cellPresenter: nil)
                    let _ = self.unitUnderTest.registerCellIfNeeded(tableView: tableView)
                    expect(tableView.registerClassCaled).to(beTrue())
                }

                it("Should raise an exception") {
                    self.unitUnderTest = TableViewDataSource(objects: [[String]](), cellClass: nil, cellNib: nil, cellPresenter: nil)
                    expect(self.unitUnderTest.registerCellIfNeeded(tableView: tableView)).to(raiseException())
                }
            }

            context("wrapObjects(_:)") {
                it("Should wrap the input array in an array") {
                    let inputArray = ["One", "Two", "Three", "Four"]
                    let result = TableViewDataSource.wrapObjects(inputArray)
                    expect(result.first).to(equal(inputArray))
                }

                it("Should return an empty array if nil is passed in as the input array") {
                    let inputArray: [String]? = nil
                    let result = TableViewDataSource.wrapObjects(inputArray)
                    expect(result).to(beAnInstanceOf(Array<Array<String>>.self))
                }
            }

            // MARK: UITableViewDataSource Methods

            context("tableView(_:numberOfRowsInSection:)") {
                let objects = [["S0R0", "S0R1", "S0R2"], ["S1R0", "S1R1"]]

                beforeEach {
                    self.unitUnderTest = TableViewDataSource(objects: objects, cellNib: nil)
                }

                it("Should return 2 if there is no delegate set.") {
                    expect(self.unitUnderTest.tableView(UITableView(), numberOfRowsInSection: 1)).to(equal(2))
                }

                it("Should return the value from the delegate if the delegate provides one.") {
                    let delegate = MockTableViewDataSourceDelegate()
                    self.unitUnderTest.delegate = delegate

                    expect(self.unitUnderTest.tableView(UITableView(), numberOfRowsInSection: 1)).to(equal(4))
                }
            }

            context("tableView(_:canEditRowAt:)") {
                var delegate: MockTableViewDataSourceDelegate!
                var indexPath: IndexPath!
                let objects = [["S0R0", "S0R1", "S0R2"], ["S1R0", "S1R1", "S1R2"]]
                var tableView: UITableView!
                
                beforeEach {
                    indexPath = IndexPath(row: 0, section: 0)
                    tableView = UITableView()
                    delegate = MockTableViewDataSourceDelegate()
                    self.unitUnderTest = TableViewDataSource(objects: objects, cellNib: nil)
                }
                
                it("should call the delegate if one is set") {
                    self.unitUnderTest.delegate = delegate
                    let _ = self.unitUnderTest.tableView(tableView, canEditRowAt: indexPath)
                    expect(delegate.canEditRowAtCalled).to(beTrue())
                }

                it("should prefer the value from the delegate if one is returned") {
                    self.unitUnderTest.delegate = delegate
                    expect(self.unitUnderTest.tableView(tableView, canEditRowAt: indexPath)).to(beTrue())
                }
                
                it("should return false if there is no delegate set") {
                    expect(self.unitUnderTest.tableView(tableView, canEditRowAt: indexPath)).to(beFalse())
                }
            }

            context("tableView(_:canMoveRowAt:)") {
                var delegate: MockTableViewDataSourceDelegate!
                var indexPath: IndexPath!
                let objects = [["S0R0", "S0R1", "S0R2"], ["S1R0", "S1R1", "S1R2"]]
                var tableView: UITableView!

                beforeEach {
                    indexPath = IndexPath(row: 0, section: 0)
                    tableView = UITableView()
                    delegate = MockTableViewDataSourceDelegate()
                    self.unitUnderTest = TableViewDataSource(objects: objects, cellNib: nil)
                }

                it("should call the delegate if one is set") {
                    self.unitUnderTest.delegate = delegate
                    let _ = self.unitUnderTest.tableView(tableView, canMoveRowAt: indexPath)
                    expect(delegate.canMoveRowAtCalled).to(beTrue())
                }

                it("should prefer the value from the delegate if one is returned") {
                    self.unitUnderTest.delegate = delegate
                    expect(self.unitUnderTest.tableView(tableView, canMoveRowAt: indexPath)).to(beFalse())
                }

                it("should return the true if there is no delegate set") {
                    expect(self.unitUnderTest.tableView(tableView, canMoveRowAt: indexPath)).to(beTrue())
                }
            }

            context("tableView(_:cellForRowAt:)") {
                var delegate: MockTableViewDataSourceDelegate!
                var indexPath: IndexPath!
                let objects = [["S0R0", "S0R1", "S0R2"], ["S1R0", "S1R1", "S1R2"]]
                var tableView: UITableView!

                beforeEach {
                    indexPath = IndexPath(row: 0, section: 0)
                    tableView = UITableView()
                    tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.reuseId)
                    delegate = MockTableViewDataSourceDelegate()
                    let cellClass = UITableViewCell.self
                    self.unitUnderTest = TableViewDataSource(objects: objects, cellClass: cellClass)
                    tableView.dataSource = self.unitUnderTest
                }

                it("should return a cell from the delegate if one is set") {
                    delegate.shouldReturnCell = true
                    self.unitUnderTest.delegate = delegate

                    expect(self.unitUnderTest.tableView(tableView, cellForRowAt: indexPath).reuseIdentifier).to(equal("testCellFromMock"))
                }

                it("should return a cell from the table view if the delegate does not return one") {
                    delegate.shouldReturnCell = false
                    self.unitUnderTest.delegate = delegate

                    expect(self.unitUnderTest.tableView(tableView, cellForRowAt: indexPath)).toNot(beNil())
                }

                it("should return a cell from the table view if the delegate is not set") {
                    expect(self.unitUnderTest.tableView(tableView, cellForRowAt: indexPath)).toNot(beNil())
                }

                it("should pass the cell to the presenter if available") {
                    self.unitUnderTest = TableViewDataSource(objects: objects, cellClass: UITableViewCell.self, cellPresenter: { (cell, object) in
                        expect(cell).toNot(beNil())
                    })

                    delegate.shouldReturnCell = false
                    self.unitUnderTest.delegate = delegate
                    tableView.dataSource = self.unitUnderTest
                    let _ = self.unitUnderTest.tableView(tableView, cellForRowAt: indexPath)
                }

                it("should pass the object to the presenter if available") {
                    self.unitUnderTest = TableViewDataSource(objects: objects, cellClass: UITableViewCell.self, cellPresenter: { (cell, object) in
                        expect(object).to(equal("S0R0"))
                    })

                    delegate.shouldReturnCell = false
                    self.unitUnderTest.delegate = delegate
                    tableView.dataSource = self.unitUnderTest
                    let _ = self.unitUnderTest.tableView(tableView, cellForRowAt: indexPath)
                }
            }

            context("tableView(_:commit:forRowAt:)") {
                var delegate: MockTableViewDataSourceDelegate!
                var indexPath: IndexPath!
                let objects = [["S0R0", "S0R1", "S0R2"], ["S1R0", "S1R1", "S1R2"]]
                var tableView: UITableView!

                beforeEach {
                    indexPath = IndexPath(row: 0, section: 0)
                    tableView = UITableView()
                    tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.reuseId)
                    delegate = MockTableViewDataSourceDelegate()
                    self.unitUnderTest = TableViewDataSource(objects: objects, cellNib: nil)
                    tableView.dataSource = self.unitUnderTest
                    self.unitUnderTest.delegate = delegate
                }

                it("should call the commit method on the delegate.") {
                    self.unitUnderTest.tableView(tableView, commit: .delete, forRowAt: indexPath)
                    expect(delegate.commitEditingStyleCalled).to(beTrue())
                }
            }

            context("tableView(_:moveRowAt:to:)") {
                var delegate: MockTableViewDataSourceDelegate!
                var indexPath: IndexPath!
                let objects = [["S0R0", "S0R1", "S0R2"], ["S1R0", "S1R1", "S1R2"]]
                var tableView: UITableView!

                beforeEach {
                    indexPath = IndexPath(row: 0, section: 0)
                    tableView = UITableView()
                    tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.reuseId)
                    delegate = MockTableViewDataSourceDelegate()
                    self.unitUnderTest = TableViewDataSource(objects: objects, cellNib: nil)
                    tableView.dataSource = self.unitUnderTest
                    self.unitUnderTest.delegate = delegate
                }

                it("should call the move row method on the delegate") {
                    self.unitUnderTest.tableView(tableView, moveRowAt: indexPath, to: IndexPath(row: 1, section: 0))
                    expect(delegate.moveRowAtCalled).to(beTrue())
                }
            }

            context("tableView(_:sectionForSectionIndexTitle:index:)") {
                beforeEach {
                    self.unitUnderTest = TableViewDataSource(objects: [[""]], cellNib: nil)
                }

                it("should return the delegate value if there is a delegate") {
                    let delegate = MockTableViewDataSourceDelegate()
                    self.unitUnderTest.delegate = delegate

                    expect(self.unitUnderTest.tableView(UITableView(), sectionForSectionIndexTitle: "", at: 0)).to(equal(1))
                }

                it("should return the default value if there is no delegate") {
                    expect(self.unitUnderTest.tableView(UITableView(), sectionForSectionIndexTitle: "", at: 0)).to(equal(-1))
                }
            }

            context("tableView(_:titleForFooterInSection:)") {
                var delegate: MockTableViewDataSourceDelegate!
                let footers = ["section0Footer", "section1Footer"]
                let objects = [["S0R0", "S0R1", "S0R2"], ["S1R0", "S1R1", "S1R2"]]
                var tableView: UITableView!

                beforeEach {
                    tableView = UITableView()
                    tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.reuseId)
                    delegate = MockTableViewDataSourceDelegate()
                    self.unitUnderTest = TableViewDataSource(objects: objects, cellNib: nil)
                    tableView.dataSource = self.unitUnderTest
                    self.unitUnderTest.footerTitles = footers
                }

                it("should return the footer from the delegate if there is a delegate and the delegate provides a title") {
                    delegate.shouldReturnFooter = true
                    self.unitUnderTest.delegate = delegate

                    expect(self.unitUnderTest.tableView(tableView, titleForFooterInSection: 0)).to(equal("testFooterFromMock"))
                }

                it("should return the footer from the footers array if the delegate returns nil") {
                    delegate.shouldReturnFooter = false
                    self.unitUnderTest.delegate = delegate

                    expect(self.unitUnderTest.tableView(tableView, titleForFooterInSection: 0)).to(equal("section0Footer"))
                }

                it("should return the footer from the footers array if the delegate is not set") {
                    expect(self.unitUnderTest.tableView(tableView, titleForFooterInSection: 0)).to(equal("section0Footer"))
                }

                it("should retun nil if there is no delegate and no footers array") {
                    self.unitUnderTest.footerTitles = nil

                    expect(self.unitUnderTest.tableView(tableView, titleForFooterInSection: 0)).to(beNil())
                }
            }

            context("tableView(_:titleForHeaderInSection:)") {
                var delegate: MockTableViewDataSourceDelegate!
                let headers = ["section0Header", "section1Header"]
                let objects = [["S0R0", "S0R1", "S0R2"], ["S1R0", "S1R1", "S1R2"]]
                var tableView: UITableView!

                beforeEach {
                    tableView = UITableView()
                    tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.reuseId)
                    delegate = MockTableViewDataSourceDelegate()
                    self.unitUnderTest = TableViewDataSource(objects: objects, cellNib: nil)
                    tableView.dataSource = self.unitUnderTest
                    self.unitUnderTest.headerTitles = headers
                }

                it("should return the header from the delegate if there is a delegate and the delegate provides a title") {
                    delegate.shouldReturnHeader = true
                    self.unitUnderTest.delegate = delegate

                    expect(self.unitUnderTest.tableView(tableView, titleForHeaderInSection: 0)).to(equal("testHeaderFromMock"))
                }

                it("should return the header from the headers array if the delegate returns nil") {
                    delegate.shouldReturnHeader = false
                    self.unitUnderTest.delegate = delegate

                    expect(self.unitUnderTest.tableView(tableView, titleForHeaderInSection: 0)).to(equal("section0Header"))
                }

                it("should return the header from the headers array if the delegate is not set") {
                    expect(self.unitUnderTest.tableView(tableView, titleForHeaderInSection: 0)).to(equal("section0Header"))
                }

                it("should retun nil if there is no delegate and no headers array") {
                    self.unitUnderTest.headerTitles = nil
                    expect(self.unitUnderTest.tableView(tableView, titleForHeaderInSection: 0)).to(beNil())
                }
            }

            context("setObjects(_:)") {
                it("Should set objects to an empty array if nil is passed in as a 2 dimensional array.") {
                    let nilStringArray: [[String]]? = nil
                    self.unitUnderTest.setObjects(nilStringArray)
                    expect(self.unitUnderTest.objects.count).to(equal(0))
                    expect(self.unitUnderTest.objects.count).toNot(beNil())
                }

                it("Should set the objects var to the passed in array") {
                    let objects: [[String]] = [["One", "Two", "Three"], ["Three", "Four", "Five"]]
                    self.unitUnderTest.setObjects(objects)
                    expect(self.unitUnderTest.objects[0]).to(equal(objects[0]))
                    expect(self.unitUnderTest.objects[1]).to(equal(objects[1]))
                }

                it("Should set objects to an empty array if nil is passed in as a 1 dimensional array.") {
                    let nilStringArray: [String]? = nil
                    self.unitUnderTest.setObjects(nilStringArray)
                    expect(self.unitUnderTest.objects.count).to(equal(0))
                    expect(self.unitUnderTest.objects.count).toNot(beNil())
                }

                it("Should wrap the array and set objects to a 2 dimensional array if a 1 dimensional array is passed in") {
                    let objects: [String] = ["One", "Two", "Three"]
                    self.unitUnderTest.setObjects(objects)
                    expect(self.unitUnderTest.objects[0]).to(equal(objects))
                }
            }
        }
    }
}
