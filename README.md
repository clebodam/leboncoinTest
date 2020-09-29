<h1 align="center">TestLeBonCoin</h1>

<p align="center">
  <a href="https://www.logolynx.com/images/logolynx/f9/f98c597f4b18590733032cc76fa88ce8.png"><img alt="ios" src="https://www.logolynx.com/images/logolynx/f9/f98c597f4b18590733032cc76fa88ce8.png"/></a>
</p>

![ListTableViewController filtered](https://github.com/clebodam/leboncoinTest/raw/master/img/scroll.gif "")

## Implementation

I will split the details about my implementation in 2 parts: 
- [ListTableViewController](https://github.com/clebodam/leboncoinTest/blob/master/TestLeBonCoin/TestLeBonCoin/Screens/List/UI/ListTableViewController.swift)
- [DetailsViewController](https://github.com/clebodam/leboncoinTest/blob/master/TestLeBonCoin/TestLeBonCoin/Screens/Details/UI/DetailsViewController.swift) 


### ListTableViewController

> 1 - Chaque item devra comporter au minimum une image, une catégorie, un titre et un prix. Un indicateur devra aussi avertir si l'item est urgent.

> 2 - Un filtre devra être disponible pour afficher seulement les items d'une catégorie.

> 3 - Les items devront être triés par date.
Attention cependant, les annonces marquées comme urgentes devront remonter en haut de la liste.

![ListTableViewController default cover](https://github.com/clebodam/leboncoinTest/raw/master/img/ListView1.jpeg "")
![ListTableViewController filter](https://github.com/clebodam/leboncoinTest/raw/master/img/filter.jpeg "")
![ListTableViewController filtered](https://github.com/clebodam/leboncoinTest/raw/master/img/filtered.jpeg "")






### DetailsViewController

> 4 - Au tap sur un item, une vue détaillée devra être affichée avec toutes les informations fournies dans l'API..


![ListTableViewController filtered](https://github.com/clebodam/leboncoinTest/raw/master/img/detail.jpeg "")


## Architecture 

I used an MVVM architecture for my application. 

![MVVM Architecture](https://upload.wikimedia.org/wikipedia/commons/8/87/MVVMPattern.png "")
For example, if we check the ListTableViewController implementation, we can see 2 classes :

- ListTableViewController, it is the View himself, which owns ListTableViewControllerViewModel
- ListTableViewControllerViewModel, the man-in-the middle classes which make the linking between the View and the Model provided by the Dao


I found this architecture pretty well because thanks to it. I can easily test the business logic, I just have to test the ListTableViewControllerViewModel class to do it. 

The whole architecture is designed to make each component as independent as possible.
I use generics and protocols to separate each layer network dao synchro model and ui.
For testing each component can be tested independently of the others

### Usage of interfaces/protocols
![protocols](https://github.com/clebodam/leboncoinTest/raw/master/img/protocols.png "")

### Data binding
Use of a generic Dynamic class for the binding of the viewModel and the view

![data binding](https://github.com/clebodam/leboncoinTest/raw/master/img/binding.png "")

### Dao double implementation 
I started doing a Dao based on the userdefaults of the system to focus on the UI.
Everything was perfectly functional but it bothered me anyway. So I chose to implement Coredata in the existing Dao.
The advantage is that this one is perfectly functional and I only have to specify if I want coredata or not and in the init of the dao and everything remains transparent for the user.
The proof is that for the unit tests I have a problem with Coredata (I cannot access the data model which causes a failure of the tests) suddenly in the test sets I initialize the dao without coreData and the tests pass

![dao](https://github.com/clebodam/leboncoinTest/raw/master/img/dao.png "")

## What went wrong during the test

I had two main problems:

-  I have a constraint that breaks in the filter UI, this is due to an iOS bug

[Known issue](https://stackoverflow.com/questions/55372093/uialertcontrollers-actionsheet-gives-constraint-error-on-ios-12-2-12-3)

-   I have a problem in the unit tests: it is currently impossible for me to access the CoreData data model in the test target



## Unit tests

I used [XCTest](https://developer.apple.com/documentation/xctest) 




