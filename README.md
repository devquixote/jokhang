# Jokhang
Quick POC to see how [Jinja2](http://jinja.pocoo.org/docs/dev/) templating might
be used to help ease the creepypasta pain with deployment artifacts
(cloudformation templates, bash scripts).

The idea is to use a template engine (Jinja 2 in this case) to
centralize stuff that has to be repeated over-and-over.  Right now,
we rely on copy-paste and its a pain when something needs to be
updated across all repositories.

Common code lives in templates and snippets to be extended or
included respectively.  Its then used to generate a cloudformation
template or bash install script.  The common templates and snippets
could be extracted into their own python modules that could be versioned
and managed with pip.  It would be [relatively simple to host our own
python module repository](https://packaging.python.org/self_hosted_repository/).

**Pluses**
* Common code is centralized
* Common code is versioned
* No more copy/paste update problems
* Works for anything (cloudformation JSON, bash install, whatever else comes
along)
* Generates artifacts that are checked in and versioned w/scm
* Team knowledge of language choice (python)

**Minuses**
* Still have to regenerate from templates when you need to modify behavior
* More difficult to grok than a simply-static file

### Components
There are 4 components in Jokhang:

1. The [`jokhang`](bin/jokhang) executable in `bin`
2. Reusable templates/snippets in [`common`](common)
3. A context that defines variables in scope when templates are rendered
(defaults to context.py in the current working directory)
4. A template file to render to standard out

There is one [`context.py`](context.py) file here, and two templates:
[`template.json`](template.json) demonstrating use with cloudformation templates
and snippets/includes and [`install.sh`](install.sh) demonstrating use with
templates.

### Using for cloudformation templates
Output of `./bin/jokhang -t template.json`

```json
{

    "AWSTemplateFormatVersion": "2010-09-09",
    "Description": "Hello Bucket",

    "Resources": {
        "MyBucket": {
            "Type" : "AWS::S3::Bucket",
            "Properties": {
                "BucketName": "hello-bucket"
            }
        }
    }
}
```

### Using for install script reuse
Output of `./bin/jokhang -t install.sh`:

```sh
#!/bin/bash

#######################
# Reusable log function
#######################
function log() {
  msg=${1}

  echo "$(date): ${msg}"
}


#######################
# Block to override in
# children for custom
# install steps
#######################


log "Hello, World!"
```
