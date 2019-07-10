Tools and Language:

Swift 5, Xcode 10.2, 

Architecture : MVVM
The main advantage of using MVVM is that view controllers are considered part of the view layer, which is what they are. ViewModel which contains only data that can be used for UI, and is designed so that one can have different views for the same ViewModel. You end up creating more components than in MVC, smaller, reusable and testable, which is always a good approach.

Coding : Functional Reactive programming using
RXSWIFT + RxCocoa

RealmSwift: Realm database is used to save data in local storage and data syncing on pull to refresh.

Modules:
1. Articles: Listing New York Times Top Stories for different categories. 
2. Details: Details for selected articles including article title, cover image, abstract,
    author name, publish date, and article link (visit stories in detail by clicking on link)

UIBinding : Using reactive functional programming the data is subscirbed to changes and table or UI get refresh as the data changes. UI refresh controller also binded using RX with viewmodel to call api and refresh that data accordingly. Filter option also works the same.


Extensions : UI clases extensions

NY Times Top Stories API:
    If you don't already have an account create one: get asscess for apis,  you have to register an app: to get API_KEY
    Visit the lionk for more details if you are facing any trouble in getting api_key -> https://developer.nytimes.com/get-started
    
API Endpoint to get list of stroies: https://api.nytimes.com/svc/topstories/v2/{section}.json?api-key=<register-and-get-your-free-api-key>
    
Possible values for section: science, technology, business, world, movies and travel
