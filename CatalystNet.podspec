Pod::Spec.new do |s|

  s.swift_versions              = '5.0'
  s.name                        = 'CatalystNet'
  s.version                     = '1.0.1'
  s.summary                     = 'Universal AppleOS Apps Networking kit'
  s.homepage                    = 'https://github.com/hellc/CatalystNet'
  s.license                     = 'MIT'
  s.author                      = { 'Ivan Manov' => 'ivanmanov@live.com' }
  s.social_media_url            = 'https://twitter.com/ihellc'

  s.requires_arc                = false
  s.ios.deployment_target       = '10.0'
  s.osx.deployment_target       = '10.15'
  s.watchos.deployment_target   = '4.0'

  s.source                      = { :git => 'https://github.com/hellc/CatalystNet.git', :tag => '1.0.1' }
  s.source_files                = 'Sources/**/*.swift'
  
end
