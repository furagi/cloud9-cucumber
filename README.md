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

    npm install cucumber-cloud9

IMPORTANT: install this plugin only after Cloud9 was started at least 1 time.

## Using

* For selecting cucumber syntax highlighter (in Cloud9): View -> Syntax -> Other -> gherkin
* For autocmlpetion: press Ctrl + Shift + Space