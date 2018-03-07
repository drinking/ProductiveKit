#脚本使用指南

收集脚本相关的解决方案

##TinyPNG图片压缩使用指南



第一步，筛选出一定大小范围的图片，该例中是50k以上图片。拷贝到一个文件夹下。

```bash
find /path/for/images/ -name "*.png" -size +50k -exec cp {} ./ \;
```

第二步，使用[TinyPNG4Mac](https://github.com/kyleduo/TinyPNG4Mac)将筛选出的图片，勾选覆盖原文件，批量压缩。

第三步，将压缩完的资源重新Copy回原处。

```bash
find /path/for/images/ -name "*.png" -size +50k -exec sh -c "basename {} | xargs -I [] cp [] {}"  \;	
```

请自行修改文件路径以适用不同的需求。