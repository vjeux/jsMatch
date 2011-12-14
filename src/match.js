
var XRegexp = require('xregexp');

var match = function (str, regex, trim) {
	if (trim || trim === undefined) {
		regex = regex.replace(/[\n\t]/g, '');
	}
	var result = XRegexp(regex, 'ms').exec(str);
	return result && changeResult(result);
}

match.all = function (str, regex, trim) {
	if (trim || trim === undefined) {
		regex = regex.replace(/[\n\t]/g, '');
	}
	var results = [];
	XRegexp.iterate(str, XRegexp(regex, 'ms'), function (result) {
		results.push(changeResult(result));
	});
	return results;
}

var changeResult = function (result) {
	// Check if the result contains named parameters
	var has_named = false;
	for (key in result) {
		if (!key.match(/^([0-9]+|index|input)$/)) {
			has_named = true;
			break;
		}
	}

	if (!has_named) {
		// Only one result, do not need to create an array
		if (result.length === 2) {
			return result[1];
		}

		// Create a clean result array without the first element
		var changed = [];
		for (var i = 1; i < result.length; ++i) {
			changed.push(result[i]);
		}
		return changed;
	}

	// Create a clean object without array elements, 'index' and 'input'
	var changed = {};
	for (key in result) {
		if (!key.match(/^([0-9]+|index|input)$/)) {
			if (key[0] == '_') {
				changed[key.substr(1)] = +result[key];
			} else {
				changed[key] = result[key];
			}
		}
	}
	return changed;
}

module.exports = match;
