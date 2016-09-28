Pod::Spec.new do |s|

  s.name         = "Typist"
  s.version      = "0.1"
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

  s.source       = { :git => "https://github.com/totocaster/Typist.git", :tag => "0.1" }

  s.source_files = 'Typist.swift'
end
