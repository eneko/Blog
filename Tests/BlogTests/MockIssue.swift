//
//  File.swift
//  
//
//  Created by Eneko Alonso on 12/27/20.
//

import Foundation

let mockIssue = """
{
    "active_lock_reason": null,
    "assignee": null,
    "assignees": [],
    "author_association": "OWNER",
    "body": "Social Media previews look pretty neat when sharing links to your blog on social media (e.g. Twitter). These can be configured in many ways, and are often defined manually (unique image per post). Some sites use a heading image for the blog post that appears at the top of the article and in social media. \\r\\n\\r\\n### Manually picked preview images\\r\\nHere is an example of a shared post from my blog, where the social media preview image has been manually picked:\\r\\n\\r\\n<blockquote class=\"twitter-tweet\"><p lang=\"en\" dir=\"ltr\">Eager to try async/await in Swift? Now you can! Here is how: <a href=\"https://t.co/PMk7E7iLhr\">https://t.co/PMk7E7iLhr</a><a href=\"https://twitter.com/hashtag/swift?src=hash&amp;ref_src=twsrc%5Etfw\">#swift</a> <a href=\"https://twitter.com/hashtag/async?src=hash&amp;ref_src=twsrc%5Etfw\">#async</a> <a href=\"https://twitter.com/hashtag/await?src=hash&amp;ref_src=twsrc%5Etfw\">#await</a></p>&mdash; Eneko Alonso (@eneko) <a href=\"https://twitter.com/eneko/status/1335799626440425472?ref_src=twsrc%5Etfw\">December 7, 2020</a></blockquote> <script async src=\"https://platform.twitter.com/widgets.js\" charset=\"utf-8\"></script>\\r\\n\\r\\n### Templated or generated preview images\\r\\n\\r\\nOther sites automatically generate an image programmatically (or with a template). Here are some examples of templated previews, or programmatically generated ones.\\r\\n\\r\\n<blockquote class=\"twitter-tweet\"><p lang=\"en\" dir=\"ltr\">This approach popped up in a recent coaching session I was running. There&#39;s a few trade-offs, but I might be using this technique more in the future.<br><br>Have you tried something like this? Is there a less obvious downside that I&#39;m missing?<a href=\"https://t.co/PZZC0iXI7L\">https://t.co/PZZC0iXI7L</a></p>&mdash; Joe Masilotti (@joemasilotti) <a href=\"https://twitter.com/joemasilotti/status/1342134689281101826?ref_src=twsrc%5Etfw\">December 24, 2020</a></blockquote> <script async src=\"https://platform.twitter.com/widgets.js\" charset=\"utf-8\"></script>\\r\\n\\r\\n<blockquote class=\"twitter-tweet\"><p lang=\"en\" dir=\"ltr\">Get started with Associated Types in Swift<a href=\"https://t.co/Gwe5cSyErr\">https://t.co/Gwe5cSyErr</a><br><br>🤓 Associated types explained<br>💪🏼 Real case code example shared<br>🚀 Reuse code among multiple types<a href=\"https://twitter.com/hashtag/swiftlang?src=hash&amp;ref_src=twsrc%5Etfw\">#swiftlang</a> <a href=\"https://twitter.com/hashtag/iosdev?src=hash&amp;ref_src=twsrc%5Etfw\">#iosdev</a></p>&mdash; Antoine v.d. SwiftLee 🚀 (@twannl) <a href=\"https://twitter.com/twannl/status/1342802192093356033?ref_src=twsrc%5Etfw\">December 26, 2020</a></blockquote> <script async src=\"https://platform.twitter.com/widgets.js\" charset=\"utf-8\"></script>\\r\\n\\r\\n## Making a media preview image for my blog from scratch\\r\\n\\r\\nI wanted to generate the image myself, in Swift, and preferably with SwiftUI. I also wanted this to be done in the cloud, instead of my computer. If you've been following my posts, you might remember my goal is for me to write GitHub Issues on my [Blog](https://github.com/eneko/Blog) repo and have the workflow take it from there.\\r\\n\\r\\n### Working with SwiftUI previews\\r\\n\\r\\nThis repository is set up as a Swift package. While SwiftUI views can be written and distributed inside Swift packages, Xcode does not support yet generating live previews without an Xcode project 😭\\r\\n\\r\\nSo I made a bogus macOS application with my view on it, so I could code it and preview in real-time. The best thing about SwiftUI previews is being able to set up multiple previews, to try different values for blog post titles, tags, etc.\\r\\n\\r\\n![Screen Shot 2020-12-27 at 8 50 01 AM](https://user-images.githubusercontent.com/32922/103179791-6d14fc80-4844-11eb-8875-2467ca555eab.png)\\r\\n\\r\\n### Swift code\\r\\n\\r\\nHere is the code for my SwiftUI view, as of now (might probably change by the time I finish writing this article)\\r\\n\\r\\n```swift\\r\\nstruct SocialPreview: View {\\r\\n    let brandColor = Color(#colorLiteral(red: 0.1843137255, green: 0.5411764706, blue: 1, alpha: 1))\\r\\n    let textColor = Color.white\\r\\n    let dateTemplate = DateTemplate().month(.full).day().year()\\r\\n\\r\\n    let title: String\\r\\n    let tags: [String]\\r\\n    let date: Date\\r\\n    let issueNumber: Int\\r\\n\\r\\n    var body: some View {\\r\\n        ZStack{\\r\\n            VStack {\\r\\n                HStack() {\\r\\n                    Spacer(minLength: 0)\\r\\n                    Text(binary(title: title))\\r\\n                        .font(.custom(\"Monaco\", size: 16))\\r\\n                        .multilineTextAlignment(.trailing)\\r\\n                        .frame(maxWidth: 200)\\r\\n                }\\r\\n                Spacer(minLength: 0)\\r\\n            }\\r\\n            .padding()\\r\\n            .opacity(0.1)\\r\\n\\r\\n            VStack(alignment: .leading, spacing: 10) {\\r\\n                Spacer(minLength: 0)\\r\\n                VStack(alignment: .leading) {\\r\\n                    Text(\"enekoalonso.com\")\\r\\n                        .font(.custom(\"SF Pro Display\", size: 24))\\r\\n                    Text(title)\\r\\n                        .font(.custom(\"SF Pro Display\", size: 64))\\r\\n                        .fontWeight(.bold)\\r\\n                }\\r\\n                HStack {\\r\\n                    ForEach(0..<tags.count) { index in\\r\\n                        let tag = tags[index]\\r\\n                        Text(tag)\\r\\n                            .font(.custom(\"SF Pro Display\", size: 24))\\r\\n                            .fontWeight(.bold)\\r\\n                            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))\\r\\n                            .overlay(\\r\\n                                RoundedRectangle(cornerRadius: 10)\\r\\n                                    .stroke(textColor, lineWidth: 2)\\r\\n                            )\\r\\n                    }\\r\\n                }\\r\\n                Spacer(minLength: 0)\\r\\n                HStack(alignment: .firstTextBaseline) {\\r\\n                    Text(\"An Over-Engineered Blog\")\\r\\n                        .fontWeight(.semibold)\\r\\n                    Text(\"—\")\\r\\n                    Text(\"Issue #\\(issueNumber)\")\\r\\n                    Spacer()\\r\\n                    Text(dateTemplate.localizedString(from: date))\\r\\n                        .font(.system(size: 18))\\r\\n                }\\r\\n                .font(.custom(\"SF Pro Display\", size: 24))\\r\\n            }\\r\\n            .padding(80)\\r\\n        }\\r\\n        .frame(maxWidth: .infinity, maxHeight: .infinity)\\r\\n        .foregroundColor(textColor)\\r\\n        .background(brandColor)\\r\\n    }\\r\\n\\r\\n    func binary(title: String) -> String {\\r\\n        let trimmed = String(title.prefix(60))\\r\\n        let binary = Data(trimmed.utf8).map { byte in\\r\\n            String(String(String(byte, radix: 2).reversed()).padding(toLength: 8, withPad: \"0\", startingAt: 0).reversed())\\r\\n        }\\r\\n        return binary.joined(separator: \" \")\\r\\n    }\\r\\n}\\r\\n```\\r\\n\\r\\nI added a method to render the blog post title as binary code. I have many other ideas to decorate the background based on the blog post title and tags, but haven't get to do it yet. Maybe later.\\r\\n\\r\\nTo rasterize the SwiftUI view into an image, I'm using the same technique I used with [ConsoleUI](https://github.com/eneko/ConsoleUI). Basically, the process is to use an `NSHostingView` view, rasterize it's contents to PNG, and save to disk.\\r\\n\\r\\n```swift\\r\\nstruct SocialPreviewGenerator {\\r\\n    static func main() throws {\\r\\n        let arguments = ProcessInfo.processInfo.arguments\\r\\n        guard arguments.count == 3 else {\\r\\n            print(\"Missing arguments.\")\\r\\n            return\\r\\n        }\\r\\n        let title = arguments[1]\\r\\n        let tags = [\"docker\", \"linux\", \"swift\"]\\r\\n        let date = Date()\\r\\n        let issueNumber = Int(arguments[2]) ?? 0\\r\\n\\r\\n        print(\"Generating Social Preview for issue #\")\\r\\n\\r\\n        let view = SocialPreview(title: title, tags: tags, date: date, issueNumber: issueNumber)\\r\\n        let wrapper = NSHostingView(rootView: view)\\r\\n        wrapper.frame = CGRect(x: 0, y: 0, width: 1280, height: 640)\\r\\n\\r\\n        let png = rasterize(view: wrapper, format: .png)\\r\\n        try png?.write(to: URL(fileURLWithPath: \"issue-\\(issueNumber).png\"))\\r\\n    }\\r\\n\\r\\n    static func rasterize(view: NSView, format: NSBitmapImageRep.FileType) -> Data? {\\r\\n        guard let bitmapRepresentation = view.bitmapImageRepForCachingDisplay(in: view.bounds) else {\\r\\n            return nil\\r\\n        }\\r\\n        bitmapRepresentation.size = view.bounds.size\\r\\n        view.cacheDisplay(in: view.bounds, to: bitmapRepresentation)\\r\\n        return bitmapRepresentation.representation(using: format, properties: [:])\\r\\n    }\\r\\n}\\r\\n\\r\\ntry SocialPreviewGenerator.main()\\r\\n```\\r\\n\\r\\nYou can find the full source code on this repo, feel free to use it.\\r\\n\\r\\n## Setting up the workflow\\r\\n\\r\\nSince SwiftUI only runs on Apple platforms, I decided to run this process in a GitHub Action workflow, using a macOS job.\\r\\n\\r\\nHere is how it works:\\r\\n- I've updated my existing [issue workflow](https://github.com/eneko/Blog/blob/main/.github/workflows/issue.yml), adding a new `generateSocialPreview` job\\r\\n- This job runs on macOS\\r\\n- The job checks-out the repo, and runs the Swift command to generate the media preview image.\\r\\n- Finally, the workflow uploads the generated image to Amazon S3.\\r\\n\\r\\nThis workflow will run before pushing the issue changes to AWS SQS.\\r\\n\\r\\n![Screen Shot 2020-12-27 at 2 16 06 PM](https://user-images.githubusercontent.com/32922/103180848-95a1f400-484e-11eb-9a39-25f06363557f.png)\\r\\n\\r\\n\\r\\n### Uploading images to Amazon S3\\r\\n\\r\\nUploading files to S3 is pretty easy, since we can use AWS CLI in Github Actions. First, we set the credentials, and then we are good to go. Here, I'm hardcoding the file name, but will later be dynamic based in the issue number:\\r\\n\\r\\n```yaml\\r\\n      - uses: aws-actions/configure-aws-credentials@v1\\r\\n        with:\\r\\n          aws-access-key-id: ${ { secrets.AWS_ACCESS_KEY_ID } }\\r\\n          aws-secret-access-key: ${ { secrets.AWS_SECRET_ACCESS_KEY } }\\r\\n          aws-region: us-east-2\\r\\n      - name: Copy to S3\\r\\n        run: |\\r\\n          aws s3 cp issue-25.png s3://eneko-blog-media/social-preview/issue-25.png --acl public-read\\r\\n```\\r\\n\\r\\nTo get this working, the user role associated with the credentials must have permissions to put objects in S3, and to update their ACL, so they can be make public-read.\\r\\n\\r\\nHere is how my policy looks like:\\r\\n\\r\\n```json\\r\\n{\\r\\n    \"Version\": \"2012-10-17\",\\r\\n    \"Statement\": [\\r\\n        {\\r\\n            \"Sid\": \"VisualEditor0\",\\r\\n            \"Effect\": \"Allow\",\\r\\n            \"Action\": [\\r\\n                \"s3:PutObject\",\\r\\n                \"s3:PutObjectAcl\"\\r\\n            ],\\r\\n            \"Resource\": \"arn:aws:s3:::eneko-blog-media/*\"\\r\\n        }\\r\\n    ]\\r\\n}\\r\\n```\\r\\n\\r\\n## Running the workflow\\r\\n\\r\\nAfter a couple of runs testing permissions, the workflow completed successfully.\\r\\n\\r\\n![Screen Shot 2020-12-27 at 10 24 18 AM](https://user-images.githubusercontent.com/32922/103179788-5ff80d80-4844-11eb-92ec-75321cf7800c.png)\\r\\n\\r\\n## Unexpected Issue: No Fonts!\\r\\n\\r\\nWell, not that there are no fonts, but the fonts I'm using, \"SF Pro Display\" and \"SF Mono\" do not seem to be installed on macOS instances in Github Actions. 😭\\r\\n\\r\\nHere is how it looks like \"out-of-the-box\"\\r\\n\\r\\n![issue-25](https://user-images.githubusercontent.com/32922/103179779-3b039a80-4844-11eb-9ce4-04d2315107f6.png)\\r\\n\\r\\n### Attempt 1: Adding custom fonts\\r\\n\\r\\nI downloaded SF Pro Display and SF Mono fonts from Apple website, [added them to this repo](https://github.com/eneko/Blog/commit/ca39f84c07d06343ddd9bd9da49e3e58ad7a09f6), and updated the workflow to copy them to `~/Library/Fonts`. \\r\\n\\r\\nNo luck. While the [workflow completed successfully](https://github.com/eneko/Blog/runs/1615026612?check_suite_focus=true), the rendered image looks as before, without custom San Francisco fonts.\\r\\n\\r\\n### Attempt 2: Using system fonts\\r\\n\\r\\nInstead of trying to install a custom font (might try again later), for now I'm going to use the default system font.\\r\\n\\r\\nAnd... there you go! Much better 👏👏\\r\\n\\r\\n![issue-25-2](https://user-images.githubusercontent.com/32922/103181132-76a56100-4852-11eb-8400-99e3a9baf528.png)\\r\\n\\r\\n## Final steps\\r\\n\\r\\nNow that the workflow is working, there are a few remaining tasks:\\r\\n- Configure preview generator to pass all issue arguments (title, tags, creation date and issue number). Since it is a command line tool, I could either pass this info via individual arguments, or passing JSON via stdin or disk.\\r\\n- Update post template to use new generated image url for social media previews.\\r\\n\\r\\nLet's get to it.\\r\\n\\r\\n### Processing event issues (JSON)\\r\\n\\r\\nSince I already have the `Codable` structures for the Lambda to load the event issue JSON, I decide to also use them for the social media preview generator. Here are the two structures I'll be using:\\r\\n\\r\\n```swift\\r\\npublic struct GitHubIssue: Codable {\\r\\n    public let number: Int\\r\\n    public let state: String\\r\\n    public let body: String\\r\\n    public let title: String\\r\\n    public let labels: [GitHubLabel]\\r\\n    public let createdAt: Date\\r\\n    public let updatedAt: Date\\r\\n}\\r\\n\\r\\npublic struct GitHubLabel: Codable {\\r\\n    public let color: String\\r\\n    public let name: String\\r\\n}\\r\\n```\\r\\n\\r\\nI'm also reusing `IssueParser`, since it has the logic for parsing ISO dates and `snake_case` JSON keys.\\r\\n\\r\\nHere is the Yaml action:\\r\\n\\r\\n```yaml\\r\\n      - name: Generate Preview\\r\\n        run: |\\r\\n          swift run socialpreview ${ { toJSON(github.event.issue) } }\\r\\n```\\r\\n",
    "closed_at": null,
    "comments": 0,
    "comments_url": "https://api.github.com/repos/eneko/Blog/issues/13/comments",
    "created_at": "2020-12-27T18:14:09Z",
    "events_url": "https://api.github.com/repos/eneko/Blog/issues/13/events",
    "html_url": "https://github.com/eneko/Blog/issues/13",
    "id": 775084430,
    "labels": [
      {
        "color": "F05138",
        "default": false,
        "description": "",
        "id": 2614311701,
        "name": "SwiftUI",
        "node_id": "MDU6TGFiZWwyNjE0MzExNzAx",
        "url": "https://api.github.com/repos/eneko/Blog/labels/SwiftUI"
      },
      {
        "color": "0C9A73",
        "default": false,
        "description": "",
        "id": 2607308698,
        "name": "blog-engine",
        "node_id": "MDU6TGFiZWwyNjA3MzA4Njk4",
        "url": "https://api.github.com/repos/eneko/Blog/labels/blog-engine"
      },
      {
        "color": "555555",
        "default": false,
        "description": "",
        "id": 2603821568,
        "name": "draft",
        "node_id": "MDU6TGFiZWwyNjAzODIxNTY4",
        "url": "https://api.github.com/repos/eneko/Blog/labels/draft"
      },
      {
        "color": "032F62",
        "default": false,
        "description": "",
        "id": 2602390373,
        "name": "github-actions",
        "node_id": "MDU6TGFiZWwyNjAyMzkwMzcz",
        "url": "https://api.github.com/repos/eneko/Blog/labels/github-actions"
      }
    ],
    "labels_url": "https://api.github.com/repos/eneko/Blog/issues/13/labels{/name}",
    "locked": false,
    "milestone": null,
    "node_id": "MDU6SXNzdWU3NzUwODQ0MzA=",
    "number": 13,
    "performed_via_github_app": null,
    "repository_url": "https://api.github.com/repos/eneko/Blog",
    "state": "open",
    "title": "Generating Social Media preview images with SwiftUI and GitHub Actions",
    "updated_at": "2020-12-27T23:33:57Z",
    "url": "https://api.github.com/repos/eneko/Blog/issues/13",
    "user": {
      "avatar_url": "https://avatars2.githubusercontent.com/u/32922?v=4",
      "events_url": "https://api.github.com/users/eneko/events{/privacy}",
      "followers_url": "https://api.github.com/users/eneko/followers",
      "following_url": "https://api.github.com/users/eneko/following{/other_user}",
      "gists_url": "https://api.github.com/users/eneko/gists{/gist_id}",
      "gravatar_id": "",
      "html_url": "https://github.com/eneko",
      "id": 32922,
      "login": "eneko",
      "node_id": "MDQ6VXNlcjMyOTIy",
      "organizations_url": "https://api.github.com/users/eneko/orgs",
      "received_events_url": "https://api.github.com/users/eneko/received_events",
      "repos_url": "https://api.github.com/users/eneko/repos",
      "site_admin": false,
      "starred_url": "https://api.github.com/users/eneko/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/eneko/subscriptions",
      "type": "User",
      "url": "https://api.github.com/users/eneko"
    }
}
"""
