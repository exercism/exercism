(function (window, undefined) {
  var readyList, rootjQuery, core_strundefined = typeof undefined, location = window.location, document = window.document, docElem = document.documentElement, _jQuery = window.jQuery, _$ = window.$, class2type = {}, core_deletedIds = [], core_version = '1.10.2', core_concat = core_deletedIds.concat, core_push = core_deletedIds.push, core_slice = core_deletedIds.slice, core_indexOf = core_deletedIds.indexOf, core_toString = class2type.toString, core_hasOwn = class2type.hasOwnProperty, core_trim = core_version.trim, jQuery = function (selector, context) {
      return new jQuery.fn.init(selector, context, rootjQuery);
    }, core_pnum = /[+-]?(?:\d*\.|)\d+(?:[eE][+-]?\d+|)/.source, core_rnotwhite = /\S+/g, rtrim = /^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g, rquickExpr = /^(?:\s*(<[\w\W]+>)[^>]*|#([\w-]*))$/, rsingleTag = /^<(\w+)\s*\/?>(?:<\/\1>|)$/, rvalidchars = /^[\],:{}\s]*$/, rvalidbraces = /(?:^|:|,)(?:\s*\[)+/g, rvalidescape = /\\(?:["\\\/bfnrt]|u[\da-fA-F]{4})/g, rvalidtokens = /"[^"\\\r\n]*"|true|false|null|-?(?:\d+\.|)\d+(?:[eE][+-]?\d+|)/g, rmsPrefix = /^-ms-/, rdashAlpha = /-([\da-z])/gi, fcamelCase = function (all, letter) {
      return letter.toUpperCase();
    }, completed = function (event) {
      if (document.addEventListener || event.type === 'load' || document.readyState === 'complete') {
        detach();
        jQuery.ready();
      }
    }, detach = function () {
      if (document.addEventListener) {
        document.removeEventListener('DOMContentLoaded', completed, false);
        window.removeEventListener('load', completed, false);
      } else {
        document.detachEvent('onreadystatechange', completed);
        window.detachEvent('onload', completed);
      }
    };
  jQuery.fn = jQuery.prototype = {
    jquery: core_version,
    constructor: jQuery,
    init: function (selector, context, rootjQuery) {
      var match, elem;
      if (!selector) {
        return this;
      }
      if (typeof selector === 'string') {
        if (selector.charAt(0) === '<' && selector.charAt(selector.length - 1) === '>' && selector.length >= 3) {
          match = [
            null,
            selector,
            null
          ];
        } else {
          match = rquickExpr.exec(selector);
        }
        if (match && (match[1] || !context)) {
          if (match[1]) {
            context = context instanceof jQuery ? context[0] : context;
            jQuery.merge(this, jQuery.parseHTML(match[1], context && context.nodeType ? context.ownerDocument || context : document, true));
            if (rsingleTag.test(match[1]) && jQuery.isPlainObject(context)) {
              for (match in context) {
                if (jQuery.isFunction(this[match])) {
                  this[match](context[match]);
                } else {
                  this.attr(match, context[match]);
                }
              }
            }
            return this;
          } else {
            elem = document.getElementById(match[2]);
            if (elem && elem.parentNode) {
              if (elem.id !== match[2]) {
                return rootjQuery.find(selector);
              }
              this.length = 1;
              this[0] = elem;
            }
            this.context = document;
            this.selector = selector;
            return this;
          }
        } else if (!context || context.jquery) {
          return (context || rootjQuery).find(selector);
        } else {
          return this.constructor(context).find(selector);
        }
      } else if (selector.nodeType) {
        this.context = this[0] = selector;
        this.length = 1;
        return this;
      } else if (jQuery.isFunction(selector)) {
        return rootjQuery.ready(selector);
      }
      if (selector.selector !== undefined) {
        this.selector = selector.selector;
        this.context = selector.context;
      }
      return jQuery.makeArray(selector, this);
    },
    selector: '',
    length: 0,
    toArray: function () {
      return core_slice.call(this);
    },
    get: function (num) {
      return num == null ? this.toArray() : num < 0 ? this[this.length + num] : this[num];
    },
    pushStack: function (elems) {
      var ret = jQuery.merge(this.constructor(), elems);
      ret.prevObject = this;
      ret.context = this.context;
      return ret;
    },
    each: function (callback, args) {
      return jQuery.each(this, callback, args);
    },
    ready: function (fn) {
      jQuery.ready.promise().done(fn);
      return this;
    },
    slice: function () {
      return this.pushStack(core_slice.apply(this, arguments));
    },
    first: function () {
      return this.eq(0);
    },
    last: function () {
      return this.eq(-1);
    },
    eq: function (i) {
      var len = this.length, j = +i + (i < 0 ? len : 0);
      return this.pushStack(j >= 0 && j < len ? [this[j]] : []);
    },
    map: function (callback) {
      return this.pushStack(jQuery.map(this, function (elem, i) {
        return callback.call(elem, i, elem);
      }));
    },
    end: function () {
      return this.prevObject || this.constructor(null);
    },
    push: core_push,
    sort: [].sort,
    splice: [].splice
  };
  jQuery.fn.init.prototype = jQuery.fn;
  jQuery.extend = jQuery.fn.extend = function () {
    var src, copyIsArray, copy, name, options, clone, target = arguments[0] || {}, i = 1, length = arguments.length, deep = false;
    if (typeof target === 'boolean') {
      deep = target;
      target = arguments[1] || {};
      i = 2;
    }
    if (typeof target !== 'object' && !jQuery.isFunction(target)) {
      target = {};
    }
    if (length === i) {
      target = this;
      --i;
    }
    for (; i < length; i++) {
      if ((options = arguments[i]) != null) {
        for (name in options) {
          src = target[name];
          copy = options[name];
          if (target === copy) {
            continue;
          }
          if (deep && copy && (jQuery.isPlainObject(copy) || (copyIsArray = jQuery.isArray(copy)))) {
            if (copyIsArray) {
              copyIsArray = false;
              clone = src && jQuery.isArray(src) ? src : [];
            } else {
              clone = src && jQuery.isPlainObject(src) ? src : {};
            }
            target[name] = jQuery.extend(deep, clone, copy);
          } else if (copy !== undefined) {
            target[name] = copy;
          }
        }
      }
    }
    return target;
  };
  jQuery.extend({
    expando: 'jQuery' + (core_version + Math.random()).replace(/\D/g, ''),
    noConflict: function (deep) {
      if (window.$ === jQuery) {
        window.$ = _$;
      }
      if (deep && window.jQuery === jQuery) {
        window.jQuery = _jQuery;
      }
      return jQuery;
    },
    isReady: false,
    readyWait: 1,
    holdReady: function (hold) {
      if (hold) {
        jQuery.readyWait++;
      } else {
        jQuery.ready(true);
      }
    },
    ready: function (wait) {
      if (wait === true ? --jQuery.readyWait : jQuery.isReady) {
        return;
      }
      if (!document.body) {
        return setTimeout(jQuery.ready);
      }
      jQuery.isReady = true;
      if (wait !== true && --jQuery.readyWait > 0) {
        return;
      }
      readyList.resolveWith(document, [jQuery]);
      if (jQuery.fn.trigger) {
        jQuery(document).trigger('ready').off('ready');
      }
    },
    isFunction: function (obj) {
      return jQuery.type(obj) === 'function';
    },
    isArray: Array.isArray || function (obj) {
      return jQuery.type(obj) === 'array';
    },
    isWindow: function (obj) {
      return obj != null && obj == obj.window;
    },
    isNumeric: function (obj) {
      return !isNaN(parseFloat(obj)) && isFinite(obj);
    },
    type: function (obj) {
      if (obj == null) {
        return String(obj);
      }
      return typeof obj === 'object' || typeof obj === 'function' ? class2type[core_toString.call(obj)] || 'object' : typeof obj;
    },
    isPlainObject: function (obj) {
      var key;
      if (!obj || jQuery.type(obj) !== 'object' || obj.nodeType || jQuery.isWindow(obj)) {
        return false;
      }
      try {
        if (obj.constructor && !core_hasOwn.call(obj, 'constructor') && !core_hasOwn.call(obj.constructor.prototype, 'isPrototypeOf')) {
          return false;
        }
      } catch (e) {
        return false;
      }
      if (jQuery.support.ownLast) {
        for (key in obj) {
          return core_hasOwn.call(obj, key);
        }
      }
      for (key in obj) {
      }
      return key === undefined || core_hasOwn.call(obj, key);
    },
    isEmptyObject: function (obj) {
      var name;
      for (name in obj) {
        return false;
      }
      return true;
    },
    error: function (msg) {
      throw new Error(msg);
    },
    parseHTML: function (data, context, keepScripts) {
      if (!data || typeof data !== 'string') {
        return null;
      }
      if (typeof context === 'boolean') {
        keepScripts = context;
        context = false;
      }
      context = context || document;
      var parsed = rsingleTag.exec(data), scripts = !keepScripts && [];
      if (parsed) {
        return [context.createElement(parsed[1])];
      }
      parsed = jQuery.buildFragment([data], context, scripts);
      if (scripts) {
        jQuery(scripts).remove();
      }
      return jQuery.merge([], parsed.childNodes);
    },
    parseJSON: function (data) {
      if (window.JSON && window.JSON.parse) {
        return window.JSON.parse(data);
      }
      if (data === null) {
        return data;
      }
      if (typeof data === 'string') {
        data = jQuery.trim(data);
        if (data) {
          if (rvalidchars.test(data.replace(rvalidescape, '@').replace(rvalidtokens, ']').replace(rvalidbraces, ''))) {
            return new Function('return ' + data)();
          }
        }
      }
      jQuery.error('Invalid JSON: ' + data);
    },
    parseXML: function (data) {
      var xml, tmp;
      if (!data || typeof data !== 'string') {
        return null;
      }
      try {
        if (window.DOMParser) {
          tmp = new DOMParser();
          xml = tmp.parseFromString(data, 'text/xml');
        } else {
          xml = new ActiveXObject('Microsoft.XMLDOM');
          xml.async = 'false';
          xml.loadXML(data);
        }
      } catch (e) {
        xml = undefined;
      }
      if (!xml || !xml.documentElement || xml.getElementsByTagName('parsererror').length) {
        jQuery.error('Invalid XML: ' + data);
      }
      return xml;
    },
    noop: function () {
    },
    globalEval: function (data) {
      if (data && jQuery.trim(data)) {
        (window.execScript || function (data) {
          window['eval'].call(window, data);
        })(data);
      }
    },
    camelCase: function (string) {
      return string.replace(rmsPrefix, 'ms-').replace(rdashAlpha, fcamelCase);
    },
    nodeName: function (elem, name) {
      return elem.nodeName && elem.nodeName.toLowerCase() === name.toLowerCase();
    },
    each: function (obj, callback, args) {
      var value, i = 0, length = obj.length, isArray = isArraylike(obj);
      if (args) {
        if (isArray) {
          for (; i < length; i++) {
            value = callback.apply(obj[i], args);
            if (value === false) {
              break;
            }
          }
        } else {
          for (i in obj) {
            value = callback.apply(obj[i], args);
            if (value === false) {
              break;
            }
          }
        }
      } else {
        if (isArray) {
          for (; i < length; i++) {
            value = callback.call(obj[i], i, obj[i]);
            if (value === false) {
              break;
            }
          }
        } else {
          for (i in obj) {
            value = callback.call(obj[i], i, obj[i]);
            if (value === false) {
              break;
            }
          }
        }
      }
      return obj;
    },
    trim: core_trim && !core_trim.call('\ufeff\xa0') ? function (text) {
      return text == null ? '' : core_trim.call(text);
    } : function (text) {
      return text == null ? '' : (text + '').replace(rtrim, '');
    },
    makeArray: function (arr, results) {
      var ret = results || [];
      if (arr != null) {
        if (isArraylike(Object(arr))) {
          jQuery.merge(ret, typeof arr === 'string' ? [arr] : arr);
        } else {
          core_push.call(ret, arr);
        }
      }
      return ret;
    },
    inArray: function (elem, arr, i) {
      var len;
      if (arr) {
        if (core_indexOf) {
          return core_indexOf.call(arr, elem, i);
        }
        len = arr.length;
        i = i ? i < 0 ? Math.max(0, len + i) : i : 0;
        for (; i < len; i++) {
          if (i in arr && arr[i] === elem) {
            return i;
          }
        }
      }
      return -1;
    },
    merge: function (first, second) {
      var l = second.length, i = first.length, j = 0;
      if (typeof l === 'number') {
        for (; j < l; j++) {
          first[i++] = second[j];
        }
      } else {
        while (second[j] !== undefined) {
          first[i++] = second[j++];
        }
      }
      first.length = i;
      return first;
    },
    grep: function (elems, callback, inv) {
      var retVal, ret = [], i = 0, length = elems.length;
      inv = !!inv;
      for (; i < length; i++) {
        retVal = !!callback(elems[i], i);
        if (inv !== retVal) {
          ret.push(elems[i]);
        }
      }
      return ret;
    },
    map: function (elems, callback, arg) {
      var value, i = 0, length = elems.length, isArray = isArraylike(elems), ret = [];
      if (isArray) {
        for (; i < length; i++) {
          value = callback(elems[i], i, arg);
          if (value != null) {
            ret[ret.length] = value;
          }
        }
      } else {
        for (i in elems) {
          value = callback(elems[i], i, arg);
          if (value != null) {
            ret[ret.length] = value;
          }
        }
      }
      return core_concat.apply([], ret);
    },
    guid: 1,
    proxy: function (fn, context) {
      var args, proxy, tmp;
      if (typeof context === 'string') {
        tmp = fn[context];
        context = fn;
        fn = tmp;
      }
      if (!jQuery.isFunction(fn)) {
        return undefined;
      }
      args = core_slice.call(arguments, 2);
      proxy = function () {
        return fn.apply(context || this, args.concat(core_slice.call(arguments)));
      };
      proxy.guid = fn.guid = fn.guid || jQuery.guid++;
      return proxy;
    },
    access: function (elems, fn, key, value, chainable, emptyGet, raw) {
      var i = 0, length = elems.length, bulk = key == null;
      if (jQuery.type(key) === 'object') {
        chainable = true;
        for (i in key) {
          jQuery.access(elems, fn, i, key[i], true, emptyGet, raw);
        }
      } else if (value !== undefined) {
        chainable = true;
        if (!jQuery.isFunction(value)) {
          raw = true;
        }
        if (bulk) {
          if (raw) {
            fn.call(elems, value);
            fn = null;
          } else {
            bulk = fn;
            fn = function (elem, key, value) {
              return bulk.call(jQuery(elem), value);
            };
          }
        }
        if (fn) {
          for (; i < length; i++) {
            fn(elems[i], key, raw ? value : value.call(elems[i], i, fn(elems[i], key)));
          }
        }
      }
      return chainable ? elems : bulk ? fn.call(elems) : length ? fn(elems[0], key) : emptyGet;
    },
    now: function () {
      return new Date().getTime();
    },
    swap: function (elem, options, callback, args) {
      var ret, name, old = {};
      for (name in options) {
        old[name] = elem.style[name];
        elem.style[name] = options[name];
      }
      ret = callback.apply(elem, args || []);
      for (name in options) {
        elem.style[name] = old[name];
      }
      return ret;
    }
  });
  jQuery.ready.promise = function (obj) {
    if (!readyList) {
      readyList = jQuery.Deferred();
      if (document.readyState === 'complete') {
        setTimeout(jQuery.ready);
      } else if (document.addEventListener) {
        document.addEventListener('DOMContentLoaded', completed, false);
        window.addEventListener('load', completed, false);
      } else {
        document.attachEvent('onreadystatechange', completed);
        window.attachEvent('onload', completed);
        var top = false;
        try {
          top = window.frameElement == null && document.documentElement;
        } catch (e) {
        }
        if (top && top.doScroll) {
          (function doScrollCheck() {
            if (!jQuery.isReady) {
              try {
                top.doScroll('left');
              } catch (e) {
                return setTimeout(doScrollCheck, 50);
              }
              detach();
              jQuery.ready();
            }
          }());
        }
      }
    }
    return readyList.promise(obj);
  };
  jQuery.each('Boolean Number String Function Array Date RegExp Object Error'.split(' '), function (i, name) {
    class2type['[object ' + name + ']'] = name.toLowerCase();
  });
  function isArraylike(obj) {
    var length = obj.length, type = jQuery.type(obj);
    if (jQuery.isWindow(obj)) {
      return false;
    }
    if (obj.nodeType === 1 && length) {
      return true;
    }
    return type === 'array' || type !== 'function' && (length === 0 || typeof length === 'number' && length > 0 && length - 1 in obj);
  }
  rootjQuery = jQuery(document);
  (function (window, undefined) {
    var i, support, cachedruns, Expr, getText, isXML, compile, outermostContext, sortInput, setDocument, document, docElem, documentIsHTML, rbuggyQSA, rbuggyMatches, matches, contains, expando = 'sizzle' + -new Date(), preferredDoc = window.document, dirruns = 0, done = 0, classCache = createCache(), tokenCache = createCache(), compilerCache = createCache(), hasDuplicate = false, sortOrder = function (a, b) {
        if (a === b) {
          hasDuplicate = true;
          return 0;
        }
        return 0;
      }, strundefined = typeof undefined, MAX_NEGATIVE = 1 << 31, hasOwn = {}.hasOwnProperty, arr = [], pop = arr.pop, push_native = arr.push, push = arr.push, slice = arr.slice, indexOf = arr.indexOf || function (elem) {
        var i = 0, len = this.length;
        for (; i < len; i++) {
          if (this[i] === elem) {
            return i;
          }
        }
        return -1;
      }, booleans = 'checked|selected|async|autofocus|autoplay|controls|defer|disabled|hidden|ismap|loop|multiple|open|readonly|required|scoped', whitespace = '[\\x20\\t\\r\\n\\f]', characterEncoding = '(?:\\\\.|[\\w-]|[^\\x00-\\xa0])+', identifier = characterEncoding.replace('w', 'w#'), attributes = '\\[' + whitespace + '*(' + characterEncoding + ')' + whitespace + '*(?:([*^$|!~]?=)' + whitespace + '*(?:([\'"])((?:\\\\.|[^\\\\])*?)\\3|(' + identifier + ')|)|)' + whitespace + '*\\]', pseudos = ':(' + characterEncoding + ')(?:\\((([\'"])((?:\\\\.|[^\\\\])*?)\\3|((?:\\\\.|[^\\\\()[\\]]|' + attributes.replace(3, 8) + ')*)|.*)\\)|)', rtrim = new RegExp('^' + whitespace + '+|((?:^|[^\\\\])(?:\\\\.)*)' + whitespace + '+$', 'g'), rcomma = new RegExp('^' + whitespace + '*,' + whitespace + '*'), rcombinators = new RegExp('^' + whitespace + '*([>+~]|' + whitespace + ')' + whitespace + '*'), rsibling = new RegExp(whitespace + '*[+~]'), rattributeQuotes = new RegExp('=' + whitespace + '*([^\\]\'"]*)' + whitespace + '*\\]', 'g'), rpseudo = new RegExp(pseudos), ridentifier = new RegExp('^' + identifier + '$'), matchExpr = {
        'ID': new RegExp('^#(' + characterEncoding + ')'),
        'CLASS': new RegExp('^\\.(' + characterEncoding + ')'),
        'TAG': new RegExp('^(' + characterEncoding.replace('w', 'w*') + ')'),
        'ATTR': new RegExp('^' + attributes),
        'PSEUDO': new RegExp('^' + pseudos),
        'CHILD': new RegExp('^:(only|first|last|nth|nth-last)-(child|of-type)(?:\\(' + whitespace + '*(even|odd|(([+-]|)(\\d*)n|)' + whitespace + '*(?:([+-]|)' + whitespace + '*(\\d+)|))' + whitespace + '*\\)|)', 'i'),
        'bool': new RegExp('^(?:' + booleans + ')$', 'i'),
        'needsContext': new RegExp('^' + whitespace + '*[>+~]|:(even|odd|eq|gt|lt|nth|first|last)(?:\\(' + whitespace + '*((?:-\\d)?\\d*)' + whitespace + '*\\)|)(?=[^-]|$)', 'i')
      }, rnative = /^[^{]+\{\s*\[native \w/, rquickExpr = /^(?:#([\w-]+)|(\w+)|\.([\w-]+))$/, rinputs = /^(?:input|select|textarea|button)$/i, rheader = /^h\d$/i, rescape = /'|\\/g, runescape = new RegExp('\\\\([\\da-f]{1,6}' + whitespace + '?|(' + whitespace + ')|.)', 'ig'), funescape = function (_, escaped, escapedWhitespace) {
        var high = '0x' + escaped - 65536;
        return high !== high || escapedWhitespace ? escaped : high < 0 ? String.fromCharCode(high + 65536) : String.fromCharCode(high >> 10 | 55296, high & 1023 | 56320);
      };
    try {
      push.apply(arr = slice.call(preferredDoc.childNodes), preferredDoc.childNodes);
      arr[preferredDoc.childNodes.length].nodeType;
    } catch (e) {
      push = {
        apply: arr.length ? function (target, els) {
          push_native.apply(target, slice.call(els));
        } : function (target, els) {
          var j = target.length, i = 0;
          while (target[j++] = els[i++]) {
          }
          target.length = j - 1;
        }
      };
    }
    function Sizzle(selector, context, results, seed) {
      var match, elem, m, nodeType, i, groups, old, nid, newContext, newSelector;
      if ((context ? context.ownerDocument || context : preferredDoc) !== document) {
        setDocument(context);
      }
      context = context || document;
      results = results || [];
      if (!selector || typeof selector !== 'string') {
        return results;
      }
      if ((nodeType = context.nodeType) !== 1 && nodeType !== 9) {
        return [];
      }
      if (documentIsHTML && !seed) {
        if (match = rquickExpr.exec(selector)) {
          if (m = match[1]) {
            if (nodeType === 9) {
              elem = context.getElementById(m);
              if (elem && elem.parentNode) {
                if (elem.id === m) {
                  results.push(elem);
                  return results;
                }
              } else {
                return results;
              }
            } else {
              if (context.ownerDocument && (elem = context.ownerDocument.getElementById(m)) && contains(context, elem) && elem.id === m) {
                results.push(elem);
                return results;
              }
            }
          } else if (match[2]) {
            push.apply(results, context.getElementsByTagName(selector));
            return results;
          } else if ((m = match[3]) && support.getElementsByClassName && context.getElementsByClassName) {
            push.apply(results, context.getElementsByClassName(m));
            return results;
          }
        }
        if (support.qsa && (!rbuggyQSA || !rbuggyQSA.test(selector))) {
          nid = old = expando;
          newContext = context;
          newSelector = nodeType === 9 && selector;
          if (nodeType === 1 && context.nodeName.toLowerCase() !== 'object') {
            groups = tokenize(selector);
            if (old = context.getAttribute('id')) {
              nid = old.replace(rescape, '\\$&');
            } else {
              context.setAttribute('id', nid);
            }
            nid = '[id=\'' + nid + '\'] ';
            i = groups.length;
            while (i--) {
              groups[i] = nid + toSelector(groups[i]);
            }
            newContext = rsibling.test(selector) && context.parentNode || context;
            newSelector = groups.join(',');
          }
          if (newSelector) {
            try {
              push.apply(results, newContext.querySelectorAll(newSelector));
              return results;
            } catch (qsaError) {
            } finally {
              if (!old) {
                context.removeAttribute('id');
              }
            }
          }
        }
      }
      return select(selector.replace(rtrim, '$1'), context, results, seed);
    }
    function createCache() {
      var keys = [];
      function cache(key, value) {
        if (keys.push(key += ' ') > Expr.cacheLength) {
          delete cache[keys.shift()];
        }
        return cache[key] = value;
      }
      return cache;
    }
    function markFunction(fn) {
      fn[expando] = true;
      return fn;
    }
    function assert(fn) {
      var div = document.createElement('div');
      try {
        return !!fn(div);
      } catch (e) {
        return false;
      } finally {
        if (div.parentNode) {
          div.parentNode.removeChild(div);
        }
        div = null;
      }
    }
    function addHandle(attrs, handler) {
      var arr = attrs.split('|'), i = attrs.length;
      while (i--) {
        Expr.attrHandle[arr[i]] = handler;
      }
    }
    function siblingCheck(a, b) {
      var cur = b && a, diff = cur && a.nodeType === 1 && b.nodeType === 1 && (~b.sourceIndex || MAX_NEGATIVE) - (~a.sourceIndex || MAX_NEGATIVE);
      if (diff) {
        return diff;
      }
      if (cur) {
        while (cur = cur.nextSibling) {
          if (cur === b) {
            return -1;
          }
        }
      }
      return a ? 1 : -1;
    }
    function createInputPseudo(type) {
      return function (elem) {
        var name = elem.nodeName.toLowerCase();
        return name === 'input' && elem.type === type;
      };
    }
    function createButtonPseudo(type) {
      return function (elem) {
        var name = elem.nodeName.toLowerCase();
        return (name === 'input' || name === 'button') && elem.type === type;
      };
    }
    function createPositionalPseudo(fn) {
      return markFunction(function (argument) {
        argument = +argument;
        return markFunction(function (seed, matches) {
          var j, matchIndexes = fn([], seed.length, argument), i = matchIndexes.length;
          while (i--) {
            if (seed[j = matchIndexes[i]]) {
              seed[j] = !(matches[j] = seed[j]);
            }
          }
        });
      });
    }
    isXML = Sizzle.isXML = function (elem) {
      var documentElement = elem && (elem.ownerDocument || elem).documentElement;
      return documentElement ? documentElement.nodeName !== 'HTML' : false;
    };
    support = Sizzle.support = {};
    setDocument = Sizzle.setDocument = function (node) {
      var doc = node ? node.ownerDocument || node : preferredDoc, parent = doc.defaultView;
      if (doc === document || doc.nodeType !== 9 || !doc.documentElement) {
        return document;
      }
      document = doc;
      docElem = doc.documentElement;
      documentIsHTML = !isXML(doc);
      if (parent && parent.attachEvent && parent !== parent.top) {
        parent.attachEvent('onbeforeunload', function () {
          setDocument();
        });
      }
      support.attributes = assert(function (div) {
        div.className = 'i';
        return !div.getAttribute('className');
      });
      support.getElementsByTagName = assert(function (div) {
        div.appendChild(doc.createComment(''));
        return !div.getElementsByTagName('*').length;
      });
      support.getElementsByClassName = assert(function (div) {
        div.innerHTML = '<div class=\'a\'></div><div class=\'a i\'></div>';
        div.firstChild.className = 'i';
        return div.getElementsByClassName('i').length === 2;
      });
      support.getById = assert(function (div) {
        docElem.appendChild(div).id = expando;
        return !doc.getElementsByName || !doc.getElementsByName(expando).length;
      });
      if (support.getById) {
        Expr.find['ID'] = function (id, context) {
          if (typeof context.getElementById !== strundefined && documentIsHTML) {
            var m = context.getElementById(id);
            return m && m.parentNode ? [m] : [];
          }
        };
        Expr.filter['ID'] = function (id) {
          var attrId = id.replace(runescape, funescape);
          return function (elem) {
            return elem.getAttribute('id') === attrId;
          };
        };
      } else {
        delete Expr.find['ID'];
        Expr.filter['ID'] = function (id) {
          var attrId = id.replace(runescape, funescape);
          return function (elem) {
            var node = typeof elem.getAttributeNode !== strundefined && elem.getAttributeNode('id');
            return node && node.value === attrId;
          };
        };
      }
      Expr.find['TAG'] = support.getElementsByTagName ? function (tag, context) {
        if (typeof context.getElementsByTagName !== strundefined) {
          return context.getElementsByTagName(tag);
        }
      } : function (tag, context) {
        var elem, tmp = [], i = 0, results = context.getElementsByTagName(tag);
        if (tag === '*') {
          while (elem = results[i++]) {
            if (elem.nodeType === 1) {
              tmp.push(elem);
            }
          }
          return tmp;
        }
        return results;
      };
      Expr.find['CLASS'] = support.getElementsByClassName && function (className, context) {
        if (typeof context.getElementsByClassName !== strundefined && documentIsHTML) {
          return context.getElementsByClassName(className);
        }
      };
      rbuggyMatches = [];
      rbuggyQSA = [];
      if (support.qsa = rnative.test(doc.querySelectorAll)) {
        assert(function (div) {
          div.innerHTML = '<select><option selected=\'\'></option></select>';
          if (!div.querySelectorAll('[selected]').length) {
            rbuggyQSA.push('\\[' + whitespace + '*(?:value|' + booleans + ')');
          }
          if (!div.querySelectorAll(':checked').length) {
            rbuggyQSA.push(':checked');
          }
        });
        assert(function (div) {
          var input = doc.createElement('input');
          input.setAttribute('type', 'hidden');
          div.appendChild(input).setAttribute('t', '');
          if (div.querySelectorAll('[t^=\'\']').length) {
            rbuggyQSA.push('[*^$]=' + whitespace + '*(?:\'\'|"")');
          }
          if (!div.querySelectorAll(':enabled').length) {
            rbuggyQSA.push(':enabled', ':disabled');
          }
          div.querySelectorAll('*,:x');
          rbuggyQSA.push(',.*:');
        });
      }
      if (support.matchesSelector = rnative.test(matches = docElem.webkitMatchesSelector || docElem.mozMatchesSelector || docElem.oMatchesSelector || docElem.msMatchesSelector)) {
        assert(function (div) {
          support.disconnectedMatch = matches.call(div, 'div');
          matches.call(div, '[s!=\'\']:x');
          rbuggyMatches.push('!=', pseudos);
        });
      }
      rbuggyQSA = rbuggyQSA.length && new RegExp(rbuggyQSA.join('|'));
      rbuggyMatches = rbuggyMatches.length && new RegExp(rbuggyMatches.join('|'));
      contains = rnative.test(docElem.contains) || docElem.compareDocumentPosition ? function (a, b) {
        var adown = a.nodeType === 9 ? a.documentElement : a, bup = b && b.parentNode;
        return a === bup || !!(bup && bup.nodeType === 1 && (adown.contains ? adown.contains(bup) : a.compareDocumentPosition && a.compareDocumentPosition(bup) & 16));
      } : function (a, b) {
        if (b) {
          while (b = b.parentNode) {
            if (b === a) {
              return true;
            }
          }
        }
        return false;
      };
      sortOrder = docElem.compareDocumentPosition ? function (a, b) {
        if (a === b) {
          hasDuplicate = true;
          return 0;
        }
        var compare = b.compareDocumentPosition && a.compareDocumentPosition && a.compareDocumentPosition(b);
        if (compare) {
          if (compare & 1 || !support.sortDetached && b.compareDocumentPosition(a) === compare) {
            if (a === doc || contains(preferredDoc, a)) {
              return -1;
            }
            if (b === doc || contains(preferredDoc, b)) {
              return 1;
            }
            return sortInput ? indexOf.call(sortInput, a) - indexOf.call(sortInput, b) : 0;
          }
          return compare & 4 ? -1 : 1;
        }
        return a.compareDocumentPosition ? -1 : 1;
      } : function (a, b) {
        var cur, i = 0, aup = a.parentNode, bup = b.parentNode, ap = [a], bp = [b];
        if (a === b) {
          hasDuplicate = true;
          return 0;
        } else if (!aup || !bup) {
          return a === doc ? -1 : b === doc ? 1 : aup ? -1 : bup ? 1 : sortInput ? indexOf.call(sortInput, a) - indexOf.call(sortInput, b) : 0;
        } else if (aup === bup) {
          return siblingCheck(a, b);
        }
        cur = a;
        while (cur = cur.parentNode) {
          ap.unshift(cur);
        }
        cur = b;
        while (cur = cur.parentNode) {
          bp.unshift(cur);
        }
        while (ap[i] === bp[i]) {
          i++;
        }
        return i ? siblingCheck(ap[i], bp[i]) : ap[i] === preferredDoc ? -1 : bp[i] === preferredDoc ? 1 : 0;
      };
      return doc;
    };
    Sizzle.matches = function (expr, elements) {
      return Sizzle(expr, null, null, elements);
    };
    Sizzle.matchesSelector = function (elem, expr) {
      if ((elem.ownerDocument || elem) !== document) {
        setDocument(elem);
      }
      expr = expr.replace(rattributeQuotes, '=\'$1\']');
      if (support.matchesSelector && documentIsHTML && (!rbuggyMatches || !rbuggyMatches.test(expr)) && (!rbuggyQSA || !rbuggyQSA.test(expr))) {
        try {
          var ret = matches.call(elem, expr);
          if (ret || support.disconnectedMatch || elem.document && elem.document.nodeType !== 11) {
            return ret;
          }
        } catch (e) {
        }
      }
      return Sizzle(expr, document, null, [elem]).length > 0;
    };
    Sizzle.contains = function (context, elem) {
      if ((context.ownerDocument || context) !== document) {
        setDocument(context);
      }
      return contains(context, elem);
    };
    Sizzle.attr = function (elem, name) {
      if ((elem.ownerDocument || elem) !== document) {
        setDocument(elem);
      }
      var fn = Expr.attrHandle[name.toLowerCase()], val = fn && hasOwn.call(Expr.attrHandle, name.toLowerCase()) ? fn(elem, name, !documentIsHTML) : undefined;
      return val === undefined ? support.attributes || !documentIsHTML ? elem.getAttribute(name) : (val = elem.getAttributeNode(name)) && val.specified ? val.value : null : val;
    };
    Sizzle.error = function (msg) {
      throw new Error('Syntax error, unrecognized expression: ' + msg);
    };
    Sizzle.uniqueSort = function (results) {
      var elem, duplicates = [], j = 0, i = 0;
      hasDuplicate = !support.detectDuplicates;
      sortInput = !support.sortStable && results.slice(0);
      results.sort(sortOrder);
      if (hasDuplicate) {
        while (elem = results[i++]) {
          if (elem === results[i]) {
            j = duplicates.push(i);
          }
        }
        while (j--) {
          results.splice(duplicates[j], 1);
        }
      }
      return results;
    };
    getText = Sizzle.getText = function (elem) {
      var node, ret = '', i = 0, nodeType = elem.nodeType;
      if (!nodeType) {
        for (; node = elem[i]; i++) {
          ret += getText(node);
        }
      } else if (nodeType === 1 || nodeType === 9 || nodeType === 11) {
        if (typeof elem.textContent === 'string') {
          return elem.textContent;
        } else {
          for (elem = elem.firstChild; elem; elem = elem.nextSibling) {
            ret += getText(elem);
          }
        }
      } else if (nodeType === 3 || nodeType === 4) {
        return elem.nodeValue;
      }
      return ret;
    };
    Expr = Sizzle.selectors = {
      cacheLength: 50,
      createPseudo: markFunction,
      match: matchExpr,
      attrHandle: {},
      find: {},
      relative: {
        '>': {
          dir: 'parentNode',
          first: true
        },
        ' ': { dir: 'parentNode' },
        '+': {
          dir: 'previousSibling',
          first: true
        },
        '~': { dir: 'previousSibling' }
      },
      preFilter: {
        'ATTR': function (match) {
          match[1] = match[1].replace(runescape, funescape);
          match[3] = (match[4] || match[5] || '').replace(runescape, funescape);
          if (match[2] === '~=') {
            match[3] = ' ' + match[3] + ' ';
          }
          return match.slice(0, 4);
        },
        'CHILD': function (match) {
          match[1] = match[1].toLowerCase();
          if (match[1].slice(0, 3) === 'nth') {
            if (!match[3]) {
              Sizzle.error(match[0]);
            }
            match[4] = +(match[4] ? match[5] + (match[6] || 1) : 2 * (match[3] === 'even' || match[3] === 'odd'));
            match[5] = +(match[7] + match[8] || match[3] === 'odd');
          } else if (match[3]) {
            Sizzle.error(match[0]);
          }
          return match;
        },
        'PSEUDO': function (match) {
          var excess, unquoted = !match[5] && match[2];
          if (matchExpr['CHILD'].test(match[0])) {
            return null;
          }
          if (match[3] && match[4] !== undefined) {
            match[2] = match[4];
          } else if (unquoted && rpseudo.test(unquoted) && (excess = tokenize(unquoted, true)) && (excess = unquoted.indexOf(')', unquoted.length - excess) - unquoted.length)) {
            match[0] = match[0].slice(0, excess);
            match[2] = unquoted.slice(0, excess);
          }
          return match.slice(0, 3);
        }
      },
      filter: {
        'TAG': function (nodeNameSelector) {
          var nodeName = nodeNameSelector.replace(runescape, funescape).toLowerCase();
          return nodeNameSelector === '*' ? function () {
            return true;
          } : function (elem) {
            return elem.nodeName && elem.nodeName.toLowerCase() === nodeName;
          };
        },
        'CLASS': function (className) {
          var pattern = classCache[className + ' '];
          return pattern || (pattern = new RegExp('(^|' + whitespace + ')' + className + '(' + whitespace + '|$)')) && classCache(className, function (elem) {
            return pattern.test(typeof elem.className === 'string' && elem.className || typeof elem.getAttribute !== strundefined && elem.getAttribute('class') || '');
          });
        },
        'ATTR': function (name, operator, check) {
          return function (elem) {
            var result = Sizzle.attr(elem, name);
            if (result == null) {
              return operator === '!=';
            }
            if (!operator) {
              return true;
            }
            result += '';
            return operator === '=' ? result === check : operator === '!=' ? result !== check : operator === '^=' ? check && result.indexOf(check) === 0 : operator === '*=' ? check && result.indexOf(check) > -1 : operator === '$=' ? check && result.slice(-check.length) === check : operator === '~=' ? (' ' + result + ' ').indexOf(check) > -1 : operator === '|=' ? result === check || result.slice(0, check.length + 1) === check + '-' : false;
          };
        },
        'CHILD': function (type, what, argument, first, last) {
          var simple = type.slice(0, 3) !== 'nth', forward = type.slice(-4) !== 'last', ofType = what === 'of-type';
          return first === 1 && last === 0 ? function (elem) {
            return !!elem.parentNode;
          } : function (elem, context, xml) {
            var cache, outerCache, node, diff, nodeIndex, start, dir = simple !== forward ? 'nextSibling' : 'previousSibling', parent = elem.parentNode, name = ofType && elem.nodeName.toLowerCase(), useCache = !xml && !ofType;
            if (parent) {
              if (simple) {
                while (dir) {
                  node = elem;
                  while (node = node[dir]) {
                    if (ofType ? node.nodeName.toLowerCase() === name : node.nodeType === 1) {
                      return false;
                    }
                  }
                  start = dir = type === 'only' && !start && 'nextSibling';
                }
                return true;
              }
              start = [forward ? parent.firstChild : parent.lastChild];
              if (forward && useCache) {
                outerCache = parent[expando] || (parent[expando] = {});
                cache = outerCache[type] || [];
                nodeIndex = cache[0] === dirruns && cache[1];
                diff = cache[0] === dirruns && cache[2];
                node = nodeIndex && parent.childNodes[nodeIndex];
                while (node = ++nodeIndex && node && node[dir] || (diff = nodeIndex = 0) || start.pop()) {
                  if (node.nodeType === 1 && ++diff && node === elem) {
                    outerCache[type] = [
                      dirruns,
                      nodeIndex,
                      diff
                    ];
                    break;
                  }
                }
              } else if (useCache && (cache = (elem[expando] || (elem[expando] = {}))[type]) && cache[0] === dirruns) {
                diff = cache[1];
              } else {
                while (node = ++nodeIndex && node && node[dir] || (diff = nodeIndex = 0) || start.pop()) {
                  if ((ofType ? node.nodeName.toLowerCase() === name : node.nodeType === 1) && ++diff) {
                    if (useCache) {
                      (node[expando] || (node[expando] = {}))[type] = [
                        dirruns,
                        diff
                      ];
                    }
                    if (node === elem) {
                      break;
                    }
                  }
                }
              }
              diff -= last;
              return diff === first || diff % first === 0 && diff / first >= 0;
            }
          };
        },
        'PSEUDO': function (pseudo, argument) {
          var args, fn = Expr.pseudos[pseudo] || Expr.setFilters[pseudo.toLowerCase()] || Sizzle.error('unsupported pseudo: ' + pseudo);
          if (fn[expando]) {
            return fn(argument);
          }
          if (fn.length > 1) {
            args = [
              pseudo,
              pseudo,
              '',
              argument
            ];
            return Expr.setFilters.hasOwnProperty(pseudo.toLowerCase()) ? markFunction(function (seed, matches) {
              var idx, matched = fn(seed, argument), i = matched.length;
              while (i--) {
                idx = indexOf.call(seed, matched[i]);
                seed[idx] = !(matches[idx] = matched[i]);
              }
            }) : function (elem) {
              return fn(elem, 0, args);
            };
          }
          return fn;
        }
      },
      pseudos: {
        'not': markFunction(function (selector) {
          var input = [], results = [], matcher = compile(selector.replace(rtrim, '$1'));
          return matcher[expando] ? markFunction(function (seed, matches, context, xml) {
            var elem, unmatched = matcher(seed, null, xml, []), i = seed.length;
            while (i--) {
              if (elem = unmatched[i]) {
                seed[i] = !(matches[i] = elem);
              }
            }
          }) : function (elem, context, xml) {
            input[0] = elem;
            matcher(input, null, xml, results);
            return !results.pop();
          };
        }),
        'has': markFunction(function (selector) {
          return function (elem) {
            return Sizzle(selector, elem).length > 0;
          };
        }),
        'contains': markFunction(function (text) {
          return function (elem) {
            return (elem.textContent || elem.innerText || getText(elem)).indexOf(text) > -1;
          };
        }),
        'lang': markFunction(function (lang) {
          if (!ridentifier.test(lang || '')) {
            Sizzle.error('unsupported lang: ' + lang);
          }
          lang = lang.replace(runescape, funescape).toLowerCase();
          return function (elem) {
            var elemLang;
            do {
              if (elemLang = documentIsHTML ? elem.lang : elem.getAttribute('xml:lang') || elem.getAttribute('lang')) {
                elemLang = elemLang.toLowerCase();
                return elemLang === lang || elemLang.indexOf(lang + '-') === 0;
              }
            } while ((elem = elem.parentNode) && elem.nodeType === 1);
            return false;
          };
        }),
        'target': function (elem) {
          var hash = window.location && window.location.hash;
          return hash && hash.slice(1) === elem.id;
        },
        'root': function (elem) {
          return elem === docElem;
        },
        'focus': function (elem) {
          return elem === document.activeElement && (!document.hasFocus || document.hasFocus()) && !!(elem.type || elem.href || ~elem.tabIndex);
        },
        'enabled': function (elem) {
          return elem.disabled === false;
        },
        'disabled': function (elem) {
          return elem.disabled === true;
        },
        'checked': function (elem) {
          var nodeName = elem.nodeName.toLowerCase();
          return nodeName === 'input' && !!elem.checked || nodeName === 'option' && !!elem.selected;
        },
        'selected': function (elem) {
          if (elem.parentNode) {
            elem.parentNode.selectedIndex;
          }
          return elem.selected === true;
        },
        'empty': function (elem) {
          for (elem = elem.firstChild; elem; elem = elem.nextSibling) {
            if (elem.nodeName > '@' || elem.nodeType === 3 || elem.nodeType === 4) {
              return false;
            }
          }
          return true;
        },
        'parent': function (elem) {
          return !Expr.pseudos['empty'](elem);
        },
        'header': function (elem) {
          return rheader.test(elem.nodeName);
        },
        'input': function (elem) {
          return rinputs.test(elem.nodeName);
        },
        'button': function (elem) {
          var name = elem.nodeName.toLowerCase();
          return name === 'input' && elem.type === 'button' || name === 'button';
        },
        'text': function (elem) {
          var attr;
          return elem.nodeName.toLowerCase() === 'input' && elem.type === 'text' && ((attr = elem.getAttribute('type')) == null || attr.toLowerCase() === elem.type);
        },
        'first': createPositionalPseudo(function () {
          return [0];
        }),
        'last': createPositionalPseudo(function (matchIndexes, length) {
          return [length - 1];
        }),
        'eq': createPositionalPseudo(function (matchIndexes, length, argument) {
          return [argument < 0 ? argument + length : argument];
        }),
        'even': createPositionalPseudo(function (matchIndexes, length) {
          var i = 0;
          for (; i < length; i += 2) {
            matchIndexes.push(i);
          }
          return matchIndexes;
        }),
        'odd': createPositionalPseudo(function (matchIndexes, length) {
          var i = 1;
          for (; i < length; i += 2) {
            matchIndexes.push(i);
          }
          return matchIndexes;
        }),
        'lt': createPositionalPseudo(function (matchIndexes, length, argument) {
          var i = argument < 0 ? argument + length : argument;
          for (; --i >= 0;) {
            matchIndexes.push(i);
          }
          return matchIndexes;
        }),
        'gt': createPositionalPseudo(function (matchIndexes, length, argument) {
          var i = argument < 0 ? argument + length : argument;
          for (; ++i < length;) {
            matchIndexes.push(i);
          }
          return matchIndexes;
        })
      }
    };
    Expr.pseudos['nth'] = Expr.pseudos['eq'];
    for (i in {
        radio: true,
        checkbox: true,
        file: true,
        password: true,
        image: true
      }) {
      Expr.pseudos[i] = createInputPseudo(i);
    }
    for (i in {
        submit: true,
        reset: true
      }) {
      Expr.pseudos[i] = createButtonPseudo(i);
    }
    function setFilters() {
    }
    setFilters.prototype = Expr.filters = Expr.pseudos;
    Expr.setFilters = new setFilters();
    function tokenize(selector, parseOnly) {
      var matched, match, tokens, type, soFar, groups, preFilters, cached = tokenCache[selector + ' '];
      if (cached) {
        return parseOnly ? 0 : cached.slice(0);
      }
      soFar = selector;
      groups = [];
      preFilters = Expr.preFilter;
      while (soFar) {
        if (!matched || (match = rcomma.exec(soFar))) {
          if (match) {
            soFar = soFar.slice(match[0].length) || soFar;
          }
          groups.push(tokens = []);
        }
        matched = false;
        if (match = rcombinators.exec(soFar)) {
          matched = match.shift();
          tokens.push({
            value: matched,
            type: match[0].replace(rtrim, ' ')
          });
          soFar = soFar.slice(matched.length);
        }
        for (type in Expr.filter) {
          if ((match = matchExpr[type].exec(soFar)) && (!preFilters[type] || (match = preFilters[type](match)))) {
            matched = match.shift();
            tokens.push({
              value: matched,
              type: type,
              matches: match
            });
            soFar = soFar.slice(matched.length);
          }
        }
        if (!matched) {
          break;
        }
      }
      return parseOnly ? soFar.length : soFar ? Sizzle.error(selector) : tokenCache(selector, groups).slice(0);
    }
    function toSelector(tokens) {
      var i = 0, len = tokens.length, selector = '';
      for (; i < len; i++) {
        selector += tokens[i].value;
      }
      return selector;
    }
    function addCombinator(matcher, combinator, base) {
      var dir = combinator.dir, checkNonElements = base && dir === 'parentNode', doneName = done++;
      return combinator.first ? function (elem, context, xml) {
        while (elem = elem[dir]) {
          if (elem.nodeType === 1 || checkNonElements) {
            return matcher(elem, context, xml);
          }
        }
      } : function (elem, context, xml) {
        var data, cache, outerCache, dirkey = dirruns + ' ' + doneName;
        if (xml) {
          while (elem = elem[dir]) {
            if (elem.nodeType === 1 || checkNonElements) {
              if (matcher(elem, context, xml)) {
                return true;
              }
            }
          }
        } else {
          while (elem = elem[dir]) {
            if (elem.nodeType === 1 || checkNonElements) {
              outerCache = elem[expando] || (elem[expando] = {});
              if ((cache = outerCache[dir]) && cache[0] === dirkey) {
                if ((data = cache[1]) === true || data === cachedruns) {
                  return data === true;
                }
              } else {
                cache = outerCache[dir] = [dirkey];
                cache[1] = matcher(elem, context, xml) || cachedruns;
                if (cache[1] === true) {
                  return true;
                }
              }
            }
          }
        }
      };
    }
    function elementMatcher(matchers) {
      return matchers.length > 1 ? function (elem, context, xml) {
        var i = matchers.length;
        while (i--) {
          if (!matchers[i](elem, context, xml)) {
            return false;
          }
        }
        return true;
      } : matchers[0];
    }
    function condense(unmatched, map, filter, context, xml) {
      var elem, newUnmatched = [], i = 0, len = unmatched.length, mapped = map != null;
      for (; i < len; i++) {
        if (elem = unmatched[i]) {
          if (!filter || filter(elem, context, xml)) {
            newUnmatched.push(elem);
            if (mapped) {
              map.push(i);
            }
          }
        }
      }
      return newUnmatched;
    }
    function setMatcher(preFilter, selector, matcher, postFilter, postFinder, postSelector) {
      if (postFilter && !postFilter[expando]) {
        postFilter = setMatcher(postFilter);
      }
      if (postFinder && !postFinder[expando]) {
        postFinder = setMatcher(postFinder, postSelector);
      }
      return markFunction(function (seed, results, context, xml) {
        var temp, i, elem, preMap = [], postMap = [], preexisting = results.length, elems = seed || multipleContexts(selector || '*', context.nodeType ? [context] : context, []), matcherIn = preFilter && (seed || !selector) ? condense(elems, preMap, preFilter, context, xml) : elems, matcherOut = matcher ? postFinder || (seed ? preFilter : preexisting || postFilter) ? [] : results : matcherIn;
        if (matcher) {
          matcher(matcherIn, matcherOut, context, xml);
        }
        if (postFilter) {
          temp = condense(matcherOut, postMap);
          postFilter(temp, [], context, xml);
          i = temp.length;
          while (i--) {
            if (elem = temp[i]) {
              matcherOut[postMap[i]] = !(matcherIn[postMap[i]] = elem);
            }
          }
        }
        if (seed) {
          if (postFinder || preFilter) {
            if (postFinder) {
              temp = [];
              i = matcherOut.length;
              while (i--) {
                if (elem = matcherOut[i]) {
                  temp.push(matcherIn[i] = elem);
                }
              }
              postFinder(null, matcherOut = [], temp, xml);
            }
            i = matcherOut.length;
            while (i--) {
              if ((elem = matcherOut[i]) && (temp = postFinder ? indexOf.call(seed, elem) : preMap[i]) > -1) {
                seed[temp] = !(results[temp] = elem);
              }
            }
          }
        } else {
          matcherOut = condense(matcherOut === results ? matcherOut.splice(preexisting, matcherOut.length) : matcherOut);
          if (postFinder) {
            postFinder(null, results, matcherOut, xml);
          } else {
            push.apply(results, matcherOut);
          }
        }
      });
    }
    function matcherFromTokens(tokens) {
      var checkContext, matcher, j, len = tokens.length, leadingRelative = Expr.relative[tokens[0].type], implicitRelative = leadingRelative || Expr.relative[' '], i = leadingRelative ? 1 : 0, matchContext = addCombinator(function (elem) {
          return elem === checkContext;
        }, implicitRelative, true), matchAnyContext = addCombinator(function (elem) {
          return indexOf.call(checkContext, elem) > -1;
        }, implicitRelative, true), matchers = [function (elem, context, xml) {
            return !leadingRelative && (xml || context !== outermostContext) || ((checkContext = context).nodeType ? matchContext(elem, context, xml) : matchAnyContext(elem, context, xml));
          }];
      for (; i < len; i++) {
        if (matcher = Expr.relative[tokens[i].type]) {
          matchers = [addCombinator(elementMatcher(matchers), matcher)];
        } else {
          matcher = Expr.filter[tokens[i].type].apply(null, tokens[i].matches);
          if (matcher[expando]) {
            j = ++i;
            for (; j < len; j++) {
              if (Expr.relative[tokens[j].type]) {
                break;
              }
            }
            return setMatcher(i > 1 && elementMatcher(matchers), i > 1 && toSelector(tokens.slice(0, i - 1).concat({ value: tokens[i - 2].type === ' ' ? '*' : '' })).replace(rtrim, '$1'), matcher, i < j && matcherFromTokens(tokens.slice(i, j)), j < len && matcherFromTokens(tokens = tokens.slice(j)), j < len && toSelector(tokens));
          }
          matchers.push(matcher);
        }
      }
      return elementMatcher(matchers);
    }
    function matcherFromGroupMatchers(elementMatchers, setMatchers) {
      var matcherCachedRuns = 0, bySet = setMatchers.length > 0, byElement = elementMatchers.length > 0, superMatcher = function (seed, context, xml, results, expandContext) {
          var elem, j, matcher, setMatched = [], matchedCount = 0, i = '0', unmatched = seed && [], outermost = expandContext != null, contextBackup = outermostContext, elems = seed || byElement && Expr.find['TAG']('*', expandContext && context.parentNode || context), dirrunsUnique = dirruns += contextBackup == null ? 1 : Math.random() || 0.1;
          if (outermost) {
            outermostContext = context !== document && context;
            cachedruns = matcherCachedRuns;
          }
          for (; (elem = elems[i]) != null; i++) {
            if (byElement && elem) {
              j = 0;
              while (matcher = elementMatchers[j++]) {
                if (matcher(elem, context, xml)) {
                  results.push(elem);
                  break;
                }
              }
              if (outermost) {
                dirruns = dirrunsUnique;
                cachedruns = ++matcherCachedRuns;
              }
            }
            if (bySet) {
              if (elem = !matcher && elem) {
                matchedCount--;
              }
              if (seed) {
                unmatched.push(elem);
              }
            }
          }
          matchedCount += i;
          if (bySet && i !== matchedCount) {
            j = 0;
            while (matcher = setMatchers[j++]) {
              matcher(unmatched, setMatched, context, xml);
            }
            if (seed) {
              if (matchedCount > 0) {
                while (i--) {
                  if (!(unmatched[i] || setMatched[i])) {
                    setMatched[i] = pop.call(results);
                  }
                }
              }
              setMatched = condense(setMatched);
            }
            push.apply(results, setMatched);
            if (outermost && !seed && setMatched.length > 0 && matchedCount + setMatchers.length > 1) {
              Sizzle.uniqueSort(results);
            }
          }
          if (outermost) {
            dirruns = dirrunsUnique;
            outermostContext = contextBackup;
          }
          return unmatched;
        };
      return bySet ? markFunction(superMatcher) : superMatcher;
    }
    compile = Sizzle.compile = function (selector, group) {
      var i, setMatchers = [], elementMatchers = [], cached = compilerCache[selector + ' '];
      if (!cached) {
        if (!group) {
          group = tokenize(selector);
        }
        i = group.length;
        while (i--) {
          cached = matcherFromTokens(group[i]);
          if (cached[expando]) {
            setMatchers.push(cached);
          } else {
            elementMatchers.push(cached);
          }
        }
        cached = compilerCache(selector, matcherFromGroupMatchers(elementMatchers, setMatchers));
      }
      return cached;
    };
    function multipleContexts(selector, contexts, results) {
      var i = 0, len = contexts.length;
      for (; i < len; i++) {
        Sizzle(selector, contexts[i], results);
      }
      return results;
    }
    function select(selector, context, results, seed) {
      var i, tokens, token, type, find, match = tokenize(selector);
      if (!seed) {
        if (match.length === 1) {
          tokens = match[0] = match[0].slice(0);
          if (tokens.length > 2 && (token = tokens[0]).type === 'ID' && support.getById && context.nodeType === 9 && documentIsHTML && Expr.relative[tokens[1].type]) {
            context = (Expr.find['ID'](token.matches[0].replace(runescape, funescape), context) || [])[0];
            if (!context) {
              return results;
            }
            selector = selector.slice(tokens.shift().value.length);
          }
          i = matchExpr['needsContext'].test(selector) ? 0 : tokens.length;
          while (i--) {
            token = tokens[i];
            if (Expr.relative[type = token.type]) {
              break;
            }
            if (find = Expr.find[type]) {
              if (seed = find(token.matches[0].replace(runescape, funescape), rsibling.test(tokens[0].type) && context.parentNode || context)) {
                tokens.splice(i, 1);
                selector = seed.length && toSelector(tokens);
                if (!selector) {
                  push.apply(results, seed);
                  return results;
                }
                break;
              }
            }
          }
        }
      }
      compile(selector, match)(seed, context, !documentIsHTML, results, rsibling.test(selector));
      return results;
    }
    support.sortStable = expando.split('').sort(sortOrder).join('') === expando;
    support.detectDuplicates = hasDuplicate;
    setDocument();
    support.sortDetached = assert(function (div1) {
      return div1.compareDocumentPosition(document.createElement('div')) & 1;
    });
    if (!assert(function (div) {
        div.innerHTML = '<a href=\'#\'></a>';
        return div.firstChild.getAttribute('href') === '#';
      })) {
      addHandle('type|href|height|width', function (elem, name, isXML) {
        if (!isXML) {
          return elem.getAttribute(name, name.toLowerCase() === 'type' ? 1 : 2);
        }
      });
    }
    if (!support.attributes || !assert(function (div) {
        div.innerHTML = '<input/>';
        div.firstChild.setAttribute('value', '');
        return div.firstChild.getAttribute('value') === '';
      })) {
      addHandle('value', function (elem, name, isXML) {
        if (!isXML && elem.nodeName.toLowerCase() === 'input') {
          return elem.defaultValue;
        }
      });
    }
    if (!assert(function (div) {
        return div.getAttribute('disabled') == null;
      })) {
      addHandle(booleans, function (elem, name, isXML) {
        var val;
        if (!isXML) {
          return (val = elem.getAttributeNode(name)) && val.specified ? val.value : elem[name] === true ? name.toLowerCase() : null;
        }
      });
    }
    jQuery.find = Sizzle;
    jQuery.expr = Sizzle.selectors;
    jQuery.expr[':'] = jQuery.expr.pseudos;
    jQuery.unique = Sizzle.uniqueSort;
    jQuery.text = Sizzle.getText;
    jQuery.isXMLDoc = Sizzle.isXML;
    jQuery.contains = Sizzle.contains;
  }(window));
  var optionsCache = {};
  function createOptions(options) {
    var object = optionsCache[options] = {};
    jQuery.each(options.match(core_rnotwhite) || [], function (_, flag) {
      object[flag] = true;
    });
    return object;
  }
  jQuery.Callbacks = function (options) {
    options = typeof options === 'string' ? optionsCache[options] || createOptions(options) : jQuery.extend({}, options);
    var firing, memory, fired, firingLength, firingIndex, firingStart, list = [], stack = !options.once && [], fire = function (data) {
        memory = options.memory && data;
        fired = true;
        firingIndex = firingStart || 0;
        firingStart = 0;
        firingLength = list.length;
        firing = true;
        for (; list && firingIndex < firingLength; firingIndex++) {
          if (list[firingIndex].apply(data[0], data[1]) === false && options.stopOnFalse) {
            memory = false;
            break;
          }
        }
        firing = false;
        if (list) {
          if (stack) {
            if (stack.length) {
              fire(stack.shift());
            }
          } else if (memory) {
            list = [];
          } else {
            self.disable();
          }
        }
      }, self = {
        add: function () {
          if (list) {
            var start = list.length;
            (function add(args) {
              jQuery.each(args, function (_, arg) {
                var type = jQuery.type(arg);
                if (type === 'function') {
                  if (!options.unique || !self.has(arg)) {
                    list.push(arg);
                  }
                } else if (arg && arg.length && type !== 'string') {
                  add(arg);
                }
              });
            }(arguments));
            if (firing) {
              firingLength = list.length;
            } else if (memory) {
              firingStart = start;
              fire(memory);
            }
          }
          return this;
        },
        remove: function () {
          if (list) {
            jQuery.each(arguments, function (_, arg) {
              var index;
              while ((index = jQuery.inArray(arg, list, index)) > -1) {
                list.splice(index, 1);
                if (firing) {
                  if (index <= firingLength) {
                    firingLength--;
                  }
                  if (index <= firingIndex) {
                    firingIndex--;
                  }
                }
              }
            });
          }
          return this;
        },
        has: function (fn) {
          return fn ? jQuery.inArray(fn, list) > -1 : !!(list && list.length);
        },
        empty: function () {
          list = [];
          firingLength = 0;
          return this;
        },
        disable: function () {
          list = stack = memory = undefined;
          return this;
        },
        disabled: function () {
          return !list;
        },
        lock: function () {
          stack = undefined;
          if (!memory) {
            self.disable();
          }
          return this;
        },
        locked: function () {
          return !stack;
        },
        fireWith: function (context, args) {
          if (list && (!fired || stack)) {
            args = args || [];
            args = [
              context,
              args.slice ? args.slice() : args
            ];
            if (firing) {
              stack.push(args);
            } else {
              fire(args);
            }
          }
          return this;
        },
        fire: function () {
          self.fireWith(this, arguments);
          return this;
        },
        fired: function () {
          return !!fired;
        }
      };
    return self;
  };
  jQuery.extend({
    Deferred: function (func) {
      var tuples = [
          [
            'resolve',
            'done',
            jQuery.Callbacks('once memory'),
            'resolved'
          ],
          [
            'reject',
            'fail',
            jQuery.Callbacks('once memory'),
            'rejected'
          ],
          [
            'notify',
            'progress',
            jQuery.Callbacks('memory')
          ]
        ], state = 'pending', promise = {
          state: function () {
            return state;
          },
          always: function () {
            deferred.done(arguments).fail(arguments);
            return this;
          },
          then: function () {
            var fns = arguments;
            return jQuery.Deferred(function (newDefer) {
              jQuery.each(tuples, function (i, tuple) {
                var action = tuple[0], fn = jQuery.isFunction(fns[i]) && fns[i];
                deferred[tuple[1]](function () {
                  var returned = fn && fn.apply(this, arguments);
                  if (returned && jQuery.isFunction(returned.promise)) {
                    returned.promise().done(newDefer.resolve).fail(newDefer.reject).progress(newDefer.notify);
                  } else {
                    newDefer[action + 'With'](this === promise ? newDefer.promise() : this, fn ? [returned] : arguments);
                  }
                });
              });
              fns = null;
            }).promise();
          },
          promise: function (obj) {
            return obj != null ? jQuery.extend(obj, promise) : promise;
          }
        }, deferred = {};
      promise.pipe = promise.then;
      jQuery.each(tuples, function (i, tuple) {
        var list = tuple[2], stateString = tuple[3];
        promise[tuple[1]] = list.add;
        if (stateString) {
          list.add(function () {
            state = stateString;
          }, tuples[i ^ 1][2].disable, tuples[2][2].lock);
        }
        deferred[tuple[0]] = function () {
          deferred[tuple[0] + 'With'](this === deferred ? promise : this, arguments);
          return this;
        };
        deferred[tuple[0] + 'With'] = list.fireWith;
      });
      promise.promise(deferred);
      if (func) {
        func.call(deferred, deferred);
      }
      return deferred;
    },
    when: function (subordinate) {
      var i = 0, resolveValues = core_slice.call(arguments), length = resolveValues.length, remaining = length !== 1 || subordinate && jQuery.isFunction(subordinate.promise) ? length : 0, deferred = remaining === 1 ? subordinate : jQuery.Deferred(), updateFunc = function (i, contexts, values) {
          return function (value) {
            contexts[i] = this;
            values[i] = arguments.length > 1 ? core_slice.call(arguments) : value;
            if (values === progressValues) {
              deferred.notifyWith(contexts, values);
            } else if (!--remaining) {
              deferred.resolveWith(contexts, values);
            }
          };
        }, progressValues, progressContexts, resolveContexts;
      if (length > 1) {
        progressValues = new Array(length);
        progressContexts = new Array(length);
        resolveContexts = new Array(length);
        for (; i < length; i++) {
          if (resolveValues[i] && jQuery.isFunction(resolveValues[i].promise)) {
            resolveValues[i].promise().done(updateFunc(i, resolveContexts, resolveValues)).fail(deferred.reject).progress(updateFunc(i, progressContexts, progressValues));
          } else {
            --remaining;
          }
        }
      }
      if (!remaining) {
        deferred.resolveWith(resolveContexts, resolveValues);
      }
      return deferred.promise();
    }
  });
  jQuery.support = function (support) {
    var all, a, input, select, fragment, opt, eventName, isSupported, i, div = document.createElement('div');
    div.setAttribute('className', 't');
    div.innerHTML = '  <link/><table></table><a href=\'/a\'>a</a><input type=\'checkbox\'/>';
    all = div.getElementsByTagName('*') || [];
    a = div.getElementsByTagName('a')[0];
    if (!a || !a.style || !all.length) {
      return support;
    }
    select = document.createElement('select');
    opt = select.appendChild(document.createElement('option'));
    input = div.getElementsByTagName('input')[0];
    a.style.cssText = 'top:1px;float:left;opacity:.5';
    support.getSetAttribute = div.className !== 't';
    support.leadingWhitespace = div.firstChild.nodeType === 3;
    support.tbody = !div.getElementsByTagName('tbody').length;
    support.htmlSerialize = !!div.getElementsByTagName('link').length;
    support.style = /top/.test(a.getAttribute('style'));
    support.hrefNormalized = a.getAttribute('href') === '/a';
    support.opacity = /^0.5/.test(a.style.opacity);
    support.cssFloat = !!a.style.cssFloat;
    support.checkOn = !!input.value;
    support.optSelected = opt.selected;
    support.enctype = !!document.createElement('form').enctype;
    support.html5Clone = document.createElement('nav').cloneNode(true).outerHTML !== '<:nav></:nav>';
    support.inlineBlockNeedsLayout = false;
    support.shrinkWrapBlocks = false;
    support.pixelPosition = false;
    support.deleteExpando = true;
    support.noCloneEvent = true;
    support.reliableMarginRight = true;
    support.boxSizingReliable = true;
    input.checked = true;
    support.noCloneChecked = input.cloneNode(true).checked;
    select.disabled = true;
    support.optDisabled = !opt.disabled;
    try {
      delete div.test;
    } catch (e) {
      support.deleteExpando = false;
    }
    input = document.createElement('input');
    input.setAttribute('value', '');
    support.input = input.getAttribute('value') === '';
    input.value = 't';
    input.setAttribute('type', 'radio');
    support.radioValue = input.value === 't';
    input.setAttribute('checked', 't');
    input.setAttribute('name', 't');
    fragment = document.createDocumentFragment();
    fragment.appendChild(input);
    support.appendChecked = input.checked;
    support.checkClone = fragment.cloneNode(true).cloneNode(true).lastChild.checked;
    if (div.attachEvent) {
      div.attachEvent('onclick', function () {
        support.noCloneEvent = false;
      });
      div.cloneNode(true).click();
    }
    for (i in {
        submit: true,
        change: true,
        focusin: true
      }) {
      div.setAttribute(eventName = 'on' + i, 't');
      support[i + 'Bubbles'] = eventName in window || div.attributes[eventName].expando === false;
    }
    div.style.backgroundClip = 'content-box';
    div.cloneNode(true).style.backgroundClip = '';
    support.clearCloneStyle = div.style.backgroundClip === 'content-box';
    for (i in jQuery(support)) {
      break;
    }
    support.ownLast = i !== '0';
    jQuery(function () {
      var container, marginDiv, tds, divReset = 'padding:0;margin:0;border:0;display:block;box-sizing:content-box;-moz-box-sizing:content-box;-webkit-box-sizing:content-box;', body = document.getElementsByTagName('body')[0];
      if (!body) {
        return;
      }
      container = document.createElement('div');
      container.style.cssText = 'border:0;width:0;height:0;position:absolute;top:0;left:-9999px;margin-top:1px';
      body.appendChild(container).appendChild(div);
      div.innerHTML = '<table><tr><td></td><td>t</td></tr></table>';
      tds = div.getElementsByTagName('td');
      tds[0].style.cssText = 'padding:0;margin:0;border:0;display:none';
      isSupported = tds[0].offsetHeight === 0;
      tds[0].style.display = '';
      tds[1].style.display = 'none';
      support.reliableHiddenOffsets = isSupported && tds[0].offsetHeight === 0;
      div.innerHTML = '';
      div.style.cssText = 'box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;padding:1px;border:1px;display:block;width:4px;margin-top:1%;position:absolute;top:1%;';
      jQuery.swap(body, body.style.zoom != null ? { zoom: 1 } : {}, function () {
        support.boxSizing = div.offsetWidth === 4;
      });
      if (window.getComputedStyle) {
        support.pixelPosition = (window.getComputedStyle(div, null) || {}).top !== '1%';
        support.boxSizingReliable = (window.getComputedStyle(div, null) || { width: '4px' }).width === '4px';
        marginDiv = div.appendChild(document.createElement('div'));
        marginDiv.style.cssText = div.style.cssText = divReset;
        marginDiv.style.marginRight = marginDiv.style.width = '0';
        div.style.width = '1px';
        support.reliableMarginRight = !parseFloat((window.getComputedStyle(marginDiv, null) || {}).marginRight);
      }
      if (typeof div.style.zoom !== core_strundefined) {
        div.innerHTML = '';
        div.style.cssText = divReset + 'width:1px;padding:1px;display:inline;zoom:1';
        support.inlineBlockNeedsLayout = div.offsetWidth === 3;
        div.style.display = 'block';
        div.innerHTML = '<div></div>';
        div.firstChild.style.width = '5px';
        support.shrinkWrapBlocks = div.offsetWidth !== 3;
        if (support.inlineBlockNeedsLayout) {
          body.style.zoom = 1;
        }
      }
      body.removeChild(container);
      container = div = tds = marginDiv = null;
    });
    all = select = fragment = opt = a = input = null;
    return support;
  }({});
  var rbrace = /(?:\{[\s\S]*\}|\[[\s\S]*\])$/, rmultiDash = /([A-Z])/g;
  function internalData(elem, name, data, pvt) {
    if (!jQuery.acceptData(elem)) {
      return;
    }
    var ret, thisCache, internalKey = jQuery.expando, isNode = elem.nodeType, cache = isNode ? jQuery.cache : elem, id = isNode ? elem[internalKey] : elem[internalKey] && internalKey;
    if ((!id || !cache[id] || !pvt && !cache[id].data) && data === undefined && typeof name === 'string') {
      return;
    }
    if (!id) {
      if (isNode) {
        id = elem[internalKey] = core_deletedIds.pop() || jQuery.guid++;
      } else {
        id = internalKey;
      }
    }
    if (!cache[id]) {
      cache[id] = isNode ? {} : { toJSON: jQuery.noop };
    }
    if (typeof name === 'object' || typeof name === 'function') {
      if (pvt) {
        cache[id] = jQuery.extend(cache[id], name);
      } else {
        cache[id].data = jQuery.extend(cache[id].data, name);
      }
    }
    thisCache = cache[id];
    if (!pvt) {
      if (!thisCache.data) {
        thisCache.data = {};
      }
      thisCache = thisCache.data;
    }
    if (data !== undefined) {
      thisCache[jQuery.camelCase(name)] = data;
    }
    if (typeof name === 'string') {
      ret = thisCache[name];
      if (ret == null) {
        ret = thisCache[jQuery.camelCase(name)];
      }
    } else {
      ret = thisCache;
    }
    return ret;
  }
  function internalRemoveData(elem, name, pvt) {
    if (!jQuery.acceptData(elem)) {
      return;
    }
    var thisCache, i, isNode = elem.nodeType, cache = isNode ? jQuery.cache : elem, id = isNode ? elem[jQuery.expando] : jQuery.expando;
    if (!cache[id]) {
      return;
    }
    if (name) {
      thisCache = pvt ? cache[id] : cache[id].data;
      if (thisCache) {
        if (!jQuery.isArray(name)) {
          if (name in thisCache) {
            name = [name];
          } else {
            name = jQuery.camelCase(name);
            if (name in thisCache) {
              name = [name];
            } else {
              name = name.split(' ');
            }
          }
        } else {
          name = name.concat(jQuery.map(name, jQuery.camelCase));
        }
        i = name.length;
        while (i--) {
          delete thisCache[name[i]];
        }
        if (pvt ? !isEmptyDataObject(thisCache) : !jQuery.isEmptyObject(thisCache)) {
          return;
        }
      }
    }
    if (!pvt) {
      delete cache[id].data;
      if (!isEmptyDataObject(cache[id])) {
        return;
      }
    }
    if (isNode) {
      jQuery.cleanData([elem], true);
    } else if (jQuery.support.deleteExpando || cache != cache.window) {
      delete cache[id];
    } else {
      cache[id] = null;
    }
  }
  jQuery.extend({
    cache: {},
    noData: {
      'applet': true,
      'embed': true,
      'object': 'clsid:D27CDB6E-AE6D-11cf-96B8-444553540000'
    },
    hasData: function (elem) {
      elem = elem.nodeType ? jQuery.cache[elem[jQuery.expando]] : elem[jQuery.expando];
      return !!elem && !isEmptyDataObject(elem);
    },
    data: function (elem, name, data) {
      return internalData(elem, name, data);
    },
    removeData: function (elem, name) {
      return internalRemoveData(elem, name);
    },
    _data: function (elem, name, data) {
      return internalData(elem, name, data, true);
    },
    _removeData: function (elem, name) {
      return internalRemoveData(elem, name, true);
    },
    acceptData: function (elem) {
      if (elem.nodeType && elem.nodeType !== 1 && elem.nodeType !== 9) {
        return false;
      }
      var noData = elem.nodeName && jQuery.noData[elem.nodeName.toLowerCase()];
      return !noData || noData !== true && elem.getAttribute('classid') === noData;
    }
  });
  jQuery.fn.extend({
    data: function (key, value) {
      var attrs, name, data = null, i = 0, elem = this[0];
      if (key === undefined) {
        if (this.length) {
          data = jQuery.data(elem);
          if (elem.nodeType === 1 && !jQuery._data(elem, 'parsedAttrs')) {
            attrs = elem.attributes;
            for (; i < attrs.length; i++) {
              name = attrs[i].name;
              if (name.indexOf('data-') === 0) {
                name = jQuery.camelCase(name.slice(5));
                dataAttr(elem, name, data[name]);
              }
            }
            jQuery._data(elem, 'parsedAttrs', true);
          }
        }
        return data;
      }
      if (typeof key === 'object') {
        return this.each(function () {
          jQuery.data(this, key);
        });
      }
      return arguments.length > 1 ? this.each(function () {
        jQuery.data(this, key, value);
      }) : elem ? dataAttr(elem, key, jQuery.data(elem, key)) : null;
    },
    removeData: function (key) {
      return this.each(function () {
        jQuery.removeData(this, key);
      });
    }
  });
  function dataAttr(elem, key, data) {
    if (data === undefined && elem.nodeType === 1) {
      var name = 'data-' + key.replace(rmultiDash, '-$1').toLowerCase();
      data = elem.getAttribute(name);
      if (typeof data === 'string') {
        try {
          data = data === 'true' ? true : data === 'false' ? false : data === 'null' ? null : +data + '' === data ? +data : rbrace.test(data) ? jQuery.parseJSON(data) : data;
        } catch (e) {
        }
        jQuery.data(elem, key, data);
      } else {
        data = undefined;
      }
    }
    return data;
  }
  function isEmptyDataObject(obj) {
    var name;
    for (name in obj) {
      if (name === 'data' && jQuery.isEmptyObject(obj[name])) {
        continue;
      }
      if (name !== 'toJSON') {
        return false;
      }
    }
    return true;
  }
  jQuery.extend({
    queue: function (elem, type, data) {
      var queue;
      if (elem) {
        type = (type || 'fx') + 'queue';
        queue = jQuery._data(elem, type);
        if (data) {
          if (!queue || jQuery.isArray(data)) {
            queue = jQuery._data(elem, type, jQuery.makeArray(data));
          } else {
            queue.push(data);
          }
        }
        return queue || [];
      }
    },
    dequeue: function (elem, type) {
      type = type || 'fx';
      var queue = jQuery.queue(elem, type), startLength = queue.length, fn = queue.shift(), hooks = jQuery._queueHooks(elem, type), next = function () {
          jQuery.dequeue(elem, type);
        };
      if (fn === 'inprogress') {
        fn = queue.shift();
        startLength--;
      }
      if (fn) {
        if (type === 'fx') {
          queue.unshift('inprogress');
        }
        delete hooks.stop;
        fn.call(elem, next, hooks);
      }
      if (!startLength && hooks) {
        hooks.empty.fire();
      }
    },
    _queueHooks: function (elem, type) {
      var key = type + 'queueHooks';
      return jQuery._data(elem, key) || jQuery._data(elem, key, {
        empty: jQuery.Callbacks('once memory').add(function () {
          jQuery._removeData(elem, type + 'queue');
          jQuery._removeData(elem, key);
        })
      });
    }
  });
  jQuery.fn.extend({
    queue: function (type, data) {
      var setter = 2;
      if (typeof type !== 'string') {
        data = type;
        type = 'fx';
        setter--;
      }
      if (arguments.length < setter) {
        return jQuery.queue(this[0], type);
      }
      return data === undefined ? this : this.each(function () {
        var queue = jQuery.queue(this, type, data);
        jQuery._queueHooks(this, type);
        if (type === 'fx' && queue[0] !== 'inprogress') {
          jQuery.dequeue(this, type);
        }
      });
    },
    dequeue: function (type) {
      return this.each(function () {
        jQuery.dequeue(this, type);
      });
    },
    delay: function (time, type) {
      time = jQuery.fx ? jQuery.fx.speeds[time] || time : time;
      type = type || 'fx';
      return this.queue(type, function (next, hooks) {
        var timeout = setTimeout(next, time);
        hooks.stop = function () {
          clearTimeout(timeout);
        };
      });
    },
    clearQueue: function (type) {
      return this.queue(type || 'fx', []);
    },
    promise: function (type, obj) {
      var tmp, count = 1, defer = jQuery.Deferred(), elements = this, i = this.length, resolve = function () {
          if (!--count) {
            defer.resolveWith(elements, [elements]);
          }
        };
      if (typeof type !== 'string') {
        obj = type;
        type = undefined;
      }
      type = type || 'fx';
      while (i--) {
        tmp = jQuery._data(elements[i], type + 'queueHooks');
        if (tmp && tmp.empty) {
          count++;
          tmp.empty.add(resolve);
        }
      }
      resolve();
      return defer.promise(obj);
    }
  });
  var nodeHook, boolHook, rclass = /[\t\r\n\f]/g, rreturn = /\r/g, rfocusable = /^(?:input|select|textarea|button|object)$/i, rclickable = /^(?:a|area)$/i, ruseDefault = /^(?:checked|selected)$/i, getSetAttribute = jQuery.support.getSetAttribute, getSetInput = jQuery.support.input;
  jQuery.fn.extend({
    attr: function (name, value) {
      return jQuery.access(this, jQuery.attr, name, value, arguments.length > 1);
    },
    removeAttr: function (name) {
      return this.each(function () {
        jQuery.removeAttr(this, name);
      });
    },
    prop: function (name, value) {
      return jQuery.access(this, jQuery.prop, name, value, arguments.length > 1);
    },
    removeProp: function (name) {
      name = jQuery.propFix[name] || name;
      return this.each(function () {
        try {
          this[name] = undefined;
          delete this[name];
        } catch (e) {
        }
      });
    },
    addClass: function (value) {
      var classes, elem, cur, clazz, j, i = 0, len = this.length, proceed = typeof value === 'string' && value;
      if (jQuery.isFunction(value)) {
        return this.each(function (j) {
          jQuery(this).addClass(value.call(this, j, this.className));
        });
      }
      if (proceed) {
        classes = (value || '').match(core_rnotwhite) || [];
        for (; i < len; i++) {
          elem = this[i];
          cur = elem.nodeType === 1 && (elem.className ? (' ' + elem.className + ' ').replace(rclass, ' ') : ' ');
          if (cur) {
            j = 0;
            while (clazz = classes[j++]) {
              if (cur.indexOf(' ' + clazz + ' ') < 0) {
                cur += clazz + ' ';
              }
            }
            elem.className = jQuery.trim(cur);
          }
        }
      }
      return this;
    },
    removeClass: function (value) {
      var classes, elem, cur, clazz, j, i = 0, len = this.length, proceed = arguments.length === 0 || typeof value === 'string' && value;
      if (jQuery.isFunction(value)) {
        return this.each(function (j) {
          jQuery(this).removeClass(value.call(this, j, this.className));
        });
      }
      if (proceed) {
        classes = (value || '').match(core_rnotwhite) || [];
        for (; i < len; i++) {
          elem = this[i];
          cur = elem.nodeType === 1 && (elem.className ? (' ' + elem.className + ' ').replace(rclass, ' ') : '');
          if (cur) {
            j = 0;
            while (clazz = classes[j++]) {
              while (cur.indexOf(' ' + clazz + ' ') >= 0) {
                cur = cur.replace(' ' + clazz + ' ', ' ');
              }
            }
            elem.className = value ? jQuery.trim(cur) : '';
          }
        }
      }
      return this;
    },
    toggleClass: function (value, stateVal) {
      var type = typeof value;
      if (typeof stateVal === 'boolean' && type === 'string') {
        return stateVal ? this.addClass(value) : this.removeClass(value);
      }
      if (jQuery.isFunction(value)) {
        return this.each(function (i) {
          jQuery(this).toggleClass(value.call(this, i, this.className, stateVal), stateVal);
        });
      }
      return this.each(function () {
        if (type === 'string') {
          var className, i = 0, self = jQuery(this), classNames = value.match(core_rnotwhite) || [];
          while (className = classNames[i++]) {
            if (self.hasClass(className)) {
              self.removeClass(className);
            } else {
              self.addClass(className);
            }
          }
        } else if (type === core_strundefined || type === 'boolean') {
          if (this.className) {
            jQuery._data(this, '__className__', this.className);
          }
          this.className = this.className || value === false ? '' : jQuery._data(this, '__className__') || '';
        }
      });
    },
    hasClass: function (selector) {
      var className = ' ' + selector + ' ', i = 0, l = this.length;
      for (; i < l; i++) {
        if (this[i].nodeType === 1 && (' ' + this[i].className + ' ').replace(rclass, ' ').indexOf(className) >= 0) {
          return true;
        }
      }
      return false;
    },
    val: function (value) {
      var ret, hooks, isFunction, elem = this[0];
      if (!arguments.length) {
        if (elem) {
          hooks = jQuery.valHooks[elem.type] || jQuery.valHooks[elem.nodeName.toLowerCase()];
          if (hooks && 'get' in hooks && (ret = hooks.get(elem, 'value')) !== undefined) {
            return ret;
          }
          ret = elem.value;
          return typeof ret === 'string' ? ret.replace(rreturn, '') : ret == null ? '' : ret;
        }
        return;
      }
      isFunction = jQuery.isFunction(value);
      return this.each(function (i) {
        var val;
        if (this.nodeType !== 1) {
          return;
        }
        if (isFunction) {
          val = value.call(this, i, jQuery(this).val());
        } else {
          val = value;
        }
        if (val == null) {
          val = '';
        } else if (typeof val === 'number') {
          val += '';
        } else if (jQuery.isArray(val)) {
          val = jQuery.map(val, function (value) {
            return value == null ? '' : value + '';
          });
        }
        hooks = jQuery.valHooks[this.type] || jQuery.valHooks[this.nodeName.toLowerCase()];
        if (!hooks || !('set' in hooks) || hooks.set(this, val, 'value') === undefined) {
          this.value = val;
        }
      });
    }
  });
  jQuery.extend({
    valHooks: {
      option: {
        get: function (elem) {
          var val = jQuery.find.attr(elem, 'value');
          return val != null ? val : elem.text;
        }
      },
      select: {
        get: function (elem) {
          var value, option, options = elem.options, index = elem.selectedIndex, one = elem.type === 'select-one' || index < 0, values = one ? null : [], max = one ? index + 1 : options.length, i = index < 0 ? max : one ? index : 0;
          for (; i < max; i++) {
            option = options[i];
            if ((option.selected || i === index) && (jQuery.support.optDisabled ? !option.disabled : option.getAttribute('disabled') === null) && (!option.parentNode.disabled || !jQuery.nodeName(option.parentNode, 'optgroup'))) {
              value = jQuery(option).val();
              if (one) {
                return value;
              }
              values.push(value);
            }
          }
          return values;
        },
        set: function (elem, value) {
          var optionSet, option, options = elem.options, values = jQuery.makeArray(value), i = options.length;
          while (i--) {
            option = options[i];
            if (option.selected = jQuery.inArray(jQuery(option).val(), values) >= 0) {
              optionSet = true;
            }
          }
          if (!optionSet) {
            elem.selectedIndex = -1;
          }
          return values;
        }
      }
    },
    attr: function (elem, name, value) {
      var hooks, ret, nType = elem.nodeType;
      if (!elem || nType === 3 || nType === 8 || nType === 2) {
        return;
      }
      if (typeof elem.getAttribute === core_strundefined) {
        return jQuery.prop(elem, name, value);
      }
      if (nType !== 1 || !jQuery.isXMLDoc(elem)) {
        name = name.toLowerCase();
        hooks = jQuery.attrHooks[name] || (jQuery.expr.match.bool.test(name) ? boolHook : nodeHook);
      }
      if (value !== undefined) {
        if (value === null) {
          jQuery.removeAttr(elem, name);
        } else if (hooks && 'set' in hooks && (ret = hooks.set(elem, value, name)) !== undefined) {
          return ret;
        } else {
          elem.setAttribute(name, value + '');
          return value;
        }
      } else if (hooks && 'get' in hooks && (ret = hooks.get(elem, name)) !== null) {
        return ret;
      } else {
        ret = jQuery.find.attr(elem, name);
        return ret == null ? undefined : ret;
      }
    },
    removeAttr: function (elem, value) {
      var name, propName, i = 0, attrNames = value && value.match(core_rnotwhite);
      if (attrNames && elem.nodeType === 1) {
        while (name = attrNames[i++]) {
          propName = jQuery.propFix[name] || name;
          if (jQuery.expr.match.bool.test(name)) {
            if (getSetInput && getSetAttribute || !ruseDefault.test(name)) {
              elem[propName] = false;
            } else {
              elem[jQuery.camelCase('default-' + name)] = elem[propName] = false;
            }
          } else {
            jQuery.attr(elem, name, '');
          }
          elem.removeAttribute(getSetAttribute ? name : propName);
        }
      }
    },
    attrHooks: {
      type: {
        set: function (elem, value) {
          if (!jQuery.support.radioValue && value === 'radio' && jQuery.nodeName(elem, 'input')) {
            var val = elem.value;
            elem.setAttribute('type', value);
            if (val) {
              elem.value = val;
            }
            return value;
          }
        }
      }
    },
    propFix: {
      'for': 'htmlFor',
      'class': 'className'
    },
    prop: function (elem, name, value) {
      var ret, hooks, notxml, nType = elem.nodeType;
      if (!elem || nType === 3 || nType === 8 || nType === 2) {
        return;
      }
      notxml = nType !== 1 || !jQuery.isXMLDoc(elem);
      if (notxml) {
        name = jQuery.propFix[name] || name;
        hooks = jQuery.propHooks[name];
      }
      if (value !== undefined) {
        return hooks && 'set' in hooks && (ret = hooks.set(elem, value, name)) !== undefined ? ret : elem[name] = value;
      } else {
        return hooks && 'get' in hooks && (ret = hooks.get(elem, name)) !== null ? ret : elem[name];
      }
    },
    propHooks: {
      tabIndex: {
        get: function (elem) {
          var tabindex = jQuery.find.attr(elem, 'tabindex');
          return tabindex ? parseInt(tabindex, 10) : rfocusable.test(elem.nodeName) || rclickable.test(elem.nodeName) && elem.href ? 0 : -1;
        }
      }
    }
  });
  boolHook = {
    set: function (elem, value, name) {
      if (value === false) {
        jQuery.removeAttr(elem, name);
      } else if (getSetInput && getSetAttribute || !ruseDefault.test(name)) {
        elem.setAttribute(!getSetAttribute && jQuery.propFix[name] || name, name);
      } else {
        elem[jQuery.camelCase('default-' + name)] = elem[name] = true;
      }
      return name;
    }
  };
  jQuery.each(jQuery.expr.match.bool.source.match(/\w+/g), function (i, name) {
    var getter = jQuery.expr.attrHandle[name] || jQuery.find.attr;
    jQuery.expr.attrHandle[name] = getSetInput && getSetAttribute || !ruseDefault.test(name) ? function (elem, name, isXML) {
      var fn = jQuery.expr.attrHandle[name], ret = isXML ? undefined : (jQuery.expr.attrHandle[name] = undefined) != getter(elem, name, isXML) ? name.toLowerCase() : null;
      jQuery.expr.attrHandle[name] = fn;
      return ret;
    } : function (elem, name, isXML) {
      return isXML ? undefined : elem[jQuery.camelCase('default-' + name)] ? name.toLowerCase() : null;
    };
  });
  if (!getSetInput || !getSetAttribute) {
    jQuery.attrHooks.value = {
      set: function (elem, value, name) {
        if (jQuery.nodeName(elem, 'input')) {
          elem.defaultValue = value;
        } else {
          return nodeHook && nodeHook.set(elem, value, name);
        }
      }
    };
  }
  if (!getSetAttribute) {
    nodeHook = {
      set: function (elem, value, name) {
        var ret = elem.getAttributeNode(name);
        if (!ret) {
          elem.setAttributeNode(ret = elem.ownerDocument.createAttribute(name));
        }
        ret.value = value += '';
        return name === 'value' || value === elem.getAttribute(name) ? value : undefined;
      }
    };
    jQuery.expr.attrHandle.id = jQuery.expr.attrHandle.name = jQuery.expr.attrHandle.coords = function (elem, name, isXML) {
      var ret;
      return isXML ? undefined : (ret = elem.getAttributeNode(name)) && ret.value !== '' ? ret.value : null;
    };
    jQuery.valHooks.button = {
      get: function (elem, name) {
        var ret = elem.getAttributeNode(name);
        return ret && ret.specified ? ret.value : undefined;
      },
      set: nodeHook.set
    };
    jQuery.attrHooks.contenteditable = {
      set: function (elem, value, name) {
        nodeHook.set(elem, value === '' ? false : value, name);
      }
    };
    jQuery.each([
      'width',
      'height'
    ], function (i, name) {
      jQuery.attrHooks[name] = {
        set: function (elem, value) {
          if (value === '') {
            elem.setAttribute(name, 'auto');
            return value;
          }
        }
      };
    });
  }
  if (!jQuery.support.hrefNormalized) {
    jQuery.each([
      'href',
      'src'
    ], function (i, name) {
      jQuery.propHooks[name] = {
        get: function (elem) {
          return elem.getAttribute(name, 4);
        }
      };
    });
  }
  if (!jQuery.support.style) {
    jQuery.attrHooks.style = {
      get: function (elem) {
        return elem.style.cssText || undefined;
      },
      set: function (elem, value) {
        return elem.style.cssText = value + '';
      }
    };
  }
  if (!jQuery.support.optSelected) {
    jQuery.propHooks.selected = {
      get: function (elem) {
        var parent = elem.parentNode;
        if (parent) {
          parent.selectedIndex;
          if (parent.parentNode) {
            parent.parentNode.selectedIndex;
          }
        }
        return null;
      }
    };
  }
  jQuery.each([
    'tabIndex',
    'readOnly',
    'maxLength',
    'cellSpacing',
    'cellPadding',
    'rowSpan',
    'colSpan',
    'useMap',
    'frameBorder',
    'contentEditable'
  ], function () {
    jQuery.propFix[this.toLowerCase()] = this;
  });
  if (!jQuery.support.enctype) {
    jQuery.propFix.enctype = 'encoding';
  }
  jQuery.each([
    'radio',
    'checkbox'
  ], function () {
    jQuery.valHooks[this] = {
      set: function (elem, value) {
        if (jQuery.isArray(value)) {
          return elem.checked = jQuery.inArray(jQuery(elem).val(), value) >= 0;
        }
      }
    };
    if (!jQuery.support.checkOn) {
      jQuery.valHooks[this].get = function (elem) {
        return elem.getAttribute('value') === null ? 'on' : elem.value;
      };
    }
  });
  var rformElems = /^(?:input|select|textarea)$/i, rkeyEvent = /^key/, rmouseEvent = /^(?:mouse|contextmenu)|click/, rfocusMorph = /^(?:focusinfocus|focusoutblur)$/, rtypenamespace = /^([^.]*)(?:\.(.+)|)$/;
  function returnTrue() {
    return true;
  }
  function returnFalse() {
    return false;
  }
  function safeActiveElement() {
    try {
      return document.activeElement;
    } catch (err) {
    }
  }
  jQuery.event = {
    global: {},
    add: function (elem, types, handler, data, selector) {
      var tmp, events, t, handleObjIn, special, eventHandle, handleObj, handlers, type, namespaces, origType, elemData = jQuery._data(elem);
      if (!elemData) {
        return;
      }
      if (handler.handler) {
        handleObjIn = handler;
        handler = handleObjIn.handler;
        selector = handleObjIn.selector;
      }
      if (!handler.guid) {
        handler.guid = jQuery.guid++;
      }
      if (!(events = elemData.events)) {
        events = elemData.events = {};
      }
      if (!(eventHandle = elemData.handle)) {
        eventHandle = elemData.handle = function (e) {
          return typeof jQuery !== core_strundefined && (!e || jQuery.event.triggered !== e.type) ? jQuery.event.dispatch.apply(eventHandle.elem, arguments) : undefined;
        };
        eventHandle.elem = elem;
      }
      types = (types || '').match(core_rnotwhite) || [''];
      t = types.length;
      while (t--) {
        tmp = rtypenamespace.exec(types[t]) || [];
        type = origType = tmp[1];
        namespaces = (tmp[2] || '').split('.').sort();
        if (!type) {
          continue;
        }
        special = jQuery.event.special[type] || {};
        type = (selector ? special.delegateType : special.bindType) || type;
        special = jQuery.event.special[type] || {};
        handleObj = jQuery.extend({
          type: type,
          origType: origType,
          data: data,
          handler: handler,
          guid: handler.guid,
          selector: selector,
          needsContext: selector && jQuery.expr.match.needsContext.test(selector),
          namespace: namespaces.join('.')
        }, handleObjIn);
        if (!(handlers = events[type])) {
          handlers = events[type] = [];
          handlers.delegateCount = 0;
          if (!special.setup || special.setup.call(elem, data, namespaces, eventHandle) === false) {
            if (elem.addEventListener) {
              elem.addEventListener(type, eventHandle, false);
            } else if (elem.attachEvent) {
              elem.attachEvent('on' + type, eventHandle);
            }
          }
        }
        if (special.add) {
          special.add.call(elem, handleObj);
          if (!handleObj.handler.guid) {
            handleObj.handler.guid = handler.guid;
          }
        }
        if (selector) {
          handlers.splice(handlers.delegateCount++, 0, handleObj);
        } else {
          handlers.push(handleObj);
        }
        jQuery.event.global[type] = true;
      }
      elem = null;
    },
    remove: function (elem, types, handler, selector, mappedTypes) {
      var j, handleObj, tmp, origCount, t, events, special, handlers, type, namespaces, origType, elemData = jQuery.hasData(elem) && jQuery._data(elem);
      if (!elemData || !(events = elemData.events)) {
        return;
      }
      types = (types || '').match(core_rnotwhite) || [''];
      t = types.length;
      while (t--) {
        tmp = rtypenamespace.exec(types[t]) || [];
        type = origType = tmp[1];
        namespaces = (tmp[2] || '').split('.').sort();
        if (!type) {
          for (type in events) {
            jQuery.event.remove(elem, type + types[t], handler, selector, true);
          }
          continue;
        }
        special = jQuery.event.special[type] || {};
        type = (selector ? special.delegateType : special.bindType) || type;
        handlers = events[type] || [];
        tmp = tmp[2] && new RegExp('(^|\\.)' + namespaces.join('\\.(?:.*\\.|)') + '(\\.|$)');
        origCount = j = handlers.length;
        while (j--) {
          handleObj = handlers[j];
          if ((mappedTypes || origType === handleObj.origType) && (!handler || handler.guid === handleObj.guid) && (!tmp || tmp.test(handleObj.namespace)) && (!selector || selector === handleObj.selector || selector === '**' && handleObj.selector)) {
            handlers.splice(j, 1);
            if (handleObj.selector) {
              handlers.delegateCount--;
            }
            if (special.remove) {
              special.remove.call(elem, handleObj);
            }
          }
        }
        if (origCount && !handlers.length) {
          if (!special.teardown || special.teardown.call(elem, namespaces, elemData.handle) === false) {
            jQuery.removeEvent(elem, type, elemData.handle);
          }
          delete events[type];
        }
      }
      if (jQuery.isEmptyObject(events)) {
        delete elemData.handle;
        jQuery._removeData(elem, 'events');
      }
    },
    trigger: function (event, data, elem, onlyHandlers) {
      var handle, ontype, cur, bubbleType, special, tmp, i, eventPath = [elem || document], type = core_hasOwn.call(event, 'type') ? event.type : event, namespaces = core_hasOwn.call(event, 'namespace') ? event.namespace.split('.') : [];
      cur = tmp = elem = elem || document;
      if (elem.nodeType === 3 || elem.nodeType === 8) {
        return;
      }
      if (rfocusMorph.test(type + jQuery.event.triggered)) {
        return;
      }
      if (type.indexOf('.') >= 0) {
        namespaces = type.split('.');
        type = namespaces.shift();
        namespaces.sort();
      }
      ontype = type.indexOf(':') < 0 && 'on' + type;
      event = event[jQuery.expando] ? event : new jQuery.Event(type, typeof event === 'object' && event);
      event.isTrigger = onlyHandlers ? 2 : 3;
      event.namespace = namespaces.join('.');
      event.namespace_re = event.namespace ? new RegExp('(^|\\.)' + namespaces.join('\\.(?:.*\\.|)') + '(\\.|$)') : null;
      event.result = undefined;
      if (!event.target) {
        event.target = elem;
      }
      data = data == null ? [event] : jQuery.makeArray(data, [event]);
      special = jQuery.event.special[type] || {};
      if (!onlyHandlers && special.trigger && special.trigger.apply(elem, data) === false) {
        return;
      }
      if (!onlyHandlers && !special.noBubble && !jQuery.isWindow(elem)) {
        bubbleType = special.delegateType || type;
        if (!rfocusMorph.test(bubbleType + type)) {
          cur = cur.parentNode;
        }
        for (; cur; cur = cur.parentNode) {
          eventPath.push(cur);
          tmp = cur;
        }
        if (tmp === (elem.ownerDocument || document)) {
          eventPath.push(tmp.defaultView || tmp.parentWindow || window);
        }
      }
      i = 0;
      while ((cur = eventPath[i++]) && !event.isPropagationStopped()) {
        event.type = i > 1 ? bubbleType : special.bindType || type;
        handle = (jQuery._data(cur, 'events') || {})[event.type] && jQuery._data(cur, 'handle');
        if (handle) {
          handle.apply(cur, data);
        }
        handle = ontype && cur[ontype];
        if (handle && jQuery.acceptData(cur) && handle.apply && handle.apply(cur, data) === false) {
          event.preventDefault();
        }
      }
      event.type = type;
      if (!onlyHandlers && !event.isDefaultPrevented()) {
        if ((!special._default || special._default.apply(eventPath.pop(), data) === false) && jQuery.acceptData(elem)) {
          if (ontype && elem[type] && !jQuery.isWindow(elem)) {
            tmp = elem[ontype];
            if (tmp) {
              elem[ontype] = null;
            }
            jQuery.event.triggered = type;
            try {
              elem[type]();
            } catch (e) {
            }
            jQuery.event.triggered = undefined;
            if (tmp) {
              elem[ontype] = tmp;
            }
          }
        }
      }
      return event.result;
    },
    dispatch: function (event) {
      event = jQuery.event.fix(event);
      var i, ret, handleObj, matched, j, handlerQueue = [], args = core_slice.call(arguments), handlers = (jQuery._data(this, 'events') || {})[event.type] || [], special = jQuery.event.special[event.type] || {};
      args[0] = event;
      event.delegateTarget = this;
      if (special.preDispatch && special.preDispatch.call(this, event) === false) {
        return;
      }
      handlerQueue = jQuery.event.handlers.call(this, event, handlers);
      i = 0;
      while ((matched = handlerQueue[i++]) && !event.isPropagationStopped()) {
        event.currentTarget = matched.elem;
        j = 0;
        while ((handleObj = matched.handlers[j++]) && !event.isImmediatePropagationStopped()) {
          if (!event.namespace_re || event.namespace_re.test(handleObj.namespace)) {
            event.handleObj = handleObj;
            event.data = handleObj.data;
            ret = ((jQuery.event.special[handleObj.origType] || {}).handle || handleObj.handler).apply(matched.elem, args);
            if (ret !== undefined) {
              if ((event.result = ret) === false) {
                event.preventDefault();
                event.stopPropagation();
              }
            }
          }
        }
      }
      if (special.postDispatch) {
        special.postDispatch.call(this, event);
      }
      return event.result;
    },
    handlers: function (event, handlers) {
      var sel, handleObj, matches, i, handlerQueue = [], delegateCount = handlers.delegateCount, cur = event.target;
      if (delegateCount && cur.nodeType && (!event.button || event.type !== 'click')) {
        for (; cur != this; cur = cur.parentNode || this) {
          if (cur.nodeType === 1 && (cur.disabled !== true || event.type !== 'click')) {
            matches = [];
            for (i = 0; i < delegateCount; i++) {
              handleObj = handlers[i];
              sel = handleObj.selector + ' ';
              if (matches[sel] === undefined) {
                matches[sel] = handleObj.needsContext ? jQuery(sel, this).index(cur) >= 0 : jQuery.find(sel, this, null, [cur]).length;
              }
              if (matches[sel]) {
                matches.push(handleObj);
              }
            }
            if (matches.length) {
              handlerQueue.push({
                elem: cur,
                handlers: matches
              });
            }
          }
        }
      }
      if (delegateCount < handlers.length) {
        handlerQueue.push({
          elem: this,
          handlers: handlers.slice(delegateCount)
        });
      }
      return handlerQueue;
    },
    fix: function (event) {
      if (event[jQuery.expando]) {
        return event;
      }
      var i, prop, copy, type = event.type, originalEvent = event, fixHook = this.fixHooks[type];
      if (!fixHook) {
        this.fixHooks[type] = fixHook = rmouseEvent.test(type) ? this.mouseHooks : rkeyEvent.test(type) ? this.keyHooks : {};
      }
      copy = fixHook.props ? this.props.concat(fixHook.props) : this.props;
      event = new jQuery.Event(originalEvent);
      i = copy.length;
      while (i--) {
        prop = copy[i];
        event[prop] = originalEvent[prop];
      }
      if (!event.target) {
        event.target = originalEvent.srcElement || document;
      }
      if (event.target.nodeType === 3) {
        event.target = event.target.parentNode;
      }
      event.metaKey = !!event.metaKey;
      return fixHook.filter ? fixHook.filter(event, originalEvent) : event;
    },
    props: 'altKey bubbles cancelable ctrlKey currentTarget eventPhase metaKey relatedTarget shiftKey target timeStamp view which'.split(' '),
    fixHooks: {},
    keyHooks: {
      props: 'char charCode key keyCode'.split(' '),
      filter: function (event, original) {
        if (event.which == null) {
          event.which = original.charCode != null ? original.charCode : original.keyCode;
        }
        return event;
      }
    },
    mouseHooks: {
      props: 'button buttons clientX clientY fromElement offsetX offsetY pageX pageY screenX screenY toElement'.split(' '),
      filter: function (event, original) {
        var body, eventDoc, doc, button = original.button, fromElement = original.fromElement;
        if (event.pageX == null && original.clientX != null) {
          eventDoc = event.target.ownerDocument || document;
          doc = eventDoc.documentElement;
          body = eventDoc.body;
          event.pageX = original.clientX + (doc && doc.scrollLeft || body && body.scrollLeft || 0) - (doc && doc.clientLeft || body && body.clientLeft || 0);
          event.pageY = original.clientY + (doc && doc.scrollTop || body && body.scrollTop || 0) - (doc && doc.clientTop || body && body.clientTop || 0);
        }
        if (!event.relatedTarget && fromElement) {
          event.relatedTarget = fromElement === event.target ? original.toElement : fromElement;
        }
        if (!event.which && button !== undefined) {
          event.which = button & 1 ? 1 : button & 2 ? 3 : button & 4 ? 2 : 0;
        }
        return event;
      }
    },
    special: {
      load: { noBubble: true },
      focus: {
        trigger: function () {
          if (this !== safeActiveElement() && this.focus) {
            try {
              this.focus();
              return false;
            } catch (e) {
            }
          }
        },
        delegateType: 'focusin'
      },
      blur: {
        trigger: function () {
          if (this === safeActiveElement() && this.blur) {
            this.blur();
            return false;
          }
        },
        delegateType: 'focusout'
      },
      click: {
        trigger: function () {
          if (jQuery.nodeName(this, 'input') && this.type === 'checkbox' && this.click) {
            this.click();
            return false;
          }
        },
        _default: function (event) {
          return jQuery.nodeName(event.target, 'a');
        }
      },
      beforeunload: {
        postDispatch: function (event) {
          if (event.result !== undefined) {
            event.originalEvent.returnValue = event.result;
          }
        }
      }
    },
    simulate: function (type, elem, event, bubble) {
      var e = jQuery.extend(new jQuery.Event(), event, {
          type: type,
          isSimulated: true,
          originalEvent: {}
        });
      if (bubble) {
        jQuery.event.trigger(e, null, elem);
      } else {
        jQuery.event.dispatch.call(elem, e);
      }
      if (e.isDefaultPrevented()) {
        event.preventDefault();
      }
    }
  };
  jQuery.removeEvent = document.removeEventListener ? function (elem, type, handle) {
    if (elem.removeEventListener) {
      elem.removeEventListener(type, handle, false);
    }
  } : function (elem, type, handle) {
    var name = 'on' + type;
    if (elem.detachEvent) {
      if (typeof elem[name] === core_strundefined) {
        elem[name] = null;
      }
      elem.detachEvent(name, handle);
    }
  };
  jQuery.Event = function (src, props) {
    if (!(this instanceof jQuery.Event)) {
      return new jQuery.Event(src, props);
    }
    if (src && src.type) {
      this.originalEvent = src;
      this.type = src.type;
      this.isDefaultPrevented = src.defaultPrevented || src.returnValue === false || src.getPreventDefault && src.getPreventDefault() ? returnTrue : returnFalse;
    } else {
      this.type = src;
    }
    if (props) {
      jQuery.extend(this, props);
    }
    this.timeStamp = src && src.timeStamp || jQuery.now();
    this[jQuery.expando] = true;
  };
  jQuery.Event.prototype = {
    isDefaultPrevented: returnFalse,
    isPropagationStopped: returnFalse,
    isImmediatePropagationStopped: returnFalse,
    preventDefault: function () {
      var e = this.originalEvent;
      this.isDefaultPrevented = returnTrue;
      if (!e) {
        return;
      }
      if (e.preventDefault) {
        e.preventDefault();
      } else {
        e.returnValue = false;
      }
    },
    stopPropagation: function () {
      var e = this.originalEvent;
      this.isPropagationStopped = returnTrue;
      if (!e) {
        return;
      }
      if (e.stopPropagation) {
        e.stopPropagation();
      }
      e.cancelBubble = true;
    },
    stopImmediatePropagation: function () {
      this.isImmediatePropagationStopped = returnTrue;
      this.stopPropagation();
    }
  };
  jQuery.each({
    mouseenter: 'mouseover',
    mouseleave: 'mouseout'
  }, function (orig, fix) {
    jQuery.event.special[orig] = {
      delegateType: fix,
      bindType: fix,
      handle: function (event) {
        var ret, target = this, related = event.relatedTarget, handleObj = event.handleObj;
        if (!related || related !== target && !jQuery.contains(target, related)) {
          event.type = handleObj.origType;
          ret = handleObj.handler.apply(this, arguments);
          event.type = fix;
        }
        return ret;
      }
    };
  });
  if (!jQuery.support.submitBubbles) {
    jQuery.event.special.submit = {
      setup: function () {
        if (jQuery.nodeName(this, 'form')) {
          return false;
        }
        jQuery.event.add(this, 'click._submit keypress._submit', function (e) {
          var elem = e.target, form = jQuery.nodeName(elem, 'input') || jQuery.nodeName(elem, 'button') ? elem.form : undefined;
          if (form && !jQuery._data(form, 'submitBubbles')) {
            jQuery.event.add(form, 'submit._submit', function (event) {
              event._submit_bubble = true;
            });
            jQuery._data(form, 'submitBubbles', true);
          }
        });
      },
      postDispatch: function (event) {
        if (event._submit_bubble) {
          delete event._submit_bubble;
          if (this.parentNode && !event.isTrigger) {
            jQuery.event.simulate('submit', this.parentNode, event, true);
          }
        }
      },
      teardown: function () {
        if (jQuery.nodeName(this, 'form')) {
          return false;
        }
        jQuery.event.remove(this, '._submit');
      }
    };
  }
  if (!jQuery.support.changeBubbles) {
    jQuery.event.special.change = {
      setup: function () {
        if (rformElems.test(this.nodeName)) {
          if (this.type === 'checkbox' || this.type === 'radio') {
            jQuery.event.add(this, 'propertychange._change', function (event) {
              if (event.originalEvent.propertyName === 'checked') {
                this._just_changed = true;
              }
            });
            jQuery.event.add(this, 'click._change', function (event) {
              if (this._just_changed && !event.isTrigger) {
                this._just_changed = false;
              }
              jQuery.event.simulate('change', this, event, true);
            });
          }
          return false;
        }
        jQuery.event.add(this, 'beforeactivate._change', function (e) {
          var elem = e.target;
          if (rformElems.test(elem.nodeName) && !jQuery._data(elem, 'changeBubbles')) {
            jQuery.event.add(elem, 'change._change', function (event) {
              if (this.parentNode && !event.isSimulated && !event.isTrigger) {
                jQuery.event.simulate('change', this.parentNode, event, true);
              }
            });
            jQuery._data(elem, 'changeBubbles', true);
          }
        });
      },
      handle: function (event) {
        var elem = event.target;
        if (this !== elem || event.isSimulated || event.isTrigger || elem.type !== 'radio' && elem.type !== 'checkbox') {
          return event.handleObj.handler.apply(this, arguments);
        }
      },
      teardown: function () {
        jQuery.event.remove(this, '._change');
        return !rformElems.test(this.nodeName);
      }
    };
  }
  if (!jQuery.support.focusinBubbles) {
    jQuery.each({
      focus: 'focusin',
      blur: 'focusout'
    }, function (orig, fix) {
      var attaches = 0, handler = function (event) {
          jQuery.event.simulate(fix, event.target, jQuery.event.fix(event), true);
        };
      jQuery.event.special[fix] = {
        setup: function () {
          if (attaches++ === 0) {
            document.addEventListener(orig, handler, true);
          }
        },
        teardown: function () {
          if (--attaches === 0) {
            document.removeEventListener(orig, handler, true);
          }
        }
      };
    });
  }
  jQuery.fn.extend({
    on: function (types, selector, data, fn, one) {
      var type, origFn;
      if (typeof types === 'object') {
        if (typeof selector !== 'string') {
          data = data || selector;
          selector = undefined;
        }
        for (type in types) {
          this.on(type, selector, data, types[type], one);
        }
        return this;
      }
      if (data == null && fn == null) {
        fn = selector;
        data = selector = undefined;
      } else if (fn == null) {
        if (typeof selector === 'string') {
          fn = data;
          data = undefined;
        } else {
          fn = data;
          data = selector;
          selector = undefined;
        }
      }
      if (fn === false) {
        fn = returnFalse;
      } else if (!fn) {
        return this;
      }
      if (one === 1) {
        origFn = fn;
        fn = function (event) {
          jQuery().off(event);
          return origFn.apply(this, arguments);
        };
        fn.guid = origFn.guid || (origFn.guid = jQuery.guid++);
      }
      return this.each(function () {
        jQuery.event.add(this, types, fn, data, selector);
      });
    },
    one: function (types, selector, data, fn) {
      return this.on(types, selector, data, fn, 1);
    },
    off: function (types, selector, fn) {
      var handleObj, type;
      if (types && types.preventDefault && types.handleObj) {
        handleObj = types.handleObj;
        jQuery(types.delegateTarget).off(handleObj.namespace ? handleObj.origType + '.' + handleObj.namespace : handleObj.origType, handleObj.selector, handleObj.handler);
        return this;
      }
      if (typeof types === 'object') {
        for (type in types) {
          this.off(type, selector, types[type]);
        }
        return this;
      }
      if (selector === false || typeof selector === 'function') {
        fn = selector;
        selector = undefined;
      }
      if (fn === false) {
        fn = returnFalse;
      }
      return this.each(function () {
        jQuery.event.remove(this, types, fn, selector);
      });
    },
    trigger: function (type, data) {
      return this.each(function () {
        jQuery.event.trigger(type, data, this);
      });
    },
    triggerHandler: function (type, data) {
      var elem = this[0];
      if (elem) {
        return jQuery.event.trigger(type, data, elem, true);
      }
    }
  });
  var isSimple = /^.[^:#\[\.,]*$/, rparentsprev = /^(?:parents|prev(?:Until|All))/, rneedsContext = jQuery.expr.match.needsContext, guaranteedUnique = {
      children: true,
      contents: true,
      next: true,
      prev: true
    };
  jQuery.fn.extend({
    find: function (selector) {
      var i, ret = [], self = this, len = self.length;
      if (typeof selector !== 'string') {
        return this.pushStack(jQuery(selector).filter(function () {
          for (i = 0; i < len; i++) {
            if (jQuery.contains(self[i], this)) {
              return true;
            }
          }
        }));
      }
      for (i = 0; i < len; i++) {
        jQuery.find(selector, self[i], ret);
      }
      ret = this.pushStack(len > 1 ? jQuery.unique(ret) : ret);
      ret.selector = this.selector ? this.selector + ' ' + selector : selector;
      return ret;
    },
    has: function (target) {
      var i, targets = jQuery(target, this), len = targets.length;
      return this.filter(function () {
        for (i = 0; i < len; i++) {
          if (jQuery.contains(this, targets[i])) {
            return true;
          }
        }
      });
    },
    not: function (selector) {
      return this.pushStack(winnow(this, selector || [], true));
    },
    filter: function (selector) {
      return this.pushStack(winnow(this, selector || [], false));
    },
    is: function (selector) {
      return !!winnow(this, typeof selector === 'string' && rneedsContext.test(selector) ? jQuery(selector) : selector || [], false).length;
    },
    closest: function (selectors, context) {
      var cur, i = 0, l = this.length, ret = [], pos = rneedsContext.test(selectors) || typeof selectors !== 'string' ? jQuery(selectors, context || this.context) : 0;
      for (; i < l; i++) {
        for (cur = this[i]; cur && cur !== context; cur = cur.parentNode) {
          if (cur.nodeType < 11 && (pos ? pos.index(cur) > -1 : cur.nodeType === 1 && jQuery.find.matchesSelector(cur, selectors))) {
            cur = ret.push(cur);
            break;
          }
        }
      }
      return this.pushStack(ret.length > 1 ? jQuery.unique(ret) : ret);
    },
    index: function (elem) {
      if (!elem) {
        return this[0] && this[0].parentNode ? this.first().prevAll().length : -1;
      }
      if (typeof elem === 'string') {
        return jQuery.inArray(this[0], jQuery(elem));
      }
      return jQuery.inArray(elem.jquery ? elem[0] : elem, this);
    },
    add: function (selector, context) {
      var set = typeof selector === 'string' ? jQuery(selector, context) : jQuery.makeArray(selector && selector.nodeType ? [selector] : selector), all = jQuery.merge(this.get(), set);
      return this.pushStack(jQuery.unique(all));
    },
    addBack: function (selector) {
      return this.add(selector == null ? this.prevObject : this.prevObject.filter(selector));
    }
  });
  function sibling(cur, dir) {
    do {
      cur = cur[dir];
    } while (cur && cur.nodeType !== 1);
    return cur;
  }
  jQuery.each({
    parent: function (elem) {
      var parent = elem.parentNode;
      return parent && parent.nodeType !== 11 ? parent : null;
    },
    parents: function (elem) {
      return jQuery.dir(elem, 'parentNode');
    },
    parentsUntil: function (elem, i, until) {
      return jQuery.dir(elem, 'parentNode', until);
    },
    next: function (elem) {
      return sibling(elem, 'nextSibling');
    },
    prev: function (elem) {
      return sibling(elem, 'previousSibling');
    },
    nextAll: function (elem) {
      return jQuery.dir(elem, 'nextSibling');
    },
    prevAll: function (elem) {
      return jQuery.dir(elem, 'previousSibling');
    },
    nextUntil: function (elem, i, until) {
      return jQuery.dir(elem, 'nextSibling', until);
    },
    prevUntil: function (elem, i, until) {
      return jQuery.dir(elem, 'previousSibling', until);
    },
    siblings: function (elem) {
      return jQuery.sibling((elem.parentNode || {}).firstChild, elem);
    },
    children: function (elem) {
      return jQuery.sibling(elem.firstChild);
    },
    contents: function (elem) {
      return jQuery.nodeName(elem, 'iframe') ? elem.contentDocument || elem.contentWindow.document : jQuery.merge([], elem.childNodes);
    }
  }, function (name, fn) {
    jQuery.fn[name] = function (until, selector) {
      var ret = jQuery.map(this, fn, until);
      if (name.slice(-5) !== 'Until') {
        selector = until;
      }
      if (selector && typeof selector === 'string') {
        ret = jQuery.filter(selector, ret);
      }
      if (this.length > 1) {
        if (!guaranteedUnique[name]) {
          ret = jQuery.unique(ret);
        }
        if (rparentsprev.test(name)) {
          ret = ret.reverse();
        }
      }
      return this.pushStack(ret);
    };
  });
  jQuery.extend({
    filter: function (expr, elems, not) {
      var elem = elems[0];
      if (not) {
        expr = ':not(' + expr + ')';
      }
      return elems.length === 1 && elem.nodeType === 1 ? jQuery.find.matchesSelector(elem, expr) ? [elem] : [] : jQuery.find.matches(expr, jQuery.grep(elems, function (elem) {
        return elem.nodeType === 1;
      }));
    },
    dir: function (elem, dir, until) {
      var matched = [], cur = elem[dir];
      while (cur && cur.nodeType !== 9 && (until === undefined || cur.nodeType !== 1 || !jQuery(cur).is(until))) {
        if (cur.nodeType === 1) {
          matched.push(cur);
        }
        cur = cur[dir];
      }
      return matched;
    },
    sibling: function (n, elem) {
      var r = [];
      for (; n; n = n.nextSibling) {
        if (n.nodeType === 1 && n !== elem) {
          r.push(n);
        }
      }
      return r;
    }
  });
  function winnow(elements, qualifier, not) {
    if (jQuery.isFunction(qualifier)) {
      return jQuery.grep(elements, function (elem, i) {
        return !!qualifier.call(elem, i, elem) !== not;
      });
    }
    if (qualifier.nodeType) {
      return jQuery.grep(elements, function (elem) {
        return elem === qualifier !== not;
      });
    }
    if (typeof qualifier === 'string') {
      if (isSimple.test(qualifier)) {
        return jQuery.filter(qualifier, elements, not);
      }
      qualifier = jQuery.filter(qualifier, elements);
    }
    return jQuery.grep(elements, function (elem) {
      return jQuery.inArray(elem, qualifier) >= 0 !== not;
    });
  }
  function createSafeFragment(document) {
    var list = nodeNames.split('|'), safeFrag = document.createDocumentFragment();
    if (safeFrag.createElement) {
      while (list.length) {
        safeFrag.createElement(list.pop());
      }
    }
    return safeFrag;
  }
  var nodeNames = 'abbr|article|aside|audio|bdi|canvas|data|datalist|details|figcaption|figure|footer|' + 'header|hgroup|mark|meter|nav|output|progress|section|summary|time|video', rinlinejQuery = / jQuery\d+="(?:null|\d+)"/g, rnoshimcache = new RegExp('<(?:' + nodeNames + ')[\\s/>]', 'i'), rleadingWhitespace = /^\s+/, rxhtmlTag = /<(?!area|br|col|embed|hr|img|input|link|meta|param)(([\w:]+)[^>]*)\/>/gi, rtagName = /<([\w:]+)/, rtbody = /<tbody/i, rhtml = /<|&#?\w+;/, rnoInnerhtml = /<(?:script|style|link)/i, manipulation_rcheckableType = /^(?:checkbox|radio)$/i, rchecked = /checked\s*(?:[^=]|=\s*.checked.)/i, rscriptType = /^$|\/(?:java|ecma)script/i, rscriptTypeMasked = /^true\/(.*)/, rcleanScript = /^\s*<!(?:\[CDATA\[|--)|(?:\]\]|--)>\s*$/g, wrapMap = {
      option: [
        1,
        '<select multiple=\'multiple\'>',
        '</select>'
      ],
      legend: [
        1,
        '<fieldset>',
        '</fieldset>'
      ],
      area: [
        1,
        '<map>',
        '</map>'
      ],
      param: [
        1,
        '<object>',
        '</object>'
      ],
      thead: [
        1,
        '<table>',
        '</table>'
      ],
      tr: [
        2,
        '<table><tbody>',
        '</tbody></table>'
      ],
      col: [
        2,
        '<table><tbody></tbody><colgroup>',
        '</colgroup></table>'
      ],
      td: [
        3,
        '<table><tbody><tr>',
        '</tr></tbody></table>'
      ],
      _default: jQuery.support.htmlSerialize ? [
        0,
        '',
        ''
      ] : [
        1,
        'X<div>',
        '</div>'
      ]
    }, safeFragment = createSafeFragment(document), fragmentDiv = safeFragment.appendChild(document.createElement('div'));
  wrapMap.optgroup = wrapMap.option;
  wrapMap.tbody = wrapMap.tfoot = wrapMap.colgroup = wrapMap.caption = wrapMap.thead;
  wrapMap.th = wrapMap.td;
  jQuery.fn.extend({
    text: function (value) {
      return jQuery.access(this, function (value) {
        return value === undefined ? jQuery.text(this) : this.empty().append((this[0] && this[0].ownerDocument || document).createTextNode(value));
      }, null, value, arguments.length);
    },
    append: function () {
      return this.domManip(arguments, function (elem) {
        if (this.nodeType === 1 || this.nodeType === 11 || this.nodeType === 9) {
          var target = manipulationTarget(this, elem);
          target.appendChild(elem);
        }
      });
    },
    prepend: function () {
      return this.domManip(arguments, function (elem) {
        if (this.nodeType === 1 || this.nodeType === 11 || this.nodeType === 9) {
          var target = manipulationTarget(this, elem);
          target.insertBefore(elem, target.firstChild);
        }
      });
    },
    before: function () {
      return this.domManip(arguments, function (elem) {
        if (this.parentNode) {
          this.parentNode.insertBefore(elem, this);
        }
      });
    },
    after: function () {
      return this.domManip(arguments, function (elem) {
        if (this.parentNode) {
          this.parentNode.insertBefore(elem, this.nextSibling);
        }
      });
    },
    remove: function (selector, keepData) {
      var elem, elems = selector ? jQuery.filter(selector, this) : this, i = 0;
      for (; (elem = elems[i]) != null; i++) {
        if (!keepData && elem.nodeType === 1) {
          jQuery.cleanData(getAll(elem));
        }
        if (elem.parentNode) {
          if (keepData && jQuery.contains(elem.ownerDocument, elem)) {
            setGlobalEval(getAll(elem, 'script'));
          }
          elem.parentNode.removeChild(elem);
        }
      }
      return this;
    },
    empty: function () {
      var elem, i = 0;
      for (; (elem = this[i]) != null; i++) {
        if (elem.nodeType === 1) {
          jQuery.cleanData(getAll(elem, false));
        }
        while (elem.firstChild) {
          elem.removeChild(elem.firstChild);
        }
        if (elem.options && jQuery.nodeName(elem, 'select')) {
          elem.options.length = 0;
        }
      }
      return this;
    },
    clone: function (dataAndEvents, deepDataAndEvents) {
      dataAndEvents = dataAndEvents == null ? false : dataAndEvents;
      deepDataAndEvents = deepDataAndEvents == null ? dataAndEvents : deepDataAndEvents;
      return this.map(function () {
        return jQuery.clone(this, dataAndEvents, deepDataAndEvents);
      });
    },
    html: function (value) {
      return jQuery.access(this, function (value) {
        var elem = this[0] || {}, i = 0, l = this.length;
        if (value === undefined) {
          return elem.nodeType === 1 ? elem.innerHTML.replace(rinlinejQuery, '') : undefined;
        }
        if (typeof value === 'string' && !rnoInnerhtml.test(value) && (jQuery.support.htmlSerialize || !rnoshimcache.test(value)) && (jQuery.support.leadingWhitespace || !rleadingWhitespace.test(value)) && !wrapMap[(rtagName.exec(value) || [
            '',
            ''
          ])[1].toLowerCase()]) {
          value = value.replace(rxhtmlTag, '<$1></$2>');
          try {
            for (; i < l; i++) {
              elem = this[i] || {};
              if (elem.nodeType === 1) {
                jQuery.cleanData(getAll(elem, false));
                elem.innerHTML = value;
              }
            }
            elem = 0;
          } catch (e) {
          }
        }
        if (elem) {
          this.empty().append(value);
        }
      }, null, value, arguments.length);
    },
    replaceWith: function () {
      var args = jQuery.map(this, function (elem) {
          return [
            elem.nextSibling,
            elem.parentNode
          ];
        }), i = 0;
      this.domManip(arguments, function (elem) {
        var next = args[i++], parent = args[i++];
        if (parent) {
          if (next && next.parentNode !== parent) {
            next = this.nextSibling;
          }
          jQuery(this).remove();
          parent.insertBefore(elem, next);
        }
      }, true);
      return i ? this : this.remove();
    },
    detach: function (selector) {
      return this.remove(selector, true);
    },
    domManip: function (args, callback, allowIntersection) {
      args = core_concat.apply([], args);
      var first, node, hasScripts, scripts, doc, fragment, i = 0, l = this.length, set = this, iNoClone = l - 1, value = args[0], isFunction = jQuery.isFunction(value);
      if (isFunction || !(l <= 1 || typeof value !== 'string' || jQuery.support.checkClone || !rchecked.test(value))) {
        return this.each(function (index) {
          var self = set.eq(index);
          if (isFunction) {
            args[0] = value.call(this, index, self.html());
          }
          self.domManip(args, callback, allowIntersection);
        });
      }
      if (l) {
        fragment = jQuery.buildFragment(args, this[0].ownerDocument, false, !allowIntersection && this);
        first = fragment.firstChild;
        if (fragment.childNodes.length === 1) {
          fragment = first;
        }
        if (first) {
          scripts = jQuery.map(getAll(fragment, 'script'), disableScript);
          hasScripts = scripts.length;
          for (; i < l; i++) {
            node = fragment;
            if (i !== iNoClone) {
              node = jQuery.clone(node, true, true);
              if (hasScripts) {
                jQuery.merge(scripts, getAll(node, 'script'));
              }
            }
            callback.call(this[i], node, i);
          }
          if (hasScripts) {
            doc = scripts[scripts.length - 1].ownerDocument;
            jQuery.map(scripts, restoreScript);
            for (i = 0; i < hasScripts; i++) {
              node = scripts[i];
              if (rscriptType.test(node.type || '') && !jQuery._data(node, 'globalEval') && jQuery.contains(doc, node)) {
                if (node.src) {
                  jQuery._evalUrl(node.src);
                } else {
                  jQuery.globalEval((node.text || node.textContent || node.innerHTML || '').replace(rcleanScript, ''));
                }
              }
            }
          }
          fragment = first = null;
        }
      }
      return this;
    }
  });
  function manipulationTarget(elem, content) {
    return jQuery.nodeName(elem, 'table') && jQuery.nodeName(content.nodeType === 1 ? content : content.firstChild, 'tr') ? elem.getElementsByTagName('tbody')[0] || elem.appendChild(elem.ownerDocument.createElement('tbody')) : elem;
  }
  function disableScript(elem) {
    elem.type = (jQuery.find.attr(elem, 'type') !== null) + '/' + elem.type;
    return elem;
  }
  function restoreScript(elem) {
    var match = rscriptTypeMasked.exec(elem.type);
    if (match) {
      elem.type = match[1];
    } else {
      elem.removeAttribute('type');
    }
    return elem;
  }
  function setGlobalEval(elems, refElements) {
    var elem, i = 0;
    for (; (elem = elems[i]) != null; i++) {
      jQuery._data(elem, 'globalEval', !refElements || jQuery._data(refElements[i], 'globalEval'));
    }
  }
  function cloneCopyEvent(src, dest) {
    if (dest.nodeType !== 1 || !jQuery.hasData(src)) {
      return;
    }
    var type, i, l, oldData = jQuery._data(src), curData = jQuery._data(dest, oldData), events = oldData.events;
    if (events) {
      delete curData.handle;
      curData.events = {};
      for (type in events) {
        for (i = 0, l = events[type].length; i < l; i++) {
          jQuery.event.add(dest, type, events[type][i]);
        }
      }
    }
    if (curData.data) {
      curData.data = jQuery.extend({}, curData.data);
    }
  }
  function fixCloneNodeIssues(src, dest) {
    var nodeName, e, data;
    if (dest.nodeType !== 1) {
      return;
    }
    nodeName = dest.nodeName.toLowerCase();
    if (!jQuery.support.noCloneEvent && dest[jQuery.expando]) {
      data = jQuery._data(dest);
      for (e in data.events) {
        jQuery.removeEvent(dest, e, data.handle);
      }
      dest.removeAttribute(jQuery.expando);
    }
    if (nodeName === 'script' && dest.text !== src.text) {
      disableScript(dest).text = src.text;
      restoreScript(dest);
    } else if (nodeName === 'object') {
      if (dest.parentNode) {
        dest.outerHTML = src.outerHTML;
      }
      if (jQuery.support.html5Clone && (src.innerHTML && !jQuery.trim(dest.innerHTML))) {
        dest.innerHTML = src.innerHTML;
      }
    } else if (nodeName === 'input' && manipulation_rcheckableType.test(src.type)) {
      dest.defaultChecked = dest.checked = src.checked;
      if (dest.value !== src.value) {
        dest.value = src.value;
      }
    } else if (nodeName === 'option') {
      dest.defaultSelected = dest.selected = src.defaultSelected;
    } else if (nodeName === 'input' || nodeName === 'textarea') {
      dest.defaultValue = src.defaultValue;
    }
  }
  jQuery.each({
    appendTo: 'append',
    prependTo: 'prepend',
    insertBefore: 'before',
    insertAfter: 'after',
    replaceAll: 'replaceWith'
  }, function (name, original) {
    jQuery.fn[name] = function (selector) {
      var elems, i = 0, ret = [], insert = jQuery(selector), last = insert.length - 1;
      for (; i <= last; i++) {
        elems = i === last ? this : this.clone(true);
        jQuery(insert[i])[original](elems);
        core_push.apply(ret, elems.get());
      }
      return this.pushStack(ret);
    };
  });
  function getAll(context, tag) {
    var elems, elem, i = 0, found = typeof context.getElementsByTagName !== core_strundefined ? context.getElementsByTagName(tag || '*') : typeof context.querySelectorAll !== core_strundefined ? context.querySelectorAll(tag || '*') : undefined;
    if (!found) {
      for (found = [], elems = context.childNodes || context; (elem = elems[i]) != null; i++) {
        if (!tag || jQuery.nodeName(elem, tag)) {
          found.push(elem);
        } else {
          jQuery.merge(found, getAll(elem, tag));
        }
      }
    }
    return tag === undefined || tag && jQuery.nodeName(context, tag) ? jQuery.merge([context], found) : found;
  }
  function fixDefaultChecked(elem) {
    if (manipulation_rcheckableType.test(elem.type)) {
      elem.defaultChecked = elem.checked;
    }
  }
  jQuery.extend({
    clone: function (elem, dataAndEvents, deepDataAndEvents) {
      var destElements, node, clone, i, srcElements, inPage = jQuery.contains(elem.ownerDocument, elem);
      if (jQuery.support.html5Clone || jQuery.isXMLDoc(elem) || !rnoshimcache.test('<' + elem.nodeName + '>')) {
        clone = elem.cloneNode(true);
      } else {
        fragmentDiv.innerHTML = elem.outerHTML;
        fragmentDiv.removeChild(clone = fragmentDiv.firstChild);
      }
      if ((!jQuery.support.noCloneEvent || !jQuery.support.noCloneChecked) && (elem.nodeType === 1 || elem.nodeType === 11) && !jQuery.isXMLDoc(elem)) {
        destElements = getAll(clone);
        srcElements = getAll(elem);
        for (i = 0; (node = srcElements[i]) != null; ++i) {
          if (destElements[i]) {
            fixCloneNodeIssues(node, destElements[i]);
          }
        }
      }
      if (dataAndEvents) {
        if (deepDataAndEvents) {
          srcElements = srcElements || getAll(elem);
          destElements = destElements || getAll(clone);
          for (i = 0; (node = srcElements[i]) != null; i++) {
            cloneCopyEvent(node, destElements[i]);
          }
        } else {
          cloneCopyEvent(elem, clone);
        }
      }
      destElements = getAll(clone, 'script');
      if (destElements.length > 0) {
        setGlobalEval(destElements, !inPage && getAll(elem, 'script'));
      }
      destElements = srcElements = node = null;
      return clone;
    },
    buildFragment: function (elems, context, scripts, selection) {
      var j, elem, contains, tmp, tag, tbody, wrap, l = elems.length, safe = createSafeFragment(context), nodes = [], i = 0;
      for (; i < l; i++) {
        elem = elems[i];
        if (elem || elem === 0) {
          if (jQuery.type(elem) === 'object') {
            jQuery.merge(nodes, elem.nodeType ? [elem] : elem);
          } else if (!rhtml.test(elem)) {
            nodes.push(context.createTextNode(elem));
          } else {
            tmp = tmp || safe.appendChild(context.createElement('div'));
            tag = (rtagName.exec(elem) || [
              '',
              ''
            ])[1].toLowerCase();
            wrap = wrapMap[tag] || wrapMap._default;
            tmp.innerHTML = wrap[1] + elem.replace(rxhtmlTag, '<$1></$2>') + wrap[2];
            j = wrap[0];
            while (j--) {
              tmp = tmp.lastChild;
            }
            if (!jQuery.support.leadingWhitespace && rleadingWhitespace.test(elem)) {
              nodes.push(context.createTextNode(rleadingWhitespace.exec(elem)[0]));
            }
            if (!jQuery.support.tbody) {
              elem = tag === 'table' && !rtbody.test(elem) ? tmp.firstChild : wrap[1] === '<table>' && !rtbody.test(elem) ? tmp : 0;
              j = elem && elem.childNodes.length;
              while (j--) {
                if (jQuery.nodeName(tbody = elem.childNodes[j], 'tbody') && !tbody.childNodes.length) {
                  elem.removeChild(tbody);
                }
              }
            }
            jQuery.merge(nodes, tmp.childNodes);
            tmp.textContent = '';
            while (tmp.firstChild) {
              tmp.removeChild(tmp.firstChild);
            }
            tmp = safe.lastChild;
          }
        }
      }
      if (tmp) {
        safe.removeChild(tmp);
      }
      if (!jQuery.support.appendChecked) {
        jQuery.grep(getAll(nodes, 'input'), fixDefaultChecked);
      }
      i = 0;
      while (elem = nodes[i++]) {
        if (selection && jQuery.inArray(elem, selection) !== -1) {
          continue;
        }
        contains = jQuery.contains(elem.ownerDocument, elem);
        tmp = getAll(safe.appendChild(elem), 'script');
        if (contains) {
          setGlobalEval(tmp);
        }
        if (scripts) {
          j = 0;
          while (elem = tmp[j++]) {
            if (rscriptType.test(elem.type || '')) {
              scripts.push(elem);
            }
          }
        }
      }
      tmp = null;
      return safe;
    },
    cleanData: function (elems, acceptData) {
      var elem, type, id, data, i = 0, internalKey = jQuery.expando, cache = jQuery.cache, deleteExpando = jQuery.support.deleteExpando, special = jQuery.event.special;
      for (; (elem = elems[i]) != null; i++) {
        if (acceptData || jQuery.acceptData(elem)) {
          id = elem[internalKey];
          data = id && cache[id];
          if (data) {
            if (data.events) {
              for (type in data.events) {
                if (special[type]) {
                  jQuery.event.remove(elem, type);
                } else {
                  jQuery.removeEvent(elem, type, data.handle);
                }
              }
            }
            if (cache[id]) {
              delete cache[id];
              if (deleteExpando) {
                delete elem[internalKey];
              } else if (typeof elem.removeAttribute !== core_strundefined) {
                elem.removeAttribute(internalKey);
              } else {
                elem[internalKey] = null;
              }
              core_deletedIds.push(id);
            }
          }
        }
      }
    },
    _evalUrl: function (url) {
      return jQuery.ajax({
        url: url,
        type: 'GET',
        dataType: 'script',
        async: false,
        global: false,
        'throws': true
      });
    }
  });
  jQuery.fn.extend({
    wrapAll: function (html) {
      if (jQuery.isFunction(html)) {
        return this.each(function (i) {
          jQuery(this).wrapAll(html.call(this, i));
        });
      }
      if (this[0]) {
        var wrap = jQuery(html, this[0].ownerDocument).eq(0).clone(true);
        if (this[0].parentNode) {
          wrap.insertBefore(this[0]);
        }
        wrap.map(function () {
          var elem = this;
          while (elem.firstChild && elem.firstChild.nodeType === 1) {
            elem = elem.firstChild;
          }
          return elem;
        }).append(this);
      }
      return this;
    },
    wrapInner: function (html) {
      if (jQuery.isFunction(html)) {
        return this.each(function (i) {
          jQuery(this).wrapInner(html.call(this, i));
        });
      }
      return this.each(function () {
        var self = jQuery(this), contents = self.contents();
        if (contents.length) {
          contents.wrapAll(html);
        } else {
          self.append(html);
        }
      });
    },
    wrap: function (html) {
      var isFunction = jQuery.isFunction(html);
      return this.each(function (i) {
        jQuery(this).wrapAll(isFunction ? html.call(this, i) : html);
      });
    },
    unwrap: function () {
      return this.parent().each(function () {
        if (!jQuery.nodeName(this, 'body')) {
          jQuery(this).replaceWith(this.childNodes);
        }
      }).end();
    }
  });
  var iframe, getStyles, curCSS, ralpha = /alpha\([^)]*\)/i, ropacity = /opacity\s*=\s*([^)]*)/, rposition = /^(top|right|bottom|left)$/, rdisplayswap = /^(none|table(?!-c[ea]).+)/, rmargin = /^margin/, rnumsplit = new RegExp('^(' + core_pnum + ')(.*)$', 'i'), rnumnonpx = new RegExp('^(' + core_pnum + ')(?!px)[a-z%]+$', 'i'), rrelNum = new RegExp('^([+-])=(' + core_pnum + ')', 'i'), elemdisplay = { BODY: 'block' }, cssShow = {
      position: 'absolute',
      visibility: 'hidden',
      display: 'block'
    }, cssNormalTransform = {
      letterSpacing: 0,
      fontWeight: 400
    }, cssExpand = [
      'Top',
      'Right',
      'Bottom',
      'Left'
    ], cssPrefixes = [
      'Webkit',
      'O',
      'Moz',
      'ms'
    ];
  function vendorPropName(style, name) {
    if (name in style) {
      return name;
    }
    var capName = name.charAt(0).toUpperCase() + name.slice(1), origName = name, i = cssPrefixes.length;
    while (i--) {
      name = cssPrefixes[i] + capName;
      if (name in style) {
        return name;
      }
    }
    return origName;
  }
  function isHidden(elem, el) {
    elem = el || elem;
    return jQuery.css(elem, 'display') === 'none' || !jQuery.contains(elem.ownerDocument, elem);
  }
  function showHide(elements, show) {
    var display, elem, hidden, values = [], index = 0, length = elements.length;
    for (; index < length; index++) {
      elem = elements[index];
      if (!elem.style) {
        continue;
      }
      values[index] = jQuery._data(elem, 'olddisplay');
      display = elem.style.display;
      if (show) {
        if (!values[index] && display === 'none') {
          elem.style.display = '';
        }
        if (elem.style.display === '' && isHidden(elem)) {
          values[index] = jQuery._data(elem, 'olddisplay', css_defaultDisplay(elem.nodeName));
        }
      } else {
        if (!values[index]) {
          hidden = isHidden(elem);
          if (display && display !== 'none' || !hidden) {
            jQuery._data(elem, 'olddisplay', hidden ? display : jQuery.css(elem, 'display'));
          }
        }
      }
    }
    for (index = 0; index < length; index++) {
      elem = elements[index];
      if (!elem.style) {
        continue;
      }
      if (!show || elem.style.display === 'none' || elem.style.display === '') {
        elem.style.display = show ? values[index] || '' : 'none';
      }
    }
    return elements;
  }
  jQuery.fn.extend({
    css: function (name, value) {
      return jQuery.access(this, function (elem, name, value) {
        var len, styles, map = {}, i = 0;
        if (jQuery.isArray(name)) {
          styles = getStyles(elem);
          len = name.length;
          for (; i < len; i++) {
            map[name[i]] = jQuery.css(elem, name[i], false, styles);
          }
          return map;
        }
        return value !== undefined ? jQuery.style(elem, name, value) : jQuery.css(elem, name);
      }, name, value, arguments.length > 1);
    },
    show: function () {
      return showHide(this, true);
    },
    hide: function () {
      return showHide(this);
    },
    toggle: function (state) {
      if (typeof state === 'boolean') {
        return state ? this.show() : this.hide();
      }
      return this.each(function () {
        if (isHidden(this)) {
          jQuery(this).show();
        } else {
          jQuery(this).hide();
        }
      });
    }
  });
  jQuery.extend({
    cssHooks: {
      opacity: {
        get: function (elem, computed) {
          if (computed) {
            var ret = curCSS(elem, 'opacity');
            return ret === '' ? '1' : ret;
          }
        }
      }
    },
    cssNumber: {
      'columnCount': true,
      'fillOpacity': true,
      'fontWeight': true,
      'lineHeight': true,
      'opacity': true,
      'order': true,
      'orphans': true,
      'widows': true,
      'zIndex': true,
      'zoom': true
    },
    cssProps: { 'float': jQuery.support.cssFloat ? 'cssFloat' : 'styleFloat' },
    style: function (elem, name, value, extra) {
      if (!elem || elem.nodeType === 3 || elem.nodeType === 8 || !elem.style) {
        return;
      }
      var ret, type, hooks, origName = jQuery.camelCase(name), style = elem.style;
      name = jQuery.cssProps[origName] || (jQuery.cssProps[origName] = vendorPropName(style, origName));
      hooks = jQuery.cssHooks[name] || jQuery.cssHooks[origName];
      if (value !== undefined) {
        type = typeof value;
        if (type === 'string' && (ret = rrelNum.exec(value))) {
          value = (ret[1] + 1) * ret[2] + parseFloat(jQuery.css(elem, name));
          type = 'number';
        }
        if (value == null || type === 'number' && isNaN(value)) {
          return;
        }
        if (type === 'number' && !jQuery.cssNumber[origName]) {
          value += 'px';
        }
        if (!jQuery.support.clearCloneStyle && value === '' && name.indexOf('background') === 0) {
          style[name] = 'inherit';
        }
        if (!hooks || !('set' in hooks) || (value = hooks.set(elem, value, extra)) !== undefined) {
          try {
            style[name] = value;
          } catch (e) {
          }
        }
      } else {
        if (hooks && 'get' in hooks && (ret = hooks.get(elem, false, extra)) !== undefined) {
          return ret;
        }
        return style[name];
      }
    },
    css: function (elem, name, extra, styles) {
      var num, val, hooks, origName = jQuery.camelCase(name);
      name = jQuery.cssProps[origName] || (jQuery.cssProps[origName] = vendorPropName(elem.style, origName));
      hooks = jQuery.cssHooks[name] || jQuery.cssHooks[origName];
      if (hooks && 'get' in hooks) {
        val = hooks.get(elem, true, extra);
      }
      if (val === undefined) {
        val = curCSS(elem, name, styles);
      }
      if (val === 'normal' && name in cssNormalTransform) {
        val = cssNormalTransform[name];
      }
      if (extra === '' || extra) {
        num = parseFloat(val);
        return extra === true || jQuery.isNumeric(num) ? num || 0 : val;
      }
      return val;
    }
  });
  if (window.getComputedStyle) {
    getStyles = function (elem) {
      return window.getComputedStyle(elem, null);
    };
    curCSS = function (elem, name, _computed) {
      var width, minWidth, maxWidth, computed = _computed || getStyles(elem), ret = computed ? computed.getPropertyValue(name) || computed[name] : undefined, style = elem.style;
      if (computed) {
        if (ret === '' && !jQuery.contains(elem.ownerDocument, elem)) {
          ret = jQuery.style(elem, name);
        }
        if (rnumnonpx.test(ret) && rmargin.test(name)) {
          width = style.width;
          minWidth = style.minWidth;
          maxWidth = style.maxWidth;
          style.minWidth = style.maxWidth = style.width = ret;
          ret = computed.width;
          style.width = width;
          style.minWidth = minWidth;
          style.maxWidth = maxWidth;
        }
      }
      return ret;
    };
  } else if (document.documentElement.currentStyle) {
    getStyles = function (elem) {
      return elem.currentStyle;
    };
    curCSS = function (elem, name, _computed) {
      var left, rs, rsLeft, computed = _computed || getStyles(elem), ret = computed ? computed[name] : undefined, style = elem.style;
      if (ret == null && style && style[name]) {
        ret = style[name];
      }
      if (rnumnonpx.test(ret) && !rposition.test(name)) {
        left = style.left;
        rs = elem.runtimeStyle;
        rsLeft = rs && rs.left;
        if (rsLeft) {
          rs.left = elem.currentStyle.left;
        }
        style.left = name === 'fontSize' ? '1em' : ret;
        ret = style.pixelLeft + 'px';
        style.left = left;
        if (rsLeft) {
          rs.left = rsLeft;
        }
      }
      return ret === '' ? 'auto' : ret;
    };
  }
  function setPositiveNumber(elem, value, subtract) {
    var matches = rnumsplit.exec(value);
    return matches ? Math.max(0, matches[1] - (subtract || 0)) + (matches[2] || 'px') : value;
  }
  function augmentWidthOrHeight(elem, name, extra, isBorderBox, styles) {
    var i = extra === (isBorderBox ? 'border' : 'content') ? 4 : name === 'width' ? 1 : 0, val = 0;
    for (; i < 4; i += 2) {
      if (extra === 'margin') {
        val += jQuery.css(elem, extra + cssExpand[i], true, styles);
      }
      if (isBorderBox) {
        if (extra === 'content') {
          val -= jQuery.css(elem, 'padding' + cssExpand[i], true, styles);
        }
        if (extra !== 'margin') {
          val -= jQuery.css(elem, 'border' + cssExpand[i] + 'Width', true, styles);
        }
      } else {
        val += jQuery.css(elem, 'padding' + cssExpand[i], true, styles);
        if (extra !== 'padding') {
          val += jQuery.css(elem, 'border' + cssExpand[i] + 'Width', true, styles);
        }
      }
    }
    return val;
  }
  function getWidthOrHeight(elem, name, extra) {
    var valueIsBorderBox = true, val = name === 'width' ? elem.offsetWidth : elem.offsetHeight, styles = getStyles(elem), isBorderBox = jQuery.support.boxSizing && jQuery.css(elem, 'boxSizing', false, styles) === 'border-box';
    if (val <= 0 || val == null) {
      val = curCSS(elem, name, styles);
      if (val < 0 || val == null) {
        val = elem.style[name];
      }
      if (rnumnonpx.test(val)) {
        return val;
      }
      valueIsBorderBox = isBorderBox && (jQuery.support.boxSizingReliable || val === elem.style[name]);
      val = parseFloat(val) || 0;
    }
    return val + augmentWidthOrHeight(elem, name, extra || (isBorderBox ? 'border' : 'content'), valueIsBorderBox, styles) + 'px';
  }
  function css_defaultDisplay(nodeName) {
    var doc = document, display = elemdisplay[nodeName];
    if (!display) {
      display = actualDisplay(nodeName, doc);
      if (display === 'none' || !display) {
        iframe = (iframe || jQuery('<iframe frameborder=\'0\' width=\'0\' height=\'0\'/>').css('cssText', 'display:block !important')).appendTo(doc.documentElement);
        doc = (iframe[0].contentWindow || iframe[0].contentDocument).document;
        doc.write('<!doctype html><html><body>');
        doc.close();
        display = actualDisplay(nodeName, doc);
        iframe.detach();
      }
      elemdisplay[nodeName] = display;
    }
    return display;
  }
  function actualDisplay(name, doc) {
    var elem = jQuery(doc.createElement(name)).appendTo(doc.body), display = jQuery.css(elem[0], 'display');
    elem.remove();
    return display;
  }
  jQuery.each([
    'height',
    'width'
  ], function (i, name) {
    jQuery.cssHooks[name] = {
      get: function (elem, computed, extra) {
        if (computed) {
          return elem.offsetWidth === 0 && rdisplayswap.test(jQuery.css(elem, 'display')) ? jQuery.swap(elem, cssShow, function () {
            return getWidthOrHeight(elem, name, extra);
          }) : getWidthOrHeight(elem, name, extra);
        }
      },
      set: function (elem, value, extra) {
        var styles = extra && getStyles(elem);
        return setPositiveNumber(elem, value, extra ? augmentWidthOrHeight(elem, name, extra, jQuery.support.boxSizing && jQuery.css(elem, 'boxSizing', false, styles) === 'border-box', styles) : 0);
      }
    };
  });
  if (!jQuery.support.opacity) {
    jQuery.cssHooks.opacity = {
      get: function (elem, computed) {
        return ropacity.test((computed && elem.currentStyle ? elem.currentStyle.filter : elem.style.filter) || '') ? 0.01 * parseFloat(RegExp.$1) + '' : computed ? '1' : '';
      },
      set: function (elem, value) {
        var style = elem.style, currentStyle = elem.currentStyle, opacity = jQuery.isNumeric(value) ? 'alpha(opacity=' + value * 100 + ')' : '', filter = currentStyle && currentStyle.filter || style.filter || '';
        style.zoom = 1;
        if ((value >= 1 || value === '') && jQuery.trim(filter.replace(ralpha, '')) === '' && style.removeAttribute) {
          style.removeAttribute('filter');
          if (value === '' || currentStyle && !currentStyle.filter) {
            return;
          }
        }
        style.filter = ralpha.test(filter) ? filter.replace(ralpha, opacity) : filter + ' ' + opacity;
      }
    };
  }
  jQuery(function () {
    if (!jQuery.support.reliableMarginRight) {
      jQuery.cssHooks.marginRight = {
        get: function (elem, computed) {
          if (computed) {
            return jQuery.swap(elem, { 'display': 'inline-block' }, curCSS, [
              elem,
              'marginRight'
            ]);
          }
        }
      };
    }
    if (!jQuery.support.pixelPosition && jQuery.fn.position) {
      jQuery.each([
        'top',
        'left'
      ], function (i, prop) {
        jQuery.cssHooks[prop] = {
          get: function (elem, computed) {
            if (computed) {
              computed = curCSS(elem, prop);
              return rnumnonpx.test(computed) ? jQuery(elem).position()[prop] + 'px' : computed;
            }
          }
        };
      });
    }
  });
  if (jQuery.expr && jQuery.expr.filters) {
    jQuery.expr.filters.hidden = function (elem) {
      return elem.offsetWidth <= 0 && elem.offsetHeight <= 0 || !jQuery.support.reliableHiddenOffsets && (elem.style && elem.style.display || jQuery.css(elem, 'display')) === 'none';
    };
    jQuery.expr.filters.visible = function (elem) {
      return !jQuery.expr.filters.hidden(elem);
    };
  }
  jQuery.each({
    margin: '',
    padding: '',
    border: 'Width'
  }, function (prefix, suffix) {
    jQuery.cssHooks[prefix + suffix] = {
      expand: function (value) {
        var i = 0, expanded = {}, parts = typeof value === 'string' ? value.split(' ') : [value];
        for (; i < 4; i++) {
          expanded[prefix + cssExpand[i] + suffix] = parts[i] || parts[i - 2] || parts[0];
        }
        return expanded;
      }
    };
    if (!rmargin.test(prefix)) {
      jQuery.cssHooks[prefix + suffix].set = setPositiveNumber;
    }
  });
  var r20 = /%20/g, rbracket = /\[\]$/, rCRLF = /\r?\n/g, rsubmitterTypes = /^(?:submit|button|image|reset|file)$/i, rsubmittable = /^(?:input|select|textarea|keygen)/i;
  jQuery.fn.extend({
    serialize: function () {
      return jQuery.param(this.serializeArray());
    },
    serializeArray: function () {
      return this.map(function () {
        var elements = jQuery.prop(this, 'elements');
        return elements ? jQuery.makeArray(elements) : this;
      }).filter(function () {
        var type = this.type;
        return this.name && !jQuery(this).is(':disabled') && rsubmittable.test(this.nodeName) && !rsubmitterTypes.test(type) && (this.checked || !manipulation_rcheckableType.test(type));
      }).map(function (i, elem) {
        var val = jQuery(this).val();
        return val == null ? null : jQuery.isArray(val) ? jQuery.map(val, function (val) {
          return {
            name: elem.name,
            value: val.replace(rCRLF, '\r\n')
          };
        }) : {
          name: elem.name,
          value: val.replace(rCRLF, '\r\n')
        };
      }).get();
    }
  });
  jQuery.param = function (a, traditional) {
    var prefix, s = [], add = function (key, value) {
        value = jQuery.isFunction(value) ? value() : value == null ? '' : value;
        s[s.length] = encodeURIComponent(key) + '=' + encodeURIComponent(value);
      };
    if (traditional === undefined) {
      traditional = jQuery.ajaxSettings && jQuery.ajaxSettings.traditional;
    }
    if (jQuery.isArray(a) || a.jquery && !jQuery.isPlainObject(a)) {
      jQuery.each(a, function () {
        add(this.name, this.value);
      });
    } else {
      for (prefix in a) {
        buildParams(prefix, a[prefix], traditional, add);
      }
    }
    return s.join('&').replace(r20, '+');
  };
  function buildParams(prefix, obj, traditional, add) {
    var name;
    if (jQuery.isArray(obj)) {
      jQuery.each(obj, function (i, v) {
        if (traditional || rbracket.test(prefix)) {
          add(prefix, v);
        } else {
          buildParams(prefix + '[' + (typeof v === 'object' ? i : '') + ']', v, traditional, add);
        }
      });
    } else if (!traditional && jQuery.type(obj) === 'object') {
      for (name in obj) {
        buildParams(prefix + '[' + name + ']', obj[name], traditional, add);
      }
    } else {
      add(prefix, obj);
    }
  }
  jQuery.each(('blur focus focusin focusout load resize scroll unload click dblclick ' + 'mousedown mouseup mousemove mouseover mouseout mouseenter mouseleave ' + 'change select submit keydown keypress keyup error contextmenu').split(' '), function (i, name) {
    jQuery.fn[name] = function (data, fn) {
      return arguments.length > 0 ? this.on(name, null, data, fn) : this.trigger(name);
    };
  });
  jQuery.fn.extend({
    hover: function (fnOver, fnOut) {
      return this.mouseenter(fnOver).mouseleave(fnOut || fnOver);
    },
    bind: function (types, data, fn) {
      return this.on(types, null, data, fn);
    },
    unbind: function (types, fn) {
      return this.off(types, null, fn);
    },
    delegate: function (selector, types, data, fn) {
      return this.on(types, selector, data, fn);
    },
    undelegate: function (selector, types, fn) {
      return arguments.length === 1 ? this.off(selector, '**') : this.off(types, selector || '**', fn);
    }
  });
  var ajaxLocParts, ajaxLocation, ajax_nonce = jQuery.now(), ajax_rquery = /\?/, rhash = /#.*$/, rts = /([?&])_=[^&]*/, rheaders = /^(.*?):[ \t]*([^\r\n]*)\r?$/gm, rlocalProtocol = /^(?:about|app|app-storage|.+-extension|file|res|widget):$/, rnoContent = /^(?:GET|HEAD)$/, rprotocol = /^\/\//, rurl = /^([\w.+-]+:)(?:\/\/([^\/?#:]*)(?::(\d+)|)|)/, _load = jQuery.fn.load, prefilters = {}, transports = {}, allTypes = '*/'.concat('*');
  try {
    ajaxLocation = location.href;
  } catch (e) {
    ajaxLocation = document.createElement('a');
    ajaxLocation.href = '';
    ajaxLocation = ajaxLocation.href;
  }
  ajaxLocParts = rurl.exec(ajaxLocation.toLowerCase()) || [];
  function addToPrefiltersOrTransports(structure) {
    return function (dataTypeExpression, func) {
      if (typeof dataTypeExpression !== 'string') {
        func = dataTypeExpression;
        dataTypeExpression = '*';
      }
      var dataType, i = 0, dataTypes = dataTypeExpression.toLowerCase().match(core_rnotwhite) || [];
      if (jQuery.isFunction(func)) {
        while (dataType = dataTypes[i++]) {
          if (dataType[0] === '+') {
            dataType = dataType.slice(1) || '*';
            (structure[dataType] = structure[dataType] || []).unshift(func);
          } else {
            (structure[dataType] = structure[dataType] || []).push(func);
          }
        }
      }
    };
  }
  function inspectPrefiltersOrTransports(structure, options, originalOptions, jqXHR) {
    var inspected = {}, seekingTransport = structure === transports;
    function inspect(dataType) {
      var selected;
      inspected[dataType] = true;
      jQuery.each(structure[dataType] || [], function (_, prefilterOrFactory) {
        var dataTypeOrTransport = prefilterOrFactory(options, originalOptions, jqXHR);
        if (typeof dataTypeOrTransport === 'string' && !seekingTransport && !inspected[dataTypeOrTransport]) {
          options.dataTypes.unshift(dataTypeOrTransport);
          inspect(dataTypeOrTransport);
          return false;
        } else if (seekingTransport) {
          return !(selected = dataTypeOrTransport);
        }
      });
      return selected;
    }
    return inspect(options.dataTypes[0]) || !inspected['*'] && inspect('*');
  }
  function ajaxExtend(target, src) {
    var deep, key, flatOptions = jQuery.ajaxSettings.flatOptions || {};
    for (key in src) {
      if (src[key] !== undefined) {
        (flatOptions[key] ? target : deep || (deep = {}))[key] = src[key];
      }
    }
    if (deep) {
      jQuery.extend(true, target, deep);
    }
    return target;
  }
  jQuery.fn.load = function (url, params, callback) {
    if (typeof url !== 'string' && _load) {
      return _load.apply(this, arguments);
    }
    var selector, response, type, self = this, off = url.indexOf(' ');
    if (off >= 0) {
      selector = url.slice(off, url.length);
      url = url.slice(0, off);
    }
    if (jQuery.isFunction(params)) {
      callback = params;
      params = undefined;
    } else if (params && typeof params === 'object') {
      type = 'POST';
    }
    if (self.length > 0) {
      jQuery.ajax({
        url: url,
        type: type,
        dataType: 'html',
        data: params
      }).done(function (responseText) {
        response = arguments;
        self.html(selector ? jQuery('<div>').append(jQuery.parseHTML(responseText)).find(selector) : responseText);
      }).complete(callback && function (jqXHR, status) {
        self.each(callback, response || [
          jqXHR.responseText,
          status,
          jqXHR
        ]);
      });
    }
    return this;
  };
  jQuery.each([
    'ajaxStart',
    'ajaxStop',
    'ajaxComplete',
    'ajaxError',
    'ajaxSuccess',
    'ajaxSend'
  ], function (i, type) {
    jQuery.fn[type] = function (fn) {
      return this.on(type, fn);
    };
  });
  jQuery.extend({
    active: 0,
    lastModified: {},
    etag: {},
    ajaxSettings: {
      url: ajaxLocation,
      type: 'GET',
      isLocal: rlocalProtocol.test(ajaxLocParts[1]),
      global: true,
      processData: true,
      async: true,
      contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
      accepts: {
        '*': allTypes,
        text: 'text/plain',
        html: 'text/html',
        xml: 'application/xml, text/xml',
        json: 'application/json, text/javascript'
      },
      contents: {
        xml: /xml/,
        html: /html/,
        json: /json/
      },
      responseFields: {
        xml: 'responseXML',
        text: 'responseText',
        json: 'responseJSON'
      },
      converters: {
        '* text': String,
        'text html': true,
        'text json': jQuery.parseJSON,
        'text xml': jQuery.parseXML
      },
      flatOptions: {
        url: true,
        context: true
      }
    },
    ajaxSetup: function (target, settings) {
      return settings ? ajaxExtend(ajaxExtend(target, jQuery.ajaxSettings), settings) : ajaxExtend(jQuery.ajaxSettings, target);
    },
    ajaxPrefilter: addToPrefiltersOrTransports(prefilters),
    ajaxTransport: addToPrefiltersOrTransports(transports),
    ajax: function (url, options) {
      if (typeof url === 'object') {
        options = url;
        url = undefined;
      }
      options = options || {};
      var parts, i, cacheURL, responseHeadersString, timeoutTimer, fireGlobals, transport, responseHeaders, s = jQuery.ajaxSetup({}, options), callbackContext = s.context || s, globalEventContext = s.context && (callbackContext.nodeType || callbackContext.jquery) ? jQuery(callbackContext) : jQuery.event, deferred = jQuery.Deferred(), completeDeferred = jQuery.Callbacks('once memory'), statusCode = s.statusCode || {}, requestHeaders = {}, requestHeadersNames = {}, state = 0, strAbort = 'canceled', jqXHR = {
          readyState: 0,
          getResponseHeader: function (key) {
            var match;
            if (state === 2) {
              if (!responseHeaders) {
                responseHeaders = {};
                while (match = rheaders.exec(responseHeadersString)) {
                  responseHeaders[match[1].toLowerCase()] = match[2];
                }
              }
              match = responseHeaders[key.toLowerCase()];
            }
            return match == null ? null : match;
          },
          getAllResponseHeaders: function () {
            return state === 2 ? responseHeadersString : null;
          },
          setRequestHeader: function (name, value) {
            var lname = name.toLowerCase();
            if (!state) {
              name = requestHeadersNames[lname] = requestHeadersNames[lname] || name;
              requestHeaders[name] = value;
            }
            return this;
          },
          overrideMimeType: function (type) {
            if (!state) {
              s.mimeType = type;
            }
            return this;
          },
          statusCode: function (map) {
            var code;
            if (map) {
              if (state < 2) {
                for (code in map) {
                  statusCode[code] = [
                    statusCode[code],
                    map[code]
                  ];
                }
              } else {
                jqXHR.always(map[jqXHR.status]);
              }
            }
            return this;
          },
          abort: function (statusText) {
            var finalText = statusText || strAbort;
            if (transport) {
              transport.abort(finalText);
            }
            done(0, finalText);
            return this;
          }
        };
      deferred.promise(jqXHR).complete = completeDeferred.add;
      jqXHR.success = jqXHR.done;
      jqXHR.error = jqXHR.fail;
      s.url = ((url || s.url || ajaxLocation) + '').replace(rhash, '').replace(rprotocol, ajaxLocParts[1] + '//');
      s.type = options.method || options.type || s.method || s.type;
      s.dataTypes = jQuery.trim(s.dataType || '*').toLowerCase().match(core_rnotwhite) || [''];
      if (s.crossDomain == null) {
        parts = rurl.exec(s.url.toLowerCase());
        s.crossDomain = !!(parts && (parts[1] !== ajaxLocParts[1] || parts[2] !== ajaxLocParts[2] || (parts[3] || (parts[1] === 'http:' ? '80' : '443')) !== (ajaxLocParts[3] || (ajaxLocParts[1] === 'http:' ? '80' : '443'))));
      }
      if (s.data && s.processData && typeof s.data !== 'string') {
        s.data = jQuery.param(s.data, s.traditional);
      }
      inspectPrefiltersOrTransports(prefilters, s, options, jqXHR);
      if (state === 2) {
        return jqXHR;
      }
      fireGlobals = s.global;
      if (fireGlobals && jQuery.active++ === 0) {
        jQuery.event.trigger('ajaxStart');
      }
      s.type = s.type.toUpperCase();
      s.hasContent = !rnoContent.test(s.type);
      cacheURL = s.url;
      if (!s.hasContent) {
        if (s.data) {
          cacheURL = s.url += (ajax_rquery.test(cacheURL) ? '&' : '?') + s.data;
          delete s.data;
        }
        if (s.cache === false) {
          s.url = rts.test(cacheURL) ? cacheURL.replace(rts, '$1_=' + ajax_nonce++) : cacheURL + (ajax_rquery.test(cacheURL) ? '&' : '?') + '_=' + ajax_nonce++;
        }
      }
      if (s.ifModified) {
        if (jQuery.lastModified[cacheURL]) {
          jqXHR.setRequestHeader('If-Modified-Since', jQuery.lastModified[cacheURL]);
        }
        if (jQuery.etag[cacheURL]) {
          jqXHR.setRequestHeader('If-None-Match', jQuery.etag[cacheURL]);
        }
      }
      if (s.data && s.hasContent && s.contentType !== false || options.contentType) {
        jqXHR.setRequestHeader('Content-Type', s.contentType);
      }
      jqXHR.setRequestHeader('Accept', s.dataTypes[0] && s.accepts[s.dataTypes[0]] ? s.accepts[s.dataTypes[0]] + (s.dataTypes[0] !== '*' ? ', ' + allTypes + '; q=0.01' : '') : s.accepts['*']);
      for (i in s.headers) {
        jqXHR.setRequestHeader(i, s.headers[i]);
      }
      if (s.beforeSend && (s.beforeSend.call(callbackContext, jqXHR, s) === false || state === 2)) {
        return jqXHR.abort();
      }
      strAbort = 'abort';
      for (i in {
          success: 1,
          error: 1,
          complete: 1
        }) {
        jqXHR[i](s[i]);
      }
      transport = inspectPrefiltersOrTransports(transports, s, options, jqXHR);
      if (!transport) {
        done(-1, 'No Transport');
      } else {
        jqXHR.readyState = 1;
        if (fireGlobals) {
          globalEventContext.trigger('ajaxSend', [
            jqXHR,
            s
          ]);
        }
        if (s.async && s.timeout > 0) {
          timeoutTimer = setTimeout(function () {
            jqXHR.abort('timeout');
          }, s.timeout);
        }
        try {
          state = 1;
          transport.send(requestHeaders, done);
        } catch (e) {
          if (state < 2) {
            done(-1, e);
          } else {
            throw e;
          }
        }
      }
      function done(status, nativeStatusText, responses, headers) {
        var isSuccess, success, error, response, modified, statusText = nativeStatusText;
        if (state === 2) {
          return;
        }
        state = 2;
        if (timeoutTimer) {
          clearTimeout(timeoutTimer);
        }
        transport = undefined;
        responseHeadersString = headers || '';
        jqXHR.readyState = status > 0 ? 4 : 0;
        isSuccess = status >= 200 && status < 300 || status === 304;
        if (responses) {
          response = ajaxHandleResponses(s, jqXHR, responses);
        }
        response = ajaxConvert(s, response, jqXHR, isSuccess);
        if (isSuccess) {
          if (s.ifModified) {
            modified = jqXHR.getResponseHeader('Last-Modified');
            if (modified) {
              jQuery.lastModified[cacheURL] = modified;
            }
            modified = jqXHR.getResponseHeader('etag');
            if (modified) {
              jQuery.etag[cacheURL] = modified;
            }
          }
          if (status === 204 || s.type === 'HEAD') {
            statusText = 'nocontent';
          } else if (status === 304) {
            statusText = 'notmodified';
          } else {
            statusText = response.state;
            success = response.data;
            error = response.error;
            isSuccess = !error;
          }
        } else {
          error = statusText;
          if (status || !statusText) {
            statusText = 'error';
            if (status < 0) {
              status = 0;
            }
          }
        }
        jqXHR.status = status;
        jqXHR.statusText = (nativeStatusText || statusText) + '';
        if (isSuccess) {
          deferred.resolveWith(callbackContext, [
            success,
            statusText,
            jqXHR
          ]);
        } else {
          deferred.rejectWith(callbackContext, [
            jqXHR,
            statusText,
            error
          ]);
        }
        jqXHR.statusCode(statusCode);
        statusCode = undefined;
        if (fireGlobals) {
          globalEventContext.trigger(isSuccess ? 'ajaxSuccess' : 'ajaxError', [
            jqXHR,
            s,
            isSuccess ? success : error
          ]);
        }
        completeDeferred.fireWith(callbackContext, [
          jqXHR,
          statusText
        ]);
        if (fireGlobals) {
          globalEventContext.trigger('ajaxComplete', [
            jqXHR,
            s
          ]);
          if (!--jQuery.active) {
            jQuery.event.trigger('ajaxStop');
          }
        }
      }
      return jqXHR;
    },
    getJSON: function (url, data, callback) {
      return jQuery.get(url, data, callback, 'json');
    },
    getScript: function (url, callback) {
      return jQuery.get(url, undefined, callback, 'script');
    }
  });
  jQuery.each([
    'get',
    'post'
  ], function (i, method) {
    jQuery[method] = function (url, data, callback, type) {
      if (jQuery.isFunction(data)) {
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
  function ajaxHandleResponses(s, jqXHR, responses) {
    var firstDataType, ct, finalDataType, type, contents = s.contents, dataTypes = s.dataTypes;
    while (dataTypes[0] === '*') {
      dataTypes.shift();
      if (ct === undefined) {
        ct = s.mimeType || jqXHR.getResponseHeader('Content-Type');
      }
    }
    if (ct) {
      for (type in contents) {
        if (contents[type] && contents[type].test(ct)) {
          dataTypes.unshift(type);
          break;
        }
      }
    }
    if (dataTypes[0] in responses) {
      finalDataType = dataTypes[0];
    } else {
      for (type in responses) {
        if (!dataTypes[0] || s.converters[type + ' ' + dataTypes[0]]) {
          finalDataType = type;
          break;
        }
        if (!firstDataType) {
          firstDataType = type;
        }
      }
      finalDataType = finalDataType || firstDataType;
    }
    if (finalDataType) {
      if (finalDataType !== dataTypes[0]) {
        dataTypes.unshift(finalDataType);
      }
      return responses[finalDataType];
    }
  }
  function ajaxConvert(s, response, jqXHR, isSuccess) {
    var conv2, current, conv, tmp, prev, converters = {}, dataTypes = s.dataTypes.slice();
    if (dataTypes[1]) {
      for (conv in s.converters) {
        converters[conv.toLowerCase()] = s.converters[conv];
      }
    }
    current = dataTypes.shift();
    while (current) {
      if (s.responseFields[current]) {
        jqXHR[s.responseFields[current]] = response;
      }
      if (!prev && isSuccess && s.dataFilter) {
        response = s.dataFilter(response, s.dataType);
      }
      prev = current;
      current = dataTypes.shift();
      if (current) {
        if (current === '*') {
          current = prev;
        } else if (prev !== '*' && prev !== current) {
          conv = converters[prev + ' ' + current] || converters['* ' + current];
          if (!conv) {
            for (conv2 in converters) {
              tmp = conv2.split(' ');
              if (tmp[1] === current) {
                conv = converters[prev + ' ' + tmp[0]] || converters['* ' + tmp[0]];
                if (conv) {
                  if (conv === true) {
                    conv = converters[conv2];
                  } else if (converters[conv2] !== true) {
                    current = tmp[0];
                    dataTypes.unshift(tmp[1]);
                  }
                  break;
                }
              }
            }
          }
          if (conv !== true) {
            if (conv && s['throws']) {
              response = conv(response);
            } else {
              try {
                response = conv(response);
              } catch (e) {
                return {
                  state: 'parsererror',
                  error: conv ? e : 'No conversion from ' + prev + ' to ' + current
                };
              }
            }
          }
        }
      }
    }
    return {
      state: 'success',
      data: response
    };
  }
  jQuery.ajaxSetup({
    accepts: { script: 'text/javascript, application/javascript, application/ecmascript, application/x-ecmascript' },
    contents: { script: /(?:java|ecma)script/ },
    converters: {
      'text script': function (text) {
        jQuery.globalEval(text);
        return text;
      }
    }
  });
  jQuery.ajaxPrefilter('script', function (s) {
    if (s.cache === undefined) {
      s.cache = false;
    }
    if (s.crossDomain) {
      s.type = 'GET';
      s.global = false;
    }
  });
  jQuery.ajaxTransport('script', function (s) {
    if (s.crossDomain) {
      var script, head = document.head || jQuery('head')[0] || document.documentElement;
      return {
        send: function (_, callback) {
          script = document.createElement('script');
          script.async = true;
          if (s.scriptCharset) {
            script.charset = s.scriptCharset;
          }
          script.src = s.url;
          script.onload = script.onreadystatechange = function (_, isAbort) {
            if (isAbort || !script.readyState || /loaded|complete/.test(script.readyState)) {
              script.onload = script.onreadystatechange = null;
              if (script.parentNode) {
                script.parentNode.removeChild(script);
              }
              script = null;
              if (!isAbort) {
                callback(200, 'success');
              }
            }
          };
          head.insertBefore(script, head.firstChild);
        },
        abort: function () {
          if (script) {
            script.onload(undefined, true);
          }
        }
      };
    }
  });
  var oldCallbacks = [], rjsonp = /(=)\?(?=&|$)|\?\?/;
  jQuery.ajaxSetup({
    jsonp: 'callback',
    jsonpCallback: function () {
      var callback = oldCallbacks.pop() || jQuery.expando + '_' + ajax_nonce++;
      this[callback] = true;
      return callback;
    }
  });
  jQuery.ajaxPrefilter('json jsonp', function (s, originalSettings, jqXHR) {
    var callbackName, overwritten, responseContainer, jsonProp = s.jsonp !== false && (rjsonp.test(s.url) ? 'url' : typeof s.data === 'string' && !(s.contentType || '').indexOf('application/x-www-form-urlencoded') && rjsonp.test(s.data) && 'data');
    if (jsonProp || s.dataTypes[0] === 'jsonp') {
      callbackName = s.jsonpCallback = jQuery.isFunction(s.jsonpCallback) ? s.jsonpCallback() : s.jsonpCallback;
      if (jsonProp) {
        s[jsonProp] = s[jsonProp].replace(rjsonp, '$1' + callbackName);
      } else if (s.jsonp !== false) {
        s.url += (ajax_rquery.test(s.url) ? '&' : '?') + s.jsonp + '=' + callbackName;
      }
      s.converters['script json'] = function () {
        if (!responseContainer) {
          jQuery.error(callbackName + ' was not called');
        }
        return responseContainer[0];
      };
      s.dataTypes[0] = 'json';
      overwritten = window[callbackName];
      window[callbackName] = function () {
        responseContainer = arguments;
      };
      jqXHR.always(function () {
        window[callbackName] = overwritten;
        if (s[callbackName]) {
          s.jsonpCallback = originalSettings.jsonpCallback;
          oldCallbacks.push(callbackName);
        }
        if (responseContainer && jQuery.isFunction(overwritten)) {
          overwritten(responseContainer[0]);
        }
        responseContainer = overwritten = undefined;
      });
      return 'script';
    }
  });
  var xhrCallbacks, xhrSupported, xhrId = 0, xhrOnUnloadAbort = window.ActiveXObject && function () {
      var key;
      for (key in xhrCallbacks) {
        xhrCallbacks[key](undefined, true);
      }
    };
  function createStandardXHR() {
    try {
      return new window.XMLHttpRequest();
    } catch (e) {
    }
  }
  function createActiveXHR() {
    try {
      return new window.ActiveXObject('Microsoft.XMLHTTP');
    } catch (e) {
    }
  }
  jQuery.ajaxSettings.xhr = window.ActiveXObject ? function () {
    return !this.isLocal && createStandardXHR() || createActiveXHR();
  } : createStandardXHR;
  xhrSupported = jQuery.ajaxSettings.xhr();
  jQuery.support.cors = !!xhrSupported && 'withCredentials' in xhrSupported;
  xhrSupported = jQuery.support.ajax = !!xhrSupported;
  if (xhrSupported) {
    jQuery.ajaxTransport(function (s) {
      if (!s.crossDomain || jQuery.support.cors) {
        var callback;
        return {
          send: function (headers, complete) {
            var handle, i, xhr = s.xhr();
            if (s.username) {
              xhr.open(s.type, s.url, s.async, s.username, s.password);
            } else {
              xhr.open(s.type, s.url, s.async);
            }
            if (s.xhrFields) {
              for (i in s.xhrFields) {
                xhr[i] = s.xhrFields[i];
              }
            }
            if (s.mimeType && xhr.overrideMimeType) {
              xhr.overrideMimeType(s.mimeType);
            }
            if (!s.crossDomain && !headers['X-Requested-With']) {
              headers['X-Requested-With'] = 'XMLHttpRequest';
            }
            try {
              for (i in headers) {
                xhr.setRequestHeader(i, headers[i]);
              }
            } catch (err) {
            }
            xhr.send(s.hasContent && s.data || null);
            callback = function (_, isAbort) {
              var status, responseHeaders, statusText, responses;
              try {
                if (callback && (isAbort || xhr.readyState === 4)) {
                  callback = undefined;
                  if (handle) {
                    xhr.onreadystatechange = jQuery.noop;
                    if (xhrOnUnloadAbort) {
                      delete xhrCallbacks[handle];
                    }
                  }
                  if (isAbort) {
                    if (xhr.readyState !== 4) {
                      xhr.abort();
                    }
                  } else {
                    responses = {};
                    status = xhr.status;
                    responseHeaders = xhr.getAllResponseHeaders();
                    if (typeof xhr.responseText === 'string') {
                      responses.text = xhr.responseText;
                    }
                    try {
                      statusText = xhr.statusText;
                    } catch (e) {
                      statusText = '';
                    }
                    if (!status && s.isLocal && !s.crossDomain) {
                      status = responses.text ? 200 : 404;
                    } else if (status === 1223) {
                      status = 204;
                    }
                  }
                }
              } catch (firefoxAccessException) {
                if (!isAbort) {
                  complete(-1, firefoxAccessException);
                }
              }
              if (responses) {
                complete(status, statusText, responses, responseHeaders);
              }
            };
            if (!s.async) {
              callback();
            } else if (xhr.readyState === 4) {
              setTimeout(callback);
            } else {
              handle = ++xhrId;
              if (xhrOnUnloadAbort) {
                if (!xhrCallbacks) {
                  xhrCallbacks = {};
                  jQuery(window).unload(xhrOnUnloadAbort);
                }
                xhrCallbacks[handle] = callback;
              }
              xhr.onreadystatechange = callback;
            }
          },
          abort: function () {
            if (callback) {
              callback(undefined, true);
            }
          }
        };
      }
    });
  }
  var fxNow, timerId, rfxtypes = /^(?:toggle|show|hide)$/, rfxnum = new RegExp('^(?:([+-])=|)(' + core_pnum + ')([a-z%]*)$', 'i'), rrun = /queueHooks$/, animationPrefilters = [defaultPrefilter], tweeners = {
      '*': [function (prop, value) {
          var tween = this.createTween(prop, value), target = tween.cur(), parts = rfxnum.exec(value), unit = parts && parts[3] || (jQuery.cssNumber[prop] ? '' : 'px'), start = (jQuery.cssNumber[prop] || unit !== 'px' && +target) && rfxnum.exec(jQuery.css(tween.elem, prop)), scale = 1, maxIterations = 20;
          if (start && start[3] !== unit) {
            unit = unit || start[3];
            parts = parts || [];
            start = +target || 1;
            do {
              scale = scale || '.5';
              start = start / scale;
              jQuery.style(tween.elem, prop, start + unit);
            } while (scale !== (scale = tween.cur() / target) && scale !== 1 && --maxIterations);
          }
          if (parts) {
            start = tween.start = +start || +target || 0;
            tween.unit = unit;
            tween.end = parts[1] ? start + (parts[1] + 1) * parts[2] : +parts[2];
          }
          return tween;
        }]
    };
  function createFxNow() {
    setTimeout(function () {
      fxNow = undefined;
    });
    return fxNow = jQuery.now();
  }
  function createTween(value, prop, animation) {
    var tween, collection = (tweeners[prop] || []).concat(tweeners['*']), index = 0, length = collection.length;
    for (; index < length; index++) {
      if (tween = collection[index].call(animation, prop, value)) {
        return tween;
      }
    }
  }
  function Animation(elem, properties, options) {
    var result, stopped, index = 0, length = animationPrefilters.length, deferred = jQuery.Deferred().always(function () {
        delete tick.elem;
      }), tick = function () {
        if (stopped) {
          return false;
        }
        var currentTime = fxNow || createFxNow(), remaining = Math.max(0, animation.startTime + animation.duration - currentTime), temp = remaining / animation.duration || 0, percent = 1 - temp, index = 0, length = animation.tweens.length;
        for (; index < length; index++) {
          animation.tweens[index].run(percent);
        }
        deferred.notifyWith(elem, [
          animation,
          percent,
          remaining
        ]);
        if (percent < 1 && length) {
          return remaining;
        } else {
          deferred.resolveWith(elem, [animation]);
          return false;
        }
      }, animation = deferred.promise({
        elem: elem,
        props: jQuery.extend({}, properties),
        opts: jQuery.extend(true, { specialEasing: {} }, options),
        originalProperties: properties,
        originalOptions: options,
        startTime: fxNow || createFxNow(),
        duration: options.duration,
        tweens: [],
        createTween: function (prop, end) {
          var tween = jQuery.Tween(elem, animation.opts, prop, end, animation.opts.specialEasing[prop] || animation.opts.easing);
          animation.tweens.push(tween);
          return tween;
        },
        stop: function (gotoEnd) {
          var index = 0, length = gotoEnd ? animation.tweens.length : 0;
          if (stopped) {
            return this;
          }
          stopped = true;
          for (; index < length; index++) {
            animation.tweens[index].run(1);
          }
          if (gotoEnd) {
            deferred.resolveWith(elem, [
              animation,
              gotoEnd
            ]);
          } else {
            deferred.rejectWith(elem, [
              animation,
              gotoEnd
            ]);
          }
          return this;
        }
      }), props = animation.props;
    propFilter(props, animation.opts.specialEasing);
    for (; index < length; index++) {
      result = animationPrefilters[index].call(animation, elem, props, animation.opts);
      if (result) {
        return result;
      }
    }
    jQuery.map(props, createTween, animation);
    if (jQuery.isFunction(animation.opts.start)) {
      animation.opts.start.call(elem, animation);
    }
    jQuery.fx.timer(jQuery.extend(tick, {
      elem: elem,
      anim: animation,
      queue: animation.opts.queue
    }));
    return animation.progress(animation.opts.progress).done(animation.opts.done, animation.opts.complete).fail(animation.opts.fail).always(animation.opts.always);
  }
  function propFilter(props, specialEasing) {
    var index, name, easing, value, hooks;
    for (index in props) {
      name = jQuery.camelCase(index);
      easing = specialEasing[name];
      value = props[index];
      if (jQuery.isArray(value)) {
        easing = value[1];
        value = props[index] = value[0];
      }
      if (index !== name) {
        props[name] = value;
        delete props[index];
      }
      hooks = jQuery.cssHooks[name];
      if (hooks && 'expand' in hooks) {
        value = hooks.expand(value);
        delete props[name];
        for (index in value) {
          if (!(index in props)) {
            props[index] = value[index];
            specialEasing[index] = easing;
          }
        }
      } else {
        specialEasing[name] = easing;
      }
    }
  }
  jQuery.Animation = jQuery.extend(Animation, {
    tweener: function (props, callback) {
      if (jQuery.isFunction(props)) {
        callback = props;
        props = ['*'];
      } else {
        props = props.split(' ');
      }
      var prop, index = 0, length = props.length;
      for (; index < length; index++) {
        prop = props[index];
        tweeners[prop] = tweeners[prop] || [];
        tweeners[prop].unshift(callback);
      }
    },
    prefilter: function (callback, prepend) {
      if (prepend) {
        animationPrefilters.unshift(callback);
      } else {
        animationPrefilters.push(callback);
      }
    }
  });
  function defaultPrefilter(elem, props, opts) {
    var prop, value, toggle, tween, hooks, oldfire, anim = this, orig = {}, style = elem.style, hidden = elem.nodeType && isHidden(elem), dataShow = jQuery._data(elem, 'fxshow');
    if (!opts.queue) {
      hooks = jQuery._queueHooks(elem, 'fx');
      if (hooks.unqueued == null) {
        hooks.unqueued = 0;
        oldfire = hooks.empty.fire;
        hooks.empty.fire = function () {
          if (!hooks.unqueued) {
            oldfire();
          }
        };
      }
      hooks.unqueued++;
      anim.always(function () {
        anim.always(function () {
          hooks.unqueued--;
          if (!jQuery.queue(elem, 'fx').length) {
            hooks.empty.fire();
          }
        });
      });
    }
    if (elem.nodeType === 1 && ('height' in props || 'width' in props)) {
      opts.overflow = [
        style.overflow,
        style.overflowX,
        style.overflowY
      ];
      if (jQuery.css(elem, 'display') === 'inline' && jQuery.css(elem, 'float') === 'none') {
        if (!jQuery.support.inlineBlockNeedsLayout || css_defaultDisplay(elem.nodeName) === 'inline') {
          style.display = 'inline-block';
        } else {
          style.zoom = 1;
        }
      }
    }
    if (opts.overflow) {
      style.overflow = 'hidden';
      if (!jQuery.support.shrinkWrapBlocks) {
        anim.always(function () {
          style.overflow = opts.overflow[0];
          style.overflowX = opts.overflow[1];
          style.overflowY = opts.overflow[2];
        });
      }
    }
    for (prop in props) {
      value = props[prop];
      if (rfxtypes.exec(value)) {
        delete props[prop];
        toggle = toggle || value === 'toggle';
        if (value === (hidden ? 'hide' : 'show')) {
          continue;
        }
        orig[prop] = dataShow && dataShow[prop] || jQuery.style(elem, prop);
      }
    }
    if (!jQuery.isEmptyObject(orig)) {
      if (dataShow) {
        if ('hidden' in dataShow) {
          hidden = dataShow.hidden;
        }
      } else {
        dataShow = jQuery._data(elem, 'fxshow', {});
      }
      if (toggle) {
        dataShow.hidden = !hidden;
      }
      if (hidden) {
        jQuery(elem).show();
      } else {
        anim.done(function () {
          jQuery(elem).hide();
        });
      }
      anim.done(function () {
        var prop;
        jQuery._removeData(elem, 'fxshow');
        for (prop in orig) {
          jQuery.style(elem, prop, orig[prop]);
        }
      });
      for (prop in orig) {
        tween = createTween(hidden ? dataShow[prop] : 0, prop, anim);
        if (!(prop in dataShow)) {
          dataShow[prop] = tween.start;
          if (hidden) {
            tween.end = tween.start;
            tween.start = prop === 'width' || prop === 'height' ? 1 : 0;
          }
        }
      }
    }
  }
  function Tween(elem, options, prop, end, easing) {
    return new Tween.prototype.init(elem, options, prop, end, easing);
  }
  jQuery.Tween = Tween;
  Tween.prototype = {
    constructor: Tween,
    init: function (elem, options, prop, end, easing, unit) {
      this.elem = elem;
      this.prop = prop;
      this.easing = easing || 'swing';
      this.options = options;
      this.start = this.now = this.cur();
      this.end = end;
      this.unit = unit || (jQuery.cssNumber[prop] ? '' : 'px');
    },
    cur: function () {
      var hooks = Tween.propHooks[this.prop];
      return hooks && hooks.get ? hooks.get(this) : Tween.propHooks._default.get(this);
    },
    run: function (percent) {
      var eased, hooks = Tween.propHooks[this.prop];
      if (this.options.duration) {
        this.pos = eased = jQuery.easing[this.easing](percent, this.options.duration * percent, 0, 1, this.options.duration);
      } else {
        this.pos = eased = percent;
      }
      this.now = (this.end - this.start) * eased + this.start;
      if (this.options.step) {
        this.options.step.call(this.elem, this.now, this);
      }
      if (hooks && hooks.set) {
        hooks.set(this);
      } else {
        Tween.propHooks._default.set(this);
      }
      return this;
    }
  };
  Tween.prototype.init.prototype = Tween.prototype;
  Tween.propHooks = {
    _default: {
      get: function (tween) {
        var result;
        if (tween.elem[tween.prop] != null && (!tween.elem.style || tween.elem.style[tween.prop] == null)) {
          return tween.elem[tween.prop];
        }
        result = jQuery.css(tween.elem, tween.prop, '');
        return !result || result === 'auto' ? 0 : result;
      },
      set: function (tween) {
        if (jQuery.fx.step[tween.prop]) {
          jQuery.fx.step[tween.prop](tween);
        } else if (tween.elem.style && (tween.elem.style[jQuery.cssProps[tween.prop]] != null || jQuery.cssHooks[tween.prop])) {
          jQuery.style(tween.elem, tween.prop, tween.now + tween.unit);
        } else {
          tween.elem[tween.prop] = tween.now;
        }
      }
    }
  };
  Tween.propHooks.scrollTop = Tween.propHooks.scrollLeft = {
    set: function (tween) {
      if (tween.elem.nodeType && tween.elem.parentNode) {
        tween.elem[tween.prop] = tween.now;
      }
    }
  };
  jQuery.each([
    'toggle',
    'show',
    'hide'
  ], function (i, name) {
    var cssFn = jQuery.fn[name];
    jQuery.fn[name] = function (speed, easing, callback) {
      return speed == null || typeof speed === 'boolean' ? cssFn.apply(this, arguments) : this.animate(genFx(name, true), speed, easing, callback);
    };
  });
  jQuery.fn.extend({
    fadeTo: function (speed, to, easing, callback) {
      return this.filter(isHidden).css('opacity', 0).show().end().animate({ opacity: to }, speed, easing, callback);
    },
    animate: function (prop, speed, easing, callback) {
      var empty = jQuery.isEmptyObject(prop), optall = jQuery.speed(speed, easing, callback), doAnimation = function () {
          var anim = Animation(this, jQuery.extend({}, prop), optall);
          if (empty || jQuery._data(this, 'finish')) {
            anim.stop(true);
          }
        };
      doAnimation.finish = doAnimation;
      return empty || optall.queue === false ? this.each(doAnimation) : this.queue(optall.queue, doAnimation);
    },
    stop: function (type, clearQueue, gotoEnd) {
      var stopQueue = function (hooks) {
        var stop = hooks.stop;
        delete hooks.stop;
        stop(gotoEnd);
      };
      if (typeof type !== 'string') {
        gotoEnd = clearQueue;
        clearQueue = type;
        type = undefined;
      }
      if (clearQueue && type !== false) {
        this.queue(type || 'fx', []);
      }
      return this.each(function () {
        var dequeue = true, index = type != null && type + 'queueHooks', timers = jQuery.timers, data = jQuery._data(this);
        if (index) {
          if (data[index] && data[index].stop) {
            stopQueue(data[index]);
          }
        } else {
          for (index in data) {
            if (data[index] && data[index].stop && rrun.test(index)) {
              stopQueue(data[index]);
            }
          }
        }
        for (index = timers.length; index--;) {
          if (timers[index].elem === this && (type == null || timers[index].queue === type)) {
            timers[index].anim.stop(gotoEnd);
            dequeue = false;
            timers.splice(index, 1);
          }
        }
        if (dequeue || !gotoEnd) {
          jQuery.dequeue(this, type);
        }
      });
    },
    finish: function (type) {
      if (type !== false) {
        type = type || 'fx';
      }
      return this.each(function () {
        var index, data = jQuery._data(this), queue = data[type + 'queue'], hooks = data[type + 'queueHooks'], timers = jQuery.timers, length = queue ? queue.length : 0;
        data.finish = true;
        jQuery.queue(this, type, []);
        if (hooks && hooks.stop) {
          hooks.stop.call(this, true);
        }
        for (index = timers.length; index--;) {
          if (timers[index].elem === this && timers[index].queue === type) {
            timers[index].anim.stop(true);
            timers.splice(index, 1);
          }
        }
        for (index = 0; index < length; index++) {
          if (queue[index] && queue[index].finish) {
            queue[index].finish.call(this);
          }
        }
        delete data.finish;
      });
    }
  });
  function genFx(type, includeWidth) {
    var which, attrs = { height: type }, i = 0;
    includeWidth = includeWidth ? 1 : 0;
    for (; i < 4; i += 2 - includeWidth) {
      which = cssExpand[i];
      attrs['margin' + which] = attrs['padding' + which] = type;
    }
    if (includeWidth) {
      attrs.opacity = attrs.width = type;
    }
    return attrs;
  }
  jQuery.each({
    slideDown: genFx('show'),
    slideUp: genFx('hide'),
    slideToggle: genFx('toggle'),
    fadeIn: { opacity: 'show' },
    fadeOut: { opacity: 'hide' },
    fadeToggle: { opacity: 'toggle' }
  }, function (name, props) {
    jQuery.fn[name] = function (speed, easing, callback) {
      return this.animate(props, speed, easing, callback);
    };
  });
  jQuery.speed = function (speed, easing, fn) {
    var opt = speed && typeof speed === 'object' ? jQuery.extend({}, speed) : {
        complete: fn || !fn && easing || jQuery.isFunction(speed) && speed,
        duration: speed,
        easing: fn && easing || easing && !jQuery.isFunction(easing) && easing
      };
    opt.duration = jQuery.fx.off ? 0 : typeof opt.duration === 'number' ? opt.duration : opt.duration in jQuery.fx.speeds ? jQuery.fx.speeds[opt.duration] : jQuery.fx.speeds._default;
    if (opt.queue == null || opt.queue === true) {
      opt.queue = 'fx';
    }
    opt.old = opt.complete;
    opt.complete = function () {
      if (jQuery.isFunction(opt.old)) {
        opt.old.call(this);
      }
      if (opt.queue) {
        jQuery.dequeue(this, opt.queue);
      }
    };
    return opt;
  };
  jQuery.easing = {
    linear: function (p) {
      return p;
    },
    swing: function (p) {
      return 0.5 - Math.cos(p * Math.PI) / 2;
    }
  };
  jQuery.timers = [];
  jQuery.fx = Tween.prototype.init;
  jQuery.fx.tick = function () {
    var timer, timers = jQuery.timers, i = 0;
    fxNow = jQuery.now();
    for (; i < timers.length; i++) {
      timer = timers[i];
      if (!timer() && timers[i] === timer) {
        timers.splice(i--, 1);
      }
    }
    if (!timers.length) {
      jQuery.fx.stop();
    }
    fxNow = undefined;
  };
  jQuery.fx.timer = function (timer) {
    if (timer() && jQuery.timers.push(timer)) {
      jQuery.fx.start();
    }
  };
  jQuery.fx.interval = 13;
  jQuery.fx.start = function () {
    if (!timerId) {
      timerId = setInterval(jQuery.fx.tick, jQuery.fx.interval);
    }
  };
  jQuery.fx.stop = function () {
    clearInterval(timerId);
    timerId = null;
  };
  jQuery.fx.speeds = {
    slow: 600,
    fast: 200,
    _default: 400
  };
  jQuery.fx.step = {};
  if (jQuery.expr && jQuery.expr.filters) {
    jQuery.expr.filters.animated = function (elem) {
      return jQuery.grep(jQuery.timers, function (fn) {
        return elem === fn.elem;
      }).length;
    };
  }
  jQuery.fn.offset = function (options) {
    if (arguments.length) {
      return options === undefined ? this : this.each(function (i) {
        jQuery.offset.setOffset(this, options, i);
      });
    }
    var docElem, win, box = {
        top: 0,
        left: 0
      }, elem = this[0], doc = elem && elem.ownerDocument;
    if (!doc) {
      return;
    }
    docElem = doc.documentElement;
    if (!jQuery.contains(docElem, elem)) {
      return box;
    }
    if (typeof elem.getBoundingClientRect !== core_strundefined) {
      box = elem.getBoundingClientRect();
    }
    win = getWindow(doc);
    return {
      top: box.top + (win.pageYOffset || docElem.scrollTop) - (docElem.clientTop || 0),
      left: box.left + (win.pageXOffset || docElem.scrollLeft) - (docElem.clientLeft || 0)
    };
  };
  jQuery.offset = {
    setOffset: function (elem, options, i) {
      var position = jQuery.css(elem, 'position');
      if (position === 'static') {
        elem.style.position = 'relative';
      }
      var curElem = jQuery(elem), curOffset = curElem.offset(), curCSSTop = jQuery.css(elem, 'top'), curCSSLeft = jQuery.css(elem, 'left'), calculatePosition = (position === 'absolute' || position === 'fixed') && jQuery.inArray('auto', [
          curCSSTop,
          curCSSLeft
        ]) > -1, props = {}, curPosition = {}, curTop, curLeft;
      if (calculatePosition) {
        curPosition = curElem.position();
        curTop = curPosition.top;
        curLeft = curPosition.left;
      } else {
        curTop = parseFloat(curCSSTop) || 0;
        curLeft = parseFloat(curCSSLeft) || 0;
      }
      if (jQuery.isFunction(options)) {
        options = options.call(elem, i, curOffset);
      }
      if (options.top != null) {
        props.top = options.top - curOffset.top + curTop;
      }
      if (options.left != null) {
        props.left = options.left - curOffset.left + curLeft;
      }
      if ('using' in options) {
        options.using.call(elem, props);
      } else {
        curElem.css(props);
      }
    }
  };
  jQuery.fn.extend({
    position: function () {
      if (!this[0]) {
        return;
      }
      var offsetParent, offset, parentOffset = {
          top: 0,
          left: 0
        }, elem = this[0];
      if (jQuery.css(elem, 'position') === 'fixed') {
        offset = elem.getBoundingClientRect();
      } else {
        offsetParent = this.offsetParent();
        offset = this.offset();
        if (!jQuery.nodeName(offsetParent[0], 'html')) {
          parentOffset = offsetParent.offset();
        }
        parentOffset.top += jQuery.css(offsetParent[0], 'borderTopWidth', true);
        parentOffset.left += jQuery.css(offsetParent[0], 'borderLeftWidth', true);
      }
      return {
        top: offset.top - parentOffset.top - jQuery.css(elem, 'marginTop', true),
        left: offset.left - parentOffset.left - jQuery.css(elem, 'marginLeft', true)
      };
    },
    offsetParent: function () {
      return this.map(function () {
        var offsetParent = this.offsetParent || docElem;
        while (offsetParent && (!jQuery.nodeName(offsetParent, 'html') && jQuery.css(offsetParent, 'position') === 'static')) {
          offsetParent = offsetParent.offsetParent;
        }
        return offsetParent || docElem;
      });
    }
  });
  jQuery.each({
    scrollLeft: 'pageXOffset',
    scrollTop: 'pageYOffset'
  }, function (method, prop) {
    var top = /Y/.test(prop);
    jQuery.fn[method] = function (val) {
      return jQuery.access(this, function (elem, method, val) {
        var win = getWindow(elem);
        if (val === undefined) {
          return win ? prop in win ? win[prop] : win.document.documentElement[method] : elem[method];
        }
        if (win) {
          win.scrollTo(!top ? val : jQuery(win).scrollLeft(), top ? val : jQuery(win).scrollTop());
        } else {
          elem[method] = val;
        }
      }, method, val, arguments.length, null);
    };
  });
  function getWindow(elem) {
    return jQuery.isWindow(elem) ? elem : elem.nodeType === 9 ? elem.defaultView || elem.parentWindow : false;
  }
  jQuery.each({
    Height: 'height',
    Width: 'width'
  }, function (name, type) {
    jQuery.each({
      padding: 'inner' + name,
      content: type,
      '': 'outer' + name
    }, function (defaultExtra, funcName) {
      jQuery.fn[funcName] = function (margin, value) {
        var chainable = arguments.length && (defaultExtra || typeof margin !== 'boolean'), extra = defaultExtra || (margin === true || value === true ? 'margin' : 'border');
        return jQuery.access(this, function (elem, type, value) {
          var doc;
          if (jQuery.isWindow(elem)) {
            return elem.document.documentElement['client' + name];
          }
          if (elem.nodeType === 9) {
            doc = elem.documentElement;
            return Math.max(elem.body['scroll' + name], doc['scroll' + name], elem.body['offset' + name], doc['offset' + name], doc['client' + name]);
          }
          return value === undefined ? jQuery.css(elem, type, extra) : jQuery.style(elem, type, value, extra);
        }, type, chainable ? margin : undefined, chainable, null);
      };
    });
  });
  jQuery.fn.size = function () {
    return this.length;
  };
  jQuery.fn.andSelf = jQuery.fn.addBack;
  if (typeof module === 'object' && module && typeof module.exports === 'object') {
    module.exports = jQuery;
  } else {
    window.jQuery = window.$ = jQuery;
    if (typeof define === 'function' && define.amd) {
      define('jquery', [], function () {
        return jQuery;
      });
    }
  }
}(window));
(function () {
  var root = this;
  var previousUnderscore = root._;
  var breaker = {};
  var ArrayProto = Array.prototype, ObjProto = Object.prototype, FuncProto = Function.prototype;
  var slice = ArrayProto.slice, unshift = ArrayProto.unshift, toString = ObjProto.toString, hasOwnProperty = ObjProto.hasOwnProperty;
  var nativeForEach = ArrayProto.forEach, nativeMap = ArrayProto.map, nativeReduce = ArrayProto.reduce, nativeReduceRight = ArrayProto.reduceRight, nativeFilter = ArrayProto.filter, nativeEvery = ArrayProto.every, nativeSome = ArrayProto.some, nativeIndexOf = ArrayProto.indexOf, nativeLastIndexOf = ArrayProto.lastIndexOf, nativeIsArray = Array.isArray, nativeKeys = Object.keys, nativeBind = FuncProto.bind;
  var _ = function (obj) {
    return new wrapper(obj);
  };
  if (typeof exports !== 'undefined') {
    if (typeof module !== 'undefined' && module.exports) {
      exports = module.exports = _;
    }
    exports._ = _;
  } else {
    root['_'] = _;
  }
  _.VERSION = '1.3.3';
  var each = _.each = _.forEach = function (obj, iterator, context) {
      if (obj == null)
        return;
      if (nativeForEach && obj.forEach === nativeForEach) {
        obj.forEach(iterator, context);
      } else if (obj.length === +obj.length) {
        for (var i = 0, l = obj.length; i < l; i++) {
          if (i in obj && iterator.call(context, obj[i], i, obj) === breaker)
            return;
        }
      } else {
        for (var key in obj) {
          if (_.has(obj, key)) {
            if (iterator.call(context, obj[key], key, obj) === breaker)
              return;
          }
        }
      }
    };
  _.map = _.collect = function (obj, iterator, context) {
    var results = [];
    if (obj == null)
      return results;
    if (nativeMap && obj.map === nativeMap)
      return obj.map(iterator, context);
    each(obj, function (value, index, list) {
      results[results.length] = iterator.call(context, value, index, list);
    });
    if (obj.length === +obj.length)
      results.length = obj.length;
    return results;
  };
  _.reduce = _.foldl = _.inject = function (obj, iterator, memo, context) {
    var initial = arguments.length > 2;
    if (obj == null)
      obj = [];
    if (nativeReduce && obj.reduce === nativeReduce) {
      if (context)
        iterator = _.bind(iterator, context);
      return initial ? obj.reduce(iterator, memo) : obj.reduce(iterator);
    }
    each(obj, function (value, index, list) {
      if (!initial) {
        memo = value;
        initial = true;
      } else {
        memo = iterator.call(context, memo, value, index, list);
      }
    });
    if (!initial)
      throw new TypeError('Reduce of empty array with no initial value');
    return memo;
  };
  _.reduceRight = _.foldr = function (obj, iterator, memo, context) {
    var initial = arguments.length > 2;
    if (obj == null)
      obj = [];
    if (nativeReduceRight && obj.reduceRight === nativeReduceRight) {
      if (context)
        iterator = _.bind(iterator, context);
      return initial ? obj.reduceRight(iterator, memo) : obj.reduceRight(iterator);
    }
    var reversed = _.toArray(obj).reverse();
    if (context && !initial)
      iterator = _.bind(iterator, context);
    return initial ? _.reduce(reversed, iterator, memo, context) : _.reduce(reversed, iterator);
  };
  _.find = _.detect = function (obj, iterator, context) {
    var result;
    any(obj, function (value, index, list) {
      if (iterator.call(context, value, index, list)) {
        result = value;
        return true;
      }
    });
    return result;
  };
  _.filter = _.select = function (obj, iterator, context) {
    var results = [];
    if (obj == null)
      return results;
    if (nativeFilter && obj.filter === nativeFilter)
      return obj.filter(iterator, context);
    each(obj, function (value, index, list) {
      if (iterator.call(context, value, index, list))
        results[results.length] = value;
    });
    return results;
  };
  _.reject = function (obj, iterator, context) {
    var results = [];
    if (obj == null)
      return results;
    each(obj, function (value, index, list) {
      if (!iterator.call(context, value, index, list))
        results[results.length] = value;
    });
    return results;
  };
  _.every = _.all = function (obj, iterator, context) {
    var result = true;
    if (obj == null)
      return result;
    if (nativeEvery && obj.every === nativeEvery)
      return obj.every(iterator, context);
    each(obj, function (value, index, list) {
      if (!(result = result && iterator.call(context, value, index, list)))
        return breaker;
    });
    return !!result;
  };
  var any = _.some = _.any = function (obj, iterator, context) {
      iterator || (iterator = _.identity);
      var result = false;
      if (obj == null)
        return result;
      if (nativeSome && obj.some === nativeSome)
        return obj.some(iterator, context);
      each(obj, function (value, index, list) {
        if (result || (result = iterator.call(context, value, index, list)))
          return breaker;
      });
      return !!result;
    };
  _.include = _.contains = function (obj, target) {
    var found = false;
    if (obj == null)
      return found;
    if (nativeIndexOf && obj.indexOf === nativeIndexOf)
      return obj.indexOf(target) != -1;
    found = any(obj, function (value) {
      return value === target;
    });
    return found;
  };
  _.invoke = function (obj, method) {
    var args = slice.call(arguments, 2);
    return _.map(obj, function (value) {
      return (_.isFunction(method) ? method || value : value[method]).apply(value, args);
    });
  };
  _.pluck = function (obj, key) {
    return _.map(obj, function (value) {
      return value[key];
    });
  };
  _.max = function (obj, iterator, context) {
    if (!iterator && _.isArray(obj) && obj[0] === +obj[0])
      return Math.max.apply(Math, obj);
    if (!iterator && _.isEmpty(obj))
      return -Infinity;
    var result = { computed: -Infinity };
    each(obj, function (value, index, list) {
      var computed = iterator ? iterator.call(context, value, index, list) : value;
      computed >= result.computed && (result = {
        value: value,
        computed: computed
      });
    });
    return result.value;
  };
  _.min = function (obj, iterator, context) {
    if (!iterator && _.isArray(obj) && obj[0] === +obj[0])
      return Math.min.apply(Math, obj);
    if (!iterator && _.isEmpty(obj))
      return Infinity;
    var result = { computed: Infinity };
    each(obj, function (value, index, list) {
      var computed = iterator ? iterator.call(context, value, index, list) : value;
      computed < result.computed && (result = {
        value: value,
        computed: computed
      });
    });
    return result.value;
  };
  _.shuffle = function (obj) {
    var shuffled = [], rand;
    each(obj, function (value, index, list) {
      rand = Math.floor(Math.random() * (index + 1));
      shuffled[index] = shuffled[rand];
      shuffled[rand] = value;
    });
    return shuffled;
  };
  _.sortBy = function (obj, val, context) {
    var iterator = _.isFunction(val) ? val : function (obj) {
        return obj[val];
      };
    return _.pluck(_.map(obj, function (value, index, list) {
      return {
        value: value,
        criteria: iterator.call(context, value, index, list)
      };
    }).sort(function (left, right) {
      var a = left.criteria, b = right.criteria;
      if (a === void 0)
        return 1;
      if (b === void 0)
        return -1;
      return a < b ? -1 : a > b ? 1 : 0;
    }), 'value');
  };
  _.groupBy = function (obj, val) {
    var result = {};
    var iterator = _.isFunction(val) ? val : function (obj) {
        return obj[val];
      };
    each(obj, function (value, index) {
      var key = iterator(value, index);
      (result[key] || (result[key] = [])).push(value);
    });
    return result;
  };
  _.sortedIndex = function (array, obj, iterator) {
    iterator || (iterator = _.identity);
    var low = 0, high = array.length;
    while (low < high) {
      var mid = low + high >> 1;
      iterator(array[mid]) < iterator(obj) ? low = mid + 1 : high = mid;
    }
    return low;
  };
  _.toArray = function (obj) {
    if (!obj)
      return [];
    if (_.isArray(obj))
      return slice.call(obj);
    if (_.isArguments(obj))
      return slice.call(obj);
    if (obj.toArray && _.isFunction(obj.toArray))
      return obj.toArray();
    return _.values(obj);
  };
  _.size = function (obj) {
    return _.isArray(obj) ? obj.length : _.keys(obj).length;
  };
  _.first = _.head = _.take = function (array, n, guard) {
    return n != null && !guard ? slice.call(array, 0, n) : array[0];
  };
  _.initial = function (array, n, guard) {
    return slice.call(array, 0, array.length - (n == null || guard ? 1 : n));
  };
  _.last = function (array, n, guard) {
    if (n != null && !guard) {
      return slice.call(array, Math.max(array.length - n, 0));
    } else {
      return array[array.length - 1];
    }
  };
  _.rest = _.tail = function (array, index, guard) {
    return slice.call(array, index == null || guard ? 1 : index);
  };
  _.compact = function (array) {
    return _.filter(array, function (value) {
      return !!value;
    });
  };
  _.flatten = function (array, shallow) {
    return _.reduce(array, function (memo, value) {
      if (_.isArray(value))
        return memo.concat(shallow ? value : _.flatten(value));
      memo[memo.length] = value;
      return memo;
    }, []);
  };
  _.without = function (array) {
    return _.difference(array, slice.call(arguments, 1));
  };
  _.uniq = _.unique = function (array, isSorted, iterator) {
    var initial = iterator ? _.map(array, iterator) : array;
    var results = [];
    if (array.length < 3)
      isSorted = true;
    _.reduce(initial, function (memo, value, index) {
      if (isSorted ? _.last(memo) !== value || !memo.length : !_.include(memo, value)) {
        memo.push(value);
        results.push(array[index]);
      }
      return memo;
    }, []);
    return results;
  };
  _.union = function () {
    return _.uniq(_.flatten(arguments, true));
  };
  _.intersection = _.intersect = function (array) {
    var rest = slice.call(arguments, 1);
    return _.filter(_.uniq(array), function (item) {
      return _.every(rest, function (other) {
        return _.indexOf(other, item) >= 0;
      });
    });
  };
  _.difference = function (array) {
    var rest = _.flatten(slice.call(arguments, 1), true);
    return _.filter(array, function (value) {
      return !_.include(rest, value);
    });
  };
  _.zip = function () {
    var args = slice.call(arguments);
    var length = _.max(_.pluck(args, 'length'));
    var results = new Array(length);
    for (var i = 0; i < length; i++)
      results[i] = _.pluck(args, '' + i);
    return results;
  };
  _.indexOf = function (array, item, isSorted) {
    if (array == null)
      return -1;
    var i, l;
    if (isSorted) {
      i = _.sortedIndex(array, item);
      return array[i] === item ? i : -1;
    }
    if (nativeIndexOf && array.indexOf === nativeIndexOf)
      return array.indexOf(item);
    for (i = 0, l = array.length; i < l; i++)
      if (i in array && array[i] === item)
        return i;
    return -1;
  };
  _.lastIndexOf = function (array, item) {
    if (array == null)
      return -1;
    if (nativeLastIndexOf && array.lastIndexOf === nativeLastIndexOf)
      return array.lastIndexOf(item);
    var i = array.length;
    while (i--)
      if (i in array && array[i] === item)
        return i;
    return -1;
  };
  _.range = function (start, stop, step) {
    if (arguments.length <= 1) {
      stop = start || 0;
      start = 0;
    }
    step = arguments[2] || 1;
    var len = Math.max(Math.ceil((stop - start) / step), 0);
    var idx = 0;
    var range = new Array(len);
    while (idx < len) {
      range[idx++] = start;
      start += step;
    }
    return range;
  };
  var ctor = function () {
  };
  _.bind = function bind(func, context) {
    var bound, args;
    if (func.bind === nativeBind && nativeBind)
      return nativeBind.apply(func, slice.call(arguments, 1));
    if (!_.isFunction(func))
      throw new TypeError();
    args = slice.call(arguments, 2);
    return bound = function () {
      if (!(this instanceof bound))
        return func.apply(context, args.concat(slice.call(arguments)));
      ctor.prototype = func.prototype;
      var self = new ctor();
      var result = func.apply(self, args.concat(slice.call(arguments)));
      if (Object(result) === result)
        return result;
      return self;
    };
  };
  _.bindAll = function (obj) {
    var funcs = slice.call(arguments, 1);
    if (funcs.length == 0)
      funcs = _.functions(obj);
    each(funcs, function (f) {
      obj[f] = _.bind(obj[f], obj);
    });
    return obj;
  };
  _.memoize = function (func, hasher) {
    var memo = {};
    hasher || (hasher = _.identity);
    return function () {
      var key = hasher.apply(this, arguments);
      return _.has(memo, key) ? memo[key] : memo[key] = func.apply(this, arguments);
    };
  };
  _.delay = function (func, wait) {
    var args = slice.call(arguments, 2);
    return setTimeout(function () {
      return func.apply(null, args);
    }, wait);
  };
  _.defer = function (func) {
    return _.delay.apply(_, [
      func,
      1
    ].concat(slice.call(arguments, 1)));
  };
  _.throttle = function (func, wait) {
    var context, args, timeout, throttling, more, result;
    var whenDone = _.debounce(function () {
        more = throttling = false;
      }, wait);
    return function () {
      context = this;
      args = arguments;
      var later = function () {
        timeout = null;
        if (more)
          func.apply(context, args);
        whenDone();
      };
      if (!timeout)
        timeout = setTimeout(later, wait);
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
  _.debounce = function (func, wait, immediate) {
    var timeout;
    return function () {
      var context = this, args = arguments;
      var later = function () {
        timeout = null;
        if (!immediate)
          func.apply(context, args);
      };
      if (immediate && !timeout)
        func.apply(context, args);
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
    };
  };
  _.once = function (func) {
    var ran = false, memo;
    return function () {
      if (ran)
        return memo;
      ran = true;
      return memo = func.apply(this, arguments);
    };
  };
  _.wrap = function (func, wrapper) {
    return function () {
      var args = [func].concat(slice.call(arguments, 0));
      return wrapper.apply(this, args);
    };
  };
  _.compose = function () {
    var funcs = arguments;
    return function () {
      var args = arguments;
      for (var i = funcs.length - 1; i >= 0; i--) {
        args = [funcs[i].apply(this, args)];
      }
      return args[0];
    };
  };
  _.after = function (times, func) {
    if (times <= 0)
      return func();
    return function () {
      if (--times < 1) {
        return func.apply(this, arguments);
      }
    };
  };
  _.keys = nativeKeys || function (obj) {
    if (obj !== Object(obj))
      throw new TypeError('Invalid object');
    var keys = [];
    for (var key in obj)
      if (_.has(obj, key))
        keys[keys.length] = key;
    return keys;
  };
  _.values = function (obj) {
    return _.map(obj, _.identity);
  };
  _.functions = _.methods = function (obj) {
    var names = [];
    for (var key in obj) {
      if (_.isFunction(obj[key]))
        names.push(key);
    }
    return names.sort();
  };
  _.extend = function (obj) {
    each(slice.call(arguments, 1), function (source) {
      for (var prop in source) {
        obj[prop] = source[prop];
      }
    });
    return obj;
  };
  _.pick = function (obj) {
    var result = {};
    each(_.flatten(slice.call(arguments, 1)), function (key) {
      if (key in obj)
        result[key] = obj[key];
    });
    return result;
  };
  _.defaults = function (obj) {
    each(slice.call(arguments, 1), function (source) {
      for (var prop in source) {
        if (obj[prop] == null)
          obj[prop] = source[prop];
      }
    });
    return obj;
  };
  _.clone = function (obj) {
    if (!_.isObject(obj))
      return obj;
    return _.isArray(obj) ? obj.slice() : _.extend({}, obj);
  };
  _.tap = function (obj, interceptor) {
    interceptor(obj);
    return obj;
  };
  function eq(a, b, stack) {
    if (a === b)
      return a !== 0 || 1 / a == 1 / b;
    if (a == null || b == null)
      return a === b;
    if (a._chain)
      a = a._wrapped;
    if (b._chain)
      b = b._wrapped;
    if (a.isEqual && _.isFunction(a.isEqual))
      return a.isEqual(b);
    if (b.isEqual && _.isFunction(b.isEqual))
      return b.isEqual(a);
    var className = toString.call(a);
    if (className != toString.call(b))
      return false;
    switch (className) {
    case '[object String]':
      return a == String(b);
    case '[object Number]':
      return a != +a ? b != +b : a == 0 ? 1 / a == 1 / b : a == +b;
    case '[object Date]':
    case '[object Boolean]':
      return +a == +b;
    case '[object RegExp]':
      return a.source == b.source && a.global == b.global && a.multiline == b.multiline && a.ignoreCase == b.ignoreCase;
    }
    if (typeof a != 'object' || typeof b != 'object')
      return false;
    var length = stack.length;
    while (length--) {
      if (stack[length] == a)
        return true;
    }
    stack.push(a);
    var size = 0, result = true;
    if (className == '[object Array]') {
      size = a.length;
      result = size == b.length;
      if (result) {
        while (size--) {
          if (!(result = size in a == size in b && eq(a[size], b[size], stack)))
            break;
        }
      }
    } else {
      if ('constructor' in a != 'constructor' in b || a.constructor != b.constructor)
        return false;
      for (var key in a) {
        if (_.has(a, key)) {
          size++;
          if (!(result = _.has(b, key) && eq(a[key], b[key], stack)))
            break;
        }
      }
      if (result) {
        for (key in b) {
          if (_.has(b, key) && !size--)
            break;
        }
        result = !size;
      }
    }
    stack.pop();
    return result;
  }
  _.isEqual = function (a, b) {
    return eq(a, b, []);
  };
  _.isEmpty = function (obj) {
    if (obj == null)
      return true;
    if (_.isArray(obj) || _.isString(obj))
      return obj.length === 0;
    for (var key in obj)
      if (_.has(obj, key))
        return false;
    return true;
  };
  _.isElement = function (obj) {
    return !!(obj && obj.nodeType == 1);
  };
  _.isArray = nativeIsArray || function (obj) {
    return toString.call(obj) == '[object Array]';
  };
  _.isObject = function (obj) {
    return obj === Object(obj);
  };
  _.isArguments = function (obj) {
    return toString.call(obj) == '[object Arguments]';
  };
  if (!_.isArguments(arguments)) {
    _.isArguments = function (obj) {
      return !!(obj && _.has(obj, 'callee'));
    };
  }
  _.isFunction = function (obj) {
    return toString.call(obj) == '[object Function]';
  };
  _.isString = function (obj) {
    return toString.call(obj) == '[object String]';
  };
  _.isNumber = function (obj) {
    return toString.call(obj) == '[object Number]';
  };
  _.isFinite = function (obj) {
    return _.isNumber(obj) && isFinite(obj);
  };
  _.isNaN = function (obj) {
    return obj !== obj;
  };
  _.isBoolean = function (obj) {
    return obj === true || obj === false || toString.call(obj) == '[object Boolean]';
  };
  _.isDate = function (obj) {
    return toString.call(obj) == '[object Date]';
  };
  _.isRegExp = function (obj) {
    return toString.call(obj) == '[object RegExp]';
  };
  _.isNull = function (obj) {
    return obj === null;
  };
  _.isUndefined = function (obj) {
    return obj === void 0;
  };
  _.has = function (obj, key) {
    return hasOwnProperty.call(obj, key);
  };
  _.noConflict = function () {
    root._ = previousUnderscore;
    return this;
  };
  _.identity = function (value) {
    return value;
  };
  _.times = function (n, iterator, context) {
    for (var i = 0; i < n; i++)
      iterator.call(context, i);
  };
  _.escape = function (string) {
    return ('' + string).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#x27;').replace(/\//g, '&#x2F;');
  };
  _.result = function (object, property) {
    if (object == null)
      return null;
    var value = object[property];
    return _.isFunction(value) ? value.call(object) : value;
  };
  _.mixin = function (obj) {
    each(_.functions(obj), function (name) {
      addToWrapper(name, _[name] = obj[name]);
    });
  };
  var idCounter = 0;
  _.uniqueId = function (prefix) {
    var id = idCounter++;
    return prefix ? prefix + id : id;
  };
  _.templateSettings = {
    evaluate: /<%([\s\S]+?)%>/g,
    interpolate: /<%=([\s\S]+?)%>/g,
    escape: /<%-([\s\S]+?)%>/g
  };
  var noMatch = /.^/;
  var escapes = {
      '\\': '\\',
      '\'': '\'',
      'r': '\r',
      'n': '\n',
      't': '\t',
      'u2028': '\u2028',
      'u2029': '\u2029'
    };
  for (var p in escapes)
    escapes[escapes[p]] = p;
  var escaper = /\\|'|\r|\n|\t|\u2028|\u2029/g;
  var unescaper = /\\(\\|'|r|n|t|u2028|u2029)/g;
  var unescape = function (code) {
    return code.replace(unescaper, function (match, escape) {
      return escapes[escape];
    });
  };
  _.template = function (text, data, settings) {
    settings = _.defaults(settings || {}, _.templateSettings);
    var source = '__p+=\'' + text.replace(escaper, function (match) {
        return '\\' + escapes[match];
      }).replace(settings.escape || noMatch, function (match, code) {
        return '\'+\n_.escape(' + unescape(code) + ')+\n\'';
      }).replace(settings.interpolate || noMatch, function (match, code) {
        return '\'+\n(' + unescape(code) + ')+\n\'';
      }).replace(settings.evaluate || noMatch, function (match, code) {
        return '\';\n' + unescape(code) + '\n;__p+=\'';
      }) + '\';\n';
    if (!settings.variable)
      source = 'with(obj||{}){\n' + source + '}\n';
    source = 'var __p=\'\';' + 'var print=function(){__p+=Array.prototype.join.call(arguments, \'\')};\n' + source + 'return __p;\n';
    var render = new Function(settings.variable || 'obj', '_', source);
    if (data)
      return render(data, _);
    var template = function (data) {
      return render.call(this, data, _);
    };
    template.source = 'function(' + (settings.variable || 'obj') + '){\n' + source + '}';
    return template;
  };
  _.chain = function (obj) {
    return _(obj).chain();
  };
  var wrapper = function (obj) {
    this._wrapped = obj;
  };
  _.prototype = wrapper.prototype;
  var result = function (obj, chain) {
    return chain ? _(obj).chain() : obj;
  };
  var addToWrapper = function (name, func) {
    wrapper.prototype[name] = function () {
      var args = slice.call(arguments);
      unshift.call(args, this._wrapped);
      return result(func.apply(_, args), this._chain);
    };
  };
  _.mixin(_);
  each([
    'pop',
    'push',
    'reverse',
    'shift',
    'sort',
    'splice',
    'unshift'
  ], function (name) {
    var method = ArrayProto[name];
    wrapper.prototype[name] = function () {
      var wrapped = this._wrapped;
      method.apply(wrapped, arguments);
      var length = wrapped.length;
      if ((name == 'shift' || name == 'splice') && length === 0)
        delete wrapped[0];
      return result(wrapped, this._chain);
    };
  });
  each([
    'concat',
    'join',
    'slice'
  ], function (name) {
    var method = ArrayProto[name];
    wrapper.prototype[name] = function () {
      return result(method.apply(this._wrapped, arguments), this._chain);
    };
  });
  wrapper.prototype.chain = function () {
    this._chain = true;
    return this;
  };
  wrapper.prototype.value = function () {
    return this._wrapped;
  };
}.call(this));
(function (window, document, undefined) {
  'use strict';
  var lowercase = function (string) {
    return isString(string) ? string.toLowerCase() : string;
  };
  var uppercase = function (string) {
    return isString(string) ? string.toUpperCase() : string;
  };
  var manualLowercase = function (s) {
    return isString(s) ? s.replace(/[A-Z]/g, function (ch) {
      return String.fromCharCode(ch.charCodeAt(0) | 32);
    }) : s;
  };
  var manualUppercase = function (s) {
    return isString(s) ? s.replace(/[a-z]/g, function (ch) {
      return String.fromCharCode(ch.charCodeAt(0) & ~32);
    }) : s;
  };
  if ('i' !== 'I'.toLowerCase()) {
    lowercase = manualLowercase;
    uppercase = manualUppercase;
  }
  var msie = int((/msie (\d+)/.exec(lowercase(navigator.userAgent)) || [])[1]), jqLite, jQuery, slice = [].slice, push = [].push, toString = Object.prototype.toString, angular = window.angular || (window.angular = {}), angularModule, nodeName_, uid = [
      '0',
      '0',
      '0'
    ];
  function isArrayLike(obj) {
    if (!obj || typeof obj.length !== 'number')
      return false;
    if (typeof obj.hasOwnProperty != 'function' && typeof obj.constructor != 'function') {
      return true;
    } else {
      return obj instanceof JQLite || jQuery && obj instanceof jQuery || toString.call(obj) !== '[object Object]' || typeof obj.callee === 'function';
    }
  }
  function forEach(obj, iterator, context) {
    var key;
    if (obj) {
      if (isFunction(obj)) {
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
    for (var i = 0; i < keys.length; i++) {
      iterator.call(context, obj[keys[i]], keys[i]);
    }
    return keys;
  }
  function reverseParams(iteratorFn) {
    return function (value, key) {
      iteratorFn(key, value);
    };
  }
  function nextUid() {
    var index = uid.length;
    var digit;
    while (index) {
      index--;
      digit = uid[index].charCodeAt(0);
      if (digit == 57) {
        uid[index] = 'A';
        return uid.join('');
      }
      if (digit == 90) {
        uid[index] = '0';
      } else {
        uid[index] = String.fromCharCode(digit + 1);
        return uid.join('');
      }
    }
    uid.unshift('0');
    return uid.join('');
  }
  function setHashKey(obj, h) {
    if (h) {
      obj.$$hashKey = h;
    } else {
      delete obj.$$hashKey;
    }
  }
  function extend(dst) {
    var h = dst.$$hashKey;
    forEach(arguments, function (obj) {
      if (obj !== dst) {
        forEach(obj, function (value, key) {
          dst[key] = value;
        });
      }
    });
    setHashKey(dst, h);
    return dst;
  }
  function int(str) {
    return parseInt(str, 10);
  }
  function inherit(parent, extra) {
    return extend(new (extend(function () {
    }, { prototype: parent }))(), extra);
  }
  function noop() {
  }
  noop.$inject = [];
  function identity($) {
    return $;
  }
  identity.$inject = [];
  function valueFn(value) {
    return function () {
      return value;
    };
  }
  function isUndefined(value) {
    return typeof value == 'undefined';
  }
  function isDefined(value) {
    return typeof value != 'undefined';
  }
  function isObject(value) {
    return value != null && typeof value == 'object';
  }
  function isString(value) {
    return typeof value == 'string';
  }
  function isNumber(value) {
    return typeof value == 'number';
  }
  function isDate(value) {
    return toString.apply(value) == '[object Date]';
  }
  function isArray(value) {
    return toString.apply(value) == '[object Array]';
  }
  function isFunction(value) {
    return typeof value == 'function';
  }
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
  function isElement(node) {
    return node && (node.nodeName || node.bind && node.find);
  }
  function makeMap(str) {
    var obj = {}, items = str.split(','), i;
    for (i = 0; i < items.length; i++)
      obj[items[i]] = true;
    return obj;
  }
  if (msie < 9) {
    nodeName_ = function (element) {
      element = element.nodeName ? element : element[0];
      return element.scopeName && element.scopeName != 'HTML' ? uppercase(element.scopeName + ':' + element.nodeName) : element.nodeName;
    };
  } else {
    nodeName_ = function (element) {
      return element.nodeName ? element.nodeName : element[0].nodeName;
    };
  }
  function map(obj, iterator, context) {
    var results = [];
    forEach(obj, function (value, index, list) {
      results.push(iterator.call(context, value, index, list));
    });
    return results;
  }
  function size(obj, ownPropsOnly) {
    var size = 0, key;
    if (isArray(obj) || isString(obj)) {
      return obj.length;
    } else if (isObject(obj)) {
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
    if (array.indexOf)
      return array.indexOf(obj);
    for (var i = 0; i < array.length; i++) {
      if (obj === array[i])
        return i;
    }
    return -1;
  }
  function arrayRemove(array, value) {
    var index = indexOf(array, value);
    if (index >= 0)
      array.splice(index, 1);
    return value;
  }
  function isLeafNode(node) {
    if (node) {
      switch (node.nodeName) {
      case 'OPTION':
      case 'PRE':
      case 'TITLE':
        return true;
      }
    }
    return false;
  }
  function copy(source, destination) {
    if (isWindow(source) || isScope(source))
      throw Error('Can\'t copy Window or Scope');
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
      if (source === destination)
        throw Error('Can\'t copy equivalent objects or arrays');
      if (isArray(source)) {
        destination.length = 0;
        for (var i = 0; i < source.length; i++) {
          destination.push(copy(source[i]));
        }
      } else {
        var h = destination.$$hashKey;
        forEach(destination, function (value, key) {
          delete destination[key];
        });
        for (var key in source) {
          destination[key] = copy(source[key]);
        }
        setHashKey(destination, h);
      }
    }
    return destination;
  }
  function shallowCopy(src, dst) {
    dst = dst || {};
    for (var key in src) {
      if (src.hasOwnProperty(key) && key.substr(0, 2) !== '$$') {
        dst[key] = src[key];
      }
    }
    return dst;
  }
  function equals(o1, o2) {
    if (o1 === o2)
      return true;
    if (o1 === null || o2 === null)
      return false;
    if (o1 !== o1 && o2 !== o2)
      return true;
    var t1 = typeof o1, t2 = typeof o2, length, key, keySet;
    if (t1 == t2) {
      if (t1 == 'object') {
        if (isArray(o1)) {
          if ((length = o1.length) == o2.length) {
            for (key = 0; key < length; key++) {
              if (!equals(o1[key], o2[key]))
                return false;
            }
            return true;
          }
        } else if (isDate(o1)) {
          return isDate(o2) && o1.getTime() == o2.getTime();
        } else {
          if (isScope(o1) || isScope(o2) || isWindow(o1) || isWindow(o2))
            return false;
          keySet = {};
          for (key in o1) {
            if (key.charAt(0) === '$' || isFunction(o1[key]))
              continue;
            if (!equals(o1[key], o2[key]))
              return false;
            keySet[key] = true;
          }
          for (key in o2) {
            if (!keySet[key] && key.charAt(0) !== '$' && o2[key] !== undefined && !isFunction(o2[key]))
              return false;
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
  function bind(self, fn) {
    var curryArgs = arguments.length > 2 ? sliceArgs(arguments, 2) : [];
    if (isFunction(fn) && !(fn instanceof RegExp)) {
      return curryArgs.length ? function () {
        return arguments.length ? fn.apply(self, curryArgs.concat(slice.call(arguments, 0))) : fn.apply(self, curryArgs);
      } : function () {
        return arguments.length ? fn.apply(self, arguments) : fn.call(self);
      };
    } else {
      return fn;
    }
  }
  function toJsonReplacer(key, value) {
    var val = value;
    if (/^\$+/.test(key)) {
      val = undefined;
    } else if (isWindow(value)) {
      val = '$WINDOW';
    } else if (value && document === value) {
      val = '$DOCUMENT';
    } else if (isScope(value)) {
      val = '$SCOPE';
    }
    return val;
  }
  function toJson(obj, pretty) {
    return JSON.stringify(obj, toJsonReplacer, pretty ? '  ' : null);
  }
  function fromJson(json) {
    return isString(json) ? JSON.parse(json) : json;
  }
  function toBoolean(value) {
    if (value && value.length !== 0) {
      var v = lowercase('' + value);
      value = !(v == 'f' || v == '0' || v == 'false' || v == 'no' || v == 'n' || v == '[]');
    } else {
      value = false;
    }
    return value;
  }
  function startingTag(element) {
    element = jqLite(element).clone();
    try {
      element.html('');
    } catch (e) {
    }
    var TEXT_NODE = 3;
    var elemHtml = jqLite('<div>').append(element).html();
    try {
      return element[0].nodeType === TEXT_NODE ? lowercase(elemHtml) : elemHtml.match(/^(<[^>]+>)/)[1].replace(/^<([\w\-]+)/, function (match, nodeName) {
        return '<' + lowercase(nodeName);
      });
    } catch (e) {
      return lowercase(elemHtml);
    }
  }
  function parseKeyValue(keyValue) {
    var obj = {}, key_value, key;
    forEach((keyValue || '').split('&'), function (keyValue) {
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
    forEach(obj, function (value, key) {
      parts.push(encodeUriQuery(key, true) + (value === true ? '' : '=' + encodeUriQuery(value, true)));
    });
    return parts.length ? parts.join('&') : '';
  }
  function encodeUriSegment(val) {
    return encodeUriQuery(val, true).replace(/%26/gi, '&').replace(/%3D/gi, '=').replace(/%2B/gi, '+');
  }
  function encodeUriQuery(val, pctEncodeSpaces) {
    return encodeURIComponent(val).replace(/%40/gi, '@').replace(/%3A/gi, ':').replace(/%24/g, '$').replace(/%2C/gi, ',').replace(/%20/g, pctEncodeSpaces ? '%20' : '+');
  }
  function angularInit(element, bootstrap) {
    var elements = [element], appElement, module, names = [
        'ng:app',
        'ng-app',
        'x-ng-app',
        'data-ng-app'
      ], NG_APP_CLASS_REGEXP = /\sng[:\-]app(:\s*([\w\d_]+);?)?\s/;
    function append(element) {
      element && elements.push(element);
    }
    forEach(names, function (name) {
      names[name] = true;
      append(document.getElementById(name));
      name = name.replace(':', '\\:');
      if (element.querySelectorAll) {
        forEach(element.querySelectorAll('.' + name), append);
        forEach(element.querySelectorAll('.' + name + '\\:'), append);
        forEach(element.querySelectorAll('[' + name + ']'), append);
      }
    });
    forEach(elements, function (element) {
      if (!appElement) {
        var className = ' ' + element.className + ' ';
        var match = NG_APP_CLASS_REGEXP.exec(className);
        if (match) {
          appElement = element;
          module = (match[2] || '').replace(/\s+/g, ',');
        } else {
          forEach(element.attributes, function (attr) {
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
  function bootstrap(element, modules) {
    var resumeBootstrapInternal = function () {
      element = jqLite(element);
      modules = modules || [];
      modules.unshift([
        '$provide',
        function ($provide) {
          $provide.value('$rootElement', element);
        }
      ]);
      modules.unshift('ng');
      var injector = createInjector(modules);
      injector.invoke([
        '$rootScope',
        '$rootElement',
        '$compile',
        '$injector',
        function (scope, element, compile, injector) {
          scope.$apply(function () {
            element.data('$injector', injector);
            compile(element)(scope);
          });
        }
      ]);
      return injector;
    };
    var NG_DEFER_BOOTSTRAP = /^NG_DEFER_BOOTSTRAP!/;
    if (window && !NG_DEFER_BOOTSTRAP.test(window.name)) {
      return resumeBootstrapInternal();
    }
    window.name = window.name.replace(NG_DEFER_BOOTSTRAP, '');
    angular.resumeBootstrap = function (extraModules) {
      forEach(extraModules, function (module) {
        modules.push(module);
      });
      resumeBootstrapInternal();
    };
  }
  var SNAKE_CASE_REGEXP = /[A-Z]/g;
  function snake_case(name, separator) {
    separator = separator || '_';
    return name.replace(SNAKE_CASE_REGEXP, function (letter, pos) {
      return (pos ? separator : '') + letter.toLowerCase();
    });
  }
  function bindJQuery() {
    jQuery = window.jQuery;
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
  function assertArg(arg, name, reason) {
    if (!arg) {
      throw new Error('Argument \'' + (name || '?') + '\' is ' + (reason || 'required'));
    }
    return arg;
  }
  function assertArgFn(arg, name, acceptArrayAnnotation) {
    if (acceptArrayAnnotation && isArray(arg)) {
      arg = arg[arg.length - 1];
    }
    assertArg(isFunction(arg), name, 'not a function, got ' + (arg && typeof arg == 'object' ? arg.constructor.name || 'Object' : typeof arg));
    return arg;
  }
  function setupModuleLoader(window) {
    function ensure(obj, name, factory) {
      return obj[name] || (obj[name] = factory());
    }
    return ensure(ensure(window, 'angular', Object), 'module', function () {
      var modules = {};
      return function module(name, requires, configFn) {
        if (requires && modules.hasOwnProperty(name)) {
          modules[name] = null;
        }
        return ensure(modules, name, function () {
          if (!requires) {
            throw Error('No module: ' + name);
          }
          var invokeQueue = [];
          var runBlocks = [];
          var config = invokeLater('$injector', 'invoke');
          var moduleInstance = {
              _invokeQueue: invokeQueue,
              _runBlocks: runBlocks,
              requires: requires,
              name: name,
              provider: invokeLater('$provide', 'provider'),
              factory: invokeLater('$provide', 'factory'),
              service: invokeLater('$provide', 'service'),
              value: invokeLater('$provide', 'value'),
              constant: invokeLater('$provide', 'constant', 'unshift'),
              filter: invokeLater('$filterProvider', 'register'),
              controller: invokeLater('$controllerProvider', 'register'),
              directive: invokeLater('$compileProvider', 'directive'),
              config: config,
              run: function (block) {
                runBlocks.push(block);
                return this;
              }
            };
          if (configFn) {
            config(configFn);
          }
          return moduleInstance;
          function invokeLater(provider, method, insertMethod) {
            return function () {
              invokeQueue[insertMethod || 'push']([
                provider,
                method,
                arguments
              ]);
              return moduleInstance;
            };
          }
        });
      };
    });
  }
  var version = {
      full: '1.0.7',
      major: 1,
      minor: 0,
      dot: 7,
      codeName: 'monochromatic-rainbow'
    };
  function publishExternalAPI(angular) {
    extend(angular, {
      'bootstrap': bootstrap,
      'copy': copy,
      'extend': extend,
      'equals': equals,
      'element': jqLite,
      'forEach': forEach,
      'injector': createInjector,
      'noop': noop,
      'bind': bind,
      'toJson': toJson,
      'fromJson': fromJson,
      'identity': identity,
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
      'callbacks': { counter: 0 }
    });
    angularModule = setupModuleLoader(window);
    try {
      angularModule('ngLocale');
    } catch (e) {
      angularModule('ngLocale', []).provider('$locale', $LocaleProvider);
    }
    angularModule('ng', ['ngLocale'], [
      '$provide',
      function ngModule($provide) {
        $provide.provider('$compile', $CompileProvider).directive({
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
        }).directive(ngAttributeAliasDirectives).directive(ngEventDirectives);
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
  var jqCache = JQLite.cache = {}, jqName = JQLite.expando = 'ng-' + new Date().getTime(), jqId = 1, addEventListenerFn = window.document.addEventListener ? function (element, type, fn) {
      element.addEventListener(type, fn, false);
    } : function (element, type, fn) {
      element.attachEvent('on' + type, fn);
    }, removeEventListenerFn = window.document.removeEventListener ? function (element, type, fn) {
      element.removeEventListener(type, fn, false);
    } : function (element, type, fn) {
      element.detachEvent('on' + type, fn);
    };
  function jqNextId() {
    return ++jqId;
  }
  var SPECIAL_CHARS_REGEXP = /([\:\-\_]+(.))/g;
  var MOZ_HACK_REGEXP = /^moz([A-Z])/;
  function camelCase(name) {
    return name.replace(SPECIAL_CHARS_REGEXP, function (_, separator, letter, offset) {
      return offset ? letter.toUpperCase() : letter;
    }).replace(MOZ_HACK_REGEXP, 'Moz$1');
  }
  function JQLitePatchJQueryRemove(name, dispatchThis) {
    var originalJqFn = jQuery.fn[name];
    originalJqFn = originalJqFn.$original || originalJqFn;
    removePatch.$original = originalJqFn;
    jQuery.fn[name] = removePatch;
    function removePatch() {
      var list = [this], fireEvent = dispatchThis, set, setIndex, setLength, element, childIndex, childLength, children, fns, events;
      while (list.length) {
        set = list.shift();
        for (setIndex = 0, setLength = set.length; setIndex < setLength; setIndex++) {
          element = jqLite(set[setIndex]);
          if (fireEvent) {
            element.triggerHandler('$destroy');
          } else {
            fireEvent = !fireEvent;
          }
          for (childIndex = 0, childLength = (children = element.children()).length; childIndex < childLength; childIndex++) {
            list.push(jQuery(children[childIndex]));
          }
        }
      }
      return originalJqFn.apply(this, arguments);
    }
  }
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
      div.innerHTML = '<div>&#160;</div>' + element;
      div.removeChild(div.firstChild);
      JQLiteAddNodes(this, div.childNodes);
      this.remove();
    } else {
      JQLiteAddNodes(this, element);
    }
  }
  function JQLiteClone(element) {
    return element.cloneNode(true);
  }
  function JQLiteDealoc(element) {
    JQLiteRemoveData(element);
    for (var i = 0, children = element.childNodes || []; i < children.length; i++) {
      JQLiteDealoc(children[i]);
    }
  }
  function JQLiteUnbind(element, type, fn) {
    var events = JQLiteExpandoStore(element, 'events'), handle = JQLiteExpandoStore(element, 'handle');
    if (!handle)
      return;
    if (isUndefined(type)) {
      forEach(events, function (eventHandler, type) {
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
    var expandoId = element[jqName], expandoStore = jqCache[expandoId];
    if (expandoStore) {
      if (expandoStore.handle) {
        expandoStore.events.$destroy && expandoStore.handle({}, '$destroy');
        JQLiteUnbind(element);
      }
      delete jqCache[expandoId];
      element[jqName] = undefined;
    }
  }
  function JQLiteExpandoStore(element, key, value) {
    var expandoId = element[jqName], expandoStore = jqCache[expandoId || -1];
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
    var data = JQLiteExpandoStore(element, 'data'), isSetter = isDefined(value), keyDefined = !isSetter && isDefined(key), isSimpleGetter = keyDefined && !isObject(key);
    if (!data && !isSimpleGetter) {
      JQLiteExpandoStore(element, 'data', data = {});
    }
    if (isSetter) {
      data[key] = value;
    } else {
      if (keyDefined) {
        if (isSimpleGetter) {
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
    return (' ' + element.className + ' ').replace(/[\n\t]/g, ' ').indexOf(' ' + selector + ' ') > -1;
  }
  function JQLiteRemoveClass(element, cssClasses) {
    if (cssClasses) {
      forEach(cssClasses.split(' '), function (cssClass) {
        element.className = trim((' ' + element.className + ' ').replace(/[\n\t]/g, ' ').replace(' ' + trim(cssClass) + ' ', ' '));
      });
    }
  }
  function JQLiteAddClass(element, cssClasses) {
    if (cssClasses) {
      forEach(cssClasses.split(' '), function (cssClass) {
        if (!JQLiteHasClass(element, cssClass)) {
          element.className = trim(element.className + ' ' + trim(cssClass));
        }
      });
    }
  }
  function JQLiteAddNodes(root, elements) {
    if (elements) {
      elements = !elements.nodeName && isDefined(elements.length) && !isWindow(elements) ? elements : [elements];
      for (var i = 0; i < elements.length; i++) {
        root.push(elements[i]);
      }
    }
  }
  function JQLiteController(element, name) {
    return JQLiteInheritedData(element, '$' + (name || 'ngController') + 'Controller');
  }
  function JQLiteInheritedData(element, name, value) {
    element = jqLite(element);
    if (element[0].nodeType == 9) {
      element = element.find('html');
    }
    while (element.length) {
      if (value = element.data(name))
        return value;
      element = element.parent();
    }
  }
  var JQLitePrototype = JQLite.prototype = {
      ready: function (fn) {
        var fired = false;
        function trigger() {
          if (fired)
            return;
          fired = true;
          fn();
        }
        this.bind('DOMContentLoaded', trigger);
        JQLite(window).bind('load', trigger);
      },
      toString: function () {
        var value = [];
        forEach(this, function (e) {
          value.push('' + e);
        });
        return '[' + value.join(', ') + ']';
      },
      eq: function (index) {
        return index >= 0 ? jqLite(this[index]) : jqLite(this[this.length + index]);
      },
      length: 0,
      push: push,
      sort: [].sort,
      splice: [].splice
    };
  var BOOLEAN_ATTR = {};
  forEach('multiple,selected,checked,disabled,readOnly,required'.split(','), function (value) {
    BOOLEAN_ATTR[lowercase(value)] = value;
  });
  var BOOLEAN_ELEMENTS = {};
  forEach('input,select,option,textarea,button,form'.split(','), function (value) {
    BOOLEAN_ELEMENTS[uppercase(value)] = true;
  });
  function getBooleanAttrName(element, name) {
    var booleanAttr = BOOLEAN_ATTR[name.toLowerCase()];
    return booleanAttr && BOOLEAN_ELEMENTS[element.nodeName] && booleanAttr;
  }
  forEach({
    data: JQLiteData,
    inheritedData: JQLiteInheritedData,
    scope: function (element) {
      return JQLiteInheritedData(element, '$scope');
    },
    controller: JQLiteController,
    injector: function (element) {
      return JQLiteInheritedData(element, '$injector');
    },
    removeAttr: function (element, name) {
      element.removeAttribute(name);
    },
    hasClass: JQLiteHasClass,
    css: function (element, name, value) {
      name = camelCase(name);
      if (isDefined(value)) {
        element.style[name] = value;
      } else {
        var val;
        if (msie <= 8) {
          val = element.currentStyle && element.currentStyle[name];
          if (val === '')
            val = 'auto';
        }
        val = val || element.style[name];
        if (msie <= 8) {
          val = val === '' ? undefined : val;
        }
        return val;
      }
    },
    attr: function (element, name, value) {
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
          return element[name] || (element.attributes.getNamedItem(name) || noop).specified ? lowercasedName : undefined;
        }
      } else if (isDefined(value)) {
        element.setAttribute(name, value);
      } else if (element.getAttribute) {
        var ret = element.getAttribute(name, 2);
        return ret === null ? undefined : ret;
      }
    },
    prop: function (element, name, value) {
      if (isDefined(value)) {
        element[name] = value;
      } else {
        return element[name];
      }
    },
    text: extend(msie < 9 ? function (element, value) {
      if (element.nodeType == 1) {
        if (isUndefined(value))
          return element.innerText;
        element.innerText = value;
      } else {
        if (isUndefined(value))
          return element.nodeValue;
        element.nodeValue = value;
      }
    } : function (element, value) {
      if (isUndefined(value)) {
        return element.textContent;
      }
      element.textContent = value;
    }, { $dv: '' }),
    val: function (element, value) {
      if (isUndefined(value)) {
        return element.value;
      }
      element.value = value;
    },
    html: function (element, value) {
      if (isUndefined(value)) {
        return element.innerHTML;
      }
      for (var i = 0, childNodes = element.childNodes; i < childNodes.length; i++) {
        JQLiteDealoc(childNodes[i]);
      }
      element.innerHTML = value;
    }
  }, function (fn, name) {
    JQLite.prototype[name] = function (arg1, arg2) {
      var i, key;
      if ((fn.length == 2 && (fn !== JQLiteHasClass && fn !== JQLiteController) ? arg1 : arg2) === undefined) {
        if (isObject(arg1)) {
          for (i = 0; i < this.length; i++) {
            if (fn === JQLiteData) {
              fn(this[i], arg1);
            } else {
              for (key in arg1) {
                fn(this[i], key, arg1[key]);
              }
            }
          }
          return this;
        } else {
          if (this.length)
            return fn(this[0], arg1, arg2);
        }
      } else {
        for (i = 0; i < this.length; i++) {
          fn(this[i], arg1, arg2);
        }
        return this;
      }
      return fn.$dv;
    };
  });
  function createEventHandler(element, events) {
    var eventHandler = function (event, type) {
      if (!event.preventDefault) {
        event.preventDefault = function () {
          event.returnValue = false;
        };
      }
      if (!event.stopPropagation) {
        event.stopPropagation = function () {
          event.cancelBubble = true;
        };
      }
      if (!event.target) {
        event.target = event.srcElement || document;
      }
      if (isUndefined(event.defaultPrevented)) {
        var prevent = event.preventDefault;
        event.preventDefault = function () {
          event.defaultPrevented = true;
          prevent.call(event);
        };
        event.defaultPrevented = false;
      }
      event.isDefaultPrevented = function () {
        return event.defaultPrevented;
      };
      forEach(events[type || event.type], function (fn) {
        fn.call(element, event);
      });
      if (msie <= 8) {
        event.preventDefault = null;
        event.stopPropagation = null;
        event.isDefaultPrevented = null;
      } else {
        delete event.preventDefault;
        delete event.stopPropagation;
        delete event.isDefaultPrevented;
      }
    };
    eventHandler.elem = element;
    return eventHandler;
  }
  forEach({
    removeData: JQLiteRemoveData,
    dealoc: JQLiteDealoc,
    bind: function bindFn(element, type, fn) {
      var events = JQLiteExpandoStore(element, 'events'), handle = JQLiteExpandoStore(element, 'handle');
      if (!events)
        JQLiteExpandoStore(element, 'events', events = {});
      if (!handle)
        JQLiteExpandoStore(element, 'handle', handle = createEventHandler(element, events));
      forEach(type.split(' '), function (type) {
        var eventFns = events[type];
        if (!eventFns) {
          if (type == 'mouseenter' || type == 'mouseleave') {
            var contains = document.body.contains || document.body.compareDocumentPosition ? function (a, b) {
                var adown = a.nodeType === 9 ? a.documentElement : a, bup = b && b.parentNode;
                return a === bup || !!(bup && bup.nodeType === 1 && (adown.contains ? adown.contains(bup) : a.compareDocumentPosition && a.compareDocumentPosition(bup) & 16));
              } : function (a, b) {
                if (b) {
                  while (b = b.parentNode) {
                    if (b === a) {
                      return true;
                    }
                  }
                }
                return false;
              };
            events[type] = [];
            var eventmap = {
                mouseleave: 'mouseout',
                mouseenter: 'mouseover'
              };
            bindFn(element, eventmap[type], function (event) {
              var ret, target = this, related = event.relatedTarget;
              if (!related || related !== target && !contains(target, related)) {
                handle(event, type);
              }
            });
          } else {
            addEventListenerFn(element, type, handle);
            events[type] = [];
          }
          eventFns = events[type];
        }
        eventFns.push(fn);
      });
    },
    unbind: JQLiteUnbind,
    replaceWith: function (element, replaceNode) {
      var index, parent = element.parentNode;
      JQLiteDealoc(element);
      forEach(new JQLite(replaceNode), function (node) {
        if (index) {
          parent.insertBefore(node, index.nextSibling);
        } else {
          parent.replaceChild(node, element);
        }
        index = node;
      });
    },
    children: function (element) {
      var children = [];
      forEach(element.childNodes, function (element) {
        if (element.nodeType === 1)
          children.push(element);
      });
      return children;
    },
    contents: function (element) {
      return element.childNodes || [];
    },
    append: function (element, node) {
      forEach(new JQLite(node), function (child) {
        if (element.nodeType === 1)
          element.appendChild(child);
      });
    },
    prepend: function (element, node) {
      if (element.nodeType === 1) {
        var index = element.firstChild;
        forEach(new JQLite(node), function (child) {
          if (index) {
            element.insertBefore(child, index);
          } else {
            element.appendChild(child);
            index = child;
          }
        });
      }
    },
    wrap: function (element, wrapNode) {
      wrapNode = jqLite(wrapNode)[0];
      var parent = element.parentNode;
      if (parent) {
        parent.replaceChild(wrapNode, element);
      }
      wrapNode.appendChild(element);
    },
    remove: function (element) {
      JQLiteDealoc(element);
      var parent = element.parentNode;
      if (parent)
        parent.removeChild(element);
    },
    after: function (element, newElement) {
      var index = element, parent = element.parentNode;
      forEach(new JQLite(newElement), function (node) {
        parent.insertBefore(node, index.nextSibling);
        index = node;
      });
    },
    addClass: JQLiteAddClass,
    removeClass: JQLiteRemoveClass,
    toggleClass: function (element, selector, condition) {
      if (isUndefined(condition)) {
        condition = !JQLiteHasClass(element, selector);
      }
      (condition ? JQLiteAddClass : JQLiteRemoveClass)(element, selector);
    },
    parent: function (element) {
      var parent = element.parentNode;
      return parent && parent.nodeType !== 11 ? parent : null;
    },
    next: function (element) {
      if (element.nextElementSibling) {
        return element.nextElementSibling;
      }
      var elm = element.nextSibling;
      while (elm != null && elm.nodeType !== 1) {
        elm = elm.nextSibling;
      }
      return elm;
    },
    find: function (element, selector) {
      return element.getElementsByTagName(selector);
    },
    clone: JQLiteClone,
    triggerHandler: function (element, eventName) {
      var eventFns = (JQLiteExpandoStore(element, 'events') || {})[eventName];
      forEach(eventFns, function (fn) {
        fn.call(element, null);
      });
    }
  }, function (fn, name) {
    JQLite.prototype[name] = function (arg1, arg2) {
      var value;
      for (var i = 0; i < this.length; i++) {
        if (value == undefined) {
          value = fn(this[i], arg1, arg2);
          if (value !== undefined) {
            value = jqLite(value);
          }
        } else {
          JQLiteAddNodes(value, fn(this[i], arg1, arg2));
        }
      }
      return value == undefined ? this : value;
    };
  });
  function hashKey(obj) {
    var objType = typeof obj, key;
    if (objType == 'object' && obj !== null) {
      if (typeof (key = obj.$$hashKey) == 'function') {
        key = obj.$$hashKey();
      } else if (key === undefined) {
        key = obj.$$hashKey = nextUid();
      }
    } else {
      key = obj;
    }
    return objType + ':' + key;
  }
  function HashMap(array) {
    forEach(array, this.put, this);
  }
  HashMap.prototype = {
    put: function (key, value) {
      this[hashKey(key)] = value;
    },
    get: function (key) {
      return this[hashKey(key)];
    },
    remove: function (key) {
      var value = this[key = hashKey(key)];
      delete this[key];
      return value;
    }
  };
  function HashQueueMap() {
  }
  HashQueueMap.prototype = {
    push: function (key, value) {
      var array = this[key = hashKey(key)];
      if (!array) {
        this[key] = [value];
      } else {
        array.push(value);
      }
    },
    shift: function (key) {
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
    peek: function (key) {
      var array = this[hashKey(key)];
      if (array) {
        return array[0];
      }
    }
  };
  var FN_ARGS = /^function\s*[^\(]*\(\s*([^\)]*)\)/m;
  var FN_ARG_SPLIT = /,/;
  var FN_ARG = /^\s*(_?)(\S+?)\1\s*$/;
  var STRIP_COMMENTS = /((\/\/.*$)|(\/\*[\s\S]*?\*\/))/gm;
  function annotate(fn) {
    var $inject, fnText, argDecl, last;
    if (typeof fn == 'function') {
      if (!($inject = fn.$inject)) {
        $inject = [];
        fnText = fn.toString().replace(STRIP_COMMENTS, '');
        argDecl = fnText.match(FN_ARGS);
        forEach(argDecl[1].split(FN_ARG_SPLIT), function (arg) {
          arg.replace(FN_ARG, function (all, underscore, name) {
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
  function createInjector(modulesToLoad) {
    var INSTANTIATING = {}, providerSuffix = 'Provider', path = [], loadedModules = new HashMap(), providerCache = {
        $provide: {
          provider: supportObject(provider),
          factory: supportObject(factory),
          service: supportObject(service),
          value: supportObject(value),
          constant: supportObject(constant),
          decorator: decorator
        }
      }, providerInjector = createInternalInjector(providerCache, function () {
        throw Error('Unknown provider: ' + path.join(' <- '));
      }), instanceCache = {}, instanceInjector = instanceCache.$injector = createInternalInjector(instanceCache, function (servicename) {
        var provider = providerInjector.get(servicename + providerSuffix);
        return instanceInjector.invoke(provider.$get, provider);
      });
    forEach(loadModules(modulesToLoad), function (fn) {
      instanceInjector.invoke(fn || noop);
    });
    return instanceInjector;
    function supportObject(delegate) {
      return function (key, value) {
        if (isObject(key)) {
          forEach(key, reverseParams(delegate));
        } else {
          return delegate(key, value);
        }
      };
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
    function factory(name, factoryFn) {
      return provider(name, { $get: factoryFn });
    }
    function service(name, constructor) {
      return factory(name, [
        '$injector',
        function ($injector) {
          return $injector.instantiate(constructor);
        }
      ]);
    }
    function value(name, value) {
      return factory(name, valueFn(value));
    }
    function constant(name, value) {
      providerCache[name] = value;
      instanceCache[name] = value;
    }
    function decorator(serviceName, decorFn) {
      var origProvider = providerInjector.get(serviceName + providerSuffix), orig$get = origProvider.$get;
      origProvider.$get = function () {
        var origInstance = instanceInjector.invoke(orig$get, origProvider);
        return instanceInjector.invoke(decorFn, null, { $delegate: origInstance });
      };
    }
    function loadModules(modulesToLoad) {
      var runBlocks = [];
      forEach(modulesToLoad, function (module) {
        if (loadedModules.get(module))
          return;
        loadedModules.put(module, true);
        if (isString(module)) {
          var moduleFn = angularModule(module);
          runBlocks = runBlocks.concat(loadModules(moduleFn.requires)).concat(moduleFn._runBlocks);
          try {
            for (var invokeQueue = moduleFn._invokeQueue, i = 0, ii = invokeQueue.length; i < ii; i++) {
              var invokeArgs = invokeQueue[i], provider = invokeArgs[0] == '$injector' ? providerInjector : providerInjector.get(invokeArgs[0]);
              provider[invokeArgs[1]].apply(provider, invokeArgs[2]);
            }
          } catch (e) {
            if (e.message)
              e.message += ' from ' + module;
            throw e;
          }
        } else if (isFunction(module)) {
          try {
            runBlocks.push(providerInjector.invoke(module));
          } catch (e) {
            if (e.message)
              e.message += ' from ' + module;
            throw e;
          }
        } else if (isArray(module)) {
          try {
            runBlocks.push(providerInjector.invoke(module));
          } catch (e) {
            if (e.message)
              e.message += ' from ' + String(module[module.length - 1]);
            throw e;
          }
        } else {
          assertArgFn(module, 'module');
        }
      });
      return runBlocks;
    }
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
      function invoke(fn, self, locals) {
        var args = [], $inject = annotate(fn), length, i, key;
        for (i = 0, length = $inject.length; i < length; i++) {
          key = $inject[i];
          args.push(locals && locals.hasOwnProperty(key) ? locals[key] : getService(key));
        }
        if (!fn.$inject) {
          fn = fn[length];
        }
        switch (self ? -1 : args.length) {
        case 0:
          return fn();
        case 1:
          return fn(args[0]);
        case 2:
          return fn(args[0], args[1]);
        case 3:
          return fn(args[0], args[1], args[2]);
        case 4:
          return fn(args[0], args[1], args[2], args[3]);
        case 5:
          return fn(args[0], args[1], args[2], args[3], args[4]);
        case 6:
          return fn(args[0], args[1], args[2], args[3], args[4], args[5]);
        case 7:
          return fn(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
        case 8:
          return fn(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
        case 9:
          return fn(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
        case 10:
          return fn(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
        default:
          return fn.apply(self, args);
        }
      }
      function instantiate(Type, locals) {
        var Constructor = function () {
          }, instance, returnedValue;
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
  function $AnchorScrollProvider() {
    var autoScrollingEnabled = true;
    this.disableAutoScrolling = function () {
      autoScrollingEnabled = false;
    };
    this.$get = [
      '$window',
      '$location',
      '$rootScope',
      function ($window, $location, $rootScope) {
        var document = $window.document;
        function getFirstAnchor(list) {
          var result = null;
          forEach(list, function (element) {
            if (!result && lowercase(element.nodeName) === 'a')
              result = element;
          });
          return result;
        }
        function scroll() {
          var hash = $location.hash(), elm;
          if (!hash)
            $window.scrollTo(0, 0);
          else if (elm = document.getElementById(hash))
            elm.scrollIntoView();
          else if (elm = getFirstAnchor(document.getElementsByName(hash)))
            elm.scrollIntoView();
          else if (hash === 'top')
            $window.scrollTo(0, 0);
        }
        if (autoScrollingEnabled) {
          $rootScope.$watch(function autoScrollWatch() {
            return $location.hash();
          }, function autoScrollWatchAction() {
            $rootScope.$evalAsync(scroll);
          });
        }
        return scroll;
      }
    ];
  }
  function Browser(window, document, $log, $sniffer) {
    var self = this, rawDocument = document[0], location = window.location, history = window.history, setTimeout = window.setTimeout, clearTimeout = window.clearTimeout, pendingDeferIds = {};
    self.isMock = false;
    var outstandingRequestCount = 0;
    var outstandingRequestCallbacks = [];
    self.$$completeOutstandingRequest = completeOutstandingRequest;
    self.$$incOutstandingRequestCount = function () {
      outstandingRequestCount++;
    };
    function completeOutstandingRequest(fn) {
      try {
        fn.apply(null, sliceArgs(arguments, 1));
      } finally {
        outstandingRequestCount--;
        if (outstandingRequestCount === 0) {
          while (outstandingRequestCallbacks.length) {
            try {
              outstandingRequestCallbacks.pop()();
            } catch (e) {
              $log.error(e);
            }
          }
        }
      }
    }
    self.notifyWhenNoOutstandingRequests = function (callback) {
      forEach(pollFns, function (pollFn) {
        pollFn();
      });
      if (outstandingRequestCount === 0) {
        callback();
      } else {
        outstandingRequestCallbacks.push(callback);
      }
    };
    var pollFns = [], pollTimeout;
    self.addPollFn = function (fn) {
      if (isUndefined(pollTimeout))
        startPoller(100, setTimeout);
      pollFns.push(fn);
      return fn;
    };
    function startPoller(interval, setTimeout) {
      (function check() {
        forEach(pollFns, function (pollFn) {
          pollFn();
        });
        pollTimeout = setTimeout(check, interval);
      }());
    }
    var lastBrowserUrl = location.href, baseElement = document.find('base');
    self.url = function (url, replace) {
      if (url) {
        if (lastBrowserUrl == url)
          return;
        lastBrowserUrl = url;
        if ($sniffer.history) {
          if (replace)
            history.replaceState(null, '', url);
          else {
            history.pushState(null, '', url);
            baseElement.attr('href', baseElement.attr('href'));
          }
        } else {
          if (replace)
            location.replace(url);
          else
            location.href = url;
        }
        return self;
      } else {
        return location.href.replace(/%27/g, '\'');
      }
    };
    var urlChangeListeners = [], urlChangeInit = false;
    function fireUrlChange() {
      if (lastBrowserUrl == self.url())
        return;
      lastBrowserUrl = self.url();
      forEach(urlChangeListeners, function (listener) {
        listener(self.url());
      });
    }
    self.onUrlChange = function (callback) {
      if (!urlChangeInit) {
        if ($sniffer.history)
          jqLite(window).bind('popstate', fireUrlChange);
        if ($sniffer.hashchange)
          jqLite(window).bind('hashchange', fireUrlChange);
        else
          self.addPollFn(fireUrlChange);
        urlChangeInit = true;
      }
      urlChangeListeners.push(callback);
      return callback;
    };
    self.baseHref = function () {
      var href = baseElement.attr('href');
      return href ? href.replace(/^https?\:\/\/[^\/]*/, '') : '';
    };
    var lastCookies = {};
    var lastCookieString = '';
    var cookiePath = self.baseHref();
    self.cookies = function (name, value) {
      var cookieLength, cookieArray, cookie, i, index;
      if (name) {
        if (value === undefined) {
          rawDocument.cookie = escape(name) + '=;path=' + cookiePath + ';expires=Thu, 01 Jan 1970 00:00:00 GMT';
        } else {
          if (isString(value)) {
            cookieLength = (rawDocument.cookie = escape(name) + '=' + escape(value) + ';path=' + cookiePath).length + 1;
            if (cookieLength > 4096) {
              $log.warn('Cookie \'' + name + '\' possibly not set or overflowed because it was too large (' + cookieLength + ' > 4096 bytes)!');
            }
          }
        }
      } else {
        if (rawDocument.cookie !== lastCookieString) {
          lastCookieString = rawDocument.cookie;
          cookieArray = lastCookieString.split('; ');
          lastCookies = {};
          for (i = 0; i < cookieArray.length; i++) {
            cookie = cookieArray[i];
            index = cookie.indexOf('=');
            if (index > 0) {
              var name = unescape(cookie.substring(0, index));
              if (lastCookies[name] === undefined) {
                lastCookies[name] = unescape(cookie.substring(index + 1));
              }
            }
          }
        }
        return lastCookies;
      }
    };
    self.defer = function (fn, delay) {
      var timeoutId;
      outstandingRequestCount++;
      timeoutId = setTimeout(function () {
        delete pendingDeferIds[timeoutId];
        completeOutstandingRequest(fn);
      }, delay || 0);
      pendingDeferIds[timeoutId] = true;
      return timeoutId;
    };
    self.defer.cancel = function (deferId) {
      if (pendingDeferIds[deferId]) {
        delete pendingDeferIds[deferId];
        clearTimeout(deferId);
        completeOutstandingRequest(noop);
        return true;
      }
      return false;
    };
  }
  function $BrowserProvider() {
    this.$get = [
      '$window',
      '$log',
      '$sniffer',
      '$document',
      function ($window, $log, $sniffer, $document) {
        return new Browser($window, $document, $log, $sniffer);
      }
    ];
  }
  function $CacheFactoryProvider() {
    this.$get = function () {
      var caches = {};
      function cacheFactory(cacheId, options) {
        if (cacheId in caches) {
          throw Error('cacheId ' + cacheId + ' taken');
        }
        var size = 0, stats = extend({}, options, { id: cacheId }), data = {}, capacity = options && options.capacity || Number.MAX_VALUE, lruHash = {}, freshEnd = null, staleEnd = null;
        return caches[cacheId] = {
          put: function (key, value) {
            var lruEntry = lruHash[key] || (lruHash[key] = { key: key });
            refresh(lruEntry);
            if (isUndefined(value))
              return;
            if (!(key in data))
              size++;
            data[key] = value;
            if (size > capacity) {
              this.remove(staleEnd.key);
            }
          },
          get: function (key) {
            var lruEntry = lruHash[key];
            if (!lruEntry)
              return;
            refresh(lruEntry);
            return data[key];
          },
          remove: function (key) {
            var lruEntry = lruHash[key];
            if (!lruEntry)
              return;
            if (lruEntry == freshEnd)
              freshEnd = lruEntry.p;
            if (lruEntry == staleEnd)
              staleEnd = lruEntry.n;
            link(lruEntry.n, lruEntry.p);
            delete lruHash[key];
            delete data[key];
            size--;
          },
          removeAll: function () {
            data = {};
            size = 0;
            lruHash = {};
            freshEnd = staleEnd = null;
          },
          destroy: function () {
            data = null;
            stats = null;
            lruHash = null;
            delete caches[cacheId];
          },
          info: function () {
            return extend({}, stats, { size: size });
          }
        };
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
        function link(nextEntry, prevEntry) {
          if (nextEntry != prevEntry) {
            if (nextEntry)
              nextEntry.p = prevEntry;
            if (prevEntry)
              prevEntry.n = nextEntry;
          }
        }
      }
      cacheFactory.info = function () {
        var info = {};
        forEach(caches, function (cache, cacheId) {
          info[cacheId] = cache.info();
        });
        return info;
      };
      cacheFactory.get = function (cacheId) {
        return caches[cacheId];
      };
      return cacheFactory;
    };
  }
  function $TemplateCacheProvider() {
    this.$get = [
      '$cacheFactory',
      function ($cacheFactory) {
        return $cacheFactory('templates');
      }
    ];
  }
  var NON_ASSIGNABLE_MODEL_EXPRESSION = 'Non-assignable model expression: ';
  $CompileProvider.$inject = ['$provide'];
  function $CompileProvider($provide) {
    var hasDirectives = {}, Suffix = 'Directive', COMMENT_DIRECTIVE_REGEXP = /^\s*directive\:\s*([\d\w\-_]+)\s+(.*)$/, CLASS_DIRECTIVE_REGEXP = /(([\d\w\-_]+)(?:\:([^;]+))?;?)/, MULTI_ROOT_TEMPLATE_ERROR = 'Template must have exactly one root element. was: ', urlSanitizationWhitelist = /^\s*(https?|ftp|mailto|file):/;
    this.directive = function registerDirective(name, directiveFactory) {
      if (isString(name)) {
        assertArg(directiveFactory, 'directive');
        if (!hasDirectives.hasOwnProperty(name)) {
          hasDirectives[name] = [];
          $provide.factory(name + Suffix, [
            '$injector',
            '$exceptionHandler',
            function ($injector, $exceptionHandler) {
              var directives = [];
              forEach(hasDirectives[name], function (directiveFactory) {
                try {
                  var directive = $injector.invoke(directiveFactory);
                  if (isFunction(directive)) {
                    directive = { compile: valueFn(directive) };
                  } else if (!directive.compile && directive.link) {
                    directive.compile = valueFn(directive.link);
                  }
                  directive.priority = directive.priority || 0;
                  directive.name = directive.name || name;
                  directive.require = directive.require || directive.controller && directive.name;
                  directive.restrict = directive.restrict || 'A';
                  directives.push(directive);
                } catch (e) {
                  $exceptionHandler(e);
                }
              });
              return directives;
            }
          ]);
        }
        hasDirectives[name].push(directiveFactory);
      } else {
        forEach(name, reverseParams(registerDirective));
      }
      return this;
    };
    this.urlSanitizationWhitelist = function (regexp) {
      if (isDefined(regexp)) {
        urlSanitizationWhitelist = regexp;
        return this;
      }
      return urlSanitizationWhitelist;
    };
    this.$get = [
      '$injector',
      '$interpolate',
      '$exceptionHandler',
      '$http',
      '$templateCache',
      '$parse',
      '$controller',
      '$rootScope',
      '$document',
      function ($injector, $interpolate, $exceptionHandler, $http, $templateCache, $parse, $controller, $rootScope, $document) {
        var Attributes = function (element, attr) {
          this.$$element = element;
          this.$attr = attr || {};
        };
        Attributes.prototype = {
          $normalize: directiveNormalize,
          $set: function (key, value, writeAttr, attrName) {
            var booleanKey = getBooleanAttrName(this.$$element[0], key), $$observers = this.$$observers, normalizedVal;
            if (booleanKey) {
              this.$$element.prop(key, value);
              attrName = booleanKey;
            }
            this[key] = value;
            if (attrName) {
              this.$attr[key] = attrName;
            } else {
              attrName = this.$attr[key];
              if (!attrName) {
                this.$attr[key] = attrName = snake_case(key, '-');
              }
            }
            if (nodeName_(this.$$element[0]) === 'A' && key === 'href') {
              urlSanitizationNode.setAttribute('href', value);
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
            $$observers && forEach($$observers[key], function (fn) {
              try {
                fn(value);
              } catch (e) {
                $exceptionHandler(e);
              }
            });
          },
          $observe: function (key, fn) {
            var attrs = this, $$observers = attrs.$$observers || (attrs.$$observers = {}), listeners = $$observers[key] || ($$observers[key] = []);
            listeners.push(fn);
            $rootScope.$evalAsync(function () {
              if (!listeners.$$inter) {
                fn(attrs[key]);
              }
            });
            return fn;
          }
        };
        var urlSanitizationNode = $document[0].createElement('a'), startSymbol = $interpolate.startSymbol(), endSymbol = $interpolate.endSymbol(), denormalizeTemplate = startSymbol == '{{' || endSymbol == '}}' ? identity : function denormalizeTemplate(template) {
            return template.replace(/\{\{/g, startSymbol).replace(/}}/g, endSymbol);
          };
        return compile;
        function compile($compileNodes, transcludeFn, maxPriority) {
          if (!($compileNodes instanceof jqLite)) {
            $compileNodes = jqLite($compileNodes);
          }
          forEach($compileNodes, function (node, index) {
            if (node.nodeType == 3 && node.nodeValue.match(/\S+/)) {
              $compileNodes[index] = jqLite(node).wrap('<span></span>').parent()[0];
            }
          });
          var compositeLinkFn = compileNodes($compileNodes, transcludeFn, $compileNodes, maxPriority);
          return function publicLinkFn(scope, cloneConnectFn) {
            assertArg(scope, 'scope');
            var $linkNode = cloneConnectFn ? JQLitePrototype.clone.call($compileNodes) : $compileNodes;
            for (var i = 0, ii = $linkNode.length; i < ii; i++) {
              var node = $linkNode[i];
              if (node.nodeType == 1 || node.nodeType == 9) {
                $linkNode.eq(i).data('$scope', scope);
              }
            }
            safeAddClass($linkNode, 'ng-scope');
            if (cloneConnectFn)
              cloneConnectFn($linkNode, scope);
            if (compositeLinkFn)
              compositeLinkFn(scope, $linkNode, $linkNode);
            return $linkNode;
          };
        }
        function wrongMode(localName, mode) {
          throw Error('Unsupported \'' + mode + '\' for \'' + localName + '\'.');
        }
        function safeAddClass($element, className) {
          try {
            $element.addClass(className);
          } catch (e) {
          }
        }
        function compileNodes(nodeList, transcludeFn, $rootElement, maxPriority) {
          var linkFns = [], nodeLinkFn, childLinkFn, directives, attrs, linkFnFound;
          for (var i = 0; i < nodeList.length; i++) {
            attrs = new Attributes();
            directives = collectDirectives(nodeList[i], [], attrs, maxPriority);
            nodeLinkFn = directives.length ? applyDirectivesToNode(directives, nodeList[i], attrs, transcludeFn, $rootElement) : null;
            childLinkFn = nodeLinkFn && nodeLinkFn.terminal || !nodeList[i].childNodes || !nodeList[i].childNodes.length ? null : compileNodes(nodeList[i].childNodes, nodeLinkFn ? nodeLinkFn.transclude : transcludeFn);
            linkFns.push(nodeLinkFn);
            linkFns.push(childLinkFn);
            linkFnFound = linkFnFound || nodeLinkFn || childLinkFn;
          }
          return linkFnFound ? compositeLinkFn : null;
          function compositeLinkFn(scope, nodeList, $rootElement, boundTranscludeFn) {
            var nodeLinkFn, childLinkFn, node, childScope, childTranscludeFn, i, ii, n;
            var stableNodeList = [];
            for (i = 0, ii = nodeList.length; i < ii; i++) {
              stableNodeList.push(nodeList[i]);
            }
            for (i = 0, n = 0, ii = linkFns.length; i < ii; n++) {
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
                if (childTranscludeFn || !boundTranscludeFn && transcludeFn) {
                  nodeLinkFn(childLinkFn, childScope, node, $rootElement, function (transcludeFn) {
                    return function (cloneFn) {
                      var transcludeScope = scope.$new();
                      transcludeScope.$$transcluded = true;
                      return transcludeFn(transcludeScope, cloneFn).bind('$destroy', bind(transcludeScope, transcludeScope.$destroy));
                    };
                  }(childTranscludeFn || transcludeFn));
                } else {
                  nodeLinkFn(childLinkFn, childScope, node, undefined, boundTranscludeFn);
                }
              } else if (childLinkFn) {
                childLinkFn(scope, node.childNodes, undefined, boundTranscludeFn);
              }
            }
          }
        }
        function collectDirectives(node, directives, attrs, maxPriority) {
          var nodeType = node.nodeType, attrsMap = attrs.$attr, match, className;
          switch (nodeType) {
          case 1:
            addDirective(directives, directiveNormalize(nodeName_(node).toLowerCase()), 'E', maxPriority);
            for (var attr, name, nName, value, nAttrs = node.attributes, j = 0, jj = nAttrs && nAttrs.length; j < jj; j++) {
              attr = nAttrs[j];
              if (attr.specified) {
                name = attr.name;
                nName = directiveNormalize(name.toLowerCase());
                attrsMap[nName] = name;
                attrs[nName] = value = trim(msie && name == 'href' ? decodeURIComponent(node.getAttribute(name, 2)) : attr.value);
                if (getBooleanAttrName(node, nName)) {
                  attrs[nName] = true;
                }
                addAttrInterpolateDirective(node, directives, value, nName);
                addDirective(directives, nName, 'A', maxPriority);
              }
            }
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
          case 3:
            addTextInterpolateDirective(directives, node.nodeValue);
            break;
          case 8:
            try {
              match = COMMENT_DIRECTIVE_REGEXP.exec(node.nodeValue);
              if (match) {
                nName = directiveNormalize(match[1]);
                if (addDirective(directives, nName, 'M', maxPriority)) {
                  attrs[nName] = trim(match[2]);
                }
              }
            } catch (e) {
            }
            break;
          }
          directives.sort(byPriority);
          return directives;
        }
        function applyDirectivesToNode(directives, compileNode, templateAttrs, transcludeFn, jqCollection) {
          var terminalPriority = -Number.MAX_VALUE, preLinkFns = [], postLinkFns = [], newScopeDirective = null, newIsolateScopeDirective = null, templateDirective = null, $compileNode = templateAttrs.$$element = jqLite(compileNode), directive, directiveName, $template, transcludeDirective, childTranscludeFn = transcludeFn, controllerDirectives, linkFn, directiveValue;
          for (var i = 0, ii = directives.length; i < ii; i++) {
            directive = directives[i];
            $template = undefined;
            if (terminalPriority > directive.priority) {
              break;
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
              assertNoDuplicate('\'' + directiveName + '\' controller', controllerDirectives[directiveName], directive, $compileNode);
              controllerDirectives[directiveName] = directive;
            }
            if (directiveValue = directive.transclude) {
              assertNoDuplicate('transclusion', transcludeDirective, directive, $compileNode);
              transcludeDirective = directive;
              terminalPriority = directive.priority;
              if (directiveValue == 'element') {
                $template = jqLite(compileNode);
                $compileNode = templateAttrs.$$element = jqLite(document.createComment(' ' + directiveName + ': ' + templateAttrs[directiveName] + ' '));
                compileNode = $compileNode[0];
                replaceWith(jqCollection, jqLite($template[0]), compileNode);
                childTranscludeFn = compile($template, transcludeFn, terminalPriority);
              } else {
                $template = jqLite(JQLiteClone(compileNode)).contents();
                $compileNode.html('');
                childTranscludeFn = compile($template, transcludeFn);
              }
            }
            if (directiveValue = directive.template) {
              assertNoDuplicate('template', templateDirective, directive, $compileNode);
              templateDirective = directive;
              directiveValue = denormalizeTemplate(directiveValue);
              if (directive.replace) {
                $template = jqLite('<div>' + trim(directiveValue) + '</div>').contents();
                compileNode = $template[0];
                if ($template.length != 1 || compileNode.nodeType !== 1) {
                  throw new Error(MULTI_ROOT_TEMPLATE_ERROR + directiveValue);
                }
                replaceWith(jqCollection, $compileNode, compileNode);
                var newTemplateAttrs = { $attr: {} };
                directives = directives.concat(collectDirectives(compileNode, directives.splice(i + 1, directives.length - (i + 1)), newTemplateAttrs));
                mergeTemplateAttributes(templateAttrs, newTemplateAttrs);
                ii = directives.length;
              } else {
                $compileNode.html(directiveValue);
              }
            }
            if (directive.templateUrl) {
              assertNoDuplicate('template', templateDirective, directive, $compileNode);
              templateDirective = directive;
              nodeLinkFn = compileTemplateUrl(directives.splice(i, directives.length - i), nodeLinkFn, $compileNode, templateAttrs, jqCollection, directive.replace, childTranscludeFn);
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
          return nodeLinkFn;
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
              while ((value = require.charAt(0)) == '^' || value == '?') {
                require = require.substr(1);
                if (value == '^') {
                  retrievalMethod = 'inheritedData';
                }
                optional = optional || value == '?';
              }
              value = $element[retrievalMethod]('$' + require + 'Controller');
              if (!value && !optional) {
                throw Error('No controller: ' + require);
              }
              return value;
            } else if (isArray(require)) {
              value = [];
              forEach(require, function (require) {
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
              forEach(newIsolateScopeDirective.scope, function (definiton, scopeName) {
                var match = definiton.match(LOCAL_REGEXP) || [], attrName = match[2] || scopeName, mode = match[1], lastValue, parentGet, parentSet;
                scope.$$isolateBindings[scopeName] = mode + attrName;
                switch (mode) {
                case '@': {
                    attrs.$observe(attrName, function (value) {
                      scope[scopeName] = value;
                    });
                    attrs.$$observers[attrName].$$scope = parentScope;
                    break;
                  }
                case '=': {
                    parentGet = $parse(attrs[attrName]);
                    parentSet = parentGet.assign || function () {
                      lastValue = scope[scopeName] = parentGet(parentScope);
                      throw Error(NON_ASSIGNABLE_MODEL_EXPRESSION + attrs[attrName] + ' (directive: ' + newIsolateScopeDirective.name + ')');
                    };
                    lastValue = scope[scopeName] = parentGet(parentScope);
                    scope.$watch(function parentValueWatch() {
                      var parentValue = parentGet(parentScope);
                      if (parentValue !== scope[scopeName]) {
                        if (parentValue !== lastValue) {
                          lastValue = scope[scopeName] = parentValue;
                        } else {
                          parentSet(parentScope, parentValue = lastValue = scope[scopeName]);
                        }
                      }
                      return parentValue;
                    });
                    break;
                  }
                case '&': {
                    parentGet = $parse(attrs[attrName]);
                    scope[scopeName] = function (locals) {
                      return parentGet(parentScope, locals);
                    };
                    break;
                  }
                default: {
                    throw Error('Invalid isolate scope definition for directive ' + newIsolateScopeDirective.name + ': ' + definiton);
                  }
                }
              });
            }
            if (controllerDirectives) {
              forEach(controllerDirectives, function (directive) {
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
                $element.data('$' + directive.name + 'Controller', $controller(controller, locals));
              });
            }
            for (i = 0, ii = preLinkFns.length; i < ii; i++) {
              try {
                linkFn = preLinkFns[i];
                linkFn(scope, $element, attrs, linkFn.require && getControllers(linkFn.require, $element));
              } catch (e) {
                $exceptionHandler(e, startingTag($element));
              }
            }
            childLinkFn && childLinkFn(scope, linkNode.childNodes, undefined, boundTranscludeFn);
            for (i = 0, ii = postLinkFns.length; i < ii; i++) {
              try {
                linkFn = postLinkFns[i];
                linkFn(scope, $element, attrs, linkFn.require && getControllers(linkFn.require, $element));
              } catch (e) {
                $exceptionHandler(e, startingTag($element));
              }
            }
          }
        }
        function addDirective(tDirectives, name, location, maxPriority) {
          var match = false;
          if (hasDirectives.hasOwnProperty(name)) {
            for (var directive, directives = $injector.get(name + Suffix), i = 0, ii = directives.length; i < ii; i++) {
              try {
                directive = directives[i];
                if ((maxPriority === undefined || maxPriority > directive.priority) && directive.restrict.indexOf(location) != -1) {
                  tDirectives.push(directive);
                  match = true;
                }
              } catch (e) {
                $exceptionHandler(e);
              }
            }
          }
          return match;
        }
        function mergeTemplateAttributes(dst, src) {
          var srcAttr = src.$attr, dstAttr = dst.$attr, $element = dst.$$element;
          forEach(dst, function (value, key) {
            if (key.charAt(0) != '$') {
              if (src[key]) {
                value += (key === 'style' ? ';' : ' ') + src[key];
              }
              dst.$set(key, value, true, srcAttr[key]);
            }
          });
          forEach(src, function (value, key) {
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
        function compileTemplateUrl(directives, beforeTemplateNodeLinkFn, $compileNode, tAttrs, $rootElement, replace, childTranscludeFn) {
          var linkQueue = [], afterTemplateNodeLinkFn, afterTemplateChildLinkFn, beforeTemplateCompileNode = $compileNode[0], origAsyncDirective = directives.shift(), derivedSyncDirective = extend({}, origAsyncDirective, {
              controller: null,
              templateUrl: null,
              transclude: null,
              scope: null
            });
          $compileNode.html('');
          $http.get(origAsyncDirective.templateUrl, { cache: $templateCache }).success(function (content) {
            var compileNode, tempTemplateAttrs, $template;
            content = denormalizeTemplate(content);
            if (replace) {
              $template = jqLite('<div>' + trim(content) + '</div>').contents();
              compileNode = $template[0];
              if ($template.length != 1 || compileNode.nodeType !== 1) {
                throw new Error(MULTI_ROOT_TEMPLATE_ERROR + content);
              }
              tempTemplateAttrs = { $attr: {} };
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
            while (linkQueue.length) {
              var controller = linkQueue.pop(), linkRootElement = linkQueue.pop(), beforeTemplateLinkNode = linkQueue.pop(), scope = linkQueue.pop(), linkNode = compileNode;
              if (beforeTemplateLinkNode !== beforeTemplateCompileNode) {
                linkNode = JQLiteClone(compileNode);
                replaceWith(linkRootElement, jqLite(beforeTemplateLinkNode), linkNode);
              }
              afterTemplateNodeLinkFn(function () {
                beforeTemplateNodeLinkFn(afterTemplateChildLinkFn, scope, linkNode, $rootElement, controller);
              }, scope, linkNode, $rootElement, controller);
            }
            linkQueue = null;
          }).error(function (response, code, headers, config) {
            throw Error('Failed to load template: ' + config.url);
          });
          return function delayedNodeLinkFn(ignoreChildLinkFn, scope, node, rootElement, controller) {
            if (linkQueue) {
              linkQueue.push(scope);
              linkQueue.push(node);
              linkQueue.push(rootElement);
              linkQueue.push(controller);
            } else {
              afterTemplateNodeLinkFn(function () {
                beforeTemplateNodeLinkFn(afterTemplateChildLinkFn, scope, node, rootElement, controller);
              }, scope, node, rootElement, controller);
            }
          };
        }
        function byPriority(a, b) {
          return b.priority - a.priority;
        }
        function assertNoDuplicate(what, previousDirective, directive, element) {
          if (previousDirective) {
            throw Error('Multiple directives [' + previousDirective.name + ', ' + directive.name + '] asking for ' + what + ' on: ' + startingTag(element));
          }
        }
        function addTextInterpolateDirective(directives, text) {
          var interpolateFn = $interpolate(text, true);
          if (interpolateFn) {
            directives.push({
              priority: 0,
              compile: valueFn(function textInterpolateLinkFn(scope, node) {
                var parent = node.parent(), bindings = parent.data('$binding') || [];
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
          if (!interpolateFn)
            return;
          directives.push({
            priority: 100,
            compile: valueFn(function attrInterpolateLinkFn(scope, element, attr) {
              var $$observers = attr.$$observers || (attr.$$observers = {});
              if (name === 'class') {
                interpolateFn = $interpolate(attr[name], true);
              }
              attr[name] = undefined;
              ($$observers[name] || ($$observers[name] = [])).$$inter = true;
              (attr.$$observers && attr.$$observers[name].$$scope || scope).$watch(interpolateFn, function interpolateFnWatchAction(value) {
                attr.$set(name, value);
              });
            })
          });
        }
        function replaceWith($rootElement, $element, newNode) {
          var oldNode = $element[0], parent = oldNode.parentNode, i, ii;
          if ($rootElement) {
            for (i = 0, ii = $rootElement.length; i < ii; i++) {
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
      }
    ];
  }
  var PREFIX_REGEXP = /^(x[\:\-_]|data[\:\-_])/i;
  function directiveNormalize(name) {
    return camelCase(name.replace(PREFIX_REGEXP, ''));
  }
  function nodesetLinkingFn(scope, nodeList, rootElement, boundTranscludeFn) {
  }
  function directiveLinkingFn(nodesetLinkingFn, scope, node, rootElement, boundTranscludeFn) {
  }
  function $ControllerProvider() {
    var controllers = {};
    this.register = function (name, constructor) {
      if (isObject(name)) {
        extend(controllers, name);
      } else {
        controllers[name] = constructor;
      }
    };
    this.$get = [
      '$injector',
      '$window',
      function ($injector, $window) {
        return function (constructor, locals) {
          if (isString(constructor)) {
            var name = constructor;
            constructor = controllers.hasOwnProperty(name) ? controllers[name] : getter(locals.$scope, name, true) || getter($window, name, true);
            assertArgFn(constructor, name, true);
          }
          return $injector.instantiate(constructor, locals);
        };
      }
    ];
  }
  function $DocumentProvider() {
    this.$get = [
      '$window',
      function (window) {
        return jqLite(window.document);
      }
    ];
  }
  function $ExceptionHandlerProvider() {
    this.$get = [
      '$log',
      function ($log) {
        return function (exception, cause) {
          $log.error.apply($log, arguments);
        };
      }
    ];
  }
  function $InterpolateProvider() {
    var startSymbol = '{{';
    var endSymbol = '}}';
    this.startSymbol = function (value) {
      if (value) {
        startSymbol = value;
        return this;
      } else {
        return startSymbol;
      }
    };
    this.endSymbol = function (value) {
      if (value) {
        endSymbol = value;
        return this;
      } else {
        return endSymbol;
      }
    };
    this.$get = [
      '$parse',
      function ($parse) {
        var startSymbolLength = startSymbol.length, endSymbolLength = endSymbol.length;
        function $interpolate(text, mustHaveExpression) {
          var startIndex, endIndex, index = 0, parts = [], length = text.length, hasInterpolation = false, fn, exp, concat = [];
          while (index < length) {
            if ((startIndex = text.indexOf(startSymbol, index)) != -1 && (endIndex = text.indexOf(endSymbol, startIndex + startSymbolLength)) != -1) {
              index != startIndex && parts.push(text.substring(index, startIndex));
              parts.push(fn = $parse(exp = text.substring(startIndex + startSymbolLength, endIndex)));
              fn.exp = exp;
              index = endIndex + endSymbolLength;
              hasInterpolation = true;
            } else {
              index != length && parts.push(text.substring(index));
              index = length;
            }
          }
          if (!(length = parts.length)) {
            parts.push('');
            length = 1;
          }
          if (!mustHaveExpression || hasInterpolation) {
            concat.length = length;
            fn = function (context) {
              for (var i = 0, ii = length, part; i < ii; i++) {
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
        $interpolate.startSymbol = function () {
          return startSymbol;
        };
        $interpolate.endSymbol = function () {
          return endSymbol;
        };
        return $interpolate;
      }
    ];
  }
  var URL_MATCH = /^([^:]+):\/\/(\w+:{0,1}\w*@)?(\{?[\w\.-]*\}?)(:([0-9]+))?(\/[^\?#]*)?(\?([^#]*))?(#(.*))?$/, PATH_MATCH = /^([^\?#]*)?(\?([^#]*))?(#(.*))?$/, HASH_MATCH = PATH_MATCH, DEFAULT_PORTS = {
      'http': 80,
      'https': 443,
      'ftp': 21
    };
  function encodePath(path) {
    var segments = path.split('/'), i = segments.length;
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
    if (decodeURIComponent(match.path) != basePath || isUndefined(match.hash) || match.hash.indexOf(hashPrefix) !== 0) {
      return url;
    } else {
      return composeProtocolHostPort(match.protocol, match.host, match.port) + pathPrefixFromBase(basePath) + match.hash.substr(hashPrefix.length);
    }
  }
  function convertToHashbangUrl(url, basePath, hashPrefix) {
    var match = matchUrl(url);
    if (decodeURIComponent(match.path) == basePath && !isUndefined(match.hash) && match.hash.indexOf(hashPrefix) === 0) {
      return url;
    } else {
      var search = match.search && '?' + match.search || '', hash = match.hash && '#' + match.hash || '', pathPrefix = pathPrefixFromBase(basePath), path = match.path.substr(pathPrefix.length);
      if (match.path.indexOf(pathPrefix) !== 0) {
        throw Error('Invalid url "' + url + '", missing path prefix "' + pathPrefix + '" !');
      }
      return composeProtocolHostPort(match.protocol, match.host, match.port) + basePath + '#' + hashPrefix + path + search + hash;
    }
  }
  function LocationUrl(url, pathPrefix, appBaseUrl) {
    pathPrefix = pathPrefix || '';
    this.$$parse = function (newAbsoluteUrl) {
      var match = matchUrl(newAbsoluteUrl, this);
      if (match.path.indexOf(pathPrefix) !== 0) {
        throw Error('Invalid url "' + newAbsoluteUrl + '", missing path prefix "' + pathPrefix + '" !');
      }
      this.$$path = decodeURIComponent(match.path.substr(pathPrefix.length));
      this.$$search = parseKeyValue(match.search);
      this.$$hash = match.hash && decodeURIComponent(match.hash) || '';
      this.$$compose();
    };
    this.$$compose = function () {
      var search = toKeyValue(this.$$search), hash = this.$$hash ? '#' + encodeUriSegment(this.$$hash) : '';
      this.$$url = encodePath(this.$$path) + (search ? '?' + search : '') + hash;
      this.$$absUrl = composeProtocolHostPort(this.$$protocol, this.$$host, this.$$port) + pathPrefix + this.$$url;
    };
    this.$$rewriteAppUrl = function (absoluteLinkUrl) {
      if (absoluteLinkUrl.indexOf(appBaseUrl) == 0) {
        return absoluteLinkUrl;
      }
    };
    this.$$parse(url);
  }
  function LocationHashbangUrl(url, hashPrefix, appBaseUrl) {
    var basePath;
    this.$$parse = function (url) {
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
    this.$$compose = function () {
      var search = toKeyValue(this.$$search), hash = this.$$hash ? '#' + encodeUriSegment(this.$$hash) : '';
      this.$$url = encodePath(this.$$path) + (search ? '?' + search : '') + hash;
      this.$$absUrl = composeProtocolHostPort(this.$$protocol, this.$$host, this.$$port) + basePath + (this.$$url ? '#' + hashPrefix + this.$$url : '');
    };
    this.$$rewriteAppUrl = function (absoluteLinkUrl) {
      if (absoluteLinkUrl.indexOf(appBaseUrl) == 0) {
        return absoluteLinkUrl;
      }
    };
    this.$$parse(url);
  }
  LocationUrl.prototype = {
    $$replace: false,
    absUrl: locationGetter('$$absUrl'),
    url: function (url, replace) {
      if (isUndefined(url))
        return this.$$url;
      var match = PATH_MATCH.exec(url);
      if (match[1])
        this.path(decodeURIComponent(match[1]));
      if (match[2] || match[1])
        this.search(match[3] || '');
      this.hash(match[5] || '', replace);
      return this;
    },
    protocol: locationGetter('$$protocol'),
    host: locationGetter('$$host'),
    port: locationGetter('$$port'),
    path: locationGetterSetter('$$path', function (path) {
      return path.charAt(0) == '/' ? path : '/' + path;
    }),
    search: function (search, paramValue) {
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
    hash: locationGetterSetter('$$hash', identity),
    replace: function () {
      this.$$replace = true;
      return this;
    }
  };
  LocationHashbangUrl.prototype = inherit(LocationUrl.prototype);
  function LocationHashbangInHtml5Url(url, hashPrefix, appBaseUrl, baseExtra) {
    LocationHashbangUrl.apply(this, arguments);
    this.$$rewriteAppUrl = function (absoluteLinkUrl) {
      if (absoluteLinkUrl.indexOf(appBaseUrl) == 0) {
        return appBaseUrl + baseExtra + '#' + hashPrefix + absoluteLinkUrl.substr(appBaseUrl.length);
      }
    };
  }
  LocationHashbangInHtml5Url.prototype = inherit(LocationHashbangUrl.prototype);
  function locationGetter(property) {
    return function () {
      return this[property];
    };
  }
  function locationGetterSetter(property, preprocess) {
    return function (value) {
      if (isUndefined(value))
        return this[property];
      this[property] = preprocess(value);
      this.$$compose();
      return this;
    };
  }
  function $LocationProvider() {
    var hashPrefix = '', html5Mode = false;
    this.hashPrefix = function (prefix) {
      if (isDefined(prefix)) {
        hashPrefix = prefix;
        return this;
      } else {
        return hashPrefix;
      }
    };
    this.html5Mode = function (mode) {
      if (isDefined(mode)) {
        html5Mode = mode;
        return this;
      } else {
        return html5Mode;
      }
    };
    this.$get = [
      '$rootScope',
      '$browser',
      '$sniffer',
      '$rootElement',
      function ($rootScope, $browser, $sniffer, $rootElement) {
        var $location, basePath, pathPrefix, initUrl = $browser.url(), initUrlParts = matchUrl(initUrl), appBaseUrl;
        if (html5Mode) {
          basePath = $browser.baseHref() || '/';
          pathPrefix = pathPrefixFromBase(basePath);
          appBaseUrl = composeProtocolHostPort(initUrlParts.protocol, initUrlParts.host, initUrlParts.port) + pathPrefix + '/';
          if ($sniffer.history) {
            $location = new LocationUrl(convertToHtml5Url(initUrl, basePath, hashPrefix), pathPrefix, appBaseUrl);
          } else {
            $location = new LocationHashbangInHtml5Url(convertToHashbangUrl(initUrl, basePath, hashPrefix), hashPrefix, appBaseUrl, basePath.substr(pathPrefix.length + 1));
          }
        } else {
          appBaseUrl = composeProtocolHostPort(initUrlParts.protocol, initUrlParts.host, initUrlParts.port) + (initUrlParts.path || '') + (initUrlParts.search ? '?' + initUrlParts.search : '') + '#' + hashPrefix + '/';
          $location = new LocationHashbangUrl(initUrl, hashPrefix, appBaseUrl);
        }
        $rootElement.bind('click', function (event) {
          if (event.ctrlKey || event.metaKey || event.which == 2)
            return;
          var elm = jqLite(event.target);
          while (lowercase(elm[0].nodeName) !== 'a') {
            if (elm[0] === $rootElement[0] || !(elm = elm.parent())[0])
              return;
          }
          var absHref = elm.prop('href'), rewrittenUrl = $location.$$rewriteAppUrl(absHref);
          if (absHref && !elm.attr('target') && rewrittenUrl) {
            $location.$$parse(rewrittenUrl);
            $rootScope.$apply();
            event.preventDefault();
            window.angular['ff-684208-preventDefault'] = true;
          }
        });
        if ($location.absUrl() != initUrl) {
          $browser.url($location.absUrl(), true);
        }
        $browser.onUrlChange(function (newUrl) {
          if ($location.absUrl() != newUrl) {
            if ($rootScope.$broadcast('$locationChangeStart', newUrl, $location.absUrl()).defaultPrevented) {
              $browser.url($location.absUrl());
              return;
            }
            $rootScope.$evalAsync(function () {
              var oldUrl = $location.absUrl();
              $location.$$parse(newUrl);
              afterLocationChange(oldUrl);
            });
            if (!$rootScope.$$phase)
              $rootScope.$digest();
          }
        });
        var changeCounter = 0;
        $rootScope.$watch(function $locationWatch() {
          var oldUrl = $browser.url();
          var currentReplace = $location.$$replace;
          if (!changeCounter || oldUrl != $location.absUrl()) {
            changeCounter++;
            $rootScope.$evalAsync(function () {
              if ($rootScope.$broadcast('$locationChangeStart', $location.absUrl(), oldUrl).defaultPrevented) {
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
      }
    ];
  }
  function $LogProvider() {
    this.$get = [
      '$window',
      function ($window) {
        return {
          log: consoleLog('log'),
          warn: consoleLog('warn'),
          info: consoleLog('info'),
          error: consoleLog('error')
        };
        function formatError(arg) {
          if (arg instanceof Error) {
            if (arg.stack) {
              arg = arg.message && arg.stack.indexOf(arg.message) === -1 ? 'Error: ' + arg.message + '\n' + arg.stack : arg.stack;
            } else if (arg.sourceURL) {
              arg = arg.message + '\n' + arg.sourceURL + ':' + arg.line;
            }
          }
          return arg;
        }
        function consoleLog(type) {
          var console = $window.console || {}, logFn = console[type] || console.log || noop;
          if (logFn.apply) {
            return function () {
              var args = [];
              forEach(arguments, function (arg) {
                args.push(formatError(arg));
              });
              return logFn.apply(console, args);
            };
          }
          return function (arg1, arg2) {
            logFn(arg1, arg2);
          };
        }
      }
    ];
  }
  var OPERATORS = {
      'null': function () {
        return null;
      },
      'true': function () {
        return true;
      },
      'false': function () {
        return false;
      },
      undefined: noop,
      '+': function (self, locals, a, b) {
        a = a(self, locals);
        b = b(self, locals);
        if (isDefined(a)) {
          if (isDefined(b)) {
            return a + b;
          }
          return a;
        }
        return isDefined(b) ? b : undefined;
      },
      '-': function (self, locals, a, b) {
        a = a(self, locals);
        b = b(self, locals);
        return (isDefined(a) ? a : 0) - (isDefined(b) ? b : 0);
      },
      '*': function (self, locals, a, b) {
        return a(self, locals) * b(self, locals);
      },
      '/': function (self, locals, a, b) {
        return a(self, locals) / b(self, locals);
      },
      '%': function (self, locals, a, b) {
        return a(self, locals) % b(self, locals);
      },
      '^': function (self, locals, a, b) {
        return a(self, locals) ^ b(self, locals);
      },
      '=': noop,
      '==': function (self, locals, a, b) {
        return a(self, locals) == b(self, locals);
      },
      '!=': function (self, locals, a, b) {
        return a(self, locals) != b(self, locals);
      },
      '<': function (self, locals, a, b) {
        return a(self, locals) < b(self, locals);
      },
      '>': function (self, locals, a, b) {
        return a(self, locals) > b(self, locals);
      },
      '<=': function (self, locals, a, b) {
        return a(self, locals) <= b(self, locals);
      },
      '>=': function (self, locals, a, b) {
        return a(self, locals) >= b(self, locals);
      },
      '&&': function (self, locals, a, b) {
        return a(self, locals) && b(self, locals);
      },
      '||': function (self, locals, a, b) {
        return a(self, locals) || b(self, locals);
      },
      '&': function (self, locals, a, b) {
        return a(self, locals) & b(self, locals);
      },
      '|': function (self, locals, a, b) {
        return b(self, locals)(self, locals, a(self, locals));
      },
      '!': function (self, locals, a) {
        return !a(self, locals);
      }
    };
  var ESCAPE = {
      'n': '\n',
      'f': '\f',
      'r': '\r',
      't': '\t',
      'v': '\x0B',
      '\'': '\'',
      '"': '"'
    };
  function lex(text, csp) {
    var tokens = [], token, index = 0, json = [], ch, lastCh = ':';
    while (index < text.length) {
      ch = text.charAt(index);
      if (is('"\'')) {
        readString(ch);
      } else if (isNumber(ch) || is('.') && isNumber(peek())) {
        readNumber();
      } else if (isIdent(ch)) {
        readIdent();
        if (was('{,') && json[0] == '{' && (token = tokens[tokens.length - 1])) {
          token.json = token.text.indexOf('.') == -1;
        }
      } else if (is('(){}[].,;:')) {
        tokens.push({
          index: index,
          text: ch,
          json: was(':[,') && is('{[') || is('}]:,')
        });
        if (is('{['))
          json.unshift(ch);
        if (is('}]'))
          json.shift();
        index++;
      } else if (isWhitespace(ch)) {
        index++;
        continue;
      } else {
        var ch2 = ch + peek(), fn = OPERATORS[ch], fn2 = OPERATORS[ch2];
        if (fn2) {
          tokens.push({
            index: index,
            text: ch2,
            fn: fn2
          });
          index += 2;
        } else if (fn) {
          tokens.push({
            index: index,
            text: ch,
            fn: fn,
            json: was('[,:') && is('+-')
          });
          index += 1;
        } else {
          throwError('Unexpected next character ', index, index + 1);
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
      return ch == ' ' || ch == '\r' || ch == '\t' || ch == '\n' || ch == '\x0B' || ch == '\xa0';
    }
    function isIdent(ch) {
      return 'a' <= ch && ch <= 'z' || 'A' <= ch && ch <= 'Z' || '_' == ch || ch == '$';
    }
    function isExpOperator(ch) {
      return ch == '-' || ch == '+' || isNumber(ch);
    }
    function throwError(error, start, end) {
      end = end || index;
      throw Error('Lexer Error: ' + error + ' at column' + (isDefined(start) ? 's ' + start + '-' + index + ' [' + text.substring(start, end) + ']' : ' ' + end) + ' in expression [' + text + '].');
    }
    function readNumber() {
      var number = '';
      var start = index;
      while (index < text.length) {
        var ch = lowercase(text.charAt(index));
        if (ch == '.' || isNumber(ch)) {
          number += ch;
        } else {
          var peekCh = peek();
          if (ch == 'e' && isExpOperator(peekCh)) {
            number += ch;
          } else if (isExpOperator(ch) && peekCh && isNumber(peekCh) && number.charAt(number.length - 1) == 'e') {
            number += ch;
          } else if (isExpOperator(ch) && (!peekCh || !isNumber(peekCh)) && number.charAt(number.length - 1) == 'e') {
            throwError('Invalid exponent');
          } else {
            break;
          }
        }
        index++;
      }
      number = 1 * number;
      tokens.push({
        index: start,
        text: number,
        json: true,
        fn: function () {
          return number;
        }
      });
    }
    function readIdent() {
      var ident = '', start = index, lastDot, peekIndex, methodName, ch;
      while (index < text.length) {
        ch = text.charAt(index);
        if (ch == '.' || isIdent(ch) || isNumber(ch)) {
          if (ch == '.')
            lastDot = index;
          ident += ch;
        } else {
          break;
        }
        index++;
      }
      if (lastDot) {
        peekIndex = index;
        while (peekIndex < text.length) {
          ch = text.charAt(peekIndex);
          if (ch == '(') {
            methodName = ident.substr(lastDot - start + 1);
            ident = ident.substr(0, lastDot - start);
            index = peekIndex;
            break;
          }
          if (isWhitespace(ch)) {
            peekIndex++;
          } else {
            break;
          }
        }
      }
      var token = {
          index: start,
          text: ident
        };
      if (OPERATORS.hasOwnProperty(ident)) {
        token.fn = token.json = OPERATORS[ident];
      } else {
        var getter = getterFn(ident, csp);
        token.fn = extend(function (self, locals) {
          return getter(self, locals);
        }, {
          assign: function (self, value) {
            return setter(self, ident, value);
          }
        });
      }
      tokens.push(token);
      if (methodName) {
        tokens.push({
          index: lastDot,
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
      var string = '';
      var rawString = quote;
      var escape = false;
      while (index < text.length) {
        var ch = text.charAt(index);
        rawString += ch;
        if (escape) {
          if (ch == 'u') {
            var hex = text.substring(index + 1, index + 5);
            if (!hex.match(/[\da-f]{4}/i))
              throwError('Invalid unicode escape [\\u' + hex + ']');
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
            index: start,
            text: rawString,
            string: string,
            json: true,
            fn: function () {
              return string;
            }
          });
          return;
        } else {
          string += ch;
        }
        index++;
      }
      throwError('Unterminated quote', start);
    }
  }
  function parser(text, json, $filter, csp) {
    var ZERO = valueFn(0), value, tokens = lex(text, csp), assignment = _assignment, functionCall = _functionCall, fieldAccess = _fieldAccess, objectIndex = _objectIndex, filterChain = _filterChain;
    if (json) {
      assignment = logicalOR;
      functionCall = fieldAccess = objectIndex = filterChain = function () {
        throwError('is not valid json', {
          text: text,
          index: 0
        });
      };
      value = primary();
    } else {
      value = statements();
    }
    if (tokens.length !== 0) {
      throwError('is an unexpected token', tokens[0]);
    }
    return value;
    function throwError(msg, token) {
      throw Error('Syntax Error: Token \'' + token.text + '\' ' + msg + ' at column ' + (token.index + 1) + ' of the expression [' + text + '] starting at [' + text.substring(token.index) + '].');
    }
    function peekToken() {
      if (tokens.length === 0)
        throw Error('Unexpected end of expression: ' + text);
      return tokens[0];
    }
    function peek(e1, e2, e3, e4) {
      if (tokens.length > 0) {
        var token = tokens[0];
        var t = token.text;
        if (t == e1 || t == e2 || t == e3 || t == e4 || !e1 && !e2 && !e3 && !e4) {
          return token;
        }
      }
      return false;
    }
    function expect(e1, e2, e3, e4) {
      var token = peek(e1, e2, e3, e4);
      if (token) {
        if (json && !token.json) {
          throwError('is not valid json', token);
        }
        tokens.shift();
        return token;
      }
      return false;
    }
    function consume(e1) {
      if (!expect(e1)) {
        throwError('is unexpected, expecting [' + e1 + ']', peek());
      }
    }
    function unaryFn(fn, right) {
      return function (self, locals) {
        return fn(self, locals, right);
      };
    }
    function binaryFn(left, fn, right) {
      return function (self, locals) {
        return fn(self, locals, left, right);
      };
    }
    function statements() {
      var statements = [];
      while (true) {
        if (tokens.length > 0 && !peek('}', ')', ';', ']'))
          statements.push(filterChain());
        if (!expect(';')) {
          return statements.length == 1 ? statements[0] : function (self, locals) {
            var value;
            for (var i = 0; i < statements.length; i++) {
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
      while (true) {
        if (token = expect('|')) {
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
      while (true) {
        if (token = expect(':')) {
          argsFn.push(expression());
        } else {
          var fnInvoke = function (self, locals, input) {
            var args = [input];
            for (var i = 0; i < argsFn.length; i++) {
              args.push(argsFn[i](self, locals));
            }
            return fn.apply(self, args);
          };
          return function () {
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
      if (token = expect('=')) {
        if (!left.assign) {
          throwError('implies assignment but [' + text.substring(0, token.index) + '] can not be assigned to', token);
        }
        right = logicalOR();
        return function (scope, locals) {
          return left.assign(scope, right(scope, locals), locals);
        };
      } else {
        return left;
      }
    }
    function logicalOR() {
      var left = logicalAND();
      var token;
      while (true) {
        if (token = expect('||')) {
          left = binaryFn(left, token.fn, logicalAND());
        } else {
          return left;
        }
      }
    }
    function logicalAND() {
      var left = equality();
      var token;
      if (token = expect('&&')) {
        left = binaryFn(left, token.fn, logicalAND());
      }
      return left;
    }
    function equality() {
      var left = relational();
      var token;
      if (token = expect('==', '!=')) {
        left = binaryFn(left, token.fn, equality());
      }
      return left;
    }
    function relational() {
      var left = additive();
      var token;
      if (token = expect('<', '>', '<=', '>=')) {
        left = binaryFn(left, token.fn, relational());
      }
      return left;
    }
    function additive() {
      var left = multiplicative();
      var token;
      while (token = expect('+', '-')) {
        left = binaryFn(left, token.fn, multiplicative());
      }
      return left;
    }
    function multiplicative() {
      var left = unary();
      var token;
      while (token = expect('*', '/', '%')) {
        left = binaryFn(left, token.fn, unary());
      }
      return left;
    }
    function unary() {
      var token;
      if (expect('+')) {
        return primary();
      } else if (token = expect('-')) {
        return binaryFn(ZERO, token.fn, unary());
      } else if (token = expect('!')) {
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
          throwError('not a primary expression', token);
        }
      }
      var next, context;
      while (next = expect('(', '[', '.')) {
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
          throwError('IMPOSSIBLE');
        }
      }
      return primary;
    }
    function _fieldAccess(object) {
      var field = expect().text;
      var getter = getterFn(field, csp);
      return extend(function (scope, locals, self) {
        return getter(self || object(scope, locals), locals);
      }, {
        assign: function (scope, value, locals) {
          return setter(object(scope, locals), field, value);
        }
      });
    }
    function _objectIndex(obj) {
      var indexFn = expression();
      consume(']');
      return extend(function (self, locals) {
        var o = obj(self, locals), i = indexFn(self, locals), v, p;
        if (!o)
          return undefined;
        v = o[i];
        if (v && v.then) {
          p = v;
          if (!('$$v' in v)) {
            p.$$v = undefined;
            p.then(function (val) {
              p.$$v = val;
            });
          }
          v = v.$$v;
        }
        return v;
      }, {
        assign: function (self, value, locals) {
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
      return function (scope, locals) {
        var args = [], context = contextGetter ? contextGetter(scope, locals) : scope;
        for (var i = 0; i < argsFn.length; i++) {
          args.push(argsFn[i](scope, locals));
        }
        var fnPtr = fn(scope, locals, context) || noop;
        return fnPtr.apply ? fnPtr.apply(context, args) : fnPtr(args[0], args[1], args[2], args[3], args[4]);
      };
    }
    function arrayDeclaration() {
      var elementFns = [];
      if (peekToken().text != ']') {
        do {
          elementFns.push(expression());
        } while (expect(','));
      }
      consume(']');
      return function (self, locals) {
        var array = [];
        for (var i = 0; i < elementFns.length; i++) {
          array.push(elementFns[i](self, locals));
        }
        return array;
      };
    }
    function object() {
      var keyValues = [];
      if (peekToken().text != '}') {
        do {
          var token = expect(), key = token.string || token.text;
          consume(':');
          var value = expression();
          keyValues.push({
            key: key,
            value: value
          });
        } while (expect(','));
      }
      consume('}');
      return function (self, locals) {
        var object = {};
        for (var i = 0; i < keyValues.length; i++) {
          var keyValue = keyValues[i];
          object[keyValue.key] = keyValue.value(self, locals);
        }
        return object;
      };
    }
  }
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
  function getter(obj, path, bindFnToScope) {
    if (!path)
      return obj;
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
  function cspSafeGetterFn(key0, key1, key2, key3, key4) {
    return function (scope, locals) {
      var pathVal = locals && locals.hasOwnProperty(key0) ? locals : scope, promise;
      if (pathVal === null || pathVal === undefined)
        return pathVal;
      pathVal = pathVal[key0];
      if (pathVal && pathVal.then) {
        if (!('$$v' in pathVal)) {
          promise = pathVal;
          promise.$$v = undefined;
          promise.then(function (val) {
            promise.$$v = val;
          });
        }
        pathVal = pathVal.$$v;
      }
      if (!key1 || pathVal === null || pathVal === undefined)
        return pathVal;
      pathVal = pathVal[key1];
      if (pathVal && pathVal.then) {
        if (!('$$v' in pathVal)) {
          promise = pathVal;
          promise.$$v = undefined;
          promise.then(function (val) {
            promise.$$v = val;
          });
        }
        pathVal = pathVal.$$v;
      }
      if (!key2 || pathVal === null || pathVal === undefined)
        return pathVal;
      pathVal = pathVal[key2];
      if (pathVal && pathVal.then) {
        if (!('$$v' in pathVal)) {
          promise = pathVal;
          promise.$$v = undefined;
          promise.then(function (val) {
            promise.$$v = val;
          });
        }
        pathVal = pathVal.$$v;
      }
      if (!key3 || pathVal === null || pathVal === undefined)
        return pathVal;
      pathVal = pathVal[key3];
      if (pathVal && pathVal.then) {
        if (!('$$v' in pathVal)) {
          promise = pathVal;
          promise.$$v = undefined;
          promise.then(function (val) {
            promise.$$v = val;
          });
        }
        pathVal = pathVal.$$v;
      }
      if (!key4 || pathVal === null || pathVal === undefined)
        return pathVal;
      pathVal = pathVal[key4];
      if (pathVal && pathVal.then) {
        if (!('$$v' in pathVal)) {
          promise = pathVal;
          promise.$$v = undefined;
          promise.then(function (val) {
            promise.$$v = val;
          });
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
    var pathKeys = path.split('.'), pathKeysLength = pathKeys.length, fn;
    if (csp) {
      fn = pathKeysLength < 6 ? cspSafeGetterFn(pathKeys[0], pathKeys[1], pathKeys[2], pathKeys[3], pathKeys[4]) : function (scope, locals) {
        var i = 0, val;
        do {
          val = cspSafeGetterFn(pathKeys[i++], pathKeys[i++], pathKeys[i++], pathKeys[i++], pathKeys[i++])(scope, locals);
          locals = undefined;
          scope = val;
        } while (i < pathKeysLength);
        return val;
      };
    } else {
      var code = 'var l, fn, p;\n';
      forEach(pathKeys, function (key, index) {
        code += 'if(s === null || s === undefined) return s;\n' + 'l=s;\n' + 's=' + (index ? 's' : '((k&&k.hasOwnProperty("' + key + '"))?k:s)') + '["' + key + '"]' + ';\n' + 'if (s && s.then) {\n' + ' if (!("$$v" in s)) {\n' + ' p=s;\n' + ' p.$$v = undefined;\n' + ' p.then(function(v) {p.$$v=v;});\n' + '}\n' + ' s=s.$$v\n' + '}\n';
      });
      code += 'return s;';
      fn = Function('s', 'k', code);
      fn.toString = function () {
        return code;
      };
    }
    return getterFnCache[path] = fn;
  }
  function $ParseProvider() {
    var cache = {};
    this.$get = [
      '$filter',
      '$sniffer',
      function ($filter, $sniffer) {
        return function (exp) {
          switch (typeof exp) {
          case 'string':
            return cache.hasOwnProperty(exp) ? cache[exp] : cache[exp] = parser(exp, false, $filter, $sniffer.csp);
          case 'function':
            return exp;
          default:
            return noop;
          }
        };
      }
    ];
  }
  function $QProvider() {
    this.$get = [
      '$rootScope',
      '$exceptionHandler',
      function ($rootScope, $exceptionHandler) {
        return qFactory(function (callback) {
          $rootScope.$evalAsync(callback);
        }, $exceptionHandler);
      }
    ];
  }
  function qFactory(nextTick, exceptionHandler) {
    var defer = function () {
      var pending = [], value, deferred;
      deferred = {
        resolve: function (val) {
          if (pending) {
            var callbacks = pending;
            pending = undefined;
            value = ref(val);
            if (callbacks.length) {
              nextTick(function () {
                var callback;
                for (var i = 0, ii = callbacks.length; i < ii; i++) {
                  callback = callbacks[i];
                  value.then(callback[0], callback[1]);
                }
              });
            }
          }
        },
        reject: function (reason) {
          deferred.resolve(reject(reason));
        },
        promise: {
          then: function (callback, errback) {
            var result = defer();
            var wrappedCallback = function (value) {
              try {
                result.resolve((callback || defaultCallback)(value));
              } catch (e) {
                exceptionHandler(e);
                result.reject(e);
              }
            };
            var wrappedErrback = function (reason) {
              try {
                result.resolve((errback || defaultErrback)(reason));
              } catch (e) {
                exceptionHandler(e);
                result.reject(e);
              }
            };
            if (pending) {
              pending.push([
                wrappedCallback,
                wrappedErrback
              ]);
            } else {
              value.then(wrappedCallback, wrappedErrback);
            }
            return result.promise;
          }
        }
      };
      return deferred;
    };
    var ref = function (value) {
      if (value && value.then)
        return value;
      return {
        then: function (callback) {
          var result = defer();
          nextTick(function () {
            result.resolve(callback(value));
          });
          return result.promise;
        }
      };
    };
    var reject = function (reason) {
      return {
        then: function (callback, errback) {
          var result = defer();
          nextTick(function () {
            result.resolve((errback || defaultErrback)(reason));
          });
          return result.promise;
        }
      };
    };
    var when = function (value, callback, errback) {
      var result = defer(), done;
      var wrappedCallback = function (value) {
        try {
          return (callback || defaultCallback)(value);
        } catch (e) {
          exceptionHandler(e);
          return reject(e);
        }
      };
      var wrappedErrback = function (reason) {
        try {
          return (errback || defaultErrback)(reason);
        } catch (e) {
          exceptionHandler(e);
          return reject(e);
        }
      };
      nextTick(function () {
        ref(value).then(function (value) {
          if (done)
            return;
          done = true;
          result.resolve(ref(value).then(wrappedCallback, wrappedErrback));
        }, function (reason) {
          if (done)
            return;
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
    function all(promises) {
      var deferred = defer(), counter = promises.length, results = [];
      if (counter) {
        forEach(promises, function (promise, index) {
          ref(promise).then(function (value) {
            if (index in results)
              return;
            results[index] = value;
            if (!--counter)
              deferred.resolve(results);
          }, function (reason) {
            if (index in results)
              return;
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
  function $RouteProvider() {
    var routes = {};
    this.when = function (path, route) {
      routes[path] = extend({ reloadOnSearch: true }, route);
      if (path) {
        var redirectPath = path[path.length - 1] == '/' ? path.substr(0, path.length - 1) : path + '/';
        routes[redirectPath] = { redirectTo: path };
      }
      return this;
    };
    this.otherwise = function (params) {
      this.when(null, params);
      return this;
    };
    this.$get = [
      '$rootScope',
      '$location',
      '$routeParams',
      '$q',
      '$injector',
      '$http',
      '$templateCache',
      function ($rootScope, $location, $routeParams, $q, $injector, $http, $templateCache) {
        var forceReload = false, $route = {
            routes: routes,
            reload: function () {
              forceReload = true;
              $rootScope.$evalAsync(updateRoute);
            }
          };
        $rootScope.$on('$locationChangeSuccess', updateRoute);
        return $route;
        function switchRouteMatcher(on, when) {
          when = '^' + when.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&') + '$';
          var regex = '', params = [], dst = {};
          var re = /:(\w+)/g, paramMatch, lastMatchedIndex = 0;
          while ((paramMatch = re.exec(when)) !== null) {
            regex += when.slice(lastMatchedIndex, paramMatch.index);
            regex += '([^\\/]*)';
            params.push(paramMatch[1]);
            lastMatchedIndex = re.lastIndex;
          }
          regex += when.substr(lastMatchedIndex);
          var match = on.match(new RegExp(regex));
          if (match) {
            forEach(params, function (name, index) {
              dst[name] = match[index + 1];
            });
          }
          return match ? dst : null;
        }
        function updateRoute() {
          var next = parseRoute(), last = $route.current;
          if (next && last && next.$$route === last.$$route && equals(next.pathParams, last.pathParams) && !next.reloadOnSearch && !forceReload) {
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
                  $location.path(interpolate(next.redirectTo, next.params)).search(next.params).replace();
                } else {
                  $location.url(next.redirectTo(next.pathParams, $location.path(), $location.search())).replace();
                }
              }
            }
            $q.when(next).then(function () {
              if (next) {
                var keys = [], values = [], template;
                forEach(next.resolve || {}, function (value, key) {
                  keys.push(key);
                  values.push(isString(value) ? $injector.get(value) : $injector.invoke(value));
                });
                if (isDefined(template = next.template)) {
                } else if (isDefined(template = next.templateUrl)) {
                  template = $http.get(template, { cache: $templateCache }).then(function (response) {
                    return response.data;
                  });
                }
                if (isDefined(template)) {
                  keys.push('$template');
                  values.push(template);
                }
                return $q.all(values).then(function (values) {
                  var locals = {};
                  forEach(values, function (value, index) {
                    locals[keys[index]] = value;
                  });
                  return locals;
                });
              }
            }).then(function (locals) {
              if (next == $route.current) {
                if (next) {
                  next.locals = locals;
                  copy(next.params, $routeParams);
                }
                $rootScope.$broadcast('$routeChangeSuccess', next, last);
              }
            }, function (error) {
              if (next == $route.current) {
                $rootScope.$broadcast('$routeChangeError', next, last, error);
              }
            });
          }
        }
        function parseRoute() {
          var params, match;
          forEach(routes, function (route, path) {
            if (!match && (params = switchRouteMatcher($location.path(), path))) {
              match = inherit(route, {
                params: extend({}, $location.search(), params),
                pathParams: params
              });
              match.$$route = route;
            }
          });
          return match || routes[null] && inherit(routes[null], {
            params: {},
            pathParams: {}
          });
        }
        function interpolate(string, params) {
          var result = [];
          forEach((string || '').split(':'), function (segment, i) {
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
      }
    ];
  }
  function $RouteParamsProvider() {
    this.$get = valueFn({});
  }
  function $RootScopeProvider() {
    var TTL = 10;
    this.digestTtl = function (value) {
      if (arguments.length) {
        TTL = value;
      }
      return TTL;
    };
    this.$get = [
      '$injector',
      '$exceptionHandler',
      '$parse',
      function ($injector, $exceptionHandler, $parse) {
        function Scope() {
          this.$id = nextUid();
          this.$$phase = this.$parent = this.$$watchers = this.$$nextSibling = this.$$prevSibling = this.$$childHead = this.$$childTail = null;
          this['this'] = this.$root = this;
          this.$$destroyed = false;
          this.$$asyncQueue = [];
          this.$$listeners = {};
          this.$$isolateBindings = {};
        }
        Scope.prototype = {
          $new: function (isolate) {
            var Child, child;
            if (isFunction(isolate)) {
              throw Error('API-CHANGE: Use $controller to instantiate controllers.');
            }
            if (isolate) {
              child = new Scope();
              child.$root = this.$root;
            } else {
              Child = function () {
              };
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
          $watch: function (watchExp, listener, objectEquality) {
            var scope = this, get = compileToFn(watchExp, 'watch'), array = scope.$$watchers, watcher = {
                fn: listener,
                last: initWatchVal,
                get: get,
                exp: watchExp,
                eq: !!objectEquality
              };
            if (!isFunction(listener)) {
              var listenFn = compileToFn(listener || noop, 'listener');
              watcher.fn = function (newVal, oldVal, scope) {
                listenFn(scope);
              };
            }
            if (!array) {
              array = scope.$$watchers = [];
            }
            array.unshift(watcher);
            return function () {
              arrayRemove(array, watcher);
            };
          },
          $digest: function () {
            var watch, value, last, watchers, asyncQueue, length, dirty, ttl = TTL, next, current, target = this, watchLog = [], logIdx, logMsg;
            beginPhase('$digest');
            do {
              dirty = false;
              current = target;
              do {
                asyncQueue = current.$$asyncQueue;
                while (asyncQueue.length) {
                  try {
                    current.$eval(asyncQueue.shift());
                  } catch (e) {
                    $exceptionHandler(e);
                  }
                }
                if (watchers = current.$$watchers) {
                  length = watchers.length;
                  while (length--) {
                    try {
                      watch = watchers[length];
                      if ((value = watch.get(current)) !== (last = watch.last) && !(watch.eq ? equals(value, last) : typeof value == 'number' && typeof last == 'number' && isNaN(value) && isNaN(last))) {
                        dirty = true;
                        watch.last = watch.eq ? copy(value) : value;
                        watch.fn(value, last === initWatchVal ? value : last, current);
                        if (ttl < 5) {
                          logIdx = 4 - ttl;
                          if (!watchLog[logIdx])
                            watchLog[logIdx] = [];
                          logMsg = isFunction(watch.exp) ? 'fn: ' + (watch.exp.name || watch.exp.toString()) : watch.exp;
                          logMsg += '; newVal: ' + toJson(value) + '; oldVal: ' + toJson(last);
                          watchLog[logIdx].push(logMsg);
                        }
                      }
                    } catch (e) {
                      $exceptionHandler(e);
                    }
                  }
                }
                if (!(next = current.$$childHead || current !== target && current.$$nextSibling)) {
                  while (current !== target && !(next = current.$$nextSibling)) {
                    current = current.$parent;
                  }
                }
              } while (current = next);
              if (dirty && !ttl--) {
                clearPhase();
                throw Error(TTL + ' $digest() iterations reached. Aborting!\n' + 'Watchers fired in the last 5 iterations: ' + toJson(watchLog));
              }
            } while (dirty || asyncQueue.length);
            clearPhase();
          },
          $destroy: function () {
            if ($rootScope == this || this.$$destroyed)
              return;
            var parent = this.$parent;
            this.$broadcast('$destroy');
            this.$$destroyed = true;
            if (parent.$$childHead == this)
              parent.$$childHead = this.$$nextSibling;
            if (parent.$$childTail == this)
              parent.$$childTail = this.$$prevSibling;
            if (this.$$prevSibling)
              this.$$prevSibling.$$nextSibling = this.$$nextSibling;
            if (this.$$nextSibling)
              this.$$nextSibling.$$prevSibling = this.$$prevSibling;
            this.$parent = this.$$nextSibling = this.$$prevSibling = this.$$childHead = this.$$childTail = null;
          },
          $eval: function (expr, locals) {
            return $parse(expr)(this, locals);
          },
          $evalAsync: function (expr) {
            this.$$asyncQueue.push(expr);
          },
          $apply: function (expr) {
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
          $on: function (name, listener) {
            var namedListeners = this.$$listeners[name];
            if (!namedListeners) {
              this.$$listeners[name] = namedListeners = [];
            }
            namedListeners.push(listener);
            return function () {
              namedListeners[indexOf(namedListeners, listener)] = null;
            };
          },
          $emit: function (name, args) {
            var empty = [], namedListeners, scope = this, stopPropagation = false, event = {
                name: name,
                targetScope: scope,
                stopPropagation: function () {
                  stopPropagation = true;
                },
                preventDefault: function () {
                  event.defaultPrevented = true;
                },
                defaultPrevented: false
              }, listenerArgs = concat([event], arguments, 1), i, length;
            do {
              namedListeners = scope.$$listeners[name] || empty;
              event.currentScope = scope;
              for (i = 0, length = namedListeners.length; i < length; i++) {
                if (!namedListeners[i]) {
                  namedListeners.splice(i, 1);
                  i--;
                  length--;
                  continue;
                }
                try {
                  namedListeners[i].apply(null, listenerArgs);
                  if (stopPropagation)
                    return event;
                } catch (e) {
                  $exceptionHandler(e);
                }
              }
              scope = scope.$parent;
            } while (scope);
            return event;
          },
          $broadcast: function (name, args) {
            var target = this, current = target, next = target, event = {
                name: name,
                targetScope: target,
                preventDefault: function () {
                  event.defaultPrevented = true;
                },
                defaultPrevented: false
              }, listenerArgs = concat([event], arguments, 1), listeners, i, length;
            do {
              current = next;
              event.currentScope = current;
              listeners = current.$$listeners[name] || [];
              for (i = 0, length = listeners.length; i < length; i++) {
                if (!listeners[i]) {
                  listeners.splice(i, 1);
                  i--;
                  length--;
                  continue;
                }
                try {
                  listeners[i].apply(null, listenerArgs);
                } catch (e) {
                  $exceptionHandler(e);
                }
              }
              if (!(next = current.$$childHead || current !== target && current.$$nextSibling)) {
                while (current !== target && !(next = current.$$nextSibling)) {
                  current = current.$parent;
                }
              }
            } while (current = next);
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
        function initWatchVal() {
        }
      }
    ];
  }
  function $SnifferProvider() {
    this.$get = [
      '$window',
      function ($window) {
        var eventSupport = {}, android = int((/android (\d+)/.exec(lowercase($window.navigator.userAgent)) || [])[1]);
        return {
          history: !!($window.history && $window.history.pushState && !(android < 4)),
          hashchange: 'onhashchange' in $window && (!$window.document.documentMode || $window.document.documentMode > 7),
          hasEvent: function (event) {
            if (event == 'input' && msie == 9)
              return false;
            if (isUndefined(eventSupport[event])) {
              var divElm = $window.document.createElement('div');
              eventSupport[event] = 'on' + event in divElm;
            }
            return eventSupport[event];
          },
          csp: false
        };
      }
    ];
  }
  function $WindowProvider() {
    this.$get = valueFn(window);
  }
  function parseHeaders(headers) {
    var parsed = {}, key, val, i;
    if (!headers)
      return parsed;
    forEach(headers.split('\n'), function (line) {
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
  function headersGetter(headers) {
    var headersObj = isObject(headers) ? headers : undefined;
    return function (name) {
      if (!headersObj)
        headersObj = parseHeaders(headers);
      if (name) {
        return headersObj[lowercase(name)] || null;
      }
      return headersObj;
    };
  }
  function transformData(data, headers, fns) {
    if (isFunction(fns))
      return fns(data, headers);
    forEach(fns, function (fn) {
      data = fn(data, headers);
    });
    return data;
  }
  function isSuccess(status) {
    return 200 <= status && status < 300;
  }
  function $HttpProvider() {
    var JSON_START = /^\s*(\[|\{[^\{])/, JSON_END = /[\}\]]\s*$/, PROTECTION_PREFIX = /^\)\]\}',?\n/;
    var $config = this.defaults = {
        transformResponse: [function (data) {
            if (isString(data)) {
              data = data.replace(PROTECTION_PREFIX, '');
              if (JSON_START.test(data) && JSON_END.test(data))
                data = fromJson(data, true);
            }
            return data;
          }],
        transformRequest: [function (d) {
            return isObject(d) && !isFile(d) ? toJson(d) : d;
          }],
        headers: {
          common: {
            'Accept': 'application/json, text/plain, */*',
            'X-Requested-With': 'XMLHttpRequest'
          },
          post: { 'Content-Type': 'application/json;charset=utf-8' },
          put: { 'Content-Type': 'application/json;charset=utf-8' }
        }
      };
    var providerResponseInterceptors = this.responseInterceptors = [];
    this.$get = [
      '$httpBackend',
      '$browser',
      '$cacheFactory',
      '$rootScope',
      '$q',
      '$injector',
      function ($httpBackend, $browser, $cacheFactory, $rootScope, $q, $injector) {
        var defaultCache = $cacheFactory('$http'), responseInterceptors = [];
        forEach(providerResponseInterceptors, function (interceptor) {
          responseInterceptors.push(isString(interceptor) ? $injector.get(interceptor) : $injector.invoke(interceptor));
        });
        function $http(config) {
          config.method = uppercase(config.method);
          var reqTransformFn = config.transformRequest || $config.transformRequest, respTransformFn = config.transformResponse || $config.transformResponse, defHeaders = $config.headers, reqHeaders = extend({ 'X-XSRF-TOKEN': $browser.cookies()['XSRF-TOKEN'] }, defHeaders.common, defHeaders[lowercase(config.method)], config.headers), reqData = transformData(config.data, headersGetter(reqHeaders), reqTransformFn), promise;
          if (isUndefined(config.data)) {
            delete reqHeaders['Content-Type'];
          }
          promise = sendReq(config, reqData, reqHeaders);
          promise = promise.then(transformResponse, transformResponse);
          forEach(responseInterceptors, function (interceptor) {
            promise = interceptor(promise);
          });
          promise.success = function (fn) {
            promise.then(function (response) {
              fn(response.data, response.status, response.headers, config);
            });
            return promise;
          };
          promise.error = function (fn) {
            promise.then(null, function (response) {
              fn(response.data, response.status, response.headers, config);
            });
            return promise;
          };
          return promise;
          function transformResponse(response) {
            var resp = extend({}, response, { data: transformData(response.data, response.headers, respTransformFn) });
            return isSuccess(response.status) ? resp : $q.reject(resp);
          }
        }
        $http.pendingRequests = [];
        createShortMethods('get', 'delete', 'head', 'jsonp');
        createShortMethodsWithData('post', 'put');
        $http.defaults = $config;
        return $http;
        function createShortMethods(names) {
          forEach(arguments, function (name) {
            $http[name] = function (url, config) {
              return $http(extend(config || {}, {
                method: name,
                url: url
              }));
            };
          });
        }
        function createShortMethodsWithData(name) {
          forEach(arguments, function (name) {
            $http[name] = function (url, data, config) {
              return $http(extend(config || {}, {
                method: name,
                url: url,
                data: data
              }));
            };
          });
        }
        function sendReq(config, reqData, reqHeaders) {
          var deferred = $q.defer(), promise = deferred.promise, cache, cachedResp, url = buildUrl(config.url, config.params);
          $http.pendingRequests.push(config);
          promise.then(removePendingReq, removePendingReq);
          if (config.cache && config.method == 'GET') {
            cache = isObject(config.cache) ? config.cache : defaultCache;
          }
          if (cache) {
            cachedResp = cache.get(url);
            if (cachedResp) {
              if (cachedResp.then) {
                cachedResp.then(removePendingReq, removePendingReq);
                return cachedResp;
              } else {
                if (isArray(cachedResp)) {
                  resolvePromise(cachedResp[1], cachedResp[0], copy(cachedResp[2]));
                } else {
                  resolvePromise(cachedResp, 200, {});
                }
              }
            } else {
              cache.put(url, promise);
            }
          }
          if (!cachedResp) {
            $httpBackend(config.method, url, reqData, done, reqHeaders, config.timeout, config.withCredentials);
          }
          return promise;
          function done(status, response, headersString) {
            if (cache) {
              if (isSuccess(status)) {
                cache.put(url, [
                  status,
                  response,
                  parseHeaders(headersString)
                ]);
              } else {
                cache.remove(url);
              }
            }
            resolvePromise(response, status, headersString);
            $rootScope.$apply();
          }
          function resolvePromise(response, status, headers) {
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
            if (idx !== -1)
              $http.pendingRequests.splice(idx, 1);
          }
        }
        function buildUrl(url, params) {
          if (!params)
            return url;
          var parts = [];
          forEachSorted(params, function (value, key) {
            if (value == null || value == undefined)
              return;
            if (isObject(value)) {
              value = toJson(value);
            }
            parts.push(encodeURIComponent(key) + '=' + encodeURIComponent(value));
          });
          return url + (url.indexOf('?') == -1 ? '?' : '&') + parts.join('&');
        }
      }
    ];
  }
  var XHR = window.XMLHttpRequest || function () {
      try {
        return new ActiveXObject('Msxml2.XMLHTTP.6.0');
      } catch (e1) {
      }
      try {
        return new ActiveXObject('Msxml2.XMLHTTP.3.0');
      } catch (e2) {
      }
      try {
        return new ActiveXObject('Msxml2.XMLHTTP');
      } catch (e3) {
      }
      throw new Error('This browser does not support XMLHttpRequest.');
    };
  function $HttpBackendProvider() {
    this.$get = [
      '$browser',
      '$window',
      '$document',
      function ($browser, $window, $document) {
        return createHttpBackend($browser, XHR, $browser.defer, $window.angular.callbacks, $document[0], $window.location.protocol.replace(':', ''));
      }
    ];
  }
  function createHttpBackend($browser, XHR, $browserDefer, callbacks, rawDocument, locationProtocol) {
    return function (method, url, post, callback, headers, timeout, withCredentials) {
      $browser.$$incOutstandingRequestCount();
      url = url || $browser.url();
      if (lowercase(method) == 'jsonp') {
        var callbackId = '_' + (callbacks.counter++).toString(36);
        callbacks[callbackId] = function (data) {
          callbacks[callbackId].data = data;
        };
        jsonpReq(url.replace('JSON_CALLBACK', 'angular.callbacks.' + callbackId), function () {
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
        forEach(headers, function (value, key) {
          if (value)
            xhr.setRequestHeader(key, value);
        });
        var status;
        xhr.onreadystatechange = function () {
          if (xhr.readyState == 4) {
            var responseHeaders = xhr.getAllResponseHeaders();
            var value, simpleHeaders = [
                'Cache-Control',
                'Content-Language',
                'Content-Type',
                'Expires',
                'Last-Modified',
                'Pragma'
              ];
            if (!responseHeaders) {
              responseHeaders = '';
              forEach(simpleHeaders, function (header) {
                var value = xhr.getResponseHeader(header);
                if (value) {
                  responseHeaders += header + ': ' + value + '\n';
                }
              });
            }
            completeRequest(callback, status || xhr.status, xhr.responseText, responseHeaders);
          }
        };
        if (withCredentials) {
          xhr.withCredentials = true;
        }
        xhr.send(post || '');
        if (timeout > 0) {
          $browserDefer(function () {
            status = -1;
            xhr.abort();
          }, timeout);
        }
      }
      function completeRequest(callback, status, response, headersString) {
        var protocol = (url.match(URL_MATCH) || [
            '',
            locationProtocol
          ])[1];
        status = protocol == 'file' ? response ? 200 : 404 : status;
        status = status == 1223 ? 204 : status;
        callback(status, response, headersString);
        $browser.$$completeOutstandingRequest(noop);
      }
    };
    function jsonpReq(url, done) {
      var script = rawDocument.createElement('script'), doneWrapper = function () {
          rawDocument.body.removeChild(script);
          if (done)
            done();
        };
      script.type = 'text/javascript';
      script.src = url;
      if (msie) {
        script.onreadystatechange = function () {
          if (/loaded|complete/.test(script.readyState))
            doneWrapper();
        };
      } else {
        script.onload = script.onerror = doneWrapper;
      }
      rawDocument.body.appendChild(script);
    }
  }
  function $LocaleProvider() {
    this.$get = function () {
      return {
        id: 'en-us',
        NUMBER_FORMATS: {
          DECIMAL_SEP: '.',
          GROUP_SEP: ',',
          PATTERNS: [
            {
              minInt: 1,
              minFrac: 0,
              maxFrac: 3,
              posPre: '',
              posSuf: '',
              negPre: '-',
              negSuf: '',
              gSize: 3,
              lgSize: 3
            },
            {
              minInt: 1,
              minFrac: 2,
              maxFrac: 2,
              posPre: '\xa4',
              posSuf: '',
              negPre: '(\xa4',
              negSuf: ')',
              gSize: 3,
              lgSize: 3
            }
          ],
          CURRENCY_SYM: '$'
        },
        DATETIME_FORMATS: {
          MONTH: 'January,February,March,April,May,June,July,August,September,October,November,December'.split(','),
          SHORTMONTH: 'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec'.split(','),
          DAY: 'Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday'.split(','),
          SHORTDAY: 'Sun,Mon,Tue,Wed,Thu,Fri,Sat'.split(','),
          AMPMS: [
            'AM',
            'PM'
          ],
          medium: 'MMM d, y h:mm:ss a',
          short: 'M/d/yy h:mm a',
          fullDate: 'EEEE, MMMM d, y',
          longDate: 'MMMM d, y',
          mediumDate: 'MMM d, y',
          shortDate: 'M/d/yy',
          mediumTime: 'h:mm:ss a',
          shortTime: 'h:mm a'
        },
        pluralCat: function (num) {
          if (num === 1) {
            return 'one';
          }
          return 'other';
        }
      };
    };
  }
  function $TimeoutProvider() {
    this.$get = [
      '$rootScope',
      '$browser',
      '$q',
      '$exceptionHandler',
      function ($rootScope, $browser, $q, $exceptionHandler) {
        var deferreds = {};
        function timeout(fn, delay, invokeApply) {
          var deferred = $q.defer(), promise = deferred.promise, skipApply = isDefined(invokeApply) && !invokeApply, timeoutId, cleanup;
          timeoutId = $browser.defer(function () {
            try {
              deferred.resolve(fn());
            } catch (e) {
              deferred.reject(e);
              $exceptionHandler(e);
            }
            if (!skipApply)
              $rootScope.$apply();
          }, delay);
          cleanup = function () {
            delete deferreds[promise.$$timeoutId];
          };
          promise.$$timeoutId = timeoutId;
          deferreds[timeoutId] = deferred;
          promise.then(cleanup, cleanup);
          return promise;
        }
        timeout.cancel = function (promise) {
          if (promise && promise.$$timeoutId in deferreds) {
            deferreds[promise.$$timeoutId].reject('canceled');
            return $browser.defer.cancel(promise.$$timeoutId);
          }
          return false;
        };
        return timeout;
      }
    ];
  }
  $FilterProvider.$inject = ['$provide'];
  function $FilterProvider($provide) {
    var suffix = 'Filter';
    function register(name, factory) {
      return $provide.factory(name + suffix, factory);
    }
    this.register = register;
    this.$get = [
      '$injector',
      function ($injector) {
        return function (name) {
          return $injector.get(name + suffix);
        };
      }
    ];
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
  function filterFilter() {
    return function (array, expression) {
      if (!isArray(array))
        return array;
      var predicates = [];
      predicates.check = function (value) {
        for (var j = 0; j < predicates.length; j++) {
          if (!predicates[j](value)) {
            return false;
          }
        }
        return true;
      };
      var search = function (obj, text) {
        if (text.charAt(0) === '!') {
          return !search(obj, text.substr(1));
        }
        switch (typeof obj) {
        case 'boolean':
        case 'number':
        case 'string':
          return ('' + obj).toLowerCase().indexOf(text) > -1;
        case 'object':
          for (var objKey in obj) {
            if (objKey.charAt(0) !== '$' && search(obj[objKey], text)) {
              return true;
            }
          }
          return false;
        case 'array':
          for (var i = 0; i < obj.length; i++) {
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
      case 'boolean':
      case 'number':
      case 'string':
        expression = { $: expression };
      case 'object':
        for (var key in expression) {
          if (key == '$') {
            (function () {
              var text = ('' + expression[key]).toLowerCase();
              if (!text)
                return;
              predicates.push(function (value) {
                return search(value, text);
              });
            }());
          } else {
            (function () {
              var path = key;
              var text = ('' + expression[key]).toLowerCase();
              if (!text)
                return;
              predicates.push(function (value) {
                return search(getter(value, path), text);
              });
            }());
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
      for (var j = 0; j < array.length; j++) {
        var value = array[j];
        if (predicates.check(value)) {
          filtered.push(value);
        }
      }
      return filtered;
    };
  }
  currencyFilter.$inject = ['$locale'];
  function currencyFilter($locale) {
    var formats = $locale.NUMBER_FORMATS;
    return function (amount, currencySymbol) {
      if (isUndefined(currencySymbol))
        currencySymbol = formats.CURRENCY_SYM;
      return formatNumber(amount, formats.PATTERNS[1], formats.GROUP_SEP, formats.DECIMAL_SEP, 2).replace(/\u00A4/g, currencySymbol);
    };
  }
  numberFilter.$inject = ['$locale'];
  function numberFilter($locale) {
    var formats = $locale.NUMBER_FORMATS;
    return function (number, fractionSize) {
      return formatNumber(number, formats.PATTERNS[0], formats.GROUP_SEP, formats.DECIMAL_SEP, fractionSize);
    };
  }
  var DECIMAL_SEP = '.';
  function formatNumber(number, pattern, groupSep, decimalSep, fractionSize) {
    if (isNaN(number) || !isFinite(number))
      return '';
    var isNegative = number < 0;
    number = Math.abs(number);
    var numStr = number + '', formatedText = '', parts = [];
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
      if (isUndefined(fractionSize)) {
        fractionSize = Math.min(Math.max(pattern.minFrac, fractionLen), pattern.maxFrac);
      }
      var pow = Math.pow(10, fractionSize);
      number = Math.round(number * pow) / pow;
      var fraction = ('' + number).split(DECIMAL_SEP);
      var whole = fraction[0];
      fraction = fraction[1] || '';
      var pos = 0, lgroup = pattern.lgSize, group = pattern.gSize;
      if (whole.length >= lgroup + group) {
        pos = whole.length - lgroup;
        for (var i = 0; i < pos; i++) {
          if ((pos - i) % group === 0 && i !== 0) {
            formatedText += groupSep;
          }
          formatedText += whole.charAt(i);
        }
      }
      for (i = pos; i < whole.length; i++) {
        if ((whole.length - i) % lgroup === 0 && i !== 0) {
          formatedText += groupSep;
        }
        formatedText += whole.charAt(i);
      }
      while (fraction.length < fractionSize) {
        fraction += '0';
      }
      if (fractionSize && fractionSize !== '0')
        formatedText += decimalSep + fraction.substr(0, fractionSize);
    }
    parts.push(isNegative ? pattern.negPre : pattern.posPre);
    parts.push(formatedText);
    parts.push(isNegative ? pattern.negSuf : pattern.posSuf);
    return parts.join('');
  }
  function padNumber(num, digits, trim) {
    var neg = '';
    if (num < 0) {
      neg = '-';
      num = -num;
    }
    num = '' + num;
    while (num.length < digits)
      num = '0' + num;
    if (trim)
      num = num.substr(num.length - digits);
    return neg + num;
  }
  function dateGetter(name, size, offset, trim) {
    offset = offset || 0;
    return function (date) {
      var value = date['get' + name]();
      if (offset > 0 || value > -offset)
        value += offset;
      if (value === 0 && offset == -12)
        value = 12;
      return padNumber(value, size, trim);
    };
  }
  function dateStrGetter(name, shortForm) {
    return function (date, formats) {
      var value = date['get' + name]();
      var get = uppercase(shortForm ? 'SHORT' + name : name);
      return formats[get][value];
    };
  }
  function timeZoneGetter(date) {
    var zone = -1 * date.getTimezoneOffset();
    var paddedZone = zone >= 0 ? '+' : '';
    paddedZone += padNumber(Math[zone > 0 ? 'floor' : 'ceil'](zone / 60), 2) + padNumber(Math.abs(zone % 60), 2);
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
  var DATE_FORMATS_SPLIT = /((?:[^yMdHhmsaZE']+)|(?:'(?:[^']|'')*')|(?:E+|y+|M+|d+|H+|h+|m+|s+|a|Z))(.*)/, NUMBER_STRING = /^\d+$/;
  dateFilter.$inject = ['$locale'];
  function dateFilter($locale) {
    var R_ISO8601_STR = /^(\d{4})-?(\d\d)-?(\d\d)(?:T(\d\d)(?::?(\d\d)(?::?(\d\d)(?:\.(\d+))?)?)?(Z|([+-])(\d\d):?(\d\d))?)?$/;
    function jsonStringToDate(string) {
      var match;
      if (match = string.match(R_ISO8601_STR)) {
        var date = new Date(0), tzHour = 0, tzMin = 0;
        if (match[9]) {
          tzHour = int(match[9] + match[10]);
          tzMin = int(match[9] + match[11]);
        }
        date.setUTCFullYear(int(match[1]), int(match[2]) - 1, int(match[3]));
        date.setUTCHours(int(match[4] || 0) - tzHour, int(match[5] || 0) - tzMin, int(match[6] || 0), int(match[7] || 0));
        return date;
      }
      return string;
    }
    return function (date, format) {
      var text = '', parts = [], fn, match;
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
      while (format) {
        match = DATE_FORMATS_SPLIT.exec(format);
        if (match) {
          parts = concat(parts, match, 1);
          format = parts.pop();
        } else {
          parts.push(format);
          format = null;
        }
      }
      forEach(parts, function (value) {
        fn = DATE_FORMATS[value];
        text += fn ? fn(date, $locale.DATETIME_FORMATS) : value.replace(/(^'|'$)/g, '').replace(/''/g, '\'');
      });
      return text;
    };
  }
  function jsonFilter() {
    return function (object) {
      return toJson(object, true);
    };
  }
  var lowercaseFilter = valueFn(lowercase);
  var uppercaseFilter = valueFn(uppercase);
  function limitToFilter() {
    return function (array, limit) {
      if (!(array instanceof Array))
        return array;
      limit = int(limit);
      var out = [], i, n;
      if (!array || !(array instanceof Array))
        return out;
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
      for (; i < n; i++) {
        out.push(array[i]);
      }
      return out;
    };
  }
  orderByFilter.$inject = ['$parse'];
  function orderByFilter($parse) {
    return function (array, sortPredicate, reverseOrder) {
      if (!isArray(array))
        return array;
      if (!sortPredicate)
        return array;
      sortPredicate = isArray(sortPredicate) ? sortPredicate : [sortPredicate];
      sortPredicate = map(sortPredicate, function (predicate) {
        var descending = false, get = predicate || identity;
        if (isString(predicate)) {
          if (predicate.charAt(0) == '+' || predicate.charAt(0) == '-') {
            descending = predicate.charAt(0) == '-';
            predicate = predicate.substring(1);
          }
          get = $parse(predicate);
        }
        return reverseComparator(function (a, b) {
          return compare(get(a), get(b));
        }, descending);
      });
      var arrayCopy = [];
      for (var i = 0; i < array.length; i++) {
        arrayCopy.push(array[i]);
      }
      return arrayCopy.sort(reverseComparator(comparator, reverseOrder));
      function comparator(o1, o2) {
        for (var i = 0; i < sortPredicate.length; i++) {
          var comp = sortPredicate[i](o1, o2);
          if (comp !== 0)
            return comp;
        }
        return 0;
      }
      function reverseComparator(comp, descending) {
        return toBoolean(descending) ? function (a, b) {
          return comp(b, a);
        } : comp;
      }
      function compare(v1, v2) {
        var t1 = typeof v1;
        var t2 = typeof v2;
        if (t1 == t2) {
          if (t1 == 'string')
            v1 = v1.toLowerCase();
          if (t1 == 'string')
            v2 = v2.toLowerCase();
          if (v1 === v2)
            return 0;
          return v1 < v2 ? -1 : 1;
        } else {
          return t1 < t2 ? -1 : 1;
        }
      }
    };
  }
  function ngDirective(directive) {
    if (isFunction(directive)) {
      directive = { link: directive };
    }
    directive.restrict = directive.restrict || 'AC';
    return valueFn(directive);
  }
  var htmlAnchorDirective = valueFn({
      restrict: 'E',
      compile: function (element, attr) {
        if (msie <= 8) {
          if (!attr.href && !attr.name) {
            attr.$set('href', '');
          }
          element.append(document.createComment('IE fix'));
        }
        return function (scope, element) {
          element.bind('click', function (event) {
            if (!element.attr('href')) {
              event.preventDefault();
            }
          });
        };
      }
    });
  var ngAttributeAliasDirectives = {};
  forEach(BOOLEAN_ATTR, function (propName, attrName) {
    var normalized = directiveNormalize('ng-' + attrName);
    ngAttributeAliasDirectives[normalized] = function () {
      return {
        priority: 100,
        compile: function () {
          return function (scope, element, attr) {
            scope.$watch(attr[normalized], function ngBooleanAttrWatchAction(value) {
              attr.$set(attrName, !!value);
            });
          };
        }
      };
    };
  });
  forEach([
    'src',
    'href'
  ], function (attrName) {
    var normalized = directiveNormalize('ng-' + attrName);
    ngAttributeAliasDirectives[normalized] = function () {
      return {
        priority: 99,
        link: function (scope, element, attr) {
          attr.$observe(normalized, function (value) {
            if (!value)
              return;
            attr.$set(attrName, value);
            if (msie)
              element.prop(attrName, attr[attrName]);
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
  FormController.$inject = [
    '$element',
    '$attrs',
    '$scope'
  ];
  function FormController(element, attrs) {
    var form = this, parentForm = element.parent().controller('form') || nullFormCtrl, invalidCount = 0, errors = form.$error = {};
    form.$name = attrs.name;
    form.$dirty = false;
    form.$pristine = true;
    form.$valid = true;
    form.$invalid = false;
    parentForm.$addControl(form);
    element.addClass(PRISTINE_CLASS);
    toggleValidCss(true);
    function toggleValidCss(isValid, validationErrorKey) {
      validationErrorKey = validationErrorKey ? '-' + snake_case(validationErrorKey, '-') : '';
      element.removeClass((isValid ? INVALID_CLASS : VALID_CLASS) + validationErrorKey).addClass((isValid ? VALID_CLASS : INVALID_CLASS) + validationErrorKey);
    }
    form.$addControl = function (control) {
      if (control.$name && !form.hasOwnProperty(control.$name)) {
        form[control.$name] = control;
      }
    };
    form.$removeControl = function (control) {
      if (control.$name && form[control.$name] === control) {
        delete form[control.$name];
      }
      forEach(errors, function (queue, validationToken) {
        form.$setValidity(validationToken, true, control);
      });
    };
    form.$setValidity = function (validationToken, isValid, control) {
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
          if (includes(queue, control))
            return;
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
    form.$setDirty = function () {
      element.removeClass(PRISTINE_CLASS).addClass(DIRTY_CLASS);
      form.$dirty = true;
      form.$pristine = false;
      parentForm.$setDirty();
    };
  }
  var formDirectiveFactory = function (isNgForm) {
    return [
      '$timeout',
      function ($timeout) {
        var formDirective = {
            name: 'form',
            restrict: 'E',
            controller: FormController,
            compile: function () {
              return {
                pre: function (scope, formElement, attr, controller) {
                  if (!attr.action) {
                    var preventDefaultListener = function (event) {
                      event.preventDefault ? event.preventDefault() : event.returnValue = false;
                    };
                    addEventListenerFn(formElement[0], 'submit', preventDefaultListener);
                    formElement.bind('$destroy', function () {
                      $timeout(function () {
                        removeEventListenerFn(formElement[0], 'submit', preventDefaultListener);
                      }, 0, false);
                    });
                  }
                  var parentFormCtrl = formElement.parent().controller('form'), alias = attr.name || attr.ngForm;
                  if (alias) {
                    scope[alias] = controller;
                  }
                  if (parentFormCtrl) {
                    formElement.bind('$destroy', function () {
                      parentFormCtrl.$removeControl(controller);
                      if (alias) {
                        scope[alias] = undefined;
                      }
                      extend(controller, nullFormCtrl);
                    });
                  }
                }
              };
            }
          };
        return isNgForm ? extend(copy(formDirective), { restrict: 'EAC' }) : formDirective;
      }
    ];
  };
  var formDirective = formDirectiveFactory();
  var ngFormDirective = formDirectiveFactory(true);
  var URL_REGEXP = /^(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?$/;
  var EMAIL_REGEXP = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/;
  var NUMBER_REGEXP = /^\s*(\-|\+)?(\d+|(\d*(\.\d*)))\s*$/;
  var inputType = {
      'text': textInputType,
      'number': numberInputType,
      'url': urlInputType,
      'email': emailInputType,
      'radio': radioInputType,
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
    var listener = function () {
      var value = trim(element.val());
      if (ctrl.$viewValue !== value) {
        scope.$apply(function () {
          ctrl.$setViewValue(value);
        });
      }
    };
    if ($sniffer.hasEvent('input')) {
      element.bind('input', listener);
    } else {
      var timeout;
      var deferListener = function () {
        if (!timeout) {
          timeout = $browser.defer(function () {
            listener();
            timeout = null;
          });
        }
      };
      element.bind('keydown', function (event) {
        var key = event.keyCode;
        if (key === 91 || 15 < key && key < 19 || 37 <= key && key <= 40)
          return;
        deferListener();
      });
      element.bind('change', listener);
      if ($sniffer.hasEvent('paste')) {
        element.bind('paste cut', deferListener);
      }
    }
    ctrl.$render = function () {
      element.val(isEmpty(ctrl.$viewValue) ? '' : ctrl.$viewValue);
    };
    var pattern = attr.ngPattern, patternValidator;
    var validate = function (regexp, value) {
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
        patternValidator = function (value) {
          return validate(pattern, value);
        };
      } else {
        patternValidator = function (value) {
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
    if (attr.ngMinlength) {
      var minlength = int(attr.ngMinlength);
      var minLengthValidator = function (value) {
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
    if (attr.ngMaxlength) {
      var maxlength = int(attr.ngMaxlength);
      var maxLengthValidator = function (value) {
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
    ctrl.$parsers.push(function (value) {
      var empty = isEmpty(value);
      if (empty || NUMBER_REGEXP.test(value)) {
        ctrl.$setValidity('number', true);
        return value === '' ? null : empty ? value : parseFloat(value);
      } else {
        ctrl.$setValidity('number', false);
        return undefined;
      }
    });
    ctrl.$formatters.push(function (value) {
      return isEmpty(value) ? '' : '' + value;
    });
    if (attr.min) {
      var min = parseFloat(attr.min);
      var minValidator = function (value) {
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
      var maxValidator = function (value) {
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
    ctrl.$formatters.push(function (value) {
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
    var urlValidator = function (value) {
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
    var emailValidator = function (value) {
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
    if (isUndefined(attr.name)) {
      element.attr('name', nextUid());
    }
    element.bind('click', function () {
      if (element[0].checked) {
        scope.$apply(function () {
          ctrl.$setViewValue(attr.value);
        });
      }
    });
    ctrl.$render = function () {
      var value = attr.value;
      element[0].checked = value == ctrl.$viewValue;
    };
    attr.$observe('value', ctrl.$render);
  }
  function checkboxInputType(scope, element, attr, ctrl) {
    var trueValue = attr.ngTrueValue, falseValue = attr.ngFalseValue;
    if (!isString(trueValue))
      trueValue = true;
    if (!isString(falseValue))
      falseValue = false;
    element.bind('click', function () {
      scope.$apply(function () {
        ctrl.$setViewValue(element[0].checked);
      });
    });
    ctrl.$render = function () {
      element[0].checked = ctrl.$viewValue;
    };
    ctrl.$formatters.push(function (value) {
      return value === trueValue;
    });
    ctrl.$parsers.push(function (value) {
      return value ? trueValue : falseValue;
    });
  }
  var inputDirective = [
      '$browser',
      '$sniffer',
      function ($browser, $sniffer) {
        return {
          restrict: 'E',
          require: '?ngModel',
          link: function (scope, element, attr, ctrl) {
            if (ctrl) {
              (inputType[lowercase(attr.type)] || inputType.text)(scope, element, attr, ctrl, $sniffer, $browser);
            }
          }
        };
      }
    ];
  var VALID_CLASS = 'ng-valid', INVALID_CLASS = 'ng-invalid', PRISTINE_CLASS = 'ng-pristine', DIRTY_CLASS = 'ng-dirty';
  var NgModelController = [
      '$scope',
      '$exceptionHandler',
      '$attrs',
      '$element',
      '$parse',
      function ($scope, $exceptionHandler, $attr, $element, $parse) {
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
        var ngModelGet = $parse($attr.ngModel), ngModelSet = ngModelGet.assign;
        if (!ngModelSet) {
          throw Error(NON_ASSIGNABLE_MODEL_EXPRESSION + $attr.ngModel + ' (' + startingTag($element) + ')');
        }
        this.$render = noop;
        var parentForm = $element.inheritedData('$formController') || nullFormCtrl, invalidCount = 0, $error = this.$error = {};
        $element.addClass(PRISTINE_CLASS);
        toggleValidCss(true);
        function toggleValidCss(isValid, validationErrorKey) {
          validationErrorKey = validationErrorKey ? '-' + snake_case(validationErrorKey, '-') : '';
          $element.removeClass((isValid ? INVALID_CLASS : VALID_CLASS) + validationErrorKey).addClass((isValid ? VALID_CLASS : INVALID_CLASS) + validationErrorKey);
        }
        this.$setValidity = function (validationErrorKey, isValid) {
          if ($error[validationErrorKey] === !isValid)
            return;
          if (isValid) {
            if ($error[validationErrorKey])
              invalidCount--;
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
        this.$setViewValue = function (value) {
          this.$viewValue = value;
          if (this.$pristine) {
            this.$dirty = true;
            this.$pristine = false;
            $element.removeClass(PRISTINE_CLASS).addClass(DIRTY_CLASS);
            parentForm.$setDirty();
          }
          forEach(this.$parsers, function (fn) {
            value = fn(value);
          });
          if (this.$modelValue !== value) {
            this.$modelValue = value;
            ngModelSet($scope, value);
            forEach(this.$viewChangeListeners, function (listener) {
              try {
                listener();
              } catch (e) {
                $exceptionHandler(e);
              }
            });
          }
        };
        var ctrl = this;
        $scope.$watch(function ngModelWatch() {
          var value = ngModelGet($scope);
          if (ctrl.$modelValue !== value) {
            var formatters = ctrl.$formatters, idx = formatters.length;
            ctrl.$modelValue = value;
            while (idx--) {
              value = formatters[idx](value);
            }
            if (ctrl.$viewValue !== value) {
              ctrl.$viewValue = value;
              ctrl.$render();
            }
          }
        });
      }
    ];
  var ngModelDirective = function () {
    return {
      require: [
        'ngModel',
        '^?form'
      ],
      controller: NgModelController,
      link: function (scope, element, attr, ctrls) {
        var modelCtrl = ctrls[0], formCtrl = ctrls[1] || nullFormCtrl;
        formCtrl.$addControl(modelCtrl);
        element.bind('$destroy', function () {
          formCtrl.$removeControl(modelCtrl);
        });
      }
    };
  };
  var ngChangeDirective = valueFn({
      require: 'ngModel',
      link: function (scope, element, attr, ctrl) {
        ctrl.$viewChangeListeners.push(function () {
          scope.$eval(attr.ngChange);
        });
      }
    });
  var requiredDirective = function () {
    return {
      require: '?ngModel',
      link: function (scope, elm, attr, ctrl) {
        if (!ctrl)
          return;
        attr.required = true;
        var validator = function (value) {
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
        attr.$observe('required', function () {
          validator(ctrl.$viewValue);
        });
      }
    };
  };
  var ngListDirective = function () {
    return {
      require: 'ngModel',
      link: function (scope, element, attr, ctrl) {
        var match = /\/(.*)\//.exec(attr.ngList), separator = match && new RegExp(match[1]) || attr.ngList || ',';
        var parse = function (viewValue) {
          var list = [];
          if (viewValue) {
            forEach(viewValue.split(separator), function (value) {
              if (value)
                list.push(trim(value));
            });
          }
          return list;
        };
        ctrl.$parsers.push(parse);
        ctrl.$formatters.push(function (value) {
          if (isArray(value)) {
            return value.join(', ');
          }
          return undefined;
        });
      }
    };
  };
  var CONSTANT_VALUE_REGEXP = /^(true|false|\d+)$/;
  var ngValueDirective = function () {
    return {
      priority: 100,
      compile: function (tpl, tplAttr) {
        if (CONSTANT_VALUE_REGEXP.test(tplAttr.ngValue)) {
          return function (scope, elm, attr) {
            attr.$set('value', scope.$eval(attr.ngValue));
          };
        } else {
          return function (scope, elm, attr) {
            scope.$watch(attr.ngValue, function valueWatchAction(value) {
              attr.$set('value', value, false);
            });
          };
        }
      }
    };
  };
  var ngBindDirective = ngDirective(function (scope, element, attr) {
      element.addClass('ng-binding').data('$binding', attr.ngBind);
      scope.$watch(attr.ngBind, function ngBindWatchAction(value) {
        element.text(value == undefined ? '' : value);
      });
    });
  var ngBindTemplateDirective = [
      '$interpolate',
      function ($interpolate) {
        return function (scope, element, attr) {
          var interpolateFn = $interpolate(element.attr(attr.$attr.ngBindTemplate));
          element.addClass('ng-binding').data('$binding', interpolateFn);
          attr.$observe('ngBindTemplate', function (value) {
            element.text(value);
          });
        };
      }
    ];
  var ngBindHtmlUnsafeDirective = [function () {
        return function (scope, element, attr) {
          element.addClass('ng-binding').data('$binding', attr.ngBindHtmlUnsafe);
          scope.$watch(attr.ngBindHtmlUnsafe, function ngBindHtmlUnsafeWatchAction(value) {
            element.html(value || '');
          });
        };
      }];
  function classDirective(name, selector) {
    name = 'ngClass' + name;
    return ngDirective(function (scope, element, attr) {
      var oldVal = undefined;
      scope.$watch(attr[name], ngClassWatchAction, true);
      attr.$observe('class', function (value) {
        var ngClass = scope.$eval(attr[name]);
        ngClassWatchAction(ngClass, ngClass);
      });
      if (name !== 'ngClass') {
        scope.$watch('$index', function ($index, old$index) {
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
          if (oldVal && !equals(newVal, oldVal)) {
            removeClass(oldVal);
          }
          addClass(newVal);
        }
        oldVal = copy(newVal);
      }
      function removeClass(classVal) {
        if (isObject(classVal) && !isArray(classVal)) {
          classVal = map(classVal, function (v, k) {
            if (v)
              return k;
          });
        }
        element.removeClass(isArray(classVal) ? classVal.join(' ') : classVal);
      }
      function addClass(classVal) {
        if (isObject(classVal) && !isArray(classVal)) {
          classVal = map(classVal, function (v, k) {
            if (v)
              return k;
          });
        }
        if (classVal) {
          element.addClass(isArray(classVal) ? classVal.join(' ') : classVal);
        }
      }
    });
  }
  var ngClassDirective = classDirective('', true);
  var ngClassOddDirective = classDirective('Odd', 0);
  var ngClassEvenDirective = classDirective('Even', 1);
  var ngCloakDirective = ngDirective({
      compile: function (element, attr) {
        attr.$set('ngCloak', undefined);
        element.removeClass('ng-cloak');
      }
    });
  var ngControllerDirective = [function () {
        return {
          scope: true,
          controller: '@'
        };
      }];
  var ngCspDirective = [
      '$sniffer',
      function ($sniffer) {
        return {
          priority: 1000,
          compile: function () {
            $sniffer.csp = true;
          }
        };
      }
    ];
  var ngEventDirectives = {};
  forEach('click dblclick mousedown mouseup mouseover mouseout mousemove mouseenter mouseleave'.split(' '), function (name) {
    var directiveName = directiveNormalize('ng-' + name);
    ngEventDirectives[directiveName] = [
      '$parse',
      function ($parse) {
        return function (scope, element, attr) {
          var fn = $parse(attr[directiveName]);
          element.bind(lowercase(name), function (event) {
            scope.$apply(function () {
              fn(scope, { $event: event });
            });
          });
        };
      }
    ];
  });
  var ngSubmitDirective = ngDirective(function (scope, element, attrs) {
      element.bind('submit', function () {
        scope.$apply(attrs.ngSubmit);
      });
    });
  var ngIncludeDirective = [
      '$http',
      '$templateCache',
      '$anchorScroll',
      '$compile',
      function ($http, $templateCache, $anchorScroll, $compile) {
        return {
          restrict: 'ECA',
          terminal: true,
          compile: function (element, attr) {
            var srcExp = attr.ngInclude || attr.src, onloadExp = attr.onload || '', autoScrollExp = attr.autoscroll;
            return function (scope, element) {
              var changeCounter = 0, childScope;
              var clearContent = function () {
                if (childScope) {
                  childScope.$destroy();
                  childScope = null;
                }
                element.html('');
              };
              scope.$watch(srcExp, function ngIncludeWatchAction(src) {
                var thisChangeId = ++changeCounter;
                if (src) {
                  $http.get(src, { cache: $templateCache }).success(function (response) {
                    if (thisChangeId !== changeCounter)
                      return;
                    if (childScope)
                      childScope.$destroy();
                    childScope = scope.$new();
                    element.html(response);
                    $compile(element.contents())(childScope);
                    if (isDefined(autoScrollExp) && (!autoScrollExp || scope.$eval(autoScrollExp))) {
                      $anchorScroll();
                    }
                    childScope.$emit('$includeContentLoaded');
                    scope.$eval(onloadExp);
                  }).error(function () {
                    if (thisChangeId === changeCounter)
                      clearContent();
                  });
                } else
                  clearContent();
              });
            };
          }
        };
      }
    ];
  var ngInitDirective = ngDirective({
      compile: function () {
        return {
          pre: function (scope, element, attrs) {
            scope.$eval(attrs.ngInit);
          }
        };
      }
    });
  var ngNonBindableDirective = ngDirective({
      terminal: true,
      priority: 1000
    });
  var ngPluralizeDirective = [
      '$locale',
      '$interpolate',
      function ($locale, $interpolate) {
        var BRACE = /{}/g;
        return {
          restrict: 'EA',
          link: function (scope, element, attr) {
            var numberExp = attr.count, whenExp = element.attr(attr.$attr.when), offset = attr.offset || 0, whens = scope.$eval(whenExp), whensExpFns = {}, startSymbol = $interpolate.startSymbol(), endSymbol = $interpolate.endSymbol();
            forEach(whens, function (expression, key) {
              whensExpFns[key] = $interpolate(expression.replace(BRACE, startSymbol + numberExp + '-' + offset + endSymbol));
            });
            scope.$watch(function ngPluralizeWatch() {
              var value = parseFloat(scope.$eval(numberExp));
              if (!isNaN(value)) {
                if (!(value in whens))
                  value = $locale.pluralCat(value - offset);
                return whensExpFns[value](scope, element, true);
              } else {
                return '';
              }
            }, function ngPluralizeWatchAction(newVal) {
              element.text(newVal);
            });
          }
        };
      }
    ];
  var ngRepeatDirective = ngDirective({
      transclude: 'element',
      priority: 1000,
      terminal: true,
      compile: function (element, attr, linker) {
        return function (scope, iterStartElement, attr) {
          var expression = attr.ngRepeat;
          var match = expression.match(/^\s*(.+)\s+in\s+(.*)\s*$/), lhs, rhs, valueIdent, keyIdent;
          if (!match) {
            throw Error('Expected ngRepeat in form of \'_item_ in _collection_\' but got \'' + expression + '\'.');
          }
          lhs = match[1];
          rhs = match[2];
          match = lhs.match(/^(?:([\$\w]+)|\(([\$\w]+)\s*,\s*([\$\w]+)\))$/);
          if (!match) {
            throw Error('\'item\' in \'item in collection\' should be identifier or (key, value) but got \'' + lhs + '\'.');
          }
          valueIdent = match[3] || match[1];
          keyIdent = match[2];
          var lastOrder = new HashQueueMap();
          scope.$watch(function ngRepeatWatch(scope) {
            var index, length, collection = scope.$eval(rhs), cursor = iterStartElement, nextOrder = new HashQueueMap(), arrayBound, childScope, key, value, array, last;
            if (!isArray(collection)) {
              array = [];
              for (key in collection) {
                if (collection.hasOwnProperty(key) && key.charAt(0) != '$') {
                  array.push(key);
                }
              }
              array.sort();
            } else {
              array = collection || [];
            }
            arrayBound = array.length - 1;
            for (index = 0, length = array.length; index < length; index++) {
              key = collection === array ? index : array[index];
              value = collection[key];
              last = lastOrder.shift(value);
              if (last) {
                childScope = last.scope;
                nextOrder.push(value, last);
                if (index === last.index) {
                  cursor = last.element;
                } else {
                  last.index = index;
                  cursor.after(last.element);
                  cursor = last.element;
                }
              } else {
                childScope = scope.$new();
              }
              childScope[valueIdent] = value;
              if (keyIdent)
                childScope[keyIdent] = key;
              childScope.$index = index;
              childScope.$first = index === 0;
              childScope.$last = index === arrayBound;
              childScope.$middle = !(childScope.$first || childScope.$last);
              if (!last) {
                linker(childScope, function (clone) {
                  cursor.after(clone);
                  last = {
                    scope: childScope,
                    element: cursor = clone,
                    index: index
                  };
                  nextOrder.push(value, last);
                });
              }
            }
            for (key in lastOrder) {
              if (lastOrder.hasOwnProperty(key)) {
                array = lastOrder[key];
                while (array.length) {
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
  var ngShowDirective = ngDirective(function (scope, element, attr) {
      scope.$watch(attr.ngShow, function ngShowWatchAction(value) {
        element.css('display', toBoolean(value) ? '' : 'none');
      });
    });
  var ngHideDirective = ngDirective(function (scope, element, attr) {
      scope.$watch(attr.ngHide, function ngHideWatchAction(value) {
        element.css('display', toBoolean(value) ? 'none' : '');
      });
    });
  var ngStyleDirective = ngDirective(function (scope, element, attr) {
      scope.$watch(attr.ngStyle, function ngStyleWatchAction(newStyles, oldStyles) {
        if (oldStyles && newStyles !== oldStyles) {
          forEach(oldStyles, function (val, style) {
            element.css(style, '');
          });
        }
        if (newStyles)
          element.css(newStyles);
      }, true);
    });
  var NG_SWITCH = 'ng-switch';
  var ngSwitchDirective = valueFn({
      restrict: 'EA',
      require: 'ngSwitch',
      controller: [
        '$scope',
        function ngSwitchController() {
          this.cases = {};
        }
      ],
      link: function (scope, element, attr, ctrl) {
        var watchExpr = attr.ngSwitch || attr.on, selectedTransclude, selectedElement, selectedScope;
        scope.$watch(watchExpr, function ngSwitchWatchAction(value) {
          if (selectedElement) {
            selectedScope.$destroy();
            selectedElement.remove();
            selectedElement = selectedScope = null;
          }
          if (selectedTransclude = ctrl.cases['!' + value] || ctrl.cases['?']) {
            scope.$eval(attr.change);
            selectedScope = scope.$new();
            selectedTransclude(selectedScope, function (caseElement) {
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
      compile: function (element, attrs, transclude) {
        return function (scope, element, attr, ctrl) {
          ctrl.cases['!' + attrs.ngSwitchWhen] = transclude;
        };
      }
    });
  var ngSwitchDefaultDirective = ngDirective({
      transclude: 'element',
      priority: 500,
      require: '^ngSwitch',
      compile: function (element, attrs, transclude) {
        return function (scope, element, attr, ctrl) {
          ctrl.cases['?'] = transclude;
        };
      }
    });
  var ngTranscludeDirective = ngDirective({
      controller: [
        '$transclude',
        '$element',
        function ($transclude, $element) {
          $transclude(function (clone) {
            $element.append(clone);
          });
        }
      ]
    });
  var ngViewDirective = [
      '$http',
      '$templateCache',
      '$route',
      '$anchorScroll',
      '$compile',
      '$controller',
      function ($http, $templateCache, $route, $anchorScroll, $compile, $controller) {
        return {
          restrict: 'ECA',
          terminal: true,
          link: function (scope, element, attr) {
            var lastScope, onloadExp = attr.onload || '';
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
              var locals = $route.current && $route.current.locals, template = locals && locals.$template;
              if (template) {
                element.html(template);
                destroyLastScope();
                var link = $compile(element.contents()), current = $route.current, controller;
                lastScope = current.scope = scope.$new();
                if (current.controller) {
                  locals.$scope = lastScope;
                  controller = $controller(current.controller, locals);
                  element.children().data('$ngControllerController', controller);
                }
                link(lastScope);
                lastScope.$emit('$viewContentLoaded');
                lastScope.$eval(onloadExp);
                $anchorScroll();
              } else {
                clearContent();
              }
            }
          }
        };
      }
    ];
  var scriptDirective = [
      '$templateCache',
      function ($templateCache) {
        return {
          restrict: 'E',
          terminal: true,
          compile: function (element, attr) {
            if (attr.type == 'text/ng-template') {
              var templateUrl = attr.id, text = element[0].text;
              $templateCache.put(templateUrl, text);
            }
          }
        };
      }
    ];
  var ngOptionsDirective = valueFn({ terminal: true });
  var selectDirective = [
      '$compile',
      '$parse',
      function ($compile, $parse) {
        var NG_OPTIONS_REGEXP = /^\s*(.*?)(?:\s+as\s+(.*?))?(?:\s+group\s+by\s+(.*))?\s+for\s+(?:([\$\w][\$\w\d]*)|(?:\(\s*([\$\w][\$\w\d]*)\s*,\s*([\$\w][\$\w\d]*)\s*\)))\s+in\s+(.*)$/, nullModelCtrl = { $setViewValue: noop };
        return {
          restrict: 'E',
          require: [
            'select',
            '?ngModel'
          ],
          controller: [
            '$element',
            '$scope',
            '$attrs',
            function ($element, $scope, $attrs) {
              var self = this, optionsMap = {}, ngModelCtrl = nullModelCtrl, nullOption, unknownOption;
              self.databound = $attrs.ngModel;
              self.init = function (ngModelCtrl_, nullOption_, unknownOption_) {
                ngModelCtrl = ngModelCtrl_;
                nullOption = nullOption_;
                unknownOption = unknownOption_;
              };
              self.addOption = function (value) {
                optionsMap[value] = true;
                if (ngModelCtrl.$viewValue == value) {
                  $element.val(value);
                  if (unknownOption.parent())
                    unknownOption.remove();
                }
              };
              self.removeOption = function (value) {
                if (this.hasOption(value)) {
                  delete optionsMap[value];
                  if (ngModelCtrl.$viewValue == value) {
                    this.renderUnknownOption(value);
                  }
                }
              };
              self.renderUnknownOption = function (val) {
                var unknownVal = '? ' + hashKey(val) + ' ?';
                unknownOption.val(unknownVal);
                $element.prepend(unknownOption);
                $element.val(unknownVal);
                unknownOption.prop('selected', true);
              };
              self.hasOption = function (value) {
                return optionsMap.hasOwnProperty(value);
              };
              $scope.$on('$destroy', function () {
                self.renderUnknownOption = noop;
              });
            }
          ],
          link: function (scope, element, attr, ctrls) {
            if (!ctrls[1])
              return;
            var selectCtrl = ctrls[0], ngModelCtrl = ctrls[1], multiple = attr.multiple, optionsExp = attr.ngOptions, nullOption = false, emptyOption, optionTemplate = jqLite(document.createElement('option')), optGroupTemplate = jqLite(document.createElement('optgroup')), unknownOption = optionTemplate.clone();
            for (var i = 0, children = element.children(), ii = children.length; i < ii; i++) {
              if (children[i].value == '') {
                emptyOption = nullOption = children.eq(i);
                break;
              }
            }
            selectCtrl.init(ngModelCtrl, nullOption, unknownOption);
            if (multiple && (attr.required || attr.ngRequired)) {
              var requiredValidator = function (value) {
                ngModelCtrl.$setValidity('required', !attr.required || value && value.length);
                return value;
              };
              ngModelCtrl.$parsers.push(requiredValidator);
              ngModelCtrl.$formatters.unshift(requiredValidator);
              attr.$observe('required', function () {
                requiredValidator(ngModelCtrl.$viewValue);
              });
            }
            if (optionsExp)
              Options(scope, element, ngModelCtrl);
            else if (multiple)
              Multiple(scope, element, ngModelCtrl);
            else
              Single(scope, element, ngModelCtrl, selectCtrl);
            function Single(scope, selectElement, ngModelCtrl, selectCtrl) {
              ngModelCtrl.$render = function () {
                var viewValue = ngModelCtrl.$viewValue;
                if (selectCtrl.hasOption(viewValue)) {
                  if (unknownOption.parent())
                    unknownOption.remove();
                  selectElement.val(viewValue);
                  if (viewValue === '')
                    emptyOption.prop('selected', true);
                } else {
                  if (isUndefined(viewValue) && emptyOption) {
                    selectElement.val('');
                  } else {
                    selectCtrl.renderUnknownOption(viewValue);
                  }
                }
              };
              selectElement.bind('change', function () {
                scope.$apply(function () {
                  if (unknownOption.parent())
                    unknownOption.remove();
                  ngModelCtrl.$setViewValue(selectElement.val());
                });
              });
            }
            function Multiple(scope, selectElement, ctrl) {
              var lastView;
              ctrl.$render = function () {
                var items = new HashMap(ctrl.$viewValue);
                forEach(selectElement.find('option'), function (option) {
                  option.selected = isDefined(items.get(option.value));
                });
              };
              scope.$watch(function selectMultipleWatch() {
                if (!equals(lastView, ctrl.$viewValue)) {
                  lastView = copy(ctrl.$viewValue);
                  ctrl.$render();
                }
              });
              selectElement.bind('change', function () {
                scope.$apply(function () {
                  var array = [];
                  forEach(selectElement.find('option'), function (option) {
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
              if (!(match = optionsExp.match(NG_OPTIONS_REGEXP))) {
                throw Error('Expected ngOptions in form of \'_select_ (as _label_)? for (_key_,)?_value_ in _collection_\'' + ' but got \'' + optionsExp + '\'.');
              }
              var displayFn = $parse(match[2] || match[1]), valueName = match[4] || match[6], keyName = match[5], groupByFn = $parse(match[3] || ''), valueFn = $parse(match[2] ? match[1] : valueName), valuesFn = $parse(match[7]), optionGroupsCache = [[{
                      element: selectElement,
                      label: ''
                    }]];
              if (nullOption) {
                $compile(nullOption)(scope);
                nullOption.removeClass('ng-scope');
                nullOption.remove();
              }
              selectElement.html('');
              selectElement.bind('change', function () {
                scope.$apply(function () {
                  var optionGroup, collection = valuesFn(scope) || [], locals = {}, key, value, optionElement, index, groupIndex, length, groupLength;
                  if (multiple) {
                    value = [];
                    for (groupIndex = 0, groupLength = optionGroupsCache.length; groupIndex < groupLength; groupIndex++) {
                      optionGroup = optionGroupsCache[groupIndex];
                      for (index = 1, length = optionGroup.length; index < length; index++) {
                        if ((optionElement = optionGroup[index].element)[0].selected) {
                          key = optionElement.val();
                          if (keyName)
                            locals[keyName] = key;
                          locals[valueName] = collection[key];
                          value.push(valueFn(scope, locals));
                        }
                      }
                    }
                  } else {
                    key = selectElement.val();
                    if (key == '?') {
                      value = undefined;
                    } else if (key == '') {
                      value = null;
                    } else {
                      locals[valueName] = collection[key];
                      if (keyName)
                        locals[keyName] = key;
                      value = valueFn(scope, locals);
                    }
                  }
                  ctrl.$setViewValue(value);
                });
              });
              ctrl.$render = render;
              scope.$watch(render);
              function render() {
                var optionGroups = { '': [] }, optionGroupNames = [''], optionGroupName, optionGroup, option, existingParent, existingOptions, existingOption, modelValue = ctrl.$modelValue, values = valuesFn(scope) || [], keys = keyName ? sortedKeys(values) : values, groupLength, length, groupIndex, index, locals = {}, selected, selectedSet = false, lastElement, element, label;
                if (multiple) {
                  selectedSet = new HashMap(modelValue);
                }
                for (index = 0; length = keys.length, index < length; index++) {
                  locals[valueName] = values[keyName ? locals[keyName] = keys[index] : index];
                  optionGroupName = groupByFn(scope, locals) || '';
                  if (!(optionGroup = optionGroups[optionGroupName])) {
                    optionGroup = optionGroups[optionGroupName] = [];
                    optionGroupNames.push(optionGroupName);
                  }
                  if (multiple) {
                    selected = selectedSet.remove(valueFn(scope, locals)) != undefined;
                  } else {
                    selected = modelValue === valueFn(scope, locals);
                    selectedSet = selectedSet || selected;
                  }
                  label = displayFn(scope, locals);
                  label = label === undefined ? '' : label;
                  optionGroup.push({
                    id: keyName ? keys[index] : index,
                    label: label,
                    selected: selected
                  });
                }
                if (!multiple) {
                  if (nullOption || modelValue === null) {
                    optionGroups[''].unshift({
                      id: '',
                      label: '',
                      selected: !selectedSet
                    });
                  } else if (!selectedSet) {
                    optionGroups[''].unshift({
                      id: '?',
                      label: '',
                      selected: true
                    });
                  }
                }
                for (groupIndex = 0, groupLength = optionGroupNames.length; groupIndex < groupLength; groupIndex++) {
                  optionGroupName = optionGroupNames[groupIndex];
                  optionGroup = optionGroups[optionGroupName];
                  if (optionGroupsCache.length <= groupIndex) {
                    existingParent = {
                      element: optGroupTemplate.clone().attr('label', optionGroupName),
                      label: optionGroup.label
                    };
                    existingOptions = [existingParent];
                    optionGroupsCache.push(existingOptions);
                    selectElement.append(existingParent.element);
                  } else {
                    existingOptions = optionGroupsCache[groupIndex];
                    existingParent = existingOptions[0];
                    if (existingParent.label != optionGroupName) {
                      existingParent.element.attr('label', existingParent.label = optionGroupName);
                    }
                  }
                  lastElement = null;
                  for (index = 0, length = optionGroup.length; index < length; index++) {
                    option = optionGroup[index];
                    if (existingOption = existingOptions[index + 1]) {
                      lastElement = existingOption.element;
                      if (existingOption.label !== option.label) {
                        lastElement.text(existingOption.label = option.label);
                      }
                      if (existingOption.id !== option.id) {
                        lastElement.val(existingOption.id = option.id);
                      }
                      if (lastElement[0].selected !== option.selected) {
                        lastElement.prop('selected', existingOption.selected = option.selected);
                      }
                    } else {
                      if (option.id === '' && nullOption) {
                        element = nullOption;
                      } else {
                        (element = optionTemplate.clone()).val(option.id).attr('selected', option.selected).text(option.label);
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
                  index++;
                  while (existingOptions.length > index) {
                    existingOptions.pop().element.remove();
                  }
                }
                while (optionGroupsCache.length > groupIndex) {
                  optionGroupsCache.pop()[0].element.remove();
                }
              }
            }
          }
        };
      }
    ];
  var optionDirective = [
      '$interpolate',
      function ($interpolate) {
        var nullSelectCtrl = {
            addOption: noop,
            removeOption: noop
          };
        return {
          restrict: 'E',
          priority: 100,
          compile: function (element, attr) {
            if (isUndefined(attr.value)) {
              var interpolateFn = $interpolate(element.text(), true);
              if (!interpolateFn) {
                attr.$set('value', element.text());
              }
            }
            return function (scope, element, attr) {
              var selectCtrlName = '$selectController', parent = element.parent(), selectCtrl = parent.data(selectCtrlName) || parent.parent().data(selectCtrlName);
              if (selectCtrl && selectCtrl.databound) {
                element.prop('selected', false);
              } else {
                selectCtrl = nullSelectCtrl;
              }
              if (interpolateFn) {
                scope.$watch(interpolateFn, function interpolateWatchAction(newVal, oldVal) {
                  attr.$set('value', newVal);
                  if (newVal !== oldVal)
                    selectCtrl.removeOption(oldVal);
                  selectCtrl.addOption(newVal);
                });
              } else {
                selectCtrl.addOption(attr.value);
              }
              element.bind('$destroy', function () {
                selectCtrl.removeOption(attr.value);
              });
            };
          }
        };
      }
    ];
  var styleDirective = valueFn({
      restrict: 'E',
      terminal: true
    });
  bindJQuery();
  publishExternalAPI(angular);
  jqLite(document).ready(function () {
    angularInit(document, bootstrap);
  });
}(window, document));
angular.element(document).find('head').append('<style type="text/css">@charset "UTF-8";[ng\\:cloak],[ng-cloak],[data-ng-cloak],[x-ng-cloak],.ng-cloak,.x-ng-cloak{display:none;}ng\\:form{display:block;}</style>');
var Chart = function (s) {
  function v(a, c, b) {
    a = A((a - c.graphMin) / (c.steps * c.stepValue), 1, 0);
    return b * c.steps * a;
  }
  function x(a, c, b, e) {
    function h() {
      g += f;
      var k = a.animation ? A(d(g), null, 0) : 1;
      e.clearRect(0, 0, q, u);
      a.scaleOverlay ? (b(k), c()) : (c(), b(k));
      if (1 >= g)
        D(h);
      else if ('function' == typeof a.onAnimationComplete)
        a.onAnimationComplete();
    }
    var f = a.animation ? 1 / A(a.animationSteps, Number.MAX_VALUE, 1) : 1, d = B[a.animationEasing], g = a.animation ? 0 : 1;
    'function' !== typeof c && (c = function () {
    });
    D(h);
  }
  function C(a, c, b, e, h, f) {
    var d;
    a = Math.floor(Math.log(e - h) / Math.LN10);
    h = Math.floor(h / (1 * Math.pow(10, a))) * Math.pow(10, a);
    e = Math.ceil(e / (1 * Math.pow(10, a))) * Math.pow(10, a) - h;
    a = Math.pow(10, a);
    for (d = Math.round(e / a); d < b || d > c;)
      a = d < b ? a / 2 : 2 * a, d = Math.round(e / a);
    c = [];
    z(f, c, d, h, a);
    return {
      steps: d,
      stepValue: a,
      graphMin: h,
      labels: c
    };
  }
  function z(a, c, b, e, h) {
    if (a)
      for (var f = 1; f < b + 1; f++)
        c.push(E(a, { value: (e + h * f).toFixed(0 != h % 1 ? h.toString().split('.')[1].length : 0) }));
  }
  function A(a, c, b) {
    return !isNaN(parseFloat(c)) && isFinite(c) && a > c ? c : !isNaN(parseFloat(b)) && isFinite(b) && a < b ? b : a;
  }
  function y(a, c) {
    var b = {}, e;
    for (e in a)
      b[e] = a[e];
    for (e in c)
      b[e] = c[e];
    return b;
  }
  function E(a, c) {
    var b = !/\W/.test(a) ? F[a] = F[a] || E(document.getElementById(a).innerHTML) : new Function('obj', 'var p=[],print=function(){p.push.apply(p,arguments);};with(obj){p.push(\'' + a.replace(/[\r\t\n]/g, ' ').split('<%').join('\t').replace(/((^|%>)[^\t]*)'/g, '$1\r').replace(/\t=(.*?)%>/g, '\',$1,\'').split('\t').join('\');').split('%>').join('p.push(\'').split('\r').join('\\\'') + '\');}return p.join(\'\');');
    return c ? b(c) : b;
  }
  var r = this, B = {
      linear: function (a) {
        return a;
      },
      easeInQuad: function (a) {
        return a * a;
      },
      easeOutQuad: function (a) {
        return -1 * a * (a - 2);
      },
      easeInOutQuad: function (a) {
        return 1 > (a /= 0.5) ? 0.5 * a * a : -0.5 * (--a * (a - 2) - 1);
      },
      easeInCubic: function (a) {
        return a * a * a;
      },
      easeOutCubic: function (a) {
        return 1 * ((a = a / 1 - 1) * a * a + 1);
      },
      easeInOutCubic: function (a) {
        return 1 > (a /= 0.5) ? 0.5 * a * a * a : 0.5 * ((a -= 2) * a * a + 2);
      },
      easeInQuart: function (a) {
        return a * a * a * a;
      },
      easeOutQuart: function (a) {
        return -1 * ((a = a / 1 - 1) * a * a * a - 1);
      },
      easeInOutQuart: function (a) {
        return 1 > (a /= 0.5) ? 0.5 * a * a * a * a : -0.5 * ((a -= 2) * a * a * a - 2);
      },
      easeInQuint: function (a) {
        return 1 * (a /= 1) * a * a * a * a;
      },
      easeOutQuint: function (a) {
        return 1 * ((a = a / 1 - 1) * a * a * a * a + 1);
      },
      easeInOutQuint: function (a) {
        return 1 > (a /= 0.5) ? 0.5 * a * a * a * a * a : 0.5 * ((a -= 2) * a * a * a * a + 2);
      },
      easeInSine: function (a) {
        return -1 * Math.cos(a / 1 * (Math.PI / 2)) + 1;
      },
      easeOutSine: function (a) {
        return 1 * Math.sin(a / 1 * (Math.PI / 2));
      },
      easeInOutSine: function (a) {
        return -0.5 * (Math.cos(Math.PI * a / 1) - 1);
      },
      easeInExpo: function (a) {
        return 0 == a ? 1 : 1 * Math.pow(2, 10 * (a / 1 - 1));
      },
      easeOutExpo: function (a) {
        return 1 == a ? 1 : 1 * (-Math.pow(2, -10 * a / 1) + 1);
      },
      easeInOutExpo: function (a) {
        return 0 == a ? 0 : 1 == a ? 1 : 1 > (a /= 0.5) ? 0.5 * Math.pow(2, 10 * (a - 1)) : 0.5 * (-Math.pow(2, -10 * --a) + 2);
      },
      easeInCirc: function (a) {
        return 1 <= a ? a : -1 * (Math.sqrt(1 - (a /= 1) * a) - 1);
      },
      easeOutCirc: function (a) {
        return 1 * Math.sqrt(1 - (a = a / 1 - 1) * a);
      },
      easeInOutCirc: function (a) {
        return 1 > (a /= 0.5) ? -0.5 * (Math.sqrt(1 - a * a) - 1) : 0.5 * (Math.sqrt(1 - (a -= 2) * a) + 1);
      },
      easeInElastic: function (a) {
        var c = 1.70158, b = 0, e = 1;
        if (0 == a)
          return 0;
        if (1 == (a /= 1))
          return 1;
        b || (b = 0.3);
        e < Math.abs(1) ? (e = 1, c = b / 4) : c = b / (2 * Math.PI) * Math.asin(1 / e);
        return -(e * Math.pow(2, 10 * (a -= 1)) * Math.sin((1 * a - c) * 2 * Math.PI / b));
      },
      easeOutElastic: function (a) {
        var c = 1.70158, b = 0, e = 1;
        if (0 == a)
          return 0;
        if (1 == (a /= 1))
          return 1;
        b || (b = 0.3);
        e < Math.abs(1) ? (e = 1, c = b / 4) : c = b / (2 * Math.PI) * Math.asin(1 / e);
        return e * Math.pow(2, -10 * a) * Math.sin((1 * a - c) * 2 * Math.PI / b) + 1;
      },
      easeInOutElastic: function (a) {
        var c = 1.70158, b = 0, e = 1;
        if (0 == a)
          return 0;
        if (2 == (a /= 0.5))
          return 1;
        b || (b = 1 * 0.3 * 1.5);
        e < Math.abs(1) ? (e = 1, c = b / 4) : c = b / (2 * Math.PI) * Math.asin(1 / e);
        return 1 > a ? -0.5 * e * Math.pow(2, 10 * (a -= 1)) * Math.sin((1 * a - c) * 2 * Math.PI / b) : 0.5 * e * Math.pow(2, -10 * (a -= 1)) * Math.sin((1 * a - c) * 2 * Math.PI / b) + 1;
      },
      easeInBack: function (a) {
        return 1 * (a /= 1) * a * (2.70158 * a - 1.70158);
      },
      easeOutBack: function (a) {
        return 1 * ((a = a / 1 - 1) * a * (2.70158 * a + 1.70158) + 1);
      },
      easeInOutBack: function (a) {
        var c = 1.70158;
        return 1 > (a /= 0.5) ? 0.5 * a * a * (((c *= 1.525) + 1) * a - c) : 0.5 * ((a -= 2) * a * (((c *= 1.525) + 1) * a + c) + 2);
      },
      easeInBounce: function (a) {
        return 1 - B.easeOutBounce(1 - a);
      },
      easeOutBounce: function (a) {
        return (a /= 1) < 1 / 2.75 ? 1 * 7.5625 * a * a : a < 2 / 2.75 ? 1 * (7.5625 * (a -= 1.5 / 2.75) * a + 0.75) : a < 2.5 / 2.75 ? 1 * (7.5625 * (a -= 2.25 / 2.75) * a + 0.9375) : 1 * (7.5625 * (a -= 2.625 / 2.75) * a + 0.984375);
      },
      easeInOutBounce: function (a) {
        return 0.5 > a ? 0.5 * B.easeInBounce(2 * a) : 0.5 * B.easeOutBounce(2 * a - 1) + 0.5;
      }
    }, q = s.canvas.width, u = s.canvas.height;
  window.devicePixelRatio && (s.canvas.style.width = q + 'px', s.canvas.style.height = u + 'px', s.canvas.height = u * window.devicePixelRatio, s.canvas.width = q * window.devicePixelRatio, s.scale(window.devicePixelRatio, window.devicePixelRatio));
  this.PolarArea = function (a, c) {
    r.PolarArea.defaults = {
      scaleOverlay: !0,
      scaleOverride: !1,
      scaleSteps: null,
      scaleStepWidth: null,
      scaleStartValue: null,
      scaleShowLine: !0,
      scaleLineColor: 'rgba(0,0,0,.1)',
      scaleLineWidth: 1,
      scaleShowLabels: !0,
      scaleLabel: '<%=value%>',
      scaleFontFamily: '\'Arial\'',
      scaleFontSize: 12,
      scaleFontStyle: 'normal',
      scaleFontColor: '#666',
      scaleShowLabelBackdrop: !0,
      scaleBackdropColor: 'rgba(255,255,255,0.75)',
      scaleBackdropPaddingY: 2,
      scaleBackdropPaddingX: 2,
      segmentShowStroke: !0,
      segmentStrokeColor: '#fff',
      segmentStrokeWidth: 2,
      animation: !0,
      animationSteps: 100,
      animationEasing: 'easeOutBounce',
      animateRotate: !0,
      animateScale: !1,
      onAnimationComplete: null
    };
    var b = c ? y(r.PolarArea.defaults, c) : r.PolarArea.defaults;
    return new G(a, b, s);
  };
  this.Radar = function (a, c) {
    r.Radar.defaults = {
      scaleOverlay: !1,
      scaleOverride: !1,
      scaleSteps: null,
      scaleStepWidth: null,
      scaleStartValue: null,
      scaleShowLine: !0,
      scaleLineColor: 'rgba(0,0,0,.1)',
      scaleLineWidth: 1,
      scaleShowLabels: !1,
      scaleLabel: '<%=value%>',
      scaleFontFamily: '\'Arial\'',
      scaleFontSize: 12,
      scaleFontStyle: 'normal',
      scaleFontColor: '#666',
      scaleShowLabelBackdrop: !0,
      scaleBackdropColor: 'rgba(255,255,255,0.75)',
      scaleBackdropPaddingY: 2,
      scaleBackdropPaddingX: 2,
      angleShowLineOut: !0,
      angleLineColor: 'rgba(0,0,0,.1)',
      angleLineWidth: 1,
      pointLabelFontFamily: '\'Arial\'',
      pointLabelFontStyle: 'normal',
      pointLabelFontSize: 12,
      pointLabelFontColor: '#666',
      pointDot: !0,
      pointDotRadius: 3,
      pointDotStrokeWidth: 1,
      datasetStroke: !0,
      datasetStrokeWidth: 2,
      datasetFill: !0,
      animation: !0,
      animationSteps: 60,
      animationEasing: 'easeOutQuart',
      onAnimationComplete: null
    };
    var b = c ? y(r.Radar.defaults, c) : r.Radar.defaults;
    return new H(a, b, s);
  };
  this.Pie = function (a, c) {
    r.Pie.defaults = {
      segmentShowStroke: !0,
      segmentStrokeColor: '#fff',
      segmentStrokeWidth: 2,
      animation: !0,
      animationSteps: 100,
      animationEasing: 'easeOutBounce',
      animateRotate: !0,
      animateScale: !1,
      onAnimationComplete: null
    };
    var b = c ? y(r.Pie.defaults, c) : r.Pie.defaults;
    return new I(a, b, s);
  };
  this.Doughnut = function (a, c) {
    r.Doughnut.defaults = {
      segmentShowStroke: !0,
      segmentStrokeColor: '#fff',
      segmentStrokeWidth: 2,
      percentageInnerCutout: 50,
      animation: !0,
      animationSteps: 100,
      animationEasing: 'easeOutBounce',
      animateRotate: !0,
      animateScale: !1,
      onAnimationComplete: null
    };
    var b = c ? y(r.Doughnut.defaults, c) : r.Doughnut.defaults;
    return new J(a, b, s);
  };
  this.Line = function (a, c) {
    r.Line.defaults = {
      scaleOverlay: !1,
      scaleOverride: !1,
      scaleSteps: null,
      scaleStepWidth: null,
      scaleStartValue: null,
      scaleLineColor: 'rgba(0,0,0,.1)',
      scaleLineWidth: 1,
      scaleShowLabels: !0,
      scaleLabel: '<%=value%>',
      scaleFontFamily: '\'Arial\'',
      scaleFontSize: 12,
      scaleFontStyle: 'normal',
      scaleFontColor: '#666',
      scaleShowGridLines: !0,
      scaleGridLineColor: 'rgba(0,0,0,.05)',
      scaleGridLineWidth: 1,
      bezierCurve: !0,
      pointDot: !0,
      pointDotRadius: 4,
      pointDotStrokeWidth: 2,
      datasetStroke: !0,
      datasetStrokeWidth: 2,
      datasetFill: !0,
      animation: !0,
      animationSteps: 60,
      animationEasing: 'easeOutQuart',
      onAnimationComplete: null
    };
    var b = c ? y(r.Line.defaults, c) : r.Line.defaults;
    return new K(a, b, s);
  };
  this.Bar = function (a, c) {
    r.Bar.defaults = {
      scaleOverlay: !1,
      scaleOverride: !1,
      scaleSteps: null,
      scaleStepWidth: null,
      scaleStartValue: null,
      scaleLineColor: 'rgba(0,0,0,.1)',
      scaleLineWidth: 1,
      scaleShowLabels: !0,
      scaleLabel: '<%=value%>',
      scaleFontFamily: '\'Arial\'',
      scaleFontSize: 12,
      scaleFontStyle: 'normal',
      scaleFontColor: '#666',
      scaleShowGridLines: !0,
      scaleGridLineColor: 'rgba(0,0,0,.05)',
      scaleGridLineWidth: 1,
      barShowStroke: !0,
      barStrokeWidth: 2,
      barValueSpacing: 5,
      barDatasetSpacing: 1,
      animation: !0,
      animationSteps: 60,
      animationEasing: 'easeOutQuart',
      onAnimationComplete: null
    };
    var b = c ? y(r.Bar.defaults, c) : r.Bar.defaults;
    return new L(a, b, s);
  };
  var G = function (a, c, b) {
      var e, h, f, d, g, k, j, l, m;
      g = Math.min.apply(Math, [
        q,
        u
      ]) / 2;
      g -= Math.max.apply(Math, [
        0.5 * c.scaleFontSize,
        0.5 * c.scaleLineWidth
      ]);
      d = 2 * c.scaleFontSize;
      c.scaleShowLabelBackdrop && (d += 2 * c.scaleBackdropPaddingY, g -= 1.5 * c.scaleBackdropPaddingY);
      l = g;
      d = d ? d : 5;
      e = Number.MIN_VALUE;
      h = Number.MAX_VALUE;
      for (f = 0; f < a.length; f++)
        a[f].value > e && (e = a[f].value), a[f].value < h && (h = a[f].value);
      f = Math.floor(l / (0.66 * d));
      d = Math.floor(0.5 * (l / d));
      m = c.scaleShowLabels ? c.scaleLabel : null;
      c.scaleOverride ? (j = {
        steps: c.scaleSteps,
        stepValue: c.scaleStepWidth,
        graphMin: c.scaleStartValue,
        labels: []
      }, z(m, j.labels, j.steps, c.scaleStartValue, c.scaleStepWidth)) : j = C(l, f, d, e, h, m);
      k = g / j.steps;
      x(c, function () {
        for (var a = 0; a < j.steps; a++)
          if (c.scaleShowLine && (b.beginPath(), b.arc(q / 2, u / 2, k * (a + 1), 0, 2 * Math.PI, !0), b.strokeStyle = c.scaleLineColor, b.lineWidth = c.scaleLineWidth, b.stroke()), c.scaleShowLabels) {
            b.textAlign = 'center';
            b.font = c.scaleFontStyle + ' ' + c.scaleFontSize + 'px ' + c.scaleFontFamily;
            var e = j.labels[a];
            if (c.scaleShowLabelBackdrop) {
              var d = b.measureText(e).width;
              b.fillStyle = c.scaleBackdropColor;
              b.beginPath();
              b.rect(Math.round(q / 2 - d / 2 - c.scaleBackdropPaddingX), Math.round(u / 2 - k * (a + 1) - 0.5 * c.scaleFontSize - c.scaleBackdropPaddingY), Math.round(d + 2 * c.scaleBackdropPaddingX), Math.round(c.scaleFontSize + 2 * c.scaleBackdropPaddingY));
              b.fill();
            }
            b.textBaseline = 'middle';
            b.fillStyle = c.scaleFontColor;
            b.fillText(e, q / 2, u / 2 - k * (a + 1));
          }
      }, function (e) {
        var d = -Math.PI / 2, g = 2 * Math.PI / a.length, f = 1, h = 1;
        c.animation && (c.animateScale && (f = e), c.animateRotate && (h = e));
        for (e = 0; e < a.length; e++)
          b.beginPath(), b.arc(q / 2, u / 2, f * v(a[e].value, j, k), d, d + h * g, !1), b.lineTo(q / 2, u / 2), b.closePath(), b.fillStyle = a[e].color, b.fill(), c.segmentShowStroke && (b.strokeStyle = c.segmentStrokeColor, b.lineWidth = c.segmentStrokeWidth, b.stroke()), d += h * g;
      }, b);
    }, H = function (a, c, b) {
      var e, h, f, d, g, k, j, l, m;
      a.labels || (a.labels = []);
      g = Math.min.apply(Math, [
        q,
        u
      ]) / 2;
      d = 2 * c.scaleFontSize;
      for (e = l = 0; e < a.labels.length; e++)
        b.font = c.pointLabelFontStyle + ' ' + c.pointLabelFontSize + 'px ' + c.pointLabelFontFamily, h = b.measureText(a.labels[e]).width, h > l && (l = h);
      g -= Math.max.apply(Math, [
        l,
        1.5 * (c.pointLabelFontSize / 2)
      ]);
      g -= c.pointLabelFontSize;
      l = g = A(g, null, 0);
      d = d ? d : 5;
      e = Number.MIN_VALUE;
      h = Number.MAX_VALUE;
      for (f = 0; f < a.datasets.length; f++)
        for (m = 0; m < a.datasets[f].data.length; m++)
          a.datasets[f].data[m] > e && (e = a.datasets[f].data[m]), a.datasets[f].data[m] < h && (h = a.datasets[f].data[m]);
      f = Math.floor(l / (0.66 * d));
      d = Math.floor(0.5 * (l / d));
      m = c.scaleShowLabels ? c.scaleLabel : null;
      c.scaleOverride ? (j = {
        steps: c.scaleSteps,
        stepValue: c.scaleStepWidth,
        graphMin: c.scaleStartValue,
        labels: []
      }, z(m, j.labels, j.steps, c.scaleStartValue, c.scaleStepWidth)) : j = C(l, f, d, e, h, m);
      k = g / j.steps;
      x(c, function () {
        var e = 2 * Math.PI / a.datasets[0].data.length;
        b.save();
        b.translate(q / 2, u / 2);
        if (c.angleShowLineOut) {
          b.strokeStyle = c.angleLineColor;
          b.lineWidth = c.angleLineWidth;
          for (var d = 0; d < a.datasets[0].data.length; d++)
            b.rotate(e), b.beginPath(), b.moveTo(0, 0), b.lineTo(0, -g), b.stroke();
        }
        for (d = 0; d < j.steps; d++) {
          b.beginPath();
          if (c.scaleShowLine) {
            b.strokeStyle = c.scaleLineColor;
            b.lineWidth = c.scaleLineWidth;
            b.moveTo(0, -k * (d + 1));
            for (var f = 0; f < a.datasets[0].data.length; f++)
              b.rotate(e), b.lineTo(0, -k * (d + 1));
            b.closePath();
            b.stroke();
          }
          c.scaleShowLabels && (b.textAlign = 'center', b.font = c.scaleFontStyle + ' ' + c.scaleFontSize + 'px ' + c.scaleFontFamily, b.textBaseline = 'middle', c.scaleShowLabelBackdrop && (f = b.measureText(j.labels[d]).width, b.fillStyle = c.scaleBackdropColor, b.beginPath(), b.rect(Math.round(-f / 2 - c.scaleBackdropPaddingX), Math.round(-k * (d + 1) - 0.5 * c.scaleFontSize - c.scaleBackdropPaddingY), Math.round(f + 2 * c.scaleBackdropPaddingX), Math.round(c.scaleFontSize + 2 * c.scaleBackdropPaddingY)), b.fill()), b.fillStyle = c.scaleFontColor, b.fillText(j.labels[d], 0, -k * (d + 1)));
        }
        for (d = 0; d < a.labels.length; d++) {
          b.font = c.pointLabelFontStyle + ' ' + c.pointLabelFontSize + 'px ' + c.pointLabelFontFamily;
          b.fillStyle = c.pointLabelFontColor;
          var f = Math.sin(e * d) * (g + c.pointLabelFontSize), h = Math.cos(e * d) * (g + c.pointLabelFontSize);
          b.textAlign = e * d == Math.PI || 0 == e * d ? 'center' : e * d > Math.PI ? 'right' : 'left';
          b.textBaseline = 'middle';
          b.fillText(a.labels[d], f, -h);
        }
        b.restore();
      }, function (d) {
        var e = 2 * Math.PI / a.datasets[0].data.length;
        b.save();
        b.translate(q / 2, u / 2);
        for (var g = 0; g < a.datasets.length; g++) {
          b.beginPath();
          b.moveTo(0, d * -1 * v(a.datasets[g].data[0], j, k));
          for (var f = 1; f < a.datasets[g].data.length; f++)
            b.rotate(e), b.lineTo(0, d * -1 * v(a.datasets[g].data[f], j, k));
          b.closePath();
          b.fillStyle = a.datasets[g].fillColor;
          b.strokeStyle = a.datasets[g].strokeColor;
          b.lineWidth = c.datasetStrokeWidth;
          b.fill();
          b.stroke();
          if (c.pointDot) {
            b.fillStyle = a.datasets[g].pointColor;
            b.strokeStyle = a.datasets[g].pointStrokeColor;
            b.lineWidth = c.pointDotStrokeWidth;
            for (f = 0; f < a.datasets[g].data.length; f++)
              b.rotate(e), b.beginPath(), b.arc(0, d * -1 * v(a.datasets[g].data[f], j, k), c.pointDotRadius, 2 * Math.PI, !1), b.fill(), b.stroke();
          }
          b.rotate(e);
        }
        b.restore();
      }, b);
    }, I = function (a, c, b) {
      for (var e = 0, h = Math.min.apply(Math, [
            u / 2,
            q / 2
          ]) - 5, f = 0; f < a.length; f++)
        e += a[f].value;
      x(c, null, function (d) {
        var g = -Math.PI / 2, f = 1, j = 1;
        c.animation && (c.animateScale && (f = d), c.animateRotate && (j = d));
        for (d = 0; d < a.length; d++) {
          var l = j * a[d].value / e * 2 * Math.PI;
          b.beginPath();
          b.arc(q / 2, u / 2, f * h, g, g + l);
          b.lineTo(q / 2, u / 2);
          b.closePath();
          b.fillStyle = a[d].color;
          b.fill();
          c.segmentShowStroke && (b.lineWidth = c.segmentStrokeWidth, b.strokeStyle = c.segmentStrokeColor, b.stroke());
          g += l;
        }
      }, b);
    }, J = function (a, c, b) {
      for (var e = 0, h = Math.min.apply(Math, [
            u / 2,
            q / 2
          ]) - 5, f = h * (c.percentageInnerCutout / 100), d = 0; d < a.length; d++)
        e += a[d].value;
      x(c, null, function (d) {
        var k = -Math.PI / 2, j = 1, l = 1;
        c.animation && (c.animateScale && (j = d), c.animateRotate && (l = d));
        for (d = 0; d < a.length; d++) {
          var m = l * a[d].value / e * 2 * Math.PI;
          b.beginPath();
          b.arc(q / 2, u / 2, j * h, k, k + m, !1);
          b.arc(q / 2, u / 2, j * f, k + m, k, !0);
          b.closePath();
          b.fillStyle = a[d].color;
          b.fill();
          c.segmentShowStroke && (b.lineWidth = c.segmentStrokeWidth, b.strokeStyle = c.segmentStrokeColor, b.stroke());
          k += m;
        }
      }, b);
    }, K = function (a, c, b) {
      var e, h, f, d, g, k, j, l, m, t, r, n, p, s = 0;
      g = u;
      b.font = c.scaleFontStyle + ' ' + c.scaleFontSize + 'px ' + c.scaleFontFamily;
      t = 1;
      for (d = 0; d < a.labels.length; d++)
        e = b.measureText(a.labels[d]).width, t = e > t ? e : t;
      q / a.labels.length < t ? (s = 45, q / a.labels.length < Math.cos(s) * t ? (s = 90, g -= t) : g -= Math.sin(s) * t) : g -= c.scaleFontSize;
      d = c.scaleFontSize;
      g = g - 5 - d;
      e = Number.MIN_VALUE;
      h = Number.MAX_VALUE;
      for (f = 0; f < a.datasets.length; f++)
        for (l = 0; l < a.datasets[f].data.length; l++)
          a.datasets[f].data[l] > e && (e = a.datasets[f].data[l]), a.datasets[f].data[l] < h && (h = a.datasets[f].data[l]);
      f = Math.floor(g / (0.66 * d));
      d = Math.floor(0.5 * (g / d));
      l = c.scaleShowLabels ? c.scaleLabel : '';
      c.scaleOverride ? (j = {
        steps: c.scaleSteps,
        stepValue: c.scaleStepWidth,
        graphMin: c.scaleStartValue,
        labels: []
      }, z(l, j.labels, j.steps, c.scaleStartValue, c.scaleStepWidth)) : j = C(g, f, d, e, h, l);
      k = Math.floor(g / j.steps);
      d = 1;
      if (c.scaleShowLabels) {
        b.font = c.scaleFontStyle + ' ' + c.scaleFontSize + 'px ' + c.scaleFontFamily;
        for (e = 0; e < j.labels.length; e++)
          h = b.measureText(j.labels[e]).width, d = h > d ? h : d;
        d += 10;
      }
      r = q - d - t;
      m = Math.floor(r / (a.labels.length - 1));
      n = q - t / 2 - r;
      p = g + c.scaleFontSize / 2;
      x(c, function () {
        b.lineWidth = c.scaleLineWidth;
        b.strokeStyle = c.scaleLineColor;
        b.beginPath();
        b.moveTo(q - t / 2 + 5, p);
        b.lineTo(q - t / 2 - r - 5, p);
        b.stroke();
        0 < s ? (b.save(), b.textAlign = 'right') : b.textAlign = 'center';
        b.fillStyle = c.scaleFontColor;
        for (var d = 0; d < a.labels.length; d++)
          b.save(), 0 < s ? (b.translate(n + d * m, p + c.scaleFontSize), b.rotate(-(s * (Math.PI / 180))), b.fillText(a.labels[d], 0, 0), b.restore()) : b.fillText(a.labels[d], n + d * m, p + c.scaleFontSize + 3), b.beginPath(), b.moveTo(n + d * m, p + 3), c.scaleShowGridLines && 0 < d ? (b.lineWidth = c.scaleGridLineWidth, b.strokeStyle = c.scaleGridLineColor, b.lineTo(n + d * m, 5)) : b.lineTo(n + d * m, p + 3), b.stroke();
        b.lineWidth = c.scaleLineWidth;
        b.strokeStyle = c.scaleLineColor;
        b.beginPath();
        b.moveTo(n, p + 5);
        b.lineTo(n, 5);
        b.stroke();
        b.textAlign = 'right';
        b.textBaseline = 'middle';
        for (d = 0; d < j.steps; d++)
          b.beginPath(), b.moveTo(n - 3, p - (d + 1) * k), c.scaleShowGridLines ? (b.lineWidth = c.scaleGridLineWidth, b.strokeStyle = c.scaleGridLineColor, b.lineTo(n + r + 5, p - (d + 1) * k)) : b.lineTo(n - 0.5, p - (d + 1) * k), b.stroke(), c.scaleShowLabels && b.fillText(j.labels[d], n - 8, p - (d + 1) * k);
      }, function (d) {
        function e(b, c) {
          return p - d * v(a.datasets[b].data[c], j, k);
        }
        for (var f = 0; f < a.datasets.length; f++) {
          b.strokeStyle = a.datasets[f].strokeColor;
          b.lineWidth = c.datasetStrokeWidth;
          b.beginPath();
          b.moveTo(n, p - d * v(a.datasets[f].data[0], j, k));
          for (var g = 1; g < a.datasets[f].data.length; g++)
            c.bezierCurve ? b.bezierCurveTo(n + m * (g - 0.5), e(f, g - 1), n + m * (g - 0.5), e(f, g), n + m * g, e(f, g)) : b.lineTo(n + m * g, e(f, g));
          b.stroke();
          c.datasetFill ? (b.lineTo(n + m * (a.datasets[f].data.length - 1), p), b.lineTo(n, p), b.closePath(), b.fillStyle = a.datasets[f].fillColor, b.fill()) : b.closePath();
          if (c.pointDot) {
            b.fillStyle = a.datasets[f].pointColor;
            b.strokeStyle = a.datasets[f].pointStrokeColor;
            b.lineWidth = c.pointDotStrokeWidth;
            for (g = 0; g < a.datasets[f].data.length; g++)
              b.beginPath(), b.arc(n + m * g, p - d * v(a.datasets[f].data[g], j, k), c.pointDotRadius, 0, 2 * Math.PI, !0), b.fill(), b.stroke();
          }
        }
      }, b);
    }, L = function (a, c, b) {
      var e, h, f, d, g, k, j, l, m, t, r, n, p, s, w = 0;
      g = u;
      b.font = c.scaleFontStyle + ' ' + c.scaleFontSize + 'px ' + c.scaleFontFamily;
      t = 1;
      for (d = 0; d < a.labels.length; d++)
        e = b.measureText(a.labels[d]).width, t = e > t ? e : t;
      q / a.labels.length < t ? (w = 45, q / a.labels.length < Math.cos(w) * t ? (w = 90, g -= t) : g -= Math.sin(w) * t) : g -= c.scaleFontSize;
      d = c.scaleFontSize;
      g = g - 5 - d;
      e = Number.MIN_VALUE;
      h = Number.MAX_VALUE;
      for (f = 0; f < a.datasets.length; f++)
        for (l = 0; l < a.datasets[f].data.length; l++)
          a.datasets[f].data[l] > e && (e = a.datasets[f].data[l]), a.datasets[f].data[l] < h && (h = a.datasets[f].data[l]);
      f = Math.floor(g / (0.66 * d));
      d = Math.floor(0.5 * (g / d));
      l = c.scaleShowLabels ? c.scaleLabel : '';
      c.scaleOverride ? (j = {
        steps: c.scaleSteps,
        stepValue: c.scaleStepWidth,
        graphMin: c.scaleStartValue,
        labels: []
      }, z(l, j.labels, j.steps, c.scaleStartValue, c.scaleStepWidth)) : j = C(g, f, d, e, h, l);
      k = Math.floor(g / j.steps);
      d = 1;
      if (c.scaleShowLabels) {
        b.font = c.scaleFontStyle + ' ' + c.scaleFontSize + 'px ' + c.scaleFontFamily;
        for (e = 0; e < j.labels.length; e++)
          h = b.measureText(j.labels[e]).width, d = h > d ? h : d;
        d += 10;
      }
      r = q - d - t;
      m = Math.floor(r / a.labels.length);
      s = (m - 2 * c.scaleGridLineWidth - 2 * c.barValueSpacing - (c.barDatasetSpacing * a.datasets.length - 1) - (c.barStrokeWidth / 2 * a.datasets.length - 1)) / a.datasets.length;
      n = q - t / 2 - r;
      p = g + c.scaleFontSize / 2;
      x(c, function () {
        b.lineWidth = c.scaleLineWidth;
        b.strokeStyle = c.scaleLineColor;
        b.beginPath();
        b.moveTo(q - t / 2 + 5, p);
        b.lineTo(q - t / 2 - r - 5, p);
        b.stroke();
        0 < w ? (b.save(), b.textAlign = 'right') : b.textAlign = 'center';
        b.fillStyle = c.scaleFontColor;
        for (var d = 0; d < a.labels.length; d++)
          b.save(), 0 < w ? (b.translate(n + d * m, p + c.scaleFontSize), b.rotate(-(w * (Math.PI / 180))), b.fillText(a.labels[d], 0, 0), b.restore()) : b.fillText(a.labels[d], n + d * m + m / 2, p + c.scaleFontSize + 3), b.beginPath(), b.moveTo(n + (d + 1) * m, p + 3), b.lineWidth = c.scaleGridLineWidth, b.strokeStyle = c.scaleGridLineColor, b.lineTo(n + (d + 1) * m, 5), b.stroke();
        b.lineWidth = c.scaleLineWidth;
        b.strokeStyle = c.scaleLineColor;
        b.beginPath();
        b.moveTo(n, p + 5);
        b.lineTo(n, 5);
        b.stroke();
        b.textAlign = 'right';
        b.textBaseline = 'middle';
        for (d = 0; d < j.steps; d++)
          b.beginPath(), b.moveTo(n - 3, p - (d + 1) * k), c.scaleShowGridLines ? (b.lineWidth = c.scaleGridLineWidth, b.strokeStyle = c.scaleGridLineColor, b.lineTo(n + r + 5, p - (d + 1) * k)) : b.lineTo(n - 0.5, p - (d + 1) * k), b.stroke(), c.scaleShowLabels && b.fillText(j.labels[d], n - 8, p - (d + 1) * k);
      }, function (d) {
        b.lineWidth = c.barStrokeWidth;
        for (var e = 0; e < a.datasets.length; e++) {
          b.fillStyle = a.datasets[e].fillColor;
          b.strokeStyle = a.datasets[e].strokeColor;
          for (var f = 0; f < a.datasets[e].data.length; f++) {
            var g = n + c.barValueSpacing + m * f + s * e + c.barDatasetSpacing * e + c.barStrokeWidth * e;
            b.beginPath();
            b.moveTo(g, p);
            b.lineTo(g, p - d * v(a.datasets[e].data[f], j, k) + c.barStrokeWidth / 2);
            b.lineTo(g + s, p - d * v(a.datasets[e].data[f], j, k) + c.barStrokeWidth / 2);
            b.lineTo(g + s, p);
            c.barShowStroke && b.stroke();
            b.closePath();
            b.fill();
          }
        }
      }, b);
    }, D = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || function (a) {
      window.setTimeout(a, 1000 / 60);
    }, F = {};
};
(function () {
  var root = this;
  var previousBackbone = root.Backbone;
  var array = [];
  var push = array.push;
  var slice = array.slice;
  var splice = array.splice;
  var Backbone;
  if (typeof exports !== 'undefined') {
    Backbone = exports;
  } else {
    Backbone = root.Backbone = {};
  }
  Backbone.VERSION = '1.0.0';
  var _ = root._;
  if (!_ && typeof require !== 'undefined')
    _ = require('underscore');
  Backbone.$ = root.jQuery || root.Zepto || root.ender || root.$;
  Backbone.noConflict = function () {
    root.Backbone = previousBackbone;
    return this;
  };
  Backbone.emulateHTTP = false;
  Backbone.emulateJSON = false;
  var Events = Backbone.Events = {
      on: function (name, callback, context) {
        if (!eventsApi(this, 'on', name, [
            callback,
            context
          ]) || !callback)
          return this;
        this._events || (this._events = {});
        var events = this._events[name] || (this._events[name] = []);
        events.push({
          callback: callback,
          context: context,
          ctx: context || this
        });
        return this;
      },
      once: function (name, callback, context) {
        if (!eventsApi(this, 'once', name, [
            callback,
            context
          ]) || !callback)
          return this;
        var self = this;
        var once = _.once(function () {
            self.off(name, once);
            callback.apply(this, arguments);
          });
        once._callback = callback;
        return this.on(name, once, context);
      },
      off: function (name, callback, context) {
        var retain, ev, events, names, i, l, j, k;
        if (!this._events || !eventsApi(this, 'off', name, [
            callback,
            context
          ]))
          return this;
        if (!name && !callback && !context) {
          this._events = {};
          return this;
        }
        names = name ? [name] : _.keys(this._events);
        for (i = 0, l = names.length; i < l; i++) {
          name = names[i];
          if (events = this._events[name]) {
            this._events[name] = retain = [];
            if (callback || context) {
              for (j = 0, k = events.length; j < k; j++) {
                ev = events[j];
                if (callback && callback !== ev.callback && callback !== ev.callback._callback || context && context !== ev.context) {
                  retain.push(ev);
                }
              }
            }
            if (!retain.length)
              delete this._events[name];
          }
        }
        return this;
      },
      trigger: function (name) {
        if (!this._events)
          return this;
        var args = slice.call(arguments, 1);
        if (!eventsApi(this, 'trigger', name, args))
          return this;
        var events = this._events[name];
        var allEvents = this._events.all;
        if (events)
          triggerEvents(events, args);
        if (allEvents)
          triggerEvents(allEvents, arguments);
        return this;
      },
      stopListening: function (obj, name, callback) {
        var listeners = this._listeners;
        if (!listeners)
          return this;
        var deleteListener = !name && !callback;
        if (typeof name === 'object')
          callback = this;
        if (obj)
          (listeners = {})[obj._listenerId] = obj;
        for (var id in listeners) {
          listeners[id].off(name, callback, this);
          if (deleteListener)
            delete this._listeners[id];
        }
        return this;
      }
    };
  var eventSplitter = /\s+/;
  var eventsApi = function (obj, action, name, rest) {
    if (!name)
      return true;
    if (typeof name === 'object') {
      for (var key in name) {
        obj[action].apply(obj, [
          key,
          name[key]
        ].concat(rest));
      }
      return false;
    }
    if (eventSplitter.test(name)) {
      var names = name.split(eventSplitter);
      for (var i = 0, l = names.length; i < l; i++) {
        obj[action].apply(obj, [names[i]].concat(rest));
      }
      return false;
    }
    return true;
  };
  var triggerEvents = function (events, args) {
    var ev, i = -1, l = events.length, a1 = args[0], a2 = args[1], a3 = args[2];
    switch (args.length) {
    case 0:
      while (++i < l)
        (ev = events[i]).callback.call(ev.ctx);
      return;
    case 1:
      while (++i < l)
        (ev = events[i]).callback.call(ev.ctx, a1);
      return;
    case 2:
      while (++i < l)
        (ev = events[i]).callback.call(ev.ctx, a1, a2);
      return;
    case 3:
      while (++i < l)
        (ev = events[i]).callback.call(ev.ctx, a1, a2, a3);
      return;
    default:
      while (++i < l)
        (ev = events[i]).callback.apply(ev.ctx, args);
    }
  };
  var listenMethods = {
      listenTo: 'on',
      listenToOnce: 'once'
    };
  _.each(listenMethods, function (implementation, method) {
    Events[method] = function (obj, name, callback) {
      var listeners = this._listeners || (this._listeners = {});
      var id = obj._listenerId || (obj._listenerId = _.uniqueId('l'));
      listeners[id] = obj;
      if (typeof name === 'object')
        callback = this;
      obj[implementation](name, callback, this);
      return this;
    };
  });
  Events.bind = Events.on;
  Events.unbind = Events.off;
  _.extend(Backbone, Events);
  var Model = Backbone.Model = function (attributes, options) {
      var defaults;
      var attrs = attributes || {};
      options || (options = {});
      this.cid = _.uniqueId('c');
      this.attributes = {};
      _.extend(this, _.pick(options, modelOptions));
      if (options.parse)
        attrs = this.parse(attrs, options) || {};
      if (defaults = _.result(this, 'defaults')) {
        attrs = _.defaults({}, attrs, defaults);
      }
      this.set(attrs, options);
      this.changed = {};
      this.initialize.apply(this, arguments);
    };
  var modelOptions = [
      'url',
      'urlRoot',
      'collection'
    ];
  _.extend(Model.prototype, Events, {
    changed: null,
    validationError: null,
    idAttribute: 'id',
    initialize: function () {
    },
    toJSON: function (options) {
      return _.clone(this.attributes);
    },
    sync: function () {
      return Backbone.sync.apply(this, arguments);
    },
    get: function (attr) {
      return this.attributes[attr];
    },
    escape: function (attr) {
      return _.escape(this.get(attr));
    },
    has: function (attr) {
      return this.get(attr) != null;
    },
    set: function (key, val, options) {
      var attr, attrs, unset, changes, silent, changing, prev, current;
      if (key == null)
        return this;
      if (typeof key === 'object') {
        attrs = key;
        options = val;
      } else {
        (attrs = {})[key] = val;
      }
      options || (options = {});
      if (!this._validate(attrs, options))
        return false;
      unset = options.unset;
      silent = options.silent;
      changes = [];
      changing = this._changing;
      this._changing = true;
      if (!changing) {
        this._previousAttributes = _.clone(this.attributes);
        this.changed = {};
      }
      current = this.attributes, prev = this._previousAttributes;
      if (this.idAttribute in attrs)
        this.id = attrs[this.idAttribute];
      for (attr in attrs) {
        val = attrs[attr];
        if (!_.isEqual(current[attr], val))
          changes.push(attr);
        if (!_.isEqual(prev[attr], val)) {
          this.changed[attr] = val;
        } else {
          delete this.changed[attr];
        }
        unset ? delete current[attr] : current[attr] = val;
      }
      if (!silent) {
        if (changes.length)
          this._pending = true;
        for (var i = 0, l = changes.length; i < l; i++) {
          this.trigger('change:' + changes[i], this, current[changes[i]], options);
        }
      }
      if (changing)
        return this;
      if (!silent) {
        while (this._pending) {
          this._pending = false;
          this.trigger('change', this, options);
        }
      }
      this._pending = false;
      this._changing = false;
      return this;
    },
    unset: function (attr, options) {
      return this.set(attr, void 0, _.extend({}, options, { unset: true }));
    },
    clear: function (options) {
      var attrs = {};
      for (var key in this.attributes)
        attrs[key] = void 0;
      return this.set(attrs, _.extend({}, options, { unset: true }));
    },
    hasChanged: function (attr) {
      if (attr == null)
        return !_.isEmpty(this.changed);
      return _.has(this.changed, attr);
    },
    changedAttributes: function (diff) {
      if (!diff)
        return this.hasChanged() ? _.clone(this.changed) : false;
      var val, changed = false;
      var old = this._changing ? this._previousAttributes : this.attributes;
      for (var attr in diff) {
        if (_.isEqual(old[attr], val = diff[attr]))
          continue;
        (changed || (changed = {}))[attr] = val;
      }
      return changed;
    },
    previous: function (attr) {
      if (attr == null || !this._previousAttributes)
        return null;
      return this._previousAttributes[attr];
    },
    previousAttributes: function () {
      return _.clone(this._previousAttributes);
    },
    fetch: function (options) {
      options = options ? _.clone(options) : {};
      if (options.parse === void 0)
        options.parse = true;
      var model = this;
      var success = options.success;
      options.success = function (resp) {
        if (!model.set(model.parse(resp, options), options))
          return false;
        if (success)
          success(model, resp, options);
        model.trigger('sync', model, resp, options);
      };
      wrapError(this, options);
      return this.sync('read', this, options);
    },
    save: function (key, val, options) {
      var attrs, method, xhr, attributes = this.attributes;
      if (key == null || typeof key === 'object') {
        attrs = key;
        options = val;
      } else {
        (attrs = {})[key] = val;
      }
      if (attrs && (!options || !options.wait) && !this.set(attrs, options))
        return false;
      options = _.extend({ validate: true }, options);
      if (!this._validate(attrs, options))
        return false;
      if (attrs && options.wait) {
        this.attributes = _.extend({}, attributes, attrs);
      }
      if (options.parse === void 0)
        options.parse = true;
      var model = this;
      var success = options.success;
      options.success = function (resp) {
        model.attributes = attributes;
        var serverAttrs = model.parse(resp, options);
        if (options.wait)
          serverAttrs = _.extend(attrs || {}, serverAttrs);
        if (_.isObject(serverAttrs) && !model.set(serverAttrs, options)) {
          return false;
        }
        if (success)
          success(model, resp, options);
        model.trigger('sync', model, resp, options);
      };
      wrapError(this, options);
      method = this.isNew() ? 'create' : options.patch ? 'patch' : 'update';
      if (method === 'patch')
        options.attrs = attrs;
      xhr = this.sync(method, this, options);
      if (attrs && options.wait)
        this.attributes = attributes;
      return xhr;
    },
    destroy: function (options) {
      options = options ? _.clone(options) : {};
      var model = this;
      var success = options.success;
      var destroy = function () {
        model.trigger('destroy', model, model.collection, options);
      };
      options.success = function (resp) {
        if (options.wait || model.isNew())
          destroy();
        if (success)
          success(model, resp, options);
        if (!model.isNew())
          model.trigger('sync', model, resp, options);
      };
      if (this.isNew()) {
        options.success();
        return false;
      }
      wrapError(this, options);
      var xhr = this.sync('delete', this, options);
      if (!options.wait)
        destroy();
      return xhr;
    },
    url: function () {
      var base = _.result(this, 'urlRoot') || _.result(this.collection, 'url') || urlError();
      if (this.isNew())
        return base;
      return base + (base.charAt(base.length - 1) === '/' ? '' : '/') + encodeURIComponent(this.id);
    },
    parse: function (resp, options) {
      return resp;
    },
    clone: function () {
      return new this.constructor(this.attributes);
    },
    isNew: function () {
      return this.id == null;
    },
    isValid: function (options) {
      return this._validate({}, _.extend(options || {}, { validate: true }));
    },
    _validate: function (attrs, options) {
      if (!options.validate || !this.validate)
        return true;
      attrs = _.extend({}, this.attributes, attrs);
      var error = this.validationError = this.validate(attrs, options) || null;
      if (!error)
        return true;
      this.trigger('invalid', this, error, _.extend(options || {}, { validationError: error }));
      return false;
    }
  });
  var modelMethods = [
      'keys',
      'values',
      'pairs',
      'invert',
      'pick',
      'omit'
    ];
  _.each(modelMethods, function (method) {
    Model.prototype[method] = function () {
      var args = slice.call(arguments);
      args.unshift(this.attributes);
      return _[method].apply(_, args);
    };
  });
  var Collection = Backbone.Collection = function (models, options) {
      options || (options = {});
      if (options.url)
        this.url = options.url;
      if (options.model)
        this.model = options.model;
      if (options.comparator !== void 0)
        this.comparator = options.comparator;
      this._reset();
      this.initialize.apply(this, arguments);
      if (models)
        this.reset(models, _.extend({ silent: true }, options));
    };
  var setOptions = {
      add: true,
      remove: true,
      merge: true
    };
  var addOptions = {
      add: true,
      merge: false,
      remove: false
    };
  _.extend(Collection.prototype, Events, {
    model: Model,
    initialize: function () {
    },
    toJSON: function (options) {
      return this.map(function (model) {
        return model.toJSON(options);
      });
    },
    sync: function () {
      return Backbone.sync.apply(this, arguments);
    },
    add: function (models, options) {
      return this.set(models, _.defaults(options || {}, addOptions));
    },
    remove: function (models, options) {
      models = _.isArray(models) ? models.slice() : [models];
      options || (options = {});
      var i, l, index, model;
      for (i = 0, l = models.length; i < l; i++) {
        model = this.get(models[i]);
        if (!model)
          continue;
        delete this._byId[model.id];
        delete this._byId[model.cid];
        index = this.indexOf(model);
        this.models.splice(index, 1);
        this.length--;
        if (!options.silent) {
          options.index = index;
          model.trigger('remove', model, this, options);
        }
        this._removeReference(model);
      }
      return this;
    },
    set: function (models, options) {
      options = _.defaults(options || {}, setOptions);
      if (options.parse)
        models = this.parse(models, options);
      if (!_.isArray(models))
        models = models ? [models] : [];
      var i, l, model, attrs, existing, sort;
      var at = options.at;
      var sortable = this.comparator && at == null && options.sort !== false;
      var sortAttr = _.isString(this.comparator) ? this.comparator : null;
      var toAdd = [], toRemove = [], modelMap = {};
      for (i = 0, l = models.length; i < l; i++) {
        if (!(model = this._prepareModel(models[i], options)))
          continue;
        if (existing = this.get(model)) {
          if (options.remove)
            modelMap[existing.cid] = true;
          if (options.merge) {
            existing.set(model.attributes, options);
            if (sortable && !sort && existing.hasChanged(sortAttr))
              sort = true;
          }
        } else if (options.add) {
          toAdd.push(model);
          model.on('all', this._onModelEvent, this);
          this._byId[model.cid] = model;
          if (model.id != null)
            this._byId[model.id] = model;
        }
      }
      if (options.remove) {
        for (i = 0, l = this.length; i < l; ++i) {
          if (!modelMap[(model = this.models[i]).cid])
            toRemove.push(model);
        }
        if (toRemove.length)
          this.remove(toRemove, options);
      }
      if (toAdd.length) {
        if (sortable)
          sort = true;
        this.length += toAdd.length;
        if (at != null) {
          splice.apply(this.models, [
            at,
            0
          ].concat(toAdd));
        } else {
          push.apply(this.models, toAdd);
        }
      }
      if (sort)
        this.sort({ silent: true });
      if (options.silent)
        return this;
      for (i = 0, l = toAdd.length; i < l; i++) {
        (model = toAdd[i]).trigger('add', model, this, options);
      }
      if (sort)
        this.trigger('sort', this, options);
      return this;
    },
    reset: function (models, options) {
      options || (options = {});
      for (var i = 0, l = this.models.length; i < l; i++) {
        this._removeReference(this.models[i]);
      }
      options.previousModels = this.models;
      this._reset();
      this.add(models, _.extend({ silent: true }, options));
      if (!options.silent)
        this.trigger('reset', this, options);
      return this;
    },
    push: function (model, options) {
      model = this._prepareModel(model, options);
      this.add(model, _.extend({ at: this.length }, options));
      return model;
    },
    pop: function (options) {
      var model = this.at(this.length - 1);
      this.remove(model, options);
      return model;
    },
    unshift: function (model, options) {
      model = this._prepareModel(model, options);
      this.add(model, _.extend({ at: 0 }, options));
      return model;
    },
    shift: function (options) {
      var model = this.at(0);
      this.remove(model, options);
      return model;
    },
    slice: function (begin, end) {
      return this.models.slice(begin, end);
    },
    get: function (obj) {
      if (obj == null)
        return void 0;
      return this._byId[obj.id != null ? obj.id : obj.cid || obj];
    },
    at: function (index) {
      return this.models[index];
    },
    where: function (attrs, first) {
      if (_.isEmpty(attrs))
        return first ? void 0 : [];
      return this[first ? 'find' : 'filter'](function (model) {
        for (var key in attrs) {
          if (attrs[key] !== model.get(key))
            return false;
        }
        return true;
      });
    },
    findWhere: function (attrs) {
      return this.where(attrs, true);
    },
    sort: function (options) {
      if (!this.comparator)
        throw new Error('Cannot sort a set without a comparator');
      options || (options = {});
      if (_.isString(this.comparator) || this.comparator.length === 1) {
        this.models = this.sortBy(this.comparator, this);
      } else {
        this.models.sort(_.bind(this.comparator, this));
      }
      if (!options.silent)
        this.trigger('sort', this, options);
      return this;
    },
    sortedIndex: function (model, value, context) {
      value || (value = this.comparator);
      var iterator = _.isFunction(value) ? value : function (model) {
          return model.get(value);
        };
      return _.sortedIndex(this.models, model, iterator, context);
    },
    pluck: function (attr) {
      return _.invoke(this.models, 'get', attr);
    },
    fetch: function (options) {
      options = options ? _.clone(options) : {};
      if (options.parse === void 0)
        options.parse = true;
      var success = options.success;
      var collection = this;
      options.success = function (resp) {
        var method = options.reset ? 'reset' : 'set';
        collection[method](resp, options);
        if (success)
          success(collection, resp, options);
        collection.trigger('sync', collection, resp, options);
      };
      wrapError(this, options);
      return this.sync('read', this, options);
    },
    create: function (model, options) {
      options = options ? _.clone(options) : {};
      if (!(model = this._prepareModel(model, options)))
        return false;
      if (!options.wait)
        this.add(model, options);
      var collection = this;
      var success = options.success;
      options.success = function (resp) {
        if (options.wait)
          collection.add(model, options);
        if (success)
          success(model, resp, options);
      };
      model.save(null, options);
      return model;
    },
    parse: function (resp, options) {
      return resp;
    },
    clone: function () {
      return new this.constructor(this.models);
    },
    _reset: function () {
      this.length = 0;
      this.models = [];
      this._byId = {};
    },
    _prepareModel: function (attrs, options) {
      if (attrs instanceof Model) {
        if (!attrs.collection)
          attrs.collection = this;
        return attrs;
      }
      options || (options = {});
      options.collection = this;
      var model = new this.model(attrs, options);
      if (!model._validate(attrs, options)) {
        this.trigger('invalid', this, attrs, options);
        return false;
      }
      return model;
    },
    _removeReference: function (model) {
      if (this === model.collection)
        delete model.collection;
      model.off('all', this._onModelEvent, this);
    },
    _onModelEvent: function (event, model, collection, options) {
      if ((event === 'add' || event === 'remove') && collection !== this)
        return;
      if (event === 'destroy')
        this.remove(model, options);
      if (model && event === 'change:' + model.idAttribute) {
        delete this._byId[model.previous(model.idAttribute)];
        if (model.id != null)
          this._byId[model.id] = model;
      }
      this.trigger.apply(this, arguments);
    }
  });
  var methods = [
      'forEach',
      'each',
      'map',
      'collect',
      'reduce',
      'foldl',
      'inject',
      'reduceRight',
      'foldr',
      'find',
      'detect',
      'filter',
      'select',
      'reject',
      'every',
      'all',
      'some',
      'any',
      'include',
      'contains',
      'invoke',
      'max',
      'min',
      'toArray',
      'size',
      'first',
      'head',
      'take',
      'initial',
      'rest',
      'tail',
      'drop',
      'last',
      'without',
      'indexOf',
      'shuffle',
      'lastIndexOf',
      'isEmpty',
      'chain'
    ];
  _.each(methods, function (method) {
    Collection.prototype[method] = function () {
      var args = slice.call(arguments);
      args.unshift(this.models);
      return _[method].apply(_, args);
    };
  });
  var attributeMethods = [
      'groupBy',
      'countBy',
      'sortBy'
    ];
  _.each(attributeMethods, function (method) {
    Collection.prototype[method] = function (value, context) {
      var iterator = _.isFunction(value) ? value : function (model) {
          return model.get(value);
        };
      return _[method](this.models, iterator, context);
    };
  });
  var View = Backbone.View = function (options) {
      this.cid = _.uniqueId('view');
      this._configure(options || {});
      this._ensureElement();
      this.initialize.apply(this, arguments);
      this.delegateEvents();
    };
  var delegateEventSplitter = /^(\S+)\s*(.*)$/;
  var viewOptions = [
      'model',
      'collection',
      'el',
      'id',
      'attributes',
      'className',
      'tagName',
      'events'
    ];
  _.extend(View.prototype, Events, {
    tagName: 'div',
    $: function (selector) {
      return this.$el.find(selector);
    },
    initialize: function () {
    },
    render: function () {
      return this;
    },
    remove: function () {
      this.$el.remove();
      this.stopListening();
      return this;
    },
    setElement: function (element, delegate) {
      if (this.$el)
        this.undelegateEvents();
      this.$el = element instanceof Backbone.$ ? element : Backbone.$(element);
      this.el = this.$el[0];
      if (delegate !== false)
        this.delegateEvents();
      return this;
    },
    delegateEvents: function (events) {
      if (!(events || (events = _.result(this, 'events'))))
        return this;
      this.undelegateEvents();
      for (var key in events) {
        var method = events[key];
        if (!_.isFunction(method))
          method = this[events[key]];
        if (!method)
          continue;
        var match = key.match(delegateEventSplitter);
        var eventName = match[1], selector = match[2];
        method = _.bind(method, this);
        eventName += '.delegateEvents' + this.cid;
        if (selector === '') {
          this.$el.on(eventName, method);
        } else {
          this.$el.on(eventName, selector, method);
        }
      }
      return this;
    },
    undelegateEvents: function () {
      this.$el.off('.delegateEvents' + this.cid);
      return this;
    },
    _configure: function (options) {
      if (this.options)
        options = _.extend({}, _.result(this, 'options'), options);
      _.extend(this, _.pick(options, viewOptions));
      this.options = options;
    },
    _ensureElement: function () {
      if (!this.el) {
        var attrs = _.extend({}, _.result(this, 'attributes'));
        if (this.id)
          attrs.id = _.result(this, 'id');
        if (this.className)
          attrs['class'] = _.result(this, 'className');
        var $el = Backbone.$('<' + _.result(this, 'tagName') + '>').attr(attrs);
        this.setElement($el, false);
      } else {
        this.setElement(_.result(this, 'el'), false);
      }
    }
  });
  Backbone.sync = function (method, model, options) {
    var type = methodMap[method];
    _.defaults(options || (options = {}), {
      emulateHTTP: Backbone.emulateHTTP,
      emulateJSON: Backbone.emulateJSON
    });
    var params = {
        type: type,
        dataType: 'json'
      };
    if (!options.url) {
      params.url = _.result(model, 'url') || urlError();
    }
    if (options.data == null && model && (method === 'create' || method === 'update' || method === 'patch')) {
      params.contentType = 'application/json';
      params.data = JSON.stringify(options.attrs || model.toJSON(options));
    }
    if (options.emulateJSON) {
      params.contentType = 'application/x-www-form-urlencoded';
      params.data = params.data ? { model: params.data } : {};
    }
    if (options.emulateHTTP && (type === 'PUT' || type === 'DELETE' || type === 'PATCH')) {
      params.type = 'POST';
      if (options.emulateJSON)
        params.data._method = type;
      var beforeSend = options.beforeSend;
      options.beforeSend = function (xhr) {
        xhr.setRequestHeader('X-HTTP-Method-Override', type);
        if (beforeSend)
          return beforeSend.apply(this, arguments);
      };
    }
    if (params.type !== 'GET' && !options.emulateJSON) {
      params.processData = false;
    }
    if (params.type === 'PATCH' && window.ActiveXObject && !(window.external && window.external.msActiveXFilteringEnabled)) {
      params.xhr = function () {
        return new ActiveXObject('Microsoft.XMLHTTP');
      };
    }
    var xhr = options.xhr = Backbone.ajax(_.extend(params, options));
    model.trigger('request', model, xhr, options);
    return xhr;
  };
  var methodMap = {
      'create': 'POST',
      'update': 'PUT',
      'patch': 'PATCH',
      'delete': 'DELETE',
      'read': 'GET'
    };
  Backbone.ajax = function () {
    return Backbone.$.ajax.apply(Backbone.$, arguments);
  };
  var Router = Backbone.Router = function (options) {
      options || (options = {});
      if (options.routes)
        this.routes = options.routes;
      this._bindRoutes();
      this.initialize.apply(this, arguments);
    };
  var optionalParam = /\((.*?)\)/g;
  var namedParam = /(\(\?)?:\w+/g;
  var splatParam = /\*\w+/g;
  var escapeRegExp = /[\-{}\[\]+?.,\\\^$|#\s]/g;
  _.extend(Router.prototype, Events, {
    initialize: function () {
    },
    route: function (route, name, callback) {
      if (!_.isRegExp(route))
        route = this._routeToRegExp(route);
      if (_.isFunction(name)) {
        callback = name;
        name = '';
      }
      if (!callback)
        callback = this[name];
      var router = this;
      Backbone.history.route(route, function (fragment) {
        var args = router._extractParameters(route, fragment);
        callback && callback.apply(router, args);
        router.trigger.apply(router, ['route:' + name].concat(args));
        router.trigger('route', name, args);
        Backbone.history.trigger('route', router, name, args);
      });
      return this;
    },
    navigate: function (fragment, options) {
      Backbone.history.navigate(fragment, options);
      return this;
    },
    _bindRoutes: function () {
      if (!this.routes)
        return;
      this.routes = _.result(this, 'routes');
      var route, routes = _.keys(this.routes);
      while ((route = routes.pop()) != null) {
        this.route(route, this.routes[route]);
      }
    },
    _routeToRegExp: function (route) {
      route = route.replace(escapeRegExp, '\\$&').replace(optionalParam, '(?:$1)?').replace(namedParam, function (match, optional) {
        return optional ? match : '([^/]+)';
      }).replace(splatParam, '(.*?)');
      return new RegExp('^' + route + '$');
    },
    _extractParameters: function (route, fragment) {
      var params = route.exec(fragment).slice(1);
      return _.map(params, function (param) {
        return param ? decodeURIComponent(param) : null;
      });
    }
  });
  var History = Backbone.History = function () {
      this.handlers = [];
      _.bindAll(this, 'checkUrl');
      if (typeof window !== 'undefined') {
        this.location = window.location;
        this.history = window.history;
      }
    };
  var routeStripper = /^[#\/]|\s+$/g;
  var rootStripper = /^\/+|\/+$/g;
  var isExplorer = /msie [\w.]+/;
  var trailingSlash = /\/$/;
  History.started = false;
  _.extend(History.prototype, Events, {
    interval: 50,
    getHash: function (window) {
      var match = (window || this).location.href.match(/#(.*)$/);
      return match ? match[1] : '';
    },
    getFragment: function (fragment, forcePushState) {
      if (fragment == null) {
        if (this._hasPushState || !this._wantsHashChange || forcePushState) {
          fragment = this.location.pathname;
          var root = this.root.replace(trailingSlash, '');
          if (!fragment.indexOf(root))
            fragment = fragment.substr(root.length);
        } else {
          fragment = this.getHash();
        }
      }
      return fragment.replace(routeStripper, '');
    },
    start: function (options) {
      if (History.started)
        throw new Error('Backbone.history has already been started');
      History.started = true;
      this.options = _.extend({}, { root: '/' }, this.options, options);
      this.root = this.options.root;
      this._wantsHashChange = this.options.hashChange !== false;
      this._wantsPushState = !!this.options.pushState;
      this._hasPushState = !!(this.options.pushState && this.history && this.history.pushState);
      var fragment = this.getFragment();
      var docMode = document.documentMode;
      var oldIE = isExplorer.exec(navigator.userAgent.toLowerCase()) && (!docMode || docMode <= 7);
      this.root = ('/' + this.root + '/').replace(rootStripper, '/');
      if (oldIE && this._wantsHashChange) {
        this.iframe = Backbone.$('<iframe src="javascript:0" tabindex="-1" />').hide().appendTo('body')[0].contentWindow;
        this.navigate(fragment);
      }
      if (this._hasPushState) {
        Backbone.$(window).on('popstate', this.checkUrl);
      } else if (this._wantsHashChange && 'onhashchange' in window && !oldIE) {
        Backbone.$(window).on('hashchange', this.checkUrl);
      } else if (this._wantsHashChange) {
        this._checkUrlInterval = setInterval(this.checkUrl, this.interval);
      }
      this.fragment = fragment;
      var loc = this.location;
      var atRoot = loc.pathname.replace(/[^\/]$/, '$&/') === this.root;
      if (this._wantsHashChange && this._wantsPushState && !this._hasPushState && !atRoot) {
        this.fragment = this.getFragment(null, true);
        this.location.replace(this.root + this.location.search + '#' + this.fragment);
        return true;
      } else if (this._wantsPushState && this._hasPushState && atRoot && loc.hash) {
        this.fragment = this.getHash().replace(routeStripper, '');
        this.history.replaceState({}, document.title, this.root + this.fragment + loc.search);
      }
      if (!this.options.silent)
        return this.loadUrl();
    },
    stop: function () {
      Backbone.$(window).off('popstate', this.checkUrl).off('hashchange', this.checkUrl);
      clearInterval(this._checkUrlInterval);
      History.started = false;
    },
    route: function (route, callback) {
      this.handlers.unshift({
        route: route,
        callback: callback
      });
    },
    checkUrl: function (e) {
      var current = this.getFragment();
      if (current === this.fragment && this.iframe) {
        current = this.getFragment(this.getHash(this.iframe));
      }
      if (current === this.fragment)
        return false;
      if (this.iframe)
        this.navigate(current);
      this.loadUrl() || this.loadUrl(this.getHash());
    },
    loadUrl: function (fragmentOverride) {
      var fragment = this.fragment = this.getFragment(fragmentOverride);
      var matched = _.any(this.handlers, function (handler) {
          if (handler.route.test(fragment)) {
            handler.callback(fragment);
            return true;
          }
        });
      return matched;
    },
    navigate: function (fragment, options) {
      if (!History.started)
        return false;
      if (!options || options === true)
        options = { trigger: options };
      fragment = this.getFragment(fragment || '');
      if (this.fragment === fragment)
        return;
      this.fragment = fragment;
      var url = this.root + fragment;
      if (this._hasPushState) {
        this.history[options.replace ? 'replaceState' : 'pushState']({}, document.title, url);
      } else if (this._wantsHashChange) {
        this._updateHash(this.location, fragment, options.replace);
        if (this.iframe && fragment !== this.getFragment(this.getHash(this.iframe))) {
          if (!options.replace)
            this.iframe.document.open().close();
          this._updateHash(this.iframe.location, fragment, options.replace);
        }
      } else {
        return this.location.assign(url);
      }
      if (options.trigger)
        this.loadUrl(fragment);
    },
    _updateHash: function (location, fragment, replace) {
      if (replace) {
        var href = location.href.replace(/(javascript:|#).*$/, '');
        location.replace(href + '#' + fragment);
      } else {
        location.hash = '#' + fragment;
      }
    }
  });
  Backbone.history = new History();
  var extend = function (protoProps, staticProps) {
    var parent = this;
    var child;
    if (protoProps && _.has(protoProps, 'constructor')) {
      child = protoProps.constructor;
    } else {
      child = function () {
        return parent.apply(this, arguments);
      };
    }
    _.extend(child, parent, staticProps);
    var Surrogate = function () {
      this.constructor = child;
    };
    Surrogate.prototype = parent.prototype;
    child.prototype = new Surrogate();
    if (protoProps)
      _.extend(child.prototype, protoProps);
    child.__super__ = parent.prototype;
    return child;
  };
  Model.extend = Collection.extend = Router.extend = View.extend = History.extend = extend;
  var urlError = function () {
    throw new Error('A "url" property or function must be specified');
  };
  var wrapError = function (model, options) {
    var error = options.error;
    options.error = function (resp) {
      if (error)
        error(model, resp, options);
      model.trigger('error', model, resp, options);
    };
  };
}.call(this));
!function ($) {
  'use strict';
  $(function () {
    $.support.transition = function () {
      var transitionEnd = function () {
          var el = document.createElement('bootstrap'), transEndEventNames = {
              'WebkitTransition': 'webkitTransitionEnd',
              'MozTransition': 'transitionend',
              'OTransition': 'oTransitionEnd otransitionend',
              'transition': 'transitionend'
            }, name;
          for (name in transEndEventNames) {
            if (el.style[name] !== undefined) {
              return transEndEventNames[name];
            }
          }
        }();
      return transitionEnd && { end: transitionEnd };
    }();
  });
}(window.jQuery);
!function ($) {
  'use strict';
  var dismiss = '[data-dismiss="alert"]', Alert = function (el) {
      $(el).on('click', dismiss, this.close);
    };
  Alert.prototype.close = function (e) {
    var $this = $(this), selector = $this.attr('data-target'), $parent;
    if (!selector) {
      selector = $this.attr('href');
      selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '');
    }
    $parent = $(selector);
    e && e.preventDefault();
    $parent.length || ($parent = $this.hasClass('alert') ? $this : $this.parent());
    $parent.trigger(e = $.Event('close'));
    if (e.isDefaultPrevented())
      return;
    $parent.removeClass('in');
    function removeElement() {
      $parent.trigger('closed').remove();
    }
    $.support.transition && $parent.hasClass('fade') ? $parent.on($.support.transition.end, removeElement) : removeElement();
  };
  var old = $.fn.alert;
  $.fn.alert = function (option) {
    return this.each(function () {
      var $this = $(this), data = $this.data('alert');
      if (!data)
        $this.data('alert', data = new Alert(this));
      if (typeof option == 'string')
        data[option].call($this);
    });
  };
  $.fn.alert.Constructor = Alert;
  $.fn.alert.noConflict = function () {
    $.fn.alert = old;
    return this;
  };
  $(document).on('click.alert.data-api', dismiss, Alert.prototype.close);
}(window.jQuery);
!function ($) {
  'use strict';
  var Button = function (element, options) {
    this.$element = $(element);
    this.options = $.extend({}, $.fn.button.defaults, options);
  };
  Button.prototype.setState = function (state) {
    var d = 'disabled', $el = this.$element, data = $el.data(), val = $el.is('input') ? 'val' : 'html';
    state = state + 'Text';
    data.resetText || $el.data('resetText', $el[val]());
    $el[val](data[state] || this.options[state]);
    setTimeout(function () {
      state == 'loadingText' ? $el.addClass(d).attr(d, d) : $el.removeClass(d).removeAttr(d);
    }, 0);
  };
  Button.prototype.toggle = function () {
    var $parent = this.$element.closest('[data-toggle="buttons-radio"]');
    $parent && $parent.find('.active').removeClass('active');
    this.$element.toggleClass('active');
  };
  var old = $.fn.button;
  $.fn.button = function (option) {
    return this.each(function () {
      var $this = $(this), data = $this.data('button'), options = typeof option == 'object' && option;
      if (!data)
        $this.data('button', data = new Button(this, options));
      if (option == 'toggle')
        data.toggle();
      else if (option)
        data.setState(option);
    });
  };
  $.fn.button.defaults = { loadingText: 'loading...' };
  $.fn.button.Constructor = Button;
  $.fn.button.noConflict = function () {
    $.fn.button = old;
    return this;
  };
  $(document).on('click.button.data-api', '[data-toggle^=button]', function (e) {
    var $btn = $(e.target);
    if (!$btn.hasClass('btn'))
      $btn = $btn.closest('.btn');
    $btn.button('toggle');
  });
}(window.jQuery);
!function ($) {
  'use strict';
  var Carousel = function (element, options) {
    this.$element = $(element);
    this.$indicators = this.$element.find('.carousel-indicators');
    this.options = options;
    this.options.pause == 'hover' && this.$element.on('mouseenter', $.proxy(this.pause, this)).on('mouseleave', $.proxy(this.cycle, this));
  };
  Carousel.prototype = {
    cycle: function (e) {
      if (!e)
        this.paused = false;
      if (this.interval)
        clearInterval(this.interval);
      this.options.interval && !this.paused && (this.interval = setInterval($.proxy(this.next, this), this.options.interval));
      return this;
    },
    getActiveIndex: function () {
      this.$active = this.$element.find('.item.active');
      this.$items = this.$active.parent().children();
      return this.$items.index(this.$active);
    },
    to: function (pos) {
      var activeIndex = this.getActiveIndex(), that = this;
      if (pos > this.$items.length - 1 || pos < 0)
        return;
      if (this.sliding) {
        return this.$element.one('slid', function () {
          that.to(pos);
        });
      }
      if (activeIndex == pos) {
        return this.pause().cycle();
      }
      return this.slide(pos > activeIndex ? 'next' : 'prev', $(this.$items[pos]));
    },
    pause: function (e) {
      if (!e)
        this.paused = true;
      if (this.$element.find('.next, .prev').length && $.support.transition.end) {
        this.$element.trigger($.support.transition.end);
        this.cycle(true);
      }
      clearInterval(this.interval);
      this.interval = null;
      return this;
    },
    next: function () {
      if (this.sliding)
        return;
      return this.slide('next');
    },
    prev: function () {
      if (this.sliding)
        return;
      return this.slide('prev');
    },
    slide: function (type, next) {
      var $active = this.$element.find('.item.active'), $next = next || $active[type](), isCycling = this.interval, direction = type == 'next' ? 'left' : 'right', fallback = type == 'next' ? 'first' : 'last', that = this, e;
      this.sliding = true;
      isCycling && this.pause();
      $next = $next.length ? $next : this.$element.find('.item')[fallback]();
      e = $.Event('slide', {
        relatedTarget: $next[0],
        direction: direction
      });
      if ($next.hasClass('active'))
        return;
      if (this.$indicators.length) {
        this.$indicators.find('.active').removeClass('active');
        this.$element.one('slid', function () {
          var $nextIndicator = $(that.$indicators.children()[that.getActiveIndex()]);
          $nextIndicator && $nextIndicator.addClass('active');
        });
      }
      if ($.support.transition && this.$element.hasClass('slide')) {
        this.$element.trigger(e);
        if (e.isDefaultPrevented())
          return;
        $next.addClass(type);
        $next[0].offsetWidth;
        $active.addClass(direction);
        $next.addClass(direction);
        this.$element.one($.support.transition.end, function () {
          $next.removeClass([
            type,
            direction
          ].join(' ')).addClass('active');
          $active.removeClass([
            'active',
            direction
          ].join(' '));
          that.sliding = false;
          setTimeout(function () {
            that.$element.trigger('slid');
          }, 0);
        });
      } else {
        this.$element.trigger(e);
        if (e.isDefaultPrevented())
          return;
        $active.removeClass('active');
        $next.addClass('active');
        this.sliding = false;
        this.$element.trigger('slid');
      }
      isCycling && this.cycle();
      return this;
    }
  };
  var old = $.fn.carousel;
  $.fn.carousel = function (option) {
    return this.each(function () {
      var $this = $(this), data = $this.data('carousel'), options = $.extend({}, $.fn.carousel.defaults, typeof option == 'object' && option), action = typeof option == 'string' ? option : options.slide;
      if (!data)
        $this.data('carousel', data = new Carousel(this, options));
      if (typeof option == 'number')
        data.to(option);
      else if (action)
        data[action]();
      else if (options.interval)
        data.pause().cycle();
    });
  };
  $.fn.carousel.defaults = {
    interval: 5000,
    pause: 'hover'
  };
  $.fn.carousel.Constructor = Carousel;
  $.fn.carousel.noConflict = function () {
    $.fn.carousel = old;
    return this;
  };
  $(document).on('click.carousel.data-api', '[data-slide], [data-slide-to]', function (e) {
    var $this = $(this), href, $target = $($this.attr('data-target') || (href = $this.attr('href')) && href.replace(/.*(?=#[^\s]+$)/, '')), options = $.extend({}, $target.data(), $this.data()), slideIndex;
    $target.carousel(options);
    if (slideIndex = $this.attr('data-slide-to')) {
      $target.data('carousel').pause().to(slideIndex).cycle();
    }
    e.preventDefault();
  });
}(window.jQuery);
!function ($) {
  'use strict';
  var Collapse = function (element, options) {
    this.$element = $(element);
    this.options = $.extend({}, $.fn.collapse.defaults, options);
    if (this.options.parent) {
      this.$parent = $(this.options.parent);
    }
    this.options.toggle && this.toggle();
  };
  Collapse.prototype = {
    constructor: Collapse,
    dimension: function () {
      var hasWidth = this.$element.hasClass('width');
      return hasWidth ? 'width' : 'height';
    },
    show: function () {
      var dimension, scroll, actives, hasData;
      if (this.transitioning || this.$element.hasClass('in'))
        return;
      dimension = this.dimension();
      scroll = $.camelCase([
        'scroll',
        dimension
      ].join('-'));
      actives = this.$parent && this.$parent.find('> .accordion-group > .in');
      if (actives && actives.length) {
        hasData = actives.data('collapse');
        if (hasData && hasData.transitioning)
          return;
        actives.collapse('hide');
        hasData || actives.data('collapse', null);
      }
      this.$element[dimension](0);
      this.transition('addClass', $.Event('show'), 'shown');
      $.support.transition && this.$element[dimension](this.$element[0][scroll]);
    },
    hide: function () {
      var dimension;
      if (this.transitioning || !this.$element.hasClass('in'))
        return;
      dimension = this.dimension();
      this.reset(this.$element[dimension]());
      this.transition('removeClass', $.Event('hide'), 'hidden');
      this.$element[dimension](0);
    },
    reset: function (size) {
      var dimension = this.dimension();
      this.$element.removeClass('collapse')[dimension](size || 'auto')[0].offsetWidth;
      this.$element[size !== null ? 'addClass' : 'removeClass']('collapse');
      return this;
    },
    transition: function (method, startEvent, completeEvent) {
      var that = this, complete = function () {
          if (startEvent.type == 'show')
            that.reset();
          that.transitioning = 0;
          that.$element.trigger(completeEvent);
        };
      this.$element.trigger(startEvent);
      if (startEvent.isDefaultPrevented())
        return;
      this.transitioning = 1;
      this.$element[method]('in');
      $.support.transition && this.$element.hasClass('collapse') ? this.$element.one($.support.transition.end, complete) : complete();
    },
    toggle: function () {
      this[this.$element.hasClass('in') ? 'hide' : 'show']();
    }
  };
  var old = $.fn.collapse;
  $.fn.collapse = function (option) {
    return this.each(function () {
      var $this = $(this), data = $this.data('collapse'), options = $.extend({}, $.fn.collapse.defaults, $this.data(), typeof option == 'object' && option);
      if (!data)
        $this.data('collapse', data = new Collapse(this, options));
      if (typeof option == 'string')
        data[option]();
    });
  };
  $.fn.collapse.defaults = { toggle: true };
  $.fn.collapse.Constructor = Collapse;
  $.fn.collapse.noConflict = function () {
    $.fn.collapse = old;
    return this;
  };
  $(document).on('click.collapse.data-api', '[data-toggle=collapse]', function (e) {
    var $this = $(this), href, target = $this.attr('data-target') || e.preventDefault() || (href = $this.attr('href')) && href.replace(/.*(?=#[^\s]+$)/, ''), option = $(target).data('collapse') ? 'toggle' : $this.data();
    $this[$(target).hasClass('in') ? 'addClass' : 'removeClass']('collapsed');
    $(target).collapse(option);
  });
}(window.jQuery);
!function ($) {
  'use strict';
  var toggle = '[data-toggle=dropdown]', Dropdown = function (element) {
      var $el = $(element).on('click.dropdown.data-api', this.toggle);
      $('html').on('click.dropdown.data-api', function () {
        $el.parent().removeClass('open');
      });
    };
  Dropdown.prototype = {
    constructor: Dropdown,
    toggle: function (e) {
      var $this = $(this), $parent, isActive;
      if ($this.is('.disabled, :disabled'))
        return;
      $parent = getParent($this);
      isActive = $parent.hasClass('open');
      clearMenus();
      if (!isActive) {
        if ('ontouchstart' in document.documentElement) {
          $('<div class="dropdown-backdrop"/>').insertBefore($(this)).on('click', clearMenus);
        }
        $parent.toggleClass('open');
      }
      $this.focus();
      return false;
    },
    keydown: function (e) {
      var $this, $items, $active, $parent, isActive, index;
      if (!/(38|40|27)/.test(e.keyCode))
        return;
      $this = $(this);
      e.preventDefault();
      e.stopPropagation();
      if ($this.is('.disabled, :disabled'))
        return;
      $parent = getParent($this);
      isActive = $parent.hasClass('open');
      if (!isActive || isActive && e.keyCode == 27) {
        if (e.which == 27)
          $parent.find(toggle).focus();
        return $this.click();
      }
      $items = $('[role=menu] li:not(.divider):visible a', $parent);
      if (!$items.length)
        return;
      index = $items.index($items.filter(':focus'));
      if (e.keyCode == 38 && index > 0)
        index--;
      if (e.keyCode == 40 && index < $items.length - 1)
        index++;
      if (!~index)
        index = 0;
      $items.eq(index).focus();
    }
  };
  function clearMenus() {
    $('.dropdown-backdrop').remove();
    $(toggle).each(function () {
      getParent($(this)).removeClass('open');
    });
  }
  function getParent($this) {
    var selector = $this.attr('data-target'), $parent;
    if (!selector) {
      selector = $this.attr('href');
      selector = selector && /#/.test(selector) && selector.replace(/.*(?=#[^\s]*$)/, '');
    }
    $parent = selector && $(selector);
    if (!$parent || !$parent.length)
      $parent = $this.parent();
    return $parent;
  }
  var old = $.fn.dropdown;
  $.fn.dropdown = function (option) {
    return this.each(function () {
      var $this = $(this), data = $this.data('dropdown');
      if (!data)
        $this.data('dropdown', data = new Dropdown(this));
      if (typeof option == 'string')
        data[option].call($this);
    });
  };
  $.fn.dropdown.Constructor = Dropdown;
  $.fn.dropdown.noConflict = function () {
    $.fn.dropdown = old;
    return this;
  };
  $(document).on('click.dropdown.data-api', clearMenus).on('click.dropdown.data-api', '.dropdown form', function (e) {
    e.stopPropagation();
  }).on('click.dropdown.data-api', toggle, Dropdown.prototype.toggle).on('keydown.dropdown.data-api', toggle + ', [role=menu]', Dropdown.prototype.keydown);
}(window.jQuery);
!function ($) {
  'use strict';
  var Modal = function (element, options) {
    this.options = options;
    this.$element = $(element).delegate('[data-dismiss="modal"]', 'click.dismiss.modal', $.proxy(this.hide, this));
    this.options.remote && this.$element.find('.modal-body').load(this.options.remote);
  };
  Modal.prototype = {
    constructor: Modal,
    toggle: function () {
      return this[!this.isShown ? 'show' : 'hide']();
    },
    show: function () {
      var that = this, e = $.Event('show');
      this.$element.trigger(e);
      if (this.isShown || e.isDefaultPrevented())
        return;
      this.isShown = true;
      this.escape();
      this.backdrop(function () {
        var transition = $.support.transition && that.$element.hasClass('fade');
        if (!that.$element.parent().length) {
          that.$element.appendTo(document.body);
        }
        that.$element.show();
        if (transition) {
          that.$element[0].offsetWidth;
        }
        that.$element.addClass('in').attr('aria-hidden', false);
        that.enforceFocus();
        transition ? that.$element.one($.support.transition.end, function () {
          that.$element.focus().trigger('shown');
        }) : that.$element.focus().trigger('shown');
      });
    },
    hide: function (e) {
      e && e.preventDefault();
      var that = this;
      e = $.Event('hide');
      this.$element.trigger(e);
      if (!this.isShown || e.isDefaultPrevented())
        return;
      this.isShown = false;
      this.escape();
      $(document).off('focusin.modal');
      this.$element.removeClass('in').attr('aria-hidden', true);
      $.support.transition && this.$element.hasClass('fade') ? this.hideWithTransition() : this.hideModal();
    },
    enforceFocus: function () {
      var that = this;
      $(document).on('focusin.modal', function (e) {
        if (that.$element[0] !== e.target && !that.$element.has(e.target).length) {
          that.$element.focus();
        }
      });
    },
    escape: function () {
      var that = this;
      if (this.isShown && this.options.keyboard) {
        this.$element.on('keyup.dismiss.modal', function (e) {
          e.which == 27 && that.hide();
        });
      } else if (!this.isShown) {
        this.$element.off('keyup.dismiss.modal');
      }
    },
    hideWithTransition: function () {
      var that = this, timeout = setTimeout(function () {
          that.$element.off($.support.transition.end);
          that.hideModal();
        }, 500);
      this.$element.one($.support.transition.end, function () {
        clearTimeout(timeout);
        that.hideModal();
      });
    },
    hideModal: function () {
      var that = this;
      this.$element.hide();
      this.backdrop(function () {
        that.removeBackdrop();
        that.$element.trigger('hidden');
      });
    },
    removeBackdrop: function () {
      this.$backdrop && this.$backdrop.remove();
      this.$backdrop = null;
    },
    backdrop: function (callback) {
      var that = this, animate = this.$element.hasClass('fade') ? 'fade' : '';
      if (this.isShown && this.options.backdrop) {
        var doAnimate = $.support.transition && animate;
        this.$backdrop = $('<div class="modal-backdrop ' + animate + '" />').appendTo(document.body);
        this.$backdrop.click(this.options.backdrop == 'static' ? $.proxy(this.$element[0].focus, this.$element[0]) : $.proxy(this.hide, this));
        if (doAnimate)
          this.$backdrop[0].offsetWidth;
        this.$backdrop.addClass('in');
        if (!callback)
          return;
        doAnimate ? this.$backdrop.one($.support.transition.end, callback) : callback();
      } else if (!this.isShown && this.$backdrop) {
        this.$backdrop.removeClass('in');
        $.support.transition && this.$element.hasClass('fade') ? this.$backdrop.one($.support.transition.end, callback) : callback();
      } else if (callback) {
        callback();
      }
    }
  };
  var old = $.fn.modal;
  $.fn.modal = function (option) {
    return this.each(function () {
      var $this = $(this), data = $this.data('modal'), options = $.extend({}, $.fn.modal.defaults, $this.data(), typeof option == 'object' && option);
      if (!data)
        $this.data('modal', data = new Modal(this, options));
      if (typeof option == 'string')
        data[option]();
      else if (options.show)
        data.show();
    });
  };
  $.fn.modal.defaults = {
    backdrop: true,
    keyboard: true,
    show: true
  };
  $.fn.modal.Constructor = Modal;
  $.fn.modal.noConflict = function () {
    $.fn.modal = old;
    return this;
  };
  $(document).on('click.modal.data-api', '[data-toggle="modal"]', function (e) {
    var $this = $(this), href = $this.attr('href'), $target = $($this.attr('data-target') || href && href.replace(/.*(?=#[^\s]+$)/, '')), option = $target.data('modal') ? 'toggle' : $.extend({ remote: !/#/.test(href) && href }, $target.data(), $this.data());
    e.preventDefault();
    $target.modal(option).one('hide', function () {
      $this.focus();
    });
  });
}(window.jQuery);
!function ($) {
  'use strict';
  var Tooltip = function (element, options) {
    this.init('tooltip', element, options);
  };
  Tooltip.prototype = {
    constructor: Tooltip,
    init: function (type, element, options) {
      var eventIn, eventOut, triggers, trigger, i;
      this.type = type;
      this.$element = $(element);
      this.options = this.getOptions(options);
      this.enabled = true;
      triggers = this.options.trigger.split(' ');
      for (i = triggers.length; i--;) {
        trigger = triggers[i];
        if (trigger == 'click') {
          this.$element.on('click.' + this.type, this.options.selector, $.proxy(this.toggle, this));
        } else if (trigger != 'manual') {
          eventIn = trigger == 'hover' ? 'mouseenter' : 'focus';
          eventOut = trigger == 'hover' ? 'mouseleave' : 'blur';
          this.$element.on(eventIn + '.' + this.type, this.options.selector, $.proxy(this.enter, this));
          this.$element.on(eventOut + '.' + this.type, this.options.selector, $.proxy(this.leave, this));
        }
      }
      this.options.selector ? this._options = $.extend({}, this.options, {
        trigger: 'manual',
        selector: ''
      }) : this.fixTitle();
    },
    getOptions: function (options) {
      options = $.extend({}, $.fn[this.type].defaults, this.$element.data(), options);
      if (options.delay && typeof options.delay == 'number') {
        options.delay = {
          show: options.delay,
          hide: options.delay
        };
      }
      return options;
    },
    enter: function (e) {
      var defaults = $.fn[this.type].defaults, options = {}, self;
      this._options && $.each(this._options, function (key, value) {
        if (defaults[key] != value)
          options[key] = value;
      }, this);
      self = $(e.currentTarget)[this.type](options).data(this.type);
      if (!self.options.delay || !self.options.delay.show)
        return self.show();
      clearTimeout(this.timeout);
      self.hoverState = 'in';
      this.timeout = setTimeout(function () {
        if (self.hoverState == 'in')
          self.show();
      }, self.options.delay.show);
    },
    leave: function (e) {
      var self = $(e.currentTarget)[this.type](this._options).data(this.type);
      if (this.timeout)
        clearTimeout(this.timeout);
      if (!self.options.delay || !self.options.delay.hide)
        return self.hide();
      self.hoverState = 'out';
      this.timeout = setTimeout(function () {
        if (self.hoverState == 'out')
          self.hide();
      }, self.options.delay.hide);
    },
    show: function () {
      var $tip, pos, actualWidth, actualHeight, placement, tp, e = $.Event('show');
      if (this.hasContent() && this.enabled) {
        this.$element.trigger(e);
        if (e.isDefaultPrevented())
          return;
        $tip = this.tip();
        this.setContent();
        if (this.options.animation) {
          $tip.addClass('fade');
        }
        placement = typeof this.options.placement == 'function' ? this.options.placement.call(this, $tip[0], this.$element[0]) : this.options.placement;
        $tip.detach().css({
          top: 0,
          left: 0,
          display: 'block'
        });
        this.options.container ? $tip.appendTo(this.options.container) : $tip.insertAfter(this.$element);
        pos = this.getPosition();
        actualWidth = $tip[0].offsetWidth;
        actualHeight = $tip[0].offsetHeight;
        switch (placement) {
        case 'bottom':
          tp = {
            top: pos.top + pos.height,
            left: pos.left + pos.width / 2 - actualWidth / 2
          };
          break;
        case 'top':
          tp = {
            top: pos.top - actualHeight,
            left: pos.left + pos.width / 2 - actualWidth / 2
          };
          break;
        case 'left':
          tp = {
            top: pos.top + pos.height / 2 - actualHeight / 2,
            left: pos.left - actualWidth
          };
          break;
        case 'right':
          tp = {
            top: pos.top + pos.height / 2 - actualHeight / 2,
            left: pos.left + pos.width
          };
          break;
        }
        this.applyPlacement(tp, placement);
        this.$element.trigger('shown');
      }
    },
    applyPlacement: function (offset, placement) {
      var $tip = this.tip(), width = $tip[0].offsetWidth, height = $tip[0].offsetHeight, actualWidth, actualHeight, delta, replace;
      $tip.offset(offset).addClass(placement).addClass('in');
      actualWidth = $tip[0].offsetWidth;
      actualHeight = $tip[0].offsetHeight;
      if (placement == 'top' && actualHeight != height) {
        offset.top = offset.top + height - actualHeight;
        replace = true;
      }
      if (placement == 'bottom' || placement == 'top') {
        delta = 0;
        if (offset.left < 0) {
          delta = offset.left * -2;
          offset.left = 0;
          $tip.offset(offset);
          actualWidth = $tip[0].offsetWidth;
          actualHeight = $tip[0].offsetHeight;
        }
        this.replaceArrow(delta - width + actualWidth, actualWidth, 'left');
      } else {
        this.replaceArrow(actualHeight - height, actualHeight, 'top');
      }
      if (replace)
        $tip.offset(offset);
    },
    replaceArrow: function (delta, dimension, position) {
      this.arrow().css(position, delta ? 50 * (1 - delta / dimension) + '%' : '');
    },
    setContent: function () {
      var $tip = this.tip(), title = this.getTitle();
      $tip.find('.tooltip-inner')[this.options.html ? 'html' : 'text'](title);
      $tip.removeClass('fade in top bottom left right');
    },
    hide: function () {
      var that = this, $tip = this.tip(), e = $.Event('hide');
      this.$element.trigger(e);
      if (e.isDefaultPrevented())
        return;
      $tip.removeClass('in');
      function removeWithAnimation() {
        var timeout = setTimeout(function () {
            $tip.off($.support.transition.end).detach();
          }, 500);
        $tip.one($.support.transition.end, function () {
          clearTimeout(timeout);
          $tip.detach();
        });
      }
      $.support.transition && this.$tip.hasClass('fade') ? removeWithAnimation() : $tip.detach();
      this.$element.trigger('hidden');
      return this;
    },
    fixTitle: function () {
      var $e = this.$element;
      if ($e.attr('title') || typeof $e.attr('data-original-title') != 'string') {
        $e.attr('data-original-title', $e.attr('title') || '').attr('title', '');
      }
    },
    hasContent: function () {
      return this.getTitle();
    },
    getPosition: function () {
      var el = this.$element[0];
      return $.extend({}, typeof el.getBoundingClientRect == 'function' ? el.getBoundingClientRect() : {
        width: el.offsetWidth,
        height: el.offsetHeight
      }, this.$element.offset());
    },
    getTitle: function () {
      var title, $e = this.$element, o = this.options;
      title = $e.attr('data-original-title') || (typeof o.title == 'function' ? o.title.call($e[0]) : o.title);
      return title;
    },
    tip: function () {
      return this.$tip = this.$tip || $(this.options.template);
    },
    arrow: function () {
      return this.$arrow = this.$arrow || this.tip().find('.tooltip-arrow');
    },
    validate: function () {
      if (!this.$element[0].parentNode) {
        this.hide();
        this.$element = null;
        this.options = null;
      }
    },
    enable: function () {
      this.enabled = true;
    },
    disable: function () {
      this.enabled = false;
    },
    toggleEnabled: function () {
      this.enabled = !this.enabled;
    },
    toggle: function (e) {
      var self = e ? $(e.currentTarget)[this.type](this._options).data(this.type) : this;
      self.tip().hasClass('in') ? self.hide() : self.show();
    },
    destroy: function () {
      this.hide().$element.off('.' + this.type).removeData(this.type);
    }
  };
  var old = $.fn.tooltip;
  $.fn.tooltip = function (option) {
    return this.each(function () {
      var $this = $(this), data = $this.data('tooltip'), options = typeof option == 'object' && option;
      if (!data)
        $this.data('tooltip', data = new Tooltip(this, options));
      if (typeof option == 'string')
        data[option]();
    });
  };
  $.fn.tooltip.Constructor = Tooltip;
  $.fn.tooltip.defaults = {
    animation: true,
    placement: 'top',
    selector: false,
    template: '<div class="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>',
    trigger: 'hover focus',
    title: '',
    delay: 0,
    html: false,
    container: false
  };
  $.fn.tooltip.noConflict = function () {
    $.fn.tooltip = old;
    return this;
  };
}(window.jQuery);
!function ($) {
  'use strict';
  var Popover = function (element, options) {
    this.init('popover', element, options);
  };
  Popover.prototype = $.extend({}, $.fn.tooltip.Constructor.prototype, {
    constructor: Popover,
    setContent: function () {
      var $tip = this.tip(), title = this.getTitle(), content = this.getContent();
      $tip.find('.popover-title')[this.options.html ? 'html' : 'text'](title);
      $tip.find('.popover-content')[this.options.html ? 'html' : 'text'](content);
      $tip.removeClass('fade top bottom left right in');
    },
    hasContent: function () {
      return this.getTitle() || this.getContent();
    },
    getContent: function () {
      var content, $e = this.$element, o = this.options;
      content = (typeof o.content == 'function' ? o.content.call($e[0]) : o.content) || $e.attr('data-content');
      return content;
    },
    tip: function () {
      if (!this.$tip) {
        this.$tip = $(this.options.template);
      }
      return this.$tip;
    },
    destroy: function () {
      this.hide().$element.off('.' + this.type).removeData(this.type);
    }
  });
  var old = $.fn.popover;
  $.fn.popover = function (option) {
    return this.each(function () {
      var $this = $(this), data = $this.data('popover'), options = typeof option == 'object' && option;
      if (!data)
        $this.data('popover', data = new Popover(this, options));
      if (typeof option == 'string')
        data[option]();
    });
  };
  $.fn.popover.Constructor = Popover;
  $.fn.popover.defaults = $.extend({}, $.fn.tooltip.defaults, {
    placement: 'right',
    trigger: 'click',
    content: '',
    template: '<div class="popover"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>'
  });
  $.fn.popover.noConflict = function () {
    $.fn.popover = old;
    return this;
  };
}(window.jQuery);
!function ($) {
  'use strict';
  function ScrollSpy(element, options) {
    var process = $.proxy(this.process, this), $element = $(element).is('body') ? $(window) : $(element), href;
    this.options = $.extend({}, $.fn.scrollspy.defaults, options);
    this.$scrollElement = $element.on('scroll.scroll-spy.data-api', process);
    this.selector = (this.options.target || (href = $(element).attr('href')) && href.replace(/.*(?=#[^\s]+$)/, '') || '') + ' .nav li > a';
    this.$body = $('body');
    this.refresh();
    this.process();
  }
  ScrollSpy.prototype = {
    constructor: ScrollSpy,
    refresh: function () {
      var self = this, $targets;
      this.offsets = $([]);
      this.targets = $([]);
      $targets = this.$body.find(this.selector).map(function () {
        var $el = $(this), href = $el.data('target') || $el.attr('href'), $href = /^#\w/.test(href) && $(href);
        return $href && $href.length && [[
            $href.position().top + (!$.isWindow(self.$scrollElement.get(0)) && self.$scrollElement.scrollTop()),
            href
          ]] || null;
      }).sort(function (a, b) {
        return a[0] - b[0];
      }).each(function () {
        self.offsets.push(this[0]);
        self.targets.push(this[1]);
      });
    },
    process: function () {
      var scrollTop = this.$scrollElement.scrollTop() + this.options.offset, scrollHeight = this.$scrollElement[0].scrollHeight || this.$body[0].scrollHeight, maxScroll = scrollHeight - this.$scrollElement.height(), offsets = this.offsets, targets = this.targets, activeTarget = this.activeTarget, i;
      if (scrollTop >= maxScroll) {
        return activeTarget != (i = targets.last()[0]) && this.activate(i);
      }
      for (i = offsets.length; i--;) {
        activeTarget != targets[i] && scrollTop >= offsets[i] && (!offsets[i + 1] || scrollTop <= offsets[i + 1]) && this.activate(targets[i]);
      }
    },
    activate: function (target) {
      var active, selector;
      this.activeTarget = target;
      $(this.selector).parent('.active').removeClass('active');
      selector = this.selector + '[data-target="' + target + '"],' + this.selector + '[href="' + target + '"]';
      active = $(selector).parent('li').addClass('active');
      if (active.parent('.dropdown-menu').length) {
        active = active.closest('li.dropdown').addClass('active');
      }
      active.trigger('activate');
    }
  };
  var old = $.fn.scrollspy;
  $.fn.scrollspy = function (option) {
    return this.each(function () {
      var $this = $(this), data = $this.data('scrollspy'), options = typeof option == 'object' && option;
      if (!data)
        $this.data('scrollspy', data = new ScrollSpy(this, options));
      if (typeof option == 'string')
        data[option]();
    });
  };
  $.fn.scrollspy.Constructor = ScrollSpy;
  $.fn.scrollspy.defaults = { offset: 10 };
  $.fn.scrollspy.noConflict = function () {
    $.fn.scrollspy = old;
    return this;
  };
  $(window).on('load', function () {
    $('[data-spy="scroll"]').each(function () {
      var $spy = $(this);
      $spy.scrollspy($spy.data());
    });
  });
}(window.jQuery);
!function ($) {
  'use strict';
  var Tab = function (element) {
    this.element = $(element);
  };
  Tab.prototype = {
    constructor: Tab,
    show: function () {
      var $this = this.element, $ul = $this.closest('ul:not(.dropdown-menu)'), selector = $this.attr('data-target'), previous, $target, e;
      if (!selector) {
        selector = $this.attr('href');
        selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '');
      }
      if ($this.parent('li').hasClass('active'))
        return;
      previous = $ul.find('.active:last a')[0];
      e = $.Event('show', { relatedTarget: previous });
      $this.trigger(e);
      if (e.isDefaultPrevented())
        return;
      $target = $(selector);
      this.activate($this.parent('li'), $ul);
      this.activate($target, $target.parent(), function () {
        $this.trigger({
          type: 'shown',
          relatedTarget: previous
        });
      });
    },
    activate: function (element, container, callback) {
      var $active = container.find('> .active'), transition = callback && $.support.transition && $active.hasClass('fade');
      function next() {
        $active.removeClass('active').find('> .dropdown-menu > .active').removeClass('active');
        element.addClass('active');
        if (transition) {
          element[0].offsetWidth;
          element.addClass('in');
        } else {
          element.removeClass('fade');
        }
        if (element.parent('.dropdown-menu')) {
          element.closest('li.dropdown').addClass('active');
        }
        callback && callback();
      }
      transition ? $active.one($.support.transition.end, next) : next();
      $active.removeClass('in');
    }
  };
  var old = $.fn.tab;
  $.fn.tab = function (option) {
    return this.each(function () {
      var $this = $(this), data = $this.data('tab');
      if (!data)
        $this.data('tab', data = new Tab(this));
      if (typeof option == 'string')
        data[option]();
    });
  };
  $.fn.tab.Constructor = Tab;
  $.fn.tab.noConflict = function () {
    $.fn.tab = old;
    return this;
  };
  $(document).on('click.tab.data-api', '[data-toggle="tab"], [data-toggle="pill"]', function (e) {
    e.preventDefault();
    $(this).tab('show');
  });
}(window.jQuery);
!function ($) {
  'use strict';
  var Typeahead = function (element, options) {
    this.$element = $(element);
    this.options = $.extend({}, $.fn.typeahead.defaults, options);
    this.matcher = this.options.matcher || this.matcher;
    this.sorter = this.options.sorter || this.sorter;
    this.highlighter = this.options.highlighter || this.highlighter;
    this.updater = this.options.updater || this.updater;
    this.source = this.options.source;
    this.$menu = $(this.options.menu);
    this.shown = false;
    this.listen();
  };
  Typeahead.prototype = {
    constructor: Typeahead,
    select: function () {
      var val = this.$menu.find('.active').attr('data-value');
      this.$element.val(this.updater(val)).change();
      return this.hide();
    },
    updater: function (item) {
      return item;
    },
    show: function () {
      var pos = $.extend({}, this.$element.position(), { height: this.$element[0].offsetHeight });
      this.$menu.insertAfter(this.$element).css({
        top: pos.top + pos.height,
        left: pos.left
      }).show();
      this.shown = true;
      return this;
    },
    hide: function () {
      this.$menu.hide();
      this.shown = false;
      return this;
    },
    lookup: function (event) {
      var items;
      this.query = this.$element.val();
      if (!this.query || this.query.length < this.options.minLength) {
        return this.shown ? this.hide() : this;
      }
      items = $.isFunction(this.source) ? this.source(this.query, $.proxy(this.process, this)) : this.source;
      return items ? this.process(items) : this;
    },
    process: function (items) {
      var that = this;
      items = $.grep(items, function (item) {
        return that.matcher(item);
      });
      items = this.sorter(items);
      if (!items.length) {
        return this.shown ? this.hide() : this;
      }
      return this.render(items.slice(0, this.options.items)).show();
    },
    matcher: function (item) {
      return ~item.toLowerCase().indexOf(this.query.toLowerCase());
    },
    sorter: function (items) {
      var beginswith = [], caseSensitive = [], caseInsensitive = [], item;
      while (item = items.shift()) {
        if (!item.toLowerCase().indexOf(this.query.toLowerCase()))
          beginswith.push(item);
        else if (~item.indexOf(this.query))
          caseSensitive.push(item);
        else
          caseInsensitive.push(item);
      }
      return beginswith.concat(caseSensitive, caseInsensitive);
    },
    highlighter: function (item) {
      var query = this.query.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, '\\$&');
      return item.replace(new RegExp('(' + query + ')', 'ig'), function ($1, match) {
        return '<strong>' + match + '</strong>';
      });
    },
    render: function (items) {
      var that = this;
      items = $(items).map(function (i, item) {
        i = $(that.options.item).attr('data-value', item);
        i.find('a').html(that.highlighter(item));
        return i[0];
      });
      items.first().addClass('active');
      this.$menu.html(items);
      return this;
    },
    next: function (event) {
      var active = this.$menu.find('.active').removeClass('active'), next = active.next();
      if (!next.length) {
        next = $(this.$menu.find('li')[0]);
      }
      next.addClass('active');
    },
    prev: function (event) {
      var active = this.$menu.find('.active').removeClass('active'), prev = active.prev();
      if (!prev.length) {
        prev = this.$menu.find('li').last();
      }
      prev.addClass('active');
    },
    listen: function () {
      this.$element.on('focus', $.proxy(this.focus, this)).on('blur', $.proxy(this.blur, this)).on('keypress', $.proxy(this.keypress, this)).on('keyup', $.proxy(this.keyup, this));
      if (this.eventSupported('keydown')) {
        this.$element.on('keydown', $.proxy(this.keydown, this));
      }
      this.$menu.on('click', $.proxy(this.click, this)).on('mouseenter', 'li', $.proxy(this.mouseenter, this)).on('mouseleave', 'li', $.proxy(this.mouseleave, this));
    },
    eventSupported: function (eventName) {
      var isSupported = eventName in this.$element;
      if (!isSupported) {
        this.$element.setAttribute(eventName, 'return;');
        isSupported = typeof this.$element[eventName] === 'function';
      }
      return isSupported;
    },
    move: function (e) {
      if (!this.shown)
        return;
      switch (e.keyCode) {
      case 9:
      case 13:
      case 27:
        e.preventDefault();
        break;
      case 38:
        e.preventDefault();
        this.prev();
        break;
      case 40:
        e.preventDefault();
        this.next();
        break;
      }
      e.stopPropagation();
    },
    keydown: function (e) {
      this.suppressKeyPressRepeat = ~$.inArray(e.keyCode, [
        40,
        38,
        9,
        13,
        27
      ]);
      this.move(e);
    },
    keypress: function (e) {
      if (this.suppressKeyPressRepeat)
        return;
      this.move(e);
    },
    keyup: function (e) {
      switch (e.keyCode) {
      case 40:
      case 38:
      case 16:
      case 17:
      case 18:
        break;
      case 9:
      case 13:
        if (!this.shown)
          return;
        this.select();
        break;
      case 27:
        if (!this.shown)
          return;
        this.hide();
        break;
      default:
        this.lookup();
      }
      e.stopPropagation();
      e.preventDefault();
    },
    focus: function (e) {
      this.focused = true;
    },
    blur: function (e) {
      this.focused = false;
      if (!this.mousedover && this.shown)
        this.hide();
    },
    click: function (e) {
      e.stopPropagation();
      e.preventDefault();
      this.select();
      this.$element.focus();
    },
    mouseenter: function (e) {
      this.mousedover = true;
      this.$menu.find('.active').removeClass('active');
      $(e.currentTarget).addClass('active');
    },
    mouseleave: function (e) {
      this.mousedover = false;
      if (!this.focused && this.shown)
        this.hide();
    }
  };
  var old = $.fn.typeahead;
  $.fn.typeahead = function (option) {
    return this.each(function () {
      var $this = $(this), data = $this.data('typeahead'), options = typeof option == 'object' && option;
      if (!data)
        $this.data('typeahead', data = new Typeahead(this, options));
      if (typeof option == 'string')
        data[option]();
    });
  };
  $.fn.typeahead.defaults = {
    source: [],
    items: 8,
    menu: '<ul class="typeahead dropdown-menu"></ul>',
    item: '<li><a href="#"></a></li>',
    minLength: 1
  };
  $.fn.typeahead.Constructor = Typeahead;
  $.fn.typeahead.noConflict = function () {
    $.fn.typeahead = old;
    return this;
  };
  $(document).on('focus.typeahead.data-api', '[data-provide="typeahead"]', function (e) {
    var $this = $(this);
    if ($this.data('typeahead'))
      return;
    $this.typeahead($this.data());
  });
}(window.jQuery);
!function ($) {
  'use strict';
  var Affix = function (element, options) {
    this.options = $.extend({}, $.fn.affix.defaults, options);
    this.$window = $(window).on('scroll.affix.data-api', $.proxy(this.checkPosition, this)).on('click.affix.data-api', $.proxy(function () {
      setTimeout($.proxy(this.checkPosition, this), 1);
    }, this));
    this.$element = $(element);
    this.checkPosition();
  };
  Affix.prototype.checkPosition = function () {
    if (!this.$element.is(':visible'))
      return;
    var scrollHeight = $(document).height(), scrollTop = this.$window.scrollTop(), position = this.$element.offset(), offset = this.options.offset, offsetBottom = offset.bottom, offsetTop = offset.top, reset = 'affix affix-top affix-bottom', affix;
    if (typeof offset != 'object')
      offsetBottom = offsetTop = offset;
    if (typeof offsetTop == 'function')
      offsetTop = offset.top();
    if (typeof offsetBottom == 'function')
      offsetBottom = offset.bottom();
    affix = this.unpin != null && scrollTop + this.unpin <= position.top ? false : offsetBottom != null && position.top + this.$element.height() >= scrollHeight - offsetBottom ? 'bottom' : offsetTop != null && scrollTop <= offsetTop ? 'top' : false;
    if (this.affixed === affix)
      return;
    this.affixed = affix;
    this.unpin = affix == 'bottom' ? position.top - scrollTop : null;
    this.$element.removeClass(reset).addClass('affix' + (affix ? '-' + affix : ''));
  };
  var old = $.fn.affix;
  $.fn.affix = function (option) {
    return this.each(function () {
      var $this = $(this), data = $this.data('affix'), options = typeof option == 'object' && option;
      if (!data)
        $this.data('affix', data = new Affix(this, options));
      if (typeof option == 'string')
        data[option]();
    });
  };
  $.fn.affix.Constructor = Affix;
  $.fn.affix.defaults = { offset: 0 };
  $.fn.affix.noConflict = function () {
    $.fn.affix = old;
    return this;
  };
  $(window).on('load', function () {
    $('[data-spy="affix"]').each(function () {
      var $spy = $(this), data = $spy.data();
      data.offset = data.offset || {};
      data.offsetBottom && (data.offset.bottom = data.offsetBottom);
      data.offsetTop && (data.offset.top = data.offsetTop);
      $spy.affix(data);
    });
  });
}(window.jQuery);
(function (global) {
  var emojify = function () {
      var document = global.window.document;
      var findText = function (element, pattern, callback) {
        for (var childi = element.childNodes.length; childi-- > 0;) {
          var child = element.childNodes[childi];
          if (child.nodeType == 1) {
            var tag = child.tagName.toLowerCase(), classname;
            if (child.hasAttribute('class'))
              classname = child.getAttribute('class').toLowerCase();
            if (classname) {
              if (tag !== 'script' && tag !== 'style' && tag !== 'textarea' && classname !== 'no-emojify')
                findText(child, pattern, callback);
            } else {
              if (tag !== 'script' && tag !== 'style' && tag !== 'textarea')
                findText(child, pattern, callback);
            }
          } else if (child.nodeType == 3) {
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
          el = el ? el : document.body;
          var selected_sets = [];
          if (this.config.people_enabled)
            selected_sets.push(PEOPLE);
          if (this.config.nature_enabled)
            selected_sets.push(NATURE);
          if (this.config.objects_enabled)
            selected_sets.push(OBJECTS);
          if (this.config.places_enabled)
            selected_sets.push(PLACES);
          if (this.config.symbols_enabled)
            selected_sets.push(SYMBOLS);
          if (this.config.emoticons_enabled)
            selected_sets.push(EMOTICONS);
          for (var index = 0; index < selected_sets.length; index++) {
            var r;
            while (r = selected_sets[index].shift()) {
              findText(el, r[0], function (node, match) {
                var wrap = document.createElement(this.emojify.config.emojify_tag_type);
                wrap.setAttribute('class', r[1]);
                title = r[1].replace(/emojify /g, '');
                wrap.setAttribute('src', this.emojify.config.cdn_host + '/' + title + '.' + this.emojify.config.emoji_image_extension);
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
    }();
  global.emojify = emojify;
  var EMOTICONS = [
      [
        /:-*\)/g,
        'emojify blush'
      ],
      [
        /:-*o/gi,
        'emojify scream'
      ],
      [
        /(:|;)-*]/g,
        'emojify smirk'
      ],
      [
        /(:|;)-*d/gi,
        'emojify smiley'
      ],
      [
        /xd/gi,
        'emojify stuck_out_tongue_closed_eyes'
      ],
      [
        /:-*p/gi,
        'emojify stuck_out_tongue_winking_eye'
      ],
      [
        /:-*(\[|@)/g,
        'emojify rage'
      ],
      [
        /:-*\(/g,
        'emojify disappointed'
      ],
      [
        /:('|’)-*\(/g,
        'emojify sob'
      ],
      [
        /:-*\*/g,
        'emojify kissing_heart'
      ],
      [
        /;-*\)/g,
        'emojify wink'
      ],
      [
        /:-*\//g,
        'emojify pensive'
      ],
      [
        /:-*s/gi,
        'emojify confounded'
      ],
      [
        /:-*\|/g,
        'emojify flushed'
      ],
      [
        /:-*\$/g,
        'emojify relaxed'
      ],
      [
        /:-*x/gi,
        'emojify mask'
      ],
      [
        /<3/g,
        'emojify heart'
      ],
      [
        /<\/3/g,
        'emojify broken_heart'
      ]
    ];
  var PEOPLE = [
      [
        /:bowtie:/g,
        'emojify bowtie'
      ],
      [
        /:smile:/g,
        'emojify smile'
      ],
      [
        /:laughing:/g,
        'emojify laughing'
      ],
      [
        /:blush:/g,
        'emojify blush'
      ],
      [
        /:smiley:/g,
        'emojify smiley'
      ],
      [
        /:relaxed:/g,
        'emojify relaxed'
      ],
      [
        /:smirk:/g,
        'emojify smirk'
      ],
      [
        /:heart_eyes:/g,
        'emojify heart_eyes'
      ],
      [
        /:kissing_heart:/g,
        'emojify kissing_heart'
      ],
      [
        /:kissing_closed_eyes:/g,
        'emojify kissing_closed_eyes'
      ],
      [
        /:flushed:/g,
        'emojify flushed'
      ],
      [
        /:relieved:/g,
        'emojify relieved'
      ],
      [
        /:satisfied:/g,
        'emojify satisfied'
      ],
      [
        /:grin:/g,
        'emojify grin'
      ],
      [
        /:wink:/g,
        'emojify wink'
      ],
      [
        /:wink2:/g,
        'emojify wink2'
      ],
      [
        /:stuck_out_tongue_winking_eye:/g,
        'emojify stuck_out_tongue_winking_eye'
      ],
      [
        /:stuck_out_tongue_closed_eyes:/g,
        'emojify stuck_out_tongue_closed_eyes'
      ],
      [
        /:grinning:/g,
        'emojify grinning'
      ],
      [
        /:kissing:/g,
        'emojify kissing'
      ],
      [
        /:kissing_smiling_eyes:/g,
        'emojify kissing_smiling_eyes'
      ],
      [
        /:stuck_out_tongue:/g,
        'emojify stuck_out_tongue'
      ],
      [
        /:sleeping:/g,
        'emojify sleeping'
      ],
      [
        /:worried:/g,
        'emojify worried'
      ],
      [
        /:frowning:/g,
        'emojify frowning'
      ],
      [
        /:anguished:/g,
        'emojify anguished'
      ],
      [
        /:open_mouth:/g,
        'emojify open_mouth'
      ],
      [
        /:grimacing:/g,
        'emojify grimacing'
      ],
      [
        /:confused:/g,
        'emojify confused'
      ],
      [
        /:hushed:/g,
        'emojify hushed'
      ],
      [
        /:expressionless:/g,
        'emojify expressionless'
      ],
      [
        /:unamused:/g,
        'emojify unamused'
      ],
      [
        /:sweat_smile:/g,
        'emojify sweat_smile'
      ],
      [
        /:sweat:/g,
        'emojify sweat'
      ],
      [
        /:weary:/g,
        'emojify weary'
      ],
      [
        /:pensive:/g,
        'emojify pensive'
      ],
      [
        /:disappointed:/g,
        'emojify disappointed'
      ],
      [
        /:confounded:/g,
        'emojify confounded'
      ],
      [
        /:fearful:/g,
        'emojify fearful'
      ],
      [
        /:cold_sweat:/g,
        'emojify cold_sweat'
      ],
      [
        /:persevere:/g,
        'emojify persevere'
      ],
      [
        /:cry:/g,
        'emojify cry'
      ],
      [
        /:sob:/g,
        'emojify sob'
      ],
      [
        /:joy:/g,
        'emojify joy'
      ],
      [
        /:scream:/g,
        'emojify scream'
      ],
      [
        /:astonished:/g,
        'emojify astonished'
      ],
      [
        /:neckbeard:/g,
        'emojify neckbeard'
      ],
      [
        /:tired_face:/g,
        'emojify tired_face'
      ],
      [
        /:angry:/g,
        'emojify angry'
      ],
      [
        /:rage:/g,
        'emojify rage'
      ],
      [
        /:triumph:/g,
        'emojify triumph'
      ],
      [
        /:sleepy:/g,
        'emojify sleepy'
      ],
      [
        /:yum:/g,
        'emojify yum'
      ],
      [
        /:mask:/g,
        'emojify mask'
      ],
      [
        /:sunglasses:/g,
        'emojify sunglasses'
      ],
      [
        /:dizzy_face:/g,
        'emojify dizzy_face'
      ],
      [
        /:imp:/g,
        'emojify imp'
      ],
      [
        /:smiling_imp:/g,
        'emojify smiling_imp'
      ],
      [
        /:neutral_face:/g,
        'emojify neutral_face'
      ],
      [
        /:no_mouth:/g,
        'emojify no_mouth'
      ],
      [
        /:innocent:/g,
        'emojify innocent'
      ],
      [
        /:alien:/g,
        'emojify alien'
      ],
      [
        /:yellow_heart:/g,
        'emojify yellow_heart'
      ],
      [
        /:blue_heart:/g,
        'emojify blue_heart'
      ],
      [
        /:purple_heart:/g,
        'emojify purple_heart'
      ],
      [
        /:heart:/g,
        'emojify heart'
      ],
      [
        /:green_heart:/g,
        'emojify green_heart'
      ],
      [
        /:broken_heart:/g,
        'emojify broken_heart'
      ],
      [
        /:heartbeat:/g,
        'emojify heartbeat'
      ],
      [
        /:heartpulse:/g,
        'emojify heartpulse'
      ],
      [
        /:two_hearts:/g,
        'emojify two_hearts'
      ],
      [
        /:revolving_hearts:/g,
        'emojify revolving_hearts'
      ],
      [
        /:cupid:/g,
        'emojify cupid'
      ],
      [
        /:sparkling_heart:/g,
        'emojify sparkling_heart'
      ],
      [
        /:sparkles:/g,
        'emojify sparkles'
      ],
      [
        /:star:/g,
        'emojify star'
      ],
      [
        /:star2:/g,
        'emojify star2'
      ],
      [
        /:dizzy:/g,
        'emojify dizzy'
      ],
      [
        /:boom:/g,
        'emojify boom'
      ],
      [
        /:collision:/g,
        'emojify collision'
      ],
      [
        /:anger:/g,
        'emojify anger'
      ],
      [
        /:exclamation:/g,
        'emojify exclamation'
      ],
      [
        /:question:/g,
        'emojify question'
      ],
      [
        /:grey_exclamation:/g,
        'emojify grey_exclamation'
      ],
      [
        /:grey_question:/g,
        'emojify grey_question'
      ],
      [
        /:zzz:/g,
        'emojify zzz'
      ],
      [
        /:dash:/g,
        'emojify dash'
      ],
      [
        /:sweat_drops:/g,
        'emojify sweat_drops'
      ],
      [
        /:notes:/g,
        'emojify notes'
      ],
      [
        /:musical_note:/g,
        'emojify musical_note'
      ],
      [
        /:fire:/g,
        'emojify fire'
      ],
      [
        /:hankey:/g,
        'emojify hankey'
      ],
      [
        /:poop:/g,
        'emojify poop'
      ],
      [
        /:shit:/g,
        'emojify shit'
      ],
      [
        /:thumbsup:|:\+1:/g,
        'emojify thumbsup'
      ],
      [
        /:thumbsdown:|:-1:/g,
        'emojify thumbsdown'
      ],
      [
        /:ok_hand:/g,
        'emojify ok_hand'
      ],
      [
        /:punch:/g,
        'emojify punch'
      ],
      [
        /:facepunch:/g,
        'emojify facepunch'
      ],
      [
        /:fist:/g,
        'emojify fist'
      ],
      [
        /:v:/g,
        'emojify v'
      ],
      [
        /:wave:/g,
        'emojify wave'
      ],
      [
        /:hand:/g,
        'emojify hand'
      ],
      [
        /:open_hands:/g,
        'emojify open_hands'
      ],
      [
        /:point_up:/g,
        'emojify point_up'
      ],
      [
        /:point_down:/g,
        'emojify point_down'
      ],
      [
        /:point_left:/g,
        'emojify point_left'
      ],
      [
        /:point_right:/g,
        'emojify point_right'
      ],
      [
        /:raised_hands:/g,
        'emojify raised_hands'
      ],
      [
        /:pray:/g,
        'emojify pray'
      ],
      [
        /:point_up_2:/g,
        'emojify point_up_2'
      ],
      [
        /:clap:/g,
        'emojify clap'
      ],
      [
        /:muscle:/g,
        'emojify muscle'
      ],
      [
        /:metal:/g,
        'emojify metal'
      ],
      [
        /:walking:/g,
        'emojify walking'
      ],
      [
        /:runner:/g,
        'emojify runner'
      ],
      [
        /:running:/g,
        'emojify running'
      ],
      [
        /:couple:/g,
        'emojify couple'
      ],
      [
        /:family:/g,
        'emojify family'
      ],
      [
        /:two_men_holding_hands:/g,
        'emojify two_men_holding_hands'
      ],
      [
        /:two_women_holding_hands:/g,
        'emojify two_women_holding_hands'
      ],
      [
        /:dancer:/g,
        'emojify dancer'
      ],
      [
        /:dancers:/g,
        'emojify dancers'
      ],
      [
        /:ok_woman:/g,
        'emojify ok_woman'
      ],
      [
        /:no_good:/g,
        'emojify no_good'
      ],
      [
        /:information_desk_person:/g,
        'emojify information_desk_person'
      ],
      [
        /:raised_hand:/g,
        'emojify raised_hand'
      ],
      [
        /:bride_with_veil:/g,
        'emojify bride_with_veil'
      ],
      [
        /:person_with_pouting_face:/g,
        'emojify person_with_pouting_face'
      ],
      [
        /:person_frowning:/g,
        'emojify person_frowning'
      ],
      [
        /:bow:/g,
        'emojify bow'
      ],
      [
        /:couplekiss:/g,
        'emojify couplekiss'
      ],
      [
        /:couple_with_heart:/g,
        'emojify couple_with_heart'
      ],
      [
        /:massage:/g,
        'emojify massage'
      ],
      [
        /:haircut:/g,
        'emojify haircut'
      ],
      [
        /:nail_care:/g,
        'emojify nail_care'
      ],
      [
        /:boy:/g,
        'emojify boy'
      ],
      [
        /:girl:/g,
        'emojify girl'
      ],
      [
        /:woman:/g,
        'emojify woman'
      ],
      [
        /:man:/g,
        'emojify man'
      ],
      [
        /:baby:/g,
        'emojify baby'
      ],
      [
        /:older_woman:/g,
        'emojify older_woman'
      ],
      [
        /:older_man:/g,
        'emojify older_man'
      ],
      [
        /:person_with_blond_hair:/g,
        'emojify person_with_blond_hair'
      ],
      [
        /:man_with_gua_pi_mao:/g,
        'emojify man_with_gua_pi_mao'
      ],
      [
        /:man_with_turban:/g,
        'emojify man_with_turban'
      ],
      [
        /:construction_worker:/g,
        'emojify construction_worker'
      ],
      [
        /:cop:/g,
        'emojify cop'
      ],
      [
        /:angel:/g,
        'emojify angel'
      ],
      [
        /:princess:/g,
        'emojify princess'
      ],
      [
        /:smiley_cat:/g,
        'emojify smiley_cat'
      ],
      [
        /:smile_cat:/g,
        'emojify smile_cat'
      ],
      [
        /:heart_eyes_cat:/g,
        'emojify heart_eyes_cat'
      ],
      [
        /:kissing_cat:/g,
        'emojify kissing_cat'
      ],
      [
        /:smirk_cat:/g,
        'emojify smirk_cat'
      ],
      [
        /:scream_cat:/g,
        'emojify scream_cat'
      ],
      [
        /:crying_cat_face:/g,
        'emojify crying_cat_face'
      ],
      [
        /:joy_cat:/g,
        'emojify joy_cat'
      ],
      [
        /:pouting_cat:/g,
        'emojify pouting_cat'
      ],
      [
        /:japanese_ogre:/g,
        'emojify japanese_ogre'
      ],
      [
        /:japanese_goblin:/g,
        'emojify japanese_goblin'
      ],
      [
        /:see_no_evil:/g,
        'emojify see_no_evil'
      ],
      [
        /:hear_no_evil:/g,
        'emojify hear_no_evil'
      ],
      [
        /:speak_no_evil:/g,
        'emojify speak_no_evil'
      ],
      [
        /:guardsman:/g,
        'emojify guardsman'
      ],
      [
        /:skull:/g,
        'emojify skull'
      ],
      [
        /:feet:/g,
        'emojify feet'
      ],
      [
        /:lips:/g,
        'emojify lips'
      ],
      [
        /:kiss:/g,
        'emojify kiss'
      ],
      [
        /:droplet:/g,
        'emojify droplet'
      ],
      [
        /:ear:/g,
        'emojify ear'
      ],
      [
        /:eyes:/g,
        'emojify eyes'
      ],
      [
        /:nose:/g,
        'emojify nose'
      ],
      [
        /:tongue:/g,
        'emojify tongue'
      ],
      [
        /:love_letter:/g,
        'emojify love_letter'
      ],
      [
        /:bust_in_silhouette:/g,
        'emojify bust_in_silhouette'
      ],
      [
        /:busts_in_silhouette:/g,
        'emojify busts_in_silhouette'
      ],
      [
        /:speech_balloon:/g,
        'emojify speech_balloon'
      ],
      [
        /:thought_balloon:/g,
        'emojify thought_balloon'
      ],
      [
        /:feelsgood:/g,
        'emojify feelsgood'
      ],
      [
        /:finnadie:/g,
        'emojify finnadie'
      ],
      [
        /:goberserk:/g,
        'emojify goberserk'
      ],
      [
        /:godmode:/g,
        'emojify godmode'
      ],
      [
        /:hurtrealbad:/g,
        'emojify hurtrealbad'
      ],
      [
        /:rage1:/g,
        'emojify rage1'
      ],
      [
        /:rage2:/g,
        'emojify rage2'
      ],
      [
        /:rage3:/g,
        'emojify rage3'
      ],
      [
        /:rage4:/g,
        'emojify rage4'
      ],
      [
        /:suspect:/g,
        'emojify suspect'
      ],
      [
        /:trollface:/g,
        'emojify trollface'
      ]
    ];
  var NATURE = [
      [
        /:sunny:/g,
        'emojify sunny'
      ],
      [
        /:umbrella:/g,
        'emojify umbrella'
      ],
      [
        /:cloud:/g,
        'emojify cloud'
      ],
      [
        /:snowflake:/g,
        'emojify snowflake'
      ],
      [
        /:snowman:/g,
        'emojify snowman'
      ],
      [
        /:zap:/g,
        'emojify zap'
      ],
      [
        /:cyclone:/g,
        'emojify cyclone'
      ],
      [
        /:foggy:/g,
        'emojify foggy'
      ],
      [
        /:ocean:/g,
        'emojify ocean'
      ],
      [
        /:cat:/g,
        'emojify cat'
      ],
      [
        /:dog:/g,
        'emojify dog'
      ],
      [
        /:mouse:/g,
        'emojify mouse'
      ],
      [
        /:hamster:/g,
        'emojify hamster'
      ],
      [
        /:rabbit:/g,
        'emojify rabbit'
      ],
      [
        /:wolf:/g,
        'emojify wolf'
      ],
      [
        /:frog:/g,
        'emojify frog'
      ],
      [
        /:tiger:/g,
        'emojify tiger'
      ],
      [
        /:koala:/g,
        'emojify koala'
      ],
      [
        /:bear:/g,
        'emojify bear'
      ],
      [
        /:pig:/g,
        'emojify pig'
      ],
      [
        /:pig_nose:/g,
        'emojify pig_nose'
      ],
      [
        /:cow:/g,
        'emojify cow'
      ],
      [
        /:boar:/g,
        'emojify boar'
      ],
      [
        /:monkey_face:/g,
        'emojify monkey_face'
      ],
      [
        /:monkey:/g,
        'emojify monkey'
      ],
      [
        /:horse:/g,
        'emojify horse'
      ],
      [
        /:racehorse:/g,
        'emojify racehorse'
      ],
      [
        /:camel:/g,
        'emojify camel'
      ],
      [
        /:sheep:/g,
        'emojify sheep'
      ],
      [
        /:elephant:/g,
        'emojify elephant'
      ],
      [
        /:panda_face:/g,
        'emojify panda_face'
      ],
      [
        /:snake:/g,
        'emojify snake'
      ],
      [
        /:bird:/g,
        'emojify bird'
      ],
      [
        /:baby_chick:/g,
        'emojify baby_chick'
      ],
      [
        /:hatched_chick:/g,
        'emojify hatched_chick'
      ],
      [
        /:hatching_chick:/g,
        'emojify hatching_chick'
      ],
      [
        /:chicken:/g,
        'emojify chicken'
      ],
      [
        /:penguin:/g,
        'emojify penguin'
      ],
      [
        /:turtle:/g,
        'emojify turtle'
      ],
      [
        /:bug:/g,
        'emojify bug'
      ],
      [
        /:honeybee:/g,
        'emojify honeybee'
      ],
      [
        /:ant:/g,
        'emojify ant'
      ],
      [
        /:beetle:/g,
        'emojify beetle'
      ],
      [
        /:snail:/g,
        'emojify snail'
      ],
      [
        /:octopus:/g,
        'emojify octopus'
      ],
      [
        /:tropical_fish:/g,
        'emojify tropical_fish'
      ],
      [
        /:fish:/g,
        'emojify fish'
      ],
      [
        /:whale:/g,
        'emojify whale'
      ],
      [
        /:whale2:/g,
        'emojify whale2'
      ],
      [
        /:dolphin:/g,
        'emojify dolphin'
      ],
      [
        /:cow2:/g,
        'emojify cow2'
      ],
      [
        /:ram:/g,
        'emojify ram'
      ],
      [
        /:rat:/g,
        'emojify rat'
      ],
      [
        /:water_buffalo:/g,
        'emojify water_buffalo'
      ],
      [
        /:tiger2:/g,
        'emojify tiger2'
      ],
      [
        /:rabbit2:/g,
        'emojify rabbit2'
      ],
      [
        /:dragon:/g,
        'emojify dragon'
      ],
      [
        /:goat:/g,
        'emojify goat'
      ],
      [
        /:rooster:/g,
        'emojify rooster'
      ],
      [
        /:dog2:/g,
        'emojify dog2'
      ],
      [
        /:pig2:/g,
        'emojify pig2'
      ],
      [
        /:mouse2:/g,
        'emojify mouse2'
      ],
      [
        /:ox:/g,
        'emojify ox'
      ],
      [
        /:dragon_face:/g,
        'emojify dragon_face'
      ],
      [
        /:blowfish:/g,
        'emojify blowfish'
      ],
      [
        /:crocodile:/g,
        'emojify crocodile'
      ],
      [
        /:dromedary_camel:/g,
        'emojify dromedary_camel'
      ],
      [
        /:leopard:/g,
        'emojify leopard'
      ],
      [
        /:cat2:/g,
        'emojify cat2'
      ],
      [
        /:poodle:/g,
        'emojify poodle'
      ],
      [
        /:paw_prints:/g,
        'emojify paw_prints'
      ],
      [
        /:bouquet:/g,
        'emojify bouquet'
      ],
      [
        /:cherry_blossom:/g,
        'emojify cherry_blossom'
      ],
      [
        /:tulip:/g,
        'emojify tulip'
      ],
      [
        /:four_leaf_clover:/g,
        'emojify four_leaf_clover'
      ],
      [
        /:rose:/g,
        'emojify rose'
      ],
      [
        /:sunflower:/g,
        'emojify sunflower'
      ],
      [
        /:hibiscus:/g,
        'emojify hibiscus'
      ],
      [
        /:maple_leaf:/g,
        'emojify maple_leaf'
      ],
      [
        /:leaves:/g,
        'emojify leaves'
      ],
      [
        /:fallen_leaf:/g,
        'emojify fallen_leaf'
      ],
      [
        /:herb:/g,
        'emojify herb'
      ],
      [
        /:mushroom:/g,
        'emojify mushroom'
      ],
      [
        /:cactus:/g,
        'emojify cactus'
      ],
      [
        /:palm_tree:/g,
        'emojify palm_tree'
      ],
      [
        /:evergreen_tree:/g,
        'emojify evergreen_tree'
      ],
      [
        /:deciduous_tree:/g,
        'emojify deciduous_tree'
      ],
      [
        /:chestnut:/g,
        'emojify chestnut'
      ],
      [
        /:seedling:/g,
        'emojify seedling'
      ],
      [
        /:blossom:/g,
        'emojify blossom'
      ],
      [
        /:ear_of_rice:/g,
        'emojify ear_of_rice'
      ],
      [
        /:shell:/g,
        'emojify shell'
      ],
      [
        /:globe_with_meridians:/g,
        'emojify globe_with_meridians'
      ],
      [
        /:sun_with_face:/g,
        'emojify sun_with_face'
      ],
      [
        /:full_moon_with_face:/g,
        'emojify full_moon_with_face'
      ],
      [
        /:new_moon_with_face:/g,
        'emojify new_moon_with_face'
      ],
      [
        /:new_moon:/g,
        'emojify new_moon'
      ],
      [
        /:waxing_crescent_moon:/g,
        'emojify waxing_crescent_moon'
      ],
      [
        /:first_quarter_moon:/g,
        'emojify first_quarter_moon'
      ],
      [
        /:waxing_gibbous_moon:/g,
        'emojify waxing_gibbous_moon'
      ],
      [
        /:full_moon:/g,
        'emojify full_moon'
      ],
      [
        /:waning_gibbous_moon:/g,
        'emojify waning_gibbous_moon'
      ],
      [
        /:last_quarter_moon:/g,
        'emojify last_quarter_moon'
      ],
      [
        /:waning_crescent_moon:/g,
        'emojify waning_crescent_moon'
      ],
      [
        /:last_quarter_moon_with_face:/g,
        'emojify last_quarter_moon_with_face'
      ],
      [
        /:first_quarter_moon_with_face:/g,
        'emojify first_quarter_moon_with_face'
      ],
      [
        /:moon:/g,
        'emojify moon'
      ],
      [
        /:earth_africa:/g,
        'emojify earth_africa'
      ],
      [
        /:earth_americas:/g,
        'emojify earth_americas'
      ],
      [
        /:earth_asia:/g,
        'emojify earth_asia'
      ],
      [
        /:volcano:/g,
        'emojify volcano'
      ],
      [
        /:milky_way:/g,
        'emojify milky_way'
      ],
      [
        /:partly_sunny:/g,
        'emojify partly_sunny'
      ],
      [
        /:octocat:/g,
        'emojify octocat'
      ],
      [
        /:squirrel:/g,
        'emojify squirrel'
      ]
    ];
  var OBJECTS = [
      [
        /:bamboo:/g,
        'emojify bamboo'
      ],
      [
        /:gift_heart:/g,
        'emojify gift_heart'
      ],
      [
        /:dolls:/g,
        'emojify dolls'
      ],
      [
        /:school_satchel:/g,
        'emojify school_satchel'
      ],
      [
        /:mortar_board:/g,
        'emojify mortar_board'
      ],
      [
        /:flags:/g,
        'emojify flags'
      ],
      [
        /:fireworks:/g,
        'emojify fireworks'
      ],
      [
        /:sparkler:/g,
        'emojify sparkler'
      ],
      [
        /:wind_chime:/g,
        'emojify wind_chime'
      ],
      [
        /:rice_scene:/g,
        'emojify rice_scene'
      ],
      [
        /:jack_o_lantern:/g,
        'emojify jack_o_lantern'
      ],
      [
        /:ghost:/g,
        'emojify ghost'
      ],
      [
        /:santa:/g,
        'emojify santa'
      ],
      [
        /:christmas_tree:/g,
        'emojify christmas_tree'
      ],
      [
        /:gift:/g,
        'emojify gift'
      ],
      [
        /:bell:/g,
        'emojify bell'
      ],
      [
        /:no_bell:/g,
        'emojify no_bell'
      ],
      [
        /:tanabata_tree:/g,
        'emojify tanabata_tree'
      ],
      [
        /:tada:/g,
        'emojify tada'
      ],
      [
        /:confetti_ball:/g,
        'emojify confetti_ball'
      ],
      [
        /:balloon:/g,
        'emojify balloon'
      ],
      [
        /:crystal_ball:/g,
        'emojify crystal_ball'
      ],
      [
        /:cd:/g,
        'emojify cd'
      ],
      [
        /:dvd:/g,
        'emojify dvd'
      ],
      [
        /:floppy_disk:/g,
        'emojify floppy_disk'
      ],
      [
        /:camera:/g,
        'emojify camera'
      ],
      [
        /:video_camera:/g,
        'emojify video_camera'
      ],
      [
        /:movie_camera:/g,
        'emojify movie_camera'
      ],
      [
        /:computer:/g,
        'emojify computer'
      ],
      [
        /:tv:/g,
        'emojify tv'
      ],
      [
        /:iphone:/g,
        'emojify iphone'
      ],
      [
        /:phone:/g,
        'emojify phone'
      ],
      [
        /:telephone:/g,
        'emojify telephone'
      ],
      [
        /:telephone_receiver:/g,
        'emojify telephone_receiver'
      ],
      [
        /:pager:/g,
        'emojify pager'
      ],
      [
        /:fax:/g,
        'emojify fax'
      ],
      [
        /:minidisc:/g,
        'emojify minidisc'
      ],
      [
        /:vhs:/g,
        'emojify vhs'
      ],
      [
        /:sound:/g,
        'emojify sound'
      ],
      [
        /:speaker:/g,
        'emojify speaker'
      ],
      [
        /:mute:/g,
        'emojify mute'
      ],
      [
        /:loudspeaker:/g,
        'emojify loudspeaker'
      ],
      [
        /:mega:/g,
        'emojify mega'
      ],
      [
        /:hourglass:/g,
        'emojify hourglass'
      ],
      [
        /:hourglass_flowing_sand:/g,
        'emojify hourglass_flowing_sand'
      ],
      [
        /:alarm_clock:/g,
        'emojify alarm_clock'
      ],
      [
        /:watch:/g,
        'emojify watch'
      ],
      [
        /:radio:/g,
        'emojify radio'
      ],
      [
        /:satellite:/g,
        'emojify satellite'
      ],
      [
        /:loop:/g,
        'emojify loop'
      ],
      [
        /:mag:/g,
        'emojify mag'
      ],
      [
        /:mag_right:/g,
        'emojify mag_right'
      ],
      [
        /:unlock:/g,
        'emojify unlock'
      ],
      [
        /:lock:/g,
        'emojify lock'
      ],
      [
        /:lock_with_ink_pen:/g,
        'emojify lock_with_ink_pen'
      ],
      [
        /:closed_lock_with_key:/g,
        'emojify closed_lock_with_key'
      ],
      [
        /:key:/g,
        'emojify key'
      ],
      [
        /:bulb:/g,
        'emojify bulb'
      ],
      [
        /:flashlight:/g,
        'emojify flashlight'
      ],
      [
        /:high_brightness:/g,
        'emojify high_brightness'
      ],
      [
        /:low_brightness:/g,
        'emojify low_brightness'
      ],
      [
        /:electric_plug:/g,
        'emojify electric_plug'
      ],
      [
        /:battery:/g,
        'emojify battery'
      ],
      [
        /:calling:/g,
        'emojify calling'
      ],
      [
        /:email:/g,
        'emojify email'
      ],
      [
        /:mailbox:/g,
        'emojify mailbox'
      ],
      [
        /:postbox:/g,
        'emojify postbox'
      ],
      [
        /:bath:/g,
        'emojify bath'
      ],
      [
        /:bathtub:/g,
        'emojify bathtub'
      ],
      [
        /:shower:/g,
        'emojify shower'
      ],
      [
        /:toilet:/g,
        'emojify toilet'
      ],
      [
        /:wrench:/g,
        'emojify wrench'
      ],
      [
        /:nut_and_bolt:/g,
        'emojify nut_and_bolt'
      ],
      [
        /:hammer:/g,
        'emojify hammer'
      ],
      [
        /:seat:/g,
        'emojify seat'
      ],
      [
        /:moneybag:/g,
        'emojify moneybag'
      ],
      [
        /:yen:/g,
        'emojify yen'
      ],
      [
        /:dollar:/g,
        'emojify dollar'
      ],
      [
        /:pound:/g,
        'emojify pound'
      ],
      [
        /:euro:/g,
        'emojify euro'
      ],
      [
        /:credit_card:/g,
        'emojify credit_card'
      ],
      [
        /:money_with_wings:/g,
        'emojify money_with_wings'
      ],
      [
        /:e-mail:/g,
        'emojify e-mail'
      ],
      [
        /:inbox_tray:/g,
        'emojify inbox_tray'
      ],
      [
        /:outbox_tray:/g,
        'emojify outbox_tray'
      ],
      [
        /:envelope:/g,
        'emojify envelope'
      ],
      [
        /:incoming_envelope:/g,
        'emojify incoming_envelope'
      ],
      [
        /:postal_horn:/g,
        'emojify postal_horn'
      ],
      [
        /:mailbox_closed:/g,
        'emojify mailbox_closed'
      ],
      [
        /:mailbox_with_mail:/g,
        'emojify mailbox_with_mail'
      ],
      [
        /:mailbox_with_no_mail:/g,
        'emojify mailbox_with_no_mail'
      ],
      [
        /:door:/g,
        'emojify door'
      ],
      [
        /:smoking:/g,
        'emojify smoking'
      ],
      [
        /:bomb:/g,
        'emojify bomb'
      ],
      [
        /:gun:/g,
        'emojify gun'
      ],
      [
        /:hocho:/g,
        'emojify hocho'
      ],
      [
        /:pill:/g,
        'emojify pill'
      ],
      [
        /:syringe:/g,
        'emojify syringe'
      ],
      [
        /:page_facing_up:/g,
        'emojify page_facing_up'
      ],
      [
        /:page_with_curl:/g,
        'emojify page_with_curl'
      ],
      [
        /:bookmark_tabs:/g,
        'emojify bookmark_tabs'
      ],
      [
        /:bar_chart:/g,
        'emojify bar_chart'
      ],
      [
        /:chart_with_upwards_trend:/g,
        'emojify chart_with_upwards_trend'
      ],
      [
        /:chart_with_downwards_trend:/g,
        'emojify chart_with_downwards_trend'
      ],
      [
        /:scroll:/g,
        'emojify scroll'
      ],
      [
        /:clipboard:/g,
        'emojify clipboard'
      ],
      [
        /:calendar:/g,
        'emojify calendar'
      ],
      [
        /:date:/g,
        'emojify date'
      ],
      [
        /:card_index:/g,
        'emojify card_index'
      ],
      [
        /:file_folder:/g,
        'emojify file_folder'
      ],
      [
        /:open_file_folder:/g,
        'emojify open_file_folder'
      ],
      [
        /:scissors:/g,
        'emojify scissors'
      ],
      [
        /:pushpin:/g,
        'emojify pushpin'
      ],
      [
        /:paperclip:/g,
        'emojify paperclip'
      ],
      [
        /:black_nib:/g,
        'emojify black_nib'
      ],
      [
        /:pencil2:/g,
        'emojify pencil2'
      ],
      [
        /:straight_ruler:/g,
        'emojify straight_ruler'
      ],
      [
        /:triangular_ruler:/g,
        'emojify triangular_ruler'
      ],
      [
        /:closed_book:/g,
        'emojify closed_book'
      ],
      [
        /:green_book:/g,
        'emojify green_book'
      ],
      [
        /:blue_book:/g,
        'emojify blue_book'
      ],
      [
        /:orange_book:/g,
        'emojify orange_book'
      ],
      [
        /:notebook:/g,
        'emojify notebook'
      ],
      [
        /:notebook_with_decorative_cover:/g,
        'emojify notebook_with_decorative_cover'
      ],
      [
        /:ledger:/g,
        'emojify ledger'
      ],
      [
        /:books:/g,
        'emojify books'
      ],
      [
        /:bookmark:/g,
        'emojify bookmark'
      ],
      [
        /:name_badge:/g,
        'emojify name_badge'
      ],
      [
        /:microscope:/g,
        'emojify microscope'
      ],
      [
        /:telescope:/g,
        'emojify telescope'
      ],
      [
        /:newspaper:/g,
        'emojify newspaper'
      ],
      [
        /:football:/g,
        'emojify football'
      ],
      [
        /:basketball:/g,
        'emojify basketball'
      ],
      [
        /:soccer:/g,
        'emojify soccer'
      ],
      [
        /:baseball:/g,
        'emojify baseball'
      ],
      [
        /:tennis:/g,
        'emojify tennis'
      ],
      [
        /:8ball:/g,
        'emojify eightball'
      ],
      [
        /:rugby_football:/g,
        'emojify rugby_football'
      ],
      [
        /:bowling:/g,
        'emojify bowling'
      ],
      [
        /:golf:/g,
        'emojify golf'
      ],
      [
        /:mountain_bicyclist:/g,
        'emojify mountain_bicyclist'
      ],
      [
        /:bicyclist:/g,
        'emojify bicyclist'
      ],
      [
        /:horse_racing:/g,
        'emojify horse_racing'
      ],
      [
        /:snowboarder:/g,
        'emojify snowboarder'
      ],
      [
        /:swimmer:/g,
        'emojify swimmer'
      ],
      [
        /:surfer:/g,
        'emojify surfer'
      ],
      [
        /:ski:/g,
        'emojify ski'
      ],
      [
        /:spades:/g,
        'emojify spades'
      ],
      [
        /:hearts:/g,
        'emojify hearts'
      ],
      [
        /:clubs:/g,
        'emojify clubs'
      ],
      [
        /:diamonds:/g,
        'emojify diamonds'
      ],
      [
        /:gem:/g,
        'emojify gem'
      ],
      [
        /:ring:/g,
        'emojify ring'
      ],
      [
        /:trophy:/g,
        'emojify trophy'
      ],
      [
        /:musical_score:/g,
        'emojify musical_score'
      ],
      [
        /:musical_keyboard:/g,
        'emojify musical_keyboard'
      ],
      [
        /:violin:/g,
        'emojify violin'
      ],
      [
        /:space_invader:/g,
        'emojify space_invader'
      ],
      [
        /:video_game:/g,
        'emojify video_game'
      ],
      [
        /:black_joker:/g,
        'emojify black_joker'
      ],
      [
        /:flower_playing_cards:/g,
        'emojify flower_playing_cards'
      ],
      [
        /:game_die:/g,
        'emojify game_die'
      ],
      [
        /:dart:/g,
        'emojify dart'
      ],
      [
        /:mahjong:/g,
        'emojify mahjong'
      ],
      [
        /:clapper:/g,
        'emojify clapper'
      ],
      [
        /:memo:/g,
        'emojify memo'
      ],
      [
        /:pencil:/g,
        'emojify pencil'
      ],
      [
        /:book:/g,
        'emojify book'
      ],
      [
        /:art:/g,
        'emojify art'
      ],
      [
        /:microphone:/g,
        'emojify microphone'
      ],
      [
        /:headphones:/g,
        'emojify headphones'
      ],
      [
        /:trumpet:/g,
        'emojify trumpet'
      ],
      [
        /:saxophone:/g,
        'emojify saxophone'
      ],
      [
        /:guitar:/g,
        'emojify guitar'
      ],
      [
        /:shoe:/g,
        'emojify shoe'
      ],
      [
        /:sandal:/g,
        'emojify sandal'
      ],
      [
        /:high_heel:/g,
        'emojify high_heel'
      ],
      [
        /:lipstick:/g,
        'emojify lipstick'
      ],
      [
        /:boot:/g,
        'emojify boot'
      ],
      [
        /:shirt:/g,
        'emojify shirt'
      ],
      [
        /:tshirt:/g,
        'emojify tshirt'
      ],
      [
        /:necktie:/g,
        'emojify necktie'
      ],
      [
        /:womans_clothes:/g,
        'emojify womans_clothes'
      ],
      [
        /:dress:/g,
        'emojify dress'
      ],
      [
        /:running_shirt_with_sash:/g,
        'emojify running_shirt_with_sash'
      ],
      [
        /:jeans:/g,
        'emojify jeans'
      ],
      [
        /:kimono:/g,
        'emojify kimono'
      ],
      [
        /:bikini:/g,
        'emojify bikini'
      ],
      [
        /:ribbon:/g,
        'emojify ribbon'
      ],
      [
        /:tophat:/g,
        'emojify tophat'
      ],
      [
        /:crown:/g,
        'emojify crown'
      ],
      [
        /:womans_hat:/g,
        'emojify womans_hat'
      ],
      [
        /:mans_shoe:/g,
        'emojify mans_shoe'
      ],
      [
        /:closed_umbrella:/g,
        'emojify closed_umbrella'
      ],
      [
        /:briefcase:/g,
        'emojify briefcase'
      ],
      [
        /:handbag:/g,
        'emojify handbag'
      ],
      [
        /:pouch:/g,
        'emojify pouch'
      ],
      [
        /:purse:/g,
        'emojify purse'
      ],
      [
        /:eyeglasses:/g,
        'emojify eyeglasses'
      ],
      [
        /:fishing_pole_and_fish:/g,
        'emojify fishing_pole_and_fish'
      ],
      [
        /:coffee:/g,
        'emojify coffee'
      ],
      [
        /:tea:/g,
        'emojify tea'
      ],
      [
        /:sake:/g,
        'emojify sake'
      ],
      [
        /:baby_bottle:/g,
        'emojify baby_bottle'
      ],
      [
        /:beer:/g,
        'emojify beer'
      ],
      [
        /:beers:/g,
        'emojify beers'
      ],
      [
        /:cocktail:/g,
        'emojify cocktail'
      ],
      [
        /:tropical_drink:/g,
        'emojify tropical_drink'
      ],
      [
        /:wine_glass:/g,
        'emojify wine_glass'
      ],
      [
        /:fork_and_knife:/g,
        'emojify fork_and_knife'
      ],
      [
        /:pizza:/g,
        'emojify pizza'
      ],
      [
        /:hamburger:/g,
        'emojify hamburger'
      ],
      [
        /:fries:/g,
        'emojify fries'
      ],
      [
        /:poultry_leg:/g,
        'emojify poultry_leg'
      ],
      [
        /:meat_on_bone:/g,
        'emojify meat_on_bone'
      ],
      [
        /:spaghetti:/g,
        'emojify spaghetti'
      ],
      [
        /:curry:/g,
        'emojify curry'
      ],
      [
        /:fried_shrimp:/g,
        'emojify fried_shrimp'
      ],
      [
        /:bento:/g,
        'emojify bento'
      ],
      [
        /:sushi:/g,
        'emojify sushi'
      ],
      [
        /:fish_cake:/g,
        'emojify fish_cake'
      ],
      [
        /:rice_ball:/g,
        'emojify rice_ball'
      ],
      [
        /:rice_cracker:/g,
        'emojify rice_cracker'
      ],
      [
        /:rice:/g,
        'emojify rice'
      ],
      [
        /:ramen:/g,
        'emojify ramen'
      ],
      [
        /:stew:/g,
        'emojify stew'
      ],
      [
        /:oden:/g,
        'emojify oden'
      ],
      [
        /:dango:/g,
        'emojify dango'
      ],
      [
        /:egg:/g,
        'emojify egg'
      ],
      [
        /:bread:/g,
        'emojify bread'
      ],
      [
        /:doughnut:/g,
        'emojify doughnut'
      ],
      [
        /:custard:/g,
        'emojify custard'
      ],
      [
        /:icecream:/g,
        'emojify icecream'
      ],
      [
        /:ice_cream:/g,
        'emojify ice_cream'
      ],
      [
        /:shaved_ice:/g,
        'emojify shaved_ice'
      ],
      [
        /:birthday:/g,
        'emojify birthday'
      ],
      [
        /:cake:/g,
        'emojify cake'
      ],
      [
        /:cookie:/g,
        'emojify cookie'
      ],
      [
        /:chocolate_bar:/g,
        'emojify chocolate_bar'
      ],
      [
        /:candy:/g,
        'emojify candy'
      ],
      [
        /:lollipop:/g,
        'emojify lollipop'
      ],
      [
        /:honey_pot:/g,
        'emojify honey_pot'
      ],
      [
        /:apple:/g,
        'emojify apple'
      ],
      [
        /:green_apple:/g,
        'emojify green_apple'
      ],
      [
        /:tangerine:/g,
        'emojify tangerine'
      ],
      [
        /:lemon:/g,
        'emojify lemon'
      ],
      [
        /:cherries:/g,
        'emojify cherries'
      ],
      [
        /:grapes:/g,
        'emojify grapes'
      ],
      [
        /:watermelon:/g,
        'emojify watermelon'
      ],
      [
        /:strawberry:/g,
        'emojify strawberry'
      ],
      [
        /:peach:/g,
        'emojify peach'
      ],
      [
        /:melon:/g,
        'emojify melon'
      ],
      [
        /:banana:/g,
        'emojify banana'
      ],
      [
        /:pear:/g,
        'emojify pear'
      ],
      [
        /:pineapple:/g,
        'emojify pineapple'
      ],
      [
        /:sweet_potato:/g,
        'emojify sweet_potato'
      ],
      [
        /:eggplant:/g,
        'emojify eggplant'
      ],
      [
        /:tomato:/g,
        'emojify tomato'
      ],
      [
        /:corn:/g,
        'emojify corn'
      ]
    ];
  var PLACES = [
      [
        /:109:/g,
        'emojify onezeronine'
      ],
      [
        /:house:/g,
        'emojify house'
      ],
      [
        /:house_with_garden:/g,
        'emojify house_with_garden'
      ],
      [
        /:school:/g,
        'emojify school'
      ],
      [
        /:office:/g,
        'emojify office'
      ],
      [
        /:post_office:/g,
        'emojify post_office'
      ],
      [
        /:hospital:/g,
        'emojify hospital'
      ],
      [
        /:bank:/g,
        'emojify bank'
      ],
      [
        /:convenience_store:/g,
        'emojify convenience_store'
      ],
      [
        /:love_hotel:/g,
        'emojify love_hotel'
      ],
      [
        /:hotel:/g,
        'emojify hotel'
      ],
      [
        /:wedding:/g,
        'emojify wedding'
      ],
      [
        /:church:/g,
        'emojify church'
      ],
      [
        /:department_store:/g,
        'emojify department_store'
      ],
      [
        /:european_post_office:/g,
        'emojify european_post_office'
      ],
      [
        /:city_sunrise:/g,
        'emojify city_sunrise'
      ],
      [
        /:city_sunset:/g,
        'emojify city_sunset'
      ],
      [
        /:japanese_castle:/g,
        'emojify japanese_castle'
      ],
      [
        /:european_castle:/g,
        'emojify european_castle'
      ],
      [
        /:tent:/g,
        'emojify tent'
      ],
      [
        /:factory:/g,
        'emojify factory'
      ],
      [
        /:tokyo_tower:/g,
        'emojify tokyo_tower'
      ],
      [
        /:japan:/g,
        'emojify japan'
      ],
      [
        /:mount_fuji:/g,
        'emojify mount_fuji'
      ],
      [
        /:sunrise_over_mountains:/g,
        'emojify sunrise_over_mountains'
      ],
      [
        /:sunrise:/g,
        'emojify sunrise'
      ],
      [
        /:stars:/g,
        'emojify stars'
      ],
      [
        /:statue_of_liberty:/g,
        'emojify statue_of_liberty'
      ],
      [
        /:bridge_at_night:/g,
        'emojify bridge_at_night'
      ],
      [
        /:carousel_horse:/g,
        'emojify carousel_horse'
      ],
      [
        /:rainbow:/g,
        'emojify rainbow'
      ],
      [
        /:ferris_wheel:/g,
        'emojify ferris_wheel'
      ],
      [
        /:fountain:/g,
        'emojify fountain'
      ],
      [
        /:roller_coaster:/g,
        'emojify roller_coaster'
      ],
      [
        /:ship:/g,
        'emojify ship'
      ],
      [
        /:speedboat:/g,
        'emojify speedboat'
      ],
      [
        /:boat:/g,
        'emojify boat'
      ],
      [
        /:sailboat:/g,
        'emojify sailboat'
      ],
      [
        /:rowboat:/g,
        'emojify rowboat'
      ],
      [
        /:anchor:/g,
        'emojify anchor'
      ],
      [
        /:rocket:/g,
        'emojify rocket'
      ],
      [
        /:airplane:/g,
        'emojify airplane'
      ],
      [
        /:helicopter:/g,
        'emojify helicopter'
      ],
      [
        /:steam_locomotive:/g,
        'emojify steam_locomotive'
      ],
      [
        /:tram:/g,
        'emojify tram'
      ],
      [
        /:mountain_railway:/g,
        'emojify mountain_railway'
      ],
      [
        /:bike:/g,
        'emojify bike'
      ],
      [
        /:aerial_tramway:/g,
        'emojify aerial_tramway'
      ],
      [
        /:suspension_railway:/g,
        'emojify suspension_railway'
      ],
      [
        /:mountain_cableway:/g,
        'emojify mountain_cableway'
      ],
      [
        /:tractor:/g,
        'emojify tractor'
      ],
      [
        /:blue_car:/g,
        'emojify blue_car'
      ],
      [
        /:oncoming_automobile:/g,
        'emojify oncoming_automobile'
      ],
      [
        /:car:/g,
        'emojify car'
      ],
      [
        /:red_car:/g,
        'emojify red_car'
      ],
      [
        /:taxi:/g,
        'emojify taxi'
      ],
      [
        /:oncoming_taxi:/g,
        'emojify oncoming_taxi'
      ],
      [
        /:articulated_lorry:/g,
        'emojify articulated_lorry'
      ],
      [
        /:bus:/g,
        'emojify bus'
      ],
      [
        /:oncoming_bus:/g,
        'emojify oncoming_bus'
      ],
      [
        /:rotating_light:/g,
        'emojify rotating_light'
      ],
      [
        /:police_car:/g,
        'emojify police_car'
      ],
      [
        /:oncoming_police_car:/g,
        'emojify oncoming_police_car'
      ],
      [
        /:fire_engine:/g,
        'emojify fire_engine'
      ],
      [
        /:ambulance:/g,
        'emojify ambulance'
      ],
      [
        /:minibus:/g,
        'emojify minibus'
      ],
      [
        /:truck:/g,
        'emojify truck'
      ],
      [
        /:train:/g,
        'emojify train'
      ],
      [
        /:station:/g,
        'emojify station'
      ],
      [
        /:train2:/g,
        'emojify train2'
      ],
      [
        /:bullettrain_front:/g,
        'emojify bullettrain_front'
      ],
      [
        /:bullettrain_side:/g,
        'emojify bullettrain_side'
      ],
      [
        /:light_rail:/g,
        'emojify light_rail'
      ],
      [
        /:monorail:/g,
        'emojify monorail'
      ],
      [
        /:railway_car:/g,
        'emojify railway_car'
      ],
      [
        /:trolleybus:/g,
        'emojify trolleybus'
      ],
      [
        /:ticket:/g,
        'emojify ticket'
      ],
      [
        /:fuelpump:/g,
        'emojify fuelpump'
      ],
      [
        /:vertical_traffic_light:/g,
        'emojify vertical_traffic_light'
      ],
      [
        /:traffic_light:/g,
        'emojify traffic_light'
      ],
      [
        /:warning:/g,
        'emojify warning'
      ],
      [
        /:construction:/g,
        'emojify construction'
      ],
      [
        /:beginner:/g,
        'emojify beginner'
      ],
      [
        /:atm:/g,
        'emojify atm'
      ],
      [
        /:slot_machine:/g,
        'emojify slot_machine'
      ],
      [
        /:busstop:/g,
        'emojify busstop'
      ],
      [
        /:barber:/g,
        'emojify barber'
      ],
      [
        /:hotsprings:/g,
        'emojify hotsprings'
      ],
      [
        /:checkered_flag:/g,
        'emojify checkered_flag'
      ],
      [
        /:crossed_flags:/g,
        'emojify crossed_flags'
      ],
      [
        /:izakaya_lantern:/g,
        'emojify izakaya_lantern'
      ],
      [
        /:moyai:/g,
        'emojify moyai'
      ],
      [
        /:circus_tent:/g,
        'emojify circus_tent'
      ],
      [
        /:performing_arts:/g,
        'emojify performing_arts'
      ],
      [
        /:round_pushpin:/g,
        'emojify round_pushpin'
      ],
      [
        /:triangular_flag_on_post:/g,
        'emojify triangular_flag_on_post'
      ],
      [
        /:jp:/g,
        'emojify jp'
      ],
      [
        /:kr:/g,
        'emojify kr'
      ],
      [
        /:cn:/g,
        'emojify cn'
      ],
      [
        /:us:/g,
        'emojify us'
      ],
      [
        /:fr:/g,
        'emojify fr'
      ],
      [
        /:es:/g,
        'emojify es'
      ],
      [
        /:it:/g,
        'emojify it'
      ],
      [
        /:ru:/g,
        'emojify ru'
      ],
      [
        /:gb:/g,
        'emojify gb'
      ],
      [
        /:uk:/g,
        'emojify uk'
      ],
      [
        /:de:/g,
        'emojify de'
      ]
    ];
  var SYMBOLS = [
      [
        /:one:/g,
        'emojify one'
      ],
      [
        /:two:/g,
        'emojify two'
      ],
      [
        /:three:/g,
        'emojify three'
      ],
      [
        /:four:/g,
        'emojify four'
      ],
      [
        /:five:/g,
        'emojify five'
      ],
      [
        /:six:/g,
        'emojify six'
      ],
      [
        /:seven:/g,
        'emojify seven'
      ],
      [
        /:eight:/g,
        'emojify eight'
      ],
      [
        /:nine:/g,
        'emojify nine'
      ],
      [
        /:keycap_ten:/g,
        'emojify keycap_ten'
      ],
      [
        /:1234:/g,
        'emojify onetwothreefour'
      ],
      [
        /:zero:/g,
        'emojify zero'
      ],
      [
        /:hash:/g,
        'emojify hash'
      ],
      [
        /:symbols:/g,
        'emojify symbols'
      ],
      [
        /:arrow_backward:/g,
        'emojify arrow_backward'
      ],
      [
        /:arrow_down:/g,
        'emojify arrow_down'
      ],
      [
        /:arrow_forward:/g,
        'emojify arrow_forward'
      ],
      [
        /:arrow_left:/g,
        'emojify arrow_left'
      ],
      [
        /:capital_abcd:/g,
        'emojify capital_abcd'
      ],
      [
        /:abcd:/g,
        'emojify abcd'
      ],
      [
        /:abc:/g,
        'emojify abc'
      ],
      [
        /:arrow_lower_left:/g,
        'emojify arrow_lower_left'
      ],
      [
        /:arrow_lower_right:/g,
        'emojify arrow_lower_right'
      ],
      [
        /:arrow_right:/g,
        'emojify arrow_right'
      ],
      [
        /:arrow_up:/g,
        'emojify arrow_up'
      ],
      [
        /:arrow_upper_left:/g,
        'emojify arrow_upper_left'
      ],
      [
        /:arrow_upper_right:/g,
        'emojify arrow_upper_right'
      ],
      [
        /:arrow_double_down:/g,
        'emojify arrow_double_down'
      ],
      [
        /:arrow_double_up:/g,
        'emojify arrow_double_up'
      ],
      [
        /:arrow_down_small:/g,
        'emojify arrow_down_small'
      ],
      [
        /:arrow_heading_down:/g,
        'emojify arrow_heading_down'
      ],
      [
        /:arrow_heading_up:/g,
        'emojify arrow_heading_up'
      ],
      [
        /:leftwards_arrow_with_hook:/g,
        'emojify leftwards_arrow_with_hook'
      ],
      [
        /:arrow_right_hook:/g,
        'emojify arrow_right_hook'
      ],
      [
        /:left_right_arrow:/g,
        'emojify left_right_arrow'
      ],
      [
        /:arrow_up_down:/g,
        'emojify arrow_up_down'
      ],
      [
        /:arrow_up_small:/g,
        'emojify arrow_up_small'
      ],
      [
        /:arrows_clockwise:/g,
        'emojify arrows_clockwise'
      ],
      [
        /:arrows_counterclockwise:/g,
        'emojify arrows_counterclockwise'
      ],
      [
        /:rewind:/g,
        'emojify rewind'
      ],
      [
        /:fast_forward:/g,
        'emojify fast_forward'
      ],
      [
        /:information_source:/g,
        'emojify information_source'
      ],
      [
        /:ok:/g,
        'emojify ok'
      ],
      [
        /:twisted_rightwards_arrows:/g,
        'emojify twisted_rightwards_arrows'
      ],
      [
        /:repeat:/g,
        'emojify repeat'
      ],
      [
        /:repeat_one:/g,
        'emojify repeat_one'
      ],
      [
        /:new:/g,
        'emojify new'
      ],
      [
        /:top:/g,
        'emojify top'
      ],
      [
        /:up:/g,
        'emojify up'
      ],
      [
        /:cool:/g,
        'emojify cool'
      ],
      [
        /:free:/g,
        'emojify free'
      ],
      [
        /:ng:/g,
        'emojify ng'
      ],
      [
        /:cinema:/g,
        'emojify cinema'
      ],
      [
        /:koko:/g,
        'emojify koko'
      ],
      [
        /:signal_strength:/g,
        'emojify signal_strength'
      ],
      [
        /:u5272:/g,
        'emojify u5272'
      ],
      [
        /:u5408:/g,
        'emojify u5408'
      ],
      [
        /:u55b6:/g,
        'emojify u55b6'
      ],
      [
        /:u6307:/g,
        'emojify u6307'
      ],
      [
        /:u6708:/g,
        'emojify u6708'
      ],
      [
        /:u6709:/g,
        'emojify u6709'
      ],
      [
        /:u6e80:/g,
        'emojify u6e80'
      ],
      [
        /:u7121:/g,
        'emojify u7121'
      ],
      [
        /:u7533:/g,
        'emojify u7533'
      ],
      [
        /:u7a7a:/g,
        'emojify u7a7a'
      ],
      [
        /:u7981:/g,
        'emojify u7981'
      ],
      [
        /:sa:/g,
        'emojify sa'
      ],
      [
        /:restroom:/g,
        'emojify restroom'
      ],
      [
        /:mens:/g,
        'emojify mens'
      ],
      [
        /:womens:/g,
        'emojify womens'
      ],
      [
        /:baby_symbol:/g,
        'emojify baby_symbol'
      ],
      [
        /:no_smoking:/g,
        'emojify no_smoking'
      ],
      [
        /:parking:/g,
        'emojify parking'
      ],
      [
        /:wheelchair:/g,
        'emojify wheelchair'
      ],
      [
        /:metro:/g,
        'emojify metro'
      ],
      [
        /:baggage_claim:/g,
        'emojify baggage_claim'
      ],
      [
        /:accept:/g,
        'emojify accept'
      ],
      [
        /:wc:/g,
        'emojify wc'
      ],
      [
        /:potable_water:/g,
        'emojify potable_water'
      ],
      [
        /:put_litter_in_its_place:/g,
        'emojify put_litter_in_its_place'
      ],
      [
        /:secret:/g,
        'emojify secret'
      ],
      [
        /:congratulations:/g,
        'emojify congratulations'
      ],
      [
        /:m:/g,
        'emojify m'
      ],
      [
        /:passport_control:/g,
        'emojify passport_control'
      ],
      [
        /:left_luggage:/g,
        'emojify left_luggage'
      ],
      [
        /:customs:/g,
        'emojify customs'
      ],
      [
        /:ideograph_advantage:/g,
        'emojify ideograph_advantage'
      ],
      [
        /:cl:/g,
        'emojify cl'
      ],
      [
        /:sos:/g,
        'emojify sos'
      ],
      [
        /:id:/g,
        'emojify id'
      ],
      [
        /:no_entry_sign:/g,
        'emojify no_entry_sign'
      ],
      [
        /:underage:/g,
        'emojify underage'
      ],
      [
        /:no_mobile_phones:/g,
        'emojify no_mobile_phones'
      ],
      [
        /:do_not_litter:/g,
        'emojify do_not_litter'
      ],
      [
        /:non-potable_water:/g,
        'emojify non-potable_water'
      ],
      [
        /:no_bicycles:/g,
        'emojify no_bicycles'
      ],
      [
        /:no_pedestrians:/g,
        'emojify no_pedestrians'
      ],
      [
        /:children_crossing:/g,
        'emojify children_crossing'
      ],
      [
        /:no_entry:/g,
        'emojify no_entry'
      ],
      [
        /:eight_spoked_asterisk:/g,
        'emojify eight_spoked_asterisk'
      ],
      [
        /:eight_pointed_black_star:/g,
        'emojify eight_pointed_black_star'
      ],
      [
        /:heart_decoration:/g,
        'emojify heart_decoration'
      ],
      [
        /:vs:/g,
        'emojify vs'
      ],
      [
        /:vibration_mode:/g,
        'emojify vibration_mode'
      ],
      [
        /:mobile_phone_off:/g,
        'emojify mobile_phone_off'
      ],
      [
        /:chart:/g,
        'emojify chart'
      ],
      [
        /:currency_exchange:/g,
        'emojify currency_exchange'
      ],
      [
        /:aries:/g,
        'emojify aries'
      ],
      [
        /:taurus:/g,
        'emojify taurus'
      ],
      [
        /:gemini:/g,
        'emojify gemini'
      ],
      [
        /:cancer:/g,
        'emojify cancer'
      ],
      [
        /:leo:/g,
        'emojify leo'
      ],
      [
        /:virgo:/g,
        'emojify virgo'
      ],
      [
        /:libra:/g,
        'emojify libra'
      ],
      [
        /:scorpius:/g,
        'emojify scorpius'
      ],
      [
        /:sagittarius:/g,
        'emojify sagittarius'
      ],
      [
        /:capricorn:/g,
        'emojify capricorn'
      ],
      [
        /:aquarius:/g,
        'emojify aquarius'
      ],
      [
        /:pisces:/g,
        'emojify pisces'
      ],
      [
        /:ophiuchus:/g,
        'emojify ophiuchus'
      ],
      [
        /:six_pointed_star:/g,
        'emojify six_pointed_star'
      ],
      [
        /:negative_squared_cross_mark:/g,
        'emojify negative_squared_cross_mark'
      ],
      [
        /:a:/g,
        'emojify a'
      ],
      [
        /:b:/g,
        'emojify b'
      ],
      [
        /:ab:/g,
        'emojify ab'
      ],
      [
        /:o2:/g,
        'emojify o2'
      ],
      [
        /:diamond_shape_with_a_dot_inside:/g,
        'emojify diamond_shape_with_a_dot_inside'
      ],
      [
        /:recycle:/g,
        'emojify recycle'
      ],
      [
        /:end:/g,
        'emojify end'
      ],
      [
        /:on:/g,
        'emojify on'
      ],
      [
        /:soon:/g,
        'emojify soon'
      ],
      [
        /:clock1:/g,
        'emojify clock1'
      ],
      [
        /:clock130:/g,
        'emojify clock130'
      ],
      [
        /:clock10:/g,
        'emojify clock10'
      ],
      [
        /:clock1030:/g,
        'emojify clock1030'
      ],
      [
        /:clock11:/g,
        'emojify clock11'
      ],
      [
        /:clock1130:/g,
        'emojify clock1130'
      ],
      [
        /:clock12:/g,
        'emojify clock12'
      ],
      [
        /:clock1230:/g,
        'emojify clock1230'
      ],
      [
        /:clock2:/g,
        'emojify clock2'
      ],
      [
        /:clock230:/g,
        'emojify clock230'
      ],
      [
        /:clock3:/g,
        'emojify clock3'
      ],
      [
        /:clock330:/g,
        'emojify clock330'
      ],
      [
        /:clock4:/g,
        'emojify clock4'
      ],
      [
        /:clock430:/g,
        'emojify clock430'
      ],
      [
        /:clock5:/g,
        'emojify clock5'
      ],
      [
        /:clock530:/g,
        'emojify clock530'
      ],
      [
        /:clock6:/g,
        'emojify clock6'
      ],
      [
        /:clock630:/g,
        'emojify clock630'
      ],
      [
        /:clock7:/g,
        'emojify clock7'
      ],
      [
        /:clock730:/g,
        'emojify clock730'
      ],
      [
        /:clock8:/g,
        'emojify clock8'
      ],
      [
        /:clock830:/g,
        'emojify clock830'
      ],
      [
        /:clock9:/g,
        'emojify clock9'
      ],
      [
        /:clock930:/g,
        'emojify clock930'
      ],
      [
        /:heavy_dollar_sign:/g,
        'emojify heavy_dollar_sign'
      ],
      [
        /:copyright:/g,
        'emojify copyright'
      ],
      [
        /:registered:/g,
        'emojify registered'
      ],
      [
        /:tm:/g,
        'emojify tm'
      ],
      [
        /:x:/g,
        'emojify x'
      ],
      [
        /:heavy_exclamation_mark:/g,
        'emojify heavy_exclamation_mark'
      ],
      [
        /:bangbang:/g,
        'emojify bangbang'
      ],
      [
        /:interrobang:/g,
        'emojify interrobang'
      ],
      [
        /:o:/g,
        'emojify o'
      ],
      [
        /:heavy_multiplication_x:/g,
        'emojify heavy_multiplication_x'
      ],
      [
        /:heavy_plus_sign:/g,
        'emojify heavy_plus_sign'
      ],
      [
        /:heavy_minus_sign:/g,
        'emojify heavy_minus_sign'
      ],
      [
        /:heavy_division_sign:/g,
        'emojify heavy_division_sign'
      ],
      [
        /:white_flower:/g,
        'emojify white_flower'
      ],
      [
        /:100:/g,
        'emojify onehundred'
      ],
      [
        /:heavy_check_mark:/g,
        'emojify heavy_check_mark'
      ],
      [
        /:ballot_box_with_check:/g,
        'emojify ballot_box_with_check'
      ],
      [
        /:radio_button:/g,
        'emojify radio_button'
      ],
      [
        /:link:/g,
        'emojify link'
      ],
      [
        /:curly_loop:/g,
        'emojify curly_loop'
      ],
      [
        /:wavy_dash:/g,
        'emojify wavy_dash'
      ],
      [
        /:part_alternation_mark:/g,
        'emojify part_alternation_mark'
      ],
      [
        /:trident:/g,
        'emojify trident'
      ],
      [
        /:black_square:/g,
        'emojify black_square'
      ],
      [
        /:white_square:/g,
        'emojify white_square'
      ],
      [
        /:white_check_mark:/g,
        'emojify white_check_mark'
      ],
      [
        /:black_square_button:/g,
        'emojify black_square_button'
      ],
      [
        /:white_square_button:/g,
        'emojify white_square_button'
      ],
      [
        /:black_circle:/g,
        'emojify black_circle'
      ],
      [
        /:white_circle:/g,
        'emojify white_circle'
      ],
      [
        /:red_circle:/g,
        'emojify red_circle'
      ],
      [
        /:large_blue_circle:/g,
        'emojify large_blue_circle'
      ],
      [
        /:large_blue_diamond:/g,
        'emojify large_blue_diamond'
      ],
      [
        /:large_orange_diamond:/g,
        'emojify large_orange_diamond'
      ],
      [
        /:small_blue_diamond:/g,
        'emojify small_blue_diamond'
      ],
      [
        /:small_orange_diamond:/g,
        'emojify small_orange_diamond'
      ],
      [
        /:small_red_triangle:/g,
        'emojify small_red_triangle'
      ],
      [
        /:small_red_triangle_down:/g,
        'emojify small_red_triangle_down'
      ],
      [
        /:shipit:/g,
        'emojify shipit'
      ]
    ];
}(this));
angular.module('ui.bootstrap', ['ui.bootstrap.tabs']);
angular.module('ui.bootstrap.tabs', []).directive('tabs', function () {
  return function () {
    throw new Error('The `tabs` directive is deprecated, please migrate to `tabset`. Instructions can be found at http://github.com/angular-ui/bootstrap/tree/master/CHANGELOG.md');
  };
}).controller('TabsetController', [
  '$scope',
  '$element',
  function TabsetCtrl($scope, $element) {
    var ctrl = this, tabs = ctrl.tabs = $scope.tabs = [];
    ctrl.select = function (tab) {
      angular.forEach(tabs, function (tab) {
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
      if (tab.active && tabs.length > 1) {
        var newActiveIndex = index == tabs.length - 1 ? index - 1 : index + 1;
        ctrl.select(tabs[newActiveIndex]);
      }
      tabs.splice(index, 1);
    };
  }
]).directive('tabset', function () {
  return {
    restrict: 'EA',
    transclude: true,
    scope: {},
    controller: 'TabsetController',
    templateUrl: 'template/tabs/tabset.html',
    link: function (scope, element, attrs) {
      scope.vertical = angular.isDefined(attrs.vertical) ? scope.$eval(attrs.vertical) : false;
      scope.type = angular.isDefined(attrs.type) ? scope.$parent.$eval(attrs.type) : 'tabs';
    }
  };
}).directive('tab', [
  '$parse',
  '$http',
  '$templateCache',
  '$compile',
  function ($parse, $http, $templateCache, $compile) {
    return {
      require: '^tabset',
      restrict: 'EA',
      replace: true,
      templateUrl: 'template/tabs/tab.html',
      transclude: true,
      scope: {
        heading: '@',
        onSelect: '&select'
      },
      controller: function () {
      },
      compile: function (elm, attrs, transclude) {
        return function postLink(scope, elm, attrs, tabsetCtrl) {
          var getActive, setActive;
          scope.active = false;
          if (attrs.active) {
            getActive = $parse(attrs.active);
            setActive = getActive.assign;
            scope.$parent.$watch(getActive, function updateActive(value) {
              if (!!value && scope.disabled) {
                setActive(scope.$parent, false);
              } else {
                scope.active = !!value;
              }
            });
          } else {
            setActive = getActive = angular.noop;
          }
          scope.$watch('active', function (active) {
            setActive(scope.$parent, active);
            if (active) {
              tabsetCtrl.select(scope);
              scope.onSelect();
            }
          });
          scope.disabled = false;
          if (attrs.disabled) {
            scope.$parent.$watch($parse(attrs.disabled), function (value) {
              scope.disabled = !!value;
            });
          }
          scope.select = function () {
            if (!scope.disabled) {
              scope.active = true;
            }
          };
          tabsetCtrl.addTab(scope);
          scope.$on('$destroy', function () {
            tabsetCtrl.removeTab(scope);
          });
          if (scope.active) {
            setActive(scope.$parent, true);
          }
          transclude(scope.$parent, function (clone) {
            var contents = [], heading;
            angular.forEach(clone, function (el) {
              if (el.tagName && (el.hasAttribute('tab-heading') || el.hasAttribute('data-tab-heading') || el.tagName.toLowerCase() == 'tab-heading' || el.tagName.toLowerCase() == 'data-tab-heading')) {
                heading = el;
              } else {
                contents.push(el);
              }
            });
            if (heading) {
              scope.headingElement = angular.element(heading);
            }
            scope.contentElement = angular.element(contents);
          });
        };
      }
    };
  }
]).directive('tabHeadingTransclude', [function () {
    return {
      restrict: 'A',
      require: '^tab',
      link: function (scope, elm, attrs, tabCtrl) {
        scope.$watch('headingElement', function updateHeadingElement(heading) {
          if (heading) {
            elm.html('');
            elm.append(heading);
          }
        });
      }
    };
  }]).directive('tabContentTransclude', [
  '$parse',
  function ($parse) {
    return {
      restrict: 'A',
      require: '^tabset',
      link: function (scope, elm, attrs, tabsetCtrl) {
        scope.$watch($parse(attrs.tabContentTransclude), function (tab) {
          elm.html('');
          if (tab) {
            elm.append(tab.contentElement);
          }
        });
      }
    };
  }
]);
;
angular.module('ui.bootstrap', [
  'ui.bootstrap.tpls',
  'ui.bootstrap.tabs'
]);
angular.module('ui.bootstrap.tpls', [
  'template/tabs/tab.html',
  'template/tabs/tabset.html'
]);
angular.module('ui.bootstrap.tabs', []).directive('tabs', function () {
  return function () {
    throw new Error('The `tabs` directive is deprecated, please migrate to `tabset`. Instructions can be found at http://github.com/angular-ui/bootstrap/tree/master/CHANGELOG.md');
  };
}).controller('TabsetController', [
  '$scope',
  '$element',
  function TabsetCtrl($scope, $element) {
    var ctrl = this, tabs = ctrl.tabs = $scope.tabs = [];
    ctrl.select = function (tab) {
      angular.forEach(tabs, function (tab) {
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
      if (tab.active && tabs.length > 1) {
        var newActiveIndex = index == tabs.length - 1 ? index - 1 : index + 1;
        ctrl.select(tabs[newActiveIndex]);
      }
      tabs.splice(index, 1);
    };
  }
]).directive('tabset', function () {
  return {
    restrict: 'EA',
    transclude: true,
    scope: {},
    controller: 'TabsetController',
    templateUrl: 'template/tabs/tabset.html',
    link: function (scope, element, attrs) {
      scope.vertical = angular.isDefined(attrs.vertical) ? scope.$eval(attrs.vertical) : false;
      scope.type = angular.isDefined(attrs.type) ? scope.$parent.$eval(attrs.type) : 'tabs';
    }
  };
}).directive('tab', [
  '$parse',
  '$http',
  '$templateCache',
  '$compile',
  function ($parse, $http, $templateCache, $compile) {
    return {
      require: '^tabset',
      restrict: 'EA',
      replace: true,
      templateUrl: 'template/tabs/tab.html',
      transclude: true,
      scope: {
        heading: '@',
        onSelect: '&select'
      },
      controller: function () {
      },
      compile: function (elm, attrs, transclude) {
        return function postLink(scope, elm, attrs, tabsetCtrl) {
          var getActive, setActive;
          scope.active = false;
          if (attrs.active) {
            getActive = $parse(attrs.active);
            setActive = getActive.assign;
            scope.$parent.$watch(getActive, function updateActive(value) {
              if (!!value && scope.disabled) {
                setActive(scope.$parent, false);
              } else {
                scope.active = !!value;
              }
            });
          } else {
            setActive = getActive = angular.noop;
          }
          scope.$watch('active', function (active) {
            setActive(scope.$parent, active);
            if (active) {
              tabsetCtrl.select(scope);
              scope.onSelect();
            }
          });
          scope.disabled = false;
          if (attrs.disabled) {
            scope.$parent.$watch($parse(attrs.disabled), function (value) {
              scope.disabled = !!value;
            });
          }
          scope.select = function () {
            if (!scope.disabled) {
              scope.active = true;
            }
          };
          tabsetCtrl.addTab(scope);
          scope.$on('$destroy', function () {
            tabsetCtrl.removeTab(scope);
          });
          if (scope.active) {
            setActive(scope.$parent, true);
          }
          transclude(scope.$parent, function (clone) {
            var contents = [], heading;
            angular.forEach(clone, function (el) {
              if (el.tagName && (el.hasAttribute('tab-heading') || el.hasAttribute('data-tab-heading') || el.tagName.toLowerCase() == 'tab-heading' || el.tagName.toLowerCase() == 'data-tab-heading')) {
                heading = el;
              } else {
                contents.push(el);
              }
            });
            if (heading) {
              scope.headingElement = angular.element(heading);
            }
            scope.contentElement = angular.element(contents);
          });
        };
      }
    };
  }
]).directive('tabHeadingTransclude', [function () {
    return {
      restrict: 'A',
      require: '^tab',
      link: function (scope, elm, attrs, tabCtrl) {
        scope.$watch('headingElement', function updateHeadingElement(heading) {
          if (heading) {
            elm.html('');
            elm.append(heading);
          }
        });
      }
    };
  }]).directive('tabContentTransclude', [
  '$parse',
  function ($parse) {
    return {
      restrict: 'A',
      require: '^tabset',
      link: function (scope, elm, attrs, tabsetCtrl) {
        scope.$watch($parse(attrs.tabContentTransclude), function (tab) {
          elm.html('');
          if (tab) {
            elm.append(tab.contentElement);
          }
        });
      }
    };
  }
]);
;
angular.module('template/tabs/pane.html', []).run([
  '$templateCache',
  function ($templateCache) {
    $templateCache.put('template/tabs/pane.html', '<div class="tab-pane" ng-class="{active: selected}" ng-show="selected" ng-transclude></div>\n' + '');
  }
]);
angular.module('template/tabs/tab.html', []).run([
  '$templateCache',
  function ($templateCache) {
    $templateCache.put('template/tabs/tab.html', '<li ng-class="{active: active, disabled: disabled}">\n' + '  <a ng-click="select()" tab-heading-transclude>{{heading}}</a>\n' + '</li>\n' + '');
  }
]);
angular.module('template/tabs/tabs.html', []).run([
  '$templateCache',
  function ($templateCache) {
    $templateCache.put('template/tabs/tabs.html', '<div class="tabbable">\n' + '  <ul class="nav nav-tabs">\n' + '    <li ng-repeat="pane in panes" ng-class="{active:pane.selected}">\n' + '      <a ng-click="select(pane)">{{pane.heading}}</a>\n' + '    </li>\n' + '  </ul>\n' + '  <div class="tab-content" ng-transclude></div>\n' + '</div>\n' + '');
  }
]);
angular.module('template/tabs/tabset.html', []).run([
  '$templateCache',
  function ($templateCache) {
    $templateCache.put('template/tabs/tabset.html', '\n' + '<div class="tabbable">\n' + '  <ul class="nav {{type && \'nav-\' + type}}" ng-class="{\'nav-stacked\': vertical}" ng-transclude>\n' + '  </ul>\n' + '  <div class="tab-content">\n' + '    <div class="tab-pane" \n' + '         ng-repeat="tab in tabs" \n' + '         ng-class="{active: tab.active}"\n' + '         tab-content-transclude="tab" tt="tab">\n' + '    </div>\n' + '  </div>\n' + '</div>\n' + '');
  }
]);
this['JST'] = this['JST'] || {};
this['JST']['app/templates/attempt_notification.us'] = function (obj) {
  obj || (obj = {});
  var __t, __p = '', __e = _.escape;
  with (obj) {
    __p += '<span class="icon-code"></span>\n<a href="' + ((__t = link) == null ? '' : __t) + '">' + ((__t = language) == null ? '' : __t) + ': ' + ((__t = slug) == null ? '' : __t) + '</a>\n&middot; ' + ((__t = username) == null ? '' : __t) + '\n<br>\nnew version ' + ((__t = ago) == null ? '' : __t) + '\n';
  }
  return __p;
};
this['JST']['app/templates/count_notifications.us'] = function (obj) {
  obj || (obj = {});
  var __t, __p = '', __e = _.escape;
  with (obj) {
    __p += ((__t = count) == null ? '' : __t) + '\n';
  }
  return __p;
};
this['JST']['app/templates/hibernating_notification.us'] = function (obj) {
  obj || (obj = {});
  var __t, __p = '', __e = _.escape;
  with (obj) {
    __p += '<span class="icon-moon"></span>\n<a href="' + ((__t = link) == null ? '' : __t) + '">' + ((__t = language) == null ? '' : __t) + ': ' + ((__t = slug) == null ? '' : __t) + '</a>\n<br>\nhibernated ' + ((__t = ago) == null ? '' : __t) + '\n';
  }
  return __p;
};
this['JST']['app/templates/invitation_notification.us'] = function (obj) {
  obj || (obj = {});
  var __t, __p = '', __e = _.escape;
  with (obj) {
    __p += '<span class="icon-user"></span>\n' + ((__t = username) == null ? '' : __t) + ' wants you to join team <a href="' + ((__t = link) == null ? '' : __t) + '">' + ((__t = team_name) == null ? '' : __t) + '</a>.\n<br>\nSent ' + ((__t = ago) == null ? '' : __t) + '.\n';
  }
  return __p;
};
this['JST']['app/templates/like_notification.us'] = function (obj) {
  obj || (obj = {});
  var __t, __p = '', __e = _.escape;
  with (obj) {
    __p += '<span class="icon-thumbs-up"></span>\n<a href="' + ((__t = link) == null ? '' : __t) + '">' + ((__t = language) == null ? '' : __t) + ': ' + ((__t = slug) == null ? '' : __t) + '</a>\n<br>\n' + ((__t = count) == null ? '' : __t) + ' ' + ((__t = count == 1 ? 'person' : 'people') == null ? '' : __t) + ' said your code looks great (' + ((__t = ago) == null ? '' : __t) + ')\n';
  }
  return __p;
};
this['JST']['app/templates/list_notifications.us'] = function (obj) {
  obj || (obj = {});
  var __t, __p = '', __e = _.escape;
  with (obj) {
    __p += '<ul id="contains-notifications">\n</ul>\n';
  }
  return __p;
};
this['JST']['app/templates/nitpicks_notification.us'] = function (obj) {
  obj || (obj = {});
  var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
  function print() {
    __p += __j.call(arguments, '');
  }
  with (obj) {
    __p += '<span class="icon-comment';
    count == 1 ? '' : 's';
    __p += '"></span>\n<a href="' + ((__t = link) == null ? '' : __t) + '">' + ((__t = language) == null ? '' : __t) + ': ' + ((__t = slug) == null ? '' : __t) + '</a>\n<br>\n' + ((__t = count) == null ? '' : __t) + ' new ' + ((__t = count == 1 ? 'nitpick' : 'nitpicks') == null ? '' : __t) + ' ' + ((__t = ago) == null ? '' : __t) + '\n';
  }
  return __p;
};
this['JST']['app/templates/notification.us'] = function (obj) {
  obj || (obj = {});
  var __t, __p = '', __e = _.escape, __j = Array.prototype.join;
  function print() {
    __p += __j.call(arguments, '');
  }
  with (obj) {
    __p += '<span class="icon-comment';
    count == 1 ? '' : 's';
    __p += '-alt"></span>\n<a href="' + ((__t = link) == null ? '' : __t) + '">' + ((__t = language) == null ? '' : __t) + ': ' + ((__t = slug) == null ? '' : __t) + '</a>\n&middot; ' + ((__t = username) == null ? '' : __t) + ' (' + ((__t = count) == null ? '' : __t) + ')\n<div class="notification date">' + ((__t = ago) == null ? '' : __t) + '</div>\n';
  }
  return __p;
};
this['JST']['app/templates/toggle_notifications.us'] = function (obj) {
  obj || (obj = {});
  var __t, __p = '', __e = _.escape;
  with (obj) {
    __p += '<button class="toggle-notifications ' + ((__t = style) == null ? '' : __t) + '">\n  <span id="count-notifications"></span>\n</button>\n';
  }
  return __p;
};
(function () {
  var destroyTeam, dismissTeamMember, toggleTeamEdit;
  angular.module('exercism', ['ui.bootstrap']);
  $(function () {
    $('.member_delete').on('click', function () {
      var slug, username;
      username = $(this).data('username');
      slug = $(this).data('team');
      if (confirm('Are you sure you want to dismiss ' + username)) {
        return dismissTeamMember(username, slug);
      }
    });
    $('#destroy_team').on('click', function () {
      var slug;
      slug = $(this).data('team');
      if (confirm('Are you sure you want to delete ' + slug + '?')) {
        return destroyTeam(slug);
      }
    });
    $('#edit_team').on('click', function (event) {
      event.preventDefault();
      return toggleTeamEdit();
    });
    if (_.any($('.comments'))) {
      emojify.setConfig({ emoticons_enabled: false });
      return emojify.run(document.getElementsByClassName('comments')[0]);
    }
  });
  toggleTeamEdit = function () {
    var delete_buttons, members_box;
    members_box = $('#add_members');
    delete_buttons = $('.member_delete');
    if (members_box.hasClass('hidden')) {
      delete_buttons.removeClass('hidden');
      members_box.slideDown();
      return members_box.removeClass('hidden');
    } else {
      return members_box.slideUp(function () {
        delete_buttons.addClass('hidden');
        return members_box.addClass('hidden');
      });
    }
  };
  destroyTeam = function (slug) {
    var form, href, method_input;
    href = '/teams/' + slug;
    form = $('<form method="post" action="' + href + '"></form>');
    method_input = '<input name="_method" value="delete" type="hidden"/>';
    form.hide().append(method_input).appendTo('body');
    return form.submit();
  };
  dismissTeamMember = function (username, slug) {
    var form, href, method_input;
    href = '/teams/' + slug + '/members/' + username;
    form = $('<form method="post" action="' + href + '"></form>');
    method_input = '<input name="_method" value="delete" type="hidden"/>';
    form.hide().append(method_input).appendTo('body');
    return form.submit();
  };
}.call(this));
(function () {
  angular.module('exercism').controller('MarkdownCtrl', [
    '$scope',
    '$http',
    function ($scope, $http) {
      $scope.data || ($scope.data = {});
      return $scope.preview = function () {
        return $http.post('/comments/preview', $.param({ 'body': $scope.data.body }), { headers: { 'Content-Type': 'application/x-www-form-urlencoded' } }).success(function (data, status, headers) {
          return $scope.data.preview = data;
        });
      };
    }
  ]);
}.call(this));
window.exercism = {
  collections: {},
  views: {},
  models: {},
  routers: {}
};
window.exercism.collections.NotificationList = Backbone.Collection.extend({
  url: '/api/v1/notifications',
  parse: function (response) {
    return response.notifications.map(function (e) {
      return e.notification;
    });
  },
  initialize: function () {
    this.newCount = 0;
    this.listenTo(this, 'all', this.updateNewCount);
  },
  updateNewCount: function () {
    var previousNewCount = this.newCount;
    this.newCount = this.countNew();
    if (this.newCount !== previousNewCount) {
      this.trigger('notification');
    }
    return this;
  },
  countNew: function () {
    return this.reduce(function (memo, model) {
      if (model.attributes.read === false) {
        return memo + 1;
      } else {
        return memo + 0;
      }
    }, 0);
  },
  hasNew: function () {
    if (this.countNew() > 0) {
      return true;
    } else {
      return false;
    }
  }
});
exercism.models.Notification = Backbone.Model.extend({
  parse: function (response) {
    return response.notification;
  }
});
$(function () {
  if ($('#nitstat-chart').length !== 0) {
    var stats = $('#nitstat-chart').data('stats');
    var data = {
        labels: stats.labels,
        datasets: [
          {
            fillColor: 'rgba(151,187,205,0.5)',
            strokeColor: 'rgba(151,187,205,1)',
            pointColor: 'rgba(151,187,205,1)',
            pointStrokeColor: '#fff',
            data: stats.given
          },
          {
            fillColor: 'rgba(220,220,220,0.5)',
            strokeColor: 'rgba(220,220,220,1)',
            pointColor: 'rgba(220,220,220,1)',
            pointStrokeColor: '#fff',
            data: stats.received
          }
        ]
      };
    var ctx = $('#nitstat-chart').get(0).getContext('2d');
    new Chart(ctx).Line(data, {
      scaleOverride: true,
      scaleSteps: stats.steps,
      scaleStepWidth: stats.step,
      scaleStartValue: 0,
      bezierCurve: false
    });
  }
});
$(function () {
  var notification = new exercism.models.Notification(), notificationList = new exercism.collections.NotificationList({ model: notification });
  $('.dropdown-toggle').dropdown();
  exercism.collections.notificationsList = new exercism.collections.NotificationList({ model: notification });
  exercism.views.toggleNotifications = new exercism.views.ToggleNotifications({
    el: $('#toggle-notifications'),
    collection: notificationList
  });
});
$(function () {
  $('.notifications li.unread a').on('click', function () {
    var elem = $(this).parent('.unread');
    elem.addClass('read');
    elem.removeClass('unread');
  });
  $('.pending-submission, .work').each(function (index, element) {
    var elem = $(element);
    var language = elem.data('language');
    $('.language', elem).tooltip({ title: language });
    var nitCount = elem.data('nits');
    $('.nits', elem).tooltip({ title: nitCount + ' Nits by Others' });
    var versionCount = elem.data('versions');
    $('.versions', elem).tooltip({ title: 'Iteration ' + versionCount });
  });
  $('.code a[data-action=\'enlarge\']').on('click', function () {
    var codeDiv = $(this).parents('.code');
    codeDiv.removeClass('span6');
    codeDiv.addClass('span12');
    $(this).hide();
    $('a[data-action=\'shrink\']', codeDiv).show();
  });
  $('.code a[data-action=\'shrink\']').on('click', function () {
    var codeDiv = $(this).parents('.code');
    codeDiv.removeClass('span12');
    codeDiv.addClass('span6');
    $(this).hide();
    $('a[data-action=\'enlarge\']', codeDiv).show();
  });
  $('form input[type=submit], form button[type=submit]').on('click', function () {
    var $this = $(this);
    window.setTimeout(function () {
      $this.attr('disabled', true);
    }, 1);
  });
  $('textarea').each(function () {
    var $this = $(this);
    var question_text = 'You have unsaved changes on this page';
    var was_sumbitted = false;
    $this.parents('form').on('submit', function () {
      was_sumbitted = true;
    });
    window.onbeforeunload = function (e) {
      var unsaved = $this.text() !== $this.val();
      if (!was_sumbitted && unsaved) {
        e = e || window.event;
        if (e) {
          e.returnValue = question_text;
        }
        return question_text;
      }
    };
  });
  $(document).on('keydown', 'textarea', function (e) {
    if (e.keyCode === 13 && (e.metaKey || e.ctrlKey)) {
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
  $('.mute').each(function (index, element) {
    var elem = $(element);
    $('.mute-btn', elem).tooltip({
      placement: 'bottom',
      title: 'Mute this submission until there is further activity.'
    });
    $('.unmute-btn', elem).tooltip({
      placement: 'bottom',
      title: 'Unmute this sumission.'
    });
  });
});
exercism.views.CountNotifications = Backbone.View.extend({
  template: JST['app/templates/count_notifications.us'],
  tag: 'span',
  initialize: function () {
    this.listenTo(this.collection, 'notification', this.render);
  },
  render: function () {
    this.$el.html(this.template({ count: this.collection.newCount }));
  }
});
exercism.views.ListNotifications = Backbone.View.extend({
  template: JST['app/templates/list_notifications.us'],
  id: 'list-notifications',
  initialize: function (options) {
    this.listenTo(this.collection, 'add', this.addOne);
  },
  render: function () {
    this.$el.html(this.template());
    return this;
  },
  toggle: function () {
    this.$el.toggleClass('reveal-notifications');
    $('body').toggleClass('reveal-notifications');
  },
  addAll: function () {
    this.collection.each(this.addOne, this);
  },
  addOne: function (model) {
    view = new exercism.views.Notification({ model: model });
    view.render();
    this.$('#contains-notifications').append(view.el);
    model.on('remove', view.remove, view);
  }
});
exercism.views.Notification = Backbone.View.extend({
  defaultTemplate: JST['app/templates/notification.us'],
  nitpicksTemplate: JST['app/templates/nitpicks_notification.us'],
  attemptTemplate: JST['app/templates/attempt_notification.us'],
  hibernatingTemplate: JST['app/templates/hibernating_notification.us'],
  likeTemplate: JST['app/templates/like_notification.us'],
  invitationTemplate: JST['app/templates/invitation_notification.us'],
  tagName: 'li',
  className: 'notification message',
  events: { 'click': 'toggleRead' },
  initialize: function (options) {
    this.listenTo(this.model, 'change', this.render);
    this.listenTo(this.model, 'destroy', this.remove);
    this.markReadIfAtPath();
  },
  markReadIfAtPath: function () {
    if (this.isAtPath()) {
      this.toggleRead();
    }
  },
  notificationType: function () {
    return this.model.get('regarding');
  },
  render: function () {
    switch (this.notificationType()) {
    case 'invitation':
      this.$el.html(this.invitationTemplate(this.model.toJSON()));
      break;
    case 'code':
      this.$el.html(this.attemptTemplate(this.model.toJSON()));
      break;
    case 'hibernating':
      this.$el.html(this.hibernatingTemplate(this.model.toJSON()));
      break;
    case 'like':
      this.$el.html(this.likeTemplate(this.model.toJSON()));
      break;
    case 'nitpick':
      if (this.isSubmitter()) {
        this.$el.html(this.nitpicksTemplate(this.model.toJSON()));
      } else {
        this.$el.html(this.defaultTemplate(this.model.toJSON()));
      }
      break;
    default:
      this.$el.html(this.defaultTemplate(this.model.toJSON()));
      break;
    }
    this.readStatus();
    return this;
  },
  toggleRead: function () {
    if (!this.model.get('read')) {
      this.model.save('read', true);
    }
  },
  readStatus: function () {
    this.$el.toggleClass('new-notification', !this.model.get('read'));
  },
  isAtPath: function () {
    return this.model.get('link') === window.location.pathname;
  },
  isSubmitter: function () {
    return this.model.get('username') === this.model.get('recipient');
  }
});
exercism.views.ToggleNotifications = Backbone.View.extend({
  events: { 'click': 'toggle' },
  template: JST['app/templates/toggle_notifications.us'],
  initialize: function () {
    if (this.isAuthorizedUser()) {
      this.startNotificationCenter();
    }
    _.bindAll(this, 'close_on_esc');
    $(document).keyup(this.close_on_esc);
  },
  render: function () {
    this.$el.html(this.template({ style: this.buttonStyle() }));
    this.countNotifications.setElement(this.$('#count-notifications')).render();
    return this;
  },
  isAuthorizedUser: function () {
    return this.el !== undefined;
  },
  startNotificationCenter: function () {
    this.listNotifications = new exercism.views.ListNotifications({
      collection: this.collection,
      el: $('#list-notifications')
    }).render();
    this.countNotifications = new exercism.views.CountNotifications({ collection: this.collection });
    this.listenTo(this.collection, 'notification', this.render);
    this.render();
    this.collection.fetch();
  },
  toggle: function () {
    this.listNotifications.toggle();
  },
  close_on_esc: function (event) {
    var notificationsAreVisible = this.listNotifications.$el.hasClass('reveal-notifications');
    var noInputHasFocus = $(':focus').length === 0;
    var keyIsEsc = event.keyCode === 27;
    if (notificationsAreVisible && noInputHasFocus && keyIsEsc) {
      this.toggle();
    }
  },
  buttonStyle: function () {
    if (this.collection.hasNew()) {
      return ' new';
    } else {
      return '';
    }
  }
});