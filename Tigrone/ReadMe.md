###赛虎离合iOS客户端 相关说明

基本说明：                   

* UI 采用AutoLayout + 多storyBoard 编写，注意：如果某些ViewController不适合用storBoard拖控件，建议仍然在storyBoard添加对应类的ViewController，ViewController的内容可以用代码写，尽量用storyboard处理跳转；
* 网络请求使用AFNetwoking 3.0； 数据库操作用FMDB 
* 暂定适配iOS7.0及以上       

框架说明：                                     
目前框架已经基本搭建完成                 
MVC结构，V和C下面是对应功能模块的文件夹；Model不分子文件夹；          

目前的Controller的模块有：       
1. auth - 登录，注册             
2. FirstPage - 首页                
3. RepairShop - 维修店       
4. ShoppingCart - 购物车       
5. Me - 我                         

其他文件夹                                        

* DB      - 数据库相关操作，基本类已经添加  
* Network - 网络请求相关封装，网络监控，AFN单例
* Vendor  - 第三方库文件； 原则上尽量用稳定常用的第三方库，减少开发时间
* Helper  - 工具类相关，公共方法；类别； 封装的常用View； 常有宏；

其他说明：                      

图片使用Assets，已经建好文件夹目录；     
首次使用的导航已经写好，缺少图片；          
图片缓存会使用SDwebImage；（后续ZG会添加对应类）     

关于取不同storyBoard 中的ViewController 见AppDelegate类中写法；