[![Build Status](https://travis-ci.org/carlo-colombo/dublin-bus-api.svg?branch=master)](https://travis-ci.org/carlo-colombo/dublin-bus-api)
[![Hex.pm](https://img.shields.io/hexpm/v/dublin_bus_api.svg?style=flat-square)](https://hex.pm/packages/dublin_bus_api)
[![Coverage Status](https://coveralls.io/repos/github/carlo-colombo/dublin-bus-api/badge.svg?branch=master)](https://coveralls.io/github/carlo-colombo/dublin-bus-api?branch=master)

Dublin Bus API
=============

Access to the Real Time Passenger Information (RTPI) for Dublin Bus services.

The API are focused on retrieving bus stop and timetables

Documentation is available at http://hexdocs.pm/dublin_bus_api/Stop.html

Disclaimer
----------

This service is in no way affiliated with Dublin Bus or the providers of the RTPI service.

Data are retrieved parsing the still-in-development [RTPI](http://rtpi.ie/) site. As with any website
scraping the html could change without notice and break the API.

Test
-----
Parsing function are tested both against fixture and the actual website, this could lead to failing test if an
internet connection is missing. It also could find if something has changed in the rtpi.ie website html.
