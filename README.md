# MVC Todo

For more background on this repository, please consider reading these blog posts:

- https://davedelong.com/blog/tags/a-better-mvc/

## What this sample shows

The point of this sample code is to illustrate the power and flexibility of using `UIViewController` containment and composition as a way to build app UIs.

## What this sample does *not* show

Pretty much everything outside the concept of `UIViewController` containment is beyond the scope of this code. There are bugs and sharp corners with the rest of the app. As an app author, I'm not entirely thrilled with how the Coordinator layer works. However, _that's not the point of the sample_. Feel free to inspect the rest of the code for positive or negative inspiration. Please just understand that those bits are not meant to be representative, and are there only to support the primary goals of the sample.

## The interesting bits

There are a few take-aways you should have from examining this code. In no particular order, they are...

- Observe how there's pretty much nothing inside `AppDelegate.swift`. That's because the object exists to be (shocker) the delegate of the `UIApplication`. Its purpose, then, is to interpret the events and requests the `UIApplication` makes, and forward them on (as necessary) to the interested parties that it knows about.

- Observe how all view controllers are programmatically instantiated. While this is not a requirement to do view controller composition, I personally find it to be much more expressive and useful than instantiating based on identifiers in storyboards.

- There is roughly a one-to-one correspondence between a Coordinator and a "page" or "screen" of information seen in the app. With that in mind, observe how _none of the coordinators_ use "custom" view controllers. By this I mean that all of them have, as their "primary" view controller, a `UIViewController` that is a reusable view controller (ie, a view controller that has not been custom-built for that screen of content)

- Multiple screens have the notion of "an empty state" and "a content-full state". It's pretty standard to see that implemented as hiding views or messing around with alphas or "background views" or what not. Observe in this app how this is implemented instead: A coordinator owns a "ContainerViewController" and just tells it to display different content.

- The lists in this app use the idea of view controllers as cells. When combined with self-sizing tableview cells, this illustrates how you never again have to give a cell a delegate in order to somehow relay functionality from the cell level to the tableview's delegate. Just send it to the cell's view controller instead.

- `ContainerViewController` is a `UIViewController` whose sole purpose is to show another view controller. When the desired "content" of the `ContainerViewController` is changed, it crossfades from the old content to the new content. If you'd like to see this in action, have the `AppRouter` go to an instance of `TestViewController` and play around in there.

- `ScrollingContentViewController` is a `UIViewController` that takes its content view controller and puts it in a `UIScrollView`. The scrollable area of the `UIScrollView` is determined by the auto-layout-determined size of the content view controller. This is really handy for when you're building up a custom container view controller and then you realize you need to make it scroll.

- `MessageViewController` shows a message (text) and can optionally also show an image and an action button. It's handy and I use it all over the place.

## The Extensions

There are a couple of important extensions in this sample:

- `UIView.embedSubview(_:)`: This adds a method to add a subview to a particular `UIView`, but also to set up the constraints to indicate that the new subview should fill its parent and resize with it. My experience with composing view controllers has led me to have lots of "container views": placeholder views for where the content of another `UIViewController` will be embedded. This extension makes that process a bit more straight-forward.

- `UIViewController.embedChild(_:in:)`: This is the "bread and butter" method of simpler view controller composition. When you're creating view controllers programmatically, having this method means that adding a view controller as a child of another and getting it to show up in the UI is a single line of code. The second parameter is a way to indicate which subview of the new parent you want the UI to go in to. If omitted, the child vc's view is embedded inside the parent's `.view`. For a concrete example of this, check out `TestViewController.swift` in the `Debug` folder.

The other extensions are mostly just for convenience. 

## The less-interesting bits

- The `AppRouter` is a bare-bones router. Please don't take it as a good example of anything. Its primary purpose is to emphasize how the concept of "I want to see this thing" is a separate idea of "I need to push/present this particular `UIViewController`"

- `ColorViewController` is a great way to debug that your containers are behaving the way you're expecting.

- There are some subclass of `UITableViewCell` for the various built-in cell types. This is so you can register those classes for cell identifiers on a `UITableView` and actually get the right cell type when you dequeue a cell.

- All the model objects are `structs`. This does mean there's a bit of weirdness when it comes to equality. Equality of model objects is based *exclusively* off the value's `Identifier`. 

## Heads Up

- `UIAlertController` is (ab)used for the list creation and item creation UI. Again, this was a conscious decision in order to keep the sample limited in size. There's also an insidious extension to make a textfield on the shown alert behave like a `UIDatePicker`, because I'm a terrible person who cuts corners in order to get the job done.

- `ListViewController` does not animate changes to the content. Ideally, it should perform a diff of the new content against the old content, and use that diff to perform an animated update. However in the interest of keeping this sample from getting excessively huge, it simply does a `reloadData()` call. This means that swipe-to-delete actions on cells will not animate correctly.

- `ListViewController` requires having all cell content loaded up-front. There are many ways to build a list of items. This is the easiest, as it doesn't require any lazy loading or whatever. However, this approach should probably not be used if you have large lists, and definitely shouldn't be used if you have infinitely long lists. 
