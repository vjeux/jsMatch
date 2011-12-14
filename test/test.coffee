
match = require '../src/match.js'



console.log '-- Match --'

file = '''
<div><a class="abc" id="123"><strong>Name</strong></a>

</div>
'''

console.log match file, 'href="([^"]+)"'
# null

console.log match file, 'id="([0-9]+)"'
# 123

console.log match file, '<a class="(?<class>[^"]+)" id="(?<class>[^"]+)">'
# { class: '123' }

console.log match '<a class="abc" id="123">', '<a class="([^"]+)" id="([^"]+)">'
# [ 'abc', '123' ]

console.log match file, '''
	<div>
	.*?
	<a class="(?<class>[^"]+)" id="(?<id>[^"]+)">
		(?<name>.*?)
	</a>
	.*?
	</div>'''
# { class: 'abc', id: '123', name: '<strong>Name</strong>' }



console.log '\n-- Match All --'


file = '''
<a href="http://blog.vjeux.com/">Vjeux</a>
<a href="http://www.curse.com/">Curse</a>
<a href="http://www.google.com/">Google</a>
'''

console.log match.all file, '<a href="[^"]+">(.*?)</a>'
# [ 'Vjeux', 'Curse', 'Google' ]

console.log match.all file, '<a href="([^"]+)">(.*?)</a>'
#[ [ 'http://blog.vjeux.com/', 'Vjeux' ],
#  [ 'http://www.curse.com/', 'Curse' ],
#  [ 'http://www.google.com/', 'Google' ] ]

console.log match.all file, '<a href="(?<link>[^"]+)">(?<name>.*?)</a>'
#[ { link: 'http://blog.vjeux.com/', name: 'Vjeux' },
#  { link: 'http://www.curse.com/', name: 'Curse' },
#  { link: 'http://www.google.com/', name: 'Google' } ]
