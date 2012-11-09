ClientError Inspector
=====================

Provides a quick interface for exceptions logged to Google Analytics
and let's you check error details, grouped by error messages and with
full backtraces and meta information.

It doesn't need any configuration, special setup or even a local server.

Setup
-----

1. Export a `CSV` file from [Google Analytics](https://www.google.com/analytics/web/?hl=en&pli=1#report/content-event-events/a103886w6911991p7169352/%3F_.sampleSize%3D500000%26_.date00%3D20121023%26_.date01%3D20121030%26_r.drilldown%3Danalytics.eventCategory%3AClientError%2Canalytics.eventAction%3ATimesheet%26explorer-table.plotKeys%3D%5B%5D/) and save it as `ga.csv` to this directory

2. `$ chmod u+w parse.rb` to make the script executable (only needed once)

3. `$ ruby parse.rb` to parse the `CSV` file

4. Open the `index.html` in your browser by dragging it on to the icon in your dock

5. Inspect.