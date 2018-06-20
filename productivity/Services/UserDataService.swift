//
//  UserDataService.swift
//  productivity
//
//  Created by MoHapX on 18.05.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import Foundation
import RealmSwift

class UserDataService {
    
    static let instance = UserDataService()
    let realm = try! Realm()
    
    public private(set) var categoryList: Results<Category>?
    public private(set) var projects: Results<Project>?
    public private(set) var selectedCategory: Category?
    public private(set) var selectedProject: Project?
    public private(set) var selectedProjectTask: Task?
    public private(set) var selectedItemRow: Int = -1
    
    func loadCategoryList() {
        categoryList = realm.objects(Category.self)
    }
    
    // Фиксируем выбранную категорию
    func setSelectedCategory(index: Int) {
        selectedCategory = categoryList?[index]
    }
    
    // Фиксируем выбранный проект
    func setSelectedProject(index: Int) {
        selectedProject = projects?[index]
    }
    
    // Фиксируем выбранную задачу
    func setSelectedProjectTask(index: Int) {
        if selectedProject != nil {
            selectedProjectTask = selectedProject?.tasks[index]
        }
    }
    
    
    
    // Сохраняем новый проект
    func saveProject(project: Project) {
        let task = Task()
        task.name = "Undefined"
        task.createDate = project.createdDate
        task.planCount = project.planCount
        
        do {
            try realm.write {
                selectedCategory?.projects.append(project)
                selectedCategory?.projects.last?.tasks.append(task)
            }
            
        } catch {
            print("Error saving category, \(error)")
        }
    }
    
    // Сохраняем новую задачу в проекте
    func saveProjectTask(task: Task) {
        do {
            try realm.write {
                selectedProject?.tasks.insert(task, at: 0)
            }
        } catch {
            print("Error saving task, \(error)")
        }
    }
    
    // Сохраняем рабочую сессию
    func saveFinishedWorkSession(workSeesion: WorkSession) {
        do {
            try realm.write {
                selectedProject?.workSessions.append(workSeesion)
                selectedProjectTask?.workSessions.append(workSeesion)
            }
            NotificationCenter.default.post(name: NOTIF_WORKSESSION_DID_SAVE, object: nil)
        } catch {
            print("Error saving finished task, \(error)")
        }
    }
    
    // Загружаем списко категорий
    func loadProjects(category: Category) {
        if selectedCategory != nil {
            projects = selectedCategory?.projects.sorted(byKeyPath: "name", ascending: true)
        }
    }
    
    // Сохраняем вновь созданную категорию
    func saveCategory(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category, \(error)")
        }
    }
    
    // Удаляем категорию из базы
    func updateCategoryList(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categoryList?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryForDeletion)
                    loadCategoryList()
                }
            } catch {
                print("Error to delete category, \(error)")
            }
        }


    }
    
    // Загружаем количество завершенных рабочих сессий
    func getCurrentProjectWorkSeeionsDone() -> Int {

        if selectedProject != nil {
            return (selectedProject?.workSessions.count)!
        }
        return 0
    }
    
    
    // Удаляем проект из списока проектов
    func deleteProject(at index: Int) {
        if let projectForDeletion = self.projects?[index] {
            do {
                try realm.write {
                    realm.delete(projectForDeletion.workSessions) // удаляем все ассоциированныеисессии
                    realm.delete(projectForDeletion.tasks) // удаляем все ассоциированные задачи
                    realm.delete(projectForDeletion) // удаляем сам проект
                    loadProjects(category: selectedCategory!) // обновляем список проектов
                }
            } catch {
                print("Error to delete project, \(error)")
            }
        }
    }
    
    // Удаляем задачу из списока задач проекта
    func deleteTask(at indexPath: IndexPath) {
        if let taskForDeletion = self.selectedProject?.tasks[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(taskForDeletion)
                }
            } catch {
                print("Error to delete task, \(error)")
            }
        }
    }
    
    // Загружаем первоначальные данные
    func initialCategoriesSetup() {
        let category1 = Category()
        category1.name = "Work"
//        category1.icon = String.fontAwesome(.fa_briefcase)
        category1.createdDate = Date()
        saveCategory(category: category1)
        
        let category2 = Category()
        category2.name = "Home"
//        category2.icon = String.fontAwesome(.fa_home)
        category2.createdDate = Date()
        saveCategory(category: category2)
        
        let category3 = Category()
        category3.name = "Study"
//        category3.icon = String.fontAwesome(.fa_leanpub)
        category3.createdDate = Date()
        saveCategory(category: category3)
        
        let category4 = Category()
        category4.name = "Read"
//        category4.icon = String.fontAwesome(.fa_book)
        category4.createdDate = Date()
        saveCategory(category: category4)
    }
}





















