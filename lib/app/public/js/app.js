/*!
 * jQuery JavaScript Library v1.10.2
 * http://jquery.com/
 *
 * Includes Sizzle.js
 * http://sizzlejs.com/
 *
 * Copyright 2005, 2013 jQuery Foundation, Inc. and other contributors
 * Released under the MIT license
 * http://jquery.org/license
 *
 * Date: 2013-07-03T13:48Z
 */
(function( window, undefined ) {

// Can't do this because several apps including ASP.NET trace
// the stack via arguments.caller.callee and Firefox dies if
// you try to trace through "use strict" call chains. (#13335)
// Support: Firefox 18+
//"use strict";
var
	// The deferred used on DOM ready
	readyList,

	// A central reference to the root jQuery(document)
	rootjQuery,

	// Support: IE<10
	// For `typeof xmlNode.method` instead of `xmlNode.method !== undefined`
	core_strundefined = typeof undefined,

	// Use the correct document accordingly with window argument (sandbox)
	location = window.location,
	document = window.document,
	docElem = document.documentElement,

	// Map over jQuery in case of overwrite
	_jQuery = window.jQuery,

	// Map over the $ in case of overwrite
	_$ = window.$,

	// [[Class]] -> type pairs
	class2type = {},

	// List of deleted data cache ids, so we can reuse them
	core_deletedIds = [],

	core_version = "1.10.2",

	// Save a reference to some core methods
	core_concat = core_deletedIds.concat,
	core_push = core_deletedIds.push,
	core_slice = core_deletedIds.slice,
	core_indexOf = core_deletedIds.indexOf,
	core_toString = class2type.toString,
	core_hasOwn = class2type.hasOwnProperty,
	core_trim = core_version.trim,

	// Define a local copy of jQuery
	jQuery = function( selector, context ) {
		// The jQuery object is actually just the init constructor 'enhanced'
		return new jQuery.fn.init( selector, context, rootjQuery );
	},

	// Used for matching numbers
	core_pnum = /[+-]?(?:\d*\.|)\d+(?:[eE][+-]?\d+|)/.source,

	// Used for splitting on whitespace
	core_rnotwhite = /\S+/g,

	// Make sure we trim BOM and NBSP (here's looking at you, Safari 5.0 and IE)
	rtrim = /^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g,

	// A simple way to check for HTML strings
	// Prioritize #id over <tag> to avoid XSS via location.hash (#9521)
	// Strict HTML recognition (#11290: must start with <)
	rquickExpr = /^(?:\s*(<[\w\W]+>)[^>]*|#([\w-]*))$/,

	// Match a standalone tag
	rsingleTag = /^<(\w+)\s*\/?>(?:<\/\1>|)$/,

	// JSON RegExp
	rvalidchars = /^[\],:{}\s]*$/,
	rvalidbraces = /(?:^|:|,)(?:\s*\[)+/g,
	rvalidescape = /\\(?:["\\\/bfnrt]|u[\da-fA-F]{4})/g,
	rvalidtokens = /"[^"\\\r\n]*"|true|false|null|-?(?:\d+\.|)\d+(?:[eE][+-]?\d+|)/g,

	// Matches dashed string for camelizing
	rmsPrefix = /^-ms-/,
	rdashAlpha = /-([\da-z])/gi,

	// Used by jQuery.camelCase as callback to replace()
	fcamelCase = function( all, letter ) {
		return letter.toUpperCase();
	},

	// The ready event handler
	completed = function( event ) {

		// readyState === "complete" is good enough for us to call the dom ready in oldIE
		if ( document.addEventListener || event.type === "load" || document.readyState === "complete" ) {
			detach();
			jQuery.ready();
		}
	},
	// Clean-up method for dom ready events
	detach = function() {
		if ( document.addEventListener ) {
			document.removeEventListener( "DOMContentLoaded", completed, false );
			window.removeEventListener( "load", completed, false );

		} else {
			document.detachEvent( "onreadystatechange", completed );
			window.detachEvent( "onload", completed );
		}
	};

jQuery.fn = jQuery.prototype = {
	// The current version of jQuery being used
	jquery: core_version,

	constructor: jQuery,
	init: function( selector, context, rootjQuery ) {
		var match, elem;

		// HANDLE: $(""), $(null), $(undefined), $(false)
		if ( !selector ) {
			return this;
		}

		// Handle HTML strings
		if ( typeof selector === "string" ) {
			if ( selector.charAt(0) === "<" && selector.charAt( selector.length - 1 ) === ">" && selector.length >= 3 ) {
				// Assume that strings that start and end with <> are HTML and skip the regex check
				match = [ null, selector, null ];

			} else {
				match = rquickExpr.exec( selector );
			}

			// Match html or make sure no context is specified for #id
			if ( match && (match[1] || !context) ) {

				// HANDLE: $(html) -> $(array)
				if ( match[1] ) {
					context = context instanceof jQuery ? context[0] : context;

					// scripts is true for back-compat
					jQuery.merge( this, jQuery.parseHTML(
						match[1],
						context && context.nodeType ? context.ownerDocument || context : document,
						true
					) );

					// HANDLE: $(html, props)
					if ( rsingleTag.test( match[1] ) && jQuery.isPlainObject( context ) ) {
						for ( match in context ) {
							// Properties of context are called as methods if possible
							if ( jQuery.isFunction( this[ match ] ) ) {
								this[ match ]( context[ match ] );

							// ...and otherwise set as attributes
							} else {
								this.attr( match, context[ match ] );
							}
						}
					}

					return this;

				// HANDLE: $(#id)
				} else {
					elem = document.getElementById( match[2] );

					// Check parentNode to catch when Blackberry 4.6 returns
					// nodes that are no longer in the document #6963
					if ( elem && elem.parentNode ) {
						// Handle the case where IE and Opera return items
						// by name instead of ID
						if ( elem.id !== match[2] ) {
							return rootjQuery.find( selector );
						}

						// Otherwise, we inject the element directly into the jQuery object
						this.length = 1;
						this[0] = elem;
					}

					this.context = document;
					this.selector = selector;
					return this;
				}

			// HANDLE: $(expr, $(...))
			} else if ( !context || context.jquery ) {
				return ( context || rootjQuery ).find( selector );

			// HANDLE: $(expr, context)
			// (which is just equivalent to: $(context).find(expr)
			} else {
				return this.constructor( context ).find( selector );
			}

		// HANDLE: $(DOMElement)
		} else if ( selector.nodeType ) {
			this.context = this[0] = selector;
			this.length = 1;
			return this;

		// HANDLE: $(function)
		// Shortcut for document ready
		} else if ( jQuery.isFunction( selector ) ) {
			return rootjQuery.ready( selector );
		}

		if ( selector.selector !== undefined ) {
			this.selector = selector.selector;
			this.context = selector.context;
		}

		return jQuery.makeArray( selector, this );
	},

	// Start with an empty selector
	selector: "",

	// The default length of a jQuery object is 0
	length: 0,

	toArray: function() {
		return core_slice.call( this );
	},

	// Get the Nth element in the matched element set OR
	// Get the whole matched element set as a clean array
	get: function( num ) {
		return num == null ?

			// Return a 'clean' array
			this.toArray() :

			// Return just the object
			( num < 0 ? this[ this.length + num ] : this[ num ] );
	},

	// Take an array of elements and push it onto the stack
	// (returning the new matched element set)
	pushStack: function( elems ) {

		// Build a new jQuery matched element set
		var ret = jQuery.merge( this.constructor(), elems );

		// Add the old object onto the stack (as a reference)
		ret.prevObject = this;
		ret.context = this.context;

		// Return the newly-formed element set
		return ret;
	},

	// Execute a callback for every element in the matched set.
	// (You can seed the arguments with an array of args, but this is
	// only used internally.)
	each: function( callback, args ) {
		return jQuery.each( this, callback, args );
	},

	ready: function( fn ) {
		// Add the callback
		jQuery.ready.promise().done( fn );

		return this;
	},

	slice: function() {
		return this.pushStack( core_slice.apply( this, arguments ) );
	},

	first: function() {
		return this.eq( 0 );
	},

	last: function() {
		return this.eq( -1 );
	},

	eq: function( i ) {
		var len = this.length,
			j = +i + ( i < 0 ? len : 0 );
		return this.pushStack( j >= 0 && j < len ? [ this[j] ] : [] );
	},

	map: function( callback ) {
		return this.pushStack( jQuery.map(this, function( elem, i ) {
			return callback.call( elem, i, elem );
		}));
	},

	end: function() {
		return this.prevObject || this.constructor(null);
	},

	// For internal use only.
	// Behaves like an Array's method, not like a jQuery method.
	push: core_push,
	sort: [].sort,
	splice: [].splice
};

// Give the init function the jQuery prototype for later instantiation
jQuery.fn.init.prototype = jQuery.fn;

jQuery.extend = jQuery.fn.extend = function() {
	var src, copyIsArray, copy, name, options, clone,
		target = arguments[0] || {},
		i = 1,
		length = arguments.length,
		deep = false;

	// Handle a deep copy situation
	if ( typeof target === "boolean" ) {
		deep = target;
		target = arguments[1] || {};
		// skip the boolean and the target
		i = 2;
	}

	// Handle case when target is a string or something (possible in deep copy)
	if ( typeof target !== "object" && !jQuery.isFunction(target) ) {
		target = {};
	}

	// extend jQuery itself if only one argument is passed
	if ( length === i ) {
		target = this;
		--i;
	}

	for ( ; i < length; i++ ) {
		// Only deal with non-null/undefined values
		if ( (options = arguments[ i ]) != null ) {
			// Extend the base object
			for ( name in options ) {
				src = target[ name ];
				copy = options[ name ];

				// Prevent never-ending loop
				if ( target === copy ) {
					continue;
				}

				// Recurse if we're merging plain objects or arrays
				if ( deep && copy && ( jQuery.isPlainObject(copy) || (copyIsArray = jQuery.isArray(copy)) ) ) {
					if ( copyIsArray ) {
						copyIsArray = false;
						clone = src && jQuery.isArray(src) ? src : [];

					} else {
						clone = src && jQuery.isPlainObject(src) ? src : {};
					}

					// Never move original objects, clone them
					target[ name ] = jQuery.extend( deep, clone, copy );

				// Don't bring in undefined values
				} else if ( copy !== undefined ) {
					target[ name ] = copy;
				}
			}
		}
	}

	// Return the modified object
	return target;
};

jQuery.extend({
	// Unique for each copy of jQuery on the page
	// Non-digits removed to match rinlinejQuery
	expando: "jQuery" + ( core_version + Math.random() ).replace( /\D/g, "" ),

	noConflict: function( deep ) {
		if ( window.$ === jQuery ) {
			window.$ = _$;
		}

		if ( deep && window.jQuery === jQuery ) {
			window.jQuery = _jQuery;
		}

		return jQuery;
	},

	// Is the DOM ready to be used? Set to true once it occurs.
	isReady: false,

	// A counter to track how many items to wait for before
	// the ready event fires. See #6781
	readyWait: 1,

	// Hold (or release) the ready event
	holdReady: function( hold ) {
		if ( hold ) {
			jQuery.readyWait++;
		} else {
			jQuery.ready( true );
		}
	},

	// Handle when the DOM is ready
	ready: function( wait ) {

		// Abort if there are pending holds or we're already ready
		if ( wait === true ? --jQuery.readyWait : jQuery.isReady ) {
			return;
		}

		// Make sure body exists, at least, in case IE gets a little overzealous (ticket #5443).
		if ( !document.body ) {
			return setTimeout( jQuery.ready );
		}

		// Remember that the DOM is ready
		jQuery.isReady = true;

		// If a normal DOM Ready event fired, decrement, and wait if need be
		if ( wait !== true && --jQuery.readyWait > 0 ) {
			return;
		}

		// If there are functions bound, to execute
		readyList.resolveWith( document, [ jQuery ] );

		// Trigger any bound ready events
		if ( jQuery.fn.trigger ) {
			jQuery( document ).trigger("ready").off("ready");
		}
	},

	// See test/unit/core.js for details concerning isFunction.
	// Since version 1.3, DOM methods and functions like alert
	// aren't supported. They return false on IE (#2968).
	isFunction: function( obj ) {
		return jQuery.type(obj) === "function";
	},

	isArray: Array.isArray || function( obj ) {
		return jQuery.type(obj) === "array";
	},

	isWindow: function( obj ) {
		/* jshint eqeqeq: false */
		return obj != null && obj == obj.window;
	},

	isNumeric: function( obj ) {
		return !isNaN( parseFloat(obj) ) && isFinite( obj );
	},

	type: function( obj ) {
		if ( obj == null ) {
			return String( obj );
		}
		return typeof obj === "object" || typeof obj === "function" ?
			class2type[ core_toString.call(obj) ] || "object" :
			typeof obj;
	},

	isPlainObject: function( obj ) {
		var key;

		// Must be an Object.
		// Because of IE, we also have to check the presence of the constructor property.
		// Make sure that DOM nodes and window objects don't pass through, as well
		if ( !obj || jQuery.type(obj) !== "object" || obj.nodeType || jQuery.isWindow( obj ) ) {
			return false;
		}

		try {
			// Not own constructor property must be Object
			if ( obj.constructor &&
				!core_hasOwn.call(obj, "constructor") &&
				!core_hasOwn.call(obj.constructor.prototype, "isPrototypeOf") ) {
				return false;
			}
		} catch ( e ) {
			// IE8,9 Will throw exceptions on certain host objects #9897
			return false;
		}

		// Support: IE<9
		// Handle iteration over inherited properties before own properties.
		if ( jQuery.support.ownLast ) {
			for ( key in obj ) {
				return core_hasOwn.call( obj, key );
			}
		}

		// Own properties are enumerated firstly, so to speed up,
		// if last one is own, then all properties are own.
		for ( key in obj ) {}

		return key === undefined || core_hasOwn.call( obj, key );
	},

	isEmptyObject: function( obj ) {
		var name;
		for ( name in obj ) {
			return false;
		}
		return true;
	},

	error: function( msg ) {
		throw new Error( msg );
	},

	// data: string of html
	// context (optional): If specified, the fragment will be created in this context, defaults to document
	// keepScripts (optional): If true, will include scripts passed in the html string
	parseHTML: function( data, context, keepScripts ) {
		if ( !data || typeof data !== "string" ) {
			return null;
		}
		if ( typeof context === "boolean" ) {
			keepScripts = context;
			context = false;
		}
		context = context || document;

		var parsed = rsingleTag.exec( data ),
			scripts = !keepScripts && [];

		// Single tag
		if ( parsed ) {
			return [ context.createElement( parsed[1] ) ];
		}

		parsed = jQuery.buildFragment( [ data ], context, scripts );
		if ( scripts ) {
			jQuery( scripts ).remove();
		}
		return jQuery.merge( [], parsed.childNodes );
	},

	parseJSON: function( data ) {
		// Attempt to parse using the native JSON parser first
		if ( window.JSON && window.JSON.parse ) {
			return window.JSON.parse( data );
		}

		if ( data === null ) {
			return data;
		}

		if ( typeof data === "string" ) {

			// Make sure leading/trailing whitespace is removed (IE can't handle it)
			data = jQuery.trim( data );

			if ( data ) {
				// Make sure the incoming data is actual JSON
				// Logic borrowed from http://json.org/json2.js
				if ( rvalidchars.test( data.replace( rvalidescape, "@" )
					.replace( rvalidtokens, "]" )
					.replace( rvalidbraces, "")) ) {

					return ( new Function( "return " + data ) )();
				}
			}
		}

		jQuery.error( "Invalid JSON: " + data );
	},

	// Cross-browser xml parsing
	parseXML: function( data ) {
		var xml, tmp;
		if ( !data || typeof data !== "string" ) {
			return null;
		}
		try {
			if ( window.DOMParser ) { // Standard
				tmp = new DOMParser();
				xml = tmp.parseFromString( data , "text/xml" );
			} else { // IE
				xml = new ActiveXObject( "Microsoft.XMLDOM" );
				xml.async = "false";
				xml.loadXML( data );
			}
		} catch( e ) {
			xml = undefined;
		}
		if ( !xml || !xml.documentElement || xml.getElementsByTagName( "parsererror" ).length ) {
			jQuery.error( "Invalid XML: " + data );
		}
		return xml;
	},

	noop: function() {},

	// Evaluates a script in a global context
	// Workarounds based on findings by Jim Driscoll
	// http://weblogs.java.net/blog/driscoll/archive/2009/09/08/eval-javascript-global-context
	globalEval: function( data ) {
		if ( data && jQuery.trim( data ) ) {
			// We use execScript on Internet Explorer
			// We use an anonymous function so that context is window
			// rather than jQuery in Firefox
			( window.execScript || function( data ) {
				window[ "eval" ].call( window, data );
			} )( data );
		}
	},

	// Convert dashed to camelCase; used by the css and data modules
	// Microsoft forgot to hump their vendor prefix (#9572)
	camelCase: function( string ) {
		return string.replace( rmsPrefix, "ms-" ).replace( rdashAlpha, fcamelCase );
	},

	nodeName: function( elem, name ) {
		return elem.nodeName && elem.nodeName.toLowerCase() === name.toLowerCase();
	},

	// args is for internal usage only
	each: function( obj, callback, args ) {
		var value,
			i = 0,
			length = obj.length,
			isArray = isArraylike( obj );

		if ( args ) {
			if ( isArray ) {
				for ( ; i < length; i++ ) {
					value = callback.apply( obj[ i ], args );

					if ( value === false ) {
						break;
					}
				}
			} else {
				for ( i in obj ) {
					value = callback.apply( obj[ i ], args );

					if ( value === false ) {
						break;
					}
				}
			}

		// A special, fast, case for the most common use of each
		} else {
			if ( isArray ) {
				for ( ; i < length; i++ ) {
					value = callback.call( obj[ i ], i, obj[ i ] );

					if ( value === false ) {
						break;
					}
				}
			} else {
				for ( i in obj ) {
					value = callback.call( obj[ i ], i, obj[ i ] );

					if ( value === false ) {
						break;
					}
				}
			}
		}

		return obj;
	},

	// Use native String.trim function wherever possible
	trim: core_trim && !core_trim.call("\uFEFF\xA0") ?
		function( text ) {
			return text == null ?
				"" :
				core_trim.call( text );
		} :

		// Otherwise use our own trimming functionality
		function( text ) {
			return text == null ?
				"" :
				( text + "" ).replace( rtrim, "" );
		},

	// results is for internal usage only
	makeArray: function( arr, results ) {
		var ret = results || [];

		if ( arr != null ) {
			if ( isArraylike( Object(arr) ) ) {
				jQuery.merge( ret,
					typeof arr === "string" ?
					[ arr ] : arr
				);
			} else {
				core_push.call( ret, arr );
			}
		}

		return ret;
	},

	inArray: function( elem, arr, i ) {
		var len;

		if ( arr ) {
			if ( core_indexOf ) {
				return core_indexOf.call( arr, elem, i );
			}

			len = arr.length;
			i = i ? i < 0 ? Math.max( 0, len + i ) : i : 0;

			for ( ; i < len; i++ ) {
				// Skip accessing in sparse arrays
				if ( i in arr && arr[ i ] === elem ) {
					return i;
				}
			}
		}

		return -1;
	},

	merge: function( first, second ) {
		var l = second.length,
			i = first.length,
			j = 0;

		if ( typeof l === "number" ) {
			for ( ; j < l; j++ ) {
				first[ i++ ] = second[ j ];
			}
		} else {
			while ( second[j] !== undefined ) {
				first[ i++ ] = second[ j++ ];
			}
		}

		first.length = i;

		return first;
	},

	grep: function( elems, callback, inv ) {
		var retVal,
			ret = [],
			i = 0,
			length = elems.length;
		inv = !!inv;

		// Go through the array, only saving the items
		// that pass the validator function
		for ( ; i < length; i++ ) {
			retVal = !!callback( elems[ i ], i );
			if ( inv !== retVal ) {
				ret.push( elems[ i ] );
			}
		}

		return ret;
	},

	// arg is for internal usage only
	map: function( elems, callback, arg ) {
		var value,
			i = 0,
			length = elems.length,
			isArray = isArraylike( elems ),
			ret = [];

		// Go through the array, translating each of the items to their
		if ( isArray ) {
			for ( ; i < length; i++ ) {
				value = callback( elems[ i ], i, arg );

				if ( value != null ) {
					ret[ ret.length ] = value;
				}
			}

		// Go through every key on the object,
		} else {
			for ( i in elems ) {
				value = callback( elems[ i ], i, arg );

				if ( value != null ) {
					ret[ ret.length ] = value;
				}
			}
		}

		// Flatten any nested arrays
		return core_concat.apply( [], ret );
	},

	// A global GUID counter for objects
	guid: 1,

	// Bind a function to a context, optionally partially applying any
	// arguments.
	proxy: function( fn, context ) {
		var args, proxy, tmp;

		if ( typeof context === "string" ) {
			tmp = fn[ context ];
			context = fn;
			fn = tmp;
		}

		// Quick check to determine if target is callable, in the spec
		// this throws a TypeError, but we will just return undefined.
		if ( !jQuery.isFunction( fn ) ) {
			return undefined;
		}

		// Simulated bind
		args = core_slice.call( arguments, 2 );
		proxy = function() {
			return fn.apply( context || this, args.concat( core_slice.call( arguments ) ) );
		};

		// Set the guid of unique handler to the same of original handler, so it can be removed
		proxy.guid = fn.guid = fn.guid || jQuery.guid++;

		return proxy;
	},

	// Multifunctional method to get and set values of a collection
	// The value/s can optionally be executed if it's a function
	access: function( elems, fn, key, value, chainable, emptyGet, raw ) {
		var i = 0,
			length = elems.length,
			bulk = key == null;

		// Sets many values
		if ( jQuery.type( key ) === "object" ) {
			chainable = true;
			for ( i in key ) {
				jQuery.access( elems, fn, i, key[i], true, emptyGet, raw );
			}

		// Sets one value
		} else if ( value !== undefined ) {
			chainable = true;

			if ( !jQuery.isFunction( value ) ) {
				raw = true;
			}

			if ( bulk ) {
				// Bulk operations run against the entire set
				if ( raw ) {
					fn.call( elems, value );
					fn = null;

				// ...except when executing function values
				} else {
					bulk = fn;
					fn = function( elem, key, value ) {
						return bulk.call( jQuery( elem ), value );
					};
				}
			}

			if ( fn ) {
				for ( ; i < length; i++ ) {
					fn( elems[i], key, raw ? value : value.call( elems[i], i, fn( elems[i], key ) ) );
				}
			}
		}

		return chainable ?
			elems :

			// Gets
			bulk ?
				fn.call( elems ) :
				length ? fn( elems[0], key ) : emptyGet;
	},

	now: function() {
		return ( new Date() ).getTime();
	},

	// A method for quickly swapping in/out CSS properties to get correct calculations.
	// Note: this method belongs to the css module but it's needed here for the support module.
	// If support gets modularized, this method should be moved back to the css module.
	swap: function( elem, options, callback, args ) {
		var ret, name,
			old = {};

		// Remember the old values, and insert the new ones
		for ( name in options ) {
			old[ name ] = elem.style[ name ];
			elem.style[ name ] = options[ name ];
		}

		ret = callback.apply( elem, args || [] );

		// Revert the old values
		for ( name in options ) {
			elem.style[ name ] = old[ name ];
		}

		return ret;
	}
});

jQuery.ready.promise = function( obj ) {
	if ( !readyList ) {

		readyList = jQuery.Deferred();

		// Catch cases where $(document).ready() is called after the browser event has already occurred.
		// we once tried to use readyState "interactive" here, but it caused issues like the one
		// discovered by ChrisS here: http://bugs.jquery.com/ticket/12282#comment:15
		if ( document.readyState === "complete" ) {
			// Handle it asynchronously to allow scripts the opportunity to delay ready
			setTimeout( jQuery.ready );

		// Standards-based browsers support DOMContentLoaded
		} else if ( document.addEventListener ) {
			// Use the handy event callback
			document.addEventListener( "DOMContentLoaded", completed, false );

			// A fallback to window.onload, that will always work
			window.addEventListener( "load", completed, false );

		// If IE event model is used
		} else {
			// Ensure firing before onload, maybe late but safe also for iframes
			document.attachEvent( "onreadystatechange", completed );

			// A fallback to window.onload, that will always work
			window.attachEvent( "onload", completed );

			// If IE and not a frame
			// continually check to see if the document is ready
			var top = false;

			try {
				top = window.frameElement == null && document.documentElement;
			} catch(e) {}

			if ( top && top.doScroll ) {
				(function doScrollCheck() {
					if ( !jQuery.isReady ) {

						try {
							// Use the trick by Diego Perini
							// http://javascript.nwbox.com/IEContentLoaded/
							top.doScroll("left");
						} catch(e) {
							return setTimeout( doScrollCheck, 50 );
						}

						// detach all dom ready events
						detach();

						// and execute any waiting functions
						jQuery.ready();
					}
				})();
			}
		}
	}
	return readyList.promise( obj );
};

// Populate the class2type map
jQuery.each("Boolean Number String Function Array Date RegExp Object Error".split(" "), function(i, name) {
	class2type[ "[object " + name + "]" ] = name.toLowerCase();
});

function isArraylike( obj ) {
	var length = obj.length,
		type = jQuery.type( obj );

	if ( jQuery.isWindow( obj ) ) {
		return false;
	}

	if ( obj.nodeType === 1 && length ) {
		return true;
	}

	return type === "array" || type !== "function" &&
		( length === 0 ||
		typeof length === "number" && length > 0 && ( length - 1 ) in obj );
}

// All jQuery objects should point back to these
rootjQuery = jQuery(document);
/*!
 * Sizzle CSS Selector Engine v1.10.2
 * http://sizzlejs.com/
 *
 * Copyright 2013 jQuery Foundation, Inc. and other contributors
 * Released under the MIT license
 * http://jquery.org/license
 *
 * Date: 2013-07-03
 */
(function( window, undefined ) {

var i,
	support,
	cachedruns,
	Expr,
	getText,
	isXML,
	compile,
	outermostContext,
	sortInput,

	// Local document vars
	setDocument,
	document,
	docElem,
	documentIsHTML,
	rbuggyQSA,
	rbuggyMatches,
	matches,
	contains,

	// Instance-specific data
	expando = "sizzle" + -(new Date()),
	preferredDoc = window.document,
	dirruns = 0,
	done = 0,
	classCache = createCache(),
	tokenCache = createCache(),
	compilerCache = createCache(),
	hasDuplicate = false,
	sortOrder = function( a, b ) {
		if ( a === b ) {
			hasDuplicate = true;
			return 0;
		}
		return 0;
	},

	// General-purpose constants
	strundefined = typeof undefined,
	MAX_NEGATIVE = 1 << 31,

	// Instance methods
	hasOwn = ({}).hasOwnProperty,
	arr = [],
	pop = arr.pop,
	push_native = arr.push,
	push = arr.push,
	slice = arr.slice,
	// Use a stripped-down indexOf if we can't use a native one
	indexOf = arr.indexOf || function( elem ) {
		var i = 0,
			len = this.length;
		for ( ; i < len; i++ ) {
			if ( this[i] === elem ) {
				return i;
			}
		}
		return -1;
	},

	booleans = "checked|selected|async|autofocus|autoplay|controls|defer|disabled|hidden|ismap|loop|multiple|open|readonly|required|scoped",

	// Regular expressions

	// Whitespace characters http://www.w3.org/TR/css3-selectors/#whitespace
	whitespace = "[\\x20\\t\\r\\n\\f]",
	// http://www.w3.org/TR/css3-syntax/#characters
	characterEncoding = "(?:\\\\.|[\\w-]|[^\\x00-\\xa0])+",

	// Loosely modeled on CSS identifier characters
	// An unquoted value should be a CSS identifier http://www.w3.org/TR/css3-selectors/#attribute-selectors
	// Proper syntax: http://www.w3.org/TR/CSS21/syndata.html#value-def-identifier
	identifier = characterEncoding.replace( "w", "w#" ),

	// Acceptable operators http://www.w3.org/TR/selectors/#attribute-selectors
	attributes = "\\[" + whitespace + "*(" + characterEncoding + ")" + whitespace +
		"*(?:([*^$|!~]?=)" + whitespace + "*(?:(['\"])((?:\\\\.|[^\\\\])*?)\\3|(" + identifier + ")|)|)" + whitespace + "*\\]",

	// Prefer arguments quoted,
	//   then not containing pseudos/brackets,
	//   then attribute selectors/non-parenthetical expressions,
	//   then anything else
	// These preferences are here to reduce the number of selectors
	//   needing tokenize in the PSEUDO preFilter
	pseudos = ":(" + characterEncoding + ")(?:\\(((['\"])((?:\\\\.|[^\\\\])*?)\\3|((?:\\\\.|[^\\\\()[\\]]|" + attributes.replace( 3, 8 ) + ")*)|.*)\\)|)",

	// Leading and non-escaped trailing whitespace, capturing some non-whitespace characters preceding the latter
	rtrim = new RegExp( "^" + whitespace + "+|((?:^|[^\\\\])(?:\\\\.)*)" + whitespace + "+$", "g" ),

	rcomma = new RegExp( "^" + whitespace + "*," + whitespace + "*" ),
	rcombinators = new RegExp( "^" + whitespace + "*([>+~]|" + whitespace + ")" + whitespace + "*" ),

	rsibling = new RegExp( whitespace + "*[+~]" ),
	rattributeQuotes = new RegExp( "=" + whitespace + "*([^\\]'\"]*)" + whitespace + "*\\]", "g" ),

	rpseudo = new RegExp( pseudos ),
	ridentifier = new RegExp( "^" + identifier + "$" ),

	matchExpr = {
		"ID": new RegExp( "^#(" + characterEncoding + ")" ),
		"CLASS": new RegExp( "^\\.(" + characterEncoding + ")" ),
		"TAG": new RegExp( "^(" + characterEncoding.replace( "w", "w*" ) + ")" ),
		"ATTR": new RegExp( "^" + attributes ),
		"PSEUDO": new RegExp( "^" + pseudos ),
		"CHILD": new RegExp( "^:(only|first|last|nth|nth-last)-(child|of-type)(?:\\(" + whitespace +
			"*(even|odd|(([+-]|)(\\d*)n|)" + whitespace + "*(?:([+-]|)" + whitespace +
			"*(\\d+)|))" + whitespace + "*\\)|)", "i" ),
		"bool": new RegExp( "^(?:" + booleans + ")$", "i" ),
		// For use in libraries implementing .is()
		// We use this for POS matching in `select`
		"needsContext": new RegExp( "^" + whitespace + "*[>+~]|:(even|odd|eq|gt|lt|nth|first|last)(?:\\(" +
			whitespace + "*((?:-\\d)?\\d*)" + whitespace + "*\\)|)(?=[^-]|$)", "i" )
	},

	rnative = /^[^{]+\{\s*\[native \w/,

	// Easily-parseable/retrievable ID or TAG or CLASS selectors
	rquickExpr = /^(?:#([\w-]+)|(\w+)|\.([\w-]+))$/,

	rinputs = /^(?:input|select|textarea|button)$/i,
	rheader = /^h\d$/i,

	rescape = /'|\\/g,

	// CSS escapes http://www.w3.org/TR/CSS21/syndata.html#escaped-characters
	runescape = new RegExp( "\\\\([\\da-f]{1,6}" + whitespace + "?|(" + whitespace + ")|.)", "ig" ),
	funescape = function( _, escaped, escapedWhitespace ) {
		var high = "0x" + escaped - 0x10000;
		// NaN means non-codepoint
		// Support: Firefox
		// Workaround erroneous numeric interpretation of +"0x"
		return high !== high || escapedWhitespace ?
			escaped :
			// BMP codepoint
			high < 0 ?
				String.fromCharCode( high + 0x10000 ) :
				// Supplemental Plane codepoint (surrogate pair)
				String.fromCharCode( high >> 10 | 0xD800, high & 0x3FF | 0xDC00 );
	};

// Optimize for push.apply( _, NodeList )
try {
	push.apply(
		(arr = slice.call( preferredDoc.childNodes )),
		preferredDoc.childNodes
	);
	// Support: Android<4.0
	// Detect silently failing push.apply
	arr[ preferredDoc.childNodes.length ].nodeType;
} catch ( e ) {
	push = { apply: arr.length ?

		// Leverage slice if possible
		function( target, els ) {
			push_native.apply( target, slice.call(els) );
		} :

		// Support: IE<9
		// Otherwise append directly
		function( target, els ) {
			var j = target.length,
				i = 0;
			// Can't trust NodeList.length
			while ( (target[j++] = els[i++]) ) {}
			target.length = j - 1;
		}
	};
}

function Sizzle( selector, context, results, seed ) {
	var match, elem, m, nodeType,
		// QSA vars
		i, groups, old, nid, newContext, newSelector;

	if ( ( context ? context.ownerDocument || context : preferredDoc ) !== document ) {
		setDocument( context );
	}

	context = context || document;
	results = results || [];

	if ( !selector || typeof selector !== "string" ) {
		return results;
	}

	if ( (nodeType = context.nodeType) !== 1 && nodeType !== 9 ) {
		return [];
	}

	if ( documentIsHTML && !seed ) {

		// Shortcuts
		if ( (match = rquickExpr.exec( selector )) ) {
			// Speed-up: Sizzle("#ID")
			if ( (m = match[1]) ) {
				if ( nodeType === 9 ) {
					elem = context.getElementById( m );
					// Check parentNode to catch when Blackberry 4.6 returns
					// nodes that are no longer in the document #6963
					if ( elem && elem.parentNode ) {
						// Handle the case where IE, Opera, and Webkit return items
						// by name instead of ID
						if ( elem.id === m ) {
							results.push( elem );
							return results;
						}
					} else {
						return results;
					}
				} else {
					// Context is not a document
					if ( context.ownerDocument && (elem = context.ownerDocument.getElementById( m )) &&
						contains( context, elem ) && elem.id === m ) {
						results.push( elem );
						return results;
					}
				}

			// Speed-up: Sizzle("TAG")
			} else if ( match[2] ) {
				push.apply( results, context.getElementsByTagName( selector ) );
				return results;

			// Speed-up: Sizzle(".CLASS")
			} else if ( (m = match[3]) && support.getElementsByClassName && context.getElementsByClassName ) {
				push.apply( results, context.getElementsByClassName( m ) );
				return results;
			}
		}

		// QSA path
		if ( support.qsa && (!rbuggyQSA || !rbuggyQSA.test( selector )) ) {
			nid = old = expando;
			newContext = context;
			newSelector = nodeType === 9 && selector;

			// qSA works strangely on Element-rooted queries
			// We can work around this by specifying an extra ID on the root
			// and working up from there (Thanks to Andrew Dupont for the technique)
			// IE 8 doesn't work on object elements
			if ( nodeType === 1 && context.nodeName.toLowerCase() !== "object" ) {
				groups = tokenize( selector );

				if ( (old = context.getAttribute("id")) ) {
					nid = old.replace( rescape, "\\$&" );
				} else {
					context.setAttribute( "id", nid );
				}
				nid = "[id='" + nid + "'] ";

				i = groups.length;
				while ( i-- ) {
					groups[i] = nid + toSelector( groups[i] );
				}
				newContext = rsibling.test( selector ) && context.parentNode || context;
				newSelector = groups.join(",");
			}

			if ( newSelector ) {
				try {
					push.apply( results,
						newContext.querySelectorAll( newSelector )
					);
					return results;
				} catch(qsaError) {
				} finally {
					if ( !old ) {
						context.removeAttribute("id");
					}
				}
			}
		}
	}

	// All others
	return select( selector.replace( rtrim, "$1" ), context, results, seed );
}

/**
 * Create key-value caches of limited size
 * @returns {Function(string, Object)} Returns the Object data after storing it on itself with
 *	property name the (space-suffixed) string and (if the cache is larger than Expr.cacheLength)
 *	deleting the oldest entry
 */
function createCache() {
	var keys = [];

	function cache( key, value ) {
		// Use (key + " ") to avoid collision with native prototype properties (see Issue #157)
		if ( keys.push( key += " " ) > Expr.cacheLength ) {
			// Only keep the most recent entries
			delete cache[ keys.shift() ];
		}
		return (cache[ key ] = value);
	}
	return cache;
}

/**
 * Mark a function for special use by Sizzle
 * @param {Function} fn The function to mark
 */
function markFunction( fn ) {
	fn[ expando ] = true;
	return fn;
}

/**
 * Support testing using an element
 * @param {Function} fn Passed the created div and expects a boolean result
 */
function assert( fn ) {
	var div = document.createElement("div");

	try {
		return !!fn( div );
	} catch (e) {
		return false;
	} finally {
		// Remove from its parent by default
		if ( div.parentNode ) {
			div.parentNode.removeChild( div );
		}
		// release memory in IE
		div = null;
	}
}

/**
 * Adds the same handler for all of the specified attrs
 * @param {String} attrs Pipe-separated list of attributes
 * @param {Function} handler The method that will be applied
 */
function addHandle( attrs, handler ) {
	var arr = attrs.split("|"),
		i = attrs.length;

	while ( i-- ) {
		Expr.attrHandle[ arr[i] ] = handler;
	}
}

/**
 * Checks document order of two siblings
 * @param {Element} a
 * @param {Element} b
 * @returns {Number} Returns less than 0 if a precedes b, greater than 0 if a follows b
 */
function siblingCheck( a, b ) {
	var cur = b && a,
		diff = cur && a.nodeType === 1 && b.nodeType === 1 &&
			( ~b.sourceIndex || MAX_NEGATIVE ) -
			( ~a.sourceIndex || MAX_NEGATIVE );

	// Use IE sourceIndex if available on both nodes
	if ( diff ) {
		return diff;
	}

	// Check if b follows a
	if ( cur ) {
		while ( (cur = cur.nextSibling) ) {
			if ( cur === b ) {
				return -1;
			}
		}
	}

	return a ? 1 : -1;
}

/**
 * Returns a function to use in pseudos for input types
 * @param {String} type
 */
function createInputPseudo( type ) {
	return function( elem ) {
		var name = elem.nodeName.toLowerCase();
		return name === "input" && elem.type === type;
	};
}

/**
 * Returns a function to use in pseudos for buttons
 * @param {String} type
 */
function createButtonPseudo( type ) {
	return function( elem ) {
		var name = elem.nodeName.toLowerCase();
		return (name === "input" || name === "button") && elem.type === type;
	};
}

/**
 * Returns a function to use in pseudos for positionals
 * @param {Function} fn
 */
function createPositionalPseudo( fn ) {
	return markFunction(function( argument ) {
		argument = +argument;
		return markFunction(function( seed, matches ) {
			var j,
				matchIndexes = fn( [], seed.length, argument ),
				i = matchIndexes.length;

			// Match elements found at the specified indexes
			while ( i-- ) {
				if ( seed[ (j = matchIndexes[i]) ] ) {
					seed[j] = !(matches[j] = seed[j]);
				}
			}
		});
	});
}

/**
 * Detect xml
 * @param {Element|Object} elem An element or a document
 */
isXML = Sizzle.isXML = function( elem ) {
	// documentElement is verified for cases where it doesn't yet exist
	// (such as loading iframes in IE - #4833)
	var documentElement = elem && (elem.ownerDocument || elem).documentElement;
	return documentElement ? documentElement.nodeName !== "HTML" : false;
};

// Expose support vars for convenience
support = Sizzle.support = {};

/**
 * Sets document-related variables once based on the current document
 * @param {Element|Object} [doc] An element or document object to use to set the document
 * @returns {Object} Returns the current document
 */
setDocument = Sizzle.setDocument = function( node ) {
	var doc = node ? node.ownerDocument || node : preferredDoc,
		parent = doc.defaultView;

	// If no document and documentElement is available, return
	if ( doc === document || doc.nodeType !== 9 || !doc.documentElement ) {
		return document;
	}

	// Set our document
	document = doc;
	docElem = doc.documentElement;

	// Support tests
	documentIsHTML = !isXML( doc );

	// Support: IE>8
	// If iframe document is assigned to "document" variable and if iframe has been reloaded,
	// IE will throw "permission denied" error when accessing "document" variable, see jQuery #13936
	// IE6-8 do not support the defaultView property so parent will be undefined
	if ( parent && parent.attachEvent && parent !== parent.top ) {
		parent.attachEvent( "onbeforeunload", function() {
			setDocument();
		});
	}

	/* Attributes
	---------------------------------------------------------------------- */

	// Support: IE<8
	// Verify that getAttribute really returns attributes and not properties (excepting IE8 booleans)
	support.attributes = assert(function( div ) {
		div.className = "i";
		return !div.getAttribute("className");
	});

	/* getElement(s)By*
	---------------------------------------------------------------------- */

	// Check if getElementsByTagName("*") returns only elements
	support.getElementsByTagName = assert(function( div ) {
		div.appendChild( doc.createComment("") );
		return !div.getElementsByTagName("*").length;
	});

	// Check if getElementsByClassName can be trusted
	support.getElementsByClassName = assert(function( div ) {
		div.innerHTML = "<div class='a'></div><div class='a i'></div>";

		// Support: Safari<4
		// Catch class over-caching
		div.firstChild.className = "i";
		// Support: Opera<10
		// Catch gEBCN failure to find non-leading classes
		return div.getElementsByClassName("i").length === 2;
	});

	// Support: IE<10
	// Check if getElementById returns elements by name
	// The broken getElementById methods don't pick up programatically-set names,
	// so use a roundabout getElementsByName test
	support.getById = assert(function( div ) {
		docElem.appendChild( div ).id = expando;
		return !doc.getElementsByName || !doc.getElementsByName( expando ).length;
	});

	// ID find and filter
	if ( support.getById ) {
		Expr.find["ID"] = function( id, context ) {
			if ( typeof context.getElementById !== strundefined && documentIsHTML ) {
				var m = context.getElementById( id );
				// Check parentNode to catch when Blackberry 4.6 returns
				// nodes that are no longer in the document #6963
				return m && m.parentNode ? [m] : [];
			}
		};
		Expr.filter["ID"] = function( id ) {
			var attrId = id.replace( runescape, funescape );
			return function( elem ) {
				return elem.getAttribute("id") === attrId;
			};
		};
	} else {
		// Support: IE6/7
		// getElementById is not reliable as a find shortcut
		delete Expr.find["ID"];

		Expr.filter["ID"] =  function( id ) {
			var attrId = id.replace( runescape, funescape );
			return function( elem ) {
				var node = typeof elem.getAttributeNode !== strundefined && elem.getAttributeNode("id");
				return node && node.value === attrId;
			};
		};
	}

	// Tag
	Expr.find["TAG"] = support.getElementsByTagName ?
		function( tag, context ) {
			if ( typeof context.getElementsByTagName !== strundefined ) {
				return context.getElementsByTagName( tag );
			}
		} :
		function( tag, context ) {
			var elem,
				tmp = [],
				i = 0,
				results = context.getElementsByTagName( tag );

			// Filter out possible comments
			if ( tag === "*" ) {
				while ( (elem = results[i++]) ) {
					if ( elem.nodeType === 1 ) {
						tmp.push( elem );
					}
				}

				return tmp;
			}
			return results;
		};

	// Class
	Expr.find["CLASS"] = support.getElementsByClassName && function( className, context ) {
		if ( typeof context.getElementsByClassName !== strundefined && documentIsHTML ) {
			return context.getElementsByClassName( className );
		}
	};

	/* QSA/matchesSelector
	---------------------------------------------------------------------- */

	// QSA and matchesSelector support

	// matchesSelector(:active) reports false when true (IE9/Opera 11.5)
	rbuggyMatches = [];

	// qSa(:focus) reports false when true (Chrome 21)
	// We allow this because of a bug in IE8/9 that throws an error
	// whenever `document.activeElement` is accessed on an iframe
	// So, we allow :focus to pass through QSA all the time to avoid the IE error
	// See http://bugs.jquery.com/ticket/13378
	rbuggyQSA = [];

	if ( (support.qsa = rnative.test( doc.querySelectorAll )) ) {
		// Build QSA regex
		// Regex strategy adopted from Diego Perini
		assert(function( div ) {
			// Select is set to empty string on purpose
			// This is to test IE's treatment of not explicitly
			// setting a boolean content attribute,
			// since its presence should be enough
			// http://bugs.jquery.com/ticket/12359
			div.innerHTML = "<select><option selected=''></option></select>";

			// Support: IE8
			// Boolean attributes and "value" are not treated correctly
			if ( !div.querySelectorAll("[selected]").length ) {
				rbuggyQSA.push( "\\[" + whitespace + "*(?:value|" + booleans + ")" );
			}

			// Webkit/Opera - :checked should return selected option elements
			// http://www.w3.org/TR/2011/REC-css3-selectors-20110929/#checked
			// IE8 throws error here and will not see later tests
			if ( !div.querySelectorAll(":checked").length ) {
				rbuggyQSA.push(":checked");
			}
		});

		assert(function( div ) {

			// Support: Opera 10-12/IE8
			// ^= $= *= and empty values
			// Should not select anything
			// Support: Windows 8 Native Apps
			// The type attribute is restricted during .innerHTML assignment
			var input = doc.createElement("input");
			input.setAttribute( "type", "hidden" );
			div.appendChild( input ).setAttribute( "t", "" );

			if ( div.querySelectorAll("[t^='']").length ) {
				rbuggyQSA.push( "[*^$]=" + whitespace + "*(?:''|\"\")" );
			}

			// FF 3.5 - :enabled/:disabled and hidden elements (hidden elements are still enabled)
			// IE8 throws error here and will not see later tests
			if ( !div.querySelectorAll(":enabled").length ) {
				rbuggyQSA.push( ":enabled", ":disabled" );
			}

			// Opera 10-11 does not throw on post-comma invalid pseudos
			div.querySelectorAll("*,:x");
			rbuggyQSA.push(",.*:");
		});
	}

	if ( (support.matchesSelector = rnative.test( (matches = docElem.webkitMatchesSelector ||
		docElem.mozMatchesSelector ||
		docElem.oMatchesSelector ||
		docElem.msMatchesSelector) )) ) {

		assert(function( div ) {
			// Check to see if it's possible to do matchesSelector
			// on a disconnected node (IE 9)
			support.disconnectedMatch = matches.call( div, "div" );

			// This should fail with an exception
			// Gecko does not error, returns false instead
			matches.call( div, "[s!='']:x" );
			rbuggyMatches.push( "!=", pseudos );
		});
	}

	rbuggyQSA = rbuggyQSA.length && new RegExp( rbuggyQSA.join("|") );
	rbuggyMatches = rbuggyMatches.length && new RegExp( rbuggyMatches.join("|") );

	/* Contains
	---------------------------------------------------------------------- */

	// Element contains another
	// Purposefully does not implement inclusive descendent
	// As in, an element does not contain itself
	contains = rnative.test( docElem.contains ) || docElem.compareDocumentPosition ?
		function( a, b ) {
			var adown = a.nodeType === 9 ? a.documentElement : a,
				bup = b && b.parentNode;
			return a === bup || !!( bup && bup.nodeType === 1 && (
				adown.contains ?
					adown.contains( bup ) :
					a.compareDocumentPosition && a.compareDocumentPosition( bup ) & 16
			));
		} :
		function( a, b ) {
			if ( b ) {
				while ( (b = b.parentNode) ) {
					if ( b === a ) {
						return true;
					}
				}
			}
			return false;
		};

	/* Sorting
	---------------------------------------------------------------------- */

	// Document order sorting
	sortOrder = docElem.compareDocumentPosition ?
	function( a, b ) {

		// Flag for duplicate removal
		if ( a === b ) {
			hasDuplicate = true;
			return 0;
		}

		var compare = b.compareDocumentPosition && a.compareDocumentPosition && a.compareDocumentPosition( b );

		if ( compare ) {
			// Disconnected nodes
			if ( compare & 1 ||
				(!support.sortDetached && b.compareDocumentPosition( a ) === compare) ) {

				// Choose the first element that is related to our preferred document
				if ( a === doc || contains(preferredDoc, a) ) {
					return -1;
				}
				if ( b === doc || contains(preferredDoc, b) ) {
					return 1;
				}

				// Maintain original order
				return sortInput ?
					( indexOf.call( sortInput, a ) - indexOf.call( sortInput, b ) ) :
					0;
			}

			return compare & 4 ? -1 : 1;
		}

		// Not directly comparable, sort on existence of method
		return a.compareDocumentPosition ? -1 : 1;
	} :
	function( a, b ) {
		var cur,
			i = 0,
			aup = a.parentNode,
			bup = b.parentNode,
			ap = [ a ],
			bp = [ b ];

		// Exit early if the nodes are identical
		if ( a === b ) {
			hasDuplicate = true;
			return 0;

		// Parentless nodes are either documents or disconnected
		} else if ( !aup || !bup ) {
			return a === doc ? -1 :
				b === doc ? 1 :
				aup ? -1 :
				bup ? 1 :
				sortInput ?
				( indexOf.call( sortInput, a ) - indexOf.call( sortInput, b ) ) :
				0;

		// If the nodes are siblings, we can do a quick check
		} else if ( aup === bup ) {
			return siblingCheck( a, b );
		}

		// Otherwise we need full lists of their ancestors for comparison
		cur = a;
		while ( (cur = cur.parentNode) ) {
			ap.unshift( cur );
		}
		cur = b;
		while ( (cur = cur.parentNode) ) {
			bp.unshift( cur );
		}

		// Walk down the tree looking for a discrepancy
		while ( ap[i] === bp[i] ) {
			i++;
		}

		return i ?
			// Do a sibling check if the nodes have a common ancestor
			siblingCheck( ap[i], bp[i] ) :

			// Otherwise nodes in our document sort first
			ap[i] === preferredDoc ? -1 :
			bp[i] === preferredDoc ? 1 :
			0;
	};

	return doc;
};

Sizzle.matches = function( expr, elements ) {
	return Sizzle( expr, null, null, elements );
};

Sizzle.matchesSelector = function( elem, expr ) {
	// Set document vars if needed
	if ( ( elem.ownerDocument || elem ) !== document ) {
		setDocument( elem );
	}

	// Make sure that attribute selectors are quoted
	expr = expr.replace( rattributeQuotes, "='$1']" );

	if ( support.matchesSelector && documentIsHTML &&
		( !rbuggyMatches || !rbuggyMatches.test( expr ) ) &&
		( !rbuggyQSA     || !rbuggyQSA.test( expr ) ) ) {

		try {
			var ret = matches.call( elem, expr );

			// IE 9's matchesSelector returns false on disconnected nodes
			if ( ret || support.disconnectedMatch ||
					// As well, disconnected nodes are said to be in a document
					// fragment in IE 9
					elem.document && elem.document.nodeType !== 11 ) {
				return ret;
			}
		} catch(e) {}
	}

	return Sizzle( expr, document, null, [elem] ).length > 0;
};

Sizzle.contains = function( context, elem ) {
	// Set document vars if needed
	if ( ( context.ownerDocument || context ) !== document ) {
		setDocument( context );
	}
	return contains( context, elem );
};

Sizzle.attr = function( elem, name ) {
	// Set document vars if needed
	if ( ( elem.ownerDocument || elem ) !== document ) {
		setDocument( elem );
	}

	var fn = Expr.attrHandle[ name.toLowerCase() ],
		// Don't get fooled by Object.prototype properties (jQuery #13807)
		val = fn && hasOwn.call( Expr.attrHandle, name.toLowerCase() ) ?
			fn( elem, name, !documentIsHTML ) :
			undefined;

	return val === undefined ?
		support.attributes || !documentIsHTML ?
			elem.getAttribute( name ) :
			(val = elem.getAttributeNode(name)) && val.specified ?
				val.value :
				null :
		val;
};

Sizzle.error = function( msg ) {
	throw new Error( "Syntax error, unrecognized expression: " + msg );
};

/**
 * Document sorting and removing duplicates
 * @param {ArrayLike} results
 */
Sizzle.uniqueSort = function( results ) {
	var elem,
		duplicates = [],
		j = 0,
		i = 0;

	// Unless we *know* we can detect duplicates, assume their presence
	hasDuplicate = !support.detectDuplicates;
	sortInput = !support.sortStable && results.slice( 0 );
	results.sort( sortOrder );

	if ( hasDuplicate ) {
		while ( (elem = results[i++]) ) {
			if ( elem === results[ i ] ) {
				j = duplicates.push( i );
			}
		}
		while ( j-- ) {
			results.splice( duplicates[ j ], 1 );
		}
	}

	return results;
};

/**
 * Utility function for retrieving the text value of an array of DOM nodes
 * @param {Array|Element} elem
 */
getText = Sizzle.getText = function( elem ) {
	var node,
		ret = "",
		i = 0,
		nodeType = elem.nodeType;

	if ( !nodeType ) {
		// If no nodeType, this is expected to be an array
		for ( ; (node = elem[i]); i++ ) {
			// Do not traverse comment nodes
			ret += getText( node );
		}
	} else if ( nodeType === 1 || nodeType === 9 || nodeType === 11 ) {
		// Use textContent for elements
		// innerText usage removed for consistency of new lines (see #11153)
		if ( typeof elem.textContent === "string" ) {
			return elem.textContent;
		} else {
			// Traverse its children
			for ( elem = elem.firstChild; elem; elem = elem.nextSibling ) {
				ret += getText( elem );
			}
		}
	} else if ( nodeType === 3 || nodeType === 4 ) {
		return elem.nodeValue;
	}
	// Do not include comment or processing instruction nodes

	return ret;
};

Expr = Sizzle.selectors = {

	// Can be adjusted by the user
	cacheLength: 50,

	createPseudo: markFunction,

	match: matchExpr,

	attrHandle: {},

	find: {},

	relative: {
		">": { dir: "parentNode", first: true },
		" ": { dir: "parentNode" },
		"+": { dir: "previousSibling", first: true },
		"~": { dir: "previousSibling" }
	},

	preFilter: {
		"ATTR": function( match ) {
			match[1] = match[1].replace( runescape, funescape );

			// Move the given value to match[3] whether quoted or unquoted
			match[3] = ( match[4] || match[5] || "" ).replace( runescape, funescape );

			if ( match[2] === "~=" ) {
				match[3] = " " + match[3] + " ";
			}

			return match.slice( 0, 4 );
		},

		"CHILD": function( match ) {
			/* matches from matchExpr["CHILD"]
				1 type (only|nth|...)
				2 what (child|of-type)
				3 argument (even|odd|\d*|\d*n([+-]\d+)?|...)
				4 xn-component of xn+y argument ([+-]?\d*n|)
				5 sign of xn-component
				6 x of xn-component
				7 sign of y-component
				8 y of y-component
			*/
			match[1] = match[1].toLowerCase();

			if ( match[1].slice( 0, 3 ) === "nth" ) {
				// nth-* requires argument
				if ( !match[3] ) {
					Sizzle.error( match[0] );
				}

				// numeric x and y parameters for Expr.filter.CHILD
				// remember that false/true cast respectively to 0/1
				match[4] = +( match[4] ? match[5] + (match[6] || 1) : 2 * ( match[3] === "even" || match[3] === "odd" ) );
				match[5] = +( ( match[7] + match[8] ) || match[3] === "odd" );

			// other types prohibit arguments
			} else if ( match[3] ) {
				Sizzle.error( match[0] );
			}

			return match;
		},

		"PSEUDO": function( match ) {
			var excess,
				unquoted = !match[5] && match[2];

			if ( matchExpr["CHILD"].test( match[0] ) ) {
				return null;
			}

			// Accept quoted arguments as-is
			if ( match[3] && match[4] !== undefined ) {
				match[2] = match[4];

			// Strip excess characters from unquoted arguments
			} else if ( unquoted && rpseudo.test( unquoted ) &&
				// Get excess from tokenize (recursively)
				(excess = tokenize( unquoted, true )) &&
				// advance to the next closing parenthesis
				(excess = unquoted.indexOf( ")", unquoted.length - excess ) - unquoted.length) ) {

				// excess is a negative index
				match[0] = match[0].slice( 0, excess );
				match[2] = unquoted.slice( 0, excess );
			}

			// Return only captures needed by the pseudo filter method (type and argument)
			return match.slice( 0, 3 );
		}
	},

	filter: {

		"TAG": function( nodeNameSelector ) {
			var nodeName = nodeNameSelector.replace( runescape, funescape ).toLowerCase();
			return nodeNameSelector === "*" ?
				function() { return true; } :
				function( elem ) {
					return elem.nodeName && elem.nodeName.toLowerCase() === nodeName;
				};
		},

		"CLASS": function( className ) {
			var pattern = classCache[ className + " " ];

			return pattern ||
				(pattern = new RegExp( "(^|" + whitespace + ")" + className + "(" + whitespace + "|$)" )) &&
				classCache( className, function( elem ) {
					return pattern.test( typeof elem.className === "string" && elem.className || typeof elem.getAttribute !== strundefined && elem.getAttribute("class") || "" );
				});
		},

		"ATTR": function( name, operator, check ) {
			return function( elem ) {
				var result = Sizzle.attr( elem, name );

				if ( result == null ) {
					return operator === "!=";
				}
				if ( !operator ) {
					return true;
				}

				result += "";

				return operator === "=" ? result === check :
					operator === "!=" ? result !== check :
					operator === "^=" ? check && result.indexOf( check ) === 0 :
					operator === "*=" ? check && result.indexOf( check ) > -1 :
					operator === "$=" ? check && result.slice( -check.length ) === check :
					operator === "~=" ? ( " " + result + " " ).indexOf( check ) > -1 :
					operator === "|=" ? result === check || result.slice( 0, check.length + 1 ) === check + "-" :
					false;
			};
		},

		"CHILD": function( type, what, argument, first, last ) {
			var simple = type.slice( 0, 3 ) !== "nth",
				forward = type.slice( -4 ) !== "last",
				ofType = what === "of-type";

			return first === 1 && last === 0 ?

				// Shortcut for :nth-*(n)
				function( elem ) {
					return !!elem.parentNode;
				} :

				function( elem, context, xml ) {
					var cache, outerCache, node, diff, nodeIndex, start,
						dir = simple !== forward ? "nextSibling" : "previousSibling",
						parent = elem.parentNode,
						name = ofType && elem.nodeName.toLowerCase(),
						useCache = !xml && !ofType;

					if ( parent ) {

						// :(first|last|only)-(child|of-type)
						if ( simple ) {
							while ( dir ) {
								node = elem;
								while ( (node = node[ dir ]) ) {
									if ( ofType ? node.nodeName.toLowerCase() === name : node.nodeType === 1 ) {
										return false;
									}
								}
								// Reverse direction for :only-* (if we haven't yet done so)
								start = dir = type === "only" && !start && "nextSibling";
							}
							return true;
						}

						start = [ forward ? parent.firstChild : parent.lastChild ];

						// non-xml :nth-child(...) stores cache data on `parent`
						if ( forward && useCache ) {
							// Seek `elem` from a previously-cached index
							outerCache = parent[ expando ] || (parent[ expando ] = {});
							cache = outerCache[ type ] || [];
							nodeIndex = cache[0] === dirruns && cache[1];
							diff = cache[0] === dirruns && cache[2];
							node = nodeIndex && parent.childNodes[ nodeIndex ];

							while ( (node = ++nodeIndex && node && node[ dir ] ||

								// Fallback to seeking `elem` from the start
								(diff = nodeIndex = 0) || start.pop()) ) {

								// When found, cache indexes on `parent` and break
								if ( node.nodeType === 1 && ++diff && node === elem ) {
									outerCache[ type ] = [ dirruns, nodeIndex, diff ];
									break;
								}
							}

						// Use previously-cached element index if available
						} else if ( useCache && (cache = (elem[ expando ] || (elem[ expando ] = {}))[ type ]) && cache[0] === dirruns ) {
							diff = cache[1];

						// xml :nth-child(...) or :nth-last-child(...) or :nth(-last)?-of-type(...)
						} else {
							// Use the same loop as above to seek `elem` from the start
							while ( (node = ++nodeIndex && node && node[ dir ] ||
								(diff = nodeIndex = 0) || start.pop()) ) {

								if ( ( ofType ? node.nodeName.toLowerCase() === name : node.nodeType === 1 ) && ++diff ) {
									// Cache the index of each encountered element
									if ( useCache ) {
										(node[ expando ] || (node[ expando ] = {}))[ type ] = [ dirruns, diff ];
									}

									if ( node === elem ) {
										break;
									}
								}
							}
						}

						// Incorporate the offset, then check against cycle size
						diff -= last;
						return diff === first || ( diff % first === 0 && diff / first >= 0 );
					}
				};
		},

		"PSEUDO": function( pseudo, argument ) {
			// pseudo-class names are case-insensitive
			// http://www.w3.org/TR/selectors/#pseudo-classes
			// Prioritize by case sensitivity in case custom pseudos are added with uppercase letters
			// Remember that setFilters inherits from pseudos
			var args,
				fn = Expr.pseudos[ pseudo ] || Expr.setFilters[ pseudo.toLowerCase() ] ||
					Sizzle.error( "unsupported pseudo: " + pseudo );

			// The user may use createPseudo to indicate that
			// arguments are needed to create the filter function
			// just as Sizzle does
			if ( fn[ expando ] ) {
				return fn( argument );
			}

			// But maintain support for old signatures
			if ( fn.length > 1 ) {
				args = [ pseudo, pseudo, "", argument ];
				return Expr.setFilters.hasOwnProperty( pseudo.toLowerCase() ) ?
					markFunction(function( seed, matches ) {
						var idx,
							matched = fn( seed, argument ),
							i = matched.length;
						while ( i-- ) {
							idx = indexOf.call( seed, matched[i] );
							seed[ idx ] = !( matches[ idx ] = matched[i] );
						}
					}) :
					function( elem ) {
						return fn( elem, 0, args );
					};
			}

			return fn;
		}
	},

	pseudos: {
		// Potentially complex pseudos
		"not": markFunction(function( selector ) {
			// Trim the selector passed to compile
			// to avoid treating leading and trailing
			// spaces as combinators
			var input = [],
				results = [],
				matcher = compile( selector.replace( rtrim, "$1" ) );

			return matcher[ expando ] ?
				markFunction(function( seed, matches, context, xml ) {
					var elem,
						unmatched = matcher( seed, null, xml, [] ),
						i = seed.length;

					// Match elements unmatched by `matcher`
					while ( i-- ) {
						if ( (elem = unmatched[i]) ) {
							seed[i] = !(matches[i] = elem);
						}
					}
				}) :
				function( elem, context, xml ) {
					input[0] = elem;
					matcher( input, null, xml, results );
					return !results.pop();
				};
		}),

		"has": markFunction(function( selector ) {
			return function( elem ) {
				return Sizzle( selector, elem ).length > 0;
			};
		}),

		"contains": markFunction(function( text ) {
			return function( elem ) {
				return ( elem.textContent || elem.innerText || getText( elem ) ).indexOf( text ) > -1;
			};
		}),

		// "Whether an element is represented by a :lang() selector
		// is based solely on the element's language value
		// being equal to the identifier C,
		// or beginning with the identifier C immediately followed by "-".
		// The matching of C against the element's language value is performed case-insensitively.
		// The identifier C does not have to be a valid language name."
		// http://www.w3.org/TR/selectors/#lang-pseudo
		"lang": markFunction( function( lang ) {
			// lang value must be a valid identifier
			if ( !ridentifier.test(lang || "") ) {
				Sizzle.error( "unsupported lang: " + lang );
			}
			lang = lang.replace( runescape, funescape ).toLowerCase();
			return function( elem ) {
				var elemLang;
				do {
					if ( (elemLang = documentIsHTML ?
						elem.lang :
						elem.getAttribute("xml:lang") || elem.getAttribute("lang")) ) {

						elemLang = elemLang.toLowerCase();
						return elemLang === lang || elemLang.indexOf( lang + "-" ) === 0;
					}
				} while ( (elem = elem.parentNode) && elem.nodeType === 1 );
				return false;
			};
		}),

		// Miscellaneous
		"target": function( elem ) {
			var hash = window.location && window.location.hash;
			return hash && hash.slice( 1 ) === elem.id;
		},

		"root": function( elem ) {
			return elem === docElem;
		},

		"focus": function( elem ) {
			return elem === document.activeElement && (!document.hasFocus || document.hasFocus()) && !!(elem.type || elem.href || ~elem.tabIndex);
		},

		// Boolean properties
		"enabled": function( elem ) {
			return elem.disabled === false;
		},

		"disabled": function( elem ) {
			return elem.disabled === true;
		},

		"checked": function( elem ) {
			// In CSS3, :checked should return both checked and selected elements
			// http://www.w3.org/TR/2011/REC-css3-selectors-20110929/#checked
			var nodeName = elem.nodeName.toLowerCase();
			return (nodeName === "input" && !!elem.checked) || (nodeName === "option" && !!elem.selected);
		},

		"selected": function( elem ) {
			// Accessing this property makes selected-by-default
			// options in Safari work properly
			if ( elem.parentNode ) {
				elem.parentNode.selectedIndex;
			}

			return elem.selected === true;
		},

		// Contents
		"empty": function( elem ) {
			// http://www.w3.org/TR/selectors/#empty-pseudo
			// :empty is only affected by element nodes and content nodes(including text(3), cdata(4)),
			//   not comment, processing instructions, or others
			// Thanks to Diego Perini for the nodeName shortcut
			//   Greater than "@" means alpha characters (specifically not starting with "#" or "?")
			for ( elem = elem.firstChild; elem; elem = elem.nextSibling ) {
				if ( elem.nodeName > "@" || elem.nodeType === 3 || elem.nodeType === 4 ) {
					return false;
				}
			}
			return true;
		},

		"parent": function( elem ) {
			return !Expr.pseudos["empty"]( elem );
		},

		// Element/input types
		"header": function( elem ) {
			return rheader.test( elem.nodeName );
		},

		"input": function( elem ) {
			return rinputs.test( elem.nodeName );
		},

		"button": function( elem ) {
			var name = elem.nodeName.toLowerCase();
			return name === "input" && elem.type === "button" || name === "button";
		},

		"text": function( elem ) {
			var attr;
			// IE6 and 7 will map elem.type to 'text' for new HTML5 types (search, etc)
			// use getAttribute instead to test this case
			return elem.nodeName.toLowerCase() === "input" &&
				elem.type === "text" &&
				( (attr = elem.getAttribute("type")) == null || attr.toLowerCase() === elem.type );
		},

		// Position-in-collection
		"first": createPositionalPseudo(function() {
			return [ 0 ];
		}),

		"last": createPositionalPseudo(function( matchIndexes, length ) {
			return [ length - 1 ];
		}),

		"eq": createPositionalPseudo(function( matchIndexes, length, argument ) {
			return [ argument < 0 ? argument + length : argument ];
		}),

		"even": createPositionalPseudo(function( matchIndexes, length ) {
			var i = 0;
			for ( ; i < length; i += 2 ) {
				matchIndexes.push( i );
			}
			return matchIndexes;
		}),

		"odd": createPositionalPseudo(function( matchIndexes, length ) {
			var i = 1;
			for ( ; i < length; i += 2 ) {
				matchIndexes.push( i );
			}
			return matchIndexes;
		}),

		"lt": createPositionalPseudo(function( matchIndexes, length, argument ) {
			var i = argument < 0 ? argument + length : argument;
			for ( ; --i >= 0; ) {
				matchIndexes.push( i );
			}
			return matchIndexes;
		}),

		"gt": createPositionalPseudo(function( matchIndexes, length, argument ) {
			var i = argument < 0 ? argument + length : argument;
			for ( ; ++i < length; ) {
				matchIndexes.push( i );
			}
			return matchIndexes;
		})
	}
};

Expr.pseudos["nth"] = Expr.pseudos["eq"];

// Add button/input type pseudos
for ( i in { radio: true, checkbox: true, file: true, password: true, image: true } ) {
	Expr.pseudos[ i ] = createInputPseudo( i );
}
for ( i in { submit: true, reset: true } ) {
	Expr.pseudos[ i ] = createButtonPseudo( i );
}

// Easy API for creating new setFilters
function setFilters() {}
setFilters.prototype = Expr.filters = Expr.pseudos;
Expr.setFilters = new setFilters();

function tokenize( selector, parseOnly ) {
	var matched, match, tokens, type,
		soFar, groups, preFilters,
		cached = tokenCache[ selector + " " ];

	if ( cached ) {
		return parseOnly ? 0 : cached.slice( 0 );
	}

	soFar = selector;
	groups = [];
	preFilters = Expr.preFilter;

	while ( soFar ) {

		// Comma and first run
		if ( !matched || (match = rcomma.exec( soFar )) ) {
			if ( match ) {
				// Don't consume trailing commas as valid
				soFar = soFar.slice( match[0].length ) || soFar;
			}
			groups.push( tokens = [] );
		}

		matched = false;

		// Combinators
		if ( (match = rcombinators.exec( soFar )) ) {
			matched = match.shift();
			tokens.push({
				value: matched,
				// Cast descendant combinators to space
				type: match[0].replace( rtrim, " " )
			});
			soFar = soFar.slice( matched.length );
		}

		// Filters
		for ( type in Expr.filter ) {
			if ( (match = matchExpr[ type ].exec( soFar )) && (!preFilters[ type ] ||
				(match = preFilters[ type ]( match ))) ) {
				matched = match.shift();
				tokens.push({
					value: matched,
					type: type,
					matches: match
				});
				soFar = soFar.slice( matched.length );
			}
		}

		if ( !matched ) {
			break;
		}
	}

	// Return the length of the invalid excess
	// if we're just parsing
	// Otherwise, throw an error or return tokens
	return parseOnly ?
		soFar.length :
		soFar ?
			Sizzle.error( selector ) :
			// Cache the tokens
			tokenCache( selector, groups ).slice( 0 );
}

function toSelector( tokens ) {
	var i = 0,
		len = tokens.length,
		selector = "";
	for ( ; i < len; i++ ) {
		selector += tokens[i].value;
	}
	return selector;
}

function addCombinator( matcher, combinator, base ) {
	var dir = combinator.dir,
		checkNonElements = base && dir === "parentNode",
		doneName = done++;

	return combinator.first ?
		// Check against closest ancestor/preceding element
		function( elem, context, xml ) {
			while ( (elem = elem[ dir ]) ) {
				if ( elem.nodeType === 1 || checkNonElements ) {
					return matcher( elem, context, xml );
				}
			}
		} :

		// Check against all ancestor/preceding elements
		function( elem, context, xml ) {
			var data, cache, outerCache,
				dirkey = dirruns + " " + doneName;

			// We can't set arbitrary data on XML nodes, so they don't benefit from dir caching
			if ( xml ) {
				while ( (elem = elem[ dir ]) ) {
					if ( elem.nodeType === 1 || checkNonElements ) {
						if ( matcher( elem, context, xml ) ) {
							return true;
						}
					}
				}
			} else {
				while ( (elem = elem[ dir ]) ) {
					if ( elem.nodeType === 1 || checkNonElements ) {
						outerCache = elem[ expando ] || (elem[ expando ] = {});
						if ( (cache = outerCache[ dir ]) && cache[0] === dirkey ) {
							if ( (data = cache[1]) === true || data === cachedruns ) {
								return data === true;
							}
						} else {
							cache = outerCache[ dir ] = [ dirkey ];
							cache[1] = matcher( elem, context, xml ) || cachedruns;
							if ( cache[1] === true ) {
								return true;
							}
						}
					}
				}
			}
		};
}

function elementMatcher( matchers ) {
	return matchers.length > 1 ?
		function( elem, context, xml ) {
			var i = matchers.length;
			while ( i-- ) {
				if ( !matchers[i]( elem, context, xml ) ) {
					return false;
				}
			}
			return true;
		} :
		matchers[0];
}

function condense( unmatched, map, filter, context, xml ) {
	var elem,
		newUnmatched = [],
		i = 0,
		len = unmatched.length,
		mapped = map != null;

	for ( ; i < len; i++ ) {
		if ( (elem = unmatched[i]) ) {
			if ( !filter || filter( elem, context, xml ) ) {
				newUnmatched.push( elem );
				if ( mapped ) {
					map.push( i );
				}
			}
		}
	}

	return newUnmatched;
}

function setMatcher( preFilter, selector, matcher, postFilter, postFinder, postSelector ) {
	if ( postFilter && !postFilter[ expando ] ) {
		postFilter = setMatcher( postFilter );
	}
	if ( postFinder && !postFinder[ expando ] ) {
		postFinder = setMatcher( postFinder, postSelector );
	}
	return markFunction(function( seed, results, context, xml ) {
		var temp, i, elem,
			preMap = [],
			postMap = [],
			preexisting = results.length,

			// Get initial elements from seed or context
			elems = seed || multipleContexts( selector || "*", context.nodeType ? [ context ] : context, [] ),

			// Prefilter to get matcher input, preserving a map for seed-results synchronization
			matcherIn = preFilter && ( seed || !selector ) ?
				condense( elems, preMap, preFilter, context, xml ) :
				elems,

			matcherOut = matcher ?
				// If we have a postFinder, or filtered seed, or non-seed postFilter or preexisting results,
				postFinder || ( seed ? preFilter : preexisting || postFilter ) ?

					// ...intermediate processing is necessary
					[] :

					// ...otherwise use results directly
					results :
				matcherIn;

		// Find primary matches
		if ( matcher ) {
			matcher( matcherIn, matcherOut, context, xml );
		}

		// Apply postFilter
		if ( postFilter ) {
			temp = condense( matcherOut, postMap );
			postFilter( temp, [], context, xml );

			// Un-match failing elements by moving them back to matcherIn
			i = temp.length;
			while ( i-- ) {
				if ( (elem = temp[i]) ) {
					matcherOut[ postMap[i] ] = !(matcherIn[ postMap[i] ] = elem);
				}
			}
		}

		if ( seed ) {
			if ( postFinder || preFilter ) {
				if ( postFinder ) {
					// Get the final matcherOut by condensing this intermediate into postFinder contexts
					temp = [];
					i = matcherOut.length;
					while ( i-- ) {
						if ( (elem = matcherOut[i]) ) {
							// Restore matcherIn since elem is not yet a final match
							temp.push( (matcherIn[i] = elem) );
						}
					}
					postFinder( null, (matcherOut = []), temp, xml );
				}

				// Move matched elements from seed to results to keep them synchronized
				i = matcherOut.length;
				while ( i-- ) {
					if ( (elem = matcherOut[i]) &&
						(temp = postFinder ? indexOf.call( seed, elem ) : preMap[i]) > -1 ) {

						seed[temp] = !(results[temp] = elem);
					}
				}
			}

		// Add elements to results, through postFinder if defined
		} else {
			matcherOut = condense(
				matcherOut === results ?
					matcherOut.splice( preexisting, matcherOut.length ) :
					matcherOut
			);
			if ( postFinder ) {
				postFinder( null, results, matcherOut, xml );
			} else {
				push.apply( results, matcherOut );
			}
		}
	});
}

function matcherFromTokens( tokens ) {
	var checkContext, matcher, j,
		len = tokens.length,
		leadingRelative = Expr.relative[ tokens[0].type ],
		implicitRelative = leadingRelative || Expr.relative[" "],
		i = leadingRelative ? 1 : 0,

		// The foundational matcher ensures that elements are reachable from top-level context(s)
		matchContext = addCombinator( function( elem ) {
			return elem === checkContext;
		}, implicitRelative, true ),
		matchAnyContext = addCombinator( function( elem ) {
			return indexOf.call( checkContext, elem ) > -1;
		}, implicitRelative, true ),
		matchers = [ function( elem, context, xml ) {
			return ( !leadingRelative && ( xml || context !== outermostContext ) ) || (
				(checkContext = context).nodeType ?
					matchContext( elem, context, xml ) :
					matchAnyContext( elem, context, xml ) );
		} ];

	for ( ; i < len; i++ ) {
		if ( (matcher = Expr.relative[ tokens[i].type ]) ) {
			matchers = [ addCombinator(elementMatcher( matchers ), matcher) ];
		} else {
			matcher = Expr.filter[ tokens[i].type ].apply( null, tokens[i].matches );

			// Return special upon seeing a positional matcher
			if ( matcher[ expando ] ) {
				// Find the next relative operator (if any) for proper handling
				j = ++i;
				for ( ; j < len; j++ ) {
					if ( Expr.relative[ tokens[j].type ] ) {
						break;
					}
				}
				return setMatcher(
					i > 1 && elementMatcher( matchers ),
					i > 1 && toSelector(
						// If the preceding token was a descendant combinator, insert an implicit any-element `*`
						tokens.slice( 0, i - 1 ).concat({ value: tokens[ i - 2 ].type === " " ? "*" : "" })
					).replace( rtrim, "$1" ),
					matcher,
					i < j && matcherFromTokens( tokens.slice( i, j ) ),
					j < len && matcherFromTokens( (tokens = tokens.slice( j )) ),
					j < len && toSelector( tokens )
				);
			}
			matchers.push( matcher );
		}
	}

	return elementMatcher( matchers );
}

function matcherFromGroupMatchers( elementMatchers, setMatchers ) {
	// A counter to specify which element is currently being matched
	var matcherCachedRuns = 0,
		bySet = setMatchers.length > 0,
		byElement = elementMatchers.length > 0,
		superMatcher = function( seed, context, xml, results, expandContext ) {
			var elem, j, matcher,
				setMatched = [],
				matchedCount = 0,
				i = "0",
				unmatched = seed && [],
				outermost = expandContext != null,
				contextBackup = outermostContext,
				// We must always have either seed elements or context
				elems = seed || byElement && Expr.find["TAG"]( "*", expandContext && context.parentNode || context ),
				// Use integer dirruns iff this is the outermost matcher
				dirrunsUnique = (dirruns += contextBackup == null ? 1 : Math.random() || 0.1);

			if ( outermost ) {
				outermostContext = context !== document && context;
				cachedruns = matcherCachedRuns;
			}

			// Add elements passing elementMatchers directly to results
			// Keep `i` a string if there are no elements so `matchedCount` will be "00" below
			for ( ; (elem = elems[i]) != null; i++ ) {
				if ( byElement && elem ) {
					j = 0;
					while ( (matcher = elementMatchers[j++]) ) {
						if ( matcher( elem, context, xml ) ) {
							results.push( elem );
							break;
						}
					}
					if ( outermost ) {
						dirruns = dirrunsUnique;
						cachedruns = ++matcherCachedRuns;
					}
				}

				// Track unmatched elements for set filters
				if ( bySet ) {
					// They will have gone through all possible matchers
					if ( (elem = !matcher && elem) ) {
						matchedCount--;
					}

					// Lengthen the array for every element, matched or not
					if ( seed ) {
						unmatched.push( elem );
					}
				}
			}

			// Apply set filters to unmatched elements
			matchedCount += i;
			if ( bySet && i !== matchedCount ) {
				j = 0;
				while ( (matcher = setMatchers[j++]) ) {
					matcher( unmatched, setMatched, context, xml );
				}

				if ( seed ) {
					// Reintegrate element matches to eliminate the need for sorting
					if ( matchedCount > 0 ) {
						while ( i-- ) {
							if ( !(unmatched[i] || setMatched[i]) ) {
								setMatched[i] = pop.call( results );
							}
						}
					}

					// Discard index placeholder values to get only actual matches
					setMatched = condense( setMatched );
				}

				// Add matches to results
				push.apply( results, setMatched );

				// Seedless set matches succeeding multiple successful matchers stipulate sorting
				if ( outermost && !seed && setMatched.length > 0 &&
					( matchedCount + setMatchers.length ) > 1 ) {

					Sizzle.uniqueSort( results );
				}
			}

			// Override manipulation of globals by nested matchers
			if ( outermost ) {
				dirruns = dirrunsUnique;
				outermostContext = contextBackup;
			}

			return unmatched;
		};

	return bySet ?
		markFunction( superMatcher ) :
		superMatcher;
}

compile = Sizzle.compile = function( selector, group /* Internal Use Only */ ) {
	var i,
		setMatchers = [],
		elementMatchers = [],
		cached = compilerCache[ selector + " " ];

	if ( !cached ) {
		// Generate a function of recursive functions that can be used to check each element
		if ( !group ) {
			group = tokenize( selector );
		}
		i = group.length;
		while ( i-- ) {
			cached = matcherFromTokens( group[i] );
			if ( cached[ expando ] ) {
				setMatchers.push( cached );
			} else {
				elementMatchers.push( cached );
			}
		}

		// Cache the compiled function
		cached = compilerCache( selector, matcherFromGroupMatchers( elementMatchers, setMatchers ) );
	}
	return cached;
};

function multipleContexts( selector, contexts, results ) {
	var i = 0,
		len = contexts.length;
	for ( ; i < len; i++ ) {
		Sizzle( selector, contexts[i], results );
	}
	return results;
}

function select( selector, context, results, seed ) {
	var i, tokens, token, type, find,
		match = tokenize( selector );

	if ( !seed ) {
		// Try to minimize operations if there is only one group
		if ( match.length === 1 ) {

			// Take a shortcut and set the context if the root selector is an ID
			tokens = match[0] = match[0].slice( 0 );
			if ( tokens.length > 2 && (token = tokens[0]).type === "ID" &&
					support.getById && context.nodeType === 9 && documentIsHTML &&
					Expr.relative[ tokens[1].type ] ) {

				context = ( Expr.find["ID"]( token.matches[0].replace(runescape, funescape), context ) || [] )[0];
				if ( !context ) {
					return results;
				}
				selector = selector.slice( tokens.shift().value.length );
			}

			// Fetch a seed set for right-to-left matching
			i = matchExpr["needsContext"].test( selector ) ? 0 : tokens.length;
			while ( i-- ) {
				token = tokens[i];

				// Abort if we hit a combinator
				if ( Expr.relative[ (type = token.type) ] ) {
					break;
				}
				if ( (find = Expr.find[ type ]) ) {
					// Search, expanding context for leading sibling combinators
					if ( (seed = find(
						token.matches[0].replace( runescape, funescape ),
						rsibling.test( tokens[0].type ) && context.parentNode || context
					)) ) {

						// If seed is empty or no tokens remain, we can return early
						tokens.splice( i, 1 );
						selector = seed.length && toSelector( tokens );
						if ( !selector ) {
							push.apply( results, seed );
							return results;
						}

						break;
					}
				}
			}
		}
	}

	// Compile and execute a filtering function
	// Provide `match` to avoid retokenization if we modified the selector above
	compile( selector, match )(
		seed,
		context,
		!documentIsHTML,
		results,
		rsibling.test( selector )
	);
	return results;
}

// One-time assignments

// Sort stability
support.sortStable = expando.split("").sort( sortOrder ).join("") === expando;

// Support: Chrome<14
// Always assume duplicates if they aren't passed to the comparison function
support.detectDuplicates = hasDuplicate;

// Initialize against the default document
setDocument();

// Support: Webkit<537.32 - Safari 6.0.3/Chrome 25 (fixed in Chrome 27)
// Detached nodes confoundingly follow *each other*
support.sortDetached = assert(function( div1 ) {
	// Should return 1, but returns 4 (following)
	return div1.compareDocumentPosition( document.createElement("div") ) & 1;
});

// Support: IE<8
// Prevent attribute/property "interpolation"
// http://msdn.microsoft.com/en-us/library/ms536429%28VS.85%29.aspx
if ( !assert(function( div ) {
	div.innerHTML = "<a href='#'></a>";
	return div.firstChild.getAttribute("href") === "#" ;
}) ) {
	addHandle( "type|href|height|width", function( elem, name, isXML ) {
		if ( !isXML ) {
			return elem.getAttribute( name, name.toLowerCase() === "type" ? 1 : 2 );
		}
	});
}

// Support: IE<9
// Use defaultValue in place of getAttribute("value")
if ( !support.attributes || !assert(function( div ) {
	div.innerHTML = "<input/>";
	div.firstChild.setAttribute( "value", "" );
	return div.firstChild.getAttribute( "value" ) === "";
}) ) {
	addHandle( "value", function( elem, name, isXML ) {
		if ( !isXML && elem.nodeName.toLowerCase() === "input" ) {
			return elem.defaultValue;
		}
	});
}

// Support: IE<9
// Use getAttributeNode to fetch booleans when getAttribute lies
if ( !assert(function( div ) {
	return div.getAttribute("disabled") == null;
}) ) {
	addHandle( booleans, function( elem, name, isXML ) {
		var val;
		if ( !isXML ) {
			return (val = elem.getAttributeNode( name )) && val.specified ?
				val.value :
				elem[ name ] === true ? name.toLowerCase() : null;
		}
	});
}

jQuery.find = Sizzle;
jQuery.expr = Sizzle.selectors;
jQuery.expr[":"] = jQuery.expr.pseudos;
jQuery.unique = Sizzle.uniqueSort;
jQuery.text = Sizzle.getText;
jQuery.isXMLDoc = Sizzle.isXML;
jQuery.contains = Sizzle.contains;


})( window );
// String to Object options format cache
var optionsCache = {};

// Convert String-formatted options into Object-formatted ones and store in cache
function createOptions( options ) {
	var object = optionsCache[ options ] = {};
	jQuery.each( options.match( core_rnotwhite ) || [], function( _, flag ) {
		object[ flag ] = true;
	});
	return object;
}

/*
 * Create a callback list using the following parameters:
 *
 *	options: an optional list of space-separated options that will change how
 *			the callback list behaves or a more traditional option object
 *
 * By default a callback list will act like an event callback list and can be
 * "fired" multiple times.
 *
 * Possible options:
 *
 *	once:			will ensure the callback list can only be fired once (like a Deferred)
 *
 *	memory:			will keep track of previous values and will call any callback added
 *					after the list has been fired right away with the latest "memorized"
 *					values (like a Deferred)
 *
 *	unique:			will ensure a callback can only be added once (no duplicate in the list)
 *
 *	stopOnFalse:	interrupt callings when a callback returns false
 *
 */
jQuery.Callbacks = function( options ) {

	// Convert options from String-formatted to Object-formatted if needed
	// (we check in cache first)
	options = typeof options === "string" ?
		( optionsCache[ options ] || createOptions( options ) ) :
		jQuery.extend( {}, options );

	var // Flag to know if list is currently firing
		firing,
		// Last fire value (for non-forgettable lists)
		memory,
		// Flag to know if list was already fired
		fired,
		// End of the loop when firing
		firingLength,
		// Index of currently firing callback (modified by remove if needed)
		firingIndex,
		// First callback to fire (used internally by add and fireWith)
		firingStart,
		// Actual callback list
		list = [],
		// Stack of fire calls for repeatable lists
		stack = !options.once && [],
		// Fire callbacks
		fire = function( data ) {
			memory = options.memory && data;
			fired = true;
			firingIndex = firingStart || 0;
			firingStart = 0;
			firingLength = list.length;
			firing = true;
			for ( ; list && firingIndex < firingLength; firingIndex++ ) {
				if ( list[ firingIndex ].apply( data[ 0 ], data[ 1 ] ) === false && options.stopOnFalse ) {
					memory = false; // To prevent further calls using add
					break;
				}
			}
			firing = false;
			if ( list ) {
				if ( stack ) {
					if ( stack.length ) {
						fire( stack.shift() );
					}
				} else if ( memory ) {
					list = [];
				} else {
					self.disable();
				}
			}
		},
		// Actual Callbacks object
		self = {
			// Add a callback or a collection of callbacks to the list
			add: function() {
				if ( list ) {
					// First, we save the current length
					var start = list.length;
					(function add( args ) {
						jQuery.each( args, function( _, arg ) {
							var type = jQuery.type( arg );
							if ( type === "function" ) {
								if ( !options.unique || !self.has( arg ) ) {
									list.push( arg );
								}
							} else if ( arg && arg.length && type !== "string" ) {
								// Inspect recursively
								add( arg );
							}
						});
					})( arguments );
					// Do we need to add the callbacks to the
					// current firing batch?
					if ( firing ) {
						firingLength = list.length;
					// With memory, if we're not firing then
					// we should call right away
					} else if ( memory ) {
						firingStart = start;
						fire( memory );
					}
				}
				return this;
			},
			// Remove a callback from the list
			remove: function() {
				if ( list ) {
					jQuery.each( arguments, function( _, arg ) {
						var index;
						while( ( index = jQuery.inArray( arg, list, index ) ) > -1 ) {
							list.splice( index, 1 );
							// Handle firing indexes
							if ( firing ) {
								if ( index <= firingLength ) {
									firingLength--;
								}
								if ( index <= firingIndex ) {
									firingIndex--;
								}
							}
						}
					});
				}
				return this;
			},
			// Check if a given callback is in the list.
			// If no argument is given, return whether or not list has callbacks attached.
			has: function( fn ) {
				return fn ? jQuery.inArray( fn, list ) > -1 : !!( list && list.length );
			},
			// Remove all callbacks from the list
			empty: function() {
				list = [];
				firingLength = 0;
				return this;
			},
			// Have the list do nothing anymore
			disable: function() {
				list = stack = memory = undefined;
				return this;
			},
			// Is it disabled?
			disabled: function() {
				return !list;
			},
			// Lock the list in its current state
			lock: function() {
				stack = undefined;
				if ( !memory ) {
					self.disable();
				}
				return this;
			},
			// Is it locked?
			locked: function() {
				return !stack;
			},
			// Call all callbacks with the given context and arguments
			fireWith: function( context, args ) {
				if ( list && ( !fired || stack ) ) {
					args = args || [];
					args = [ context, args.slice ? args.slice() : args ];
					if ( firing ) {
						stack.push( args );
					} else {
						fire( args );
					}
				}
				return this;
			},
			// Call all the callbacks with the given arguments
			fire: function() {
				self.fireWith( this, arguments );
				return this;
			},
			// To know if the callbacks have already been called at least once
			fired: function() {
				return !!fired;
			}
		};

	return self;
};
jQuery.extend({

	Deferred: function( func ) {
		var tuples = [
				// action, add listener, listener list, final state
				[ "resolve", "done", jQuery.Callbacks("once memory"), "resolved" ],
				[ "reject", "fail", jQuery.Callbacks("once memory"), "rejected" ],
				[ "notify", "progress", jQuery.Callbacks("memory") ]
			],
			state = "pending",
			promise = {
				state: function() {
					return state;
				},
				always: function() {
					deferred.done( arguments ).fail( arguments );
					return this;
				},
				then: function( /* fnDone, fnFail, fnProgress */ ) {
					var fns = arguments;
					return jQuery.Deferred(function( newDefer ) {
						jQuery.each( tuples, function( i, tuple ) {
							var action = tuple[ 0 ],
								fn = jQuery.isFunction( fns[ i ] ) && fns[ i ];
							// deferred[ done | fail | progress ] for forwarding actions to newDefer
							deferred[ tuple[1] ](function() {
								var returned = fn && fn.apply( this, arguments );
								if ( returned && jQuery.isFunction( returned.promise ) ) {
									returned.promise()
										.done( newDefer.resolve )
										.fail( newDefer.reject )
										.progress( newDefer.notify );
								} else {
									newDefer[ action + "With" ]( this === promise ? newDefer.promise() : this, fn ? [ returned ] : arguments );
								}
							});
						});
						fns = null;
					}).promise();
				},
				// Get a promise for this deferred
				// If obj is provided, the promise aspect is added to the object
				promise: function( obj ) {
					return obj != null ? jQuery.extend( obj, promise ) : promise;
				}
			},
			deferred = {};

		// Keep pipe for back-compat
		promise.pipe = promise.then;

		// Add list-specific methods
		jQuery.each( tuples, function( i, tuple ) {
			var list = tuple[ 2 ],
				stateString = tuple[ 3 ];

			// promise[ done | fail | progress ] = list.add
			promise[ tuple[1] ] = list.add;

			// Handle state
			if ( stateString ) {
				list.add(function() {
					// state = [ resolved | rejected ]
					state = stateString;

				// [ reject_list | resolve_list ].disable; progress_list.lock
				}, tuples[ i ^ 1 ][ 2 ].disable, tuples[ 2 ][ 2 ].lock );
			}

			// deferred[ resolve | reject | notify ]
			deferred[ tuple[0] ] = function() {
				deferred[ tuple[0] + "With" ]( this === deferred ? promise : this, arguments );
				return this;
			};
			deferred[ tuple[0] + "With" ] = list.fireWith;
		});

		// Make the deferred a promise
		promise.promise( deferred );

		// Call given func if any
		if ( func ) {
			func.call( deferred, deferred );
		}

		// All done!
		return deferred;
	},

	// Deferred helper
	when: function( subordinate /* , ..., subordinateN */ ) {
		var i = 0,
			resolveValues = core_slice.call( arguments ),
			length = resolveValues.length,

			// the count of uncompleted subordinates
			remaining = length !== 1 || ( subordinate && jQuery.isFunction( subordinate.promise ) ) ? length : 0,

			// the master Deferred. If resolveValues consist of only a single Deferred, just use that.
			deferred = remaining === 1 ? subordinate : jQuery.Deferred(),

			// Update function for both resolve and progress values
			updateFunc = function( i, contexts, values ) {
				return function( value ) {
					contexts[ i ] = this;
					values[ i ] = arguments.length > 1 ? core_slice.call( arguments ) : value;
					if( values === progressValues ) {
						deferred.notifyWith( contexts, values );
					} else if ( !( --remaining ) ) {
						deferred.resolveWith( contexts, values );
					}
				};
			},

			progressValues, progressContexts, resolveContexts;

		// add listeners to Deferred subordinates; treat others as resolved
		if ( length > 1 ) {
			progressValues = new Array( length );
			progressContexts = new Array( length );
			resolveContexts = new Array( length );
			for ( ; i < length; i++ ) {
				if ( resolveValues[ i ] && jQuery.isFunction( resolveValues[ i ].promise ) ) {
					resolveValues[ i ].promise()
						.done( updateFunc( i, resolveContexts, resolveValues ) )
						.fail( deferred.reject )
						.progress( updateFunc( i, progressContexts, progressValues ) );
				} else {
					--remaining;
				}
			}
		}

		// if we're not waiting on anything, resolve the master
		if ( !remaining ) {
			deferred.resolveWith( resolveContexts, resolveValues );
		}

		return deferred.promise();
	}
});
jQuery.support = (function( support ) {

	var all, a, input, select, fragment, opt, eventName, isSupported, i,
		div = document.createElement("div");

	// Setup
	div.setAttribute( "className", "t" );
	div.innerHTML = "  <link/><table></table><a href='/a'>a</a><input type='checkbox'/>";

	// Finish early in limited (non-browser) environments
	all = div.getElementsByTagName("*") || [];
	a = div.getElementsByTagName("a")[ 0 ];
	if ( !a || !a.style || !all.length ) {
		return support;
	}

	// First batch of tests
	select = document.createElement("select");
	opt = select.appendChild( document.createElement("option") );
	input = div.getElementsByTagName("input")[ 0 ];

	a.style.cssText = "top:1px;float:left;opacity:.5";

	// Test setAttribute on camelCase class. If it works, we need attrFixes when doing get/setAttribute (ie6/7)
	support.getSetAttribute = div.className !== "t";

	// IE strips leading whitespace when .innerHTML is used
	support.leadingWhitespace = div.firstChild.nodeType === 3;

	// Make sure that tbody elements aren't automatically inserted
	// IE will insert them into empty tables
	support.tbody = !div.getElementsByTagName("tbody").length;

	// Make sure that link elements get serialized correctly by innerHTML
	// This requires a wrapper element in IE
	support.htmlSerialize = !!div.getElementsByTagName("link").length;

	// Get the style information from getAttribute
	// (IE uses .cssText instead)
	support.style = /top/.test( a.getAttribute("style") );

	// Make sure that URLs aren't manipulated
	// (IE normalizes it by default)
	support.hrefNormalized = a.getAttribute("href") === "/a";

	// Make sure that element opacity exists
	// (IE uses filter instead)
	// Use a regex to work around a WebKit issue. See #5145
	support.opacity = /^0.5/.test( a.style.opacity );

	// Verify style float existence
	// (IE uses styleFloat instead of cssFloat)
	support.cssFloat = !!a.style.cssFloat;

	// Check the default checkbox/radio value ("" on WebKit; "on" elsewhere)
	support.checkOn = !!input.value;

	// Make sure that a selected-by-default option has a working selected property.
	// (WebKit defaults to false instead of true, IE too, if it's in an optgroup)
	support.optSelected = opt.selected;

	// Tests for enctype support on a form (#6743)
	support.enctype = !!document.createElement("form").enctype;

	// Makes sure cloning an html5 element does not cause problems
	// Where outerHTML is undefined, this still works
	support.html5Clone = document.createElement("nav").cloneNode( true ).outerHTML !== "<:nav></:nav>";

	// Will be defined later
	support.inlineBlockNeedsLayout = false;
	support.shrinkWrapBlocks = false;
	support.pixelPosition = false;
	support.deleteExpando = true;
	support.noCloneEvent = true;
	support.reliableMarginRight = true;
	support.boxSizingReliable = true;

	// Make sure checked status is properly cloned
	input.checked = true;
	support.noCloneChecked = input.cloneNode( true ).checked;

	// Make sure that the options inside disabled selects aren't marked as disabled
	// (WebKit marks them as disabled)
	select.disabled = true;
	support.optDisabled = !opt.disabled;

	// Support: IE<9
	try {
		delete div.test;
	} catch( e ) {
		support.deleteExpando = false;
	}

	// Check if we can trust getAttribute("value")
	input = document.createElement("input");
	input.setAttribute( "value", "" );
	support.input = input.getAttribute( "value" ) === "";

	// Check if an input maintains its value after becoming a radio
	input.value = "t";
	input.setAttribute( "type", "radio" );
	support.radioValue = input.value === "t";

	// #11217 - WebKit loses check when the name is after the checked attribute
	input.setAttribute( "checked", "t" );
	input.setAttribute( "name", "t" );

	fragment = document.createDocumentFragment();
	fragment.appendChild( input );

	// Check if a disconnected checkbox will retain its checked
	// value of true after appended to the DOM (IE6/7)
	support.appendChecked = input.checked;

	// WebKit doesn't clone checked state correctly in fragments
	support.checkClone = fragment.cloneNode( true ).cloneNode( true ).lastChild.checked;

	// Support: IE<9
	// Opera does not clone events (and typeof div.attachEvent === undefined).
	// IE9-10 clones events bound via attachEvent, but they don't trigger with .click()
	if ( div.attachEvent ) {
		div.attachEvent( "onclick", function() {
			support.noCloneEvent = false;
		});

		div.cloneNode( true ).click();
	}

	// Support: IE<9 (lack submit/change bubble), Firefox 17+ (lack focusin event)
	// Beware of CSP restrictions (https://developer.mozilla.org/en/Security/CSP)
	for ( i in { submit: true, change: true, focusin: true }) {
		div.setAttribute( eventName = "on" + i, "t" );

		support[ i + "Bubbles" ] = eventName in window || div.attributes[ eventName ].expando === false;
	}

	div.style.backgroundClip = "content-box";
	div.cloneNode( true ).style.backgroundClip = "";
	support.clearCloneStyle = div.style.backgroundClip === "content-box";

	// Support: IE<9
	// Iteration over object's inherited properties before its own.
	for ( i in jQuery( support ) ) {
		break;
	}
	support.ownLast = i !== "0";

	// Run tests that need a body at doc ready
	jQuery(function() {
		var container, marginDiv, tds,
			divReset = "padding:0;margin:0;border:0;display:block;box-sizing:content-box;-moz-box-sizing:content-box;-webkit-box-sizing:content-box;",
			body = document.getElementsByTagName("body")[0];

		if ( !body ) {
			// Return for frameset docs that don't have a body
			return;
		}

		container = document.createElement("div");
		container.style.cssText = "border:0;width:0;height:0;position:absolute;top:0;left:-9999px;margin-top:1px";

		body.appendChild( container ).appendChild( div );

		// Support: IE8
		// Check if table cells still have offsetWidth/Height when they are set
		// to display:none and there are still other visible table cells in a
		// table row; if so, offsetWidth/Height are not reliable for use when
		// determining if an element has been hidden directly using
		// display:none (it is still safe to use offsets if a parent element is
		// hidden; don safety goggles and see bug #4512 for more information).
		div.innerHTML = "<table><tr><td></td><td>t</td></tr></table>";
		tds = div.getElementsByTagName("td");
		tds[ 0 ].style.cssText = "padding:0;margin:0;border:0;display:none";
		isSupported = ( tds[ 0 ].offsetHeight === 0 );

		tds[ 0 ].style.display = "";
		tds[ 1 ].style.display = "none";

		// Support: IE8
		// Check if empty table cells still have offsetWidth/Height
		support.reliableHiddenOffsets = isSupported && ( tds[ 0 ].offsetHeight === 0 );

		// Check box-sizing and margin behavior.
		div.innerHTML = "";
		div.style.cssText = "box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;padding:1px;border:1px;display:block;width:4px;margin-top:1%;position:absolute;top:1%;";

		// Workaround failing boxSizing test due to offsetWidth returning wrong value
		// with some non-1 values of body zoom, ticket #13543
		jQuery.swap( body, body.style.zoom != null ? { zoom: 1 } : {}, function() {
			support.boxSizing = div.offsetWidth === 4;
		});

		// Use window.getComputedStyle because jsdom on node.js will break without it.
		if ( window.getComputedStyle ) {
			support.pixelPosition = ( window.getComputedStyle( div, null ) || {} ).top !== "1%";
			support.boxSizingReliable = ( window.getComputedStyle( div, null ) || { width: "4px" } ).width === "4px";

			// Check if div with explicit width and no margin-right incorrectly
			// gets computed margin-right based on width of container. (#3333)
			// Fails in WebKit before Feb 2011 nightlies
			// WebKit Bug 13343 - getComputedStyle returns wrong value for margin-right
			marginDiv = div.appendChild( document.createElement("div") );
			marginDiv.style.cssText = div.style.cssText = divReset;
			marginDiv.style.marginRight = marginDiv.style.width = "0";
			div.style.width = "1px";

			support.reliableMarginRight =
				!parseFloat( ( window.getComputedStyle( marginDiv, null ) || {} ).marginRight );
		}

		if ( typeof div.style.zoom !== core_strundefined ) {
			// Support: IE<8
			// Check if natively block-level elements act like inline-block
			// elements when setting their display to 'inline' and giving
			// them layout
			div.innerHTML = "";
			div.style.cssText = divReset + "width:1px;padding:1px;display:inline;zoom:1";
			support.inlineBlockNeedsLayout = ( div.offsetWidth === 3 );

			// Support: IE6
			// Check if elements with layout shrink-wrap their children
			div.style.display = "block";
			div.innerHTML = "<div></div>";
			div.firstChild.style.width = "5px";
			support.shrinkWrapBlocks = ( div.offsetWidth !== 3 );

			if ( support.inlineBlockNeedsLayout ) {
				// Prevent IE 6 from affecting layout for positioned elements #11048
				// Prevent IE from shrinking the body in IE 7 mode #12869
				// Support: IE<8
				body.style.zoom = 1;
			}
		}

		body.removeChild( container );

		// Null elements to avoid leaks in IE
		container = div = tds = marginDiv = null;
	});

	// Null elements to avoid leaks in IE
	all = select = fragment = opt = a = input = null;

	return support;
})({});

var rbrace = /(?:\{[\s\S]*\}|\[[\s\S]*\])$/,
	rmultiDash = /([A-Z])/g;

function internalData( elem, name, data, pvt /* Internal Use Only */ ){
	if ( !jQuery.acceptData( elem ) ) {
		return;
	}

	var ret, thisCache,
		internalKey = jQuery.expando,

		// We have to handle DOM nodes and JS objects differently because IE6-7
		// can't GC object references properly across the DOM-JS boundary
		isNode = elem.nodeType,

		// Only DOM nodes need the global jQuery cache; JS object data is
		// attached directly to the object so GC can occur automatically
		cache = isNode ? jQuery.cache : elem,

		// Only defining an ID for JS objects if its cache already exists allows
		// the code to shortcut on the same path as a DOM node with no cache
		id = isNode ? elem[ internalKey ] : elem[ internalKey ] && internalKey;

	// Avoid doing any more work than we need to when trying to get data on an
	// object that has no data at all
	if ( (!id || !cache[id] || (!pvt && !cache[id].data)) && data === undefined && typeof name === "string" ) {
		return;
	}

	if ( !id ) {
		// Only DOM nodes need a new unique ID for each element since their data
		// ends up in the global cache
		if ( isNode ) {
			id = elem[ internalKey ] = core_deletedIds.pop() || jQuery.guid++;
		} else {
			id = internalKey;
		}
	}

	if ( !cache[ id ] ) {
		// Avoid exposing jQuery metadata on plain JS objects when the object
		// is serialized using JSON.stringify
		cache[ id ] = isNode ? {} : { toJSON: jQuery.noop };
	}

	// An object can be passed to jQuery.data instead of a key/value pair; this gets
	// shallow copied over onto the existing cache
	if ( typeof name === "object" || typeof name === "function" ) {
		if ( pvt ) {
			cache[ id ] = jQuery.extend( cache[ id ], name );
		} else {
			cache[ id ].data = jQuery.extend( cache[ id ].data, name );
		}
	}

	thisCache = cache[ id ];

	// jQuery data() is stored in a separate object inside the object's internal data
	// cache in order to avoid key collisions between internal data and user-defined
	// data.
	if ( !pvt ) {
		if ( !thisCache.data ) {
			thisCache.data = {};
		}

		thisCache = thisCache.data;
	}

	if ( data !== undefined ) {
		thisCache[ jQuery.camelCase( name ) ] = data;
	}

	// Check for both converted-to-camel and non-converted data property names
	// If a data property was specified
	if ( typeof name === "string" ) {

		// First Try to find as-is property data
		ret = thisCache[ name ];

		// Test for null|undefined property data
		if ( ret == null ) {

			// Try to find the camelCased property
			ret = thisCache[ jQuery.camelCase( name ) ];
		}
	} else {
		ret = thisCache;
	}

	return ret;
}

function internalRemoveData( elem, name, pvt ) {
	if ( !jQuery.acceptData( elem ) ) {
		return;
	}

	var thisCache, i,
		isNode = elem.nodeType,

		// See jQuery.data for more information
		cache = isNode ? jQuery.cache : elem,
		id = isNode ? elem[ jQuery.expando ] : jQuery.expando;

	// If there is already no cache entry for this object, there is no
	// purpose in continuing
	if ( !cache[ id ] ) {
		return;
	}

	if ( name ) {

		thisCache = pvt ? cache[ id ] : cache[ id ].data;

		if ( thisCache ) {

			// Support array or space separated string names for data keys
			if ( !jQuery.isArray( name ) ) {

				// try the string as a key before any manipulation
				if ( name in thisCache ) {
					name = [ name ];
				} else {

					// split the camel cased version by spaces unless a key with the spaces exists
					name = jQuery.camelCase( name );
					if ( name in thisCache ) {
						name = [ name ];
					} else {
						name = name.split(" ");
					}
				}
			} else {
				// If "name" is an array of keys...
				// When data is initially created, via ("key", "val") signature,
				// keys will be converted to camelCase.
				// Since there is no way to tell _how_ a key was added, remove
				// both plain key and camelCase key. #12786
				// This will only penalize the array argument path.
				name = name.concat( jQuery.map( name, jQuery.camelCase ) );
			}

			i = name.length;
			while ( i-- ) {
				delete thisCache[ name[i] ];
			}

			// If there is no data left in the cache, we want to continue
			// and let the cache object itself get destroyed
			if ( pvt ? !isEmptyDataObject(thisCache) : !jQuery.isEmptyObject(thisCache) ) {
				return;
			}
		}
	}

	// See jQuery.data for more information
	if ( !pvt ) {
		delete cache[ id ].data;

		// Don't destroy the parent cache unless the internal data object
		// had been the only thing left in it
		if ( !isEmptyDataObject( cache[ id ] ) ) {
			return;
		}
	}

	// Destroy the cache
	if ( isNode ) {
		jQuery.cleanData( [ elem ], true );

	// Use delete when supported for expandos or `cache` is not a window per isWindow (#10080)
	/* jshint eqeqeq: false */
	} else if ( jQuery.support.deleteExpando || cache != cache.window ) {
		/* jshint eqeqeq: true */
		delete cache[ id ];

	// When all else fails, null
	} else {
		cache[ id ] = null;
	}
}

jQuery.extend({
	cache: {},

	// The following elements throw uncatchable exceptions if you
	// attempt to add expando properties to them.
	noData: {
		"applet": true,
		"embed": true,
		// Ban all objects except for Flash (which handle expandos)
		"object": "clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
	},

	hasData: function( elem ) {
		elem = elem.nodeType ? jQuery.cache[ elem[jQuery.expando] ] : elem[ jQuery.expando ];
		return !!elem && !isEmptyDataObject( elem );
	},

	data: function( elem, name, data ) {
		return internalData( elem, name, data );
	},

	removeData: function( elem, name ) {
		return internalRemoveData( elem, name );
	},

	// For internal use only.
	_data: function( elem, name, data ) {
		return internalData( elem, name, data, true );
	},

	_removeData: function( elem, name ) {
		return internalRemoveData( elem, name, true );
	},

	// A method for determining if a DOM node can handle the data expando
	acceptData: function( elem ) {
		// Do not set data on non-element because it will not be cleared (#8335).
		if ( elem.nodeType && elem.nodeType !== 1 && elem.nodeType !== 9 ) {
			return false;
		}

		var noData = elem.nodeName && jQuery.noData[ elem.nodeName.toLowerCase() ];

		// nodes accept data unless otherwise specified; rejection can be conditional
		return !noData || noData !== true && elem.getAttribute("classid") === noData;
	}
});

jQuery.fn.extend({
	data: function( key, value ) {
		var attrs, name,
			data = null,
			i = 0,
			elem = this[0];

		// Special expections of .data basically thwart jQuery.access,
		// so implement the relevant behavior ourselves

		// Gets all values
		if ( key === undefined ) {
			if ( this.length ) {
				data = jQuery.data( elem );

				if ( elem.nodeType === 1 && !jQuery._data( elem, "parsedAttrs" ) ) {
					attrs = elem.attributes;
					for ( ; i < attrs.length; i++ ) {
						name = attrs[i].name;

						if ( name.indexOf("data-") === 0 ) {
							name = jQuery.camelCase( name.slice(5) );

							dataAttr( elem, name, data[ name ] );
						}
					}
					jQuery._data( elem, "parsedAttrs", true );
				}
			}

			return data;
		}

		// Sets multiple values
		if ( typeof key === "object" ) {
			return this.each(function() {
				jQuery.data( this, key );
			});
		}

		return arguments.length > 1 ?

			// Sets one value
			this.each(function() {
				jQuery.data( this, key, value );
			}) :

			// Gets one value
			// Try to fetch any internally stored data first
			elem ? dataAttr( elem, key, jQuery.data( elem, key ) ) : null;
	},

	removeData: function( key ) {
		return this.each(function() {
			jQuery.removeData( this, key );
		});
	}
});

function dataAttr( elem, key, data ) {
	// If nothing was found internally, try to fetch any
	// data from the HTML5 data-* attribute
	if ( data === undefined && elem.nodeType === 1 ) {

		var name = "data-" + key.replace( rmultiDash, "-$1" ).toLowerCase();

		data = elem.getAttribute( name );

		if ( typeof data === "string" ) {
			try {
				data = data === "true" ? true :
					data === "false" ? false :
					data === "null" ? null :
					// Only convert to a number if it doesn't change the string
					+data + "" === data ? +data :
					rbrace.test( data ) ? jQuery.parseJSON( data ) :
						data;
			} catch( e ) {}

			// Make sure we set the data so it isn't changed later
			jQuery.data( elem, key, data );

		} else {
			data = undefined;
		}
	}

	return data;
}

// checks a cache object for emptiness
function isEmptyDataObject( obj ) {
	var name;
	for ( name in obj ) {

		// if the public data object is empty, the private is still empty
		if ( name === "data" && jQuery.isEmptyObject( obj[name] ) ) {
			continue;
		}
		if ( name !== "toJSON" ) {
			return false;
		}
	}

	return true;
}
jQuery.extend({
	queue: function( elem, type, data ) {
		var queue;

		if ( elem ) {
			type = ( type || "fx" ) + "queue";
			queue = jQuery._data( elem, type );

			// Speed up dequeue by getting out quickly if this is just a lookup
			if ( data ) {
				if ( !queue || jQuery.isArray(data) ) {
					queue = jQuery._data( elem, type, jQuery.makeArray(data) );
				} else {
					queue.push( data );
				}
			}
			return queue || [];
		}
	},

	dequeue: function( elem, type ) {
		type = type || "fx";

		var queue = jQuery.queue( elem, type ),
			startLength = queue.length,
			fn = queue.shift(),
			hooks = jQuery._queueHooks( elem, type ),
			next = function() {
				jQuery.dequeue( elem, type );
			};

		// If the fx queue is dequeued, always remove the progress sentinel
		if ( fn === "inprogress" ) {
			fn = queue.shift();
			startLength--;
		}

		if ( fn ) {

			// Add a progress sentinel to prevent the fx queue from being
			// automatically dequeued
			if ( type === "fx" ) {
				queue.unshift( "inprogress" );
			}

			// clear up the last queue stop function
			delete hooks.stop;
			fn.call( elem, next, hooks );
		}

		if ( !startLength && hooks ) {
			hooks.empty.fire();
		}
	},

	// not intended for public consumption - generates a queueHooks object, or returns the current one
	_queueHooks: function( elem, type ) {
		var key = type + "queueHooks";
		return jQuery._data( elem, key ) || jQuery._data( elem, key, {
			empty: jQuery.Callbacks("once memory").add(function() {
				jQuery._removeData( elem, type + "queue" );
				jQuery._removeData( elem, key );
			})
		});
	}
});

jQuery.fn.extend({
	queue: function( type, data ) {
		var setter = 2;

		if ( typeof type !== "string" ) {
			data = type;
			type = "fx";
			setter--;
		}

		if ( arguments.length < setter ) {
			return jQuery.queue( this[0], type );
		}

		return data === undefined ?
			this :
			this.each(function() {
				var queue = jQuery.queue( this, type, data );

				// ensure a hooks for this queue
				jQuery._queueHooks( this, type );

				if ( type === "fx" && queue[0] !== "inprogress" ) {
					jQuery.dequeue( this, type );
				}
			});
	},
	dequeue: function( type ) {
		return this.each(function() {
			jQuery.dequeue( this, type );
		});
	},
	// Based off of the plugin by Clint Helfers, with permission.
	// http://blindsignals.com/index.php/2009/07/jquery-delay/
	delay: function( time, type ) {
		time = jQuery.fx ? jQuery.fx.speeds[ time ] || time : time;
		type = type || "fx";

		return this.queue( type, function( next, hooks ) {
			var timeout = setTimeout( next, time );
			hooks.stop = function() {
				clearTimeout( timeout );
			};
		});
	},
	clearQueue: function( type ) {
		return this.queue( type || "fx", [] );
	},
	// Get a promise resolved when queues of a certain type
	// are emptied (fx is the type by default)
	promise: function( type, obj ) {
		var tmp,
			count = 1,
			defer = jQuery.Deferred(),
			elements = this,
			i = this.length,
			resolve = function() {
				if ( !( --count ) ) {
					defer.resolveWith( elements, [ elements ] );
				}
			};

		if ( typeof type !== "string" ) {
			obj = type;
			type = undefined;
		}
		type = type || "fx";

		while( i-- ) {
			tmp = jQuery._data( elements[ i ], type + "queueHooks" );
			if ( tmp && tmp.empty ) {
				count++;
				tmp.empty.add( resolve );
			}
		}
		resolve();
		return defer.promise( obj );
	}
});
var nodeHook, boolHook,
	rclass = /[\t\r\n\f]/g,
	rreturn = /\r/g,
	rfocusable = /^(?:input|select|textarea|button|object)$/i,
	rclickable = /^(?:a|area)$/i,
	ruseDefault = /^(?:checked|selected)$/i,
	getSetAttribute = jQuery.support.getSetAttribute,
	getSetInput = jQuery.support.input;

jQuery.fn.extend({
	attr: function( name, value ) {
		return jQuery.access( this, jQuery.attr, name, value, arguments.length > 1 );
	},

	removeAttr: function( name ) {
		return this.each(function() {
			jQuery.removeAttr( this, name );
		});
	},

	prop: function( name, value ) {
		return jQuery.access( this, jQuery.prop, name, value, arguments.length > 1 );
	},

	removeProp: function( name ) {
		name = jQuery.propFix[ name ] || name;
		return this.each(function() {
			// try/catch handles cases where IE balks (such as removing a property on window)
			try {
				this[ name ] = undefined;
				delete this[ name ];
			} catch( e ) {}
		});
	},

	addClass: function( value ) {
		var classes, elem, cur, clazz, j,
			i = 0,
			len = this.length,
			proceed = typeof value === "string" && value;

		if ( jQuery.isFunction( value ) ) {
			return this.each(function( j ) {
				jQuery( this ).addClass( value.call( this, j, this.className ) );
			});
		}

		if ( proceed ) {
			// The disjunction here is for better compressibility (see removeClass)
			classes = ( value || "" ).match( core_rnotwhite ) || [];

			for ( ; i < len; i++ ) {
				elem = this[ i ];
				cur = elem.nodeType === 1 && ( elem.className ?
					( " " + elem.className + " " ).replace( rclass, " " ) :
					" "
				);

				if ( cur ) {
					j = 0;
					while ( (clazz = classes[j++]) ) {
						if ( cur.indexOf( " " + clazz + " " ) < 0 ) {
							cur += clazz + " ";
						}
					}
					elem.className = jQuery.trim( cur );

				}
			}
		}

		return this;
	},

	removeClass: function( value ) {
		var classes, elem, cur, clazz, j,
			i = 0,
			len = this.length,
			proceed = arguments.length === 0 || typeof value === "string" && value;

		if ( jQuery.isFunction( value ) ) {
			return this.each(function( j ) {
				jQuery( this ).removeClass( value.call( this, j, this.className ) );
			});
		}
		if ( proceed ) {
			classes = ( value || "" ).match( core_rnotwhite ) || [];

			for ( ; i < len; i++ ) {
				elem = this[ i ];
				// This expression is here for better compressibility (see addClass)
				cur = elem.nodeType === 1 && ( elem.className ?
					( " " + elem.className + " " ).replace( rclass, " " ) :
					""
				);

				if ( cur ) {
					j = 0;
					while ( (clazz = classes[j++]) ) {
						// Remove *all* instances
						while ( cur.indexOf( " " + clazz + " " ) >= 0 ) {
							cur = cur.replace( " " + clazz + " ", " " );
						}
					}
					elem.className = value ? jQuery.trim( cur ) : "";
				}
			}
		}

		return this;
	},

	toggleClass: function( value, stateVal ) {
		var type = typeof value;

		if ( typeof stateVal === "boolean" && type === "string" ) {
			return stateVal ? this.addClass( value ) : this.removeClass( value );
		}

		if ( jQuery.isFunction( value ) ) {
			return this.each(function( i ) {
				jQuery( this ).toggleClass( value.call(this, i, this.className, stateVal), stateVal );
			});
		}

		return this.each(function() {
			if ( type === "string" ) {
				// toggle individual class names
				var className,
					i = 0,
					self = jQuery( this ),
					classNames = value.match( core_rnotwhite ) || [];

				while ( (className = classNames[ i++ ]) ) {
					// check each className given, space separated list
					if ( self.hasClass( className ) ) {
						self.removeClass( className );
					} else {
						self.addClass( className );
					}
				}

			// Toggle whole class name
			} else if ( type === core_strundefined || type === "boolean" ) {
				if ( this.className ) {
					// store className if set
					jQuery._data( this, "__className__", this.className );
				}

				// If the element has a class name or if we're passed "false",
				// then remove the whole classname (if there was one, the above saved it).
				// Otherwise bring back whatever was previously saved (if anything),
				// falling back to the empty string if nothing was stored.
				this.className = this.className || value === false ? "" : jQuery._data( this, "__className__" ) || "";
			}
		});
	},

	hasClass: function( selector ) {
		var className = " " + selector + " ",
			i = 0,
			l = this.length;
		for ( ; i < l; i++ ) {
			if ( this[i].nodeType === 1 && (" " + this[i].className + " ").replace(rclass, " ").indexOf( className ) >= 0 ) {
				return true;
			}
		}

		return false;
	},

	val: function( value ) {
		var ret, hooks, isFunction,
			elem = this[0];

		if ( !arguments.length ) {
			if ( elem ) {
				hooks = jQuery.valHooks[ elem.type ] || jQuery.valHooks[ elem.nodeName.toLowerCase() ];

				if ( hooks && "get" in hooks && (ret = hooks.get( elem, "value" )) !== undefined ) {
					return ret;
				}

				ret = elem.value;

				return typeof ret === "string" ?
					// handle most common string cases
					ret.replace(rreturn, "") :
					// handle cases where value is null/undef or number
					ret == null ? "" : ret;
			}

			return;
		}

		isFunction = jQuery.isFunction( value );

		return this.each(function( i ) {
			var val;

			if ( this.nodeType !== 1 ) {
				return;
			}

			if ( isFunction ) {
				val = value.call( this, i, jQuery( this ).val() );
			} else {
				val = value;
			}

			// Treat null/undefined as ""; convert numbers to string
			if ( val == null ) {
				val = "";
			} else if ( typeof val === "number" ) {
				val += "";
			} else if ( jQuery.isArray( val ) ) {
				val = jQuery.map(val, function ( value ) {
					return value == null ? "" : value + "";
				});
			}

			hooks = jQuery.valHooks[ this.type ] || jQuery.valHooks[ this.nodeName.toLowerCase() ];

			// If set returns undefined, fall back to normal setting
			if ( !hooks || !("set" in hooks) || hooks.set( this, val, "value" ) === undefined ) {
				this.value = val;
			}
		});
	}
});

jQuery.extend({
	valHooks: {
		option: {
			get: function( elem ) {
				// Use proper attribute retrieval(#6932, #12072)
				var val = jQuery.find.attr( elem, "value" );
				return val != null ?
					val :
					elem.text;
			}
		},
		select: {
			get: function( elem ) {
				var value, option,
					options = elem.options,
					index = elem.selectedIndex,
					one = elem.type === "select-one" || index < 0,
					values = one ? null : [],
					max = one ? index + 1 : options.length,
					i = index < 0 ?
						max :
						one ? index : 0;

				// Loop through all the selected options
				for ( ; i < max; i++ ) {
					option = options[ i ];

					// oldIE doesn't update selected after form reset (#2551)
					if ( ( option.selected || i === index ) &&
							// Don't return options that are disabled or in a disabled optgroup
							( jQuery.support.optDisabled ? !option.disabled : option.getAttribute("disabled") === null ) &&
							( !option.parentNode.disabled || !jQuery.nodeName( option.parentNode, "optgroup" ) ) ) {

						// Get the specific value for the option
						value = jQuery( option ).val();

						// We don't need an array for one selects
						if ( one ) {
							return value;
						}

						// Multi-Selects return an array
						values.push( value );
					}
				}

				return values;
			},

			set: function( elem, value ) {
				var optionSet, option,
					options = elem.options,
					values = jQuery.makeArray( value ),
					i = options.length;

				while ( i-- ) {
					option = options[ i ];
					if ( (option.selected = jQuery.inArray( jQuery(option).val(), values ) >= 0) ) {
						optionSet = true;
					}
				}

				// force browsers to behave consistently when non-matching value is set
				if ( !optionSet ) {
					elem.selectedIndex = -1;
				}
				return values;
			}
		}
	},

	attr: function( elem, name, value ) {
		var hooks, ret,
			nType = elem.nodeType;

		// don't get/set attributes on text, comment and attribute nodes
		if ( !elem || nType === 3 || nType === 8 || nType === 2 ) {
			return;
		}

		// Fallback to prop when attributes are not supported
		if ( typeof elem.getAttribute === core_strundefined ) {
			return jQuery.prop( elem, name, value );
		}

		// All attributes are lowercase
		// Grab necessary hook if one is defined
		if ( nType !== 1 || !jQuery.isXMLDoc( elem ) ) {
			name = name.toLowerCase();
			hooks = jQuery.attrHooks[ name ] ||
				( jQuery.expr.match.bool.test( name ) ? boolHook : nodeHook );
		}

		if ( value !== undefined ) {

			if ( value === null ) {
				jQuery.removeAttr( elem, name );

			} else if ( hooks && "set" in hooks && (ret = hooks.set( elem, value, name )) !== undefined ) {
				return ret;

			} else {
				elem.setAttribute( name, value + "" );
				return value;
			}

		} else if ( hooks && "get" in hooks && (ret = hooks.get( elem, name )) !== null ) {
			return ret;

		} else {
			ret = jQuery.find.attr( elem, name );

			// Non-existent attributes return null, we normalize to undefined
			return ret == null ?
				undefined :
				ret;
		}
	},

	removeAttr: function( elem, value ) {
		var name, propName,
			i = 0,
			attrNames = value && value.match( core_rnotwhite );

		if ( attrNames && elem.nodeType === 1 ) {
			while ( (name = attrNames[i++]) ) {
				propName = jQuery.propFix[ name ] || name;

				// Boolean attributes get special treatment (#10870)
				if ( jQuery.expr.match.bool.test( name ) ) {
					// Set corresponding property to false
					if ( getSetInput && getSetAttribute || !ruseDefault.test( name ) ) {
						elem[ propName ] = false;
					// Support: IE<9
					// Also clear defaultChecked/defaultSelected (if appropriate)
					} else {
						elem[ jQuery.camelCase( "default-" + name ) ] =
							elem[ propName ] = false;
					}

				// See #9699 for explanation of this approach (setting first, then removal)
				} else {
					jQuery.attr( elem, name, "" );
				}

				elem.removeAttribute( getSetAttribute ? name : propName );
			}
		}
	},

	attrHooks: {
		type: {
			set: function( elem, value ) {
				if ( !jQuery.support.radioValue && value === "radio" && jQuery.nodeName(elem, "input") ) {
					// Setting the type on a radio button after the value resets the value in IE6-9
					// Reset value to default in case type is set after value during creation
					var val = elem.value;
					elem.setAttribute( "type", value );
					if ( val ) {
						elem.value = val;
					}
					return value;
				}
			}
		}
	},

	propFix: {
		"for": "htmlFor",
		"class": "className"
	},

	prop: function( elem, name, value ) {
		var ret, hooks, notxml,
			nType = elem.nodeType;

		// don't get/set properties on text, comment and attribute nodes
		if ( !elem || nType === 3 || nType === 8 || nType === 2 ) {
			return;
		}

		notxml = nType !== 1 || !jQuery.isXMLDoc( elem );

		if ( notxml ) {
			// Fix name and attach hooks
			name = jQuery.propFix[ name ] || name;
			hooks = jQuery.propHooks[ name ];
		}

		if ( value !== undefined ) {
			return hooks && "set" in hooks && (ret = hooks.set( elem, value, name )) !== undefined ?
				ret :
				( elem[ name ] = value );

		} else {
			return hooks && "get" in hooks && (ret = hooks.get( elem, name )) !== null ?
				ret :
				elem[ name ];
		}
	},

	propHooks: {
		tabIndex: {
			get: function( elem ) {
				// elem.tabIndex doesn't always return the correct value when it hasn't been explicitly set
				// http://fluidproject.org/blog/2008/01/09/getting-setting-and-removing-tabindex-values-with-javascript/
				// Use proper attribute retrieval(#12072)
				var tabindex = jQuery.find.attr( elem, "tabindex" );

				return tabindex ?
					parseInt( tabindex, 10 ) :
					rfocusable.test( elem.nodeName ) || rclickable.test( elem.nodeName ) && elem.href ?
						0 :
						-1;
			}
		}
	}
});

// Hooks for boolean attributes
boolHook = {
	set: function( elem, value, name ) {
		if ( value === false ) {
			// Remove boolean attributes when set to false
			jQuery.removeAttr( elem, name );
		} else if ( getSetInput && getSetAttribute || !ruseDefault.test( name ) ) {
			// IE<8 needs the *property* name
			elem.setAttribute( !getSetAttribute && jQuery.propFix[ name ] || name, name );

		// Use defaultChecked and defaultSelected for oldIE
		} else {
			elem[ jQuery.camelCase( "default-" + name ) ] = elem[ name ] = true;
		}

		return name;
	}
};
jQuery.each( jQuery.expr.match.bool.source.match( /\w+/g ), function( i, name ) {
	var getter = jQuery.expr.attrHandle[ name ] || jQuery.find.attr;

	jQuery.expr.attrHandle[ name ] = getSetInput && getSetAttribute || !ruseDefault.test( name ) ?
		function( elem, name, isXML ) {
			var fn = jQuery.expr.attrHandle[ name ],
				ret = isXML ?
					undefined :
					/* jshint eqeqeq: false */
					(jQuery.expr.attrHandle[ name ] = undefined) !=
						getter( elem, name, isXML ) ?

						name.toLowerCase() :
						null;
			jQuery.expr.attrHandle[ name ] = fn;
			return ret;
		} :
		function( elem, name, isXML ) {
			return isXML ?
				undefined :
				elem[ jQuery.camelCase( "default-" + name ) ] ?
					name.toLowerCase() :
					null;
		};
});

// fix oldIE attroperties
if ( !getSetInput || !getSetAttribute ) {
	jQuery.attrHooks.value = {
		set: function( elem, value, name ) {
			if ( jQuery.nodeName( elem, "input" ) ) {
				// Does not return so that setAttribute is also used
				elem.defaultValue = value;
			} else {
				// Use nodeHook if defined (#1954); otherwise setAttribute is fine
				return nodeHook && nodeHook.set( elem, value, name );
			}
		}
	};
}

// IE6/7 do not support getting/setting some attributes with get/setAttribute
if ( !getSetAttribute ) {

	// Use this for any attribute in IE6/7
	// This fixes almost every IE6/7 issue
	nodeHook = {
		set: function( elem, value, name ) {
			// Set the existing or create a new attribute node
			var ret = elem.getAttributeNode( name );
			if ( !ret ) {
				elem.setAttributeNode(
					(ret = elem.ownerDocument.createAttribute( name ))
				);
			}

			ret.value = value += "";

			// Break association with cloned elements by also using setAttribute (#9646)
			return name === "value" || value === elem.getAttribute( name ) ?
				value :
				undefined;
		}
	};
	jQuery.expr.attrHandle.id = jQuery.expr.attrHandle.name = jQuery.expr.attrHandle.coords =
		// Some attributes are constructed with empty-string values when not defined
		function( elem, name, isXML ) {
			var ret;
			return isXML ?
				undefined :
				(ret = elem.getAttributeNode( name )) && ret.value !== "" ?
					ret.value :
					null;
		};
	jQuery.valHooks.button = {
		get: function( elem, name ) {
			var ret = elem.getAttributeNode( name );
			return ret && ret.specified ?
				ret.value :
				undefined;
		},
		set: nodeHook.set
	};

	// Set contenteditable to false on removals(#10429)
	// Setting to empty string throws an error as an invalid value
	jQuery.attrHooks.contenteditable = {
		set: function( elem, value, name ) {
			nodeHook.set( elem, value === "" ? false : value, name );
		}
	};

	// Set width and height to auto instead of 0 on empty string( Bug #8150 )
	// This is for removals
	jQuery.each([ "width", "height" ], function( i, name ) {
		jQuery.attrHooks[ name ] = {
			set: function( elem, value ) {
				if ( value === "" ) {
					elem.setAttribute( name, "auto" );
					return value;
				}
			}
		};
	});
}


// Some attributes require a special call on IE
// http://msdn.microsoft.com/en-us/library/ms536429%28VS.85%29.aspx
if ( !jQuery.support.hrefNormalized ) {
	// href/src property should get the full normalized URL (#10299/#12915)
	jQuery.each([ "href", "src" ], function( i, name ) {
		jQuery.propHooks[ name ] = {
			get: function( elem ) {
				return elem.getAttribute( name, 4 );
			}
		};
	});
}

if ( !jQuery.support.style ) {
	jQuery.attrHooks.style = {
		get: function( elem ) {
			// Return undefined in the case of empty string
			// Note: IE uppercases css property names, but if we were to .toLowerCase()
			// .cssText, that would destroy case senstitivity in URL's, like in "background"
			return elem.style.cssText || undefined;
		},
		set: function( elem, value ) {
			return ( elem.style.cssText = value + "" );
		}
	};
}

// Safari mis-reports the default selected property of an option
// Accessing the parent's selectedIndex property fixes it
if ( !jQuery.support.optSelected ) {
	jQuery.propHooks.selected = {
		get: function( elem ) {
			var parent = elem.parentNode;

			if ( parent ) {
				parent.selectedIndex;

				// Make sure that it also works with optgroups, see #5701
				if ( parent.parentNode ) {
					parent.parentNode.selectedIndex;
				}
			}
			return null;
		}
	};
}

jQuery.each([
	"tabIndex",
	"readOnly",
	"maxLength",
	"cellSpacing",
	"cellPadding",
	"rowSpan",
	"colSpan",
	"useMap",
	"frameBorder",
	"contentEditable"
], function() {
	jQuery.propFix[ this.toLowerCase() ] = this;
});

// IE6/7 call enctype encoding
if ( !jQuery.support.enctype ) {
	jQuery.propFix.enctype = "encoding";
}

// Radios and checkboxes getter/setter
jQuery.each([ "radio", "checkbox" ], function() {
	jQuery.valHooks[ this ] = {
		set: function( elem, value ) {
			if ( jQuery.isArray( value ) ) {
				return ( elem.checked = jQuery.inArray( jQuery(elem).val(), value ) >= 0 );
			}
		}
	};
	if ( !jQuery.support.checkOn ) {
		jQuery.valHooks[ this ].get = function( elem ) {
			// Support: Webkit
			// "" is returned instead of "on" if a value isn't specified
			return elem.getAttribute("value") === null ? "on" : elem.value;
		};
	}
});
var rformElems = /^(?:input|select|textarea)$/i,
	rkeyEvent = /^key/,
	rmouseEvent = /^(?:mouse|contextmenu)|click/,
	rfocusMorph = /^(?:focusinfocus|focusoutblur)$/,
	rtypenamespace = /^([^.]*)(?:\.(.+)|)$/;

function returnTrue() {
	return true;
}

function returnFalse() {
	return false;
}

function safeActiveElement() {
	try {
		return document.activeElement;
	} catch ( err ) { }
}

/*
 * Helper functions for managing events -- not part of the public interface.
 * Props to Dean Edwards' addEvent library for many of the ideas.
 */
jQuery.event = {

	global: {},

	add: function( elem, types, handler, data, selector ) {
		var tmp, events, t, handleObjIn,
			special, eventHandle, handleObj,
			handlers, type, namespaces, origType,
			elemData = jQuery._data( elem );

		// Don't attach events to noData or text/comment nodes (but allow plain objects)
		if ( !elemData ) {
			return;
		}

		// Caller can pass in an object of custom data in lieu of the handler
		if ( handler.handler ) {
			handleObjIn = handler;
			handler = handleObjIn.handler;
			selector = handleObjIn.selector;
		}

		// Make sure that the handler has a unique ID, used to find/remove it later
		if ( !handler.guid ) {
			handler.guid = jQuery.guid++;
		}

		// Init the element's event structure and main handler, if this is the first
		if ( !(events = elemData.events) ) {
			events = elemData.events = {};
		}
		if ( !(eventHandle = elemData.handle) ) {
			eventHandle = elemData.handle = function( e ) {
				// Discard the second event of a jQuery.event.trigger() and
				// when an event is called after a page has unloaded
				return typeof jQuery !== core_strundefined && (!e || jQuery.event.triggered !== e.type) ?
					jQuery.event.dispatch.apply( eventHandle.elem, arguments ) :
					undefined;
			};
			// Add elem as a property of the handle fn to prevent a memory leak with IE non-native events
			eventHandle.elem = elem;
		}

		// Handle multiple events separated by a space
		types = ( types || "" ).match( core_rnotwhite ) || [""];
		t = types.length;
		while ( t-- ) {
			tmp = rtypenamespace.exec( types[t] ) || [];
			type = origType = tmp[1];
			namespaces = ( tmp[2] || "" ).split( "." ).sort();

			// There *must* be a type, no attaching namespace-only handlers
			if ( !type ) {
				continue;
			}

			// If event changes its type, use the special event handlers for the changed type
			special = jQuery.event.special[ type ] || {};

			// If selector defined, determine special event api type, otherwise given type
			type = ( selector ? special.delegateType : special.bindType ) || type;

			// Update special based on newly reset type
			special = jQuery.event.special[ type ] || {};

			// handleObj is passed to all event handlers
			handleObj = jQuery.extend({
				type: type,
				origType: origType,
				data: data,
				handler: handler,
				guid: handler.guid,
				selector: selector,
				needsContext: selector && jQuery.expr.match.needsContext.test( selector ),
				namespace: namespaces.join(".")
			}, handleObjIn );

			// Init the event handler queue if we're the first
			if ( !(handlers = events[ type ]) ) {
				handlers = events[ type ] = [];
				handlers.delegateCount = 0;

				// Only use addEventListener/attachEvent if the special events handler returns false
				if ( !special.setup || special.setup.call( elem, data, namespaces, eventHandle ) === false ) {
					// Bind the global event handler to the element
					if ( elem.addEventListener ) {
						elem.addEventListener( type, eventHandle, false );

					} else if ( elem.attachEvent ) {
						elem.attachEvent( "on" + type, eventHandle );
					}
				}
			}

			if ( special.add ) {
				special.add.call( elem, handleObj );

				if ( !handleObj.handler.guid ) {
					handleObj.handler.guid = handler.guid;
				}
			}

			// Add to the element's handler list, delegates in front
			if ( selector ) {
				handlers.splice( handlers.delegateCount++, 0, handleObj );
			} else {
				handlers.push( handleObj );
			}

			// Keep track of which events have ever been used, for event optimization
			jQuery.event.global[ type ] = true;
		}

		// Nullify elem to prevent memory leaks in IE
		elem = null;
	},

	// Detach an event or set of events from an element
	remove: function( elem, types, handler, selector, mappedTypes ) {
		var j, handleObj, tmp,
			origCount, t, events,
			special, handlers, type,
			namespaces, origType,
			elemData = jQuery.hasData( elem ) && jQuery._data( elem );

		if ( !elemData || !(events = elemData.events) ) {
			return;
		}

		// Once for each type.namespace in types; type may be omitted
		types = ( types || "" ).match( core_rnotwhite ) || [""];
		t = types.length;
		while ( t-- ) {
			tmp = rtypenamespace.exec( types[t] ) || [];
			type = origType = tmp[1];
			namespaces = ( tmp[2] || "" ).split( "." ).sort();

			// Unbind all events (on this namespace, if provided) for the element
			if ( !type ) {
				for ( type in events ) {
					jQuery.event.remove( elem, type + types[ t ], handler, selector, true );
				}
				continue;
			}

			special = jQuery.event.special[ type ] || {};
			type = ( selector ? special.delegateType : special.bindType ) || type;
			handlers = events[ type ] || [];
			tmp = tmp[2] && new RegExp( "(^|\\.)" + namespaces.join("\\.(?:.*\\.|)") + "(\\.|$)" );

			// Remove matching events
			origCount = j = handlers.length;
			while ( j-- ) {
				handleObj = handlers[ j ];

				if ( ( mappedTypes || origType === handleObj.origType ) &&
					( !handler || handler.guid === handleObj.guid ) &&
					( !tmp || tmp.test( handleObj.namespace ) ) &&
					( !selector || selector === handleObj.selector || selector === "**" && handleObj.selector ) ) {
					handlers.splice( j, 1 );

					if ( handleObj.selector ) {
						handlers.delegateCount--;
					}
					if ( special.remove ) {
						special.remove.call( elem, handleObj );
					}
				}
			}

			// Remove generic event handler if we removed something and no more handlers exist
			// (avoids potential for endless recursion during removal of special event handlers)
			if ( origCount && !handlers.length ) {
				if ( !special.teardown || special.teardown.call( elem, namespaces, elemData.handle ) === false ) {
					jQuery.removeEvent( elem, type, elemData.handle );
				}

				delete events[ type ];
			}
		}

		// Remove the expando if it's no longer used
		if ( jQuery.isEmptyObject( events ) ) {
			delete elemData.handle;

			// removeData also checks for emptiness and clears the expando if empty
			// so use it instead of delete
			jQuery._removeData( elem, "events" );
		}
	},

	trigger: function( event, data, elem, onlyHandlers ) {
		var handle, ontype, cur,
			bubbleType, special, tmp, i,
			eventPath = [ elem || document ],
			type = core_hasOwn.call( event, "type" ) ? event.type : event,
			namespaces = core_hasOwn.call( event, "namespace" ) ? event.namespace.split(".") : [];

		cur = tmp = elem = elem || document;

		// Don't do events on text and comment nodes
		if ( elem.nodeType === 3 || elem.nodeType === 8 ) {
			return;
		}

		// focus/blur morphs to focusin/out; ensure we're not firing them right now
		if ( rfocusMorph.test( type + jQuery.event.triggered ) ) {
			return;
		}

		if ( type.indexOf(".") >= 0 ) {
			// Namespaced trigger; create a regexp to match event type in handle()
			namespaces = type.split(".");
			type = namespaces.shift();
			namespaces.sort();
		}
		ontype = type.indexOf(":") < 0 && "on" + type;

		// Caller can pass in a jQuery.Event object, Object, or just an event type string
		event = event[ jQuery.expando ] ?
			event :
			new jQuery.Event( type, typeof event === "object" && event );

		// Trigger bitmask: & 1 for native handlers; & 2 for jQuery (always true)
		event.isTrigger = onlyHandlers ? 2 : 3;
		event.namespace = namespaces.join(".");
		event.namespace_re = event.namespace ?
			new RegExp( "(^|\\.)" + namespaces.join("\\.(?:.*\\.|)") + "(\\.|$)" ) :
			null;

		// Clean up the event in case it is being reused
		event.result = undefined;
		if ( !event.target ) {
			event.target = elem;
		}

		// Clone any incoming data and prepend the event, creating the handler arg list
		data = data == null ?
			[ event ] :
			jQuery.makeArray( data, [ event ] );

		// Allow special events to draw outside the lines
		special = jQuery.event.special[ type ] || {};
		if ( !onlyHandlers && special.trigger && special.trigger.apply( elem, data ) === false ) {
			return;
		}

		// Determine event propagation path in advance, per W3C events spec (#9951)
		// Bubble up to document, then to window; watch for a global ownerDocument var (#9724)
		if ( !onlyHandlers && !special.noBubble && !jQuery.isWindow( elem ) ) {

			bubbleType = special.delegateType || type;
			if ( !rfocusMorph.test( bubbleType + type ) ) {
				cur = cur.parentNode;
			}
			for ( ; cur; cur = cur.parentNode ) {
				eventPath.push( cur );
				tmp = cur;
			}

			// Only add window if we got to document (e.g., not plain obj or detached DOM)
			if ( tmp === (elem.ownerDocument || document) ) {
				eventPath.push( tmp.defaultView || tmp.parentWindow || window );
			}
		}

		// Fire handlers on the event path
		i = 0;
		while ( (cur = eventPath[i++]) && !event.isPropagationStopped() ) {

			event.type = i > 1 ?
				bubbleType :
				special.bindType || type;

			// jQuery handler
			handle = ( jQuery._data( cur, "events" ) || {} )[ event.type ] && jQuery._data( cur, "handle" );
			if ( handle ) {
				handle.apply( cur, data );
			}

			// Native handler
			handle = ontype && cur[ ontype ];
			if ( handle && jQuery.acceptData( cur ) && handle.apply && handle.apply( cur, data ) === false ) {
				event.preventDefault();
			}
		}
		event.type = type;

		// If nobody prevented the default action, do it now
		if ( !onlyHandlers && !event.isDefaultPrevented() ) {

			if ( (!special._default || special._default.apply( eventPath.pop(), data ) === false) &&
				jQuery.acceptData( elem ) ) {

				// Call a native DOM method on the target with the same name name as the event.
				// Can't use an .isFunction() check here because IE6/7 fails that test.
				// Don't do default actions on window, that's where global variables be (#6170)
				if ( ontype && elem[ type ] && !jQuery.isWindow( elem ) ) {

					// Don't re-trigger an onFOO event when we call its FOO() method
					tmp = elem[ ontype ];

					if ( tmp ) {
						elem[ ontype ] = null;
					}

					// Prevent re-triggering of the same event, since we already bubbled it above
					jQuery.event.triggered = type;
					try {
						elem[ type ]();
					} catch ( e ) {
						// IE<9 dies on focus/blur to hidden element (#1486,#12518)
						// only reproducible on winXP IE8 native, not IE9 in IE8 mode
					}
					jQuery.event.triggered = undefined;

					if ( tmp ) {
						elem[ ontype ] = tmp;
					}
				}
			}
		}

		return event.result;
	},

	dispatch: function( event ) {

		// Make a writable jQuery.Event from the native event object
		event = jQuery.event.fix( event );

		var i, ret, handleObj, matched, j,
			handlerQueue = [],
			args = core_slice.call( arguments ),
			handlers = ( jQuery._data( this, "events" ) || {} )[ event.type ] || [],
			special = jQuery.event.special[ event.type ] || {};

		// Use the fix-ed jQuery.Event rather than the (read-only) native event
		args[0] = event;
		event.delegateTarget = this;

		// Call the preDispatch hook for the mapped type, and let it bail if desired
		if ( special.preDispatch && special.preDispatch.call( this, event ) === false ) {
			return;
		}

		// Determine handlers
		handlerQueue = jQuery.event.handlers.call( this, event, handlers );

		// Run delegates first; they may want to stop propagation beneath us
		i = 0;
		while ( (matched = handlerQueue[ i++ ]) && !event.isPropagationStopped() ) {
			event.currentTarget = matched.elem;

			j = 0;
			while ( (handleObj = matched.handlers[ j++ ]) && !event.isImmediatePropagationStopped() ) {

				// Triggered event must either 1) have no namespace, or
				// 2) have namespace(s) a subset or equal to those in the bound event (both can have no namespace).
				if ( !event.namespace_re || event.namespace_re.test( handleObj.namespace ) ) {

					event.handleObj = handleObj;
					event.data = handleObj.data;

					ret = ( (jQuery.event.special[ handleObj.origType ] || {}).handle || handleObj.handler )
							.apply( matched.elem, args );

					if ( ret !== undefined ) {
						if ( (event.result = ret) === false ) {
							event.preventDefault();
							event.stopPropagation();
						}
					}
				}
			}
		}

		// Call the postDispatch hook for the mapped type
		if ( special.postDispatch ) {
			special.postDispatch.call( this, event );
		}

		return event.result;
	},

	handlers: function( event, handlers ) {
		var sel, handleObj, matches, i,
			handlerQueue = [],
			delegateCount = handlers.delegateCount,
			cur = event.target;

		// Find delegate handlers
		// Black-hole SVG <use> instance trees (#13180)
		// Avoid non-left-click bubbling in Firefox (#3861)
		if ( delegateCount && cur.nodeType && (!event.button || event.type !== "click") ) {

			/* jshint eqeqeq: false */
			for ( ; cur != this; cur = cur.parentNode || this ) {
				/* jshint eqeqeq: true */

				// Don't check non-elements (#13208)
				// Don't process clicks on disabled elements (#6911, #8165, #11382, #11764)
				if ( cur.nodeType === 1 && (cur.disabled !== true || event.type !== "click") ) {
					matches = [];
					for ( i = 0; i < delegateCount; i++ ) {
						handleObj = handlers[ i ];

						// Don't conflict with Object.prototype properties (#13203)
						sel = handleObj.selector + " ";

						if ( matches[ sel ] === undefined ) {
							matches[ sel ] = handleObj.needsContext ?
								jQuery( sel, this ).index( cur ) >= 0 :
								jQuery.find( sel, this, null, [ cur ] ).length;
						}
						if ( matches[ sel ] ) {
							matches.push( handleObj );
						}
					}
					if ( matches.length ) {
						handlerQueue.push({ elem: cur, handlers: matches });
					}
				}
			}
		}

		// Add the remaining (directly-bound) handlers
		if ( delegateCount < handlers.length ) {
			handlerQueue.push({ elem: this, handlers: handlers.slice( delegateCount ) });
		}

		return handlerQueue;
	},

	fix: function( event ) {
		if ( event[ jQuery.expando ] ) {
			return event;
		}

		// Create a writable copy of the event object and normalize some properties
		var i, prop, copy,
			type = event.type,
			originalEvent = event,
			fixHook = this.fixHooks[ type ];

		if ( !fixHook ) {
			this.fixHooks[ type ] = fixHook =
				rmouseEvent.test( type ) ? this.mouseHooks :
				rkeyEvent.test( type ) ? this.keyHooks :
				{};
		}
		copy = fixHook.props ? this.props.concat( fixHook.props ) : this.props;

		event = new jQuery.Event( originalEvent );

		i = copy.length;
		while ( i-- ) {
			prop = copy[ i ];
			event[ prop ] = originalEvent[ prop ];
		}

		// Support: IE<9
		// Fix target property (#1925)
		if ( !event.target ) {
			event.target = originalEvent.srcElement || document;
		}

		// Support: Chrome 23+, Safari?
		// Target should not be a text node (#504, #13143)
		if ( event.target.nodeType === 3 ) {
			event.target = event.target.parentNode;
		}

		// Support: IE<9
		// For mouse/key events, metaKey==false if it's undefined (#3368, #11328)
		event.metaKey = !!event.metaKey;

		return fixHook.filter ? fixHook.filter( event, originalEvent ) : event;
	},

	// Includes some event props shared by KeyEvent and MouseEvent
	props: "altKey bubbles cancelable ctrlKey currentTarget eventPhase metaKey relatedTarget shiftKey target timeStamp view which".split(" "),

	fixHooks: {},

	keyHooks: {
		props: "char charCode key keyCode".split(" "),
		filter: function( event, original ) {

			// Add which for key events
			if ( event.which == null ) {
				event.which = original.charCode != null ? original.charCode : original.keyCode;
			}

			return event;
		}
	},

	mouseHooks: {
		props: "button buttons clientX clientY fromElement offsetX offsetY pageX pageY screenX screenY toElement".split(" "),
		filter: function( event, original ) {
			var body, eventDoc, doc,
				button = original.button,
				fromElement = original.fromElement;

			// Calculate pageX/Y if missing and clientX/Y available
			if ( event.pageX == null && original.clientX != null ) {
				eventDoc = event.target.ownerDocument || document;
				doc = eventDoc.documentElement;
				body = eventDoc.body;

				event.pageX = original.clientX + ( doc && doc.scrollLeft || body && body.scrollLeft || 0 ) - ( doc && doc.clientLeft || body && body.clientLeft || 0 );
				event.pageY = original.clientY + ( doc && doc.scrollTop  || body && body.scrollTop  || 0 ) - ( doc && doc.clientTop  || body && body.clientTop  || 0 );
			}

			// Add relatedTarget, if necessary
			if ( !event.relatedTarget && fromElement ) {
				event.relatedTarget = fromElement === event.target ? original.toElement : fromElement;
			}

			// Add which for click: 1 === left; 2 === middle; 3 === right
			// Note: button is not normalized, so don't use it
			if ( !event.which && button !== undefined ) {
				event.which = ( button & 1 ? 1 : ( button & 2 ? 3 : ( button & 4 ? 2 : 0 ) ) );
			}

			return event;
		}
	},

	special: {
		load: {
			// Prevent triggered image.load events from bubbling to window.load
			noBubble: true
		},
		focus: {
			// Fire native event if possible so blur/focus sequence is correct
			trigger: function() {
				if ( this !== safeActiveElement() && this.focus ) {
					try {
						this.focus();
						return false;
					} catch ( e ) {
						// Support: IE<9
						// If we error on focus to hidden element (#1486, #12518),
						// let .trigger() run the handlers
					}
				}
			},
			delegateType: "focusin"
		},
		blur: {
			trigger: function() {
				if ( this === safeActiveElement() && this.blur ) {
					this.blur();
					return false;
				}
			},
			delegateType: "focusout"
		},
		click: {
			// For checkbox, fire native event so checked state will be right
			trigger: function() {
				if ( jQuery.nodeName( this, "input" ) && this.type === "checkbox" && this.click ) {
					this.click();
					return false;
				}
			},

			// For cross-browser consistency, don't fire native .click() on links
			_default: function( event ) {
				return jQuery.nodeName( event.target, "a" );
			}
		},

		beforeunload: {
			postDispatch: function( event ) {

				// Even when returnValue equals to undefined Firefox will still show alert
				if ( event.result !== undefined ) {
					event.originalEvent.returnValue = event.result;
				}
			}
		}
	},

	simulate: function( type, elem, event, bubble ) {
		// Piggyback on a donor event to simulate a different one.
		// Fake originalEvent to avoid donor's stopPropagation, but if the
		// simulated event prevents default then we do the same on the donor.
		var e = jQuery.extend(
			new jQuery.Event(),
			event,
			{
				type: type,
				isSimulated: true,
				originalEvent: {}
			}
		);
		if ( bubble ) {
			jQuery.event.trigger( e, null, elem );
		} else {
			jQuery.event.dispatch.call( elem, e );
		}
		if ( e.isDefaultPrevented() ) {
			event.preventDefault();
		}
	}
};

jQuery.removeEvent = document.removeEventListener ?
	function( elem, type, handle ) {
		if ( elem.removeEventListener ) {
			elem.removeEventListener( type, handle, false );
		}
	} :
	function( elem, type, handle ) {
		var name = "on" + type;

		if ( elem.detachEvent ) {

			// #8545, #7054, preventing memory leaks for custom events in IE6-8
			// detachEvent needed property on element, by name of that event, to properly expose it to GC
			if ( typeof elem[ name ] === core_strundefined ) {
				elem[ name ] = null;
			}

			elem.detachEvent( name, handle );
		}
	};

jQuery.Event = function( src, props ) {
	// Allow instantiation without the 'new' keyword
	if ( !(this instanceof jQuery.Event) ) {
		return new jQuery.Event( src, props );
	}

	// Event object
	if ( src && src.type ) {
		this.originalEvent = src;
		this.type = src.type;

		// Events bubbling up the document may have been marked as prevented
		// by a handler lower down the tree; reflect the correct value.
		this.isDefaultPrevented = ( src.defaultPrevented || src.returnValue === false ||
			src.getPreventDefault && src.getPreventDefault() ) ? returnTrue : returnFalse;

	// Event type
	} else {
		this.type = src;
	}

	// Put explicitly provided properties onto the event object
	if ( props ) {
		jQuery.extend( this, props );
	}

	// Create a timestamp if incoming event doesn't have one
	this.timeStamp = src && src.timeStamp || jQuery.now();

	// Mark it as fixed
	this[ jQuery.expando ] = true;
};

// jQuery.Event is based on DOM3 Events as specified by the ECMAScript Language Binding
// http://www.w3.org/TR/2003/WD-DOM-Level-3-Events-20030331/ecma-script-binding.html
jQuery.Event.prototype = {
	isDefaultPrevented: returnFalse,
	isPropagationStopped: returnFalse,
	isImmediatePropagationStopped: returnFalse,

	preventDefault: function() {
		var e = this.originalEvent;

		this.isDefaultPrevented = returnTrue;
		if ( !e ) {
			return;
		}

		// If preventDefault exists, run it on the original event
		if ( e.preventDefault ) {
			e.preventDefault();

		// Support: IE
		// Otherwise set the returnValue property of the original event to false
		} else {
			e.returnValue = false;
		}
	},
	stopPropagation: function() {
		var e = this.originalEvent;

		this.isPropagationStopped = returnTrue;
		if ( !e ) {
			return;
		}
		// If stopPropagation exists, run it on the original event
		if ( e.stopPropagation ) {
			e.stopPropagation();
		}

		// Support: IE
		// Set the cancelBubble property of the original event to true
		e.cancelBubble = true;
	},
	stopImmediatePropagation: function() {
		this.isImmediatePropagationStopped = returnTrue;
		this.stopPropagation();
	}
};

// Create mouseenter/leave events using mouseover/out and event-time checks
jQuery.each({
	mouseenter: "mouseover",
	mouseleave: "mouseout"
}, function( orig, fix ) {
	jQuery.event.special[ orig ] = {
		delegateType: fix,
		bindType: fix,

		handle: function( event ) {
			var ret,
				target = this,
				related = event.relatedTarget,
				handleObj = event.handleObj;

			// For mousenter/leave call the handler if related is outside the target.
			// NB: No relatedTarget if the mouse left/entered the browser window
			if ( !related || (related !== target && !jQuery.contains( target, related )) ) {
				event.type = handleObj.origType;
				ret = handleObj.handler.apply( this, arguments );
				event.type = fix;
			}
			return ret;
		}
	};
});

// IE submit delegation
if ( !jQuery.support.submitBubbles ) {

	jQuery.event.special.submit = {
		setup: function() {
			// Only need this for delegated form submit events
			if ( jQuery.nodeName( this, "form" ) ) {
				return false;
			}

			// Lazy-add a submit handler when a descendant form may potentially be submitted
			jQuery.event.add( this, "click._submit keypress._submit", function( e ) {
				// Node name check avoids a VML-related crash in IE (#9807)
				var elem = e.target,
					form = jQuery.nodeName( elem, "input" ) || jQuery.nodeName( elem, "button" ) ? elem.form : undefined;
				if ( form && !jQuery._data( form, "submitBubbles" ) ) {
					jQuery.event.add( form, "submit._submit", function( event ) {
						event._submit_bubble = true;
					});
					jQuery._data( form, "submitBubbles", true );
				}
			});
			// return undefined since we don't need an event listener
		},

		postDispatch: function( event ) {
			// If form was submitted by the user, bubble the event up the tree
			if ( event._submit_bubble ) {
				delete event._submit_bubble;
				if ( this.parentNode && !event.isTrigger ) {
					jQuery.event.simulate( "submit", this.parentNode, event, true );
				}
			}
		},

		teardown: function() {
			// Only need this for delegated form submit events
			if ( jQuery.nodeName( this, "form" ) ) {
				return false;
			}

			// Remove delegated handlers; cleanData eventually reaps submit handlers attached above
			jQuery.event.remove( this, "._submit" );
		}
	};
}

// IE change delegation and checkbox/radio fix
if ( !jQuery.support.changeBubbles ) {

	jQuery.event.special.change = {

		setup: function() {

			if ( rformElems.test( this.nodeName ) ) {
				// IE doesn't fire change on a check/radio until blur; trigger it on click
				// after a propertychange. Eat the blur-change in special.change.handle.
				// This still fires onchange a second time for check/radio after blur.
				if ( this.type === "checkbox" || this.type === "radio" ) {
					jQuery.event.add( this, "propertychange._change", function( event ) {
						if ( event.originalEvent.propertyName === "checked" ) {
							this._just_changed = true;
						}
					});
					jQuery.event.add( this, "click._change", function( event ) {
						if ( this._just_changed && !event.isTrigger ) {
							this._just_changed = false;
						}
						// Allow triggered, simulated change events (#11500)
						jQuery.event.simulate( "change", this, event, true );
					});
				}
				return false;
			}
			// Delegated event; lazy-add a change handler on descendant inputs
			jQuery.event.add( this, "beforeactivate._change", function( e ) {
				var elem = e.target;

				if ( rformElems.test( elem.nodeName ) && !jQuery._data( elem, "changeBubbles" ) ) {
					jQuery.event.add( elem, "change._change", function( event ) {
						if ( this.parentNode && !event.isSimulated && !event.isTrigger ) {
							jQuery.event.simulate( "change", this.parentNode, event, true );
						}
					});
					jQuery._data( elem, "changeBubbles", true );
				}
			});
		},

		handle: function( event ) {
			var elem = event.target;

			// Swallow native change events from checkbox/radio, we already triggered them above
			if ( this !== elem || event.isSimulated || event.isTrigger || (elem.type !== "radio" && elem.type !== "checkbox") ) {
				return event.handleObj.handler.apply( this, arguments );
			}
		},

		teardown: function() {
			jQuery.event.remove( this, "._change" );

			return !rformElems.test( this.nodeName );
		}
	};
}

// Create "bubbling" focus and blur events
if ( !jQuery.support.focusinBubbles ) {
	jQuery.each({ focus: "focusin", blur: "focusout" }, function( orig, fix ) {

		// Attach a single capturing handler while someone wants focusin/focusout
		var attaches = 0,
			handler = function( event ) {
				jQuery.event.simulate( fix, event.target, jQuery.event.fix( event ), true );
			};

		jQuery.event.special[ fix ] = {
			setup: function() {
				if ( attaches++ === 0 ) {
					document.addEventListener( orig, handler, true );
				}
			},
			teardown: function() {
				if ( --attaches === 0 ) {
					document.removeEventListener( orig, handler, true );
				}
			}
		};
	});
}

jQuery.fn.extend({

	on: function( types, selector, data, fn, /*INTERNAL*/ one ) {
		var type, origFn;

		// Types can be a map of types/handlers
		if ( typeof types === "object" ) {
			// ( types-Object, selector, data )
			if ( typeof selector !== "string" ) {
				// ( types-Object, data )
				data = data || selector;
				selector = undefined;
			}
			for ( type in types ) {
				this.on( type, selector, data, types[ type ], one );
			}
			return this;
		}

		if ( data == null && fn == null ) {
			// ( types, fn )
			fn = selector;
			data = selector = undefined;
		} else if ( fn == null ) {
			if ( typeof selector === "string" ) {
				// ( types, selector, fn )
				fn = data;
				data = undefined;
			} else {
				// ( types, data, fn )
				fn = data;
				data = selector;
				selector = undefined;
			}
		}
		if ( fn === false ) {
			fn = returnFalse;
		} else if ( !fn ) {
			return this;
		}

		if ( one === 1 ) {
			origFn = fn;
			fn = function( event ) {
				// Can use an empty set, since event contains the info
				jQuery().off( event );
				return origFn.apply( this, arguments );
			};
			// Use same guid so caller can remove using origFn
			fn.guid = origFn.guid || ( origFn.guid = jQuery.guid++ );
		}
		return this.each( function() {
			jQuery.event.add( this, types, fn, data, selector );
		});
	},
	one: function( types, selector, data, fn ) {
		return this.on( types, selector, data, fn, 1 );
	},
	off: function( types, selector, fn ) {
		var handleObj, type;
		if ( types && types.preventDefault && types.handleObj ) {
			// ( event )  dispatched jQuery.Event
			handleObj = types.handleObj;
			jQuery( types.delegateTarget ).off(
				handleObj.namespace ? handleObj.origType + "." + handleObj.namespace : handleObj.origType,
				handleObj.selector,
				handleObj.handler
			);
			return this;
		}
		if ( typeof types === "object" ) {
			// ( types-object [, selector] )
			for ( type in types ) {
				this.off( type, selector, types[ type ] );
			}
			return this;
		}
		if ( selector === false || typeof selector === "function" ) {
			// ( types [, fn] )
			fn = selector;
			selector = undefined;
		}
		if ( fn === false ) {
			fn = returnFalse;
		}
		return this.each(function() {
			jQuery.event.remove( this, types, fn, selector );
		});
	},

	trigger: function( type, data ) {
		return this.each(function() {
			jQuery.event.trigger( type, data, this );
		});
	},
	triggerHandler: function( type, data ) {
		var elem = this[0];
		if ( elem ) {
			return jQuery.event.trigger( type, data, elem, true );
		}
	}
});
var isSimple = /^.[^:#\[\.,]*$/,
	rparentsprev = /^(?:parents|prev(?:Until|All))/,
	rneedsContext = jQuery.expr.match.needsContext,
	// methods guaranteed to produce a unique set when starting from a unique set
	guaranteedUnique = {
		children: true,
		contents: true,
		next: true,
		prev: true
	};

jQuery.fn.extend({
	find: function( selector ) {
		var i,
			ret = [],
			self = this,
			len = self.length;

		if ( typeof selector !== "string" ) {
			return this.pushStack( jQuery( selector ).filter(function() {
				for ( i = 0; i < len; i++ ) {
					if ( jQuery.contains( self[ i ], this ) ) {
						return true;
					}
				}
			}) );
		}

		for ( i = 0; i < len; i++ ) {
			jQuery.find( selector, self[ i ], ret );
		}

		// Needed because $( selector, context ) becomes $( context ).find( selector )
		ret = this.pushStack( len > 1 ? jQuery.unique( ret ) : ret );
		ret.selector = this.selector ? this.selector + " " + selector : selector;
		return ret;
	},

	has: function( target ) {
		var i,
			targets = jQuery( target, this ),
			len = targets.length;

		return this.filter(function() {
			for ( i = 0; i < len; i++ ) {
				if ( jQuery.contains( this, targets[i] ) ) {
					return true;
				}
			}
		});
	},

	not: function( selector ) {
		return this.pushStack( winnow(this, selector || [], true) );
	},

	filter: function( selector ) {
		return this.pushStack( winnow(this, selector || [], false) );
	},

	is: function( selector ) {
		return !!winnow(
			this,

			// If this is a positional/relative selector, check membership in the returned set
			// so $("p:first").is("p:last") won't return true for a doc with two "p".
			typeof selector === "string" && rneedsContext.test( selector ) ?
				jQuery( selector ) :
				selector || [],
			false
		).length;
	},

	closest: function( selectors, context ) {
		var cur,
			i = 0,
			l = this.length,
			ret = [],
			pos = rneedsContext.test( selectors ) || typeof selectors !== "string" ?
				jQuery( selectors, context || this.context ) :
				0;

		for ( ; i < l; i++ ) {
			for ( cur = this[i]; cur && cur !== context; cur = cur.parentNode ) {
				// Always skip document fragments
				if ( cur.nodeType < 11 && (pos ?
					pos.index(cur) > -1 :

					// Don't pass non-elements to Sizzle
					cur.nodeType === 1 &&
						jQuery.find.matchesSelector(cur, selectors)) ) {

					cur = ret.push( cur );
					break;
				}
			}
		}

		return this.pushStack( ret.length > 1 ? jQuery.unique( ret ) : ret );
	},

	// Determine the position of an element within
	// the matched set of elements
	index: function( elem ) {

		// No argument, return index in parent
		if ( !elem ) {
			return ( this[0] && this[0].parentNode ) ? this.first().prevAll().length : -1;
		}

		// index in selector
		if ( typeof elem === "string" ) {
			return jQuery.inArray( this[0], jQuery( elem ) );
		}

		// Locate the position of the desired element
		return jQuery.inArray(
			// If it receives a jQuery object, the first element is used
			elem.jquery ? elem[0] : elem, this );
	},

	add: function( selector, context ) {
		var set = typeof selector === "string" ?
				jQuery( selector, context ) :
				jQuery.makeArray( selector && selector.nodeType ? [ selector ] : selector ),
			all = jQuery.merge( this.get(), set );

		return this.pushStack( jQuery.unique(all) );
	},

	addBack: function( selector ) {
		return this.add( selector == null ?
			this.prevObject : this.prevObject.filter(selector)
		);
	}
});

function sibling( cur, dir ) {
	do {
		cur = cur[ dir ];
	} while ( cur && cur.nodeType !== 1 );

	return cur;
}

jQuery.each({
	parent: function( elem ) {
		var parent = elem.parentNode;
		return parent && parent.nodeType !== 11 ? parent : null;
	},
	parents: function( elem ) {
		return jQuery.dir( elem, "parentNode" );
	},
	parentsUntil: function( elem, i, until ) {
		return jQuery.dir( elem, "parentNode", until );
	},
	next: function( elem ) {
		return sibling( elem, "nextSibling" );
	},
	prev: function( elem ) {
		return sibling( elem, "previousSibling" );
	},
	nextAll: function( elem ) {
		return jQuery.dir( elem, "nextSibling" );
	},
	prevAll: function( elem ) {
		return jQuery.dir( elem, "previousSibling" );
	},
	nextUntil: function( elem, i, until ) {
		return jQuery.dir( elem, "nextSibling", until );
	},
	prevUntil: function( elem, i, until ) {
		return jQuery.dir( elem, "previousSibling", until );
	},
	siblings: function( elem ) {
		return jQuery.sibling( ( elem.parentNode || {} ).firstChild, elem );
	},
	children: function( elem ) {
		return jQuery.sibling( elem.firstChild );
	},
	contents: function( elem ) {
		return jQuery.nodeName( elem, "iframe" ) ?
			elem.contentDocument || elem.contentWindow.document :
			jQuery.merge( [], elem.childNodes );
	}
}, function( name, fn ) {
	jQuery.fn[ name ] = function( until, selector ) {
		var ret = jQuery.map( this, fn, until );

		if ( name.slice( -5 ) !== "Until" ) {
			selector = until;
		}

		if ( selector && typeof selector === "string" ) {
			ret = jQuery.filter( selector, ret );
		}

		if ( this.length > 1 ) {
			// Remove duplicates
			if ( !guaranteedUnique[ name ] ) {
				ret = jQuery.unique( ret );
			}

			// Reverse order for parents* and prev-derivatives
			if ( rparentsprev.test( name ) ) {
				ret = ret.reverse();
			}
		}

		return this.pushStack( ret );
	};
});

jQuery.extend({
	filter: function( expr, elems, not ) {
		var elem = elems[ 0 ];

		if ( not ) {
			expr = ":not(" + expr + ")";
		}

		return elems.length === 1 && elem.nodeType === 1 ?
			jQuery.find.matchesSelector( elem, expr ) ? [ elem ] : [] :
			jQuery.find.matches( expr, jQuery.grep( elems, function( elem ) {
				return elem.nodeType === 1;
			}));
	},

	dir: function( elem, dir, until ) {
		var matched = [],
			cur = elem[ dir ];

		while ( cur && cur.nodeType !== 9 && (until === undefined || cur.nodeType !== 1 || !jQuery( cur ).is( until )) ) {
			if ( cur.nodeType === 1 ) {
				matched.push( cur );
			}
			cur = cur[dir];
		}
		return matched;
	},

	sibling: function( n, elem ) {
		var r = [];

		for ( ; n; n = n.nextSibling ) {
			if ( n.nodeType === 1 && n !== elem ) {
				r.push( n );
			}
		}

		return r;
	}
});

// Implement the identical functionality for filter and not
function winnow( elements, qualifier, not ) {
	if ( jQuery.isFunction( qualifier ) ) {
		return jQuery.grep( elements, function( elem, i ) {
			/* jshint -W018 */
			return !!qualifier.call( elem, i, elem ) !== not;
		});

	}

	if ( qualifier.nodeType ) {
		return jQuery.grep( elements, function( elem ) {
			return ( elem === qualifier ) !== not;
		});

	}

	if ( typeof qualifier === "string" ) {
		if ( isSimple.test( qualifier ) ) {
			return jQuery.filter( qualifier, elements, not );
		}

		qualifier = jQuery.filter( qualifier, elements );
	}

	return jQuery.grep( elements, function( elem ) {
		return ( jQuery.inArray( elem, qualifier ) >= 0 ) !== not;
	});
}
function createSafeFragment( document ) {
	var list = nodeNames.split( "|" ),
		safeFrag = document.createDocumentFragment();

	if ( safeFrag.createElement ) {
		while ( list.length ) {
			safeFrag.createElement(
				list.pop()
			);
		}
	}
	return safeFrag;
}

var nodeNames = "abbr|article|aside|audio|bdi|canvas|data|datalist|details|figcaption|figure|footer|" +
		"header|hgroup|mark|meter|nav|output|progress|section|summary|time|video",
	rinlinejQuery = / jQuery\d+="(?:null|\d+)"/g,
	rnoshimcache = new RegExp("<(?:" + nodeNames + ")[\\s/>]", "i"),
	rleadingWhitespace = /^\s+/,
	rxhtmlTag = /<(?!area|br|col|embed|hr|img|input|link|meta|param)(([\w:]+)[^>]*)\/>/gi,
	rtagName = /<([\w:]+)/,
	rtbody = /<tbody/i,
	rhtml = /<|&#?\w+;/,
	rnoInnerhtml = /<(?:script|style|link)/i,
	manipulation_rcheckableType = /^(?:checkbox|radio)$/i,
	// checked="checked" or checked
	rchecked = /checked\s*(?:[^=]|=\s*.checked.)/i,
	rscriptType = /^$|\/(?:java|ecma)script/i,
	rscriptTypeMasked = /^true\/(.*)/,
	rcleanScript = /^\s*<!(?:\[CDATA\[|--)|(?:\]\]|--)>\s*$/g,

	// We have to close these tags to support XHTML (#13200)
	wrapMap = {
		option: [ 1, "<select multiple='multiple'>", "</select>" ],
		legend: [ 1, "<fieldset>", "</fieldset>" ],
		area: [ 1, "<map>", "</map>" ],
		param: [ 1, "<object>", "</object>" ],
		thead: [ 1, "<table>", "</table>" ],
		tr: [ 2, "<table><tbody>", "</tbody></table>" ],
		col: [ 2, "<table><tbody></tbody><colgroup>", "</colgroup></table>" ],
		td: [ 3, "<table><tbody><tr>", "</tr></tbody></table>" ],

		// IE6-8 can't serialize link, script, style, or any html5 (NoScope) tags,
		// unless wrapped in a div with non-breaking characters in front of it.
		_default: jQuery.support.htmlSerialize ? [ 0, "", "" ] : [ 1, "X<div>", "</div>"  ]
	},
	safeFragment = createSafeFragment( document ),
	fragmentDiv = safeFragment.appendChild( document.createElement("div") );

wrapMap.optgroup = wrapMap.option;
wrapMap.tbody = wrapMap.tfoot = wrapMap.colgroup = wrapMap.caption = wrapMap.thead;
wrapMap.th = wrapMap.td;

jQuery.fn.extend({
	text: function( value ) {
		return jQuery.access( this, function( value ) {
			return value === undefined ?
				jQuery.text( this ) :
				this.empty().append( ( this[0] && this[0].ownerDocument || document ).createTextNode( value ) );
		}, null, value, arguments.length );
	},

	append: function() {
		return this.domManip( arguments, function( elem ) {
			if ( this.nodeType === 1 || this.nodeType === 11 || this.nodeType === 9 ) {
				var target = manipulationTarget( this, elem );
				target.appendChild( elem );
			}
		});
	},

	prepend: function() {
		return this.domManip( arguments, function( elem ) {
			if ( this.nodeType === 1 || this.nodeType === 11 || this.nodeType === 9 ) {
				var target = manipulationTarget( this, elem );
				target.insertBefore( elem, target.firstChild );
			}
		});
	},

	before: function() {
		return this.domManip( arguments, function( elem ) {
			if ( this.parentNode ) {
				this.parentNode.insertBefore( elem, this );
			}
		});
	},

	after: function() {
		return this.domManip( arguments, function( elem ) {
			if ( this.parentNode ) {
				this.parentNode.insertBefore( elem, this.nextSibling );
			}
		});
	},

	// keepData is for internal use only--do not document
	remove: function( selector, keepData ) {
		var elem,
			elems = selector ? jQuery.filter( selector, this ) : this,
			i = 0;

		for ( ; (elem = elems[i]) != null; i++ ) {

			if ( !keepData && elem.nodeType === 1 ) {
				jQuery.cleanData( getAll( elem ) );
			}

			if ( elem.parentNode ) {
				if ( keepData && jQuery.contains( elem.ownerDocument, elem ) ) {
					setGlobalEval( getAll( elem, "script" ) );
				}
				elem.parentNode.removeChild( elem );
			}
		}

		return this;
	},

	empty: function() {
		var elem,
			i = 0;

		for ( ; (elem = this[i]) != null; i++ ) {
			// Remove element nodes and prevent memory leaks
			if ( elem.nodeType === 1 ) {
				jQuery.cleanData( getAll( elem, false ) );
			}

			// Remove any remaining nodes
			while ( elem.firstChild ) {
				elem.removeChild( elem.firstChild );
			}

			// If this is a select, ensure that it displays empty (#12336)
			// Support: IE<9
			if ( elem.options && jQuery.nodeName( elem, "select" ) ) {
				elem.options.length = 0;
			}
		}

		return this;
	},

	clone: function( dataAndEvents, deepDataAndEvents ) {
		dataAndEvents = dataAndEvents == null ? false : dataAndEvents;
		deepDataAndEvents = deepDataAndEvents == null ? dataAndEvents : deepDataAndEvents;

		return this.map( function () {
			return jQuery.clone( this, dataAndEvents, deepDataAndEvents );
		});
	},

	html: function( value ) {
		return jQuery.access( this, function( value ) {
			var elem = this[0] || {},
				i = 0,
				l = this.length;

			if ( value === undefined ) {
				return elem.nodeType === 1 ?
					elem.innerHTML.replace( rinlinejQuery, "" ) :
					undefined;
			}

			// See if we can take a shortcut and just use innerHTML
			if ( typeof value === "string" && !rnoInnerhtml.test( value ) &&
				( jQuery.support.htmlSerialize || !rnoshimcache.test( value )  ) &&
				( jQuery.support.leadingWhitespace || !rleadingWhitespace.test( value ) ) &&
				!wrapMap[ ( rtagName.exec( value ) || ["", ""] )[1].toLowerCase() ] ) {

				value = value.replace( rxhtmlTag, "<$1></$2>" );

				try {
					for (; i < l; i++ ) {
						// Remove element nodes and prevent memory leaks
						elem = this[i] || {};
						if ( elem.nodeType === 1 ) {
							jQuery.cleanData( getAll( elem, false ) );
							elem.innerHTML = value;
						}
					}

					elem = 0;

				// If using innerHTML throws an exception, use the fallback method
				} catch(e) {}
			}

			if ( elem ) {
				this.empty().append( value );
			}
		}, null, value, arguments.length );
	},

	replaceWith: function() {
		var
			// Snapshot the DOM in case .domManip sweeps something relevant into its fragment
			args = jQuery.map( this, function( elem ) {
				return [ elem.nextSibling, elem.parentNode ];
			}),
			i = 0;

		// Make the changes, replacing each context element with the new content
		this.domManip( arguments, function( elem ) {
			var next = args[ i++ ],
				parent = args[ i++ ];

			if ( parent ) {
				// Don't use the snapshot next if it has moved (#13810)
				if ( next && next.parentNode !== parent ) {
					next = this.nextSibling;
				}
				jQuery( this ).remove();
				parent.insertBefore( elem, next );
			}
		// Allow new content to include elements from the context set
		}, true );

		// Force removal if there was no new content (e.g., from empty arguments)
		return i ? this : this.remove();
	},

	detach: function( selector ) {
		return this.remove( selector, true );
	},

	domManip: function( args, callback, allowIntersection ) {

		// Flatten any nested arrays
		args = core_concat.apply( [], args );

		var first, node, hasScripts,
			scripts, doc, fragment,
			i = 0,
			l = this.length,
			set = this,
			iNoClone = l - 1,
			value = args[0],
			isFunction = jQuery.isFunction( value );

		// We can't cloneNode fragments that contain checked, in WebKit
		if ( isFunction || !( l <= 1 || typeof value !== "string" || jQuery.support.checkClone || !rchecked.test( value ) ) ) {
			return this.each(function( index ) {
				var self = set.eq( index );
				if ( isFunction ) {
					args[0] = value.call( this, index, self.html() );
				}
				self.domManip( args, callback, allowIntersection );
			});
		}

		if ( l ) {
			fragment = jQuery.buildFragment( args, this[ 0 ].ownerDocument, false, !allowIntersection && this );
			first = fragment.firstChild;

			if ( fragment.childNodes.length === 1 ) {
				fragment = first;
			}

			if ( first ) {
				scripts = jQuery.map( getAll( fragment, "script" ), disableScript );
				hasScripts = scripts.length;

				// Use the original fragment for the last item instead of the first because it can end up
				// being emptied incorrectly in certain situations (#8070).
				for ( ; i < l; i++ ) {
					node = fragment;

					if ( i !== iNoClone ) {
						node = jQuery.clone( node, true, true );

						// Keep references to cloned scripts for later restoration
						if ( hasScripts ) {
							jQuery.merge( scripts, getAll( node, "script" ) );
						}
					}

					callback.call( this[i], node, i );
				}

				if ( hasScripts ) {
					doc = scripts[ scripts.length - 1 ].ownerDocument;

					// Reenable scripts
					jQuery.map( scripts, restoreScript );

					// Evaluate executable scripts on first document insertion
					for ( i = 0; i < hasScripts; i++ ) {
						node = scripts[ i ];
						if ( rscriptType.test( node.type || "" ) &&
							!jQuery._data( node, "globalEval" ) && jQuery.contains( doc, node ) ) {

							if ( node.src ) {
								// Hope ajax is available...
								jQuery._evalUrl( node.src );
							} else {
								jQuery.globalEval( ( node.text || node.textContent || node.innerHTML || "" ).replace( rcleanScript, "" ) );
							}
						}
					}
				}

				// Fix #11809: Avoid leaking memory
				fragment = first = null;
			}
		}

		return this;
	}
});

// Support: IE<8
// Manipulating tables requires a tbody
function manipulationTarget( elem, content ) {
	return jQuery.nodeName( elem, "table" ) &&
		jQuery.nodeName( content.nodeType === 1 ? content : content.firstChild, "tr" ) ?

		elem.getElementsByTagName("tbody")[0] ||
			elem.appendChild( elem.ownerDocument.createElement("tbody") ) :
		elem;
}

// Replace/restore the type attribute of script elements for safe DOM manipulation
function disableScript( elem ) {
	elem.type = (jQuery.find.attr( elem, "type" ) !== null) + "/" + elem.type;
	return elem;
}
function restoreScript( elem ) {
	var match = rscriptTypeMasked.exec( elem.type );
	if ( match ) {
		elem.type = match[1];
	} else {
		elem.removeAttribute("type");
	}
	return elem;
}

// Mark scripts as having already been evaluated
function setGlobalEval( elems, refElements ) {
	var elem,
		i = 0;
	for ( ; (elem = elems[i]) != null; i++ ) {
		jQuery._data( elem, "globalEval", !refElements || jQuery._data( refElements[i], "globalEval" ) );
	}
}

function cloneCopyEvent( src, dest ) {

	if ( dest.nodeType !== 1 || !jQuery.hasData( src ) ) {
		return;
	}

	var type, i, l,
		oldData = jQuery._data( src ),
		curData = jQuery._data( dest, oldData ),
		events = oldData.events;

	if ( events ) {
		delete curData.handle;
		curData.events = {};

		for ( type in events ) {
			for ( i = 0, l = events[ type ].length; i < l; i++ ) {
				jQuery.event.add( dest, type, events[ type ][ i ] );
			}
		}
	}

	// make the cloned public data object a copy from the original
	if ( curData.data ) {
		curData.data = jQuery.extend( {}, curData.data );
	}
}

function fixCloneNodeIssues( src, dest ) {
	var nodeName, e, data;

	// We do not need to do anything for non-Elements
	if ( dest.nodeType !== 1 ) {
		return;
	}

	nodeName = dest.nodeName.toLowerCase();

	// IE6-8 copies events bound via attachEvent when using cloneNode.
	if ( !jQuery.support.noCloneEvent && dest[ jQuery.expando ] ) {
		data = jQuery._data( dest );

		for ( e in data.events ) {
			jQuery.removeEvent( dest, e, data.handle );
		}

		// Event data gets referenced instead of copied if the expando gets copied too
		dest.removeAttribute( jQuery.expando );
	}

	// IE blanks contents when cloning scripts, and tries to evaluate newly-set text
	if ( nodeName === "script" && dest.text !== src.text ) {
		disableScript( dest ).text = src.text;
		restoreScript( dest );

	// IE6-10 improperly clones children of object elements using classid.
	// IE10 throws NoModificationAllowedError if parent is null, #12132.
	} else if ( nodeName === "object" ) {
		if ( dest.parentNode ) {
			dest.outerHTML = src.outerHTML;
		}

		// This path appears unavoidable for IE9. When cloning an object
		// element in IE9, the outerHTML strategy above is not sufficient.
		// If the src has innerHTML and the destination does not,
		// copy the src.innerHTML into the dest.innerHTML. #10324
		if ( jQuery.support.html5Clone && ( src.innerHTML && !jQuery.trim(dest.innerHTML) ) ) {
			dest.innerHTML = src.innerHTML;
		}

	} else if ( nodeName === "input" && manipulation_rcheckableType.test( src.type ) ) {
		// IE6-8 fails to persist the checked state of a cloned checkbox
		// or radio button. Worse, IE6-7 fail to give the cloned element
		// a checked appearance if the defaultChecked value isn't also set

		dest.defaultChecked = dest.checked = src.checked;

		// IE6-7 get confused and end up setting the value of a cloned
		// checkbox/radio button to an empty string instead of "on"
		if ( dest.value !== src.value ) {
			dest.value = src.value;
		}

	// IE6-8 fails to return the selected option to the default selected
	// state when cloning options
	} else if ( nodeName === "option" ) {
		dest.defaultSelected = dest.selected = src.defaultSelected;

	// IE6-8 fails to set the defaultValue to the correct value when
	// cloning other types of input fields
	} else if ( nodeName === "input" || nodeName === "textarea" ) {
		dest.defaultValue = src.defaultValue;
	}
}

jQuery.each({
	appendTo: "append",
	prependTo: "prepend",
	insertBefore: "before",
	insertAfter: "after",
	replaceAll: "replaceWith"
}, function( name, original ) {
	jQuery.fn[ name ] = function( selector ) {
		var elems,
			i = 0,
			ret = [],
			insert = jQuery( selector ),
			last = insert.length - 1;

		for ( ; i <= last; i++ ) {
			elems = i === last ? this : this.clone(true);
			jQuery( insert[i] )[ original ]( elems );

			// Modern browsers can apply jQuery collections as arrays, but oldIE needs a .get()
			core_push.apply( ret, elems.get() );
		}

		return this.pushStack( ret );
	};
});

function getAll( context, tag ) {
	var elems, elem,
		i = 0,
		found = typeof context.getElementsByTagName !== core_strundefined ? context.getElementsByTagName( tag || "*" ) :
			typeof context.querySelectorAll !== core_strundefined ? context.querySelectorAll( tag || "*" ) :
			undefined;

	if ( !found ) {
		for ( found = [], elems = context.childNodes || context; (elem = elems[i]) != null; i++ ) {
			if ( !tag || jQuery.nodeName( elem, tag ) ) {
				found.push( elem );
			} else {
				jQuery.merge( found, getAll( elem, tag ) );
			}
		}
	}

	return tag === undefined || tag && jQuery.nodeName( context, tag ) ?
		jQuery.merge( [ context ], found ) :
		found;
}

// Used in buildFragment, fixes the defaultChecked property
function fixDefaultChecked( elem ) {
	if ( manipulation_rcheckableType.test( elem.type ) ) {
		elem.defaultChecked = elem.checked;
	}
}

jQuery.extend({
	clone: function( elem, dataAndEvents, deepDataAndEvents ) {
		var destElements, node, clone, i, srcElements,
			inPage = jQuery.contains( elem.ownerDocument, elem );

		if ( jQuery.support.html5Clone || jQuery.isXMLDoc(elem) || !rnoshimcache.test( "<" + elem.nodeName + ">" ) ) {
			clone = elem.cloneNode( true );

		// IE<=8 does not properly clone detached, unknown element nodes
		} else {
			fragmentDiv.innerHTML = elem.outerHTML;
			fragmentDiv.removeChild( clone = fragmentDiv.firstChild );
		}

		if ( (!jQuery.support.noCloneEvent || !jQuery.support.noCloneChecked) &&
				(elem.nodeType === 1 || elem.nodeType === 11) && !jQuery.isXMLDoc(elem) ) {

			// We eschew Sizzle here for performance reasons: http://jsperf.com/getall-vs-sizzle/2
			destElements = getAll( clone );
			srcElements = getAll( elem );

			// Fix all IE cloning issues
			for ( i = 0; (node = srcElements[i]) != null; ++i ) {
				// Ensure that the destination node is not null; Fixes #9587
				if ( destElements[i] ) {
					fixCloneNodeIssues( node, destElements[i] );
				}
			}
		}

		// Copy the events from the original to the clone
		if ( dataAndEvents ) {
			if ( deepDataAndEvents ) {
				srcElements = srcElements || getAll( elem );
				destElements = destElements || getAll( clone );

				for ( i = 0; (node = srcElements[i]) != null; i++ ) {
					cloneCopyEvent( node, destElements[i] );
				}
			} else {
				cloneCopyEvent( elem, clone );
			}
		}

		// Preserve script evaluation history
		destElements = getAll( clone, "script" );
		if ( destElements.length > 0 ) {
			setGlobalEval( destElements, !inPage && getAll( elem, "script" ) );
		}

		destElements = srcElements = node = null;

		// Return the cloned set
		return clone;
	},

	buildFragment: function( elems, context, scripts, selection ) {
		var j, elem, contains,
			tmp, tag, tbody, wrap,
			l = elems.length,

			// Ensure a safe fragment
			safe = createSafeFragment( context ),

			nodes = [],
			i = 0;

		for ( ; i < l; i++ ) {
			elem = elems[ i ];

			if ( elem || elem === 0 ) {

				// Add nodes directly
				if ( jQuery.type( elem ) === "object" ) {
					jQuery.merge( nodes, elem.nodeType ? [ elem ] : elem );

				// Convert non-html into a text node
				} else if ( !rhtml.test( elem ) ) {
					nodes.push( context.createTextNode( elem ) );

				// Convert html into DOM nodes
				} else {
					tmp = tmp || safe.appendChild( context.createElement("div") );

					// Deserialize a standard representation
					tag = ( rtagName.exec( elem ) || ["", ""] )[1].toLowerCase();
					wrap = wrapMap[ tag ] || wrapMap._default;

					tmp.innerHTML = wrap[1] + elem.replace( rxhtmlTag, "<$1></$2>" ) + wrap[2];

					// Descend through wrappers to the right content
					j = wrap[0];
					while ( j-- ) {
						tmp = tmp.lastChild;
					}

					// Manually add leading whitespace removed by IE
					if ( !jQuery.support.leadingWhitespace && rleadingWhitespace.test( elem ) ) {
						nodes.push( context.createTextNode( rleadingWhitespace.exec( elem )[0] ) );
					}

					// Remove IE's autoinserted <tbody> from table fragments
					if ( !jQuery.support.tbody ) {

						// String was a <table>, *may* have spurious <tbody>
						elem = tag === "table" && !rtbody.test( elem ) ?
							tmp.firstChild :

							// String was a bare <thead> or <tfoot>
							wrap[1] === "<table>" && !rtbody.test( elem ) ?
								tmp :
								0;

						j = elem && elem.childNodes.length;
						while ( j-- ) {
							if ( jQuery.nodeName( (tbody = elem.childNodes[j]), "tbody" ) && !tbody.childNodes.length ) {
								elem.removeChild( tbody );
							}
						}
					}

					jQuery.merge( nodes, tmp.childNodes );

					// Fix #12392 for WebKit and IE > 9
					tmp.textContent = "";

					// Fix #12392 for oldIE
					while ( tmp.firstChild ) {
						tmp.removeChild( tmp.firstChild );
					}

					// Remember the top-level container for proper cleanup
					tmp = safe.lastChild;
				}
			}
		}

		// Fix #11356: Clear elements from fragment
		if ( tmp ) {
			safe.removeChild( tmp );
		}

		// Reset defaultChecked for any radios and checkboxes
		// about to be appended to the DOM in IE 6/7 (#8060)
		if ( !jQuery.support.appendChecked ) {
			jQuery.grep( getAll( nodes, "input" ), fixDefaultChecked );
		}

		i = 0;
		while ( (elem = nodes[ i++ ]) ) {

			// #4087 - If origin and destination elements are the same, and this is
			// that element, do not do anything
			if ( selection && jQuery.inArray( elem, selection ) !== -1 ) {
				continue;
			}

			contains = jQuery.contains( elem.ownerDocument, elem );

			// Append to fragment
			tmp = getAll( safe.appendChild( elem ), "script" );

			// Preserve script evaluation history
			if ( contains ) {
				setGlobalEval( tmp );
			}

			// Capture executables
			if ( scripts ) {
				j = 0;
				while ( (elem = tmp[ j++ ]) ) {
					if ( rscriptType.test( elem.type || "" ) ) {
						scripts.push( elem );
					}
				}
			}
		}

		tmp = null;

		return safe;
	},

	cleanData: function( elems, /* internal */ acceptData ) {
		var elem, type, id, data,
			i = 0,
			internalKey = jQuery.expando,
			cache = jQuery.cache,
			deleteExpando = jQuery.support.deleteExpando,
			special = jQuery.event.special;

		for ( ; (elem = elems[i]) != null; i++ ) {

			if ( acceptData || jQuery.acceptData( elem ) ) {

				id = elem[ internalKey ];
				data = id && cache[ id ];

				if ( data ) {
					if ( data.events ) {
						for ( type in data.events ) {
							if ( special[ type ] ) {
								jQuery.event.remove( elem, type );

							// This is a shortcut to avoid jQuery.event.remove's overhead
							} else {
								jQuery.removeEvent( elem, type, data.handle );
							}
						}
					}

					// Remove cache only if it was not already removed by jQuery.event.remove
					if ( cache[ id ] ) {

						delete cache[ id ];

						// IE does not allow us to delete expando properties from nodes,
						// nor does it have a removeAttribute function on Document nodes;
						// we must handle all of these cases
						if ( deleteExpando ) {
							delete elem[ internalKey ];

						} else if ( typeof elem.removeAttribute !== core_strundefined ) {
							elem.removeAttribute( internalKey );

						} else {
							elem[ internalKey ] = null;
						}

						core_deletedIds.push( id );
					}
				}
			}
		}
	},

	_evalUrl: function( url ) {
		return jQuery.ajax({
			url: url,
			type: "GET",
			dataType: "script",
			async: false,
			global: false,
			"throws": true
		});
	}
});
jQuery.fn.extend({
	wrapAll: function( html ) {
		if ( jQuery.isFunction( html ) ) {
			return this.each(function(i) {
				jQuery(this).wrapAll( html.call(this, i) );
			});
		}

		if ( this[0] ) {
			// The elements to wrap the target around
			var wrap = jQuery( html, this[0].ownerDocument ).eq(0).clone(true);

			if ( this[0].parentNode ) {
				wrap.insertBefore( this[0] );
			}

			wrap.map(function() {
				var elem = this;

				while ( elem.firstChild && elem.firstChild.nodeType === 1 ) {
					elem = elem.firstChild;
				}

				return elem;
			}).append( this );
		}

		return this;
	},

	wrapInner: function( html ) {
		if ( jQuery.isFunction( html ) ) {
			return this.each(function(i) {
				jQuery(this).wrapInner( html.call(this, i) );
			});
		}

		return this.each(function() {
			var self = jQuery( this ),
				contents = self.contents();

			if ( contents.length ) {
				contents.wrapAll( html );

			} else {
				self.append( html );
			}
		});
	},

	wrap: function( html ) {
		var isFunction = jQuery.isFunction( html );

		return this.each(function(i) {
			jQuery( this ).wrapAll( isFunction ? html.call(this, i) : html );
		});
	},

	unwrap: function() {
		return this.parent().each(function() {
			if ( !jQuery.nodeName( this, "body" ) ) {
				jQuery( this ).replaceWith( this.childNodes );
			}
		}).end();
	}
});
var iframe, getStyles, curCSS,
	ralpha = /alpha\([^)]*\)/i,
	ropacity = /opacity\s*=\s*([^)]*)/,
	rposition = /^(top|right|bottom|left)$/,
	// swappable if display is none or starts with table except "table", "table-cell", or "table-caption"
	// see here for display values: https://developer.mozilla.org/en-US/docs/CSS/display
	rdisplayswap = /^(none|table(?!-c[ea]).+)/,
	rmargin = /^margin/,
	rnumsplit = new RegExp( "^(" + core_pnum + ")(.*)$", "i" ),
	rnumnonpx = new RegExp( "^(" + core_pnum + ")(?!px)[a-z%]+$", "i" ),
	rrelNum = new RegExp( "^([+-])=(" + core_pnum + ")", "i" ),
	elemdisplay = { BODY: "block" },

	cssShow = { position: "absolute", visibility: "hidden", display: "block" },
	cssNormalTransform = {
		letterSpacing: 0,
		fontWeight: 400
	},

	cssExpand = [ "Top", "Right", "Bottom", "Left" ],
	cssPrefixes = [ "Webkit", "O", "Moz", "ms" ];

// return a css property mapped to a potentially vendor prefixed property
function vendorPropName( style, name ) {

	// shortcut for names that are not vendor prefixed
	if ( name in style ) {
		return name;
	}

	// check for vendor prefixed names
	var capName = name.charAt(0).toUpperCase() + name.slice(1),
		origName = name,
		i = cssPrefixes.length;

	while ( i-- ) {
		name = cssPrefixes[ i ] + capName;
		if ( name in style ) {
			return name;
		}
	}

	return origName;
}

function isHidden( elem, el ) {
	// isHidden might be called from jQuery#filter function;
	// in that case, element will be second argument
	elem = el || elem;
	return jQuery.css( elem, "display" ) === "none" || !jQuery.contains( elem.ownerDocument, elem );
}

function showHide( elements, show ) {
	var display, elem, hidden,
		values = [],
		index = 0,
		length = elements.length;

	for ( ; index < length; index++ ) {
		elem = elements[ index ];
		if ( !elem.style ) {
			continue;
		}

		values[ index ] = jQuery._data( elem, "olddisplay" );
		display = elem.style.display;
		if ( show ) {
			// Reset the inline display of this element to learn if it is
			// being hidden by cascaded rules or not
			if ( !values[ index ] && display === "none" ) {
				elem.style.display = "";
			}

			// Set elements which have been overridden with display: none
			// in a stylesheet to whatever the default browser style is
			// for such an element
			if ( elem.style.display === "" && isHidden( elem ) ) {
				values[ index ] = jQuery._data( elem, "olddisplay", css_defaultDisplay(elem.nodeName) );
			}
		} else {

			if ( !values[ index ] ) {
				hidden = isHidden( elem );

				if ( display && display !== "none" || !hidden ) {
					jQuery._data( elem, "olddisplay", hidden ? display : jQuery.css( elem, "display" ) );
				}
			}
		}
	}

	// Set the display of most of the elements in a second loop
	// to avoid the constant reflow
	for ( index = 0; index < length; index++ ) {
		elem = elements[ index ];
		if ( !elem.style ) {
			continue;
		}
		if ( !show || elem.style.display === "none" || elem.style.display === "" ) {
			elem.style.display = show ? values[ index ] || "" : "none";
		}
	}

	return elements;
}

jQuery.fn.extend({
	css: function( name, value ) {
		return jQuery.access( this, function( elem, name, value ) {
			var len, styles,
				map = {},
				i = 0;

			if ( jQuery.isArray( name ) ) {
				styles = getStyles( elem );
				len = name.length;

				for ( ; i < len; i++ ) {
					map[ name[ i ] ] = jQuery.css( elem, name[ i ], false, styles );
				}

				return map;
			}

			return value !== undefined ?
				jQuery.style( elem, name, value ) :
				jQuery.css( elem, name );
		}, name, value, arguments.length > 1 );
	},
	show: function() {
		return showHide( this, true );
	},
	hide: function() {
		return showHide( this );
	},
	toggle: function( state ) {
		if ( typeof state === "boolean" ) {
			return state ? this.show() : this.hide();
		}

		return this.each(function() {
			if ( isHidden( this ) ) {
				jQuery( this ).show();
			} else {
				jQuery( this ).hide();
			}
		});
	}
});

jQuery.extend({
	// Add in style property hooks for overriding the default
	// behavior of getting and setting a style property
	cssHooks: {
		opacity: {
			get: function( elem, computed ) {
				if ( computed ) {
					// We should always get a number back from opacity
					var ret = curCSS( elem, "opacity" );
					return ret === "" ? "1" : ret;
				}
			}
		}
	},

	// Don't automatically add "px" to these possibly-unitless properties
	cssNumber: {
		"columnCount": true,
		"fillOpacity": true,
		"fontWeight": true,
		"lineHeight": true,
		"opacity": true,
		"order": true,
		"orphans": true,
		"widows": true,
		"zIndex": true,
		"zoom": true
	},

	// Add in properties whose names you wish to fix before
	// setting or getting the value
	cssProps: {
		// normalize float css property
		"float": jQuery.support.cssFloat ? "cssFloat" : "styleFloat"
	},

	// Get and set the style property on a DOM Node
	style: function( elem, name, value, extra ) {
		// Don't set styles on text and comment nodes
		if ( !elem || elem.nodeType === 3 || elem.nodeType === 8 || !elem.style ) {
			return;
		}

		// Make sure that we're working with the right name
		var ret, type, hooks,
			origName = jQuery.camelCase( name ),
			style = elem.style;

		name = jQuery.cssProps[ origName ] || ( jQuery.cssProps[ origName ] = vendorPropName( style, origName ) );

		// gets hook for the prefixed version
		// followed by the unprefixed version
		hooks = jQuery.cssHooks[ name ] || jQuery.cssHooks[ origName ];

		// Check if we're setting a value
		if ( value !== undefined ) {
			type = typeof value;

			// convert relative number strings (+= or -=) to relative numbers. #7345
			if ( type === "string" && (ret = rrelNum.exec( value )) ) {
				value = ( ret[1] + 1 ) * ret[2] + parseFloat( jQuery.css( elem, name ) );
				// Fixes bug #9237
				type = "number";
			}

			// Make sure that NaN and null values aren't set. See: #7116
			if ( value == null || type === "number" && isNaN( value ) ) {
				return;
			}

			// If a number was passed in, add 'px' to the (except for certain CSS properties)
			if ( type === "number" && !jQuery.cssNumber[ origName ] ) {
				value += "px";
			}

			// Fixes #8908, it can be done more correctly by specifing setters in cssHooks,
			// but it would mean to define eight (for every problematic property) identical functions
			if ( !jQuery.support.clearCloneStyle && value === "" && name.indexOf("background") === 0 ) {
				style[ name ] = "inherit";
			}

			// If a hook was provided, use that value, otherwise just set the specified value
			if ( !hooks || !("set" in hooks) || (value = hooks.set( elem, value, extra )) !== undefined ) {

				// Wrapped to prevent IE from throwing errors when 'invalid' values are provided
				// Fixes bug #5509
				try {
					style[ name ] = value;
				} catch(e) {}
			}

		} else {
			// If a hook was provided get the non-computed value from there
			if ( hooks && "get" in hooks && (ret = hooks.get( elem, false, extra )) !== undefined ) {
				return ret;
			}

			// Otherwise just get the value from the style object
			return style[ name ];
		}
	},

	css: function( elem, name, extra, styles ) {
		var num, val, hooks,
			origName = jQuery.camelCase( name );

		// Make sure that we're working with the right name
		name = jQuery.cssProps[ origName ] || ( jQuery.cssProps[ origName ] = vendorPropName( elem.style, origName ) );

		// gets hook for the prefixed version
		// followed by the unprefixed version
		hooks = jQuery.cssHooks[ name ] || jQuery.cssHooks[ origName ];

		// If a hook was provided get the computed value from there
		if ( hooks && "get" in hooks ) {
			val = hooks.get( elem, true, extra );
		}

		// Otherwise, if a way to get the computed value exists, use that
		if ( val === undefined ) {
			val = curCSS( elem, name, styles );
		}

		//convert "normal" to computed value
		if ( val === "normal" && name in cssNormalTransform ) {
			val = cssNormalTransform[ name ];
		}

		// Return, converting to number if forced or a qualifier was provided and val looks numeric
		if ( extra === "" || extra ) {
			num = parseFloat( val );
			return extra === true || jQuery.isNumeric( num ) ? num || 0 : val;
		}
		return val;
	}
});

// NOTE: we've included the "window" in window.getComputedStyle
// because jsdom on node.js will break without it.
if ( window.getComputedStyle ) {
	getStyles = function( elem ) {
		return window.getComputedStyle( elem, null );
	};

	curCSS = function( elem, name, _computed ) {
		var width, minWidth, maxWidth,
			computed = _computed || getStyles( elem ),

			// getPropertyValue is only needed for .css('filter') in IE9, see #12537
			ret = computed ? computed.getPropertyValue( name ) || computed[ name ] : undefined,
			style = elem.style;

		if ( computed ) {

			if ( ret === "" && !jQuery.contains( elem.ownerDocument, elem ) ) {
				ret = jQuery.style( elem, name );
			}

			// A tribute to the "awesome hack by Dean Edwards"
			// Chrome < 17 and Safari 5.0 uses "computed value" instead of "used value" for margin-right
			// Safari 5.1.7 (at least) returns percentage for a larger set of values, but width seems to be reliably pixels
			// this is against the CSSOM draft spec: http://dev.w3.org/csswg/cssom/#resolved-values
			if ( rnumnonpx.test( ret ) && rmargin.test( name ) ) {

				// Remember the original values
				width = style.width;
				minWidth = style.minWidth;
				maxWidth = style.maxWidth;

				// Put in the new values to get a computed value out
				style.minWidth = style.maxWidth = style.width = ret;
				ret = computed.width;

				// Revert the changed values
				style.width = width;
				style.minWidth = minWidth;
				style.maxWidth = maxWidth;
			}
		}

		return ret;
	};
} else if ( document.documentElement.currentStyle ) {
	getStyles = function( elem ) {
		return elem.currentStyle;
	};

	curCSS = function( elem, name, _computed ) {
		var left, rs, rsLeft,
			computed = _computed || getStyles( elem ),
			ret = computed ? computed[ name ] : undefined,
			style = elem.style;

		// Avoid setting ret to empty string here
		// so we don't default to auto
		if ( ret == null && style && style[ name ] ) {
			ret = style[ name ];
		}

		// From the awesome hack by Dean Edwards
		// http://erik.eae.net/archives/2007/07/27/18.54.15/#comment-102291

		// If we're not dealing with a regular pixel number
		// but a number that has a weird ending, we need to convert it to pixels
		// but not position css attributes, as those are proportional to the parent element instead
		// and we can't measure the parent instead because it might trigger a "stacking dolls" problem
		if ( rnumnonpx.test( ret ) && !rposition.test( name ) ) {

			// Remember the original values
			left = style.left;
			rs = elem.runtimeStyle;
			rsLeft = rs && rs.left;

			// Put in the new values to get a computed value out
			if ( rsLeft ) {
				rs.left = elem.currentStyle.left;
			}
			style.left = name === "fontSize" ? "1em" : ret;
			ret = style.pixelLeft + "px";

			// Revert the changed values
			style.left = left;
			if ( rsLeft ) {
				rs.left = rsLeft;
			}
		}

		return ret === "" ? "auto" : ret;
	};
}

function setPositiveNumber( elem, value, subtract ) {
	var matches = rnumsplit.exec( value );
	return matches ?
		// Guard against undefined "subtract", e.g., when used as in cssHooks
		Math.max( 0, matches[ 1 ] - ( subtract || 0 ) ) + ( matches[ 2 ] || "px" ) :
		value;
}

function augmentWidthOrHeight( elem, name, extra, isBorderBox, styles ) {
	var i = extra === ( isBorderBox ? "border" : "content" ) ?
		// If we already have the right measurement, avoid augmentation
		4 :
		// Otherwise initialize for horizontal or vertical properties
		name === "width" ? 1 : 0,

		val = 0;

	for ( ; i < 4; i += 2 ) {
		// both box models exclude margin, so add it if we want it
		if ( extra === "margin" ) {
			val += jQuery.css( elem, extra + cssExpand[ i ], true, styles );
		}

		if ( isBorderBox ) {
			// border-box includes padding, so remove it if we want content
			if ( extra === "content" ) {
				val -= jQuery.css( elem, "padding" + cssExpand[ i ], true, styles );
			}

			// at this point, extra isn't border nor margin, so remove border
			if ( extra !== "margin" ) {
				val -= jQuery.css( elem, "border" + cssExpand[ i ] + "Width", true, styles );
			}
		} else {
			// at this point, extra isn't content, so add padding
			val += jQuery.css( elem, "padding" + cssExpand[ i ], true, styles );

			// at this point, extra isn't content nor padding, so add border
			if ( extra !== "padding" ) {
				val += jQuery.css( elem, "border" + cssExpand[ i ] + "Width", true, styles );
			}
		}
	}

	return val;
}

function getWidthOrHeight( elem, name, extra ) {

	// Start with offset property, which is equivalent to the border-box value
	var valueIsBorderBox = true,
		val = name === "width" ? elem.offsetWidth : elem.offsetHeight,
		styles = getStyles( elem ),
		isBorderBox = jQuery.support.boxSizing && jQuery.css( elem, "boxSizing", false, styles ) === "border-box";

	// some non-html elements return undefined for offsetWidth, so check for null/undefined
	// svg - https://bugzilla.mozilla.org/show_bug.cgi?id=649285
	// MathML - https://bugzilla.mozilla.org/show_bug.cgi?id=491668
	if ( val <= 0 || val == null ) {
		// Fall back to computed then uncomputed css if necessary
		val = curCSS( elem, name, styles );
		if ( val < 0 || val == null ) {
			val = elem.style[ name ];
		}

		// Computed unit is not pixels. Stop here and return.
		if ( rnumnonpx.test(val) ) {
			return val;
		}

		// we need the check for style in case a browser which returns unreliable values
		// for getComputedStyle silently falls back to the reliable elem.style
		valueIsBorderBox = isBorderBox && ( jQuery.support.boxSizingReliable || val === elem.style[ name ] );

		// Normalize "", auto, and prepare for extra
		val = parseFloat( val ) || 0;
	}

	// use the active box-sizing model to add/subtract irrelevant styles
	return ( val +
		augmentWidthOrHeight(
			elem,
			name,
			extra || ( isBorderBox ? "border" : "content" ),
			valueIsBorderBox,
			styles
		)
	) + "px";
}

// Try to determine the default display value of an element
function css_defaultDisplay( nodeName ) {
	var doc = document,
		display = elemdisplay[ nodeName ];

	if ( !display ) {
		display = actualDisplay( nodeName, doc );

		// If the simple way fails, read from inside an iframe
		if ( display === "none" || !display ) {
			// Use the already-created iframe if possible
			iframe = ( iframe ||
				jQuery("<iframe frameborder='0' width='0' height='0'/>")
				.css( "cssText", "display:block !important" )
			).appendTo( doc.documentElement );

			// Always write a new HTML skeleton so Webkit and Firefox don't choke on reuse
			doc = ( iframe[0].contentWindow || iframe[0].contentDocument ).document;
			doc.write("<!doctype html><html><body>");
			doc.close();

			display = actualDisplay( nodeName, doc );
			iframe.detach();
		}

		// Store the correct default display
		elemdisplay[ nodeName ] = display;
	}

	return display;
}

// Called ONLY from within css_defaultDisplay
function actualDisplay( name, doc ) {
	var elem = jQuery( doc.createElement( name ) ).appendTo( doc.body ),
		display = jQuery.css( elem[0], "display" );
	elem.remove();
	return display;
}

jQuery.each([ "height", "width" ], function( i, name ) {
	jQuery.cssHooks[ name ] = {
		get: function( elem, computed, extra ) {
			if ( computed ) {
				// certain elements can have dimension info if we invisibly show them
				// however, it must have a current display style that would benefit from this
				return elem.offsetWidth === 0 && rdisplayswap.test( jQuery.css( elem, "display" ) ) ?
					jQuery.swap( elem, cssShow, function() {
						return getWidthOrHeight( elem, name, extra );
					}) :
					getWidthOrHeight( elem, name, extra );
			}
		},

		set: function( elem, value, extra ) {
			var styles = extra && getStyles( elem );
			return setPositiveNumber( elem, value, extra ?
				augmentWidthOrHeight(
					elem,
					name,
					extra,
					jQuery.support.boxSizing && jQuery.css( elem, "boxSizing", false, styles ) === "border-box",
					styles
				) : 0
			);
		}
	};
});

if ( !jQuery.support.opacity ) {
	jQuery.cssHooks.opacity = {
		get: function( elem, computed ) {
			// IE uses filters for opacity
			return ropacity.test( (computed && elem.currentStyle ? elem.currentStyle.filter : elem.style.filter) || "" ) ?
				( 0.01 * parseFloat( RegExp.$1 ) ) + "" :
				computed ? "1" : "";
		},

		set: function( elem, value ) {
			var style = elem.style,
				currentStyle = elem.currentStyle,
				opacity = jQuery.isNumeric( value ) ? "alpha(opacity=" + value * 100 + ")" : "",
				filter = currentStyle && currentStyle.filter || style.filter || "";

			// IE has trouble with opacity if it does not have layout
			// Force it by setting the zoom level
			style.zoom = 1;

			// if setting opacity to 1, and no other filters exist - attempt to remove filter attribute #6652
			// if value === "", then remove inline opacity #12685
			if ( ( value >= 1 || value === "" ) &&
					jQuery.trim( filter.replace( ralpha, "" ) ) === "" &&
					style.removeAttribute ) {

				// Setting style.filter to null, "" & " " still leave "filter:" in the cssText
				// if "filter:" is present at all, clearType is disabled, we want to avoid this
				// style.removeAttribute is IE Only, but so apparently is this code path...
				style.removeAttribute( "filter" );

				// if there is no filter style applied in a css rule or unset inline opacity, we are done
				if ( value === "" || currentStyle && !currentStyle.filter ) {
					return;
				}
			}

			// otherwise, set new filter values
			style.filter = ralpha.test( filter ) ?
				filter.replace( ralpha, opacity ) :
				filter + " " + opacity;
		}
	};
}

// These hooks cannot be added until DOM ready because the support test
// for it is not run until after DOM ready
jQuery(function() {
	if ( !jQuery.support.reliableMarginRight ) {
		jQuery.cssHooks.marginRight = {
			get: function( elem, computed ) {
				if ( computed ) {
					// WebKit Bug 13343 - getComputedStyle returns wrong value for margin-right
					// Work around by temporarily setting element display to inline-block
					return jQuery.swap( elem, { "display": "inline-block" },
						curCSS, [ elem, "marginRight" ] );
				}
			}
		};
	}

	// Webkit bug: https://bugs.webkit.org/show_bug.cgi?id=29084
	// getComputedStyle returns percent when specified for top/left/bottom/right
	// rather than make the css module depend on the offset module, we just check for it here
	if ( !jQuery.support.pixelPosition && jQuery.fn.position ) {
		jQuery.each( [ "top", "left" ], function( i, prop ) {
			jQuery.cssHooks[ prop ] = {
				get: function( elem, computed ) {
					if ( computed ) {
						computed = curCSS( elem, prop );
						// if curCSS returns percentage, fallback to offset
						return rnumnonpx.test( computed ) ?
							jQuery( elem ).position()[ prop ] + "px" :
							computed;
					}
				}
			};
		});
	}

});

if ( jQuery.expr && jQuery.expr.filters ) {
	jQuery.expr.filters.hidden = function( elem ) {
		// Support: Opera <= 12.12
		// Opera reports offsetWidths and offsetHeights less than zero on some elements
		return elem.offsetWidth <= 0 && elem.offsetHeight <= 0 ||
			(!jQuery.support.reliableHiddenOffsets && ((elem.style && elem.style.display) || jQuery.css( elem, "display" )) === "none");
	};

	jQuery.expr.filters.visible = function( elem ) {
		return !jQuery.expr.filters.hidden( elem );
	};
}

// These hooks are used by animate to expand properties
jQuery.each({
	margin: "",
	padding: "",
	border: "Width"
}, function( prefix, suffix ) {
	jQuery.cssHooks[ prefix + suffix ] = {
		expand: function( value ) {
			var i = 0,
				expanded = {},

				// assumes a single number if not a string
				parts = typeof value === "string" ? value.split(" ") : [ value ];

			for ( ; i < 4; i++ ) {
				expanded[ prefix + cssExpand[ i ] + suffix ] =
					parts[ i ] || parts[ i - 2 ] || parts[ 0 ];
			}

			return expanded;
		}
	};

	if ( !rmargin.test( prefix ) ) {
		jQuery.cssHooks[ prefix + suffix ].set = setPositiveNumber;
	}
});
var r20 = /%20/g,
	rbracket = /\[\]$/,
	rCRLF = /\r?\n/g,
	rsubmitterTypes = /^(?:submit|button|image|reset|file)$/i,
	rsubmittable = /^(?:input|select|textarea|keygen)/i;

jQuery.fn.extend({
	serialize: function() {
		return jQuery.param( this.serializeArray() );
	},
	serializeArray: function() {
		return this.map(function(){
			// Can add propHook for "elements" to filter or add form elements
			var elements = jQuery.prop( this, "elements" );
			return elements ? jQuery.makeArray( elements ) : this;
		})
		.filter(function(){
			var type = this.type;
			// Use .is(":disabled") so that fieldset[disabled] works
			return this.name && !jQuery( this ).is( ":disabled" ) &&
				rsubmittable.test( this.nodeName ) && !rsubmitterTypes.test( type ) &&
				( this.checked || !manipulation_rcheckableType.test( type ) );
		})
		.map(function( i, elem ){
			var val = jQuery( this ).val();

			return val == null ?
				null :
				jQuery.isArray( val ) ?
					jQuery.map( val, function( val ){
						return { name: elem.name, value: val.replace( rCRLF, "\r\n" ) };
					}) :
					{ name: elem.name, value: val.replace( rCRLF, "\r\n" ) };
		}).get();
	}
});

//Serialize an array of form elements or a set of
//key/values into a query string
jQuery.param = function( a, traditional ) {
	var prefix,
		s = [],
		add = function( key, value ) {
			// If value is a function, invoke it and return its value
			value = jQuery.isFunction( value ) ? value() : ( value == null ? "" : value );
			s[ s.length ] = encodeURIComponent( key ) + "=" + encodeURIComponent( value );
		};

	// Set traditional to true for jQuery <= 1.3.2 behavior.
	if ( traditional === undefined ) {
		traditional = jQuery.ajaxSettings && jQuery.ajaxSettings.traditional;
	}

	// If an array was passed in, assume that it is an array of form elements.
	if ( jQuery.isArray( a ) || ( a.jquery && !jQuery.isPlainObject( a ) ) ) {
		// Serialize the form elements
		jQuery.each( a, function() {
			add( this.name, this.value );
		});

	} else {
		// If traditional, encode the "old" way (the way 1.3.2 or older
		// did it), otherwise encode params recursively.
		for ( prefix in a ) {
			buildParams( prefix, a[ prefix ], traditional, add );
		}
	}

	// Return the resulting serialization
	return s.join( "&" ).replace( r20, "+" );
};

function buildParams( prefix, obj, traditional, add ) {
	var name;

	if ( jQuery.isArray( obj ) ) {
		// Serialize array item.
		jQuery.each( obj, function( i, v ) {
			if ( traditional || rbracket.test( prefix ) ) {
				// Treat each array item as a scalar.
				add( prefix, v );

			} else {
				// Item is non-scalar (array or object), encode its numeric index.
				buildParams( prefix + "[" + ( typeof v === "object" ? i : "" ) + "]", v, traditional, add );
			}
		});

	} else if ( !traditional && jQuery.type( obj ) === "object" ) {
		// Serialize object item.
		for ( name in obj ) {
			buildParams( prefix + "[" + name + "]", obj[ name ], traditional, add );
		}

	} else {
		// Serialize scalar item.
		add( prefix, obj );
	}
}
jQuery.each( ("blur focus focusin focusout load resize scroll unload click dblclick " +
	"mousedown mouseup mousemove mouseover mouseout mouseenter mouseleave " +
	"change select submit keydown keypress keyup error contextmenu").split(" "), function( i, name ) {

	// Handle event binding
	jQuery.fn[ name ] = function( data, fn ) {
		return arguments.length > 0 ?
			this.on( name, null, data, fn ) :
			this.trigger( name );
	};
});

jQuery.fn.extend({
	hover: function( fnOver, fnOut ) {
		return this.mouseenter( fnOver ).mouseleave( fnOut || fnOver );
	},

	bind: function( types, data, fn ) {
		return this.on( types, null, data, fn );
	},
	unbind: function( types, fn ) {
		return this.off( types, null, fn );
	},

	delegate: function( selector, types, data, fn ) {
		return this.on( types, selector, data, fn );
	},
	undelegate: function( selector, types, fn ) {
		// ( namespace ) or ( selector, types [, fn] )
		return arguments.length === 1 ? this.off( selector, "**" ) : this.off( types, selector || "**", fn );
	}
});
var
	// Document location
	ajaxLocParts,
	ajaxLocation,
	ajax_nonce = jQuery.now(),

	ajax_rquery = /\?/,
	rhash = /#.*$/,
	rts = /([?&])_=[^&]*/,
	rheaders = /^(.*?):[ \t]*([^\r\n]*)\r?$/mg, // IE leaves an \r character at EOL
	// #7653, #8125, #8152: local protocol detection
	rlocalProtocol = /^(?:about|app|app-storage|.+-extension|file|res|widget):$/,
	rnoContent = /^(?:GET|HEAD)$/,
	rprotocol = /^\/\//,
	rurl = /^([\w.+-]+:)(?:\/\/([^\/?#:]*)(?::(\d+)|)|)/,

	// Keep a copy of the old load method
	_load = jQuery.fn.load,

	/* Prefilters
	 * 1) They are useful to introduce custom dataTypes (see ajax/jsonp.js for an example)
	 * 2) These are called:
	 *    - BEFORE asking for a transport
	 *    - AFTER param serialization (s.data is a string if s.processData is true)
	 * 3) key is the dataType
	 * 4) the catchall symbol "*" can be used
	 * 5) execution will start with transport dataType and THEN continue down to "*" if needed
	 */
	prefilters = {},

	/* Transports bindings
	 * 1) key is the dataType
	 * 2) the catchall symbol "*" can be used
	 * 3) selection will start with transport dataType and THEN go to "*" if needed
	 */
	transports = {},

	// Avoid comment-prolog char sequence (#10098); must appease lint and evade compression
	allTypes = "*/".concat("*");

// #8138, IE may throw an exception when accessing
// a field from window.location if document.domain has been set
try {
	ajaxLocation = location.href;
} catch( e ) {
	// Use the href attribute of an A element
	// since IE will modify it given document.location
	ajaxLocation = document.createElement( "a" );
	ajaxLocation.href = "";
	ajaxLocation = ajaxLocation.href;
}

// Segment location into parts
ajaxLocParts = rurl.exec( ajaxLocation.toLowerCase() ) || [];

// Base "constructor" for jQuery.ajaxPrefilter and jQuery.ajaxTransport
function addToPrefiltersOrTransports( structure ) {

	// dataTypeExpression is optional and defaults to "*"
	return function( dataTypeExpression, func ) {

		if ( typeof dataTypeExpression !== "string" ) {
			func = dataTypeExpression;
			dataTypeExpression = "*";
		}

		var dataType,
			i = 0,
			dataTypes = dataTypeExpression.toLowerCase().match( core_rnotwhite ) || [];

		if ( jQuery.isFunction( func ) ) {
			// For each dataType in the dataTypeExpression
			while ( (dataType = dataTypes[i++]) ) {
				// Prepend if requested
				if ( dataType[0] === "+" ) {
					dataType = dataType.slice( 1 ) || "*";
					(structure[ dataType ] = structure[ dataType ] || []).unshift( func );

				// Otherwise append
				} else {
					(structure[ dataType ] = structure[ dataType ] || []).push( func );
				}
			}
		}
	};
}

// Base inspection function for prefilters and transports
function inspectPrefiltersOrTransports( structure, options, originalOptions, jqXHR ) {

	var inspected = {},
		seekingTransport = ( structure === transports );

	function inspect( dataType ) {
		var selected;
		inspected[ dataType ] = true;
		jQuery.each( structure[ dataType ] || [], function( _, prefilterOrFactory ) {
			var dataTypeOrTransport = prefilterOrFactory( options, originalOptions, jqXHR );
			if( typeof dataTypeOrTransport === "string" && !seekingTransport && !inspected[ dataTypeOrTransport ] ) {
				options.dataTypes.unshift( dataTypeOrTransport );
				inspect( dataTypeOrTransport );
				return false;
			} else if ( seekingTransport ) {
				return !( selected = dataTypeOrTransport );
			}
		});
		return selected;
	}

	return inspect( options.dataTypes[ 0 ] ) || !inspected[ "*" ] && inspect( "*" );
}

// A special extend for ajax options
// that takes "flat" options (not to be deep extended)
// Fixes #9887
function ajaxExtend( target, src ) {
	var deep, key,
		flatOptions = jQuery.ajaxSettings.flatOptions || {};

	for ( key in src ) {
		if ( src[ key ] !== undefined ) {
			( flatOptions[ key ] ? target : ( deep || (deep = {}) ) )[ key ] = src[ key ];
		}
	}
	if ( deep ) {
		jQuery.extend( true, target, deep );
	}

	return target;
}

jQuery.fn.load = function( url, params, callback ) {
	if ( typeof url !== "string" && _load ) {
		return _load.apply( this, arguments );
	}

	var selector, response, type,
		self = this,
		off = url.indexOf(" ");

	if ( off >= 0 ) {
		selector = url.slice( off, url.length );
		url = url.slice( 0, off );
	}

	// If it's a function
	if ( jQuery.isFunction( params ) ) {

		// We assume that it's the callback
		callback = params;
		params = undefined;

	// Otherwise, build a param string
	} else if ( params && typeof params === "object" ) {
		type = "POST";
	}

	// If we have elements to modify, make the request
	if ( self.length > 0 ) {
		jQuery.ajax({
			url: url,

			// if "type" variable is undefined, then "GET" method will be used
			type: type,
			dataType: "html",
			data: params
		}).done(function( responseText ) {

			// Save response for use in complete callback
			response = arguments;

			self.html( selector ?

				// If a selector was specified, locate the right elements in a dummy div
				// Exclude scripts to avoid IE 'Permission Denied' errors
				jQuery("<div>").append( jQuery.parseHTML( responseText ) ).find( selector ) :

				// Otherwise use the full result
				responseText );

		}).complete( callback && function( jqXHR, status ) {
			self.each( callback, response || [ jqXHR.responseText, status, jqXHR ] );
		});
	}

	return this;
};

// Attach a bunch of functions for handling common AJAX events
jQuery.each( [ "ajaxStart", "ajaxStop", "ajaxComplete", "ajaxError", "ajaxSuccess", "ajaxSend" ], function( i, type ){
	jQuery.fn[ type ] = function( fn ){
		return this.on( type, fn );
	};
});

jQuery.extend({

	// Counter for holding the number of active queries
	active: 0,

	// Last-Modified header cache for next request
	lastModified: {},
	etag: {},

	ajaxSettings: {
		url: ajaxLocation,
		type: "GET",
		isLocal: rlocalProtocol.test( ajaxLocParts[ 1 ] ),
		global: true,
		processData: true,
		async: true,
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		/*
		timeout: 0,
		data: null,
		dataType: null,
		username: null,
		password: null,
		cache: null,
		throws: false,
		traditional: false,
		headers: {},
		*/

		accepts: {
			"*": allTypes,
			text: "text/plain",
			html: "text/html",
			xml: "application/xml, text/xml",
			json: "application/json, text/javascript"
		},

		contents: {
			xml: /xml/,
			html: /html/,
			json: /json/
		},

		responseFields: {
			xml: "responseXML",
			text: "responseText",
			json: "responseJSON"
		},

		// Data converters
		// Keys separate source (or catchall "*") and destination types with a single space
		converters: {

			// Convert anything to text
			"* text": String,

			// Text to html (true = no transformation)
			"text html": true,

			// Evaluate text as a json expression
			"text json": jQuery.parseJSON,

			// Parse text as xml
			"text xml": jQuery.parseXML
		},

		// For options that shouldn't be deep extended:
		// you can add your own custom options here if
		// and when you create one that shouldn't be
		// deep extended (see ajaxExtend)
		flatOptions: {
			url: true,
			context: true
		}
	},

	// Creates a full fledged settings object into target
	// with both ajaxSettings and settings fields.
	// If target is omitted, writes into ajaxSettings.
	ajaxSetup: function( target, settings ) {
		return settings ?

			// Building a settings object
			ajaxExtend( ajaxExtend( target, jQuery.ajaxSettings ), settings ) :

			// Extending ajaxSettings
			ajaxExtend( jQuery.ajaxSettings, target );
	},

	ajaxPrefilter: addToPrefiltersOrTransports( prefilters ),
	ajaxTransport: addToPrefiltersOrTransports( transports ),

	// Main method
	ajax: function( url, options ) {

		// If url is an object, simulate pre-1.5 signature
		if ( typeof url === "object" ) {
			options = url;
			url = undefined;
		}

		// Force options to be an object
		options = options || {};

		var // Cross-domain detection vars
			parts,
			// Loop variable
			i,
			// URL without anti-cache param
			cacheURL,
			// Response headers as string
			responseHeadersString,
			// timeout handle
			timeoutTimer,

			// To know if global events are to be dispatched
			fireGlobals,

			transport,
			// Response headers
			responseHeaders,
			// Create the final options object
			s = jQuery.ajaxSetup( {}, options ),
			// Callbacks context
			callbackContext = s.context || s,
			// Context for global events is callbackContext if it is a DOM node or jQuery collection
			globalEventContext = s.context && ( callbackContext.nodeType || callbackContext.jquery ) ?
				jQuery( callbackContext ) :
				jQuery.event,
			// Deferreds
			deferred = jQuery.Deferred(),
			completeDeferred = jQuery.Callbacks("once memory"),
			// Status-dependent callbacks
			statusCode = s.statusCode || {},
			// Headers (they are sent all at once)
			requestHeaders = {},
			requestHeadersNames = {},
			// The jqXHR state
			state = 0,
			// Default abort message
			strAbort = "canceled",
			// Fake xhr
			jqXHR = {
				readyState: 0,

				// Builds headers hashtable if needed
				getResponseHeader: function( key ) {
					var match;
					if ( state === 2 ) {
						if ( !responseHeaders ) {
							responseHeaders = {};
							while ( (match = rheaders.exec( responseHeadersString )) ) {
								responseHeaders[ match[1].toLowerCase() ] = match[ 2 ];
							}
						}
						match = responseHeaders[ key.toLowerCase() ];
					}
					return match == null ? null : match;
				},

				// Raw string
				getAllResponseHeaders: function() {
					return state === 2 ? responseHeadersString : null;
				},

				// Caches the header
				setRequestHeader: function( name, value ) {
					var lname = name.toLowerCase();
					if ( !state ) {
						name = requestHeadersNames[ lname ] = requestHeadersNames[ lname ] || name;
						requestHeaders[ name ] = value;
					}
					return this;
				},

				// Overrides response content-type header
				overrideMimeType: function( type ) {
					if ( !state ) {
						s.mimeType = type;
					}
					return this;
				},

				// Status-dependent callbacks
				statusCode: function( map ) {
					var code;
					if ( map ) {
						if ( state < 2 ) {
							for ( code in map ) {
								// Lazy-add the new callback in a way that preserves old ones
								statusCode[ code ] = [ statusCode[ code ], map[ code ] ];
							}
						} else {
							// Execute the appropriate callbacks
							jqXHR.always( map[ jqXHR.status ] );
						}
					}
					return this;
				},

				// Cancel the request
				abort: function( statusText ) {
					var finalText = statusText || strAbort;
					if ( transport ) {
						transport.abort( finalText );
					}
					done( 0, finalText );
					return this;
				}
			};

		// Attach deferreds
		deferred.promise( jqXHR ).complete = completeDeferred.add;
		jqXHR.success = jqXHR.done;
		jqXHR.error = jqXHR.fail;

		// Remove hash character (#7531: and string promotion)
		// Add protocol if not provided (#5866: IE7 issue with protocol-less urls)
		// Handle falsy url in the settings object (#10093: consistency with old signature)
		// We also use the url parameter if available
		s.url = ( ( url || s.url || ajaxLocation ) + "" ).replace( rhash, "" ).replace( rprotocol, ajaxLocParts[ 1 ] + "//" );

		// Alias method option to type as per ticket #12004
		s.type = options.method || options.type || s.method || s.type;

		// Extract dataTypes list
		s.dataTypes = jQuery.trim( s.dataType || "*" ).toLowerCase().match( core_rnotwhite ) || [""];

		// A cross-domain request is in order when we have a protocol:host:port mismatch
		if ( s.crossDomain == null ) {
			parts = rurl.exec( s.url.toLowerCase() );
			s.crossDomain = !!( parts &&
				( parts[ 1 ] !== ajaxLocParts[ 1 ] || parts[ 2 ] !== ajaxLocParts[ 2 ] ||
					( parts[ 3 ] || ( parts[ 1 ] === "http:" ? "80" : "443" ) ) !==
						( ajaxLocParts[ 3 ] || ( ajaxLocParts[ 1 ] === "http:" ? "80" : "443" ) ) )
			);
		}

		// Convert data if not already a string
		if ( s.data && s.processData && typeof s.data !== "string" ) {
			s.data = jQuery.param( s.data, s.traditional );
		}

		// Apply prefilters
		inspectPrefiltersOrTransports( prefilters, s, options, jqXHR );

		// If request was aborted inside a prefilter, stop there
		if ( state === 2 ) {
			return jqXHR;
		}

		// We can fire global events as of now if asked to
		fireGlobals = s.global;

		// Watch for a new set of requests
		if ( fireGlobals && jQuery.active++ === 0 ) {
			jQuery.event.trigger("ajaxStart");
		}

		// Uppercase the type
		s.type = s.type.toUpperCase();

		// Determine if request has content
		s.hasContent = !rnoContent.test( s.type );

		// Save the URL in case we're toying with the If-Modified-Since
		// and/or If-None-Match header later on
		cacheURL = s.url;

		// More options handling for requests with no content
		if ( !s.hasContent ) {

			// If data is available, append data to url
			if ( s.data ) {
				cacheURL = ( s.url += ( ajax_rquery.test( cacheURL ) ? "&" : "?" ) + s.data );
				// #9682: remove data so that it's not used in an eventual retry
				delete s.data;
			}

			// Add anti-cache in url if needed
			if ( s.cache === false ) {
				s.url = rts.test( cacheURL ) ?

					// If there is already a '_' parameter, set its value
					cacheURL.replace( rts, "$1_=" + ajax_nonce++ ) :

					// Otherwise add one to the end
					cacheURL + ( ajax_rquery.test( cacheURL ) ? "&" : "?" ) + "_=" + ajax_nonce++;
			}
		}

		// Set the If-Modified-Since and/or If-None-Match header, if in ifModified mode.
		if ( s.ifModified ) {
			if ( jQuery.lastModified[ cacheURL ] ) {
				jqXHR.setRequestHeader( "If-Modified-Since", jQuery.lastModified[ cacheURL ] );
			}
			if ( jQuery.etag[ cacheURL ] ) {
				jqXHR.setRequestHeader( "If-None-Match", jQuery.etag[ cacheURL ] );
			}
		}

		// Set the correct header, if data is being sent
		if ( s.data && s.hasContent && s.contentType !== false || options.contentType ) {
			jqXHR.setRequestHeader( "Content-Type", s.contentType );
		}

		// Set the Accepts header for the server, depending on the dataType
		jqXHR.setRequestHeader(
			"Accept",
			s.dataTypes[ 0 ] && s.accepts[ s.dataTypes[0] ] ?
				s.accepts[ s.dataTypes[0] ] + ( s.dataTypes[ 0 ] !== "*" ? ", " + allTypes + "; q=0.01" : "" ) :
				s.accepts[ "*" ]
		);

		// Check for headers option
		for ( i in s.headers ) {
			jqXHR.setRequestHeader( i, s.headers[ i ] );
		}

		// Allow custom headers/mimetypes and early abort
		if ( s.beforeSend && ( s.beforeSend.call( callbackContext, jqXHR, s ) === false || state === 2 ) ) {
			// Abort if not done already and return
			return jqXHR.abort();
		}

		// aborting is no longer a cancellation
		strAbort = "abort";

		// Install callbacks on deferreds
		for ( i in { success: 1, error: 1, complete: 1 } ) {
			jqXHR[ i ]( s[ i ] );
		}

		// Get transport
		transport = inspectPrefiltersOrTransports( transports, s, options, jqXHR );

		// If no transport, we auto-abort
		if ( !transport ) {
			done( -1, "No Transport" );
		} else {
			jqXHR.readyState = 1;

			// Send global event
			if ( fireGlobals ) {
				globalEventContext.trigger( "ajaxSend", [ jqXHR, s ] );
			}
			// Timeout
			if ( s.async && s.timeout > 0 ) {
				timeoutTimer = setTimeout(function() {
					jqXHR.abort("timeout");
				}, s.timeout );
			}

			try {
				state = 1;
				transport.send( requestHeaders, done );
			} catch ( e ) {
				// Propagate exception as error if not done
				if ( state < 2 ) {
					done( -1, e );
				// Simply rethrow otherwise
				} else {
					throw e;
				}
			}
		}

		// Callback for when everything is done
		function done( status, nativeStatusText, responses, headers ) {
			var isSuccess, success, error, response, modified,
				statusText = nativeStatusText;

			// Called once
			if ( state === 2 ) {
				return;
			}

			// State is "done" now
			state = 2;

			// Clear timeout if it exists
			if ( timeoutTimer ) {
				clearTimeout( timeoutTimer );
			}

			// Dereference transport for early garbage collection
			// (no matter how long the jqXHR object will be used)
			transport = undefined;

			// Cache response headers
			responseHeadersString = headers || "";

			// Set readyState
			jqXHR.readyState = status > 0 ? 4 : 0;

			// Determine if successful
			isSuccess = status >= 200 && status < 300 || status === 304;

			// Get response data
			if ( responses ) {
				response = ajaxHandleResponses( s, jqXHR, responses );
			}

			// Convert no matter what (that way responseXXX fields are always set)
			response = ajaxConvert( s, response, jqXHR, isSuccess );

			// If successful, handle type chaining
			if ( isSuccess ) {

				// Set the If-Modified-Since and/or If-None-Match header, if in ifModified mode.
				if ( s.ifModified ) {
					modified = jqXHR.getResponseHeader("Last-Modified");
					if ( modified ) {
						jQuery.lastModified[ cacheURL ] = modified;
					}
					modified = jqXHR.getResponseHeader("etag");
					if ( modified ) {
						jQuery.etag[ cacheURL ] = modified;
					}
				}

				// if no content
				if ( status === 204 || s.type === "HEAD" ) {
					statusText = "nocontent";

				// if not modified
				} else if ( status === 304 ) {
					statusText = "notmodified";

				// If we have data, let's convert it
				} else {
					statusText = response.state;
					success = response.data;
					error = response.error;
					isSuccess = !error;
				}
			} else {
				// We extract error from statusText
				// then normalize statusText and status for non-aborts
				error = statusText;
				if ( status || !statusText ) {
					statusText = "error";
					if ( status < 0 ) {
						status = 0;
					}
				}
			}

			// Set data for the fake xhr object
			jqXHR.status = status;
			jqXHR.statusText = ( nativeStatusText || statusText ) + "";

			// Success/Error
			if ( isSuccess ) {
				deferred.resolveWith( callbackContext, [ success, statusText, jqXHR ] );
			} else {
				deferred.rejectWith( callbackContext, [ jqXHR, statusText, error ] );
			}

			// Status-dependent callbacks
			jqXHR.statusCode( statusCode );
			statusCode = undefined;

			if ( fireGlobals ) {
				globalEventContext.trigger( isSuccess ? "ajaxSuccess" : "ajaxError",
					[ jqXHR, s, isSuccess ? success : error ] );
			}

			// Complete
			completeDeferred.fireWith( callbackContext, [ jqXHR, statusText ] );

			if ( fireGlobals ) {
				globalEventContext.trigger( "ajaxComplete", [ jqXHR, s ] );
				// Handle the global AJAX counter
				if ( !( --jQuery.active ) ) {
					jQuery.event.trigger("ajaxStop");
				}
			}
		}

		return jqXHR;
	},

	getJSON: function( url, data, callback ) {
		return jQuery.get( url, data, callback, "json" );
	},

	getScript: function( url, callback ) {
		return jQuery.get( url, undefined, callback, "script" );
	}
});

jQuery.each( [ "get", "post" ], function( i, method ) {
	jQuery[ method ] = function( url, data, callback, type ) {
		// shift arguments if data argument was omitted
		if ( jQuery.isFunction( data ) ) {
			type = type || callback;
			callback = data;
			data = undefined;
		}

		return jQuery.ajax({
			url: url,
			type: method,
			dataType: type,
			data: data,
			success: callback
		});
	};
});

/* Handles responses to an ajax request:
 * - finds the right dataType (mediates between content-type and expected dataType)
 * - returns the corresponding response
 */
function ajaxHandleResponses( s, jqXHR, responses ) {
	var firstDataType, ct, finalDataType, type,
		contents = s.contents,
		dataTypes = s.dataTypes;

	// Remove auto dataType and get content-type in the process
	while( dataTypes[ 0 ] === "*" ) {
		dataTypes.shift();
		if ( ct === undefined ) {
			ct = s.mimeType || jqXHR.getResponseHeader("Content-Type");
		}
	}

	// Check if we're dealing with a known content-type
	if ( ct ) {
		for ( type in contents ) {
			if ( contents[ type ] && contents[ type ].test( ct ) ) {
				dataTypes.unshift( type );
				break;
			}
		}
	}

	// Check to see if we have a response for the expected dataType
	if ( dataTypes[ 0 ] in responses ) {
		finalDataType = dataTypes[ 0 ];
	} else {
		// Try convertible dataTypes
		for ( type in responses ) {
			if ( !dataTypes[ 0 ] || s.converters[ type + " " + dataTypes[0] ] ) {
				finalDataType = type;
				break;
			}
			if ( !firstDataType ) {
				firstDataType = type;
			}
		}
		// Or just use first one
		finalDataType = finalDataType || firstDataType;
	}

	// If we found a dataType
	// We add the dataType to the list if needed
	// and return the corresponding response
	if ( finalDataType ) {
		if ( finalDataType !== dataTypes[ 0 ] ) {
			dataTypes.unshift( finalDataType );
		}
		return responses[ finalDataType ];
	}
}

/* Chain conversions given the request and the original response
 * Also sets the responseXXX fields on the jqXHR instance
 */
function ajaxConvert( s, response, jqXHR, isSuccess ) {
	var conv2, current, conv, tmp, prev,
		converters = {},
		// Work with a copy of dataTypes in case we need to modify it for conversion
		dataTypes = s.dataTypes.slice();

	// Create converters map with lowercased keys
	if ( dataTypes[ 1 ] ) {
		for ( conv in s.converters ) {
			converters[ conv.toLowerCase() ] = s.converters[ conv ];
		}
	}

	current = dataTypes.shift();

	// Convert to each sequential dataType
	while ( current ) {

		if ( s.responseFields[ current ] ) {
			jqXHR[ s.responseFields[ current ] ] = response;
		}

		// Apply the dataFilter if provided
		if ( !prev && isSuccess && s.dataFilter ) {
			response = s.dataFilter( response, s.dataType );
		}

		prev = current;
		current = dataTypes.shift();

		if ( current ) {

			// There's only work to do if current dataType is non-auto
			if ( current === "*" ) {

				current = prev;

			// Convert response if prev dataType is non-auto and differs from current
			} else if ( prev !== "*" && prev !== current ) {

				// Seek a direct converter
				conv = converters[ prev + " " + current ] || converters[ "* " + current ];

				// If none found, seek a pair
				if ( !conv ) {
					for ( conv2 in converters ) {

						// If conv2 outputs current
						tmp = conv2.split( " " );
						if ( tmp[ 1 ] === current ) {

							// If prev can be converted to accepted input
							conv = converters[ prev + " " + tmp[ 0 ] ] ||
								converters[ "* " + tmp[ 0 ] ];
							if ( conv ) {
								// Condense equivalence converters
								if ( conv === true ) {
									conv = converters[ conv2 ];

								// Otherwise, insert the intermediate dataType
								} else if ( converters[ conv2 ] !== true ) {
									current = tmp[ 0 ];
									dataTypes.unshift( tmp[ 1 ] );
								}
								break;
							}
						}
					}
				}

				// Apply converter (if not an equivalence)
				if ( conv !== true ) {

					// Unless errors are allowed to bubble, catch and return them
					if ( conv && s[ "throws" ] ) {
						response = conv( response );
					} else {
						try {
							response = conv( response );
						} catch ( e ) {
							return { state: "parsererror", error: conv ? e : "No conversion from " + prev + " to " + current };
						}
					}
				}
			}
		}
	}

	return { state: "success", data: response };
}
// Install script dataType
jQuery.ajaxSetup({
	accepts: {
		script: "text/javascript, application/javascript, application/ecmascript, application/x-ecmascript"
	},
	contents: {
		script: /(?:java|ecma)script/
	},
	converters: {
		"text script": function( text ) {
			jQuery.globalEval( text );
			return text;
		}
	}
});

// Handle cache's special case and global
jQuery.ajaxPrefilter( "script", function( s ) {
	if ( s.cache === undefined ) {
		s.cache = false;
	}
	if ( s.crossDomain ) {
		s.type = "GET";
		s.global = false;
	}
});

// Bind script tag hack transport
jQuery.ajaxTransport( "script", function(s) {

	// This transport only deals with cross domain requests
	if ( s.crossDomain ) {

		var script,
			head = document.head || jQuery("head")[0] || document.documentElement;

		return {

			send: function( _, callback ) {

				script = document.createElement("script");

				script.async = true;

				if ( s.scriptCharset ) {
					script.charset = s.scriptCharset;
				}

				script.src = s.url;

				// Attach handlers for all browsers
				script.onload = script.onreadystatechange = function( _, isAbort ) {

					if ( isAbort || !script.readyState || /loaded|complete/.test( script.readyState ) ) {

						// Handle memory leak in IE
						script.onload = script.onreadystatechange = null;

						// Remove the script
						if ( script.parentNode ) {
							script.parentNode.removeChild( script );
						}

						// Dereference the script
						script = null;

						// Callback if not abort
						if ( !isAbort ) {
							callback( 200, "success" );
						}
					}
				};

				// Circumvent IE6 bugs with base elements (#2709 and #4378) by prepending
				// Use native DOM manipulation to avoid our domManip AJAX trickery
				head.insertBefore( script, head.firstChild );
			},

			abort: function() {
				if ( script ) {
					script.onload( undefined, true );
				}
			}
		};
	}
});
var oldCallbacks = [],
	rjsonp = /(=)\?(?=&|$)|\?\?/;

// Default jsonp settings
jQuery.ajaxSetup({
	jsonp: "callback",
	jsonpCallback: function() {
		var callback = oldCallbacks.pop() || ( jQuery.expando + "_" + ( ajax_nonce++ ) );
		this[ callback ] = true;
		return callback;
	}
});

// Detect, normalize options and install callbacks for jsonp requests
jQuery.ajaxPrefilter( "json jsonp", function( s, originalSettings, jqXHR ) {

	var callbackName, overwritten, responseContainer,
		jsonProp = s.jsonp !== false && ( rjsonp.test( s.url ) ?
			"url" :
			typeof s.data === "string" && !( s.contentType || "" ).indexOf("application/x-www-form-urlencoded") && rjsonp.test( s.data ) && "data"
		);

	// Handle iff the expected data type is "jsonp" or we have a parameter to set
	if ( jsonProp || s.dataTypes[ 0 ] === "jsonp" ) {

		// Get callback name, remembering preexisting value associated with it
		callbackName = s.jsonpCallback = jQuery.isFunction( s.jsonpCallback ) ?
			s.jsonpCallback() :
			s.jsonpCallback;

		// Insert callback into url or form data
		if ( jsonProp ) {
			s[ jsonProp ] = s[ jsonProp ].replace( rjsonp, "$1" + callbackName );
		} else if ( s.jsonp !== false ) {
			s.url += ( ajax_rquery.test( s.url ) ? "&" : "?" ) + s.jsonp + "=" + callbackName;
		}

		// Use data converter to retrieve json after script execution
		s.converters["script json"] = function() {
			if ( !responseContainer ) {
				jQuery.error( callbackName + " was not called" );
			}
			return responseContainer[ 0 ];
		};

		// force json dataType
		s.dataTypes[ 0 ] = "json";

		// Install callback
		overwritten = window[ callbackName ];
		window[ callbackName ] = function() {
			responseContainer = arguments;
		};

		// Clean-up function (fires after converters)
		jqXHR.always(function() {
			// Restore preexisting value
			window[ callbackName ] = overwritten;

			// Save back as free
			if ( s[ callbackName ] ) {
				// make sure that re-using the options doesn't screw things around
				s.jsonpCallback = originalSettings.jsonpCallback;

				// save the callback name for future use
				oldCallbacks.push( callbackName );
			}

			// Call if it was a function and we have a response
			if ( responseContainer && jQuery.isFunction( overwritten ) ) {
				overwritten( responseContainer[ 0 ] );
			}

			responseContainer = overwritten = undefined;
		});

		// Delegate to script
		return "script";
	}
});
var xhrCallbacks, xhrSupported,
	xhrId = 0,
	// #5280: Internet Explorer will keep connections alive if we don't abort on unload
	xhrOnUnloadAbort = window.ActiveXObject && function() {
		// Abort all pending requests
		var key;
		for ( key in xhrCallbacks ) {
			xhrCallbacks[ key ]( undefined, true );
		}
	};

// Functions to create xhrs
function createStandardXHR() {
	try {
		return new window.XMLHttpRequest();
	} catch( e ) {}
}

function createActiveXHR() {
	try {
		return new window.ActiveXObject("Microsoft.XMLHTTP");
	} catch( e ) {}
}

// Create the request object
// (This is still attached to ajaxSettings for backward compatibility)
jQuery.ajaxSettings.xhr = window.ActiveXObject ?
	/* Microsoft failed to properly
	 * implement the XMLHttpRequest in IE7 (can't request local files),
	 * so we use the ActiveXObject when it is available
	 * Additionally XMLHttpRequest can be disabled in IE7/IE8 so
	 * we need a fallback.
	 */
	function() {
		return !this.isLocal && createStandardXHR() || createActiveXHR();
	} :
	// For all other browsers, use the standard XMLHttpRequest object
	createStandardXHR;

// Determine support properties
xhrSupported = jQuery.ajaxSettings.xhr();
jQuery.support.cors = !!xhrSupported && ( "withCredentials" in xhrSupported );
xhrSupported = jQuery.support.ajax = !!xhrSupported;

// Create transport if the browser can provide an xhr
if ( xhrSupported ) {

	jQuery.ajaxTransport(function( s ) {
		// Cross domain only allowed if supported through XMLHttpRequest
		if ( !s.crossDomain || jQuery.support.cors ) {

			var callback;

			return {
				send: function( headers, complete ) {

					// Get a new xhr
					var handle, i,
						xhr = s.xhr();

					// Open the socket
					// Passing null username, generates a login popup on Opera (#2865)
					if ( s.username ) {
						xhr.open( s.type, s.url, s.async, s.username, s.password );
					} else {
						xhr.open( s.type, s.url, s.async );
					}

					// Apply custom fields if provided
					if ( s.xhrFields ) {
						for ( i in s.xhrFields ) {
							xhr[ i ] = s.xhrFields[ i ];
						}
					}

					// Override mime type if needed
					if ( s.mimeType && xhr.overrideMimeType ) {
						xhr.overrideMimeType( s.mimeType );
					}

					// X-Requested-With header
					// For cross-domain requests, seeing as conditions for a preflight are
					// akin to a jigsaw puzzle, we simply never set it to be sure.
					// (it can always be set on a per-request basis or even using ajaxSetup)
					// For same-domain requests, won't change header if already provided.
					if ( !s.crossDomain && !headers["X-Requested-With"] ) {
						headers["X-Requested-With"] = "XMLHttpRequest";
					}

					// Need an extra try/catch for cross domain requests in Firefox 3
					try {
						for ( i in headers ) {
							xhr.setRequestHeader( i, headers[ i ] );
						}
					} catch( err ) {}

					// Do send the request
					// This may raise an exception which is actually
					// handled in jQuery.ajax (so no try/catch here)
					xhr.send( ( s.hasContent && s.data ) || null );

					// Listener
					callback = function( _, isAbort ) {
						var status, responseHeaders, statusText, responses;

						// Firefox throws exceptions when accessing properties
						// of an xhr when a network error occurred
						// http://helpful.knobs-dials.com/index.php/Component_returned_failure_code:_0x80040111_(NS_ERROR_NOT_AVAILABLE)
						try {

							// Was never called and is aborted or complete
							if ( callback && ( isAbort || xhr.readyState === 4 ) ) {

								// Only called once
								callback = undefined;

								// Do not keep as active anymore
								if ( handle ) {
									xhr.onreadystatechange = jQuery.noop;
									if ( xhrOnUnloadAbort ) {
										delete xhrCallbacks[ handle ];
									}
								}

								// If it's an abort
								if ( isAbort ) {
									// Abort it manually if needed
									if ( xhr.readyState !== 4 ) {
										xhr.abort();
									}
								} else {
									responses = {};
									status = xhr.status;
									responseHeaders = xhr.getAllResponseHeaders();

									// When requesting binary data, IE6-9 will throw an exception
									// on any attempt to access responseText (#11426)
									if ( typeof xhr.responseText === "string" ) {
										responses.text = xhr.responseText;
									}

									// Firefox throws an exception when accessing
									// statusText for faulty cross-domain requests
									try {
										statusText = xhr.statusText;
									} catch( e ) {
										// We normalize with Webkit giving an empty statusText
										statusText = "";
									}

									// Filter status for non standard behaviors

									// If the request is local and we have data: assume a success
									// (success with no data won't get notified, that's the best we
									// can do given current implementations)
									if ( !status && s.isLocal && !s.crossDomain ) {
										status = responses.text ? 200 : 404;
									// IE - #1450: sometimes returns 1223 when it should be 204
									} else if ( status === 1223 ) {
										status = 204;
									}
								}
							}
						} catch( firefoxAccessException ) {
							if ( !isAbort ) {
								complete( -1, firefoxAccessException );
							}
						}

						// Call complete if needed
						if ( responses ) {
							complete( status, statusText, responses, responseHeaders );
						}
					};

					if ( !s.async ) {
						// if we're in sync mode we fire the callback
						callback();
					} else if ( xhr.readyState === 4 ) {
						// (IE6 & IE7) if it's in cache and has been
						// retrieved directly we need to fire the callback
						setTimeout( callback );
					} else {
						handle = ++xhrId;
						if ( xhrOnUnloadAbort ) {
							// Create the active xhrs callbacks list if needed
							// and attach the unload handler
							if ( !xhrCallbacks ) {
								xhrCallbacks = {};
								jQuery( window ).unload( xhrOnUnloadAbort );
							}
							// Add to list of active xhrs callbacks
							xhrCallbacks[ handle ] = callback;
						}
						xhr.onreadystatechange = callback;
					}
				},

				abort: function() {
					if ( callback ) {
						callback( undefined, true );
					}
				}
			};
		}
	});
}
var fxNow, timerId,
	rfxtypes = /^(?:toggle|show|hide)$/,
	rfxnum = new RegExp( "^(?:([+-])=|)(" + core_pnum + ")([a-z%]*)$", "i" ),
	rrun = /queueHooks$/,
	animationPrefilters = [ defaultPrefilter ],
	tweeners = {
		"*": [function( prop, value ) {
			var tween = this.createTween( prop, value ),
				target = tween.cur(),
				parts = rfxnum.exec( value ),
				unit = parts && parts[ 3 ] || ( jQuery.cssNumber[ prop ] ? "" : "px" ),

				// Starting value computation is required for potential unit mismatches
				start = ( jQuery.cssNumber[ prop ] || unit !== "px" && +target ) &&
					rfxnum.exec( jQuery.css( tween.elem, prop ) ),
				scale = 1,
				maxIterations = 20;

			if ( start && start[ 3 ] !== unit ) {
				// Trust units reported by jQuery.css
				unit = unit || start[ 3 ];

				// Make sure we update the tween properties later on
				parts = parts || [];

				// Iteratively approximate from a nonzero starting point
				start = +target || 1;

				do {
					// If previous iteration zeroed out, double until we get *something*
					// Use a string for doubling factor so we don't accidentally see scale as unchanged below
					scale = scale || ".5";

					// Adjust and apply
					start = start / scale;
					jQuery.style( tween.elem, prop, start + unit );

				// Update scale, tolerating zero or NaN from tween.cur()
				// And breaking the loop if scale is unchanged or perfect, or if we've just had enough
				} while ( scale !== (scale = tween.cur() / target) && scale !== 1 && --maxIterations );
			}

			// Update tween properties
			if ( parts ) {
				start = tween.start = +start || +target || 0;
				tween.unit = unit;
				// If a +=/-= token was provided, we're doing a relative animation
				tween.end = parts[ 1 ] ?
					start + ( parts[ 1 ] + 1 ) * parts[ 2 ] :
					+parts[ 2 ];
			}

			return tween;
		}]
	};

// Animations created synchronously will run synchronously
function createFxNow() {
	setTimeout(function() {
		fxNow = undefined;
	});
	return ( fxNow = jQuery.now() );
}

function createTween( value, prop, animation ) {
	var tween,
		collection = ( tweeners[ prop ] || [] ).concat( tweeners[ "*" ] ),
		index = 0,
		length = collection.length;
	for ( ; index < length; index++ ) {
		if ( (tween = collection[ index ].call( animation, prop, value )) ) {

			// we're done with this property
			return tween;
		}
	}
}

function Animation( elem, properties, options ) {
	var result,
		stopped,
		index = 0,
		length = animationPrefilters.length,
		deferred = jQuery.Deferred().always( function() {
			// don't match elem in the :animated selector
			delete tick.elem;
		}),
		tick = function() {
			if ( stopped ) {
				return false;
			}
			var currentTime = fxNow || createFxNow(),
				remaining = Math.max( 0, animation.startTime + animation.duration - currentTime ),
				// archaic crash bug won't allow us to use 1 - ( 0.5 || 0 ) (#12497)
				temp = remaining / animation.duration || 0,
				percent = 1 - temp,
				index = 0,
				length = animation.tweens.length;

			for ( ; index < length ; index++ ) {
				animation.tweens[ index ].run( percent );
			}

			deferred.notifyWith( elem, [ animation, percent, remaining ]);

			if ( percent < 1 && length ) {
				return remaining;
			} else {
				deferred.resolveWith( elem, [ animation ] );
				return false;
			}
		},
		animation = deferred.promise({
			elem: elem,
			props: jQuery.extend( {}, properties ),
			opts: jQuery.extend( true, { specialEasing: {} }, options ),
			originalProperties: properties,
			originalOptions: options,
			startTime: fxNow || createFxNow(),
			duration: options.duration,
			tweens: [],
			createTween: function( prop, end ) {
				var tween = jQuery.Tween( elem, animation.opts, prop, end,
						animation.opts.specialEasing[ prop ] || animation.opts.easing );
				animation.tweens.push( tween );
				return tween;
			},
			stop: function( gotoEnd ) {
				var index = 0,
					// if we are going to the end, we want to run all the tweens
					// otherwise we skip this part
					length = gotoEnd ? animation.tweens.length : 0;
				if ( stopped ) {
					return this;
				}
				stopped = true;
				for ( ; index < length ; index++ ) {
					animation.tweens[ index ].run( 1 );
				}

				// resolve when we played the last frame
				// otherwise, reject
				if ( gotoEnd ) {
					deferred.resolveWith( elem, [ animation, gotoEnd ] );
				} else {
					deferred.rejectWith( elem, [ animation, gotoEnd ] );
				}
				return this;
			}
		}),
		props = animation.props;

	propFilter( props, animation.opts.specialEasing );

	for ( ; index < length ; index++ ) {
		result = animationPrefilters[ index ].call( animation, elem, props, animation.opts );
		if ( result ) {
			return result;
		}
	}

	jQuery.map( props, createTween, animation );

	if ( jQuery.isFunction( animation.opts.start ) ) {
		animation.opts.start.call( elem, animation );
	}

	jQuery.fx.timer(
		jQuery.extend( tick, {
			elem: elem,
			anim: animation,
			queue: animation.opts.queue
		})
	);

	// attach callbacks from options
	return animation.progress( animation.opts.progress )
		.done( animation.opts.done, animation.opts.complete )
		.fail( animation.opts.fail )
		.always( animation.opts.always );
}

function propFilter( props, specialEasing ) {
	var index, name, easing, value, hooks;

	// camelCase, specialEasing and expand cssHook pass
	for ( index in props ) {
		name = jQuery.camelCase( index );
		easing = specialEasing[ name ];
		value = props[ index ];
		if ( jQuery.isArray( value ) ) {
			easing = value[ 1 ];
			value = props[ index ] = value[ 0 ];
		}

		if ( index !== name ) {
			props[ name ] = value;
			delete props[ index ];
		}

		hooks = jQuery.cssHooks[ name ];
		if ( hooks && "expand" in hooks ) {
			value = hooks.expand( value );
			delete props[ name ];

			// not quite $.extend, this wont overwrite keys already present.
			// also - reusing 'index' from above because we have the correct "name"
			for ( index in value ) {
				if ( !( index in props ) ) {
					props[ index ] = value[ index ];
					specialEasing[ index ] = easing;
				}
			}
		} else {
			specialEasing[ name ] = easing;
		}
	}
}

jQuery.Animation = jQuery.extend( Animation, {

	tweener: function( props, callback ) {
		if ( jQuery.isFunction( props ) ) {
			callback = props;
			props = [ "*" ];
		} else {
			props = props.split(" ");
		}

		var prop,
			index = 0,
			length = props.length;

		for ( ; index < length ; index++ ) {
			prop = props[ index ];
			tweeners[ prop ] = tweeners[ prop ] || [];
			tweeners[ prop ].unshift( callback );
		}
	},

	prefilter: function( callback, prepend ) {
		if ( prepend ) {
			animationPrefilters.unshift( callback );
		} else {
			animationPrefilters.push( callback );
		}
	}
});

function defaultPrefilter( elem, props, opts ) {
	/* jshint validthis: true */
	var prop, value, toggle, tween, hooks, oldfire,
		anim = this,
		orig = {},
		style = elem.style,
		hidden = elem.nodeType && isHidden( elem ),
		dataShow = jQuery._data( elem, "fxshow" );

	// handle queue: false promises
	if ( !opts.queue ) {
		hooks = jQuery._queueHooks( elem, "fx" );
		if ( hooks.unqueued == null ) {
			hooks.unqueued = 0;
			oldfire = hooks.empty.fire;
			hooks.empty.fire = function() {
				if ( !hooks.unqueued ) {
					oldfire();
				}
			};
		}
		hooks.unqueued++;

		anim.always(function() {
			// doing this makes sure that the complete handler will be called
			// before this completes
			anim.always(function() {
				hooks.unqueued--;
				if ( !jQuery.queue( elem, "fx" ).length ) {
					hooks.empty.fire();
				}
			});
		});
	}

	// height/width overflow pass
	if ( elem.nodeType === 1 && ( "height" in props || "width" in props ) ) {
		// Make sure that nothing sneaks out
		// Record all 3 overflow attributes because IE does not
		// change the overflow attribute when overflowX and
		// overflowY are set to the same value
		opts.overflow = [ style.overflow, style.overflowX, style.overflowY ];

		// Set display property to inline-block for height/width
		// animations on inline elements that are having width/height animated
		if ( jQuery.css( elem, "display" ) === "inline" &&
				jQuery.css( elem, "float" ) === "none" ) {

			// inline-level elements accept inline-block;
			// block-level elements need to be inline with layout
			if ( !jQuery.support.inlineBlockNeedsLayout || css_defaultDisplay( elem.nodeName ) === "inline" ) {
				style.display = "inline-block";

			} else {
				style.zoom = 1;
			}
		}
	}

	if ( opts.overflow ) {
		style.overflow = "hidden";
		if ( !jQuery.support.shrinkWrapBlocks ) {
			anim.always(function() {
				style.overflow = opts.overflow[ 0 ];
				style.overflowX = opts.overflow[ 1 ];
				style.overflowY = opts.overflow[ 2 ];
			});
		}
	}


	// show/hide pass
	for ( prop in props ) {
		value = props[ prop ];
		if ( rfxtypes.exec( value ) ) {
			delete props[ prop ];
			toggle = toggle || value === "toggle";
			if ( value === ( hidden ? "hide" : "show" ) ) {
				continue;
			}
			orig[ prop ] = dataShow && dataShow[ prop ] || jQuery.style( elem, prop );
		}
	}

	if ( !jQuery.isEmptyObject( orig ) ) {
		if ( dataShow ) {
			if ( "hidden" in dataShow ) {
				hidden = dataShow.hidden;
			}
		} else {
			dataShow = jQuery._data( elem, "fxshow", {} );
		}

		// store state if its toggle - enables .stop().toggle() to "reverse"
		if ( toggle ) {
			dataShow.hidden = !hidden;
		}
		if ( hidden ) {
			jQuery( elem ).show();
		} else {
			anim.done(function() {
				jQuery( elem ).hide();
			});
		}
		anim.done(function() {
			var prop;
			jQuery._removeData( elem, "fxshow" );
			for ( prop in orig ) {
				jQuery.style( elem, prop, orig[ prop ] );
			}
		});
		for ( prop in orig ) {
			tween = createTween( hidden ? dataShow[ prop ] : 0, prop, anim );

			if ( !( prop in dataShow ) ) {
				dataShow[ prop ] = tween.start;
				if ( hidden ) {
					tween.end = tween.start;
					tween.start = prop === "width" || prop === "height" ? 1 : 0;
				}
			}
		}
	}
}

function Tween( elem, options, prop, end, easing ) {
	return new Tween.prototype.init( elem, options, prop, end, easing );
}
jQuery.Tween = Tween;

Tween.prototype = {
	constructor: Tween,
	init: function( elem, options, prop, end, easing, unit ) {
		this.elem = elem;
		this.prop = prop;
		this.easing = easing || "swing";
		this.options = options;
		this.start = this.now = this.cur();
		this.end = end;
		this.unit = unit || ( jQuery.cssNumber[ prop ] ? "" : "px" );
	},
	cur: function() {
		var hooks = Tween.propHooks[ this.prop ];

		return hooks && hooks.get ?
			hooks.get( this ) :
			Tween.propHooks._default.get( this );
	},
	run: function( percent ) {
		var eased,
			hooks = Tween.propHooks[ this.prop ];

		if ( this.options.duration ) {
			this.pos = eased = jQuery.easing[ this.easing ](
				percent, this.options.duration * percent, 0, 1, this.options.duration
			);
		} else {
			this.pos = eased = percent;
		}
		this.now = ( this.end - this.start ) * eased + this.start;

		if ( this.options.step ) {
			this.options.step.call( this.elem, this.now, this );
		}

		if ( hooks && hooks.set ) {
			hooks.set( this );
		} else {
			Tween.propHooks._default.set( this );
		}
		return this;
	}
};

Tween.prototype.init.prototype = Tween.prototype;

Tween.propHooks = {
	_default: {
		get: function( tween ) {
			var result;

			if ( tween.elem[ tween.prop ] != null &&
				(!tween.elem.style || tween.elem.style[ tween.prop ] == null) ) {
				return tween.elem[ tween.prop ];
			}

			// passing an empty string as a 3rd parameter to .css will automatically
			// attempt a parseFloat and fallback to a string if the parse fails
			// so, simple values such as "10px" are parsed to Float.
			// complex values such as "rotate(1rad)" are returned as is.
			result = jQuery.css( tween.elem, tween.prop, "" );
			// Empty strings, null, undefined and "auto" are converted to 0.
			return !result || result === "auto" ? 0 : result;
		},
		set: function( tween ) {
			// use step hook for back compat - use cssHook if its there - use .style if its
			// available and use plain properties where available
			if ( jQuery.fx.step[ tween.prop ] ) {
				jQuery.fx.step[ tween.prop ]( tween );
			} else if ( tween.elem.style && ( tween.elem.style[ jQuery.cssProps[ tween.prop ] ] != null || jQuery.cssHooks[ tween.prop ] ) ) {
				jQuery.style( tween.elem, tween.prop, tween.now + tween.unit );
			} else {
				tween.elem[ tween.prop ] = tween.now;
			}
		}
	}
};

// Support: IE <=9
// Panic based approach to setting things on disconnected nodes

Tween.propHooks.scrollTop = Tween.propHooks.scrollLeft = {
	set: function( tween ) {
		if ( tween.elem.nodeType && tween.elem.parentNode ) {
			tween.elem[ tween.prop ] = tween.now;
		}
	}
};

jQuery.each([ "toggle", "show", "hide" ], function( i, name ) {
	var cssFn = jQuery.fn[ name ];
	jQuery.fn[ name ] = function( speed, easing, callback ) {
		return speed == null || typeof speed === "boolean" ?
			cssFn.apply( this, arguments ) :
			this.animate( genFx( name, true ), speed, easing, callback );
	};
});

jQuery.fn.extend({
	fadeTo: function( speed, to, easing, callback ) {

		// show any hidden elements after setting opacity to 0
		return this.filter( isHidden ).css( "opacity", 0 ).show()

			// animate to the value specified
			.end().animate({ opacity: to }, speed, easing, callback );
	},
	animate: function( prop, speed, easing, callback ) {
		var empty = jQuery.isEmptyObject( prop ),
			optall = jQuery.speed( speed, easing, callback ),
			doAnimation = function() {
				// Operate on a copy of prop so per-property easing won't be lost
				var anim = Animation( this, jQuery.extend( {}, prop ), optall );

				// Empty animations, or finishing resolves immediately
				if ( empty || jQuery._data( this, "finish" ) ) {
					anim.stop( true );
				}
			};
			doAnimation.finish = doAnimation;

		return empty || optall.queue === false ?
			this.each( doAnimation ) :
			this.queue( optall.queue, doAnimation );
	},
	stop: function( type, clearQueue, gotoEnd ) {
		var stopQueue = function( hooks ) {
			var stop = hooks.stop;
			delete hooks.stop;
			stop( gotoEnd );
		};

		if ( typeof type !== "string" ) {
			gotoEnd = clearQueue;
			clearQueue = type;
			type = undefined;
		}
		if ( clearQueue && type !== false ) {
			this.queue( type || "fx", [] );
		}

		return this.each(function() {
			var dequeue = true,
				index = type != null && type + "queueHooks",
				timers = jQuery.timers,
				data = jQuery._data( this );

			if ( index ) {
				if ( data[ index ] && data[ index ].stop ) {
					stopQueue( data[ index ] );
				}
			} else {
				for ( index in data ) {
					if ( data[ index ] && data[ index ].stop && rrun.test( index ) ) {
						stopQueue( data[ index ] );
					}
				}
			}

			for ( index = timers.length; index--; ) {
				if ( timers[ index ].elem === this && (type == null || timers[ index ].queue === type) ) {
					timers[ index ].anim.stop( gotoEnd );
					dequeue = false;
					timers.splice( index, 1 );
				}
			}

			// start the next in the queue if the last step wasn't forced
			// timers currently will call their complete callbacks, which will dequeue
			// but only if they were gotoEnd
			if ( dequeue || !gotoEnd ) {
				jQuery.dequeue( this, type );
			}
		});
	},
	finish: function( type ) {
		if ( type !== false ) {
			type = type || "fx";
		}
		return this.each(function() {
			var index,
				data = jQuery._data( this ),
				queue = data[ type + "queue" ],
				hooks = data[ type + "queueHooks" ],
				timers = jQuery.timers,
				length = queue ? queue.length : 0;

			// enable finishing flag on private data
			data.finish = true;

			// empty the queue first
			jQuery.queue( this, type, [] );

			if ( hooks && hooks.stop ) {
				hooks.stop.call( this, true );
			}

			// look for any active animations, and finish them
			for ( index = timers.length; index--; ) {
				if ( timers[ index ].elem === this && timers[ index ].queue === type ) {
					timers[ index ].anim.stop( true );
					timers.splice( index, 1 );
				}
			}

			// look for any animations in the old queue and finish them
			for ( index = 0; index < length; index++ ) {
				if ( queue[ index ] && queue[ index ].finish ) {
					queue[ index ].finish.call( this );
				}
			}

			// turn off finishing flag
			delete data.finish;
		});
	}
});

// Generate parameters to create a standard animation
function genFx( type, includeWidth ) {
	var which,
		attrs = { height: type },
		i = 0;

	// if we include width, step value is 1 to do all cssExpand values,
	// if we don't include width, step value is 2 to skip over Left and Right
	includeWidth = includeWidth? 1 : 0;
	for( ; i < 4 ; i += 2 - includeWidth ) {
		which = cssExpand[ i ];
		attrs[ "margin" + which ] = attrs[ "padding" + which ] = type;
	}

	if ( includeWidth ) {
		attrs.opacity = attrs.width = type;
	}

	return attrs;
}

// Generate shortcuts for custom animations
jQuery.each({
	slideDown: genFx("show"),
	slideUp: genFx("hide"),
	slideToggle: genFx("toggle"),
	fadeIn: { opacity: "show" },
	fadeOut: { opacity: "hide" },
	fadeToggle: { opacity: "toggle" }
}, function( name, props ) {
	jQuery.fn[ name ] = function( speed, easing, callback ) {
		return this.animate( props, speed, easing, callback );
	};
});

jQuery.speed = function( speed, easing, fn ) {
	var opt = speed && typeof speed === "object" ? jQuery.extend( {}, speed ) : {
		complete: fn || !fn && easing ||
			jQuery.isFunction( speed ) && speed,
		duration: speed,
		easing: fn && easing || easing && !jQuery.isFunction( easing ) && easing
	};

	opt.duration = jQuery.fx.off ? 0 : typeof opt.duration === "number" ? opt.duration :
		opt.duration in jQuery.fx.speeds ? jQuery.fx.speeds[ opt.duration ] : jQuery.fx.speeds._default;

	// normalize opt.queue - true/undefined/null -> "fx"
	if ( opt.queue == null || opt.queue === true ) {
		opt.queue = "fx";
	}

	// Queueing
	opt.old = opt.complete;

	opt.complete = function() {
		if ( jQuery.isFunction( opt.old ) ) {
			opt.old.call( this );
		}

		if ( opt.queue ) {
			jQuery.dequeue( this, opt.queue );
		}
	};

	return opt;
};

jQuery.easing = {
	linear: function( p ) {
		return p;
	},
	swing: function( p ) {
		return 0.5 - Math.cos( p*Math.PI ) / 2;
	}
};

jQuery.timers = [];
jQuery.fx = Tween.prototype.init;
jQuery.fx.tick = function() {
	var timer,
		timers = jQuery.timers,
		i = 0;

	fxNow = jQuery.now();

	for ( ; i < timers.length; i++ ) {
		timer = timers[ i ];
		// Checks the timer has not already been removed
		if ( !timer() && timers[ i ] === timer ) {
			timers.splice( i--, 1 );
		}
	}

	if ( !timers.length ) {
		jQuery.fx.stop();
	}
	fxNow = undefined;
};

jQuery.fx.timer = function( timer ) {
	if ( timer() && jQuery.timers.push( timer ) ) {
		jQuery.fx.start();
	}
};

jQuery.fx.interval = 13;

jQuery.fx.start = function() {
	if ( !timerId ) {
		timerId = setInterval( jQuery.fx.tick, jQuery.fx.interval );
	}
};

jQuery.fx.stop = function() {
	clearInterval( timerId );
	timerId = null;
};

jQuery.fx.speeds = {
	slow: 600,
	fast: 200,
	// Default speed
	_default: 400
};

// Back Compat <1.8 extension point
jQuery.fx.step = {};

if ( jQuery.expr && jQuery.expr.filters ) {
	jQuery.expr.filters.animated = function( elem ) {
		return jQuery.grep(jQuery.timers, function( fn ) {
			return elem === fn.elem;
		}).length;
	};
}
jQuery.fn.offset = function( options ) {
	if ( arguments.length ) {
		return options === undefined ?
			this :
			this.each(function( i ) {
				jQuery.offset.setOffset( this, options, i );
			});
	}

	var docElem, win,
		box = { top: 0, left: 0 },
		elem = this[ 0 ],
		doc = elem && elem.ownerDocument;

	if ( !doc ) {
		return;
	}

	docElem = doc.documentElement;

	// Make sure it's not a disconnected DOM node
	if ( !jQuery.contains( docElem, elem ) ) {
		return box;
	}

	// If we don't have gBCR, just use 0,0 rather than error
	// BlackBerry 5, iOS 3 (original iPhone)
	if ( typeof elem.getBoundingClientRect !== core_strundefined ) {
		box = elem.getBoundingClientRect();
	}
	win = getWindow( doc );
	return {
		top: box.top  + ( win.pageYOffset || docElem.scrollTop )  - ( docElem.clientTop  || 0 ),
		left: box.left + ( win.pageXOffset || docElem.scrollLeft ) - ( docElem.clientLeft || 0 )
	};
};

jQuery.offset = {

	setOffset: function( elem, options, i ) {
		var position = jQuery.css( elem, "position" );

		// set position first, in-case top/left are set even on static elem
		if ( position === "static" ) {
			elem.style.position = "relative";
		}

		var curElem = jQuery( elem ),
			curOffset = curElem.offset(),
			curCSSTop = jQuery.css( elem, "top" ),
			curCSSLeft = jQuery.css( elem, "left" ),
			calculatePosition = ( position === "absolute" || position === "fixed" ) && jQuery.inArray("auto", [curCSSTop, curCSSLeft]) > -1,
			props = {}, curPosition = {}, curTop, curLeft;

		// need to be able to calculate position if either top or left is auto and position is either absolute or fixed
		if ( calculatePosition ) {
			curPosition = curElem.position();
			curTop = curPosition.top;
			curLeft = curPosition.left;
		} else {
			curTop = parseFloat( curCSSTop ) || 0;
			curLeft = parseFloat( curCSSLeft ) || 0;
		}

		if ( jQuery.isFunction( options ) ) {
			options = options.call( elem, i, curOffset );
		}

		if ( options.top != null ) {
			props.top = ( options.top - curOffset.top ) + curTop;
		}
		if ( options.left != null ) {
			props.left = ( options.left - curOffset.left ) + curLeft;
		}

		if ( "using" in options ) {
			options.using.call( elem, props );
		} else {
			curElem.css( props );
		}
	}
};


jQuery.fn.extend({

	position: function() {
		if ( !this[ 0 ] ) {
			return;
		}

		var offsetParent, offset,
			parentOffset = { top: 0, left: 0 },
			elem = this[ 0 ];

		// fixed elements are offset from window (parentOffset = {top:0, left: 0}, because it is it's only offset parent
		if ( jQuery.css( elem, "position" ) === "fixed" ) {
			// we assume that getBoundingClientRect is available when computed position is fixed
			offset = elem.getBoundingClientRect();
		} else {
			// Get *real* offsetParent
			offsetParent = this.offsetParent();

			// Get correct offsets
			offset = this.offset();
			if ( !jQuery.nodeName( offsetParent[ 0 ], "html" ) ) {
				parentOffset = offsetParent.offset();
			}

			// Add offsetParent borders
			parentOffset.top  += jQuery.css( offsetParent[ 0 ], "borderTopWidth", true );
			parentOffset.left += jQuery.css( offsetParent[ 0 ], "borderLeftWidth", true );
		}

		// Subtract parent offsets and element margins
		// note: when an element has margin: auto the offsetLeft and marginLeft
		// are the same in Safari causing offset.left to incorrectly be 0
		return {
			top:  offset.top  - parentOffset.top - jQuery.css( elem, "marginTop", true ),
			left: offset.left - parentOffset.left - jQuery.css( elem, "marginLeft", true)
		};
	},

	offsetParent: function() {
		return this.map(function() {
			var offsetParent = this.offsetParent || docElem;
			while ( offsetParent && ( !jQuery.nodeName( offsetParent, "html" ) && jQuery.css( offsetParent, "position") === "static" ) ) {
				offsetParent = offsetParent.offsetParent;
			}
			return offsetParent || docElem;
		});
	}
});


// Create scrollLeft and scrollTop methods
jQuery.each( {scrollLeft: "pageXOffset", scrollTop: "pageYOffset"}, function( method, prop ) {
	var top = /Y/.test( prop );

	jQuery.fn[ method ] = function( val ) {
		return jQuery.access( this, function( elem, method, val ) {
			var win = getWindow( elem );

			if ( val === undefined ) {
				return win ? (prop in win) ? win[ prop ] :
					win.document.documentElement[ method ] :
					elem[ method ];
			}

			if ( win ) {
				win.scrollTo(
					!top ? val : jQuery( win ).scrollLeft(),
					top ? val : jQuery( win ).scrollTop()
				);

			} else {
				elem[ method ] = val;
			}
		}, method, val, arguments.length, null );
	};
});

function getWindow( elem ) {
	return jQuery.isWindow( elem ) ?
		elem :
		elem.nodeType === 9 ?
			elem.defaultView || elem.parentWindow :
			false;
}
// Create innerHeight, innerWidth, height, width, outerHeight and outerWidth methods
jQuery.each( { Height: "height", Width: "width" }, function( name, type ) {
	jQuery.each( { padding: "inner" + name, content: type, "": "outer" + name }, function( defaultExtra, funcName ) {
		// margin is only for outerHeight, outerWidth
		jQuery.fn[ funcName ] = function( margin, value ) {
			var chainable = arguments.length && ( defaultExtra || typeof margin !== "boolean" ),
				extra = defaultExtra || ( margin === true || value === true ? "margin" : "border" );

			return jQuery.access( this, function( elem, type, value ) {
				var doc;

				if ( jQuery.isWindow( elem ) ) {
					// As of 5/8/2012 this will yield incorrect results for Mobile Safari, but there
					// isn't a whole lot we can do. See pull request at this URL for discussion:
					// https://github.com/jquery/jquery/pull/764
					return elem.document.documentElement[ "client" + name ];
				}

				// Get document width or height
				if ( elem.nodeType === 9 ) {
					doc = elem.documentElement;

					// Either scroll[Width/Height] or offset[Width/Height] or client[Width/Height], whichever is greatest
					// unfortunately, this causes bug #3838 in IE6/8 only, but there is currently no good, small way to fix it.
					return Math.max(
						elem.body[ "scroll" + name ], doc[ "scroll" + name ],
						elem.body[ "offset" + name ], doc[ "offset" + name ],
						doc[ "client" + name ]
					);
				}

				return value === undefined ?
					// Get width or height on the element, requesting but not forcing parseFloat
					jQuery.css( elem, type, extra ) :

					// Set width or height on the element
					jQuery.style( elem, type, value, extra );
			}, type, chainable ? margin : undefined, chainable, null );
		};
	});
});
// Limit scope pollution from any deprecated API
// (function() {

// The number of elements contained in the matched element set
jQuery.fn.size = function() {
	return this.length;
};

jQuery.fn.andSelf = jQuery.fn.addBack;

// })();
if ( typeof module === "object" && module && typeof module.exports === "object" ) {
	// Expose jQuery as module.exports in loaders that implement the Node
	// module pattern (including browserify). Do not create the global, since
	// the user will be storing it themselves locally, and globals are frowned
	// upon in the Node module world.
	module.exports = jQuery;
} else {
	// Otherwise expose jQuery to the global object as usual
	window.jQuery = window.$ = jQuery;

	// Register as a named AMD module, since jQuery can be concatenated with other
	// files that may use define, but not via a proper concatenation script that
	// understands anonymous AMD modules. A named AMD is safest and most robust
	// way to register. Lowercase jquery is used because AMD module names are
	// derived from file names, and jQuery is normally delivered in a lowercase
	// file name. Do this after creating the global so that if an AMD module wants
	// to call noConflict to hide this version of jQuery, it will work.
	if ( typeof define === "function" && define.amd ) {
		define( "jquery", [], function () { return jQuery; } );
	}
}

})( window );

(function(){!function(a){return"function"==typeof define&&define.amd?define(["jquery"],a):a(window.jQuery)}(function(a){var b,c,d,e,f,g,h,i,j,k=[].slice;d=function(){function b(b){this.current_flag=null,this.controllers={},this.alias_maps={},this.$inputor=a(b),this.iframe=null,this.setIframe(),this.listen()}return b.prototype.setIframe=function(a){var b;if(a)return this.window=a.contentWindow,this.document=a.contentDocument||this.window.document,this.iframe=a,this;this.document=this.$inputor[0].ownerDocument,this.window=this.document.defaultView||this.document.parentWindow;try{return this.iframe=this.window.frameElement}catch(c){b=c}},b.prototype.controller=function(a){var b,c,d,e;if(this.alias_maps[a])c=this.controllers[this.alias_maps[a]];else{e=this.controllers;for(d in e)if(b=e[d],d===a){c=b;break}}return c?c:this.controllers[this.current_flag]},b.prototype.set_context_for=function(a){return this.current_flag=a,this},b.prototype.reg=function(a,b){var c,d;return c=(d=this.controllers)[a]||(d[a]=new f(this,a)),b.alias&&(this.alias_maps[b.alias]=a),c.init(b),this},b.prototype.listen=function(){return this.$inputor.on("keyup.atwhoInner",function(a){return function(b){return a.on_keyup(b)}}(this)).on("keydown.atwhoInner",function(a){return function(b){return a.on_keydown(b)}}(this)).on("scroll.atwhoInner",function(a){return function(b){var c;return null!=(c=a.controller())?c.view.hide(b):void 0}}(this)).on("blur.atwhoInner",function(a){return function(b){var c;return(c=a.controller())?c.view.hide(b,c.get_opt("display_timeout")):void 0}}(this))},b.prototype.shutdown=function(){var a,b,c;c=this.controllers;for(b in c)a=c[b],a.destroy(),delete this.controllers[b];return this.$inputor.off(".atwhoInner")},b.prototype.dispatch=function(){return a.map(this.controllers,function(a){return function(b){var c;return(c=b.get_opt("delay"))?(clearTimeout(a.delayedCallback),a.delayedCallback=setTimeout(function(){return b.look_up()?a.set_context_for(b.at):void 0},c)):b.look_up()?a.set_context_for(b.at):void 0}}(this))},b.prototype.on_keyup=function(b){var c;switch(b.keyCode){case h.ESC:b.preventDefault(),null!=(c=this.controller())&&c.view.hide();break;case h.DOWN:case h.UP:case h.CTRL:a.noop();break;case h.P:case h.N:b.ctrlKey||this.dispatch();break;default:this.dispatch()}},b.prototype.on_keydown=function(b){var c,d;if(c=null!=(d=this.controller())?d.view:void 0,c&&c.visible())switch(b.keyCode){case h.ESC:b.preventDefault(),c.hide(b);break;case h.UP:b.preventDefault(),c.prev();break;case h.DOWN:b.preventDefault(),c.next();break;case h.P:if(!b.ctrlKey)return;b.preventDefault(),c.prev();break;case h.N:if(!b.ctrlKey)return;b.preventDefault(),c.next();break;case h.TAB:case h.ENTER:if(!c.visible())return;b.preventDefault(),c.choosing=!0,c.choose(b);break;default:a.noop()}},b}(),f=function(){function c(c,d){this.app=c,this.at=d,this.$inputor=this.app.$inputor,this.id=this.$inputor[0].id||this.uid(),this.setting=null,this.query=null,this.pos=0,this.cur_rect=null,this.range=null,b.append(this.$el=a("<div id='atwho-ground-"+this.id+"'></div>")),this.model=new i(this),this.view=new j(this)}return c.prototype.uid=function(){return(Math.random().toString(16)+"000000000").substr(2,8)+(new Date).getTime()},c.prototype.init=function(b){return this.setting=a.extend({},this.setting||a.fn.atwho["default"],b),this.view.init(),this.model.reload(this.setting.data)},c.prototype.destroy=function(){return this.trigger("beforeDestroy"),this.model.destroy(),this.view.destroy(),this.$el.remove()},c.prototype.call_default=function(){var b,c,d;d=arguments[0],b=2<=arguments.length?k.call(arguments,1):[];try{return g[d].apply(this,b)}catch(e){return c=e,a.error(""+c+" Or maybe At.js doesn't have function "+d)}},c.prototype.trigger=function(a,b){var c,d;return null==b&&(b=[]),b.push(this),c=this.get_opt("alias"),d=c?""+a+"-"+c+".atwho":""+a+".atwho",this.$inputor.trigger(d,b)},c.prototype.callbacks=function(a){return this.get_opt("callbacks")[a]||g[a]},c.prototype.get_opt=function(a){var b;try{return this.setting[a]}catch(c){return b=c,null}},c.prototype.content=function(){return this.$inputor.is("textarea, input")?this.$inputor.val():this.$inputor.text()},c.prototype.catch_query=function(){var a,b,c,d,e,f;return b=this.content(),a=this.$inputor.caret("pos"),f=b.slice(0,a),d=this.callbacks("matcher").call(this,this.at,f,this.get_opt("start_with_space")),"string"==typeof d&&d.length<=this.get_opt("max_len",20)?(e=a-d.length,c=e+d.length,this.pos=e,d={text:d,head_pos:e,end_pos:c},this.trigger("matched",[this.at,d.text])):(d=null,this.view.hide()),this.query=d},c.prototype.rect=function(){var a,b;if(a=this.$inputor.caret({iframe:this.app.iframe}).caret("offset",this.pos-1))return"true"===this.$inputor.attr("contentEditable")&&(a=this.cur_rect||(this.cur_rect=a)||a),b=this.app.document.selection?0:2,{left:a.left,top:a.top,bottom:a.top+a.height+b}},c.prototype.reset_rect=function(){return"true"===this.$inputor.attr("contentEditable")?this.cur_rect=null:void 0},c.prototype.mark_range=function(){return"true"===this.$inputor.attr("contentEditable")&&(this.app.window.getSelection&&(this.range=this.app.window.getSelection().getRangeAt(0)),this.app.document.selection)?this.ie8_range=this.app.document.selection.createRange():void 0},c.prototype.insert_content_for=function(b){var c,d,e;return d=b.data("value"),e=this.get_opt("insert_tpl"),this.$inputor.is("textarea, input")||!e?d:(c=a.extend({},b.data("item-data"),{"atwho-data-value":d,"atwho-at":this.at}),this.callbacks("tpl_eval").call(this,e,c))},c.prototype.insert=function(b,c){var d,e,f,g,h,i,j,k,l,m,n;return d=this.$inputor,"true"===d.attr("contentEditable")&&(f="atwho-view-flag atwho-view-flag-"+(this.get_opt("alias")||this.at),g=""+b+"<span contenteditable='false'>&nbsp;<span>",h="<span contenteditable='false' class='"+f+"'>"+g+"</span>",e=a(h,this.app.document).data("atwho-data-item",c.data("item-data")),this.app.document.selection&&(e=a("<span contenteditable='true'></span>",this.app.document).html(e))),d.is("textarea, input")?(b=this.get_opt("space_after")?b+" ":""+b,l=d.val(),m=l.slice(0,Math.max(this.query.head_pos-this.at.length,0)),n=""+m+b+l.slice(this.query.end_pos||0),d.val(n),d.caret("pos",m.length+b.length)):(j=this.range)?(i=j.startOffset-(this.query.end_pos-this.query.head_pos)-this.at.length,j.setStart(j.endContainer,Math.max(i,0)),j.setEnd(j.endContainer,j.endOffset),j.deleteContents(),j.insertNode(e[0]),j.collapse(!1),k=this.app.window.getSelection(),k.removeAllRanges(),k.addRange(j)):(j=this.ie8_range)&&(j.moveStart("character",this.query.end_pos-this.query.head_pos-this.at.length),j.pasteHTML(g),j.collapse(!1),j.select()),d.is(":focus")||d.focus(),d.change()},c.prototype.render_view=function(a){var b;return b=this.get_opt("search_key"),a=this.callbacks("sorter").call(this,this.query.text,a.slice(0,1001),b),this.view.render(a.slice(0,this.get_opt("limit")))},c.prototype.look_up=function(){var b,c;if(b=this.catch_query())return c=function(a){return a&&a.length>0?this.render_view(a):this.view.hide()},this.model.query(b.text,a.proxy(c,this)),b},c}(),i=function(){function b(a){this.context=a,this.at=this.context.at,this.storage=this.context.$inputor}return b.prototype.destroy=function(){return this.storage.data(this.at,null)},b.prototype.saved=function(){return this.fetch()>0},b.prototype.query=function(a,b){var c,d,e;return c=this.fetch(),d=this.context.get_opt("search_key"),c=this.context.callbacks("filter").call(this.context,a,c,d)||[],e=this.context.callbacks("remote_filter"),c.length>0||!e&&0===c.length?b(c):e.call(this.context,a,b)},b.prototype.fetch=function(){return this.storage.data(this.at)||[]},b.prototype.save=function(a){return this.storage.data(this.at,this.context.callbacks("before_save").call(this.context,a||[]))},b.prototype.load=function(a){return!this.saved()&&a?this._load(a):void 0},b.prototype.reload=function(a){return this._load(a)},b.prototype._load=function(b){return"string"==typeof b?a.ajax(b,{dataType:"json"}).done(function(a){return function(b){return a.save(b)}}(this)):this.save(b)},b}(),j=function(){function b(b){this.context=b,this.$el=a("<div class='atwho-view'><ul class='atwho-view-ul'></ul></div>"),this.timeout_id=null,this.context.$el.append(this.$el),this.bind_event()}return b.prototype.init=function(){var a;return a=this.context.get_opt("alias")||this.context.at.charCodeAt(0),this.$el.attr({id:"at-view-"+a})},b.prototype.destroy=function(){return this.$el.remove()},b.prototype.bind_event=function(){var b;return b=this.$el.find("ul"),b.on("mouseenter.atwho-view","li",function(c){return b.find(".cur").removeClass("cur"),a(c.currentTarget).addClass("cur")}).on("click",function(a){return function(b){return a.choose(b),b.preventDefault()}}(this))},b.prototype.visible=function(){return this.$el.is(":visible")},b.prototype.choose=function(a){var b,c;return(b=this.$el.find(".cur")).length?(c=this.context.insert_content_for(b),this.context.insert(this.context.callbacks("before_insert").call(this.context,c,b),b),this.context.trigger("inserted",[b,a]),this.hide(a)):void 0},b.prototype.reposition=function(b){var c,d;return b.bottom+this.$el.height()-a(window).scrollTop()>a(window).height()&&(b.bottom=b.top-this.$el.height()),c={left:b.left,top:b.bottom},null!=(d=this.context.callbacks("before_reposition"))&&d.call(this.context,c),this.$el.offset(c),this.context.trigger("reposition",[c])},b.prototype.next=function(){var a,b;return a=this.$el.find(".cur").removeClass("cur"),b=a.next(),b.length||(b=this.$el.find("li:first")),b.addClass("cur")},b.prototype.prev=function(){var a,b;return a=this.$el.find(".cur").removeClass("cur"),b=a.prev(),b.length||(b=this.$el.find("li:last")),b.addClass("cur")},b.prototype.show=function(){var a;return this.choosing?void(this.choosing=!1):(this.context.mark_range(),this.visible()||(this.$el.show(),this.context.trigger("shown")),(a=this.context.rect())?this.reposition(a):void 0)},b.prototype.hide=function(a,b){var c;if(this.visible())return isNaN(b)?(this.context.reset_rect(),this.$el.hide(),this.context.trigger("hidden",[a])):(c=function(a){return function(){return a.hide()}}(this),clearTimeout(this.timeout_id),this.timeout_id=setTimeout(c,b))},b.prototype.render=function(b){var c,d,e,f,g,h,i;if(!(a.isArray(b)&&b.length>0))return void this.hide();for(this.$el.find("ul").empty(),d=this.$el.find("ul"),g=this.context.get_opt("tpl"),h=0,i=b.length;i>h;h++)e=b[h],e=a.extend({},e,{"atwho-at":this.context.at}),f=this.context.callbacks("tpl_eval").call(this.context,g,e),c=a(this.context.callbacks("highlighter").call(this.context,f,this.context.query.text)),c.data("item-data",e),d.append(c);return this.show(),this.context.get_opt("highlight_first")?d.find("li:first").addClass("cur"):void 0},b}(),h={DOWN:40,UP:38,ESC:27,TAB:9,ENTER:13,CTRL:17,P:80,N:78},g={before_save:function(b){var c,d,e,f;if(!a.isArray(b))return b;for(f=[],d=0,e=b.length;e>d;d++)c=b[d],f.push(a.isPlainObject(c)?c:{name:c});return f},matcher:function(a,b,c){var d,e;return a=a.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g,"\\$&"),c&&(a="(?:^|\\s)"+a),e=new RegExp(a+"([A-Za-z0-9_+-]*)$|"+a+"([^\\x00-\\xff]*)$","gi"),d=e.exec(b),d?d[2]||d[1]:null},filter:function(a,b,c){var d,e,f,g;for(g=[],e=0,f=b.length;f>e;e++)d=b[e],~d[c].toLowerCase().indexOf(a.toLowerCase())&&g.push(d);return g},remote_filter:null,sorter:function(a,b,c){var d,e,f,g;if(!a)return b;for(g=[],e=0,f=b.length;f>e;e++)d=b[e],d.atwho_order=d[c].toLowerCase().indexOf(a.toLowerCase()),d.atwho_order>-1&&g.push(d);return g.sort(function(a,b){return a.atwho_order-b.atwho_order})},tpl_eval:function(a,b){var c;try{return a.replace(/\$\{([^\}]*)\}/g,function(a,c){return b[c]})}catch(d){return c=d,""}},highlighter:function(a,b){var c;return b?(c=new RegExp(">\\s*(\\w*?)("+b.replace("+","\\+")+")(\\w*)\\s*<","ig"),a.replace(c,function(a,b,c,d){return"> "+b+"<strong>"+c+"</strong>"+d+" <"})):a},before_insert:function(a){return a}},c={load:function(a,b){var c;return(c=this.controller(a))?c.model.load(b):void 0},getInsertedItemsWithIDs:function(b){var c,d,e;return(c=this.controller(b))?(b&&(b="-"+(c.get_opt("alias")||c.at)),d=[],e=a.map(this.$inputor.find("span.atwho-view-flag"+(b||"")),function(b){var c;return c=a(b).data("atwho-data-item"),d.indexOf(c.id)>-1?void 0:(c.id&&(d.push=c.id),c)}),[d,e]):[null,null]},getInsertedItems:function(a){return c.getInsertedItemsWithIDs.apply(this,[a])[1]},getInsertedIDs:function(a){return c.getInsertedItemsWithIDs.apply(this,[a])[0]},setIframe:function(a){return this.setIframe(a)},run:function(){return this.dispatch()},destroy:function(){return this.shutdown(),this.$inputor.data("atwho",null)}},e={init:function(b){var c,e;return e=(c=a(this)).data("atwho"),e||c.data("atwho",e=new d(this)),e.reg(b.at,b),this}},b=a("<div id='atwho-container'></div>"),a.fn.atwho=function(d){var f,g;return g=arguments,a("body").append(b),f=null,this.filter("textarea, input, [contenteditable=true]").each(function(){var b;return"object"!=typeof d&&d?c[d]?(b=a(this).data("atwho"))?f=c[d].apply(b,Array.prototype.slice.call(g,1)):void 0:a.error("Method "+d+" does not exist on jQuery.caret"):e.init.apply(this,g)}),f||this},a.fn.atwho["default"]={at:void 0,alias:void 0,space_after:!0,data:null,tpl:"<li data-value='${atwho-at}${name}'>${name}</li>",insert_tpl:"<span>${atwho-data-value}</span>",callbacks:g,search_key:"name",start_with_space:!0,highlight_first:!0,limit:5,max_len:20,display_timeout:300,delay:null}})}).call(this);
/*! jquery.caret 2014-06-13 */
(function(){!function(a){return"function"==typeof define&&define.amd?define(["jquery"],a):a(window.jQuery)}(function(a){"use strict";var b,c,d,e,f,g,h,i,j,k,l;return k="caret",b=function(){function b(a){this.$inputor=a,this.domInputor=this.$inputor[0]}return b.prototype.setPos=function(){return this.domInputor},b.prototype.getIEPosition=function(){return a.noop()},b.prototype.getPosition=function(){return a.noop()},b.prototype.getOldIEPos=function(){var a,b;return b=h.selection.createRange(),a=h.body.createTextRange(),a.moveToElementText(this.domInputor),a.setEndPoint("EndToEnd",b),a.text.length},b.prototype.getPos=function(){var a,b,c;return(c=this.range())?(a=c.cloneRange(),a.selectNodeContents(this.domInputor),a.setEnd(c.endContainer,c.endOffset),b=a.toString().length,a.detach(),b):h.selection?this.getOldIEPos():void 0},b.prototype.getOldIEOffset=function(){var a,b;return a=h.selection.createRange().duplicate(),a.moveStart("character",-1),b=a.getBoundingClientRect(),{height:b.bottom-b.top,left:b.left,top:b.top}},b.prototype.getOffset=function(){var b,c,d,e;if(j.getSelection&&(d=this.range())){if(d.endOffset-1<0)return null;b=d.cloneRange(),b.setStart(d.endContainer,d.endOffset-1),b.setEnd(d.endContainer,d.endOffset),e=b.getBoundingClientRect(),c={height:e.height,left:e.left+e.width,top:e.top},b.detach()}else h.selection&&(c=this.getOldIEOffset());return c&&!i&&(c.top+=a(j).scrollTop(),c.left+=a(j).scrollLeft()),c},b.prototype.range=function(){var a;if(j.getSelection)return a=j.getSelection(),a.rangeCount>0?a.getRangeAt(0):null},b}(),c=function(){function b(a){this.$inputor=a,this.domInputor=this.$inputor[0]}return b.prototype.getIEPos=function(){var a,b,c,d,e,f,g;return b=this.domInputor,f=h.selection.createRange(),e=0,f&&f.parentElement()===b&&(d=b.value.replace(/\r\n/g,"\n"),c=d.length,g=b.createTextRange(),g.moveToBookmark(f.getBookmark()),a=b.createTextRange(),a.collapse(!1),e=g.compareEndPoints("StartToEnd",a)>-1?c:-g.moveStart("character",-c)),e},b.prototype.getPos=function(){return h.selection?this.getIEPos():this.domInputor.selectionStart},b.prototype.setPos=function(a){var b,c;return b=this.domInputor,h.selection?(c=b.createTextRange(),c.move("character",a),c.select()):b.setSelectionRange&&b.setSelectionRange(a,a),b},b.prototype.getIEOffset=function(a){var b,c,d,e;return c=this.domInputor.createTextRange(),a||(a=this.getPos()),c.move("character",a),d=c.boundingLeft,e=c.boundingTop,b=c.boundingHeight,{left:d,top:e,height:b}},b.prototype.getOffset=function(b){var c,d,e;return c=this.$inputor,h.selection?(d=this.getIEOffset(b),d.top+=a(j).scrollTop()+c.scrollTop(),d.left+=a(j).scrollLeft()+c.scrollLeft(),d):(d=c.offset(),e=this.getPosition(b),d={left:d.left+e.left-c.scrollLeft(),top:d.top+e.top-c.scrollTop(),height:e.height})},b.prototype.getPosition=function(a){var b,c,e,f,g,h;return b=this.$inputor,e=function(a){return a.replace(/</g,"&lt").replace(/>/g,"&gt").replace(/`/g,"&#96").replace(/"/g,"&quot").replace(/\r\n|\r|\n/g,"<br />")},void 0===a&&(a=this.getPos()),h=b.val().slice(0,a),f="<span>"+e(h)+"</span>",f+="<span id='caret'>|</span>",g=new d(b),c=g.create(f).rect()},b.prototype.getIEPosition=function(a){var b,c,d,e,f;return d=this.getIEOffset(a),c=this.$inputor.offset(),e=d.left-c.left,f=d.top-c.top,b=d.height,{left:e,top:f,height:b}},b}(),d=function(){function b(a){this.$inputor=a}return b.prototype.css_attr=["borderBottomWidth","borderLeftWidth","borderRightWidth","borderTopStyle","borderRightStyle","borderBottomStyle","borderLeftStyle","borderTopWidth","boxSizing","fontFamily","fontSize","fontWeight","height","letterSpacing","lineHeight","marginBottom","marginLeft","marginRight","marginTop","outlineWidth","overflow","overflowX","overflowY","paddingBottom","paddingLeft","paddingRight","paddingTop","textAlign","textOverflow","textTransform","whiteSpace","wordBreak","wordWrap"],b.prototype.mirrorCss=function(){var b,c=this;return b={position:"absolute",left:-9999,top:0,zIndex:-2e4},"TEXTAREA"===this.$inputor.prop("tagName")&&this.css_attr.push("width"),a.each(this.css_attr,function(a,d){return b[d]=c.$inputor.css(d)}),b},b.prototype.create=function(b){return this.$mirror=a("<div></div>"),this.$mirror.css(this.mirrorCss()),this.$mirror.html(b),this.$inputor.after(this.$mirror),this},b.prototype.rect=function(){var a,b,c;return a=this.$mirror.find("#caret"),b=a.position(),c={left:b.left,top:b.top,height:a.height()},this.$mirror.remove(),c},b}(),e={contentEditable:function(a){return!(!a[0].contentEditable||"true"!==a[0].contentEditable)}},g={pos:function(a){return a||0===a?this.setPos(a):this.getPos()},position:function(a){return h.selection?this.getIEPosition(a):this.getPosition(a)},offset:function(b){var c,d;return d=this.getOffset(b),i&&(c=a(i).offset(),d.top+=c.top,d.left+=c.left),d}},h=null,j=null,i=null,l=function(a){return i=a,j=a.contentWindow,h=a.contentDocument||j.document},f=function(b,c){var d,e;if(a.isPlainObject(c)&&(e=c.iframe))return b.data("caret-iframe",e),l(e);if(e=b.data("caret-iframe"))return l(e);h=b[0].ownerDocument,j=h.defaultView||h.parentWindow;try{return i=j.frameElement}catch(f){d=f}},a.fn.caret=function(d){var h;return"object"==typeof d?(f(this,d),this):g[d]?(f(this),h=e.contentEditable(this)?new b(this):new c(this),g[d].apply(h,Array.prototype.slice.call(arguments,1))):a.error("Method "+d+" does not exist on jQuery.caret")},a.fn.caret.EditableCaret=b,a.fn.caret.InputCaret=c,a.fn.caret.Utils=e,a.fn.caret.apis=g})}).call(this);

//     Underscore.js 1.3.3
//     (c) 2009-2012 Jeremy Ashkenas, DocumentCloud Inc.
//     Underscore is freely distributable under the MIT license.
//     Portions of Underscore are inspired or borrowed from Prototype,
//     Oliver Steele's Functional, and John Resig's Micro-Templating.
//     For all details and documentation:
//     http://documentcloud.github.com/underscore

(function() {

  // Baseline setup
  // --------------

  // Establish the root object, `window` in the browser, or `global` on the server.
  var root = this;

  // Save the previous value of the `_` variable.
  var previousUnderscore = root._;

  // Establish the object that gets returned to break out of a loop iteration.
  var breaker = {};

  // Save bytes in the minified (but not gzipped) version:
  var ArrayProto = Array.prototype, ObjProto = Object.prototype, FuncProto = Function.prototype;

  // Create quick reference variables for speed access to core prototypes.
  var slice            = ArrayProto.slice,
      unshift          = ArrayProto.unshift,
      toString         = ObjProto.toString,
      hasOwnProperty   = ObjProto.hasOwnProperty;

  // All **ECMAScript 5** native function implementations that we hope to use
  // are declared here.
  var
    nativeForEach      = ArrayProto.forEach,
    nativeMap          = ArrayProto.map,
    nativeReduce       = ArrayProto.reduce,
    nativeReduceRight  = ArrayProto.reduceRight,
    nativeFilter       = ArrayProto.filter,
    nativeEvery        = ArrayProto.every,
    nativeSome         = ArrayProto.some,
    nativeIndexOf      = ArrayProto.indexOf,
    nativeLastIndexOf  = ArrayProto.lastIndexOf,
    nativeIsArray      = Array.isArray,
    nativeKeys         = Object.keys,
    nativeBind         = FuncProto.bind;

  // Create a safe reference to the Underscore object for use below.
  var _ = function(obj) { return new wrapper(obj); };

  // Export the Underscore object for **Node.js**, with
  // backwards-compatibility for the old `require()` API. If we're in
  // the browser, add `_` as a global object via a string identifier,
  // for Closure Compiler "advanced" mode.
  if (typeof exports !== 'undefined') {
    if (typeof module !== 'undefined' && module.exports) {
      exports = module.exports = _;
    }
    exports._ = _;
  } else {
    root['_'] = _;
  }

  // Current version.
  _.VERSION = '1.3.3';

  // Collection Functions
  // --------------------

  // The cornerstone, an `each` implementation, aka `forEach`.
  // Handles objects with the built-in `forEach`, arrays, and raw objects.
  // Delegates to **ECMAScript 5**'s native `forEach` if available.
  var each = _.each = _.forEach = function(obj, iterator, context) {
    if (obj == null) return;
    if (nativeForEach && obj.forEach === nativeForEach) {
      obj.forEach(iterator, context);
    } else if (obj.length === +obj.length) {
      for (var i = 0, l = obj.length; i < l; i++) {
        if (i in obj && iterator.call(context, obj[i], i, obj) === breaker) return;
      }
    } else {
      for (var key in obj) {
        if (_.has(obj, key)) {
          if (iterator.call(context, obj[key], key, obj) === breaker) return;
        }
      }
    }
  };

  // Return the results of applying the iterator to each element.
  // Delegates to **ECMAScript 5**'s native `map` if available.
  _.map = _.collect = function(obj, iterator, context) {
    var results = [];
    if (obj == null) return results;
    if (nativeMap && obj.map === nativeMap) return obj.map(iterator, context);
    each(obj, function(value, index, list) {
      results[results.length] = iterator.call(context, value, index, list);
    });
    if (obj.length === +obj.length) results.length = obj.length;
    return results;
  };

  // **Reduce** builds up a single result from a list of values, aka `inject`,
  // or `foldl`. Delegates to **ECMAScript 5**'s native `reduce` if available.
  _.reduce = _.foldl = _.inject = function(obj, iterator, memo, context) {
    var initial = arguments.length > 2;
    if (obj == null) obj = [];
    if (nativeReduce && obj.reduce === nativeReduce) {
      if (context) iterator = _.bind(iterator, context);
      return initial ? obj.reduce(iterator, memo) : obj.reduce(iterator);
    }
    each(obj, function(value, index, list) {
      if (!initial) {
        memo = value;
        initial = true;
      } else {
        memo = iterator.call(context, memo, value, index, list);
      }
    });
    if (!initial) throw new TypeError('Reduce of empty array with no initial value');
    return memo;
  };

  // The right-associative version of reduce, also known as `foldr`.
  // Delegates to **ECMAScript 5**'s native `reduceRight` if available.
  _.reduceRight = _.foldr = function(obj, iterator, memo, context) {
    var initial = arguments.length > 2;
    if (obj == null) obj = [];
    if (nativeReduceRight && obj.reduceRight === nativeReduceRight) {
      if (context) iterator = _.bind(iterator, context);
      return initial ? obj.reduceRight(iterator, memo) : obj.reduceRight(iterator);
    }
    var reversed = _.toArray(obj).reverse();
    if (context && !initial) iterator = _.bind(iterator, context);
    return initial ? _.reduce(reversed, iterator, memo, context) : _.reduce(reversed, iterator);
  };

  // Return the first value which passes a truth test. Aliased as `detect`.
  _.find = _.detect = function(obj, iterator, context) {
    var result;
    any(obj, function(value, index, list) {
      if (iterator.call(context, value, index, list)) {
        result = value;
        return true;
      }
    });
    return result;
  };

  // Return all the elements that pass a truth test.
  // Delegates to **ECMAScript 5**'s native `filter` if available.
  // Aliased as `select`.
  _.filter = _.select = function(obj, iterator, context) {
    var results = [];
    if (obj == null) return results;
    if (nativeFilter && obj.filter === nativeFilter) return obj.filter(iterator, context);
    each(obj, function(value, index, list) {
      if (iterator.call(context, value, index, list)) results[results.length] = value;
    });
    return results;
  };

  // Return all the elements for which a truth test fails.
  _.reject = function(obj, iterator, context) {
    var results = [];
    if (obj == null) return results;
    each(obj, function(value, index, list) {
      if (!iterator.call(context, value, index, list)) results[results.length] = value;
    });
    return results;
  };

  // Determine whether all of the elements match a truth test.
  // Delegates to **ECMAScript 5**'s native `every` if available.
  // Aliased as `all`.
  _.every = _.all = function(obj, iterator, context) {
    var result = true;
    if (obj == null) return result;
    if (nativeEvery && obj.every === nativeEvery) return obj.every(iterator, context);
    each(obj, function(value, index, list) {
      if (!(result = result && iterator.call(context, value, index, list))) return breaker;
    });
    return !!result;
  };

  // Determine if at least one element in the object matches a truth test.
  // Delegates to **ECMAScript 5**'s native `some` if available.
  // Aliased as `any`.
  var any = _.some = _.any = function(obj, iterator, context) {
    iterator || (iterator = _.identity);
    var result = false;
    if (obj == null) return result;
    if (nativeSome && obj.some === nativeSome) return obj.some(iterator, context);
    each(obj, function(value, index, list) {
      if (result || (result = iterator.call(context, value, index, list))) return breaker;
    });
    return !!result;
  };

  // Determine if a given value is included in the array or object using `===`.
  // Aliased as `contains`.
  _.include = _.contains = function(obj, target) {
    var found = false;
    if (obj == null) return found;
    if (nativeIndexOf && obj.indexOf === nativeIndexOf) return obj.indexOf(target) != -1;
    found = any(obj, function(value) {
      return value === target;
    });
    return found;
  };

  // Invoke a method (with arguments) on every item in a collection.
  _.invoke = function(obj, method) {
    var args = slice.call(arguments, 2);
    return _.map(obj, function(value) {
      return (_.isFunction(method) ? method || value : value[method]).apply(value, args);
    });
  };

  // Convenience version of a common use case of `map`: fetching a property.
  _.pluck = function(obj, key) {
    return _.map(obj, function(value){ return value[key]; });
  };

  // Return the maximum element or (element-based computation).
  _.max = function(obj, iterator, context) {
    if (!iterator && _.isArray(obj) && obj[0] === +obj[0]) return Math.max.apply(Math, obj);
    if (!iterator && _.isEmpty(obj)) return -Infinity;
    var result = {computed : -Infinity};
    each(obj, function(value, index, list) {
      var computed = iterator ? iterator.call(context, value, index, list) : value;
      computed >= result.computed && (result = {value : value, computed : computed});
    });
    return result.value;
  };

  // Return the minimum element (or element-based computation).
  _.min = function(obj, iterator, context) {
    if (!iterator && _.isArray(obj) && obj[0] === +obj[0]) return Math.min.apply(Math, obj);
    if (!iterator && _.isEmpty(obj)) return Infinity;
    var result = {computed : Infinity};
    each(obj, function(value, index, list) {
      var computed = iterator ? iterator.call(context, value, index, list) : value;
      computed < result.computed && (result = {value : value, computed : computed});
    });
    return result.value;
  };

  // Shuffle an array.
  _.shuffle = function(obj) {
    var shuffled = [], rand;
    each(obj, function(value, index, list) {
      rand = Math.floor(Math.random() * (index + 1));
      shuffled[index] = shuffled[rand];
      shuffled[rand] = value;
    });
    return shuffled;
  };

  // Sort the object's values by a criterion produced by an iterator.
  _.sortBy = function(obj, val, context) {
    var iterator = _.isFunction(val) ? val : function(obj) { return obj[val]; };
    return _.pluck(_.map(obj, function(value, index, list) {
      return {
        value : value,
        criteria : iterator.call(context, value, index, list)
      };
    }).sort(function(left, right) {
      var a = left.criteria, b = right.criteria;
      if (a === void 0) return 1;
      if (b === void 0) return -1;
      return a < b ? -1 : a > b ? 1 : 0;
    }), 'value');
  };

  // Groups the object's values by a criterion. Pass either a string attribute
  // to group by, or a function that returns the criterion.
  _.groupBy = function(obj, val) {
    var result = {};
    var iterator = _.isFunction(val) ? val : function(obj) { return obj[val]; };
    each(obj, function(value, index) {
      var key = iterator(value, index);
      (result[key] || (result[key] = [])).push(value);
    });
    return result;
  };

  // Use a comparator function to figure out at what index an object should
  // be inserted so as to maintain order. Uses binary search.
  _.sortedIndex = function(array, obj, iterator) {
    iterator || (iterator = _.identity);
    var low = 0, high = array.length;
    while (low < high) {
      var mid = (low + high) >> 1;
      iterator(array[mid]) < iterator(obj) ? low = mid + 1 : high = mid;
    }
    return low;
  };

  // Safely convert anything iterable into a real, live array.
  _.toArray = function(obj) {
    if (!obj)                                     return [];
    if (_.isArray(obj))                           return slice.call(obj);
    if (_.isArguments(obj))                       return slice.call(obj);
    if (obj.toArray && _.isFunction(obj.toArray)) return obj.toArray();
    return _.values(obj);
  };

  // Return the number of elements in an object.
  _.size = function(obj) {
    return _.isArray(obj) ? obj.length : _.keys(obj).length;
  };

  // Array Functions
  // ---------------

  // Get the first element of an array. Passing **n** will return the first N
  // values in the array. Aliased as `head` and `take`. The **guard** check
  // allows it to work with `_.map`.
  _.first = _.head = _.take = function(array, n, guard) {
    return (n != null) && !guard ? slice.call(array, 0, n) : array[0];
  };

  // Returns everything but the last entry of the array. Especcialy useful on
  // the arguments object. Passing **n** will return all the values in
  // the array, excluding the last N. The **guard** check allows it to work with
  // `_.map`.
  _.initial = function(array, n, guard) {
    return slice.call(array, 0, array.length - ((n == null) || guard ? 1 : n));
  };

  // Get the last element of an array. Passing **n** will return the last N
  // values in the array. The **guard** check allows it to work with `_.map`.
  _.last = function(array, n, guard) {
    if ((n != null) && !guard) {
      return slice.call(array, Math.max(array.length - n, 0));
    } else {
      return array[array.length - 1];
    }
  };

  // Returns everything but the first entry of the array. Aliased as `tail`.
  // Especially useful on the arguments object. Passing an **index** will return
  // the rest of the values in the array from that index onward. The **guard**
  // check allows it to work with `_.map`.
  _.rest = _.tail = function(array, index, guard) {
    return slice.call(array, (index == null) || guard ? 1 : index);
  };

  // Trim out all falsy values from an array.
  _.compact = function(array) {
    return _.filter(array, function(value){ return !!value; });
  };

  // Return a completely flattened version of an array.
  _.flatten = function(array, shallow) {
    return _.reduce(array, function(memo, value) {
      if (_.isArray(value)) return memo.concat(shallow ? value : _.flatten(value));
      memo[memo.length] = value;
      return memo;
    }, []);
  };

  // Return a version of the array that does not contain the specified value(s).
  _.without = function(array) {
    return _.difference(array, slice.call(arguments, 1));
  };

  // Produce a duplicate-free version of the array. If the array has already
  // been sorted, you have the option of using a faster algorithm.
  // Aliased as `unique`.
  _.uniq = _.unique = function(array, isSorted, iterator) {
    var initial = iterator ? _.map(array, iterator) : array;
    var results = [];
    // The `isSorted` flag is irrelevant if the array only contains two elements.
    if (array.length < 3) isSorted = true;
    _.reduce(initial, function (memo, value, index) {
      if (isSorted ? _.last(memo) !== value || !memo.length : !_.include(memo, value)) {
        memo.push(value);
        results.push(array[index]);
      }
      return memo;
    }, []);
    return results;
  };

  // Produce an array that contains the union: each distinct element from all of
  // the passed-in arrays.
  _.union = function() {
    return _.uniq(_.flatten(arguments, true));
  };

  // Produce an array that contains every item shared between all the
  // passed-in arrays. (Aliased as "intersect" for back-compat.)
  _.intersection = _.intersect = function(array) {
    var rest = slice.call(arguments, 1);
    return _.filter(_.uniq(array), function(item) {
      return _.every(rest, function(other) {
        return _.indexOf(other, item) >= 0;
      });
    });
  };

  // Take the difference between one array and a number of other arrays.
  // Only the elements present in just the first array will remain.
  _.difference = function(array) {
    var rest = _.flatten(slice.call(arguments, 1), true);
    return _.filter(array, function(value){ return !_.include(rest, value); });
  };

  // Zip together multiple lists into a single array -- elements that share
  // an index go together.
  _.zip = function() {
    var args = slice.call(arguments);
    var length = _.max(_.pluck(args, 'length'));
    var results = new Array(length);
    for (var i = 0; i < length; i++) results[i] = _.pluck(args, "" + i);
    return results;
  };

  // If the browser doesn't supply us with indexOf (I'm looking at you, **MSIE**),
  // we need this function. Return the position of the first occurrence of an
  // item in an array, or -1 if the item is not included in the array.
  // Delegates to **ECMAScript 5**'s native `indexOf` if available.
  // If the array is large and already in sort order, pass `true`
  // for **isSorted** to use binary search.
  _.indexOf = function(array, item, isSorted) {
    if (array == null) return -1;
    var i, l;
    if (isSorted) {
      i = _.sortedIndex(array, item);
      return array[i] === item ? i : -1;
    }
    if (nativeIndexOf && array.indexOf === nativeIndexOf) return array.indexOf(item);
    for (i = 0, l = array.length; i < l; i++) if (i in array && array[i] === item) return i;
    return -1;
  };

  // Delegates to **ECMAScript 5**'s native `lastIndexOf` if available.
  _.lastIndexOf = function(array, item) {
    if (array == null) return -1;
    if (nativeLastIndexOf && array.lastIndexOf === nativeLastIndexOf) return array.lastIndexOf(item);
    var i = array.length;
    while (i--) if (i in array && array[i] === item) return i;
    return -1;
  };

  // Generate an integer Array containing an arithmetic progression. A port of
  // the native Python `range()` function. See
  // [the Python documentation](http://docs.python.org/library/functions.html#range).
  _.range = function(start, stop, step) {
    if (arguments.length <= 1) {
      stop = start || 0;
      start = 0;
    }
    step = arguments[2] || 1;

    var len = Math.max(Math.ceil((stop - start) / step), 0);
    var idx = 0;
    var range = new Array(len);

    while(idx < len) {
      range[idx++] = start;
      start += step;
    }

    return range;
  };

  // Function (ahem) Functions
  // ------------------

  // Reusable constructor function for prototype setting.
  var ctor = function(){};

  // Create a function bound to a given object (assigning `this`, and arguments,
  // optionally). Binding with arguments is also known as `curry`.
  // Delegates to **ECMAScript 5**'s native `Function.bind` if available.
  // We check for `func.bind` first, to fail fast when `func` is undefined.
  _.bind = function bind(func, context) {
    var bound, args;
    if (func.bind === nativeBind && nativeBind) return nativeBind.apply(func, slice.call(arguments, 1));
    if (!_.isFunction(func)) throw new TypeError;
    args = slice.call(arguments, 2);
    return bound = function() {
      if (!(this instanceof bound)) return func.apply(context, args.concat(slice.call(arguments)));
      ctor.prototype = func.prototype;
      var self = new ctor;
      var result = func.apply(self, args.concat(slice.call(arguments)));
      if (Object(result) === result) return result;
      return self;
    };
  };

  // Bind all of an object's methods to that object. Useful for ensuring that
  // all callbacks defined on an object belong to it.
  _.bindAll = function(obj) {
    var funcs = slice.call(arguments, 1);
    if (funcs.length == 0) funcs = _.functions(obj);
    each(funcs, function(f) { obj[f] = _.bind(obj[f], obj); });
    return obj;
  };

  // Memoize an expensive function by storing its results.
  _.memoize = function(func, hasher) {
    var memo = {};
    hasher || (hasher = _.identity);
    return function() {
      var key = hasher.apply(this, arguments);
      return _.has(memo, key) ? memo[key] : (memo[key] = func.apply(this, arguments));
    };
  };

  // Delays a function for the given number of milliseconds, and then calls
  // it with the arguments supplied.
  _.delay = function(func, wait) {
    var args = slice.call(arguments, 2);
    return setTimeout(function(){ return func.apply(null, args); }, wait);
  };

  // Defers a function, scheduling it to run after the current call stack has
  // cleared.
  _.defer = function(func) {
    return _.delay.apply(_, [func, 1].concat(slice.call(arguments, 1)));
  };

  // Returns a function, that, when invoked, will only be triggered at most once
  // during a given window of time.
  _.throttle = function(func, wait) {
    var context, args, timeout, throttling, more, result;
    var whenDone = _.debounce(function(){ more = throttling = false; }, wait);
    return function() {
      context = this; args = arguments;
      var later = function() {
        timeout = null;
        if (more) func.apply(context, args);
        whenDone();
      };
      if (!timeout) timeout = setTimeout(later, wait);
      if (throttling) {
        more = true;
      } else {
        result = func.apply(context, args);
      }
      whenDone();
      throttling = true;
      return result;
    };
  };

  // Returns a function, that, as long as it continues to be invoked, will not
  // be triggered. The function will be called after it stops being called for
  // N milliseconds. If `immediate` is passed, trigger the function on the
  // leading edge, instead of the trailing.
  _.debounce = function(func, wait, immediate) {
    var timeout;
    return function() {
      var context = this, args = arguments;
      var later = function() {
        timeout = null;
        if (!immediate) func.apply(context, args);
      };
      if (immediate && !timeout) func.apply(context, args);
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
    };
  };

  // Returns a function that will be executed at most one time, no matter how
  // often you call it. Useful for lazy initialization.
  _.once = function(func) {
    var ran = false, memo;
    return function() {
      if (ran) return memo;
      ran = true;
      return memo = func.apply(this, arguments);
    };
  };

  // Returns the first function passed as an argument to the second,
  // allowing you to adjust arguments, run code before and after, and
  // conditionally execute the original function.
  _.wrap = function(func, wrapper) {
    return function() {
      var args = [func].concat(slice.call(arguments, 0));
      return wrapper.apply(this, args);
    };
  };

  // Returns a function that is the composition of a list of functions, each
  // consuming the return value of the function that follows.
  _.compose = function() {
    var funcs = arguments;
    return function() {
      var args = arguments;
      for (var i = funcs.length - 1; i >= 0; i--) {
        args = [funcs[i].apply(this, args)];
      }
      return args[0];
    };
  };

  // Returns a function that will only be executed after being called N times.
  _.after = function(times, func) {
    if (times <= 0) return func();
    return function() {
      if (--times < 1) { return func.apply(this, arguments); }
    };
  };

  // Object Functions
  // ----------------

  // Retrieve the names of an object's properties.
  // Delegates to **ECMAScript 5**'s native `Object.keys`
  _.keys = nativeKeys || function(obj) {
    if (obj !== Object(obj)) throw new TypeError('Invalid object');
    var keys = [];
    for (var key in obj) if (_.has(obj, key)) keys[keys.length] = key;
    return keys;
  };

  // Retrieve the values of an object's properties.
  _.values = function(obj) {
    return _.map(obj, _.identity);
  };

  // Return a sorted list of the function names available on the object.
  // Aliased as `methods`
  _.functions = _.methods = function(obj) {
    var names = [];
    for (var key in obj) {
      if (_.isFunction(obj[key])) names.push(key);
    }
    return names.sort();
  };

  // Extend a given object with all the properties in passed-in object(s).
  _.extend = function(obj) {
    each(slice.call(arguments, 1), function(source) {
      for (var prop in source) {
        obj[prop] = source[prop];
      }
    });
    return obj;
  };

  // Return a copy of the object only containing the whitelisted properties.
  _.pick = function(obj) {
    var result = {};
    each(_.flatten(slice.call(arguments, 1)), function(key) {
      if (key in obj) result[key] = obj[key];
    });
    return result;
  };

  // Fill in a given object with default properties.
  _.defaults = function(obj) {
    each(slice.call(arguments, 1), function(source) {
      for (var prop in source) {
        if (obj[prop] == null) obj[prop] = source[prop];
      }
    });
    return obj;
  };

  // Create a (shallow-cloned) duplicate of an object.
  _.clone = function(obj) {
    if (!_.isObject(obj)) return obj;
    return _.isArray(obj) ? obj.slice() : _.extend({}, obj);
  };

  // Invokes interceptor with the obj, and then returns obj.
  // The primary purpose of this method is to "tap into" a method chain, in
  // order to perform operations on intermediate results within the chain.
  _.tap = function(obj, interceptor) {
    interceptor(obj);
    return obj;
  };

  // Internal recursive comparison function.
  function eq(a, b, stack) {
    // Identical objects are equal. `0 === -0`, but they aren't identical.
    // See the Harmony `egal` proposal: http://wiki.ecmascript.org/doku.php?id=harmony:egal.
    if (a === b) return a !== 0 || 1 / a == 1 / b;
    // A strict comparison is necessary because `null == undefined`.
    if (a == null || b == null) return a === b;
    // Unwrap any wrapped objects.
    if (a._chain) a = a._wrapped;
    if (b._chain) b = b._wrapped;
    // Invoke a custom `isEqual` method if one is provided.
    if (a.isEqual && _.isFunction(a.isEqual)) return a.isEqual(b);
    if (b.isEqual && _.isFunction(b.isEqual)) return b.isEqual(a);
    // Compare `[[Class]]` names.
    var className = toString.call(a);
    if (className != toString.call(b)) return false;
    switch (className) {
      // Strings, numbers, dates, and booleans are compared by value.
      case '[object String]':
        // Primitives and their corresponding object wrappers are equivalent; thus, `"5"` is
        // equivalent to `new String("5")`.
        return a == String(b);
      case '[object Number]':
        // `NaN`s are equivalent, but non-reflexive. An `egal` comparison is performed for
        // other numeric values.
        return a != +a ? b != +b : (a == 0 ? 1 / a == 1 / b : a == +b);
      case '[object Date]':
      case '[object Boolean]':
        // Coerce dates and booleans to numeric primitive values. Dates are compared by their
        // millisecond representations. Note that invalid dates with millisecond representations
        // of `NaN` are not equivalent.
        return +a == +b;
      // RegExps are compared by their source patterns and flags.
      case '[object RegExp]':
        return a.source == b.source &&
               a.global == b.global &&
               a.multiline == b.multiline &&
               a.ignoreCase == b.ignoreCase;
    }
    if (typeof a != 'object' || typeof b != 'object') return false;
    // Assume equality for cyclic structures. The algorithm for detecting cyclic
    // structures is adapted from ES 5.1 section 15.12.3, abstract operation `JO`.
    var length = stack.length;
    while (length--) {
      // Linear search. Performance is inversely proportional to the number of
      // unique nested structures.
      if (stack[length] == a) return true;
    }
    // Add the first object to the stack of traversed objects.
    stack.push(a);
    var size = 0, result = true;
    // Recursively compare objects and arrays.
    if (className == '[object Array]') {
      // Compare array lengths to determine if a deep comparison is necessary.
      size = a.length;
      result = size == b.length;
      if (result) {
        // Deep compare the contents, ignoring non-numeric properties.
        while (size--) {
          // Ensure commutative equality for sparse arrays.
          if (!(result = size in a == size in b && eq(a[size], b[size], stack))) break;
        }
      }
    } else {
      // Objects with different constructors are not equivalent.
      if ('constructor' in a != 'constructor' in b || a.constructor != b.constructor) return false;
      // Deep compare objects.
      for (var key in a) {
        if (_.has(a, key)) {
          // Count the expected number of properties.
          size++;
          // Deep compare each member.
          if (!(result = _.has(b, key) && eq(a[key], b[key], stack))) break;
        }
      }
      // Ensure that both objects contain the same number of properties.
      if (result) {
        for (key in b) {
          if (_.has(b, key) && !(size--)) break;
        }
        result = !size;
      }
    }
    // Remove the first object from the stack of traversed objects.
    stack.pop();
    return result;
  }

  // Perform a deep comparison to check if two objects are equal.
  _.isEqual = function(a, b) {
    return eq(a, b, []);
  };

  // Is a given array, string, or object empty?
  // An "empty" object has no enumerable own-properties.
  _.isEmpty = function(obj) {
    if (obj == null) return true;
    if (_.isArray(obj) || _.isString(obj)) return obj.length === 0;
    for (var key in obj) if (_.has(obj, key)) return false;
    return true;
  };

  // Is a given value a DOM element?
  _.isElement = function(obj) {
    return !!(obj && obj.nodeType == 1);
  };

  // Is a given value an array?
  // Delegates to ECMA5's native Array.isArray
  _.isArray = nativeIsArray || function(obj) {
    return toString.call(obj) == '[object Array]';
  };

  // Is a given variable an object?
  _.isObject = function(obj) {
    return obj === Object(obj);
  };

  // Is a given variable an arguments object?
  _.isArguments = function(obj) {
    return toString.call(obj) == '[object Arguments]';
  };
  if (!_.isArguments(arguments)) {
    _.isArguments = function(obj) {
      return !!(obj && _.has(obj, 'callee'));
    };
  }

  // Is a given value a function?
  _.isFunction = function(obj) {
    return toString.call(obj) == '[object Function]';
  };

  // Is a given value a string?
  _.isString = function(obj) {
    return toString.call(obj) == '[object String]';
  };

  // Is a given value a number?
  _.isNumber = function(obj) {
    return toString.call(obj) == '[object Number]';
  };

  // Is a given object a finite number?
  _.isFinite = function(obj) {
    return _.isNumber(obj) && isFinite(obj);
  };

  // Is the given value `NaN`?
  _.isNaN = function(obj) {
    // `NaN` is the only value for which `===` is not reflexive.
    return obj !== obj;
  };

  // Is a given value a boolean?
  _.isBoolean = function(obj) {
    return obj === true || obj === false || toString.call(obj) == '[object Boolean]';
  };

  // Is a given value a date?
  _.isDate = function(obj) {
    return toString.call(obj) == '[object Date]';
  };

  // Is the given value a regular expression?
  _.isRegExp = function(obj) {
    return toString.call(obj) == '[object RegExp]';
  };

  // Is a given value equal to null?
  _.isNull = function(obj) {
    return obj === null;
  };

  // Is a given variable undefined?
  _.isUndefined = function(obj) {
    return obj === void 0;
  };

  // Has own property?
  _.has = function(obj, key) {
    return hasOwnProperty.call(obj, key);
  };

  // Utility Functions
  // -----------------

  // Run Underscore.js in *noConflict* mode, returning the `_` variable to its
  // previous owner. Returns a reference to the Underscore object.
  _.noConflict = function() {
    root._ = previousUnderscore;
    return this;
  };

  // Keep the identity function around for default iterators.
  _.identity = function(value) {
    return value;
  };

  // Run a function **n** times.
  _.times = function (n, iterator, context) {
    for (var i = 0; i < n; i++) iterator.call(context, i);
  };

  // Escape a string for HTML interpolation.
  _.escape = function(string) {
    return (''+string).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#x27;').replace(/\//g,'&#x2F;');
  };

  // If the value of the named property is a function then invoke it;
  // otherwise, return it.
  _.result = function(object, property) {
    if (object == null) return null;
    var value = object[property];
    return _.isFunction(value) ? value.call(object) : value;
  };

  // Add your own custom functions to the Underscore object, ensuring that
  // they're correctly added to the OOP wrapper as well.
  _.mixin = function(obj) {
    each(_.functions(obj), function(name){
      addToWrapper(name, _[name] = obj[name]);
    });
  };

  // Generate a unique integer id (unique within the entire client session).
  // Useful for temporary DOM ids.
  var idCounter = 0;
  _.uniqueId = function(prefix) {
    var id = idCounter++;
    return prefix ? prefix + id : id;
  };

  // By default, Underscore uses ERB-style template delimiters, change the
  // following template settings to use alternative delimiters.
  _.templateSettings = {
    evaluate    : /<%([\s\S]+?)%>/g,
    interpolate : /<%=([\s\S]+?)%>/g,
    escape      : /<%-([\s\S]+?)%>/g
  };

  // When customizing `templateSettings`, if you don't want to define an
  // interpolation, evaluation or escaping regex, we need one that is
  // guaranteed not to match.
  var noMatch = /.^/;

  // Certain characters need to be escaped so that they can be put into a
  // string literal.
  var escapes = {
    '\\': '\\',
    "'": "'",
    'r': '\r',
    'n': '\n',
    't': '\t',
    'u2028': '\u2028',
    'u2029': '\u2029'
  };

  for (var p in escapes) escapes[escapes[p]] = p;
  var escaper = /\\|'|\r|\n|\t|\u2028|\u2029/g;
  var unescaper = /\\(\\|'|r|n|t|u2028|u2029)/g;

  // Within an interpolation, evaluation, or escaping, remove HTML escaping
  // that had been previously added.
  var unescape = function(code) {
    return code.replace(unescaper, function(match, escape) {
      return escapes[escape];
    });
  };

  // JavaScript micro-templating, similar to John Resig's implementation.
  // Underscore templating handles arbitrary delimiters, preserves whitespace,
  // and correctly escapes quotes within interpolated code.
  _.template = function(text, data, settings) {
    settings = _.defaults(settings || {}, _.templateSettings);

    // Compile the template source, taking care to escape characters that
    // cannot be included in a string literal and then unescape them in code
    // blocks.
    var source = "__p+='" + text
      .replace(escaper, function(match) {
        return '\\' + escapes[match];
      })
      .replace(settings.escape || noMatch, function(match, code) {
        return "'+\n_.escape(" + unescape(code) + ")+\n'";
      })
      .replace(settings.interpolate || noMatch, function(match, code) {
        return "'+\n(" + unescape(code) + ")+\n'";
      })
      .replace(settings.evaluate || noMatch, function(match, code) {
        return "';\n" + unescape(code) + "\n;__p+='";
      }) + "';\n";

    // If a variable is not specified, place data values in local scope.
    if (!settings.variable) source = 'with(obj||{}){\n' + source + '}\n';

    source = "var __p='';" +
      "var print=function(){__p+=Array.prototype.join.call(arguments, '')};\n" +
      source + "return __p;\n";

    var render = new Function(settings.variable || 'obj', '_', source);
    if (data) return render(data, _);
    var template = function(data) {
      return render.call(this, data, _);
    };

    // Provide the compiled function source as a convenience for build time
    // precompilation.
    template.source = 'function(' + (settings.variable || 'obj') + '){\n' +
      source + '}';

    return template;
  };

  // Add a "chain" function, which will delegate to the wrapper.
  _.chain = function(obj) {
    return _(obj).chain();
  };

  // The OOP Wrapper
  // ---------------

  // If Underscore is called as a function, it returns a wrapped object that
  // can be used OO-style. This wrapper holds altered versions of all the
  // underscore functions. Wrapped objects may be chained.
  var wrapper = function(obj) { this._wrapped = obj; };

  // Expose `wrapper.prototype` as `_.prototype`
  _.prototype = wrapper.prototype;

  // Helper function to continue chaining intermediate results.
  var result = function(obj, chain) {
    return chain ? _(obj).chain() : obj;
  };

  // A method to easily add functions to the OOP wrapper.
  var addToWrapper = function(name, func) {
    wrapper.prototype[name] = function() {
      var args = slice.call(arguments);
      unshift.call(args, this._wrapped);
      return result(func.apply(_, args), this._chain);
    };
  };

  // Add all of the Underscore functions to the wrapper object.
  _.mixin(_);

  // Add all mutator Array functions to the wrapper.
  each(['pop', 'push', 'reverse', 'shift', 'sort', 'splice', 'unshift'], function(name) {
    var method = ArrayProto[name];
    wrapper.prototype[name] = function() {
      var wrapped = this._wrapped;
      method.apply(wrapped, arguments);
      var length = wrapped.length;
      if ((name == 'shift' || name == 'splice') && length === 0) delete wrapped[0];
      return result(wrapped, this._chain);
    };
  });

  // Add all accessor Array functions to the wrapper.
  each(['concat', 'join', 'slice'], function(name) {
    var method = ArrayProto[name];
    wrapper.prototype[name] = function() {
      return result(method.apply(this._wrapped, arguments), this._chain);
    };
  });

  // Start chaining a wrapped Underscore object.
  wrapper.prototype.chain = function() {
    this._chain = true;
    return this;
  };

  // Extracts the result from a wrapped and chained object.
  wrapper.prototype.value = function() {
    return this._wrapped;
  };

}).call(this);

/**
 * @license AngularJS v1.0.7
 * (c) 2010-2012 Google, Inc. http://angularjs.org
 * License: MIT
 */
(function(window, document, undefined) {
'use strict';

////////////////////////////////////

/**
 * @ngdoc function
 * @name angular.lowercase
 * @function
 *
 * @description Converts the specified string to lowercase.
 * @param {string} string String to be converted to lowercase.
 * @returns {string} Lowercased string.
 */
var lowercase = function(string){return isString(string) ? string.toLowerCase() : string;};


/**
 * @ngdoc function
 * @name angular.uppercase
 * @function
 *
 * @description Converts the specified string to uppercase.
 * @param {string} string String to be converted to uppercase.
 * @returns {string} Uppercased string.
 */
var uppercase = function(string){return isString(string) ? string.toUpperCase() : string;};


var manualLowercase = function(s) {
  return isString(s)
      ? s.replace(/[A-Z]/g, function(ch) {return String.fromCharCode(ch.charCodeAt(0) | 32);})
      : s;
};
var manualUppercase = function(s) {
  return isString(s)
      ? s.replace(/[a-z]/g, function(ch) {return String.fromCharCode(ch.charCodeAt(0) & ~32);})
      : s;
};


// String#toLowerCase and String#toUpperCase don't produce correct results in browsers with Turkish
// locale, for this reason we need to detect this case and redefine lowercase/uppercase methods
// with correct but slower alternatives.
if ('i' !== 'I'.toLowerCase()) {
  lowercase = manualLowercase;
  uppercase = manualUppercase;
}


var /** holds major version number for IE or NaN for real browsers */
    msie              = int((/msie (\d+)/.exec(lowercase(navigator.userAgent)) || [])[1]),
    jqLite,           // delay binding since jQuery could be loaded after us.
    jQuery,           // delay binding
    slice             = [].slice,
    push              = [].push,
    toString          = Object.prototype.toString,

    /** @name angular */
    angular           = window.angular || (window.angular = {}),
    angularModule,
    nodeName_,
    uid               = ['0', '0', '0'];


/**
 * @private
 * @param {*} obj
 * @return {boolean} Returns true if `obj` is an array or array-like object (NodeList, Arguments, ...)
 */
function isArrayLike(obj) {
  if (!obj || (typeof obj.length !== 'number')) return false;

  // We have on object which has length property. Should we treat it as array?
  if (typeof obj.hasOwnProperty != 'function' &&
      typeof obj.constructor != 'function') {
    // This is here for IE8: it is a bogus object treat it as array;
    return true;
  } else  {
    return obj instanceof JQLite ||                      // JQLite
           (jQuery && obj instanceof jQuery) ||          // jQuery
           toString.call(obj) !== '[object Object]' ||   // some browser native object
           typeof obj.callee === 'function';              // arguments (on IE8 looks like regular obj)
  }
}


/**
 * @ngdoc function
 * @name angular.forEach
 * @function
 *
 * @description
 * Invokes the `iterator` function once for each item in `obj` collection, which can be either an
 * object or an array. The `iterator` function is invoked with `iterator(value, key)`, where `value`
 * is the value of an object property or an array element and `key` is the object property key or
 * array element index. Specifying a `context` for the function is optional.
 *
 * Note: this function was previously known as `angular.foreach`.
 *
   <pre>
     var values = {name: 'misko', gender: 'male'};
     var log = [];
     angular.forEach(values, function(value, key){
       this.push(key + ': ' + value);
     }, log);
     expect(log).toEqual(['name: misko', 'gender:male']);
   </pre>
 *
 * @param {Object|Array} obj Object to iterate over.
 * @param {Function} iterator Iterator function.
 * @param {Object=} context Object to become context (`this`) for the iterator function.
 * @returns {Object|Array} Reference to `obj`.
 */
function forEach(obj, iterator, context) {
  var key;
  if (obj) {
    if (isFunction(obj)){
      for (key in obj) {
        if (key != 'prototype' && key != 'length' && key != 'name' && obj.hasOwnProperty(key)) {
          iterator.call(context, obj[key], key);
        }
      }
    } else if (obj.forEach && obj.forEach !== forEach) {
      obj.forEach(iterator, context);
    } else if (isArrayLike(obj)) {
      for (key = 0; key < obj.length; key++)
        iterator.call(context, obj[key], key);
    } else {
      for (key in obj) {
        if (obj.hasOwnProperty(key)) {
          iterator.call(context, obj[key], key);
        }
      }
    }
  }
  return obj;
}

function sortedKeys(obj) {
  var keys = [];
  for (var key in obj) {
    if (obj.hasOwnProperty(key)) {
      keys.push(key);
    }
  }
  return keys.sort();
}

function forEachSorted(obj, iterator, context) {
  var keys = sortedKeys(obj);
  for ( var i = 0; i < keys.length; i++) {
    iterator.call(context, obj[keys[i]], keys[i]);
  }
  return keys;
}


/**
 * when using forEach the params are value, key, but it is often useful to have key, value.
 * @param {function(string, *)} iteratorFn
 * @returns {function(*, string)}
 */
function reverseParams(iteratorFn) {
  return function(value, key) { iteratorFn(key, value) };
}

/**
 * A consistent way of creating unique IDs in angular. The ID is a sequence of alpha numeric
 * characters such as '012ABC'. The reason why we are not using simply a number counter is that
 * the number string gets longer over time, and it can also overflow, where as the nextId
 * will grow much slower, it is a string, and it will never overflow.
 *
 * @returns an unique alpha-numeric string
 */
function nextUid() {
  var index = uid.length;
  var digit;

  while(index) {
    index--;
    digit = uid[index].charCodeAt(0);
    if (digit == 57 /*'9'*/) {
      uid[index] = 'A';
      return uid.join('');
    }
    if (digit == 90  /*'Z'*/) {
      uid[index] = '0';
    } else {
      uid[index] = String.fromCharCode(digit + 1);
      return uid.join('');
    }
  }
  uid.unshift('0');
  return uid.join('');
}


/**
 * Set or clear the hashkey for an object.
 * @param obj object 
 * @param h the hashkey (!truthy to delete the hashkey)
 */
function setHashKey(obj, h) {
  if (h) {
    obj.$$hashKey = h;
  }
  else {
    delete obj.$$hashKey;
  }
}

/**
 * @ngdoc function
 * @name angular.extend
 * @function
 *
 * @description
 * Extends the destination object `dst` by copying all of the properties from the `src` object(s)
 * to `dst`. You can specify multiple `src` objects.
 *
 * @param {Object} dst Destination object.
 * @param {...Object} src Source object(s).
 * @returns {Object} Reference to `dst`.
 */
function extend(dst) {
  var h = dst.$$hashKey;
  forEach(arguments, function(obj){
    if (obj !== dst) {
      forEach(obj, function(value, key){
        dst[key] = value;
      });
    }
  });

  setHashKey(dst,h);
  return dst;
}

function int(str) {
  return parseInt(str, 10);
}


function inherit(parent, extra) {
  return extend(new (extend(function() {}, {prototype:parent}))(), extra);
}


/**
 * @ngdoc function
 * @name angular.noop
 * @function
 *
 * @description
 * A function that performs no operations. This function can be useful when writing code in the
 * functional style.
   <pre>
     function foo(callback) {
       var result = calculateResult();
       (callback || angular.noop)(result);
     }
   </pre>
 */
function noop() {}
noop.$inject = [];


/**
 * @ngdoc function
 * @name angular.identity
 * @function
 *
 * @description
 * A function that returns its first argument. This function is useful when writing code in the
 * functional style.
 *
   <pre>
     function transformer(transformationFn, value) {
       return (transformationFn || identity)(value);
     };
   </pre>
 */
function identity($) {return $;}
identity.$inject = [];


function valueFn(value) {return function() {return value;};}

/**
 * @ngdoc function
 * @name angular.isUndefined
 * @function
 *
 * @description
 * Determines if a reference is undefined.
 *
 * @param {*} value Reference to check.
 * @returns {boolean} True if `value` is undefined.
 */
function isUndefined(value){return typeof value == 'undefined';}


/**
 * @ngdoc function
 * @name angular.isDefined
 * @function
 *
 * @description
 * Determines if a reference is defined.
 *
 * @param {*} value Reference to check.
 * @returns {boolean} True if `value` is defined.
 */
function isDefined(value){return typeof value != 'undefined';}


/**
 * @ngdoc function
 * @name angular.isObject
 * @function
 *
 * @description
 * Determines if a reference is an `Object`. Unlike `typeof` in JavaScript, `null`s are not
 * considered to be objects.
 *
 * @param {*} value Reference to check.
 * @returns {boolean} True if `value` is an `Object` but not `null`.
 */
function isObject(value){return value != null && typeof value == 'object';}


/**
 * @ngdoc function
 * @name angular.isString
 * @function
 *
 * @description
 * Determines if a reference is a `String`.
 *
 * @param {*} value Reference to check.
 * @returns {boolean} True if `value` is a `String`.
 */
function isString(value){return typeof value == 'string';}


/**
 * @ngdoc function
 * @name angular.isNumber
 * @function
 *
 * @description
 * Determines if a reference is a `Number`.
 *
 * @param {*} value Reference to check.
 * @returns {boolean} True if `value` is a `Number`.
 */
function isNumber(value){return typeof value == 'number';}


/**
 * @ngdoc function
 * @name angular.isDate
 * @function
 *
 * @description
 * Determines if a value is a date.
 *
 * @param {*} value Reference to check.
 * @returns {boolean} True if `value` is a `Date`.
 */
function isDate(value){
  return toString.apply(value) == '[object Date]';
}


/**
 * @ngdoc function
 * @name angular.isArray
 * @function
 *
 * @description
 * Determines if a reference is an `Array`.
 *
 * @param {*} value Reference to check.
 * @returns {boolean} True if `value` is an `Array`.
 */
function isArray(value) {
  return toString.apply(value) == '[object Array]';
}


/**
 * @ngdoc function
 * @name angular.isFunction
 * @function
 *
 * @description
 * Determines if a reference is a `Function`.
 *
 * @param {*} value Reference to check.
 * @returns {boolean} True if `value` is a `Function`.
 */
function isFunction(value){return typeof value == 'function';}


/**
 * Checks if `obj` is a window object.
 *
 * @private
 * @param {*} obj Object to check
 * @returns {boolean} True if `obj` is a window obj.
 */
function isWindow(obj) {
  return obj && obj.document && obj.location && obj.alert && obj.setInterval;
}


function isScope(obj) {
  return obj && obj.$evalAsync && obj.$watch;
}


function isFile(obj) {
  return toString.apply(obj) === '[object File]';
}


function isBoolean(value) {
  return typeof value == 'boolean';
}


function trim(value) {
  return isString(value) ? value.replace(/^\s*/, '').replace(/\s*$/, '') : value;
}

/**
 * @ngdoc function
 * @name angular.isElement
 * @function
 *
 * @description
 * Determines if a reference is a DOM element (or wrapped jQuery element).
 *
 * @param {*} value Reference to check.
 * @returns {boolean} True if `value` is a DOM element (or wrapped jQuery element).
 */
function isElement(node) {
  return node &&
    (node.nodeName  // we are a direct element
    || (node.bind && node.find));  // we have a bind and find method part of jQuery API
}

/**
 * @param str 'key1,key2,...'
 * @returns {object} in the form of {key1:true, key2:true, ...}
 */
function makeMap(str){
  var obj = {}, items = str.split(","), i;
  for ( i = 0; i < items.length; i++ )
    obj[ items[i] ] = true;
  return obj;
}


if (msie < 9) {
  nodeName_ = function(element) {
    element = element.nodeName ? element : element[0];
    return (element.scopeName && element.scopeName != 'HTML')
      ? uppercase(element.scopeName + ':' + element.nodeName) : element.nodeName;
  };
} else {
  nodeName_ = function(element) {
    return element.nodeName ? element.nodeName : element[0].nodeName;
  };
}


function map(obj, iterator, context) {
  var results = [];
  forEach(obj, function(value, index, list) {
    results.push(iterator.call(context, value, index, list));
  });
  return results;
}


/**
 * @description
 * Determines the number of elements in an array, the number of properties an object has, or
 * the length of a string.
 *
 * Note: This function is used to augment the Object type in Angular expressions. See
 * {@link angular.Object} for more information about Angular arrays.
 *
 * @param {Object|Array|string} obj Object, array, or string to inspect.
 * @param {boolean} [ownPropsOnly=false] Count only "own" properties in an object
 * @returns {number} The size of `obj` or `0` if `obj` is neither an object nor an array.
 */
function size(obj, ownPropsOnly) {
  var size = 0, key;

  if (isArray(obj) || isString(obj)) {
    return obj.length;
  } else if (isObject(obj)){
    for (key in obj)
      if (!ownPropsOnly || obj.hasOwnProperty(key))
        size++;
  }

  return size;
}


function includes(array, obj) {
  return indexOf(array, obj) != -1;
}

function indexOf(array, obj) {
  if (array.indexOf) return array.indexOf(obj);

  for ( var i = 0; i < array.length; i++) {
    if (obj === array[i]) return i;
  }
  return -1;
}

function arrayRemove(array, value) {
  var index = indexOf(array, value);
  if (index >=0)
    array.splice(index, 1);
  return value;
}

function isLeafNode (node) {
  if (node) {
    switch (node.nodeName) {
    case "OPTION":
    case "PRE":
    case "TITLE":
      return true;
    }
  }
  return false;
}

/**
 * @ngdoc function
 * @name angular.copy
 * @function
 *
 * @description
 * Creates a deep copy of `source`, which should be an object or an array.
 *
 * * If no destination is supplied, a copy of the object or array is created.
 * * If a destination is provided, all of its elements (for array) or properties (for objects)
 *   are deleted and then all elements/properties from the source are copied to it.
 * * If  `source` is not an object or array, `source` is returned.
 *
 * Note: this function is used to augment the Object type in Angular expressions. See
 * {@link ng.$filter} for more information about Angular arrays.
 *
 * @param {*} source The source that will be used to make a copy.
 *                   Can be any type, including primitives, `null`, and `undefined`.
 * @param {(Object|Array)=} destination Destination into which the source is copied. If
 *     provided, must be of the same type as `source`.
 * @returns {*} The copy or updated `destination`, if `destination` was specified.
 */
function copy(source, destination){
  if (isWindow(source) || isScope(source)) throw Error("Can't copy Window or Scope");
  if (!destination) {
    destination = source;
    if (source) {
      if (isArray(source)) {
        destination = copy(source, []);
      } else if (isDate(source)) {
        destination = new Date(source.getTime());
      } else if (isObject(source)) {
        destination = copy(source, {});
      }
    }
  } else {
    if (source === destination) throw Error("Can't copy equivalent objects or arrays");
    if (isArray(source)) {
      destination.length = 0;
      for ( var i = 0; i < source.length; i++) {
        destination.push(copy(source[i]));
      }
    } else {
      var h = destination.$$hashKey;
      forEach(destination, function(value, key){
        delete destination[key];
      });
      for ( var key in source) {
        destination[key] = copy(source[key]);
      }
      setHashKey(destination,h);
    }
  }
  return destination;
}

/**
 * Create a shallow copy of an object
 */
function shallowCopy(src, dst) {
  dst = dst || {};

  for(var key in src) {
    if (src.hasOwnProperty(key) && key.substr(0, 2) !== '$$') {
      dst[key] = src[key];
    }
  }

  return dst;
}


/**
 * @ngdoc function
 * @name angular.equals
 * @function
 *
 * @description
 * Determines if two objects or two values are equivalent. Supports value types, arrays and
 * objects.
 *
 * Two objects or values are considered equivalent if at least one of the following is true:
 *
 * * Both objects or values pass `===` comparison.
 * * Both objects or values are of the same type and all of their properties pass `===` comparison.
 * * Both values are NaN. (In JavasScript, NaN == NaN => false. But we consider two NaN as equal)
 *
 * During a property comparision, properties of `function` type and properties with names
 * that begin with `$` are ignored.
 *
 * Scope and DOMWindow objects are being compared only by identify (`===`).
 *
 * @param {*} o1 Object or value to compare.
 * @param {*} o2 Object or value to compare.
 * @returns {boolean} True if arguments are equal.
 */
function equals(o1, o2) {
  if (o1 === o2) return true;
  if (o1 === null || o2 === null) return false;
  if (o1 !== o1 && o2 !== o2) return true; // NaN === NaN
  var t1 = typeof o1, t2 = typeof o2, length, key, keySet;
  if (t1 == t2) {
    if (t1 == 'object') {
      if (isArray(o1)) {
        if ((length = o1.length) == o2.length) {
          for(key=0; key<length; key++) {
            if (!equals(o1[key], o2[key])) return false;
          }
          return true;
        }
      } else if (isDate(o1)) {
        return isDate(o2) && o1.getTime() == o2.getTime();
      } else {
        if (isScope(o1) || isScope(o2) || isWindow(o1) || isWindow(o2)) return false;
        keySet = {};
        for(key in o1) {
          if (key.charAt(0) === '$' || isFunction(o1[key])) continue;
          if (!equals(o1[key], o2[key])) return false;
          keySet[key] = true;
        }
        for(key in o2) {
          if (!keySet[key] &&
              key.charAt(0) !== '$' &&
              o2[key] !== undefined &&
              !isFunction(o2[key])) return false;
        }
        return true;
      }
    }
  }
  return false;
}


function concat(array1, array2, index) {
  return array1.concat(slice.call(array2, index));
}

function sliceArgs(args, startIndex) {
  return slice.call(args, startIndex || 0);
}


/**
 * @ngdoc function
 * @name angular.bind
 * @function
 *
 * @description
 * Returns a function which calls function `fn` bound to `self` (`self` becomes the `this` for
 * `fn`). You can supply optional `args` that are prebound to the function. This feature is also
 * known as [function currying](http://en.wikipedia.org/wiki/Currying).
 *
 * @param {Object} self Context which `fn` should be evaluated in.
 * @param {function()} fn Function to be bound.
 * @param {...*} args Optional arguments to be prebound to the `fn` function call.
 * @returns {function()} Function that wraps the `fn` with all the specified bindings.
 */
function bind(self, fn) {
  var curryArgs = arguments.length > 2 ? sliceArgs(arguments, 2) : [];
  if (isFunction(fn) && !(fn instanceof RegExp)) {
    return curryArgs.length
      ? function() {
          return arguments.length
            ? fn.apply(self, curryArgs.concat(slice.call(arguments, 0)))
            : fn.apply(self, curryArgs);
        }
      : function() {
          return arguments.length
            ? fn.apply(self, arguments)
            : fn.call(self);
        };
  } else {
    // in IE, native methods are not functions so they cannot be bound (note: they don't need to be)
    return fn;
  }
}


function toJsonReplacer(key, value) {
  var val = value;

  if (/^\$+/.test(key)) {
    val = undefined;
  } else if (isWindow(value)) {
    val = '$WINDOW';
  } else if (value &&  document === value) {
    val = '$DOCUMENT';
  } else if (isScope(value)) {
    val = '$SCOPE';
  }

  return val;
}


/**
 * @ngdoc function
 * @name angular.toJson
 * @function
 *
 * @description
 * Serializes input into a JSON-formatted string.
 *
 * @param {Object|Array|Date|string|number} obj Input to be serialized into JSON.
 * @param {boolean=} pretty If set to true, the JSON output will contain newlines and whitespace.
 * @returns {string} Jsonified string representing `obj`.
 */
function toJson(obj, pretty) {
  return JSON.stringify(obj, toJsonReplacer, pretty ? '  ' : null);
}


/**
 * @ngdoc function
 * @name angular.fromJson
 * @function
 *
 * @description
 * Deserializes a JSON string.
 *
 * @param {string} json JSON string to deserialize.
 * @returns {Object|Array|Date|string|number} Deserialized thingy.
 */
function fromJson(json) {
  return isString(json)
      ? JSON.parse(json)
      : json;
}


function toBoolean(value) {
  if (value && value.length !== 0) {
    var v = lowercase("" + value);
    value = !(v == 'f' || v == '0' || v == 'false' || v == 'no' || v == 'n' || v == '[]');
  } else {
    value = false;
  }
  return value;
}

/**
 * @returns {string} Returns the string representation of the element.
 */
function startingTag(element) {
  element = jqLite(element).clone();
  try {
    // turns out IE does not let you set .html() on elements which
    // are not allowed to have children. So we just ignore it.
    element.html('');
  } catch(e) {}
  // As Per DOM Standards
  var TEXT_NODE = 3;
  var elemHtml = jqLite('<div>').append(element).html();
  try {
    return element[0].nodeType === TEXT_NODE ? lowercase(elemHtml) :
        elemHtml.
          match(/^(<[^>]+>)/)[1].
          replace(/^<([\w\-]+)/, function(match, nodeName) { return '<' + lowercase(nodeName); });
  } catch(e) {
    return lowercase(elemHtml);
  }

}


/////////////////////////////////////////////////

/**
 * Parses an escaped url query string into key-value pairs.
 * @returns Object.<(string|boolean)>
 */
function parseKeyValue(/**string*/keyValue) {
  var obj = {}, key_value, key;
  forEach((keyValue || "").split('&'), function(keyValue){
    if (keyValue) {
      key_value = keyValue.split('=');
      key = decodeURIComponent(key_value[0]);
      obj[key] = isDefined(key_value[1]) ? decodeURIComponent(key_value[1]) : true;
    }
  });
  return obj;
}

function toKeyValue(obj) {
  var parts = [];
  forEach(obj, function(value, key) {
    parts.push(encodeUriQuery(key, true) + (value === true ? '' : '=' + encodeUriQuery(value, true)));
  });
  return parts.length ? parts.join('&') : '';
}


/**
 * We need our custom method because encodeURIComponent is too agressive and doesn't follow
 * http://www.ietf.org/rfc/rfc3986.txt with regards to the character set (pchar) allowed in path
 * segments:
 *    segment       = *pchar
 *    pchar         = unreserved / pct-encoded / sub-delims / ":" / "@"
 *    pct-encoded   = "%" HEXDIG HEXDIG
 *    unreserved    = ALPHA / DIGIT / "-" / "." / "_" / "~"
 *    sub-delims    = "!" / "$" / "&" / "'" / "(" / ")"
 *                     / "*" / "+" / "," / ";" / "="
 */
function encodeUriSegment(val) {
  return encodeUriQuery(val, true).
             replace(/%26/gi, '&').
             replace(/%3D/gi, '=').
             replace(/%2B/gi, '+');
}


/**
 * This method is intended for encoding *key* or *value* parts of query component. We need a custom
 * method becuase encodeURIComponent is too agressive and encodes stuff that doesn't have to be
 * encoded per http://tools.ietf.org/html/rfc3986:
 *    query       = *( pchar / "/" / "?" )
 *    pchar         = unreserved / pct-encoded / sub-delims / ":" / "@"
 *    unreserved    = ALPHA / DIGIT / "-" / "." / "_" / "~"
 *    pct-encoded   = "%" HEXDIG HEXDIG
 *    sub-delims    = "!" / "$" / "&" / "'" / "(" / ")"
 *                     / "*" / "+" / "," / ";" / "="
 */
function encodeUriQuery(val, pctEncodeSpaces) {
  return encodeURIComponent(val).
             replace(/%40/gi, '@').
             replace(/%3A/gi, ':').
             replace(/%24/g, '$').
             replace(/%2C/gi, ',').
             replace(/%20/g, (pctEncodeSpaces ? '%20' : '+'));
}


/**
 * @ngdoc directive
 * @name ng.directive:ngApp
 *
 * @element ANY
 * @param {angular.Module} ngApp an optional application
 *   {@link angular.module module} name to load.
 *
 * @description
 *
 * Use this directive to auto-bootstrap an application. Only
 * one directive can be used per HTML document. The directive
 * designates the root of the application and is typically placed
 * at the root of the page.
 *
 * In the example below if the `ngApp` directive would not be placed
 * on the `html` element then the document would not be compiled
 * and the `{{ 1+2 }}` would not be resolved to `3`.
 *
 * `ngApp` is the easiest way to bootstrap an application.
 *
 <doc:example>
   <doc:source>
    I can add: 1 + 2 =  {{ 1+2 }}
   </doc:source>
 </doc:example>
 *
 */
function angularInit(element, bootstrap) {
  var elements = [element],
      appElement,
      module,
      names = ['ng:app', 'ng-app', 'x-ng-app', 'data-ng-app'],
      NG_APP_CLASS_REGEXP = /\sng[:\-]app(:\s*([\w\d_]+);?)?\s/;

  function append(element) {
    element && elements.push(element);
  }

  forEach(names, function(name) {
    names[name] = true;
    append(document.getElementById(name));
    name = name.replace(':', '\\:');
    if (element.querySelectorAll) {
      forEach(element.querySelectorAll('.' + name), append);
      forEach(element.querySelectorAll('.' + name + '\\:'), append);
      forEach(element.querySelectorAll('[' + name + ']'), append);
    }
  });

  forEach(elements, function(element) {
    if (!appElement) {
      var className = ' ' + element.className + ' ';
      var match = NG_APP_CLASS_REGEXP.exec(className);
      if (match) {
        appElement = element;
        module = (match[2] || '').replace(/\s+/g, ',');
      } else {
        forEach(element.attributes, function(attr) {
          if (!appElement && names[attr.name]) {
            appElement = element;
            module = attr.value;
          }
        });
      }
    }
  });
  if (appElement) {
    bootstrap(appElement, module ? [module] : []);
  }
}

/**
 * @ngdoc function
 * @name angular.bootstrap
 * @description
 * Use this function to manually start up angular application.
 *
 * See: {@link guide/bootstrap Bootstrap}
 *
 * @param {Element} element DOM element which is the root of angular application.
 * @param {Array<String|Function>=} modules an array of module declarations. See: {@link angular.module modules}
 * @returns {AUTO.$injector} Returns the newly created injector for this app.
 */
function bootstrap(element, modules) {
  var resumeBootstrapInternal = function() {
    element = jqLite(element);
    modules = modules || [];
    modules.unshift(['$provide', function($provide) {
      $provide.value('$rootElement', element);
    }]);
    modules.unshift('ng');
    var injector = createInjector(modules);
    injector.invoke(['$rootScope', '$rootElement', '$compile', '$injector',
       function(scope, element, compile, injector) {
        scope.$apply(function() {
          element.data('$injector', injector);
          compile(element)(scope);
        });
      }]
    );
    return injector;
  };

  var NG_DEFER_BOOTSTRAP = /^NG_DEFER_BOOTSTRAP!/;

  if (window && !NG_DEFER_BOOTSTRAP.test(window.name)) {
    return resumeBootstrapInternal();
  }

  window.name = window.name.replace(NG_DEFER_BOOTSTRAP, '');
  angular.resumeBootstrap = function(extraModules) {
    forEach(extraModules, function(module) {
      modules.push(module);
    });
    resumeBootstrapInternal();
  };
}

var SNAKE_CASE_REGEXP = /[A-Z]/g;
function snake_case(name, separator){
  separator = separator || '_';
  return name.replace(SNAKE_CASE_REGEXP, function(letter, pos) {
    return (pos ? separator : '') + letter.toLowerCase();
  });
}

function bindJQuery() {
  // bind to jQuery if present;
  jQuery = window.jQuery;
  // reset to jQuery or default to us.
  if (jQuery) {
    jqLite = jQuery;
    extend(jQuery.fn, {
      scope: JQLitePrototype.scope,
      controller: JQLitePrototype.controller,
      injector: JQLitePrototype.injector,
      inheritedData: JQLitePrototype.inheritedData
    });
    JQLitePatchJQueryRemove('remove', true);
    JQLitePatchJQueryRemove('empty');
    JQLitePatchJQueryRemove('html');
  } else {
    jqLite = JQLite;
  }
  angular.element = jqLite;
}

/**
 * throw error if the argument is falsy.
 */
function assertArg(arg, name, reason) {
  if (!arg) {
    throw new Error("Argument '" + (name || '?') + "' is " + (reason || "required"));
  }
  return arg;
}

function assertArgFn(arg, name, acceptArrayAnnotation) {
  if (acceptArrayAnnotation && isArray(arg)) {
      arg = arg[arg.length - 1];
  }

  assertArg(isFunction(arg), name, 'not a function, got ' +
      (arg && typeof arg == 'object' ? arg.constructor.name || 'Object' : typeof arg));
  return arg;
}

/**
 * @ngdoc interface
 * @name angular.Module
 * @description
 *
 * Interface for configuring angular {@link angular.module modules}.
 */

function setupModuleLoader(window) {

  function ensure(obj, name, factory) {
    return obj[name] || (obj[name] = factory());
  }

  return ensure(ensure(window, 'angular', Object), 'module', function() {
    /** @type {Object.<string, angular.Module>} */
    var modules = {};

    /**
     * @ngdoc function
     * @name angular.module
     * @description
     *
     * The `angular.module` is a global place for creating and registering Angular modules. All
     * modules (angular core or 3rd party) that should be available to an application must be
     * registered using this mechanism.
     *
     *
     * # Module
     *
     * A module is a collocation of services, directives, filters, and configuration information. Module
     * is used to configure the {@link AUTO.$injector $injector}.
     *
     * <pre>
     * // Create a new module
     * var myModule = angular.module('myModule', []);
     *
     * // register a new service
     * myModule.value('appName', 'MyCoolApp');
     *
     * // configure existing services inside initialization blocks.
     * myModule.config(function($locationProvider) {
     *   // Configure existing providers
     *   $locationProvider.hashPrefix('!');
     * });
     * </pre>
     *
     * Then you can create an injector and load your modules like this:
     *
     * <pre>
     * var injector = angular.injector(['ng', 'MyModule'])
     * </pre>
     *
     * However it's more likely that you'll just use
     * {@link ng.directive:ngApp ngApp} or
     * {@link angular.bootstrap} to simplify this process for you.
     *
     * @param {!string} name The name of the module to create or retrieve.
     * @param {Array.<string>=} requires If specified then new module is being created. If unspecified then the
     *        the module is being retrieved for further configuration.
     * @param {Function} configFn Optional configuration function for the module. Same as
     *        {@link angular.Module#config Module#config()}.
     * @returns {module} new module with the {@link angular.Module} api.
     */
    return function module(name, requires, configFn) {
      if (requires && modules.hasOwnProperty(name)) {
        modules[name] = null;
      }
      return ensure(modules, name, function() {
        if (!requires) {
          throw Error('No module: ' + name);
        }

        /** @type {!Array.<Array.<*>>} */
        var invokeQueue = [];

        /** @type {!Array.<Function>} */
        var runBlocks = [];

        var config = invokeLater('$injector', 'invoke');

        /** @type {angular.Module} */
        var moduleInstance = {
          // Private state
          _invokeQueue: invokeQueue,
          _runBlocks: runBlocks,

          /**
           * @ngdoc property
           * @name angular.Module#requires
           * @propertyOf angular.Module
           * @returns {Array.<string>} List of module names which must be loaded before this module.
           * @description
           * Holds the list of modules which the injector will load before the current module is loaded.
           */
          requires: requires,

          /**
           * @ngdoc property
           * @name angular.Module#name
           * @propertyOf angular.Module
           * @returns {string} Name of the module.
           * @description
           */
          name: name,


          /**
           * @ngdoc method
           * @name angular.Module#provider
           * @methodOf angular.Module
           * @param {string} name service name
           * @param {Function} providerType Construction function for creating new instance of the service.
           * @description
           * See {@link AUTO.$provide#provider $provide.provider()}.
           */
          provider: invokeLater('$provide', 'provider'),

          /**
           * @ngdoc method
           * @name angular.Module#factory
           * @methodOf angular.Module
           * @param {string} name service name
           * @param {Function} providerFunction Function for creating new instance of the service.
           * @description
           * See {@link AUTO.$provide#factory $provide.factory()}.
           */
          factory: invokeLater('$provide', 'factory'),

          /**
           * @ngdoc method
           * @name angular.Module#service
           * @methodOf angular.Module
           * @param {string} name service name
           * @param {Function} constructor A constructor function that will be instantiated.
           * @description
           * See {@link AUTO.$provide#service $provide.service()}.
           */
          service: invokeLater('$provide', 'service'),

          /**
           * @ngdoc method
           * @name angular.Module#value
           * @methodOf angular.Module
           * @param {string} name service name
           * @param {*} object Service instance object.
           * @description
           * See {@link AUTO.$provide#value $provide.value()}.
           */
          value: invokeLater('$provide', 'value'),

          /**
           * @ngdoc method
           * @name angular.Module#constant
           * @methodOf angular.Module
           * @param {string} name constant name
           * @param {*} object Constant value.
           * @description
           * Because the constant are fixed, they get applied before other provide methods.
           * See {@link AUTO.$provide#constant $provide.constant()}.
           */
          constant: invokeLater('$provide', 'constant', 'unshift'),

          /**
           * @ngdoc method
           * @name angular.Module#filter
           * @methodOf angular.Module
           * @param {string} name Filter name.
           * @param {Function} filterFactory Factory function for creating new instance of filter.
           * @description
           * See {@link ng.$filterProvider#register $filterProvider.register()}.
           */
          filter: invokeLater('$filterProvider', 'register'),

          /**
           * @ngdoc method
           * @name angular.Module#controller
           * @methodOf angular.Module
           * @param {string} name Controller name.
           * @param {Function} constructor Controller constructor function.
           * @description
           * See {@link ng.$controllerProvider#register $controllerProvider.register()}.
           */
          controller: invokeLater('$controllerProvider', 'register'),

          /**
           * @ngdoc method
           * @name angular.Module#directive
           * @methodOf angular.Module
           * @param {string} name directive name
           * @param {Function} directiveFactory Factory function for creating new instance of
           * directives.
           * @description
           * See {@link ng.$compileProvider#directive $compileProvider.directive()}.
           */
          directive: invokeLater('$compileProvider', 'directive'),

          /**
           * @ngdoc method
           * @name angular.Module#config
           * @methodOf angular.Module
           * @param {Function} configFn Execute this function on module load. Useful for service
           *    configuration.
           * @description
           * Use this method to register work which needs to be performed on module loading.
           */
          config: config,

          /**
           * @ngdoc method
           * @name angular.Module#run
           * @methodOf angular.Module
           * @param {Function} initializationFn Execute this function after injector creation.
           *    Useful for application initialization.
           * @description
           * Use this method to register work which should be performed when the injector is done
           * loading all modules.
           */
          run: function(block) {
            runBlocks.push(block);
            return this;
          }
        };

        if (configFn) {
          config(configFn);
        }

        return  moduleInstance;

        /**
         * @param {string} provider
         * @param {string} method
         * @param {String=} insertMethod
         * @returns {angular.Module}
         */
        function invokeLater(provider, method, insertMethod) {
          return function() {
            invokeQueue[insertMethod || 'push']([provider, method, arguments]);
            return moduleInstance;
          }
        }
      });
    };
  });

}

/**
 * @ngdoc property
 * @name angular.version
 * @description
 * An object that contains information about the current AngularJS version. This object has the
 * following properties:
 *
 * - `full` – `{string}` – Full version string, such as "0.9.18".
 * - `major` – `{number}` – Major version number, such as "0".
 * - `minor` – `{number}` – Minor version number, such as "9".
 * - `dot` – `{number}` – Dot version number, such as "18".
 * - `codeName` – `{string}` – Code name of the release, such as "jiggling-armfat".
 */
var version = {
  full: '1.0.7',    // all of these placeholder strings will be replaced by grunt's
  major: 1,    // package task
  minor: 0,
  dot: 7,
  codeName: 'monochromatic-rainbow'
};


function publishExternalAPI(angular){
  extend(angular, {
    'bootstrap': bootstrap,
    'copy': copy,
    'extend': extend,
    'equals': equals,
    'element': jqLite,
    'forEach': forEach,
    'injector': createInjector,
    'noop':noop,
    'bind':bind,
    'toJson': toJson,
    'fromJson': fromJson,
    'identity':identity,
    'isUndefined': isUndefined,
    'isDefined': isDefined,
    'isString': isString,
    'isFunction': isFunction,
    'isObject': isObject,
    'isNumber': isNumber,
    'isElement': isElement,
    'isArray': isArray,
    'version': version,
    'isDate': isDate,
    'lowercase': lowercase,
    'uppercase': uppercase,
    'callbacks': {counter: 0}
  });

  angularModule = setupModuleLoader(window);
  try {
    angularModule('ngLocale');
  } catch (e) {
    angularModule('ngLocale', []).provider('$locale', $LocaleProvider);
  }

  angularModule('ng', ['ngLocale'], ['$provide',
    function ngModule($provide) {
      $provide.provider('$compile', $CompileProvider).
        directive({
            a: htmlAnchorDirective,
            input: inputDirective,
            textarea: inputDirective,
            form: formDirective,
            script: scriptDirective,
            select: selectDirective,
            style: styleDirective,
            option: optionDirective,
            ngBind: ngBindDirective,
            ngBindHtmlUnsafe: ngBindHtmlUnsafeDirective,
            ngBindTemplate: ngBindTemplateDirective,
            ngClass: ngClassDirective,
            ngClassEven: ngClassEvenDirective,
            ngClassOdd: ngClassOddDirective,
            ngCsp: ngCspDirective,
            ngCloak: ngCloakDirective,
            ngController: ngControllerDirective,
            ngForm: ngFormDirective,
            ngHide: ngHideDirective,
            ngInclude: ngIncludeDirective,
            ngInit: ngInitDirective,
            ngNonBindable: ngNonBindableDirective,
            ngPluralize: ngPluralizeDirective,
            ngRepeat: ngRepeatDirective,
            ngShow: ngShowDirective,
            ngSubmit: ngSubmitDirective,
            ngStyle: ngStyleDirective,
            ngSwitch: ngSwitchDirective,
            ngSwitchWhen: ngSwitchWhenDirective,
            ngSwitchDefault: ngSwitchDefaultDirective,
            ngOptions: ngOptionsDirective,
            ngView: ngViewDirective,
            ngTransclude: ngTranscludeDirective,
            ngModel: ngModelDirective,
            ngList: ngListDirective,
            ngChange: ngChangeDirective,
            required: requiredDirective,
            ngRequired: requiredDirective,
            ngValue: ngValueDirective
        }).
        directive(ngAttributeAliasDirectives).
        directive(ngEventDirectives);
      $provide.provider({
        $anchorScroll: $AnchorScrollProvider,
        $browser: $BrowserProvider,
        $cacheFactory: $CacheFactoryProvider,
        $controller: $ControllerProvider,
        $document: $DocumentProvider,
        $exceptionHandler: $ExceptionHandlerProvider,
        $filter: $FilterProvider,
        $interpolate: $InterpolateProvider,
        $http: $HttpProvider,
        $httpBackend: $HttpBackendProvider,
        $location: $LocationProvider,
        $log: $LogProvider,
        $parse: $ParseProvider,
        $route: $RouteProvider,
        $routeParams: $RouteParamsProvider,
        $rootScope: $RootScopeProvider,
        $q: $QProvider,
        $sniffer: $SnifferProvider,
        $templateCache: $TemplateCacheProvider,
        $timeout: $TimeoutProvider,
        $window: $WindowProvider
      });
    }
  ]);
}

//////////////////////////////////
//JQLite
//////////////////////////////////

/**
 * @ngdoc function
 * @name angular.element
 * @function
 *
 * @description
 * Wraps a raw DOM element or HTML string as a [jQuery](http://jquery.com) element.
 * `angular.element` can be either an alias for [jQuery](http://api.jquery.com/jQuery/) function, if
 * jQuery is available, or a function that wraps the element or string in Angular's jQuery lite
 * implementation (commonly referred to as jqLite).
 *
 * Real jQuery always takes precedence over jqLite, provided it was loaded before `DOMContentLoaded`
 * event fired.
 *
 * jqLite is a tiny, API-compatible subset of jQuery that allows
 * Angular to manipulate the DOM. jqLite implements only the most commonly needed functionality
 * within a very small footprint, so only a subset of the jQuery API - methods, arguments and
 * invocation styles - are supported.
 *
 * Note: All element references in Angular are always wrapped with jQuery or jqLite; they are never
 * raw DOM references.
 *
 * ## Angular's jQuery lite provides the following methods:
 *
 * - [addClass()](http://api.jquery.com/addClass/)
 * - [after()](http://api.jquery.com/after/)
 * - [append()](http://api.jquery.com/append/)
 * - [attr()](http://api.jquery.com/attr/)
 * - [bind()](http://api.jquery.com/bind/) - Does not support namespaces
 * - [children()](http://api.jquery.com/children/) - Does not support selectors
 * - [clone()](http://api.jquery.com/clone/)
 * - [contents()](http://api.jquery.com/contents/)
 * - [css()](http://api.jquery.com/css/)
 * - [data()](http://api.jquery.com/data/)
 * - [eq()](http://api.jquery.com/eq/)
 * - [find()](http://api.jquery.com/find/) - Limited to lookups by tag name
 * - [hasClass()](http://api.jquery.com/hasClass/)
 * - [html()](http://api.jquery.com/html/)
 * - [next()](http://api.jquery.com/next/) - Does not support selectors
 * - [parent()](http://api.jquery.com/parent/) - Does not support selectors
 * - [prepend()](http://api.jquery.com/prepend/)
 * - [prop()](http://api.jquery.com/prop/)
 * - [ready()](http://api.jquery.com/ready/)
 * - [remove()](http://api.jquery.com/remove/)
 * - [removeAttr()](http://api.jquery.com/removeAttr/)
 * - [removeClass()](http://api.jquery.com/removeClass/)
 * - [removeData()](http://api.jquery.com/removeData/)
 * - [replaceWith()](http://api.jquery.com/replaceWith/)
 * - [text()](http://api.jquery.com/text/)
 * - [toggleClass()](http://api.jquery.com/toggleClass/)
 * - [triggerHandler()](http://api.jquery.com/triggerHandler/) - Doesn't pass native event objects to handlers.
 * - [unbind()](http://api.jquery.com/unbind/) - Does not support namespaces
 * - [val()](http://api.jquery.com/val/)
 * - [wrap()](http://api.jquery.com/wrap/)
 *
 * ## In addtion to the above, Angular provides additional methods to both jQuery and jQuery lite:
 *
 * - `controller(name)` - retrieves the controller of the current element or its parent. By default
 *   retrieves controller associated with the `ngController` directive. If `name` is provided as
 *   camelCase directive name, then the controller for this directive will be retrieved (e.g.
 *   `'ngModel'`).
 * - `injector()` - retrieves the injector of the current element or its parent.
 * - `scope()` - retrieves the {@link api/ng.$rootScope.Scope scope} of the current
 *   element or its parent.
 * - `inheritedData()` - same as `data()`, but walks up the DOM until a value is found or the top
 *   parent element is reached.
 *
 * @param {string|DOMElement} element HTML string or DOMElement to be wrapped into jQuery.
 * @returns {Object} jQuery object.
 */

var jqCache = JQLite.cache = {},
    jqName = JQLite.expando = 'ng-' + new Date().getTime(),
    jqId = 1,
    addEventListenerFn = (window.document.addEventListener
      ? function(element, type, fn) {element.addEventListener(type, fn, false);}
      : function(element, type, fn) {element.attachEvent('on' + type, fn);}),
    removeEventListenerFn = (window.document.removeEventListener
      ? function(element, type, fn) {element.removeEventListener(type, fn, false); }
      : function(element, type, fn) {element.detachEvent('on' + type, fn); });

function jqNextId() { return ++jqId; }


var SPECIAL_CHARS_REGEXP = /([\:\-\_]+(.))/g;
var MOZ_HACK_REGEXP = /^moz([A-Z])/;

/**
 * Converts snake_case to camelCase.
 * Also there is special case for Moz prefix starting with upper case letter.
 * @param name Name to normalize
 */
function camelCase(name) {
  return name.
    replace(SPECIAL_CHARS_REGEXP, function(_, separator, letter, offset) {
      return offset ? letter.toUpperCase() : letter;
    }).
    replace(MOZ_HACK_REGEXP, 'Moz$1');
}

/////////////////////////////////////////////
// jQuery mutation patch
//
//  In conjunction with bindJQuery intercepts all jQuery's DOM destruction apis and fires a
// $destroy event on all DOM nodes being removed.
//
/////////////////////////////////////////////

function JQLitePatchJQueryRemove(name, dispatchThis) {
  var originalJqFn = jQuery.fn[name];
  originalJqFn = originalJqFn.$original || originalJqFn;
  removePatch.$original = originalJqFn;
  jQuery.fn[name] = removePatch;

  function removePatch() {
    var list = [this],
        fireEvent = dispatchThis,
        set, setIndex, setLength,
        element, childIndex, childLength, children,
        fns, events;

    while(list.length) {
      set = list.shift();
      for(setIndex = 0, setLength = set.length; setIndex < setLength; setIndex++) {
        element = jqLite(set[setIndex]);
        if (fireEvent) {
          element.triggerHandler('$destroy');
        } else {
          fireEvent = !fireEvent;
        }
        for(childIndex = 0, childLength = (children = element.children()).length;
            childIndex < childLength;
            childIndex++) {
          list.push(jQuery(children[childIndex]));
        }
      }
    }
    return originalJqFn.apply(this, arguments);
  }
}

/////////////////////////////////////////////
function JQLite(element) {
  if (element instanceof JQLite) {
    return element;
  }
  if (!(this instanceof JQLite)) {
    if (isString(element) && element.charAt(0) != '<') {
      throw Error('selectors not implemented');
    }
    return new JQLite(element);
  }

  if (isString(element)) {
    var div = document.createElement('div');
    // Read about the NoScope elements here:
    // http://msdn.microsoft.com/en-us/library/ms533897(VS.85).aspx
    div.innerHTML = '<div>&#160;</div>' + element; // IE insanity to make NoScope elements work!
    div.removeChild(div.firstChild); // remove the superfluous div
    JQLiteAddNodes(this, div.childNodes);
    this.remove(); // detach the elements from the temporary DOM div.
  } else {
    JQLiteAddNodes(this, element);
  }
}

function JQLiteClone(element) {
  return element.cloneNode(true);
}

function JQLiteDealoc(element){
  JQLiteRemoveData(element);
  for ( var i = 0, children = element.childNodes || []; i < children.length; i++) {
    JQLiteDealoc(children[i]);
  }
}

function JQLiteUnbind(element, type, fn) {
  var events = JQLiteExpandoStore(element, 'events'),
      handle = JQLiteExpandoStore(element, 'handle');

  if (!handle) return; //no listeners registered

  if (isUndefined(type)) {
    forEach(events, function(eventHandler, type) {
      removeEventListenerFn(element, type, eventHandler);
      delete events[type];
    });
  } else {
    if (isUndefined(fn)) {
      removeEventListenerFn(element, type, events[type]);
      delete events[type];
    } else {
      arrayRemove(events[type], fn);
    }
  }
}

function JQLiteRemoveData(element) {
  var expandoId = element[jqName],
      expandoStore = jqCache[expandoId];

  if (expandoStore) {
    if (expandoStore.handle) {
      expandoStore.events.$destroy && expandoStore.handle({}, '$destroy');
      JQLiteUnbind(element);
    }
    delete jqCache[expandoId];
    element[jqName] = undefined; // ie does not allow deletion of attributes on elements.
  }
}

function JQLiteExpandoStore(element, key, value) {
  var expandoId = element[jqName],
      expandoStore = jqCache[expandoId || -1];

  if (isDefined(value)) {
    if (!expandoStore) {
      element[jqName] = expandoId = jqNextId();
      expandoStore = jqCache[expandoId] = {};
    }
    expandoStore[key] = value;
  } else {
    return expandoStore && expandoStore[key];
  }
}

function JQLiteData(element, key, value) {
  var data = JQLiteExpandoStore(element, 'data'),
      isSetter = isDefined(value),
      keyDefined = !isSetter && isDefined(key),
      isSimpleGetter = keyDefined && !isObject(key);

  if (!data && !isSimpleGetter) {
    JQLiteExpandoStore(element, 'data', data = {});
  }

  if (isSetter) {
    data[key] = value;
  } else {
    if (keyDefined) {
      if (isSimpleGetter) {
        // don't create data in this case.
        return data && data[key];
      } else {
        extend(data, key);
      }
    } else {
      return data;
    }
  }
}

function JQLiteHasClass(element, selector) {
  return ((" " + element.className + " ").replace(/[\n\t]/g, " ").
      indexOf( " " + selector + " " ) > -1);
}

function JQLiteRemoveClass(element, cssClasses) {
  if (cssClasses) {
    forEach(cssClasses.split(' '), function(cssClass) {
      element.className = trim(
          (" " + element.className + " ")
          .replace(/[\n\t]/g, " ")
          .replace(" " + trim(cssClass) + " ", " ")
      );
    });
  }
}

function JQLiteAddClass(element, cssClasses) {
  if (cssClasses) {
    forEach(cssClasses.split(' '), function(cssClass) {
      if (!JQLiteHasClass(element, cssClass)) {
        element.className = trim(element.className + ' ' + trim(cssClass));
      }
    });
  }
}

function JQLiteAddNodes(root, elements) {
  if (elements) {
    elements = (!elements.nodeName && isDefined(elements.length) && !isWindow(elements))
      ? elements
      : [ elements ];
    for(var i=0; i < elements.length; i++) {
      root.push(elements[i]);
    }
  }
}

function JQLiteController(element, name) {
  return JQLiteInheritedData(element, '$' + (name || 'ngController' ) + 'Controller');
}

function JQLiteInheritedData(element, name, value) {
  element = jqLite(element);

  // if element is the document object work with the html element instead
  // this makes $(document).scope() possible
  if(element[0].nodeType == 9) {
    element = element.find('html');
  }

  while (element.length) {
    if (value = element.data(name)) return value;
    element = element.parent();
  }
}

//////////////////////////////////////////
// Functions which are declared directly.
//////////////////////////////////////////
var JQLitePrototype = JQLite.prototype = {
  ready: function(fn) {
    var fired = false;

    function trigger() {
      if (fired) return;
      fired = true;
      fn();
    }

    this.bind('DOMContentLoaded', trigger); // works for modern browsers and IE9
    // we can not use jqLite since we are not done loading and jQuery could be loaded later.
    JQLite(window).bind('load', trigger); // fallback to window.onload for others
  },
  toString: function() {
    var value = [];
    forEach(this, function(e){ value.push('' + e);});
    return '[' + value.join(', ') + ']';
  },

  eq: function(index) {
      return (index >= 0) ? jqLite(this[index]) : jqLite(this[this.length + index]);
  },

  length: 0,
  push: push,
  sort: [].sort,
  splice: [].splice
};

//////////////////////////////////////////
// Functions iterating getter/setters.
// these functions return self on setter and
// value on get.
//////////////////////////////////////////
var BOOLEAN_ATTR = {};
forEach('multiple,selected,checked,disabled,readOnly,required'.split(','), function(value) {
  BOOLEAN_ATTR[lowercase(value)] = value;
});
var BOOLEAN_ELEMENTS = {};
forEach('input,select,option,textarea,button,form'.split(','), function(value) {
  BOOLEAN_ELEMENTS[uppercase(value)] = true;
});

function getBooleanAttrName(element, name) {
  // check dom last since we will most likely fail on name
  var booleanAttr = BOOLEAN_ATTR[name.toLowerCase()];

  // booleanAttr is here twice to minimize DOM access
  return booleanAttr && BOOLEAN_ELEMENTS[element.nodeName] && booleanAttr;
}

forEach({
  data: JQLiteData,
  inheritedData: JQLiteInheritedData,

  scope: function(element) {
    return JQLiteInheritedData(element, '$scope');
  },

  controller: JQLiteController ,

  injector: function(element) {
    return JQLiteInheritedData(element, '$injector');
  },

  removeAttr: function(element,name) {
    element.removeAttribute(name);
  },

  hasClass: JQLiteHasClass,

  css: function(element, name, value) {
    name = camelCase(name);

    if (isDefined(value)) {
      element.style[name] = value;
    } else {
      var val;

      if (msie <= 8) {
        // this is some IE specific weirdness that jQuery 1.6.4 does not sure why
        val = element.currentStyle && element.currentStyle[name];
        if (val === '') val = 'auto';
      }

      val = val || element.style[name];

      if (msie <= 8) {
        // jquery weirdness :-/
        val = (val === '') ? undefined : val;
      }

      return  val;
    }
  },

  attr: function(element, name, value){
    var lowercasedName = lowercase(name);
    if (BOOLEAN_ATTR[lowercasedName]) {
      if (isDefined(value)) {
        if (!!value) {
          element[name] = true;
          element.setAttribute(name, lowercasedName);
        } else {
          element[name] = false;
          element.removeAttribute(lowercasedName);
        }
      } else {
        return (element[name] ||
                 (element.attributes.getNamedItem(name)|| noop).specified)
               ? lowercasedName
               : undefined;
      }
    } else if (isDefined(value)) {
      element.setAttribute(name, value);
    } else if (element.getAttribute) {
      // the extra argument "2" is to get the right thing for a.href in IE, see jQuery code
      // some elements (e.g. Document) don't have get attribute, so return undefined
      var ret = element.getAttribute(name, 2);
      // normalize non-existing attributes to undefined (as jQuery)
      return ret === null ? undefined : ret;
    }
  },

  prop: function(element, name, value) {
    if (isDefined(value)) {
      element[name] = value;
    } else {
      return element[name];
    }
  },

  text: extend((msie < 9)
      ? function(element, value) {
        if (element.nodeType == 1 /** Element */) {
          if (isUndefined(value))
            return element.innerText;
          element.innerText = value;
        } else {
          if (isUndefined(value))
            return element.nodeValue;
          element.nodeValue = value;
        }
      }
      : function(element, value) {
        if (isUndefined(value)) {
          return element.textContent;
        }
        element.textContent = value;
      }, {$dv:''}),

  val: function(element, value) {
    if (isUndefined(value)) {
      return element.value;
    }
    element.value = value;
  },

  html: function(element, value) {
    if (isUndefined(value)) {
      return element.innerHTML;
    }
    for (var i = 0, childNodes = element.childNodes; i < childNodes.length; i++) {
      JQLiteDealoc(childNodes[i]);
    }
    element.innerHTML = value;
  }
}, function(fn, name){
  /**
   * Properties: writes return selection, reads return first value
   */
  JQLite.prototype[name] = function(arg1, arg2) {
    var i, key;

    // JQLiteHasClass has only two arguments, but is a getter-only fn, so we need to special-case it
    // in a way that survives minification.
    if (((fn.length == 2 && (fn !== JQLiteHasClass && fn !== JQLiteController)) ? arg1 : arg2) === undefined) {
      if (isObject(arg1)) {

        // we are a write, but the object properties are the key/values
        for(i=0; i < this.length; i++) {
          if (fn === JQLiteData) {
            // data() takes the whole object in jQuery
            fn(this[i], arg1);
          } else {
            for (key in arg1) {
              fn(this[i], key, arg1[key]);
            }
          }
        }
        // return self for chaining
        return this;
      } else {
        // we are a read, so read the first child.
        if (this.length)
          return fn(this[0], arg1, arg2);
      }
    } else {
      // we are a write, so apply to all children
      for(i=0; i < this.length; i++) {
        fn(this[i], arg1, arg2);
      }
      // return self for chaining
      return this;
    }
    return fn.$dv;
  };
});

function createEventHandler(element, events) {
  var eventHandler = function (event, type) {
    if (!event.preventDefault) {
      event.preventDefault = function() {
        event.returnValue = false; //ie
      };
    }

    if (!event.stopPropagation) {
      event.stopPropagation = function() {
        event.cancelBubble = true; //ie
      };
    }

    if (!event.target) {
      event.target = event.srcElement || document;
    }

    if (isUndefined(event.defaultPrevented)) {
      var prevent = event.preventDefault;
      event.preventDefault = function() {
        event.defaultPrevented = true;
        prevent.call(event);
      };
      event.defaultPrevented = false;
    }

    event.isDefaultPrevented = function() {
      return event.defaultPrevented;
    };

    forEach(events[type || event.type], function(fn) {
      fn.call(element, event);
    });

    // Remove monkey-patched methods (IE),
    // as they would cause memory leaks in IE8.
    if (msie <= 8) {
      // IE7/8 does not allow to delete property on native object
      event.preventDefault = null;
      event.stopPropagation = null;
      event.isDefaultPrevented = null;
    } else {
      // It shouldn't affect normal browsers (native methods are defined on prototype).
      delete event.preventDefault;
      delete event.stopPropagation;
      delete event.isDefaultPrevented;
    }
  };
  eventHandler.elem = element;
  return eventHandler;
}

//////////////////////////////////////////
// Functions iterating traversal.
// These functions chain results into a single
// selector.
//////////////////////////////////////////
forEach({
  removeData: JQLiteRemoveData,

  dealoc: JQLiteDealoc,

  bind: function bindFn(element, type, fn){
    var events = JQLiteExpandoStore(element, 'events'),
        handle = JQLiteExpandoStore(element, 'handle');

    if (!events) JQLiteExpandoStore(element, 'events', events = {});
    if (!handle) JQLiteExpandoStore(element, 'handle', handle = createEventHandler(element, events));

    forEach(type.split(' '), function(type){
      var eventFns = events[type];

      if (!eventFns) {
        if (type == 'mouseenter' || type == 'mouseleave') {
          var contains = document.body.contains || document.body.compareDocumentPosition ?
          function( a, b ) {
            var adown = a.nodeType === 9 ? a.documentElement : a,
            bup = b && b.parentNode;
            return a === bup || !!( bup && bup.nodeType === 1 && (
              adown.contains ?
              adown.contains( bup ) :
              a.compareDocumentPosition && a.compareDocumentPosition( bup ) & 16
              ));
            } :
            function( a, b ) {
              if ( b ) {
                while ( (b = b.parentNode) ) {
                  if ( b === a ) {
                    return true;
                  }
                }
              }
              return false;
            };	

          events[type] = [];
		
		  // Refer to jQuery's implementation of mouseenter & mouseleave
          // Read about mouseenter and mouseleave:
          // http://www.quirksmode.org/js/events_mouse.html#link8
          var eventmap = { mouseleave : "mouseout", mouseenter : "mouseover"}          
          bindFn(element, eventmap[type], function(event) {
            var ret, target = this, related = event.relatedTarget;
            // For mousenter/leave call the handler if related is outside the target.
            // NB: No relatedTarget if the mouse left/entered the browser window
            if ( !related || (related !== target && !contains(target, related)) ){
              handle(event, type);
            }	

          });

        } else {
          addEventListenerFn(element, type, handle);
          events[type] = [];
        }
        eventFns = events[type]
      }
      eventFns.push(fn);
    });
  },

  unbind: JQLiteUnbind,

  replaceWith: function(element, replaceNode) {
    var index, parent = element.parentNode;
    JQLiteDealoc(element);
    forEach(new JQLite(replaceNode), function(node){
      if (index) {
        parent.insertBefore(node, index.nextSibling);
      } else {
        parent.replaceChild(node, element);
      }
      index = node;
    });
  },

  children: function(element) {
    var children = [];
    forEach(element.childNodes, function(element){
      if (element.nodeType === 1)
        children.push(element);
    });
    return children;
  },

  contents: function(element) {
    return element.childNodes || [];
  },

  append: function(element, node) {
    forEach(new JQLite(node), function(child){
      if (element.nodeType === 1)
        element.appendChild(child);
    });
  },

  prepend: function(element, node) {
    if (element.nodeType === 1) {
      var index = element.firstChild;
      forEach(new JQLite(node), function(child){
        if (index) {
          element.insertBefore(child, index);
        } else {
          element.appendChild(child);
          index = child;
        }
      });
    }
  },

  wrap: function(element, wrapNode) {
    wrapNode = jqLite(wrapNode)[0];
    var parent = element.parentNode;
    if (parent) {
      parent.replaceChild(wrapNode, element);
    }
    wrapNode.appendChild(element);
  },

  remove: function(element) {
    JQLiteDealoc(element);
    var parent = element.parentNode;
    if (parent) parent.removeChild(element);
  },

  after: function(element, newElement) {
    var index = element, parent = element.parentNode;
    forEach(new JQLite(newElement), function(node){
      parent.insertBefore(node, index.nextSibling);
      index = node;
    });
  },

  addClass: JQLiteAddClass,
  removeClass: JQLiteRemoveClass,

  toggleClass: function(element, selector, condition) {
    if (isUndefined(condition)) {
      condition = !JQLiteHasClass(element, selector);
    }
    (condition ? JQLiteAddClass : JQLiteRemoveClass)(element, selector);
  },

  parent: function(element) {
    var parent = element.parentNode;
    return parent && parent.nodeType !== 11 ? parent : null;
  },

  next: function(element) {
    if (element.nextElementSibling) {
      return element.nextElementSibling;
    }

    // IE8 doesn't have nextElementSibling
    var elm = element.nextSibling;
    while (elm != null && elm.nodeType !== 1) {
      elm = elm.nextSibling;
    }
    return elm;
  },

  find: function(element, selector) {
    return element.getElementsByTagName(selector);
  },

  clone: JQLiteClone,

  triggerHandler: function(element, eventName) {
    var eventFns = (JQLiteExpandoStore(element, 'events') || {})[eventName];

    forEach(eventFns, function(fn) {
      fn.call(element, null);
    });
  }
}, function(fn, name){
  /**
   * chaining functions
   */
  JQLite.prototype[name] = function(arg1, arg2) {
    var value;
    for(var i=0; i < this.length; i++) {
      if (value == undefined) {
        value = fn(this[i], arg1, arg2);
        if (value !== undefined) {
          // any function which returns a value needs to be wrapped
          value = jqLite(value);
        }
      } else {
        JQLiteAddNodes(value, fn(this[i], arg1, arg2));
      }
    }
    return value == undefined ? this : value;
  };
});

/**
 * Computes a hash of an 'obj'.
 * Hash of a:
 *  string is string
 *  number is number as string
 *  object is either result of calling $$hashKey function on the object or uniquely generated id,
 *         that is also assigned to the $$hashKey property of the object.
 *
 * @param obj
 * @returns {string} hash string such that the same input will have the same hash string.
 *         The resulting string key is in 'type:hashKey' format.
 */
function hashKey(obj) {
  var objType = typeof obj,
      key;

  if (objType == 'object' && obj !== null) {
    if (typeof (key = obj.$$hashKey) == 'function') {
      // must invoke on object to keep the right this
      key = obj.$$hashKey();
    } else if (key === undefined) {
      key = obj.$$hashKey = nextUid();
    }
  } else {
    key = obj;
  }

  return objType + ':' + key;
}

/**
 * HashMap which can use objects as keys
 */
function HashMap(array){
  forEach(array, this.put, this);
}
HashMap.prototype = {
  /**
   * Store key value pair
   * @param key key to store can be any type
   * @param value value to store can be any type
   */
  put: function(key, value) {
    this[hashKey(key)] = value;
  },

  /**
   * @param key
   * @returns the value for the key
   */
  get: function(key) {
    return this[hashKey(key)];
  },

  /**
   * Remove the key/value pair
   * @param key
   */
  remove: function(key) {
    var value = this[key = hashKey(key)];
    delete this[key];
    return value;
  }
};

/**
 * A map where multiple values can be added to the same key such that they form a queue.
 * @returns {HashQueueMap}
 */
function HashQueueMap() {}
HashQueueMap.prototype = {
  /**
   * Same as array push, but using an array as the value for the hash
   */
  push: function(key, value) {
    var array = this[key = hashKey(key)];
    if (!array) {
      this[key] = [value];
    } else {
      array.push(value);
    }
  },

  /**
   * Same as array shift, but using an array as the value for the hash
   */
  shift: function(key) {
    var array = this[key = hashKey(key)];
    if (array) {
      if (array.length == 1) {
        delete this[key];
        return array[0];
      } else {
        return array.shift();
      }
    }
  },

  /**
   * return the first item without deleting it
   */
  peek: function(key) {
    var array = this[hashKey(key)];
    if (array) {
    return array[0];
    }
  }
};

/**
 * @ngdoc function
 * @name angular.injector
 * @function
 *
 * @description
 * Creates an injector function that can be used for retrieving services as well as for
 * dependency injection (see {@link guide/di dependency injection}).
 *

 * @param {Array.<string|Function>} modules A list of module functions or their aliases. See
 *        {@link angular.module}. The `ng` module must be explicitly added.
 * @returns {function()} Injector function. See {@link AUTO.$injector $injector}.
 *
 * @example
 * Typical usage
 * <pre>
 *   // create an injector
 *   var $injector = angular.injector(['ng']);
 *
 *   // use the injector to kick off your application
 *   // use the type inference to auto inject arguments, or use implicit injection
 *   $injector.invoke(function($rootScope, $compile, $document){
 *     $compile($document)($rootScope);
 *     $rootScope.$digest();
 *   });
 * </pre>
 */


/**
 * @ngdoc overview
 * @name AUTO
 * @description
 *
 * Implicit module which gets automatically added to each {@link AUTO.$injector $injector}.
 */

var FN_ARGS = /^function\s*[^\(]*\(\s*([^\)]*)\)/m;
var FN_ARG_SPLIT = /,/;
var FN_ARG = /^\s*(_?)(\S+?)\1\s*$/;
var STRIP_COMMENTS = /((\/\/.*$)|(\/\*[\s\S]*?\*\/))/mg;
function annotate(fn) {
  var $inject,
      fnText,
      argDecl,
      last;

  if (typeof fn == 'function') {
    if (!($inject = fn.$inject)) {
      $inject = [];
      fnText = fn.toString().replace(STRIP_COMMENTS, '');
      argDecl = fnText.match(FN_ARGS);
      forEach(argDecl[1].split(FN_ARG_SPLIT), function(arg){
        arg.replace(FN_ARG, function(all, underscore, name){
          $inject.push(name);
        });
      });
      fn.$inject = $inject;
    }
  } else if (isArray(fn)) {
    last = fn.length - 1;
    assertArgFn(fn[last], 'fn');
    $inject = fn.slice(0, last);
  } else {
    assertArgFn(fn, 'fn', true);
  }
  return $inject;
}

///////////////////////////////////////

/**
 * @ngdoc object
 * @name AUTO.$injector
 * @function
 *
 * @description
 *
 * `$injector` is used to retrieve object instances as defined by
 * {@link AUTO.$provide provider}, instantiate types, invoke methods,
 * and load modules.
 *
 * The following always holds true:
 *
 * <pre>
 *   var $injector = angular.injector();
 *   expect($injector.get('$injector')).toBe($injector);
 *   expect($injector.invoke(function($injector){
 *     return $injector;
 *   }).toBe($injector);
 * </pre>
 *
 * # Injection Function Annotation
 *
 * JavaScript does not have annotations, and annotations are needed for dependency injection. The
 * following are all valid ways of annotating function with injection arguments and are equivalent.
 *
 * <pre>
 *   // inferred (only works if code not minified/obfuscated)
 *   $injector.invoke(function(serviceA){});
 *
 *   // annotated
 *   function explicit(serviceA) {};
 *   explicit.$inject = ['serviceA'];
 *   $injector.invoke(explicit);
 *
 *   // inline
 *   $injector.invoke(['serviceA', function(serviceA){}]);
 * </pre>
 *
 * ## Inference
 *
 * In JavaScript calling `toString()` on a function returns the function definition. The definition can then be
 * parsed and the function arguments can be extracted. *NOTE:* This does not work with minification, and obfuscation
 * tools since these tools change the argument names.
 *
 * ## `$inject` Annotation
 * By adding a `$inject` property onto a function the injection parameters can be specified.
 *
 * ## Inline
 * As an array of injection names, where the last item in the array is the function to call.
 */

/**
 * @ngdoc method
 * @name AUTO.$injector#get
 * @methodOf AUTO.$injector
 *
 * @description
 * Return an instance of the service.
 *
 * @param {string} name The name of the instance to retrieve.
 * @return {*} The instance.
 */

/**
 * @ngdoc method
 * @name AUTO.$injector#invoke
 * @methodOf AUTO.$injector
 *
 * @description
 * Invoke the method and supply the method arguments from the `$injector`.
 *
 * @param {!function} fn The function to invoke. The function arguments come form the function annotation.
 * @param {Object=} self The `this` for the invoked method.
 * @param {Object=} locals Optional object. If preset then any argument names are read from this object first, before
 *   the `$injector` is consulted.
 * @returns {*} the value returned by the invoked `fn` function.
 */

/**
 * @ngdoc method
 * @name AUTO.$injector#instantiate
 * @methodOf AUTO.$injector
 * @description
 * Create a new instance of JS type. The method takes a constructor function invokes the new operator and supplies
 * all of the arguments to the constructor function as specified by the constructor annotation.
 *
 * @param {function} Type Annotated constructor function.
 * @param {Object=} locals Optional object. If preset then any argument names are read from this object first, before
 *   the `$injector` is consulted.
 * @returns {Object} new instance of `Type`.
 */

/**
 * @ngdoc method
 * @name AUTO.$injector#annotate
 * @methodOf AUTO.$injector
 *
 * @description
 * Returns an array of service names which the function is requesting for injection. This API is used by the injector
 * to determine which services need to be injected into the function when the function is invoked. There are three
 * ways in which the function can be annotated with the needed dependencies.
 *
 * # Argument names
 *
 * The simplest form is to extract the dependencies from the arguments of the function. This is done by converting
 * the function into a string using `toString()` method and extracting the argument names.
 * <pre>
 *   // Given
 *   function MyController($scope, $route) {
 *     // ...
 *   }
 *
 *   // Then
 *   expect(injector.annotate(MyController)).toEqual(['$scope', '$route']);
 * </pre>
 *
 * This method does not work with code minfication / obfuscation. For this reason the following annotation strategies
 * are supported.
 *
 * # The `$inject` property
 *
 * If a function has an `$inject` property and its value is an array of strings, then the strings represent names of
 * services to be injected into the function.
 * <pre>
 *   // Given
 *   var MyController = function(obfuscatedScope, obfuscatedRoute) {
 *     // ...
 *   }
 *   // Define function dependencies
 *   MyController.$inject = ['$scope', '$route'];
 *
 *   // Then
 *   expect(injector.annotate(MyController)).toEqual(['$scope', '$route']);
 * </pre>
 *
 * # The array notation
 *
 * It is often desirable to inline Injected functions and that's when setting the `$inject` property is very
 * inconvenient. In these situations using the array notation to specify the dependencies in a way that survives
 * minification is a better choice:
 *
 * <pre>
 *   // We wish to write this (not minification / obfuscation safe)
 *   injector.invoke(function($compile, $rootScope) {
 *     // ...
 *   });
 *
 *   // We are forced to write break inlining
 *   var tmpFn = function(obfuscatedCompile, obfuscatedRootScope) {
 *     // ...
 *   };
 *   tmpFn.$inject = ['$compile', '$rootScope'];
 *   injector.invoke(tmpFn);
 *
 *   // To better support inline function the inline annotation is supported
 *   injector.invoke(['$compile', '$rootScope', function(obfCompile, obfRootScope) {
 *     // ...
 *   }]);
 *
 *   // Therefore
 *   expect(injector.annotate(
 *      ['$compile', '$rootScope', function(obfus_$compile, obfus_$rootScope) {}])
 *    ).toEqual(['$compile', '$rootScope']);
 * </pre>
 *
 * @param {function|Array.<string|Function>} fn Function for which dependent service names need to be retrieved as described
 *   above.
 *
 * @returns {Array.<string>} The names of the services which the function requires.
 */




/**
 * @ngdoc object
 * @name AUTO.$provide
 *
 * @description
 *
 * Use `$provide` to register new providers with the `$injector`. The providers are the factories for the instance.
 * The providers share the same name as the instance they create with `Provider` suffixed to them.
 *
 * A provider is an object with a `$get()` method. The injector calls the `$get` method to create a new instance of
 * a service. The Provider can have additional methods which would allow for configuration of the provider.
 *
 * <pre>
 *   function GreetProvider() {
 *     var salutation = 'Hello';
 *
 *     this.salutation = function(text) {
 *       salutation = text;
 *     };
 *
 *     this.$get = function() {
 *       return function (name) {
 *         return salutation + ' ' + name + '!';
 *       };
 *     };
 *   }
 *
 *   describe('Greeter', function(){
 *
 *     beforeEach(module(function($provide) {
 *       $provide.provider('greet', GreetProvider);
 *     }));
 *
 *     it('should greet', inject(function(greet) {
 *       expect(greet('angular')).toEqual('Hello angular!');
 *     }));
 *
 *     it('should allow configuration of salutation', function() {
 *       module(function(greetProvider) {
 *         greetProvider.salutation('Ahoj');
 *       });
 *       inject(function(greet) {
 *         expect(greet('angular')).toEqual('Ahoj angular!');
 *       });
 *     });
 * </pre>
 */

/**
 * @ngdoc method
 * @name AUTO.$provide#provider
 * @methodOf AUTO.$provide
 * @description
 *
 * Register a provider for a service. The providers can be retrieved and can have additional configuration methods.
 *
 * @param {string} name The name of the instance. NOTE: the provider will be available under `name + 'Provider'` key.
 * @param {(Object|function())} provider If the provider is:
 *
 *   - `Object`: then it should have a `$get` method. The `$get` method will be invoked using
 *               {@link AUTO.$injector#invoke $injector.invoke()} when an instance needs to be created.
 *   - `Constructor`: a new instance of the provider will be created using
 *               {@link AUTO.$injector#instantiate $injector.instantiate()}, then treated as `object`.
 *
 * @returns {Object} registered provider instance
 */

/**
 * @ngdoc method
 * @name AUTO.$provide#factory
 * @methodOf AUTO.$provide
 * @description
 *
 * A short hand for configuring services if only `$get` method is required.
 *
 * @param {string} name The name of the instance.
 * @param {function()} $getFn The $getFn for the instance creation. Internally this is a short hand for
 * `$provide.provider(name, {$get: $getFn})`.
 * @returns {Object} registered provider instance
 */


/**
 * @ngdoc method
 * @name AUTO.$provide#service
 * @methodOf AUTO.$provide
 * @description
 *
 * A short hand for registering service of given class.
 *
 * @param {string} name The name of the instance.
 * @param {Function} constructor A class (constructor function) that will be instantiated.
 * @returns {Object} registered provider instance
 */


/**
 * @ngdoc method
 * @name AUTO.$provide#value
 * @methodOf AUTO.$provide
 * @description
 *
 * A short hand for configuring services if the `$get` method is a constant.
 *
 * @param {string} name The name of the instance.
 * @param {*} value The value.
 * @returns {Object} registered provider instance
 */


/**
 * @ngdoc method
 * @name AUTO.$provide#constant
 * @methodOf AUTO.$provide
 * @description
 *
 * A constant value, but unlike {@link AUTO.$provide#value value} it can be injected
 * into configuration function (other modules) and it is not interceptable by
 * {@link AUTO.$provide#decorator decorator}.
 *
 * @param {string} name The name of the constant.
 * @param {*} value The constant value.
 * @returns {Object} registered instance
 */


/**
 * @ngdoc method
 * @name AUTO.$provide#decorator
 * @methodOf AUTO.$provide
 * @description
 *
 * Decoration of service, allows the decorator to intercept the service instance creation. The
 * returned instance may be the original instance, or a new instance which delegates to the
 * original instance.
 *
 * @param {string} name The name of the service to decorate.
 * @param {function()} decorator This function will be invoked when the service needs to be
 *    instantiated. The function is called using the {@link AUTO.$injector#invoke
 *    injector.invoke} method and is therefore fully injectable. Local injection arguments:
 *
 *    * `$delegate` - The original service instance, which can be monkey patched, configured,
 *      decorated or delegated to.
 */


function createInjector(modulesToLoad) {
  var INSTANTIATING = {},
      providerSuffix = 'Provider',
      path = [],
      loadedModules = new HashMap(),
      providerCache = {
        $provide: {
            provider: supportObject(provider),
            factory: supportObject(factory),
            service: supportObject(service),
            value: supportObject(value),
            constant: supportObject(constant),
            decorator: decorator
          }
      },
      providerInjector = createInternalInjector(providerCache, function() {
        throw Error("Unknown provider: " + path.join(' <- '));
      }),
      instanceCache = {},
      instanceInjector = (instanceCache.$injector =
          createInternalInjector(instanceCache, function(servicename) {
            var provider = providerInjector.get(servicename + providerSuffix);
            return instanceInjector.invoke(provider.$get, provider);
          }));


  forEach(loadModules(modulesToLoad), function(fn) { instanceInjector.invoke(fn || noop); });

  return instanceInjector;

  ////////////////////////////////////
  // $provider
  ////////////////////////////////////

  function supportObject(delegate) {
    return function(key, value) {
      if (isObject(key)) {
        forEach(key, reverseParams(delegate));
      } else {
        return delegate(key, value);
      }
    }
  }

  function provider(name, provider_) {
    if (isFunction(provider_) || isArray(provider_)) {
      provider_ = providerInjector.instantiate(provider_);
    }
    if (!provider_.$get) {
      throw Error('Provider ' + name + ' must define $get factory method.');
    }
    return providerCache[name + providerSuffix] = provider_;
  }

  function factory(name, factoryFn) { return provider(name, { $get: factoryFn }); }

  function service(name, constructor) {
    return factory(name, ['$injector', function($injector) {
      return $injector.instantiate(constructor);
    }]);
  }

  function value(name, value) { return factory(name, valueFn(value)); }

  function constant(name, value) {
    providerCache[name] = value;
    instanceCache[name] = value;
  }

  function decorator(serviceName, decorFn) {
    var origProvider = providerInjector.get(serviceName + providerSuffix),
        orig$get = origProvider.$get;

    origProvider.$get = function() {
      var origInstance = instanceInjector.invoke(orig$get, origProvider);
      return instanceInjector.invoke(decorFn, null, {$delegate: origInstance});
    };
  }

  ////////////////////////////////////
  // Module Loading
  ////////////////////////////////////
  function loadModules(modulesToLoad){
    var runBlocks = [];
    forEach(modulesToLoad, function(module) {
      if (loadedModules.get(module)) return;
      loadedModules.put(module, true);
      if (isString(module)) {
        var moduleFn = angularModule(module);
        runBlocks = runBlocks.concat(loadModules(moduleFn.requires)).concat(moduleFn._runBlocks);

        try {
          for(var invokeQueue = moduleFn._invokeQueue, i = 0, ii = invokeQueue.length; i < ii; i++) {
            var invokeArgs = invokeQueue[i],
                provider = invokeArgs[0] == '$injector'
                    ? providerInjector
                    : providerInjector.get(invokeArgs[0]);

            provider[invokeArgs[1]].apply(provider, invokeArgs[2]);
          }
        } catch (e) {
          if (e.message) e.message += ' from ' + module;
          throw e;
        }
      } else if (isFunction(module)) {
        try {
          runBlocks.push(providerInjector.invoke(module));
        } catch (e) {
          if (e.message) e.message += ' from ' + module;
          throw e;
        }
      } else if (isArray(module)) {
        try {
          runBlocks.push(providerInjector.invoke(module));
        } catch (e) {
          if (e.message) e.message += ' from ' + String(module[module.length - 1]);
          throw e;
        }
      } else {
        assertArgFn(module, 'module');
      }
    });
    return runBlocks;
  }

  ////////////////////////////////////
  // internal Injector
  ////////////////////////////////////

  function createInternalInjector(cache, factory) {

    function getService(serviceName) {
      if (typeof serviceName !== 'string') {
        throw Error('Service name expected');
      }
      if (cache.hasOwnProperty(serviceName)) {
        if (cache[serviceName] === INSTANTIATING) {
          throw Error('Circular dependency: ' + path.join(' <- '));
        }
        return cache[serviceName];
      } else {
        try {
          path.unshift(serviceName);
          cache[serviceName] = INSTANTIATING;
          return cache[serviceName] = factory(serviceName);
        } finally {
          path.shift();
        }
      }
    }

    function invoke(fn, self, locals){
      var args = [],
          $inject = annotate(fn),
          length, i,
          key;

      for(i = 0, length = $inject.length; i < length; i++) {
        key = $inject[i];
        args.push(
          locals && locals.hasOwnProperty(key)
          ? locals[key]
          : getService(key)
        );
      }
      if (!fn.$inject) {
        // this means that we must be an array.
        fn = fn[length];
      }


      // Performance optimization: http://jsperf.com/apply-vs-call-vs-invoke
      switch (self ? -1 : args.length) {
        case  0: return fn();
        case  1: return fn(args[0]);
        case  2: return fn(args[0], args[1]);
        case  3: return fn(args[0], args[1], args[2]);
        case  4: return fn(args[0], args[1], args[2], args[3]);
        case  5: return fn(args[0], args[1], args[2], args[3], args[4]);
        case  6: return fn(args[0], args[1], args[2], args[3], args[4], args[5]);
        case  7: return fn(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
        case  8: return fn(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
        case  9: return fn(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
        case 10: return fn(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
        default: return fn.apply(self, args);
      }
    }

    function instantiate(Type, locals) {
      var Constructor = function() {},
          instance, returnedValue;

      // Check if Type is annotated and use just the given function at n-1 as parameter
      // e.g. someModule.factory('greeter', ['$window', function(renamed$window) {}]);
      Constructor.prototype = (isArray(Type) ? Type[Type.length - 1] : Type).prototype;
      instance = new Constructor();
      returnedValue = invoke(Type, instance, locals);

      return isObject(returnedValue) ? returnedValue : instance;
    }

    return {
      invoke: invoke,
      instantiate: instantiate,
      get: getService,
      annotate: annotate
    };
  }
}

/**
 * @ngdoc function
 * @name ng.$anchorScroll
 * @requires $window
 * @requires $location
 * @requires $rootScope
 *
 * @description
 * When called, it checks current value of `$location.hash()` and scroll to related element,
 * according to rules specified in
 * {@link http://dev.w3.org/html5/spec/Overview.html#the-indicated-part-of-the-document Html5 spec}.
 *
 * It also watches the `$location.hash()` and scroll whenever it changes to match any anchor.
 * This can be disabled by calling `$anchorScrollProvider.disableAutoScrolling()`.
 */
function $AnchorScrollProvider() {

  var autoScrollingEnabled = true;

  this.disableAutoScrolling = function() {
    autoScrollingEnabled = false;
  };

  this.$get = ['$window', '$location', '$rootScope', function($window, $location, $rootScope) {
    var document = $window.document;

    // helper function to get first anchor from a NodeList
    // can't use filter.filter, as it accepts only instances of Array
    // and IE can't convert NodeList to an array using [].slice
    // TODO(vojta): use filter if we change it to accept lists as well
    function getFirstAnchor(list) {
      var result = null;
      forEach(list, function(element) {
        if (!result && lowercase(element.nodeName) === 'a') result = element;
      });
      return result;
    }

    function scroll() {
      var hash = $location.hash(), elm;

      // empty hash, scroll to the top of the page
      if (!hash) $window.scrollTo(0, 0);

      // element with given id
      else if ((elm = document.getElementById(hash))) elm.scrollIntoView();

      // first anchor with given name :-D
      else if ((elm = getFirstAnchor(document.getElementsByName(hash)))) elm.scrollIntoView();

      // no element and hash == 'top', scroll to the top of the page
      else if (hash === 'top') $window.scrollTo(0, 0);
    }

    // does not scroll when user clicks on anchor link that is currently on
    // (no url change, no $location.hash() change), browser native does scroll
    if (autoScrollingEnabled) {
      $rootScope.$watch(function autoScrollWatch() {return $location.hash();},
        function autoScrollWatchAction() {
          $rootScope.$evalAsync(scroll);
        });
    }

    return scroll;
  }];
}

/**
 * ! This is a private undocumented service !
 *
 * @name ng.$browser
 * @requires $log
 * @description
 * This object has two goals:
 *
 * - hide all the global state in the browser caused by the window object
 * - abstract away all the browser specific features and inconsistencies
 *
 * For tests we provide {@link ngMock.$browser mock implementation} of the `$browser`
 * service, which can be used for convenient testing of the application without the interaction with
 * the real browser apis.
 */
/**
 * @param {object} window The global window object.
 * @param {object} document jQuery wrapped document.
 * @param {function()} XHR XMLHttpRequest constructor.
 * @param {object} $log console.log or an object with the same interface.
 * @param {object} $sniffer $sniffer service
 */
function Browser(window, document, $log, $sniffer) {
  var self = this,
      rawDocument = document[0],
      location = window.location,
      history = window.history,
      setTimeout = window.setTimeout,
      clearTimeout = window.clearTimeout,
      pendingDeferIds = {};

  self.isMock = false;

  var outstandingRequestCount = 0;
  var outstandingRequestCallbacks = [];

  // TODO(vojta): remove this temporary api
  self.$$completeOutstandingRequest = completeOutstandingRequest;
  self.$$incOutstandingRequestCount = function() { outstandingRequestCount++; };

  /**
   * Executes the `fn` function(supports currying) and decrements the `outstandingRequestCallbacks`
   * counter. If the counter reaches 0, all the `outstandingRequestCallbacks` are executed.
   */
  function completeOutstandingRequest(fn) {
    try {
      fn.apply(null, sliceArgs(arguments, 1));
    } finally {
      outstandingRequestCount--;
      if (outstandingRequestCount === 0) {
        while(outstandingRequestCallbacks.length) {
          try {
            outstandingRequestCallbacks.pop()();
          } catch (e) {
            $log.error(e);
          }
        }
      }
    }
  }

  /**
   * @private
   * Note: this method is used only by scenario runner
   * TODO(vojta): prefix this method with $$ ?
   * @param {function()} callback Function that will be called when no outstanding request
   */
  self.notifyWhenNoOutstandingRequests = function(callback) {
    // force browser to execute all pollFns - this is needed so that cookies and other pollers fire
    // at some deterministic time in respect to the test runner's actions. Leaving things up to the
    // regular poller would result in flaky tests.
    forEach(pollFns, function(pollFn){ pollFn(); });

    if (outstandingRequestCount === 0) {
      callback();
    } else {
      outstandingRequestCallbacks.push(callback);
    }
  };

  //////////////////////////////////////////////////////////////
  // Poll Watcher API
  //////////////////////////////////////////////////////////////
  var pollFns = [],
      pollTimeout;

  /**
   * @name ng.$browser#addPollFn
   * @methodOf ng.$browser
   *
   * @param {function()} fn Poll function to add
   *
   * @description
   * Adds a function to the list of functions that poller periodically executes,
   * and starts polling if not started yet.
   *
   * @returns {function()} the added function
   */
  self.addPollFn = function(fn) {
    if (isUndefined(pollTimeout)) startPoller(100, setTimeout);
    pollFns.push(fn);
    return fn;
  };

  /**
   * @param {number} interval How often should browser call poll functions (ms)
   * @param {function()} setTimeout Reference to a real or fake `setTimeout` function.
   *
   * @description
   * Configures the poller to run in the specified intervals, using the specified
   * setTimeout fn and kicks it off.
   */
  function startPoller(interval, setTimeout) {
    (function check() {
      forEach(pollFns, function(pollFn){ pollFn(); });
      pollTimeout = setTimeout(check, interval);
    })();
  }

  //////////////////////////////////////////////////////////////
  // URL API
  //////////////////////////////////////////////////////////////

  var lastBrowserUrl = location.href,
      baseElement = document.find('base');

  /**
   * @name ng.$browser#url
   * @methodOf ng.$browser
   *
   * @description
   * GETTER:
   * Without any argument, this method just returns current value of location.href.
   *
   * SETTER:
   * With at least one argument, this method sets url to new value.
   * If html5 history api supported, pushState/replaceState is used, otherwise
   * location.href/location.replace is used.
   * Returns its own instance to allow chaining
   *
   * NOTE: this api is intended for use only by the $location service. Please use the
   * {@link ng.$location $location service} to change url.
   *
   * @param {string} url New url (when used as setter)
   * @param {boolean=} replace Should new url replace current history record ?
   */
  self.url = function(url, replace) {
    // setter
    if (url) {
      if (lastBrowserUrl == url) return;
      lastBrowserUrl = url;
      if ($sniffer.history) {
        if (replace) history.replaceState(null, '', url);
        else {
          history.pushState(null, '', url);
          // Crazy Opera Bug: http://my.opera.com/community/forums/topic.dml?id=1185462
          baseElement.attr('href', baseElement.attr('href'));
        }
      } else {
        if (replace) location.replace(url);
        else location.href = url;
      }
      return self;
    // getter
    } else {
      // the replacement is a workaround for https://bugzilla.mozilla.org/show_bug.cgi?id=407172
      return location.href.replace(/%27/g,"'");
    }
  };

  var urlChangeListeners = [],
      urlChangeInit = false;

  function fireUrlChange() {
    if (lastBrowserUrl == self.url()) return;

    lastBrowserUrl = self.url();
    forEach(urlChangeListeners, function(listener) {
      listener(self.url());
    });
  }

  /**
   * @name ng.$browser#onUrlChange
   * @methodOf ng.$browser
   * @TODO(vojta): refactor to use node's syntax for events
   *
   * @description
   * Register callback function that will be called, when url changes.
   *
   * It's only called when the url is changed by outside of angular:
   * - user types different url into address bar
   * - user clicks on history (forward/back) button
   * - user clicks on a link
   *
   * It's not called when url is changed by $browser.url() method
   *
   * The listener gets called with new url as parameter.
   *
   * NOTE: this api is intended for use only by the $location service. Please use the
   * {@link ng.$location $location service} to monitor url changes in angular apps.
   *
   * @param {function(string)} listener Listener function to be called when url changes.
   * @return {function(string)} Returns the registered listener fn - handy if the fn is anonymous.
   */
  self.onUrlChange = function(callback) {
    if (!urlChangeInit) {
      // We listen on both (hashchange/popstate) when available, as some browsers (e.g. Opera)
      // don't fire popstate when user change the address bar and don't fire hashchange when url
      // changed by push/replaceState

      // html5 history api - popstate event
      if ($sniffer.history) jqLite(window).bind('popstate', fireUrlChange);
      // hashchange event
      if ($sniffer.hashchange) jqLite(window).bind('hashchange', fireUrlChange);
      // polling
      else self.addPollFn(fireUrlChange);

      urlChangeInit = true;
    }

    urlChangeListeners.push(callback);
    return callback;
  };

  //////////////////////////////////////////////////////////////
  // Misc API
  //////////////////////////////////////////////////////////////

  /**
   * Returns current <base href>
   * (always relative - without domain)
   *
   * @returns {string=}
   */
  self.baseHref = function() {
    var href = baseElement.attr('href');
    return href ? href.replace(/^https?\:\/\/[^\/]*/, '') : '';
  };

  //////////////////////////////////////////////////////////////
  // Cookies API
  //////////////////////////////////////////////////////////////
  var lastCookies = {};
  var lastCookieString = '';
  var cookiePath = self.baseHref();

  /**
   * @name ng.$browser#cookies
   * @methodOf ng.$browser
   *
   * @param {string=} name Cookie name
   * @param {string=} value Cokkie value
   *
   * @description
   * The cookies method provides a 'private' low level access to browser cookies.
   * It is not meant to be used directly, use the $cookie service instead.
   *
   * The return values vary depending on the arguments that the method was called with as follows:
   * <ul>
   *   <li>cookies() -> hash of all cookies, this is NOT a copy of the internal state, so do not modify it</li>
   *   <li>cookies(name, value) -> set name to value, if value is undefined delete the cookie</li>
   *   <li>cookies(name) -> the same as (name, undefined) == DELETES (no one calls it right now that way)</li>
   * </ul>
   *
   * @returns {Object} Hash of all cookies (if called without any parameter)
   */
  self.cookies = function(name, value) {
    var cookieLength, cookieArray, cookie, i, index;

    if (name) {
      if (value === undefined) {
        rawDocument.cookie = escape(name) + "=;path=" + cookiePath + ";expires=Thu, 01 Jan 1970 00:00:00 GMT";
      } else {
        if (isString(value)) {
          cookieLength = (rawDocument.cookie = escape(name) + '=' + escape(value) + ';path=' + cookiePath).length + 1;

          // per http://www.ietf.org/rfc/rfc2109.txt browser must allow at minimum:
          // - 300 cookies
          // - 20 cookies per unique domain
          // - 4096 bytes per cookie
          if (cookieLength > 4096) {
            $log.warn("Cookie '"+ name +"' possibly not set or overflowed because it was too large ("+
              cookieLength + " > 4096 bytes)!");
          }
        }
      }
    } else {
      if (rawDocument.cookie !== lastCookieString) {
        lastCookieString = rawDocument.cookie;
        cookieArray = lastCookieString.split("; ");
        lastCookies = {};

        for (i = 0; i < cookieArray.length; i++) {
          cookie = cookieArray[i];
          index = cookie.indexOf('=');
          if (index > 0) { //ignore nameless cookies
            var name = unescape(cookie.substring(0, index));
            // the first value that is seen for a cookie is the most
            // specific one.  values for the same cookie name that
            // follow are for less specific paths.
            if (lastCookies[name] === undefined) {
              lastCookies[name] = unescape(cookie.substring(index + 1));
            }
          }
        }
      }
      return lastCookies;
    }
  };


  /**
   * @name ng.$browser#defer
   * @methodOf ng.$browser
   * @param {function()} fn A function, who's execution should be defered.
   * @param {number=} [delay=0] of milliseconds to defer the function execution.
   * @returns {*} DeferId that can be used to cancel the task via `$browser.defer.cancel()`.
   *
   * @description
   * Executes a fn asynchroniously via `setTimeout(fn, delay)`.
   *
   * Unlike when calling `setTimeout` directly, in test this function is mocked and instead of using
   * `setTimeout` in tests, the fns are queued in an array, which can be programmatically flushed
   * via `$browser.defer.flush()`.
   *
   */
  self.defer = function(fn, delay) {
    var timeoutId;
    outstandingRequestCount++;
    timeoutId = setTimeout(function() {
      delete pendingDeferIds[timeoutId];
      completeOutstandingRequest(fn);
    }, delay || 0);
    pendingDeferIds[timeoutId] = true;
    return timeoutId;
  };


  /**
   * @name ng.$browser#defer.cancel
   * @methodOf ng.$browser.defer
   *
   * @description
   * Cancels a defered task identified with `deferId`.
   *
   * @param {*} deferId Token returned by the `$browser.defer` function.
   * @returns {boolean} Returns `true` if the task hasn't executed yet and was successfuly canceled.
   */
  self.defer.cancel = function(deferId) {
    if (pendingDeferIds[deferId]) {
      delete pendingDeferIds[deferId];
      clearTimeout(deferId);
      completeOutstandingRequest(noop);
      return true;
    }
    return false;
  };

}

function $BrowserProvider(){
  this.$get = ['$window', '$log', '$sniffer', '$document',
      function( $window,   $log,   $sniffer,   $document){
        return new Browser($window, $document, $log, $sniffer);
      }];
}

/**
 * @ngdoc object
 * @name ng.$cacheFactory
 *
 * @description
 * Factory that constructs cache objects.
 *
 *
 * @param {string} cacheId Name or id of the newly created cache.
 * @param {object=} options Options object that specifies the cache behavior. Properties:
 *
 *   - `{number=}` `capacity` — turns the cache into LRU cache.
 *
 * @returns {object} Newly created cache object with the following set of methods:
 *
 * - `{object}` `info()` — Returns id, size, and options of cache.
 * - `{void}` `put({string} key, {*} value)` — Puts a new key-value pair into the cache.
 * - `{{*}}` `get({string} key)` — Returns cached value for `key` or undefined for cache miss.
 * - `{void}` `remove({string} key)` — Removes a key-value pair from the cache.
 * - `{void}` `removeAll()` — Removes all cached values.
 * - `{void}` `destroy()` — Removes references to this cache from $cacheFactory.
 *
 */
function $CacheFactoryProvider() {

  this.$get = function() {
    var caches = {};

    function cacheFactory(cacheId, options) {
      if (cacheId in caches) {
        throw Error('cacheId ' + cacheId + ' taken');
      }

      var size = 0,
          stats = extend({}, options, {id: cacheId}),
          data = {},
          capacity = (options && options.capacity) || Number.MAX_VALUE,
          lruHash = {},
          freshEnd = null,
          staleEnd = null;

      return caches[cacheId] = {

        put: function(key, value) {
          var lruEntry = lruHash[key] || (lruHash[key] = {key: key});

          refresh(lruEntry);

          if (isUndefined(value)) return;
          if (!(key in data)) size++;
          data[key] = value;

          if (size > capacity) {
            this.remove(staleEnd.key);
          }
        },


        get: function(key) {
          var lruEntry = lruHash[key];

          if (!lruEntry) return;

          refresh(lruEntry);

          return data[key];
        },


        remove: function(key) {
          var lruEntry = lruHash[key];

          if (!lruEntry) return;

          if (lruEntry == freshEnd) freshEnd = lruEntry.p;
          if (lruEntry == staleEnd) staleEnd = lruEntry.n;
          link(lruEntry.n,lruEntry.p);

          delete lruHash[key];
          delete data[key];
          size--;
        },


        removeAll: function() {
          data = {};
          size = 0;
          lruHash = {};
          freshEnd = staleEnd = null;
        },


        destroy: function() {
          data = null;
          stats = null;
          lruHash = null;
          delete caches[cacheId];
        },


        info: function() {
          return extend({}, stats, {size: size});
        }
      };


      /**
       * makes the `entry` the freshEnd of the LRU linked list
       */
      function refresh(entry) {
        if (entry != freshEnd) {
          if (!staleEnd) {
            staleEnd = entry;
          } else if (staleEnd == entry) {
            staleEnd = entry.n;
          }

          link(entry.n, entry.p);
          link(entry, freshEnd);
          freshEnd = entry;
          freshEnd.n = null;
        }
      }


      /**
       * bidirectionally links two entries of the LRU linked list
       */
      function link(nextEntry, prevEntry) {
        if (nextEntry != prevEntry) {
          if (nextEntry) nextEntry.p = prevEntry; //p stands for previous, 'prev' didn't minify
          if (prevEntry) prevEntry.n = nextEntry; //n stands for next, 'next' didn't minify
        }
      }
    }


    cacheFactory.info = function() {
      var info = {};
      forEach(caches, function(cache, cacheId) {
        info[cacheId] = cache.info();
      });
      return info;
    };


    cacheFactory.get = function(cacheId) {
      return caches[cacheId];
    };


    return cacheFactory;
  };
}

/**
 * @ngdoc object
 * @name ng.$templateCache
 *
 * @description
 * Cache used for storing html templates.
 *
 * See {@link ng.$cacheFactory $cacheFactory}.
 *
 */
function $TemplateCacheProvider() {
  this.$get = ['$cacheFactory', function($cacheFactory) {
    return $cacheFactory('templates');
  }];
}

/* ! VARIABLE/FUNCTION NAMING CONVENTIONS THAT APPLY TO THIS FILE!
 *
 * DOM-related variables:
 *
 * - "node" - DOM Node
 * - "element" - DOM Element or Node
 * - "$node" or "$element" - jqLite-wrapped node or element
 *
 *
 * Compiler related stuff:
 *
 * - "linkFn" - linking fn of a single directive
 * - "nodeLinkFn" - function that aggregates all linking fns for a particular node
 * - "childLinkFn" -  function that aggregates all linking fns for child nodes of a particular node
 * - "compositeLinkFn" - function that aggregates all linking fns for a compilation root (nodeList)
 */


var NON_ASSIGNABLE_MODEL_EXPRESSION = 'Non-assignable model expression: ';


/**
 * @ngdoc function
 * @name ng.$compile
 * @function
 *
 * @description
 * Compiles a piece of HTML string or DOM into a template and produces a template function, which
 * can then be used to link {@link ng.$rootScope.Scope scope} and the template together.
 *
 * The compilation is a process of walking the DOM tree and trying to match DOM elements to
 * {@link ng.$compileProvider#directive directives}. For each match it
 * executes corresponding template function and collects the
 * instance functions into a single template function which is then returned.
 *
 * The template function can then be used once to produce the view or as it is the case with
 * {@link ng.directive:ngRepeat repeater} many-times, in which
 * case each call results in a view that is a DOM clone of the original template.
 *
 <doc:example module="compile">
   <doc:source>
    <script>
      // declare a new module, and inject the $compileProvider
      angular.module('compile', [], function($compileProvider) {
        // configure new 'compile' directive by passing a directive
        // factory function. The factory function injects the '$compile'
        $compileProvider.directive('compile', function($compile) {
          // directive factory creates a link function
          return function(scope, element, attrs) {
            scope.$watch(
              function(scope) {
                 // watch the 'compile' expression for changes
                return scope.$eval(attrs.compile);
              },
              function(value) {
                // when the 'compile' expression changes
                // assign it into the current DOM
                element.html(value);

                // compile the new DOM and link it to the current
                // scope.
                // NOTE: we only compile .childNodes so that
                // we don't get into infinite loop compiling ourselves
                $compile(element.contents())(scope);
              }
            );
          };
        })
      });

      function Ctrl($scope) {
        $scope.name = 'Angular';
        $scope.html = 'Hello {{name}}';
      }
    </script>
    <div ng-controller="Ctrl">
      <input ng-model="name"> <br>
      <textarea ng-model="html"></textarea> <br>
      <div compile="html"></div>
    </div>
   </doc:source>
   <doc:scenario>
     it('should auto compile', function() {
       expect(element('div[compile]').text()).toBe('Hello Angular');
       input('html').enter('{{name}}!');
       expect(element('div[compile]').text()).toBe('Angular!');
     });
   </doc:scenario>
 </doc:example>

 *
 *
 * @param {string|DOMElement} element Element or HTML string to compile into a template function.
 * @param {function(angular.Scope[, cloneAttachFn]} transclude function available to directives.
 * @param {number} maxPriority only apply directives lower then given priority (Only effects the
 *                 root element(s), not their children)
 * @returns {function(scope[, cloneAttachFn])} a link function which is used to bind template
 * (a DOM element/tree) to a scope. Where:
 *
 *  * `scope` - A {@link ng.$rootScope.Scope Scope} to bind to.
 *  * `cloneAttachFn` - If `cloneAttachFn` is provided, then the link function will clone the
 *               `template` and call the `cloneAttachFn` function allowing the caller to attach the
 *               cloned elements to the DOM document at the appropriate place. The `cloneAttachFn` is
 *               called as: <br> `cloneAttachFn(clonedElement, scope)` where:
 *
 *      * `clonedElement` - is a clone of the original `element` passed into the compiler.
 *      * `scope` - is the current scope with which the linking function is working with.
 *
 * Calling the linking function returns the element of the template. It is either the original element
 * passed in, or the clone of the element if the `cloneAttachFn` is provided.
 *
 * After linking the view is not updated until after a call to $digest which typically is done by
 * Angular automatically.
 *
 * If you need access to the bound view, there are two ways to do it:
 *
 * - If you are not asking the linking function to clone the template, create the DOM element(s)
 *   before you send them to the compiler and keep this reference around.
 *   <pre>
 *     var element = $compile('<p>{{total}}</p>')(scope);
 *   </pre>
 *
 * - if on the other hand, you need the element to be cloned, the view reference from the original
 *   example would not point to the clone, but rather to the original template that was cloned. In
 *   this case, you can access the clone via the cloneAttachFn:
 *   <pre>
 *     var templateHTML = angular.element('<p>{{total}}</p>'),
 *         scope = ....;
 *
 *     var clonedElement = $compile(templateHTML)(scope, function(clonedElement, scope) {
 *       //attach the clone to DOM document at the right place
 *     });
 *
 *     //now we have reference to the cloned DOM via `clone`
 *   </pre>
 *
 *
 * For information on how the compiler works, see the
 * {@link guide/compiler Angular HTML Compiler} section of the Developer Guide.
 */


/**
 * @ngdoc service
 * @name ng.$compileProvider
 * @function
 *
 * @description
 */
$CompileProvider.$inject = ['$provide'];
function $CompileProvider($provide) {
  var hasDirectives = {},
      Suffix = 'Directive',
      COMMENT_DIRECTIVE_REGEXP = /^\s*directive\:\s*([\d\w\-_]+)\s+(.*)$/,
      CLASS_DIRECTIVE_REGEXP = /(([\d\w\-_]+)(?:\:([^;]+))?;?)/,
      MULTI_ROOT_TEMPLATE_ERROR = 'Template must have exactly one root element. was: ',
      urlSanitizationWhitelist = /^\s*(https?|ftp|mailto|file):/;


  /**
   * @ngdoc function
   * @name ng.$compileProvider#directive
   * @methodOf ng.$compileProvider
   * @function
   *
   * @description
   * Register a new directives with the compiler.
   *
   * @param {string} name Name of the directive in camel-case. (ie <code>ngBind</code> which will match as
   *                <code>ng-bind</code>).
   * @param {function} directiveFactory An injectable directive factroy function. See {@link guide/directive} for more
   *                info.
   * @returns {ng.$compileProvider} Self for chaining.
   */
   this.directive = function registerDirective(name, directiveFactory) {
    if (isString(name)) {
      assertArg(directiveFactory, 'directive');
      if (!hasDirectives.hasOwnProperty(name)) {
        hasDirectives[name] = [];
        $provide.factory(name + Suffix, ['$injector', '$exceptionHandler',
          function($injector, $exceptionHandler) {
            var directives = [];
            forEach(hasDirectives[name], function(directiveFactory) {
              try {
                var directive = $injector.invoke(directiveFactory);
                if (isFunction(directive)) {
                  directive = { compile: valueFn(directive) };
                } else if (!directive.compile && directive.link) {
                  directive.compile = valueFn(directive.link);
                }
                directive.priority = directive.priority || 0;
                directive.name = directive.name || name;
                directive.require = directive.require || (directive.controller && directive.name);
                directive.restrict = directive.restrict || 'A';
                directives.push(directive);
              } catch (e) {
                $exceptionHandler(e);
              }
            });
            return directives;
          }]);
      }
      hasDirectives[name].push(directiveFactory);
    } else {
      forEach(name, reverseParams(registerDirective));
    }
    return this;
  };


  /**
   * @ngdoc function
   * @name ng.$compileProvider#urlSanitizationWhitelist
   * @methodOf ng.$compileProvider
   * @function
   *
   * @description
   * Retrieves or overrides the default regular expression that is used for whitelisting of safe
   * urls during a[href] sanitization.
   *
   * The sanitization is a security measure aimed at prevent XSS attacks via html links.
   *
   * Any url about to be assigned to a[href] via data-binding is first normalized and turned into an
   * absolute url. Afterwards the url is matched against the `urlSanitizationWhitelist` regular
   * expression. If a match is found the original url is written into the dom. Otherwise the
   * absolute url is prefixed with `'unsafe:'` string and only then it is written into the DOM.
   *
   * @param {RegExp=} regexp New regexp to whitelist urls with.
   * @returns {RegExp|ng.$compileProvider} Current RegExp if called without value or self for
   *    chaining otherwise.
   */
  this.urlSanitizationWhitelist = function(regexp) {
    if (isDefined(regexp)) {
      urlSanitizationWhitelist = regexp;
      return this;
    }
    return urlSanitizationWhitelist;
  };


  this.$get = [
            '$injector', '$interpolate', '$exceptionHandler', '$http', '$templateCache', '$parse',
            '$controller', '$rootScope', '$document',
    function($injector,   $interpolate,   $exceptionHandler,   $http,   $templateCache,   $parse,
             $controller,   $rootScope,   $document) {

    var Attributes = function(element, attr) {
      this.$$element = element;
      this.$attr = attr || {};
    };

    Attributes.prototype = {
      $normalize: directiveNormalize,


      /**
       * Set a normalized attribute on the element in a way such that all directives
       * can share the attribute. This function properly handles boolean attributes.
       * @param {string} key Normalized key. (ie ngAttribute)
       * @param {string|boolean} value The value to set. If `null` attribute will be deleted.
       * @param {boolean=} writeAttr If false, does not write the value to DOM element attribute.
       *     Defaults to true.
       * @param {string=} attrName Optional none normalized name. Defaults to key.
       */
      $set: function(key, value, writeAttr, attrName) {
        var booleanKey = getBooleanAttrName(this.$$element[0], key),
            $$observers = this.$$observers,
            normalizedVal;

        if (booleanKey) {
          this.$$element.prop(key, value);
          attrName = booleanKey;
        }

        this[key] = value;

        // translate normalized key to actual key
        if (attrName) {
          this.$attr[key] = attrName;
        } else {
          attrName = this.$attr[key];
          if (!attrName) {
            this.$attr[key] = attrName = snake_case(key, '-');
          }
        }


        // sanitize a[href] values
        if (nodeName_(this.$$element[0]) === 'A' && key === 'href') {
          urlSanitizationNode.setAttribute('href', value);

          // href property always returns normalized absolute url, so we can match against that
          normalizedVal = urlSanitizationNode.href;
          if (!normalizedVal.match(urlSanitizationWhitelist)) {
            this[key] = value = 'unsafe:' + normalizedVal;
          }
        }


        if (writeAttr !== false) {
          if (value === null || value === undefined) {
            this.$$element.removeAttr(attrName);
          } else {
            this.$$element.attr(attrName, value);
          }
        }

        // fire observers
        $$observers && forEach($$observers[key], function(fn) {
          try {
            fn(value);
          } catch (e) {
            $exceptionHandler(e);
          }
        });
      },


      /**
       * Observe an interpolated attribute.
       * The observer will never be called, if given attribute is not interpolated.
       *
       * @param {string} key Normalized key. (ie ngAttribute) .
       * @param {function(*)} fn Function that will be called whenever the attribute value changes.
       * @returns {function(*)} the `fn` Function passed in.
       */
      $observe: function(key, fn) {
        var attrs = this,
            $$observers = (attrs.$$observers || (attrs.$$observers = {})),
            listeners = ($$observers[key] || ($$observers[key] = []));

        listeners.push(fn);
        $rootScope.$evalAsync(function() {
          if (!listeners.$$inter) {
            // no one registered attribute interpolation function, so lets call it manually
            fn(attrs[key]);
          }
        });
        return fn;
      }
    };

    var urlSanitizationNode = $document[0].createElement('a'),
        startSymbol = $interpolate.startSymbol(),
        endSymbol = $interpolate.endSymbol(),
        denormalizeTemplate = (startSymbol == '{{' || endSymbol  == '}}')
            ? identity
            : function denormalizeTemplate(template) {
              return template.replace(/\{\{/g, startSymbol).replace(/}}/g, endSymbol);
            };


    return compile;

    //================================

    function compile($compileNodes, transcludeFn, maxPriority) {
      if (!($compileNodes instanceof jqLite)) {
        // jquery always rewraps, whereas we need to preserve the original selector so that we can modify it.
        $compileNodes = jqLite($compileNodes);
      }
      // We can not compile top level text elements since text nodes can be merged and we will
      // not be able to attach scope data to them, so we will wrap them in <span>
      forEach($compileNodes, function(node, index){
        if (node.nodeType == 3 /* text node */ && node.nodeValue.match(/\S+/) /* non-empty */ ) {
          $compileNodes[index] = jqLite(node).wrap('<span></span>').parent()[0];
        }
      });
      var compositeLinkFn = compileNodes($compileNodes, transcludeFn, $compileNodes, maxPriority);
      return function publicLinkFn(scope, cloneConnectFn){
        assertArg(scope, 'scope');
        // important!!: we must call our jqLite.clone() since the jQuery one is trying to be smart
        // and sometimes changes the structure of the DOM.
        var $linkNode = cloneConnectFn
          ? JQLitePrototype.clone.call($compileNodes) // IMPORTANT!!!
          : $compileNodes;

        // Attach scope only to non-text nodes.
        for(var i = 0, ii = $linkNode.length; i<ii; i++) {
          var node = $linkNode[i];
          if (node.nodeType == 1 /* element */ || node.nodeType == 9 /* document */) {
            $linkNode.eq(i).data('$scope', scope);
          }
        }
        safeAddClass($linkNode, 'ng-scope');
        if (cloneConnectFn) cloneConnectFn($linkNode, scope);
        if (compositeLinkFn) compositeLinkFn(scope, $linkNode, $linkNode);
        return $linkNode;
      };
    }

    function wrongMode(localName, mode) {
      throw Error("Unsupported '" + mode + "' for '" + localName + "'.");
    }

    function safeAddClass($element, className) {
      try {
        $element.addClass(className);
      } catch(e) {
        // ignore, since it means that we are trying to set class on
        // SVG element, where class name is read-only.
      }
    }

    /**
     * Compile function matches each node in nodeList against the directives. Once all directives
     * for a particular node are collected their compile functions are executed. The compile
     * functions return values - the linking functions - are combined into a composite linking
     * function, which is the a linking function for the node.
     *
     * @param {NodeList} nodeList an array of nodes or NodeList to compile
     * @param {function(angular.Scope[, cloneAttachFn]} transcludeFn A linking function, where the
     *        scope argument is auto-generated to the new child of the transcluded parent scope.
     * @param {DOMElement=} $rootElement If the nodeList is the root of the compilation tree then the
     *        rootElement must be set the jqLite collection of the compile root. This is
     *        needed so that the jqLite collection items can be replaced with widgets.
     * @param {number=} max directive priority
     * @returns {?function} A composite linking function of all of the matched directives or null.
     */
    function compileNodes(nodeList, transcludeFn, $rootElement, maxPriority) {
      var linkFns = [],
          nodeLinkFn, childLinkFn, directives, attrs, linkFnFound;

      for(var i = 0; i < nodeList.length; i++) {
        attrs = new Attributes();

        // we must always refer to nodeList[i] since the nodes can be replaced underneath us.
        directives = collectDirectives(nodeList[i], [], attrs, maxPriority);

        nodeLinkFn = (directives.length)
            ? applyDirectivesToNode(directives, nodeList[i], attrs, transcludeFn, $rootElement)
            : null;

        childLinkFn = (nodeLinkFn && nodeLinkFn.terminal || !nodeList[i].childNodes || !nodeList[i].childNodes.length)
            ? null
            : compileNodes(nodeList[i].childNodes,
                 nodeLinkFn ? nodeLinkFn.transclude : transcludeFn);

        linkFns.push(nodeLinkFn);
        linkFns.push(childLinkFn);
        linkFnFound = (linkFnFound || nodeLinkFn || childLinkFn);
      }

      // return a linking function if we have found anything, null otherwise
      return linkFnFound ? compositeLinkFn : null;

      function compositeLinkFn(scope, nodeList, $rootElement, boundTranscludeFn) {
        var nodeLinkFn, childLinkFn, node, childScope, childTranscludeFn, i, ii, n;

        // copy nodeList so that linking doesn't break due to live list updates.
        var stableNodeList = [];
        for (i = 0, ii = nodeList.length; i < ii; i++) {
          stableNodeList.push(nodeList[i]);
        }

        for(i = 0, n = 0, ii = linkFns.length; i < ii; n++) {
          node = stableNodeList[n];
          nodeLinkFn = linkFns[i++];
          childLinkFn = linkFns[i++];

          if (nodeLinkFn) {
            if (nodeLinkFn.scope) {
              childScope = scope.$new(isObject(nodeLinkFn.scope));
              jqLite(node).data('$scope', childScope);
            } else {
              childScope = scope;
            }
            childTranscludeFn = nodeLinkFn.transclude;
            if (childTranscludeFn || (!boundTranscludeFn && transcludeFn)) {
              nodeLinkFn(childLinkFn, childScope, node, $rootElement,
                  (function(transcludeFn) {
                    return function(cloneFn) {
                      var transcludeScope = scope.$new();
                      transcludeScope.$$transcluded = true;

                      return transcludeFn(transcludeScope, cloneFn).
                          bind('$destroy', bind(transcludeScope, transcludeScope.$destroy));
                    };
                  })(childTranscludeFn || transcludeFn)
              );
            } else {
              nodeLinkFn(childLinkFn, childScope, node, undefined, boundTranscludeFn);
            }
          } else if (childLinkFn) {
            childLinkFn(scope, node.childNodes, undefined, boundTranscludeFn);
          }
        }
      }
    }


    /**
     * Looks for directives on the given node and adds them to the directive collection which is
     * sorted.
     *
     * @param node Node to search.
     * @param directives An array to which the directives are added to. This array is sorted before
     *        the function returns.
     * @param attrs The shared attrs object which is used to populate the normalized attributes.
     * @param {number=} maxPriority Max directive priority.
     */
    function collectDirectives(node, directives, attrs, maxPriority) {
      var nodeType = node.nodeType,
          attrsMap = attrs.$attr,
          match,
          className;

      switch(nodeType) {
        case 1: /* Element */
          // use the node name: <directive>
          addDirective(directives,
              directiveNormalize(nodeName_(node).toLowerCase()), 'E', maxPriority);

          // iterate over the attributes
          for (var attr, name, nName, value, nAttrs = node.attributes,
                   j = 0, jj = nAttrs && nAttrs.length; j < jj; j++) {
            attr = nAttrs[j];
            if (attr.specified) {
              name = attr.name;
              nName = directiveNormalize(name.toLowerCase());
              attrsMap[nName] = name;
              attrs[nName] = value = trim((msie && name == 'href')
                ? decodeURIComponent(node.getAttribute(name, 2))
                : attr.value);
              if (getBooleanAttrName(node, nName)) {
                attrs[nName] = true; // presence means true
              }
              addAttrInterpolateDirective(node, directives, value, nName);
              addDirective(directives, nName, 'A', maxPriority);
            }
          }

          // use class as directive
          className = node.className;
          if (isString(className) && className !== '') {
            while (match = CLASS_DIRECTIVE_REGEXP.exec(className)) {
              nName = directiveNormalize(match[2]);
              if (addDirective(directives, nName, 'C', maxPriority)) {
                attrs[nName] = trim(match[3]);
              }
              className = className.substr(match.index + match[0].length);
            }
          }
          break;
        case 3: /* Text Node */
          addTextInterpolateDirective(directives, node.nodeValue);
          break;
        case 8: /* Comment */
          try {
            match = COMMENT_DIRECTIVE_REGEXP.exec(node.nodeValue);
            if (match) {
              nName = directiveNormalize(match[1]);
              if (addDirective(directives, nName, 'M', maxPriority)) {
                attrs[nName] = trim(match[2]);
              }
            }
          } catch (e) {
            // turns out that under some circumstances IE9 throws errors when one attempts to read comment's node value.
            // Just ignore it and continue. (Can't seem to reproduce in test case.)
          }
          break;
      }

      directives.sort(byPriority);
      return directives;
    }


    /**
     * Once the directives have been collected, their compile functions are executed. This method
     * is responsible for inlining directive templates as well as terminating the application
     * of the directives if the terminal directive has been reached.
     *
     * @param {Array} directives Array of collected directives to execute their compile function.
     *        this needs to be pre-sorted by priority order.
     * @param {Node} compileNode The raw DOM node to apply the compile functions to
     * @param {Object} templateAttrs The shared attribute function
     * @param {function(angular.Scope[, cloneAttachFn]} transcludeFn A linking function, where the
     *        scope argument is auto-generated to the new child of the transcluded parent scope.
     * @param {JQLite} jqCollection If we are working on the root of the compile tree then this
     *        argument has the root jqLite array so that we can replace nodes on it.
     * @returns linkFn
     */
    function applyDirectivesToNode(directives, compileNode, templateAttrs, transcludeFn, jqCollection) {
      var terminalPriority = -Number.MAX_VALUE,
          preLinkFns = [],
          postLinkFns = [],
          newScopeDirective = null,
          newIsolateScopeDirective = null,
          templateDirective = null,
          $compileNode = templateAttrs.$$element = jqLite(compileNode),
          directive,
          directiveName,
          $template,
          transcludeDirective,
          childTranscludeFn = transcludeFn,
          controllerDirectives,
          linkFn,
          directiveValue;

      // executes all directives on the current element
      for(var i = 0, ii = directives.length; i < ii; i++) {
        directive = directives[i];
        $template = undefined;

        if (terminalPriority > directive.priority) {
          break; // prevent further processing of directives
        }

        if (directiveValue = directive.scope) {
          assertNoDuplicate('isolated scope', newIsolateScopeDirective, directive, $compileNode);
          if (isObject(directiveValue)) {
            safeAddClass($compileNode, 'ng-isolate-scope');
            newIsolateScopeDirective = directive;
          }
          safeAddClass($compileNode, 'ng-scope');
          newScopeDirective = newScopeDirective || directive;
        }

        directiveName = directive.name;

        if (directiveValue = directive.controller) {
          controllerDirectives = controllerDirectives || {};
          assertNoDuplicate("'" + directiveName + "' controller",
              controllerDirectives[directiveName], directive, $compileNode);
          controllerDirectives[directiveName] = directive;
        }

        if (directiveValue = directive.transclude) {
          assertNoDuplicate('transclusion', transcludeDirective, directive, $compileNode);
          transcludeDirective = directive;
          terminalPriority = directive.priority;
          if (directiveValue == 'element') {
            $template = jqLite(compileNode);
            $compileNode = templateAttrs.$$element =
                jqLite(document.createComment(' ' + directiveName + ': ' + templateAttrs[directiveName] + ' '));
            compileNode = $compileNode[0];
            replaceWith(jqCollection, jqLite($template[0]), compileNode);
            childTranscludeFn = compile($template, transcludeFn, terminalPriority);
          } else {
            $template = jqLite(JQLiteClone(compileNode)).contents();
            $compileNode.html(''); // clear contents
            childTranscludeFn = compile($template, transcludeFn);
          }
        }

        if ((directiveValue = directive.template)) {
          assertNoDuplicate('template', templateDirective, directive, $compileNode);
          templateDirective = directive;
          directiveValue = denormalizeTemplate(directiveValue);

          if (directive.replace) {
            $template = jqLite('<div>' +
                                 trim(directiveValue) +
                               '</div>').contents();
            compileNode = $template[0];

            if ($template.length != 1 || compileNode.nodeType !== 1) {
              throw new Error(MULTI_ROOT_TEMPLATE_ERROR + directiveValue);
            }

            replaceWith(jqCollection, $compileNode, compileNode);

            var newTemplateAttrs = {$attr: {}};

            // combine directives from the original node and from the template:
            // - take the array of directives for this element
            // - split it into two parts, those that were already applied and those that weren't
            // - collect directives from the template, add them to the second group and sort them
            // - append the second group with new directives to the first group
            directives = directives.concat(
                collectDirectives(
                    compileNode,
                    directives.splice(i + 1, directives.length - (i + 1)),
                    newTemplateAttrs
                )
            );
            mergeTemplateAttributes(templateAttrs, newTemplateAttrs);

            ii = directives.length;
          } else {
            $compileNode.html(directiveValue);
          }
        }

        if (directive.templateUrl) {
          assertNoDuplicate('template', templateDirective, directive, $compileNode);
          templateDirective = directive;
          nodeLinkFn = compileTemplateUrl(directives.splice(i, directives.length - i),
              nodeLinkFn, $compileNode, templateAttrs, jqCollection, directive.replace,
              childTranscludeFn);
          ii = directives.length;
        } else if (directive.compile) {
          try {
            linkFn = directive.compile($compileNode, templateAttrs, childTranscludeFn);
            if (isFunction(linkFn)) {
              addLinkFns(null, linkFn);
            } else if (linkFn) {
              addLinkFns(linkFn.pre, linkFn.post);
            }
          } catch (e) {
            $exceptionHandler(e, startingTag($compileNode));
          }
        }

        if (directive.terminal) {
          nodeLinkFn.terminal = true;
          terminalPriority = Math.max(terminalPriority, directive.priority);
        }

      }

      nodeLinkFn.scope = newScopeDirective && newScopeDirective.scope;
      nodeLinkFn.transclude = transcludeDirective && childTranscludeFn;

      // might be normal or delayed nodeLinkFn depending on if templateUrl is present
      return nodeLinkFn;

      ////////////////////

      function addLinkFns(pre, post) {
        if (pre) {
          pre.require = directive.require;
          preLinkFns.push(pre);
        }
        if (post) {
          post.require = directive.require;
          postLinkFns.push(post);
        }
      }


      function getControllers(require, $element) {
        var value, retrievalMethod = 'data', optional = false;
        if (isString(require)) {
          while((value = require.charAt(0)) == '^' || value == '?') {
            require = require.substr(1);
            if (value == '^') {
              retrievalMethod = 'inheritedData';
            }
            optional = optional || value == '?';
          }
          value = $element[retrievalMethod]('$' + require + 'Controller');
          if (!value && !optional) {
            throw Error("No controller: " + require);
          }
          return value;
        } else if (isArray(require)) {
          value = [];
          forEach(require, function(require) {
            value.push(getControllers(require, $element));
          });
        }
        return value;
      }


      function nodeLinkFn(childLinkFn, scope, linkNode, $rootElement, boundTranscludeFn) {
        var attrs, $element, i, ii, linkFn, controller;

        if (compileNode === linkNode) {
          attrs = templateAttrs;
        } else {
          attrs = shallowCopy(templateAttrs, new Attributes(jqLite(linkNode), templateAttrs.$attr));
        }
        $element = attrs.$$element;

        if (newIsolateScopeDirective) {
          var LOCAL_REGEXP = /^\s*([@=&])\s*(\w*)\s*$/;

          var parentScope = scope.$parent || scope;

          forEach(newIsolateScopeDirective.scope, function(definiton, scopeName) {
            var match = definiton.match(LOCAL_REGEXP) || [],
                attrName = match[2]|| scopeName,
                mode = match[1], // @, =, or &
                lastValue,
                parentGet, parentSet;

            scope.$$isolateBindings[scopeName] = mode + attrName;

            switch (mode) {

              case '@': {
                attrs.$observe(attrName, function(value) {
                  scope[scopeName] = value;
                });
                attrs.$$observers[attrName].$$scope = parentScope;
                break;
              }

              case '=': {
                parentGet = $parse(attrs[attrName]);
                parentSet = parentGet.assign || function() {
                  // reset the change, or we will throw this exception on every $digest
                  lastValue = scope[scopeName] = parentGet(parentScope);
                  throw Error(NON_ASSIGNABLE_MODEL_EXPRESSION + attrs[attrName] +
                      ' (directive: ' + newIsolateScopeDirective.name + ')');
                };
                lastValue = scope[scopeName] = parentGet(parentScope);
                scope.$watch(function parentValueWatch() {
                  var parentValue = parentGet(parentScope);

                  if (parentValue !== scope[scopeName]) {
                    // we are out of sync and need to copy
                    if (parentValue !== lastValue) {
                      // parent changed and it has precedence
                      lastValue = scope[scopeName] = parentValue;
                    } else {
                      // if the parent can be assigned then do so
                      parentSet(parentScope, parentValue = lastValue = scope[scopeName]);
                    }
                  }
                  return parentValue;
                });
                break;
              }

              case '&': {
                parentGet = $parse(attrs[attrName]);
                scope[scopeName] = function(locals) {
                  return parentGet(parentScope, locals);
                };
                break;
              }

              default: {
                throw Error('Invalid isolate scope definition for directive ' +
                    newIsolateScopeDirective.name + ': ' + definiton);
              }
            }
          });
        }

        if (controllerDirectives) {
          forEach(controllerDirectives, function(directive) {
            var locals = {
              $scope: scope,
              $element: $element,
              $attrs: attrs,
              $transclude: boundTranscludeFn
            };

            controller = directive.controller;
            if (controller == '@') {
              controller = attrs[directive.name];
            }

            $element.data(
                '$' + directive.name + 'Controller',
                $controller(controller, locals));
          });
        }

        // PRELINKING
        for(i = 0, ii = preLinkFns.length; i < ii; i++) {
          try {
            linkFn = preLinkFns[i];
            linkFn(scope, $element, attrs,
                linkFn.require && getControllers(linkFn.require, $element));
          } catch (e) {
            $exceptionHandler(e, startingTag($element));
          }
        }

        // RECURSION
        childLinkFn && childLinkFn(scope, linkNode.childNodes, undefined, boundTranscludeFn);

        // POSTLINKING
        for(i = 0, ii = postLinkFns.length; i < ii; i++) {
          try {
            linkFn = postLinkFns[i];
            linkFn(scope, $element, attrs,
                linkFn.require && getControllers(linkFn.require, $element));
          } catch (e) {
            $exceptionHandler(e, startingTag($element));
          }
        }
      }
    }


    /**
     * looks up the directive and decorates it with exception handling and proper parameters. We
     * call this the boundDirective.
     *
     * @param {string} name name of the directive to look up.
     * @param {string} location The directive must be found in specific format.
     *   String containing any of theses characters:
     *
     *   * `E`: element name
     *   * `A': attribute
     *   * `C`: class
     *   * `M`: comment
     * @returns true if directive was added.
     */
    function addDirective(tDirectives, name, location, maxPriority) {
      var match = false;
      if (hasDirectives.hasOwnProperty(name)) {
        for(var directive, directives = $injector.get(name + Suffix),
            i = 0, ii = directives.length; i<ii; i++) {
          try {
            directive = directives[i];
            if ( (maxPriority === undefined || maxPriority > directive.priority) &&
                 directive.restrict.indexOf(location) != -1) {
              tDirectives.push(directive);
              match = true;
            }
          } catch(e) { $exceptionHandler(e); }
        }
      }
      return match;
    }


    /**
     * When the element is replaced with HTML template then the new attributes
     * on the template need to be merged with the existing attributes in the DOM.
     * The desired effect is to have both of the attributes present.
     *
     * @param {object} dst destination attributes (original DOM)
     * @param {object} src source attributes (from the directive template)
     */
    function mergeTemplateAttributes(dst, src) {
      var srcAttr = src.$attr,
          dstAttr = dst.$attr,
          $element = dst.$$element;

      // reapply the old attributes to the new element
      forEach(dst, function(value, key) {
        if (key.charAt(0) != '$') {
          if (src[key]) {
            value += (key === 'style' ? ';' : ' ') + src[key];
          }
          dst.$set(key, value, true, srcAttr[key]);
        }
      });

      // copy the new attributes on the old attrs object
      forEach(src, function(value, key) {
        if (key == 'class') {
          safeAddClass($element, value);
          dst['class'] = (dst['class'] ? dst['class'] + ' ' : '') + value;
        } else if (key == 'style') {
          $element.attr('style', $element.attr('style') + ';' + value);
        } else if (key.charAt(0) != '$' && !dst.hasOwnProperty(key)) {
          dst[key] = value;
          dstAttr[key] = srcAttr[key];
        }
      });
    }


    function compileTemplateUrl(directives, beforeTemplateNodeLinkFn, $compileNode, tAttrs,
        $rootElement, replace, childTranscludeFn) {
      var linkQueue = [],
          afterTemplateNodeLinkFn,
          afterTemplateChildLinkFn,
          beforeTemplateCompileNode = $compileNode[0],
          origAsyncDirective = directives.shift(),
          // The fact that we have to copy and patch the directive seems wrong!
          derivedSyncDirective = extend({}, origAsyncDirective, {
            controller: null, templateUrl: null, transclude: null, scope: null
          });

      $compileNode.html('');

      $http.get(origAsyncDirective.templateUrl, {cache: $templateCache}).
        success(function(content) {
          var compileNode, tempTemplateAttrs, $template;

          content = denormalizeTemplate(content);

          if (replace) {
            $template = jqLite('<div>' + trim(content) + '</div>').contents();
            compileNode = $template[0];

            if ($template.length != 1 || compileNode.nodeType !== 1) {
              throw new Error(MULTI_ROOT_TEMPLATE_ERROR + content);
            }

            tempTemplateAttrs = {$attr: {}};
            replaceWith($rootElement, $compileNode, compileNode);
            collectDirectives(compileNode, directives, tempTemplateAttrs);
            mergeTemplateAttributes(tAttrs, tempTemplateAttrs);
          } else {
            compileNode = beforeTemplateCompileNode;
            $compileNode.html(content);
          }

          directives.unshift(derivedSyncDirective);
          afterTemplateNodeLinkFn = applyDirectivesToNode(directives, compileNode, tAttrs, childTranscludeFn);
          afterTemplateChildLinkFn = compileNodes($compileNode[0].childNodes, childTranscludeFn);


          while(linkQueue.length) {
            var controller = linkQueue.pop(),
                linkRootElement = linkQueue.pop(),
                beforeTemplateLinkNode = linkQueue.pop(),
                scope = linkQueue.pop(),
                linkNode = compileNode;

            if (beforeTemplateLinkNode !== beforeTemplateCompileNode) {
              // it was cloned therefore we have to clone as well.
              linkNode = JQLiteClone(compileNode);
              replaceWith(linkRootElement, jqLite(beforeTemplateLinkNode), linkNode);
            }

            afterTemplateNodeLinkFn(function() {
              beforeTemplateNodeLinkFn(afterTemplateChildLinkFn, scope, linkNode, $rootElement, controller);
            }, scope, linkNode, $rootElement, controller);
          }
          linkQueue = null;
        }).
        error(function(response, code, headers, config) {
          throw Error('Failed to load template: ' + config.url);
        });

      return function delayedNodeLinkFn(ignoreChildLinkFn, scope, node, rootElement, controller) {
        if (linkQueue) {
          linkQueue.push(scope);
          linkQueue.push(node);
          linkQueue.push(rootElement);
          linkQueue.push(controller);
        } else {
          afterTemplateNodeLinkFn(function() {
            beforeTemplateNodeLinkFn(afterTemplateChildLinkFn, scope, node, rootElement, controller);
          }, scope, node, rootElement, controller);
        }
      };
    }


    /**
     * Sorting function for bound directives.
     */
    function byPriority(a, b) {
      return b.priority - a.priority;
    }


    function assertNoDuplicate(what, previousDirective, directive, element) {
      if (previousDirective) {
        throw Error('Multiple directives [' + previousDirective.name + ', ' +
          directive.name + '] asking for ' + what + ' on: ' +  startingTag(element));
      }
    }


    function addTextInterpolateDirective(directives, text) {
      var interpolateFn = $interpolate(text, true);
      if (interpolateFn) {
        directives.push({
          priority: 0,
          compile: valueFn(function textInterpolateLinkFn(scope, node) {
            var parent = node.parent(),
                bindings = parent.data('$binding') || [];
            bindings.push(interpolateFn);
            safeAddClass(parent.data('$binding', bindings), 'ng-binding');
            scope.$watch(interpolateFn, function interpolateFnWatchAction(value) {
              node[0].nodeValue = value;
            });
          })
        });
      }
    }


    function addAttrInterpolateDirective(node, directives, value, name) {
      var interpolateFn = $interpolate(value, true);

      // no interpolation found -> ignore
      if (!interpolateFn) return;


      directives.push({
        priority: 100,
        compile: valueFn(function attrInterpolateLinkFn(scope, element, attr) {
          var $$observers = (attr.$$observers || (attr.$$observers = {}));

          if (name === 'class') {
            // we need to interpolate classes again, in the case the element was replaced
            // and therefore the two class attrs got merged - we want to interpolate the result
            interpolateFn = $interpolate(attr[name], true);
          }

          attr[name] = undefined;
          ($$observers[name] || ($$observers[name] = [])).$$inter = true;
          (attr.$$observers && attr.$$observers[name].$$scope || scope).
            $watch(interpolateFn, function interpolateFnWatchAction(value) {
              attr.$set(name, value);
            });
        })
      });
    }


    /**
     * This is a special jqLite.replaceWith, which can replace items which
     * have no parents, provided that the containing jqLite collection is provided.
     *
     * @param {JqLite=} $rootElement The root of the compile tree. Used so that we can replace nodes
     *    in the root of the tree.
     * @param {JqLite} $element The jqLite element which we are going to replace. We keep the shell,
     *    but replace its DOM node reference.
     * @param {Node} newNode The new DOM node.
     */
    function replaceWith($rootElement, $element, newNode) {
      var oldNode = $element[0],
          parent = oldNode.parentNode,
          i, ii;

      if ($rootElement) {
        for(i = 0, ii = $rootElement.length; i < ii; i++) {
          if ($rootElement[i] == oldNode) {
            $rootElement[i] = newNode;
            break;
          }
        }
      }

      if (parent) {
        parent.replaceChild(newNode, oldNode);
      }

      newNode[jqLite.expando] = oldNode[jqLite.expando];
      $element[0] = newNode;
    }
  }];
}

var PREFIX_REGEXP = /^(x[\:\-_]|data[\:\-_])/i;
/**
 * Converts all accepted directives format into proper directive name.
 * All of these will become 'myDirective':
 *   my:DiRective
 *   my-directive
 *   x-my-directive
 *   data-my:directive
 *
 * Also there is special case for Moz prefix starting with upper case letter.
 * @param name Name to normalize
 */
function directiveNormalize(name) {
  return camelCase(name.replace(PREFIX_REGEXP, ''));
}

/**
 * @ngdoc object
 * @name ng.$compile.directive.Attributes
 * @description
 *
 * A shared object between directive compile / linking functions which contains normalized DOM element
 * attributes. The the values reflect current binding state `{{ }}`. The normalization is needed
 * since all of these are treated as equivalent in Angular:
 *
 *          <span ng:bind="a" ng-bind="a" data-ng-bind="a" x-ng-bind="a">
 */

/**
 * @ngdoc property
 * @name ng.$compile.directive.Attributes#$attr
 * @propertyOf ng.$compile.directive.Attributes
 * @returns {object} A map of DOM element attribute names to the normalized name. This is
 *          needed to do reverse lookup from normalized name back to actual name.
 */


/**
 * @ngdoc function
 * @name ng.$compile.directive.Attributes#$set
 * @methodOf ng.$compile.directive.Attributes
 * @function
 *
 * @description
 * Set DOM element attribute value.
 *
 *
 * @param {string} name Normalized element attribute name of the property to modify. The name is
 *          revers translated using the {@link ng.$compile.directive.Attributes#$attr $attr}
 *          property to the original name.
 * @param {string} value Value to set the attribute to.
 */



/**
 * Closure compiler type information
 */

function nodesetLinkingFn(
  /* angular.Scope */ scope,
  /* NodeList */ nodeList,
  /* Element */ rootElement,
  /* function(Function) */ boundTranscludeFn
){}

function directiveLinkingFn(
  /* nodesetLinkingFn */ nodesetLinkingFn,
  /* angular.Scope */ scope,
  /* Node */ node,
  /* Element */ rootElement,
  /* function(Function) */ boundTranscludeFn
){}

/**
 * @ngdoc object
 * @name ng.$controllerProvider
 * @description
 * The {@link ng.$controller $controller service} is used by Angular to create new
 * controllers.
 *
 * This provider allows controller registration via the
 * {@link ng.$controllerProvider#register register} method.
 */
function $ControllerProvider() {
  var controllers = {};


  /**
   * @ngdoc function
   * @name ng.$controllerProvider#register
   * @methodOf ng.$controllerProvider
   * @param {string} name Controller name
   * @param {Function|Array} constructor Controller constructor fn (optionally decorated with DI
   *    annotations in the array notation).
   */
  this.register = function(name, constructor) {
    if (isObject(name)) {
      extend(controllers, name)
    } else {
      controllers[name] = constructor;
    }
  };


  this.$get = ['$injector', '$window', function($injector, $window) {

    /**
     * @ngdoc function
     * @name ng.$controller
     * @requires $injector
     *
     * @param {Function|string} constructor If called with a function then it's considered to be the
     *    controller constructor function. Otherwise it's considered to be a string which is used
     *    to retrieve the controller constructor using the following steps:
     *
     *    * check if a controller with given name is registered via `$controllerProvider`
     *    * check if evaluating the string on the current scope returns a constructor
     *    * check `window[constructor]` on the global `window` object
     *
     * @param {Object} locals Injection locals for Controller.
     * @return {Object} Instance of given controller.
     *
     * @description
     * `$controller` service is responsible for instantiating controllers.
     *
     * It's just a simple call to {@link AUTO.$injector $injector}, but extracted into
     * a service, so that one can override this service with {@link https://gist.github.com/1649788
     * BC version}.
     */
    return function(constructor, locals) {
      if(isString(constructor)) {
        var name = constructor;
        constructor = controllers.hasOwnProperty(name)
            ? controllers[name]
            : getter(locals.$scope, name, true) || getter($window, name, true);

        assertArgFn(constructor, name, true);
      }

      return $injector.instantiate(constructor, locals);
    };
  }];
}

/**
 * @ngdoc object
 * @name ng.$document
 * @requires $window
 *
 * @description
 * A {@link angular.element jQuery (lite)}-wrapped reference to the browser's `window.document`
 * element.
 */
function $DocumentProvider(){
  this.$get = ['$window', function(window){
    return jqLite(window.document);
  }];
}

/**
 * @ngdoc function
 * @name ng.$exceptionHandler
 * @requires $log
 *
 * @description
 * Any uncaught exception in angular expressions is delegated to this service.
 * The default implementation simply delegates to `$log.error` which logs it into
 * the browser console.
 *
 * In unit tests, if `angular-mocks.js` is loaded, this service is overridden by
 * {@link ngMock.$exceptionHandler mock $exceptionHandler} which aids in testing.
 *
 * @param {Error} exception Exception associated with the error.
 * @param {string=} cause optional information about the context in which
 *       the error was thrown.
 *
 */
function $ExceptionHandlerProvider() {
  this.$get = ['$log', function($log) {
    return function(exception, cause) {
      $log.error.apply($log, arguments);
    };
  }];
}

/**
 * @ngdoc object
 * @name ng.$interpolateProvider
 * @function
 *
 * @description
 *
 * Used for configuring the interpolation markup. Defaults to `{{` and `}}`.
 */
function $InterpolateProvider() {
  var startSymbol = '{{';
  var endSymbol = '}}';

  /**
   * @ngdoc method
   * @name ng.$interpolateProvider#startSymbol
   * @methodOf ng.$interpolateProvider
   * @description
   * Symbol to denote start of expression in the interpolated string. Defaults to `{{`.
   *
   * @param {string=} value new value to set the starting symbol to.
   * @returns {string|self} Returns the symbol when used as getter and self if used as setter.
   */
  this.startSymbol = function(value){
    if (value) {
      startSymbol = value;
      return this;
    } else {
      return startSymbol;
    }
  };

  /**
   * @ngdoc method
   * @name ng.$interpolateProvider#endSymbol
   * @methodOf ng.$interpolateProvider
   * @description
   * Symbol to denote the end of expression in the interpolated string. Defaults to `}}`.
   *
   * @param {string=} value new value to set the ending symbol to.
   * @returns {string|self} Returns the symbol when used as getter and self if used as setter.
   */
  this.endSymbol = function(value){
    if (value) {
      endSymbol = value;
      return this;
    } else {
      return endSymbol;
    }
  };


  this.$get = ['$parse', function($parse) {
    var startSymbolLength = startSymbol.length,
        endSymbolLength = endSymbol.length;

    /**
     * @ngdoc function
     * @name ng.$interpolate
     * @function
     *
     * @requires $parse
     *
     * @description
     *
     * Compiles a string with markup into an interpolation function. This service is used by the
     * HTML {@link ng.$compile $compile} service for data binding. See
     * {@link ng.$interpolateProvider $interpolateProvider} for configuring the
     * interpolation markup.
     *
     *
       <pre>
         var $interpolate = ...; // injected
         var exp = $interpolate('Hello {{name}}!');
         expect(exp({name:'Angular'}).toEqual('Hello Angular!');
       </pre>
     *
     *
     * @param {string} text The text with markup to interpolate.
     * @param {boolean=} mustHaveExpression if set to true then the interpolation string must have
     *    embedded expression in order to return an interpolation function. Strings with no
     *    embedded expression will return null for the interpolation function.
     * @returns {function(context)} an interpolation function which is used to compute the interpolated
     *    string. The function has these parameters:
     *
     *    * `context`: an object against which any expressions embedded in the strings are evaluated
     *      against.
     *
     */
    function $interpolate(text, mustHaveExpression) {
      var startIndex,
          endIndex,
          index = 0,
          parts = [],
          length = text.length,
          hasInterpolation = false,
          fn,
          exp,
          concat = [];

      while(index < length) {
        if ( ((startIndex = text.indexOf(startSymbol, index)) != -1) &&
             ((endIndex = text.indexOf(endSymbol, startIndex + startSymbolLength)) != -1) ) {
          (index != startIndex) && parts.push(text.substring(index, startIndex));
          parts.push(fn = $parse(exp = text.substring(startIndex + startSymbolLength, endIndex)));
          fn.exp = exp;
          index = endIndex + endSymbolLength;
          hasInterpolation = true;
        } else {
          // we did not find anything, so we have to add the remainder to the parts array
          (index != length) && parts.push(text.substring(index));
          index = length;
        }
      }

      if (!(length = parts.length)) {
        // we added, nothing, must have been an empty string.
        parts.push('');
        length = 1;
      }

      if (!mustHaveExpression  || hasInterpolation) {
        concat.length = length;
        fn = function(context) {
          for(var i = 0, ii = length, part; i<ii; i++) {
            if (typeof (part = parts[i]) == 'function') {
              part = part(context);
              if (part == null || part == undefined) {
                part = '';
              } else if (typeof part != 'string') {
                part = toJson(part);
              }
            }
            concat[i] = part;
          }
          return concat.join('');
        };
        fn.exp = text;
        fn.parts = parts;
        return fn;
      }
    }


    /**
     * @ngdoc method
     * @name ng.$interpolate#startSymbol
     * @methodOf ng.$interpolate
     * @description
     * Symbol to denote the start of expression in the interpolated string. Defaults to `{{`.
     *
     * Use {@link ng.$interpolateProvider#startSymbol $interpolateProvider#startSymbol} to change
     * the symbol.
     *
     * @returns {string} start symbol.
     */
    $interpolate.startSymbol = function() {
      return startSymbol;
    }


    /**
     * @ngdoc method
     * @name ng.$interpolate#endSymbol
     * @methodOf ng.$interpolate
     * @description
     * Symbol to denote the end of expression in the interpolated string. Defaults to `}}`.
     *
     * Use {@link ng.$interpolateProvider#endSymbol $interpolateProvider#endSymbol} to change
     * the symbol.
     *
     * @returns {string} start symbol.
     */
    $interpolate.endSymbol = function() {
      return endSymbol;
    }

    return $interpolate;
  }];
}

var URL_MATCH = /^([^:]+):\/\/(\w+:{0,1}\w*@)?(\{?[\w\.-]*\}?)(:([0-9]+))?(\/[^\?#]*)?(\?([^#]*))?(#(.*))?$/,
    PATH_MATCH = /^([^\?#]*)?(\?([^#]*))?(#(.*))?$/,
    HASH_MATCH = PATH_MATCH,
    DEFAULT_PORTS = {'http': 80, 'https': 443, 'ftp': 21};


/**
 * Encode path using encodeUriSegment, ignoring forward slashes
 *
 * @param {string} path Path to encode
 * @returns {string}
 */
function encodePath(path) {
  var segments = path.split('/'),
      i = segments.length;

  while (i--) {
    segments[i] = encodeUriSegment(segments[i]);
  }

  return segments.join('/');
}

function stripHash(url) {
  return url.split('#')[0];
}


function matchUrl(url, obj) {
  var match = URL_MATCH.exec(url);

  match = {
      protocol: match[1],
      host: match[3],
      port: int(match[5]) || DEFAULT_PORTS[match[1]] || null,
      path: match[6] || '/',
      search: match[8],
      hash: match[10]
    };

  if (obj) {
    obj.$$protocol = match.protocol;
    obj.$$host = match.host;
    obj.$$port = match.port;
  }

  return match;
}


function composeProtocolHostPort(protocol, host, port) {
  return protocol + '://' + host + (port == DEFAULT_PORTS[protocol] ? '' : ':' + port);
}


function pathPrefixFromBase(basePath) {
  return basePath.substr(0, basePath.lastIndexOf('/'));
}


function convertToHtml5Url(url, basePath, hashPrefix) {
  var match = matchUrl(url);

  // already html5 url
  if (decodeURIComponent(match.path) != basePath || isUndefined(match.hash) ||
      match.hash.indexOf(hashPrefix) !== 0) {
    return url;
  // convert hashbang url -> html5 url
  } else {
    return composeProtocolHostPort(match.protocol, match.host, match.port) +
           pathPrefixFromBase(basePath) + match.hash.substr(hashPrefix.length);
  }
}


function convertToHashbangUrl(url, basePath, hashPrefix) {
  var match = matchUrl(url);

  // already hashbang url
  if (decodeURIComponent(match.path) == basePath && !isUndefined(match.hash) &&
      match.hash.indexOf(hashPrefix) === 0) {
    return url;
  // convert html5 url -> hashbang url
  } else {
    var search = match.search && '?' + match.search || '',
        hash = match.hash && '#' + match.hash || '',
        pathPrefix = pathPrefixFromBase(basePath),
        path = match.path.substr(pathPrefix.length);

    if (match.path.indexOf(pathPrefix) !== 0) {
      throw Error('Invalid url "' + url + '", missing path prefix "' + pathPrefix + '" !');
    }

    return composeProtocolHostPort(match.protocol, match.host, match.port) + basePath +
           '#' + hashPrefix + path + search + hash;
  }
}


/**
 * LocationUrl represents an url
 * This object is exposed as $location service when HTML5 mode is enabled and supported
 *
 * @constructor
 * @param {string} url HTML5 url
 * @param {string} pathPrefix
 */
function LocationUrl(url, pathPrefix, appBaseUrl) {
  pathPrefix = pathPrefix || '';

  /**
   * Parse given html5 (regular) url string into properties
   * @param {string} newAbsoluteUrl HTML5 url
   * @private
   */
  this.$$parse = function(newAbsoluteUrl) {
    var match = matchUrl(newAbsoluteUrl, this);

    if (match.path.indexOf(pathPrefix) !== 0) {
      throw Error('Invalid url "' + newAbsoluteUrl + '", missing path prefix "' + pathPrefix + '" !');
    }

    this.$$path = decodeURIComponent(match.path.substr(pathPrefix.length));
    this.$$search = parseKeyValue(match.search);
    this.$$hash = match.hash && decodeURIComponent(match.hash) || '';

    this.$$compose();
  };

  /**
   * Compose url and update `absUrl` property
   * @private
   */
  this.$$compose = function() {
    var search = toKeyValue(this.$$search),
        hash = this.$$hash ? '#' + encodeUriSegment(this.$$hash) : '';

    this.$$url = encodePath(this.$$path) + (search ? '?' + search : '') + hash;
    this.$$absUrl = composeProtocolHostPort(this.$$protocol, this.$$host, this.$$port) +
                    pathPrefix + this.$$url;
  };


  this.$$rewriteAppUrl = function(absoluteLinkUrl) {
    if(absoluteLinkUrl.indexOf(appBaseUrl) == 0) {
      return absoluteLinkUrl;
    }
  }


  this.$$parse(url);
}


/**
 * LocationHashbangUrl represents url
 * This object is exposed as $location service when html5 history api is disabled or not supported
 *
 * @constructor
 * @param {string} url Legacy url
 * @param {string} hashPrefix Prefix for hash part (containing path and search)
 */
function LocationHashbangUrl(url, hashPrefix, appBaseUrl) {
  var basePath;

  /**
   * Parse given hashbang url into properties
   * @param {string} url Hashbang url
   * @private
   */
  this.$$parse = function(url) {
    var match = matchUrl(url, this);


    if (match.hash && match.hash.indexOf(hashPrefix) !== 0) {
      throw Error('Invalid url "' + url + '", missing hash prefix "' + hashPrefix + '" !');
    }

    basePath = match.path + (match.search ? '?' + match.search : '');
    match = HASH_MATCH.exec((match.hash || '').substr(hashPrefix.length));
    if (match[1]) {
      this.$$path = (match[1].charAt(0) == '/' ? '' : '/') + decodeURIComponent(match[1]);
    } else {
      this.$$path = '';
    }

    this.$$search = parseKeyValue(match[3]);
    this.$$hash = match[5] && decodeURIComponent(match[5]) || '';

    this.$$compose();
  };

  /**
   * Compose hashbang url and update `absUrl` property
   * @private
   */
  this.$$compose = function() {
    var search = toKeyValue(this.$$search),
        hash = this.$$hash ? '#' + encodeUriSegment(this.$$hash) : '';

    this.$$url = encodePath(this.$$path) + (search ? '?' + search : '') + hash;
    this.$$absUrl = composeProtocolHostPort(this.$$protocol, this.$$host, this.$$port) +
                    basePath + (this.$$url ? '#' + hashPrefix + this.$$url : '');
  };

  this.$$rewriteAppUrl = function(absoluteLinkUrl) {
    if(absoluteLinkUrl.indexOf(appBaseUrl) == 0) {
      return absoluteLinkUrl;
    }
  }


  this.$$parse(url);
}


LocationUrl.prototype = {

  /**
   * Has any change been replacing ?
   * @private
   */
  $$replace: false,

  /**
   * @ngdoc method
   * @name ng.$location#absUrl
   * @methodOf ng.$location
   *
   * @description
   * This method is getter only.
   *
   * Return full url representation with all segments encoded according to rules specified in
   * {@link http://www.ietf.org/rfc/rfc3986.txt RFC 3986}.
   *
   * @return {string} full url
   */
  absUrl: locationGetter('$$absUrl'),

  /**
   * @ngdoc method
   * @name ng.$location#url
   * @methodOf ng.$location
   *
   * @description
   * This method is getter / setter.
   *
   * Return url (e.g. `/path?a=b#hash`) when called without any parameter.
   *
   * Change path, search and hash, when called with parameter and return `$location`.
   *
   * @param {string=} url New url without base prefix (e.g. `/path?a=b#hash`)
   * @return {string} url
   */
  url: function(url, replace) {
    if (isUndefined(url))
      return this.$$url;

    var match = PATH_MATCH.exec(url);
    if (match[1]) this.path(decodeURIComponent(match[1]));
    if (match[2] || match[1]) this.search(match[3] || '');
    this.hash(match[5] || '', replace);

    return this;
  },

  /**
   * @ngdoc method
   * @name ng.$location#protocol
   * @methodOf ng.$location
   *
   * @description
   * This method is getter only.
   *
   * Return protocol of current url.
   *
   * @return {string} protocol of current url
   */
  protocol: locationGetter('$$protocol'),

  /**
   * @ngdoc method
   * @name ng.$location#host
   * @methodOf ng.$location
   *
   * @description
   * This method is getter only.
   *
   * Return host of current url.
   *
   * @return {string} host of current url.
   */
  host: locationGetter('$$host'),

  /**
   * @ngdoc method
   * @name ng.$location#port
   * @methodOf ng.$location
   *
   * @description
   * This method is getter only.
   *
   * Return port of current url.
   *
   * @return {Number} port
   */
  port: locationGetter('$$port'),

  /**
   * @ngdoc method
   * @name ng.$location#path
   * @methodOf ng.$location
   *
   * @description
   * This method is getter / setter.
   *
   * Return path of current url when called without any parameter.
   *
   * Change path when called with parameter and return `$location`.
   *
   * Note: Path should always begin with forward slash (/), this method will add the forward slash
   * if it is missing.
   *
   * @param {string=} path New path
   * @return {string} path
   */
  path: locationGetterSetter('$$path', function(path) {
    return path.charAt(0) == '/' ? path : '/' + path;
  }),

  /**
   * @ngdoc method
   * @name ng.$location#search
   * @methodOf ng.$location
   *
   * @description
   * This method is getter / setter.
   *
   * Return search part (as object) of current url when called without any parameter.
   *
   * Change search part when called with parameter and return `$location`.
   *
   * @param {string|object<string,string>=} search New search params - string or hash object
   * @param {string=} paramValue If `search` is a string, then `paramValue` will override only a
   *    single search parameter. If the value is `null`, the parameter will be deleted.
   *
   * @return {string} search
   */
  search: function(search, paramValue) {
    if (isUndefined(search))
      return this.$$search;

    if (isDefined(paramValue)) {
      if (paramValue === null) {
        delete this.$$search[search];
      } else {
        this.$$search[search] = paramValue;
      }
    } else {
      this.$$search = isString(search) ? parseKeyValue(search) : search;
    }

    this.$$compose();
    return this;
  },

  /**
   * @ngdoc method
   * @name ng.$location#hash
   * @methodOf ng.$location
   *
   * @description
   * This method is getter / setter.
   *
   * Return hash fragment when called without any parameter.
   *
   * Change hash fragment when called with parameter and return `$location`.
   *
   * @param {string=} hash New hash fragment
   * @return {string} hash
   */
  hash: locationGetterSetter('$$hash', identity),

  /**
   * @ngdoc method
   * @name ng.$location#replace
   * @methodOf ng.$location
   *
   * @description
   * If called, all changes to $location during current `$digest` will be replacing current history
   * record, instead of adding new one.
   */
  replace: function() {
    this.$$replace = true;
    return this;
  }
};

LocationHashbangUrl.prototype = inherit(LocationUrl.prototype);

function LocationHashbangInHtml5Url(url, hashPrefix, appBaseUrl, baseExtra) {
  LocationHashbangUrl.apply(this, arguments);


  this.$$rewriteAppUrl = function(absoluteLinkUrl) {
    if (absoluteLinkUrl.indexOf(appBaseUrl) == 0) {
      return appBaseUrl + baseExtra + '#' + hashPrefix  + absoluteLinkUrl.substr(appBaseUrl.length);
    }
  }
}

LocationHashbangInHtml5Url.prototype = inherit(LocationHashbangUrl.prototype);

function locationGetter(property) {
  return function() {
    return this[property];
  };
}


function locationGetterSetter(property, preprocess) {
  return function(value) {
    if (isUndefined(value))
      return this[property];

    this[property] = preprocess(value);
    this.$$compose();

    return this;
  };
}


/**
 * @ngdoc object
 * @name ng.$location
 *
 * @requires $browser
 * @requires $sniffer
 * @requires $rootElement
 *
 * @description
 * The $location service parses the URL in the browser address bar (based on the
 * {@link https://developer.mozilla.org/en/window.location window.location}) and makes the URL
 * available to your application. Changes to the URL in the address bar are reflected into
 * $location service and changes to $location are reflected into the browser address bar.
 *
 * **The $location service:**
 *
 * - Exposes the current URL in the browser address bar, so you can
 *   - Watch and observe the URL.
 *   - Change the URL.
 * - Synchronizes the URL with the browser when the user
 *   - Changes the address bar.
 *   - Clicks the back or forward button (or clicks a History link).
 *   - Clicks on a link.
 * - Represents the URL object as a set of methods (protocol, host, port, path, search, hash).
 *
 * For more information see {@link guide/dev_guide.services.$location Developer Guide: Angular
 * Services: Using $location}
 */

/**
 * @ngdoc object
 * @name ng.$locationProvider
 * @description
 * Use the `$locationProvider` to configure how the application deep linking paths are stored.
 */
function $LocationProvider(){
  var hashPrefix = '',
      html5Mode = false;

  /**
   * @ngdoc property
   * @name ng.$locationProvider#hashPrefix
   * @methodOf ng.$locationProvider
   * @description
   * @param {string=} prefix Prefix for hash part (containing path and search)
   * @returns {*} current value if used as getter or itself (chaining) if used as setter
   */
  this.hashPrefix = function(prefix) {
    if (isDefined(prefix)) {
      hashPrefix = prefix;
      return this;
    } else {
      return hashPrefix;
    }
  };

  /**
   * @ngdoc property
   * @name ng.$locationProvider#html5Mode
   * @methodOf ng.$locationProvider
   * @description
   * @param {string=} mode Use HTML5 strategy if available.
   * @returns {*} current value if used as getter or itself (chaining) if used as setter
   */
  this.html5Mode = function(mode) {
    if (isDefined(mode)) {
      html5Mode = mode;
      return this;
    } else {
      return html5Mode;
    }
  };

  this.$get = ['$rootScope', '$browser', '$sniffer', '$rootElement',
      function( $rootScope,   $browser,   $sniffer,   $rootElement) {
    var $location,
        basePath,
        pathPrefix,
        initUrl = $browser.url(),
        initUrlParts = matchUrl(initUrl),
        appBaseUrl;

    if (html5Mode) {
      basePath = $browser.baseHref() || '/';
      pathPrefix = pathPrefixFromBase(basePath);
      appBaseUrl =
          composeProtocolHostPort(initUrlParts.protocol, initUrlParts.host, initUrlParts.port) +
          pathPrefix + '/';

      if ($sniffer.history) {
        $location = new LocationUrl(
          convertToHtml5Url(initUrl, basePath, hashPrefix),
          pathPrefix, appBaseUrl);
      } else {
        $location = new LocationHashbangInHtml5Url(
          convertToHashbangUrl(initUrl, basePath, hashPrefix),
          hashPrefix, appBaseUrl, basePath.substr(pathPrefix.length + 1));
      }
    } else {
      appBaseUrl =
          composeProtocolHostPort(initUrlParts.protocol, initUrlParts.host, initUrlParts.port) +
          (initUrlParts.path || '') +
          (initUrlParts.search ? ('?' + initUrlParts.search) : '') +
          '#' + hashPrefix + '/';

      $location = new LocationHashbangUrl(initUrl, hashPrefix, appBaseUrl);
    }

    $rootElement.bind('click', function(event) {
      // TODO(vojta): rewrite link when opening in new tab/window (in legacy browser)
      // currently we open nice url link and redirect then

      if (event.ctrlKey || event.metaKey || event.which == 2) return;

      var elm = jqLite(event.target);

      // traverse the DOM up to find first A tag
      while (lowercase(elm[0].nodeName) !== 'a') {
        // ignore rewriting if no A tag (reached root element, or no parent - removed from document)
        if (elm[0] === $rootElement[0] || !(elm = elm.parent())[0]) return;
      }

      var absHref = elm.prop('href'),
          rewrittenUrl = $location.$$rewriteAppUrl(absHref);

      if (absHref && !elm.attr('target') && rewrittenUrl) {
        // update location manually
        $location.$$parse(rewrittenUrl);
        $rootScope.$apply();
        event.preventDefault();
        // hack to work around FF6 bug 684208 when scenario runner clicks on links
        window.angular['ff-684208-preventDefault'] = true;
      }
    });


    // rewrite hashbang url <> html5 url
    if ($location.absUrl() != initUrl) {
      $browser.url($location.absUrl(), true);
    }

    // update $location when $browser url changes
    $browser.onUrlChange(function(newUrl) {
      if ($location.absUrl() != newUrl) {
        if ($rootScope.$broadcast('$locationChangeStart', newUrl, $location.absUrl()).defaultPrevented) {
          $browser.url($location.absUrl());
          return;
        }
        $rootScope.$evalAsync(function() {
          var oldUrl = $location.absUrl();

          $location.$$parse(newUrl);
          afterLocationChange(oldUrl);
        });
        if (!$rootScope.$$phase) $rootScope.$digest();
      }
    });

    // update browser
    var changeCounter = 0;
    $rootScope.$watch(function $locationWatch() {
      var oldUrl = $browser.url();
      var currentReplace = $location.$$replace;

      if (!changeCounter || oldUrl != $location.absUrl()) {
        changeCounter++;
        $rootScope.$evalAsync(function() {
          if ($rootScope.$broadcast('$locationChangeStart', $location.absUrl(), oldUrl).
              defaultPrevented) {
            $location.$$parse(oldUrl);
          } else {
            $browser.url($location.absUrl(), currentReplace);
            afterLocationChange(oldUrl);
          }
        });
      }
      $location.$$replace = false;

      return changeCounter;
    });

    return $location;

    function afterLocationChange(oldUrl) {
      $rootScope.$broadcast('$locationChangeSuccess', $location.absUrl(), oldUrl);
    }
}];
}

/**
 * @ngdoc object
 * @name ng.$log
 * @requires $window
 *
 * @description
 * Simple service for logging. Default implementation writes the message
 * into the browser's console (if present).
 *
 * The main purpose of this service is to simplify debugging and troubleshooting.
 *
 * @example
   <example>
     <file name="script.js">
       function LogCtrl($scope, $log) {
         $scope.$log = $log;
         $scope.message = 'Hello World!';
       }
     </file>
     <file name="index.html">
       <div ng-controller="LogCtrl">
         <p>Reload this page with open console, enter text and hit the log button...</p>
         Message:
         <input type="text" ng-model="message"/>
         <button ng-click="$log.log(message)">log</button>
         <button ng-click="$log.warn(message)">warn</button>
         <button ng-click="$log.info(message)">info</button>
         <button ng-click="$log.error(message)">error</button>
       </div>
     </file>
   </example>
 */

function $LogProvider(){
  this.$get = ['$window', function($window){
    return {
      /**
       * @ngdoc method
       * @name ng.$log#log
       * @methodOf ng.$log
       *
       * @description
       * Write a log message
       */
      log: consoleLog('log'),

      /**
       * @ngdoc method
       * @name ng.$log#warn
       * @methodOf ng.$log
       *
       * @description
       * Write a warning message
       */
      warn: consoleLog('warn'),

      /**
       * @ngdoc method
       * @name ng.$log#info
       * @methodOf ng.$log
       *
       * @description
       * Write an information message
       */
      info: consoleLog('info'),

      /**
       * @ngdoc method
       * @name ng.$log#error
       * @methodOf ng.$log
       *
       * @description
       * Write an error message
       */
      error: consoleLog('error')
    };

    function formatError(arg) {
      if (arg instanceof Error) {
        if (arg.stack) {
          arg = (arg.message && arg.stack.indexOf(arg.message) === -1)
              ? 'Error: ' + arg.message + '\n' + arg.stack
              : arg.stack;
        } else if (arg.sourceURL) {
          arg = arg.message + '\n' + arg.sourceURL + ':' + arg.line;
        }
      }
      return arg;
    }

    function consoleLog(type) {
      var console = $window.console || {},
          logFn = console[type] || console.log || noop;

      if (logFn.apply) {
        return function() {
          var args = [];
          forEach(arguments, function(arg) {
            args.push(formatError(arg));
          });
          return logFn.apply(console, args);
        };
      }

      // we are IE which either doesn't have window.console => this is noop and we do nothing,
      // or we are IE where console.log doesn't have apply so we log at least first 2 args
      return function(arg1, arg2) {
        logFn(arg1, arg2);
      }
    }
  }];
}

var OPERATORS = {
    'null':function(){return null;},
    'true':function(){return true;},
    'false':function(){return false;},
    undefined:noop,
    '+':function(self, locals, a,b){
      a=a(self, locals); b=b(self, locals);
      if (isDefined(a)) {
        if (isDefined(b)) {
          return a + b;
        }
        return a;
      }
      return isDefined(b)?b:undefined;},
    '-':function(self, locals, a,b){a=a(self, locals); b=b(self, locals); return (isDefined(a)?a:0)-(isDefined(b)?b:0);},
    '*':function(self, locals, a,b){return a(self, locals)*b(self, locals);},
    '/':function(self, locals, a,b){return a(self, locals)/b(self, locals);},
    '%':function(self, locals, a,b){return a(self, locals)%b(self, locals);},
    '^':function(self, locals, a,b){return a(self, locals)^b(self, locals);},
    '=':noop,
    '==':function(self, locals, a,b){return a(self, locals)==b(self, locals);},
    '!=':function(self, locals, a,b){return a(self, locals)!=b(self, locals);},
    '<':function(self, locals, a,b){return a(self, locals)<b(self, locals);},
    '>':function(self, locals, a,b){return a(self, locals)>b(self, locals);},
    '<=':function(self, locals, a,b){return a(self, locals)<=b(self, locals);},
    '>=':function(self, locals, a,b){return a(self, locals)>=b(self, locals);},
    '&&':function(self, locals, a,b){return a(self, locals)&&b(self, locals);},
    '||':function(self, locals, a,b){return a(self, locals)||b(self, locals);},
    '&':function(self, locals, a,b){return a(self, locals)&b(self, locals);},
//    '|':function(self, locals, a,b){return a|b;},
    '|':function(self, locals, a,b){return b(self, locals)(self, locals, a(self, locals));},
    '!':function(self, locals, a){return !a(self, locals);}
};
var ESCAPE = {"n":"\n", "f":"\f", "r":"\r", "t":"\t", "v":"\v", "'":"'", '"':'"'};

function lex(text, csp){
  var tokens = [],
      token,
      index = 0,
      json = [],
      ch,
      lastCh = ':'; // can start regexp

  while (index < text.length) {
    ch = text.charAt(index);
    if (is('"\'')) {
      readString(ch);
    } else if (isNumber(ch) || is('.') && isNumber(peek())) {
      readNumber();
    } else if (isIdent(ch)) {
      readIdent();
      // identifiers can only be if the preceding char was a { or ,
      if (was('{,') && json[0]=='{' &&
         (token=tokens[tokens.length-1])) {
        token.json = token.text.indexOf('.') == -1;
      }
    } else if (is('(){}[].,;:')) {
      tokens.push({
        index:index,
        text:ch,
        json:(was(':[,') && is('{[')) || is('}]:,')
      });
      if (is('{[')) json.unshift(ch);
      if (is('}]')) json.shift();
      index++;
    } else if (isWhitespace(ch)) {
      index++;
      continue;
    } else {
      var ch2 = ch + peek(),
          fn = OPERATORS[ch],
          fn2 = OPERATORS[ch2];
      if (fn2) {
        tokens.push({index:index, text:ch2, fn:fn2});
        index += 2;
      } else if (fn) {
        tokens.push({index:index, text:ch, fn:fn, json: was('[,:') && is('+-')});
        index += 1;
      } else {
        throwError("Unexpected next character ", index, index+1);
      }
    }
    lastCh = ch;
  }
  return tokens;

  function is(chars) {
    return chars.indexOf(ch) != -1;
  }

  function was(chars) {
    return chars.indexOf(lastCh) != -1;
  }

  function peek() {
    return index + 1 < text.length ? text.charAt(index + 1) : false;
  }
  function isNumber(ch) {
    return '0' <= ch && ch <= '9';
  }
  function isWhitespace(ch) {
    return ch == ' ' || ch == '\r' || ch == '\t' ||
           ch == '\n' || ch == '\v' || ch == '\u00A0'; // IE treats non-breaking space as \u00A0
  }
  function isIdent(ch) {
    return 'a' <= ch && ch <= 'z' ||
           'A' <= ch && ch <= 'Z' ||
           '_' == ch || ch == '$';
  }
  function isExpOperator(ch) {
    return ch == '-' || ch == '+' || isNumber(ch);
  }

  function throwError(error, start, end) {
    end = end || index;
    throw Error("Lexer Error: " + error + " at column" +
        (isDefined(start)
            ? "s " + start +  "-" + index + " [" + text.substring(start, end) + "]"
            : " " + end) +
        " in expression [" + text + "].");
  }

  function readNumber() {
    var number = "";
    var start = index;
    while (index < text.length) {
      var ch = lowercase(text.charAt(index));
      if (ch == '.' || isNumber(ch)) {
        number += ch;
      } else {
        var peekCh = peek();
        if (ch == 'e' && isExpOperator(peekCh)) {
          number += ch;
        } else if (isExpOperator(ch) &&
            peekCh && isNumber(peekCh) &&
            number.charAt(number.length - 1) == 'e') {
          number += ch;
        } else if (isExpOperator(ch) &&
            (!peekCh || !isNumber(peekCh)) &&
            number.charAt(number.length - 1) == 'e') {
          throwError('Invalid exponent');
        } else {
          break;
        }
      }
      index++;
    }
    number = 1 * number;
    tokens.push({index:start, text:number, json:true,
      fn:function() {return number;}});
  }
  function readIdent() {
    var ident = "",
        start = index,
        lastDot, peekIndex, methodName, ch;

    while (index < text.length) {
      ch = text.charAt(index);
      if (ch == '.' || isIdent(ch) || isNumber(ch)) {
        if (ch == '.') lastDot = index;
        ident += ch;
      } else {
        break;
      }
      index++;
    }

    //check if this is not a method invocation and if it is back out to last dot
    if (lastDot) {
      peekIndex = index;
      while(peekIndex < text.length) {
        ch = text.charAt(peekIndex);
        if (ch == '(') {
          methodName = ident.substr(lastDot - start + 1);
          ident = ident.substr(0, lastDot - start);
          index = peekIndex;
          break;
        }
        if(isWhitespace(ch)) {
          peekIndex++;
        } else {
          break;
        }
      }
    }


    var token = {
      index:start,
      text:ident
    };

    if (OPERATORS.hasOwnProperty(ident)) {
      token.fn = token.json = OPERATORS[ident];
    } else {
      var getter = getterFn(ident, csp);
      token.fn = extend(function(self, locals) {
        return (getter(self, locals));
      }, {
        assign: function(self, value) {
          return setter(self, ident, value);
        }
      });
    }

    tokens.push(token);

    if (methodName) {
      tokens.push({
        index:lastDot,
        text: '.',
        json: false
      });
      tokens.push({
        index: lastDot + 1,
        text: methodName,
        json: false
      });
    }
  }

  function readString(quote) {
    var start = index;
    index++;
    var string = "";
    var rawString = quote;
    var escape = false;
    while (index < text.length) {
      var ch = text.charAt(index);
      rawString += ch;
      if (escape) {
        if (ch == 'u') {
          var hex = text.substring(index + 1, index + 5);
          if (!hex.match(/[\da-f]{4}/i))
            throwError( "Invalid unicode escape [\\u" + hex + "]");
          index += 4;
          string += String.fromCharCode(parseInt(hex, 16));
        } else {
          var rep = ESCAPE[ch];
          if (rep) {
            string += rep;
          } else {
            string += ch;
          }
        }
        escape = false;
      } else if (ch == '\\') {
        escape = true;
      } else if (ch == quote) {
        index++;
        tokens.push({
          index:start,
          text:rawString,
          string:string,
          json:true,
          fn:function() { return string; }
        });
        return;
      } else {
        string += ch;
      }
      index++;
    }
    throwError("Unterminated quote", start);
  }
}

/////////////////////////////////////////

function parser(text, json, $filter, csp){
  var ZERO = valueFn(0),
      value,
      tokens = lex(text, csp),
      assignment = _assignment,
      functionCall = _functionCall,
      fieldAccess = _fieldAccess,
      objectIndex = _objectIndex,
      filterChain = _filterChain;

  if(json){
    // The extra level of aliasing is here, just in case the lexer misses something, so that
    // we prevent any accidental execution in JSON.
    assignment = logicalOR;
    functionCall =
      fieldAccess =
      objectIndex =
      filterChain =
        function() { throwError("is not valid json", {text:text, index:0}); };
    value = primary();
  } else {
    value = statements();
  }
  if (tokens.length !== 0) {
    throwError("is an unexpected token", tokens[0]);
  }
  return value;

  ///////////////////////////////////
  function throwError(msg, token) {
    throw Error("Syntax Error: Token '" + token.text +
      "' " + msg + " at column " +
      (token.index + 1) + " of the expression [" +
      text + "] starting at [" + text.substring(token.index) + "].");
  }

  function peekToken() {
    if (tokens.length === 0)
      throw Error("Unexpected end of expression: " + text);
    return tokens[0];
  }

  function peek(e1, e2, e3, e4) {
    if (tokens.length > 0) {
      var token = tokens[0];
      var t = token.text;
      if (t==e1 || t==e2 || t==e3 || t==e4 ||
          (!e1 && !e2 && !e3 && !e4)) {
        return token;
      }
    }
    return false;
  }

  function expect(e1, e2, e3, e4){
    var token = peek(e1, e2, e3, e4);
    if (token) {
      if (json && !token.json) {
        throwError("is not valid json", token);
      }
      tokens.shift();
      return token;
    }
    return false;
  }

  function consume(e1){
    if (!expect(e1)) {
      throwError("is unexpected, expecting [" + e1 + "]", peek());
    }
  }

  function unaryFn(fn, right) {
    return function(self, locals) {
      return fn(self, locals, right);
    };
  }

  function binaryFn(left, fn, right) {
    return function(self, locals) {
      return fn(self, locals, left, right);
    };
  }

  function statements() {
    var statements = [];
    while(true) {
      if (tokens.length > 0 && !peek('}', ')', ';', ']'))
        statements.push(filterChain());
      if (!expect(';')) {
        // optimize for the common case where there is only one statement.
        // TODO(size): maybe we should not support multiple statements?
        return statements.length == 1
          ? statements[0]
          : function(self, locals){
            var value;
            for ( var i = 0; i < statements.length; i++) {
              var statement = statements[i];
              if (statement)
                value = statement(self, locals);
            }
            return value;
          };
      }
    }
  }

  function _filterChain() {
    var left = expression();
    var token;
    while(true) {
      if ((token = expect('|'))) {
        left = binaryFn(left, token.fn, filter());
      } else {
        return left;
      }
    }
  }

  function filter() {
    var token = expect();
    var fn = $filter(token.text);
    var argsFn = [];
    while(true) {
      if ((token = expect(':'))) {
        argsFn.push(expression());
      } else {
        var fnInvoke = function(self, locals, input){
          var args = [input];
          for ( var i = 0; i < argsFn.length; i++) {
            args.push(argsFn[i](self, locals));
          }
          return fn.apply(self, args);
        };
        return function() {
          return fnInvoke;
        };
      }
    }
  }

  function expression() {
    return assignment();
  }

  function _assignment() {
    var left = logicalOR();
    var right;
    var token;
    if ((token = expect('='))) {
      if (!left.assign) {
        throwError("implies assignment but [" +
          text.substring(0, token.index) + "] can not be assigned to", token);
      }
      right = logicalOR();
      return function(scope, locals){
        return left.assign(scope, right(scope, locals), locals);
      };
    } else {
      return left;
    }
  }

  function logicalOR() {
    var left = logicalAND();
    var token;
    while(true) {
      if ((token = expect('||'))) {
        left = binaryFn(left, token.fn, logicalAND());
      } else {
        return left;
      }
    }
  }

  function logicalAND() {
    var left = equality();
    var token;
    if ((token = expect('&&'))) {
      left = binaryFn(left, token.fn, logicalAND());
    }
    return left;
  }

  function equality() {
    var left = relational();
    var token;
    if ((token = expect('==','!='))) {
      left = binaryFn(left, token.fn, equality());
    }
    return left;
  }

  function relational() {
    var left = additive();
    var token;
    if ((token = expect('<', '>', '<=', '>='))) {
      left = binaryFn(left, token.fn, relational());
    }
    return left;
  }

  function additive() {
    var left = multiplicative();
    var token;
    while ((token = expect('+','-'))) {
      left = binaryFn(left, token.fn, multiplicative());
    }
    return left;
  }

  function multiplicative() {
    var left = unary();
    var token;
    while ((token = expect('*','/','%'))) {
      left = binaryFn(left, token.fn, unary());
    }
    return left;
  }

  function unary() {
    var token;
    if (expect('+')) {
      return primary();
    } else if ((token = expect('-'))) {
      return binaryFn(ZERO, token.fn, unary());
    } else if ((token = expect('!'))) {
      return unaryFn(token.fn, unary());
    } else {
      return primary();
    }
  }


  function primary() {
    var primary;
    if (expect('(')) {
      primary = filterChain();
      consume(')');
    } else if (expect('[')) {
      primary = arrayDeclaration();
    } else if (expect('{')) {
      primary = object();
    } else {
      var token = expect();
      primary = token.fn;
      if (!primary) {
        throwError("not a primary expression", token);
      }
    }

    var next, context;
    while ((next = expect('(', '[', '.'))) {
      if (next.text === '(') {
        primary = functionCall(primary, context);
        context = null;
      } else if (next.text === '[') {
        context = primary;
        primary = objectIndex(primary);
      } else if (next.text === '.') {
        context = primary;
        primary = fieldAccess(primary);
      } else {
        throwError("IMPOSSIBLE");
      }
    }
    return primary;
  }

  function _fieldAccess(object) {
    var field = expect().text;
    var getter = getterFn(field, csp);
    return extend(
        function(scope, locals, self) {
          return getter(self || object(scope, locals), locals);
        },
        {
          assign:function(scope, value, locals) {
            return setter(object(scope, locals), field, value);
          }
        }
    );
  }

  function _objectIndex(obj) {
    var indexFn = expression();
    consume(']');
    return extend(
      function(self, locals){
        var o = obj(self, locals),
            i = indexFn(self, locals),
            v, p;

        if (!o) return undefined;
        v = o[i];
        if (v && v.then) {
          p = v;
          if (!('$$v' in v)) {
            p.$$v = undefined;
            p.then(function(val) { p.$$v = val; });
          }
          v = v.$$v;
        }
        return v;
      }, {
        assign:function(self, value, locals){
          return obj(self, locals)[indexFn(self, locals)] = value;
        }
      });
  }

  function _functionCall(fn, contextGetter) {
    var argsFn = [];
    if (peekToken().text != ')') {
      do {
        argsFn.push(expression());
      } while (expect(','));
    }
    consume(')');
    return function(scope, locals){
      var args = [],
          context = contextGetter ? contextGetter(scope, locals) : scope;

      for ( var i = 0; i < argsFn.length; i++) {
        args.push(argsFn[i](scope, locals));
      }
      var fnPtr = fn(scope, locals, context) || noop;
      // IE stupidity!
      return fnPtr.apply
          ? fnPtr.apply(context, args)
          : fnPtr(args[0], args[1], args[2], args[3], args[4]);
    };
  }

  // This is used with json array declaration
  function arrayDeclaration () {
    var elementFns = [];
    if (peekToken().text != ']') {
      do {
        elementFns.push(expression());
      } while (expect(','));
    }
    consume(']');
    return function(self, locals){
      var array = [];
      for ( var i = 0; i < elementFns.length; i++) {
        array.push(elementFns[i](self, locals));
      }
      return array;
    };
  }

  function object () {
    var keyValues = [];
    if (peekToken().text != '}') {
      do {
        var token = expect(),
        key = token.string || token.text;
        consume(":");
        var value = expression();
        keyValues.push({key:key, value:value});
      } while (expect(','));
    }
    consume('}');
    return function(self, locals){
      var object = {};
      for ( var i = 0; i < keyValues.length; i++) {
        var keyValue = keyValues[i];
        object[keyValue.key] = keyValue.value(self, locals);
      }
      return object;
    };
  }
}

//////////////////////////////////////////////////
// Parser helper functions
//////////////////////////////////////////////////

function setter(obj, path, setValue) {
  var element = path.split('.');
  for (var i = 0; element.length > 1; i++) {
    var key = element.shift();
    var propertyObj = obj[key];
    if (!propertyObj) {
      propertyObj = {};
      obj[key] = propertyObj;
    }
    obj = propertyObj;
  }
  obj[element.shift()] = setValue;
  return setValue;
}

/**
 * Return the value accesible from the object by path. Any undefined traversals are ignored
 * @param {Object} obj starting object
 * @param {string} path path to traverse
 * @param {boolean=true} bindFnToScope
 * @returns value as accesbile by path
 */
//TODO(misko): this function needs to be removed
function getter(obj, path, bindFnToScope) {
  if (!path) return obj;
  var keys = path.split('.');
  var key;
  var lastInstance = obj;
  var len = keys.length;

  for (var i = 0; i < len; i++) {
    key = keys[i];
    if (obj) {
      obj = (lastInstance = obj)[key];
    }
  }
  if (!bindFnToScope && isFunction(obj)) {
    return bind(lastInstance, obj);
  }
  return obj;
}

var getterFnCache = {};

/**
 * Implementation of the "Black Hole" variant from:
 * - http://jsperf.com/angularjs-parse-getter/4
 * - http://jsperf.com/path-evaluation-simplified/7
 */
function cspSafeGetterFn(key0, key1, key2, key3, key4) {
  return function(scope, locals) {
    var pathVal = (locals && locals.hasOwnProperty(key0)) ? locals : scope,
        promise;

    if (pathVal === null || pathVal === undefined) return pathVal;

    pathVal = pathVal[key0];
    if (pathVal && pathVal.then) {
      if (!("$$v" in pathVal)) {
        promise = pathVal;
        promise.$$v = undefined;
        promise.then(function(val) { promise.$$v = val; });
      }
      pathVal = pathVal.$$v;
    }
    if (!key1 || pathVal === null || pathVal === undefined) return pathVal;

    pathVal = pathVal[key1];
    if (pathVal && pathVal.then) {
      if (!("$$v" in pathVal)) {
        promise = pathVal;
        promise.$$v = undefined;
        promise.then(function(val) { promise.$$v = val; });
      }
      pathVal = pathVal.$$v;
    }
    if (!key2 || pathVal === null || pathVal === undefined) return pathVal;

    pathVal = pathVal[key2];
    if (pathVal && pathVal.then) {
      if (!("$$v" in pathVal)) {
        promise = pathVal;
        promise.$$v = undefined;
        promise.then(function(val) { promise.$$v = val; });
      }
      pathVal = pathVal.$$v;
    }
    if (!key3 || pathVal === null || pathVal === undefined) return pathVal;

    pathVal = pathVal[key3];
    if (pathVal && pathVal.then) {
      if (!("$$v" in pathVal)) {
        promise = pathVal;
        promise.$$v = undefined;
        promise.then(function(val) { promise.$$v = val; });
      }
      pathVal = pathVal.$$v;
    }
    if (!key4 || pathVal === null || pathVal === undefined) return pathVal;

    pathVal = pathVal[key4];
    if (pathVal && pathVal.then) {
      if (!("$$v" in pathVal)) {
        promise = pathVal;
        promise.$$v = undefined;
        promise.then(function(val) { promise.$$v = val; });
      }
      pathVal = pathVal.$$v;
    }
    return pathVal;
  };
}

function getterFn(path, csp) {
  if (getterFnCache.hasOwnProperty(path)) {
    return getterFnCache[path];
  }

  var pathKeys = path.split('.'),
      pathKeysLength = pathKeys.length,
      fn;

  if (csp) {
    fn = (pathKeysLength < 6)
        ? cspSafeGetterFn(pathKeys[0], pathKeys[1], pathKeys[2], pathKeys[3], pathKeys[4])
        : function(scope, locals) {
          var i = 0, val;
          do {
            val = cspSafeGetterFn(
                    pathKeys[i++], pathKeys[i++], pathKeys[i++], pathKeys[i++], pathKeys[i++]
                  )(scope, locals);

            locals = undefined; // clear after first iteration
            scope = val;
          } while (i < pathKeysLength);
          return val;
        }
  } else {
    var code = 'var l, fn, p;\n';
    forEach(pathKeys, function(key, index) {
      code += 'if(s === null || s === undefined) return s;\n' +
              'l=s;\n' +
              's='+ (index
                      // we simply dereference 's' on any .dot notation
                      ? 's'
                      // but if we are first then we check locals first, and if so read it first
                      : '((k&&k.hasOwnProperty("' + key + '"))?k:s)') + '["' + key + '"]' + ';\n' +
              'if (s && s.then) {\n' +
                ' if (!("$$v" in s)) {\n' +
                  ' p=s;\n' +
                  ' p.$$v = undefined;\n' +
                  ' p.then(function(v) {p.$$v=v;});\n' +
                  '}\n' +
                ' s=s.$$v\n' +
              '}\n';
    });
    code += 'return s;';
    fn = Function('s', 'k', code); // s=scope, k=locals
    fn.toString = function() { return code; };
  }

  return getterFnCache[path] = fn;
}

///////////////////////////////////

/**
 * @ngdoc function
 * @name ng.$parse
 * @function
 *
 * @description
 *
 * Converts Angular {@link guide/expression expression} into a function.
 *
 * <pre>
 *   var getter = $parse('user.name');
 *   var setter = getter.assign;
 *   var context = {user:{name:'angular'}};
 *   var locals = {user:{name:'local'}};
 *
 *   expect(getter(context)).toEqual('angular');
 *   setter(context, 'newValue');
 *   expect(context.user.name).toEqual('newValue');
 *   expect(getter(context, locals)).toEqual('local');
 * </pre>
 *
 *
 * @param {string} expression String expression to compile.
 * @returns {function(context, locals)} a function which represents the compiled expression:
 *
 *    * `context` – `{object}` – an object against which any expressions embedded in the strings
 *      are evaluated against (tipically a scope object).
 *    * `locals` – `{object=}` – local variables context object, useful for overriding values in
 *      `context`.
 *
 *    The return function also has an `assign` property, if the expression is assignable, which
 *    allows one to set values to expressions.
 *
 */
function $ParseProvider() {
  var cache = {};
  this.$get = ['$filter', '$sniffer', function($filter, $sniffer) {
    return function(exp) {
      switch(typeof exp) {
        case 'string':
          return cache.hasOwnProperty(exp)
            ? cache[exp]
            : cache[exp] =  parser(exp, false, $filter, $sniffer.csp);
        case 'function':
          return exp;
        default:
          return noop;
      }
    };
  }];
}

/**
 * @ngdoc service
 * @name ng.$q
 * @requires $rootScope
 *
 * @description
 * A promise/deferred implementation inspired by [Kris Kowal's Q](https://github.com/kriskowal/q).
 *
 * [The CommonJS Promise proposal](http://wiki.commonjs.org/wiki/Promises) describes a promise as an
 * interface for interacting with an object that represents the result of an action that is
 * performed asynchronously, and may or may not be finished at any given point in time.
 *
 * From the perspective of dealing with error handling, deferred and promise APIs are to
 * asynchronous programming what `try`, `catch` and `throw` keywords are to synchronous programming.
 *
 * <pre>
 *   // for the purpose of this example let's assume that variables `$q` and `scope` are
 *   // available in the current lexical scope (they could have been injected or passed in).
 *
 *   function asyncGreet(name) {
 *     var deferred = $q.defer();
 *
 *     setTimeout(function() {
 *       // since this fn executes async in a future turn of the event loop, we need to wrap
 *       // our code into an $apply call so that the model changes are properly observed.
 *       scope.$apply(function() {
 *         if (okToGreet(name)) {
 *           deferred.resolve('Hello, ' + name + '!');
 *         } else {
 *           deferred.reject('Greeting ' + name + ' is not allowed.');
 *         }
 *       });
 *     }, 1000);
 *
 *     return deferred.promise;
 *   }
 *
 *   var promise = asyncGreet('Robin Hood');
 *   promise.then(function(greeting) {
 *     alert('Success: ' + greeting);
 *   }, function(reason) {
 *     alert('Failed: ' + reason);
 *   });
 * </pre>
 *
 * At first it might not be obvious why this extra complexity is worth the trouble. The payoff
 * comes in the way of
 * [guarantees that promise and deferred APIs make](https://github.com/kriskowal/uncommonjs/blob/master/promises/specification.md).
 *
 * Additionally the promise api allows for composition that is very hard to do with the
 * traditional callback ([CPS](http://en.wikipedia.org/wiki/Continuation-passing_style)) approach.
 * For more on this please see the [Q documentation](https://github.com/kriskowal/q) especially the
 * section on serial or parallel joining of promises.
 *
 *
 * # The Deferred API
 *
 * A new instance of deferred is constructed by calling `$q.defer()`.
 *
 * The purpose of the deferred object is to expose the associated Promise instance as well as APIs
 * that can be used for signaling the successful or unsuccessful completion of the task.
 *
 * **Methods**
 *
 * - `resolve(value)` – resolves the derived promise with the `value`. If the value is a rejection
 *   constructed via `$q.reject`, the promise will be rejected instead.
 * - `reject(reason)` – rejects the derived promise with the `reason`. This is equivalent to
 *   resolving it with a rejection constructed via `$q.reject`.
 *
 * **Properties**
 *
 * - promise – `{Promise}` – promise object associated with this deferred.
 *
 *
 * # The Promise API
 *
 * A new promise instance is created when a deferred instance is created and can be retrieved by
 * calling `deferred.promise`.
 *
 * The purpose of the promise object is to allow for interested parties to get access to the result
 * of the deferred task when it completes.
 *
 * **Methods**
 *
 * - `then(successCallback, errorCallback)` – regardless of when the promise was or will be resolved
 *   or rejected calls one of the success or error callbacks asynchronously as soon as the result
 *   is available. The callbacks are called with a single argument the result or rejection reason.
 *
 *   This method *returns a new promise* which is resolved or rejected via the return value of the
 *   `successCallback` or `errorCallback`.
 *
 *
 * # Chaining promises
 *
 * Because calling `then` api of a promise returns a new derived promise, it is easily possible
 * to create a chain of promises:
 *
 * <pre>
 *   promiseB = promiseA.then(function(result) {
 *     return result + 1;
 *   });
 *
 *   // promiseB will be resolved immediately after promiseA is resolved and its value will be
 *   // the result of promiseA incremented by 1
 * </pre>
 *
 * It is possible to create chains of any length and since a promise can be resolved with another
 * promise (which will defer its resolution further), it is possible to pause/defer resolution of
 * the promises at any point in the chain. This makes it possible to implement powerful apis like
 * $http's response interceptors.
 *
 *
 * # Differences between Kris Kowal's Q and $q
 *
 *  There are three main differences:
 *
 * - $q is integrated with the {@link ng.$rootScope.Scope} Scope model observation
 *   mechanism in angular, which means faster propagation of resolution or rejection into your
 *   models and avoiding unnecessary browser repaints, which would result in flickering UI.
 * - $q promises are recognized by the templating engine in angular, which means that in templates
 *   you can treat promises attached to a scope as if they were the resulting values.
 * - Q has many more features than $q, but that comes at a cost of bytes. $q is tiny, but contains
 *   all the important functionality needed for common async tasks.
 * 
 *  # Testing
 * 
 *  <pre>
 *    it('should simulate promise', inject(function($q, $rootScope) {
 *      var deferred = $q.defer();
 *      var promise = deferred.promise;
 *      var resolvedValue;
 * 
 *      promise.then(function(value) { resolvedValue = value; });
 *      expect(resolvedValue).toBeUndefined();
 * 
 *      // Simulate resolving of promise
 *      deferred.resolve(123);
 *      // Note that the 'then' function does not get called synchronously.
 *      // This is because we want the promise API to always be async, whether or not
 *      // it got called synchronously or asynchronously.
 *      expect(resolvedValue).toBeUndefined();
 * 
 *      // Propagate promise resolution to 'then' functions using $apply().
 *      $rootScope.$apply();
 *      expect(resolvedValue).toEqual(123);
 *    });
 *  </pre>
 */
function $QProvider() {

  this.$get = ['$rootScope', '$exceptionHandler', function($rootScope, $exceptionHandler) {
    return qFactory(function(callback) {
      $rootScope.$evalAsync(callback);
    }, $exceptionHandler);
  }];
}


/**
 * Constructs a promise manager.
 *
 * @param {function(function)} nextTick Function for executing functions in the next turn.
 * @param {function(...*)} exceptionHandler Function into which unexpected exceptions are passed for
 *     debugging purposes.
 * @returns {object} Promise manager.
 */
function qFactory(nextTick, exceptionHandler) {

  /**
   * @ngdoc
   * @name ng.$q#defer
   * @methodOf ng.$q
   * @description
   * Creates a `Deferred` object which represents a task which will finish in the future.
   *
   * @returns {Deferred} Returns a new instance of deferred.
   */
  var defer = function() {
    var pending = [],
        value, deferred;

    deferred = {

      resolve: function(val) {
        if (pending) {
          var callbacks = pending;
          pending = undefined;
          value = ref(val);

          if (callbacks.length) {
            nextTick(function() {
              var callback;
              for (var i = 0, ii = callbacks.length; i < ii; i++) {
                callback = callbacks[i];
                value.then(callback[0], callback[1]);
              }
            });
          }
        }
      },


      reject: function(reason) {
        deferred.resolve(reject(reason));
      },


      promise: {
        then: function(callback, errback) {
          var result = defer();

          var wrappedCallback = function(value) {
            try {
              result.resolve((callback || defaultCallback)(value));
            } catch(e) {
              exceptionHandler(e);
              result.reject(e);
            }
          };

          var wrappedErrback = function(reason) {
            try {
              result.resolve((errback || defaultErrback)(reason));
            } catch(e) {
              exceptionHandler(e);
              result.reject(e);
            }
          };

          if (pending) {
            pending.push([wrappedCallback, wrappedErrback]);
          } else {
            value.then(wrappedCallback, wrappedErrback);
          }

          return result.promise;
        }
      }
    };

    return deferred;
  };


  var ref = function(value) {
    if (value && value.then) return value;
    return {
      then: function(callback) {
        var result = defer();
        nextTick(function() {
          result.resolve(callback(value));
        });
        return result.promise;
      }
    };
  };


  /**
   * @ngdoc
   * @name ng.$q#reject
   * @methodOf ng.$q
   * @description
   * Creates a promise that is resolved as rejected with the specified `reason`. This api should be
   * used to forward rejection in a chain of promises. If you are dealing with the last promise in
   * a promise chain, you don't need to worry about it.
   *
   * When comparing deferreds/promises to the familiar behavior of try/catch/throw, think of
   * `reject` as the `throw` keyword in JavaScript. This also means that if you "catch" an error via
   * a promise error callback and you want to forward the error to the promise derived from the
   * current promise, you have to "rethrow" the error by returning a rejection constructed via
   * `reject`.
   *
   * <pre>
   *   promiseB = promiseA.then(function(result) {
   *     // success: do something and resolve promiseB
   *     //          with the old or a new result
   *     return result;
   *   }, function(reason) {
   *     // error: handle the error if possible and
   *     //        resolve promiseB with newPromiseOrValue,
   *     //        otherwise forward the rejection to promiseB
   *     if (canHandle(reason)) {
   *      // handle the error and recover
   *      return newPromiseOrValue;
   *     }
   *     return $q.reject(reason);
   *   });
   * </pre>
   *
   * @param {*} reason Constant, message, exception or an object representing the rejection reason.
   * @returns {Promise} Returns a promise that was already resolved as rejected with the `reason`.
   */
  var reject = function(reason) {
    return {
      then: function(callback, errback) {
        var result = defer();
        nextTick(function() {
          result.resolve((errback || defaultErrback)(reason));
        });
        return result.promise;
      }
    };
  };


  /**
   * @ngdoc
   * @name ng.$q#when
   * @methodOf ng.$q
   * @description
   * Wraps an object that might be a value or a (3rd party) then-able promise into a $q promise.
   * This is useful when you are dealing with an object that might or might not be a promise, or if
   * the promise comes from a source that can't be trusted.
   *
   * @param {*} value Value or a promise
   * @returns {Promise} Returns a promise of the passed value or promise
   */
  var when = function(value, callback, errback) {
    var result = defer(),
        done;

    var wrappedCallback = function(value) {
      try {
        return (callback || defaultCallback)(value);
      } catch (e) {
        exceptionHandler(e);
        return reject(e);
      }
    };

    var wrappedErrback = function(reason) {
      try {
        return (errback || defaultErrback)(reason);
      } catch (e) {
        exceptionHandler(e);
        return reject(e);
      }
    };

    nextTick(function() {
      ref(value).then(function(value) {
        if (done) return;
        done = true;
        result.resolve(ref(value).then(wrappedCallback, wrappedErrback));
      }, function(reason) {
        if (done) return;
        done = true;
        result.resolve(wrappedErrback(reason));
      });
    });

    return result.promise;
  };


  function defaultCallback(value) {
    return value;
  }


  function defaultErrback(reason) {
    return reject(reason);
  }


  /**
   * @ngdoc
   * @name ng.$q#all
   * @methodOf ng.$q
   * @description
   * Combines multiple promises into a single promise that is resolved when all of the input
   * promises are resolved.
   *
   * @param {Array.<Promise>} promises An array of promises.
   * @returns {Promise} Returns a single promise that will be resolved with an array of values,
   *   each value corresponding to the promise at the same index in the `promises` array. If any of
   *   the promises is resolved with a rejection, this resulting promise will be resolved with the
   *   same rejection.
   */
  function all(promises) {
    var deferred = defer(),
        counter = promises.length,
        results = [];

    if (counter) {
      forEach(promises, function(promise, index) {
        ref(promise).then(function(value) {
          if (index in results) return;
          results[index] = value;
          if (!(--counter)) deferred.resolve(results);
        }, function(reason) {
          if (index in results) return;
          deferred.reject(reason);
        });
      });
    } else {
      deferred.resolve(results);
    }

    return deferred.promise;
  }

  return {
    defer: defer,
    reject: reject,
    when: when,
    all: all
  };
}

/**
 * @ngdoc object
 * @name ng.$routeProvider
 * @function
 *
 * @description
 *
 * Used for configuring routes. See {@link ng.$route $route} for an example.
 */
function $RouteProvider(){
  var routes = {};

  /**
   * @ngdoc method
   * @name ng.$routeProvider#when
   * @methodOf ng.$routeProvider
   *
   * @param {string} path Route path (matched against `$location.path`). If `$location.path`
   *    contains redundant trailing slash or is missing one, the route will still match and the
   *    `$location.path` will be updated to add or drop the trailing slash to exactly match the
   *    route definition.
   *
   *    `path` can contain named groups starting with a colon (`:name`). All characters up to the
   *    next slash are matched and stored in `$routeParams` under the given `name` when the route
   *    matches.
   *
   * @param {Object} route Mapping information to be assigned to `$route.current` on route
   *    match.
   *
   *    Object properties:
   *
   *    - `controller` – `{(string|function()=}` – Controller fn that should be associated with newly
   *      created scope or the name of a {@link angular.Module#controller registered controller}
   *      if passed as a string.
   *    - `template` – `{string=}` –  html template as a string that should be used by
   *      {@link ng.directive:ngView ngView} or
   *      {@link ng.directive:ngInclude ngInclude} directives.
   *      this property takes precedence over `templateUrl`.
   *    - `templateUrl` – `{string=}` – path to an html template that should be used by
   *      {@link ng.directive:ngView ngView}.
   *    - `resolve` - `{Object.<string, function>=}` - An optional map of dependencies which should
   *      be injected into the controller. If any of these dependencies are promises, they will be
   *      resolved and converted to a value before the controller is instantiated and the
   *      `$routeChangeSuccess` event is fired. The map object is:
   *
   *      - `key` – `{string}`: a name of a dependency to be injected into the controller.
   *      - `factory` - `{string|function}`: If `string` then it is an alias for a service.
   *        Otherwise if function, then it is {@link api/AUTO.$injector#invoke injected}
   *        and the return value is treated as the dependency. If the result is a promise, it is resolved
   *        before its value is injected into the controller.
   *
   *    - `redirectTo` – {(string|function())=} – value to update
   *      {@link ng.$location $location} path with and trigger route redirection.
   *
   *      If `redirectTo` is a function, it will be called with the following parameters:
   *
   *      - `{Object.<string>}` - route parameters extracted from the current
   *        `$location.path()` by applying the current route templateUrl.
   *      - `{string}` - current `$location.path()`
   *      - `{Object}` - current `$location.search()`
   *
   *      The custom `redirectTo` function is expected to return a string which will be used
   *      to update `$location.path()` and `$location.search()`.
   *
   *    - `[reloadOnSearch=true]` - {boolean=} - reload route when only $location.search()
   *    changes.
   *
   *      If the option is set to `false` and url in the browser changes, then
   *      `$routeUpdate` event is broadcasted on the root scope.
   *
   * @returns {Object} self
   *
   * @description
   * Adds a new route definition to the `$route` service.
   */
  this.when = function(path, route) {
    routes[path] = extend({reloadOnSearch: true}, route);

    // create redirection for trailing slashes
    if (path) {
      var redirectPath = (path[path.length-1] == '/')
          ? path.substr(0, path.length-1)
          : path +'/';

      routes[redirectPath] = {redirectTo: path};
    }

    return this;
  };

  /**
   * @ngdoc method
   * @name ng.$routeProvider#otherwise
   * @methodOf ng.$routeProvider
   *
   * @description
   * Sets route definition that will be used on route change when no other route definition
   * is matched.
   *
   * @param {Object} params Mapping information to be assigned to `$route.current`.
   * @returns {Object} self
   */
  this.otherwise = function(params) {
    this.when(null, params);
    return this;
  };


  this.$get = ['$rootScope', '$location', '$routeParams', '$q', '$injector', '$http', '$templateCache',
      function( $rootScope,   $location,   $routeParams,   $q,   $injector,   $http,   $templateCache) {

    /**
     * @ngdoc object
     * @name ng.$route
     * @requires $location
     * @requires $routeParams
     *
     * @property {Object} current Reference to the current route definition.
     * The route definition contains:
     *
     *   - `controller`: The controller constructor as define in route definition.
     *   - `locals`: A map of locals which is used by {@link ng.$controller $controller} service for
     *     controller instantiation. The `locals` contain
     *     the resolved values of the `resolve` map. Additionally the `locals` also contain:
     *
     *     - `$scope` - The current route scope.
     *     - `$template` - The current route template HTML.
     *
     * @property {Array.<Object>} routes Array of all configured routes.
     *
     * @description
     * Is used for deep-linking URLs to controllers and views (HTML partials).
     * It watches `$location.url()` and tries to map the path to an existing route definition.
     *
     * You can define routes through {@link ng.$routeProvider $routeProvider}'s API.
     *
     * The `$route` service is typically used in conjunction with {@link ng.directive:ngView ngView}
     * directive and the {@link ng.$routeParams $routeParams} service.
     *
     * @example
       This example shows how changing the URL hash causes the `$route` to match a route against the
       URL, and the `ngView` pulls in the partial.

       Note that this example is using {@link ng.directive:script inlined templates}
       to get it working on jsfiddle as well.

     <example module="ngView">
       <file name="index.html">
         <div ng-controller="MainCntl">
           Choose:
           <a href="Book/Moby">Moby</a> |
           <a href="Book/Moby/ch/1">Moby: Ch1</a> |
           <a href="Book/Gatsby">Gatsby</a> |
           <a href="Book/Gatsby/ch/4?key=value">Gatsby: Ch4</a> |
           <a href="Book/Scarlet">Scarlet Letter</a><br/>

           <div ng-view></div>
           <hr />

           <pre>$location.path() = {{$location.path()}}</pre>
           <pre>$route.current.templateUrl = {{$route.current.templateUrl}}</pre>
           <pre>$route.current.params = {{$route.current.params}}</pre>
           <pre>$route.current.scope.name = {{$route.current.scope.name}}</pre>
           <pre>$routeParams = {{$routeParams}}</pre>
         </div>
       </file>

       <file name="book.html">
         controller: {{name}}<br />
         Book Id: {{params.bookId}}<br />
       </file>

       <file name="chapter.html">
         controller: {{name}}<br />
         Book Id: {{params.bookId}}<br />
         Chapter Id: {{params.chapterId}}
       </file>

       <file name="script.js">
         angular.module('ngView', [], function($routeProvider, $locationProvider) {
           $routeProvider.when('/Book/:bookId', {
             templateUrl: 'book.html',
             controller: BookCntl,
             resolve: {
               // I will cause a 1 second delay
               delay: function($q, $timeout) {
                 var delay = $q.defer();
                 $timeout(delay.resolve, 1000);
                 return delay.promise;
               }
             }
           });
           $routeProvider.when('/Book/:bookId/ch/:chapterId', {
             templateUrl: 'chapter.html',
             controller: ChapterCntl
           });

           // configure html5 to get links working on jsfiddle
           $locationProvider.html5Mode(true);
         });

         function MainCntl($scope, $route, $routeParams, $location) {
           $scope.$route = $route;
           $scope.$location = $location;
           $scope.$routeParams = $routeParams;
         }

         function BookCntl($scope, $routeParams) {
           $scope.name = "BookCntl";
           $scope.params = $routeParams;
         }

         function ChapterCntl($scope, $routeParams) {
           $scope.name = "ChapterCntl";
           $scope.params = $routeParams;
         }
       </file>

       <file name="scenario.js">
         it('should load and compile correct template', function() {
           element('a:contains("Moby: Ch1")').click();
           var content = element('.doc-example-live [ng-view]').text();
           expect(content).toMatch(/controller\: ChapterCntl/);
           expect(content).toMatch(/Book Id\: Moby/);
           expect(content).toMatch(/Chapter Id\: 1/);

           element('a:contains("Scarlet")').click();
           sleep(2); // promises are not part of scenario waiting
           content = element('.doc-example-live [ng-view]').text();
           expect(content).toMatch(/controller\: BookCntl/);
           expect(content).toMatch(/Book Id\: Scarlet/);
         });
       </file>
     </example>
     */

    /**
     * @ngdoc event
     * @name ng.$route#$routeChangeStart
     * @eventOf ng.$route
     * @eventType broadcast on root scope
     * @description
     * Broadcasted before a route change. At this  point the route services starts
     * resolving all of the dependencies needed for the route change to occurs.
     * Typically this involves fetching the view template as well as any dependencies
     * defined in `resolve` route property. Once  all of the dependencies are resolved
     * `$routeChangeSuccess` is fired.
     *
     * @param {Route} next Future route information.
     * @param {Route} current Current route information.
     */

    /**
     * @ngdoc event
     * @name ng.$route#$routeChangeSuccess
     * @eventOf ng.$route
     * @eventType broadcast on root scope
     * @description
     * Broadcasted after a route dependencies are resolved.
     * {@link ng.directive:ngView ngView} listens for the directive
     * to instantiate the controller and render the view.
     *
     * @param {Object} angularEvent Synthetic event object.
     * @param {Route} current Current route information.
     * @param {Route|Undefined} previous Previous route information, or undefined if current is first route entered.
     */

    /**
     * @ngdoc event
     * @name ng.$route#$routeChangeError
     * @eventOf ng.$route
     * @eventType broadcast on root scope
     * @description
     * Broadcasted if any of the resolve promises are rejected.
     *
     * @param {Route} current Current route information.
     * @param {Route} previous Previous route information.
     * @param {Route} rejection Rejection of the promise. Usually the error of the failed promise.
     */

    /**
     * @ngdoc event
     * @name ng.$route#$routeUpdate
     * @eventOf ng.$route
     * @eventType broadcast on root scope
     * @description
     *
     * The `reloadOnSearch` property has been set to false, and we are reusing the same
     * instance of the Controller.
     */

    var forceReload = false,
        $route = {
          routes: routes,

          /**
           * @ngdoc method
           * @name ng.$route#reload
           * @methodOf ng.$route
           *
           * @description
           * Causes `$route` service to reload the current route even if
           * {@link ng.$location $location} hasn't changed.
           *
           * As a result of that, {@link ng.directive:ngView ngView}
           * creates new scope, reinstantiates the controller.
           */
          reload: function() {
            forceReload = true;
            $rootScope.$evalAsync(updateRoute);
          }
        };

    $rootScope.$on('$locationChangeSuccess', updateRoute);

    return $route;

    /////////////////////////////////////////////////////

    /**
     * @param on {string} current url
     * @param when {string} route when template to match the url against
     * @return {?Object}
     */
    function switchRouteMatcher(on, when) {
      // TODO(i): this code is convoluted and inefficient, we should construct the route matching
      //   regex only once and then reuse it

      // Escape regexp special characters.
      when = '^' + when.replace(/[-\/\\^$*+?.()|[\]{}]/g, "\\$&") + '$';
      var regex = '',
          params = [],
          dst = {};

      var re = /:(\w+)/g,
          paramMatch,
          lastMatchedIndex = 0;

      while ((paramMatch = re.exec(when)) !== null) {
        // Find each :param in `when` and replace it with a capturing group.
        // Append all other sections of when unchanged.
        regex += when.slice(lastMatchedIndex, paramMatch.index);
        regex += '([^\\/]*)';
        params.push(paramMatch[1]);
        lastMatchedIndex = re.lastIndex;
      }
      // Append trailing path part.
      regex += when.substr(lastMatchedIndex);

      var match = on.match(new RegExp(regex));
      if (match) {
        forEach(params, function(name, index) {
          dst[name] = match[index + 1];
        });
      }
      return match ? dst : null;
    }

    function updateRoute() {
      var next = parseRoute(),
          last = $route.current;

      if (next && last && next.$$route === last.$$route
          && equals(next.pathParams, last.pathParams) && !next.reloadOnSearch && !forceReload) {
        last.params = next.params;
        copy(last.params, $routeParams);
        $rootScope.$broadcast('$routeUpdate', last);
      } else if (next || last) {
        forceReload = false;
        $rootScope.$broadcast('$routeChangeStart', next, last);
        $route.current = next;
        if (next) {
          if (next.redirectTo) {
            if (isString(next.redirectTo)) {
              $location.path(interpolate(next.redirectTo, next.params)).search(next.params)
                       .replace();
            } else {
              $location.url(next.redirectTo(next.pathParams, $location.path(), $location.search()))
                       .replace();
            }
          }
        }

        $q.when(next).
          then(function() {
            if (next) {
              var keys = [],
                  values = [],
                  template;

              forEach(next.resolve || {}, function(value, key) {
                keys.push(key);
                values.push(isString(value) ? $injector.get(value) : $injector.invoke(value));
              });
              if (isDefined(template = next.template)) {
              } else if (isDefined(template = next.templateUrl)) {
                template = $http.get(template, {cache: $templateCache}).
                    then(function(response) { return response.data; });
              }
              if (isDefined(template)) {
                keys.push('$template');
                values.push(template);
              }
              return $q.all(values).then(function(values) {
                var locals = {};
                forEach(values, function(value, index) {
                  locals[keys[index]] = value;
                });
                return locals;
              });
            }
          }).
          // after route change
          then(function(locals) {
            if (next == $route.current) {
              if (next) {
                next.locals = locals;
                copy(next.params, $routeParams);
              }
              $rootScope.$broadcast('$routeChangeSuccess', next, last);
            }
          }, function(error) {
            if (next == $route.current) {
              $rootScope.$broadcast('$routeChangeError', next, last, error);
            }
          });
      }
    }


    /**
     * @returns the current active route, by matching it against the URL
     */
    function parseRoute() {
      // Match a route
      var params, match;
      forEach(routes, function(route, path) {
        if (!match && (params = switchRouteMatcher($location.path(), path))) {
          match = inherit(route, {
            params: extend({}, $location.search(), params),
            pathParams: params});
          match.$$route = route;
        }
      });
      // No route matched; fallback to "otherwise" route
      return match || routes[null] && inherit(routes[null], {params: {}, pathParams:{}});
    }

    /**
     * @returns interpolation of the redirect path with the parametrs
     */
    function interpolate(string, params) {
      var result = [];
      forEach((string||'').split(':'), function(segment, i) {
        if (i == 0) {
          result.push(segment);
        } else {
          var segmentMatch = segment.match(/(\w+)(.*)/);
          var key = segmentMatch[1];
          result.push(params[key]);
          result.push(segmentMatch[2] || '');
          delete params[key];
        }
      });
      return result.join('');
    }
  }];
}

/**
 * @ngdoc object
 * @name ng.$routeParams
 * @requires $route
 *
 * @description
 * Current set of route parameters. The route parameters are a combination of the
 * {@link ng.$location $location} `search()`, and `path()`. The `path` parameters
 * are extracted when the {@link ng.$route $route} path is matched.
 *
 * In case of parameter name collision, `path` params take precedence over `search` params.
 *
 * The service guarantees that the identity of the `$routeParams` object will remain unchanged
 * (but its properties will likely change) even when a route change occurs.
 *
 * @example
 * <pre>
 *  // Given:
 *  // URL: http://server.com/index.html#/Chapter/1/Section/2?search=moby
 *  // Route: /Chapter/:chapterId/Section/:sectionId
 *  //
 *  // Then
 *  $routeParams ==> {chapterId:1, sectionId:2, search:'moby'}
 * </pre>
 */
function $RouteParamsProvider() {
  this.$get = valueFn({});
}

/**
 * DESIGN NOTES
 *
 * The design decisions behind the scope are heavily favored for speed and memory consumption.
 *
 * The typical use of scope is to watch the expressions, which most of the time return the same
 * value as last time so we optimize the operation.
 *
 * Closures construction is expensive in terms of speed as well as memory:
 *   - No closures, instead use prototypical inheritance for API
 *   - Internal state needs to be stored on scope directly, which means that private state is
 *     exposed as $$____ properties
 *
 * Loop operations are optimized by using while(count--) { ... }
 *   - this means that in order to keep the same order of execution as addition we have to add
 *     items to the array at the beginning (shift) instead of at the end (push)
 *
 * Child scopes are created and removed often
 *   - Using an array would be slow since inserts in middle are expensive so we use linked list
 *
 * There are few watches then a lot of observers. This is why you don't want the observer to be
 * implemented in the same way as watch. Watch requires return of initialization function which
 * are expensive to construct.
 */


/**
 * @ngdoc object
 * @name ng.$rootScopeProvider
 * @description
 *
 * Provider for the $rootScope service.
 */

/**
 * @ngdoc function
 * @name ng.$rootScopeProvider#digestTtl
 * @methodOf ng.$rootScopeProvider
 * @description
 *
 * Sets the number of digest iterations the scope should attempt to execute before giving up and
 * assuming that the model is unstable.
 *
 * The current default is 10 iterations.
 *
 * @param {number} limit The number of digest iterations.
 */


/**
 * @ngdoc object
 * @name ng.$rootScope
 * @description
 *
 * Every application has a single root {@link ng.$rootScope.Scope scope}.
 * All other scopes are child scopes of the root scope. Scopes provide mechanism for watching the model and provide
 * event processing life-cycle. See {@link guide/scope developer guide on scopes}.
 */
function $RootScopeProvider(){
  var TTL = 10;

  this.digestTtl = function(value) {
    if (arguments.length) {
      TTL = value;
    }
    return TTL;
  };

  this.$get = ['$injector', '$exceptionHandler', '$parse',
      function( $injector,   $exceptionHandler,   $parse) {

    /**
     * @ngdoc function
     * @name ng.$rootScope.Scope
     *
     * @description
     * A root scope can be retrieved using the {@link ng.$rootScope $rootScope} key from the
     * {@link AUTO.$injector $injector}. Child scopes are created using the
     * {@link ng.$rootScope.Scope#$new $new()} method. (Most scopes are created automatically when
     * compiled HTML template is executed.)
     *
     * Here is a simple scope snippet to show how you can interact with the scope.
     * <pre>
        angular.injector(['ng']).invoke(function($rootScope) {
           var scope = $rootScope.$new();
           scope.salutation = 'Hello';
           scope.name = 'World';

           expect(scope.greeting).toEqual(undefined);

           scope.$watch('name', function() {
             scope.greeting = scope.salutation + ' ' + scope.name + '!';
           }); // initialize the watch

           expect(scope.greeting).toEqual(undefined);
           scope.name = 'Misko';
           // still old value, since watches have not been called yet
           expect(scope.greeting).toEqual(undefined);

           scope.$digest(); // fire all  the watches
           expect(scope.greeting).toEqual('Hello Misko!');
        });
     * </pre>
     *
     * # Inheritance
     * A scope can inherit from a parent scope, as in this example:
     * <pre>
         var parent = $rootScope;
         var child = parent.$new();

         parent.salutation = "Hello";
         child.name = "World";
         expect(child.salutation).toEqual('Hello');

         child.salutation = "Welcome";
         expect(child.salutation).toEqual('Welcome');
         expect(parent.salutation).toEqual('Hello');
     * </pre>
     *
     *
     * @param {Object.<string, function()>=} providers Map of service factory which need to be provided
     *     for the current scope. Defaults to {@link ng}.
     * @param {Object.<string, *>=} instanceCache Provides pre-instantiated services which should
     *     append/override services provided by `providers`. This is handy when unit-testing and having
     *     the need to override a default service.
     * @returns {Object} Newly created scope.
     *
     */
    function Scope() {
      this.$id = nextUid();
      this.$$phase = this.$parent = this.$$watchers =
                     this.$$nextSibling = this.$$prevSibling =
                     this.$$childHead = this.$$childTail = null;
      this['this'] = this.$root =  this;
      this.$$destroyed = false;
      this.$$asyncQueue = [];
      this.$$listeners = {};
      this.$$isolateBindings = {};
    }

    /**
     * @ngdoc property
     * @name ng.$rootScope.Scope#$id
     * @propertyOf ng.$rootScope.Scope
     * @returns {number} Unique scope ID (monotonically increasing alphanumeric sequence) useful for
     *   debugging.
     */


    Scope.prototype = {
      /**
       * @ngdoc function
       * @name ng.$rootScope.Scope#$new
       * @methodOf ng.$rootScope.Scope
       * @function
       *
       * @description
       * Creates a new child {@link ng.$rootScope.Scope scope}.
       *
       * The parent scope will propagate the {@link ng.$rootScope.Scope#$digest $digest()} and
       * {@link ng.$rootScope.Scope#$digest $digest()} events. The scope can be removed from the scope
       * hierarchy using {@link ng.$rootScope.Scope#$destroy $destroy()}.
       *
       * {@link ng.$rootScope.Scope#$destroy $destroy()} must be called on a scope when it is desired for
       * the scope and its child scopes to be permanently detached from the parent and thus stop
       * participating in model change detection and listener notification by invoking.
       *
       * @param {boolean} isolate if true then the scope does not prototypically inherit from the
       *         parent scope. The scope is isolated, as it can not see parent scope properties.
       *         When creating widgets it is useful for the widget to not accidentally read parent
       *         state.
       *
       * @returns {Object} The newly created child scope.
       *
       */
      $new: function(isolate) {
        var Child,
            child;

        if (isFunction(isolate)) {
          // TODO: remove at some point
          throw Error('API-CHANGE: Use $controller to instantiate controllers.');
        }
        if (isolate) {
          child = new Scope();
          child.$root = this.$root;
        } else {
          Child = function() {}; // should be anonymous; This is so that when the minifier munges
            // the name it does not become random set of chars. These will then show up as class
            // name in the debugger.
          Child.prototype = this;
          child = new Child();
          child.$id = nextUid();
        }
        child['this'] = child;
        child.$$listeners = {};
        child.$parent = this;
        child.$$asyncQueue = [];
        child.$$watchers = child.$$nextSibling = child.$$childHead = child.$$childTail = null;
        child.$$prevSibling = this.$$childTail;
        if (this.$$childHead) {
          this.$$childTail.$$nextSibling = child;
          this.$$childTail = child;
        } else {
          this.$$childHead = this.$$childTail = child;
        }
        return child;
      },

      /**
       * @ngdoc function
       * @name ng.$rootScope.Scope#$watch
       * @methodOf ng.$rootScope.Scope
       * @function
       *
       * @description
       * Registers a `listener` callback to be executed whenever the `watchExpression` changes.
       *
       * - The `watchExpression` is called on every call to {@link ng.$rootScope.Scope#$digest $digest()} and
       *   should return the value which will be watched. (Since {@link ng.$rootScope.Scope#$digest $digest()}
       *   reruns when it detects changes the `watchExpression` can execute multiple times per
       *   {@link ng.$rootScope.Scope#$digest $digest()} and should be idempotent.)
       * - The `listener` is called only when the value from the current `watchExpression` and the
       *   previous call to `watchExpression` are not equal (with the exception of the initial run,
       *   see below). The inequality is determined according to
       *   {@link angular.equals} function. To save the value of the object for later comparison, the
       *   {@link angular.copy} function is used. It also means that watching complex options will
       *   have adverse memory and performance implications.
       * - The watch `listener` may change the model, which may trigger other `listener`s to fire. This
       *   is achieved by rerunning the watchers until no changes are detected. The rerun iteration
       *   limit is 10 to prevent an infinite loop deadlock.
       *
       *
       * If you want to be notified whenever {@link ng.$rootScope.Scope#$digest $digest} is called,
       * you can register a `watchExpression` function with no `listener`. (Since `watchExpression`
       * can execute multiple times per {@link ng.$rootScope.Scope#$digest $digest} cycle when a change is
       * detected, be prepared for multiple calls to your listener.)
       *
       * After a watcher is registered with the scope, the `listener` fn is called asynchronously
       * (via {@link ng.$rootScope.Scope#$evalAsync $evalAsync}) to initialize the
       * watcher. In rare cases, this is undesirable because the listener is called when the result
       * of `watchExpression` didn't change. To detect this scenario within the `listener` fn, you
       * can compare the `newVal` and `oldVal`. If these two values are identical (`===`) then the
       * listener was called due to initialization.
       *
       *
       * # Example
       * <pre>
           // let's assume that scope was dependency injected as the $rootScope
           var scope = $rootScope;
           scope.name = 'misko';
           scope.counter = 0;

           expect(scope.counter).toEqual(0);
           scope.$watch('name', function(newValue, oldValue) { scope.counter = scope.counter + 1; });
           expect(scope.counter).toEqual(0);

           scope.$digest();
           // no variable change
           expect(scope.counter).toEqual(0);

           scope.name = 'adam';
           scope.$digest();
           expect(scope.counter).toEqual(1);
       * </pre>
       *
       *
       *
       * @param {(function()|string)} watchExpression Expression that is evaluated on each
       *    {@link ng.$rootScope.Scope#$digest $digest} cycle. A change in the return value triggers a
       *    call to the `listener`.
       *
       *    - `string`: Evaluated as {@link guide/expression expression}
       *    - `function(scope)`: called with current `scope` as a parameter.
       * @param {(function()|string)=} listener Callback called whenever the return value of
       *   the `watchExpression` changes.
       *
       *    - `string`: Evaluated as {@link guide/expression expression}
       *    - `function(newValue, oldValue, scope)`: called with current and previous values as parameters.
       *
       * @param {boolean=} objectEquality Compare object for equality rather than for reference.
       * @returns {function()} Returns a deregistration function for this listener.
       */
      $watch: function(watchExp, listener, objectEquality) {
        var scope = this,
            get = compileToFn(watchExp, 'watch'),
            array = scope.$$watchers,
            watcher = {
              fn: listener,
              last: initWatchVal,
              get: get,
              exp: watchExp,
              eq: !!objectEquality
            };

        // in the case user pass string, we need to compile it, do we really need this ?
        if (!isFunction(listener)) {
          var listenFn = compileToFn(listener || noop, 'listener');
          watcher.fn = function(newVal, oldVal, scope) {listenFn(scope);};
        }

        if (!array) {
          array = scope.$$watchers = [];
        }
        // we use unshift since we use a while loop in $digest for speed.
        // the while loop reads in reverse order.
        array.unshift(watcher);

        return function() {
          arrayRemove(array, watcher);
        };
      },

      /**
       * @ngdoc function
       * @name ng.$rootScope.Scope#$digest
       * @methodOf ng.$rootScope.Scope
       * @function
       *
       * @description
       * Processes all of the {@link ng.$rootScope.Scope#$watch watchers} of the current scope and its children.
       * Because a {@link ng.$rootScope.Scope#$watch watcher}'s listener can change the model, the
       * `$digest()` keeps calling the {@link ng.$rootScope.Scope#$watch watchers} until no more listeners are
       * firing. This means that it is possible to get into an infinite loop. This function will throw
       * `'Maximum iteration limit exceeded.'` if the number of iterations exceeds 10.
       *
       * Usually you don't call `$digest()` directly in
       * {@link ng.directive:ngController controllers} or in
       * {@link ng.$compileProvider#directive directives}.
       * Instead a call to {@link ng.$rootScope.Scope#$apply $apply()} (typically from within a
       * {@link ng.$compileProvider#directive directives}) will force a `$digest()`.
       *
       * If you want to be notified whenever `$digest()` is called,
       * you can register a `watchExpression` function  with {@link ng.$rootScope.Scope#$watch $watch()}
       * with no `listener`.
       *
       * You may have a need to call `$digest()` from within unit-tests, to simulate the scope
       * life-cycle.
       *
       * # Example
       * <pre>
           var scope = ...;
           scope.name = 'misko';
           scope.counter = 0;

           expect(scope.counter).toEqual(0);
           scope.$watch('name', function(newValue, oldValue) {
             scope.counter = scope.counter + 1;
           });
           expect(scope.counter).toEqual(0);

           scope.$digest();
           // no variable change
           expect(scope.counter).toEqual(0);

           scope.name = 'adam';
           scope.$digest();
           expect(scope.counter).toEqual(1);
       * </pre>
       *
       */
      $digest: function() {
        var watch, value, last,
            watchers,
            asyncQueue,
            length,
            dirty, ttl = TTL,
            next, current, target = this,
            watchLog = [],
            logIdx, logMsg;

        beginPhase('$digest');

        do {
          dirty = false;
          current = target;
          do {
            asyncQueue = current.$$asyncQueue;
            while(asyncQueue.length) {
              try {
                current.$eval(asyncQueue.shift());
              } catch (e) {
                $exceptionHandler(e);
              }
            }
            if ((watchers = current.$$watchers)) {
              // process our watches
              length = watchers.length;
              while (length--) {
                try {
                  watch = watchers[length];
                  // Most common watches are on primitives, in which case we can short
                  // circuit it with === operator, only when === fails do we use .equals
                  if ((value = watch.get(current)) !== (last = watch.last) &&
                      !(watch.eq
                          ? equals(value, last)
                          : (typeof value == 'number' && typeof last == 'number'
                             && isNaN(value) && isNaN(last)))) {
                    dirty = true;
                    watch.last = watch.eq ? copy(value) : value;
                    watch.fn(value, ((last === initWatchVal) ? value : last), current);
                    if (ttl < 5) {
                      logIdx = 4 - ttl;
                      if (!watchLog[logIdx]) watchLog[logIdx] = [];
                      logMsg = (isFunction(watch.exp))
                          ? 'fn: ' + (watch.exp.name || watch.exp.toString())
                          : watch.exp;
                      logMsg += '; newVal: ' + toJson(value) + '; oldVal: ' + toJson(last);
                      watchLog[logIdx].push(logMsg);
                    }
                  }
                } catch (e) {
                  $exceptionHandler(e);
                }
              }
            }

            // Insanity Warning: scope depth-first traversal
            // yes, this code is a bit crazy, but it works and we have tests to prove it!
            // this piece should be kept in sync with the traversal in $broadcast
            if (!(next = (current.$$childHead || (current !== target && current.$$nextSibling)))) {
              while(current !== target && !(next = current.$$nextSibling)) {
                current = current.$parent;
              }
            }
          } while ((current = next));

          if(dirty && !(ttl--)) {
            clearPhase();
            throw Error(TTL + ' $digest() iterations reached. Aborting!\n' +
                'Watchers fired in the last 5 iterations: ' + toJson(watchLog));
          }
        } while (dirty || asyncQueue.length);

        clearPhase();
      },


      /**
       * @ngdoc event
       * @name ng.$rootScope.Scope#$destroy
       * @eventOf ng.$rootScope.Scope
       * @eventType broadcast on scope being destroyed
       *
       * @description
       * Broadcasted when a scope and its children are being destroyed.
       */

      /**
       * @ngdoc function
       * @name ng.$rootScope.Scope#$destroy
       * @methodOf ng.$rootScope.Scope
       * @function
       *
       * @description
       * Removes the current scope (and all of its children) from the parent scope. Removal implies
       * that calls to {@link ng.$rootScope.Scope#$digest $digest()} will no longer
       * propagate to the current scope and its children. Removal also implies that the current
       * scope is eligible for garbage collection.
       *
       * The `$destroy()` is usually used by directives such as
       * {@link ng.directive:ngRepeat ngRepeat} for managing the
       * unrolling of the loop.
       *
       * Just before a scope is destroyed a `$destroy` event is broadcasted on this scope.
       * Application code can register a `$destroy` event handler that will give it chance to
       * perform any necessary cleanup.
       */
      $destroy: function() {
        // we can't destroy the root scope or a scope that has been already destroyed
        if ($rootScope == this || this.$$destroyed) return;
        var parent = this.$parent;

        this.$broadcast('$destroy');
        this.$$destroyed = true;

        if (parent.$$childHead == this) parent.$$childHead = this.$$nextSibling;
        if (parent.$$childTail == this) parent.$$childTail = this.$$prevSibling;
        if (this.$$prevSibling) this.$$prevSibling.$$nextSibling = this.$$nextSibling;
        if (this.$$nextSibling) this.$$nextSibling.$$prevSibling = this.$$prevSibling;

        // This is bogus code that works around Chrome's GC leak
        // see: https://github.com/angular/angular.js/issues/1313#issuecomment-10378451
        this.$parent = this.$$nextSibling = this.$$prevSibling = this.$$childHead =
            this.$$childTail = null;
      },

      /**
       * @ngdoc function
       * @name ng.$rootScope.Scope#$eval
       * @methodOf ng.$rootScope.Scope
       * @function
       *
       * @description
       * Executes the `expression` on the current scope returning the result. Any exceptions in the
       * expression are propagated (uncaught). This is useful when evaluating Angular expressions.
       *
       * # Example
       * <pre>
           var scope = ng.$rootScope.Scope();
           scope.a = 1;
           scope.b = 2;

           expect(scope.$eval('a+b')).toEqual(3);
           expect(scope.$eval(function(scope){ return scope.a + scope.b; })).toEqual(3);
       * </pre>
       *
       * @param {(string|function())=} expression An angular expression to be executed.
       *
       *    - `string`: execute using the rules as defined in  {@link guide/expression expression}.
       *    - `function(scope)`: execute the function with the current `scope` parameter.
       *
       * @returns {*} The result of evaluating the expression.
       */
      $eval: function(expr, locals) {
        return $parse(expr)(this, locals);
      },

      /**
       * @ngdoc function
       * @name ng.$rootScope.Scope#$evalAsync
       * @methodOf ng.$rootScope.Scope
       * @function
       *
       * @description
       * Executes the expression on the current scope at a later point in time.
       *
       * The `$evalAsync` makes no guarantees as to when the `expression` will be executed, only that:
       *
       *   - it will execute in the current script execution context (before any DOM rendering).
       *   - at least one {@link ng.$rootScope.Scope#$digest $digest cycle} will be performed after
       *     `expression` execution.
       *
       * Any exceptions from the execution of the expression are forwarded to the
       * {@link ng.$exceptionHandler $exceptionHandler} service.
       *
       * @param {(string|function())=} expression An angular expression to be executed.
       *
       *    - `string`: execute using the rules as defined in  {@link guide/expression expression}.
       *    - `function(scope)`: execute the function with the current `scope` parameter.
       *
       */
      $evalAsync: function(expr) {
        this.$$asyncQueue.push(expr);
      },

      /**
       * @ngdoc function
       * @name ng.$rootScope.Scope#$apply
       * @methodOf ng.$rootScope.Scope
       * @function
       *
       * @description
       * `$apply()` is used to execute an expression in angular from outside of the angular framework.
       * (For example from browser DOM events, setTimeout, XHR or third party libraries).
       * Because we are calling into the angular framework we need to perform proper scope life-cycle
       * of {@link ng.$exceptionHandler exception handling},
       * {@link ng.$rootScope.Scope#$digest executing watches}.
       *
       * ## Life cycle
       *
       * # Pseudo-Code of `$apply()`
       * <pre>
           function $apply(expr) {
             try {
               return $eval(expr);
             } catch (e) {
               $exceptionHandler(e);
             } finally {
               $root.$digest();
             }
           }
       * </pre>
       *
       *
       * Scope's `$apply()` method transitions through the following stages:
       *
       * 1. The {@link guide/expression expression} is executed using the
       *    {@link ng.$rootScope.Scope#$eval $eval()} method.
       * 2. Any exceptions from the execution of the expression are forwarded to the
       *    {@link ng.$exceptionHandler $exceptionHandler} service.
       * 3. The {@link ng.$rootScope.Scope#$watch watch} listeners are fired immediately after the expression
       *    was executed using the {@link ng.$rootScope.Scope#$digest $digest()} method.
       *
       *
       * @param {(string|function())=} exp An angular expression to be executed.
       *
       *    - `string`: execute using the rules as defined in {@link guide/expression expression}.
       *    - `function(scope)`: execute the function with current `scope` parameter.
       *
       * @returns {*} The result of evaluating the expression.
       */
      $apply: function(expr) {
        try {
          beginPhase('$apply');
          return this.$eval(expr);
        } catch (e) {
          $exceptionHandler(e);
        } finally {
          clearPhase();
          try {
            $rootScope.$digest();
          } catch (e) {
            $exceptionHandler(e);
            throw e;
          }
        }
      },

      /**
       * @ngdoc function
       * @name ng.$rootScope.Scope#$on
       * @methodOf ng.$rootScope.Scope
       * @function
       *
       * @description
       * Listens on events of a given type. See {@link ng.$rootScope.Scope#$emit $emit} for discussion of
       * event life cycle.
       *
       * The event listener function format is: `function(event, args...)`. The `event` object
       * passed into the listener has the following attributes:
       *
       *   - `targetScope` - `{Scope}`: the scope on which the event was `$emit`-ed or `$broadcast`-ed.
       *   - `currentScope` - `{Scope}`: the current scope which is handling the event.
       *   - `name` - `{string}`: Name of the event.
       *   - `stopPropagation` - `{function=}`: calling `stopPropagation` function will cancel further event
       *     propagation (available only for events that were `$emit`-ed).
       *   - `preventDefault` - `{function}`: calling `preventDefault` sets `defaultPrevented` flag to true.
       *   - `defaultPrevented` - `{boolean}`: true if `preventDefault` was called.
       *
       * @param {string} name Event name to listen on.
       * @param {function(event, args...)} listener Function to call when the event is emitted.
       * @returns {function()} Returns a deregistration function for this listener.
       */
      $on: function(name, listener) {
        var namedListeners = this.$$listeners[name];
        if (!namedListeners) {
          this.$$listeners[name] = namedListeners = [];
        }
        namedListeners.push(listener);

        return function() {
          namedListeners[indexOf(namedListeners, listener)] = null;
        };
      },


      /**
       * @ngdoc function
       * @name ng.$rootScope.Scope#$emit
       * @methodOf ng.$rootScope.Scope
       * @function
       *
       * @description
       * Dispatches an event `name` upwards through the scope hierarchy notifying the
       * registered {@link ng.$rootScope.Scope#$on} listeners.
       *
       * The event life cycle starts at the scope on which `$emit` was called. All
       * {@link ng.$rootScope.Scope#$on listeners} listening for `name` event on this scope get notified.
       * Afterwards, the event traverses upwards toward the root scope and calls all registered
       * listeners along the way. The event will stop propagating if one of the listeners cancels it.
       *
       * Any exception emitted from the {@link ng.$rootScope.Scope#$on listeners} will be passed
       * onto the {@link ng.$exceptionHandler $exceptionHandler} service.
       *
       * @param {string} name Event name to emit.
       * @param {...*} args Optional set of arguments which will be passed onto the event listeners.
       * @return {Object} Event object, see {@link ng.$rootScope.Scope#$on}
       */
      $emit: function(name, args) {
        var empty = [],
            namedListeners,
            scope = this,
            stopPropagation = false,
            event = {
              name: name,
              targetScope: scope,
              stopPropagation: function() {stopPropagation = true;},
              preventDefault: function() {
                event.defaultPrevented = true;
              },
              defaultPrevented: false
            },
            listenerArgs = concat([event], arguments, 1),
            i, length;

        do {
          namedListeners = scope.$$listeners[name] || empty;
          event.currentScope = scope;
          for (i=0, length=namedListeners.length; i<length; i++) {

            // if listeners were deregistered, defragment the array
            if (!namedListeners[i]) {
              namedListeners.splice(i, 1);
              i--;
              length--;
              continue;
            }
            try {
              namedListeners[i].apply(null, listenerArgs);
              if (stopPropagation) return event;
            } catch (e) {
              $exceptionHandler(e);
            }
          }
          //traverse upwards
          scope = scope.$parent;
        } while (scope);

        return event;
      },


      /**
       * @ngdoc function
       * @name ng.$rootScope.Scope#$broadcast
       * @methodOf ng.$rootScope.Scope
       * @function
       *
       * @description
       * Dispatches an event `name` downwards to all child scopes (and their children) notifying the
       * registered {@link ng.$rootScope.Scope#$on} listeners.
       *
       * The event life cycle starts at the scope on which `$broadcast` was called. All
       * {@link ng.$rootScope.Scope#$on listeners} listening for `name` event on this scope get notified.
       * Afterwards, the event propagates to all direct and indirect scopes of the current scope and
       * calls all registered listeners along the way. The event cannot be canceled.
       *
       * Any exception emmited from the {@link ng.$rootScope.Scope#$on listeners} will be passed
       * onto the {@link ng.$exceptionHandler $exceptionHandler} service.
       *
       * @param {string} name Event name to broadcast.
       * @param {...*} args Optional set of arguments which will be passed onto the event listeners.
       * @return {Object} Event object, see {@link ng.$rootScope.Scope#$on}
       */
      $broadcast: function(name, args) {
        var target = this,
            current = target,
            next = target,
            event = {
              name: name,
              targetScope: target,
              preventDefault: function() {
                event.defaultPrevented = true;
              },
              defaultPrevented: false
            },
            listenerArgs = concat([event], arguments, 1),
            listeners, i, length;

        //down while you can, then up and next sibling or up and next sibling until back at root
        do {
          current = next;
          event.currentScope = current;
          listeners = current.$$listeners[name] || [];
          for (i=0, length = listeners.length; i<length; i++) {
            // if listeners were deregistered, defragment the array
            if (!listeners[i]) {
              listeners.splice(i, 1);
              i--;
              length--;
              continue;
            }

            try {
              listeners[i].apply(null, listenerArgs);
            } catch(e) {
              $exceptionHandler(e);
            }
          }

          // Insanity Warning: scope depth-first traversal
          // yes, this code is a bit crazy, but it works and we have tests to prove it!
          // this piece should be kept in sync with the traversal in $digest
          if (!(next = (current.$$childHead || (current !== target && current.$$nextSibling)))) {
            while(current !== target && !(next = current.$$nextSibling)) {
              current = current.$parent;
            }
          }
        } while ((current = next));

        return event;
      }
    };

    var $rootScope = new Scope();

    return $rootScope;


    function beginPhase(phase) {
      if ($rootScope.$$phase) {
        throw Error($rootScope.$$phase + ' already in progress');
      }

      $rootScope.$$phase = phase;
    }

    function clearPhase() {
      $rootScope.$$phase = null;
    }

    function compileToFn(exp, name) {
      var fn = $parse(exp);
      assertArgFn(fn, name);
      return fn;
    }

    /**
     * function used as an initial value for watchers.
     * because it's unique we can easily tell it apart from other values
     */
    function initWatchVal() {}
  }];
}

/**
 * !!! This is an undocumented "private" service !!!
 *
 * @name ng.$sniffer
 * @requires $window
 *
 * @property {boolean} history Does the browser support html5 history api ?
 * @property {boolean} hashchange Does the browser support hashchange event ?
 *
 * @description
 * This is very simple implementation of testing browser's features.
 */
function $SnifferProvider() {
  this.$get = ['$window', function($window) {
    var eventSupport = {},
        android = int((/android (\d+)/.exec(lowercase($window.navigator.userAgent)) || [])[1]);

    return {
      // Android has history.pushState, but it does not update location correctly
      // so let's not use the history API at all.
      // http://code.google.com/p/android/issues/detail?id=17471
      // https://github.com/angular/angular.js/issues/904
      history: !!($window.history && $window.history.pushState && !(android < 4)),
      hashchange: 'onhashchange' in $window &&
                  // IE8 compatible mode lies
                  (!$window.document.documentMode || $window.document.documentMode > 7),
      hasEvent: function(event) {
        // IE9 implements 'input' event it's so fubared that we rather pretend that it doesn't have
        // it. In particular the event is not fired when backspace or delete key are pressed or
        // when cut operation is performed.
        if (event == 'input' && msie == 9) return false;

        if (isUndefined(eventSupport[event])) {
          var divElm = $window.document.createElement('div');
          eventSupport[event] = 'on' + event in divElm;
        }

        return eventSupport[event];
      },
      // TODO(i): currently there is no way to feature detect CSP without triggering alerts
      csp: false
    };
  }];
}

/**
 * @ngdoc object
 * @name ng.$window
 *
 * @description
 * A reference to the browser's `window` object. While `window`
 * is globally available in JavaScript, it causes testability problems, because
 * it is a global variable. In angular we always refer to it through the
 * `$window` service, so it may be overriden, removed or mocked for testing.
 *
 * All expressions are evaluated with respect to current scope so they don't
 * suffer from window globality.
 *
 * @example
   <doc:example>
     <doc:source>
       <script>
         function Ctrl($scope, $window) {
           $scope.$window = $window;
           $scope.greeting = 'Hello, World!';
         }
       </script>
       <div ng-controller="Ctrl">
         <input type="text" ng-model="greeting" />
         <button ng-click="$window.alert(greeting)">ALERT</button>
       </div>
     </doc:source>
     <doc:scenario>
      it('should display the greeting in the input box', function() {
       input('greeting').enter('Hello, E2E Tests');
       // If we click the button it will block the test runner
       // element(':button').click();
      });
     </doc:scenario>
   </doc:example>
 */
function $WindowProvider(){
  this.$get = valueFn(window);
}

/**
 * Parse headers into key value object
 *
 * @param {string} headers Raw headers as a string
 * @returns {Object} Parsed headers as key value object
 */
function parseHeaders(headers) {
  var parsed = {}, key, val, i;

  if (!headers) return parsed;

  forEach(headers.split('\n'), function(line) {
    i = line.indexOf(':');
    key = lowercase(trim(line.substr(0, i)));
    val = trim(line.substr(i + 1));

    if (key) {
      if (parsed[key]) {
        parsed[key] += ', ' + val;
      } else {
        parsed[key] = val;
      }
    }
  });

  return parsed;
}


/**
 * Returns a function that provides access to parsed headers.
 *
 * Headers are lazy parsed when first requested.
 * @see parseHeaders
 *
 * @param {(string|Object)} headers Headers to provide access to.
 * @returns {function(string=)} Returns a getter function which if called with:
 *
 *   - if called with single an argument returns a single header value or null
 *   - if called with no arguments returns an object containing all headers.
 */
function headersGetter(headers) {
  var headersObj = isObject(headers) ? headers : undefined;

  return function(name) {
    if (!headersObj) headersObj =  parseHeaders(headers);

    if (name) {
      return headersObj[lowercase(name)] || null;
    }

    return headersObj;
  };
}


/**
 * Chain all given functions
 *
 * This function is used for both request and response transforming
 *
 * @param {*} data Data to transform.
 * @param {function(string=)} headers Http headers getter fn.
 * @param {(function|Array.<function>)} fns Function or an array of functions.
 * @returns {*} Transformed data.
 */
function transformData(data, headers, fns) {
  if (isFunction(fns))
    return fns(data, headers);

  forEach(fns, function(fn) {
    data = fn(data, headers);
  });

  return data;
}


function isSuccess(status) {
  return 200 <= status && status < 300;
}


function $HttpProvider() {
  var JSON_START = /^\s*(\[|\{[^\{])/,
      JSON_END = /[\}\]]\s*$/,
      PROTECTION_PREFIX = /^\)\]\}',?\n/;

  var $config = this.defaults = {
    // transform incoming response data
    transformResponse: [function(data) {
      if (isString(data)) {
        // strip json vulnerability protection prefix
        data = data.replace(PROTECTION_PREFIX, '');
        if (JSON_START.test(data) && JSON_END.test(data))
          data = fromJson(data, true);
      }
      return data;
    }],

    // transform outgoing request data
    transformRequest: [function(d) {
      return isObject(d) && !isFile(d) ? toJson(d) : d;
    }],

    // default headers
    headers: {
      common: {
        'Accept': 'application/json, text/plain, */*',
        'X-Requested-With': 'XMLHttpRequest'
      },
      post: {'Content-Type': 'application/json;charset=utf-8'},
      put:  {'Content-Type': 'application/json;charset=utf-8'}
    }
  };

  var providerResponseInterceptors = this.responseInterceptors = [];

  this.$get = ['$httpBackend', '$browser', '$cacheFactory', '$rootScope', '$q', '$injector',
      function($httpBackend, $browser, $cacheFactory, $rootScope, $q, $injector) {

    var defaultCache = $cacheFactory('$http'),
        responseInterceptors = [];

    forEach(providerResponseInterceptors, function(interceptor) {
      responseInterceptors.push(
          isString(interceptor)
              ? $injector.get(interceptor)
              : $injector.invoke(interceptor)
      );
    });


    /**
     * @ngdoc function
     * @name ng.$http
     * @requires $httpBackend
     * @requires $browser
     * @requires $cacheFactory
     * @requires $rootScope
     * @requires $q
     * @requires $injector
     *
     * @description
     * The `$http` service is a core Angular service that facilitates communication with the remote
     * HTTP servers via the browser's {@link https://developer.mozilla.org/en/xmlhttprequest
     * XMLHttpRequest} object or via {@link http://en.wikipedia.org/wiki/JSONP JSONP}.
     *
     * For unit testing applications that use `$http` service, see
     * {@link ngMock.$httpBackend $httpBackend mock}.
     *
     * For a higher level of abstraction, please check out the {@link ngResource.$resource
     * $resource} service.
     *
     * The $http API is based on the {@link ng.$q deferred/promise APIs} exposed by
     * the $q service. While for simple usage patterns this doesn't matter much, for advanced usage
     * it is important to familiarize yourself with these APIs and the guarantees they provide.
     *
     *
     * # General usage
     * The `$http` service is a function which takes a single argument — a configuration object —
     * that is used to generate an HTTP request and returns  a {@link ng.$q promise}
     * with two $http specific methods: `success` and `error`.
     *
     * <pre>
     *   $http({method: 'GET', url: '/someUrl'}).
     *     success(function(data, status, headers, config) {
     *       // this callback will be called asynchronously
     *       // when the response is available
     *     }).
     *     error(function(data, status, headers, config) {
     *       // called asynchronously if an error occurs
     *       // or server returns response with an error status.
     *     });
     * </pre>
     *
     * Since the returned value of calling the $http function is a `promise`, you can also use
     * the `then` method to register callbacks, and these callbacks will receive a single argument –
     * an object representing the response. See the API signature and type info below for more
     * details.
     *
     * A response status code between 200 and 299 is considered a success status and
     * will result in the success callback being called. Note that if the response is a redirect,
     * XMLHttpRequest will transparently follow it, meaning that the error callback will not be
     * called for such responses.
     *
     * # Shortcut methods
     *
     * Since all invocations of the $http service require passing in an HTTP method and URL, and
     * POST/PUT requests require request data to be provided as well, shortcut methods
     * were created:
     *
     * <pre>
     *   $http.get('/someUrl').success(successCallback);
     *   $http.post('/someUrl', data).success(successCallback);
     * </pre>
     *
     * Complete list of shortcut methods:
     *
     * - {@link ng.$http#get $http.get}
     * - {@link ng.$http#head $http.head}
     * - {@link ng.$http#post $http.post}
     * - {@link ng.$http#put $http.put}
     * - {@link ng.$http#delete $http.delete}
     * - {@link ng.$http#jsonp $http.jsonp}
     *
     *
     * # Setting HTTP Headers
     *
     * The $http service will automatically add certain HTTP headers to all requests. These defaults
     * can be fully configured by accessing the `$httpProvider.defaults.headers` configuration
     * object, which currently contains this default configuration:
     *
     * - `$httpProvider.defaults.headers.common` (headers that are common for all requests):
     *   - `Accept: application/json, text/plain, * / *`
     *   - `X-Requested-With: XMLHttpRequest`
     * - `$httpProvider.defaults.headers.post`: (header defaults for POST requests)
     *   - `Content-Type: application/json`
     * - `$httpProvider.defaults.headers.put` (header defaults for PUT requests)
     *   - `Content-Type: application/json`
     *
     * To add or overwrite these defaults, simply add or remove a property from these configuration
     * objects. To add headers for an HTTP method other than POST or PUT, simply add a new object
     * with the lowercased HTTP method name as the key, e.g.
     * `$httpProvider.defaults.headers.get['My-Header']='value'`.
     *
     * Additionally, the defaults can be set at runtime via the `$http.defaults` object in the same
     * fashion.
     *
     *
     * # Transforming Requests and Responses
     *
     * Both requests and responses can be transformed using transform functions. By default, Angular
     * applies these transformations:
     *
     * Request transformations:
     *
     * - If the `data` property of the request configuration object contains an object, serialize it into
     *   JSON format.
     *
     * Response transformations:
     *
     *  - If XSRF prefix is detected, strip it (see Security Considerations section below).
     *  - If JSON response is detected, deserialize it using a JSON parser.
     *
     * To globally augment or override the default transforms, modify the `$httpProvider.defaults.transformRequest` and
     * `$httpProvider.defaults.transformResponse` properties. These properties are by default an
     * array of transform functions, which allows you to `push` or `unshift` a new transformation function into the
     * transformation chain. You can also decide to completely override any default transformations by assigning your
     * transformation functions to these properties directly without the array wrapper.
     *
     * Similarly, to locally override the request/response transforms, augment the `transformRequest` and/or
     * `transformResponse` properties of the configuration object passed into `$http`.
     *
     *
     * # Caching
     *
     * To enable caching, set the configuration property `cache` to `true`. When the cache is
     * enabled, `$http` stores the response from the server in local cache. Next time the
     * response is served from the cache without sending a request to the server.
     *
     * Note that even if the response is served from cache, delivery of the data is asynchronous in
     * the same way that real requests are.
     *
     * If there are multiple GET requests for the same URL that should be cached using the same
     * cache, but the cache is not populated yet, only one request to the server will be made and
     * the remaining requests will be fulfilled using the response from the first request.
     *
     *
     * # Response interceptors
     *
     * Before you start creating interceptors, be sure to understand the
     * {@link ng.$q $q and deferred/promise APIs}.
     *
     * For purposes of global error handling, authentication or any kind of synchronous or
     * asynchronous preprocessing of received responses, it is desirable to be able to intercept
     * responses for http requests before they are handed over to the application code that
     * initiated these requests. The response interceptors leverage the {@link ng.$q
     * promise apis} to fulfil this need for both synchronous and asynchronous preprocessing.
     *
     * The interceptors are service factories that are registered with the $httpProvider by
     * adding them to the `$httpProvider.responseInterceptors` array. The factory is called and
     * injected with dependencies (if specified) and returns the interceptor  — a function that
     * takes a {@link ng.$q promise} and returns the original or a new promise.
     *
     * <pre>
     *   // register the interceptor as a service
     *   $provide.factory('myHttpInterceptor', function($q, dependency1, dependency2) {
     *     return function(promise) {
     *       return promise.then(function(response) {
     *         // do something on success
     *       }, function(response) {
     *         // do something on error
     *         if (canRecover(response)) {
     *           return responseOrNewPromise
     *         }
     *         return $q.reject(response);
     *       });
     *     }
     *   });
     *
     *   $httpProvider.responseInterceptors.push('myHttpInterceptor');
     *
     *
     *   // register the interceptor via an anonymous factory
     *   $httpProvider.responseInterceptors.push(function($q, dependency1, dependency2) {
     *     return function(promise) {
     *       // same as above
     *     }
     *   });
     * </pre>
     *
     *
     * # Security Considerations
     *
     * When designing web applications, consider security threats from:
     *
     * - {@link http://haacked.com/archive/2008/11/20/anatomy-of-a-subtle-json-vulnerability.aspx
     *   JSON vulnerability}
     * - {@link http://en.wikipedia.org/wiki/Cross-site_request_forgery XSRF}
     *
     * Both server and the client must cooperate in order to eliminate these threats. Angular comes
     * pre-configured with strategies that address these issues, but for this to work backend server
     * cooperation is required.
     *
     * ## JSON Vulnerability Protection
     *
     * A {@link http://haacked.com/archive/2008/11/20/anatomy-of-a-subtle-json-vulnerability.aspx
     * JSON vulnerability} allows third party website to turn your JSON resource URL into
     * {@link http://en.wikipedia.org/wiki/JSONP JSONP} request under some conditions. To
     * counter this your server can prefix all JSON requests with following string `")]}',\n"`.
     * Angular will automatically strip the prefix before processing it as JSON.
     *
     * For example if your server needs to return:
     * <pre>
     * ['one','two']
     * </pre>
     *
     * which is vulnerable to attack, your server can return:
     * <pre>
     * )]}',
     * ['one','two']
     * </pre>
     *
     * Angular will strip the prefix, before processing the JSON.
     *
     *
     * ## Cross Site Request Forgery (XSRF) Protection
     *
     * {@link http://en.wikipedia.org/wiki/Cross-site_request_forgery XSRF} is a technique by which
     * an unauthorized site can gain your user's private data. Angular provides a mechanism
     * to counter XSRF. When performing XHR requests, the $http service reads a token from a cookie
     * called `XSRF-TOKEN` and sets it as the HTTP header `X-XSRF-TOKEN`. Since only JavaScript that
     * runs on your domain could read the cookie, your server can be assured that the XHR came from
     * JavaScript running on your domain.
     *
     * To take advantage of this, your server needs to set a token in a JavaScript readable session
     * cookie called `XSRF-TOKEN` on the first HTTP GET request. On subsequent XHR requests the
     * server can verify that the cookie matches `X-XSRF-TOKEN` HTTP header, and therefore be sure
     * that only JavaScript running on your domain could have sent the request. The token must be
     * unique for each user and must be verifiable by the server (to prevent the JavaScript from making
     * up its own tokens). We recommend that the token is a digest of your site's authentication
     * cookie with a {@link https://en.wikipedia.org/wiki/Salt_(cryptography) salt} for added security.
     *
     *
     * @param {object} config Object describing the request to be made and how it should be
     *    processed. The object has following properties:
     *
     *    - **method** – `{string}` – HTTP method (e.g. 'GET', 'POST', etc)
     *    - **url** – `{string}` – Absolute or relative URL of the resource that is being requested.
     *    - **params** – `{Object.<string|Object>}` – Map of strings or objects which will be turned to
     *      `?key1=value1&key2=value2` after the url. If the value is not a string, it will be JSONified.
     *    - **data** – `{string|Object}` – Data to be sent as the request message data.
     *    - **headers** – `{Object}` – Map of strings representing HTTP headers to send to the server.
     *    - **transformRequest** – `{function(data, headersGetter)|Array.<function(data, headersGetter)>}` –
     *      transform function or an array of such functions. The transform function takes the http
     *      request body and headers and returns its transformed (typically serialized) version.
     *    - **transformResponse** – `{function(data, headersGetter)|Array.<function(data, headersGetter)>}` –
     *      transform function or an array of such functions. The transform function takes the http
     *      response body and headers and returns its transformed (typically deserialized) version.
     *    - **cache** – `{boolean|Cache}` – If true, a default $http cache will be used to cache the
     *      GET request, otherwise if a cache instance built with
     *      {@link ng.$cacheFactory $cacheFactory}, this cache will be used for
     *      caching.
     *    - **timeout** – `{number}` – timeout in milliseconds.
     *    - **withCredentials** - `{boolean}` - whether to to set the `withCredentials` flag on the
     *      XHR object. See {@link https://developer.mozilla.org/en/http_access_control#section_5
     *      requests with credentials} for more information.
     *
     * @returns {HttpPromise} Returns a {@link ng.$q promise} object with the
     *   standard `then` method and two http specific methods: `success` and `error`. The `then`
     *   method takes two arguments a success and an error callback which will be called with a
     *   response object. The `success` and `error` methods take a single argument - a function that
     *   will be called when the request succeeds or fails respectively. The arguments passed into
     *   these functions are destructured representation of the response object passed into the
     *   `then` method. The response object has these properties:
     *
     *   - **data** – `{string|Object}` – The response body transformed with the transform functions.
     *   - **status** – `{number}` – HTTP status code of the response.
     *   - **headers** – `{function([headerName])}` – Header getter function.
     *   - **config** – `{Object}` – The configuration object that was used to generate the request.
     *
     * @property {Array.<Object>} pendingRequests Array of config objects for currently pending
     *   requests. This is primarily meant to be used for debugging purposes.
     *
     *
     * @example
      <example>
        <file name="index.html">
          <div ng-controller="FetchCtrl">
            <select ng-model="method">
              <option>GET</option>
              <option>JSONP</option>
            </select>
            <input type="text" ng-model="url" size="80"/>
            <button ng-click="fetch()">fetch</button><br>
            <button ng-click="updateModel('GET', 'http-hello.html')">Sample GET</button>
            <button ng-click="updateModel('JSONP', 'http://angularjs.org/greet.php?callback=JSON_CALLBACK&name=Super%20Hero')">Sample JSONP</button>
            <button ng-click="updateModel('JSONP', 'http://angularjs.org/doesntexist&callback=JSON_CALLBACK')">Invalid JSONP</button>
            <pre>http status code: {{status}}</pre>
            <pre>http response data: {{data}}</pre>
          </div>
        </file>
        <file name="script.js">
          function FetchCtrl($scope, $http, $templateCache) {
            $scope.method = 'GET';
            $scope.url = 'http-hello.html';

            $scope.fetch = function() {
              $scope.code = null;
              $scope.response = null;

              $http({method: $scope.method, url: $scope.url, cache: $templateCache}).
                success(function(data, status) {
                  $scope.status = status;
                  $scope.data = data;
                }).
                error(function(data, status) {
                  $scope.data = data || "Request failed";
                  $scope.status = status;
              });
            };

            $scope.updateModel = function(method, url) {
              $scope.method = method;
              $scope.url = url;
            };
          }
        </file>
        <file name="http-hello.html">
          Hello, $http!
        </file>
        <file name="scenario.js">
          it('should make an xhr GET request', function() {
            element(':button:contains("Sample GET")').click();
            element(':button:contains("fetch")').click();
            expect(binding('status')).toBe('200');
            expect(binding('data')).toMatch(/Hello, \$http!/);
          });

          it('should make a JSONP request to angularjs.org', function() {
            element(':button:contains("Sample JSONP")').click();
            element(':button:contains("fetch")').click();
            expect(binding('status')).toBe('200');
            expect(binding('data')).toMatch(/Super Hero!/);
          });

          it('should make JSONP request to invalid URL and invoke the error handler',
              function() {
            element(':button:contains("Invalid JSONP")').click();
            element(':button:contains("fetch")').click();
            expect(binding('status')).toBe('0');
            expect(binding('data')).toBe('Request failed');
          });
        </file>
      </example>
     */
    function $http(config) {
      config.method = uppercase(config.method);

      var reqTransformFn = config.transformRequest || $config.transformRequest,
          respTransformFn = config.transformResponse || $config.transformResponse,
          defHeaders = $config.headers,
          reqHeaders = extend({'X-XSRF-TOKEN': $browser.cookies()['XSRF-TOKEN']},
              defHeaders.common, defHeaders[lowercase(config.method)], config.headers),
          reqData = transformData(config.data, headersGetter(reqHeaders), reqTransformFn),
          promise;

      // strip content-type if data is undefined
      if (isUndefined(config.data)) {
        delete reqHeaders['Content-Type'];
      }

      // send request
      promise = sendReq(config, reqData, reqHeaders);


      // transform future response
      promise = promise.then(transformResponse, transformResponse);

      // apply interceptors
      forEach(responseInterceptors, function(interceptor) {
        promise = interceptor(promise);
      });

      promise.success = function(fn) {
        promise.then(function(response) {
          fn(response.data, response.status, response.headers, config);
        });
        return promise;
      };

      promise.error = function(fn) {
        promise.then(null, function(response) {
          fn(response.data, response.status, response.headers, config);
        });
        return promise;
      };

      return promise;

      function transformResponse(response) {
        // make a copy since the response must be cacheable
        var resp = extend({}, response, {
          data: transformData(response.data, response.headers, respTransformFn)
        });
        return (isSuccess(response.status))
          ? resp
          : $q.reject(resp);
      }
    }

    $http.pendingRequests = [];

    /**
     * @ngdoc method
     * @name ng.$http#get
     * @methodOf ng.$http
     *
     * @description
     * Shortcut method to perform `GET` request.
     *
     * @param {string} url Relative or absolute URL specifying the destination of the request
     * @param {Object=} config Optional configuration object
     * @returns {HttpPromise} Future object
     */

    /**
     * @ngdoc method
     * @name ng.$http#delete
     * @methodOf ng.$http
     *
     * @description
     * Shortcut method to perform `DELETE` request.
     *
     * @param {string} url Relative or absolute URL specifying the destination of the request
     * @param {Object=} config Optional configuration object
     * @returns {HttpPromise} Future object
     */

    /**
     * @ngdoc method
     * @name ng.$http#head
     * @methodOf ng.$http
     *
     * @description
     * Shortcut method to perform `HEAD` request.
     *
     * @param {string} url Relative or absolute URL specifying the destination of the request
     * @param {Object=} config Optional configuration object
     * @returns {HttpPromise} Future object
     */

    /**
     * @ngdoc method
     * @name ng.$http#jsonp
     * @methodOf ng.$http
     *
     * @description
     * Shortcut method to perform `JSONP` request.
     *
     * @param {string} url Relative or absolute URL specifying the destination of the request.
     *                     Should contain `JSON_CALLBACK` string.
     * @param {Object=} config Optional configuration object
     * @returns {HttpPromise} Future object
     */
    createShortMethods('get', 'delete', 'head', 'jsonp');

    /**
     * @ngdoc method
     * @name ng.$http#post
     * @methodOf ng.$http
     *
     * @description
     * Shortcut method to perform `POST` request.
     *
     * @param {string} url Relative or absolute URL specifying the destination of the request
     * @param {*} data Request content
     * @param {Object=} config Optional configuration object
     * @returns {HttpPromise} Future object
     */

    /**
     * @ngdoc method
     * @name ng.$http#put
     * @methodOf ng.$http
     *
     * @description
     * Shortcut method to perform `PUT` request.
     *
     * @param {string} url Relative or absolute URL specifying the destination of the request
     * @param {*} data Request content
     * @param {Object=} config Optional configuration object
     * @returns {HttpPromise} Future object
     */
    createShortMethodsWithData('post', 'put');

        /**
         * @ngdoc property
         * @name ng.$http#defaults
         * @propertyOf ng.$http
         *
         * @description
         * Runtime equivalent of the `$httpProvider.defaults` property. Allows configuration of
         * default headers as well as request and response transformations.
         *
         * See "Setting HTTP Headers" and "Transforming Requests and Responses" sections above.
         */
    $http.defaults = $config;


    return $http;


    function createShortMethods(names) {
      forEach(arguments, function(name) {
        $http[name] = function(url, config) {
          return $http(extend(config || {}, {
            method: name,
            url: url
          }));
        };
      });
    }


    function createShortMethodsWithData(name) {
      forEach(arguments, function(name) {
        $http[name] = function(url, data, config) {
          return $http(extend(config || {}, {
            method: name,
            url: url,
            data: data
          }));
        };
      });
    }


    /**
     * Makes the request.
     *
     * !!! ACCESSES CLOSURE VARS:
     * $httpBackend, $config, $log, $rootScope, defaultCache, $http.pendingRequests
     */
    function sendReq(config, reqData, reqHeaders) {
      var deferred = $q.defer(),
          promise = deferred.promise,
          cache,
          cachedResp,
          url = buildUrl(config.url, config.params);

      $http.pendingRequests.push(config);
      promise.then(removePendingReq, removePendingReq);


      if (config.cache && config.method == 'GET') {
        cache = isObject(config.cache) ? config.cache : defaultCache;
      }

      if (cache) {
        cachedResp = cache.get(url);
        if (cachedResp) {
          if (cachedResp.then) {
            // cached request has already been sent, but there is no response yet
            cachedResp.then(removePendingReq, removePendingReq);
            return cachedResp;
          } else {
            // serving from cache
            if (isArray(cachedResp)) {
              resolvePromise(cachedResp[1], cachedResp[0], copy(cachedResp[2]));
            } else {
              resolvePromise(cachedResp, 200, {});
            }
          }
        } else {
          // put the promise for the non-transformed response into cache as a placeholder
          cache.put(url, promise);
        }
      }

      // if we won't have the response in cache, send the request to the backend
      if (!cachedResp) {
        $httpBackend(config.method, url, reqData, done, reqHeaders, config.timeout,
            config.withCredentials);
      }

      return promise;


      /**
       * Callback registered to $httpBackend():
       *  - caches the response if desired
       *  - resolves the raw $http promise
       *  - calls $apply
       */
      function done(status, response, headersString) {
        if (cache) {
          if (isSuccess(status)) {
            cache.put(url, [status, response, parseHeaders(headersString)]);
          } else {
            // remove promise from the cache
            cache.remove(url);
          }
        }

        resolvePromise(response, status, headersString);
        $rootScope.$apply();
      }


      /**
       * Resolves the raw $http promise.
       */
      function resolvePromise(response, status, headers) {
        // normalize internal statuses to 0
        status = Math.max(status, 0);

        (isSuccess(status) ? deferred.resolve : deferred.reject)({
          data: response,
          status: status,
          headers: headersGetter(headers),
          config: config
        });
      }


      function removePendingReq() {
        var idx = indexOf($http.pendingRequests, config);
        if (idx !== -1) $http.pendingRequests.splice(idx, 1);
      }
    }


    function buildUrl(url, params) {
          if (!params) return url;
          var parts = [];
          forEachSorted(params, function(value, key) {
            if (value == null || value == undefined) return;
            if (isObject(value)) {
              value = toJson(value);
            }
            parts.push(encodeURIComponent(key) + '=' + encodeURIComponent(value));
          });
          return url + ((url.indexOf('?') == -1) ? '?' : '&') + parts.join('&');
        }


  }];
}

var XHR = window.XMLHttpRequest || function() {
  try { return new ActiveXObject("Msxml2.XMLHTTP.6.0"); } catch (e1) {}
  try { return new ActiveXObject("Msxml2.XMLHTTP.3.0"); } catch (e2) {}
  try { return new ActiveXObject("Msxml2.XMLHTTP"); } catch (e3) {}
  throw new Error("This browser does not support XMLHttpRequest.");
};


/**
 * @ngdoc object
 * @name ng.$httpBackend
 * @requires $browser
 * @requires $window
 * @requires $document
 *
 * @description
 * HTTP backend used by the {@link ng.$http service} that delegates to
 * XMLHttpRequest object or JSONP and deals with browser incompatibilities.
 *
 * You should never need to use this service directly, instead use the higher-level abstractions:
 * {@link ng.$http $http} or {@link ngResource.$resource $resource}.
 *
 * During testing this implementation is swapped with {@link ngMock.$httpBackend mock
 * $httpBackend} which can be trained with responses.
 */
function $HttpBackendProvider() {
  this.$get = ['$browser', '$window', '$document', function($browser, $window, $document) {
    return createHttpBackend($browser, XHR, $browser.defer, $window.angular.callbacks,
        $document[0], $window.location.protocol.replace(':', ''));
  }];
}

function createHttpBackend($browser, XHR, $browserDefer, callbacks, rawDocument, locationProtocol) {
  // TODO(vojta): fix the signature
  return function(method, url, post, callback, headers, timeout, withCredentials) {
    $browser.$$incOutstandingRequestCount();
    url = url || $browser.url();

    if (lowercase(method) == 'jsonp') {
      var callbackId = '_' + (callbacks.counter++).toString(36);
      callbacks[callbackId] = function(data) {
        callbacks[callbackId].data = data;
      };

      jsonpReq(url.replace('JSON_CALLBACK', 'angular.callbacks.' + callbackId),
          function() {
        if (callbacks[callbackId].data) {
          completeRequest(callback, 200, callbacks[callbackId].data);
        } else {
          completeRequest(callback, -2);
        }
        delete callbacks[callbackId];
      });
    } else {
      var xhr = new XHR();
      xhr.open(method, url, true);
      forEach(headers, function(value, key) {
        if (value) xhr.setRequestHeader(key, value);
      });

      var status;

      // In IE6 and 7, this might be called synchronously when xhr.send below is called and the
      // response is in the cache. the promise api will ensure that to the app code the api is
      // always async
      xhr.onreadystatechange = function() {
        if (xhr.readyState == 4) {
          var responseHeaders = xhr.getAllResponseHeaders();

          // TODO(vojta): remove once Firefox 21 gets released.
          // begin: workaround to overcome Firefox CORS http response headers bug
          // https://bugzilla.mozilla.org/show_bug.cgi?id=608735
          // Firefox already patched in nightly. Should land in Firefox 21.

          // CORS "simple response headers" http://www.w3.org/TR/cors/
          var value,
              simpleHeaders = ["Cache-Control", "Content-Language", "Content-Type",
                                  "Expires", "Last-Modified", "Pragma"];
          if (!responseHeaders) {
            responseHeaders = "";
            forEach(simpleHeaders, function (header) {
              var value = xhr.getResponseHeader(header);
              if (value) {
                  responseHeaders += header + ": " + value + "\n";
              }
            });
          }
          // end of the workaround.

          completeRequest(callback, status || xhr.status, xhr.responseText,
                          responseHeaders);
        }
      };

      if (withCredentials) {
        xhr.withCredentials = true;
      }

      xhr.send(post || '');

      if (timeout > 0) {
        $browserDefer(function() {
          status = -1;
          xhr.abort();
        }, timeout);
      }
    }


    function completeRequest(callback, status, response, headersString) {
      // URL_MATCH is defined in src/service/location.js
      var protocol = (url.match(URL_MATCH) || ['', locationProtocol])[1];

      // fix status code for file protocol (it's always 0)
      status = (protocol == 'file') ? (response ? 200 : 404) : status;

      // normalize IE bug (http://bugs.jquery.com/ticket/1450)
      status = status == 1223 ? 204 : status;

      callback(status, response, headersString);
      $browser.$$completeOutstandingRequest(noop);
    }
  };

  function jsonpReq(url, done) {
    // we can't use jQuery/jqLite here because jQuery does crazy shit with script elements, e.g.:
    // - fetches local scripts via XHR and evals them
    // - adds and immediately removes script elements from the document
    var script = rawDocument.createElement('script'),
        doneWrapper = function() {
          rawDocument.body.removeChild(script);
          if (done) done();
        };

    script.type = 'text/javascript';
    script.src = url;

    if (msie) {
      script.onreadystatechange = function() {
        if (/loaded|complete/.test(script.readyState)) doneWrapper();
      };
    } else {
      script.onload = script.onerror = doneWrapper;
    }

    rawDocument.body.appendChild(script);
  }
}

/**
 * @ngdoc object
 * @name ng.$locale
 *
 * @description
 * $locale service provides localization rules for various Angular components. As of right now the
 * only public api is:
 *
 * * `id` – `{string}` – locale id formatted as `languageId-countryId` (e.g. `en-us`)
 */
function $LocaleProvider(){
  this.$get = function() {
    return {
      id: 'en-us',

      NUMBER_FORMATS: {
        DECIMAL_SEP: '.',
        GROUP_SEP: ',',
        PATTERNS: [
          { // Decimal Pattern
            minInt: 1,
            minFrac: 0,
            maxFrac: 3,
            posPre: '',
            posSuf: '',
            negPre: '-',
            negSuf: '',
            gSize: 3,
            lgSize: 3
          },{ //Currency Pattern
            minInt: 1,
            minFrac: 2,
            maxFrac: 2,
            posPre: '\u00A4',
            posSuf: '',
            negPre: '(\u00A4',
            negSuf: ')',
            gSize: 3,
            lgSize: 3
          }
        ],
        CURRENCY_SYM: '$'
      },

      DATETIME_FORMATS: {
        MONTH: 'January,February,March,April,May,June,July,August,September,October,November,December'
                .split(','),
        SHORTMONTH:  'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec'.split(','),
        DAY: 'Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday'.split(','),
        SHORTDAY: 'Sun,Mon,Tue,Wed,Thu,Fri,Sat'.split(','),
        AMPMS: ['AM','PM'],
        medium: 'MMM d, y h:mm:ss a',
        short: 'M/d/yy h:mm a',
        fullDate: 'EEEE, MMMM d, y',
        longDate: 'MMMM d, y',
        mediumDate: 'MMM d, y',
        shortDate: 'M/d/yy',
        mediumTime: 'h:mm:ss a',
        shortTime: 'h:mm a'
      },

      pluralCat: function(num) {
        if (num === 1) {
          return 'one';
        }
        return 'other';
      }
    };
  };
}

function $TimeoutProvider() {
  this.$get = ['$rootScope', '$browser', '$q', '$exceptionHandler',
       function($rootScope,   $browser,   $q,   $exceptionHandler) {
    var deferreds = {};


     /**
      * @ngdoc function
      * @name ng.$timeout
      * @requires $browser
      *
      * @description
      * Angular's wrapper for `window.setTimeout`. The `fn` function is wrapped into a try/catch
      * block and delegates any exceptions to
      * {@link ng.$exceptionHandler $exceptionHandler} service.
      *
      * The return value of registering a timeout function is a promise, which will be resolved when
      * the timeout is reached and the timeout function is executed.
      *
      * To cancel a timeout request, call `$timeout.cancel(promise)`.
      *
      * In tests you can use {@link ngMock.$timeout `$timeout.flush()`} to
      * synchronously flush the queue of deferred functions.
      *
      * @param {function()} fn A function, whose execution should be delayed.
      * @param {number=} [delay=0] Delay in milliseconds.
      * @param {boolean=} [invokeApply=true] If set to `false` skips model dirty checking, otherwise
      *   will invoke `fn` within the {@link ng.$rootScope.Scope#$apply $apply} block.
      * @returns {Promise} Promise that will be resolved when the timeout is reached. The value this
      *   promise will be resolved with is the return value of the `fn` function.
      */
    function timeout(fn, delay, invokeApply) {
      var deferred = $q.defer(),
          promise = deferred.promise,
          skipApply = (isDefined(invokeApply) && !invokeApply),
          timeoutId, cleanup;

      timeoutId = $browser.defer(function() {
        try {
          deferred.resolve(fn());
        } catch(e) {
          deferred.reject(e);
          $exceptionHandler(e);
        }

        if (!skipApply) $rootScope.$apply();
      }, delay);

      cleanup = function() {
        delete deferreds[promise.$$timeoutId];
      };

      promise.$$timeoutId = timeoutId;
      deferreds[timeoutId] = deferred;
      promise.then(cleanup, cleanup);

      return promise;
    }


     /**
      * @ngdoc function
      * @name ng.$timeout#cancel
      * @methodOf ng.$timeout
      *
      * @description
      * Cancels a task associated with the `promise`. As a result of this, the promise will be
      * resolved with a rejection.
      *
      * @param {Promise=} promise Promise returned by the `$timeout` function.
      * @returns {boolean} Returns `true` if the task hasn't executed yet and was successfully
      *   canceled.
      */
    timeout.cancel = function(promise) {
      if (promise && promise.$$timeoutId in deferreds) {
        deferreds[promise.$$timeoutId].reject('canceled');
        return $browser.defer.cancel(promise.$$timeoutId);
      }
      return false;
    };

    return timeout;
  }];
}

/**
 * @ngdoc object
 * @name ng.$filterProvider
 * @description
 *
 * Filters are just functions which transform input to an output. However filters need to be Dependency Injected. To
 * achieve this a filter definition consists of a factory function which is annotated with dependencies and is
 * responsible for creating a filter function.
 *
 * <pre>
 *   // Filter registration
 *   function MyModule($provide, $filterProvider) {
 *     // create a service to demonstrate injection (not always needed)
 *     $provide.value('greet', function(name){
 *       return 'Hello ' + name + '!';
 *     });
 *
 *     // register a filter factory which uses the
 *     // greet service to demonstrate DI.
 *     $filterProvider.register('greet', function(greet){
 *       // return the filter function which uses the greet service
 *       // to generate salutation
 *       return function(text) {
 *         // filters need to be forgiving so check input validity
 *         return text && greet(text) || text;
 *       };
 *     });
 *   }
 * </pre>
 *
 * The filter function is registered with the `$injector` under the filter name suffixe with `Filter`.
 * <pre>
 *   it('should be the same instance', inject(
 *     function($filterProvider) {
 *       $filterProvider.register('reverse', function(){
 *         return ...;
 *       });
 *     },
 *     function($filter, reverseFilter) {
 *       expect($filter('reverse')).toBe(reverseFilter);
 *     });
 * </pre>
 *
 *
 * For more information about how angular filters work, and how to create your own filters, see
 * {@link guide/dev_guide.templates.filters Understanding Angular Filters} in the angular Developer
 * Guide.
 */
/**
 * @ngdoc method
 * @name ng.$filterProvider#register
 * @methodOf ng.$filterProvider
 * @description
 * Register filter factory function.
 *
 * @param {String} name Name of the filter.
 * @param {function} fn The filter factory function which is injectable.
 */


/**
 * @ngdoc function
 * @name ng.$filter
 * @function
 * @description
 * Filters are used for formatting data displayed to the user.
 *
 * The general syntax in templates is as follows:
 *
 *         {{ expression [| filter_name[:parameter_value] ... ] }}
 *
 * @param {String} name Name of the filter function to retrieve
 * @return {Function} the filter function
 */
$FilterProvider.$inject = ['$provide'];
function $FilterProvider($provide) {
  var suffix = 'Filter';

  function register(name, factory) {
    return $provide.factory(name + suffix, factory);
  }
  this.register = register;

  this.$get = ['$injector', function($injector) {
    return function(name) {
      return $injector.get(name + suffix);
    }
  }];

  ////////////////////////////////////////

  register('currency', currencyFilter);
  register('date', dateFilter);
  register('filter', filterFilter);
  register('json', jsonFilter);
  register('limitTo', limitToFilter);
  register('lowercase', lowercaseFilter);
  register('number', numberFilter);
  register('orderBy', orderByFilter);
  register('uppercase', uppercaseFilter);
}

/**
 * @ngdoc filter
 * @name ng.filter:filter
 * @function
 *
 * @description
 * Selects a subset of items from `array` and returns it as a new array.
 *
 * Note: This function is used to augment the `Array` type in Angular expressions. See
 * {@link ng.$filter} for more information about Angular arrays.
 *
 * @param {Array} array The source array.
 * @param {string|Object|function()} expression The predicate to be used for selecting items from
 *   `array`.
 *
 *   Can be one of:
 *
 *   - `string`: Predicate that results in a substring match using the value of `expression`
 *     string. All strings or objects with string properties in `array` that contain this string
 *     will be returned. The predicate can be negated by prefixing the string with `!`.
 *
 *   - `Object`: A pattern object can be used to filter specific properties on objects contained
 *     by `array`. For example `{name:"M", phone:"1"}` predicate will return an array of items
 *     which have property `name` containing "M" and property `phone` containing "1". A special
 *     property name `$` can be used (as in `{$:"text"}`) to accept a match against any
 *     property of the object. That's equivalent to the simple substring match with a `string`
 *     as described above.
 *
 *   - `function`: A predicate function can be used to write arbitrary filters. The function is
 *     called for each element of `array`. The final result is an array of those elements that
 *     the predicate returned true for.
 *
 * @example
   <doc:example>
     <doc:source>
       <div ng-init="friends = [{name:'John', phone:'555-1276'},
                                {name:'Mary', phone:'800-BIG-MARY'},
                                {name:'Mike', phone:'555-4321'},
                                {name:'Adam', phone:'555-5678'},
                                {name:'Julie', phone:'555-8765'}]"></div>

       Search: <input ng-model="searchText">
       <table id="searchTextResults">
         <tr><th>Name</th><th>Phone</th></tr>
         <tr ng-repeat="friend in friends | filter:searchText">
           <td>{{friend.name}}</td>
           <td>{{friend.phone}}</td>
         </tr>
       </table>
       <hr>
       Any: <input ng-model="search.$"> <br>
       Name only <input ng-model="search.name"><br>
       Phone only <input ng-model="search.phone"><br>
       <table id="searchObjResults">
         <tr><th>Name</th><th>Phone</th></tr>
         <tr ng-repeat="friend in friends | filter:search">
           <td>{{friend.name}}</td>
           <td>{{friend.phone}}</td>
         </tr>
       </table>
     </doc:source>
     <doc:scenario>
       it('should search across all fields when filtering with a string', function() {
         input('searchText').enter('m');
         expect(repeater('#searchTextResults tr', 'friend in friends').column('friend.name')).
           toEqual(['Mary', 'Mike', 'Adam']);

         input('searchText').enter('76');
         expect(repeater('#searchTextResults tr', 'friend in friends').column('friend.name')).
           toEqual(['John', 'Julie']);
       });

       it('should search in specific fields when filtering with a predicate object', function() {
         input('search.$').enter('i');
         expect(repeater('#searchObjResults tr', 'friend in friends').column('friend.name')).
           toEqual(['Mary', 'Mike', 'Julie']);
       });
     </doc:scenario>
   </doc:example>
 */
function filterFilter() {
  return function(array, expression) {
    if (!isArray(array)) return array;
    var predicates = [];
    predicates.check = function(value) {
      for (var j = 0; j < predicates.length; j++) {
        if(!predicates[j](value)) {
          return false;
        }
      }
      return true;
    };
    var search = function(obj, text){
      if (text.charAt(0) === '!') {
        return !search(obj, text.substr(1));
      }
      switch (typeof obj) {
        case "boolean":
        case "number":
        case "string":
          return ('' + obj).toLowerCase().indexOf(text) > -1;
        case "object":
          for ( var objKey in obj) {
            if (objKey.charAt(0) !== '$' && search(obj[objKey], text)) {
              return true;
            }
          }
          return false;
        case "array":
          for ( var i = 0; i < obj.length; i++) {
            if (search(obj[i], text)) {
              return true;
            }
          }
          return false;
        default:
          return false;
      }
    };
    switch (typeof expression) {
      case "boolean":
      case "number":
      case "string":
        expression = {$:expression};
      case "object":
        for (var key in expression) {
          if (key == '$') {
            (function() {
              var text = (''+expression[key]).toLowerCase();
              if (!text) return;
              predicates.push(function(value) {
                return search(value, text);
              });
            })();
          } else {
            (function() {
              var path = key;
              var text = (''+expression[key]).toLowerCase();
              if (!text) return;
              predicates.push(function(value) {
                return search(getter(value, path), text);
              });
            })();
          }
        }
        break;
      case 'function':
        predicates.push(expression);
        break;
      default:
        return array;
    }
    var filtered = [];
    for ( var j = 0; j < array.length; j++) {
      var value = array[j];
      if (predicates.check(value)) {
        filtered.push(value);
      }
    }
    return filtered;
  }
}

/**
 * @ngdoc filter
 * @name ng.filter:currency
 * @function
 *
 * @description
 * Formats a number as a currency (ie $1,234.56). When no currency symbol is provided, default
 * symbol for current locale is used.
 *
 * @param {number} amount Input to filter.
 * @param {string=} symbol Currency symbol or identifier to be displayed.
 * @returns {string} Formatted number.
 *
 *
 * @example
   <doc:example>
     <doc:source>
       <script>
         function Ctrl($scope) {
           $scope.amount = 1234.56;
         }
       </script>
       <div ng-controller="Ctrl">
         <input type="number" ng-model="amount"> <br>
         default currency symbol ($): {{amount | currency}}<br>
         custom currency identifier (USD$): {{amount | currency:"USD$"}}
       </div>
     </doc:source>
     <doc:scenario>
       it('should init with 1234.56', function() {
         expect(binding('amount | currency')).toBe('$1,234.56');
         expect(binding('amount | currency:"USD$"')).toBe('USD$1,234.56');
       });
       it('should update', function() {
         input('amount').enter('-1234');
         expect(binding('amount | currency')).toBe('($1,234.00)');
         expect(binding('amount | currency:"USD$"')).toBe('(USD$1,234.00)');
       });
     </doc:scenario>
   </doc:example>
 */
currencyFilter.$inject = ['$locale'];
function currencyFilter($locale) {
  var formats = $locale.NUMBER_FORMATS;
  return function(amount, currencySymbol){
    if (isUndefined(currencySymbol)) currencySymbol = formats.CURRENCY_SYM;
    return formatNumber(amount, formats.PATTERNS[1], formats.GROUP_SEP, formats.DECIMAL_SEP, 2).
                replace(/\u00A4/g, currencySymbol);
  };
}

/**
 * @ngdoc filter
 * @name ng.filter:number
 * @function
 *
 * @description
 * Formats a number as text.
 *
 * If the input is not a number an empty string is returned.
 *
 * @param {number|string} number Number to format.
 * @param {(number|string)=} [fractionSize=2] Number of decimal places to round the number to.
 * @returns {string} Number rounded to decimalPlaces and places a “,” after each third digit.
 *
 * @example
   <doc:example>
     <doc:source>
       <script>
         function Ctrl($scope) {
           $scope.val = 1234.56789;
         }
       </script>
       <div ng-controller="Ctrl">
         Enter number: <input ng-model='val'><br>
         Default formatting: {{val | number}}<br>
         No fractions: {{val | number:0}}<br>
         Negative number: {{-val | number:4}}
       </div>
     </doc:source>
     <doc:scenario>
       it('should format numbers', function() {
         expect(binding('val | number')).toBe('1,234.568');
         expect(binding('val | number:0')).toBe('1,235');
         expect(binding('-val | number:4')).toBe('-1,234.5679');
       });

       it('should update', function() {
         input('val').enter('3374.333');
         expect(binding('val | number')).toBe('3,374.333');
         expect(binding('val | number:0')).toBe('3,374');
         expect(binding('-val | number:4')).toBe('-3,374.3330');
       });
     </doc:scenario>
   </doc:example>
 */


numberFilter.$inject = ['$locale'];
function numberFilter($locale) {
  var formats = $locale.NUMBER_FORMATS;
  return function(number, fractionSize) {
    return formatNumber(number, formats.PATTERNS[0], formats.GROUP_SEP, formats.DECIMAL_SEP,
      fractionSize);
  };
}

var DECIMAL_SEP = '.';
function formatNumber(number, pattern, groupSep, decimalSep, fractionSize) {
  if (isNaN(number) || !isFinite(number)) return '';

  var isNegative = number < 0;
  number = Math.abs(number);
  var numStr = number + '',
      formatedText = '',
      parts = [];

  var hasExponent = false;
  if (numStr.indexOf('e') !== -1) {
    var match = numStr.match(/([\d\.]+)e(-?)(\d+)/);
    if (match && match[2] == '-' && match[3] > fractionSize + 1) {
      numStr = '0';
    } else {
      formatedText = numStr;
      hasExponent = true;
    }
  }

  if (!hasExponent) {
    var fractionLen = (numStr.split(DECIMAL_SEP)[1] || '').length;

    // determine fractionSize if it is not specified
    if (isUndefined(fractionSize)) {
      fractionSize = Math.min(Math.max(pattern.minFrac, fractionLen), pattern.maxFrac);
    }

    var pow = Math.pow(10, fractionSize);
    number = Math.round(number * pow) / pow;
    var fraction = ('' + number).split(DECIMAL_SEP);
    var whole = fraction[0];
    fraction = fraction[1] || '';

    var pos = 0,
        lgroup = pattern.lgSize,
        group = pattern.gSize;

    if (whole.length >= (lgroup + group)) {
      pos = whole.length - lgroup;
      for (var i = 0; i < pos; i++) {
        if ((pos - i)%group === 0 && i !== 0) {
          formatedText += groupSep;
        }
        formatedText += whole.charAt(i);
      }
    }

    for (i = pos; i < whole.length; i++) {
      if ((whole.length - i)%lgroup === 0 && i !== 0) {
        formatedText += groupSep;
      }
      formatedText += whole.charAt(i);
    }

    // format fraction part.
    while(fraction.length < fractionSize) {
      fraction += '0';
    }

    if (fractionSize && fractionSize !== "0") formatedText += decimalSep + fraction.substr(0, fractionSize);
  }

  parts.push(isNegative ? pattern.negPre : pattern.posPre);
  parts.push(formatedText);
  parts.push(isNegative ? pattern.negSuf : pattern.posSuf);
  return parts.join('');
}

function padNumber(num, digits, trim) {
  var neg = '';
  if (num < 0) {
    neg =  '-';
    num = -num;
  }
  num = '' + num;
  while(num.length < digits) num = '0' + num;
  if (trim)
    num = num.substr(num.length - digits);
  return neg + num;
}


function dateGetter(name, size, offset, trim) {
  offset = offset || 0;
  return function(date) {
    var value = date['get' + name]();
    if (offset > 0 || value > -offset)
      value += offset;
    if (value === 0 && offset == -12 ) value = 12;
    return padNumber(value, size, trim);
  };
}

function dateStrGetter(name, shortForm) {
  return function(date, formats) {
    var value = date['get' + name]();
    var get = uppercase(shortForm ? ('SHORT' + name) : name);

    return formats[get][value];
  };
}

function timeZoneGetter(date) {
  var zone = -1 * date.getTimezoneOffset();
  var paddedZone = (zone >= 0) ? "+" : "";

  paddedZone += padNumber(Math[zone > 0 ? 'floor' : 'ceil'](zone / 60), 2) +
                padNumber(Math.abs(zone % 60), 2);

  return paddedZone;
}

function ampmGetter(date, formats) {
  return date.getHours() < 12 ? formats.AMPMS[0] : formats.AMPMS[1];
}

var DATE_FORMATS = {
  yyyy: dateGetter('FullYear', 4),
    yy: dateGetter('FullYear', 2, 0, true),
     y: dateGetter('FullYear', 1),
  MMMM: dateStrGetter('Month'),
   MMM: dateStrGetter('Month', true),
    MM: dateGetter('Month', 2, 1),
     M: dateGetter('Month', 1, 1),
    dd: dateGetter('Date', 2),
     d: dateGetter('Date', 1),
    HH: dateGetter('Hours', 2),
     H: dateGetter('Hours', 1),
    hh: dateGetter('Hours', 2, -12),
     h: dateGetter('Hours', 1, -12),
    mm: dateGetter('Minutes', 2),
     m: dateGetter('Minutes', 1),
    ss: dateGetter('Seconds', 2),
     s: dateGetter('Seconds', 1),
  EEEE: dateStrGetter('Day'),
   EEE: dateStrGetter('Day', true),
     a: ampmGetter,
     Z: timeZoneGetter
};

var DATE_FORMATS_SPLIT = /((?:[^yMdHhmsaZE']+)|(?:'(?:[^']|'')*')|(?:E+|y+|M+|d+|H+|h+|m+|s+|a|Z))(.*)/,
    NUMBER_STRING = /^\d+$/;

/**
 * @ngdoc filter
 * @name ng.filter:date
 * @function
 *
 * @description
 *   Formats `date` to a string based on the requested `format`.
 *
 *   `format` string can be composed of the following elements:
 *
 *   * `'yyyy'`: 4 digit representation of year (e.g. AD 1 => 0001, AD 2010 => 2010)
 *   * `'yy'`: 2 digit representation of year, padded (00-99). (e.g. AD 2001 => 01, AD 2010 => 10)
 *   * `'y'`: 1 digit representation of year, e.g. (AD 1 => 1, AD 199 => 199)
 *   * `'MMMM'`: Month in year (January-December)
 *   * `'MMM'`: Month in year (Jan-Dec)
 *   * `'MM'`: Month in year, padded (01-12)
 *   * `'M'`: Month in year (1-12)
 *   * `'dd'`: Day in month, padded (01-31)
 *   * `'d'`: Day in month (1-31)
 *   * `'EEEE'`: Day in Week,(Sunday-Saturday)
 *   * `'EEE'`: Day in Week, (Sun-Sat)
 *   * `'HH'`: Hour in day, padded (00-23)
 *   * `'H'`: Hour in day (0-23)
 *   * `'hh'`: Hour in am/pm, padded (01-12)
 *   * `'h'`: Hour in am/pm, (1-12)
 *   * `'mm'`: Minute in hour, padded (00-59)
 *   * `'m'`: Minute in hour (0-59)
 *   * `'ss'`: Second in minute, padded (00-59)
 *   * `'s'`: Second in minute (0-59)
 *   * `'a'`: am/pm marker
 *   * `'Z'`: 4 digit (+sign) representation of the timezone offset (-1200-+1200)
 *
 *   `format` string can also be one of the following predefined
 *   {@link guide/i18n localizable formats}:
 *
 *   * `'medium'`: equivalent to `'MMM d, y h:mm:ss a'` for en_US locale
 *     (e.g. Sep 3, 2010 12:05:08 pm)
 *   * `'short'`: equivalent to `'M/d/yy h:mm a'` for en_US  locale (e.g. 9/3/10 12:05 pm)
 *   * `'fullDate'`: equivalent to `'EEEE, MMMM d,y'` for en_US  locale
 *     (e.g. Friday, September 3, 2010)
 *   * `'longDate'`: equivalent to `'MMMM d, y'` for en_US  locale (e.g. September 3, 2010
 *   * `'mediumDate'`: equivalent to `'MMM d, y'` for en_US  locale (e.g. Sep 3, 2010)
 *   * `'shortDate'`: equivalent to `'M/d/yy'` for en_US locale (e.g. 9/3/10)
 *   * `'mediumTime'`: equivalent to `'h:mm:ss a'` for en_US locale (e.g. 12:05:08 pm)
 *   * `'shortTime'`: equivalent to `'h:mm a'` for en_US locale (e.g. 12:05 pm)
 *
 *   `format` string can contain literal values. These need to be quoted with single quotes (e.g.
 *   `"h 'in the morning'"`). In order to output single quote, use two single quotes in a sequence
 *   (e.g. `"h o''clock"`).
 *
 * @param {(Date|number|string)} date Date to format either as Date object, milliseconds (string or
 *    number) or various ISO 8601 datetime string formats (e.g. yyyy-MM-ddTHH:mm:ss.SSSZ and its
 *    shorter versions like yyyy-MM-ddTHH:mmZ, yyyy-MM-dd or yyyyMMddTHHmmssZ). If no timezone is
 *    specified in the string input, the time is considered to be in the local timezone.
 * @param {string=} format Formatting rules (see Description). If not specified,
 *    `mediumDate` is used.
 * @returns {string} Formatted string or the input if input is not recognized as date/millis.
 *
 * @example
   <doc:example>
     <doc:source>
       <span ng-non-bindable>{{1288323623006 | date:'medium'}}</span>:
           {{1288323623006 | date:'medium'}}<br>
       <span ng-non-bindable>{{1288323623006 | date:'yyyy-MM-dd HH:mm:ss Z'}}</span>:
          {{1288323623006 | date:'yyyy-MM-dd HH:mm:ss Z'}}<br>
       <span ng-non-bindable>{{1288323623006 | date:'MM/dd/yyyy @ h:mma'}}</span>:
          {{'1288323623006' | date:'MM/dd/yyyy @ h:mma'}}<br>
     </doc:source>
     <doc:scenario>
       it('should format date', function() {
         expect(binding("1288323623006 | date:'medium'")).
            toMatch(/Oct 2\d, 2010 \d{1,2}:\d{2}:\d{2} (AM|PM)/);
         expect(binding("1288323623006 | date:'yyyy-MM-dd HH:mm:ss Z'")).
            toMatch(/2010\-10\-2\d \d{2}:\d{2}:\d{2} (\-|\+)?\d{4}/);
         expect(binding("'1288323623006' | date:'MM/dd/yyyy @ h:mma'")).
            toMatch(/10\/2\d\/2010 @ \d{1,2}:\d{2}(AM|PM)/);
       });
     </doc:scenario>
   </doc:example>
 */
dateFilter.$inject = ['$locale'];
function dateFilter($locale) {


  var R_ISO8601_STR = /^(\d{4})-?(\d\d)-?(\d\d)(?:T(\d\d)(?::?(\d\d)(?::?(\d\d)(?:\.(\d+))?)?)?(Z|([+-])(\d\d):?(\d\d))?)?$/;
  function jsonStringToDate(string){
    var match;
    if (match = string.match(R_ISO8601_STR)) {
      var date = new Date(0),
          tzHour = 0,
          tzMin  = 0;
      if (match[9]) {
        tzHour = int(match[9] + match[10]);
        tzMin = int(match[9] + match[11]);
      }
      date.setUTCFullYear(int(match[1]), int(match[2]) - 1, int(match[3]));
      date.setUTCHours(int(match[4]||0) - tzHour, int(match[5]||0) - tzMin, int(match[6]||0), int(match[7]||0));
      return date;
    }
    return string;
  }


  return function(date, format) {
    var text = '',
        parts = [],
        fn, match;

    format = format || 'mediumDate';
    format = $locale.DATETIME_FORMATS[format] || format;
    if (isString(date)) {
      if (NUMBER_STRING.test(date)) {
        date = int(date);
      } else {
        date = jsonStringToDate(date);
      }
    }

    if (isNumber(date)) {
      date = new Date(date);
    }

    if (!isDate(date)) {
      return date;
    }

    while(format) {
      match = DATE_FORMATS_SPLIT.exec(format);
      if (match) {
        parts = concat(parts, match, 1);
        format = parts.pop();
      } else {
        parts.push(format);
        format = null;
      }
    }

    forEach(parts, function(value){
      fn = DATE_FORMATS[value];
      text += fn ? fn(date, $locale.DATETIME_FORMATS)
                 : value.replace(/(^'|'$)/g, '').replace(/''/g, "'");
    });

    return text;
  };
}


/**
 * @ngdoc filter
 * @name ng.filter:json
 * @function
 *
 * @description
 *   Allows you to convert a JavaScript object into JSON string.
 *
 *   This filter is mostly useful for debugging. When using the double curly {{value}} notation
 *   the binding is automatically converted to JSON.
 *
 * @param {*} object Any JavaScript object (including arrays and primitive types) to filter.
 * @returns {string} JSON string.
 *
 *
 * @example:
   <doc:example>
     <doc:source>
       <pre>{{ {'name':'value'} | json }}</pre>
     </doc:source>
     <doc:scenario>
       it('should jsonify filtered objects', function() {
         expect(binding("{'name':'value'}")).toMatch(/\{\n  "name": ?"value"\n}/);
       });
     </doc:scenario>
   </doc:example>
 *
 */
function jsonFilter() {
  return function(object) {
    return toJson(object, true);
  };
}


/**
 * @ngdoc filter
 * @name ng.filter:lowercase
 * @function
 * @description
 * Converts string to lowercase.
 * @see angular.lowercase
 */
var lowercaseFilter = valueFn(lowercase);


/**
 * @ngdoc filter
 * @name ng.filter:uppercase
 * @function
 * @description
 * Converts string to uppercase.
 * @see angular.uppercase
 */
var uppercaseFilter = valueFn(uppercase);

/**
 * @ngdoc function
 * @name ng.filter:limitTo
 * @function
 *
 * @description
 * Creates a new array containing only a specified number of elements in an array. The elements
 * are taken from either the beginning or the end of the source array, as specified by the
 * value and sign (positive or negative) of `limit`.
 *
 * Note: This function is used to augment the `Array` type in Angular expressions. See
 * {@link ng.$filter} for more information about Angular arrays.
 *
 * @param {Array} array Source array to be limited.
 * @param {string|Number} limit The length of the returned array. If the `limit` number is
 *     positive, `limit` number of items from the beginning of the source array are copied.
 *     If the number is negative, `limit` number  of items from the end of the source array are
 *     copied. The `limit` will be trimmed if it exceeds `array.length`
 * @returns {Array} A new sub-array of length `limit` or less if input array had less than `limit`
 *     elements.
 *
 * @example
   <doc:example>
     <doc:source>
       <script>
         function Ctrl($scope) {
           $scope.numbers = [1,2,3,4,5,6,7,8,9];
           $scope.limit = 3;
         }
       </script>
       <div ng-controller="Ctrl">
         Limit {{numbers}} to: <input type="integer" ng-model="limit">
         <p>Output: {{ numbers | limitTo:limit }}</p>
       </div>
     </doc:source>
     <doc:scenario>
       it('should limit the numer array to first three items', function() {
         expect(element('.doc-example-live input[ng-model=limit]').val()).toBe('3');
         expect(binding('numbers | limitTo:limit')).toEqual('[1,2,3]');
       });

       it('should update the output when -3 is entered', function() {
         input('limit').enter(-3);
         expect(binding('numbers | limitTo:limit')).toEqual('[7,8,9]');
       });

       it('should not exceed the maximum size of input array', function() {
         input('limit').enter(100);
         expect(binding('numbers | limitTo:limit')).toEqual('[1,2,3,4,5,6,7,8,9]');
       });
     </doc:scenario>
   </doc:example>
 */
function limitToFilter(){
  return function(array, limit) {
    if (!(array instanceof Array)) return array;
    limit = int(limit);
    var out = [],
      i, n;

    // check that array is iterable
    if (!array || !(array instanceof Array))
      return out;

    // if abs(limit) exceeds maximum length, trim it
    if (limit > array.length)
      limit = array.length;
    else if (limit < -array.length)
      limit = -array.length;

    if (limit > 0) {
      i = 0;
      n = limit;
    } else {
      i = array.length + limit;
      n = array.length;
    }

    for (; i<n; i++) {
      out.push(array[i]);
    }

    return out;
  }
}

/**
 * @ngdoc function
 * @name ng.filter:orderBy
 * @function
 *
 * @description
 * Orders a specified `array` by the `expression` predicate.
 *
 * Note: this function is used to augment the `Array` type in Angular expressions. See
 * {@link ng.$filter} for more informaton about Angular arrays.
 *
 * @param {Array} array The array to sort.
 * @param {function(*)|string|Array.<(function(*)|string)>} expression A predicate to be
 *    used by the comparator to determine the order of elements.
 *
 *    Can be one of:
 *
 *    - `function`: Getter function. The result of this function will be sorted using the
 *      `<`, `=`, `>` operator.
 *    - `string`: An Angular expression which evaluates to an object to order by, such as 'name'
 *      to sort by a property called 'name'. Optionally prefixed with `+` or `-` to control
 *      ascending or descending sort order (for example, +name or -name).
 *    - `Array`: An array of function or string predicates. The first predicate in the array
 *      is used for sorting, but when two items are equivalent, the next predicate is used.
 *
 * @param {boolean=} reverse Reverse the order the array.
 * @returns {Array} Sorted copy of the source array.
 *
 * @example
   <doc:example>
     <doc:source>
       <script>
         function Ctrl($scope) {
           $scope.friends =
               [{name:'John', phone:'555-1212', age:10},
                {name:'Mary', phone:'555-9876', age:19},
                {name:'Mike', phone:'555-4321', age:21},
                {name:'Adam', phone:'555-5678', age:35},
                {name:'Julie', phone:'555-8765', age:29}]
           $scope.predicate = '-age';
         }
       </script>
       <div ng-controller="Ctrl">
         <pre>Sorting predicate = {{predicate}}; reverse = {{reverse}}</pre>
         <hr/>
         [ <a href="" ng-click="predicate=''">unsorted</a> ]
         <table class="friend">
           <tr>
             <th><a href="" ng-click="predicate = 'name'; reverse=false">Name</a>
                 (<a href ng-click="predicate = '-name'; reverse=false">^</a>)</th>
             <th><a href="" ng-click="predicate = 'phone'; reverse=!reverse">Phone Number</a></th>
             <th><a href="" ng-click="predicate = 'age'; reverse=!reverse">Age</a></th>
           </tr>
           <tr ng-repeat="friend in friends | orderBy:predicate:reverse">
             <td>{{friend.name}}</td>
             <td>{{friend.phone}}</td>
             <td>{{friend.age}}</td>
           </tr>
         </table>
       </div>
     </doc:source>
     <doc:scenario>
       it('should be reverse ordered by aged', function() {
         expect(binding('predicate')).toBe('-age');
         expect(repeater('table.friend', 'friend in friends').column('friend.age')).
           toEqual(['35', '29', '21', '19', '10']);
         expect(repeater('table.friend', 'friend in friends').column('friend.name')).
           toEqual(['Adam', 'Julie', 'Mike', 'Mary', 'John']);
       });

       it('should reorder the table when user selects different predicate', function() {
         element('.doc-example-live a:contains("Name")').click();
         expect(repeater('table.friend', 'friend in friends').column('friend.name')).
           toEqual(['Adam', 'John', 'Julie', 'Mary', 'Mike']);
         expect(repeater('table.friend', 'friend in friends').column('friend.age')).
           toEqual(['35', '10', '29', '19', '21']);

         element('.doc-example-live a:contains("Phone")').click();
         expect(repeater('table.friend', 'friend in friends').column('friend.phone')).
           toEqual(['555-9876', '555-8765', '555-5678', '555-4321', '555-1212']);
         expect(repeater('table.friend', 'friend in friends').column('friend.name')).
           toEqual(['Mary', 'Julie', 'Adam', 'Mike', 'John']);
       });
     </doc:scenario>
   </doc:example>
 */
orderByFilter.$inject = ['$parse'];
function orderByFilter($parse){
  return function(array, sortPredicate, reverseOrder) {
    if (!isArray(array)) return array;
    if (!sortPredicate) return array;
    sortPredicate = isArray(sortPredicate) ? sortPredicate: [sortPredicate];
    sortPredicate = map(sortPredicate, function(predicate){
      var descending = false, get = predicate || identity;
      if (isString(predicate)) {
        if ((predicate.charAt(0) == '+' || predicate.charAt(0) == '-')) {
          descending = predicate.charAt(0) == '-';
          predicate = predicate.substring(1);
        }
        get = $parse(predicate);
      }
      return reverseComparator(function(a,b){
        return compare(get(a),get(b));
      }, descending);
    });
    var arrayCopy = [];
    for ( var i = 0; i < array.length; i++) { arrayCopy.push(array[i]); }
    return arrayCopy.sort(reverseComparator(comparator, reverseOrder));

    function comparator(o1, o2){
      for ( var i = 0; i < sortPredicate.length; i++) {
        var comp = sortPredicate[i](o1, o2);
        if (comp !== 0) return comp;
      }
      return 0;
    }
    function reverseComparator(comp, descending) {
      return toBoolean(descending)
          ? function(a,b){return comp(b,a);}
          : comp;
    }
    function compare(v1, v2){
      var t1 = typeof v1;
      var t2 = typeof v2;
      if (t1 == t2) {
        if (t1 == "string") v1 = v1.toLowerCase();
        if (t1 == "string") v2 = v2.toLowerCase();
        if (v1 === v2) return 0;
        return v1 < v2 ? -1 : 1;
      } else {
        return t1 < t2 ? -1 : 1;
      }
    }
  }
}

function ngDirective(directive) {
  if (isFunction(directive)) {
    directive = {
      link: directive
    }
  }
  directive.restrict = directive.restrict || 'AC';
  return valueFn(directive);
}

/**
 * @ngdoc directive
 * @name ng.directive:a
 * @restrict E
 *
 * @description
 * Modifies the default behavior of html A tag, so that the default action is prevented when href
 * attribute is empty.
 *
 * The reasoning for this change is to allow easy creation of action links with `ngClick` directive
 * without changing the location or causing page reloads, e.g.:
 * `<a href="" ng-click="model.$save()">Save</a>`
 */
var htmlAnchorDirective = valueFn({
  restrict: 'E',
  compile: function(element, attr) {

    if (msie <= 8) {

      // turn <a href ng-click="..">link</a> into a stylable link in IE
      // but only if it doesn't have name attribute, in which case it's an anchor
      if (!attr.href && !attr.name) {
        attr.$set('href', '');
      }

      // add a comment node to anchors to workaround IE bug that causes element content to be reset
      // to new attribute content if attribute is updated with value containing @ and element also
      // contains value with @
      // see issue #1949
      element.append(document.createComment('IE fix'));
    }

    return function(scope, element) {
      element.bind('click', function(event){
        // if we have no href url, then don't navigate anywhere.
        if (!element.attr('href')) {
          event.preventDefault();
        }
      });
    }
  }
});

/**
 * @ngdoc directive
 * @name ng.directive:ngHref
 * @restrict A
 *
 * @description
 * Using Angular markup like {{hash}} in an href attribute makes
 * the page open to a wrong URL, if the user clicks that link before
 * angular has a chance to replace the {{hash}} with actual URL, the
 * link will be broken and will most likely return a 404 error.
 * The `ngHref` directive solves this problem.
 *
 * The buggy way to write it:
 * <pre>
 * <a href="http://www.gravatar.com/avatar/{{hash}}"/>
 * </pre>
 *
 * The correct way to write it:
 * <pre>
 * <a ng-href="http://www.gravatar.com/avatar/{{hash}}"/>
 * </pre>
 *
 * @element A
 * @param {template} ngHref any string which can contain `{{}}` markup.
 *
 * @example
 * This example uses `link` variable inside `href` attribute:
    <doc:example>
      <doc:source>
        <input ng-model="value" /><br />
        <a id="link-1" href ng-click="value = 1">link 1</a> (link, don't reload)<br />
        <a id="link-2" href="" ng-click="value = 2">link 2</a> (link, don't reload)<br />
        <a id="link-3" ng-href="/{{'123'}}">link 3</a> (link, reload!)<br />
        <a id="link-4" href="" name="xx" ng-click="value = 4">anchor</a> (link, don't reload)<br />
        <a id="link-5" name="xxx" ng-click="value = 5">anchor</a> (no link)<br />
        <a id="link-6" ng-href="{{value}}">link</a> (link, change location)
      </doc:source>
      <doc:scenario>
        it('should execute ng-click but not reload when href without value', function() {
          element('#link-1').click();
          expect(input('value').val()).toEqual('1');
          expect(element('#link-1').attr('href')).toBe("");
        });

        it('should execute ng-click but not reload when href empty string', function() {
          element('#link-2').click();
          expect(input('value').val()).toEqual('2');
          expect(element('#link-2').attr('href')).toBe("");
        });

        it('should execute ng-click and change url when ng-href specified', function() {
          expect(element('#link-3').attr('href')).toBe("/123");

          element('#link-3').click();
          expect(browser().window().path()).toEqual('/123');
        });

        it('should execute ng-click but not reload when href empty string and name specified', function() {
          element('#link-4').click();
          expect(input('value').val()).toEqual('4');
          expect(element('#link-4').attr('href')).toBe('');
        });

        it('should execute ng-click but not reload when no href but name specified', function() {
          element('#link-5').click();
          expect(input('value').val()).toEqual('5');
          expect(element('#link-5').attr('href')).toBe(undefined);
        });

        it('should only change url when only ng-href', function() {
          input('value').enter('6');
          expect(element('#link-6').attr('href')).toBe('6');

          element('#link-6').click();
          expect(browser().location().url()).toEqual('/6');
        });
      </doc:scenario>
    </doc:example>
 */

/**
 * @ngdoc directive
 * @name ng.directive:ngSrc
 * @restrict A
 *
 * @description
 * Using Angular markup like `{{hash}}` in a `src` attribute doesn't
 * work right: The browser will fetch from the URL with the literal
 * text `{{hash}}` until Angular replaces the expression inside
 * `{{hash}}`. The `ngSrc` directive solves this problem.
 *
 * The buggy way to write it:
 * <pre>
 * <img src="http://www.gravatar.com/avatar/{{hash}}"/>
 * </pre>
 *
 * The correct way to write it:
 * <pre>
 * <img ng-src="http://www.gravatar.com/avatar/{{hash}}"/>
 * </pre>
 *
 * @element IMG
 * @param {template} ngSrc any string which can contain `{{}}` markup.
 */

/**
 * @ngdoc directive
 * @name ng.directive:ngDisabled
 * @restrict A
 *
 * @description
 *
 * The following markup will make the button enabled on Chrome/Firefox but not on IE8 and older IEs:
 * <pre>
 * <div ng-init="scope = { isDisabled: false }">
 *  <button disabled="{{scope.isDisabled}}">Disabled</button>
 * </div>
 * </pre>
 *
 * The HTML specs do not require browsers to preserve the special attributes such as disabled.
 * (The presence of them means true and absence means false)
 * This prevents the angular compiler from correctly retrieving the binding expression.
 * To solve this problem, we introduce the `ngDisabled` directive.
 *
 * @example
    <doc:example>
      <doc:source>
        Click me to toggle: <input type="checkbox" ng-model="checked"><br/>
        <button ng-model="button" ng-disabled="checked">Button</button>
      </doc:source>
      <doc:scenario>
        it('should toggle button', function() {
          expect(element('.doc-example-live :button').prop('disabled')).toBeFalsy();
          input('checked').check();
          expect(element('.doc-example-live :button').prop('disabled')).toBeTruthy();
        });
      </doc:scenario>
    </doc:example>
 *
 * @element INPUT
 * @param {expression} ngDisabled Angular expression that will be evaluated.
 */


/**
 * @ngdoc directive
 * @name ng.directive:ngChecked
 * @restrict A
 *
 * @description
 * The HTML specs do not require browsers to preserve the special attributes such as checked.
 * (The presence of them means true and absence means false)
 * This prevents the angular compiler from correctly retrieving the binding expression.
 * To solve this problem, we introduce the `ngChecked` directive.
 * @example
    <doc:example>
      <doc:source>
        Check me to check both: <input type="checkbox" ng-model="master"><br/>
        <input id="checkSlave" type="checkbox" ng-checked="master">
      </doc:source>
      <doc:scenario>
        it('should check both checkBoxes', function() {
          expect(element('.doc-example-live #checkSlave').prop('checked')).toBeFalsy();
          input('master').check();
          expect(element('.doc-example-live #checkSlave').prop('checked')).toBeTruthy();
        });
      </doc:scenario>
    </doc:example>
 *
 * @element INPUT
 * @param {expression} ngChecked Angular expression that will be evaluated.
 */


/**
 * @ngdoc directive
 * @name ng.directive:ngMultiple
 * @restrict A
 *
 * @description
 * The HTML specs do not require browsers to preserve the special attributes such as multiple.
 * (The presence of them means true and absence means false)
 * This prevents the angular compiler from correctly retrieving the binding expression.
 * To solve this problem, we introduce the `ngMultiple` directive.
 *
 * @example
     <doc:example>
       <doc:source>
         Check me check multiple: <input type="checkbox" ng-model="checked"><br/>
         <select id="select" ng-multiple="checked">
           <option>Misko</option>
           <option>Igor</option>
           <option>Vojta</option>
           <option>Di</option>
         </select>
       </doc:source>
       <doc:scenario>
         it('should toggle multiple', function() {
           expect(element('.doc-example-live #select').prop('multiple')).toBeFalsy();
           input('checked').check();
           expect(element('.doc-example-live #select').prop('multiple')).toBeTruthy();
         });
       </doc:scenario>
     </doc:example>
 *
 * @element SELECT
 * @param {expression} ngMultiple Angular expression that will be evaluated.
 */


/**
 * @ngdoc directive
 * @name ng.directive:ngReadonly
 * @restrict A
 *
 * @description
 * The HTML specs do not require browsers to preserve the special attributes such as readonly.
 * (The presence of them means true and absence means false)
 * This prevents the angular compiler from correctly retrieving the binding expression.
 * To solve this problem, we introduce the `ngReadonly` directive.
 * @example
    <doc:example>
      <doc:source>
        Check me to make text readonly: <input type="checkbox" ng-model="checked"><br/>
        <input type="text" ng-readonly="checked" value="I'm Angular"/>
      </doc:source>
      <doc:scenario>
        it('should toggle readonly attr', function() {
          expect(element('.doc-example-live :text').prop('readonly')).toBeFalsy();
          input('checked').check();
          expect(element('.doc-example-live :text').prop('readonly')).toBeTruthy();
        });
      </doc:scenario>
    </doc:example>
 *
 * @element INPUT
 * @param {string} expression Angular expression that will be evaluated.
 */


/**
 * @ngdoc directive
 * @name ng.directive:ngSelected
 * @restrict A
 *
 * @description
 * The HTML specs do not require browsers to preserve the special attributes such as selected.
 * (The presence of them means true and absence means false)
 * This prevents the angular compiler from correctly retrieving the binding expression.
 * To solve this problem, we introduced the `ngSelected` directive.
 * @example
    <doc:example>
      <doc:source>
        Check me to select: <input type="checkbox" ng-model="selected"><br/>
        <select>
          <option>Hello!</option>
          <option id="greet" ng-selected="selected">Greetings!</option>
        </select>
      </doc:source>
      <doc:scenario>
        it('should select Greetings!', function() {
          expect(element('.doc-example-live #greet').prop('selected')).toBeFalsy();
          input('selected').check();
          expect(element('.doc-example-live #greet').prop('selected')).toBeTruthy();
        });
      </doc:scenario>
    </doc:example>
 *
 * @element OPTION
 * @param {string} expression Angular expression that will be evaluated.
 */


var ngAttributeAliasDirectives = {};


// boolean attrs are evaluated
forEach(BOOLEAN_ATTR, function(propName, attrName) {
  var normalized = directiveNormalize('ng-' + attrName);
  ngAttributeAliasDirectives[normalized] = function() {
    return {
      priority: 100,
      compile: function() {
        return function(scope, element, attr) {
          scope.$watch(attr[normalized], function ngBooleanAttrWatchAction(value) {
            attr.$set(attrName, !!value);
          });
        };
      }
    };
  };
});


// ng-src, ng-href are interpolated
forEach(['src', 'href'], function(attrName) {
  var normalized = directiveNormalize('ng-' + attrName);
  ngAttributeAliasDirectives[normalized] = function() {
    return {
      priority: 99, // it needs to run after the attributes are interpolated
      link: function(scope, element, attr) {
        attr.$observe(normalized, function(value) {
          if (!value)
             return;

          attr.$set(attrName, value);

          // on IE, if "ng:src" directive declaration is used and "src" attribute doesn't exist
          // then calling element.setAttribute('src', 'foo') doesn't do anything, so we need
          // to set the property as well to achieve the desired effect.
          // we use attr[attrName] value since $set can sanitize the url.
          if (msie) element.prop(attrName, attr[attrName]);
        });
      }
    };
  };
});

var nullFormCtrl = {
  $addControl: noop,
  $removeControl: noop,
  $setValidity: noop,
  $setDirty: noop
};

/**
 * @ngdoc object
 * @name ng.directive:form.FormController
 *
 * @property {boolean} $pristine True if user has not interacted with the form yet.
 * @property {boolean} $dirty True if user has already interacted with the form.
 * @property {boolean} $valid True if all of the containing forms and controls are valid.
 * @property {boolean} $invalid True if at least one containing control or form is invalid.
 *
 * @property {Object} $error Is an object hash, containing references to all invalid controls or
 *  forms, where:
 *
 *  - keys are validation tokens (error names) — such as `required`, `url` or `email`),
 *  - values are arrays of controls or forms that are invalid with given error.
 *
 * @description
 * `FormController` keeps track of all its controls and nested forms as well as state of them,
 * such as being valid/invalid or dirty/pristine.
 *
 * Each {@link ng.directive:form form} directive creates an instance
 * of `FormController`.
 *
 */
//asks for $scope to fool the BC controller module
FormController.$inject = ['$element', '$attrs', '$scope'];
function FormController(element, attrs) {
  var form = this,
      parentForm = element.parent().controller('form') || nullFormCtrl,
      invalidCount = 0, // used to easily determine if we are valid
      errors = form.$error = {};

  // init state
  form.$name = attrs.name;
  form.$dirty = false;
  form.$pristine = true;
  form.$valid = true;
  form.$invalid = false;

  parentForm.$addControl(form);

  // Setup initial state of the control
  element.addClass(PRISTINE_CLASS);
  toggleValidCss(true);

  // convenience method for easy toggling of classes
  function toggleValidCss(isValid, validationErrorKey) {
    validationErrorKey = validationErrorKey ? '-' + snake_case(validationErrorKey, '-') : '';
    element.
      removeClass((isValid ? INVALID_CLASS : VALID_CLASS) + validationErrorKey).
      addClass((isValid ? VALID_CLASS : INVALID_CLASS) + validationErrorKey);
  }

  form.$addControl = function(control) {
    if (control.$name && !form.hasOwnProperty(control.$name)) {
      form[control.$name] = control;
    }
  };

  form.$removeControl = function(control) {
    if (control.$name && form[control.$name] === control) {
      delete form[control.$name];
    }
    forEach(errors, function(queue, validationToken) {
      form.$setValidity(validationToken, true, control);
    });
  };

  form.$setValidity = function(validationToken, isValid, control) {
    var queue = errors[validationToken];

    if (isValid) {
      if (queue) {
        arrayRemove(queue, control);
        if (!queue.length) {
          invalidCount--;
          if (!invalidCount) {
            toggleValidCss(isValid);
            form.$valid = true;
            form.$invalid = false;
          }
          errors[validationToken] = false;
          toggleValidCss(true, validationToken);
          parentForm.$setValidity(validationToken, true, form);
        }
      }

    } else {
      if (!invalidCount) {
        toggleValidCss(isValid);
      }
      if (queue) {
        if (includes(queue, control)) return;
      } else {
        errors[validationToken] = queue = [];
        invalidCount++;
        toggleValidCss(false, validationToken);
        parentForm.$setValidity(validationToken, false, form);
      }
      queue.push(control);

      form.$valid = false;
      form.$invalid = true;
    }
  };

  form.$setDirty = function() {
    element.removeClass(PRISTINE_CLASS).addClass(DIRTY_CLASS);
    form.$dirty = true;
    form.$pristine = false;
    parentForm.$setDirty();
  };

}


/**
 * @ngdoc directive
 * @name ng.directive:ngForm
 * @restrict EAC
 *
 * @description
 * Nestable alias of {@link ng.directive:form `form`} directive. HTML
 * does not allow nesting of form elements. It is useful to nest forms, for example if the validity of a
 * sub-group of controls needs to be determined.
 *
 * @param {string=} name|ngForm Name of the form. If specified, the form controller will be published into
 *                       related scope, under this name.
 *
 */

 /**
 * @ngdoc directive
 * @name ng.directive:form
 * @restrict E
 *
 * @description
 * Directive that instantiates
 * {@link ng.directive:form.FormController FormController}.
 *
 * If `name` attribute is specified, the form controller is published onto the current scope under
 * this name.
 *
 * # Alias: {@link ng.directive:ngForm `ngForm`}
 *
 * In angular forms can be nested. This means that the outer form is valid when all of the child
 * forms are valid as well. However browsers do not allow nesting of `<form>` elements, for this
 * reason angular provides {@link ng.directive:ngForm `ngForm`} alias
 * which behaves identical to `<form>` but allows form nesting.
 *
 *
 * # CSS classes
 *  - `ng-valid` Is set if the form is valid.
 *  - `ng-invalid` Is set if the form is invalid.
 *  - `ng-pristine` Is set if the form is pristine.
 *  - `ng-dirty` Is set if the form is dirty.
 *
 *
 * # Submitting a form and preventing default action
 *
 * Since the role of forms in client-side Angular applications is different than in classical
 * roundtrip apps, it is desirable for the browser not to translate the form submission into a full
 * page reload that sends the data to the server. Instead some javascript logic should be triggered
 * to handle the form submission in application specific way.
 *
 * For this reason, Angular prevents the default action (form submission to the server) unless the
 * `<form>` element has an `action` attribute specified.
 *
 * You can use one of the following two ways to specify what javascript method should be called when
 * a form is submitted:
 *
 * - {@link ng.directive:ngSubmit ngSubmit} directive on the form element
 * - {@link ng.directive:ngClick ngClick} directive on the first
  *  button or input field of type submit (input[type=submit])
 *
 * To prevent double execution of the handler, use only one of ngSubmit or ngClick directives. This
 * is because of the following form submission rules coming from the html spec:
 *
 * - If a form has only one input field then hitting enter in this field triggers form submit
 * (`ngSubmit`)
 * - if a form has has 2+ input fields and no buttons or input[type=submit] then hitting enter
 * doesn't trigger submit
 * - if a form has one or more input fields and one or more buttons or input[type=submit] then
 * hitting enter in any of the input fields will trigger the click handler on the *first* button or
 * input[type=submit] (`ngClick`) *and* a submit handler on the enclosing form (`ngSubmit`)
 *
 * @param {string=} name Name of the form. If specified, the form controller will be published into
 *                       related scope, under this name.
 *
 * @example
    <doc:example>
      <doc:source>
       <script>
         function Ctrl($scope) {
           $scope.userType = 'guest';
         }
       </script>
       <form name="myForm" ng-controller="Ctrl">
         userType: <input name="input" ng-model="userType" required>
         <span class="error" ng-show="myForm.input.$error.required">Required!</span><br>
         <tt>userType = {{userType}}</tt><br>
         <tt>myForm.input.$valid = {{myForm.input.$valid}}</tt><br>
         <tt>myForm.input.$error = {{myForm.input.$error}}</tt><br>
         <tt>myForm.$valid = {{myForm.$valid}}</tt><br>
         <tt>myForm.$error.required = {{!!myForm.$error.required}}</tt><br>
        </form>
      </doc:source>
      <doc:scenario>
        it('should initialize to model', function() {
         expect(binding('userType')).toEqual('guest');
         expect(binding('myForm.input.$valid')).toEqual('true');
        });

        it('should be invalid if empty', function() {
         input('userType').enter('');
         expect(binding('userType')).toEqual('');
         expect(binding('myForm.input.$valid')).toEqual('false');
        });
      </doc:scenario>
    </doc:example>
 */
var formDirectiveFactory = function(isNgForm) {
  return ['$timeout', function($timeout) {
    var formDirective = {
      name: 'form',
      restrict: 'E',
      controller: FormController,
      compile: function() {
        return {
          pre: function(scope, formElement, attr, controller) {
            if (!attr.action) {
              // we can't use jq events because if a form is destroyed during submission the default
              // action is not prevented. see #1238
              //
              // IE 9 is not affected because it doesn't fire a submit event and try to do a full
              // page reload if the form was destroyed by submission of the form via a click handler
              // on a button in the form. Looks like an IE9 specific bug.
              var preventDefaultListener = function(event) {
                event.preventDefault
                  ? event.preventDefault()
                  : event.returnValue = false; // IE
              };

              addEventListenerFn(formElement[0], 'submit', preventDefaultListener);

              // unregister the preventDefault listener so that we don't not leak memory but in a
              // way that will achieve the prevention of the default action.
              formElement.bind('$destroy', function() {
                $timeout(function() {
                  removeEventListenerFn(formElement[0], 'submit', preventDefaultListener);
                }, 0, false);
              });
            }

            var parentFormCtrl = formElement.parent().controller('form'),
                alias = attr.name || attr.ngForm;

            if (alias) {
              scope[alias] = controller;
            }
            if (parentFormCtrl) {
              formElement.bind('$destroy', function() {
                parentFormCtrl.$removeControl(controller);
                if (alias) {
                  scope[alias] = undefined;
                }
                extend(controller, nullFormCtrl); //stop propagating child destruction handlers upwards
              });
            }
          }
        };
      }
    };

    return isNgForm ? extend(copy(formDirective), {restrict: 'EAC'}) : formDirective;
  }];
};

var formDirective = formDirectiveFactory();
var ngFormDirective = formDirectiveFactory(true);

var URL_REGEXP = /^(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?$/;
var EMAIL_REGEXP = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/;
var NUMBER_REGEXP = /^\s*(\-|\+)?(\d+|(\d*(\.\d*)))\s*$/;

var inputType = {

  /**
   * @ngdoc inputType
   * @name ng.directive:input.text
   *
   * @description
   * Standard HTML text input with angular data binding.
   *
   * @param {string} ngModel Assignable angular expression to data-bind to.
   * @param {string=} name Property name of the form under which the control is published.
   * @param {string=} required Adds `required` validation error key if the value is not entered.
   * @param {string=} ngRequired Adds `required` attribute and `required` validation constraint to
   *    the element when the ngRequired expression evaluates to true. Use `ngRequired` instead of
   *    `required` when you want to data-bind to the `required` attribute.
   * @param {number=} ngMinlength Sets `minlength` validation error key if the value is shorter than
   *    minlength.
   * @param {number=} ngMaxlength Sets `maxlength` validation error key if the value is longer than
   *    maxlength.
   * @param {string=} ngPattern Sets `pattern` validation error key if the value does not match the
   *    RegExp pattern expression. Expected value is `/regexp/` for inline patterns or `regexp` for
   *    patterns defined as scope expressions.
   * @param {string=} ngChange Angular expression to be executed when input changes due to user
   *    interaction with the input element.
   *
   * @example
      <doc:example>
        <doc:source>
         <script>
           function Ctrl($scope) {
             $scope.text = 'guest';
             $scope.word = /^\w*$/;
           }
         </script>
         <form name="myForm" ng-controller="Ctrl">
           Single word: <input type="text" name="input" ng-model="text"
                               ng-pattern="word" required>
           <span class="error" ng-show="myForm.input.$error.required">
             Required!</span>
           <span class="error" ng-show="myForm.input.$error.pattern">
             Single word only!</span>

           <tt>text = {{text}}</tt><br/>
           <tt>myForm.input.$valid = {{myForm.input.$valid}}</tt><br/>
           <tt>myForm.input.$error = {{myForm.input.$error}}</tt><br/>
           <tt>myForm.$valid = {{myForm.$valid}}</tt><br/>
           <tt>myForm.$error.required = {{!!myForm.$error.required}}</tt><br/>
          </form>
        </doc:source>
        <doc:scenario>
          it('should initialize to model', function() {
            expect(binding('text')).toEqual('guest');
            expect(binding('myForm.input.$valid')).toEqual('true');
          });

          it('should be invalid if empty', function() {
            input('text').enter('');
            expect(binding('text')).toEqual('');
            expect(binding('myForm.input.$valid')).toEqual('false');
          });

          it('should be invalid if multi word', function() {
            input('text').enter('hello world');
            expect(binding('myForm.input.$valid')).toEqual('false');
          });
        </doc:scenario>
      </doc:example>
   */
  'text': textInputType,


  /**
   * @ngdoc inputType
   * @name ng.directive:input.number
   *
   * @description
   * Text input with number validation and transformation. Sets the `number` validation
   * error if not a valid number.
   *
   * @param {string} ngModel Assignable angular expression to data-bind to.
   * @param {string=} name Property name of the form under which the control is published.
   * @param {string=} min Sets the `min` validation error key if the value entered is less than `min`.
   * @param {string=} max Sets the `max` validation error key if the value entered is greater than `max`.
   * @param {string=} required Sets `required` validation error key if the value is not entered.
   * @param {string=} ngRequired Adds `required` attribute and `required` validation constraint to
   *    the element when the ngRequired expression evaluates to true. Use `ngRequired` instead of
   *    `required` when you want to data-bind to the `required` attribute.
   * @param {number=} ngMinlength Sets `minlength` validation error key if the value is shorter than
   *    minlength.
   * @param {number=} ngMaxlength Sets `maxlength` validation error key if the value is longer than
   *    maxlength.
   * @param {string=} ngPattern Sets `pattern` validation error key if the value does not match the
   *    RegExp pattern expression. Expected value is `/regexp/` for inline patterns or `regexp` for
   *    patterns defined as scope expressions.
   * @param {string=} ngChange Angular expression to be executed when input changes due to user
   *    interaction with the input element.
   *
   * @example
      <doc:example>
        <doc:source>
         <script>
           function Ctrl($scope) {
             $scope.value = 12;
           }
         </script>
         <form name="myForm" ng-controller="Ctrl">
           Number: <input type="number" name="input" ng-model="value"
                          min="0" max="99" required>
           <span class="error" ng-show="myForm.list.$error.required">
             Required!</span>
           <span class="error" ng-show="myForm.list.$error.number">
             Not valid number!</span>
           <tt>value = {{value}}</tt><br/>
           <tt>myForm.input.$valid = {{myForm.input.$valid}}</tt><br/>
           <tt>myForm.input.$error = {{myForm.input.$error}}</tt><br/>
           <tt>myForm.$valid = {{myForm.$valid}}</tt><br/>
           <tt>myForm.$error.required = {{!!myForm.$error.required}}</tt><br/>
          </form>
        </doc:source>
        <doc:scenario>
          it('should initialize to model', function() {
           expect(binding('value')).toEqual('12');
           expect(binding('myForm.input.$valid')).toEqual('true');
          });

          it('should be invalid if empty', function() {
           input('value').enter('');
           expect(binding('value')).toEqual('');
           expect(binding('myForm.input.$valid')).toEqual('false');
          });

          it('should be invalid if over max', function() {
           input('value').enter('123');
           expect(binding('value')).toEqual('');
           expect(binding('myForm.input.$valid')).toEqual('false');
          });
        </doc:scenario>
      </doc:example>
   */
  'number': numberInputType,


  /**
   * @ngdoc inputType
   * @name ng.directive:input.url
   *
   * @description
   * Text input with URL validation. Sets the `url` validation error key if the content is not a
   * valid URL.
   *
   * @param {string} ngModel Assignable angular expression to data-bind to.
   * @param {string=} name Property name of the form under which the control is published.
   * @param {string=} required Sets `required` validation error key if the value is not entered.
   * @param {string=} ngRequired Adds `required` attribute and `required` validation constraint to
   *    the element when the ngRequired expression evaluates to true. Use `ngRequired` instead of
   *    `required` when you want to data-bind to the `required` attribute.
   * @param {number=} ngMinlength Sets `minlength` validation error key if the value is shorter than
   *    minlength.
   * @param {number=} ngMaxlength Sets `maxlength` validation error key if the value is longer than
   *    maxlength.
   * @param {string=} ngPattern Sets `pattern` validation error key if the value does not match the
   *    RegExp pattern expression. Expected value is `/regexp/` for inline patterns or `regexp` for
   *    patterns defined as scope expressions.
   * @param {string=} ngChange Angular expression to be executed when input changes due to user
   *    interaction with the input element.
   *
   * @example
      <doc:example>
        <doc:source>
         <script>
           function Ctrl($scope) {
             $scope.text = 'http://google.com';
           }
         </script>
         <form name="myForm" ng-controller="Ctrl">
           URL: <input type="url" name="input" ng-model="text" required>
           <span class="error" ng-show="myForm.input.$error.required">
             Required!</span>
           <span class="error" ng-show="myForm.input.$error.url">
             Not valid url!</span>
           <tt>text = {{text}}</tt><br/>
           <tt>myForm.input.$valid = {{myForm.input.$valid}}</tt><br/>
           <tt>myForm.input.$error = {{myForm.input.$error}}</tt><br/>
           <tt>myForm.$valid = {{myForm.$valid}}</tt><br/>
           <tt>myForm.$error.required = {{!!myForm.$error.required}}</tt><br/>
           <tt>myForm.$error.url = {{!!myForm.$error.url}}</tt><br/>
          </form>
        </doc:source>
        <doc:scenario>
          it('should initialize to model', function() {
            expect(binding('text')).toEqual('http://google.com');
            expect(binding('myForm.input.$valid')).toEqual('true');
          });

          it('should be invalid if empty', function() {
            input('text').enter('');
            expect(binding('text')).toEqual('');
            expect(binding('myForm.input.$valid')).toEqual('false');
          });

          it('should be invalid if not url', function() {
            input('text').enter('xxx');
            expect(binding('myForm.input.$valid')).toEqual('false');
          });
        </doc:scenario>
      </doc:example>
   */
  'url': urlInputType,


  /**
   * @ngdoc inputType
   * @name ng.directive:input.email
   *
   * @description
   * Text input with email validation. Sets the `email` validation error key if not a valid email
   * address.
   *
   * @param {string} ngModel Assignable angular expression to data-bind to.
   * @param {string=} name Property name of the form under which the control is published.
   * @param {string=} required Sets `required` validation error key if the value is not entered.
   * @param {string=} ngRequired Adds `required` attribute and `required` validation constraint to
   *    the element when the ngRequired expression evaluates to true. Use `ngRequired` instead of
   *    `required` when you want to data-bind to the `required` attribute.
   * @param {number=} ngMinlength Sets `minlength` validation error key if the value is shorter than
   *    minlength.
   * @param {number=} ngMaxlength Sets `maxlength` validation error key if the value is longer than
   *    maxlength.
   * @param {string=} ngPattern Sets `pattern` validation error key if the value does not match the
   *    RegExp pattern expression. Expected value is `/regexp/` for inline patterns or `regexp` for
   *    patterns defined as scope expressions.
   *
   * @example
      <doc:example>
        <doc:source>
         <script>
           function Ctrl($scope) {
             $scope.text = 'me@example.com';
           }
         </script>
           <form name="myForm" ng-controller="Ctrl">
             Email: <input type="email" name="input" ng-model="text" required>
             <span class="error" ng-show="myForm.input.$error.required">
               Required!</span>
             <span class="error" ng-show="myForm.input.$error.email">
               Not valid email!</span>
             <tt>text = {{text}}</tt><br/>
             <tt>myForm.input.$valid = {{myForm.input.$valid}}</tt><br/>
             <tt>myForm.input.$error = {{myForm.input.$error}}</tt><br/>
             <tt>myForm.$valid = {{myForm.$valid}}</tt><br/>
             <tt>myForm.$error.required = {{!!myForm.$error.required}}</tt><br/>
             <tt>myForm.$error.email = {{!!myForm.$error.email}}</tt><br/>
           </form>
        </doc:source>
        <doc:scenario>
          it('should initialize to model', function() {
            expect(binding('text')).toEqual('me@example.com');
            expect(binding('myForm.input.$valid')).toEqual('true');
          });

          it('should be invalid if empty', function() {
            input('text').enter('');
            expect(binding('text')).toEqual('');
            expect(binding('myForm.input.$valid')).toEqual('false');
          });

          it('should be invalid if not email', function() {
            input('text').enter('xxx');
            expect(binding('myForm.input.$valid')).toEqual('false');
          });
        </doc:scenario>
      </doc:example>
   */
  'email': emailInputType,


  /**
   * @ngdoc inputType
   * @name ng.directive:input.radio
   *
   * @description
   * HTML radio button.
   *
   * @param {string} ngModel Assignable angular expression to data-bind to.
   * @param {string} value The value to which the expression should be set when selected.
   * @param {string=} name Property name of the form under which the control is published.
   * @param {string=} ngChange Angular expression to be executed when input changes due to user
   *    interaction with the input element.
   *
   * @example
      <doc:example>
        <doc:source>
         <script>
           function Ctrl($scope) {
             $scope.color = 'blue';
           }
         </script>
         <form name="myForm" ng-controller="Ctrl">
           <input type="radio" ng-model="color" value="red">  Red <br/>
           <input type="radio" ng-model="color" value="green"> Green <br/>
           <input type="radio" ng-model="color" value="blue"> Blue <br/>
           <tt>color = {{color}}</tt><br/>
          </form>
        </doc:source>
        <doc:scenario>
          it('should change state', function() {
            expect(binding('color')).toEqual('blue');

            input('color').select('red');
            expect(binding('color')).toEqual('red');
          });
        </doc:scenario>
      </doc:example>
   */
  'radio': radioInputType,


  /**
   * @ngdoc inputType
   * @name ng.directive:input.checkbox
   *
   * @description
   * HTML checkbox.
   *
   * @param {string} ngModel Assignable angular expression to data-bind to.
   * @param {string=} name Property name of the form under which the control is published.
   * @param {string=} ngTrueValue The value to which the expression should be set when selected.
   * @param {string=} ngFalseValue The value to which the expression should be set when not selected.
   * @param {string=} ngChange Angular expression to be executed when input changes due to user
   *    interaction with the input element.
   *
   * @example
      <doc:example>
        <doc:source>
         <script>
           function Ctrl($scope) {
             $scope.value1 = true;
             $scope.value2 = 'YES'
           }
         </script>
         <form name="myForm" ng-controller="Ctrl">
           Value1: <input type="checkbox" ng-model="value1"> <br/>
           Value2: <input type="checkbox" ng-model="value2"
                          ng-true-value="YES" ng-false-value="NO"> <br/>
           <tt>value1 = {{value1}}</tt><br/>
           <tt>value2 = {{value2}}</tt><br/>
          </form>
        </doc:source>
        <doc:scenario>
          it('should change state', function() {
            expect(binding('value1')).toEqual('true');
            expect(binding('value2')).toEqual('YES');

            input('value1').check();
            input('value2').check();
            expect(binding('value1')).toEqual('false');
            expect(binding('value2')).toEqual('NO');
          });
        </doc:scenario>
      </doc:example>
   */
  'checkbox': checkboxInputType,

  'hidden': noop,
  'button': noop,
  'submit': noop,
  'reset': noop
};


function isEmpty(value) {
  return isUndefined(value) || value === '' || value === null || value !== value;
}


function textInputType(scope, element, attr, ctrl, $sniffer, $browser) {

  var listener = function() {
    var value = trim(element.val());

    if (ctrl.$viewValue !== value) {
      scope.$apply(function() {
        ctrl.$setViewValue(value);
      });
    }
  };

  // if the browser does support "input" event, we are fine - except on IE9 which doesn't fire the
  // input event on backspace, delete or cut
  if ($sniffer.hasEvent('input')) {
    element.bind('input', listener);
  } else {
    var timeout;

    var deferListener = function() {
      if (!timeout) {
        timeout = $browser.defer(function() {
          listener();
          timeout = null;
        });
      }
    };

    element.bind('keydown', function(event) {
      var key = event.keyCode;

      // ignore
      //    command            modifiers                   arrows
      if (key === 91 || (15 < key && key < 19) || (37 <= key && key <= 40)) return;

      deferListener();
    });

    // if user paste into input using mouse, we need "change" event to catch it
    element.bind('change', listener);

    // if user modifies input value using context menu in IE, we need "paste" and "cut" events to catch it
    if ($sniffer.hasEvent('paste')) {
      element.bind('paste cut', deferListener);
    }
  }


  ctrl.$render = function() {
    element.val(isEmpty(ctrl.$viewValue) ? '' : ctrl.$viewValue);
  };

  // pattern validator
  var pattern = attr.ngPattern,
      patternValidator;

  var validate = function(regexp, value) {
    if (isEmpty(value) || regexp.test(value)) {
      ctrl.$setValidity('pattern', true);
      return value;
    } else {
      ctrl.$setValidity('pattern', false);
      return undefined;
    }
  };

  if (pattern) {
    if (pattern.match(/^\/(.*)\/$/)) {
      pattern = new RegExp(pattern.substr(1, pattern.length - 2));
      patternValidator = function(value) {
        return validate(pattern, value)
      };
    } else {
      patternValidator = function(value) {
        var patternObj = scope.$eval(pattern);

        if (!patternObj || !patternObj.test) {
          throw new Error('Expected ' + pattern + ' to be a RegExp but was ' + patternObj);
        }
        return validate(patternObj, value);
      };
    }

    ctrl.$formatters.push(patternValidator);
    ctrl.$parsers.push(patternValidator);
  }

  // min length validator
  if (attr.ngMinlength) {
    var minlength = int(attr.ngMinlength);
    var minLengthValidator = function(value) {
      if (!isEmpty(value) && value.length < minlength) {
        ctrl.$setValidity('minlength', false);
        return undefined;
      } else {
        ctrl.$setValidity('minlength', true);
        return value;
      }
    };

    ctrl.$parsers.push(minLengthValidator);
    ctrl.$formatters.push(minLengthValidator);
  }

  // max length validator
  if (attr.ngMaxlength) {
    var maxlength = int(attr.ngMaxlength);
    var maxLengthValidator = function(value) {
      if (!isEmpty(value) && value.length > maxlength) {
        ctrl.$setValidity('maxlength', false);
        return undefined;
      } else {
        ctrl.$setValidity('maxlength', true);
        return value;
      }
    };

    ctrl.$parsers.push(maxLengthValidator);
    ctrl.$formatters.push(maxLengthValidator);
  }
}

function numberInputType(scope, element, attr, ctrl, $sniffer, $browser) {
  textInputType(scope, element, attr, ctrl, $sniffer, $browser);

  ctrl.$parsers.push(function(value) {
    var empty = isEmpty(value);
    if (empty || NUMBER_REGEXP.test(value)) {
      ctrl.$setValidity('number', true);
      return value === '' ? null : (empty ? value : parseFloat(value));
    } else {
      ctrl.$setValidity('number', false);
      return undefined;
    }
  });

  ctrl.$formatters.push(function(value) {
    return isEmpty(value) ? '' : '' + value;
  });

  if (attr.min) {
    var min = parseFloat(attr.min);
    var minValidator = function(value) {
      if (!isEmpty(value) && value < min) {
        ctrl.$setValidity('min', false);
        return undefined;
      } else {
        ctrl.$setValidity('min', true);
        return value;
      }
    };

    ctrl.$parsers.push(minValidator);
    ctrl.$formatters.push(minValidator);
  }

  if (attr.max) {
    var max = parseFloat(attr.max);
    var maxValidator = function(value) {
      if (!isEmpty(value) && value > max) {
        ctrl.$setValidity('max', false);
        return undefined;
      } else {
        ctrl.$setValidity('max', true);
        return value;
      }
    };

    ctrl.$parsers.push(maxValidator);
    ctrl.$formatters.push(maxValidator);
  }

  ctrl.$formatters.push(function(value) {

    if (isEmpty(value) || isNumber(value)) {
      ctrl.$setValidity('number', true);
      return value;
    } else {
      ctrl.$setValidity('number', false);
      return undefined;
    }
  });
}

function urlInputType(scope, element, attr, ctrl, $sniffer, $browser) {
  textInputType(scope, element, attr, ctrl, $sniffer, $browser);

  var urlValidator = function(value) {
    if (isEmpty(value) || URL_REGEXP.test(value)) {
      ctrl.$setValidity('url', true);
      return value;
    } else {
      ctrl.$setValidity('url', false);
      return undefined;
    }
  };

  ctrl.$formatters.push(urlValidator);
  ctrl.$parsers.push(urlValidator);
}

function emailInputType(scope, element, attr, ctrl, $sniffer, $browser) {
  textInputType(scope, element, attr, ctrl, $sniffer, $browser);

  var emailValidator = function(value) {
    if (isEmpty(value) || EMAIL_REGEXP.test(value)) {
      ctrl.$setValidity('email', true);
      return value;
    } else {
      ctrl.$setValidity('email', false);
      return undefined;
    }
  };

  ctrl.$formatters.push(emailValidator);
  ctrl.$parsers.push(emailValidator);
}

function radioInputType(scope, element, attr, ctrl) {
  // make the name unique, if not defined
  if (isUndefined(attr.name)) {
    element.attr('name', nextUid());
  }

  element.bind('click', function() {
    if (element[0].checked) {
      scope.$apply(function() {
        ctrl.$setViewValue(attr.value);
      });
    }
  });

  ctrl.$render = function() {
    var value = attr.value;
    element[0].checked = (value == ctrl.$viewValue);
  };

  attr.$observe('value', ctrl.$render);
}

function checkboxInputType(scope, element, attr, ctrl) {
  var trueValue = attr.ngTrueValue,
      falseValue = attr.ngFalseValue;

  if (!isString(trueValue)) trueValue = true;
  if (!isString(falseValue)) falseValue = false;

  element.bind('click', function() {
    scope.$apply(function() {
      ctrl.$setViewValue(element[0].checked);
    });
  });

  ctrl.$render = function() {
    element[0].checked = ctrl.$viewValue;
  };

  ctrl.$formatters.push(function(value) {
    return value === trueValue;
  });

  ctrl.$parsers.push(function(value) {
    return value ? trueValue : falseValue;
  });
}


/**
 * @ngdoc directive
 * @name ng.directive:textarea
 * @restrict E
 *
 * @description
 * HTML textarea element control with angular data-binding. The data-binding and validation
 * properties of this element are exactly the same as those of the
 * {@link ng.directive:input input element}.
 *
 * @param {string} ngModel Assignable angular expression to data-bind to.
 * @param {string=} name Property name of the form under which the control is published.
 * @param {string=} required Sets `required` validation error key if the value is not entered.
 * @param {string=} ngRequired Adds `required` attribute and `required` validation constraint to
 *    the element when the ngRequired expression evaluates to true. Use `ngRequired` instead of
 *    `required` when you want to data-bind to the `required` attribute.
 * @param {number=} ngMinlength Sets `minlength` validation error key if the value is shorter than
 *    minlength.
 * @param {number=} ngMaxlength Sets `maxlength` validation error key if the value is longer than
 *    maxlength.
 * @param {string=} ngPattern Sets `pattern` validation error key if the value does not match the
 *    RegExp pattern expression. Expected value is `/regexp/` for inline patterns or `regexp` for
 *    patterns defined as scope expressions.
 * @param {string=} ngChange Angular expression to be executed when input changes due to user
 *    interaction with the input element.
 */


/**
 * @ngdoc directive
 * @name ng.directive:input
 * @restrict E
 *
 * @description
 * HTML input element control with angular data-binding. Input control follows HTML5 input types
 * and polyfills the HTML5 validation behavior for older browsers.
 *
 * @param {string} ngModel Assignable angular expression to data-bind to.
 * @param {string=} name Property name of the form under which the control is published.
 * @param {string=} required Sets `required` validation error key if the value is not entered.
 * @param {boolean=} ngRequired Sets `required` attribute if set to true
 * @param {number=} ngMinlength Sets `minlength` validation error key if the value is shorter than
 *    minlength.
 * @param {number=} ngMaxlength Sets `maxlength` validation error key if the value is longer than
 *    maxlength.
 * @param {string=} ngPattern Sets `pattern` validation error key if the value does not match the
 *    RegExp pattern expression. Expected value is `/regexp/` for inline patterns or `regexp` for
 *    patterns defined as scope expressions.
 * @param {string=} ngChange Angular expression to be executed when input changes due to user
 *    interaction with the input element.
 *
 * @example
    <doc:example>
      <doc:source>
       <script>
         function Ctrl($scope) {
           $scope.user = {name: 'guest', last: 'visitor'};
         }
       </script>
       <div ng-controller="Ctrl">
         <form name="myForm">
           User name: <input type="text" name="userName" ng-model="user.name" required>
           <span class="error" ng-show="myForm.userName.$error.required">
             Required!</span><br>
           Last name: <input type="text" name="lastName" ng-model="user.last"
             ng-minlength="3" ng-maxlength="10">
           <span class="error" ng-show="myForm.lastName.$error.minlength">
             Too short!</span>
           <span class="error" ng-show="myForm.lastName.$error.maxlength">
             Too long!</span><br>
         </form>
         <hr>
         <tt>user = {{user}}</tt><br/>
         <tt>myForm.userName.$valid = {{myForm.userName.$valid}}</tt><br>
         <tt>myForm.userName.$error = {{myForm.userName.$error}}</tt><br>
         <tt>myForm.lastName.$valid = {{myForm.lastName.$valid}}</tt><br>
         <tt>myForm.lastName.$error = {{myForm.lastName.$error}}</tt><br>
         <tt>myForm.$valid = {{myForm.$valid}}</tt><br>
         <tt>myForm.$error.required = {{!!myForm.$error.required}}</tt><br>
         <tt>myForm.$error.minlength = {{!!myForm.$error.minlength}}</tt><br>
         <tt>myForm.$error.maxlength = {{!!myForm.$error.maxlength}}</tt><br>
       </div>
      </doc:source>
      <doc:scenario>
        it('should initialize to model', function() {
          expect(binding('user')).toEqual('{"name":"guest","last":"visitor"}');
          expect(binding('myForm.userName.$valid')).toEqual('true');
          expect(binding('myForm.$valid')).toEqual('true');
        });

        it('should be invalid if empty when required', function() {
          input('user.name').enter('');
          expect(binding('user')).toEqual('{"last":"visitor"}');
          expect(binding('myForm.userName.$valid')).toEqual('false');
          expect(binding('myForm.$valid')).toEqual('false');
        });

        it('should be valid if empty when min length is set', function() {
          input('user.last').enter('');
          expect(binding('user')).toEqual('{"name":"guest","last":""}');
          expect(binding('myForm.lastName.$valid')).toEqual('true');
          expect(binding('myForm.$valid')).toEqual('true');
        });

        it('should be invalid if less than required min length', function() {
          input('user.last').enter('xx');
          expect(binding('user')).toEqual('{"name":"guest"}');
          expect(binding('myForm.lastName.$valid')).toEqual('false');
          expect(binding('myForm.lastName.$error')).toMatch(/minlength/);
          expect(binding('myForm.$valid')).toEqual('false');
        });

        it('should be invalid if longer than max length', function() {
          input('user.last').enter('some ridiculously long name');
          expect(binding('user'))
            .toEqual('{"name":"guest"}');
          expect(binding('myForm.lastName.$valid')).toEqual('false');
          expect(binding('myForm.lastName.$error')).toMatch(/maxlength/);
          expect(binding('myForm.$valid')).toEqual('false');
        });
      </doc:scenario>
    </doc:example>
 */
var inputDirective = ['$browser', '$sniffer', function($browser, $sniffer) {
  return {
    restrict: 'E',
    require: '?ngModel',
    link: function(scope, element, attr, ctrl) {
      if (ctrl) {
        (inputType[lowercase(attr.type)] || inputType.text)(scope, element, attr, ctrl, $sniffer,
                                                            $browser);
      }
    }
  };
}];

var VALID_CLASS = 'ng-valid',
    INVALID_CLASS = 'ng-invalid',
    PRISTINE_CLASS = 'ng-pristine',
    DIRTY_CLASS = 'ng-dirty';

/**
 * @ngdoc object
 * @name ng.directive:ngModel.NgModelController
 *
 * @property {string} $viewValue Actual string value in the view.
 * @property {*} $modelValue The value in the model, that the control is bound to.
 * @property {Array.<Function>} $parsers Whenever the control reads value from the DOM, it executes
 *     all of these functions to sanitize / convert the value as well as validate.
 *
 * @property {Array.<Function>} $formatters Whenever the model value changes, it executes all of
 *     these functions to convert the value as well as validate.
 *
 * @property {Object} $error An bject hash with all errors as keys.
 *
 * @property {boolean} $pristine True if user has not interacted with the control yet.
 * @property {boolean} $dirty True if user has already interacted with the control.
 * @property {boolean} $valid True if there is no error.
 * @property {boolean} $invalid True if at least one error on the control.
 *
 * @description
 *
 * `NgModelController` provides API for the `ng-model` directive. The controller contains
 * services for data-binding, validation, CSS update, value formatting and parsing. It
 * specifically does not contain any logic which deals with DOM rendering or listening to
 * DOM events. The `NgModelController` is meant to be extended by other directives where, the
 * directive provides DOM manipulation and the `NgModelController` provides the data-binding.
 *
 * This example shows how to use `NgModelController` with a custom control to achieve
 * data-binding. Notice how different directives (`contenteditable`, `ng-model`, and `required`)
 * collaborate together to achieve the desired result.
 *
 * <example module="customControl">
    <file name="style.css">
      [contenteditable] {
        border: 1px solid black;
        background-color: white;
        min-height: 20px;
      }

      .ng-invalid {
        border: 1px solid red;
      }

    </file>
    <file name="script.js">
      angular.module('customControl', []).
        directive('contenteditable', function() {
          return {
            restrict: 'A', // only activate on element attribute
            require: '?ngModel', // get a hold of NgModelController
            link: function(scope, element, attrs, ngModel) {
              if(!ngModel) return; // do nothing if no ng-model

              // Specify how UI should be updated
              ngModel.$render = function() {
                element.html(ngModel.$viewValue || '');
              };

              // Listen for change events to enable binding
              element.bind('blur keyup change', function() {
                scope.$apply(read);
              });
              read(); // initialize

              // Write data to the model
              function read() {
                ngModel.$setViewValue(element.html());
              }
            }
          };
        });
    </file>
    <file name="index.html">
      <form name="myForm">
       <div contenteditable
            name="myWidget" ng-model="userContent"
            required>Change me!</div>
        <span ng-show="myForm.myWidget.$error.required">Required!</span>
       <hr>
       <textarea ng-model="userContent"></textarea>
      </form>
    </file>
    <file name="scenario.js">
      it('should data-bind and become invalid', function() {
        var contentEditable = element('[contenteditable]');

        expect(contentEditable.text()).toEqual('Change me!');
        input('userContent').enter('');
        expect(contentEditable.text()).toEqual('');
        expect(contentEditable.prop('className')).toMatch(/ng-invalid-required/);
      });
    </file>
 * </example>
 *
 */
var NgModelController = ['$scope', '$exceptionHandler', '$attrs', '$element', '$parse',
    function($scope, $exceptionHandler, $attr, $element, $parse) {
  this.$viewValue = Number.NaN;
  this.$modelValue = Number.NaN;
  this.$parsers = [];
  this.$formatters = [];
  this.$viewChangeListeners = [];
  this.$pristine = true;
  this.$dirty = false;
  this.$valid = true;
  this.$invalid = false;
  this.$name = $attr.name;

  var ngModelGet = $parse($attr.ngModel),
      ngModelSet = ngModelGet.assign;

  if (!ngModelSet) {
    throw Error(NON_ASSIGNABLE_MODEL_EXPRESSION + $attr.ngModel +
        ' (' + startingTag($element) + ')');
  }

  /**
   * @ngdoc function
   * @name ng.directive:ngModel.NgModelController#$render
   * @methodOf ng.directive:ngModel.NgModelController
   *
   * @description
   * Called when the view needs to be updated. It is expected that the user of the ng-model
   * directive will implement this method.
   */
  this.$render = noop;

  var parentForm = $element.inheritedData('$formController') || nullFormCtrl,
      invalidCount = 0, // used to easily determine if we are valid
      $error = this.$error = {}; // keep invalid keys here


  // Setup initial state of the control
  $element.addClass(PRISTINE_CLASS);
  toggleValidCss(true);

  // convenience method for easy toggling of classes
  function toggleValidCss(isValid, validationErrorKey) {
    validationErrorKey = validationErrorKey ? '-' + snake_case(validationErrorKey, '-') : '';
    $element.
      removeClass((isValid ? INVALID_CLASS : VALID_CLASS) + validationErrorKey).
      addClass((isValid ? VALID_CLASS : INVALID_CLASS) + validationErrorKey);
  }

  /**
   * @ngdoc function
   * @name ng.directive:ngModel.NgModelController#$setValidity
   * @methodOf ng.directive:ngModel.NgModelController
   *
   * @description
   * Change the validity state, and notifies the form when the control changes validity. (i.e. it
   * does not notify form if given validator is already marked as invalid).
   *
   * This method should be called by validators - i.e. the parser or formatter functions.
   *
   * @param {string} validationErrorKey Name of the validator. the `validationErrorKey` will assign
   *        to `$error[validationErrorKey]=isValid` so that it is available for data-binding.
   *        The `validationErrorKey` should be in camelCase and will get converted into dash-case
   *        for class name. Example: `myError` will result in `ng-valid-my-error` and `ng-invalid-my-error`
   *        class and can be bound to as  `{{someForm.someControl.$error.myError}}` .
   * @param {boolean} isValid Whether the current state is valid (true) or invalid (false).
   */
  this.$setValidity = function(validationErrorKey, isValid) {
    if ($error[validationErrorKey] === !isValid) return;

    if (isValid) {
      if ($error[validationErrorKey]) invalidCount--;
      if (!invalidCount) {
        toggleValidCss(true);
        this.$valid = true;
        this.$invalid = false;
      }
    } else {
      toggleValidCss(false);
      this.$invalid = true;
      this.$valid = false;
      invalidCount++;
    }

    $error[validationErrorKey] = !isValid;
    toggleValidCss(isValid, validationErrorKey);

    parentForm.$setValidity(validationErrorKey, isValid, this);
  };


  /**
   * @ngdoc function
   * @name ng.directive:ngModel.NgModelController#$setViewValue
   * @methodOf ng.directive:ngModel.NgModelController
   *
   * @description
   * Read a value from view.
   *
   * This method should be called from within a DOM event handler.
   * For example {@link ng.directive:input input} or
   * {@link ng.directive:select select} directives call it.
   *
   * It internally calls all `parsers` and if resulted value is valid, updates the model and
   * calls all registered change listeners.
   *
   * @param {string} value Value from the view.
   */
  this.$setViewValue = function(value) {
    this.$viewValue = value;

    // change to dirty
    if (this.$pristine) {
      this.$dirty = true;
      this.$pristine = false;
      $element.removeClass(PRISTINE_CLASS).addClass(DIRTY_CLASS);
      parentForm.$setDirty();
    }

    forEach(this.$parsers, function(fn) {
      value = fn(value);
    });

    if (this.$modelValue !== value) {
      this.$modelValue = value;
      ngModelSet($scope, value);
      forEach(this.$viewChangeListeners, function(listener) {
        try {
          listener();
        } catch(e) {
          $exceptionHandler(e);
        }
      })
    }
  };

  // model -> value
  var ctrl = this;

  $scope.$watch(function ngModelWatch() {
    var value = ngModelGet($scope);

    // if scope model value and ngModel value are out of sync
    if (ctrl.$modelValue !== value) {

      var formatters = ctrl.$formatters,
          idx = formatters.length;

      ctrl.$modelValue = value;
      while(idx--) {
        value = formatters[idx](value);
      }

      if (ctrl.$viewValue !== value) {
        ctrl.$viewValue = value;
        ctrl.$render();
      }
    }
  });
}];


/**
 * @ngdoc directive
 * @name ng.directive:ngModel
 *
 * @element input
 *
 * @description
 * Is directive that tells Angular to do two-way data binding. It works together with `input`,
 * `select`, `textarea`. You can easily write your own directives to use `ngModel` as well.
 *
 * `ngModel` is responsible for:
 *
 * - binding the view into the model, which other directives such as `input`, `textarea` or `select`
 *   require,
 * - providing validation behavior (i.e. required, number, email, url),
 * - keeping state of the control (valid/invalid, dirty/pristine, validation errors),
 * - setting related css class onto the element (`ng-valid`, `ng-invalid`, `ng-dirty`, `ng-pristine`),
 * - register the control with parent {@link ng.directive:form form}.
 *
 * For basic examples, how to use `ngModel`, see:
 *
 *  - {@link ng.directive:input input}
 *    - {@link ng.directive:input.text text}
 *    - {@link ng.directive:input.checkbox checkbox}
 *    - {@link ng.directive:input.radio radio}
 *    - {@link ng.directive:input.number number}
 *    - {@link ng.directive:input.email email}
 *    - {@link ng.directive:input.url url}
 *  - {@link ng.directive:select select}
 *  - {@link ng.directive:textarea textarea}
 *
 */
var ngModelDirective = function() {
  return {
    require: ['ngModel', '^?form'],
    controller: NgModelController,
    link: function(scope, element, attr, ctrls) {
      // notify others, especially parent forms

      var modelCtrl = ctrls[0],
          formCtrl = ctrls[1] || nullFormCtrl;

      formCtrl.$addControl(modelCtrl);

      element.bind('$destroy', function() {
        formCtrl.$removeControl(modelCtrl);
      });
    }
  };
};


/**
 * @ngdoc directive
 * @name ng.directive:ngChange
 * @restrict E
 *
 * @description
 * Evaluate given expression when user changes the input.
 * The expression is not evaluated when the value change is coming from the model.
 *
 * Note, this directive requires `ngModel` to be present.
 *
 * @element input
 *
 * @example
 * <doc:example>
 *   <doc:source>
 *     <script>
 *       function Controller($scope) {
 *         $scope.counter = 0;
 *         $scope.change = function() {
 *           $scope.counter++;
 *         };
 *       }
 *     </script>
 *     <div ng-controller="Controller">
 *       <input type="checkbox" ng-model="confirmed" ng-change="change()" id="ng-change-example1" />
 *       <input type="checkbox" ng-model="confirmed" id="ng-change-example2" />
 *       <label for="ng-change-example2">Confirmed</label><br />
 *       debug = {{confirmed}}<br />
 *       counter = {{counter}}
 *     </div>
 *   </doc:source>
 *   <doc:scenario>
 *     it('should evaluate the expression if changing from view', function() {
 *       expect(binding('counter')).toEqual('0');
 *       element('#ng-change-example1').click();
 *       expect(binding('counter')).toEqual('1');
 *       expect(binding('confirmed')).toEqual('true');
 *     });
 *
 *     it('should not evaluate the expression if changing from model', function() {
 *       element('#ng-change-example2').click();
 *       expect(binding('counter')).toEqual('0');
 *       expect(binding('confirmed')).toEqual('true');
 *     });
 *   </doc:scenario>
 * </doc:example>
 */
var ngChangeDirective = valueFn({
  require: 'ngModel',
  link: function(scope, element, attr, ctrl) {
    ctrl.$viewChangeListeners.push(function() {
      scope.$eval(attr.ngChange);
    });
  }
});


var requiredDirective = function() {
  return {
    require: '?ngModel',
    link: function(scope, elm, attr, ctrl) {
      if (!ctrl) return;
      attr.required = true; // force truthy in case we are on non input element

      var validator = function(value) {
        if (attr.required && (isEmpty(value) || value === false)) {
          ctrl.$setValidity('required', false);
          return;
        } else {
          ctrl.$setValidity('required', true);
          return value;
        }
      };

      ctrl.$formatters.push(validator);
      ctrl.$parsers.unshift(validator);

      attr.$observe('required', function() {
        validator(ctrl.$viewValue);
      });
    }
  };
};


/**
 * @ngdoc directive
 * @name ng.directive:ngList
 *
 * @description
 * Text input that converts between comma-separated string into an array of strings.
 *
 * @element input
 * @param {string=} ngList optional delimiter that should be used to split the value. If
 *   specified in form `/something/` then the value will be converted into a regular expression.
 *
 * @example
    <doc:example>
      <doc:source>
       <script>
         function Ctrl($scope) {
           $scope.names = ['igor', 'misko', 'vojta'];
         }
       </script>
       <form name="myForm" ng-controller="Ctrl">
         List: <input name="namesInput" ng-model="names" ng-list required>
         <span class="error" ng-show="myForm.list.$error.required">
           Required!</span>
         <tt>names = {{names}}</tt><br/>
         <tt>myForm.namesInput.$valid = {{myForm.namesInput.$valid}}</tt><br/>
         <tt>myForm.namesInput.$error = {{myForm.namesInput.$error}}</tt><br/>
         <tt>myForm.$valid = {{myForm.$valid}}</tt><br/>
         <tt>myForm.$error.required = {{!!myForm.$error.required}}</tt><br/>
        </form>
      </doc:source>
      <doc:scenario>
        it('should initialize to model', function() {
          expect(binding('names')).toEqual('["igor","misko","vojta"]');
          expect(binding('myForm.namesInput.$valid')).toEqual('true');
        });

        it('should be invalid if empty', function() {
          input('names').enter('');
          expect(binding('names')).toEqual('[]');
          expect(binding('myForm.namesInput.$valid')).toEqual('false');
        });
      </doc:scenario>
    </doc:example>
 */
var ngListDirective = function() {
  return {
    require: 'ngModel',
    link: function(scope, element, attr, ctrl) {
      var match = /\/(.*)\//.exec(attr.ngList),
          separator = match && new RegExp(match[1]) || attr.ngList || ',';

      var parse = function(viewValue) {
        var list = [];

        if (viewValue) {
          forEach(viewValue.split(separator), function(value) {
            if (value) list.push(trim(value));
          });
        }

        return list;
      };

      ctrl.$parsers.push(parse);
      ctrl.$formatters.push(function(value) {
        if (isArray(value)) {
          return value.join(', ');
        }

        return undefined;
      });
    }
  };
};


var CONSTANT_VALUE_REGEXP = /^(true|false|\d+)$/;

var ngValueDirective = function() {
  return {
    priority: 100,
    compile: function(tpl, tplAttr) {
      if (CONSTANT_VALUE_REGEXP.test(tplAttr.ngValue)) {
        return function(scope, elm, attr) {
          attr.$set('value', scope.$eval(attr.ngValue));
        };
      } else {
        return function(scope, elm, attr) {
          scope.$watch(attr.ngValue, function valueWatchAction(value) {
            attr.$set('value', value, false);
          });
        };
      }
    }
  };
};

/**
 * @ngdoc directive
 * @name ng.directive:ngBind
 *
 * @description
 * The `ngBind` attribute tells Angular to replace the text content of the specified HTML element
 * with the value of a given expression, and to update the text content when the value of that
 * expression changes.
 *
 * Typically, you don't use `ngBind` directly, but instead you use the double curly markup like
 * `{{ expression }}` which is similar but less verbose.
 *
 * One scenario in which the use of `ngBind` is preferred over `{{ expression }}` binding is when
 * it's desirable to put bindings into template that is momentarily displayed by the browser in its
 * raw state before Angular compiles it. Since `ngBind` is an element attribute, it makes the
 * bindings invisible to the user while the page is loading.
 *
 * An alternative solution to this problem would be using the
 * {@link ng.directive:ngCloak ngCloak} directive.
 *
 *
 * @element ANY
 * @param {expression} ngBind {@link guide/expression Expression} to evaluate.
 *
 * @example
 * Enter a name in the Live Preview text box; the greeting below the text box changes instantly.
   <doc:example>
     <doc:source>
       <script>
         function Ctrl($scope) {
           $scope.name = 'Whirled';
         }
       </script>
       <div ng-controller="Ctrl">
         Enter name: <input type="text" ng-model="name"><br>
         Hello <span ng-bind="name"></span>!
       </div>
     </doc:source>
     <doc:scenario>
       it('should check ng-bind', function() {
         expect(using('.doc-example-live').binding('name')).toBe('Whirled');
         using('.doc-example-live').input('name').enter('world');
         expect(using('.doc-example-live').binding('name')).toBe('world');
       });
     </doc:scenario>
   </doc:example>
 */
var ngBindDirective = ngDirective(function(scope, element, attr) {
  element.addClass('ng-binding').data('$binding', attr.ngBind);
  scope.$watch(attr.ngBind, function ngBindWatchAction(value) {
    element.text(value == undefined ? '' : value);
  });
});


/**
 * @ngdoc directive
 * @name ng.directive:ngBindTemplate
 *
 * @description
 * The `ngBindTemplate` directive specifies that the element
 * text should be replaced with the template in ngBindTemplate.
 * Unlike ngBind the ngBindTemplate can contain multiple `{{` `}}`
 * expressions. (This is required since some HTML elements
 * can not have SPAN elements such as TITLE, or OPTION to name a few.)
 *
 * @element ANY
 * @param {string} ngBindTemplate template of form
 *   <tt>{{</tt> <tt>expression</tt> <tt>}}</tt> to eval.
 *
 * @example
 * Try it here: enter text in text box and watch the greeting change.
   <doc:example>
     <doc:source>
       <script>
         function Ctrl($scope) {
           $scope.salutation = 'Hello';
           $scope.name = 'World';
         }
       </script>
       <div ng-controller="Ctrl">
        Salutation: <input type="text" ng-model="salutation"><br>
        Name: <input type="text" ng-model="name"><br>
        <pre ng-bind-template="{{salutation}} {{name}}!"></pre>
       </div>
     </doc:source>
     <doc:scenario>
       it('should check ng-bind', function() {
         expect(using('.doc-example-live').binding('salutation')).
           toBe('Hello');
         expect(using('.doc-example-live').binding('name')).
           toBe('World');
         using('.doc-example-live').input('salutation').enter('Greetings');
         using('.doc-example-live').input('name').enter('user');
         expect(using('.doc-example-live').binding('salutation')).
           toBe('Greetings');
         expect(using('.doc-example-live').binding('name')).
           toBe('user');
       });
     </doc:scenario>
   </doc:example>
 */
var ngBindTemplateDirective = ['$interpolate', function($interpolate) {
  return function(scope, element, attr) {
    // TODO: move this to scenario runner
    var interpolateFn = $interpolate(element.attr(attr.$attr.ngBindTemplate));
    element.addClass('ng-binding').data('$binding', interpolateFn);
    attr.$observe('ngBindTemplate', function(value) {
      element.text(value);
    });
  }
}];


/**
 * @ngdoc directive
 * @name ng.directive:ngBindHtmlUnsafe
 *
 * @description
 * Creates a binding that will innerHTML the result of evaluating the `expression` into the current
 * element. *The innerHTML-ed content will not be sanitized!* You should use this directive only if
 * {@link ngSanitize.directive:ngBindHtml ngBindHtml} directive is too
 * restrictive and when you absolutely trust the source of the content you are binding to.
 *
 * See {@link ngSanitize.$sanitize $sanitize} docs for examples.
 *
 * @element ANY
 * @param {expression} ngBindHtmlUnsafe {@link guide/expression Expression} to evaluate.
 */
var ngBindHtmlUnsafeDirective = [function() {
  return function(scope, element, attr) {
    element.addClass('ng-binding').data('$binding', attr.ngBindHtmlUnsafe);
    scope.$watch(attr.ngBindHtmlUnsafe, function ngBindHtmlUnsafeWatchAction(value) {
      element.html(value || '');
    });
  };
}];

function classDirective(name, selector) {
  name = 'ngClass' + name;
  return ngDirective(function(scope, element, attr) {
    var oldVal = undefined;

    scope.$watch(attr[name], ngClassWatchAction, true);

    attr.$observe('class', function(value) {
      var ngClass = scope.$eval(attr[name]);
      ngClassWatchAction(ngClass, ngClass);
    });


    if (name !== 'ngClass') {
      scope.$watch('$index', function($index, old$index) {
        var mod = $index & 1;
        if (mod !== old$index & 1) {
          if (mod === selector) {
            addClass(scope.$eval(attr[name]));
          } else {
            removeClass(scope.$eval(attr[name]));
          }
        }
      });
    }


    function ngClassWatchAction(newVal) {
      if (selector === true || scope.$index % 2 === selector) {
        if (oldVal && !equals(newVal,oldVal)) {
          removeClass(oldVal);
        }
        addClass(newVal);
      }
      oldVal = copy(newVal);
    }


    function removeClass(classVal) {
      if (isObject(classVal) && !isArray(classVal)) {
        classVal = map(classVal, function(v, k) { if (v) return k });
      }
      element.removeClass(isArray(classVal) ? classVal.join(' ') : classVal);
    }


    function addClass(classVal) {
      if (isObject(classVal) && !isArray(classVal)) {
        classVal = map(classVal, function(v, k) { if (v) return k });
      }
      if (classVal) {
        element.addClass(isArray(classVal) ? classVal.join(' ') : classVal);
      }
    }
  });
}

/**
 * @ngdoc directive
 * @name ng.directive:ngClass
 *
 * @description
 * The `ngClass` allows you to set CSS class on HTML element dynamically by databinding an
 * expression that represents all classes to be added.
 *
 * The directive won't add duplicate classes if a particular class was already set.
 *
 * When the expression changes, the previously added classes are removed and only then the
 * new classes are added.
 *
 * @element ANY
 * @param {expression} ngClass {@link guide/expression Expression} to eval. The result
 *   of the evaluation can be a string representing space delimited class
 *   names, an array, or a map of class names to boolean values.
 *
 * @example
   <example>
     <file name="index.html">
      <input type="button" value="set" ng-click="myVar='my-class'">
      <input type="button" value="clear" ng-click="myVar=''">
      <br>
      <span ng-class="myVar">Sample Text</span>
     </file>
     <file name="style.css">
       .my-class {
         color: red;
       }
     </file>
     <file name="scenario.js">
       it('should check ng-class', function() {
         expect(element('.doc-example-live span').prop('className')).not().
           toMatch(/my-class/);

         using('.doc-example-live').element(':button:first').click();

         expect(element('.doc-example-live span').prop('className')).
           toMatch(/my-class/);

         using('.doc-example-live').element(':button:last').click();

         expect(element('.doc-example-live span').prop('className')).not().
           toMatch(/my-class/);
       });
     </file>
   </example>
 */
var ngClassDirective = classDirective('', true);

/**
 * @ngdoc directive
 * @name ng.directive:ngClassOdd
 *
 * @description
 * The `ngClassOdd` and `ngClassEven` directives work exactly as
 * {@link ng.directive:ngClass ngClass}, except it works in
 * conjunction with `ngRepeat` and takes affect only on odd (even) rows.
 *
 * This directive can be applied only within a scope of an
 * {@link ng.directive:ngRepeat ngRepeat}.
 *
 * @element ANY
 * @param {expression} ngClassOdd {@link guide/expression Expression} to eval. The result
 *   of the evaluation can be a string representing space delimited class names or an array.
 *
 * @example
   <example>
     <file name="index.html">
        <ol ng-init="names=['John', 'Mary', 'Cate', 'Suz']">
          <li ng-repeat="name in names">
           <span ng-class-odd="'odd'" ng-class-even="'even'">
             {{name}}
           </span>
          </li>
        </ol>
     </file>
     <file name="style.css">
       .odd {
         color: red;
       }
       .even {
         color: blue;
       }
     </file>
     <file name="scenario.js">
       it('should check ng-class-odd and ng-class-even', function() {
         expect(element('.doc-example-live li:first span').prop('className')).
           toMatch(/odd/);
         expect(element('.doc-example-live li:last span').prop('className')).
           toMatch(/even/);
       });
     </file>
   </example>
 */
var ngClassOddDirective = classDirective('Odd', 0);

/**
 * @ngdoc directive
 * @name ng.directive:ngClassEven
 *
 * @description
 * The `ngClassOdd` and `ngClassEven` directives work exactly as
 * {@link ng.directive:ngClass ngClass}, except it works in
 * conjunction with `ngRepeat` and takes affect only on odd (even) rows.
 *
 * This directive can be applied only within a scope of an
 * {@link ng.directive:ngRepeat ngRepeat}.
 *
 * @element ANY
 * @param {expression} ngClassEven {@link guide/expression Expression} to eval. The
 *   result of the evaluation can be a string representing space delimited class names or an array.
 *
 * @example
   <example>
     <file name="index.html">
        <ol ng-init="names=['John', 'Mary', 'Cate', 'Suz']">
          <li ng-repeat="name in names">
           <span ng-class-odd="'odd'" ng-class-even="'even'">
             {{name}} &nbsp; &nbsp; &nbsp;
           </span>
          </li>
        </ol>
     </file>
     <file name="style.css">
       .odd {
         color: red;
       }
       .even {
         color: blue;
       }
     </file>
     <file name="scenario.js">
       it('should check ng-class-odd and ng-class-even', function() {
         expect(element('.doc-example-live li:first span').prop('className')).
           toMatch(/odd/);
         expect(element('.doc-example-live li:last span').prop('className')).
           toMatch(/even/);
       });
     </file>
   </example>
 */
var ngClassEvenDirective = classDirective('Even', 1);

/**
 * @ngdoc directive
 * @name ng.directive:ngCloak
 *
 * @description
 * The `ngCloak` directive is used to prevent the Angular html template from being briefly
 * displayed by the browser in its raw (uncompiled) form while your application is loading. Use this
 * directive to avoid the undesirable flicker effect caused by the html template display.
 *
 * The directive can be applied to the `<body>` element, but typically a fine-grained application is
 * prefered in order to benefit from progressive rendering of the browser view.
 *
 * `ngCloak` works in cooperation with a css rule that is embedded within `angular.js` and
 *  `angular.min.js` files. Following is the css rule:
 *
 * <pre>
 * [ng\:cloak], [ng-cloak], [data-ng-cloak], [x-ng-cloak], .ng-cloak, .x-ng-cloak {
 *   display: none;
 * }
 * </pre>
 *
 * When this css rule is loaded by the browser, all html elements (including their children) that
 * are tagged with the `ng-cloak` directive are hidden. When Angular comes across this directive
 * during the compilation of the template it deletes the `ngCloak` element attribute, which
 * makes the compiled element visible.
 *
 * For the best result, `angular.js` script must be loaded in the head section of the html file;
 * alternatively, the css rule (above) must be included in the external stylesheet of the
 * application.
 *
 * Legacy browsers, like IE7, do not provide attribute selector support (added in CSS 2.1) so they
 * cannot match the `[ng\:cloak]` selector. To work around this limitation, you must add the css
 * class `ngCloak` in addition to `ngCloak` directive as shown in the example below.
 *
 * @element ANY
 *
 * @example
   <doc:example>
     <doc:source>
        <div id="template1" ng-cloak>{{ 'hello' }}</div>
        <div id="template2" ng-cloak class="ng-cloak">{{ 'hello IE7' }}</div>
     </doc:source>
     <doc:scenario>
       it('should remove the template directive and css class', function() {
         expect(element('.doc-example-live #template1').attr('ng-cloak')).
           not().toBeDefined();
         expect(element('.doc-example-live #template2').attr('ng-cloak')).
           not().toBeDefined();
       });
     </doc:scenario>
   </doc:example>
 *
 */
var ngCloakDirective = ngDirective({
  compile: function(element, attr) {
    attr.$set('ngCloak', undefined);
    element.removeClass('ng-cloak');
  }
});

/**
 * @ngdoc directive
 * @name ng.directive:ngController
 *
 * @description
 * The `ngController` directive assigns behavior to a scope. This is a key aspect of how angular
 * supports the principles behind the Model-View-Controller design pattern.
 *
 * MVC components in angular:
 *
 * * Model — The Model is data in scope properties; scopes are attached to the DOM.
 * * View — The template (HTML with data bindings) is rendered into the View.
 * * Controller — The `ngController` directive specifies a Controller class; the class has
 *   methods that typically express the business logic behind the application.
 *
 * Note that an alternative way to define controllers is via the {@link ng.$route $route} service.
 *
 * @element ANY
 * @scope
 * @param {expression} ngController Name of a globally accessible constructor function or an
 *     {@link guide/expression expression} that on the current scope evaluates to a
 *     constructor function.
 *
 * @example
 * Here is a simple form for editing user contact information. Adding, removing, clearing, and
 * greeting are methods declared on the controller (see source tab). These methods can
 * easily be called from the angular markup. Notice that the scope becomes the `this` for the
 * controller's instance. This allows for easy access to the view data from the controller. Also
 * notice that any changes to the data are automatically reflected in the View without the need
 * for a manual update.
   <doc:example>
     <doc:source>
      <script>
        function SettingsController($scope) {
          $scope.name = "John Smith";
          $scope.contacts = [
            {type:'phone', value:'408 555 1212'},
            {type:'email', value:'john.smith@example.org'} ];

          $scope.greet = function() {
           alert(this.name);
          };

          $scope.addContact = function() {
           this.contacts.push({type:'email', value:'yourname@example.org'});
          };

          $scope.removeContact = function(contactToRemove) {
           var index = this.contacts.indexOf(contactToRemove);
           this.contacts.splice(index, 1);
          };

          $scope.clearContact = function(contact) {
           contact.type = 'phone';
           contact.value = '';
          };
        }
      </script>
      <div ng-controller="SettingsController">
        Name: <input type="text" ng-model="name"/>
        [ <a href="" ng-click="greet()">greet</a> ]<br/>
        Contact:
        <ul>
          <li ng-repeat="contact in contacts">
            <select ng-model="contact.type">
               <option>phone</option>
               <option>email</option>
            </select>
            <input type="text" ng-model="contact.value"/>
            [ <a href="" ng-click="clearContact(contact)">clear</a>
            | <a href="" ng-click="removeContact(contact)">X</a> ]
          </li>
          <li>[ <a href="" ng-click="addContact()">add</a> ]</li>
       </ul>
      </div>
     </doc:source>
     <doc:scenario>
       it('should check controller', function() {
         expect(element('.doc-example-live div>:input').val()).toBe('John Smith');
         expect(element('.doc-example-live li:nth-child(1) input').val())
           .toBe('408 555 1212');
         expect(element('.doc-example-live li:nth-child(2) input').val())
           .toBe('john.smith@example.org');

         element('.doc-example-live li:first a:contains("clear")').click();
         expect(element('.doc-example-live li:first input').val()).toBe('');

         element('.doc-example-live li:last a:contains("add")').click();
         expect(element('.doc-example-live li:nth-child(3) input').val())
           .toBe('yourname@example.org');
       });
     </doc:scenario>
   </doc:example>
 */
var ngControllerDirective = [function() {
  return {
    scope: true,
    controller: '@'
  };
}];

/**
 * @ngdoc directive
 * @name ng.directive:ngCsp
 * @priority 1000
 *
 * @element html
 * @description
 * Enables [CSP (Content Security Policy)](https://developer.mozilla.org/en/Security/CSP) support.
 * 
 * This is necessary when developing things like Google Chrome Extensions.
 * 
 * CSP forbids apps to use `eval` or `Function(string)` generated functions (among other things).
 * For us to be compatible, we just need to implement the "getterFn" in $parse without violating
 * any of these restrictions.
 * 
 * AngularJS uses `Function(string)` generated functions as a speed optimization. By applying `ngCsp`
 * it is be possible to opt into the CSP compatible mode. When this mode is on AngularJS will
 * evaluate all expressions up to 30% slower than in non-CSP mode, but no security violations will
 * be raised.
 * 
 * In order to use this feature put `ngCsp` directive on the root element of the application.
 * 
 * @example
 * This example shows how to apply the `ngCsp` directive to the `html` tag.
   <pre>
     <!doctype html>
     <html ng-app ng-csp>
     ...
     ...
     </html>
   </pre>
 */

var ngCspDirective = ['$sniffer', function($sniffer) {
  return {
    priority: 1000,
    compile: function() {
      $sniffer.csp = true;
    }
  };
}];

/**
 * @ngdoc directive
 * @name ng.directive:ngClick
 *
 * @description
 * The ngClick allows you to specify custom behavior when
 * element is clicked.
 *
 * @element ANY
 * @param {expression} ngClick {@link guide/expression Expression} to evaluate upon
 * click. (Event object is available as `$event`)
 *
 * @example
   <doc:example>
     <doc:source>
      <button ng-click="count = count + 1" ng-init="count=0">
        Increment
      </button>
      count: {{count}}
     </doc:source>
     <doc:scenario>
       it('should check ng-click', function() {
         expect(binding('count')).toBe('0');
         element('.doc-example-live :button').click();
         expect(binding('count')).toBe('1');
       });
     </doc:scenario>
   </doc:example>
 */
/*
 * A directive that allows creation of custom onclick handlers that are defined as angular
 * expressions and are compiled and executed within the current scope.
 *
 * Events that are handled via these handler are always configured not to propagate further.
 */
var ngEventDirectives = {};
forEach(
  'click dblclick mousedown mouseup mouseover mouseout mousemove mouseenter mouseleave'.split(' '),
  function(name) {
    var directiveName = directiveNormalize('ng-' + name);
    ngEventDirectives[directiveName] = ['$parse', function($parse) {
      return function(scope, element, attr) {
        var fn = $parse(attr[directiveName]);
        element.bind(lowercase(name), function(event) {
          scope.$apply(function() {
            fn(scope, {$event:event});
          });
        });
      };
    }];
  }
);

/**
 * @ngdoc directive
 * @name ng.directive:ngDblclick
 *
 * @description
 * The `ngDblclick` directive allows you to specify custom behavior on dblclick event.
 *
 * @element ANY
 * @param {expression} ngDblclick {@link guide/expression Expression} to evaluate upon
 * dblclick. (Event object is available as `$event`)
 *
 * @example
 * See {@link ng.directive:ngClick ngClick}
 */


/**
 * @ngdoc directive
 * @name ng.directive:ngMousedown
 *
 * @description
 * The ngMousedown directive allows you to specify custom behavior on mousedown event.
 *
 * @element ANY
 * @param {expression} ngMousedown {@link guide/expression Expression} to evaluate upon
 * mousedown. (Event object is available as `$event`)
 *
 * @example
 * See {@link ng.directive:ngClick ngClick}
 */


/**
 * @ngdoc directive
 * @name ng.directive:ngMouseup
 *
 * @description
 * Specify custom behavior on mouseup event.
 *
 * @element ANY
 * @param {expression} ngMouseup {@link guide/expression Expression} to evaluate upon
 * mouseup. (Event object is available as `$event`)
 *
 * @example
 * See {@link ng.directive:ngClick ngClick}
 */

/**
 * @ngdoc directive
 * @name ng.directive:ngMouseover
 *
 * @description
 * Specify custom behavior on mouseover event.
 *
 * @element ANY
 * @param {expression} ngMouseover {@link guide/expression Expression} to evaluate upon
 * mouseover. (Event object is available as `$event`)
 *
 * @example
 * See {@link ng.directive:ngClick ngClick}
 */


/**
 * @ngdoc directive
 * @name ng.directive:ngMouseenter
 *
 * @description
 * Specify custom behavior on mouseenter event.
 *
 * @element ANY
 * @param {expression} ngMouseenter {@link guide/expression Expression} to evaluate upon
 * mouseenter. (Event object is available as `$event`)
 *
 * @example
 * See {@link ng.directive:ngClick ngClick}
 */


/**
 * @ngdoc directive
 * @name ng.directive:ngMouseleave
 *
 * @description
 * Specify custom behavior on mouseleave event.
 *
 * @element ANY
 * @param {expression} ngMouseleave {@link guide/expression Expression} to evaluate upon
 * mouseleave. (Event object is available as `$event`)
 *
 * @example
 * See {@link ng.directive:ngClick ngClick}
 */


/**
 * @ngdoc directive
 * @name ng.directive:ngMousemove
 *
 * @description
 * Specify custom behavior on mousemove event.
 *
 * @element ANY
 * @param {expression} ngMousemove {@link guide/expression Expression} to evaluate upon
 * mousemove. (Event object is available as `$event`)
 *
 * @example
 * See {@link ng.directive:ngClick ngClick}
 */


/**
 * @ngdoc directive
 * @name ng.directive:ngSubmit
 *
 * @description
 * Enables binding angular expressions to onsubmit events.
 *
 * Additionally it prevents the default action (which for form means sending the request to the
 * server and reloading the current page).
 *
 * @element form
 * @param {expression} ngSubmit {@link guide/expression Expression} to eval.
 *
 * @example
   <doc:example>
     <doc:source>
      <script>
        function Ctrl($scope) {
          $scope.list = [];
          $scope.text = 'hello';
          $scope.submit = function() {
            if (this.text) {
              this.list.push(this.text);
              this.text = '';
            }
          };
        }
      </script>
      <form ng-submit="submit()" ng-controller="Ctrl">
        Enter text and hit enter:
        <input type="text" ng-model="text" name="text" />
        <input type="submit" id="submit" value="Submit" />
        <pre>list={{list}}</pre>
      </form>
     </doc:source>
     <doc:scenario>
       it('should check ng-submit', function() {
         expect(binding('list')).toBe('[]');
         element('.doc-example-live #submit').click();
         expect(binding('list')).toBe('["hello"]');
         expect(input('text').val()).toBe('');
       });
       it('should ignore empty strings', function() {
         expect(binding('list')).toBe('[]');
         element('.doc-example-live #submit').click();
         element('.doc-example-live #submit').click();
         expect(binding('list')).toBe('["hello"]');
       });
     </doc:scenario>
   </doc:example>
 */
var ngSubmitDirective = ngDirective(function(scope, element, attrs) {
  element.bind('submit', function() {
    scope.$apply(attrs.ngSubmit);
  });
});

/**
 * @ngdoc directive
 * @name ng.directive:ngInclude
 * @restrict ECA
 *
 * @description
 * Fetches, compiles and includes an external HTML fragment.
 *
 * Keep in mind that Same Origin Policy applies to included resources
 * (e.g. ngInclude won't work for cross-domain requests on all browsers and for
 *  file:// access on some browsers).
 *
 * @scope
 *
 * @param {string} ngInclude|src angular expression evaluating to URL. If the source is a string constant,
 *                 make sure you wrap it in quotes, e.g. `src="'myPartialTemplate.html'"`.
 * @param {string=} onload Expression to evaluate when a new partial is loaded.
 *
 * @param {string=} autoscroll Whether `ngInclude` should call {@link ng.$anchorScroll
 *                  $anchorScroll} to scroll the viewport after the content is loaded.
 *
 *                  - If the attribute is not set, disable scrolling.
 *                  - If the attribute is set without value, enable scrolling.
 *                  - Otherwise enable scrolling only if the expression evaluates to truthy value.
 *
 * @example
  <example>
    <file name="index.html">
     <div ng-controller="Ctrl">
       <select ng-model="template" ng-options="t.name for t in templates">
        <option value="">(blank)</option>
       </select>
       url of the template: <tt>{{template.url}}</tt>
       <hr/>
       <div ng-include src="template.url"></div>
     </div>
    </file>
    <file name="script.js">
      function Ctrl($scope) {
        $scope.templates =
          [ { name: 'template1.html', url: 'template1.html'}
          , { name: 'template2.html', url: 'template2.html'} ];
        $scope.template = $scope.templates[0];
      }
     </file>
    <file name="template1.html">
      Content of template1.html
    </file>
    <file name="template2.html">
      Content of template2.html
    </file>
    <file name="scenario.js">
      it('should load template1.html', function() {
       expect(element('.doc-example-live [ng-include]').text()).
         toMatch(/Content of template1.html/);
      });
      it('should load template2.html', function() {
       select('template').option('1');
       expect(element('.doc-example-live [ng-include]').text()).
         toMatch(/Content of template2.html/);
      });
      it('should change to blank', function() {
       select('template').option('');
       expect(element('.doc-example-live [ng-include]').text()).toEqual('');
      });
    </file>
  </example>
 */


/**
 * @ngdoc event
 * @name ng.directive:ngInclude#$includeContentLoaded
 * @eventOf ng.directive:ngInclude
 * @eventType emit on the current ngInclude scope
 * @description
 * Emitted every time the ngInclude content is reloaded.
 */
var ngIncludeDirective = ['$http', '$templateCache', '$anchorScroll', '$compile',
                  function($http,   $templateCache,   $anchorScroll,   $compile) {
  return {
    restrict: 'ECA',
    terminal: true,
    compile: function(element, attr) {
      var srcExp = attr.ngInclude || attr.src,
          onloadExp = attr.onload || '',
          autoScrollExp = attr.autoscroll;

      return function(scope, element) {
        var changeCounter = 0,
            childScope;

        var clearContent = function() {
          if (childScope) {
            childScope.$destroy();
            childScope = null;
          }

          element.html('');
        };

        scope.$watch(srcExp, function ngIncludeWatchAction(src) {
          var thisChangeId = ++changeCounter;

          if (src) {
            $http.get(src, {cache: $templateCache}).success(function(response) {
              if (thisChangeId !== changeCounter) return;

              if (childScope) childScope.$destroy();
              childScope = scope.$new();

              element.html(response);
              $compile(element.contents())(childScope);

              if (isDefined(autoScrollExp) && (!autoScrollExp || scope.$eval(autoScrollExp))) {
                $anchorScroll();
              }

              childScope.$emit('$includeContentLoaded');
              scope.$eval(onloadExp);
            }).error(function() {
              if (thisChangeId === changeCounter) clearContent();
            });
          } else clearContent();
        });
      };
    }
  };
}];

/**
 * @ngdoc directive
 * @name ng.directive:ngInit
 *
 * @description
 * The `ngInit` directive specifies initialization tasks to be executed
 *  before the template enters execution mode during bootstrap.
 *
 * @element ANY
 * @param {expression} ngInit {@link guide/expression Expression} to eval.
 *
 * @example
   <doc:example>
     <doc:source>
    <div ng-init="greeting='Hello'; person='World'">
      {{greeting}} {{person}}!
    </div>
     </doc:source>
     <doc:scenario>
       it('should check greeting', function() {
         expect(binding('greeting')).toBe('Hello');
         expect(binding('person')).toBe('World');
       });
     </doc:scenario>
   </doc:example>
 */
var ngInitDirective = ngDirective({
  compile: function() {
    return {
      pre: function(scope, element, attrs) {
        scope.$eval(attrs.ngInit);
      }
    }
  }
});

/**
 * @ngdoc directive
 * @name ng.directive:ngNonBindable
 * @priority 1000
 *
 * @description
 * Sometimes it is necessary to write code which looks like bindings but which should be left alone
 * by angular. Use `ngNonBindable` to make angular ignore a chunk of HTML.
 *
 * @element ANY
 *
 * @example
 * In this example there are two location where a simple binding (`{{}}`) is present, but the one
 * wrapped in `ngNonBindable` is left alone.
 *
 * @example
    <doc:example>
      <doc:source>
        <div>Normal: {{1 + 2}}</div>
        <div ng-non-bindable>Ignored: {{1 + 2}}</div>
      </doc:source>
      <doc:scenario>
       it('should check ng-non-bindable', function() {
         expect(using('.doc-example-live').binding('1 + 2')).toBe('3');
         expect(using('.doc-example-live').element('div:last').text()).
           toMatch(/1 \+ 2/);
       });
      </doc:scenario>
    </doc:example>
 */
var ngNonBindableDirective = ngDirective({ terminal: true, priority: 1000 });

/**
 * @ngdoc directive
 * @name ng.directive:ngPluralize
 * @restrict EA
 *
 * @description
 * # Overview
 * `ngPluralize` is a directive that displays messages according to en-US localization rules.
 * These rules are bundled with angular.js and the rules can be overridden
 * (see {@link guide/i18n Angular i18n} dev guide). You configure ngPluralize directive
 * by specifying the mappings between
 * {@link http://unicode.org/repos/cldr-tmp/trunk/diff/supplemental/language_plural_rules.html
 * plural categories} and the strings to be displayed.
 *
 * # Plural categories and explicit number rules
 * There are two
 * {@link http://unicode.org/repos/cldr-tmp/trunk/diff/supplemental/language_plural_rules.html
 * plural categories} in Angular's default en-US locale: "one" and "other".
 *
 * While a pural category may match many numbers (for example, in en-US locale, "other" can match
 * any number that is not 1), an explicit number rule can only match one number. For example, the
 * explicit number rule for "3" matches the number 3. You will see the use of plural categories
 * and explicit number rules throughout later parts of this documentation.
 *
 * # Configuring ngPluralize
 * You configure ngPluralize by providing 2 attributes: `count` and `when`.
 * You can also provide an optional attribute, `offset`.
 *
 * The value of the `count` attribute can be either a string or an {@link guide/expression
 * Angular expression}; these are evaluated on the current scope for its bound value.
 *
 * The `when` attribute specifies the mappings between plural categories and the actual
 * string to be displayed. The value of the attribute should be a JSON object so that Angular
 * can interpret it correctly.
 *
 * The following example shows how to configure ngPluralize:
 *
 * <pre>
 * <ng-pluralize count="personCount"
                 when="{'0': 'Nobody is viewing.',
 *                      'one': '1 person is viewing.',
 *                      'other': '{} people are viewing.'}">
 * </ng-pluralize>
 *</pre>
 *
 * In the example, `"0: Nobody is viewing."` is an explicit number rule. If you did not
 * specify this rule, 0 would be matched to the "other" category and "0 people are viewing"
 * would be shown instead of "Nobody is viewing". You can specify an explicit number rule for
 * other numbers, for example 12, so that instead of showing "12 people are viewing", you can
 * show "a dozen people are viewing".
 *
 * You can use a set of closed braces(`{}`) as a placeholder for the number that you want substituted
 * into pluralized strings. In the previous example, Angular will replace `{}` with
 * <span ng-non-bindable>`{{personCount}}`</span>. The closed braces `{}` is a placeholder
 * for <span ng-non-bindable>{{numberExpression}}</span>.
 *
 * # Configuring ngPluralize with offset
 * The `offset` attribute allows further customization of pluralized text, which can result in
 * a better user experience. For example, instead of the message "4 people are viewing this document",
 * you might display "John, Kate and 2 others are viewing this document".
 * The offset attribute allows you to offset a number by any desired value.
 * Let's take a look at an example:
 *
 * <pre>
 * <ng-pluralize count="personCount" offset=2
 *               when="{'0': 'Nobody is viewing.',
 *                      '1': '{{person1}} is viewing.',
 *                      '2': '{{person1}} and {{person2}} are viewing.',
 *                      'one': '{{person1}}, {{person2}} and one other person are viewing.',
 *                      'other': '{{person1}}, {{person2}} and {} other people are viewing.'}">
 * </ng-pluralize>
 * </pre>
 *
 * Notice that we are still using two plural categories(one, other), but we added
 * three explicit number rules 0, 1 and 2.
 * When one person, perhaps John, views the document, "John is viewing" will be shown.
 * When three people view the document, no explicit number rule is found, so
 * an offset of 2 is taken off 3, and Angular uses 1 to decide the plural category.
 * In this case, plural category 'one' is matched and "John, Marry and one other person are viewing"
 * is shown.
 *
 * Note that when you specify offsets, you must provide explicit number rules for
 * numbers from 0 up to and including the offset. If you use an offset of 3, for example,
 * you must provide explicit number rules for 0, 1, 2 and 3. You must also provide plural strings for
 * plural categories "one" and "other".
 *
 * @param {string|expression} count The variable to be bounded to.
 * @param {string} when The mapping between plural category to its correspoding strings.
 * @param {number=} offset Offset to deduct from the total number.
 *
 * @example
    <doc:example>
      <doc:source>
        <script>
          function Ctrl($scope) {
            $scope.person1 = 'Igor';
            $scope.person2 = 'Misko';
            $scope.personCount = 1;
          }
        </script>
        <div ng-controller="Ctrl">
          Person 1:<input type="text" ng-model="person1" value="Igor" /><br/>
          Person 2:<input type="text" ng-model="person2" value="Misko" /><br/>
          Number of People:<input type="text" ng-model="personCount" value="1" /><br/>

          <!--- Example with simple pluralization rules for en locale --->
          Without Offset:
          <ng-pluralize count="personCount"
                        when="{'0': 'Nobody is viewing.',
                               'one': '1 person is viewing.',
                               'other': '{} people are viewing.'}">
          </ng-pluralize><br>

          <!--- Example with offset --->
          With Offset(2):
          <ng-pluralize count="personCount" offset=2
                        when="{'0': 'Nobody is viewing.',
                               '1': '{{person1}} is viewing.',
                               '2': '{{person1}} and {{person2}} are viewing.',
                               'one': '{{person1}}, {{person2}} and one other person are viewing.',
                               'other': '{{person1}}, {{person2}} and {} other people are viewing.'}">
          </ng-pluralize>
        </div>
      </doc:source>
      <doc:scenario>
        it('should show correct pluralized string', function() {
          expect(element('.doc-example-live ng-pluralize:first').text()).
                                             toBe('1 person is viewing.');
          expect(element('.doc-example-live ng-pluralize:last').text()).
                                                toBe('Igor is viewing.');

          using('.doc-example-live').input('personCount').enter('0');
          expect(element('.doc-example-live ng-pluralize:first').text()).
                                               toBe('Nobody is viewing.');
          expect(element('.doc-example-live ng-pluralize:last').text()).
                                              toBe('Nobody is viewing.');

          using('.doc-example-live').input('personCount').enter('2');
          expect(element('.doc-example-live ng-pluralize:first').text()).
                                            toBe('2 people are viewing.');
          expect(element('.doc-example-live ng-pluralize:last').text()).
                              toBe('Igor and Misko are viewing.');

          using('.doc-example-live').input('personCount').enter('3');
          expect(element('.doc-example-live ng-pluralize:first').text()).
                                            toBe('3 people are viewing.');
          expect(element('.doc-example-live ng-pluralize:last').text()).
                              toBe('Igor, Misko and one other person are viewing.');

          using('.doc-example-live').input('personCount').enter('4');
          expect(element('.doc-example-live ng-pluralize:first').text()).
                                            toBe('4 people are viewing.');
          expect(element('.doc-example-live ng-pluralize:last').text()).
                              toBe('Igor, Misko and 2 other people are viewing.');
        });

        it('should show data-binded names', function() {
          using('.doc-example-live').input('personCount').enter('4');
          expect(element('.doc-example-live ng-pluralize:last').text()).
              toBe('Igor, Misko and 2 other people are viewing.');

          using('.doc-example-live').input('person1').enter('Di');
          using('.doc-example-live').input('person2').enter('Vojta');
          expect(element('.doc-example-live ng-pluralize:last').text()).
              toBe('Di, Vojta and 2 other people are viewing.');
        });
      </doc:scenario>
    </doc:example>
 */
var ngPluralizeDirective = ['$locale', '$interpolate', function($locale, $interpolate) {
  var BRACE = /{}/g;
  return {
    restrict: 'EA',
    link: function(scope, element, attr) {
      var numberExp = attr.count,
          whenExp = element.attr(attr.$attr.when), // this is because we have {{}} in attrs
          offset = attr.offset || 0,
          whens = scope.$eval(whenExp),
          whensExpFns = {},
          startSymbol = $interpolate.startSymbol(),
          endSymbol = $interpolate.endSymbol();

      forEach(whens, function(expression, key) {
        whensExpFns[key] =
          $interpolate(expression.replace(BRACE, startSymbol + numberExp + '-' +
            offset + endSymbol));
      });

      scope.$watch(function ngPluralizeWatch() {
        var value = parseFloat(scope.$eval(numberExp));

        if (!isNaN(value)) {
          //if explicit number rule such as 1, 2, 3... is defined, just use it. Otherwise,
          //check it against pluralization rules in $locale service
          if (!(value in whens)) value = $locale.pluralCat(value - offset);
           return whensExpFns[value](scope, element, true);
        } else {
          return '';
        }
      }, function ngPluralizeWatchAction(newVal) {
        element.text(newVal);
      });
    }
  };
}];

/**
 * @ngdoc directive
 * @name ng.directive:ngRepeat
 *
 * @description
 * The `ngRepeat` directive instantiates a template once per item from a collection. Each template
 * instance gets its own scope, where the given loop variable is set to the current collection item,
 * and `$index` is set to the item index or key.
 *
 * Special properties are exposed on the local scope of each template instance, including:
 *
 *   * `$index` – `{number}` – iterator offset of the repeated element (0..length-1)
 *   * `$first` – `{boolean}` – true if the repeated element is first in the iterator.
 *   * `$middle` – `{boolean}` – true if the repeated element is between the first and last in the iterator.
 *   * `$last` – `{boolean}` – true if the repeated element is last in the iterator.
 *
 *
 * @element ANY
 * @scope
 * @priority 1000
 * @param {repeat_expression} ngRepeat The expression indicating how to enumerate a collection. Two
 *   formats are currently supported:
 *
 *   * `variable in expression` – where variable is the user defined loop variable and `expression`
 *     is a scope expression giving the collection to enumerate.
 *
 *     For example: `track in cd.tracks`.
 *
 *   * `(key, value) in expression` – where `key` and `value` can be any user defined identifiers,
 *     and `expression` is the scope expression giving the collection to enumerate.
 *
 *     For example: `(name, age) in {'adam':10, 'amalie':12}`.
 *
 * @example
 * This example initializes the scope to a list of names and
 * then uses `ngRepeat` to display every person:
    <doc:example>
      <doc:source>
        <div ng-init="friends = [{name:'John', age:25}, {name:'Mary', age:28}]">
          I have {{friends.length}} friends. They are:
          <ul>
            <li ng-repeat="friend in friends">
              [{{$index + 1}}] {{friend.name}} who is {{friend.age}} years old.
            </li>
          </ul>
        </div>
      </doc:source>
      <doc:scenario>
         it('should check ng-repeat', function() {
           var r = using('.doc-example-live').repeater('ul li');
           expect(r.count()).toBe(2);
           expect(r.row(0)).toEqual(["1","John","25"]);
           expect(r.row(1)).toEqual(["2","Mary","28"]);
         });
      </doc:scenario>
    </doc:example>
 */
var ngRepeatDirective = ngDirective({
  transclude: 'element',
  priority: 1000,
  terminal: true,
  compile: function(element, attr, linker) {
    return function(scope, iterStartElement, attr){
      var expression = attr.ngRepeat;
      var match = expression.match(/^\s*(.+)\s+in\s+(.*)\s*$/),
        lhs, rhs, valueIdent, keyIdent;
      if (! match) {
        throw Error("Expected ngRepeat in form of '_item_ in _collection_' but got '" +
          expression + "'.");
      }
      lhs = match[1];
      rhs = match[2];
      match = lhs.match(/^(?:([\$\w]+)|\(([\$\w]+)\s*,\s*([\$\w]+)\))$/);
      if (!match) {
        throw Error("'item' in 'item in collection' should be identifier or (key, value) but got '" +
            lhs + "'.");
      }
      valueIdent = match[3] || match[1];
      keyIdent = match[2];

      // Store a list of elements from previous run. This is a hash where key is the item from the
      // iterator, and the value is an array of objects with following properties.
      //   - scope: bound scope
      //   - element: previous element.
      //   - index: position
      // We need an array of these objects since the same object can be returned from the iterator.
      // We expect this to be a rare case.
      var lastOrder = new HashQueueMap();

      scope.$watch(function ngRepeatWatch(scope){
        var index, length,
            collection = scope.$eval(rhs),
            cursor = iterStartElement,     // current position of the node
            // Same as lastOrder but it has the current state. It will become the
            // lastOrder on the next iteration.
            nextOrder = new HashQueueMap(),
            arrayBound,
            childScope,
            key, value, // key/value of iteration
            array,
            last;       // last object information {scope, element, index}



        if (!isArray(collection)) {
          // if object, extract keys, sort them and use to determine order of iteration over obj props
          array = [];
          for(key in collection) {
            if (collection.hasOwnProperty(key) && key.charAt(0) != '$') {
              array.push(key);
            }
          }
          array.sort();
        } else {
          array = collection || [];
        }

        arrayBound = array.length-1;

        // we are not using forEach for perf reasons (trying to avoid #call)
        for (index = 0, length = array.length; index < length; index++) {
          key = (collection === array) ? index : array[index];
          value = collection[key];

          last = lastOrder.shift(value);

          if (last) {
            // if we have already seen this object, then we need to reuse the
            // associated scope/element
            childScope = last.scope;
            nextOrder.push(value, last);

            if (index === last.index) {
              // do nothing
              cursor = last.element;
            } else {
              // existing item which got moved
              last.index = index;
              // This may be a noop, if the element is next, but I don't know of a good way to
              // figure this out,  since it would require extra DOM access, so let's just hope that
              // the browsers realizes that it is noop, and treats it as such.
              cursor.after(last.element);
              cursor = last.element;
            }
          } else {
            // new item which we don't know about
            childScope = scope.$new();
          }

          childScope[valueIdent] = value;
          if (keyIdent) childScope[keyIdent] = key;
          childScope.$index = index;

          childScope.$first = (index === 0);
          childScope.$last = (index === arrayBound);
          childScope.$middle = !(childScope.$first || childScope.$last);

          if (!last) {
            linker(childScope, function(clone){
              cursor.after(clone);
              last = {
                  scope: childScope,
                  element: (cursor = clone),
                  index: index
                };
              nextOrder.push(value, last);
            });
          }
        }

        //shrink children
        for (key in lastOrder) {
          if (lastOrder.hasOwnProperty(key)) {
            array = lastOrder[key];
            while(array.length) {
              value = array.pop();
              value.element.remove();
              value.scope.$destroy();
            }
          }
        }

        lastOrder = nextOrder;
      });
    };
  }
});

/**
 * @ngdoc directive
 * @name ng.directive:ngShow
 *
 * @description
 * The `ngShow` and `ngHide` directives show or hide a portion of the DOM tree (HTML)
 * conditionally.
 *
 * @element ANY
 * @param {expression} ngShow If the {@link guide/expression expression} is truthy
 *     then the element is shown or hidden respectively.
 *
 * @example
   <doc:example>
     <doc:source>
        Click me: <input type="checkbox" ng-model="checked"><br/>
        Show: <span ng-show="checked">I show up when your checkbox is checked.</span> <br/>
        Hide: <span ng-hide="checked">I hide when your checkbox is checked.</span>
     </doc:source>
     <doc:scenario>
       it('should check ng-show / ng-hide', function() {
         expect(element('.doc-example-live span:first:hidden').count()).toEqual(1);
         expect(element('.doc-example-live span:last:visible').count()).toEqual(1);

         input('checked').check();

         expect(element('.doc-example-live span:first:visible').count()).toEqual(1);
         expect(element('.doc-example-live span:last:hidden').count()).toEqual(1);
       });
     </doc:scenario>
   </doc:example>
 */
//TODO(misko): refactor to remove element from the DOM
var ngShowDirective = ngDirective(function(scope, element, attr){
  scope.$watch(attr.ngShow, function ngShowWatchAction(value){
    element.css('display', toBoolean(value) ? '' : 'none');
  });
});


/**
 * @ngdoc directive
 * @name ng.directive:ngHide
 *
 * @description
 * The `ngHide` and `ngShow` directives hide or show a portion of the DOM tree (HTML)
 * conditionally.
 *
 * @element ANY
 * @param {expression} ngHide If the {@link guide/expression expression} is truthy then
 *     the element is shown or hidden respectively.
 *
 * @example
   <doc:example>
     <doc:source>
        Click me: <input type="checkbox" ng-model="checked"><br/>
        Show: <span ng-show="checked">I show up when you checkbox is checked?</span> <br/>
        Hide: <span ng-hide="checked">I hide when you checkbox is checked?</span>
     </doc:source>
     <doc:scenario>
       it('should check ng-show / ng-hide', function() {
         expect(element('.doc-example-live span:first:hidden').count()).toEqual(1);
         expect(element('.doc-example-live span:last:visible').count()).toEqual(1);

         input('checked').check();

         expect(element('.doc-example-live span:first:visible').count()).toEqual(1);
         expect(element('.doc-example-live span:last:hidden').count()).toEqual(1);
       });
     </doc:scenario>
   </doc:example>
 */
//TODO(misko): refactor to remove element from the DOM
var ngHideDirective = ngDirective(function(scope, element, attr){
  scope.$watch(attr.ngHide, function ngHideWatchAction(value){
    element.css('display', toBoolean(value) ? 'none' : '');
  });
});

/**
 * @ngdoc directive
 * @name ng.directive:ngStyle
 *
 * @description
 * The `ngStyle` directive allows you to set CSS style on an HTML element conditionally.
 *
 * @element ANY
 * @param {expression} ngStyle {@link guide/expression Expression} which evals to an
 *      object whose keys are CSS style names and values are corresponding values for those CSS
 *      keys.
 *
 * @example
   <example>
     <file name="index.html">
        <input type="button" value="set" ng-click="myStyle={color:'red'}">
        <input type="button" value="clear" ng-click="myStyle={}">
        <br/>
        <span ng-style="myStyle">Sample Text</span>
        <pre>myStyle={{myStyle}}</pre>
     </file>
     <file name="style.css">
       span {
         color: black;
       }
     </file>
     <file name="scenario.js">
       it('should check ng-style', function() {
         expect(element('.doc-example-live span').css('color')).toBe('rgb(0, 0, 0)');
         element('.doc-example-live :button[value=set]').click();
         expect(element('.doc-example-live span').css('color')).toBe('rgb(255, 0, 0)');
         element('.doc-example-live :button[value=clear]').click();
         expect(element('.doc-example-live span').css('color')).toBe('rgb(0, 0, 0)');
       });
     </file>
   </example>
 */
var ngStyleDirective = ngDirective(function(scope, element, attr) {
  scope.$watch(attr.ngStyle, function ngStyleWatchAction(newStyles, oldStyles) {
    if (oldStyles && (newStyles !== oldStyles)) {
      forEach(oldStyles, function(val, style) { element.css(style, '');});
    }
    if (newStyles) element.css(newStyles);
  }, true);
});

/**
 * @ngdoc directive
 * @name ng.directive:ngSwitch
 * @restrict EA
 *
 * @description
 * Conditionally change the DOM structure.
 *
 * @usage
 * <ANY ng-switch="expression">
 *   <ANY ng-switch-when="matchValue1">...</ANY>
 *   <ANY ng-switch-when="matchValue2">...</ANY>
 *   ...
 *   <ANY ng-switch-default>...</ANY>
 * </ANY>
 *
 * @scope
 * @param {*} ngSwitch|on expression to match against <tt>ng-switch-when</tt>.
 * @paramDescription
 * On child elments add:
 *
 * * `ngSwitchWhen`: the case statement to match against. If match then this
 *   case will be displayed.
 * * `ngSwitchDefault`: the default case when no other casses match.
 *
 * @example
    <doc:example>
      <doc:source>
        <script>
          function Ctrl($scope) {
            $scope.items = ['settings', 'home', 'other'];
            $scope.selection = $scope.items[0];
          }
        </script>
        <div ng-controller="Ctrl">
          <select ng-model="selection" ng-options="item for item in items">
          </select>
          <tt>selection={{selection}}</tt>
          <hr/>
          <div ng-switch on="selection" >
            <div ng-switch-when="settings">Settings Div</div>
            <span ng-switch-when="home">Home Span</span>
            <span ng-switch-default>default</span>
          </div>
        </div>
      </doc:source>
      <doc:scenario>
        it('should start in settings', function() {
         expect(element('.doc-example-live [ng-switch]').text()).toMatch(/Settings Div/);
        });
        it('should change to home', function() {
         select('selection').option('home');
         expect(element('.doc-example-live [ng-switch]').text()).toMatch(/Home Span/);
        });
        it('should select deafault', function() {
         select('selection').option('other');
         expect(element('.doc-example-live [ng-switch]').text()).toMatch(/default/);
        });
      </doc:scenario>
    </doc:example>
 */
var NG_SWITCH = 'ng-switch';
var ngSwitchDirective = valueFn({
  restrict: 'EA',
  require: 'ngSwitch',
  // asks for $scope to fool the BC controller module
  controller: ['$scope', function ngSwitchController() {
    this.cases = {};
  }],
  link: function(scope, element, attr, ctrl) {
    var watchExpr = attr.ngSwitch || attr.on,
        selectedTransclude,
        selectedElement,
        selectedScope;

    scope.$watch(watchExpr, function ngSwitchWatchAction(value) {
      if (selectedElement) {
        selectedScope.$destroy();
        selectedElement.remove();
        selectedElement = selectedScope = null;
      }
      if ((selectedTransclude = ctrl.cases['!' + value] || ctrl.cases['?'])) {
        scope.$eval(attr.change);
        selectedScope = scope.$new();
        selectedTransclude(selectedScope, function(caseElement) {
          selectedElement = caseElement;
          element.append(caseElement);
        });
      }
    });
  }
});

var ngSwitchWhenDirective = ngDirective({
  transclude: 'element',
  priority: 500,
  require: '^ngSwitch',
  compile: function(element, attrs, transclude) {
    return function(scope, element, attr, ctrl) {
      ctrl.cases['!' + attrs.ngSwitchWhen] = transclude;
    };
  }
});

var ngSwitchDefaultDirective = ngDirective({
  transclude: 'element',
  priority: 500,
  require: '^ngSwitch',
  compile: function(element, attrs, transclude) {
    return function(scope, element, attr, ctrl) {
      ctrl.cases['?'] = transclude;
    };
  }
});

/**
 * @ngdoc directive
 * @name ng.directive:ngTransclude
 *
 * @description
 * Insert the transcluded DOM here.
 *
 * @element ANY
 *
 * @example
   <doc:example module="transclude">
     <doc:source>
       <script>
         function Ctrl($scope) {
           $scope.title = 'Lorem Ipsum';
           $scope.text = 'Neque porro quisquam est qui dolorem ipsum quia dolor...';
         }

         angular.module('transclude', [])
          .directive('pane', function(){
             return {
               restrict: 'E',
               transclude: true,
               scope: 'isolate',
               locals: { title:'bind' },
               template: '<div style="border: 1px solid black;">' +
                           '<div style="background-color: gray">{{title}}</div>' +
                           '<div ng-transclude></div>' +
                         '</div>'
             };
         });
       </script>
       <div ng-controller="Ctrl">
         <input ng-model="title"><br>
         <textarea ng-model="text"></textarea> <br/>
         <pane title="{{title}}">{{text}}</pane>
       </div>
     </doc:source>
     <doc:scenario>
        it('should have transcluded', function() {
          input('title').enter('TITLE');
          input('text').enter('TEXT');
          expect(binding('title')).toEqual('TITLE');
          expect(binding('text')).toEqual('TEXT');
        });
     </doc:scenario>
   </doc:example>
 *
 */
var ngTranscludeDirective = ngDirective({
  controller: ['$transclude', '$element', function($transclude, $element) {
    $transclude(function(clone) {
      $element.append(clone);
    });
  }]
});

/**
 * @ngdoc directive
 * @name ng.directive:ngView
 * @restrict ECA
 *
 * @description
 * # Overview
 * `ngView` is a directive that complements the {@link ng.$route $route} service by
 * including the rendered template of the current route into the main layout (`index.html`) file.
 * Every time the current route changes, the included view changes with it according to the
 * configuration of the `$route` service.
 *
 * @scope
 * @example
    <example module="ngView">
      <file name="index.html">
        <div ng-controller="MainCntl">
          Choose:
          <a href="Book/Moby">Moby</a> |
          <a href="Book/Moby/ch/1">Moby: Ch1</a> |
          <a href="Book/Gatsby">Gatsby</a> |
          <a href="Book/Gatsby/ch/4?key=value">Gatsby: Ch4</a> |
          <a href="Book/Scarlet">Scarlet Letter</a><br/>

          <div ng-view></div>
          <hr />

          <pre>$location.path() = {{$location.path()}}</pre>
          <pre>$route.current.templateUrl = {{$route.current.templateUrl}}</pre>
          <pre>$route.current.params = {{$route.current.params}}</pre>
          <pre>$route.current.scope.name = {{$route.current.scope.name}}</pre>
          <pre>$routeParams = {{$routeParams}}</pre>
        </div>
      </file>

      <file name="book.html">
        controller: {{name}}<br />
        Book Id: {{params.bookId}}<br />
      </file>

      <file name="chapter.html">
        controller: {{name}}<br />
        Book Id: {{params.bookId}}<br />
        Chapter Id: {{params.chapterId}}
      </file>

      <file name="script.js">
        angular.module('ngView', [], function($routeProvider, $locationProvider) {
          $routeProvider.when('/Book/:bookId', {
            templateUrl: 'book.html',
            controller: BookCntl
          });
          $routeProvider.when('/Book/:bookId/ch/:chapterId', {
            templateUrl: 'chapter.html',
            controller: ChapterCntl
          });

          // configure html5 to get links working on jsfiddle
          $locationProvider.html5Mode(true);
        });

        function MainCntl($scope, $route, $routeParams, $location) {
          $scope.$route = $route;
          $scope.$location = $location;
          $scope.$routeParams = $routeParams;
        }

        function BookCntl($scope, $routeParams) {
          $scope.name = "BookCntl";
          $scope.params = $routeParams;
        }

        function ChapterCntl($scope, $routeParams) {
          $scope.name = "ChapterCntl";
          $scope.params = $routeParams;
        }
      </file>

      <file name="scenario.js">
        it('should load and compile correct template', function() {
          element('a:contains("Moby: Ch1")').click();
          var content = element('.doc-example-live [ng-view]').text();
          expect(content).toMatch(/controller\: ChapterCntl/);
          expect(content).toMatch(/Book Id\: Moby/);
          expect(content).toMatch(/Chapter Id\: 1/);

          element('a:contains("Scarlet")').click();
          content = element('.doc-example-live [ng-view]').text();
          expect(content).toMatch(/controller\: BookCntl/);
          expect(content).toMatch(/Book Id\: Scarlet/);
        });
      </file>
    </example>
 */


/**
 * @ngdoc event
 * @name ng.directive:ngView#$viewContentLoaded
 * @eventOf ng.directive:ngView
 * @eventType emit on the current ngView scope
 * @description
 * Emitted every time the ngView content is reloaded.
 */
var ngViewDirective = ['$http', '$templateCache', '$route', '$anchorScroll', '$compile',
                       '$controller',
               function($http,   $templateCache,   $route,   $anchorScroll,   $compile,
                        $controller) {
  return {
    restrict: 'ECA',
    terminal: true,
    link: function(scope, element, attr) {
      var lastScope,
          onloadExp = attr.onload || '';

      scope.$on('$routeChangeSuccess', update);
      update();


      function destroyLastScope() {
        if (lastScope) {
          lastScope.$destroy();
          lastScope = null;
        }
      }

      function clearContent() {
        element.html('');
        destroyLastScope();
      }

      function update() {
        var locals = $route.current && $route.current.locals,
            template = locals && locals.$template;

        if (template) {
          element.html(template);
          destroyLastScope();

          var link = $compile(element.contents()),
              current = $route.current,
              controller;

          lastScope = current.scope = scope.$new();
          if (current.controller) {
            locals.$scope = lastScope;
            controller = $controller(current.controller, locals);
            element.children().data('$ngControllerController', controller);
          }

          link(lastScope);
          lastScope.$emit('$viewContentLoaded');
          lastScope.$eval(onloadExp);

          // $anchorScroll might listen on event...
          $anchorScroll();
        } else {
          clearContent();
        }
      }
    }
  };
}];

/**
 * @ngdoc directive
 * @name ng.directive:script
 *
 * @description
 * Load content of a script tag, with type `text/ng-template`, into `$templateCache`, so that the
 * template can be used by `ngInclude`, `ngView` or directive templates.
 *
 * @restrict E
 * @param {'text/ng-template'} type must be set to `'text/ng-template'`
 *
 * @example
  <doc:example>
    <doc:source>
      <script type="text/ng-template" id="/tpl.html">
        Content of the template.
      </script>

      <a ng-click="currentTpl='/tpl.html'" id="tpl-link">Load inlined template</a>
      <div id="tpl-content" ng-include src="currentTpl"></div>
    </doc:source>
    <doc:scenario>
      it('should load template defined inside script tag', function() {
        element('#tpl-link').click();
        expect(element('#tpl-content').text()).toMatch(/Content of the template/);
      });
    </doc:scenario>
  </doc:example>
 */
var scriptDirective = ['$templateCache', function($templateCache) {
  return {
    restrict: 'E',
    terminal: true,
    compile: function(element, attr) {
      if (attr.type == 'text/ng-template') {
        var templateUrl = attr.id,
            // IE is not consistent, in scripts we have to read .text but in other nodes we have to read .textContent
            text = element[0].text;

        $templateCache.put(templateUrl, text);
      }
    }
  };
}];

/**
 * @ngdoc directive
 * @name ng.directive:select
 * @restrict E
 *
 * @description
 * HTML `SELECT` element with angular data-binding.
 *
 * # `ngOptions`
 *
 * Optionally `ngOptions` attribute can be used to dynamically generate a list of `<option>`
 * elements for a `<select>` element using an array or an object obtained by evaluating the
 * `ngOptions` expression.
 *˝˝
 * When an item in the select menu is select, the value of array element or object property
 * represented by the selected option will be bound to the model identified by the `ngModel`
 * directive of the parent select element.
 *
 * Optionally, a single hard-coded `<option>` element, with the value set to an empty string, can
 * be nested into the `<select>` element. This element will then represent `null` or "not selected"
 * option. See example below for demonstration.
 *
 * Note: `ngOptions` provides iterator facility for `<option>` element which should be used instead
 * of {@link ng.directive:ngRepeat ngRepeat} when you want the
 * `select` model to be bound to a non-string value. This is because an option element can currently
 * be bound to string values only.
 *
 * @param {string} ngModel Assignable angular expression to data-bind to.
 * @param {string=} name Property name of the form under which the control is published.
 * @param {string=} required The control is considered valid only if value is entered.
 * @param {string=} ngRequired Adds `required` attribute and `required` validation constraint to
 *    the element when the ngRequired expression evaluates to true. Use `ngRequired` instead of
 *    `required` when you want to data-bind to the `required` attribute.
 * @param {comprehension_expression=} ngOptions in one of the following forms:
 *
 *   * for array data sources:
 *     * `label` **`for`** `value` **`in`** `array`
 *     * `select` **`as`** `label` **`for`** `value` **`in`** `array`
 *     * `label`  **`group by`** `group` **`for`** `value` **`in`** `array`
 *     * `select` **`as`** `label` **`group by`** `group` **`for`** `value` **`in`** `array`
 *   * for object data sources:
 *     * `label` **`for (`**`key` **`,`** `value`**`) in`** `object`
 *     * `select` **`as`** `label` **`for (`**`key` **`,`** `value`**`) in`** `object`
 *     * `label` **`group by`** `group` **`for (`**`key`**`,`** `value`**`) in`** `object`
 *     * `select` **`as`** `label` **`group by`** `group`
 *         **`for` `(`**`key`**`,`** `value`**`) in`** `object`
 *
 * Where:
 *
 *   * `array` / `object`: an expression which evaluates to an array / object to iterate over.
 *   * `value`: local variable which will refer to each item in the `array` or each property value
 *      of `object` during iteration.
 *   * `key`: local variable which will refer to a property name in `object` during iteration.
 *   * `label`: The result of this expression will be the label for `<option>` element. The
 *     `expression` will most likely refer to the `value` variable (e.g. `value.propertyName`).
 *   * `select`: The result of this expression will be bound to the model of the parent `<select>`
 *      element. If not specified, `select` expression will default to `value`.
 *   * `group`: The result of this expression will be used to group options using the `<optgroup>`
 *      DOM element.
 *
 * @example
    <doc:example>
      <doc:source>
        <script>
        function MyCntrl($scope) {
          $scope.colors = [
            {name:'black', shade:'dark'},
            {name:'white', shade:'light'},
            {name:'red', shade:'dark'},
            {name:'blue', shade:'dark'},
            {name:'yellow', shade:'light'}
          ];
          $scope.color = $scope.colors[2]; // red
        }
        </script>
        <div ng-controller="MyCntrl">
          <ul>
            <li ng-repeat="color in colors">
              Name: <input ng-model="color.name">
              [<a href ng-click="colors.splice($index, 1)">X</a>]
            </li>
            <li>
              [<a href ng-click="colors.push({})">add</a>]
            </li>
          </ul>
          <hr/>
          Color (null not allowed):
          <select ng-model="color" ng-options="c.name for c in colors"></select><br>

          Color (null allowed):
          <span  class="nullable">
            <select ng-model="color" ng-options="c.name for c in colors">
              <option value="">-- chose color --</option>
            </select>
          </span><br/>

          Color grouped by shade:
          <select ng-model="color" ng-options="c.name group by c.shade for c in colors">
          </select><br/>


          Select <a href ng-click="color={name:'not in list'}">bogus</a>.<br>
          <hr/>
          Currently selected: {{ {selected_color:color}  }}
          <div style="border:solid 1px black; height:20px"
               ng-style="{'background-color':color.name}">
          </div>
        </div>
      </doc:source>
      <doc:scenario>
         it('should check ng-options', function() {
           expect(binding('{selected_color:color}')).toMatch('red');
           select('color').option('0');
           expect(binding('{selected_color:color}')).toMatch('black');
           using('.nullable').select('color').option('');
           expect(binding('{selected_color:color}')).toMatch('null');
         });
      </doc:scenario>
    </doc:example>
 */

var ngOptionsDirective = valueFn({ terminal: true });
var selectDirective = ['$compile', '$parse', function($compile,   $parse) {
                         //0000111110000000000022220000000000000000000000333300000000000000444444444444444440000000005555555555555555500000006666666666666666600000000000000077770
  var NG_OPTIONS_REGEXP = /^\s*(.*?)(?:\s+as\s+(.*?))?(?:\s+group\s+by\s+(.*))?\s+for\s+(?:([\$\w][\$\w\d]*)|(?:\(\s*([\$\w][\$\w\d]*)\s*,\s*([\$\w][\$\w\d]*)\s*\)))\s+in\s+(.*)$/,
      nullModelCtrl = {$setViewValue: noop};

  return {
    restrict: 'E',
    require: ['select', '?ngModel'],
    controller: ['$element', '$scope', '$attrs', function($element, $scope, $attrs) {
      var self = this,
          optionsMap = {},
          ngModelCtrl = nullModelCtrl,
          nullOption,
          unknownOption;


      self.databound = $attrs.ngModel;


      self.init = function(ngModelCtrl_, nullOption_, unknownOption_) {
        ngModelCtrl = ngModelCtrl_;
        nullOption = nullOption_;
        unknownOption = unknownOption_;
      }


      self.addOption = function(value) {
        optionsMap[value] = true;

        if (ngModelCtrl.$viewValue == value) {
          $element.val(value);
          if (unknownOption.parent()) unknownOption.remove();
        }
      };


      self.removeOption = function(value) {
        if (this.hasOption(value)) {
          delete optionsMap[value];
          if (ngModelCtrl.$viewValue == value) {
            this.renderUnknownOption(value);
          }
        }
      };


      self.renderUnknownOption = function(val) {
        var unknownVal = '? ' + hashKey(val) + ' ?';
        unknownOption.val(unknownVal);
        $element.prepend(unknownOption);
        $element.val(unknownVal);
        unknownOption.prop('selected', true); // needed for IE
      }


      self.hasOption = function(value) {
        return optionsMap.hasOwnProperty(value);
      }

      $scope.$on('$destroy', function() {
        // disable unknown option so that we don't do work when the whole select is being destroyed
        self.renderUnknownOption = noop;
      });
    }],

    link: function(scope, element, attr, ctrls) {
      // if ngModel is not defined, we don't need to do anything
      if (!ctrls[1]) return;

      var selectCtrl = ctrls[0],
          ngModelCtrl = ctrls[1],
          multiple = attr.multiple,
          optionsExp = attr.ngOptions,
          nullOption = false, // if false, user will not be able to select it (used by ngOptions)
          emptyOption,
          // we can't just jqLite('<option>') since jqLite is not smart enough
          // to create it in <select> and IE barfs otherwise.
          optionTemplate = jqLite(document.createElement('option')),
          optGroupTemplate =jqLite(document.createElement('optgroup')),
          unknownOption = optionTemplate.clone();

      // find "null" option
      for(var i = 0, children = element.children(), ii = children.length; i < ii; i++) {
        if (children[i].value == '') {
          emptyOption = nullOption = children.eq(i);
          break;
        }
      }

      selectCtrl.init(ngModelCtrl, nullOption, unknownOption);

      // required validator
      if (multiple && (attr.required || attr.ngRequired)) {
        var requiredValidator = function(value) {
          ngModelCtrl.$setValidity('required', !attr.required || (value && value.length));
          return value;
        };

        ngModelCtrl.$parsers.push(requiredValidator);
        ngModelCtrl.$formatters.unshift(requiredValidator);

        attr.$observe('required', function() {
          requiredValidator(ngModelCtrl.$viewValue);
        });
      }

      if (optionsExp) Options(scope, element, ngModelCtrl);
      else if (multiple) Multiple(scope, element, ngModelCtrl);
      else Single(scope, element, ngModelCtrl, selectCtrl);


      ////////////////////////////



      function Single(scope, selectElement, ngModelCtrl, selectCtrl) {
        ngModelCtrl.$render = function() {
          var viewValue = ngModelCtrl.$viewValue;

          if (selectCtrl.hasOption(viewValue)) {
            if (unknownOption.parent()) unknownOption.remove();
            selectElement.val(viewValue);
            if (viewValue === '') emptyOption.prop('selected', true); // to make IE9 happy
          } else {
            if (isUndefined(viewValue) && emptyOption) {
              selectElement.val('');
            } else {
              selectCtrl.renderUnknownOption(viewValue);
            }
          }
        };

        selectElement.bind('change', function() {
          scope.$apply(function() {
            if (unknownOption.parent()) unknownOption.remove();
            ngModelCtrl.$setViewValue(selectElement.val());
          });
        });
      }

      function Multiple(scope, selectElement, ctrl) {
        var lastView;
        ctrl.$render = function() {
          var items = new HashMap(ctrl.$viewValue);
          forEach(selectElement.find('option'), function(option) {
            option.selected = isDefined(items.get(option.value));
          });
        };

        // we have to do it on each watch since ngModel watches reference, but
        // we need to work of an array, so we need to see if anything was inserted/removed
        scope.$watch(function selectMultipleWatch() {
          if (!equals(lastView, ctrl.$viewValue)) {
            lastView = copy(ctrl.$viewValue);
            ctrl.$render();
          }
        });

        selectElement.bind('change', function() {
          scope.$apply(function() {
            var array = [];
            forEach(selectElement.find('option'), function(option) {
              if (option.selected) {
                array.push(option.value);
              }
            });
            ctrl.$setViewValue(array);
          });
        });
      }

      function Options(scope, selectElement, ctrl) {
        var match;

        if (! (match = optionsExp.match(NG_OPTIONS_REGEXP))) {
          throw Error(
            "Expected ngOptions in form of '_select_ (as _label_)? for (_key_,)?_value_ in _collection_'" +
            " but got '" + optionsExp + "'.");
        }

        var displayFn = $parse(match[2] || match[1]),
            valueName = match[4] || match[6],
            keyName = match[5],
            groupByFn = $parse(match[3] || ''),
            valueFn = $parse(match[2] ? match[1] : valueName),
            valuesFn = $parse(match[7]),
            // This is an array of array of existing option groups in DOM. We try to reuse these if possible
            // optionGroupsCache[0] is the options with no option group
            // optionGroupsCache[?][0] is the parent: either the SELECT or OPTGROUP element
            optionGroupsCache = [[{element: selectElement, label:''}]];

        if (nullOption) {
          // compile the element since there might be bindings in it
          $compile(nullOption)(scope);

          // remove the class, which is added automatically because we recompile the element and it
          // becomes the compilation root
          nullOption.removeClass('ng-scope');

          // we need to remove it before calling selectElement.html('') because otherwise IE will
          // remove the label from the element. wtf?
          nullOption.remove();
        }

        // clear contents, we'll add what's needed based on the model
        selectElement.html('');

        selectElement.bind('change', function() {
          scope.$apply(function() {
            var optionGroup,
                collection = valuesFn(scope) || [],
                locals = {},
                key, value, optionElement, index, groupIndex, length, groupLength;

            if (multiple) {
              value = [];
              for (groupIndex = 0, groupLength = optionGroupsCache.length;
                   groupIndex < groupLength;
                   groupIndex++) {
                // list of options for that group. (first item has the parent)
                optionGroup = optionGroupsCache[groupIndex];

                for(index = 1, length = optionGroup.length; index < length; index++) {
                  if ((optionElement = optionGroup[index].element)[0].selected) {
                    key = optionElement.val();
                    if (keyName) locals[keyName] = key;
                    locals[valueName] = collection[key];
                    value.push(valueFn(scope, locals));
                  }
                }
              }
            } else {
              key = selectElement.val();
              if (key == '?') {
                value = undefined;
              } else if (key == ''){
                value = null;
              } else {
                locals[valueName] = collection[key];
                if (keyName) locals[keyName] = key;
                value = valueFn(scope, locals);
              }
            }
            ctrl.$setViewValue(value);
          });
        });

        ctrl.$render = render;

        // TODO(vojta): can't we optimize this ?
        scope.$watch(render);

        function render() {
          var optionGroups = {'':[]}, // Temporary location for the option groups before we render them
              optionGroupNames = [''],
              optionGroupName,
              optionGroup,
              option,
              existingParent, existingOptions, existingOption,
              modelValue = ctrl.$modelValue,
              values = valuesFn(scope) || [],
              keys = keyName ? sortedKeys(values) : values,
              groupLength, length,
              groupIndex, index,
              locals = {},
              selected,
              selectedSet = false, // nothing is selected yet
              lastElement,
              element,
              label;

          if (multiple) {
            selectedSet = new HashMap(modelValue);
          }

          // We now build up the list of options we need (we merge later)
          for (index = 0; length = keys.length, index < length; index++) {
               locals[valueName] = values[keyName ? locals[keyName]=keys[index]:index];
               optionGroupName = groupByFn(scope, locals) || '';
            if (!(optionGroup = optionGroups[optionGroupName])) {
              optionGroup = optionGroups[optionGroupName] = [];
              optionGroupNames.push(optionGroupName);
            }
            if (multiple) {
              selected = selectedSet.remove(valueFn(scope, locals)) != undefined;
            } else {
              selected = modelValue === valueFn(scope, locals);
              selectedSet = selectedSet || selected; // see if at least one item is selected
            }
            label = displayFn(scope, locals); // what will be seen by the user
            label = label === undefined ? '' : label; // doing displayFn(scope, locals) || '' overwrites zero values
            optionGroup.push({
              id: keyName ? keys[index] : index,   // either the index into array or key from object
              label: label,
              selected: selected                   // determine if we should be selected
            });
          }
          if (!multiple) {
            if (nullOption || modelValue === null) {
              // insert null option if we have a placeholder, or the model is null
              optionGroups[''].unshift({id:'', label:'', selected:!selectedSet});
            } else if (!selectedSet) {
              // option could not be found, we have to insert the undefined item
              optionGroups[''].unshift({id:'?', label:'', selected:true});
            }
          }

          // Now we need to update the list of DOM nodes to match the optionGroups we computed above
          for (groupIndex = 0, groupLength = optionGroupNames.length;
               groupIndex < groupLength;
               groupIndex++) {
            // current option group name or '' if no group
            optionGroupName = optionGroupNames[groupIndex];

            // list of options for that group. (first item has the parent)
            optionGroup = optionGroups[optionGroupName];

            if (optionGroupsCache.length <= groupIndex) {
              // we need to grow the optionGroups
              existingParent = {
                element: optGroupTemplate.clone().attr('label', optionGroupName),
                label: optionGroup.label
              };
              existingOptions = [existingParent];
              optionGroupsCache.push(existingOptions);
              selectElement.append(existingParent.element);
            } else {
              existingOptions = optionGroupsCache[groupIndex];
              existingParent = existingOptions[0];  // either SELECT (no group) or OPTGROUP element

              // update the OPTGROUP label if not the same.
              if (existingParent.label != optionGroupName) {
                existingParent.element.attr('label', existingParent.label = optionGroupName);
              }
            }

            lastElement = null;  // start at the beginning
            for(index = 0, length = optionGroup.length; index < length; index++) {
              option = optionGroup[index];
              if ((existingOption = existingOptions[index+1])) {
                // reuse elements
                lastElement = existingOption.element;
                if (existingOption.label !== option.label) {
                  lastElement.text(existingOption.label = option.label);
                }
                if (existingOption.id !== option.id) {
                  lastElement.val(existingOption.id = option.id);
                }
                // lastElement.prop('selected') provided by jQuery has side-effects
                if (lastElement[0].selected !== option.selected) {
                  lastElement.prop('selected', (existingOption.selected = option.selected));
                }
              } else {
                // grow elements

                // if it's a null option
                if (option.id === '' && nullOption) {
                  // put back the pre-compiled element
                  element = nullOption;
                } else {
                  // jQuery(v1.4.2) Bug: We should be able to chain the method calls, but
                  // in this version of jQuery on some browser the .text() returns a string
                  // rather then the element.
                  (element = optionTemplate.clone())
                      .val(option.id)
                      .attr('selected', option.selected)
                      .text(option.label);
                }

                existingOptions.push(existingOption = {
                    element: element,
                    label: option.label,
                    id: option.id,
                    selected: option.selected
                });
                if (lastElement) {
                  lastElement.after(element);
                } else {
                  existingParent.element.append(element);
                }
                lastElement = element;
              }
            }
            // remove any excessive OPTIONs in a group
            index++; // increment since the existingOptions[0] is parent element not OPTION
            while(existingOptions.length > index) {
              existingOptions.pop().element.remove();
            }
          }
          // remove any excessive OPTGROUPs from select
          while(optionGroupsCache.length > groupIndex) {
            optionGroupsCache.pop()[0].element.remove();
          }
        }
      }
    }
  }
}];

var optionDirective = ['$interpolate', function($interpolate) {
  var nullSelectCtrl = {
    addOption: noop,
    removeOption: noop
  };

  return {
    restrict: 'E',
    priority: 100,
    compile: function(element, attr) {
      if (isUndefined(attr.value)) {
        var interpolateFn = $interpolate(element.text(), true);
        if (!interpolateFn) {
          attr.$set('value', element.text());
        }
      }

      return function (scope, element, attr) {
        var selectCtrlName = '$selectController',
            parent = element.parent(),
            selectCtrl = parent.data(selectCtrlName) ||
              parent.parent().data(selectCtrlName); // in case we are in optgroup

        if (selectCtrl && selectCtrl.databound) {
          // For some reason Opera defaults to true and if not overridden this messes up the repeater.
          // We don't want the view to drive the initialization of the model anyway.
          element.prop('selected', false);
        } else {
          selectCtrl = nullSelectCtrl;
        }

        if (interpolateFn) {
          scope.$watch(interpolateFn, function interpolateWatchAction(newVal, oldVal) {
            attr.$set('value', newVal);
            if (newVal !== oldVal) selectCtrl.removeOption(oldVal);
            selectCtrl.addOption(newVal);
          });
        } else {
          selectCtrl.addOption(attr.value);
        }

        element.bind('$destroy', function() {
          selectCtrl.removeOption(attr.value);
        });
      };
    }
  }
}];

var styleDirective = valueFn({
  restrict: 'E',
  terminal: true
});

  //try to bind to jquery now so that one can write angular.element().read()
  //but we will rebind on bootstrap again.
  bindJQuery();

  publishExternalAPI(angular);

  jqLite(document).ready(function() {
    angularInit(document, bootstrap);
  });

})(window, document);
angular.element(document).find('head').append('<style type="text/css">@charset "UTF-8";[ng\\:cloak],[ng-cloak],[data-ng-cloak],[x-ng-cloak],.ng-cloak,.x-ng-cloak{display:none;}ng\\:form{display:block;}</style>');
var Chart=function(s){function v(a,c,b){a=A((a-c.graphMin)/(c.steps*c.stepValue),1,0);return b*c.steps*a}function x(a,c,b,e){function h(){g+=f;var k=a.animation?A(d(g),null,0):1;e.clearRect(0,0,q,u);a.scaleOverlay?(b(k),c()):(c(),b(k));if(1>=g)D(h);else if("function"==typeof a.onAnimationComplete)a.onAnimationComplete()}var f=a.animation?1/A(a.animationSteps,Number.MAX_VALUE,1):1,d=B[a.animationEasing],g=a.animation?0:1;"function"!==typeof c&&(c=function(){});D(h)}function C(a,c,b,e,h,f){var d;a=
Math.floor(Math.log(e-h)/Math.LN10);h=Math.floor(h/(1*Math.pow(10,a)))*Math.pow(10,a);e=Math.ceil(e/(1*Math.pow(10,a)))*Math.pow(10,a)-h;a=Math.pow(10,a);for(d=Math.round(e/a);d<b||d>c;)a=d<b?a/2:2*a,d=Math.round(e/a);c=[];z(f,c,d,h,a);return{steps:d,stepValue:a,graphMin:h,labels:c}}function z(a,c,b,e,h){if(a)for(var f=1;f<b+1;f++)c.push(E(a,{value:(e+h*f).toFixed(0!=h%1?h.toString().split(".")[1].length:0)}))}function A(a,c,b){return!isNaN(parseFloat(c))&&isFinite(c)&&a>c?c:!isNaN(parseFloat(b))&&
isFinite(b)&&a<b?b:a}function y(a,c){var b={},e;for(e in a)b[e]=a[e];for(e in c)b[e]=c[e];return b}function E(a,c){var b=!/\W/.test(a)?F[a]=F[a]||E(document.getElementById(a).innerHTML):new Function("obj","var p=[],print=function(){p.push.apply(p,arguments);};with(obj){p.push('"+a.replace(/[\r\t\n]/g," ").split("<%").join("\t").replace(/((^|%>)[^\t]*)'/g,"$1\r").replace(/\t=(.*?)%>/g,"',$1,'").split("\t").join("');").split("%>").join("p.push('").split("\r").join("\\'")+"');}return p.join('');");return c?
b(c):b}var r=this,B={linear:function(a){return a},easeInQuad:function(a){return a*a},easeOutQuad:function(a){return-1*a*(a-2)},easeInOutQuad:function(a){return 1>(a/=0.5)?0.5*a*a:-0.5*(--a*(a-2)-1)},easeInCubic:function(a){return a*a*a},easeOutCubic:function(a){return 1*((a=a/1-1)*a*a+1)},easeInOutCubic:function(a){return 1>(a/=0.5)?0.5*a*a*a:0.5*((a-=2)*a*a+2)},easeInQuart:function(a){return a*a*a*a},easeOutQuart:function(a){return-1*((a=a/1-1)*a*a*a-1)},easeInOutQuart:function(a){return 1>(a/=0.5)?
0.5*a*a*a*a:-0.5*((a-=2)*a*a*a-2)},easeInQuint:function(a){return 1*(a/=1)*a*a*a*a},easeOutQuint:function(a){return 1*((a=a/1-1)*a*a*a*a+1)},easeInOutQuint:function(a){return 1>(a/=0.5)?0.5*a*a*a*a*a:0.5*((a-=2)*a*a*a*a+2)},easeInSine:function(a){return-1*Math.cos(a/1*(Math.PI/2))+1},easeOutSine:function(a){return 1*Math.sin(a/1*(Math.PI/2))},easeInOutSine:function(a){return-0.5*(Math.cos(Math.PI*a/1)-1)},easeInExpo:function(a){return 0==a?1:1*Math.pow(2,10*(a/1-1))},easeOutExpo:function(a){return 1==
a?1:1*(-Math.pow(2,-10*a/1)+1)},easeInOutExpo:function(a){return 0==a?0:1==a?1:1>(a/=0.5)?0.5*Math.pow(2,10*(a-1)):0.5*(-Math.pow(2,-10*--a)+2)},easeInCirc:function(a){return 1<=a?a:-1*(Math.sqrt(1-(a/=1)*a)-1)},easeOutCirc:function(a){return 1*Math.sqrt(1-(a=a/1-1)*a)},easeInOutCirc:function(a){return 1>(a/=0.5)?-0.5*(Math.sqrt(1-a*a)-1):0.5*(Math.sqrt(1-(a-=2)*a)+1)},easeInElastic:function(a){var c=1.70158,b=0,e=1;if(0==a)return 0;if(1==(a/=1))return 1;b||(b=0.3);e<Math.abs(1)?(e=1,c=b/4):c=b/(2*
Math.PI)*Math.asin(1/e);return-(e*Math.pow(2,10*(a-=1))*Math.sin((1*a-c)*2*Math.PI/b))},easeOutElastic:function(a){var c=1.70158,b=0,e=1;if(0==a)return 0;if(1==(a/=1))return 1;b||(b=0.3);e<Math.abs(1)?(e=1,c=b/4):c=b/(2*Math.PI)*Math.asin(1/e);return e*Math.pow(2,-10*a)*Math.sin((1*a-c)*2*Math.PI/b)+1},easeInOutElastic:function(a){var c=1.70158,b=0,e=1;if(0==a)return 0;if(2==(a/=0.5))return 1;b||(b=1*0.3*1.5);e<Math.abs(1)?(e=1,c=b/4):c=b/(2*Math.PI)*Math.asin(1/e);return 1>a?-0.5*e*Math.pow(2,10*
(a-=1))*Math.sin((1*a-c)*2*Math.PI/b):0.5*e*Math.pow(2,-10*(a-=1))*Math.sin((1*a-c)*2*Math.PI/b)+1},easeInBack:function(a){return 1*(a/=1)*a*(2.70158*a-1.70158)},easeOutBack:function(a){return 1*((a=a/1-1)*a*(2.70158*a+1.70158)+1)},easeInOutBack:function(a){var c=1.70158;return 1>(a/=0.5)?0.5*a*a*(((c*=1.525)+1)*a-c):0.5*((a-=2)*a*(((c*=1.525)+1)*a+c)+2)},easeInBounce:function(a){return 1-B.easeOutBounce(1-a)},easeOutBounce:function(a){return(a/=1)<1/2.75?1*7.5625*a*a:a<2/2.75?1*(7.5625*(a-=1.5/2.75)*
a+0.75):a<2.5/2.75?1*(7.5625*(a-=2.25/2.75)*a+0.9375):1*(7.5625*(a-=2.625/2.75)*a+0.984375)},easeInOutBounce:function(a){return 0.5>a?0.5*B.easeInBounce(2*a):0.5*B.easeOutBounce(2*a-1)+0.5}},q=s.canvas.width,u=s.canvas.height;window.devicePixelRatio&&(s.canvas.style.width=q+"px",s.canvas.style.height=u+"px",s.canvas.height=u*window.devicePixelRatio,s.canvas.width=q*window.devicePixelRatio,s.scale(window.devicePixelRatio,window.devicePixelRatio));this.PolarArea=function(a,c){r.PolarArea.defaults={scaleOverlay:!0,
scaleOverride:!1,scaleSteps:null,scaleStepWidth:null,scaleStartValue:null,scaleShowLine:!0,scaleLineColor:"rgba(0,0,0,.1)",scaleLineWidth:1,scaleShowLabels:!0,scaleLabel:"<%=value%>",scaleFontFamily:"'Arial'",scaleFontSize:12,scaleFontStyle:"normal",scaleFontColor:"#666",scaleShowLabelBackdrop:!0,scaleBackdropColor:"rgba(255,255,255,0.75)",scaleBackdropPaddingY:2,scaleBackdropPaddingX:2,segmentShowStroke:!0,segmentStrokeColor:"#fff",segmentStrokeWidth:2,animation:!0,animationSteps:100,animationEasing:"easeOutBounce",
animateRotate:!0,animateScale:!1,onAnimationComplete:null};var b=c?y(r.PolarArea.defaults,c):r.PolarArea.defaults;return new G(a,b,s)};this.Radar=function(a,c){r.Radar.defaults={scaleOverlay:!1,scaleOverride:!1,scaleSteps:null,scaleStepWidth:null,scaleStartValue:null,scaleShowLine:!0,scaleLineColor:"rgba(0,0,0,.1)",scaleLineWidth:1,scaleShowLabels:!1,scaleLabel:"<%=value%>",scaleFontFamily:"'Arial'",scaleFontSize:12,scaleFontStyle:"normal",scaleFontColor:"#666",scaleShowLabelBackdrop:!0,scaleBackdropColor:"rgba(255,255,255,0.75)",
scaleBackdropPaddingY:2,scaleBackdropPaddingX:2,angleShowLineOut:!0,angleLineColor:"rgba(0,0,0,.1)",angleLineWidth:1,pointLabelFontFamily:"'Arial'",pointLabelFontStyle:"normal",pointLabelFontSize:12,pointLabelFontColor:"#666",pointDot:!0,pointDotRadius:3,pointDotStrokeWidth:1,datasetStroke:!0,datasetStrokeWidth:2,datasetFill:!0,animation:!0,animationSteps:60,animationEasing:"easeOutQuart",onAnimationComplete:null};var b=c?y(r.Radar.defaults,c):r.Radar.defaults;return new H(a,b,s)};this.Pie=function(a,
c){r.Pie.defaults={segmentShowStroke:!0,segmentStrokeColor:"#fff",segmentStrokeWidth:2,animation:!0,animationSteps:100,animationEasing:"easeOutBounce",animateRotate:!0,animateScale:!1,onAnimationComplete:null};var b=c?y(r.Pie.defaults,c):r.Pie.defaults;return new I(a,b,s)};this.Doughnut=function(a,c){r.Doughnut.defaults={segmentShowStroke:!0,segmentStrokeColor:"#fff",segmentStrokeWidth:2,percentageInnerCutout:50,animation:!0,animationSteps:100,animationEasing:"easeOutBounce",animateRotate:!0,animateScale:!1,
onAnimationComplete:null};var b=c?y(r.Doughnut.defaults,c):r.Doughnut.defaults;return new J(a,b,s)};this.Line=function(a,c){r.Line.defaults={scaleOverlay:!1,scaleOverride:!1,scaleSteps:null,scaleStepWidth:null,scaleStartValue:null,scaleLineColor:"rgba(0,0,0,.1)",scaleLineWidth:1,scaleShowLabels:!0,scaleLabel:"<%=value%>",scaleFontFamily:"'Arial'",scaleFontSize:12,scaleFontStyle:"normal",scaleFontColor:"#666",scaleShowGridLines:!0,scaleGridLineColor:"rgba(0,0,0,.05)",scaleGridLineWidth:1,bezierCurve:!0,
pointDot:!0,pointDotRadius:4,pointDotStrokeWidth:2,datasetStroke:!0,datasetStrokeWidth:2,datasetFill:!0,animation:!0,animationSteps:60,animationEasing:"easeOutQuart",onAnimationComplete:null};var b=c?y(r.Line.defaults,c):r.Line.defaults;return new K(a,b,s)};this.Bar=function(a,c){r.Bar.defaults={scaleOverlay:!1,scaleOverride:!1,scaleSteps:null,scaleStepWidth:null,scaleStartValue:null,scaleLineColor:"rgba(0,0,0,.1)",scaleLineWidth:1,scaleShowLabels:!0,scaleLabel:"<%=value%>",scaleFontFamily:"'Arial'",
scaleFontSize:12,scaleFontStyle:"normal",scaleFontColor:"#666",scaleShowGridLines:!0,scaleGridLineColor:"rgba(0,0,0,.05)",scaleGridLineWidth:1,barShowStroke:!0,barStrokeWidth:2,barValueSpacing:5,barDatasetSpacing:1,animation:!0,animationSteps:60,animationEasing:"easeOutQuart",onAnimationComplete:null};var b=c?y(r.Bar.defaults,c):r.Bar.defaults;return new L(a,b,s)};var G=function(a,c,b){var e,h,f,d,g,k,j,l,m;g=Math.min.apply(Math,[q,u])/2;g-=Math.max.apply(Math,[0.5*c.scaleFontSize,0.5*c.scaleLineWidth]);
d=2*c.scaleFontSize;c.scaleShowLabelBackdrop&&(d+=2*c.scaleBackdropPaddingY,g-=1.5*c.scaleBackdropPaddingY);l=g;d=d?d:5;e=Number.MIN_VALUE;h=Number.MAX_VALUE;for(f=0;f<a.length;f++)a[f].value>e&&(e=a[f].value),a[f].value<h&&(h=a[f].value);f=Math.floor(l/(0.66*d));d=Math.floor(0.5*(l/d));m=c.scaleShowLabels?c.scaleLabel:null;c.scaleOverride?(j={steps:c.scaleSteps,stepValue:c.scaleStepWidth,graphMin:c.scaleStartValue,labels:[]},z(m,j.labels,j.steps,c.scaleStartValue,c.scaleStepWidth)):j=C(l,f,d,e,h,
m);k=g/j.steps;x(c,function(){for(var a=0;a<j.steps;a++)if(c.scaleShowLine&&(b.beginPath(),b.arc(q/2,u/2,k*(a+1),0,2*Math.PI,!0),b.strokeStyle=c.scaleLineColor,b.lineWidth=c.scaleLineWidth,b.stroke()),c.scaleShowLabels){b.textAlign="center";b.font=c.scaleFontStyle+" "+c.scaleFontSize+"px "+c.scaleFontFamily;var e=j.labels[a];if(c.scaleShowLabelBackdrop){var d=b.measureText(e).width;b.fillStyle=c.scaleBackdropColor;b.beginPath();b.rect(Math.round(q/2-d/2-c.scaleBackdropPaddingX),Math.round(u/2-k*(a+
1)-0.5*c.scaleFontSize-c.scaleBackdropPaddingY),Math.round(d+2*c.scaleBackdropPaddingX),Math.round(c.scaleFontSize+2*c.scaleBackdropPaddingY));b.fill()}b.textBaseline="middle";b.fillStyle=c.scaleFontColor;b.fillText(e,q/2,u/2-k*(a+1))}},function(e){var d=-Math.PI/2,g=2*Math.PI/a.length,f=1,h=1;c.animation&&(c.animateScale&&(f=e),c.animateRotate&&(h=e));for(e=0;e<a.length;e++)b.beginPath(),b.arc(q/2,u/2,f*v(a[e].value,j,k),d,d+h*g,!1),b.lineTo(q/2,u/2),b.closePath(),b.fillStyle=a[e].color,b.fill(),
c.segmentShowStroke&&(b.strokeStyle=c.segmentStrokeColor,b.lineWidth=c.segmentStrokeWidth,b.stroke()),d+=h*g},b)},H=function(a,c,b){var e,h,f,d,g,k,j,l,m;a.labels||(a.labels=[]);g=Math.min.apply(Math,[q,u])/2;d=2*c.scaleFontSize;for(e=l=0;e<a.labels.length;e++)b.font=c.pointLabelFontStyle+" "+c.pointLabelFontSize+"px "+c.pointLabelFontFamily,h=b.measureText(a.labels[e]).width,h>l&&(l=h);g-=Math.max.apply(Math,[l,1.5*(c.pointLabelFontSize/2)]);g-=c.pointLabelFontSize;l=g=A(g,null,0);d=d?d:5;e=Number.MIN_VALUE;
h=Number.MAX_VALUE;for(f=0;f<a.datasets.length;f++)for(m=0;m<a.datasets[f].data.length;m++)a.datasets[f].data[m]>e&&(e=a.datasets[f].data[m]),a.datasets[f].data[m]<h&&(h=a.datasets[f].data[m]);f=Math.floor(l/(0.66*d));d=Math.floor(0.5*(l/d));m=c.scaleShowLabels?c.scaleLabel:null;c.scaleOverride?(j={steps:c.scaleSteps,stepValue:c.scaleStepWidth,graphMin:c.scaleStartValue,labels:[]},z(m,j.labels,j.steps,c.scaleStartValue,c.scaleStepWidth)):j=C(l,f,d,e,h,m);k=g/j.steps;x(c,function(){var e=2*Math.PI/
a.datasets[0].data.length;b.save();b.translate(q/2,u/2);if(c.angleShowLineOut){b.strokeStyle=c.angleLineColor;b.lineWidth=c.angleLineWidth;for(var d=0;d<a.datasets[0].data.length;d++)b.rotate(e),b.beginPath(),b.moveTo(0,0),b.lineTo(0,-g),b.stroke()}for(d=0;d<j.steps;d++){b.beginPath();if(c.scaleShowLine){b.strokeStyle=c.scaleLineColor;b.lineWidth=c.scaleLineWidth;b.moveTo(0,-k*(d+1));for(var f=0;f<a.datasets[0].data.length;f++)b.rotate(e),b.lineTo(0,-k*(d+1));b.closePath();b.stroke()}c.scaleShowLabels&&
(b.textAlign="center",b.font=c.scaleFontStyle+" "+c.scaleFontSize+"px "+c.scaleFontFamily,b.textBaseline="middle",c.scaleShowLabelBackdrop&&(f=b.measureText(j.labels[d]).width,b.fillStyle=c.scaleBackdropColor,b.beginPath(),b.rect(Math.round(-f/2-c.scaleBackdropPaddingX),Math.round(-k*(d+1)-0.5*c.scaleFontSize-c.scaleBackdropPaddingY),Math.round(f+2*c.scaleBackdropPaddingX),Math.round(c.scaleFontSize+2*c.scaleBackdropPaddingY)),b.fill()),b.fillStyle=c.scaleFontColor,b.fillText(j.labels[d],0,-k*(d+
1)))}for(d=0;d<a.labels.length;d++){b.font=c.pointLabelFontStyle+" "+c.pointLabelFontSize+"px "+c.pointLabelFontFamily;b.fillStyle=c.pointLabelFontColor;var f=Math.sin(e*d)*(g+c.pointLabelFontSize),h=Math.cos(e*d)*(g+c.pointLabelFontSize);b.textAlign=e*d==Math.PI||0==e*d?"center":e*d>Math.PI?"right":"left";b.textBaseline="middle";b.fillText(a.labels[d],f,-h)}b.restore()},function(d){var e=2*Math.PI/a.datasets[0].data.length;b.save();b.translate(q/2,u/2);for(var g=0;g<a.datasets.length;g++){b.beginPath();
b.moveTo(0,d*-1*v(a.datasets[g].data[0],j,k));for(var f=1;f<a.datasets[g].data.length;f++)b.rotate(e),b.lineTo(0,d*-1*v(a.datasets[g].data[f],j,k));b.closePath();b.fillStyle=a.datasets[g].fillColor;b.strokeStyle=a.datasets[g].strokeColor;b.lineWidth=c.datasetStrokeWidth;b.fill();b.stroke();if(c.pointDot){b.fillStyle=a.datasets[g].pointColor;b.strokeStyle=a.datasets[g].pointStrokeColor;b.lineWidth=c.pointDotStrokeWidth;for(f=0;f<a.datasets[g].data.length;f++)b.rotate(e),b.beginPath(),b.arc(0,d*-1*
v(a.datasets[g].data[f],j,k),c.pointDotRadius,2*Math.PI,!1),b.fill(),b.stroke()}b.rotate(e)}b.restore()},b)},I=function(a,c,b){for(var e=0,h=Math.min.apply(Math,[u/2,q/2])-5,f=0;f<a.length;f++)e+=a[f].value;x(c,null,function(d){var g=-Math.PI/2,f=1,j=1;c.animation&&(c.animateScale&&(f=d),c.animateRotate&&(j=d));for(d=0;d<a.length;d++){var l=j*a[d].value/e*2*Math.PI;b.beginPath();b.arc(q/2,u/2,f*h,g,g+l);b.lineTo(q/2,u/2);b.closePath();b.fillStyle=a[d].color;b.fill();c.segmentShowStroke&&(b.lineWidth=
c.segmentStrokeWidth,b.strokeStyle=c.segmentStrokeColor,b.stroke());g+=l}},b)},J=function(a,c,b){for(var e=0,h=Math.min.apply(Math,[u/2,q/2])-5,f=h*(c.percentageInnerCutout/100),d=0;d<a.length;d++)e+=a[d].value;x(c,null,function(d){var k=-Math.PI/2,j=1,l=1;c.animation&&(c.animateScale&&(j=d),c.animateRotate&&(l=d));for(d=0;d<a.length;d++){var m=l*a[d].value/e*2*Math.PI;b.beginPath();b.arc(q/2,u/2,j*h,k,k+m,!1);b.arc(q/2,u/2,j*f,k+m,k,!0);b.closePath();b.fillStyle=a[d].color;b.fill();c.segmentShowStroke&&
(b.lineWidth=c.segmentStrokeWidth,b.strokeStyle=c.segmentStrokeColor,b.stroke());k+=m}},b)},K=function(a,c,b){var e,h,f,d,g,k,j,l,m,t,r,n,p,s=0;g=u;b.font=c.scaleFontStyle+" "+c.scaleFontSize+"px "+c.scaleFontFamily;t=1;for(d=0;d<a.labels.length;d++)e=b.measureText(a.labels[d]).width,t=e>t?e:t;q/a.labels.length<t?(s=45,q/a.labels.length<Math.cos(s)*t?(s=90,g-=t):g-=Math.sin(s)*t):g-=c.scaleFontSize;d=c.scaleFontSize;g=g-5-d;e=Number.MIN_VALUE;h=Number.MAX_VALUE;for(f=0;f<a.datasets.length;f++)for(l=
0;l<a.datasets[f].data.length;l++)a.datasets[f].data[l]>e&&(e=a.datasets[f].data[l]),a.datasets[f].data[l]<h&&(h=a.datasets[f].data[l]);f=Math.floor(g/(0.66*d));d=Math.floor(0.5*(g/d));l=c.scaleShowLabels?c.scaleLabel:"";c.scaleOverride?(j={steps:c.scaleSteps,stepValue:c.scaleStepWidth,graphMin:c.scaleStartValue,labels:[]},z(l,j.labels,j.steps,c.scaleStartValue,c.scaleStepWidth)):j=C(g,f,d,e,h,l);k=Math.floor(g/j.steps);d=1;if(c.scaleShowLabels){b.font=c.scaleFontStyle+" "+c.scaleFontSize+"px "+c.scaleFontFamily;
for(e=0;e<j.labels.length;e++)h=b.measureText(j.labels[e]).width,d=h>d?h:d;d+=10}r=q-d-t;m=Math.floor(r/(a.labels.length-1));n=q-t/2-r;p=g+c.scaleFontSize/2;x(c,function(){b.lineWidth=c.scaleLineWidth;b.strokeStyle=c.scaleLineColor;b.beginPath();b.moveTo(q-t/2+5,p);b.lineTo(q-t/2-r-5,p);b.stroke();0<s?(b.save(),b.textAlign="right"):b.textAlign="center";b.fillStyle=c.scaleFontColor;for(var d=0;d<a.labels.length;d++)b.save(),0<s?(b.translate(n+d*m,p+c.scaleFontSize),b.rotate(-(s*(Math.PI/180))),b.fillText(a.labels[d],
0,0),b.restore()):b.fillText(a.labels[d],n+d*m,p+c.scaleFontSize+3),b.beginPath(),b.moveTo(n+d*m,p+3),c.scaleShowGridLines&&0<d?(b.lineWidth=c.scaleGridLineWidth,b.strokeStyle=c.scaleGridLineColor,b.lineTo(n+d*m,5)):b.lineTo(n+d*m,p+3),b.stroke();b.lineWidth=c.scaleLineWidth;b.strokeStyle=c.scaleLineColor;b.beginPath();b.moveTo(n,p+5);b.lineTo(n,5);b.stroke();b.textAlign="right";b.textBaseline="middle";for(d=0;d<j.steps;d++)b.beginPath(),b.moveTo(n-3,p-(d+1)*k),c.scaleShowGridLines?(b.lineWidth=c.scaleGridLineWidth,
b.strokeStyle=c.scaleGridLineColor,b.lineTo(n+r+5,p-(d+1)*k)):b.lineTo(n-0.5,p-(d+1)*k),b.stroke(),c.scaleShowLabels&&b.fillText(j.labels[d],n-8,p-(d+1)*k)},function(d){function e(b,c){return p-d*v(a.datasets[b].data[c],j,k)}for(var f=0;f<a.datasets.length;f++){b.strokeStyle=a.datasets[f].strokeColor;b.lineWidth=c.datasetStrokeWidth;b.beginPath();b.moveTo(n,p-d*v(a.datasets[f].data[0],j,k));for(var g=1;g<a.datasets[f].data.length;g++)c.bezierCurve?b.bezierCurveTo(n+m*(g-0.5),e(f,g-1),n+m*(g-0.5),
e(f,g),n+m*g,e(f,g)):b.lineTo(n+m*g,e(f,g));b.stroke();c.datasetFill?(b.lineTo(n+m*(a.datasets[f].data.length-1),p),b.lineTo(n,p),b.closePath(),b.fillStyle=a.datasets[f].fillColor,b.fill()):b.closePath();if(c.pointDot){b.fillStyle=a.datasets[f].pointColor;b.strokeStyle=a.datasets[f].pointStrokeColor;b.lineWidth=c.pointDotStrokeWidth;for(g=0;g<a.datasets[f].data.length;g++)b.beginPath(),b.arc(n+m*g,p-d*v(a.datasets[f].data[g],j,k),c.pointDotRadius,0,2*Math.PI,!0),b.fill(),b.stroke()}}},b)},L=function(a,
c,b){var e,h,f,d,g,k,j,l,m,t,r,n,p,s,w=0;g=u;b.font=c.scaleFontStyle+" "+c.scaleFontSize+"px "+c.scaleFontFamily;t=1;for(d=0;d<a.labels.length;d++)e=b.measureText(a.labels[d]).width,t=e>t?e:t;q/a.labels.length<t?(w=45,q/a.labels.length<Math.cos(w)*t?(w=90,g-=t):g-=Math.sin(w)*t):g-=c.scaleFontSize;d=c.scaleFontSize;g=g-5-d;e=Number.MIN_VALUE;h=Number.MAX_VALUE;for(f=0;f<a.datasets.length;f++)for(l=0;l<a.datasets[f].data.length;l++)a.datasets[f].data[l]>e&&(e=a.datasets[f].data[l]),a.datasets[f].data[l]<
h&&(h=a.datasets[f].data[l]);f=Math.floor(g/(0.66*d));d=Math.floor(0.5*(g/d));l=c.scaleShowLabels?c.scaleLabel:"";c.scaleOverride?(j={steps:c.scaleSteps,stepValue:c.scaleStepWidth,graphMin:c.scaleStartValue,labels:[]},z(l,j.labels,j.steps,c.scaleStartValue,c.scaleStepWidth)):j=C(g,f,d,e,h,l);k=Math.floor(g/j.steps);d=1;if(c.scaleShowLabels){b.font=c.scaleFontStyle+" "+c.scaleFontSize+"px "+c.scaleFontFamily;for(e=0;e<j.labels.length;e++)h=b.measureText(j.labels[e]).width,d=h>d?h:d;d+=10}r=q-d-t;m=
Math.floor(r/a.labels.length);s=(m-2*c.scaleGridLineWidth-2*c.barValueSpacing-(c.barDatasetSpacing*a.datasets.length-1)-(c.barStrokeWidth/2*a.datasets.length-1))/a.datasets.length;n=q-t/2-r;p=g+c.scaleFontSize/2;x(c,function(){b.lineWidth=c.scaleLineWidth;b.strokeStyle=c.scaleLineColor;b.beginPath();b.moveTo(q-t/2+5,p);b.lineTo(q-t/2-r-5,p);b.stroke();0<w?(b.save(),b.textAlign="right"):b.textAlign="center";b.fillStyle=c.scaleFontColor;for(var d=0;d<a.labels.length;d++)b.save(),0<w?(b.translate(n+
d*m,p+c.scaleFontSize),b.rotate(-(w*(Math.PI/180))),b.fillText(a.labels[d],0,0),b.restore()):b.fillText(a.labels[d],n+d*m+m/2,p+c.scaleFontSize+3),b.beginPath(),b.moveTo(n+(d+1)*m,p+3),b.lineWidth=c.scaleGridLineWidth,b.strokeStyle=c.scaleGridLineColor,b.lineTo(n+(d+1)*m,5),b.stroke();b.lineWidth=c.scaleLineWidth;b.strokeStyle=c.scaleLineColor;b.beginPath();b.moveTo(n,p+5);b.lineTo(n,5);b.stroke();b.textAlign="right";b.textBaseline="middle";for(d=0;d<j.steps;d++)b.beginPath(),b.moveTo(n-3,p-(d+1)*
k),c.scaleShowGridLines?(b.lineWidth=c.scaleGridLineWidth,b.strokeStyle=c.scaleGridLineColor,b.lineTo(n+r+5,p-(d+1)*k)):b.lineTo(n-0.5,p-(d+1)*k),b.stroke(),c.scaleShowLabels&&b.fillText(j.labels[d],n-8,p-(d+1)*k)},function(d){b.lineWidth=c.barStrokeWidth;for(var e=0;e<a.datasets.length;e++){b.fillStyle=a.datasets[e].fillColor;b.strokeStyle=a.datasets[e].strokeColor;for(var f=0;f<a.datasets[e].data.length;f++){var g=n+c.barValueSpacing+m*f+s*e+c.barDatasetSpacing*e+c.barStrokeWidth*e;b.beginPath();
b.moveTo(g,p);b.lineTo(g,p-d*v(a.datasets[e].data[f],j,k)+c.barStrokeWidth/2);b.lineTo(g+s,p-d*v(a.datasets[e].data[f],j,k)+c.barStrokeWidth/2);b.lineTo(g+s,p);c.barShowStroke&&b.stroke();b.closePath();b.fill()}}},b)},D=window.requestAnimationFrame||window.webkitRequestAnimationFrame||window.mozRequestAnimationFrame||window.oRequestAnimationFrame||window.msRequestAnimationFrame||function(a){window.setTimeout(a,1E3/60)},F={}};
/* ===================================================
 * bootstrap-transition.js v2.3.2
 * http://twitter.github.com/bootstrap/javascript.html#transitions
 * ===================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================== */


!function ($) {

  "use strict"; // jshint ;_;


  /* CSS TRANSITION SUPPORT (http://www.modernizr.com/)
   * ======================================================= */

  $(function () {

    $.support.transition = (function () {

      var transitionEnd = (function () {

        var el = document.createElement('bootstrap')
          , transEndEventNames = {
               'WebkitTransition' : 'webkitTransitionEnd'
            ,  'MozTransition'    : 'transitionend'
            ,  'OTransition'      : 'oTransitionEnd otransitionend'
            ,  'transition'       : 'transitionend'
            }
          , name

        for (name in transEndEventNames){
          if (el.style[name] !== undefined) {
            return transEndEventNames[name]
          }
        }

      }())

      return transitionEnd && {
        end: transitionEnd
      }

    })()

  })

}(window.jQuery);/* ==========================================================
 * bootstrap-alert.js v2.3.2
 * http://twitter.github.com/bootstrap/javascript.html#alerts
 * ==========================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================== */


!function ($) {

  "use strict"; // jshint ;_;


 /* ALERT CLASS DEFINITION
  * ====================== */

  var dismiss = '[data-dismiss="alert"]'
    , Alert = function (el) {
        $(el).on('click', dismiss, this.close)
      }

  Alert.prototype.close = function (e) {
    var $this = $(this)
      , selector = $this.attr('data-target')
      , $parent

    if (!selector) {
      selector = $this.attr('href')
      selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7
    }

    $parent = $(selector)

    e && e.preventDefault()

    $parent.length || ($parent = $this.hasClass('alert') ? $this : $this.parent())

    $parent.trigger(e = $.Event('close'))

    if (e.isDefaultPrevented()) return

    $parent.removeClass('in')

    function removeElement() {
      $parent
        .trigger('closed')
        .remove()
    }

    $.support.transition && $parent.hasClass('fade') ?
      $parent.on($.support.transition.end, removeElement) :
      removeElement()
  }


 /* ALERT PLUGIN DEFINITION
  * ======================= */

  var old = $.fn.alert

  $.fn.alert = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('alert')
      if (!data) $this.data('alert', (data = new Alert(this)))
      if (typeof option == 'string') data[option].call($this)
    })
  }

  $.fn.alert.Constructor = Alert


 /* ALERT NO CONFLICT
  * ================= */

  $.fn.alert.noConflict = function () {
    $.fn.alert = old
    return this
  }


 /* ALERT DATA-API
  * ============== */

  $(document).on('click.alert.data-api', dismiss, Alert.prototype.close)

}(window.jQuery);/* ============================================================
 * bootstrap-button.js v2.3.2
 * http://twitter.github.com/bootstrap/javascript.html#buttons
 * ============================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */


!function ($) {

  "use strict"; // jshint ;_;


 /* BUTTON PUBLIC CLASS DEFINITION
  * ============================== */

  var Button = function (element, options) {
    this.$element = $(element)
    this.options = $.extend({}, $.fn.button.defaults, options)
  }

  Button.prototype.setState = function (state) {
    var d = 'disabled'
      , $el = this.$element
      , data = $el.data()
      , val = $el.is('input') ? 'val' : 'html'

    state = state + 'Text'
    data.resetText || $el.data('resetText', $el[val]())

    $el[val](data[state] || this.options[state])

    // push to event loop to allow forms to submit
    setTimeout(function () {
      state == 'loadingText' ?
        $el.addClass(d).attr(d, d) :
        $el.removeClass(d).removeAttr(d)
    }, 0)
  }

  Button.prototype.toggle = function () {
    var $parent = this.$element.closest('[data-toggle="buttons-radio"]')

    $parent && $parent
      .find('.active')
      .removeClass('active')

    this.$element.toggleClass('active')
  }


 /* BUTTON PLUGIN DEFINITION
  * ======================== */

  var old = $.fn.button

  $.fn.button = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('button')
        , options = typeof option == 'object' && option
      if (!data) $this.data('button', (data = new Button(this, options)))
      if (option == 'toggle') data.toggle()
      else if (option) data.setState(option)
    })
  }

  $.fn.button.defaults = {
    loadingText: 'loading...'
  }

  $.fn.button.Constructor = Button


 /* BUTTON NO CONFLICT
  * ================== */

  $.fn.button.noConflict = function () {
    $.fn.button = old
    return this
  }


 /* BUTTON DATA-API
  * =============== */

  $(document).on('click.button.data-api', '[data-toggle^=button]', function (e) {
    var $btn = $(e.target)
    if (!$btn.hasClass('btn')) $btn = $btn.closest('.btn')
    $btn.button('toggle')
  })

}(window.jQuery);/* ==========================================================
 * bootstrap-carousel.js v2.3.2
 * http://twitter.github.com/bootstrap/javascript.html#carousel
 * ==========================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================== */


!function ($) {

  "use strict"; // jshint ;_;


 /* CAROUSEL CLASS DEFINITION
  * ========================= */

  var Carousel = function (element, options) {
    this.$element = $(element)
    this.$indicators = this.$element.find('.carousel-indicators')
    this.options = options
    this.options.pause == 'hover' && this.$element
      .on('mouseenter', $.proxy(this.pause, this))
      .on('mouseleave', $.proxy(this.cycle, this))
  }

  Carousel.prototype = {

    cycle: function (e) {
      if (!e) this.paused = false
      if (this.interval) clearInterval(this.interval);
      this.options.interval
        && !this.paused
        && (this.interval = setInterval($.proxy(this.next, this), this.options.interval))
      return this
    }

  , getActiveIndex: function () {
      this.$active = this.$element.find('.item.active')
      this.$items = this.$active.parent().children()
      return this.$items.index(this.$active)
    }

  , to: function (pos) {
      var activeIndex = this.getActiveIndex()
        , that = this

      if (pos > (this.$items.length - 1) || pos < 0) return

      if (this.sliding) {
        return this.$element.one('slid', function () {
          that.to(pos)
        })
      }

      if (activeIndex == pos) {
        return this.pause().cycle()
      }

      return this.slide(pos > activeIndex ? 'next' : 'prev', $(this.$items[pos]))
    }

  , pause: function (e) {
      if (!e) this.paused = true
      if (this.$element.find('.next, .prev').length && $.support.transition.end) {
        this.$element.trigger($.support.transition.end)
        this.cycle(true)
      }
      clearInterval(this.interval)
      this.interval = null
      return this
    }

  , next: function () {
      if (this.sliding) return
      return this.slide('next')
    }

  , prev: function () {
      if (this.sliding) return
      return this.slide('prev')
    }

  , slide: function (type, next) {
      var $active = this.$element.find('.item.active')
        , $next = next || $active[type]()
        , isCycling = this.interval
        , direction = type == 'next' ? 'left' : 'right'
        , fallback  = type == 'next' ? 'first' : 'last'
        , that = this
        , e

      this.sliding = true

      isCycling && this.pause()

      $next = $next.length ? $next : this.$element.find('.item')[fallback]()

      e = $.Event('slide', {
        relatedTarget: $next[0]
      , direction: direction
      })

      if ($next.hasClass('active')) return

      if (this.$indicators.length) {
        this.$indicators.find('.active').removeClass('active')
        this.$element.one('slid', function () {
          var $nextIndicator = $(that.$indicators.children()[that.getActiveIndex()])
          $nextIndicator && $nextIndicator.addClass('active')
        })
      }

      if ($.support.transition && this.$element.hasClass('slide')) {
        this.$element.trigger(e)
        if (e.isDefaultPrevented()) return
        $next.addClass(type)
        $next[0].offsetWidth // force reflow
        $active.addClass(direction)
        $next.addClass(direction)
        this.$element.one($.support.transition.end, function () {
          $next.removeClass([type, direction].join(' ')).addClass('active')
          $active.removeClass(['active', direction].join(' '))
          that.sliding = false
          setTimeout(function () { that.$element.trigger('slid') }, 0)
        })
      } else {
        this.$element.trigger(e)
        if (e.isDefaultPrevented()) return
        $active.removeClass('active')
        $next.addClass('active')
        this.sliding = false
        this.$element.trigger('slid')
      }

      isCycling && this.cycle()

      return this
    }

  }


 /* CAROUSEL PLUGIN DEFINITION
  * ========================== */

  var old = $.fn.carousel

  $.fn.carousel = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('carousel')
        , options = $.extend({}, $.fn.carousel.defaults, typeof option == 'object' && option)
        , action = typeof option == 'string' ? option : options.slide
      if (!data) $this.data('carousel', (data = new Carousel(this, options)))
      if (typeof option == 'number') data.to(option)
      else if (action) data[action]()
      else if (options.interval) data.pause().cycle()
    })
  }

  $.fn.carousel.defaults = {
    interval: 5000
  , pause: 'hover'
  }

  $.fn.carousel.Constructor = Carousel


 /* CAROUSEL NO CONFLICT
  * ==================== */

  $.fn.carousel.noConflict = function () {
    $.fn.carousel = old
    return this
  }

 /* CAROUSEL DATA-API
  * ================= */

  $(document).on('click.carousel.data-api', '[data-slide], [data-slide-to]', function (e) {
    var $this = $(this), href
      , $target = $($this.attr('data-target') || (href = $this.attr('href')) && href.replace(/.*(?=#[^\s]+$)/, '')) //strip for ie7
      , options = $.extend({}, $target.data(), $this.data())
      , slideIndex

    $target.carousel(options)

    if (slideIndex = $this.attr('data-slide-to')) {
      $target.data('carousel').pause().to(slideIndex).cycle()
    }

    e.preventDefault()
  })

}(window.jQuery);/* =============================================================
 * bootstrap-collapse.js v2.3.2
 * http://twitter.github.com/bootstrap/javascript.html#collapse
 * =============================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */


!function ($) {

  "use strict"; // jshint ;_;


 /* COLLAPSE PUBLIC CLASS DEFINITION
  * ================================ */

  var Collapse = function (element, options) {
    this.$element = $(element)
    this.options = $.extend({}, $.fn.collapse.defaults, options)

    if (this.options.parent) {
      this.$parent = $(this.options.parent)
    }

    this.options.toggle && this.toggle()
  }

  Collapse.prototype = {

    constructor: Collapse

  , dimension: function () {
      var hasWidth = this.$element.hasClass('width')
      return hasWidth ? 'width' : 'height'
    }

  , show: function () {
      var dimension
        , scroll
        , actives
        , hasData

      if (this.transitioning || this.$element.hasClass('in')) return

      dimension = this.dimension()
      scroll = $.camelCase(['scroll', dimension].join('-'))
      actives = this.$parent && this.$parent.find('> .accordion-group > .in')

      if (actives && actives.length) {
        hasData = actives.data('collapse')
        if (hasData && hasData.transitioning) return
        actives.collapse('hide')
        hasData || actives.data('collapse', null)
      }

      this.$element[dimension](0)
      this.transition('addClass', $.Event('show'), 'shown')
      $.support.transition && this.$element[dimension](this.$element[0][scroll])
    }

  , hide: function () {
      var dimension
      if (this.transitioning || !this.$element.hasClass('in')) return
      dimension = this.dimension()
      this.reset(this.$element[dimension]())
      this.transition('removeClass', $.Event('hide'), 'hidden')
      this.$element[dimension](0)
    }

  , reset: function (size) {
      var dimension = this.dimension()

      this.$element
        .removeClass('collapse')
        [dimension](size || 'auto')
        [0].offsetWidth

      this.$element[size !== null ? 'addClass' : 'removeClass']('collapse')

      return this
    }

  , transition: function (method, startEvent, completeEvent) {
      var that = this
        , complete = function () {
            if (startEvent.type == 'show') that.reset()
            that.transitioning = 0
            that.$element.trigger(completeEvent)
          }

      this.$element.trigger(startEvent)

      if (startEvent.isDefaultPrevented()) return

      this.transitioning = 1

      this.$element[method]('in')

      $.support.transition && this.$element.hasClass('collapse') ?
        this.$element.one($.support.transition.end, complete) :
        complete()
    }

  , toggle: function () {
      this[this.$element.hasClass('in') ? 'hide' : 'show']()
    }

  }


 /* COLLAPSE PLUGIN DEFINITION
  * ========================== */

  var old = $.fn.collapse

  $.fn.collapse = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('collapse')
        , options = $.extend({}, $.fn.collapse.defaults, $this.data(), typeof option == 'object' && option)
      if (!data) $this.data('collapse', (data = new Collapse(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

  $.fn.collapse.defaults = {
    toggle: true
  }

  $.fn.collapse.Constructor = Collapse


 /* COLLAPSE NO CONFLICT
  * ==================== */

  $.fn.collapse.noConflict = function () {
    $.fn.collapse = old
    return this
  }


 /* COLLAPSE DATA-API
  * ================= */

  $(document).on('click.collapse.data-api', '[data-toggle=collapse]', function (e) {
    var $this = $(this), href
      , target = $this.attr('data-target')
        || e.preventDefault()
        || (href = $this.attr('href')) && href.replace(/.*(?=#[^\s]+$)/, '') //strip for ie7
      , option = $(target).data('collapse') ? 'toggle' : $this.data()
    $this[$(target).hasClass('in') ? 'addClass' : 'removeClass']('collapsed')
    $(target).collapse(option)
  })

}(window.jQuery);/* ============================================================
 * bootstrap-dropdown.js v2.3.2
 * http://twitter.github.com/bootstrap/javascript.html#dropdowns
 * ============================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */


!function ($) {

  "use strict"; // jshint ;_;


 /* DROPDOWN CLASS DEFINITION
  * ========================= */

  var toggle = '[data-toggle=dropdown]'
    , Dropdown = function (element) {
        var $el = $(element).on('click.dropdown.data-api', this.toggle)
        $('html').on('click.dropdown.data-api', function () {
          $el.parent().removeClass('open')
        })
      }

  Dropdown.prototype = {

    constructor: Dropdown

  , toggle: function (e) {
      var $this = $(this)
        , $parent
        , isActive

      if ($this.is('.disabled, :disabled')) return

      $parent = getParent($this)

      isActive = $parent.hasClass('open')

      clearMenus()

      if (!isActive) {
        if ('disable-ontouchstart' in document.documentElement) {
          // if mobile we we use a backdrop because click events don't delegate
          $('<div class="dropdown-backdrop"/>').insertBefore($(this)).on('click', clearMenus)
        }
        $parent.toggleClass('open')
      }

      $this.focus()

      return false
    }

  , keydown: function (e) {
      var $this
        , $items
        , $active
        , $parent
        , isActive
        , index

      if (!/(38|40|27)/.test(e.keyCode)) return

      $this = $(this)

      e.preventDefault()
      e.stopPropagation()

      if ($this.is('.disabled, :disabled')) return

      $parent = getParent($this)

      isActive = $parent.hasClass('open')

      if (!isActive || (isActive && e.keyCode == 27)) {
        if (e.which == 27) $parent.find(toggle).focus()
        return $this.click()
      }

      $items = $('[role=menu] li:not(.divider):visible a', $parent)

      if (!$items.length) return

      index = $items.index($items.filter(':focus'))

      if (e.keyCode == 38 && index > 0) index--                                        // up
      if (e.keyCode == 40 && index < $items.length - 1) index++                        // down
      if (!~index) index = 0

      $items
        .eq(index)
        .focus()
    }

  }

  function clearMenus() {
    $('.dropdown-backdrop').remove()
    $(toggle).each(function () {
      getParent($(this)).removeClass('open')
    })
  }

  function getParent($this) {
    var selector = $this.attr('data-target')
      , $parent

    if (!selector) {
      selector = $this.attr('href')
      selector = selector && /#/.test(selector) && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7
    }

    $parent = selector && $(selector)

    if (!$parent || !$parent.length) $parent = $this.parent()

    return $parent
  }


  /* DROPDOWN PLUGIN DEFINITION
   * ========================== */

  var old = $.fn.dropdown

  $.fn.dropdown = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('dropdown')
      if (!data) $this.data('dropdown', (data = new Dropdown(this)))
      if (typeof option == 'string') data[option].call($this)
    })
  }

  $.fn.dropdown.Constructor = Dropdown


 /* DROPDOWN NO CONFLICT
  * ==================== */

  $.fn.dropdown.noConflict = function () {
    $.fn.dropdown = old
    return this
  }


  /* APPLY TO STANDARD DROPDOWN ELEMENTS
   * =================================== */

  $(document)
    .on('click.dropdown.data-api', clearMenus)
    .on('click.dropdown.data-api', '.dropdown form', function (e) { e.stopPropagation() })
    .on('click.dropdown.data-api'  , toggle, Dropdown.prototype.toggle)
    .on('keydown.dropdown.data-api', toggle + ', [role=menu]' , Dropdown.prototype.keydown)

}(window.jQuery);
/* =========================================================
 * bootstrap-modal.js v2.3.2
 * http://twitter.github.com/bootstrap/javascript.html#modals
 * =========================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================= */


!function ($) {

  "use strict"; // jshint ;_;


 /* MODAL CLASS DEFINITION
  * ====================== */

  var Modal = function (element, options) {
    this.options = options
    this.$element = $(element)
      .delegate('[data-dismiss="modal"]', 'click.dismiss.modal', $.proxy(this.hide, this))
    this.options.remote && this.$element.find('.modal-body').load(this.options.remote)
  }

  Modal.prototype = {

      constructor: Modal

    , toggle: function () {
        return this[!this.isShown ? 'show' : 'hide']()
      }

    , show: function () {
        var that = this
          , e = $.Event('show')

        this.$element.trigger(e)

        if (this.isShown || e.isDefaultPrevented()) return

        this.isShown = true

        this.escape()

        this.backdrop(function () {
          var transition = $.support.transition && that.$element.hasClass('fade')

          if (!that.$element.parent().length) {
            that.$element.appendTo(document.body) //don't move modals dom position
          }

          that.$element.show()

          if (transition) {
            that.$element[0].offsetWidth // force reflow
          }

          that.$element
            .addClass('in')
            .attr('aria-hidden', false)

          that.enforceFocus()

          transition ?
            that.$element.one($.support.transition.end, function () { that.$element.focus().trigger('shown') }) :
            that.$element.focus().trigger('shown')

        })
      }

    , hide: function (e) {
        e && e.preventDefault()

        var that = this

        e = $.Event('hide')

        this.$element.trigger(e)

        if (!this.isShown || e.isDefaultPrevented()) return

        this.isShown = false

        this.escape()

        $(document).off('focusin.modal')

        this.$element
          .removeClass('in')
          .attr('aria-hidden', true)

        $.support.transition && this.$element.hasClass('fade') ?
          this.hideWithTransition() :
          this.hideModal()
      }

    , enforceFocus: function () {
        var that = this
        $(document).on('focusin.modal', function (e) {
          if (that.$element[0] !== e.target && !that.$element.has(e.target).length) {
            that.$element.focus()
          }
        })
      }

    , escape: function () {
        var that = this
        if (this.isShown && this.options.keyboard) {
          this.$element.on('keyup.dismiss.modal', function ( e ) {
            e.which == 27 && that.hide()
          })
        } else if (!this.isShown) {
          this.$element.off('keyup.dismiss.modal')
        }
      }

    , hideWithTransition: function () {
        var that = this
          , timeout = setTimeout(function () {
              that.$element.off($.support.transition.end)
              that.hideModal()
            }, 500)

        this.$element.one($.support.transition.end, function () {
          clearTimeout(timeout)
          that.hideModal()
        })
      }

    , hideModal: function () {
        var that = this
        this.$element.hide()
        this.backdrop(function () {
          that.removeBackdrop()
          that.$element.trigger('hidden')
        })
      }

    , removeBackdrop: function () {
        this.$backdrop && this.$backdrop.remove()
        this.$backdrop = null
      }

    , backdrop: function (callback) {
        var that = this
          , animate = this.$element.hasClass('fade') ? 'fade' : ''

        if (this.isShown && this.options.backdrop) {
          var doAnimate = $.support.transition && animate

          this.$backdrop = $('<div class="modal-backdrop ' + animate + '" />')
            .appendTo(document.body)

          this.$backdrop.click(
            this.options.backdrop == 'static' ?
              $.proxy(this.$element[0].focus, this.$element[0])
            : $.proxy(this.hide, this)
          )

          if (doAnimate) this.$backdrop[0].offsetWidth // force reflow

          this.$backdrop.addClass('in')

          if (!callback) return

          doAnimate ?
            this.$backdrop.one($.support.transition.end, callback) :
            callback()

        } else if (!this.isShown && this.$backdrop) {
          this.$backdrop.removeClass('in')

          $.support.transition && this.$element.hasClass('fade')?
            this.$backdrop.one($.support.transition.end, callback) :
            callback()

        } else if (callback) {
          callback()
        }
      }
  }


 /* MODAL PLUGIN DEFINITION
  * ======================= */

  var old = $.fn.modal

  $.fn.modal = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('modal')
        , options = $.extend({}, $.fn.modal.defaults, $this.data(), typeof option == 'object' && option)
      if (!data) $this.data('modal', (data = new Modal(this, options)))
      if (typeof option == 'string') data[option]()
      else if (options.show) data.show()
    })
  }

  $.fn.modal.defaults = {
      backdrop: true
    , keyboard: true
    , show: true
  }

  $.fn.modal.Constructor = Modal


 /* MODAL NO CONFLICT
  * ================= */

  $.fn.modal.noConflict = function () {
    $.fn.modal = old
    return this
  }


 /* MODAL DATA-API
  * ============== */

  $(document).on('click.modal.data-api', '[data-toggle="modal"]', function (e) {
    var $this = $(this)
      , href = $this.attr('href')
      , $target = $($this.attr('data-target') || (href && href.replace(/.*(?=#[^\s]+$)/, ''))) //strip for ie7
      , option = $target.data('modal') ? 'toggle' : $.extend({ remote:!/#/.test(href) && href }, $target.data(), $this.data())

    e.preventDefault()

    $target
      .modal(option)
      .one('hide', function () {
        $this.focus()
      })
  })

}(window.jQuery);
/* ===========================================================
 * bootstrap-tooltip.js v2.3.2
 * http://twitter.github.com/bootstrap/javascript.html#tooltips
 * Inspired by the original jQuery.tipsy by Jason Frame
 * ===========================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================== */


!function ($) {

  "use strict"; // jshint ;_;


 /* TOOLTIP PUBLIC CLASS DEFINITION
  * =============================== */

  var Tooltip = function (element, options) {
    this.init('tooltip', element, options)
  }

  Tooltip.prototype = {

    constructor: Tooltip

  , init: function (type, element, options) {
      var eventIn
        , eventOut
        , triggers
        , trigger
        , i

      this.type = type
      this.$element = $(element)
      this.options = this.getOptions(options)
      this.enabled = true

      triggers = this.options.trigger.split(' ')

      for (i = triggers.length; i--;) {
        trigger = triggers[i]
        if (trigger == 'click') {
          this.$element.on('click.' + this.type, this.options.selector, $.proxy(this.toggle, this))
        } else if (trigger != 'manual') {
          eventIn = trigger == 'hover' ? 'mouseenter' : 'focus'
          eventOut = trigger == 'hover' ? 'mouseleave' : 'blur'
          this.$element.on(eventIn + '.' + this.type, this.options.selector, $.proxy(this.enter, this))
          this.$element.on(eventOut + '.' + this.type, this.options.selector, $.proxy(this.leave, this))
        }
      }

      this.options.selector ?
        (this._options = $.extend({}, this.options, { trigger: 'manual', selector: '' })) :
        this.fixTitle()
    }

  , getOptions: function (options) {
      options = $.extend({}, $.fn[this.type].defaults, this.$element.data(), options)

      if (options.delay && typeof options.delay == 'number') {
        options.delay = {
          show: options.delay
        , hide: options.delay
        }
      }

      return options
    }

  , enter: function (e) {
      var defaults = $.fn[this.type].defaults
        , options = {}
        , self

      this._options && $.each(this._options, function (key, value) {
        if (defaults[key] != value) options[key] = value
      }, this)

      self = $(e.currentTarget)[this.type](options).data(this.type)

      if (!self.options.delay || !self.options.delay.show) return self.show()

      clearTimeout(this.timeout)
      self.hoverState = 'in'
      this.timeout = setTimeout(function() {
        if (self.hoverState == 'in') self.show()
      }, self.options.delay.show)
    }

  , leave: function (e) {
      var self = $(e.currentTarget)[this.type](this._options).data(this.type)

      if (this.timeout) clearTimeout(this.timeout)
      if (!self.options.delay || !self.options.delay.hide) return self.hide()

      self.hoverState = 'out'
      this.timeout = setTimeout(function() {
        if (self.hoverState == 'out') self.hide()
      }, self.options.delay.hide)
    }

  , show: function () {
      var $tip
        , pos
        , actualWidth
        , actualHeight
        , placement
        , tp
        , e = $.Event('show')

      if (this.hasContent() && this.enabled) {
        this.$element.trigger(e)
        if (e.isDefaultPrevented()) return
        $tip = this.tip()
        this.setContent()

        if (this.options.animation) {
          $tip.addClass('fade')
        }

        placement = typeof this.options.placement == 'function' ?
          this.options.placement.call(this, $tip[0], this.$element[0]) :
          this.options.placement

        $tip
          .detach()
          .css({ top: 0, left: 0, display: 'block' })

        this.options.container ? $tip.appendTo(this.options.container) : $tip.insertAfter(this.$element)

        pos = this.getPosition()

        actualWidth = $tip[0].offsetWidth
        actualHeight = $tip[0].offsetHeight

        switch (placement) {
          case 'bottom':
            tp = {top: pos.top + pos.height, left: pos.left + pos.width / 2 - actualWidth / 2}
            break
          case 'top':
            tp = {top: pos.top - actualHeight, left: pos.left + pos.width / 2 - actualWidth / 2}
            break
          case 'left':
            tp = {top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left - actualWidth}
            break
          case 'right':
            tp = {top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left + pos.width}
            break
        }

        this.applyPlacement(tp, placement)
        this.$element.trigger('shown')
      }
    }

  , applyPlacement: function(offset, placement){
      var $tip = this.tip()
        , width = $tip[0].offsetWidth
        , height = $tip[0].offsetHeight
        , actualWidth
        , actualHeight
        , delta
        , replace

      $tip
        .offset(offset)
        .addClass(placement)
        .addClass('in')

      actualWidth = $tip[0].offsetWidth
      actualHeight = $tip[0].offsetHeight

      if (placement == 'top' && actualHeight != height) {
        offset.top = offset.top + height - actualHeight
        replace = true
      }

      if (placement == 'bottom' || placement == 'top') {
        delta = 0

        if (offset.left < 0){
          delta = offset.left * -2
          offset.left = 0
          $tip.offset(offset)
          actualWidth = $tip[0].offsetWidth
          actualHeight = $tip[0].offsetHeight
        }

        this.replaceArrow(delta - width + actualWidth, actualWidth, 'left')
      } else {
        this.replaceArrow(actualHeight - height, actualHeight, 'top')
      }

      if (replace) $tip.offset(offset)
    }

  , replaceArrow: function(delta, dimension, position){
      this
        .arrow()
        .css(position, delta ? (50 * (1 - delta / dimension) + "%") : '')
    }

  , setContent: function () {
      var $tip = this.tip()
        , title = this.getTitle()

      $tip.find('.tooltip-inner')[this.options.html ? 'html' : 'text'](title)
      $tip.removeClass('fade in top bottom left right')
    }

  , hide: function () {
      var that = this
        , $tip = this.tip()
        , e = $.Event('hide')

      this.$element.trigger(e)
      if (e.isDefaultPrevented()) return

      $tip.removeClass('in')

      function removeWithAnimation() {
        var timeout = setTimeout(function () {
          $tip.off($.support.transition.end).detach()
        }, 500)

        $tip.one($.support.transition.end, function () {
          clearTimeout(timeout)
          $tip.detach()
        })
      }

      $.support.transition && this.$tip.hasClass('fade') ?
        removeWithAnimation() :
        $tip.detach()

      this.$element.trigger('hidden')

      return this
    }

  , fixTitle: function () {
      var $e = this.$element
      if ($e.attr('title') || typeof($e.attr('data-original-title')) != 'string') {
        $e.attr('data-original-title', $e.attr('title') || '').attr('title', '')
      }
    }

  , hasContent: function () {
      return this.getTitle()
    }

  , getPosition: function () {
      var el = this.$element[0]
      return $.extend({}, (typeof el.getBoundingClientRect == 'function') ? el.getBoundingClientRect() : {
        width: el.offsetWidth
      , height: el.offsetHeight
      }, this.$element.offset())
    }

  , getTitle: function () {
      var title
        , $e = this.$element
        , o = this.options

      title = $e.attr('data-original-title')
        || (typeof o.title == 'function' ? o.title.call($e[0]) :  o.title)

      return title
    }

  , tip: function () {
      return this.$tip = this.$tip || $(this.options.template)
    }

  , arrow: function(){
      return this.$arrow = this.$arrow || this.tip().find(".tooltip-arrow")
    }

  , validate: function () {
      if (!this.$element[0].parentNode) {
        this.hide()
        this.$element = null
        this.options = null
      }
    }

  , enable: function () {
      this.enabled = true
    }

  , disable: function () {
      this.enabled = false
    }

  , toggleEnabled: function () {
      this.enabled = !this.enabled
    }

  , toggle: function (e) {
      var self = e ? $(e.currentTarget)[this.type](this._options).data(this.type) : this
      self.tip().hasClass('in') ? self.hide() : self.show()
    }

  , destroy: function () {
      this.hide().$element.off('.' + this.type).removeData(this.type)
    }

  }


 /* TOOLTIP PLUGIN DEFINITION
  * ========================= */

  var old = $.fn.tooltip

  $.fn.tooltip = function ( option ) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('tooltip')
        , options = typeof option == 'object' && option
      if (!data) $this.data('tooltip', (data = new Tooltip(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

  $.fn.tooltip.Constructor = Tooltip

  $.fn.tooltip.defaults = {
    animation: true
  , placement: 'top'
  , selector: false
  , template: '<div class="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>'
  , trigger: 'hover focus'
  , title: ''
  , delay: 0
  , html: false
  , container: false
  }


 /* TOOLTIP NO CONFLICT
  * =================== */

  $.fn.tooltip.noConflict = function () {
    $.fn.tooltip = old
    return this
  }

}(window.jQuery);
/* ===========================================================
 * bootstrap-popover.js v2.3.2
 * http://twitter.github.com/bootstrap/javascript.html#popovers
 * ===========================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =========================================================== */


!function ($) {

  "use strict"; // jshint ;_;


 /* POPOVER PUBLIC CLASS DEFINITION
  * =============================== */

  var Popover = function (element, options) {
    this.init('popover', element, options)
  }


  /* NOTE: POPOVER EXTENDS BOOTSTRAP-TOOLTIP.js
     ========================================== */

  Popover.prototype = $.extend({}, $.fn.tooltip.Constructor.prototype, {

    constructor: Popover

  , setContent: function () {
      var $tip = this.tip()
        , title = this.getTitle()
        , content = this.getContent()

      $tip.find('.popover-title')[this.options.html ? 'html' : 'text'](title)
      $tip.find('.popover-content')[this.options.html ? 'html' : 'text'](content)

      $tip.removeClass('fade top bottom left right in')
    }

  , hasContent: function () {
      return this.getTitle() || this.getContent()
    }

  , getContent: function () {
      var content
        , $e = this.$element
        , o = this.options

      content = (typeof o.content == 'function' ? o.content.call($e[0]) :  o.content)
        || $e.attr('data-content')

      return content
    }

  , tip: function () {
      if (!this.$tip) {
        this.$tip = $(this.options.template)
      }
      return this.$tip
    }

  , destroy: function () {
      this.hide().$element.off('.' + this.type).removeData(this.type)
    }

  })


 /* POPOVER PLUGIN DEFINITION
  * ======================= */

  var old = $.fn.popover

  $.fn.popover = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('popover')
        , options = typeof option == 'object' && option
      if (!data) $this.data('popover', (data = new Popover(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

  $.fn.popover.Constructor = Popover

  $.fn.popover.defaults = $.extend({} , $.fn.tooltip.defaults, {
    placement: 'right'
  , trigger: 'click'
  , content: ''
  , template: '<div class="popover"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>'
  })


 /* POPOVER NO CONFLICT
  * =================== */

  $.fn.popover.noConflict = function () {
    $.fn.popover = old
    return this
  }

}(window.jQuery);
/* =============================================================
 * bootstrap-scrollspy.js v2.3.2
 * http://twitter.github.com/bootstrap/javascript.html#scrollspy
 * =============================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================== */


!function ($) {

  "use strict"; // jshint ;_;


 /* SCROLLSPY CLASS DEFINITION
  * ========================== */

  function ScrollSpy(element, options) {
    var process = $.proxy(this.process, this)
      , $element = $(element).is('body') ? $(window) : $(element)
      , href
    this.options = $.extend({}, $.fn.scrollspy.defaults, options)
    this.$scrollElement = $element.on('scroll.scroll-spy.data-api', process)
    this.selector = (this.options.target
      || ((href = $(element).attr('href')) && href.replace(/.*(?=#[^\s]+$)/, '')) //strip for ie7
      || '') + ' .nav li > a'
    this.$body = $('body')
    this.refresh()
    this.process()
  }

  ScrollSpy.prototype = {

      constructor: ScrollSpy

    , refresh: function () {
        var self = this
          , $targets

        this.offsets = $([])
        this.targets = $([])

        $targets = this.$body
          .find(this.selector)
          .map(function () {
            var $el = $(this)
              , href = $el.data('target') || $el.attr('href')
              , $href = /^#\w/.test(href) && $(href)
            return ( $href
              && $href.length
              && [[ $href.position().top + (!$.isWindow(self.$scrollElement.get(0)) && self.$scrollElement.scrollTop()), href ]] ) || null
          })
          .sort(function (a, b) { return a[0] - b[0] })
          .each(function () {
            self.offsets.push(this[0])
            self.targets.push(this[1])
          })
      }

    , process: function () {
        var scrollTop = this.$scrollElement.scrollTop() + this.options.offset
          , scrollHeight = this.$scrollElement[0].scrollHeight || this.$body[0].scrollHeight
          , maxScroll = scrollHeight - this.$scrollElement.height()
          , offsets = this.offsets
          , targets = this.targets
          , activeTarget = this.activeTarget
          , i

        if (scrollTop >= maxScroll) {
          return activeTarget != (i = targets.last()[0])
            && this.activate ( i )
        }

        for (i = offsets.length; i--;) {
          activeTarget != targets[i]
            && scrollTop >= offsets[i]
            && (!offsets[i + 1] || scrollTop <= offsets[i + 1])
            && this.activate( targets[i] )
        }
      }

    , activate: function (target) {
        var active
          , selector

        this.activeTarget = target

        $(this.selector)
          .parent('.active')
          .removeClass('active')

        selector = this.selector
          + '[data-target="' + target + '"],'
          + this.selector + '[href="' + target + '"]'

        active = $(selector)
          .parent('li')
          .addClass('active')

        if (active.parent('.dropdown-menu').length)  {
          active = active.closest('li.dropdown').addClass('active')
        }

        active.trigger('activate')
      }

  }


 /* SCROLLSPY PLUGIN DEFINITION
  * =========================== */

  var old = $.fn.scrollspy

  $.fn.scrollspy = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('scrollspy')
        , options = typeof option == 'object' && option
      if (!data) $this.data('scrollspy', (data = new ScrollSpy(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

  $.fn.scrollspy.Constructor = ScrollSpy

  $.fn.scrollspy.defaults = {
    offset: 10
  }


 /* SCROLLSPY NO CONFLICT
  * ===================== */

  $.fn.scrollspy.noConflict = function () {
    $.fn.scrollspy = old
    return this
  }


 /* SCROLLSPY DATA-API
  * ================== */

  $(window).on('load', function () {
    $('[data-spy="scroll"]').each(function () {
      var $spy = $(this)
      $spy.scrollspy($spy.data())
    })
  })

}(window.jQuery);/* ========================================================
 * bootstrap-tab.js v2.3.2
 * http://twitter.github.com/bootstrap/javascript.html#tabs
 * ========================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ======================================================== */


!function ($) {

  "use strict"; // jshint ;_;


 /* TAB CLASS DEFINITION
  * ==================== */

  var Tab = function (element) {
    this.element = $(element)
  }

  Tab.prototype = {

    constructor: Tab

  , show: function () {
      var $this = this.element
        , $ul = $this.closest('ul:not(.dropdown-menu)')
        , selector = $this.attr('data-target')
        , previous
        , $target
        , e

      if (!selector) {
        selector = $this.attr('href')
        selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7
      }

      if ( $this.parent('li').hasClass('active') ) return

      previous = $ul.find('.active:last a')[0]

      e = $.Event('show', {
        relatedTarget: previous
      })

      $this.trigger(e)

      if (e.isDefaultPrevented()) return

      $target = $(selector)

      this.activate($this.parent('li'), $ul)
      this.activate($target, $target.parent(), function () {
        $this.trigger({
          type: 'shown'
        , relatedTarget: previous
        })
      })
    }

  , activate: function ( element, container, callback) {
      var $active = container.find('> .active')
        , transition = callback
            && $.support.transition
            && $active.hasClass('fade')

      function next() {
        $active
          .removeClass('active')
          .find('> .dropdown-menu > .active')
          .removeClass('active')

        element.addClass('active')

        if (transition) {
          element[0].offsetWidth // reflow for transition
          element.addClass('in')
        } else {
          element.removeClass('fade')
        }

        if ( element.parent('.dropdown-menu') ) {
          element.closest('li.dropdown').addClass('active')
        }

        callback && callback()
      }

      transition ?
        $active.one($.support.transition.end, next) :
        next()

      $active.removeClass('in')
    }
  }


 /* TAB PLUGIN DEFINITION
  * ===================== */

  var old = $.fn.tab

  $.fn.tab = function ( option ) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('tab')
      if (!data) $this.data('tab', (data = new Tab(this)))
      if (typeof option == 'string') data[option]()
    })
  }

  $.fn.tab.Constructor = Tab


 /* TAB NO CONFLICT
  * =============== */

  $.fn.tab.noConflict = function () {
    $.fn.tab = old
    return this
  }


 /* TAB DATA-API
  * ============ */

  $(document).on('click.tab.data-api', '[data-toggle="tab"], [data-toggle="pill"]', function (e) {
    e.preventDefault()
    $(this).tab('show')
  })

}(window.jQuery);/* =============================================================
 * bootstrap-typeahead.js v2.3.2
 * http://twitter.github.com/bootstrap/javascript.html#typeahead
 * =============================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */


!function($){

  "use strict"; // jshint ;_;


 /* TYPEAHEAD PUBLIC CLASS DEFINITION
  * ================================= */

  var Typeahead = function (element, options) {
    this.$element = $(element)
    this.options = $.extend({}, $.fn.typeahead.defaults, options)
    this.matcher = this.options.matcher || this.matcher
    this.sorter = this.options.sorter || this.sorter
    this.highlighter = this.options.highlighter || this.highlighter
    this.updater = this.options.updater || this.updater
    this.source = this.options.source
    this.$menu = $(this.options.menu)
    this.shown = false
    this.listen()
  }

  Typeahead.prototype = {

    constructor: Typeahead

  , select: function () {
      var val = this.$menu.find('.active').attr('data-value')
      this.$element
        .val(this.updater(val))
        .change()
      return this.hide()
    }

  , updater: function (item) {
      return item
    }

  , show: function () {
      var pos = $.extend({}, this.$element.position(), {
        height: this.$element[0].offsetHeight
      })

      this.$menu
        .insertAfter(this.$element)
        .css({
          top: pos.top + pos.height
        , left: pos.left
        })
        .show()

      this.shown = true
      return this
    }

  , hide: function () {
      this.$menu.hide()
      this.shown = false
      return this
    }

  , lookup: function (event) {
      var items

      this.query = this.$element.val()

      if (!this.query || this.query.length < this.options.minLength) {
        return this.shown ? this.hide() : this
      }

      items = $.isFunction(this.source) ? this.source(this.query, $.proxy(this.process, this)) : this.source

      return items ? this.process(items) : this
    }

  , process: function (items) {
      var that = this

      items = $.grep(items, function (item) {
        return that.matcher(item)
      })

      items = this.sorter(items)

      if (!items.length) {
        return this.shown ? this.hide() : this
      }

      return this.render(items.slice(0, this.options.items)).show()
    }

  , matcher: function (item) {
      return ~item.toLowerCase().indexOf(this.query.toLowerCase())
    }

  , sorter: function (items) {
      var beginswith = []
        , caseSensitive = []
        , caseInsensitive = []
        , item

      while (item = items.shift()) {
        if (!item.toLowerCase().indexOf(this.query.toLowerCase())) beginswith.push(item)
        else if (~item.indexOf(this.query)) caseSensitive.push(item)
        else caseInsensitive.push(item)
      }

      return beginswith.concat(caseSensitive, caseInsensitive)
    }

  , highlighter: function (item) {
      var query = this.query.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, '\\$&')
      return item.replace(new RegExp('(' + query + ')', 'ig'), function ($1, match) {
        return '<strong>' + match + '</strong>'
      })
    }

  , render: function (items) {
      var that = this

      items = $(items).map(function (i, item) {
        i = $(that.options.item).attr('data-value', item)
        i.find('a').html(that.highlighter(item))
        return i[0]
      })

      items.first().addClass('active')
      this.$menu.html(items)
      return this
    }

  , next: function (event) {
      var active = this.$menu.find('.active').removeClass('active')
        , next = active.next()

      if (!next.length) {
        next = $(this.$menu.find('li')[0])
      }

      next.addClass('active')
    }

  , prev: function (event) {
      var active = this.$menu.find('.active').removeClass('active')
        , prev = active.prev()

      if (!prev.length) {
        prev = this.$menu.find('li').last()
      }

      prev.addClass('active')
    }

  , listen: function () {
      this.$element
        .on('focus',    $.proxy(this.focus, this))
        .on('blur',     $.proxy(this.blur, this))
        .on('keypress', $.proxy(this.keypress, this))
        .on('keyup',    $.proxy(this.keyup, this))

      if (this.eventSupported('keydown')) {
        this.$element.on('keydown', $.proxy(this.keydown, this))
      }

      this.$menu
        .on('click', $.proxy(this.click, this))
        .on('mouseenter', 'li', $.proxy(this.mouseenter, this))
        .on('mouseleave', 'li', $.proxy(this.mouseleave, this))
    }

  , eventSupported: function(eventName) {
      var isSupported = eventName in this.$element
      if (!isSupported) {
        this.$element.setAttribute(eventName, 'return;')
        isSupported = typeof this.$element[eventName] === 'function'
      }
      return isSupported
    }

  , move: function (e) {
      if (!this.shown) return

      switch(e.keyCode) {
        case 9: // tab
        case 13: // enter
        case 27: // escape
          e.preventDefault()
          break

        case 38: // up arrow
          e.preventDefault()
          this.prev()
          break

        case 40: // down arrow
          e.preventDefault()
          this.next()
          break
      }

      e.stopPropagation()
    }

  , keydown: function (e) {
      this.suppressKeyPressRepeat = ~$.inArray(e.keyCode, [40,38,9,13,27])
      this.move(e)
    }

  , keypress: function (e) {
      if (this.suppressKeyPressRepeat) return
      this.move(e)
    }

  , keyup: function (e) {
      switch(e.keyCode) {
        case 40: // down arrow
        case 38: // up arrow
        case 16: // shift
        case 17: // ctrl
        case 18: // alt
          break

        case 9: // tab
        case 13: // enter
          if (!this.shown) return
          this.select()
          break

        case 27: // escape
          if (!this.shown) return
          this.hide()
          break

        default:
          this.lookup()
      }

      e.stopPropagation()
      e.preventDefault()
  }

  , focus: function (e) {
      this.focused = true
    }

  , blur: function (e) {
      this.focused = false
      if (!this.mousedover && this.shown) this.hide()
    }

  , click: function (e) {
      e.stopPropagation()
      e.preventDefault()
      this.select()
      this.$element.focus()
    }

  , mouseenter: function (e) {
      this.mousedover = true
      this.$menu.find('.active').removeClass('active')
      $(e.currentTarget).addClass('active')
    }

  , mouseleave: function (e) {
      this.mousedover = false
      if (!this.focused && this.shown) this.hide()
    }

  }


  /* TYPEAHEAD PLUGIN DEFINITION
   * =========================== */

  var old = $.fn.typeahead

  $.fn.typeahead = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('typeahead')
        , options = typeof option == 'object' && option
      if (!data) $this.data('typeahead', (data = new Typeahead(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

  $.fn.typeahead.defaults = {
    source: []
  , items: 8
  , menu: '<ul class="typeahead dropdown-menu"></ul>'
  , item: '<li><a href="#"></a></li>'
  , minLength: 1
  }

  $.fn.typeahead.Constructor = Typeahead


 /* TYPEAHEAD NO CONFLICT
  * =================== */

  $.fn.typeahead.noConflict = function () {
    $.fn.typeahead = old
    return this
  }


 /* TYPEAHEAD DATA-API
  * ================== */

  $(document).on('focus.typeahead.data-api', '[data-provide="typeahead"]', function (e) {
    var $this = $(this)
    if ($this.data('typeahead')) return
    $this.typeahead($this.data())
  })

}(window.jQuery);
/* ==========================================================
 * bootstrap-affix.js v2.3.2
 * http://twitter.github.com/bootstrap/javascript.html#affix
 * ==========================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================== */


!function ($) {

  "use strict"; // jshint ;_;


 /* AFFIX CLASS DEFINITION
  * ====================== */

  var Affix = function (element, options) {
    this.options = $.extend({}, $.fn.affix.defaults, options)
    this.$window = $(window)
      .on('scroll.affix.data-api', $.proxy(this.checkPosition, this))
      .on('click.affix.data-api',  $.proxy(function () { setTimeout($.proxy(this.checkPosition, this), 1) }, this))
    this.$element = $(element)
    this.checkPosition()
  }

  Affix.prototype.checkPosition = function () {
    if (!this.$element.is(':visible')) return

    var scrollHeight = $(document).height()
      , scrollTop = this.$window.scrollTop()
      , position = this.$element.offset()
      , offset = this.options.offset
      , offsetBottom = offset.bottom
      , offsetTop = offset.top
      , reset = 'affix affix-top affix-bottom'
      , affix

    if (typeof offset != 'object') offsetBottom = offsetTop = offset
    if (typeof offsetTop == 'function') offsetTop = offset.top()
    if (typeof offsetBottom == 'function') offsetBottom = offset.bottom()

    affix = this.unpin != null && (scrollTop + this.unpin <= position.top) ?
      false    : offsetBottom != null && (position.top + this.$element.height() >= scrollHeight - offsetBottom) ?
      'bottom' : offsetTop != null && scrollTop <= offsetTop ?
      'top'    : false

    if (this.affixed === affix) return

    this.affixed = affix
    this.unpin = affix == 'bottom' ? position.top - scrollTop : null

    this.$element.removeClass(reset).addClass('affix' + (affix ? '-' + affix : ''))
  }


 /* AFFIX PLUGIN DEFINITION
  * ======================= */

  var old = $.fn.affix

  $.fn.affix = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('affix')
        , options = typeof option == 'object' && option
      if (!data) $this.data('affix', (data = new Affix(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

  $.fn.affix.Constructor = Affix

  $.fn.affix.defaults = {
    offset: 0
  }


 /* AFFIX NO CONFLICT
  * ================= */

  $.fn.affix.noConflict = function () {
    $.fn.affix = old
    return this
  }


 /* AFFIX DATA-API
  * ============== */

  $(window).on('load', function () {
    $('[data-spy="affix"]').each(function () {
      var $spy = $(this)
        , data = $spy.data()

      data.offset = data.offset || {}

      data.offsetBottom && (data.offset.bottom = data.offsetBottom)
      data.offsetTop && (data.offset.top = data.offsetTop)

      $spy.affix(data)
    })
  })


}(window.jQuery);

(function (global) {
  var emojify = (function () {

    var document = global.window.document;

    var findText = function (element, pattern, callback) {
      for (var childi = element.childNodes.length; childi-- > 0;) {
        var child = element.childNodes[childi];
        if (child.nodeType == 1) {

          var tag = child.tagName.toLowerCase(),
          classname;
          if (child.hasAttribute('class')) classname = child.getAttribute('class').toLowerCase();

          if (classname) {
            if (tag !== 'script' && tag !== 'style' && tag !== 'textarea' && classname !== 'no-emojify') findText(child, pattern, callback);
          }
          else {
            if (tag !== 'script' && tag !== 'style' && tag !== 'textarea') findText(child, pattern, callback);
          }

        }
        else if (child.nodeType == 3) {
          var matches = [];
          if (typeof pattern === 'string') {
            console.error('Accepts regex only');
          } else {
            var match;
            while (match = pattern.exec(child.data))
              matches.push(match);
          }
          for (var i = matches.length; i-- > 0;)
          callback.call(window, child, matches[i]);
        }
      }
    };

    return {
      config: {
        emojify_tag_type: 'img',
        cdn_host: 'http://www.tortue.me/emoji',
        emoji_image_extension: 'png',
        emoticons_enabled: true,
        people_enabled: true,
        nature_enabled: true,
        objects_enabled: true,
        places_enabled: true,
        symbols_enabled: true
      },

      setConfig: function (newConfig) {
        this.config.emojify_tag_type = typeof newConfig.emojify_tag_type !== 'undefined' ? newConfig.emojify_tag_type : this.config.emojify_tag_type;
        this.config.emoticons_enabled = typeof newConfig.emoticons_enabled !== 'undefined' ? newConfig.emoticons_enabled : this.config.emoticons_enabled;
        this.config.people_enabled = typeof newConfig.people_enabled !== 'undefined' ? newConfig.people_enabled : this.config.people_enabled;
        this.config.nature_enabled = typeof newConfig.nature_enabled !== 'undefined' ? newConfig.nature_enabled : this.config.nature_enabled;
        this.config.objects_enabled = typeof newConfig.objects_enabled !== 'undefined' ? newConfig.objects_enabled : this.config.objects_enabled;
        this.config.places_enabled = typeof newConfig.places_enabled !== 'undefined' ? newConfig.places_enabled : this.config.places_enabled;
        this.config.symbols_enabled = typeof newConfig.symbols_enabled !== 'undefined' ? newConfig.symbols_enabled : this.config.symbols_enabled;

        this.config.cdn_host = typeof newConfig.cdn_host !== 'undefined' ? newConfig.cdn_host : this.config.cdn_host;
        this.config.emoji_image_extension = typeof newConfig.emoji_image_extension !== 'undefined' ? newConfig.emoji_image_extension : this.config.emoji_image_extension;
      },

      run: function (el) {
        el = el ? el : document.body

        var selected_sets = []
        if (this.config.people_enabled) selected_sets.push(PEOPLE);
        if (this.config.nature_enabled) selected_sets.push(NATURE);
        if (this.config.objects_enabled) selected_sets.push(OBJECTS);
        if (this.config.places_enabled) selected_sets.push(PLACES);
        if (this.config.symbols_enabled) selected_sets.push(SYMBOLS);
        if (this.config.emoticons_enabled) selected_sets.push(EMOTICONS);

        for (var index = 0; index < selected_sets.length; index++) {
          var r;
          while (r = selected_sets[index].shift()) {
            findText(el, r[0], function (node, match) {
              var wrap = document.createElement(this.emojify.config.emojify_tag_type);
              wrap.setAttribute('class', r[1]);
              title = r[1].replace(/emojify /g, '');
              wrap.setAttribute('src', this.emojify.config.cdn_host + "/" + title + "." + this.emojify.config.emoji_image_extension)
              wrap.setAttribute('title', ':' + title + ':');
              node.splitText(match.index);
              node.nextSibling.nodeValue = node.nextSibling.nodeValue.substr(match[0].length, node.nextSibling.nodeValue.length);
              wrap.appendChild(node.splitText(match.index));
              node.parentNode.insertBefore(wrap, node.nextSibling);
            });
          }
        }
      }
    };
  })();

  global.emojify = emojify;

  var EMOTICONS = [
    [/:-*\)/g, 'emojify blush'],
    [/:-*o/gi, 'emojify scream'],
    [/(:|;)-*]/g, 'emojify smirk'],
    [/(:|;)-*d/gi, 'emojify smiley'],
    [/xd/gi, 'emojify stuck_out_tongue_closed_eyes'],
    [/:-*p/gi, 'emojify stuck_out_tongue_winking_eye'],
    [/:-*(\[|@)/g, 'emojify rage'],
    [/:-*\(/g, 'emojify disappointed'],
    [/:('|’)-*\(/g, 'emojify sob'],
    [/:-*\*/g, 'emojify kissing_heart'],
    [/;-*\)/g, 'emojify wink'],
    [/:-*\//g, 'emojify pensive'],
    [/:-*s/gi, 'emojify confounded'],
    [/:-*\|/g, 'emojify flushed'],
    [/:-*\$/g, 'emojify relaxed'],
    [/:-*x/gi, 'emojify mask'],
    [/<3/g, 'emojify heart'],
    [/<\/3/g, 'emojify broken_heart']
  ];

  var PEOPLE = [
    [/:bowtie:/g, 'emojify bowtie'],
    [/:smile:/g, 'emojify smile'],
    [/:laughing:/g, 'emojify laughing'],
    [/:blush:/g, 'emojify blush'],
    [/:smiley:/g, 'emojify smiley'],
    [/:relaxed:/g, 'emojify relaxed'],
    [/:smirk:/g, 'emojify smirk'],
    [/:heart_eyes:/g, 'emojify heart_eyes'],
    [/:kissing_heart:/g, 'emojify kissing_heart'],
    [/:kissing_closed_eyes:/g, 'emojify kissing_closed_eyes'],
    [/:flushed:/g, 'emojify flushed'],
    [/:relieved:/g, 'emojify relieved'],
    [/:satisfied:/g, 'emojify satisfied'],
    [/:grin:/g, 'emojify grin'],
    [/:wink:/g, 'emojify wink'],
    [/:wink2:/g, 'emojify wink2'],
    [/:stuck_out_tongue_winking_eye:/g, 'emojify stuck_out_tongue_winking_eye'],
    [/:stuck_out_tongue_closed_eyes:/g, 'emojify stuck_out_tongue_closed_eyes'],
    [/:grinning:/g, 'emojify grinning'],
    [/:kissing:/g, 'emojify kissing'],
    [/:kissing_smiling_eyes:/g, 'emojify kissing_smiling_eyes'],
    [/:stuck_out_tongue:/g, 'emojify stuck_out_tongue'],
    [/:sleeping:/g, 'emojify sleeping'],
    [/:worried:/g, 'emojify worried'],
    [/:frowning:/g, 'emojify frowning'],
    [/:anguished:/g, 'emojify anguished'],
    [/:open_mouth:/g, 'emojify open_mouth'],
    [/:grimacing:/g, 'emojify grimacing'],
    [/:confused:/g, 'emojify confused'],
    [/:hushed:/g, 'emojify hushed'],
    [/:expressionless:/g, 'emojify expressionless'],
    [/:unamused:/g, 'emojify unamused'],
    [/:sweat_smile:/g, 'emojify sweat_smile'],
    [/:sweat:/g, 'emojify sweat'],
    [/:weary:/g, 'emojify weary'],
    [/:pensive:/g, 'emojify pensive'],
    [/:disappointed:/g, 'emojify disappointed'],
    [/:confounded:/g, 'emojify confounded'],
    [/:fearful:/g, 'emojify fearful'],
    [/:cold_sweat:/g, 'emojify cold_sweat'],
    [/:persevere:/g, 'emojify persevere'],
    [/:cry:/g, 'emojify cry'],
    [/:sob:/g, 'emojify sob'],
    [/:joy:/g, 'emojify joy'],
    [/:scream:/g, 'emojify scream'],
    [/:astonished:/g, 'emojify astonished'],
    [/:neckbeard:/g, 'emojify neckbeard'],
    [/:tired_face:/g, 'emojify tired_face'],
    [/:angry:/g, 'emojify angry'],
    [/:rage:/g, 'emojify rage'],
    [/:triumph:/g, 'emojify triumph'],
    [/:sleepy:/g, 'emojify sleepy'],
    [/:yum:/g, 'emojify yum'],
    [/:mask:/g, 'emojify mask'],
    [/:sunglasses:/g, 'emojify sunglasses'],
    [/:dizzy_face:/g, 'emojify dizzy_face'],
    [/:imp:/g, 'emojify imp'],
    [/:smiling_imp:/g, 'emojify smiling_imp'],
    [/:neutral_face:/g, 'emojify neutral_face'],
    [/:no_mouth:/g, 'emojify no_mouth'],
    [/:innocent:/g, 'emojify innocent'],
    [/:alien:/g, 'emojify alien'],
    [/:yellow_heart:/g, 'emojify yellow_heart'],
    [/:blue_heart:/g, 'emojify blue_heart'],
    [/:purple_heart:/g, 'emojify purple_heart'],
    [/:heart:/g, 'emojify heart'],
    [/:green_heart:/g, 'emojify green_heart'],
    [/:broken_heart:/g, 'emojify broken_heart'],
    [/:heartbeat:/g, 'emojify heartbeat'],
    [/:heartpulse:/g, 'emojify heartpulse'],
    [/:two_hearts:/g, 'emojify two_hearts'],
    [/:revolving_hearts:/g, 'emojify revolving_hearts'],
    [/:cupid:/g, 'emojify cupid'],
    [/:sparkling_heart:/g, 'emojify sparkling_heart'],
    [/:sparkles:/g, 'emojify sparkles'],
    [/:star:/g, 'emojify star'],
    [/:star2:/g, 'emojify star2'],
    [/:dizzy:/g, 'emojify dizzy'],
    [/:boom:/g, 'emojify boom'],
    [/:collision:/g, 'emojify collision'],
    [/:anger:/g, 'emojify anger'],
    [/:exclamation:/g, 'emojify exclamation'],
    [/:question:/g, 'emojify question'],
    [/:grey_exclamation:/g, 'emojify grey_exclamation'],
    [/:grey_question:/g, 'emojify grey_question'],
    [/:zzz:/g, 'emojify zzz'],
    [/:dash:/g, 'emojify dash'],
    [/:sweat_drops:/g, 'emojify sweat_drops'],
    [/:notes:/g, 'emojify notes'],
    [/:musical_note:/g, 'emojify musical_note'],
    [/:fire:/g, 'emojify fire'],
    [/:hankey:/g, 'emojify hankey'],
    [/:poop:/g, 'emojify poop'],
    [/:shit:/g, 'emojify shit'],
    [/:thumbsup:|:\+1:/g, 'emojify thumbsup'],
    [/:thumbsdown:|:-1:/g, 'emojify thumbsdown'],
    [/:ok_hand:/g, 'emojify ok_hand'],
    [/:punch:/g, 'emojify punch'],
    [/:facepunch:/g, 'emojify facepunch'],
    [/:fist:/g, 'emojify fist'],
    [/:v:/g, 'emojify v'],
    [/:wave:/g, 'emojify wave'],
    [/:hand:/g, 'emojify hand'],
    [/:open_hands:/g, 'emojify open_hands'],
    [/:point_up:/g, 'emojify point_up'],
    [/:point_down:/g, 'emojify point_down'],
    [/:point_left:/g, 'emojify point_left'],
    [/:point_right:/g, 'emojify point_right'],
    [/:raised_hands:/g, 'emojify raised_hands'],
    [/:pray:/g, 'emojify pray'],
    [/:point_up_2:/g, 'emojify point_up_2'],
    [/:clap:/g, 'emojify clap'],
    [/:muscle:/g, 'emojify muscle'],
    [/:metal:/g, 'emojify metal'],
    [/:walking:/g, 'emojify walking'],
    [/:runner:/g, 'emojify runner'],
    [/:running:/g, 'emojify running'],
    [/:couple:/g, 'emojify couple'],
    [/:family:/g, 'emojify family'],
    [/:two_men_holding_hands:/g, 'emojify two_men_holding_hands'],
    [/:two_women_holding_hands:/g, 'emojify two_women_holding_hands'],
    [/:dancer:/g, 'emojify dancer'],
    [/:dancers:/g, 'emojify dancers'],
    [/:ok_woman:/g, 'emojify ok_woman'],
    [/:no_good:/g, 'emojify no_good'],
    [/:information_desk_person:/g, 'emojify information_desk_person'],
    [/:raised_hand:/g, 'emojify raised_hand'],
    [/:bride_with_veil:/g, 'emojify bride_with_veil'],
    [/:person_with_pouting_face:/g, 'emojify person_with_pouting_face'],
    [/:person_frowning:/g, 'emojify person_frowning'],
    [/:bow:/g, 'emojify bow'],
    [/:couplekiss:/g, 'emojify couplekiss'],
    [/:couple_with_heart:/g, 'emojify couple_with_heart'],
    [/:massage:/g, 'emojify massage'],
    [/:haircut:/g, 'emojify haircut'],
    [/:nail_care:/g, 'emojify nail_care'],
    [/:boy:/g, 'emojify boy'],
    [/:girl:/g, 'emojify girl'],
    [/:woman:/g, 'emojify woman'],
    [/:man:/g, 'emojify man'],
    [/:baby:/g, 'emojify baby'],
    [/:older_woman:/g, 'emojify older_woman'],
    [/:older_man:/g, 'emojify older_man'],
    [/:person_with_blond_hair:/g, 'emojify person_with_blond_hair'],
    [/:man_with_gua_pi_mao:/g, 'emojify man_with_gua_pi_mao'],
    [/:man_with_turban:/g, 'emojify man_with_turban'],
    [/:construction_worker:/g, 'emojify construction_worker'],
    [/:cop:/g, 'emojify cop'],
    [/:angel:/g, 'emojify angel'],
    [/:princess:/g, 'emojify princess'],
    [/:smiley_cat:/g, 'emojify smiley_cat'],
    [/:smile_cat:/g, 'emojify smile_cat'],
    [/:heart_eyes_cat:/g, 'emojify heart_eyes_cat'],
    [/:kissing_cat:/g, 'emojify kissing_cat'],
    [/:smirk_cat:/g, 'emojify smirk_cat'],
    [/:scream_cat:/g, 'emojify scream_cat'],
    [/:crying_cat_face:/g, 'emojify crying_cat_face'],
    [/:joy_cat:/g, 'emojify joy_cat'],
    [/:pouting_cat:/g, 'emojify pouting_cat'],
    [/:japanese_ogre:/g, 'emojify japanese_ogre'],
    [/:japanese_goblin:/g, 'emojify japanese_goblin'],
    [/:see_no_evil:/g, 'emojify see_no_evil'],
    [/:hear_no_evil:/g, 'emojify hear_no_evil'],
    [/:speak_no_evil:/g, 'emojify speak_no_evil'],
    [/:guardsman:/g, 'emojify guardsman'],
    [/:skull:/g, 'emojify skull'],
    [/:feet:/g, 'emojify feet'],
    [/:lips:/g, 'emojify lips'],
    [/:kiss:/g, 'emojify kiss'],
    [/:droplet:/g, 'emojify droplet'],
    [/:ear:/g, 'emojify ear'],
    [/:eyes:/g, 'emojify eyes'],
    [/:nose:/g, 'emojify nose'],
    [/:tongue:/g, 'emojify tongue'],
    [/:love_letter:/g, 'emojify love_letter'],
    [/:bust_in_silhouette:/g, 'emojify bust_in_silhouette'],
    [/:busts_in_silhouette:/g, 'emojify busts_in_silhouette'],
    [/:speech_balloon:/g, 'emojify speech_balloon'],
    [/:thought_balloon:/g, 'emojify thought_balloon'],
    [/:feelsgood:/g, 'emojify feelsgood'],
    [/:finnadie:/g, 'emojify finnadie'],
    [/:goberserk:/g, 'emojify goberserk'],
    [/:godmode:/g, 'emojify godmode'],
    [/:hurtrealbad:/g, 'emojify hurtrealbad'],
    [/:rage1:/g, 'emojify rage1'],
    [/:rage2:/g, 'emojify rage2'],
    [/:rage3:/g, 'emojify rage3'],
    [/:rage4:/g, 'emojify rage4'],
    [/:suspect:/g, 'emojify suspect'],
    [/:trollface:/g, 'emojify trollface']
  ];

  var NATURE = [
    [/:sunny:/g, 'emojify sunny'],
    [/:umbrella:/g, 'emojify umbrella'],
    [/:cloud:/g, 'emojify cloud'],
    [/:snowflake:/g, 'emojify snowflake'],
    [/:snowman:/g, 'emojify snowman'],
    [/:zap:/g, 'emojify zap'],
    [/:cyclone:/g, 'emojify cyclone'],
    [/:foggy:/g, 'emojify foggy'],
    [/:ocean:/g, 'emojify ocean'],
    [/:cat:/g, 'emojify cat'],
    [/:dog:/g, 'emojify dog'],
    [/:mouse:/g, 'emojify mouse'],
    [/:hamster:/g, 'emojify hamster'],
    [/:rabbit:/g, 'emojify rabbit'],
    [/:wolf:/g, 'emojify wolf'],
    [/:frog:/g, 'emojify frog'],
    [/:tiger:/g, 'emojify tiger'],
    [/:koala:/g, 'emojify koala'],
    [/:bear:/g, 'emojify bear'],
    [/:pig:/g, 'emojify pig'],
    [/:pig_nose:/g, 'emojify pig_nose'],
    [/:cow:/g, 'emojify cow'],
    [/:boar:/g, 'emojify boar'],
    [/:monkey_face:/g, 'emojify monkey_face'],
    [/:monkey:/g, 'emojify monkey'],
    [/:horse:/g, 'emojify horse'],
    [/:racehorse:/g, 'emojify racehorse'],
    [/:camel:/g, 'emojify camel'],
    [/:sheep:/g, 'emojify sheep'],
    [/:elephant:/g, 'emojify elephant'],
    [/:panda_face:/g, 'emojify panda_face'],
    [/:snake:/g, 'emojify snake'],
    [/:bird:/g, 'emojify bird'],
    [/:baby_chick:/g, 'emojify baby_chick'],
    [/:hatched_chick:/g, 'emojify hatched_chick'],
    [/:hatching_chick:/g, 'emojify hatching_chick'],
    [/:chicken:/g, 'emojify chicken'],
    [/:penguin:/g, 'emojify penguin'],
    [/:turtle:/g, 'emojify turtle'],
    [/:bug:/g, 'emojify bug'],
    [/:honeybee:/g, 'emojify honeybee'],
    [/:ant:/g, 'emojify ant'],
    [/:beetle:/g, 'emojify beetle'],
    [/:snail:/g, 'emojify snail'],
    [/:octopus:/g, 'emojify octopus'],
    [/:tropical_fish:/g, 'emojify tropical_fish'],
    [/:fish:/g, 'emojify fish'],
    [/:whale:/g, 'emojify whale'],
    [/:whale2:/g, 'emojify whale2'],
    [/:dolphin:/g, 'emojify dolphin'],
    [/:cow2:/g, 'emojify cow2'],
    [/:ram:/g, 'emojify ram'],
    [/:rat:/g, 'emojify rat'],
    [/:water_buffalo:/g, 'emojify water_buffalo'],
    [/:tiger2:/g, 'emojify tiger2'],
    [/:rabbit2:/g, 'emojify rabbit2'],
    [/:dragon:/g, 'emojify dragon'],
    [/:goat:/g, 'emojify goat'],
    [/:rooster:/g, 'emojify rooster'],
    [/:dog2:/g, 'emojify dog2'],
    [/:pig2:/g, 'emojify pig2'],
    [/:mouse2:/g, 'emojify mouse2'],
    [/:ox:/g, 'emojify ox'],
    [/:dragon_face:/g, 'emojify dragon_face'],
    [/:blowfish:/g, 'emojify blowfish'],
    [/:crocodile:/g, 'emojify crocodile'],
    [/:dromedary_camel:/g, 'emojify dromedary_camel'],
    [/:leopard:/g, 'emojify leopard'],
    [/:cat2:/g, 'emojify cat2'],
    [/:poodle:/g, 'emojify poodle'],
    [/:paw_prints:/g, 'emojify paw_prints'],
    [/:bouquet:/g, 'emojify bouquet'],
    [/:cherry_blossom:/g, 'emojify cherry_blossom'],
    [/:tulip:/g, 'emojify tulip'],
    [/:four_leaf_clover:/g, 'emojify four_leaf_clover'],
    [/:rose:/g, 'emojify rose'],
    [/:sunflower:/g, 'emojify sunflower'],
    [/:hibiscus:/g, 'emojify hibiscus'],
    [/:maple_leaf:/g, 'emojify maple_leaf'],
    [/:leaves:/g, 'emojify leaves'],
    [/:fallen_leaf:/g, 'emojify fallen_leaf'],
    [/:herb:/g, 'emojify herb'],
    [/:mushroom:/g, 'emojify mushroom'],
    [/:cactus:/g, 'emojify cactus'],
    [/:palm_tree:/g, 'emojify palm_tree'],
    [/:evergreen_tree:/g, 'emojify evergreen_tree'],
    [/:deciduous_tree:/g, 'emojify deciduous_tree'],
    [/:chestnut:/g, 'emojify chestnut'],
    [/:seedling:/g, 'emojify seedling'],
    [/:blossom:/g, 'emojify blossom'],
    [/:ear_of_rice:/g, 'emojify ear_of_rice'],
    [/:shell:/g, 'emojify shell'],
    [/:globe_with_meridians:/g, 'emojify globe_with_meridians'],
    [/:sun_with_face:/g, 'emojify sun_with_face'],
    [/:full_moon_with_face:/g, 'emojify full_moon_with_face'],
    [/:new_moon_with_face:/g, 'emojify new_moon_with_face'],
    [/:new_moon:/g, 'emojify new_moon'],
    [/:waxing_crescent_moon:/g, 'emojify waxing_crescent_moon'],
    [/:first_quarter_moon:/g, 'emojify first_quarter_moon'],
    [/:waxing_gibbous_moon:/g, 'emojify waxing_gibbous_moon'],
    [/:full_moon:/g, 'emojify full_moon'],
    [/:waning_gibbous_moon:/g, 'emojify waning_gibbous_moon'],
    [/:last_quarter_moon:/g, 'emojify last_quarter_moon'],
    [/:waning_crescent_moon:/g, 'emojify waning_crescent_moon'],
    [/:last_quarter_moon_with_face:/g, 'emojify last_quarter_moon_with_face'],
    [/:first_quarter_moon_with_face:/g, 'emojify first_quarter_moon_with_face'],
    [/:moon:/g, 'emojify moon'],
    [/:earth_africa:/g, 'emojify earth_africa'],
    [/:earth_americas:/g, 'emojify earth_americas'],
    [/:earth_asia:/g, 'emojify earth_asia'],
    [/:volcano:/g, 'emojify volcano'],
    [/:milky_way:/g, 'emojify milky_way'],
    [/:partly_sunny:/g, 'emojify partly_sunny'],
    [/:octocat:/g, 'emojify octocat'],
    [/:squirrel:/g, 'emojify squirrel']
  ];

  var OBJECTS = [
    [/:bamboo:/g, 'emojify bamboo'],
    [/:gift_heart:/g, 'emojify gift_heart'],
    [/:dolls:/g, 'emojify dolls'],
    [/:school_satchel:/g, 'emojify school_satchel'],
    [/:mortar_board:/g, 'emojify mortar_board'],
    [/:flags:/g, 'emojify flags'],
    [/:fireworks:/g, 'emojify fireworks'],
    [/:sparkler:/g, 'emojify sparkler'],
    [/:wind_chime:/g, 'emojify wind_chime'],
    [/:rice_scene:/g, 'emojify rice_scene'],
    [/:jack_o_lantern:/g, 'emojify jack_o_lantern'],
    [/:ghost:/g, 'emojify ghost'],
    [/:santa:/g, 'emojify santa'],
    [/:christmas_tree:/g, 'emojify christmas_tree'],
    [/:gift:/g, 'emojify gift'],
    [/:bell:/g, 'emojify bell'],
    [/:no_bell:/g, 'emojify no_bell'],
    [/:tanabata_tree:/g, 'emojify tanabata_tree'],
    [/:tada:/g, 'emojify tada'],
    [/:confetti_ball:/g, 'emojify confetti_ball'],
    [/:balloon:/g, 'emojify balloon'],
    [/:crystal_ball:/g, 'emojify crystal_ball'],
    [/:cd:/g, 'emojify cd'],
    [/:dvd:/g, 'emojify dvd'],
    [/:floppy_disk:/g, 'emojify floppy_disk'],
    [/:camera:/g, 'emojify camera'],
    [/:video_camera:/g, 'emojify video_camera'],
    [/:movie_camera:/g, 'emojify movie_camera'],
    [/:computer:/g, 'emojify computer'],
    [/:tv:/g, 'emojify tv'],
    [/:iphone:/g, 'emojify iphone'],
    [/:phone:/g, 'emojify phone'],
    [/:telephone:/g, 'emojify telephone'],
    [/:telephone_receiver:/g, 'emojify telephone_receiver'],
    [/:pager:/g, 'emojify pager'],
    [/:fax:/g, 'emojify fax'],
    [/:minidisc:/g, 'emojify minidisc'],
    [/:vhs:/g, 'emojify vhs'],
    [/:sound:/g, 'emojify sound'],
    [/:speaker:/g, 'emojify speaker'],
    [/:mute:/g, 'emojify mute'],
    [/:loudspeaker:/g, 'emojify loudspeaker'],
    [/:mega:/g, 'emojify mega'],
    [/:hourglass:/g, 'emojify hourglass'],
    [/:hourglass_flowing_sand:/g, 'emojify hourglass_flowing_sand'],
    [/:alarm_clock:/g, 'emojify alarm_clock'],
    [/:watch:/g, 'emojify watch'],
    [/:radio:/g, 'emojify radio'],
    [/:satellite:/g, 'emojify satellite'],
    [/:loop:/g, 'emojify loop'],
    [/:mag:/g, 'emojify mag'],
    [/:mag_right:/g, 'emojify mag_right'],
    [/:unlock:/g, 'emojify unlock'],
    [/:lock:/g, 'emojify lock'],
    [/:lock_with_ink_pen:/g, 'emojify lock_with_ink_pen'],
    [/:closed_lock_with_key:/g, 'emojify closed_lock_with_key'],
    [/:key:/g, 'emojify key'],
    [/:bulb:/g, 'emojify bulb'],
    [/:flashlight:/g, 'emojify flashlight'],
    [/:high_brightness:/g, 'emojify high_brightness'],
    [/:low_brightness:/g, 'emojify low_brightness'],
    [/:electric_plug:/g, 'emojify electric_plug'],
    [/:battery:/g, 'emojify battery'],
    [/:calling:/g, 'emojify calling'],
    [/:email:/g, 'emojify email'],
    [/:mailbox:/g, 'emojify mailbox'],
    [/:postbox:/g, 'emojify postbox'],
    [/:bath:/g, 'emojify bath'],
    [/:bathtub:/g, 'emojify bathtub'],
    [/:shower:/g, 'emojify shower'],
    [/:toilet:/g, 'emojify toilet'],
    [/:wrench:/g, 'emojify wrench'],
    [/:nut_and_bolt:/g, 'emojify nut_and_bolt'],
    [/:hammer:/g, 'emojify hammer'],
    [/:seat:/g, 'emojify seat'],
    [/:moneybag:/g, 'emojify moneybag'],
    [/:yen:/g, 'emojify yen'],
    [/:dollar:/g, 'emojify dollar'],
    [/:pound:/g, 'emojify pound'],
    [/:euro:/g, 'emojify euro'],
    [/:credit_card:/g, 'emojify credit_card'],
    [/:money_with_wings:/g, 'emojify money_with_wings'],
    [/:e-mail:/g, 'emojify e-mail'],
    [/:inbox_tray:/g, 'emojify inbox_tray'],
    [/:outbox_tray:/g, 'emojify outbox_tray'],
    [/:envelope:/g, 'emojify envelope'],
    [/:incoming_envelope:/g, 'emojify incoming_envelope'],
    [/:postal_horn:/g, 'emojify postal_horn'],
    [/:mailbox_closed:/g, 'emojify mailbox_closed'],
    [/:mailbox_with_mail:/g, 'emojify mailbox_with_mail'],
    [/:mailbox_with_no_mail:/g, 'emojify mailbox_with_no_mail'],
    [/:door:/g, 'emojify door'],
    [/:smoking:/g, 'emojify smoking'],
    [/:bomb:/g, 'emojify bomb'],
    [/:gun:/g, 'emojify gun'],
    [/:hocho:/g, 'emojify hocho'],
    [/:pill:/g, 'emojify pill'],
    [/:syringe:/g, 'emojify syringe'],
    [/:page_facing_up:/g, 'emojify page_facing_up'],
    [/:page_with_curl:/g, 'emojify page_with_curl'],
    [/:bookmark_tabs:/g, 'emojify bookmark_tabs'],
    [/:bar_chart:/g, 'emojify bar_chart'],
    [/:chart_with_upwards_trend:/g, 'emojify chart_with_upwards_trend'],
    [/:chart_with_downwards_trend:/g, 'emojify chart_with_downwards_trend'],
    [/:scroll:/g, 'emojify scroll'],
    [/:clipboard:/g, 'emojify clipboard'],
    [/:calendar:/g, 'emojify calendar'],
    [/:date:/g, 'emojify date'],
    [/:card_index:/g, 'emojify card_index'],
    [/:file_folder:/g, 'emojify file_folder'],
    [/:open_file_folder:/g, 'emojify open_file_folder'],
    [/:scissors:/g, 'emojify scissors'],
    [/:pushpin:/g, 'emojify pushpin'],
    [/:paperclip:/g, 'emojify paperclip'],
    [/:black_nib:/g, 'emojify black_nib'],
    [/:pencil2:/g, 'emojify pencil2'],
    [/:straight_ruler:/g, 'emojify straight_ruler'],
    [/:triangular_ruler:/g, 'emojify triangular_ruler'],
    [/:closed_book:/g, 'emojify closed_book'],
    [/:green_book:/g, 'emojify green_book'],
    [/:blue_book:/g, 'emojify blue_book'],
    [/:orange_book:/g, 'emojify orange_book'],
    [/:notebook:/g, 'emojify notebook'],
    [/:notebook_with_decorative_cover:/g, 'emojify notebook_with_decorative_cover'],
    [/:ledger:/g, 'emojify ledger'],
    [/:books:/g, 'emojify books'],
    [/:bookmark:/g, 'emojify bookmark'],
    [/:name_badge:/g, 'emojify name_badge'],
    [/:microscope:/g, 'emojify microscope'],
    [/:telescope:/g, 'emojify telescope'],
    [/:newspaper:/g, 'emojify newspaper'],
    [/:football:/g, 'emojify football'],
    [/:basketball:/g, 'emojify basketball'],
    [/:soccer:/g, 'emojify soccer'],
    [/:baseball:/g, 'emojify baseball'],
    [/:tennis:/g, 'emojify tennis'],
    [/:8ball:/g, 'emojify eightball'],
    [/:rugby_football:/g, 'emojify rugby_football'],
    [/:bowling:/g, 'emojify bowling'],
    [/:golf:/g, 'emojify golf'],
    [/:mountain_bicyclist:/g, 'emojify mountain_bicyclist'],
    [/:bicyclist:/g, 'emojify bicyclist'],
    [/:horse_racing:/g, 'emojify horse_racing'],
    [/:snowboarder:/g, 'emojify snowboarder'],
    [/:swimmer:/g, 'emojify swimmer'],
    [/:surfer:/g, 'emojify surfer'],
    [/:ski:/g, 'emojify ski'],
    [/:spades:/g, 'emojify spades'],
    [/:hearts:/g, 'emojify hearts'],
    [/:clubs:/g, 'emojify clubs'],
    [/:diamonds:/g, 'emojify diamonds'],
    [/:gem:/g, 'emojify gem'],
    [/:ring:/g, 'emojify ring'],
    [/:trophy:/g, 'emojify trophy'],
    [/:musical_score:/g, 'emojify musical_score'],
    [/:musical_keyboard:/g, 'emojify musical_keyboard'],
    [/:violin:/g, 'emojify violin'],
    [/:space_invader:/g, 'emojify space_invader'],
    [/:video_game:/g, 'emojify video_game'],
    [/:black_joker:/g, 'emojify black_joker'],
    [/:flower_playing_cards:/g, 'emojify flower_playing_cards'],
    [/:game_die:/g, 'emojify game_die'],
    [/:dart:/g, 'emojify dart'],
    [/:mahjong:/g, 'emojify mahjong'],
    [/:clapper:/g, 'emojify clapper'],
    [/:memo:/g, 'emojify memo'],
    [/:pencil:/g, 'emojify pencil'],
    [/:book:/g, 'emojify book'],
    [/:art:/g, 'emojify art'],
    [/:microphone:/g, 'emojify microphone'],
    [/:headphones:/g, 'emojify headphones'],
    [/:trumpet:/g, 'emojify trumpet'],
    [/:saxophone:/g, 'emojify saxophone'],
    [/:guitar:/g, 'emojify guitar'],
    [/:shoe:/g, 'emojify shoe'],
    [/:sandal:/g, 'emojify sandal'],
    [/:high_heel:/g, 'emojify high_heel'],
    [/:lipstick:/g, 'emojify lipstick'],
    [/:boot:/g, 'emojify boot'],
    [/:shirt:/g, 'emojify shirt'],
    [/:tshirt:/g, 'emojify tshirt'],
    [/:necktie:/g, 'emojify necktie'],
    [/:womans_clothes:/g, 'emojify womans_clothes'],
    [/:dress:/g, 'emojify dress'],
    [/:running_shirt_with_sash:/g, 'emojify running_shirt_with_sash'],
    [/:jeans:/g, 'emojify jeans'],
    [/:kimono:/g, 'emojify kimono'],
    [/:bikini:/g, 'emojify bikini'],
    [/:ribbon:/g, 'emojify ribbon'],
    [/:tophat:/g, 'emojify tophat'],
    [/:crown:/g, 'emojify crown'],
    [/:womans_hat:/g, 'emojify womans_hat'],
    [/:mans_shoe:/g, 'emojify mans_shoe'],
    [/:closed_umbrella:/g, 'emojify closed_umbrella'],
    [/:briefcase:/g, 'emojify briefcase'],
    [/:handbag:/g, 'emojify handbag'],
    [/:pouch:/g, 'emojify pouch'],
    [/:purse:/g, 'emojify purse'],
    [/:eyeglasses:/g, 'emojify eyeglasses'],
    [/:fishing_pole_and_fish:/g, 'emojify fishing_pole_and_fish'],
    [/:coffee:/g, 'emojify coffee'],
    [/:tea:/g, 'emojify tea'],
    [/:sake:/g, 'emojify sake'],
    [/:baby_bottle:/g, 'emojify baby_bottle'],
    [/:beer:/g, 'emojify beer'],
    [/:beers:/g, 'emojify beers'],
    [/:cocktail:/g, 'emojify cocktail'],
    [/:tropical_drink:/g, 'emojify tropical_drink'],
    [/:wine_glass:/g, 'emojify wine_glass'],
    [/:fork_and_knife:/g, 'emojify fork_and_knife'],
    [/:pizza:/g, 'emojify pizza'],
    [/:hamburger:/g, 'emojify hamburger'],
    [/:fries:/g, 'emojify fries'],
    [/:poultry_leg:/g, 'emojify poultry_leg'],
    [/:meat_on_bone:/g, 'emojify meat_on_bone'],
    [/:spaghetti:/g, 'emojify spaghetti'],
    [/:curry:/g, 'emojify curry'],
    [/:fried_shrimp:/g, 'emojify fried_shrimp'],
    [/:bento:/g, 'emojify bento'],
    [/:sushi:/g, 'emojify sushi'],
    [/:fish_cake:/g, 'emojify fish_cake'],
    [/:rice_ball:/g, 'emojify rice_ball'],
    [/:rice_cracker:/g, 'emojify rice_cracker'],
    [/:rice:/g, 'emojify rice'],
    [/:ramen:/g, 'emojify ramen'],
    [/:stew:/g, 'emojify stew'],
    [/:oden:/g, 'emojify oden'],
    [/:dango:/g, 'emojify dango'],
    [/:egg:/g, 'emojify egg'],
    [/:bread:/g, 'emojify bread'],
    [/:doughnut:/g, 'emojify doughnut'],
    [/:custard:/g, 'emojify custard'],
    [/:icecream:/g, 'emojify icecream'],
    [/:ice_cream:/g, 'emojify ice_cream'],
    [/:shaved_ice:/g, 'emojify shaved_ice'],
    [/:birthday:/g, 'emojify birthday'],
    [/:cake:/g, 'emojify cake'],
    [/:cookie:/g, 'emojify cookie'],
    [/:chocolate_bar:/g, 'emojify chocolate_bar'],
    [/:candy:/g, 'emojify candy'],
    [/:lollipop:/g, 'emojify lollipop'],
    [/:honey_pot:/g, 'emojify honey_pot'],
    [/:apple:/g, 'emojify apple'],
    [/:green_apple:/g, 'emojify green_apple'],
    [/:tangerine:/g, 'emojify tangerine'],
    [/:lemon:/g, 'emojify lemon'],
    [/:cherries:/g, 'emojify cherries'],
    [/:grapes:/g, 'emojify grapes'],
    [/:watermelon:/g, 'emojify watermelon'],
    [/:strawberry:/g, 'emojify strawberry'],
    [/:peach:/g, 'emojify peach'],
    [/:melon:/g, 'emojify melon'],
    [/:banana:/g, 'emojify banana'],
    [/:pear:/g, 'emojify pear'],
    [/:pineapple:/g, 'emojify pineapple'],
    [/:sweet_potato:/g, 'emojify sweet_potato'],
    [/:eggplant:/g, 'emojify eggplant'],
    [/:tomato:/g, 'emojify tomato'],
    [/:corn:/g, 'emojify corn']
  ];

  var PLACES = [
    [/:109:/g, 'emojify onezeronine'],
    [/:house:/g, 'emojify house'],
    [/:house_with_garden:/g, 'emojify house_with_garden'],
    [/:school:/g, 'emojify school'],
    [/:office:/g, 'emojify office'],
    [/:post_office:/g, 'emojify post_office'],
    [/:hospital:/g, 'emojify hospital'],
    [/:bank:/g, 'emojify bank'],
    [/:convenience_store:/g, 'emojify convenience_store'],
    [/:love_hotel:/g, 'emojify love_hotel'],
    [/:hotel:/g, 'emojify hotel'],
    [/:wedding:/g, 'emojify wedding'],
    [/:church:/g, 'emojify church'],
    [/:department_store:/g, 'emojify department_store'],
    [/:european_post_office:/g, 'emojify european_post_office'],
    [/:city_sunrise:/g, 'emojify city_sunrise'],
    [/:city_sunset:/g, 'emojify city_sunset'],
    [/:japanese_castle:/g, 'emojify japanese_castle'],
    [/:european_castle:/g, 'emojify european_castle'],
    [/:tent:/g, 'emojify tent'],
    [/:factory:/g, 'emojify factory'],
    [/:tokyo_tower:/g, 'emojify tokyo_tower'],
    [/:japan:/g, 'emojify japan'],
    [/:mount_fuji:/g, 'emojify mount_fuji'],
    [/:sunrise_over_mountains:/g, 'emojify sunrise_over_mountains'],
    [/:sunrise:/g, 'emojify sunrise'],
    [/:stars:/g, 'emojify stars'],
    [/:statue_of_liberty:/g, 'emojify statue_of_liberty'],
    [/:bridge_at_night:/g, 'emojify bridge_at_night'],
    [/:carousel_horse:/g, 'emojify carousel_horse'],
    [/:rainbow:/g, 'emojify rainbow'],
    [/:ferris_wheel:/g, 'emojify ferris_wheel'],
    [/:fountain:/g, 'emojify fountain'],
    [/:roller_coaster:/g, 'emojify roller_coaster'],
    [/:ship:/g, 'emojify ship'],
    [/:speedboat:/g, 'emojify speedboat'],
    [/:boat:/g, 'emojify boat'],
    [/:sailboat:/g, 'emojify sailboat'],
    [/:rowboat:/g, 'emojify rowboat'],
    [/:anchor:/g, 'emojify anchor'],
    [/:rocket:/g, 'emojify rocket'],
    [/:airplane:/g, 'emojify airplane'],
    [/:helicopter:/g, 'emojify helicopter'],
    [/:steam_locomotive:/g, 'emojify steam_locomotive'],
    [/:tram:/g, 'emojify tram'],
    [/:mountain_railway:/g, 'emojify mountain_railway'],
    [/:bike:/g, 'emojify bike'],
    [/:aerial_tramway:/g, 'emojify aerial_tramway'],
    [/:suspension_railway:/g, 'emojify suspension_railway'],
    [/:mountain_cableway:/g, 'emojify mountain_cableway'],
    [/:tractor:/g, 'emojify tractor'],
    [/:blue_car:/g, 'emojify blue_car'],
    [/:oncoming_automobile:/g, 'emojify oncoming_automobile'],
    [/:car:/g, 'emojify car'],
    [/:red_car:/g, 'emojify red_car'],
    [/:taxi:/g, 'emojify taxi'],
    [/:oncoming_taxi:/g, 'emojify oncoming_taxi'],
    [/:articulated_lorry:/g, 'emojify articulated_lorry'],
    [/:bus:/g, 'emojify bus'],
    [/:oncoming_bus:/g, 'emojify oncoming_bus'],
    [/:rotating_light:/g, 'emojify rotating_light'],
    [/:police_car:/g, 'emojify police_car'],
    [/:oncoming_police_car:/g, 'emojify oncoming_police_car'],
    [/:fire_engine:/g, 'emojify fire_engine'],
    [/:ambulance:/g, 'emojify ambulance'],
    [/:minibus:/g, 'emojify minibus'],
    [/:truck:/g, 'emojify truck'],
    [/:train:/g, 'emojify train'],
    [/:station:/g, 'emojify station'],
    [/:train2:/g, 'emojify train2'],
    [/:bullettrain_front:/g, 'emojify bullettrain_front'],
    [/:bullettrain_side:/g, 'emojify bullettrain_side'],
    [/:light_rail:/g, 'emojify light_rail'],
    [/:monorail:/g, 'emojify monorail'],
    [/:railway_car:/g, 'emojify railway_car'],
    [/:trolleybus:/g, 'emojify trolleybus'],
    [/:ticket:/g, 'emojify ticket'],
    [/:fuelpump:/g, 'emojify fuelpump'],
    [/:vertical_traffic_light:/g, 'emojify vertical_traffic_light'],
    [/:traffic_light:/g, 'emojify traffic_light'],
    [/:warning:/g, 'emojify warning'],
    [/:construction:/g, 'emojify construction'],
    [/:beginner:/g, 'emojify beginner'],
    [/:atm:/g, 'emojify atm'],
    [/:slot_machine:/g, 'emojify slot_machine'],
    [/:busstop:/g, 'emojify busstop'],
    [/:barber:/g, 'emojify barber'],
    [/:hotsprings:/g, 'emojify hotsprings'],
    [/:checkered_flag:/g, 'emojify checkered_flag'],
    [/:crossed_flags:/g, 'emojify crossed_flags'],
    [/:izakaya_lantern:/g, 'emojify izakaya_lantern'],
    [/:moyai:/g, 'emojify moyai'],
    [/:circus_tent:/g, 'emojify circus_tent'],
    [/:performing_arts:/g, 'emojify performing_arts'],
    [/:round_pushpin:/g, 'emojify round_pushpin'],
    [/:triangular_flag_on_post:/g, 'emojify triangular_flag_on_post'],
    [/:jp:/g, 'emojify jp'],
    [/:kr:/g, 'emojify kr'],
    [/:cn:/g, 'emojify cn'],
    [/:us:/g, 'emojify us'],
    [/:fr:/g, 'emojify fr'],
    [/:es:/g, 'emojify es'],
    [/:it:/g, 'emojify it'],
    [/:ru:/g, 'emojify ru'],
    [/:gb:/g, 'emojify gb'],
    [/:uk:/g, 'emojify uk'],
    [/:de:/g, 'emojify de']
  ];

  var SYMBOLS = [
    [/:one:/g, 'emojify one'],
    [/:two:/g, 'emojify two'],
    [/:three:/g, 'emojify three'],
    [/:four:/g, 'emojify four'],
    [/:five:/g, 'emojify five'],
    [/:six:/g, 'emojify six'],
    [/:seven:/g, 'emojify seven'],
    [/:eight:/g, 'emojify eight'],
    [/:nine:/g, 'emojify nine'],
    [/:keycap_ten:/g, 'emojify keycap_ten'],
    [/:1234:/g, 'emojify onetwothreefour'],
    [/:zero:/g, 'emojify zero'],
    [/:hash:/g, 'emojify hash'],
    [/:symbols:/g, 'emojify symbols'],
    [/:arrow_backward:/g, 'emojify arrow_backward'],
    [/:arrow_down:/g, 'emojify arrow_down'],
    [/:arrow_forward:/g, 'emojify arrow_forward'],
    [/:arrow_left:/g, 'emojify arrow_left'],
    [/:capital_abcd:/g, 'emojify capital_abcd'],
    [/:abcd:/g, 'emojify abcd'],
    [/:abc:/g, 'emojify abc'],
    [/:arrow_lower_left:/g, 'emojify arrow_lower_left'],
    [/:arrow_lower_right:/g, 'emojify arrow_lower_right'],
    [/:arrow_right:/g, 'emojify arrow_right'],
    [/:arrow_up:/g, 'emojify arrow_up'],
    [/:arrow_upper_left:/g, 'emojify arrow_upper_left'],
    [/:arrow_upper_right:/g, 'emojify arrow_upper_right'],
    [/:arrow_double_down:/g, 'emojify arrow_double_down'],
    [/:arrow_double_up:/g, 'emojify arrow_double_up'],
    [/:arrow_down_small:/g, 'emojify arrow_down_small'],
    [/:arrow_heading_down:/g, 'emojify arrow_heading_down'],
    [/:arrow_heading_up:/g, 'emojify arrow_heading_up'],
    [/:leftwards_arrow_with_hook:/g, 'emojify leftwards_arrow_with_hook'],
    [/:arrow_right_hook:/g, 'emojify arrow_right_hook'],
    [/:left_right_arrow:/g, 'emojify left_right_arrow'],
    [/:arrow_up_down:/g, 'emojify arrow_up_down'],
    [/:arrow_up_small:/g, 'emojify arrow_up_small'],
    [/:arrows_clockwise:/g, 'emojify arrows_clockwise'],
    [/:arrows_counterclockwise:/g, 'emojify arrows_counterclockwise'],
    [/:rewind:/g, 'emojify rewind'],
    [/:fast_forward:/g, 'emojify fast_forward'],
    [/:information_source:/g, 'emojify information_source'],
    [/:ok:/g, 'emojify ok'],
    [/:twisted_rightwards_arrows:/g, 'emojify twisted_rightwards_arrows'],
    [/:repeat:/g, 'emojify repeat'],
    [/:repeat_one:/g, 'emojify repeat_one'],
    [/:new:/g, 'emojify new'],
    [/:top:/g, 'emojify top'],
    [/:up:/g, 'emojify up'],
    [/:cool:/g, 'emojify cool'],
    [/:free:/g, 'emojify free'],
    [/:ng:/g, 'emojify ng'],
    [/:cinema:/g, 'emojify cinema'],
    [/:koko:/g, 'emojify koko'],
    [/:signal_strength:/g, 'emojify signal_strength'],
    [/:u5272:/g, 'emojify u5272'],
    [/:u5408:/g, 'emojify u5408'],
    [/:u55b6:/g, 'emojify u55b6'],
    [/:u6307:/g, 'emojify u6307'],
    [/:u6708:/g, 'emojify u6708'],
    [/:u6709:/g, 'emojify u6709'],
    [/:u6e80:/g, 'emojify u6e80'],
    [/:u7121:/g, 'emojify u7121'],
    [/:u7533:/g, 'emojify u7533'],
    [/:u7a7a:/g, 'emojify u7a7a'],
    [/:u7981:/g, 'emojify u7981'],
    [/:sa:/g, 'emojify sa'],
    [/:restroom:/g, 'emojify restroom'],
    [/:mens:/g, 'emojify mens'],
    [/:womens:/g, 'emojify womens'],
    [/:baby_symbol:/g, 'emojify baby_symbol'],
    [/:no_smoking:/g, 'emojify no_smoking'],
    [/:parking:/g, 'emojify parking'],
    [/:wheelchair:/g, 'emojify wheelchair'],
    [/:metro:/g, 'emojify metro'],
    [/:baggage_claim:/g, 'emojify baggage_claim'],
    [/:accept:/g, 'emojify accept'],
    [/:wc:/g, 'emojify wc'],
    [/:potable_water:/g, 'emojify potable_water'],
    [/:put_litter_in_its_place:/g, 'emojify put_litter_in_its_place'],
    [/:secret:/g, 'emojify secret'],
    [/:congratulations:/g, 'emojify congratulations'],
    [/:m:/g, 'emojify m'],
    [/:passport_control:/g, 'emojify passport_control'],
    [/:left_luggage:/g, 'emojify left_luggage'],
    [/:customs:/g, 'emojify customs'],
    [/:ideograph_advantage:/g, 'emojify ideograph_advantage'],
    [/:cl:/g, 'emojify cl'],
    [/:sos:/g, 'emojify sos'],
    [/:id:/g, 'emojify id'],
    [/:no_entry_sign:/g, 'emojify no_entry_sign'],
    [/:underage:/g, 'emojify underage'],
    [/:no_mobile_phones:/g, 'emojify no_mobile_phones'],
    [/:do_not_litter:/g, 'emojify do_not_litter'],
    [/:non-potable_water:/g, 'emojify non-potable_water'],
    [/:no_bicycles:/g, 'emojify no_bicycles'],
    [/:no_pedestrians:/g, 'emojify no_pedestrians'],
    [/:children_crossing:/g, 'emojify children_crossing'],
    [/:no_entry:/g, 'emojify no_entry'],
    [/:eight_spoked_asterisk:/g, 'emojify eight_spoked_asterisk'],
    [/:eight_pointed_black_star:/g, 'emojify eight_pointed_black_star'],
    [/:heart_decoration:/g, 'emojify heart_decoration'],
    [/:vs:/g, 'emojify vs'],
    [/:vibration_mode:/g, 'emojify vibration_mode'],
    [/:mobile_phone_off:/g, 'emojify mobile_phone_off'],
    [/:chart:/g, 'emojify chart'],
    [/:currency_exchange:/g, 'emojify currency_exchange'],
    [/:aries:/g, 'emojify aries'],
    [/:taurus:/g, 'emojify taurus'],
    [/:gemini:/g, 'emojify gemini'],
    [/:cancer:/g, 'emojify cancer'],
    [/:leo:/g, 'emojify leo'],
    [/:virgo:/g, 'emojify virgo'],
    [/:libra:/g, 'emojify libra'],
    [/:scorpius:/g, 'emojify scorpius'],
    [/:sagittarius:/g, 'emojify sagittarius'],
    [/:capricorn:/g, 'emojify capricorn'],
    [/:aquarius:/g, 'emojify aquarius'],
    [/:pisces:/g, 'emojify pisces'],
    [/:ophiuchus:/g, 'emojify ophiuchus'],
    [/:six_pointed_star:/g, 'emojify six_pointed_star'],
    [/:negative_squared_cross_mark:/g, 'emojify negative_squared_cross_mark'],
    [/:a:/g, 'emojify a'],
    [/:b:/g, 'emojify b'],
    [/:ab:/g, 'emojify ab'],
    [/:o2:/g, 'emojify o2'],
    [/:diamond_shape_with_a_dot_inside:/g, 'emojify diamond_shape_with_a_dot_inside'],
    [/:recycle:/g, 'emojify recycle'],
    [/:end:/g, 'emojify end'],
    [/:on:/g, 'emojify on'],
    [/:soon:/g, 'emojify soon'],
    [/:clock1:/g, 'emojify clock1'],
    [/:clock130:/g, 'emojify clock130'],
    [/:clock10:/g, 'emojify clock10'],
    [/:clock1030:/g, 'emojify clock1030'],
    [/:clock11:/g, 'emojify clock11'],
    [/:clock1130:/g, 'emojify clock1130'],
    [/:clock12:/g, 'emojify clock12'],
    [/:clock1230:/g, 'emojify clock1230'],
    [/:clock2:/g, 'emojify clock2'],
    [/:clock230:/g, 'emojify clock230'],
    [/:clock3:/g, 'emojify clock3'],
    [/:clock330:/g, 'emojify clock330'],
    [/:clock4:/g, 'emojify clock4'],
    [/:clock430:/g, 'emojify clock430'],
    [/:clock5:/g, 'emojify clock5'],
    [/:clock530:/g, 'emojify clock530'],
    [/:clock6:/g, 'emojify clock6'],
    [/:clock630:/g, 'emojify clock630'],
    [/:clock7:/g, 'emojify clock7'],
    [/:clock730:/g, 'emojify clock730'],
    [/:clock8:/g, 'emojify clock8'],
    [/:clock830:/g, 'emojify clock830'],
    [/:clock9:/g, 'emojify clock9'],
    [/:clock930:/g, 'emojify clock930'],
    [/:heavy_dollar_sign:/g, 'emojify heavy_dollar_sign'],
    [/:copyright:/g, 'emojify copyright'],
    [/:registered:/g, 'emojify registered'],
    [/:tm:/g, 'emojify tm'],
    [/:x:/g, 'emojify x'],
    [/:heavy_exclamation_mark:/g, 'emojify heavy_exclamation_mark'],
    [/:bangbang:/g, 'emojify bangbang'],
    [/:interrobang:/g, 'emojify interrobang'],
    [/:o:/g, 'emojify o'],
    [/:heavy_multiplication_x:/g, 'emojify heavy_multiplication_x'],
    [/:heavy_plus_sign:/g, 'emojify heavy_plus_sign'],
    [/:heavy_minus_sign:/g, 'emojify heavy_minus_sign'],
    [/:heavy_division_sign:/g, 'emojify heavy_division_sign'],
    [/:white_flower:/g, 'emojify white_flower'],
    [/:100:/g, 'emojify onehundred'],
    [/:heavy_check_mark:/g, 'emojify heavy_check_mark'],
    [/:ballot_box_with_check:/g, 'emojify ballot_box_with_check'],
    [/:radio_button:/g, 'emojify radio_button'],
    [/:link:/g, 'emojify link'],
    [/:curly_loop:/g, 'emojify curly_loop'],
    [/:wavy_dash:/g, 'emojify wavy_dash'],
    [/:part_alternation_mark:/g, 'emojify part_alternation_mark'],
    [/:trident:/g, 'emojify trident'],
    [/:black_square:/g, 'emojify black_square'],
    [/:white_square:/g, 'emojify white_square'],
    [/:white_check_mark:/g, 'emojify white_check_mark'],
    [/:black_square_button:/g, 'emojify black_square_button'],
    [/:white_square_button:/g, 'emojify white_square_button'],
    [/:black_circle:/g, 'emojify black_circle'],
    [/:white_circle:/g, 'emojify white_circle'],
    [/:red_circle:/g, 'emojify red_circle'],
    [/:large_blue_circle:/g, 'emojify large_blue_circle'],
    [/:large_blue_diamond:/g, 'emojify large_blue_diamond'],
    [/:large_orange_diamond:/g, 'emojify large_orange_diamond'],
    [/:small_blue_diamond:/g, 'emojify small_blue_diamond'],
    [/:small_orange_diamond:/g, 'emojify small_orange_diamond'],
    [/:small_red_triangle:/g, 'emojify small_red_triangle'],
    [/:small_red_triangle_down:/g, 'emojify small_red_triangle_down'],
    [/:shipit:/g, 'emojify shipit']
  ];
})(this);

angular.module("ui.bootstrap", ["ui.bootstrap.tabs"]);

/**
 * @ngdoc overview
 * @name ui.bootstrap.tabs
 *
 * @description
 * AngularJS version of the tabs directive.
 */

angular.module('ui.bootstrap.tabs', [])

.directive('tabs', function() {
  return function() {
    throw new Error("The `tabs` directive is deprecated, please migrate to `tabset`. Instructions can be found at http://github.com/angular-ui/bootstrap/tree/master/CHANGELOG.md");
  };
})

.controller('TabsetController', ['$scope', '$element', 
function TabsetCtrl($scope, $element) {
  var ctrl = this,
    tabs = ctrl.tabs = $scope.tabs = [];

  ctrl.select = function(tab) {
    angular.forEach(tabs, function(tab) {
      tab.active = false;
    });  
    tab.active = true;
  };

  ctrl.addTab = function addTab(tab) {
    tabs.push(tab);
    if (tabs.length == 1) {
      ctrl.select(tab);
    }
  };

  ctrl.removeTab = function removeTab(tab) { 
    var index = tabs.indexOf(tab);
    //Select a new tab if the tab to be removed is selected
    if (tab.active && tabs.length > 1) {
      //If this is the last tab, select the previous tab. else, the next tab.
      var newActiveIndex = index == tabs.length - 1 ? index - 1 : index + 1;
      ctrl.select(tabs[newActiveIndex]);
    }
    tabs.splice(index, 1);
  };
}])

/**
 * @ngdoc directive
 * @name ui.bootstrap.tabs.directive:tabset
 * @restrict EA
 *
 * @description
 * Tabset is the outer container for the tabs directive
 *
 * @param {boolean=} vertical Whether or not to use vertical styling for the tabs.
 *
 * @example
<example module="ui.bootstrap">
  <file name="index.html">
    <tabset>
      <tab heading="Vertical Tab 1"><b>First</b> Content!</tab>
      <tab heading="Vertical Tab 2"><i>Second</i> Content!</tab>
    </tabset>
    <hr />
    <tabset vertical="true">
      <tab heading="Vertical Tab 1"><b>First</b> Vertical Content!</tab>
      <tab heading="Vertical Tab 2"><i>Second</i> Vertical Content!</tab>
    </tabset>
  </file>
</example>
 */
.directive('tabset', function() {
  return {
    restrict: 'EA',
    transclude: true,
    scope: {},
    controller: 'TabsetController',
    templateUrl: 'template/tabs/tabset.html',
    link: function(scope, element, attrs) {
      scope.vertical = angular.isDefined(attrs.vertical) ? scope.$eval(attrs.vertical) : false;
      scope.type = angular.isDefined(attrs.type) ? scope.$parent.$eval(attrs.type) : 'tabs';
    }
  };
})

/**
 * @ngdoc directive
 * @name ui.bootstrap.tabs.directive:tab
 * @restrict EA
 *
 * @param {string=} heading The visible heading, or title, of the tab. Set HTML headings with {@link ui.bootstrap.tabs.directive:tabHeading tabHeading}.
 * @param {string=} select An expression to evaluate when the tab is selected.
 * @param {boolean=} active A binding, telling whether or not this tab is selected.
 * @param {boolean=} disabled A binding, telling whether or not this tab is disabled.
 *
 * @description 
 * Creates a tab with a heading and content. Must be placed within a {@link ui.bootstrap.tabs.directive:tabset tabset}.
 *
 * @example
<example module="ui.bootstrap">
  <file name="index.html">
    <div ng-controller="TabsDemoCtrl">
      <button class="btn btn-small" ng-click="items[0].active = true">
        Select item 1, using active binding
      </button>
      <button class="btn btn-small" ng-click="items[1].disabled = !items[1].disabled">
        Enable/disable item 2, using disabled binding
      </button>
      <br />
      <tabset>
        <tab heading="Tab 1">First Tab</tab>
        <tab select="alertMe()">
          <tab-heading><i class="icon-bell"></i> Alert me!</tab-heading>
          Second Tab, with alert callback and html heading!
        </tab>
        <tab ng-repeat="item in items"
          heading="{{item.title}}"
          disabled="item.disabled"
          active="item.active">
          {{item.content}}
        </tab>
      </tabset>
    </div>
  </file>
  <file name="script.js">
    function TabsDemoCtrl($scope) {
      $scope.items = [
        { title:"Dynamic Title 1", content:"Dynamic Item 0" },
        { title:"Dynamic Title 2", content:"Dynamic Item 1", disabled: true }
      ];

      $scope.alertMe = function() {
        setTimeout(function() {
          alert("You've selected the alert tab!");
        });
      };
    };
  </file>
</example>
 */

/**
 * @ngdoc directive
 * @name ui.bootstrap.tabs.directive:tabHeading
 * @restrict EA
 *
 * @description
 * Creates an HTML heading for a {@link ui.bootstrap.tabs.directive:tab tab}. Must be placed as a child of a tab element.
 *
 * @example
<example module="ui.bootstrap">
  <file name="index.html">
    <tabset>
      <tab>
        <tab-heading><b>HTML</b> in my titles?!</tab-heading>
        And some content, too!
      </tab>
      <tab>
        <tab-heading><i class="icon-heart"></i> Icon heading?!?</tab-heading>
        That's right.
      </tab>
    </tabset>
  </file>
</example>
 */
.directive('tab', ['$parse', '$http', '$templateCache', '$compile',
function($parse, $http, $templateCache, $compile) {
  return {
    require: '^tabset',
    restrict: 'EA',
    replace: true,
    templateUrl: 'template/tabs/tab.html',
    transclude: true,
    scope: {
      heading: '@',
      onSelect: '&select' //This callback is called in contentHeadingTransclude
                          //once it inserts the tab's content into the dom
    },
    controller: function() {
      //Empty controller so other directives can require being 'under' a tab
    },
    compile: function(elm, attrs, transclude) {
      return function postLink(scope, elm, attrs, tabsetCtrl) {
        var getActive, setActive;
        scope.active = false; // default value
        if (attrs.active) {
          getActive = $parse(attrs.active);
          setActive = getActive.assign;
          scope.$parent.$watch(getActive, function updateActive(value) {
            if ( !!value && scope.disabled ) {
              setActive(scope.$parent, false); // Prevent active assignment
            } else {
              scope.active = !!value;
            }
          });
        } else {
          setActive = getActive = angular.noop;
        }

        scope.$watch('active', function(active) {
          setActive(scope.$parent, active);
          if (active) {
            tabsetCtrl.select(scope);
            scope.onSelect();
          }
        });

        scope.disabled = false;
        if ( attrs.disabled ) {
          scope.$parent.$watch($parse(attrs.disabled), function(value) {
            scope.disabled = !! value;
          });
        }

        scope.select = function() {
          if ( ! scope.disabled ) {
            scope.active = true;
          }
        };

        tabsetCtrl.addTab(scope);
        scope.$on('$destroy', function() {
          tabsetCtrl.removeTab(scope);
        });
        //If the tabset sets this tab to active, set the parent scope's active
        //binding too.  We do this so the watch for the parent's initial active
        //value won't overwrite what is initially set by the tabset
        if (scope.active) {
          setActive(scope.$parent, true);
        } 

        //Transclude the collection of sibling elements. Use forEach to find
        //the heading if it exists. We don't use a directive for tab-heading
        //because it is problematic. Discussion @ http://git.io/MSNPwQ
        transclude(scope.$parent, function(clone) {
          //Look at every element in the clone collection. If it's tab-heading,
          //mark it as that.  If it's not tab-heading, mark it as tab contents
          var contents = [], heading;
          angular.forEach(clone, function(el) {
            //See if it's a tab-heading attr or element directive
            //First make sure it's a normal element, one that has a tagName
            if (el.tagName &&
                (el.hasAttribute("tab-heading") || 
                 el.hasAttribute("data-tab-heading") ||
                 el.tagName.toLowerCase() == "tab-heading" ||
                 el.tagName.toLowerCase() == "data-tab-heading"
                )) {
              heading = el;
            } else {
              contents.push(el);
            }
          });
          //Share what we found on the scope, so our tabHeadingTransclude and
          //tabContentTransclude directives can find out what the heading and
          //contents are.
          if (heading) { 
            scope.headingElement = angular.element(heading);
          }
          scope.contentElement = angular.element(contents);
        });
      };
    }
  };
}])

.directive('tabHeadingTransclude', [function() {
  return {
    restrict: 'A',
    require: '^tab', 
    link: function(scope, elm, attrs, tabCtrl) {
      scope.$watch('headingElement', function updateHeadingElement(heading) {
        if (heading) {
          elm.html('');
          elm.append(heading);
        }
      });
    }
  };
}])

.directive('tabContentTransclude', ['$parse', function($parse) {
  return {
    restrict: 'A',
    require: '^tabset',
    link: function(scope, elm, attrs, tabsetCtrl) {
      scope.$watch($parse(attrs.tabContentTransclude), function(tab) {
        elm.html('');
        if (tab) {
          elm.append(tab.contentElement);
        }
      });
    }
  };
}])

;


angular.module("ui.bootstrap", ["ui.bootstrap.tpls", "ui.bootstrap.tabs"]);
angular.module("ui.bootstrap.tpls", ["template/tabs/tab.html","template/tabs/tabset.html"]);

/**
 * @ngdoc overview
 * @name ui.bootstrap.tabs
 *
 * @description
 * AngularJS version of the tabs directive.
 */

angular.module('ui.bootstrap.tabs', [])

.directive('tabs', function() {
  return function() {
    throw new Error("The `tabs` directive is deprecated, please migrate to `tabset`. Instructions can be found at http://github.com/angular-ui/bootstrap/tree/master/CHANGELOG.md");
  };
})

.controller('TabsetController', ['$scope', '$element', 
function TabsetCtrl($scope, $element) {
  var ctrl = this,
    tabs = ctrl.tabs = $scope.tabs = [];

  ctrl.select = function(tab) {
    angular.forEach(tabs, function(tab) {
      tab.active = false;
    });  
    tab.active = true;
  };

  ctrl.addTab = function addTab(tab) {
    tabs.push(tab);
    if (tabs.length == 1) {
      ctrl.select(tab);
    }
  };

  ctrl.removeTab = function removeTab(tab) { 
    var index = tabs.indexOf(tab);
    //Select a new tab if the tab to be removed is selected
    if (tab.active && tabs.length > 1) {
      //If this is the last tab, select the previous tab. else, the next tab.
      var newActiveIndex = index == tabs.length - 1 ? index - 1 : index + 1;
      ctrl.select(tabs[newActiveIndex]);
    }
    tabs.splice(index, 1);
  };
}])

/**
 * @ngdoc directive
 * @name ui.bootstrap.tabs.directive:tabset
 * @restrict EA
 *
 * @description
 * Tabset is the outer container for the tabs directive
 *
 * @param {boolean=} vertical Whether or not to use vertical styling for the tabs.
 *
 * @example
<example module="ui.bootstrap">
  <file name="index.html">
    <tabset>
      <tab heading="Vertical Tab 1"><b>First</b> Content!</tab>
      <tab heading="Vertical Tab 2"><i>Second</i> Content!</tab>
    </tabset>
    <hr />
    <tabset vertical="true">
      <tab heading="Vertical Tab 1"><b>First</b> Vertical Content!</tab>
      <tab heading="Vertical Tab 2"><i>Second</i> Vertical Content!</tab>
    </tabset>
  </file>
</example>
 */
.directive('tabset', function() {
  return {
    restrict: 'EA',
    transclude: true,
    scope: {},
    controller: 'TabsetController',
    templateUrl: 'template/tabs/tabset.html',
    link: function(scope, element, attrs) {
      scope.vertical = angular.isDefined(attrs.vertical) ? scope.$eval(attrs.vertical) : false;
      scope.type = angular.isDefined(attrs.type) ? scope.$parent.$eval(attrs.type) : 'tabs';
    }
  };
})

/**
 * @ngdoc directive
 * @name ui.bootstrap.tabs.directive:tab
 * @restrict EA
 *
 * @param {string=} heading The visible heading, or title, of the tab. Set HTML headings with {@link ui.bootstrap.tabs.directive:tabHeading tabHeading}.
 * @param {string=} select An expression to evaluate when the tab is selected.
 * @param {boolean=} active A binding, telling whether or not this tab is selected.
 * @param {boolean=} disabled A binding, telling whether or not this tab is disabled.
 *
 * @description 
 * Creates a tab with a heading and content. Must be placed within a {@link ui.bootstrap.tabs.directive:tabset tabset}.
 *
 * @example
<example module="ui.bootstrap">
  <file name="index.html">
    <div ng-controller="TabsDemoCtrl">
      <button class="btn btn-small" ng-click="items[0].active = true">
        Select item 1, using active binding
      </button>
      <button class="btn btn-small" ng-click="items[1].disabled = !items[1].disabled">
        Enable/disable item 2, using disabled binding
      </button>
      <br />
      <tabset>
        <tab heading="Tab 1">First Tab</tab>
        <tab select="alertMe()">
          <tab-heading><i class="icon-bell"></i> Alert me!</tab-heading>
          Second Tab, with alert callback and html heading!
        </tab>
        <tab ng-repeat="item in items"
          heading="{{item.title}}"
          disabled="item.disabled"
          active="item.active">
          {{item.content}}
        </tab>
      </tabset>
    </div>
  </file>
  <file name="script.js">
    function TabsDemoCtrl($scope) {
      $scope.items = [
        { title:"Dynamic Title 1", content:"Dynamic Item 0" },
        { title:"Dynamic Title 2", content:"Dynamic Item 1", disabled: true }
      ];

      $scope.alertMe = function() {
        setTimeout(function() {
          alert("You've selected the alert tab!");
        });
      };
    };
  </file>
</example>
 */

/**
 * @ngdoc directive
 * @name ui.bootstrap.tabs.directive:tabHeading
 * @restrict EA
 *
 * @description
 * Creates an HTML heading for a {@link ui.bootstrap.tabs.directive:tab tab}. Must be placed as a child of a tab element.
 *
 * @example
<example module="ui.bootstrap">
  <file name="index.html">
    <tabset>
      <tab>
        <tab-heading><b>HTML</b> in my titles?!</tab-heading>
        And some content, too!
      </tab>
      <tab>
        <tab-heading><i class="icon-heart"></i> Icon heading?!?</tab-heading>
        That's right.
      </tab>
    </tabset>
  </file>
</example>
 */
.directive('tab', ['$parse', '$http', '$templateCache', '$compile',
function($parse, $http, $templateCache, $compile) {
  return {
    require: '^tabset',
    restrict: 'EA',
    replace: true,
    templateUrl: 'template/tabs/tab.html',
    transclude: true,
    scope: {
      heading: '@',
      onSelect: '&select' //This callback is called in contentHeadingTransclude
                          //once it inserts the tab's content into the dom
    },
    controller: function() {
      //Empty controller so other directives can require being 'under' a tab
    },
    compile: function(elm, attrs, transclude) {
      return function postLink(scope, elm, attrs, tabsetCtrl) {
        var getActive, setActive;
        scope.active = false; // default value
        if (attrs.active) {
          getActive = $parse(attrs.active);
          setActive = getActive.assign;
          scope.$parent.$watch(getActive, function updateActive(value) {
            if ( !!value && scope.disabled ) {
              setActive(scope.$parent, false); // Prevent active assignment
            } else {
              scope.active = !!value;
            }
          });
        } else {
          setActive = getActive = angular.noop;
        }

        scope.$watch('active', function(active) {
          setActive(scope.$parent, active);
          if (active) {
            tabsetCtrl.select(scope);
            scope.onSelect();
          }
        });

        scope.disabled = false;
        if ( attrs.disabled ) {
          scope.$parent.$watch($parse(attrs.disabled), function(value) {
            scope.disabled = !! value;
          });
        }

        scope.select = function() {
          if ( ! scope.disabled ) {
            scope.active = true;
          }
        };

        tabsetCtrl.addTab(scope);
        scope.$on('$destroy', function() {
          tabsetCtrl.removeTab(scope);
        });
        //If the tabset sets this tab to active, set the parent scope's active
        //binding too.  We do this so the watch for the parent's initial active
        //value won't overwrite what is initially set by the tabset
        if (scope.active) {
          setActive(scope.$parent, true);
        } 

        //Transclude the collection of sibling elements. Use forEach to find
        //the heading if it exists. We don't use a directive for tab-heading
        //because it is problematic. Discussion @ http://git.io/MSNPwQ
        transclude(scope.$parent, function(clone) {
          //Look at every element in the clone collection. If it's tab-heading,
          //mark it as that.  If it's not tab-heading, mark it as tab contents
          var contents = [], heading;
          angular.forEach(clone, function(el) {
            //See if it's a tab-heading attr or element directive
            //First make sure it's a normal element, one that has a tagName
            if (el.tagName &&
                (el.hasAttribute("tab-heading") || 
                 el.hasAttribute("data-tab-heading") ||
                 el.tagName.toLowerCase() == "tab-heading" ||
                 el.tagName.toLowerCase() == "data-tab-heading"
                )) {
              heading = el;
            } else {
              contents.push(el);
            }
          });
          //Share what we found on the scope, so our tabHeadingTransclude and
          //tabContentTransclude directives can find out what the heading and
          //contents are.
          if (heading) { 
            scope.headingElement = angular.element(heading);
          }
          scope.contentElement = angular.element(contents);
        });
      };
    }
  };
}])

.directive('tabHeadingTransclude', [function() {
  return {
    restrict: 'A',
    require: '^tab', 
    link: function(scope, elm, attrs, tabCtrl) {
      scope.$watch('headingElement', function updateHeadingElement(heading) {
        if (heading) {
          elm.html('');
          elm.append(heading);
        }
      });
    }
  };
}])

.directive('tabContentTransclude', ['$parse', function($parse) {
  return {
    restrict: 'A',
    require: '^tabset',
    link: function(scope, elm, attrs, tabsetCtrl) {
      scope.$watch($parse(attrs.tabContentTransclude), function(tab) {
        elm.html('');
        if (tab) {
          elm.append(tab.contentElement);
        }
      });
    }
  };
}])

;


angular.module("template/tabs/pane.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("template/tabs/pane.html",
    "<div class=\"tab-pane\" ng-class=\"{active: selected}\" ng-show=\"selected\" ng-transclude></div>\n" +
    "");
}]);

angular.module("template/tabs/tab.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("template/tabs/tab.html",
    "<li ng-class=\"{active: active, disabled: disabled}\">\n" +
    "  <a ng-click=\"select()\" tab-heading-transclude>{{heading}}</a>\n" +
    "</li>\n" +
    "");
}]);

angular.module("template/tabs/tabs.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("template/tabs/tabs.html",
    "<div class=\"tabbable\">\n" +
    "  <ul class=\"nav nav-tabs\">\n" +
    "    <li ng-repeat=\"pane in panes\" ng-class=\"{active:pane.selected}\">\n" +
    "      <a ng-click=\"select(pane)\">{{pane.heading}}</a>\n" +
    "    </li>\n" +
    "  </ul>\n" +
    "  <div class=\"tab-content\" ng-transclude></div>\n" +
    "</div>\n" +
    "");
}]);

angular.module("template/tabs/tabset.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("template/tabs/tabset.html",
    "\n" +
    "<div class=\"tabbable\">\n" +
    "  <ul class=\"nav {{type && 'nav-' + type}}\" ng-class=\"{'nav-stacked': vertical}\" ng-transclude>\n" +
    "  </ul>\n" +
    "  <div class=\"tab-content\">\n" +
    "    <div class=\"tab-pane\" \n" +
    "         ng-repeat=\"tab in tabs\" \n" +
    "         ng-class=\"{active: tab.active}\"\n" +
    "         tab-content-transclude=\"tab\" tt=\"tab\">\n" +
    "    </div>\n" +
    "  </div>\n" +
    "</div>\n" +
    "");
}]);

/* 
* zClip :: jQuery ZeroClipboard v1.1.1
 * http://steamdev.com/zclip
 *
 * Copyright 2011, SteamDev
 * Released under the MIT license.
 * http://www.opensource.org/licenses/mit-license.php
 *
 * Date: Wed Jun 01, 2011
 */

(function(a){a.fn.zclip=function(c){if(typeof c=="object"&&!c.length){var b=a.extend({path:"ZeroClipboard.swf",copy:null,beforeCopy:null,afterCopy:null,clickAfter:true,setHandCursor:true,setCSSEffects:true},c);return this.each(function(){var e=a(this);if(e.is(":visible")&&(typeof b.copy=="string"||a.isFunction(b.copy))){ZeroClipboard.setMoviePath(b.path);var d=new ZeroClipboard.Client();if(a.isFunction(b.copy)){e.bind("zClip_copy",b.copy)}if(a.isFunction(b.beforeCopy)){e.bind("zClip_beforeCopy",b.beforeCopy)}if(a.isFunction(b.afterCopy)){e.bind("zClip_afterCopy",b.afterCopy)}d.setHandCursor(b.setHandCursor);d.setCSSEffects(b.setCSSEffects);d.addEventListener("mouseOver",function(f){e.trigger("mouseenter")});d.addEventListener("mouseOut",function(f){e.trigger("mouseleave")});d.addEventListener("mouseDown",function(f){e.trigger("mousedown");if(!a.isFunction(b.copy)){d.setText(b.copy)}else{d.setText(e.triggerHandler("zClip_copy"))}if(a.isFunction(b.beforeCopy)){e.trigger("zClip_beforeCopy")}});d.addEventListener("complete",function(f,g){if(a.isFunction(b.afterCopy)){e.trigger("zClip_afterCopy")}else{if(g.length>500){g=g.substr(0,500)+"...\n\n("+(g.length-500)+" characters not shown)"}e.removeClass("hover");alert("Copied text to clipboard:\n\n "+g)}if(b.clickAfter){e.trigger("click")}});d.glue(e[0],e.parent()[0]);a(window).bind("load resize",function(){d.reposition()})}})}else{if(typeof c=="string"){return this.each(function(){var f=a(this);c=c.toLowerCase();var e=f.data("zclipId");var d=a("#"+e+".zclip");if(c=="remove"){d.remove();f.removeClass("active hover")}else{if(c=="hide"){d.hide();f.removeClass("active hover")}else{if(c=="show"){d.show()}}}})}}}})(jQuery);var ZeroClipboard={version:"1.0.7",clients:{},moviePath:"ZeroClipboard.swf",nextId:1,$:function(a){if(typeof(a)=="string"){a=document.getElementById(a)}if(!a.addClass){a.hide=function(){this.style.display="none"};a.show=function(){this.style.display=""};a.addClass=function(b){this.removeClass(b);this.className+=" "+b};a.removeClass=function(d){var e=this.className.split(/\s+/);var b=-1;for(var c=0;c<e.length;c++){if(e[c]==d){b=c;c=e.length}}if(b>-1){e.splice(b,1);this.className=e.join(" ")}return this};a.hasClass=function(b){return !!this.className.match(new RegExp("\\s*"+b+"\\s*"))}}return a},setMoviePath:function(a){this.moviePath=a},dispatch:function(d,b,c){var a=this.clients[d];if(a){a.receiveEvent(b,c)}},register:function(b,a){this.clients[b]=a},getDOMObjectPosition:function(c,a){var b={left:0,top:0,width:c.width?c.width:c.offsetWidth,height:c.height?c.height:c.offsetHeight};if(c&&(c!=a)){b.left+=c.offsetLeft;b.top+=c.offsetTop}return b},Client:function(a){this.handlers={};this.id=ZeroClipboard.nextId++;this.movieId="ZeroClipboardMovie_"+this.id;ZeroClipboard.register(this.id,this);if(a){this.glue(a)}}};ZeroClipboard.Client.prototype={id:0,ready:false,movie:null,clipText:"",handCursorEnabled:true,cssEffects:true,handlers:null,glue:function(d,b,e){this.domElement=ZeroClipboard.$(d);var f=99;if(this.domElement.style.zIndex){f=parseInt(this.domElement.style.zIndex,10)+1}if(typeof(b)=="string"){b=ZeroClipboard.$(b)}else{if(typeof(b)=="undefined"){b=document.getElementsByTagName("body")[0]}}var c=ZeroClipboard.getDOMObjectPosition(this.domElement,b);this.div=document.createElement("div");this.div.className="zclip";this.div.id="zclip-"+this.movieId;$(this.domElement).data("zclipId","zclip-"+this.movieId);var a=this.div.style;a.position="absolute";a.left=""+c.left+"px";a.top=""+c.top+"px";a.width=""+c.width+"px";a.height=""+c.height+"px";a.zIndex=f;if(typeof(e)=="object"){for(addedStyle in e){a[addedStyle]=e[addedStyle]}}b.appendChild(this.div);this.div.innerHTML=this.getHTML(c.width,c.height)},getHTML:function(d,a){var c="";var b="id="+this.id+"&width="+d+"&height="+a;if(navigator.userAgent.match(/MSIE/)){var e=location.href.match(/^https/i)?"https://":"http://";c+='<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="'+e+'download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0" width="'+d+'" height="'+a+'" id="'+this.movieId+'" align="middle"><param name="allowScriptAccess" value="always" /><param name="allowFullScreen" value="false" /><param name="movie" value="'+ZeroClipboard.moviePath+'" /><param name="loop" value="false" /><param name="menu" value="false" /><param name="quality" value="best" /><param name="bgcolor" value="#ffffff" /><param name="flashvars" value="'+b+'"/><param name="wmode" value="transparent"/></object>'}else{c+='<embed id="'+this.movieId+'" src="'+ZeroClipboard.moviePath+'" loop="false" menu="false" quality="best" bgcolor="#ffffff" width="'+d+'" height="'+a+'" name="'+this.movieId+'" align="middle" allowScriptAccess="always" allowFullScreen="false" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" flashvars="'+b+'" wmode="transparent" />'}return c},hide:function(){if(this.div){this.div.style.left="-2000px"}},show:function(){this.reposition()},destroy:function(){if(this.domElement&&this.div){this.hide();this.div.innerHTML="";var a=document.getElementsByTagName("body")[0];try{a.removeChild(this.div)}catch(b){}this.domElement=null;this.div=null}},reposition:function(c){if(c){this.domElement=ZeroClipboard.$(c);if(!this.domElement){this.hide()}}if(this.domElement&&this.div){var b=ZeroClipboard.getDOMObjectPosition(this.domElement);var a=this.div.style;a.left=""+b.left+"px";a.top=""+b.top+"px"}},setText:function(a){this.clipText=a;if(this.ready){this.movie.setText(a)}},addEventListener:function(a,b){a=a.toString().toLowerCase().replace(/^on/,"");if(!this.handlers[a]){this.handlers[a]=[]}this.handlers[a].push(b)},setHandCursor:function(a){this.handCursorEnabled=a;if(this.ready){this.movie.setHandCursor(a)}},setCSSEffects:function(a){this.cssEffects=!!a},receiveEvent:function(d,f){d=d.toString().toLowerCase().replace(/^on/,"");switch(d){case"load":this.movie=document.getElementById(this.movieId);if(!this.movie){var c=this;setTimeout(function(){c.receiveEvent("load",null)},1);return}if(!this.ready&&navigator.userAgent.match(/Firefox/)&&navigator.userAgent.match(/Windows/)){var c=this;setTimeout(function(){c.receiveEvent("load",null)},100);this.ready=true;return}this.ready=true;try{this.movie.setText(this.clipText)}catch(h){}try{this.movie.setHandCursor(this.handCursorEnabled)}catch(h){}break;case"mouseover":if(this.domElement&&this.cssEffects){this.domElement.addClass("hover");if(this.recoverActive){this.domElement.addClass("active")}}break;case"mouseout":if(this.domElement&&this.cssEffects){this.recoverActive=false;if(this.domElement.hasClass("active")){this.domElement.removeClass("active");this.recoverActive=true}this.domElement.removeClass("hover")}break;case"mousedown":if(this.domElement&&this.cssEffects){this.domElement.addClass("active")}break;case"mouseup":if(this.domElement&&this.cssEffects){this.domElement.removeClass("active");this.recoverActive=false}break}if(this.handlers[d]){for(var b=0,a=this.handlers[d].length;b<a;b++){var g=this.handlers[d][b];if(typeof(g)=="function"){g(this,f)}else{if((typeof(g)=="object")&&(g.length==2)){g[0][g[1]](this,f)}else{if(typeof(g)=="string"){window[g](this,f)}}}}}}};

window.exercism = {
  collections: {},
  views: {},
  models: {},
  routers: {}
};

$(document).ready(function() {
  $("a#copy-code").on('click', function (e) {
    e.preventDefault();
  }).each(function () {
    $(this).zclip({
      path: 'http://www.steamdev.com/zclip/js/ZeroClipboard.swf',
    copy: $("#submission-code").text(),
    afterCopy: function() {
      alert("The submission code was successfully copied to your clipboard!");
    }
    });
  });
});

$(function () {
  if ($('#nitstat-chart').length !== 0) {

    var stats = $('#nitstat-chart').data('stats');

    var data = {
       labels : stats.labels,
       datasets : [
         {
           fillColor : "rgba(151,187,205,0.5)",
           strokeColor : "rgba(151,187,205,1)",
           pointColor : "rgba(151,187,205,1)",
           pointStrokeColor : "#fff",
           data : stats.given
         },
         {
           fillColor : "rgba(220,220,220,0.5)",
           strokeColor : "rgba(220,220,220,1)",
           pointColor : "rgba(220,220,220,1)",
           pointStrokeColor : "#fff",
           data : stats.received
         }
       ]
    };
    var ctx = $("#nitstat-chart").get(0).getContext("2d");
    new Chart(ctx).Line(data, {
      scaleOverride : true,
      scaleSteps : stats.steps,
      scaleStepWidth : stats.step,
      scaleStartValue : 0,
      bezierCurve: false });
  }
});

//TODO move all variable declaration to the tops of functions.
$(function() {
  $(".pending-submission, .work").each(function(index,element) {
    var elem = $(element);

    var language = elem.data('language');
    $(".language",elem).tooltip({ title: language });

    var nitCount = elem.data('nits');
    $(".nits",elem).tooltip({ title: nitCount + " Nits by Others" });

    var versionCount = elem.data('versions');
    $(".versions",elem).tooltip({ title: "Iteration " + versionCount });
  });

  $(".code a[data-action='enlarge']").on("click",function() {
    var codeDiv = $(this).parents(".code");
    codeDiv.removeClass($(this).data("old-class"));
    codeDiv.addClass($(this).data("new-class"));
    $(this).hide();
    $("a[data-action='shrink']",codeDiv).show();
  });

  $(".code a[data-action='shrink']").on("click",function() {
    var codeDiv = $(this).parents(".code");
    codeDiv.removeClass($(this).data("old-class"));
    codeDiv.addClass($(this).data("new-class"));
    $(this).hide();
    $("a[data-action='enlarge']",codeDiv).show();
  });

  $('form input[type=submit], form button[type=submit]').on('click', function() {
    var $this = $(this);
    window.setTimeout(function() { $this.attr('disabled', true); }, 1);
  });

  $('textarea').each(function () {
    var $this = $(this);
    var question_text = "You have unsaved changes on this page";
    var was_sumbitted = false;
    $this.parents("form").on('submit',function(){
      was_sumbitted = true;
    });
    window.onbeforeunload = function (e) {
      var unsaved = $this.text() !== $this.val();
      if(!was_sumbitted && unsaved) {
        // see http://stackoverflow.com/questions/10311341/confirmation-before-closing-of-tab-browser
        e = e || window.event;

        if (e) {
            e.returnValue = question_text;
        }

        return question_text;
      }
    };
  });

  // cmd + return submits nitpicks on mac ctrl + return submits on windows
  // from https://github.com/dewski/cmd-enter
  $(document).on('keydown', 'textarea', function(e) {
      if(e.keyCode === 13 && (e.metaKey || e.ctrlKey)) {
          $(this).parents('form').submit();
      }
  });

  $('.work-slug').popover({
    trigger: 'hover',
    placement: 'right',
    html: true,
    delay: {
      show: 600,
      hide: 100
    },
    content: 'use the command <code>exercism fetch</code> to add this assignment to your exercism directory'
  });



  $(".mute").each(function(index, element) {
    var elem = $(element);

    $(".mute-btn",elem).tooltip({ placement: "bottom", title: "Mute this submission until there is further activity." });
    $(".unmute-btn",elem).tooltip({ placement: "bottom", title: "Unmute this sumission." });
  });
});

(function() {
  var destroyTeam, dismissTeamMember, toggleTeamEdit;

  angular.module('exercism', ['ui.bootstrap']);

  $(function() {
    $('.member_delete').on('click', function() {
      var slug, username;
      username = $(this).data('username');
      slug = $(this).data('team');
      if (confirm("Are you sure you want to dismiss " + username)) {
        return dismissTeamMember(username, slug);
      }
    });
    $('#destroy_team').on('click', function() {
      var slug;
      slug = $(this).data('team');
      if (confirm("Are you sure you want to delete " + slug + "?")) {
        return destroyTeam(slug);
      }
    });
    $('#edit_team').on('click', function(event) {
      event.preventDefault();
      return toggleTeamEdit();
    });
    if (_.any($('.comments'))) {
      emojify.setConfig({
        emoticons_enabled: false
      });
      return emojify.run(document.getElementsByClassName("comments")[0]);
    }
  });

  toggleTeamEdit = function() {
    var delete_buttons, members_box;
    members_box = $('#add_members');
    delete_buttons = $('.member_delete');
    if (members_box.hasClass('hidden')) {
      delete_buttons.removeClass('hidden');
      members_box.slideDown();
      return members_box.removeClass('hidden');
    } else {
      return members_box.slideUp(function() {
        delete_buttons.addClass('hidden');
        return members_box.addClass('hidden');
      });
    }
  };

  destroyTeam = function(slug) {
    var form, href, method_input;
    href = "/teams/" + slug;
    form = $('<form method="post" action="' + href + '"></form>');
    method_input = '<input name="_method" value="delete" type="hidden"/>';
    form.hide().append(method_input).appendTo('body');
    return form.submit();
  };

  dismissTeamMember = function(username, slug) {
    var form, href, method_input;
    href = "/teams/" + slug + "/members/" + username;
    form = $('<form method="post" action="' + href + '"></form>');
    method_input = '<input name="_method" value="delete" type="hidden"/>';
    form.hide().append(method_input).appendTo('body');
    return form.submit();
  };

}).call(this);

(function() {
  angular.module('exercism').controller("MarkdownCtrl", function($scope, $http) {
    var PATTERN;
    PATTERN = /\B@[a-z0-9_-]+/gi;
    $scope.data || ($scope.data = {});
    $scope.$watch('data.body', function(body) {
      var query;
      if (body && PATTERN.test(body)) {
        query = body.match(PATTERN)[0].replace('@', '');
        return $http.post("/api/v1/user/find", $.param({
          "query": query
        }), {
          headers: {
            "Content-Type": 'application/x-www-form-urlencoded'
          }
        }).success(function(data, status, headers) {
          return $('.comment').atwho({
            at: '@',
            data: data
          });
        });
      }
    });
    return $scope.preview = function() {
      return $http.post("/comments/preview", $.param({
        "body": $scope.data.body
      }), {
        headers: {
          "Content-Type": 'application/x-www-form-urlencoded'
        }
      }).success(function(data, status, headers) {
        return $scope.data.preview = data;
      });
    };
  });

}).call(this);

(function() {
  angular.module('exercism').controller("PaginationCtrl", function($scope, $http) {
    $scope.currentPage = 0;
    $scope.pageSize = 10;
    $scope.looks = [];
    $http.get("/api/v1/looks").success(function(data, status, headers) {
      return $scope.looks = data.looks;
    });
    $scope.numberOfPages = function() {
      return Math.ceil($scope.looks.length / $scope.pageSize);
    };
    return this;
  });

  angular.module('exercism').filter('startFrom', function() {
    return function(input, start) {
      start = +start;
      return input.slice(start);
    };
  });

}).call(this);

//# sourceMappingURL=app.js.map