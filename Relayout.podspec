Pod::Spec.new do |s|

  s.name         = "Relayout"
  s.version      = "2.0.0"
  s.summary      = "Swift microframework for declaring Auto Layout constraints functionally"

  s.description  = <<-DESC
Relayout is a Swift microframework to make using Auto Layout easier with static and dynamic layouts.
Instead of trying to hold references to specific constraints and mutating them when your state
changes, create a single object that returns all the constraints you need for any given UI state.
Relayout will apply those new constraints automatically as needed. This makes it super easy to create
really dynamic layouts that change or react to UI state changes using Auto Layout.
                   DESC

  s.homepage     = "https://github.com/stevestreza/Relayout"
  s.license      = { :type => "ISC", :file => "LICENSE" }

  s.author    = "Steve Streza"
  s.social_media_url   = "https://twitter.com/SteveStreza"

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'

  s.source       = { :git => "https://github.com/stevestreza/Relayout.git", :branch => "swift-3" }

  s.source_files  = "Framework", "Framework/**/*.swift"

  s.frameworks = "Foundation"
  s.ios.frameworks = "UIKit"
  s.tvos.frameworks = "UIKit"
  s.osx.frameworks = "AppKit"
end
