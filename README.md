# YMPlayer

## 注意事项：
> 因为github对单文件超过100MB的限制上传，而当前工程依赖的IJKMediaFramework超过了100MB
> 我使用了git-lfs才上传上去，所以要clone下来也需要安装git-lfs

```
brew install git-lfs
# 在你要引入的项目目录下
git lfs install
```
> 参考资料：https://www.jianshu.com/p/3f25cd20e392

## install
> 推荐使用方式二，拉取下来后推到你自己的个人私有源，或者自己拉取demo集成到你的项目

方式一：
```
source 'https://github.com/MrQiuHaHa/JRSpecs.git'   # 在podfile最上面指定源
pod 'YMPlayer'    # 在podfile的target里
```

方式二：
```
git clone https://github.com/MrQiuHaHa/JRIJKMediaFramework.git
cd YMPlayer/Example
pod install
```


## Author

qiujr, 2574282239@qq.com

## License

YMPlayer is available under the MIT license. See the LICENSE file for more info.
