//
//  iconfonts-fontawesome.swift
//  Tioga
//
//  Created by Kristofer Younger on 7/1/15.
//

import UIKit


public extension UIFont{
    class func iconFontOfSize(_ font: String, fontSize: CGFloat) -> UIFont {
        
        return UIFont(name: font, size: fontSize)!
        
    }
}

public extension String {
    public static func fontAwesomeString(_ name: String) -> String {
        
        return fetchIconFontAwesome(name)
        
    }
}

public extension NSMutableAttributedString {
    public static func fontAwesomeAttributedString(_ name: String, suffix: String?, iconSize: CGFloat, suffixSize: CGFloat?) -> NSMutableAttributedString {
        
        // Initialise some variables
        var iconString = fetchIconFontAwesome(name)
        var suffixFontSize = iconSize
        
        // If there is some suffix text - add it to the string
        if let suffix = suffix {
            iconString = iconString + suffix
        }
        
        // If there is a suffix font size - make a note
        if let suffixSize = suffixSize {
            suffixFontSize = suffixSize
        }
        
        // Build the initial string - using the suffix specifics
        let iconAttributed = NSMutableAttributedString(string: iconString, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: suffixFontSize)!])
        
        // Role font awesome over the icon and size according to parameter
        iconAttributed.addAttribute(NSFontAttributeName, value: UIFont.iconFontOfSize("FontAwesome", fontSize: iconSize), range: NSRange(location: 0,length: 1))
        
        return iconAttributed
        
    }
}

protocol UnicodeLiteralConvertible {
    func convertToUnicode() -> String
}

extension String: UnicodeLiteralConvertible {
    
    func convertToUnicode() -> String {
        let scanner = Scanner(string: self)
        var _unicode : UInt32 = 0
        if scanner.scanHexInt32(&_unicode) {
            return String(describing: UnicodeScalar(_unicode))
        }
        
        return self
    }
}

extension Int: UnicodeLiteralConvertible {
    
    func convertToUnicode() -> String {
        return String(describing: UnicodeScalar(self))
    }
}

class FontAwesome {
    
    private static var __once: () = {
            FontManager.load("FontAwesome")
        }()
    
    struct Static {
        static var token : Int = 0
    }
    
    class func load() {
        _ = FontAwesome.__once
    }
    
    class FontManager {
        
        class func load(_ fontName: String) {
            if (UIFont.fontNames(forFamilyName: fontName).count > 0) {
                return
            }
            
            let fontData = findFontData(fontName)
            registerFontData(fontData)
        }
        
        class func findFontData(_ fontName: String) -> Data {
            let fontURL = Bundle.main.url(forResource: fontName, withExtension: "otf")
            if let fontURL = fontURL, let data = try? Data(contentsOf: fontURL) {
                return data
            }
            
            fatalError("\(fontName).otf is not found in the main bundle resources.")
        }
        
        class func registerFontData(_ fontData: Data) {
            
            let provider = CGDataProvider(data: fontData as CFData)
            let font = CGFont(provider!)
            var error: Unmanaged<CFError>?
            if !CTFontManagerRegisterGraphicsFont(font, &error) {
                    print(error)
            }

        }
    }
}

// Use Font Awesome

extension UIFont {
    class func fontAwesome(size: CGFloat) -> UIFont {
        FontAwesome.load()
        
        if let font = UIFont(name: "FontAwesome", size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size)
    }
}

extension String {
    static func fontAwesome(unicode fontAwesome: UnicodeLiteralConvertible) -> String {
        return fontAwesome.convertToUnicode()
    }
}

class ImageCacheFA {
    
    var cache: [String: UIImage]
    
    init() {
        self.cache = [String: UIImage]()
    }
    class func singleton() -> ImageCacheFA
    {
        return globalImageCacheSingleton
    }
    class func imageFor(_ s: String, c: UIColor, size: CGFloat) -> UIImage?
    {
        let key = s + ImageCacheFA.hexFromUIColor(c)
        if let yes = globalImageCacheSingleton.cache[key] {
            return yes
        } else {
            return nil
        }
        
    }
    class func addImage(_ s: String, c: UIColor, i: UIImage, size: CGFloat) {
        let key = s + ImageCacheFA.hexFromUIColor(c)
        globalImageCacheSingleton.cache[key] = i
    }
    
    class func hexFromUIColor(_ color: UIColor) -> String
    {
        let hexString = String(format: "%02X%02X%02X",
            Int((color.cgColor.components?[0])! * 255.0),
            Int((color.cgColor.components?[1])! * 255.0),
            Int((color.cgColor.components?[2])! * 255.0))
        return hexString
    }
    
}
let globalImageCacheSingleton = ImageCacheFA()


public extension UIImageView {
    // to make image from font awesome
    class func fontAwesomeAsImage(_ fontAwesomeName: String, size: CGFloat, color: UIColor = UIColor.black) -> UIImage {
        if let _image = ImageCacheFA.imageFor(fontAwesomeName, c: color, size: size) {
            //println("image hit")
            return _image
        } else {
            //println("image made")
            let iv = UIImageView()
            //let frame = iv.frame
            iv.frame = CGRect(x: 0,y: 0,width: 32,height: 32)

            let _image = iv.fontAwesomeImageCreate(fontAwesomeName, color: color, size: size)
            ImageCacheFA.addImage(fontAwesomeName, c: color, i: _image, size: size)
            return _image
        }
    }
    func fontAwesome(_ fontAwesomeName: String, color: UIColor = UIColor.black) {
        if let _image = ImageCacheFA.imageFor(fontAwesomeName, c: color, size: frame.size.height) {
            //println("image hit")
            image = _image
        } else {
            //println("image made")
            let _image = fontAwesomeImageCreate(fontAwesomeName, color: color, size: frame.size.height)
            ImageCacheFA.addImage(fontAwesomeName, c: color, i: _image, size: frame.size.height)
            image = _image
        }
    }
    
