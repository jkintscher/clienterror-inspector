ClientError Inspector
=====================

Provides a quick interface for exceptions logged to Google Analytics
and let's you check error details, grouped by error messages and with
full backtraces and meta information.

It doesn't need any configuration, special setup or even a local server.

Setup
-----

1. Clone this repo to any directory on your computer and open it in your terminal.

2. Export a `CSV` file of recorded exceptions for any timeframe from [Google Analytics](https://www.google.com/analytics/web/?hl=en&pli=1#report/content-event-events/a103886w6911991p7169352/%3F_.sampleSize%3D500000%26_.date00%3D20121023%26_.date01%3D20121030%26_r.drilldown%3Danalytics.eventCategory%3AClientError%2Canalytics.eventAction%3ATimesheet%26explorer-table.plotKeys%3D%5B%5D/) and save it to the same directory

3. Rename that `Analytics harvestapp.com Top Events \d{8}-\d{8}.csv` to `ga.csv`

4. In your terminal, execute `$ ruby parse.rb`. (You might need to change that file's persmission with
`% chmod u+w parse.rb` first).

5. Open the `index.html` in your browser by dragging it on to the icon in your dock.

6. Inspect.