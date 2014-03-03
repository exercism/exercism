# Exercism Redesign

## Structure

The top node for this redesign is:

```
./lib/redesign.rb
```

All the supporting app code goes in

```
./lib/redesign/
```

The main structure is:

```
.
├── README.md
├── helpers
│   └── *.rb
├── helpers.rb
├── public
│   └── js
│   └── css
│   └── img
│   └── ico
│       └── favicon.png
├── routes
│   └── *.rb
├── routes.rb
└── views
    └── *.rb
```

If you need supporting code for a file, create a subdirectory with the same name as the file, and stick the code in there.

All the routes inherit from `Core`, so if there is shared setup/config/whatever (for example the helpers), it can go in `./lib/redesign/routes/core.rb`.

