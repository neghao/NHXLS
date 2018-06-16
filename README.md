### excel文件生成、分享，支持微信和QQ直接打开阅读
> 你只需要将：** NHXLS**文件夹拖入你的工程，就可以直接使用，打包上架的时候建议将lib库换成**armv7-arm64**文件里面那个，这个只支持真机，可以减少ipa包的大小；

##### 搞这样一个库的原因：
起初自已直接通过oc代码生成的xls文件，电脑和专业的excel软件能读取，但在手机上分享到微信和QQ后，微信上无法直接打开读取，

于是借处了第三方开源库：[DHlibxls](https://github.com/dhoerl/DHlibxls)，感谢DHlibxls；
我这编译了支持：`armv7` `x86_64` `arm64`构架的包，也有单独支持某种构架的包，看你自己的需求去替换，这样可以减小ipa的大小。
详情见：**/NHXLS/NHXLS/lib/**这个目录

demo[传送门](https://github.com/nenhall/NHXLS)

![效果图](https://github.com/nenhall/NHXLS/demogift.gif)

