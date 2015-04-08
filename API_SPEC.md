1. [Submissions](#submissions)
    1. [GET /submissions/:id](#get-submissionsid)
    2. [PUT /submissions/:id](#put-submissionsid)
    3. [DELETE /submissions/:id](#delete-submissionsid)
2. [Comments](#comments)
    1. [GET /comments/:id](#get-commentsid)
    2. [POST /submissions/:submission_id/comments/:id](#post-submissionssubmission_idcommentsid)
    3. [PATCH /comments/:id](#patch-commentsid)
    4. [POST /comments/:id/preview](#post-commentsidpreview)

## Submissions
### GET /submissions/:id
Gets submission object

#### Responses
**200**:
```
{
    "_link": "/submissions/d5f76a20f4b847c59d2d9b65f134c9ef",
    "views": "4",
    "solution": "Solution code here...",
    "acceptsFeedback": "true",
    "exercise": {
        "_link": "/exercises/ruby/hamming"
        "name": "Hamming",
        "track": "Ruby"
    },
    "readme": {
        "_link": "/exercises/ruby/hamming/readme"
    },
    "testSuite": {
        "_link": "/exercises/ruby/hamming/test-suite"
    },
    "user": {
        "_link": "/jblack",
        "slug": "jblack"
    },
    "iterations": [{
        "_link": "/submissions/d5f76a20f4b847c59d2d9b65f134c9ef",
        "position": "1",
        "numberOfComments": "0"
    }],
    "likes": [{
        "_link": "/jblack"
    }],
    "comments": [{
        "_link": "/comments/1",
        "bodyRaw": "Is there an advantage to write def `self.compute` instead if def `Hamming.compute`?",
        "body": "Is there an advantage to write def `self.compute` instead if def `Hamming.compute`?",
        "createdAt": "Datetime in some form",
        "user": {
            "_link": "/agreen",
            "username": "agreen"
        }
    }]
}
```

**404**:
```
{
    "code": "404",
    "error": "Not found",
    "message": "We couldn't that submission"
}
```

**500**:
```
{
    "code": "500",
    "error": "Server error",
    "message": "Something went wrong on our servers. Please try again later."
}
```

### PUT /submissions/:id
Updates submission obect

#### Request
```
{
    "acceptsFeedback": "false"
}
```

#### Responses
**200**:
```
{
    "_link": "/submissions/d5f76a20f4b847c59d2d9b65f134c9ef",
    "views": "4",
    "solution": "Solution code here...",
    "acceptsFeedback": "false",
    "exercise": {
        "_link": "/exercises/ruby/hamming"
        "name": "Hamming",
        "track": "Ruby"
    },
    "readme": {
        "_link": "/exercises/ruby/hamming/readme"
    },
    "testSuite": {
        "_link": "/exercises/ruby/hamming/test-suite"
    },
    "user": {
        "_link": "/jblack",
        "slug": "jblack"
    },
    "iterations": [{
        "_link": "/submissions/d5f76a20f4b847c59d2d9b65f134c9ef",
        "position": "1",
        "numberOfComments": "0"
    }],
    "likes": [{
        "_link": "/jblack"
    }],
    "comments": [{
        "_link": "/comments/1",
        "bodyRaw": "Is there an advantage to write def `self.compute` instead if def `Hamming.compute`?",
        "body": "Is there an advantage to write def `self.compute` instead if def `Hamming.compute`?",
        "createdAt": "Datetime in some form",
        "user": {
            "_link": "/agreen",
            "username": "agreen"
        }
    }]
}
```

**401**:
```
{
    "code": "401",
    "error": "Unauthorized",
    "message": "You have to log in."
}
```

**404**:
```
{
    "code": "404",
    "error": "Not found",
    "message": "We couldn't that submission"
}
```

**422**:
```
{
    "code": "400",
    "error": "Bad request",
    "message": "Validation failed."
}
```

**500**:
```
{
    "code": "500",
    "error": "Server error",
    "message": "Something went wrong on our servers. Please try again later."
}
```

### DELETE /submissions/:id
Deletes submission

#### Responses
**204**:

**401**:
```
{
    "code": "401",
    "error": "Unauthorized",
    "message": "You have to log in."
}
```

**404**:
```
{
    "code": "404",
    "error": "Not found",
    "message": "We couldn't that submission"
}
```

**500**:
```
{
    "code": "500",
    "error": "Server error",
    "message": "Something went wrong on our servers. Please try again later."
}
```

## Comments
### GET /comments/:id
Gets comment object

#### Responses
**200**:
```
{
    "_link": "/comments/1",
    "bodyRaw": "Is there an advantage to write def `self.compute` instead if def `Hamming.compute`?",
    "body": "Is there an advantage to write def `self.compute` instead if def `Hamming.compute`?",
    "createdAt": "Datetime in some form",
    "user": {
        "_link": "/agreen",
        "username": "agreen"
    }
}
```

**404**

**500**

### POST /submissions/:submission_id/comments/:id
Creates comment for submission with id `:submission_id`

#### Request
{
    "bodyRaw": "Lorem ipsum dolor sit amet"
}

#### Responses
**201**:
```
{
    "_link": "/comments/2",
    "bodyRaw": "Lorem ipsum dolor sit amet",
    "body": "Lorem ipsum dolor sit amet",
    "createdAt": "Datetime in some form",
    "user": {
        "_link": "/username",
        "username": "username"
    }
}
```

**400**

**401**

**404**

**500**

### PATCH /comments/:id
Updates comment

#### Request
{
    "bodyRaw": "Lorem ipsum dolor sit amet"
}

#### Responses
**200**:
```
{
    "_link": "/comments/2",
    "bodyRaw": "Lorem ipsum dolor sit amet",
    "body": "Lorem ipsum dolor sit amet",
    "createdAt": "Datetime in some form",
    "user": {
        "_link": "/username",
        "username": "username"
    }
}
```

**400**

**401**

**404**

**500**

### POST /comments/:id/preview
Returns a preview of a comment

#### Request
```
{
    "bodyRaw": "Lorem ipsum dolor sit amet"
}
```

#### Response
**200**:
{
    "body": "Lorem ipsum dolor sit amet"
}

**400**

**401**

**500**
