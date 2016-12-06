# SMRESTNetworking
A REST based Networking library for iOS that simplifies making authenticated requests with JSON Web Tokens. 

## Dependencies
SMRESTNetworking uses iOS's Keychain mechanism to encrypt and store tokens passed from servers on the devices. There are many advantages to this technique, including persistance between app installs when desired. Because of this, SMRESTNetworking uses the library - [FXKeychain](https://github.com/nicklockwood/FXKeychain) to handle storing the items into keychain.

## Type Based
SMRESTNetworking is a Type Based system that prevents string-typing as much as possible. Because of this, to get working with SMRESTNetworking, the first step is to edit it's source files. I know this may sound crazy for a library, but trust me it's worth it.

Open the file "SMURLManager" and input your enum cases. This is where you will add/edit the different base routes for your URL.

In SMURLManager:

```swift
var base: String {
        switch self {
            //Add and edit base cases here. Return the string values representing the base URL's. This example shows an APIBase and an AuthBase, where the AuthBase is used to authenticate a user and receive a token, and the APIBase is used to send authenticated requests.
        case .APIBase:
            return "https://..."
        case .AuthBase:
            return "https://..."
        }
    }
```

## Authenticate a user
To authenticate users, we will use the SMAuthenticator class. This class makes the request to the .AuthBase endpoint from above, looks for the token in the response, and saves the token to keychain. To make sure SMAuthenticator finds the token, initialize the SMAutheticator class with the serverTokenKey that is the key name for the token value in the JSON response.
You can pass in whatever body dictionary data you want to store on the server.
Sample Usage:
```swift
    let auth = Authenticator(serverTokenKey: "token")
    let body = ["emailAddress" : "test@gmail.com"]
 
    auth.authenticateUser(userDetailsToSave: body, tokenCallback: {
        tokenReturned, error in
       // Do something with the token if desired, it is persisted already using the SMTokenManager class
    })
```

## Time to make requests!
To make authenticated requests, we simply use the SMNetworkConnection class to make requests and the library handles the rest! Here's how:
```swift
    let url = NSURL(string: SMURLManager.APIBase)!
    let body = ["foo" : "bar"]
    SMNetworkConnection().makeAuthenticatedRequest(requestMethod: RequestMethod.POST, requestURL: url, bodyDictionary: body, returnedJSON: {
            jsonArray in 
            //Handle your JSON data here
        })
```

SMNetworking uses Types for request methods. As the first parameter in makeAuthenticatedRequest, acceptable parameters are .GET || .POST || .PUT || .DELETE

By default, the Header field for the authorization value to be passed in is 'authorization'. This can easily be edited in the SMNetworkConnection.swift file like so:
```swift
let authorizationHeaderField = "anything you want here"
```
