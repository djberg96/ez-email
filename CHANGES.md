## 0.4.0 - 13-Jul-2025
- Add support for email attachments.

## 0.3.0 - 20-Oct-2020
- Switch test suite from test-unit to rspec.

## 0.2.2 - 3-Aug-2020
- Switch README, CHANGES and MANIFEST files to markdown format.

## 0.2.1 - 1-Jun-2020
- Added a LICENSE file to the distro as required by the Apache-2.0 license.

## 0.2.0 - 28-Jan-2019
- Changed license to Apache-2.0.
- Fixed a bug where it was blowing up on a single "to" argument.
- The VERSION constant is now frozen.
- Added the ez-mail.rb file for convenience.
- Modified code internally to use singletons instead of class variables.
- Updated cert, should be good for about 10 years.
- Added metadata to the gemspec.

## 0.1.5 - 12-Dec-2015
- This gem is now signed.
- Updates to Rakefile and gemspec for gem signing.

## 0.1.4 - 8-Nov-2014
- Minor updates to gemspec and Rakefile.

## 0.1.3 - 9-Jan-2013
- Fixed a bug where the default 'from' value was not actually being set
  if it wasn't explicitly specified.
- Refactored the tests and use test-unit 2 instead.

## 0.1.2 - 31-Aug-2011
- Refactored the Rakefile. Removed the old install task, added a clean
  task, added a default task, and reorganized the gem tasks.

## 0.1.1 - 27-Sep-2009
- Changed license to Artistic 2.0.
- The mail host now defaults to localhost if the mailhost cannot be resolved.
- Added the 'gem' Rake task.
- Some gemspec updates.

## 0.1.0 - 23-Jan-2009
- Initial release
