//
//  WorkspacesTableVC.swift
//  productivity
//
//  Created by MoHapX on 21.05.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import UIKit
import FontAwesomeKit_Swift

class WorkspacesTableVC: SwipeTableViewController {
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.2117647059, alpha: 1)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ItemsTableVC
        
        destinationVC.navigationItem.title = UserDataService.instance.selectedCategory?.name
    }


   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UserDataService.instance.loadCategoryList()
        return (UserDataService.instance.categoryList?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as? CategoryCell
        let category = UserDataService.instance.categoryList![indexPath.row]
        
        cell?.categoryTitleLbl.text = category.name
        cell?.labelIcon.text = category.icon
        cell?.labelIcon.font = UIFont.fa?.fontSize(30)
            
        return cell!
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UserDataService.instance.setSelectedCategory(index: indexPath.row)
        performSegue(withIdentifier: "goTodoItems", sender: self)
    }
    
    
    @IBAction func addCategoryBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Внимание!", message: "Вы действительно хотите удалить категорию?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
 

}
