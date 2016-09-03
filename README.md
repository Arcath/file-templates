# File Templates
[![Build Status](https://travis-ci.org/Arcath/file-templates.svg)](https://travis-ci.org/Arcath/file-templates)

An Atom package for working with file templates.

## Usage

Trigger `File Templates: New Template` from the command palette, give your template a name and hit enter. A copy of your active file is now stored in your template store.

Trigger `File Templates: New File` and select a template from the list, you will now be given a new file with the contents of the template.

Trigger `File Templates: Update Template` and select a template from the list, you will now be given a modal box where you can change the name & grammar of the template. There is also a button to edit the contents of the template which opens the file from the template store in a new tab.

Trigger `File Templates: Delete File` and select a template the list, this template will now be deleted.

## Macros

You can add on of the predefined macros to your template, like this:
* `@timestamp@`: Will be replaced with current timestamp in ISO format (i.e. `2016-09-02T08:32:11.073Z`)
* `@author@`: Will be replaced with your `git config user.name`
* `@email@`: Will be replaced with your `git config user.email`

To make `@author@` and `@email@` work in your project, it must be a GIT repository.

You can add custom macros to your [init file](http://flight-manual.atom.io/hacking-atom/sections/the-init-file/) like so

```coffee
proccess.fileTemplates = {
  macros:
    foo: ->
      return 'new text here'
}
```

## Config

The only config for file templates is the location it saves templates, by default this is `~/.atom/file-templates` but you can set it to anything.

## Planned Features

 - Export/Sharing of templates
 - Insert into current file
