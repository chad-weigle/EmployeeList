# EmployeeList
A simple list app for practice

## Build tools & versions used
XCode Version 13.3 (13E113)
xcode-select version 2395

## Steps to run the app
Open the project through xcode.
Once loaded, click the "run" button in the top left to deploy to an iPhone simulator.
P.S. I ran this on an iPhone 13 Pro, iPhone SE, and iPad Air simulator and all 3 looked good.

## Steps to run the tests
Open the project through xcode.
Once loaded, click and hold the "run" button in the top left and drag down to the tests icon to select and run tests.
P.S. There are UI test files but currently are just placeholders. The unit test I wrote for the api request is in NetworkTests.swift.

## What areas of the app did you focus on?
I spread my focus pretty evenly between UI/feature completeness, architecture, and code cleanliness.

## What was the reason for your focus? What problems were you trying to solve?
I wanted to meet all of the requirements evenly without missing any so I didn't focus in one area
more than any others. This is also because my professional experience has also been pretty evenly
spread over the years so I wouldn't say I have an expertise in anyone thing over another.

## How long did you spend on this project?
About 8 hours total across a week.

## Did you make any trade-offs for this project? What would you have done differently with more time?
I would have liked to use SwiftUI rather than Storyboards but as I am more familiar with Storyboards, 
I stuck to what I knew. With more time to learn SwiftUI before beginning the project, I would have used it.

I also would have added in a few more unit tests to ensure my EmployeeImageService class was fully tested.
Lastly, I would have made improvements to the UI. I would have added in some flair to the table to make
it less plain.

## What do you think is the weakest part of your project?
The UI itself is straight forward but VERY plain. I would enjoy spending a couple of hours cleaning 
up the style, adding some colors, and adding some flair with fun features (like tapping to expand a cell to view more, 
and using a collection view that scaled horizontally on larger screens like iPad).

## Did you copy any code or dependencies? Please make sure to attribute them here!
I used this hackingwithswift blog post to help with the async api requests:
https://www.hackingwithswift.com/books/ios-swiftui/sending-and-receiving-codable-data-with-urlsession-and-swiftui

Quick stack overflow to remember the line of code to load from a nib:
https://stackoverflow.com/questions/24857986/load-a-uiview-from-nib-in-swift

Resources for unit test with mock URLSession:
https://medium.com/@dhawaldawar/how-to-mock-urlsession-using-urlprotocol-8b74f389a67a
https://www.swiftbysundell.com/articles/unit-testing-code-that-uses-async-await/

Resources for image caching:
https://programmingwithswift.com/save-images-locally-with-swift-5/

## Is there any other information you’d like us to know?
I hope you like my project and I look forward to speaking with you soon!
