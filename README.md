![build status](https://circleci.com/gh/tanakaworld/google-spreadsheets-parser.svg?style=shield&circle-token=0ef40ae186ef9cc9aa40b96d2ad5b6ddeeed272d)

# google-spreadsheets-parser
Simple Google Spreadsheets parser for JavaScript

## Installation

#### NPM
```
npm install google-spreadsheets-parser
```

#### Bower
```
bower install google-spreadsheets-parser
```

#### Manual Download
Download from [here](https://github.com/TanakaYutaro/google-spreadsheets-parser/releases)


## Introduction

1. Create new Google Spreadsheet

  ![intro-1](https://raw.githubusercontent.com/wiki/TanakaYutaro/google-spreadsheets-parser/img/intro-1.png)


2. Publish spreadsheet

  ![intro-2](https://raw.githubusercontent.com/wiki/TanakaYutaro/google-spreadsheets-parser/img/intro-2.png)

  You can show following tables from [published url](https://docs.google.com/spreadsheets/d/1vyPu1EtzU1DvGXfthjrR-blJ8mGe75TL4BFNWtFMm0I/pubhtml)

  ![intro-3](https://raw.githubusercontent.com/wiki/TanakaYutaro/google-spreadsheets-parser/img/intro-3.png)
  
3. Setting

  With Browser, import googleSpreadsheetsParser.js in header
  ```html
  <script type="text/javascript" src="/path/to/googleSpreadsheetsParser.js"></script>
  ```

  Node.js
  ```
  var GoogleSpreadsheetsParser = require 'google-spreadsheets-parser'
  ```
  
4. Get data

  ```javascript
  var gss = new GoogleSpreadsheetsParser(publishedUrl, {sheetTitle: 'Sample', hasTitle: true});
  
  console.log(gss.titles);          // ["ID", "Name", "Age"]
  console.log(gss.contents);        // [Array[3], Array[3], Array[3], Array[3], Array[3]]
  console.log(gss.contents[2][1]);  // Doug
  ```

## Features

* `.titles` : Table titles array in the frst row.
* `.contents` : Table data 2d array in the second row later.
* `.toJSON` : JSON data of contents.

# Demo
[Demo](http://tanakaworld.github.io/google-spreadsheets-parser/demo/)