    fileprivate func fontAwesomeImageCreate(_ name: String, color: UIColor = UIColor.black, size: CGFloat ) -> UIImage {
        let fontAwesome = String.fontAwesomeString(name)
        let unicode = fontAwesome.convertToUnicode()
        let font = UIFont.fontAwesome(size: size)
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        
        let textSize = unicode.size(attributes: [NSFontAttributeName : font])
        let x = (bounds.width - textSize.width)/2
        let y = (bounds.height - textSize.height)/2
        let textRect = CGRect(x: x, y: y, width: textSize.width, height: textSize.height)
        
        let style = NSMutableParagraphStyle.default
        let attributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: color,
            NSParagraphStyleAttributeName: style
        ]
        unicode.draw(in: textRect, withAttributes: attributes)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        return image!
    }
    
}


func fetchIconFontAwesome(_ name: String) -> String {
    
    var returnValue = "\u{f059}"
    let start = name[name.characters.index(name.startIndex, offsetBy: 3)]
    
    switch start {
    case "a":
        switch name {
        case "fa-adjust": returnValue = "\u{f042}"
        case "fa-adn": returnValue = "\u{f170}"
        case "fa-align-center": returnValue = "\u{f037}"
        case "fa-align-justify": returnValue = "\u{f039}"
        case "fa-align-left": returnValue = "\u{f036}"
        case "fa-align-right": returnValue = "\u{f038}"
        case "fa-ambulance": returnValue = "\u{f0f9}"
        case "fa-anchor": returnValue = "\u{f13d}"
        case "fa-android": returnValue = "\u{f17b}"
        case "fa-angellist": returnValue = "\u{f209}"
        case "fa-angle-double-down": returnValue = "\u{f103}"
        case "fa-angle-double-left": returnValue = "\u{f100}"
        case "fa-angle-double-right": returnValue = "\u{f101}"
        case "fa-angle-double-up": returnValue = "\u{f102}"
        case "fa-angle-down": returnValue = "\u{f107}"
        case "fa-angle-left": returnValue = "\u{f104}"
        case "fa-angle-right": returnValue = "\u{f105}"
        case "fa-angle-up": returnValue = "\u{f106}"
        case "fa-apple": returnValue = "\u{f179}"
        case "fa-archive": returnValue = "\u{f187}"
        case "fa-area-chart": returnValue = "\u{f1fe}"
        case "fa-arrow-circle-down": returnValue = "\u{f0ab}"
        case "fa-arrow-circle-left": returnValue = "\u{f0a8}"
        case "fa-arrow-circle-o-down": returnValue = "\u{f01a}"
        case "fa-arrow-circle-o-left": returnValue = "\u{f190}"
        case "fa-arrow-circle-o-right": returnValue = "\u{f18e}"
        case "fa-arrow-circle-o-up": returnValue = "\u{f01b}"
        case "fa-arrow-circle-right": returnValue = "\u{f0a9}"
        case "fa-arrow-circle-up": returnValue = "\u{f0aa}"
        case "fa-arrow-down": returnValue = "\u{f063}"
        case "fa-arrow-left": returnValue = "\u{f060}"
        case "fa-arrow-right": returnValue = "\u{f061}"
        case "fa-arrow-up": returnValue = "\u{f062}"
        case "fa-arrows": returnValue = "\u{f047}"
        case "fa-arrows-alt": returnValue = "\u{f0b2}"
        case "fa-arrows-h": returnValue = "\u{f07e}"
        case "fa-arrows-v": returnValue = "\u{f07d}"
        case "fa-asterisk": returnValue = "\u{f069}"
        case "fa-at": returnValue = "\u{f1fa}"
        case "fa-automobile": returnValue = "\u{f1b9}"
        default : returnValue =  "\u{f059}"
        }
    case "b":
        switch name {
        case "fa-backward": returnValue = "\u{f04a}"
        case "fa-ban": returnValue = "\u{f05e}"
        case "fa-bank": returnValue = "\u{f19c}"
        case "fa-bar-chart": returnValue = "\u{f080}"
        case "fa-bar-chart-o": returnValue = "\u{f080}"
        case "fa-barcode": returnValue = "\u{f02a}"
        case "fa-bars": returnValue = "\u{f0c9}"
        case "fa-bed": returnValue = "\u{f236}"
        case "fa-beer": returnValue = "\u{f0fc}"
        case "fa-behance": returnValue = "\u{f1b4}"
        case "fa-behance-square": returnValue = "\u{f1b5}"
        case "fa-bell": returnValue = "\u{f0f3}"
        case "fa-bell-o": returnValue = "\u{f0a2}"
        case "fa-bell-slash": returnValue = "\u{f1f6}"
        case "fa-bell-slash-o": returnValue = "\u{f1f7}"
        case "fa-bicycle": returnValue = "\u{f206}"
        case "fa-binoculars": returnValue = "\u{f1e5}"
        case "fa-birthday-cake": returnValue = "\u{f1fd}"
        case "fa-bitbucket": returnValue = "\u{f171}"
        case "fa-bitbucket-square": returnValue = "\u{f172}"
        case "fa-bitcoin": returnValue = "\u{f15a}"
        case "fa-bold": returnValue = "\u{f032}"
        case "fa-bolt": returnValue = "\u{f0e7}"
        case "fa-bomb": returnValue = "\u{f1e2}"
        case "fa-book": returnValue = "\u{f02d}"
        case "fa-bookmark": returnValue = "\u{f02e}"
        case "fa-bookmark-o": returnValue = "\u{f097}"
        case "fa-briefcase": returnValue = "\u{f0b1}"
        case "fa-btc": returnValue = "\u{f15a}"
        case "fa-bug": returnValue = "\u{f188}"
        case "fa-building": returnValue = "\u{f1ad}"
        case "fa-building-o": returnValue = "\u{f0f7}"
        case "fa-bullhorn": returnValue = "\u{f0a1}"
        case "fa-bullseye": returnValue = "\u{f140}"
        case "fa-bus": returnValue = "\u{f207}"
        case "fa-buysellads": returnValue = "\u{f20d}"
        default : returnValue =  "\u{f059}"
        }
    case "c":
        switch name {
        case "fa-cab": returnValue = "\u{f1ba}"
        case "fa-calculator": returnValue = "\u{f1ec}"
        case "fa-calendar": returnValue = "\u{f073}"
        case "fa-calendar-o": returnValue = "\u{f133}"
        case "fa-camera": returnValue = "\u{f030}"
        case "fa-camera-retro": returnValue = "\u{f083}"
        case "fa-car": returnValue = "\u{f1b9}"
        case "fa-caret-down": returnValue = "\u{f0d7}"
        case "fa-caret-left": returnValue = "\u{f0d9}"
        case "fa-caret-right": returnValue = "\u{f0da}"
        case "fa-caret-square-o-down": returnValue = "\u{f150}"
        case "fa-caret-square-o-left": returnValue = "\u{f191}"
        case "fa-caret-square-o-right": returnValue = "\u{f152}"
        case "fa-caret-square-o-up": returnValue = "\u{f151}"
        case "fa-caret-up": returnValue = "\u{f0d8}"
        case "fa-cart-arrow-down": returnValue = "\u{f218}"
        case "fa-cart-plus": returnValue = "\u{f217}"
        case "fa-cc": returnValue = "\u{f20a}"
        case "fa-cc-amex": returnValue = "\u{f1f3}"
        case "fa-cc-discover": returnValue = "\u{f1f2}"
        case "fa-cc-mastercard": returnValue = "\u{f1f1}"
        case "fa-cc-paypal": returnValue = "\u{f1f4}"
        case "fa-cc-stripe": returnValue = "\u{f1f5}"
        case "fa-cc-visa": returnValue = "\u{f1f0}"
        case "fa-certificate": returnValue = "\u{f0a3}"
        case "fa-chain": returnValue = "\u{f0c1}"
        case "fa-chain-broken": returnValue = "\u{f127}"
        case "fa-check": returnValue = "\u{f00c}"
        case "fa-check-circle": returnValue = "\u{f058}"
        case "fa-check-circle-o": returnValue = "\u{f05d}"
        case "fa-check-square": returnValue = "\u{f14a}"
        case "fa-check-square-o": returnValue = "\u{f046}"
        case "fa-chevron-circle-down": returnValue = "\u{f13a}"
        case "fa-chevron-circle-left": returnValue = "\u{f137}"
        case "fa-chevron-circle-right": returnValue = "\u{f138}"
        case "fa-chevron-circle-up": returnValue = "\u{f139}"
        case "fa-chevron-down": returnValue = "\u{f078}"
        case "fa-chevron-left": returnValue = "\u{f053}"
        case "fa-chevron-right": returnValue = "\u{f054}"
        case "fa-chevron-up": returnValue = "\u{f077}"
        case "fa-child": returnValue = "\u{f1ae}"
        case "fa-circle": returnValue = "\u{f111}"
        case "fa-circle-o": returnValue = "\u{f10c}"
        case "fa-circle-o-notch": returnValue = "\u{f1ce}"
        case "fa-circle-thin": returnValue = "\u{f1db}"
        case "fa-clipboard": returnValue = "\u{f0ea}"
        case "fa-clock-o": returnValue = "\u{f017}"
        case "fa-close": returnValue = "\u{f00d}"
        case "fa-cloud": returnValue = "\u{f0c2}"
        case "fa-cloud-download": returnValue = "\u{f0ed}"
        case "fa-cloud-upload": returnValue = "\u{f0ee}"
        case "fa-cny": returnValue = "\u{f157}"
        case "fa-code": returnValue = "\u{f121}"
        case "fa-code-fork": returnValue = "\u{f126}"
        case "fa-codepen": returnValue = "\u{f1cb}"
        case "fa-coffee": returnValue = "\u{f0f4}"
        case "fa-cog": returnValue = "\u{f013}"
        case "fa-cogs": returnValue = "\u{f085}"
        case "fa-columns": returnValue = "\u{f0db}"
        case "fa-comment": returnValue = "\u{f075}"
        case "fa-comment-o": returnValue = "\u{f0e5}"
        case "fa-comments": returnValue = "\u{f086}"
        case "fa-comments-o": returnValue = "\u{f0e6}"
        case "fa-compass": returnValue = "\u{f14e}"
        case "fa-compress": returnValue = "\u{f066}"
        case "fa-connectdevelop": returnValue = "\u{f20e}"
        case "fa-copy": returnValue = "\u{f0c5}"
        case "fa-copyright": returnValue = "\u{f1f9}"
        case "fa-credit-card": returnValue = "\u{f09d}"
        case "fa-crop": returnValue = "\u{f125}"
        case "fa-crosshairs": returnValue = "\u{f05b}"
        case "fa-css3": returnValue = "\u{f13c}"
        case "fa-cube": returnValue = "\u{f1b2}"
        case "fa-cubes": returnValue = "\u{f1b3}"
        case "fa-cut": returnValue = "\u{f0c4}"
        case "fa-cutlery": returnValue = "\u{f0f5}"
        default : returnValue =  "\u{f059}"
        }
    case "d":
        switch name {
        case "fa-dashboard": returnValue = "\u{f0e4}"
        case "fa-dashcube": returnValue = "\u{f210}"
        case "fa-database": returnValue = "\u{f1c0}"
        case "fa-dedent": returnValue = "\u{f03b}"
        case "fa-delicious": returnValue = "\u{f1a5}"
        case "fa-desktop": returnValue = "\u{f108}"
        case "fa-deviantart": returnValue = "\u{f1bd}"
        case "fa-diamond": returnValue = "\u{f219}"
        case "fa-digg": returnValue = "\u{f1a6}"
        case "fa-dollar": returnValue = "\u{f155}"
        case "fa-dot-circle-o": returnValue = "\u{f192}"
        case "fa-download": returnValue = "\u{f019}"
        case "fa-dribbble": returnValue = "\u{f17d}"
        case "fa-dropbox": returnValue = "\u{f16b}"
        case "fa-drupal": returnValue = "\u{f1a9}"
        default : returnValue =  "\u{f059}"
        }
    case "e":
        switch name {
        case "fa-edit": returnValue = "\u{f044}"
        case "fa-eject": returnValue = "\u{f052}"
        case "fa-ellipsis-h": returnValue = "\u{f141}"
        case "fa-ellipsis-v": returnValue = "\u{f142}"
        case "fa-empire": returnValue = "\u{f1d1}"
        case "fa-envelope": returnValue = "\u{f0e0}"
        case "fa-envelope-o": returnValue = "\u{f003}"
        case "fa-envelope-square": returnValue = "\u{f199}"
        case "fa-eraser": returnValue = "\u{f12d}"
        case "fa-eur": returnValue = "\u{f153}"
        case "fa-euro": returnValue = "\u{f153}"
        case "fa-exchange": returnValue = "\u{f0ec}"
        case "fa-exclamation": returnValue = "\u{f12a}"
        case "fa-exclamation-circle": returnValue = "\u{f06a}"
        case "fa-exclamation-triangle": returnValue = "\u{f071}"
        case "fa-expand": returnValue = "\u{f065}"
        case "fa-external-link": returnValue = "\u{f08e}"
        case "fa-external-link-square": returnValue = "\u{f14c}"
        case "fa-eye": returnValue = "\u{f06e}"
        case "fa-eye-slash": returnValue = "\u{f070}"
        case "fa-eyedropper": returnValue = "\u{f1fb}"
            
        default : returnValue =  "\u{f059}"
        }
    case "f":
        switch name {
        case "fa-facebook": returnValue = "\u{f09a}"
        case "fa-facebook-f": returnValue = "\u{f09a}"
        case "fa-facebook-official": returnValue = "\u{f230}"
        case "fa-facebook-square": returnValue = "\u{f082}"
        case "fa-fast-backward": returnValue = "\u{f049}"
        case "fa-fast-forward": returnValue = "\u{f050}"
        case "fa-fax": returnValue = "\u{f1ac}"
        case "fa-female": returnValue = "\u{f182}"
        case "fa-fighter-jet": returnValue = "\u{f0fb}"
        case "fa-file": returnValue = "\u{f15b}"
        case "fa-file-archive-o": returnValue = "\u{f1c6}"
        case "fa-file-audio-o": returnValue = "\u{f1c7}"
        case "fa-file-code-o": returnValue = "\u{f1c9}"
        case "fa-file-excel-o": returnValue = "\u{f1c3}"
        case "fa-file-image-o": returnValue = "\u{f1c5}"
        case "fa-file-movie-o": returnValue = "\u{f1c8}"
        case "fa-file-o": returnValue = "\u{f016}"
        case "fa-file-pdf-o": returnValue = "\u{f1c1}"
        case "fa-file-photo-o": returnValue = "\u{f1c5}"
        case "fa-file-picture-o": returnValue = "\u{f1c5}"
        case "fa-file-powerpoint-o": returnValue = "\u{f1c4}"
        case "fa-file-sound-o": returnValue = "\u{f1c7}"
        case "fa-file-text": returnValue = "\u{f15c}"
        case "fa-file-text-o": returnValue = "\u{f0f6}"
        case "fa-file-video-o": returnValue = "\u{f1c8}"
        case "fa-file-word-o": returnValue = "\u{f1c2}"
        case "fa-file-zip-o": returnValue = "\u{f1c6}"
        case "fa-files-o": returnValue = "\u{f0c5}"
        case "fa-film": returnValue = "\u{f008}"
        case "fa-filter": returnValue = "\u{f0b0}"
        case "fa-fire": returnValue = "\u{f06d}"
        case "fa-fire-extinguisher": returnValue = "\u{f134}"
        case "fa-flag": returnValue = "\u{f024}"
        case "fa-flag-checkered": returnValue = "\u{f11e}"
        case "fa-flag-o": returnValue = "\u{f11d}"
        case "fa-flash": returnValue = "\u{f0e7}"
        case "fa-flask": returnValue = "\u{f0c3}"
        case "fa-flickr": returnValue = "\u{f16e}"
        case "fa-floppy-o": returnValue = "\u{f0c7}"
        case "fa-folder": returnValue = "\u{f07b}"
        case "fa-folder-o": returnValue = "\u{f114}"
        case "fa-folder-open": returnValue = "\u{f07c}"
        case "fa-folder-open-o": returnValue = "\u{f115}"
        case "fa-font": returnValue = "\u{f031}"
        case "fa-forumbee": returnValue = "\u{f211}"
        case "fa-forward": returnValue = "\u{f04e}"
        case "fa-foursquare": returnValue = "\u{f180}"
        case "fa-frown-o": returnValue = "\u{f119}"
        case "fa-futbol-o": returnValue = "\u{f1e3}"
        default : returnValue =  "\u{f059}"
        }
    case "g":
        switch name {
        case "fa-gamepad": returnValue = "\u{f11b}"
        case "fa-gavel": returnValue = "\u{f0e3}"
        case "fa-gbp": returnValue = "\u{f154}"
        case "fa-ge": returnValue = "\u{f1d1}"
        case "fa-gear": returnValue = "\u{f013}"
        case "fa-gears": returnValue = "\u{f085}"
        case "fa-genderless": returnValue = "\u{f1db}"
        case "fa-gift": returnValue = "\u{f06b}"
        case "fa-git": returnValue = "\u{f1d3}"
        case "fa-git-square": returnValue = "\u{f1d2}"
        case "fa-github": returnValue = "\u{f09b}"
        case "fa-github-alt": returnValue = "\u{f113}"
        case "fa-github-square": returnValue = "\u{f092}"
        case "fa-gittip": returnValue = "\u{f184}"
        case "fa-glass": returnValue = "\u{f000}"
        case "fa-globe": returnValue = "\u{f0ac}"
        case "fa-google": returnValue = "\u{f1a0}"
        case "fa-google-plus": returnValue = "\u{f0d5}"
        case "fa-google-plus-square": returnValue = "\u{f0d4}"
        case "fa-google-wallet": returnValue = "\u{f1ee}"
        case "fa-graduation-cap": returnValue = "\u{f19d}"
        case "fa-gratipay": returnValue = "\u{f184}"
        case "fa-group": returnValue = "\u{f0c0}"
        default : returnValue =  "\u{f059}"
        }
    case "h":
        switch name {
        case "fa-h-square": returnValue = "\u{f0fd}"
        case "fa-hacker-news": returnValue = "\u{f1d4}"
        case "fa-hand-o-down": returnValue = "\u{f0a7}"
        case "fa-hand-o-left": returnValue = "\u{f0a5}"
        case "fa-hand-o-right": returnValue = "\u{f0a4}"
        case "fa-hand-o-up": returnValue = "\u{f0a6}"
        case "fa-hdd-o": returnValue = "\u{f0a0}"
        case "fa-header": returnValue = "\u{f1dc}"
        case "fa-headphones": returnValue = "\u{f025}"
        case "fa-heart": returnValue = "\u{f004}"
        case "fa-heart-o": returnValue = "\u{f08a}"
        case "fa-heartbeat": returnValue = "\u{f21e}"
        case "fa-history": returnValue = "\u{f1da}"
        case "fa-home": returnValue = "\u{f015}"
        case "fa-hospital-o": returnValue = "\u{f0f8}"
        case "fa-hotel": returnValue = "\u{f236}"
        case "fa-html5": returnValue = "\u{f13b}"
        default : returnValue =  "\u{f059}"
        }
    case "i":
        switch name {
        case "fa-ils": returnValue = "\u{f20b}"
        case "fa-image": returnValue = "\u{f03e}"
        case "fa-inbox": returnValue = "\u{f01c}"
        case "fa-indent": returnValue = "\u{f03c}"
        case "fa-info": returnValue = "\u{f129}"
        case "fa-info-circle": returnValue = "\u{f05a}"
        case "fa-inr": returnValue = "\u{f156}"
        case "fa-instagram": returnValue = "\u{f16d}"
        case "fa-institution": returnValue = "\u{f19c}"
        case "fa-ioxhost": returnValue = "\u{f208}"
        case "fa-italic": returnValue = "\u{f033}"
        default : returnValue =  "\u{f059}"
        }
    case "j":
        switch name {
        case "fa-joomla": returnValue = "\u{f1aa}"
        case "fa-jpy": returnValue = "\u{f157}"
        case "fa-jsfiddle": returnValue = "\u{f1cc}"
        default : returnValue =  "\u{f059}"
        }
    case "k":
        switch name {
        case "fa-key": returnValue = "\u{f084}"
        case "fa-keyboard-o": returnValue = "\u{f11c}"
        case "fa-krw": returnValue = "\u{f159}"
        default : returnValue =  "\u{f059}"
        }
    case "l":
        switch name {
        case "fa-language": returnValue = "\u{f1ab}"
        case "fa-laptop": returnValue = "\u{f109}"
        case "fa-lastfm": returnValue = "\u{f202}"
        case "fa-lastfm-square": returnValue = "\u{f203}"
        case "fa-leaf": returnValue = "\u{f06c}"
        case "fa-leanpub": returnValue = "\u{f212}"
        case "fa-legal": returnValue = "\u{f0e3}"
        case "fa-lemon-o": returnValue = "\u{f094}"
        case "fa-level-down": returnValue = "\u{f149}"
        case "fa-level-up": returnValue = "\u{f148}"
        case "fa-life-bouy": returnValue = "\u{f1cd}"
        case "fa-life-buoy": returnValue = "\u{f1cd}"
        case "fa-life-ring": returnValue = "\u{f1cd}"
        case "fa-life-saver": returnValue = "\u{f1cd}"
        case "fa-lightbulb-o": returnValue = "\u{f0eb}"
        case "fa-line-chart": returnValue = "\u{f201}"
        case "fa-link": returnValue = "\u{f0c1}"
        case "fa-linkedin": returnValue = "\u{f0e1}"
        case "fa-linkedin-square": returnValue = "\u{f08c}"
        case "fa-linux": returnValue = "\u{f17c}"
        case "fa-list": returnValue = "\u{f03a}"
        case "fa-list-alt": returnValue = "\u{f022}"
        case "fa-list-ol": returnValue = "\u{f0cb}"
        case "fa-list-ul": returnValue = "\u{f0ca}"
        case "fa-location-arrow": returnValue = "\u{f124}"
        case "fa-lock": returnValue = "\u{f023}"
        case "fa-long-arrow-down": returnValue = "\u{f175}"
        case "fa-long-arrow-left": returnValue = "\u{f177}"
        case "fa-long-arrow-right": returnValue = "\u{f178}"
        case "fa-long-arrow-up": returnValue = "\u{f176}"
        default : returnValue =  "\u{f059}"
        }
    case "m":
        switch name {
        case "fa-magic": returnValue = "\u{f0d0}"
        case "fa-magnet": returnValue = "\u{f076}"
        case "fa-mail-forward": returnValue = "\u{f064}"
        case "fa-mail-reply": returnValue = "\u{f112}"
        case "fa-mail-reply-all": returnValue = "\u{f122}"
        case "fa-male": returnValue = "\u{f183}"
        case "fa-map-marker": returnValue = "\u{f041}"
        case "fa-mars": returnValue = "\u{f222}"
        case "fa-mars-double": returnValue = "\u{f227}"
        case "fa-mars-stroke": returnValue = "\u{f229}"
        case "fa-mars-stroke-h": returnValue = "\u{f22b}"
        case "fa-mars-stroke-v": returnValue = "\u{f22a}"
        case "fa-maxcdn": returnValue = "\u{f136}"
        case "fa-meanpath": returnValue = "\u{f20c}"
        case "fa-medium": returnValue = "\u{f23a}"
        case "fa-medkit": returnValue = "\u{f0fa}"
        case "fa-meh-o": returnValue = "\u{f11a}"
        case "fa-mercury": returnValue = "\u{f223}"
        case "fa-microphone": returnValue = "\u{f130}"
        case "fa-microphone-slash": returnValue = "\u{f131}"
        case "fa-minus": returnValue = "\u{f068}"
        case "fa-minus-circle": returnValue = "\u{f056}"
        case "fa-minus-square": returnValue = "\u{f146}"
        case "fa-minus-square-o": returnValue = "\u{f147}"
        case "fa-mobile": returnValue = "\u{f10b}"
        case "fa-mobile-phone": returnValue = "\u{f10b}"
        case "fa-money": returnValue = "\u{f0d6}"
        case "fa-moon-o": returnValue = "\u{f186}"
        case "fa-mortar-board": returnValue = "\u{f19d}"
        case "fa-motorcycle": returnValue = "\u{f21c}"
        case "fa-music": returnValue = "\u{f001}"
        default : returnValue =  "\u{f059}"
        }
    case "n":
        switch name {
        case "fa-navicon": returnValue = "\u{f0c9}"
        case "fa-neuter": returnValue = "\u{f22c}"
        case "fa-newspaper-o": returnValue = "\u{f1ea}"
        default : returnValue =  "\u{f059}"
        }
    case "o":
        switch name {
        case "fa-openid": returnValue = "\u{f19b}"
        case "fa-outdent": returnValue = "\u{f03b}"
        default : returnValue =  "\u{f059}"
        }
    case "p":
        switch name {
        case "fa-pagelines": returnValue = "\u{f18c}"
        case "fa-paint-brush": returnValue = "\u{f1fc}"
        case "fa-paper-plane": returnValue = "\u{f1d8}"
        case "fa-paper-plane-o": returnValue = "\u{f1d9}"
        case "fa-paperclip": returnValue = "\u{f0c6}"
        case "fa-paragraph": returnValue = "\u{f1dd}"
        case "fa-paste": returnValue = "\u{f0ea}"
        case "fa-pause": returnValue = "\u{f04c}"
        case "fa-paw": returnValue = "\u{f1b0}"
        case "fa-paypal": returnValue = "\u{f1ed}"
        case "fa-pencil": returnValue = "\u{f040}"
        case "fa-pencil-square": returnValue = "\u{f14b}"
        case "fa-pencil-square-o": returnValue = "\u{f044}"
        case "fa-phone": returnValue = "\u{f095}"
        case "fa-phone-square": returnValue = "\u{f098}"
        case "fa-photo": returnValue = "\u{f03e}"
        case "fa-picture-o": returnValue = "\u{f03e}"
        case "fa-pie-chart": returnValue = "\u{f200}"
        case "fa-pied-piper": returnValue = "\u{f1a7}"
        case "fa-pied-piper-alt": returnValue = "\u{f1a8}"
        case "fa-pinterest": returnValue = "\u{f0d2}"
        case "fa-pinterest-p": returnValue = "\u{f231}"
        case "fa-pinterest-square": returnValue = "\u{f0d3}"
        case "fa-plane": returnValue = "\u{f072}"
        case "fa-play": returnValue = "\u{f04b}"
        case "fa-play-circle": returnValue = "\u{f144}"
        case "fa-play-circle-o": returnValue = "\u{f01d}"
        case "fa-plug": returnValue = "\u{f1e6}"
        case "fa-plus": returnValue = "\u{f067}"
        case "fa-plus-circle": returnValue = "\u{f055}"
        case "fa-plus-square": returnValue = "\u{f0fe}"
        case "fa-plus-square-o": returnValue = "\u{f196}"
        case "fa-power-off": returnValue = "\u{f011}"
        case "fa-print": returnValue = "\u{f02f}"
        case "fa-puzzle-piece": returnValue = "\u{f12e}"
        default : returnValue =  "\u{f059}"
        }
    case "q":
        switch name {
        case "fa-qq": returnValue = "\u{f1d6}"
        case "fa-qrcode": returnValue = "\u{f029}"
        case "fa-question": returnValue = "\u{f128}"
        case "fa-question-circle": returnValue = "\u{f059}"
        case "fa-quote-left": returnValue = "\u{f10d}"
        case "fa-quote-right": returnValue = "\u{f10e}"
        default : returnValue =  "\u{f059}"
        }
    case "r":
        switch name {
        case "fa-ra": returnValue = "\u{f1d0}"
        case "fa-random": returnValue = "\u{f074}"
        case "fa-rebel": returnValue = "\u{f1d0}"
        case "fa-recycle": returnValue = "\u{f1b8}"
        case "fa-reddit": returnValue = "\u{f1a1}"
        case "fa-reddit-square": returnValue = "\u{f1a2}"
        case "fa-refresh": returnValue = "\u{f021}"
        case "fa-remove": returnValue = "\u{f00d}"
        case "fa-renren": returnValue = "\u{f18b}"
        case "fa-reorder": returnValue = "\u{f0c9}"
        case "fa-repeat": returnValue = "\u{f01e}"
        case "fa-reply": returnValue = "\u{f112}"
        case "fa-reply-all": returnValue = "\u{f122}"
        case "fa-retweet": returnValue = "\u{f079}"
        case "fa-rmb": returnValue = "\u{f157}"
        case "fa-road": returnValue = "\u{f018}"
        case "fa-rocket": returnValue = "\u{f135}"
        case "fa-rotate-left": returnValue = "\u{f0e2}"
        case "fa-rotate-right": returnValue = "\u{f01e}"
        case "fa-rouble": returnValue = "\u{f158}"
        case "fa-rss": returnValue = "\u{f09e}"
        case "fa-rss-square": returnValue = "\u{f143}"
        case "fa-rub": returnValue = "\u{f158}"
        case "fa-ruble": returnValue = "\u{f158}"
        case "fa-rupee": returnValue = "\u{f156}"
        default : returnValue =  "\u{f059}"
        }
    case "s":
        switch name {
        case "fa-save": returnValue = "\u{f0c7}"
        case "fa-scissors": returnValue = "\u{f0c4}"
        case "fa-search": returnValue = "\u{f002}"
        case "fa-search-minus": returnValue = "\u{f010}"
        case "fa-search-plus": returnValue = "\u{f00e}"
        case "fa-sellsy": returnValue = "\u{f213}"
        case "fa-send": returnValue = "\u{f1d8}"
        case "fa-send-o": returnValue = "\u{f1d9}"
        case "fa-server": returnValue = "\u{f233}"
        case "fa-share": returnValue = "\u{f064}"
        case "fa-share-alt": returnValue = "\u{f1e0}"
        case "fa-share-alt-square": returnValue = "\u{f1e1}"
        case "fa-share-square": returnValue = "\u{f14d}"
        case "fa-share-square-o": returnValue = "\u{f045}"
        case "fa-shekel": returnValue = "\u{f20b}"
        case "fa-sheqel": returnValue = "\u{f20b}"
        case "fa-shield": returnValue = "\u{f132}"
        case "fa-ship": returnValue = "\u{f21a}"
        case "fa-shirtsinbulk": returnValue = "\u{f214}"
        case "fa-shopping-cart": returnValue = "\u{f07a}"
        case "fa-sign-in": returnValue = "\u{f090}"
        case "fa-sign-out": returnValue = "\u{f08b}"
        case "fa-signal": returnValue = "\u{f012}"
        case "fa-simplybuilt": returnValue = "\u{f215}"
        case "fa-sitemap": returnValue = "\u{f0e8}"
        case "fa-skyatlas": returnValue = "\u{f216}"
        case "fa-skype": returnValue = "\u{f17e}"
        case "fa-slack": returnValue = "\u{f198}"
        case "fa-sliders": returnValue = "\u{f1de}"
        case "fa-slideshare": returnValue = "\u{f1e7}"
        case "fa-smile-o": returnValue = "\u{f118}"
        case "fa-soccer-ball-o": returnValue = "\u{f1e3}"
        case "fa-sort": returnValue = "\u{f0dc}"
        case "fa-sort-alpha-asc": returnValue = "\u{f15d}"
        case "fa-sort-alpha-desc": returnValue = "\u{f15e}"
        case "fa-sort-amount-asc": returnValue = "\u{f160}"
        case "fa-sort-amount-desc": returnValue = "\u{f161}"
        case "fa-sort-asc": returnValue = "\u{f0de}"
        case "fa-sort-desc": returnValue = "\u{f0dd}"
        case "fa-sort-down": returnValue = "\u{f0dd}"
        case "fa-sort-numeric-asc": returnValue = "\u{f162}"
        case "fa-sort-numeric-desc": returnValue = "\u{f163}"
        case "fa-sort-up": returnValue = "\u{f0de}"
        case "fa-soundcloud": returnValue = "\u{f1be}"
        case "fa-space-shuttle": returnValue = "\u{f197}"
        case "fa-spinner": returnValue = "\u{f110}"
        case "fa-spoon": returnValue = "\u{f1b1}"
        case "fa-spotify": returnValue = "\u{f1bc}"
        case "fa-square": returnValue = "\u{f0c8}"
        case "fa-square-o": returnValue = "\u{f096}"
        case "fa-stack-exchange": returnValue = "\u{f18d}"
        case "fa-stack-overflow": returnValue = "\u{f16c}"
        case "fa-star": returnValue = "\u{f005}"
        case "fa-star-half": returnValue = "\u{f089}"
        case "fa-star-half-empty": returnValue = "\u{f123}"
        case "fa-star-half-full": returnValue = "\u{f123}"
        case "fa-star-half-o": returnValue = "\u{f123}"
        case "fa-star-o": returnValue = "\u{f006}"
        case "fa-steam": returnValue = "\u{f1b6}"
        case "fa-steam-square": returnValue = "\u{f1b7}"
        case "fa-step-backward": returnValue = "\u{f048}"
        case "fa-step-forward": returnValue = "\u{f051}"
        case "fa-stethoscope": returnValue = "\u{f0f1}"
        case "fa-stop": returnValue = "\u{f04d}"
        case "fa-street-view": returnValue = "\u{f21d}"
        case "fa-strikethrough": returnValue = "\u{f0cc}"
        case "fa-stumbleupon": returnValue = "\u{f1a4}"
        case "fa-stumbleupon-circle": returnValue = "\u{f1a3}"
        case "fa-subscript": returnValue = "\u{f12c}"
        case "fa-subway": returnValue = "\u{f239}"
        case "fa-suitcase": returnValue = "\u{f0f2}"
        case "fa-sun-o": returnValue = "\u{f185}"
        case "fa-superscript": returnValue = "\u{f12b}"
        case "fa-support": returnValue = "\u{f1cd}"
        default : returnValue =  "\u{f059}"
        }
    case "t":
        switch name {
        case "fa-table": returnValue = "\u{f0ce}"
        case "fa-tablet": returnValue = "\u{f10a}"
        case "fa-tachometer": returnValue = "\u{f0e4}"
        case "fa-tag": returnValue = "\u{f02b}"
        case "fa-tags": returnValue = "\u{f02c}"
        case "fa-tasks": returnValue = "\u{f0ae}"
        case "fa-taxi": returnValue = "\u{f1ba}"
        case "fa-tencent-weibo": returnValue = "\u{f1d5}"
        case "fa-terminal": returnValue = "\u{f120}"
        case "fa-text-height": returnValue = "\u{f034}"
        case "fa-text-width": returnValue = "\u{f035}"
        case "fa-th": returnValue = "\u{f00a}"
        case "fa-th-large": returnValue = "\u{f009}"
        case "fa-th-list": returnValue = "\u{f00b}"
        case "fa-thumb-tack": returnValue = "\u{f08d}"
        case "fa-thumbs-down": returnValue = "\u{f165}"
        case "fa-thumbs-o-down": returnValue = "\u{f088}"
        case "fa-thumbs-o-up": returnValue = "\u{f087}"
        case "fa-thumbs-up": returnValue = "\u{f164}"
        case "fa-ticket": returnValue = "\u{f145}"
        case "fa-times": returnValue = "\u{f00d}"
        case "fa-times-circle": returnValue = "\u{f057}"
        case "fa-times-circle-o": returnValue = "\u{f05c}"
        case "fa-tint": returnValue = "\u{f043}"
        case "fa-toggle-down": returnValue = "\u{f150}"
        case "fa-toggle-left": returnValue = "\u{f191}"
        case "fa-toggle-off": returnValue = "\u{f204}"
        case "fa-toggle-on": returnValue = "\u{f205}"
        case "fa-toggle-right": returnValue = "\u{f152}"
        case "fa-toggle-up": returnValue = "\u{f151}"
        case "fa-train": returnValue = "\u{f238}"
        case "fa-transgender": returnValue = "\u{f224}"
        case "fa-transgender-alt": returnValue = "\u{f225}"
        case "fa-trash": returnValue = "\u{f1f8}"
        case "fa-trash-o": returnValue = "\u{f014}"
        case "fa-tree": returnValue = "\u{f1bb}"
        case "fa-trello": returnValue = "\u{f181}"
        case "fa-trophy": returnValue = "\u{f091}"
        case "fa-truck": returnValue = "\u{f0d1}"
        case "fa-try": returnValue = "\u{f195}"
        case "fa-tty": returnValue = "\u{f1e4}"
        case "fa-tumblr": returnValue = "\u{f173}"
        case "fa-tumblr-square": returnValue = "\u{f174}"
        case "fa-turkish-lira": returnValue = "\u{f195}"
        case "fa-twitch": returnValue = "\u{f1e8}"
        case "fa-twitter": returnValue = "\u{f099}"
        case "fa-twitter-square": returnValue = "\u{f081}"
        default : returnValue =  "\u{f059}"
        }
    case "u":
        switch name {
        case "fa-umbrella": returnValue = "\u{f0e9}"
        case "fa-underline": returnValue = "\u{f0cd}"
        case "fa-undo": returnValue = "\u{f0e2}"
        case "fa-university": returnValue = "\u{f19c}"
        case "fa-unlink": returnValue = "\u{f127}"
        case "fa-unlock": returnValue = "\u{f09c}"
        case "fa-unlock-alt": returnValue = "\u{f13e}"
        case "fa-unsorted": returnValue = "\u{f0dc}"
        case "fa-upload": returnValue = "\u{f093}"
        case "fa-usd": returnValue = "\u{f155}"
        case "fa-user": returnValue = "\u{f007}"
        case "fa-user-md": returnValue = "\u{f0f0}"
        case "fa-user-plus": returnValue = "\u{f234}"
        case "fa-user-secret": returnValue = "\u{f21b}"
        case "fa-user-times": returnValue = "\u{f235}"
        case "fa-users": returnValue = "\u{f0c0}"
        default : returnValue =  "\u{f059}"
        }
    case "v":
        switch name {
        case "fa-venus": returnValue = "\u{f221}"
        case "fa-venus-double": returnValue = "\u{f226}"
        case "fa-venus-mars": returnValue = "\u{f228}"
        case "fa-viacoin": returnValue = "\u{f237}"
        case "fa-video-camera": returnValue = "\u{f03d}"
        case "fa-vimeo-square": returnValue = "\u{f194}"
        case "fa-vine": returnValue = "\u{f1ca}"
        case "fa-vk": returnValue = "\u{f189}"
        case "fa-volume-down": returnValue = "\u{f027}"
        case "fa-volume-off": returnValue = "\u{f026}"
        case "fa-volume-up": returnValue = "\u{f028}"
        default : returnValue =  "\u{f059}"
        }
    case "w":
        switch name {
        case "fa-warning": returnValue = "\u{f071}"
        case "fa-wechat": returnValue = "\u{f1d7}"
        case "fa-weibo": returnValue = "\u{f18a}"
        case "fa-weixin": returnValue = "\u{f1d7}"
        case "fa-whatsapp": returnValue = "\u{f232}"
        case "fa-wheelchair": returnValue = "\u{f193}"
        case "fa-wifi": returnValue = "\u{f1eb}"
        case "fa-windows": returnValue = "\u{f17a}"
        case "fa-won": returnValue = "\u{f159}"
        case "fa-wordpress": returnValue = "\u{f19a}"
        case "fa-wrench": returnValue = "\u{f0ad}"
        default : returnValue =  "\u{f059}"
        }
    case "x":
        switch name {
        case "fa-xing": returnValue = "\u{f168}"
        case "fa-xing-square": returnValue = "\u{f169}"
        default : returnValue =  "\u{f059}"
        }
    case "y":
        switch name {
        case "fa-yahoo": returnValue = "\u{f19e}"
        case "fa-yelp": returnValue = "\u{f1e9}"
        case "fa-yen": returnValue = "\u{f157}"
        case "fa-youtube": returnValue = "\u{f167}"
        case "fa-youtube-play": returnValue = "\u{f16a}"
        default : returnValue =  "\u{f059}"
        }
    default:
        returnValue =  "\u{f059}"
    }
    
    return returnValue
}
