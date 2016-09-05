#集成EaseCustomer说明  

1. 参照EaseCustomerDemo来进行建立。  
2. 首先建立一个工程，然后直接把EaseCustomer文件夹拖入工程，不需要选择“Copy item when needed!”  
3. 设置pch: 点击工程，builder setting,在过滤处 prefix 即可以找到：并增加相应的路径：
    $(PROJECT_DIR)/../EaseCustomer/ChatDemo-UI3.0/ChatDemo-UI3.0-Prefix.pch (增加相对路径)  
4. 配置infolist : build Settings :  Package/InfoListFile :  检查后并打开响应的文件，  
       增加配置： + App Transport Security Settings : Dictionary
                                   Allow Arbitary Loads Boolean YES 
   如果不配置，则用http不能发送和接收文件，具体可以google  
5. 配置头文件 和 framewok，lib的查找路径.
  在 build Settings中 过滤： search ,配置相应的路径即可。注意用相对路径，如果麻烦，可以设置为递归 recurse  
6. 编译：如果在连接时出错，则增加如下FrameWork 即可：

	*	SystemConfiguration.framework
	*	CoreMedia.framework
	*	MobileCoreServices.framework
	*	ImageIO.framework
	*	libc++.tbd
	*	libz.tbd
	*	libstdc++.6.0.9.tbd
	*	libsqlite3.tbd
	*	libiconv.tbd

   注意：其他的libMobClickLibrary.a, libopencore-amrwb.a,libopencore-amrnb.a,libHyphenteFullSDK.a, Parse.framework, Bolts.framework  均是EaseCustomer拖入后自动加入的。
    Foundation.framework 和UIKit.framework一般不用特别设置。如果出现报错提示，则需要设置。

  这样一般就可编译通过。 
