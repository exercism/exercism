# Writing Language Track Documentation

If someone is going to use Exercism to ramp up in a new programming language, they are going to need to get their local environment set up so that they can solve the problems in that language.

At the very minimum, people will need to know:

0. how to install the programming language on their machine
0. how to install any necessary dependencies
0. how to run the tests

We also like to add some other goodies, for example:

* **a short introduction about the language**. This helps entice people to start learning it. This should not go into too much detail, as it can link to more in-depth information. It should give a high-level idea of what kind of language it is, and what type of problems it's used to solve, or where it is typically used. The keyword here is *enticing*. We don't need to tell people everything, just get them curious enough to want to try it, or to read more about it.
* **where to learn the basics**. If you're learning the language from scratch, what are some good resources that teach you about the language. Tutorials, websites, books, videos—we're looking for things that people would use to orient themselves and get a good introduction. This is often what you'd use *before* doing Exercism.
* **references and resources**. As people work the exercises on Exercism, they'll probably want reference materials. Where can they find the documentation for the standard library? Are there any useful tools, such as linters or style guides? Are there forums or channels where people can meet other people and ask for help?

This documentation gets included on the website on the page for each language track. You can browse the track documentation starting from [the main language page](http://exercism.io/languages).

## File Structure

Everything that is specific to a particular programming language lives in the repository for that particular language track, making it easy for the people who maintain the track to manage it.

Since all the language track documentation gets included on the site, it needs to be standardized. We've settled on the following file structure:

```bash
.
└── docs/
    ├── img/
    │   ├── image-one.svg
    │   ├── image-two.png
    │   └── image-three.jpg
    ├── ABOUT.md
    ├── INSTALLATION.md
    ├── LEARNING.md
    ├── RESOURCES.md
    └── TESTS.md
```

The mapping of topics to filenames goes like this:

* `INSTALLATION.md` - how to install the language and any dependencies
* `TESTS.md` - how to run the tests
* `ABOUT.md` - short, enticing introduction to the language
* `LEARNING.md` - where to get an introduction to the language if you're learning it for the first time
* `RESOURCES.md` - references, tools, etc.

Any images referenced in the markdown files need to live within the `docs/img` directory. If the directory doesn't exist, you can create it when you need it.

Use the relative path to this directory when referring to the images in the markdown. E.g., if you have an image named `docs/img/dropdown.png`, then you would reference it with:

```
![](/docs/img/dropdown.png)
```

There are a number of variations on markdown image syntax. [This guide](https://daringfireball.net/projects/markdown/syntax#img) has more details.

This will show up correctly when you browse the documentation within the repository on GitHub, and also when it is included on the Exercism website, where we rewrite the paths to refer to the correct API endpoint that serves the images.

