

class Links {
    
//    static let BASE_URL = "http://35.167.101.93/api/"
    static let BASE_URL = "http://192.168.1.40/mandobi/api/"
//    static let BASE_URL = "http://192.168.1.25/mandobi/revamp/api/"

    
    static let APP_KEY = "3e990ab542678f436a24304c5d5367d6"
    static let URl_IMAGES = "http://35.167.101.93/v1/uploads/"
    
    static let AUTH_PARAMETERS = "?app_key=\(APP_KEY)&lang=\(LanguageHelper.getCurrentLanguage())"
    
//    static let SOCKET_URL = "http://35.167.101.93:30010"
    
    static let SOCKET_URL = "http://192.168.1.40:30010"
    
    static let DRIVER_LOGIN = Links.BASE_URL + "driver/users/login" + Links.AUTH_PARAMETERS
    static let DRIVER_PROFILE = Links.BASE_URL + "driver/users/view-profile" + Links.AUTH_PARAMETERS
    static let DRIVER_PROFIT = Links.BASE_URL + "driver/transactions/profit" + Links.AUTH_PARAMETERS
    static let OPEN_ORDERS_HISTORY = Links.BASE_URL + "driver/orders/open" + Links.AUTH_PARAMETERS
    static let EXCUTED_ORDERS_HISTORY = Links.BASE_URL + "driver/orders/executed" + Links.AUTH_PARAMETERS
    static let CANCELLED_ORDERS_HISTORY = Links.BASE_URL + "driver/orders/rejected" + Links.AUTH_PARAMETERS
    static let FIRST_ORDER_DATE = Links.BASE_URL + "driver/orders/first-order-date" + Links.AUTH_PARAMETERS
    
}
