extract_subdomain = (url) ->
  url.replace /https:\/\/([\w]*)\.harvestapp.*/, '$1'

format_trace = (trace) ->
  return trace unless trace?
  trace = trace.replace /\n/g, '<br />'
  trace.replace /\(https:\/\/[\w\/\.]*\/([\w]*\.js)\?[\d]*:[\d]*:([\d]*)\)/ig, '<small>$1:$2</small>'


$(window).ready () ->
  unless clienterror_exceptions?
    return alert 'Could not find parsed exceptions file at `./exceptions.json`.'

  groups = {}

  for exception in clienterror_exceptions
    groups[exception.message] = [] unless groups[exception.message]?
    groups[exception.message].push exception

  list = $('.exceptions')

  for message, exceptions of groups
    exceptions = exceptions.sort (a, b) -> b.time - a.time

    list.append $ """
      <dt>
        <h2>#{message} <span class="count">(#{exceptions.length})</span></h2>
        Latest: <time>#{new Date exceptions[0].time}</time>
      </dt>
      """

    for exception in exceptions
      list.append $ """
        <dd>
          <dl>
            <dt class="subdomain">Subdomain</dt>
            <dd>#{extract_subdomain(exception.url)}</dd>

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
            <ddt>#{exception.name}: #{exception.type}</dd>

            <dt class="backtrace">Backtrace</dt>
            <dd>
              <h4>Outer</h4>
              #{format_trace exception.outer_backtrace}
              <h4>Inner</h4>
              #{format_trace exception.backtrace}
            </dd>
        </dd>
        """

  console.log groups
