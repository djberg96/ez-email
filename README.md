### Description
A very easy interface for sending simple text based emails.

### Installation
`gem install ez-email`

### Synopsis
```ruby
require 'ez-email'
   
EZ::Email.deliver(
  :to      => 'your_friend@hotstuff.com',
  :from    => 'you@blah.com',
  :subject => 'Hello',
  :body    => 'How are you?'
)
```
   
### Rationale

When I originally created this library the existing list of email handling
libraries were either not designed for sending email, were extremely cumbersome,
had lousy interfaces, or were no longer maintained.
   
I just wanted to send a flippin' email! This library scratched that itch.
Hopefully you will find its simplicity useful, too.

### Bugs

None that I'm aware of. Please log any bug reports on the project page at

https://github.com/djberg96/ez-email.

### License

Apache-2.0

### Copyright

(C) 2009-2021, Daniel J. Berger, All Rights Reserved
   
### Author

Daniel Berger
