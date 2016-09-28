#
#  Be sure to run `pod spec lint Typist.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "Typist"
  s.version      = "0.1.0"
  s.summary      = "Small Swift UIKit keyboard manager for iOS apps."

  s.description  = <<-DESC
    Typist is small, drop-in Swift UIKit keyboard manager for iOS apps. 
    It helps you manage keyboard's screen presence and behavior without 
    notification center and Objective-C.
                   DESC

  s.homepage     = "https://github.com/totocaster/Typist"
  s.license      = "MIT"
  
  s.author             = { "Toto Tvalavadze" => "totocaster@me.com" }
  s.social_media_url   = "http://twitter.com/totocaster"
  
  s.platform     = :ios
  s.platform     = :ios, "10.0"

  s.source       = { :git => "https://github.com/totocaster/Typist.git", :commit => "cd2999f03fa1fa652fa596a09b1bd2fb62e5dec0" }

  s.source_files = 'Typist.swift'
end
