# UserDefaultsEx
> Making UserDefaults great (again?)

By [v-braun - viktor-braun.de](https://viktor-braun.de).

[![](https://img.shields.io/github/license/v-braun/UserDefaultsEx.svg?style=flat-square)](https://github.com/v-braun/UserDefaultsEx/blob/master/LICENSE)
[![Build Status](https://img.shields.io/travis/v-braun/UserDefaultsEx.svg?style=flat-square)](https://travis-ci.org/v-braun/UserDefaultsEx)
![PR welcome](https://img.shields.io/badge/PR-welcome-green.svg?style=flat-square)

<p align="center">
<img width="70%" src="https://via.placeholder.com/800x480.png?text=this%20is%20a%20placeholder%20for%20the%20project%20banner" />
</p>


## Description
Help you to store _Codable_ Objects within UserDefaults.  
Just define your properties and UserDefaultsEx will take care of the encoding and decoding process.


## Installation

```
.package(url: "https://github.com/v-braun/UserDefaultsEx", from: "1.0.0")
```


## Usage

``` swift
struct TestSetting : Codable{
    var prop1 = ""
    var prop2 = ""
}

extension UserDefaults{
    @JsonUserDefault(storeIn: UserDefaults.standard, withKey: "mySettings", defaults: TestSetting())
    static var mySettings : TestSetting
}

// somewhere:

let settings = UserDefaults.mySettings // will read the settings

settings.prop1 = "hello"
settings.prop2 = "world"

UserDefaults.mySettings = settings // will write the settings

```


## Authors

![image](https://avatars3.githubusercontent.com/u/4738210?v=3&amp;s=50)  
[v-braun](https://github.com/v-braun/)



## Contributing

Make sure to read these guides before getting started:
- [Contribution Guidelines](https://github.com/v-braun/UserDefaultsEx/blob/master/CONTRIBUTING.md)
- [Code of Conduct](https://github.com/v-braun/UserDefaultsEx/blob/master/CODE_OF_CONDUCT.md)

## License
**UserDefaultsEx** is available under the MIT License. See [LICENSE](https://github.com/v-braun/UserDefaultsEx/blob/master/LICENSE) for details.
