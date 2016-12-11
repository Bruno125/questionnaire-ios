# questionnaire-ios

iOS application developed as my first assignment for COMP327 - Mobile Computing at University of Liverpool.

It's my first attempt to develop an iOS app using the MVVM pattern + RxSwift

UPDATE: I got full marks for this project 😉!

## Setup

To run this project, you will need:
- Xcode 8.+
- Swift 3.0.+
- [Carthage dependency manager](https://github.com/Carthage/Carthage)

When downloading the project, please run 

`carthage update --platform iOS --no-use-binaries`

to generate the proper build versions for your local configuration

## Rx + MVVM

This project uses the Model-View-ViewModel pattern, in combination with RxSwift. Basically, the view model will emmit streams of data for which the view will subscribe (using Rx observables) to update its UI. For further info about this, you can check [here](http://reactivex.io/), [here](https://realm.io/news/altconf-scott-gardner-reactive-programming-with-rxswift/) and [here](https://upday.github.io/blog/model-view-viewmodel/)

## Data

This are the models used to represent the data in the app. Every model has a unique ID

- __Questionnaire__: represents a collection of questions. Has a `title` a `description`, and a set of `Question`s
- __Question__: represents an specific question from the questionnarie. Has `title`, a collection of `Choice`s, and a type. 
   - __Text__: a question where the user has to type his answer. Will only have ONE choice, of type text
   - __Numeric__: a question where the user can pick a numeric value. Will only have ONE choice, of type numeric
   - __Single option__: a question that displays a list of choices, and only allows the user to select one
   - __Multiple option__: a question that displays a list of choices, and allows the user to select as many as he wants
- __Choice__: represents a choice within a question. 
   - __Text__: has a `question` and a `hint`
   - __Numeric__: has a `min` and `max` value
   - __Single/Multiple option__: has a `label` and optional `value`
- __Answer__: represents an answer for a question. It's generated when the user completes the questionnaire, and saves the `questionnaireId` and the `questionId`. There is only one type of answer, but its data will be set differently depending on the question type

## Data Source

The data can be access by four different ways:

- __Web service__: That will return a json file with the questionnaire information. To see the json structure used in this app, you can [check the URL that the app consumes](https://private-9d5799-questionnaireapp.apiary-mock.com/questionnaire). This is managed in the [`QuestionnaireService`](Questionnaire/Data/Source/Questionnaire/QuestionnaireService.swift)
- __JSON file__: there are a couple of .json files inside the projects that contain a json with the same structure as the one used in the web service. This is managed in the [`QuestionnaireFileSource`](Questionnaire/Data/Source/Questionnaire/QuestionnaireFileSource.swift)
- __Core data__: once the user completes the questionnaire, his answers are saved in Core Data. This is managed in the [`AnswerCoreData`](Questionnaire/Data/Source/Answer/AnswerCoreData.swift)
- __Simulated data__: this generates random answers data, in case you feel too lazy to answer the questionnaire. This is managed in the [`AnswerSimulatedRepo`](Questionnaire/Data/Source/Answer/AnswerSimulatedRepo.swift)

## Multiple targets

The app supports multiple targets to show the usage of the `Injection` class. At this moment, there are 3 targets:

- __Questionnaire A__: uses the `QuestionnaireRepository` to access the data
- __Questionnaire B__: uses the `QuestionnaireFileSource` to access the data
- __Questionnaire C__: uses the `QuestionnaireFileSource` and `AnswerSimulatedRepo` to access the data

This is managed under the Injection folder (notice how every `Injection` belongs to a different target)

## Questionnarie preview

<img src="https://media.giphy.com/media/3oriO5OASvOMfpHjCE/source.gif" alt="Questionnaire preview" width="200" />

## Statistics preview

<img src="https://media.giphy.com/media/3oriOiaALnZXCAjp60/source.gif" alt="Statistics preview" width="200" />

## Dependencies

The frameworks used in this project are:
- [RxSwift](https://github.com/ReactiveX/RxSwift)
- [Alamofire](https://github.com/Alamofire/Alamofire)
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
- [Charts](https://github.com/danielgindi/Charts)
- [NVActivityIndicatorView](https://github.com/ninjaprox/NVActivityIndicatorView)

