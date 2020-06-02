#
# Be sure to run `pod lib lint YMPlayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YMPlayer'
  s.version          = '1.0.2'
  s.summary          = 'A short description of YMPlayer.'


  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/MrQiuHaHa/YMPlayer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'qiujr' => 'qiujunrong@ecpark.cn' }
  s.source           = { :git => 'https://github.com/MrQiuHaHa/YMPlayer.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'

  s.requires_arc = true
  s.static_framework = true
  
  s.subspec 'Core' do |core|
        core.source_files = 'YMPlayer/Classes/Core/**/*.{h,m}'
        core.public_header_files = 'YMPlayer/Classes/Core/**/*.h'
        core.frameworks = 'UIKit', 'MediaPlayer', 'AVFoundation'
        core.dependency 'JRIJKMediaFramework', '0.2.6'
  end
  
  s.subspec 'Common' do |common|
        common.source_files = 'YMPlayer/Classes/Common/**/*.{h,m}'
        common.public_header_files = 'YMPlayer/Classes/Common/**/*.h'
        common.resource = 'YMPlayer/Classes/Common/YMPlayer.bundle'
        common.frameworks = 'UIKit'
  end
  
    # 视频控制层
    s.subspec 'VideoControlView' do |videoControlView|
        videoControlView.source_files = 'YMPlayer/Classes/VideoControlView/**/*.{h,m}'
        videoControlView.public_header_files = 'YMPlayer/Classes/VideoControlView/**/*.h'
        videoControlView.dependency 'YMPlayer/Core'
        videoControlView.dependency 'YMPlayer/Common'
        videoControlView.dependency 'YMPlayer/AVPlayer'
        videoControlView.dependency 'YMPlayer/ijkplayer'
    end
    
    #相册控制层
    s.subspec 'PhotosBrowseView' do |photosBrowseView|
        photosBrowseView.source_files = 'YMPlayer/Classes/PhotosBrowseView/**/*.{h,m}'
        photosBrowseView.public_header_files = 'YMPlayer/Classes/PhotosBrowseView/**/*.h'
        photosBrowseView.dependency 'YMPlayer/Common'
    end
    
    #AVPlayer是系统自带的播放器，封装了一样的使用控制层
    s.subspec 'AVPlayer' do |avPlayer|
        avPlayer.source_files = 'YMPlayer/Classes/AVPlayer/**/*.{h,m}'
        avPlayer.public_header_files = 'YMPlayer/Classes/AVPlayer/**/*.h'
        avPlayer.dependency 'YMPlayer/Core'
    end
    
    #第三方播放器ijkplayer
  s.subspec 'ijkplayer' do |ijkplayer|
      ijkplayer.source_files = 'YMPlayer/Classes/ijkplayer/*.{h,m}'
      ijkplayer.public_header_files = 'YMPlayer/Classes/ijkplayer/*.h'
      ijkplayer.dependency 'YMPlayer/Core'
      ijkplayer.dependency 'JRIJKMediaFramework', '0.2.6'
  end

  
end
