# Bob (Ruby)

There are many readable and valid approaches to solving Bob. I am not interested in guiding people towards a specific solution. What I *am* interested in, is looking at the code they have, responding to signals in that code, using things there to talk about concepts that are relevant (naming, style, conventions, trade-offs), and helping guide them towards a good solution based on the direction they're already taking.

## The Big Conditional

A typical first submission is a single method consisting of a case statement, a series of if/elsif/elses, or a series of explicit returns.

The conditions are generally some combination of string methods and regexes (more or less complicated).

### Round 1: Implementation vs Meaning

I think that the most important nitpick with this code is the idea that there are two different levels of abstraction here:

1. The implementation details (all caps)
2. The meaning (loud, forceful, yelling, or shouting)

One can point to the README and say that there are these ideas about asking and shouting, but the code doesn't make it explicit. As a reader, I have to mentally make the connection between all caps and shouting. If I haven't seen the tests or the README, then it's not certain that I *will* make the connection.

The typical suggestion to make is to extract intention-revealing methods. Hide the implementation details behind names that tell the story.

There are typically two types of push-back:

1. Why bother, it's easy enough to understand.
2. Extracting methods add complexity and code.

For (1) either expand on the idea of the two levels of abstraction and the value of intention-revealing code.

Or perhaps make an appeal to authority: about 20 years ago, Kent Beck published a book called Smalltalk Best Practice Patterns, which has become a classic. There's a pattern named "Intention Revealing Message" which talks about simple cases very similar to this where implementation is straight-forward (one-liner), but focuses on the wrong level of abstraction.

For (2) you can talk about how it adds code, yes, but not a whole lot of complexity in that you often don't need to even read the extra methods, because the `hey` method is so expressive.

If they are very adamantly against extracting methods, then guide them in making that One Big Conditional as clean as possible, and move on.

#### Secondary Feedback

Supporting discussions could be about implementation choices, formatting, and style. String methods vs Regex, explicit returns, indentation, spacing in and around parentheses and braces, use of parentheses, brace placement, the value of consistency, etc. I think it's worth mentioning alternate options so they know that they exist. "Did you consider `String#end_with?`?"

I would not push hard in any direction, except for the thing about 2 spaces for indentation.

A word on regexes: They can be a very nice solution, but they are quite heavy-handed and can quickly become pretty overwhelming. In the hands of experienced users, they can be an appropriate tool for the job, and I've seen some nice solutions that use them effectively.

#### Things to **NOT** discuss

**Do Not Suggest Extract Class**

There's NOTHING in the code at this point that suggests extracting a class for the input (remark, message, utterance, whatever).

If you suggest doing so at this point, you can't lean on any features that you see in the code itself, and it becomes pure speculation "ease of reuse" or "separation of concerns".

Overall I think that all feedback should be grounded in the code itself, not in speculation about future requirements or re-use.

There are several directions that the requirements *could* take, and they would drive the code in very different directions. For example, maybe you need to be able to have a large number of different people responding to the same inputs. Or, perhaps Bob becomes more and more sophisticated as he matures.

The current requirements are ambiguous, and it's impossible to guess. I don't think that pushing towards any sort of future requirement is helpful.

**don't worry about the type of conditional**

I would also suggest refraining from discussing the choice of if/else vs case statement, unless the submitter brings up the question. They're essentially equivalent.

Some people use early returns. While I don't think these are particularly appropriate, I would not nitpick them at the time when someone has a single method with a big conditional. There are bigger fish to fry.

### Round 2: Single Responsibility

They've typically extracted methods. Often they will pass a local variable to the method as a parameter.

I think the most important idea here is to point out how each of the methods take the same parameter, and the method is more concerned with that parameter than with Bob himself. This might be a sign that there's a missing abstraction. Sometimes there is, sometimes there isn't. Sometimes there is, but it's overkill. I think it's important to recognise the signal and make a choice about whether or not to act on it.

If you want an appeal to authority, Martin Fowler's book 'Refactoring' contains a refactoring named "Extract Parameter Object".

An alternate version is when they use an instance variable in order to avoid passing the method. The instinct to _not_ want to pass the same parameter everywhere is good, but storing a fleeting value in an instance value can cause a lot of trouble, and so this isn't the best way to resolve this ache. In particular, Bob is no longer thread-safe. If two people are talking to the same instance of Bob, he will get his answers muddled up.

If the submitter seems experienced, go ahead and point to the fact that the methods are concerned with a very un-Bob like thing, but usually it's easier to let them resubmit and talk about extracting an object when you can point explicitly to the repeated parameter.

#### Secondary Feedback

Supporting nitpicks at this stage is often about naming: They'll often have `shouting` or `yelling` and `question` or `asking`, and then the last one will be `empty`. Empty prattle is, to my mind, discussions about the weather, the local sports team, and Aunt Emma's gall bladder surgery. In other words: this is the same _implementation vs meaning_ discussion that we probably had back in round 1.

Also, this is often where people have predicate methods that are named `isYelling` or `is_yelling` (with or without a question mark). If appropriate, talk about how the `is_` prefix is redundant because of the question-mark.

### Round 3: Completed

At this point, they probably have a reasonable solution, and it's absolutely fine to leave them with some final remarks, and let them get on their way.

If they've extracted a class, they might inherit from String or Struct. Warn about the dangers.

There are often further opportunities to talk about names here, for example `s` vs `string` vs some expressive name.

For example, if I have a generic string in a very small scope, I tend to name it `s`, since this is idiomatic and well-understood. If I find that I'm in a scope that is too large to comfortably live with a single-letter variable, I am not happy with `string` which gives no information aside from the underlying datatype. In that case, I want to find a more expressive name.

If they are using multiple returns in the form of guard clauses I might talk about how this tends to signal edge case / guard clause / want to get the hell out and stop execution.

