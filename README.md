# dogradar

Take-home assignment for SportRadar

## Details

- iOS 17+
- Xcode 16.2
- Swift 5.9
  - Did not use Swift 6.0 as a lot of concurrency changes were introduced that I have yet to understand


## Used frameworks

- SwiftUI
- Swift Concurrency
- Combine

## Overview

### Architecture:
Tried my go at a modularized architecture for the following reasons:
1. Modules set hard boundaries which help make decisions on what and what not to expose to consumers.
2. Forces the developers to better think reusability of each component.
3. In a more complex app, developing in modules speeds up development cycles due to not having to compile the entire project every time we want to run/test the changes being done.


### Diagram
![Arch-diagram](https://github.com/user-attachments/assets/e7ffc39d-c75e-462b-8448-526da0fb3c8b)


### Components:

#### Core Modules:

- `SharedUtils`:
  - Target `SharedUtils`: Unused for the moment but can contain any shared helpers and mappers that can be used by **ANY** consumer
  - Target `TestingUtils`: Same logic but for testing targets only
- `Networking`:
  - Contains the interface of the API providers + default implementation using `URLSession`. To be used by feature modules **only**
- `UIComponents`:
  - Shared basic UI components that should be shared across the app's screens such as Buttons, TextFields, Loaders, etc. To be used by feature modules **only**

#### Feature Modules:

- `DogListingAPI`:
  - Contains the definition of the API endpoints + the API client that will consume these endpoints. Also contains the DTOs that will be mapped from the API responses. 
- `DogListingCore`:
  - Contains:
    - Domain models that will be used by our features/app.
    - Repositories that will decide where to fetch the data from (remote/cache). For this project, specifically, it's always going to the API but if we wanted to implement caching, this is where the data would be fetched from (using cache policies, for instance)
    - Use Cases that hide all the logic below and will be used by our View Models to request any data necessary to be adapted and displayed on the view.
- `ListFeature`:
  - Feature module that contains the Listing view with the search logic. Depends on `DetailFeature` to present the detail view when tapping on an element of the dog breed list.
- `DetailFeature`:
  - Feature module that contains the Detail view that displays the title and image of the breed.

## Potential improvements:

- Adding snapshot or UI tests for the views.
- Caching (`FileManager` or `Core Data`) to reduce network calls.
- DI containers could be inverted and having the modules requesting the dependencies from a service locator, instead of the app injecting them in the feature modules.
- Some components naming can be updated to better portray the meaning of that component.

--------- 

# Thank you!
