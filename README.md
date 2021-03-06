[jsMatch](http://blog.vjeux.com/) - Wrapper around regexp to make them user friendly
================================

Regexp are your ally when you are working on web spiders, however it is not really convenient to work with. Those small helpers will help you capture elements with more ease!

<table><tr><td><strong>Match</strong>

<pre lang="coffeescript">
match '&lt;a class="abc" id="123"&gt;', 'id="([0-9]+)"'
> '123'



</pre>

</td><td><strong>Default Regexp</strong>

<pre lang="coffeescript">
'&lt;a class="abc" id="123"&gt;'.match /id="([0-9]+)"/
> [ 'id="123"',
>   '123',
>   index: 15,
>   input: '<a class="abc" id="123">' ]
</pre>

</td></tr></table>

* The result is directly in the return value and have the form you expect
  * Capturing one element will give you that element, it won't be wrapper on an array
	* No more duplicate in the array when naming the elements
	* The matched string is removed from the result. It is annoying when dumping the result and who ever used it!?
* Regex is configured properly to fit your needs
	* ms options to be multi-line ready
	* tabs and new lines are removed to let you write readable regex

```
npm install match

node
> var match = require('match');
```

Match
-----

### Prototype

	match(str, regex, trim = true)

Takes

* **str**: the string to execute the search on
* **regex**: the regular expression to match
	* \n and \t are trimmed (not spaces!)
	* Multiple line environment
* **trim**: Optional: false to disable the removal of the \n and \t

Returns

* **null**: is nothing is matched
* **string**: if there's one non-named captured element
* **object**: if there are named captured elements
* **array**: all the captured elements


### Examples
We use Coffeescript for the examples as it supports multiline strings. However it works as well in Javascript.

In all the examples, this is the file variable. 

```coffeescript
file = '''
<div><a class="abc" id="123"><strong>Name</strong></a>

</div>
'''
```

The value is directly returned by the function, no need to do write another line to get the result. false is returned when nothing is matched.

```coffeescript
match file, 'href="([^"]+)"'
# null
```

If you are only capturing one element, it is given as is. No more useless single array.

```coffeescript
match file, 'id="([0-9]+)"'
# 123
```

When naming elements, all the numbered values are removed!

```coffeescript
match file, '<a class="(?<class>[^"]+)" id="(?<class>[^"]+)">'
# { class: '123' }
```

The first element of the resulting array (the matched string) is removed, you now only get what you wanted!

```coffeescript
match '<a class="abc" id="123">', '<a class="([^"]+)" id="([^"]+)">'
# [ 'abc', '123' ]
```

When working on real files, your regexes can be complex. You can use tabs and line breaks to make it more readable.
The . is also capturing \n, this will let you use the [.*? trick](http://www.google.fr/search?q=regex+non+greedy) to magically capture the content you want :)

```coffeescript
# WARNING: Make sure you convert the indentation to TABs when copy & pasting the code!
match file, '''
  <div>
	.*?
	<a class="(?<class>[^"]+)" id="(?<id>[^"]+)">
		(?<name>.*?)
	</a>
	.*?
	</div>'''
# { class: 'abc', id: '123', name: '<strong>Name</strong>' }
```

Match All
---------

match.all is the same as match but captures more than the first.

### Prototype

	match.all(str, regex, trim = true)

Takes

* **str**: the string to execute the search on
* **regex**: the regular expression to match
	* \n and \t are trimmed (not spaces!)
	* Multiple line environment
* **trim**: Optional: false to disable the removal of the \n and \t

Returns

* Array of 
	* **string**: if there's one non-named captured element
	* **object**: if there are named captured elements
	* **array**: all the captured elements

### Examples

```coffeescript
file = '''
<a href="http://blog.vjeux.com/">Vjeux</a>
<a href="http://www.curse.com/">Curse</a>
<a href="http://www.google.com/">Google</a>
'''

match.all file, '<a href="[^"]+">(.*?)</a>'
# [ 'Vjeux', 'Curse', 'Google' ]

match.all file, '<a href="([^"]+)">(.*?)</a>'
#[ [ 'http://blog.vjeux.com/', 'Vjeux' ],
#  [ 'http://www.curse.com/', 'Curse' ],
#  [ 'http://www.google.com/', 'Google' ] ]

match.all file, '<a href="(?<link>[^"]+)">(?<name>.*?)</a>'
#[ { link: 'http://blog.vjeux.com/', name: 'Vjeux' },
#  { link: 'http://www.curse.com/', name: 'Curse' },
#  { link: 'http://www.google.com/', name: 'Google' } ]
```
