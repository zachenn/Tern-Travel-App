# Tern Travel App

## Overview
Tern is an extensive travel app that gives a holistic view of unfamiliar places, reduces time unnecessarily commuting back and forth, increases the number of POIs you can complete in a day, and allows the creation and sharing of more efficient itineraries.

It is built in native iOS using Swift as well as varying tools, frameworks, and design patterns that were selected to promote the long term scalability, maintainability, user experience, and security of the app. 

I've added the main files for the two views below. The rest of the code is located in a private repo and is available upon request.

## Selected Tools, Frameworks, and Design Patterns 

<!-- (memory management, security), optionals, HTTP Requests --> 
  
### Scalability
* *Firestore (NoSQL)* 
    * Chosen over Core Data as the primary database so that i) the app occupies less memory on the user device and ii) user data is accessible and editable across devices 
* *MVVM architecture*

### Maintainability
* *Programmatic UI + Autolayout*
* *MVVM architecture*
* *Git*
* *Cocoapods*
* *Unit tests*

### User Experience
* *OAuth (Firebase Auth)*
* *3rd party frameworks*
* *Social media sign in SDKs (Google Sign In, FBSDKCoreKit)*
* *Contextual onboarding, an intuitive workflow, and animated transitions*

### Security
* *OAuth (Firebase Auth)*

## Samples of the Basic Use Case of Tern

This is a collection we created titled "Los Angeles"

<img src="https://user-images.githubusercontent.com/27001034/54667137-d7faa680-4aa8-11e9-8c74-9945fd1f5bf2.JPG" width="350"> <img src="https://user-images.githubusercontent.com/27001034/54667152-e779ef80-4aa8-11e9-808c-7faf76e002e6.JPG" width="368">

## Sample Animations for an Enhanced UX/UI

<img src="https://user-images.githubusercontent.com/27001034/55716889-f15a8880-59ac-11e9-884e-2b7a360a55c5.gif" width="300"> 
<img src="https://user-images.githubusercontent.com/27001034/55716897-f4557900-59ac-11e9-972b-7ad3623bf42d.gif" width="300">  
