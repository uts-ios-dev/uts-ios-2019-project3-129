# BlogChain

BlogChain is a blog platform running on iOS which hosts its blogs on the blockchain. By doing so, it is easier to protect the intellectual property and may extend the life-hood of articles (as long as at least one copy exists in the network).

## How to run
Install Vapor

```shell
brew tap vapor/tap
brew install vapor/tap/vapor
```

Execute following commands in `/server` folder

```shell
vapor build
```

Use the following command to create xcode project file.

```shell
vapor xcode
```

```shell
vapor run --port=8080
```

(You may run another server on a different port to see how the blockchain sync between servers.)

Install Cocoapods

```shell
sudo gem install cocoapods
```

Install the pods by executing the following command in the `/blogchain` folder.

```shell
pod install
```

For the Notepad package which provides the markdown editor feature, you may need to follow this [issue](https://github.com/ruddfawcett/Notepad/issues/52#issuecomment-496066568) to fix the "theme not found" problem, since the developer has not combined the fixing solution in his main branch.


## Features

#### Sign-in is protected by Touch ID

![](https://github.com/uts-ios-dev/uts-ios-2019-project3-129/blob/master/docs/BC-Touch-ID.PNG)

#### PIN code is supported as well

![](https://github.com/uts-ios-dev/uts-ios-2019-project3-129/blob/master/docs/BC-PIN-code.png)

#### Create a note

![](https://github.com/uts-ios-dev/uts-ios-2019-project3-129/blob/master/docs/BC-New-Note.png)

*Notes support markdown!*

#### Modify and upload a note

![](https://github.com/uts-ios-dev/uts-ios-2019-project3-129/blob/master/docs/BC-Upload-Note.png)

#### Search notes

![](https://github.com/uts-ios-dev/uts-ios-2019-project3-129/blob/master/docs/BC-Search-Notes.png)

#### Delete a note

![](https://github.com/uts-ios-dev/uts-ios-2019-project3-129/blob/master/docs/BC-Delete-Note.png)

#### User

![](https://github.com/uts-ios-dev/uts-ios-2019-project3-129/blob/master/docs/BC-User.png)

#### Sync blockchains between servers

(Each server has to register on others)

##### Register by POST `\api\nodes\register`

![](https://github.com/uts-ios-dev/uts-ios-2019-project3-129/blob/master/docs/BC-Register-Node.png)

##### Sync by GET `\resolve`

![](https://github.com/uts-ios-dev/uts-ios-2019-project3-129/blob/master/docs/BC-Resolve.png)

## Frameworks used

- SnapKit
- Alamofire
- Notepad
- CommonCrypto
- CodableFirebase
