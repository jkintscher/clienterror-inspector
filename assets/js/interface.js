// Generated by CoffeeScript 1.3.3
(function() {
  var extract_subdomain, format_trace, render;

  $(window).ready(function() {
    var exception, groups, list, _i, _len;
    if (typeof clienterror_exceptions === "undefined" || clienterror_exceptions === null) {
      return alert('Could not find parsed exceptions file at `./exceptions.json`.');
    }
    groups = {};
    for (_i = 0, _len = clienterror_exceptions.length; _i < _len; _i++) {
      exception = clienterror_exceptions[_i];
      if (groups[exception.message] == null) {
        groups[exception.message] = [];
      }
      groups[exception.message].push(exception);
    }
    list = $('.exceptions');
    render(list, groups);
    list.find('> dt').click(function(e) {
      var head;
      head = e.target.nodeName !== 'DT' ? $(e.target).parent() : $(e.target);
      return head.toggleClass('toggled');
    });
    return list.find('.backtrace + dd h4').click(function(e) {
      return $(e.target).toggleClass('toggled');
    });
  });

  extract_subdomain = function(url) {
    return url.replace(/https:\/\/([\w]*)\.harvestapp.*/, '$1');
  };

  format_trace = function(trace) {
    if (trace == null) {
      return trace;
    }
    trace = trace.replace(/\n/g, '<br />');
    return trace.replace(/\(https:\/\/[\w\/\.]*\/([\w]*\.js)\?[\d]*:[\d]*:([\d]*)\)/ig, '<small class="file">($1:$2)</small>');
  };

  render = function(view, groups) {
    var count, exception, exceptions, li, list, message, subdomain, subdomains, subs, _i, _len, _ref, _ref1, _ref2, _results;
    _results = [];
    for (message in groups) {
      exceptions = groups[message];
      exceptions = exceptions.sort(function(a, b) {
        return b.time - a.time;
      });
      view.append($("<dt class=\"toggled\">\n  <h2>" + message + " <span class=\"count\">(" + exceptions.length + ")</span></h2>\n  Latest: <time>" + (new Date(exceptions[0].time)) + "</time>\n</dt>"));
      list = $('<ol />');
      view.append($('<dd />').append(list));
      subdomains = {};
      for (_i = 0, _len = exceptions.length; _i < _len; _i++) {
        exception = exceptions[_i];
        subdomain = extract_subdomain(exception.url);
        subdomains[subdomain] = subdomains[subdomain] != null ? subdomains[subdomain] + 1 : 1;
        li = $("<li>\n  <dl>\n    <dt class=\"subdomain\">Subdomain</dt>\n    <dd>" + subdomain + "</dd>\n\n    <dt class=\"timestamp\">Timestamp</dt>\n    <dd><time>" + (new Date(exception.time)) + "</time></dd>\n\n    <dt class=\"url\">URL</dt>\n    <dd>" + exception.url + "</dd>\n\n    <dt class=\"browser\">Browser</dt>\n    <dd>" + ((_ref = exception.navigator) != null ? _ref.userAgent : void 0) + "</dd>\n\n    <dt class=\"platform\">Platform</dt>\n    <dd>" + ((_ref1 = exception.navigator) != null ? _ref1.platform : void 0) + "</dd>\n\n    <dt class=\"language\">Language</dt>\n    <dd>" + ((_ref2 = exception.navigator) != null ? _ref2.language : void 0) + "</dd>\n\n    <dt>Details</dt>\n    <dd>" + exception.name + ": " + exception.type + "</dd>\n\n    <dt class=\"arguments\">Arguments</dt>\n    <dd><a href=\"#\">Click to debug scope's arguments with <code>console.dir()</code></a></dd>\n\n    <dt class=\"backtrace\">Backtrace</dt>\n    <dd>\n      <h4 class=\"toggled\">Outer</h4>\n      <p class=\"trace\">" + (format_trace(exception.outer_backtrace)) + "</p>\n      <h4 class=\"toggled\">Inner</h4>\n      <p class=\"trace\">" + (format_trace(exception.backtrace)) + "</p>\n    </dd>\n  </dl>\n</li>");
        li.find('.arguments + dd a').data('arguments', exception["arguments"]).click(function(e) {
          e.preventDefault();
          return console.dir($(this).data('arguments'));
        });
        list.append(li);
      }
      subs = "<li><table>";
      for (subdomain in subdomains) {
        count = subdomains[subdomain];
        subs += "<tr>\n  <td>" + subdomain + "</td>\n  <td>" + count + "</td>\n</tr>";
      }
      subs += "</table></li>";
      _results.push(list.prepend(subs));
    }
    return _results;
  };

}).call(this);
