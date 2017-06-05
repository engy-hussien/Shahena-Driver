import UIKit

class LanguageHelper {
    
    fileprivate static var currentLanguage = UserData.getUserLanguage() == nil ? Locale.current.languageCode! : UserData.getUserLanguage() as String
    
    static func setCurrentLanguage(_ langugaeCode: String) {
        currentLanguage = langugaeCode
        UserData.setUserLangugae(langugaeCode)
    }
    
    static func getCurrentLanguage() -> String {
        return currentLanguage
    }
    
    static func getStringLocalized(_ key: String) -> String{
        return (currentLanguage == "en" ? EnglishStrings.EnglishStringsDictionary[key] : ArabicStrings.ArabicStringsDictionary[key])!
    }
}
