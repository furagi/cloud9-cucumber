Cucumber plugin for Cloud9
============================

## Features

* Syntax highlighting (it used syntax highlighters for Gherkin source https://github.com/cucumber/gherkin-syntax-highlighters).
* Indexing project directory.
* Atucompletion for tags and steps.

## Installation

Install pure Cloud9: 

    git clone https://github.com/ajaxorg/cloud9.git
    cd cloud9
    npm install
    bin/cloud9.sh

Install this plugin: 

    npm install cloud9-cucumber
    Add this module to the your config file (for example look at the file config.js.example).

IMPORTANT: install this plugin only after Cloud9 was started at least 1 time.

Open the Tools -> Extension Manager window in Cloud9, and enter the extension path:

    https://github.com/furagi/cloud9-cucumber-ext

## Using

* For selecting cucumber syntax highlighter (in Cloud9): View -> Syntax -> Other -> gherkin
* For autocmlpetion: press Ctrl + Shift + Space or Command-Shift-J for the Mac OS.

Repo of client part of this plugin: https://github.com/furagi/cloud9-cucumber-ext