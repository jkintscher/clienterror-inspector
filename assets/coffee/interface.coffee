$(window).ready () ->
  unless clienterror_exceptions?
    return alert 'Could not find parsed exceptions file at `./exceptions.json`.'

  groups = {}

  for exception in clienterror_exceptions
    groups[exception.message] = [] unless groups[exception.message]?
    groups[exception.message].push exception

  list = $('.exceptions')
  render list, groups

  # add some small internactions to toggle long lists
  list.find('> dt').click (e) ->
    head = if e.target.nodeName isnt 'DT' then $(e.target).parent() else $(e.target)
    head.toggleClass 'toggled'

  list.find('.backtrace + dd h4').click (e) ->
    $(e.target).toggleClass 'toggled'

  list.on 'click', '.exception-argument-object', (e) ->
    console.dir window.exception_arguments[$(e.target).data("exception-arg")]


extract_subdomain = (url) ->
  url.replace /https:\/\/([\w]*)\.harvestapp.*/, '$1'

format_trace = (trace) ->
  return trace unless trace?
  trace = trace.replace /\n/g, '<br />'
  trace.replace /\(https:\/\/[\w\/\.]*\/([\w]*\.js)\?[\d]*:[\d]*:([\d]*)\)/ig, '<small class="file">($1:$2)</small>'

render = (view, groups) ->
  window.exception_arguments = []

  for message, exceptions of groups
    exceptions = exceptions.sort (a, b) -> b.time - a.time

    view.append $("""
      <dt class="toggled">
        <h2>#{message} <span class="count">(#{exceptions.length})</span></h2>
        Latest: <time>#{new Date exceptions[0].time}</time>
      </dt>
      """)

    list = $('<ol />')
    view.append $('<dd />').append(list)

    subdomains = {}

    for exception in exceptions
      subdomain = extract_subdomain(exception.url)
      subdomains[subdomain] = if subdomains[subdomain]? then subdomains[subdomain] + 1 else 1

      li = $("<li />").html("""
        <dl>
          <dt class="subdomain">Subdomain</dt>
          <dd>#{subdomain}</dd>

          <dt class="timestamp">Timestamp</dt>
          <dd><time>#{new Date exception.time}</time></dd>

          <dt class="url">URL</dt>
          <dd>#{exception.url}</dd>

          <dt class="browser">Browser</dt>
          <dd>#{exception.navigator?.userAgent}</dd>

          <dt class="platform">Platform</dt>
          <dd>#{exception.navigator?.platform}</dd>

          <dt class="language">Language</dt>
          <dd>#{exception.navigator?.language}</dd>

          <dt>Details</dt>
          <dd>#{exception.name}: #{exception.type}</dd>

          <dt>Arguments</dt>
          <dd class="args-spot">n/a</dd>

          <dt class="backtrace">Backtrace</dt>
          <dd>
            <h4 class="toggled">Outer</h4>
            <p class="trace">#{format_trace exception.outer_backtrace}</p>
            <h4 class="toggled">Inner</h4>
            <p class="trace">#{format_trace exception.backtrace}</p>
          </dd>
        </dl>
      """)

      if exception.arguments and typeof exception.arguments is "object"
        for prop of exception.arguments
          window.exception_arguments.push exception.arguments
          args = $("<span />", {class: "exception-argument-object"}).text("click to show object in console").data("exception-arg",window.exception_arguments.length-1)
          li.find(".args-spot").html args
          break
      list.append li

    subs = "<li><table>"
    for subdomain, count of subdomains
      subs += """
        <tr>
          <td>#{subdomain}</td>
          <td>#{count}</td>
        </tr>
      """
    subs += "</table></li>"
    list.prepend(subs)