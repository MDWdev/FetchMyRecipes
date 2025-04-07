# FetchMyRecipes
This app will fetch recipes from a provided Recipes json url

Summary Video

https://github.com/user-attachments/assets/c999e80c-9de7-4478-90d7-dde3e6dcac09

Focus: I focused on an attainable MVP that still felt like a rich user experience, with stable services to back it up and make it run smoothly.

Time: I spent approximately 6-8 hours on this project. The element that took me the longest was the loading overlay! I struggled to find a way for it to stay on the screen until the images were physically loaded and visible in each tile, without using a hacky solution.

Trade-offs and Decisions: I could have spent a significant amount of time on making the animations smoother and more fun. I also wanted to be able to show more of the data inside the app code, but considering most of the data was only available inside the html of the source url--I thought that would be too much effort for the expected time spent. I also would like to note that I did not "title" this project as I would a standalone app being sent to production. I imagined it as part of a larger project, as if it were being added inside of the Fetch ecosystem. 

Weakest Part: There are a few things that I would have liked to spend more time to get right. One of them, still, is the loading overlay. The code still makes assumptions that I think could be avoided. It's also very possible that the test coverage could be better. I'm quite the novice when it comes to testing and I feel like things are missing.

Additional Information: This project was an excellent exercise in balancing UX polish with real-world data limitations. Notably, I implemented custom image caching and loading logic to avoid third-party dependencies and to dynamically respond to layout state. A key constraint was the limited recipe metadata, which I handled by linking out via an embedded browser.

I also encountered subtle challenges like launch screen behavior (missing initial view controller) and testing configuration (hanging due to async logic and XCTestExpectations), which I resolved through targeted debugging.

Overall, I want to note how much fun I had building this. It was a breath of fresh air to be able to build something in SwiftUI (which we never used in production in my past employment). While some of the intricacies of working with SwiftUI vs UIKit are sometimes frustrating, I can see the massive amount of potential that SwiftUI has and I hope to be able to utilize it with Fetch in the future!
