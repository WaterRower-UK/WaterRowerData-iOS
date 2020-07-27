Pod::Spec.new do |s|
  s.name		= 'WaterRowerData-BLE'
  s.version		= '0.1.1'
  s.summary		= 'A library for reading data from a BLE-connected WaterRower device.'

  s.homepage		= 'https://github.com/WaterRower-UK/WaterRowerData-iOS'
  s.license		= { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author		= { 'Niek Haarman' => 'niek@305.nl' }

  s.source		= { :git => 'https://github.com/WaterRower-UK/WaterRowerData-iOS.git', :tag => s.version.to_s }
  s.swift_version	= '5.0'
  
  s.ios.deployment_target = '11.0'

  s.source_files 	= 'Sources/WaterRowerData-BLE/**/*.swift'
end
