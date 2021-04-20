# frozen_string_literal: true

require 'resolv'
require 'etc'
require 'socket'
require 'net/smtp'

# The EZ module serves as a namespace only.
module EZ

  # The Email class encapsulates certain SMTP attributes, which are then
  # used to send simple emails.
  class Email
    # The version of the ez-email library
    VERSION = '0.3.0'.freeze

    class << self
      attr_writer :mail_host
      attr_writer :mail_port

      # The name of the mail host to use when sending email. The default
      # is whatever the address of your system's 'mailhost' resolves to.
      # If that cannot be determined, your localhost is used.
      #
      def mail_host
        @mail_host ||= Resolv.getaddress('mailhost')
      rescue Resolv::ResolvError
        @mail_host ||= 'localhost'
      end

      # The port to use when sending email. The default is 25.
      #
      def mail_port
        @mail_port ||= 25
      end
    end

    # A single email address or an array of email addresses to whom
    # the email should be sent. Mandatory.
    attr_accessor :to

    # A single email address from whom the email is being delivered. The
    # default is your login + '@' + your host name, though it is recommended
    # that you specify it explicitly.
    attr_accessor :from

    # The subject of the email. Mandatory.
    attr_accessor :subject

    # The body of the email. Mandatory.
    attr_accessor :body

    # Creates a new EZ::Email object. As a general rule you won't use
    # this method, but should use EZ::Email.deliver instead.
    #
    def initialize(options={})
      raise TypeError unless options.is_a?(Hash)
      options[:from] ||= Etc.getlogin + '@' + Socket.gethostname
      validate_options(options)
      @options = options
    end

    # Sends the email based on the options passed to the constructor.
    # As a general rule you won't use this method directly, but should
    # use EZ::Email.deliver instead.
    #
    def deliver
      host = EZ::Email.mail_host
      port = EZ::Email.mail_port

      to_list = to.is_a?(Array) ? to : [to]

      Net::SMTP.start(host, port, host) do |smtp|
        smtp.open_message_stream(from, to) do |stream|
          stream.puts "From: #{from}"
          stream.puts 'To: ' + to_list.join(', ')
          stream.puts "Subject: #{subject}"
          stream.puts
          stream.puts body
        end
      end
    end

    # Delivers a simple text email message using four options:
    #
    # * to
    # * from
    # * subject
    # * body
    #
    # Examples:
    #
    #    # Send an email to a single user
    #    EZ::Email.deliver(
    #       :to      => 'some_user@hotmail.com',
    #       :from    => 'me@hotmail.com',
    #       :subject => 'Hi',
    #       :body    => 'How are you?'
    #    )
    #
    #    # Send an email to a multiple users
    #    EZ::Email.deliver(
    #       :to      => ['jon@hotmail.com', 'mary@hotmail.com'],
    #       :from    => 'me@hotmail.com',
    #       :subject => 'Hi',
    #       :body    => 'How are you?'
    #    )
    #
    # This is a shortcut for EZ::Email.new + EZ::Email#deliver.
    #
    def self.deliver(options)
      new(options).deliver
    end

    private

    # Private method that both validates the hash options, and sets
    # the attribute values.
    #
    def validate_options(hash)
      valid = %w[to from subject body]

      hash.each do |key, value|
        key = key.to_s.downcase
        raise ArgumentError unless valid.include?(key)
        send("#{key}=", value)
      end

      if to.nil? || subject.nil? || body.nil?
        raise ArgumentError, 'Missing :to, :subject or :body'
      end
    end
  end
end
