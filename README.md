# DxLoadingHUD
Loading HUD by Swift

Loading animation HUD,base on https://github.com/pkluz/PKHUD and https://github.com/iamim2/OneLoadingAnimation

 ![image](https://github.com/StevenDXC/DxLoadingHUD/blob/master/Image/demo.gif)
 

usage:


show:
```swift
DxLoadingHUD.sharedInstance.show();
```

success:
```swift
DxLoadingHUD.sharedInstance.showSuccessAnimation();
```

failed:
```swift
DxLoadingHUD.sharedInstance.showErrorAnimation();
```

empty:
```swift
DxLoadingHUD.sharedInstance.showEmptyAnimation();
```

hide:
```swift
DxLoadingHUD.sharedInstance.hide(animated:true);
```
