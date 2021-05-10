//
//  BasePresenter.swift
//  TMDBApp
//
//  Created by Gabriel Rico on 4/2/21.
//

import Foundation

/// Esta es un protocol dónde se definen las funciones que se reutilizan el la arquitectura MVP
protocol BasePresenter {
  
    associatedtype View
    
    /**
     Esta funcion se utiliza para adjuntar la View en el Presenter
     
     ### Usage Example: ###
     ````
        func attachView(view: View) {
          self.loginView = view
        }
     ````
     */
    func attachView(view : View)
      
    /**
     Esta funcion se utiliza para separar o desinstalar  la View en el Presenter
     
     ### Usage Example: ###
     ````
        func detachView() {
            self.loginView = nil
        }
     ````
     */
    func detachView()
      
    /**
     Esta funcion se utiliza para destruir  la View en el Presenter
     
     ### Usage Example: ###
     ````
        func destroy() {

        }
     ````
     */
    func destroy()
  
}
